/datum/component/fog_entity
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/vanishing = FALSE

/datum/component/fog_entity/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	RegisterSignal(parent, COMSIG_ENTER_AREA, .proc/check_area_safety)
	RegisterSignal(SSevent_scheduler, COMSIG_FOG_END, .proc/fog_end)

/datum/component/fog_entity/proc/check_area_safety(datum/source, area/new_area)
	SIGNAL_HANDLER
	if(vanishing)
		return

	if(new_area.fog_protected)
		start_vanishing()

/datum/component/fog_entity/proc/start_vanishing()
	vanishing = TRUE
	var/mob/living/simple_animal/hostile/retaliate/rogue/revenant/R = parent
	
	R.visible_message(span_notice("[R] shimmers and begins to dissolve as it enters the light..."))

	if(istype(R))
		R.disappear_animated()
	else
		qdel(R) // Fallback for non-revenant types
		// You know, just in case someone gives this to any other cool mobs.

/datum/component/fog_entity/proc/fog_end()
	SIGNAL_HANDLER
	start_vanishing()
