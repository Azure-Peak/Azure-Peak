/obj/item/rogueweapon/huntingknife/idagger/steel/rotfang
	name = "rotfang"
	desc = "A decorated dagger fabricated using Pestran secrets. In heretical fashion, it is used to spread black rot rather than to contain it. </br>I can coat this dagger in black ichor, giving them black rot on strikes that aren't parried or dodged. </br> I can put this knife in my boot."
	icon_state = "rotfang"
	// Unique antag weapon, it can be a good deal better
	max_integrity = 220
	wdefense = 5
	special = /datum/special_intent/rot_ring
	// Identical to dagger except it uses the heavier cut to help build rot.
	possible_item_intents = list(/datum/intent/dagger/thrust, /datum/intent/dagger/cut/heavy, /datum/intent/dagger/thrust/pick, /datum/intent/dagger/sucker_punch)

/obj/item/rogueweapon/huntingknife/idagger/steel/rotfang/Initialize()
	. = ..()
	AddComponent(/datum/component/ichor_stained)

/obj/item/reagent_containers/powder/black_ichor
	name = "black ichor"
	desc = "A malevolent little ball of stabilized black rot, siphoned from the heartbeast."
	icon = 'icons/obj/structures/heart_items.dmi'
	icon_state = "ichor"

/datum/component/ichor_stained
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/obj/item/parent_weapon
	var/charges = 0
	var/max_charges = 200
	var/charges_to_restore = 110

/datum/component/ichor_stained/Initialize()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	parent_weapon = parent

	RegisterSignal(parent_weapon, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent_weapon, COMSIG_ITEM_PRE_ATTACK, PROC_REF(check_dip))
	RegisterSignal(parent_weapon, COMSIG_ITEM_ATTACK_SUCCESS, PROC_REF(on_attack_success))

/datum/component/ichor_stained/proc/on_examine(datum/source, mob/user, list/examine_list)
	if(charges > 0)
		examine_list += span_notice("It is coated in [charges]/[max_charges] layers of thick, viscous ichor.")
		examine_list += span_notice("Black rot scales up to 100 stacks.")
		if(parent_weapon.possible_item_intents && length(parent_weapon.possible_item_intents))
			examine_list += span_notice("Careful strikes will apply the following rot stacks:")
			for(var/I_path in parent_weapon.possible_item_intents)
				if(!ispath(I_path))
					continue
				var/intent_name = initial(I_path:name)
				var/intent_cd = initial(I_path:clickcd)
				var/intent_delay = initial(I_path:swingdelay)
				var/intent_can_dodge = initial(I_path:candodge)
				var/intent_can_parry = initial(I_path:canparry)
				var/predicted_rot = 5
				if(intent_cd > CLICK_CD_QUICK)
					predicted_rot += 2
				if(intent_delay > 5)
					predicted_rot += 4
				if(!intent_can_dodge || !intent_can_parry)
					predicted_rot = 0
				examine_list += span_info(" - <b>[uppertext(intent_name)]</b>: [predicted_rot] stacks")

/datum/component/ichor_stained/proc/check_dip(obj/item/source, atom/_target, mob/living/attacker, params)
	SIGNAL_HANDLER

	if(!istype(_target, /obj/item/reagent_containers/powder/black_ichor))
		return

	if(charges >= max_charges)
		to_chat(attacker, span_warning("\The [parent_weapon] can't hold any more ichor!"))
		return COMPONENT_NO_ATTACK

	attacker.visible_message(span_notice("[attacker] begins coating \the [parent_weapon] with ichor..."), span_notice("You begin coating \the [parent_weapon] in ichor..."))

	INVOKE_ASYNC(src, PROC_REF(start_dipping), _target, attacker)
	return COMPONENT_NO_ATTACK

/datum/component/ichor_stained/proc/start_dipping(obj/item/_target, mob/living/attacker, params)
	if(do_after(attacker, 0.4 SECONDS, target = _target))
		charges = min(max_charges, charges + charges_to_restore)
		update_visuals(attacker)
		to_chat(attacker, span_nicegreen("You coat the blade in a fresh layer of ichor."))
		qdel(_target)

/datum/component/ichor_stained/proc/on_attack_success(obj/item/source, mob/living/target, mob/living/user)
	SIGNAL_HANDLER
	if(charges <= 0 || !isliving(target))
		return

	// This is mostly so that if the balance of these intents changes, it won't make the dagger useless
	var/datum/intent/I = user.used_intent
	var/rot_to_apply = 5 // Base amount

	if(I)
		// If the intent is slower/heavier than the standard quick stab
		if(I.clickcd > CLICK_CD_QUICK)
			rot_to_apply += 2

		// If the swing delay is significant (0.5s or 5 deciseconds)
		if(I.swingdelay > 5) 
			rot_to_apply += 4

		if(!I.canparry || !I.candodge)
			rot_to_apply = 0

	if(rot_to_apply)
		var/datum/status_effect/buff/rot_cleansing/cleanse = target.has_status_effect(/datum/status_effect/buff/rot_cleansing)
		if(cleanse)
			cleanse.reduce_cleansing_cap(12)
		apply_black_rot(target, rot_to_apply)
		charges -= rot_to_apply
		to_chat(user, span_warning("you apply black ichor to [target]!"))

	if(charges <= 0)
		remove_visuals(user)
		to_chat(user, span_warning("The last of the ichor rubs off onto [target]!"))

/datum/component/ichor_stained/proc/apply_black_rot(mob/living/target, amount)
	var/datum/status_effect/black_rot/R = target.has_status_effect(/datum/status_effect/black_rot)
	if(R)
		R.add_stack(amount)
	else
		target.apply_status_effect(/datum/status_effect/black_rot, amount)

/datum/component/ichor_stained/proc/update_visuals(mob/living/attacker)
	parent_weapon.icon_state = "[initial(parent_weapon.icon_state)]_p"
	attacker.update_inv_hands()

/datum/component/ichor_stained/proc/remove_visuals(mob/living/user)
	parent_weapon.icon_state = initial(parent_weapon.icon_state)
	user.update_inv_hands()

/obj/projectile/bullet/rot_bolt
	name = "rot bolt"
	desc = "A glob of concentrated black rot."
	icon = 'icons/obj/structures/heart_items.dmi'
	icon_state = "ichor_bolt"
	damage = 0 // No direct damage, only applies status effect
	damage_type = BRUTE
	armor_penetration = 100
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	var/rot_stacks_to_apply = 1

/obj/projectile/bullet/rot_bolt/on_hit(atom/target, blocked)
	if(blocked)
		return ..()
	if(isliving(target))
		var/mob/living/L = target
		var/datum/status_effect/black_rot/R = L.has_status_effect(/datum/status_effect/black_rot)
		var/stacks_to_add = rot_stacks_to_apply

		// Apply scaling logic
		if(R)
			// If they have rot, we push them toward thresholds or add chunks
			if(R.stacks < 33)
				stacks_to_add = max(11, 33 - R.stacks) // Guarantee at least 11, or push to 33
			else if(R.stacks < 66)
				stacks_to_add = 11
			else
				stacks_to_add = 5
			R.add_stack(stacks_to_add)
		else
			// Initial infection
			if(prob(50))
				L.apply_status_effect(/datum/status_effect/black_rot, 1)

		to_chat(L, span_danger("The rot bolt seeps into your flesh!"))
	return ..()

/datum/special_intent/rot_ring
	name = "Rot Ring"
	desc = "Unleash a ring of black rot projectiles in all directions, starting from where you face and moving clockwise. Each bolt has a chance to inflict, or otherwise worsens black rot. The first bolt fires after a short delay."
	tile_coordinates = list(list(0,0)) // Dummy, we override deployment
	use_clickloc = FALSE
	respect_adjacency = FALSE
	delay = 0.5 SECONDS // Initial delay before first bolt
	cooldown = 45 SECONDS
	stamcost = 35
	requires_wielding = FALSE // Can be used even if not wielded
	var/bolt_delay_between = 0.25 SECONDS

/datum/special_intent/rot_ring/process_attack()
	SHOULD_CALL_PARENT(FALSE) // We handle everything manually

	howner.visible_message(span_warning("[howner]'s [iparent] pulses with dark energy!"))
	howner.Immobilize(0.5 SECONDS)
	playsound(howner, 'sound/magic/blade_burst.ogg', 80, TRUE)

	new /obj/effect/temp_visual/rot_ring_tell(get_turf(howner), howner.dir)
	var/start_angle = dir2angle(howner.dir)

	addtimer(CALLBACK(src, PROC_REF(fire_next_bolt), 1, start_angle), delay)
	apply_cooldown()

/datum/special_intent/rot_ring/proc/fire_next_bolt(index, start_angle)
	if(index > 8)
		return

	var/turf/start_turf = get_turf(howner)
	if(!start_turf)
		return

	var/current_angle = (start_angle + ((index - 1) * 45)) % 360

	var/obj/projectile/bullet/rot_bolt/bolt = new(start_turf)
	bolt.firer = howner
	bolt.def_zone = howner.zone_selected

	bolt.prepare_direct(start_turf, current_angle)

	// Schedule next bolt
	if(index < 8)
		addtimer(CALLBACK(src, PROC_REF(fire_next_bolt), index + 1, start_angle), bolt_delay_between)

/obj/projectile/bullet/rot_bolt/proc/prepare_direct(turf/start_loc, firing_angle)
	forceMove(start_loc)
	starting = start_loc
	setAngle(firing_angle)
	fire(firing_angle)

/obj/effect/temp_visual/rot_ring_tell
	icon = 'icons/effects/effects.dmi'
	icon_state = "rot_tell"
	duration = 0.5 SECONDS
	layer = ABOVE_MOB_LAYER
