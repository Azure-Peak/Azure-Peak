#define DRAGONHIDE_FILTER "dragonhide_glow"

/datum/status_effect/buff/dragonhide
	id = "dragonscaled"
	alert_type = /atom/movable/screen/alert/status_effect/buff/dragonhide
	duration = -1
	var/outline_colour = "#c23d09"

/atom/movable/screen/alert/status_effect/buff/dragonhide
	name = "Dragonhide"
	desc = "Flames dance at my heels, yet do not sting!"

/datum/status_effect/buff/dragonhide/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_NOFIRE, TRAIT_GENERIC)
	var/filter = owner.get_filter(DRAGONHIDE_FILTER)
	if (!filter)
		owner.add_filter(DRAGONHIDE_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))

/datum/status_effect/buff/dragonhide/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_NOFIRE, TRAIT_GENERIC)
	owner.remove_filter(DRAGONHIDE_FILTER)

#undef DRAGONHIDE_FILTER
