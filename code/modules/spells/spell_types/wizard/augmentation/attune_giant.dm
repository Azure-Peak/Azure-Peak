/datum/action/cooldown/spell/augment_buff/attune_giant
	name = "Attune: Giant"
	desc = "Strengthen the target. (+4 Strength)\nAttunement - Giant, Hawk, and Haste share a cooldown; only one may be held at a time."
	button_icon_state = "giants_strength"

	invocations = list("Vis Gigantis.")
	shared_cooldown = "augment_attunement"
	other_cast_cooldown_reduction = 0.33 // Casting on an ally cuts a third off the cooldown

	point_cost = 2

/datum/action/cooldown/spell/augment_buff/attune_giant/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!isliving(cast_on))
		to_chat(H, span_warning("That is not a valid target!"))
		return FALSE

	var/mob/living/spelltarget = cast_on

	if(spelltarget != H)
		H.visible_message("[H] mutters an incantation and [spelltarget]'s muscles strengthen and grow.")
	else
		H.visible_message("[H] mutters an incantation and their muscles strengthen and grow.")
	spelltarget.apply_status_effect(/datum/status_effect/buff/attune_giant, ATTUNE_BUFF_DURATION)

	return TRUE
