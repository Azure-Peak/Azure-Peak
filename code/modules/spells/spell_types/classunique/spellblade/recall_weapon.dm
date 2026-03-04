/obj/effect/proc_holder/spell/self/recall_weapon
	name = "Recall Weapon"
	desc = "Recall your bound weapon to your hand from anywhere."
	clothes_req = FALSE
	action_icon = 'icons/mob/actions/spellblade.dmi'
	overlay_state = "recall_weapon"
	releasedrain = 15
	chargedrain = 0
	chargetime = 0
	recharge_time = 20 SECONDS
	warnie = "spellwarning"
	invocations = list("Revoca, ferrum!")
	invocation_type = "shout"
	gesture_required = TRUE
	xp_gain = FALSE

/obj/effect/proc_holder/spell/self/recall_weapon/cast(list/targets, mob/user = usr)
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		revert_cast()
		return

	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	var/obj/item/bound_weapon = M?.bound_weapon

	if(!bound_weapon || QDELETED(bound_weapon))
		to_chat(H, span_warning("I have no bound weapon to recall!"))
		revert_cast()
		return

	if(bound_weapon in H.held_items)
		to_chat(H, span_warning("My bound weapon is already in my hand!"))
		revert_cast()
		return

	// If the weapon is embedded in someone, rip it out first
	if(bound_weapon.is_embedded && istype(bound_weapon.loc, /obj/item/bodypart))
		var/obj/item/bodypart/BP = bound_weapon.loc
		BP.remove_embedded_object(bound_weapon)
	else if(ismob(bound_weapon.loc))
		var/mob/holder = bound_weapon.loc
		holder.dropItemToGround(bound_weapon, TRUE)

	var/turf/weapon_turf = get_turf(bound_weapon)
	if(!weapon_turf)
		to_chat(H, span_warning("Cannot locate my bound weapon!"))
		revert_cast()
		return

	playsound(weapon_turf, 'sound/magic/blink.ogg', 30, TRUE)
	weapon_turf.visible_message(span_notice("[bound_weapon] vanishes in a flash of arcyne light."))

	if(!H.put_in_hands(bound_weapon))
		bound_weapon.forceMove(get_turf(H))
		to_chat(H, span_notice("My bound weapon returns to my feet — my hands are full."))
	else
		to_chat(H, span_notice("My bound weapon flies back to my hand."))

	playsound(get_turf(H), 'sound/magic/blink.ogg', 40, TRUE)
	H.visible_message(span_notice("[bound_weapon] materializes in [H]'s hand."))
	return TRUE
