/datum/action/cooldown/spell/augment_buff/stoneskin
	name = "Stoneskin"
	desc = "Harden the target's skin like stone. (+5 Constitution)"
	button_icon_state = "stoneskin"

	invocations = list("Perstare Sicut Saxum.")

	point_cost = 1

/datum/action/cooldown/spell/augment_buff/stoneskin/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!isliving(cast_on))
		to_chat(H, span_warning("That is not a valid target!"))
		return FALSE

	var/mob/living/spelltarget = cast_on

	if(spelltarget != H)
		H.visible_message("[H] mutters an incantation and [spelltarget]'s skin hardens like stone.")
	else
		H.visible_message("[H] mutters an incantation and their skin hardens.")
	apply_buff_to(spelltarget, /datum/status_effect/buff/stoneskin, STAT_BUFF_SELF_DURATION)

	return TRUE
