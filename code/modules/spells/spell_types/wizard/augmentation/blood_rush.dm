/datum/action/cooldown/spell/augment_buff/blood_rush
	name = "Blood Rush"
	desc = "Flood the target's veins with a surge of vigor, quickening their body for a short burst."
	button_icon_state = "blood_rush"

	cooldown_time = 60 SECONDS

	invocations = list("Sanguis Fervet.")

	point_cost = 1

/datum/action/cooldown/spell/augment_buff/blood_rush/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!isliving(cast_on))
		to_chat(H, span_warning("That is not a valid target!"))
		return FALSE

	var/mob/living/spelltarget = cast_on

	if(spelltarget != H)
		H.visible_message("[H] mutters an incantation and [spelltarget]'s veins flush with sudden vigor.")
		spelltarget.apply_status_effect(/datum/status_effect/buff/adrenaline_rush)
		H.apply_status_effect(/datum/status_effect/buff/adrenaline_rush)
		to_chat(H, span_notice("The surge courses through me as well!"))
	else
		H.visible_message("[H] mutters an incantation and their veins flush with sudden vigor.")
		H.apply_status_effect(/datum/status_effect/buff/adrenaline_rush)

	return TRUE
