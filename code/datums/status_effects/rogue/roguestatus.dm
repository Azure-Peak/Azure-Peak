/datum/status_effect/mood
	id = "mood"

/datum/status_effect/mood/bad
	id = "mood"
	effectedstats = list(STATKEY_LCK = -1)
	alert_type = /atom/movable/screen/alert/status_effect/moodbad
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/moodbad
	name = "Stressed"
	desc = ""
	icon_state = "stressb"

/datum/status_effect/mood/vbad
	id = "mood"
	effectedstats = list(STATKEY_LCK = -2)
	alert_type = /atom/movable/screen/alert/status_effect/moodvbad
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/moodvbad
	name = "Max Stress"
	desc = ""
	icon_state = "stressvb"

/datum/status_effect/mood/good
	id = "mood"
	effectedstats = list(STATKEY_LCK = 1)
	alert_type = /atom/movable/screen/alert/status_effect/moodgood
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/moodgood
	name = "Inner Peace"
	desc = ""
	icon_state = "stressg"

/datum/status_effect/mood/vgood
	id = "mood"
	effectedstats = list(STATKEY_LCK = 2)
	alert_type = /atom/movable/screen/alert/status_effect/moodvgood
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/moodvgood
	name = "Max Peace"
	desc = ""
	icon_state = "stressvg"
