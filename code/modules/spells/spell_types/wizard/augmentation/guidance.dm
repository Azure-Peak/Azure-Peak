/datum/action/cooldown/spell/augment_buff/guidance
	name = "Guidance"
	desc = "Makes one's hand travel true, blessing them with arcyne luck in combat. (+20% chance to bypass parry / dodge, +20% chance to parry / dodge)"
	button_icon_state = "guidance"

	invocations = list("Ducere")
	cooldown_time = 60 SECONDS // 100% uptime, by design

	point_cost = 1

/datum/action/cooldown/spell/augment_buff/guidance/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!isliving(cast_on))
		to_chat(H, span_warning("That is not a valid target!"))
		return FALSE

	var/mob/living/spelltarget = cast_on

	if(spelltarget != H)
		H.visible_message("[H] mutters an incantation and [spelltarget] briefly shines orange.")
	else
		H.visible_message("[H] mutters an incantation and they briefly shine orange.")
	apply_buff_to(spelltarget, /datum/status_effect/buff/guidance, STAT_BUFF_SELF_DURATION)

	return TRUE
