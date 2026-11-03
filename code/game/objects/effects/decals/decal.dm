/obj/effect/decal
	name = "decal"
	plane = FLOOR_PLANE
	anchored = TRUE
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/turf_loc_check = TRUE
	/// If set, SSseason swaps this decal's icon_state to this value in Winter and back the rest
	/// of the year. Decals are purely decorative with no per-instance state to lose, so - unlike
	/// dirt's ChangeTurf() subtypes - a direct icon_state swap is all that's needed here.
	var/winter_icon_state
	/// Cached the first time this decal registers: its actual pre-Winter icon_state.
	var/summer_icon_state

/obj/effect/decal/Initialize(mapload)
	. = ..()
	if(turf_loc_check && (!isturf(loc) || NeverShouldHaveComeHere(loc)))
		return INITIALIZE_HINT_QDEL
	if(winter_icon_state)
		summer_icon_state = icon_state
		GLOB.seasonal_decal_objs += src

/obj/effect/decal/Destroy()
	GLOB.seasonal_decal_objs -= src
	return ..()

/obj/effect/decal/proc/NeverShouldHaveComeHere(turf/T)
	return isclosedturf(T) || isgroundlessturf(T)

/obj/effect/decal/ex_act(severity, target)
	qdel(src)

/obj/effect/decal/fire_act(added, maxstacks)
	if(!(resistance_flags & FIRE_PROOF)) //non fire proof decal or being burned by lava
		qdel(src)

/obj/effect/decal/HandleTurfChange(turf/T)
	..()
	if(T == loc && NeverShouldHaveComeHere(T))
		qdel(src)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/effect/turf_decal
	icon = 'icons/turf/decals.dmi'
	icon_state = "warningline"
	layer = TURF_DECAL_LAYER

/obj/effect/turf_decal/Initialize(mapload)
	..()
	return INITIALIZE_HINT_QDEL

/obj/effect/turf_decal/ComponentInitialize()
	. = ..()
	var/turf/T = loc
	if(!istype(T)) //you know this will happen somehow
		CRASH("Turf decal initialized in an object/nullspace")
	T.AddComponent(/datum/component/decal, icon, icon_state, dir, CLEAN_GOD, color, null, null, alpha)
