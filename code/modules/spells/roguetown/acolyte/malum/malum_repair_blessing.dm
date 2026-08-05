/datum/component/dreamwalker_repair/limited
	/// Total amount of health this component can repair before it expires
	var/total_repair_budget = 300
	/// How much we have repaired so far
	var/total_repaired = 0
	/// Time limit for the component
	var/lifetime = 15 MINUTES
	shard_type = /obj/effect/temp_visual/dream_shard/malum

/datum/component/dreamwalker_repair/limited/Initialize(repair_budget = 300, time_limit = 15 MINUTES)
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	src.total_repair_budget = repair_budget
	src.lifetime = time_limit
	var/mob/living/carbon/human/H = parent
	to_chat(H, span_notice("Your armor hums with a temporary protective resonance."))

	// Register all currently worn items that have armor
	for(var/obj/item/I in H.contents)
		if(I.armor)
			add_item(I)

	RegisterSignal(H, COMSIG_MOB_EQUIPPED_ITEM, .proc/on_item_equipped)
	RegisterSignal(H, COMSIG_MOB_DROPITEM, .proc/on_item_dropped)
	addtimer(CALLBACK(src, .proc/expire), lifetime)
	H.apply_status_effect(/datum/status_effect/buff/malum_reinforcement)

/datum/component/dreamwalker_repair/limited/on_item_equipped(mob/user, obj/item/source, slot)
	if(source.armor)
		add_item(source)

/datum/component/dreamwalker_repair/limited/on_item_dropped(mob/user, obj/item/source)
	remove_item(source)

/datum/component/dreamwalker_repair/limited/repair_from_shard(amount)
	// Track how much we are actually about to repair
	var/pre_repair_integrity = 0
	for(var/obj/item/I in repairing_items)
		pre_repair_integrity += I.obj_integrity

	..()

	var/post_repair_integrity = 0
	for(var/obj/item/I in repairing_items)
		post_repair_integrity += I.obj_integrity

	var/actual_healed = post_repair_integrity - pre_repair_integrity
	total_repaired += actual_healed

	if(total_repaired >= total_repair_budget)
		qdel(src)

/datum/component/dreamwalker_repair/limited/proc/expire()
	if(!QDELETED(src))
		qdel(src)

/datum/component/dreamwalker_repair/limited/Destroy()
	var/mob/living/L = parent
	if(L)
		L.remove_status_effect(/datum/status_effect/buff/malum_reinforcement)
	to_chat(parent, span_boldnotice("The protective resonance fades away!"))
	return ..()

/obj/effect/temp_visual/dream_shard/malum
	name = "malum shard"
	desc = "Malum's glory shines through these shards. Hold the line, soldier."
	icon_state = "malum_shards"
	dream_check = FALSE
	effect_color = "#330000"

/datum/status_effect/buff/malum_reinforcement
	id = "malum_reinforcement"
	alert_type = /atom/movable/screen/alert/status_effect/buff/malum_reinforcement
	duration = -1
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/buff/malum_reinforcement
	name = "Malum's Resonance"
	desc = "My armor resonates with Malum's dilligence. Shards fly off when damaged, I can collect them to regain some integrity."
	icon_state = "buff"

/datum/action/cooldown/spell/apply_malum
	name = "Invoke Malum Reinforcement"
	desc = "Call upon the Malum energy gifted to you to reinforce your armor."
	background_icon = 'icons/mob/actions/malummiracles.dmi'
	button_icon = 'icons/mob/actions/malummiracles.dmi'
	button_icon_state = "invoke_malum"

	cast_range = 1
	self_cast_possible = TRUE
	cooldown_time = 1 HOURS // One-time use
	charge_time = 2 SECONDS
	cast_range = SPELL_RANGE_GROUND
	associated_skill = /datum/skill/magic/holy
	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_STAT_BUFF
	spell_color = "#330000"
	
/datum/action/cooldown/spell/apply_malum/cast(atom/cast_on)
	. = ..()
	var/mob/living/L = owner
	if(L.GetComponent(/datum/component/dreamwalker_repair))
		to_chat(owner, span_warning("[L] is already reinforced!"))
		return FALSE
	L.AddComponent(/datum/component/dreamwalker_repair/limited)
	L.visible_message(span_notice("[L]'s armor begins to hum with a dark, metallic resonance."))

	addtimer(CALLBACK(src, .proc/self_consume, L), 1)
	return TRUE

/datum/action/cooldown/spell/apply_malum/proc/self_consume(mob/living/L)
	if(L?.mind)
		L.mind.RemoveSpell(src)

/datum/action/cooldown/spell/malum_blessing
	name = "Gift of Malum"
	desc = "Grant a target the ability to invoke Malum armor reinforcement. \
	Armor reinforcements causes pickuppable armor repair shards to be dropped when the target's armor is damaged."
	background_icon = 'icons/mob/actions/malummiracles.dmi'
	button_icon = 'icons/mob/actions/malummiracles.dmi'
	button_icon_state = "malum_gift"
	sound = 'sound/magic/bless.ogg'
	spell_color = "#330000"

	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = SPELLCOST_MIRACLE_MAJOR + 20

	secondary_resource_type = SPELL_COST_STAMINA
	secondary_resource_cost = SPELLCOST_MIRACLE

	ignore_armor_penalty = TRUE
	cooldown_time = 10 MINUTES
	charge_time = 0.1 SECONDS

	invocations = list("Malum's hand will heed you from harm!")
	invocation_type = INVOCATION_SHOUT
	cast_range = SPELL_RANGE_GROUND
	associated_stat = null
	associated_skill = /datum/skill/magic/holy

/datum/action/cooldown/spell/malum_blessing/cast(atom/cast_on)
	. = ..()
	if(!isliving(cast_on))
		to_chat(owner, span_warning("This must be cast upon a living target."))
		return FALSE
	if(cast_on == owner)
		to_chat(owner, span_warning("You cannot reinforce yourself."))
		return FALSE

	var/mob/living/target = cast_on

	if(target.mind?.has_spell(/datum/action/cooldown/spell/apply_malum))
		to_chat(owner, span_warning("[target] already holds a fragment of Malum's blessings."))
		return FALSE

	var/datum/action/cooldown/spell/apply_malum/SP = new /datum/action/cooldown/spell/apply_malum
	target.mind?.AddSpell(SP, target)
	target.visible_message(span_warning("A shadow settles over [target], promising protection."))
	to_chat(target, span_notice("You have been gifted a fragment of Malum. Use the new ability to reinforce your armor."))

	return TRUE
