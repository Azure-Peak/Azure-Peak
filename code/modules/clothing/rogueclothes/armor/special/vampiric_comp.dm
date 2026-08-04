/datum/component/vampiric_striker
	/// List of our specific target armor items being tracked for repairs
	var/list/repairing_items = list()
	/// How much armor damage we have stripped from targets
	var/accumulated_armor_damage = 0
	/// How much armor damage we must deal to drop a shard
	var/shard_threshold = 50
	/// The value of the spawned shard
	var/shard_repair_value = 20
	/// Type of shard to spawn
	var/obj/effect/temp_visual/dream_shard/shard_type = /obj/effect/temp_visual/dream_shard/vampiric
	/// The specific path type of armor we want to check for and repair
	var/target_armor_path = /obj/item/clothing/suit/roguetown/armor/vampiric
	/// Weakref to the victim whose armor we're tracking, triggered in a single tick.
	var/datum/weakref/current_victim_ref
	/// Whether shards are allowed to actively repair tracked items when picked up
	var/repairs_enabled = TRUE
	/// How high the fury can build from picking up shards.
	var/fury_cap = 100

/datum/component/vampiric_striker/Initialize(threshold, repair_value, custom_fury_cap)
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	if(!isnull(threshold))
		shard_threshold = threshold
	if(!isnull(repair_value))
		shard_repair_value = repair_value
	if(!isnull(custom_fury_cap))
		fury_cap = custom_fury_cap

	to_chat(parent, span_userdanger("Your strikes look to splinter the defenses of your foes."))

	var/mob/living/carbon/human/H = parent

	for(var/obj/item/I in H.contents)
		if(istype(I, target_armor_path))
			add_item(I)

	RegisterSignal(H, COMSIG_MOB_EQUIPPED_ITEM, .proc/on_item_equipped)
	RegisterSignal(H, COMSIG_MOB_DROPITEM, .proc/on_item_dropped)
	RegisterSignal(H, COMSIG_MOB_ITEM_ATTACK, .proc/on_successful_strike)
	RegisterSignal(H, COMSIG_MOB_ITEM_AFTERATTACK, .proc/on_attack_finished)

/datum/component/vampiric_striker/proc/on_item_equipped(mob/user, obj/item/source, slot)
	SIGNAL_HANDLER
	if(istype(source, target_armor_path))
		add_item(source)

/datum/component/vampiric_striker/proc/on_item_dropped(mob/user, obj/item/source)
	SIGNAL_HANDLER
	if(istype(source, target_armor_path))
		remove_item(source)
	UnregisterSignal(source, COMSIG_ITEM_ATTACK)

/datum/component/vampiric_striker/proc/add_item(obj/item/I)
	if(I in repairing_items)
		return
	repairing_items += I

/datum/component/vampiric_striker/proc/remove_item(obj/item/I)
	repairing_items -= I

/datum/component/vampiric_striker/proc/on_successful_strike(mob/living/carbon/human/source, mob/living/target, obj/item/weapon)
	SIGNAL_HANDLER

	var/datum/component/vampiric_striker/vamp_comp = target.GetComponent(/datum/component/vampiric_striker)
	// We don't really want gnolls to hit each other to pre-buff.
	if(vamp_comp)
		return
	if(!istype(target, /mob/living/carbon/human))
		return
	if(target.stat == DEAD || !target.mind)
		return
	current_victim_ref = WEAKREF(target)
	RegisterSignal(target, COMSIG_MOB_ARMOR_INTEGRITY_DAMAGED, .proc/handle_target_armor_shred)

/datum/component/vampiric_striker/proc/handle_target_armor_shred(mob/living/carbon/human/target, armor_damage_taken, obj/item/clothing/damaged_item, current_layer, total_layers)
	SIGNAL_HANDLER

	if(armor_damage_taken <= 0)
		return

	// If we are using blunt to damage multiple layers, there are diminishing returns.
	// Blunt damage already doesn't pierce through fully, but this is a further dampener, especially to prevent abuse when riposting.
	// Layer 2 only gives 33% the value anymore.
	// Layer 3 only gives 25% the value anymore. (Example, damaging MASK + COIF + HELM)
	// Layer 4 only gives 20% the value anymore.
	var/layer_modifier = 1
	if(current_layer > 1)
		layer_modifier = 1 / (current_layer + 1)
	var/effective_damage = armor_damage_taken * layer_modifier

	accumulated_armor_damage += effective_damage

	if(accumulated_armor_damage >= shard_threshold)
		while(accumulated_armor_damage >= shard_threshold)
			spawn_offensive_shard(target)
			accumulated_armor_damage -= shard_threshold

/datum/component/vampiric_striker/proc/on_attack_finished(mob/living/carbon/human/source, atom/target, obj/item/weapon, proximity_flag, click_parameters)
	SIGNAL_HANDLER

	if(!current_victim_ref)
		return

	var/mob/living/carbon/human/victim = current_victim_ref.resolve()
	if(victim)
		UnregisterSignal(victim, COMSIG_MOB_ARMOR_INTEGRITY_DAMAGED)

	current_victim_ref = null

/datum/component/vampiric_striker/proc/spawn_offensive_shard(mob/living/target)
	var/turf/spawn_location = get_turf(target)
	var/turf/attacker_turf = get_turf(parent)
	if(!spawn_location || !attacker_turf)
		return

	playsound(spawn_location, 'sound/combat/sharpness_loss1.ogg', 75, TRUE)
	target.visible_message(span_danger("Fragments of [target]'s armor are ripped away by the blow!"))

	var/turf/landing_turf
	var/attempts = 0
	while(attempts < 10)
		attempts++
		var/rand_x = attacker_turf.x + rand(-2, 2)
		var/rand_y = attacker_turf.y + rand(-2, 2)
		var/turf/picked_turf = locate(rand_x, rand_y, attacker_turf.z)
		if(picked_turf && !picked_turf.is_blocked_turf() && picked_turf != spawn_location)
			landing_turf = picked_turf
			break
	if(!landing_turf)
		landing_turf = locate(spawn_location.x + 1, spawn_location.y, spawn_location.z)
	var/obj/effect/temp_visual/dream_shard/vampiric/S = new shard_type(spawn_location, 10 SECONDS, shard_repair_value, landing_turf)
	S.creator_ref = WEAKREF(parent)

/datum/component/vampiric_striker/proc/on_shard_crossed(obj/effect/temp_visual/dream_shard/S, atom/movable/AM)
	SIGNAL_HANDLER
	if(AM != parent)
		return

	repair_from_shard(S.repair_value)
	
	var/obj/effect/temp_visual/heal/E = new /obj/effect/temp_visual/heal_rogue/campfire(get_turf(parent))
	E.color = S.effect_color
	playsound(parent, 'sound/magic/magic_nulled.ogg', 70, TRUE)
	
	UnregisterSignal(S, COMSIG_MOVABLE_CROSSED)
	qdel(S)

/datum/component/vampiric_striker/proc/repair_from_shard(amount)
	if(!repairs_enabled)
		return

	var/remaining_repair = amount
	while(remaining_repair > 0)
		var/obj/item/most_broken = null
		var/lowest_percent = 1

		for(var/obj/item/I in repairing_items)
			var/integrity_ratio = I.obj_integrity / I.max_integrity
			if(integrity_ratio < lowest_percent)
				lowest_percent = integrity_ratio
				most_broken = I

		if(!most_broken)
			break 

		var/needed = most_broken.max_integrity - most_broken.obj_integrity
		var/applied = min(remaining_repair, needed)
		most_broken.obj_integrity += applied
		
		if(most_broken.max_blade_int && most_broken.blade_int < most_broken.max_blade_int)
			most_broken.blade_int = most_broken.max_blade_int
		remaining_repair -= applied

		if(most_broken.obj_broken && most_broken.obj_integrity > 0)
			most_broken.obj_fix(null, FALSE)

		most_broken.update_icon()

		if(needed > applied) 
			break

/datum/component/vampiric_striker/Destroy()
	repairing_items = null
	return ..()

/obj/effect/temp_visual/dream_shard/vampiric
	name = "twisted armor shard"
	desc = "A piece of someone's armor, twisted to invigorate someone else instead. Looks fragile and easily destructible as a result."
	icon_state = "graggshard"
	/// Weak reference to the player mob who spawned this shard
	var/datum/weakref/creator_ref
	effect_color = "#440101"

/obj/effect/temp_visual/dream_shard/vampiric/Crossed(atom/movable/AM)
	if(!creator_ref)
		return
	var/mob/living/carbon/human/creator = creator_ref.resolve()
	if(!creator)
		qdel(src)
		return
	if(AM != creator)
		if(isliving(AM))
			if(prob(40))
				AM.visible_message(span_notice("[AM] crushes the [src] underfoot!"))
			qdel(src)
		return
	if(!pickuppable || QDELETED(src))
		return
	var/datum/component/vampiric_striker/vamp_comp = creator.GetComponent(/datum/component/vampiric_striker)
	if(!vamp_comp)
		return
	if(!vamp_comp.repairs_enabled)
		return
	vamp_comp.repair_from_shard(repair_value)
	var/datum/status_effect/vampiric_fury/F = creator.has_status_effect(/datum/status_effect/vampiric_fury)
	if(F)
		F.add_stack(11)
	else
		creator.apply_status_effect(/datum/status_effect/vampiric_fury, 11, vamp_comp.fury_cap)
	var/obj/effect/temp_visual/heal/E = new /obj/effect/temp_visual/heal_rogue/campfire(get_turf(creator))
	E.color = effect_color
	playsound(creator, 'sound/magic/magic_nulled.ogg', 70, TRUE)
	qdel(src)
