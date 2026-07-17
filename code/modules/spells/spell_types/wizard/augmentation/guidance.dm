/datum/action/cooldown/spell/augment_buff/guidance
	name = "Guidance"
	desc = "Channel arcyne power unto an ally, empowering their next strike to bypass parry and dodge. Works with both weapons and unarmed attacks. \
		Enable Fellowship Mode (Shift+G) to snap an off-target cast to your nearest fellowship member in range. \
		Casting it on yourself increases the cooldown by half."
	button_icon_state = "guidance"

	invocations = list("Vera Manus!")
	invocation_type = INVOCATION_SHOUT
	cooldown_time = 30 SECONDS

	point_cost = 2
	charge_time = 0 // Special

	self_cast_cooldown_multiplier = 1.5

	/// How long the empowered strike lingers - longer than Empower Weapon's, so a guided ally has time to close in.
	var/empowered_duration = 10 SECONDS

/datum/action/cooldown/spell/augment_buff/guidance/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!isliving(cast_on))
		to_chat(H, span_warning("That is not a valid target!"))
		return FALSE

	var/mob/living/spelltarget = cast_on

	if(spelltarget.has_status_effect(/datum/status_effect/buff/empowered_strike))
		to_chat(H, span_warning("[spelltarget == H ? "My" : "[spelltarget]'s"] weapon is already empowered!"))
		H.balloon_alert(H, "already empowered!")
		return FALSE

	spelltarget.apply_status_effect(/datum/status_effect/buff/empowered_strike, empowered_duration)

	if(spelltarget == H)
		H.visible_message("[H] mutters an incantation and their weapon flares with a violent red glow!")
		to_chat(H, span_notice("I guide my own strike - the next will not be denied. ([self_cast_cooldown_multiplier]x cooldown)"))
	else
		H.visible_message("[H] mutters an incantation and [spelltarget]'s weapon flares with a violent red glow!")
		to_chat(H, span_notice("I guide [spelltarget]'s strike - their next will not be denied."))
		to_chat(spelltarget, span_notice("[H]'s guidance empowers my weapon - my next strike will not be denied!"))

	return TRUE
