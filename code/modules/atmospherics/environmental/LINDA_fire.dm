

/atom/proc/temperature_expose(exposed_temperature, exposed_volume)
	return null



/turf/proc/hotspot_expose(added, maxstacks, soh = 0)
	return


/turf/open/hotspot_expose(added, maxstacks, soh)
	return

///spreading and turf ignitions stop while this many hotspots exist
#define MAX_FIRES 400

/turf/fire_act(added, maxstacks)
	. = ..()
	if(burn_power && !active_hotspot && length(SShotspots.hotspots) < MAX_FIRES)
		new /obj/effect/hotspot(src)

/turf/proc/quench(hold)
	var/obj/effect/hotspot/H = locate() in src
	if(H)
		new /obj/effect/temp_visual/small_smoke(src)
		qdel(H)
	if(hold)
		. = burn_power
		burn_power = 0

//This is the icon for fire on turfs, also helps for nurturing small fires until they are full tile
/obj/effect/hotspot
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	icon = 'icons/effects/fire.dmi'
	icon_state = "1"
	layer = GASFIRE_LAYER
	light_outer_range =	LIGHT_RANGE_FIRE
	light_color = LIGHT_COLOR_FIRE
	blend_mode = BLEND_ADD

	var/just_spawned = TRUE
	var/life = 20
	var/firelevel = 1 //RTD new firehotspot mechanics
	///fuel taken from the turf and its flammable contents, burnt by firelevel each tick; life is used instead at 0
	var/fuel = 0

//obj/effect/hotspot/extinguish() handled in other_reagents
//	if(isturf(loc))
//		new /obj/effect/temp_visual/small_smoke(src.loc)
//	qdel(src)

/obj/effect/hotspot/Initialize(mapload, life)
	for(var/dir in GLOB.alldirs)
		var/turf/T = get_step(src, dir)
		if(T?.active_hotspot?.light_outer_range)
			light_outer_range = 0
			break
	. = ..()
	SShotspots.hotspots += src

	if(!isnull(life))
		src.life = life

	var/turf/T = loc
	if(isturf(T) && T.burn_power)
		fuel = T.burn_power
		T.burn_power = 0
		for(var/obj/O in T)
			if(O.resistance_flags & FLAMMABLE)
				fuel += istype(O, /obj/structure/flora) ? 2 : 5

	icon_state = "[firelevel]"
	perform_exposure()
	setDir(pick(GLOB.cardinals))

/obj/effect/hotspot/proc/try_fire_act(atom/target, added, maxstacks)
	SHOULD_CALL_PARENT(FALSE)
	target.fire_act(added, maxstacks)

/obj/effect/hotspot/proc/perform_exposure()

	var/turf/location = loc
	if(!isturf(location))
		return

	location.active_hotspot = src

	for(var/A in location)
		var/atom/AT = A
		if(QDELETED(AT) || AT == src) // It's possible that the item is deleted in temperature_expose
			continue
		var/obj/O = AT
		if(isobj(O) && (O.resistance_flags & FLAMMABLE))
			try_fire_act(O, firelevel * 250, 20)
		else
			try_fire_act(AT, 1, 20)

/obj/effect/hotspot/process()
	if(just_spawned)
		just_spawned = FALSE
		return

	var/turf/location = loc
	if(!isturf(location))
		qdel(src)
		return

	perform_exposure()

	if(fuel <= 0)
		if(--life <= 0)
			qdel(src)
		return

	var/wet = SSParticleWeather.runningWeather?.running && SSParticleWeather.runningWeather.target_trait == PARTICLEWEATHER_RAIN && location.outdoor_effect && !location.outdoor_effect.weatherproof
	fuel -= wet ? firelevel * 2 : firelevel
	if(fuel <= 0)
		qdel(src)
		var/turf/below = GET_TURF_BELOW(location)
		if(iswallturf(location))
			location.ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
		else if(location.burnthrough && below && !isclosedturf(below))
			var/turf/hole = location.ChangeTurf(/turf/open/transparent/openspace, flags = CHANGETURF_INHERIT_AIR)
			for(var/atom/movable/AM in hole)
				hole.zFall(AM)
			below.fire_act()
		else
			location.add_atom_colour("#5c534c", FIXED_COLOUR_PRIORITY)
		return

	if(firelevel < 3 && prob(location.spread_chance))
		change_firelevel(firelevel + 1)

	var/heat = wet ? firelevel * 0.5 : firelevel
	for(var/dir in GLOB.cardinals)
		var/turf/T = get_step(location, dir)
		if(T?.burn_power && prob(T.spread_chance * heat))
			T.fire_act()

/obj/effect/hotspot/Destroy()
	if(light_outer_range)
		for(var/dir in GLOB.alldirs)
			var/turf/N = get_step(src, dir)
			var/obj/effect/hotspot/H = N?.active_hotspot
			if(H && !H.light_outer_range && !QDELETED(H))
				H.set_light(LIGHT_RANGE_FIRE, 0)
				break
	set_light(0)
	SShotspots.hotspots -= src
	var/turf/T = loc
	if(isturf(T))
		if(fuel > 0)
			T.burn_power += fuel
		if(T.active_hotspot == src)
			T.active_hotspot = null
	return ..()

/obj/effect/hotspot/Crossed(atom/movable/AM, oldLoc)
	..()
	if(isliving(AM))
		var/mob/living/L = AM
		try_fire_act(L, 1, 20)

/obj/effect/dummy/lighting_obj/moblight/fire
	name = "fire"
	light_color = LIGHT_COLOR_FIRE
	light_outer_range =	LIGHT_RANGE_FIRE

/obj/effect/hotspot/proc/change_firelevel(level = 1)
	firelevel = level
	icon_state = "[firelevel]"

#undef MAX_FIRES

/// For use with demonic T5 ability
/obj/effect/hotspot/vampiric
	life = 6
	firelevel = 3
	color = COLOR_LIME
	light_color = COLOR_LIME
	var/datum/clan/owner_clan

/obj/effect/hotspot/vampiric/Initialize(mapload, datum/clan/owner_clan)
	if(!istype(owner_clan))
		return INITIALIZE_HINT_QDEL
	src.owner_clan = owner_clan
	. = ..()

/obj/effect/hotspot/vampiric/Destroy()
	owner_clan = null
	return ..()

/obj/effect/hotspot/vampiric/try_fire_act(mob/living/carbon/human/target, added, maxstacks)
	if(istype(target) && target.clan == owner_clan)
		return

	return ..()
