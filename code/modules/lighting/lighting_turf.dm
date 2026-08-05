/turf
	var/dynamic_lighting = TRUE
	luminosity           = 1

	var/tmp/lighting_corners_initialised = FALSE

	var/tmp/atom/movable/lighting_object/lighting_object // Our lighting object.
	var/tmp/list/datum/lighting_corner/corners
	var/tmp/opaque_atom_count = 0 // Not to be confused with opacity, this is the number of opaque atoms on the tile.

// Causes any affecting light sources to be queued for a visibility update, for example a door got opened.
/turf/proc/reconsider_lights()
	for(var/datum/lighting_corner/corner as anything in get_corners())
		corner.vis_update()

/turf/proc/lighting_clear_overlay()
	if (lighting_object)
		qdel(lighting_object, TRUE)

// Builds a lighting object for us, but only if our area is dynamic.
/turf/proc/lighting_build_overlay()
	if(lighting_object)
		qdel(lighting_object,force=TRUE) //Shitty fix for lighting objects persisting after death

	new/atom/movable/lighting_object(src)

// Used to get a scaled lumcount.
/turf/proc/get_lumcount(minlum = 0, maxlum = 1)
	if (!lighting_object)
		return 1

	var/totallums = 0
	var/thing
	var/datum/lighting_corner/L
	var/totalSunFalloff
	for (thing in corners)
		if(!thing)
			continue
		L = thing
		totallums += L.lum_r + L.lum_b + L.lum_g
		totalSunFalloff += L.sunFalloff

	if(outdoor_effect && outdoor_effect.state)
		totalSunFalloff = 4

	totallums += totalSunFalloff / 4

	totallums /= 12 // 4 corners, each with 3 channels, get the average.

	totallums = (totallums - minlum) / (maxlum - minlum)
	totallums += dynamic_lumcount

	return CLAMP01(totallums)

// Returns a boolean whether the turf is on soft lighting.
// Soft lighting being the threshold at which point the overlay considers
// itself as too dark to allow sight and see_in_dark becomes useful.
// So basically if this returns true the tile is unlit black.
/turf/proc/is_softly_lit()
	if (!lighting_object)
		return FALSE

	return !lighting_object.luminosity

// Can't think of a good name, this proc will recalculate the opaque_atom_count variable.
/turf/proc/recalc_atom_opacity()
	opaque_atom_count = opacity // we count ourselves
	for (var/atom/A in src.contents) // Loop through every movable atom on our tile
		if (A.opacity)
			opaque_atom_count++

/turf/proc/change_area(area/old_area, area/new_area)
	GLOB.SUNLIGHT_QUEUE_WORK += src
	if(outdoor_effect)
		GLOB.SUNLIGHT_QUEUE_UPDATE += outdoor_effect
	if(SSlighting.initialized)
		if (new_area.dynamic_lighting != old_area.dynamic_lighting)
			if (new_area.dynamic_lighting)
				lighting_build_overlay()
			else
				lighting_clear_overlay()

/turf/proc/get_corners()
	if (!IS_DYNAMIC_LIGHTING(src) && !light_sources)
		return null
	if (!lighting_corners_initialised)
		generate_missing_corners()
	if (opacity || (opaque_atom_count > 0))
		return null // Since this proc gets used in a for loop, null won't be looped though.

	return corners

/turf/proc/generate_missing_corners()
	if (!IS_DYNAMIC_LIGHTING(src) && !light_sources)
		return
	lighting_corners_initialised = TRUE
	if (!corners)
		corners = list(null, null, null, null)

	for (var/i = 1 to 4)
		if (corners[i]) // Already have a corner on this direction.
			continue

		corners[i] = new/datum/lighting_corner(src, GLOB.LIGHTING_CORNER_DIAGONAL[i])
