/datum/status_effect/buff/brew
	exclusive_group = "brew"
	exclusive_quiet = TRUE
	duration = 10 MINUTES

/datum/status_effect/buff/brew/on_creation(mob/living/new_owner, ...)
	for(var/S in effectedstats)
		exclusive_priority += effectedstats[S]
	return ..()

/datum/status_effect/buff/brew/vigorized
	id = "vigorized"
	alert_type = /atom/movable/screen/alert/status_effect/vigorized
	effectedstats = list(STATKEY_SPD = 1, STATKEY_INT = 1)

/datum/status_effect/buff/brew/vigorized/on_apply()
	. = ..()
	if(.)
		to_chat(owner, span_warning("I feel a surge of energy inside me!"))

/datum/status_effect/buff/brew/vigorized/on_remove()
	. = ..()
	if(!rejected_by_exclusion)
		to_chat(owner, span_warning("The surge of energy inside me fades..."))

/atom/movable/screen/alert/status_effect/vigorized
	name = "Vigorized"
	desc = "I feel a surge of energy inside, quickening my speed and sharpening my focus."
	icon_state = "vigorized"

/datum/status_effect/buff/brew/ravox_calm
	id = "ravoxcalm"
	alert_type = /atom/movable/screen/alert/status_effect/buff/brew/ravox_calm
	effectedstats = list(STATKEY_SPD = 1, STATKEY_CON = 1)

/datum/status_effect/buff/brew/perception
	id = "pertea"
	alert_type = /atom/movable/screen/alert/status_effect/buff/brew/per
	effectedstats = list(STATKEY_PER = 1)

/datum/status_effect/buff/brew/constitution
	id = "contea"
	alert_type = /atom/movable/screen/alert/status_effect/buff/brew/con
	effectedstats = list(STATKEY_CON = 1)

/datum/status_effect/buff/brew/willpower
	id = "wiltea"
	alert_type = /atom/movable/screen/alert/status_effect/buff/brew/wil
	effectedstats = list(STATKEY_WIL = 1)

/datum/status_effect/buff/brew/intelligence
	id = "inttea"
	alert_type = /atom/movable/screen/alert/status_effect/buff/brew/int
	effectedstats = list(STATKEY_INT = 1)

/atom/movable/screen/alert/status_effect/buff/brew
	desc = "An herbal brew fortifies your body."
	icon_state = "buff"

/atom/movable/screen/alert/status_effect/buff/brew/ravox_calm
	name = "Ravox's Calm"

/atom/movable/screen/alert/status_effect/buff/brew/per
	name = STATKEY_PER

/atom/movable/screen/alert/status_effect/buff/brew/con
	name = STATKEY_CON

/atom/movable/screen/alert/status_effect/buff/brew/wil
	name = STATKEY_WIL

/atom/movable/screen/alert/status_effect/buff/brew/int
	name = STATKEY_INT

/datum/status_effect/debuff/baothaforget
	id = "baothaforget"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/baothaforget
	effectedstats = list(STATKEY_INT = -5)
	duration = 3 MINUTES

/atom/movable/screen/alert/status_effect/debuff/baothaforget
	name = "Scorned indulgence"
	desc = "Your memory and wit fails you, the current moment seems all that matters"
	icon_state = "debuff"
