

/atom/proc/temperature_expose(exposed_temperature, exposed_volume)
	return null



/turf/proc/hotspot_expose(added, maxstacks, soh = 0)
	return


/turf/open/hotspot_expose(added, maxstacks, soh)
	return

///spreading and turf ignitions stop while this many hotspots exist
#define MAX_FIRES 400
///scales every spread roll, lower makes fire creep slower and reach less far
#define SPREAD_RATE 0.75
///mob_timers key for the cooldown between scorch stacks from standing in fire
#define FIRE_SCORCH_KEY "fire_scorch"
///half-second steps each SShotspots tick covers; fuel, life and spread odds are tuned per half-second
#define FIRE_STEP 2
///colour multiplied onto turfs a fire burnt out on or uncovered
#define CHAR_TINT "#a09488"

/turf/fire_act(added, maxstacks, maxlevel = 3)
	. = ..()
	if(!burn_power || active_hotspot || length(SShotspots.hotspots) >= MAX_FIRES)
		return
	for(var/dir in GLOB.alldirs)
		if(istype(get_step(src, dir), /turf/open/water))
			burn_power = 0
			return
	new /obj/effect/hotspot(src, null, maxlevel)

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
	light_outer_range = 2
	light_color = LIGHT_COLOR_FIRE
	blend_mode = BLEND_ADD

	var/just_spawned = TRUE
	var/life = 20
	var/firelevel = 1 //RTD new firehotspot mechanics
	///fuel taken from the turf and its flammable contents, burnt by firelevel each tick; life is used instead at 0
	var/fuel = 0
	///highest firelevel this fire and the fires it spreads can reach; spell fire lights at 1
	var/maxlevel = 3
	///smoke emitter shared by every fire at level 2 or higher
	var/static/particles/plume

//obj/effect/hotspot/extinguish() handled in other_reagents
//	if(isturf(loc))
//		new /obj/effect/temp_visual/small_smoke(src.loc)
//	qdel(src)

/obj/effect/hotspot/Initialize(mapload, life, maxlevel)
	for(var/dir in GLOB.alldirs)
		var/turf/T = get_step(src, dir)
		if(T?.active_hotspot?.light_outer_range)
			light_outer_range = 0
			break
	. = ..()
	SShotspots.hotspots += src

	if(!isnull(life))
		src.life = life

	if(maxlevel)
		src.maxlevel = maxlevel

	var/turf/T = loc
	if(isturf(T) && T.burn_power)
		fuel = T.burn_power
		T.burn_power = 0
		for(var/obj/O in T)
			if(O.resistance_flags & FLAMMABLE)
				fuel += istype(O, /obj/structure/flora) ? 2 : 5

	change_firelevel(firelevel)
	perform_exposure(TRUE)
	setDir(pick(GLOB.cardinals))

/obj/effect/hotspot/proc/try_fire_act(atom/target, added, maxstacks)
	SHOULD_CALL_PARENT(FALSE)
	if(!isliving(target))
		target.fire_act(added, maxstacks)
		return
	var/mob/living/L = target
	if(L.stat == DEAD || HAS_TRAIT(L, TRAIT_NOFIRE) || L.mob_timers[FIRE_SCORCH_KEY] > world.time)
		return
	L.mob_timers[FIRE_SCORCH_KEY] = world.time + 2 SECONDS
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(apply_scorch_stack), L)

/obj/effect/hotspot/proc/perform_exposure(fresh)

	var/turf/location = loc
	if(!isturf(location))
		return

	location.active_hotspot = src

	for(var/A in location)
		var/atom/AT = A
		if(QDELETED(AT) || AT == src) // It's possible that the item is deleted in temperature_expose
			continue
		if(isliving(AT))
			try_fire_act(AT, 1, 20)
			continue
		var/obj/O = AT
		if(isobj(O) && (O.resistance_flags & FLAMMABLE))
			try_fire_act(O, firelevel * 250 * FIRE_STEP, 20)
		else if(fresh)
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
		life -= FIRE_STEP
		if(life <= 0)
			qdel(src)
		return

	var/wet = SSParticleWeather.runningWeather?.running && SSParticleWeather.runningWeather.target_trait == PARTICLEWEATHER_RAIN && location.outdoor_effect && !location.outdoor_effect.weatherproof
	fuel -= (wet ? firelevel * 2 : firelevel) * FIRE_STEP
	if(fuel <= 0)
		qdel(src)
		if(iswallturf(location))
			location.ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
			return
		var/under = islist(location.baseturfs) ? location.baseturfs[length(location.baseturfs)] : location.baseturfs
		var/turf/below = GET_TURF_BELOW(location)
		var/area/rogue/belowarea = below?.loc
		var/sealed = !below || isclosedturf(below) || (istype(belowarea) && belowarea.ceiling_protected)
		if(!location.burnthrough || (sealed && ispath(under, /turf/open/transparent/openspace)))
			location.add_atom_colour(CHAR_TINT, FIXED_COLOUR_PRIORITY)
			return
		var/turf/hole = location.ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
		if(!istype(hole, /turf/open/transparent/openspace))
			hole.add_atom_colour(CHAR_TINT, FIXED_COLOUR_PRIORITY)
			return
		for(var/atom/movable/AM in hole)
			hole.zFall(AM)
		below.fire_act()
		return

	if(firelevel < maxlevel && prob(location.spread_chance * FIRE_STEP))
		change_firelevel(firelevel + 1)

	var/heat = (wet ? firelevel * 0.5 : firelevel) * SPREAD_RATE * FIRE_STEP
	for(var/dir in GLOB.cardinals)
		var/turf/T = get_step(location, dir)
		if(T?.burn_power && prob(T.spread_chance * heat))
			T.fire_act(maxlevel = maxlevel)

/obj/effect/hotspot/Destroy()
	if(light_outer_range)
		for(var/dir in GLOB.alldirs)
			var/turf/N = get_step(src, dir)
			var/obj/effect/hotspot/H = N?.active_hotspot
			if(H && !H.light_outer_range && !QDELETED(H))
				H.set_light(initial(H.light_outer_range), 0)
				break
	set_light(0)
	particles = null
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
	if(!isprojectile(AM))
		try_fire_act(AM, 1, 20)

/obj/effect/dummy/lighting_obj/moblight/fire
	name = "fire"
	light_color = LIGHT_COLOR_FIRE
	light_outer_range =	LIGHT_RANGE_FIRE

/obj/effect/hotspot/proc/change_firelevel(level = 1)
	firelevel = level
	icon_state = "[firelevel]"
	if(firelevel >= 2)
		particles = plume ||= new /particles/smoke/burning/plume

#undef MAX_FIRES
#undef SPREAD_RATE
#undef FIRE_SCORCH_KEY
#undef FIRE_STEP
#undef CHAR_TINT

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
	. = ..(mapload)

/obj/effect/hotspot/vampiric/Destroy()
	owner_clan = null
	return ..()

/obj/effect/hotspot/vampiric/try_fire_act(mob/living/carbon/human/target, added, maxstacks)
	if(istype(target) && target.clan == owner_clan)
		return

	return ..()
