/datum/status_effect/recent_weapon
	id = "recent_weapon"
	alert_type = null
	duration = 10 SECONDS

/datum/status_effect/recent_weapon/on_creation(mob/living/new_owner, duration = 10 SECONDS)
	src.duration = duration
	return ..()
