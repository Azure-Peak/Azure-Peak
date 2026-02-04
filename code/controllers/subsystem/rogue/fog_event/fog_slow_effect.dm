#define MOVESPEED_ID_FOG_SLOW "movespeed_fog_slow"
#define FILTER_SLOWING_FOG "filter_slowing_fog"

/datum/status_effect/debuff/fog_chilled
	id = "fog_chilled"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/fog_chilled
	var/slowdown_val = 1.75

/datum/status_effect/debuff/fog_chilled/on_apply()
	if(!isliving(owner))
		return FALSE
	owner.add_movespeed_modifier(MOVESPEED_ID_FOG_SLOW, update=TRUE, multiplicative_slowdown=slowdown_val)

	// Add a subtle fog screen filter to the player
	var/mob/living/L = owner
	var/list/filter_params = list(
		"type" = "layer",
		"icon" = icon('icons/mob/mob_effects_fog.dmi', "subtle"),
		"render_source" = L.render_target, 
		"blend_mode" = BLEND_INSET_OVERLAY
		)
	L.add_filter(FILTER_SLOWING_FOG, 1, filter_params)
	return TRUE

/datum/status_effect/debuff/fog_chilled/on_remove()
	owner.remove_movespeed_modifier(MOVESPEED_ID_FOG_SLOW)
	var/mob/living/L = owner
	L.remove_filter(FILTER_SLOWING_FOG)
	return ..()

/atom/movable/screen/alert/status_effect/fog_chilled
	name = "Chilling Fog"
	desc = "The heavy mist clings to your limbs, making every movement a chore. Something moves within the white..."
	//icon_state = "fog_alert"

#undef MOVESPEED_ID_FOG_SLOW
#undef FILTER_SLOWING_FOG
