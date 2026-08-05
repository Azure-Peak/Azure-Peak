// Yes this doesn't align correctly on anything other than 4 width tabs.
// If you want it to go switch everybody to elastic tab stops.
// Actually that'd be great if you could!
#define EFFECT_UPDATE(level)                \
	if (needs_update == LIGHTING_NO_UPDATE) \
		SSlighting.sources_queue += src; \
	if (needs_update < level)               \
		needs_update = level;    \

// This is where the fun begins.
// These are the main datums that emit light.

/datum/light_source
	var/atom/top_atom        // The atom we're emitting light from (for example a mob if we're from a flashlight that's being held).
	var/atom/source_atom     // The atom that we belong to.

	var/turf/source_turf     // The turf under the above.
	var/turf/pixel_turf      // The turf the top_atom appears to over.
	var/light_power    // Intensity of the emitter light.
	/// The range of the emitted light.
	var/light_inner_range
	/// Range where light begins to taper into darkness in tiles.
	var/light_outer_range
	/// Adjusts curve for falloff gradient
	var/light_falloff_curve = LIGHTING_DEFAULT_FALLOFF_CURVE
	var/light_color    // The colour of the light, string, decomposed by parse_light_color()

	// Variables for keeping track of the colour.
	var/lum_r
	var/lum_g
	var/lum_b

	// The lumcount values used to apply the light.
	var/tmp/applied_lum_r
	var/tmp/applied_lum_g
	var/tmp/applied_lum_b

	var/list/datum/lighting_corner/effect_str     // List used to store how much we're affecting corners.

	var/applied = FALSE // Whether we have applied our light yet or not.

	var/needs_update = LIGHTING_NO_UPDATE    // Whether we are queued for an update.


/datum/light_source/New(atom/owner, atom/top)
	source_atom = owner // Set our new owner.
	add_to_light_sources(source_atom)
	top_atom = top
	if (top_atom != source_atom)
		add_to_light_sources(top_atom)

	source_turf = top_atom
	pixel_turf = get_turf_pixel(top_atom) || source_turf

	light_power = source_atom.light_power
	light_inner_range = source_atom.light_inner_range
	light_outer_range = source_atom.light_outer_range
	light_falloff_curve = source_atom.light_falloff_curve
	light_color = source_atom.light_color

	parse_light_color()

	update()

/datum/light_source/Destroy(force)
	remove_lum()
	if (source_atom)
		LAZYREMOVE(source_atom.light_sources, src)

	if (top_atom)
		LAZYREMOVE(top_atom.light_sources, src)

	if (needs_update)
		SSlighting.sources_queue -= src

	. = ..()

///add this light source to new_atom_host's light_sources list. updating movement registrations as needed
/datum/light_source/proc/add_to_light_sources(atom/new_atom_host)
	if(QDELETED(new_atom_host))
		return FALSE

	LAZYADD(new_atom_host.light_sources, src)
	//yes, we register the signal to the top atom too, this is intentional and ensures contained lighting updates properly
	if(ismovable(new_atom_host) && new_atom_host == source_atom)
		RegisterSignal(new_atom_host, COMSIG_MOVABLE_MOVED, PROC_REF(update_host_lights))
	return TRUE

///remove this light source from old_atom_host's light_sources list, unsetting movement registrations
/datum/light_source/proc/remove_from_light_sources(atom/old_atom_host)
	if(QDELETED(old_atom_host))
		return FALSE

	LAZYREMOVE(old_atom_host.light_sources, src)
	if(ismovable(old_atom_host) && old_atom_host == source_atom)
		UnregisterSignal(old_atom_host, COMSIG_MOVABLE_MOVED)
	return TRUE

///signal handler for when our host atom moves and we need to update our effects
/datum/light_source/proc/update_host_lights(atom/movable/host)
	SIGNAL_HANDLER
	if(QDELETED(host))
		return

	// If the host is our owner, we want to call their update so they can decide who the top atom should be
	if(host == source_atom)
		host.update_light()
		return

	// Otherwise, our top atom just moved, so we trigger a normal rebuild
	EFFECT_UPDATE(LIGHTING_CHECK_UPDATE)

// This proc will cause the light source to update the top atom, and add itself to the update queue.
/datum/light_source/proc/update(atom/new_top_atom)
	// This top atom is different.
	if (new_top_atom && new_top_atom != top_atom)
		if(top_atom != source_atom && top_atom.light_sources) // Remove ourselves from the light sources of that top atom.
			LAZYREMOVE(top_atom.light_sources, src)

		top_atom = new_top_atom

		if (top_atom != source_atom)
			LAZYADD(top_atom.light_sources, src) // Add ourselves to the light sources of our new top atom.

	EFFECT_UPDATE(LIGHTING_CHECK_UPDATE)

// Will force an update without checking if it's actually needed.
/datum/light_source/proc/force_update()
	EFFECT_UPDATE(LIGHTING_FORCE_UPDATE)

// Will cause the light source to recalculate turfs that were removed or added to visibility only.
/datum/light_source/proc/vis_update()
	EFFECT_UPDATE(LIGHTING_VIS_UPDATE)

// Decompile the hexadecimal colour into lumcounts of each perspective.
/datum/light_source/proc/parse_light_color()
	if (light_color)
		lum_r = GetRedPart   (light_color) / 255
		lum_g = GetGreenPart (light_color) / 255
		lum_b = GetBluePart  (light_color) / 255
	else
		lum_r = 1
		lum_g = 1
		lum_b = 1

// This exists so we can cache the vars used in this macro, and save MASSIVE time :)
// Most of this is saving off datum var accesses, tho some of it does actually cache computation
// You will NEED to call this before you call APPLY_CORNER
#define SETUP_CORNERS_CACHE(lighting_source) \
	var/_turf_x = lighting_source.pixel_turf.x; \
	var/_turf_y = lighting_source.pixel_turf.y; \
	var/_turf_z = lighting_source.pixel_turf.z; \
	var/_range_divisor = max(light_outer_range - light_inner_range, 1); \
	var/_range_subtrahend = -light_outer_range / _range_divisor; \
	var/_light_power = lighting_source.light_power; \
	var/_applied_lum_r = lighting_source.applied_lum_r; \
	var/_applied_lum_g = lighting_source.applied_lum_g; \
	var/_applied_lum_b = lighting_source.applied_lum_b; \
	var/_lum_r = lighting_source.lum_r; \
	var/_lum_g = lighting_source.lum_g; \
	var/_lum_b = lighting_source.lum_b; \

#define SETUP_CORNERS_UPDATE_CACHE(lighting_source, range_divisor_old, light_power_old) \
	var/_light_update_shift = _light_power * (1 - range_divisor_old / _range_divisor); \
	var/_light_update_mult = _light_power * range_divisor_old / (_range_divisor * light_power_old);

#define SETUP_CORNERS_REMOVAL_CACHE(lighting_source) \
	var/_applied_lum_r = lighting_source.applied_lum_r; \
	var/_applied_lum_g = lighting_source.applied_lum_g; \
	var/_applied_lum_b = lighting_source.applied_lum_b;

// Macro that applies light to a new corner.
// It is a macro in the interest of speed, yet not having to copy paste it.
// If you're wondering what's with the backslashes, the backslashes cause BYOND to not automatically end the line.
// As such this all gets counted as a single line.
// The braces and semicolons are there to be able to do this on a single line.
// This is the define used to calculate falloff.
// Assuming a brightness of 1 at range 1, formula should be (brightness = 1 / distance^2)
// However, due to the weird range factor, brightness = (-(distance - full_dark_start) / (full_dark_start - full_light_end)) ^ light_max_bright
#define LUM_FALLOFF(C)(CLAMP01(-(sqrt((C.x - _turf_x) ** 2 +(C.y - _turf_y) ** 2 + LIGHTING_HEIGHT) / _range_divisor + _range_subtrahend)) ** light_falloff_curve)
// This is the same as the above but it takes into account Z-distance.
#define LUM_FALLOFF_MULTIZ(C)(CLAMP01(-(sqrt((C.x - _turf_x) ** 2 +(C.y - _turf_y) ** 2 + (C.z - _turf_z) ** 2 + LIGHTING_HEIGHT) / _range_divisor + _range_subtrahend)) ** light_falloff_curve)

#define APPLY_CORNER(C)                          \
	if(C.z == _turf_z) {                         \
		. = LUM_FALLOFF(C);                      \
	}                                            \
	else {                                       \
		. = LUM_FALLOFF_MULTIZ(C)                \
	}                                            \
	. *= _light_power;                            \
	var/OLD = effect_str[C];                     \
	C.update_lumcount                            \
	(                                            \
		(. * _lum_r) - (OLD * _applied_lum_r),     \
		(. * _lum_g) - (OLD * _applied_lum_g),     \
		(. * _lum_b) - (OLD * _applied_lum_b)      \
	);

#define UPDATE_CORNER(C)                          \
	var/OLD = effect_str[C];                     \
	. = max(_light_update_mult * OLD + _light_update_shift, 0);\
	C.update_lumcount                            \
	(                                            \
		(. * _lum_r) - (OLD * _applied_lum_r),     \
		(. * _lum_g) - (OLD * _applied_lum_g),     \
		(. * _lum_b) - (OLD * _applied_lum_b)      \
	);

#define REMOVE_CORNER(C)                         \
	. = -effect_str[C];                          \
	C.update_lumcount                            \
	(                                            \
		. * _applied_lum_r,                       \
		. * _applied_lum_g,                       \
		. * _applied_lum_b                        \
	);

// This is the define used to calculate falloff.

/datum/light_source/proc/remove_lum()
	SETUP_CORNERS_REMOVAL_CACHE(src)
	applied = FALSE
	for (var/datum/lighting_corner/corner as anything in effect_str)
		REMOVE_CORNER(corner)
		LAZYREMOVE(corner.affecting, src)
	effect_str = null

/datum/light_source/proc/recalc_corner(datum/lighting_corner/C)
	SETUP_CORNERS_CACHE(src)
	LAZYINITLIST(effect_str)
	if (effect_str[C]) // Already have one.
		REMOVE_CORNER(C)
		effect_str[C] = 0

	APPLY_CORNER(C)
	effect_str[C] = .

/datum/light_source/proc/update_corners()
	var/update = FALSE
	var/atom/source_atom = src.source_atom

	if (QDELETED(source_atom))
		qdel(src)
		return

	if (source_atom.light_power != light_power)
		light_power = source_atom.light_power
		update = TRUE

	if (source_atom.light_inner_range != light_inner_range)
		light_inner_range = source_atom.light_inner_range
		update = TRUE

	if (source_atom.light_outer_range != light_outer_range)
		light_outer_range = source_atom.light_outer_range
		update = TRUE

	if (!top_atom)
		top_atom = source_atom
		update = TRUE

	if (!light_outer_range || !light_power)
		qdel(src)
		return

	if (isturf(top_atom))
		if (source_turf != top_atom)
			source_turf = top_atom
			pixel_turf = source_turf
			update = TRUE
	else if (top_atom.loc != source_turf)
		source_turf = top_atom.loc
		pixel_turf = get_turf_pixel(top_atom)
		update = TRUE
	else
		var/P = get_turf_pixel(top_atom)
		if (P != pixel_turf)
			pixel_turf = P
			update = TRUE

	if (!isturf(source_turf))
		if (applied)
			remove_lum()
		return

	if (source_atom.light_falloff_curve != light_falloff_curve)
		light_falloff_curve = source_atom.light_falloff_curve
		update = TRUE

	if (light_outer_range && light_power && !applied)
		update = TRUE

	if (source_atom.light_color != light_color)
		light_color = source_atom.light_color
		parse_light_color()
		update = TRUE

	else if (applied_lum_r != lum_r || applied_lum_g != lum_g || applied_lum_b != lum_b)
		update = TRUE

	if (update)
		needs_update = LIGHTING_CHECK_UPDATE
		applied = TRUE
	else if (needs_update == LIGHTING_CHECK_UPDATE)
		return //nothing's changed

	var/list/datum/lighting_corner/corners
	var/datum/lighting_corner/C
	if (source_turf)
		corners = list()
		/// turfs we need to generate corners for
		var/list/turf/impacted_turfs = list()
		var/list/turf/check_below_turfs = list()
		var/turf_light_range = max(CEILING(light_outer_range, 1), 0)
		var/oldlum = source_turf.luminosity
		source_turf.luminosity = turf_light_range
		for(var/turf/candidate_turf in view(CEILING(light_outer_range, 1), source_turf))
			if(!candidate_turf.opacity)
				impacted_turfs += candidate_turf
			if(istransparentturf(candidate_turf))
				check_below_turfs += candidate_turf
		var/list/turf/check_above_turfs = impacted_turfs
		while(TRUE) // don't freak out, this is just because we know the first termination check will always pass
			var/list/turf/above_turfs = SSmapping.get_same_z_turfs_above(check_above_turfs)
			if(!length(above_turfs))
				break
			// we start off with impacted_turfs in check_above_turfs so don't add it until we recalculate it
			check_above_turfs = list()
			for(var/turf/candidate_turf as anything in above_turfs)
				if(istransparentturf(candidate_turf))
					check_above_turfs += candidate_turf // turf from which we can see light below
			if(!length(check_above_turfs))
				break
			impacted_turfs += check_above_turfs // add them to the impacted
		
		while(length(check_below_turfs))
			var/list/turf/below_turfs = SSmapping.get_same_z_turfs_below(check_below_turfs)
			if(!length(below_turfs))
				break
			impacted_turfs += below_turfs // turfs we found below a transparent turf
			check_below_turfs = list()
			for(var/turf/candidate_turf as anything in below_turfs)
				if(istransparentturf(candidate_turf))
					check_below_turfs += candidate_turf // new transparent turfs to check below

		var/list/cached_corners
		for(var/turf/impacted_turf as anything in impacted_turfs)		
			if (!impacted_turf.lighting_corners_initialised)
				impacted_turf.generate_missing_corners()
			cached_corners = impacted_turf.corners
			corners[cached_corners[1]] = 0
			corners[cached_corners[2]] = 0
			corners[cached_corners[3]] = 0
			corners[cached_corners[4]] = 0
		source_turf.luminosity = oldlum

	LAZYINITLIST(src.effect_str)
	var/list/effect_str = src.effect_str // local vars are faster to access than member vars
	SETUP_CORNERS_CACHE(src)
	var/list/L
	if (needs_update == LIGHTING_VIS_UPDATE)
		for (C as anything in corners - effect_str) // New corners
			APPLY_CORNER(C)
			if(. != 0)
				LAZYADD(C.affecting, src)
				effect_str[C] = .
	else
		L = corners - effect_str
		for (C as anything in L) // New corners
			APPLY_CORNER(C)
			if(. != 0)
				LAZYADD(C.affecting, src)
				effect_str[C] = .

		for (C as anything in corners - L) // Existing corners
			APPLY_CORNER(C)
			if (. != 0)
				effect_str[C] = .
			else
				LAZYREMOVE(C.affecting, src)
				effect_str -= C

	L = effect_str - corners
	for (C as anything in L) // Old, now gone, corners.
		REMOVE_CORNER(C)
		LAZYREMOVE(C.affecting, src)
	effect_str -= L

	applied_lum_r = lum_r
	applied_lum_g = lum_g
	applied_lum_b = lum_b

	UNSETEMPTY(src.effect_str)

#undef EFFECT_UPDATE
#undef LUM_FALLOFF
#undef LUM_FALLOFF_MULTIZ
#undef REMOVE_CORNER
#undef APPLY_CORNER
#undef UPDATE_CORNER
#undef SETUP_CORNERS_CACHE
#undef SETUP_CORNERS_UPDATE_CACHE
#undef SETUP_CORNERS_REMOVAL_CACHE
