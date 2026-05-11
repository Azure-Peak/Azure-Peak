/datum/status_effect/buff/fog_grace/on_remove()
	REMOVE_TRAIT(owner, TRAIT_FOG_WARDED, TRAIT_STATUS_EFFECT)
	SEND_SIGNAL(owner, COMSIG_WARDED_TRAIT_CHANGE)
	to_chat(owner, span_userdanger("The protective warmth fades. You feel the fog's hunger turning toward you..."))
	. = ..()

/atom/movable/screen/alert/status_effect/fog_grace
	name = "Fog Grace"
	desc = "The fog does not yet recognize you as prey. This protection will soon fade."
	//icon_state = "foodbuff"

/datum/status_effect/buff/fog_grace
	id = "fog_grace"
	alert_type = /atom/movable/screen/alert/status_effect/fog_grace
	effectedstats = list(STATKEY_CON = 1)
	duration = 15 MINUTES

/datum/status_effect/buff/fog_grace/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_FOG_WARDED, TRAIT_STATUS_EFFECT)
	SEND_SIGNAL(owner, COMSIG_WARDED_TRAIT_CHANGE)
	to_chat(owner, span_userdanger("You cannot fall prey to the fog yet, but it won't be long until the spirits find you..."))
