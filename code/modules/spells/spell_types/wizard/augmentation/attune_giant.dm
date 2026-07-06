/datum/action/cooldown/spell/augment_buff/attune_giant
	name = "Attune: Giant"
	desc = "Strengthen the target. (+4 Strength, grants Guidance)\nAttunement - Giant, Hawk, and Haste share a cooldown; only one may be held at a time."
	button_icon_state = "giants_strength"

	invocations = list("Vis Gigantis.")
	shared_cooldown = "augment_attunement"

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
	apply_buff_to(spelltarget, /datum/status_effect/buff/attune_giant, STAT_BUFF_SELF_DURATION)

	return TRUE
