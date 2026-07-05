/datum/action/cooldown/spell/augment_buff/attune_hawk
	name = "Attune: Hawk"
	desc = "Sharpen the target's body and vision. (+1 Strength, +4 Perception, grants Guidance)\nAttunement - Giant, Hawk, and Haste share a cooldown; only one may be held at a time."
	button_icon_state = "hawks_eyes"

	invocations = list("Oculi Accipitris.")

	shared_cooldown = "augment_attunement"

	point_cost = 2

/datum/action/cooldown/spell/augment_buff/attune_hawk/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!isliving(cast_on))
		to_chat(H, span_warning("That is not a valid target!"))
		return FALSE

	var/mob/living/spelltarget = cast_on

	if(spelltarget != H)
		H.visible_message("[H] mutters an incantation and [spelltarget]'s eyes glimmer.")
	else
		H.visible_message("[H] mutters an incantation and their eyes glimmer.")
	apply_buff_to(spelltarget, /datum/status_effect/buff/attune_hawk, STAT_BUFF_SELF_DURATION)

	return TRUE
