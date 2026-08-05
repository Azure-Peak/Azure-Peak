/atom/movable/screen/alert/status_effect/buff/alch
	desc = "Power rushes through your veins."
	icon_state = "buff"

// A new system for statbuff, that increases the duration based on how much is consumed, capping it out
// The long duration and trade off is meant to make it more viable to take as a PVE supplement, combined with the lower statweight
#define STATBUFF_FILTER "statbuff_glow"

/datum/status_effect/buff/alch/statbuff
	duration = 1 MINUTES
	var/max_duration = 10 MINUTES
	var/outline_colour = "#008000"
	var/buff_flavor

/datum/status_effect/buff/alch/statbuff/on_creation(mob/living/new_owner, added_duration = 1 MINUTES)
	duration = min(added_duration, max_duration)
	return ..()

/datum/status_effect/buff/alch/statbuff/refresh(mob/living/new_owner, added_duration = 1 MINUTES)
	add_duration(added_duration)

/datum/status_effect/buff/alch/statbuff/proc/add_duration(amount)
	if(duration == -1)
		return
	duration = min(duration + amount, world.time + max_duration)

/datum/status_effect/buff/alch/statbuff/on_apply()
	. = ..()
	if(!.)
		return
	var/list/to_clear = list()
	for(var/datum/status_effect/buff/alch/statbuff/other in owner.status_effects)
		if(other == src)
			continue
		to_clear += other
	for(var/datum/status_effect/buff/alch/statbuff/loser in to_clear)
		qdel(loser)
	if(!owner.get_filter(STATBUFF_FILTER))
		owner.add_filter(STATBUFF_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 50, "size" = 1))
	if(buff_flavor)
		owner.balloon_alert_to_viewers("<font color='[outline_colour]'>[buff_flavor]</font>")

/datum/status_effect/buff/alch/statbuff/on_remove()
	. = ..()
	owner.remove_filter(STATBUFF_FILTER)

#undef STATBUFF_FILTER

/datum/status_effect/buff/alch/statbuff/strengthpot
	id = "strpot"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/strengthpot
	effectedstats = list(STATKEY_STR = 2, STATKEY_LCK = -1, STATKEY_INT = -1, STATKEY_PER = -1)
	outline_colour = "#ff9000"
	buff_flavor = "strength (str +2, for -1, int -1, per -1)!"

/atom/movable/screen/alert/status_effect/buff/alch/strengthpot
	name = STATKEY_STR
	icon_state = "buff"

/datum/status_effect/buff/alch/statbuff/perceptionpot
	id = "perpot"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/perceptionpot
	effectedstats = list(STATKEY_PER = 2, STATKEY_LCK = -1)
	outline_colour = "#45c8ff"
	buff_flavor = "perception (per +2, for -1)!"

/atom/movable/screen/alert/status_effect/buff/alch/perceptionpot
	name = STATKEY_PER
	icon_state = "buff"

/datum/status_effect/buff/alch/statbuff/intelligencepot
	id = "intpot"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/intelligencepot
	effectedstats = list(STATKEY_INT = 2, STATKEY_LCK = -1)
	outline_colour = "#7b5cff"
	buff_flavor = "intelligence (int +2, for -1)!"

/atom/movable/screen/alert/status_effect/buff/alch/intelligencepot
	name = STATKEY_INT
	icon_state = "buff"

/datum/status_effect/buff/alch/statbuff/constitutionpot
	id = "conpot"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/constitutionpot
	effectedstats = list(STATKEY_CON = 2, STATKEY_LCK = -1)
	outline_colour = "#a0522d"
	buff_flavor = "constitution (con +2, for -1)!"

/atom/movable/screen/alert/status_effect/buff/alch/constitutionpot
	name = STATKEY_CON
	icon_state = "buff"

/datum/status_effect/buff/alch/statbuff/endurancepot
	id = "endpot"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/endurancepot
	effectedstats = list(STATKEY_WIL = 2, STATKEY_LCK = -1)
	outline_colour = "#d63384"
	buff_flavor = "willpower (wil +2, for -1)!"

/atom/movable/screen/alert/status_effect/buff/alch/endurancepot
	name = STATKEY_WIL
	icon_state = "buff"

/datum/status_effect/buff/alch/statbuff/speedpot
	id = "spdpot"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/speedpot
	effectedstats = list(STATKEY_SPD = 2, STATKEY_LCK = -1, STATKEY_WIL = -1, STATKEY_CON = -1)
	outline_colour = "#00d9b5"
	buff_flavor = "speed (spd +2, for -1, wil -1, con -1)!"

/atom/movable/screen/alert/status_effect/buff/alch/speedpot
	name = STATKEY_SPD
	icon_state = "buff"

/datum/status_effect/buff/alch/statbuff/fortunepot
	id = "forpot"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/fortunepot
	effectedstats = list(STATKEY_LCK = 3)
	outline_colour = "#ffd700"
	buff_flavor = "fortune (for +3)!"

/atom/movable/screen/alert/status_effect/buff/alch/fortunepot
	name = STATKEY_LCK
	icon_state = "buff"

/datum/status_effect/buff/alch/statbuff/fortitude
	id = "fortitudepot"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/fortitude
	buff_flavor = "fortitude (-15% stam)!"

/datum/status_effect/buff/alch/statbuff/fortitude/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_FORTITUDE, src)
	to_chat(owner, span_warning("My body feels lighter..."))

/datum/status_effect/buff/alch/statbuff/fortitude/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_FORTITUDE, src)
	to_chat(owner, span_warning("The weight of the world rests upon my shoulders once more."))

/atom/movable/screen/alert/status_effect/buff/alch/fortitude
	name = "Fortitude"
	desc = "My humors have been hardened to the fatigues of the body. (-15% Stamina Usage)"
	icon_state = "buff"

//////////////////////
// NON-STAT BUFFS ! //
//////////////////////

/datum/status_effect/buff/alch/fire_resist
	id = "fire resistance"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/fire_resist
	duration = 15 MINUTES

/datum/status_effect/buff/alch/fire_resist/on_apply()
	. = ..()
	if(!HAS_TRAIT(owner, TRAIT_FIRE_RESIST))
		ADD_TRAIT(owner, TRAIT_FIRE_RESIST, src)

/datum/status_effect/buff/alch/fire_resist/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_FIRE_RESIST, src)

/atom/movable/screen/alert/status_effect/buff/alch/fire_resist
	name = "Fire Resistance"
	desc = "My hide toughens to fire."
	icon_state = "buff"
