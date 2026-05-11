#define CRYSTALHIDE_FILTER "crystalhide_glow"

/datum/status_effect/buff/crystalhide
	id = "crystalhide"
	alert_type = /atom/movable/screen/alert/status_effect/buff/crystalhide
	duration = -1
	effectedstats = list(STATKEY_INT = 1)
	var/outline_colour = "#3aa8ff"

/atom/movable/screen/alert/status_effect/buff/crystalhide
	name = "Crystalhide Aggregatemind"
	desc = "Collection of worldline-static; my mind expandeth. Whispers and suggestions from foreign egos are encoded on the holographic boundary."

/datum/status_effect/buff/crystalhide/on_apply()
	. = ..()
	var/filter = owner.get_filter(CRYSTALHIDE_FILTER)
	if(!filter)
		owner.add_filter(CRYSTALHIDE_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 40, "size" = 1))

/datum/status_effect/buff/crystalhide/on_remove()
	. = ..()
	owner.remove_filter(CRYSTALHIDE_FILTER)

#undef CRYSTALHIDE_FILTER
