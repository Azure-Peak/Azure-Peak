/atom/movable/screen/alert/status_effect/buff/alch
	desc = "Power rushes through your veins."
	icon_state = "buff"

/datum/status_effect/buff/alch/strengthpot
	id = "strpot"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/strengthpot
	effectedstats = list(STATKEY_STR = 3)
	duration = 3 SECONDS

/atom/movable/screen/alert/status_effect/buff/alch/strengthpot
	name = STATKEY_STR
	icon_state = "buff"

/datum/status_effect/buff/alch/perceptionpot
	id = "perpot"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/perceptionpot
	effectedstats = list(STATKEY_PER = 3)
	duration = 3 SECONDS

/atom/movable/screen/alert/status_effect/buff/alch/perceptionpot
	name = STATKEY_PER
	icon_state = "buff"

/datum/status_effect/buff/alch/intelligencepot
	id = "intpot"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/intelligencepot
	effectedstats = list(STATKEY_INT = 3)
	duration = 3 SECONDS

/atom/movable/screen/alert/status_effect/buff/alch/intelligencepot
	name = STATKEY_INT
	icon_state = "buff"

/datum/status_effect/buff/alch/constitutionpot
	id = "conpot"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/constitutionpot
	effectedstats = list(STATKEY_CON = 3)
	duration = 3 SECONDS

/atom/movable/screen/alert/status_effect/buff/alch/constitutionpot
	name = STATKEY_CON
	icon_state = "buff"

/datum/status_effect/buff/alch/endurancepot
	id = "endpot"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/endurancepot
	effectedstats = list(STATKEY_WIL = 3)
	duration = 3 SECONDS

/atom/movable/screen/alert/status_effect/buff/alch/endurancepot
	name = STATKEY_WIL
	icon_state = "buff"

/datum/status_effect/buff/alch/speedpot
	id = "spdpot"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/speedpot
	effectedstats = list(STATKEY_SPD = 3)
	duration = 3 SECONDS

/atom/movable/screen/alert/status_effect/buff/alch/speedpot
	name = STATKEY_SPD
	icon_state = "buff"

/datum/status_effect/buff/alch/fortunepot
	id = "forpot"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/fortunepot
	effectedstats = list(STATKEY_LCK = 3)
	duration = 3 SECONDS

/atom/movable/screen/alert/status_effect/buff/alch/fortunepot
	name = STATKEY_LCK
	icon_state = "buff"

/datum/status_effect/buff/alch/tripot
	id = "tripot" //Triumph-exclusive. Shouldn't be craftable or obtainable under any other circumstance.
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/tripot
	effectedstats = list(STATKEY_STR = 1, STATKEY_PER = 1, STATKEY_INT = 1, STATKEY_CON = 1, STATKEY_WIL = 1, STATKEY_SPD = 1, STATKEY_LCK = 1)
	duration = 777 MINUTES

/atom/movable/screen/alert/status_effect/buff/alch/tripot
	name = "Triumphance"
	desc = "My latest triumph has empowered me! I am a true champion of Azuria!"
	icon_state = "triumph"

//////////////////////
// NON-STAT BUFFS ! //
//////////////////////

/datum/status_effect/buff/alch/fire_resist
	id = "fire resistance"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/fire_resist
	duration = 15 MINUTES

/datum/status_effect/buff/alch/fire_resist/on_apply()
	. = ..()
	if(!HAS_TRAIT(owner, TRAIT_NOFIRE))
		ADD_TRAIT(owner, TRAIT_NOFIRE, src)

/datum/status_effect/buff/alch/fire_resist/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_NOFIRE, src)

/atom/movable/screen/alert/status_effect/buff/alch/fire_resist
	name = "Fire Resistance"
	desc = "My hide toughens to fire."
	icon_state = "buff"
