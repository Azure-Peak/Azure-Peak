/datum/action/cooldown/spell/augment_buff/fortitude
	name = "Fortitude"
	desc = "Harden one's humors to the fatigues of the body. (-25% Stamina Usage)"
	button_icon_state = "fortitude"

	invocations = list("Tenax")

	point_cost = 3

/datum/action/cooldown/spell/augment_buff/fortitude/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!isliving(cast_on))
		to_chat(H, span_warning("That is not a valid target!"))
		return FALSE

	var/mob/living/spelltarget = cast_on

	if(spelltarget != H)
		H.visible_message("[H] mutters an incantation and [spelltarget] briefly shines green.")
	else
		H.visible_message("[H] mutters an incantation and they briefly shine green.")
	apply_buff_to(spelltarget, /datum/status_effect/buff/fortitude, STAT_BUFF_SELF_DURATION)

	return TRUE
