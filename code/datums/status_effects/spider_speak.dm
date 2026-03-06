/atom/movable/screen/alert/status_effect/buff/spider_speak
	name = "Spider language"
	desc = "I'm able to click my tongue how spiders speak."
	icon_state = "buff"

/datum/status_effect/buff/spider_speak
	id = "spider_speak"
	alert_type = /atom/movable/screen/alert/status_effect/buff/spider_speak
	duration = 2700 SECONDS

/datum/status_effect/buff/spider_speak/on_apply()
	owner.faction += "spiders"
	examine_text = "SUBJECTPRONOUN occasionally clicks [owner.p_their(FALSE)] tongue quietly."
	return TRUE

/datum/status_effect/buff/spider_speak/on_remove()
	owner.faction -= "spiders"
	return TRUE
