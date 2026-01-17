

/atom/proc/temperature_expose(exposed_temperature, exposed_volume)
	return null



/turf/proc/hotspot_expose(added, maxstacks, soh = 0)
	return


/turf/open/hotspot_expose(added, maxstacks, soh)
	return

//This is the icon for fire on turfs, also helps for nurturing small fires until they are full tile
/obj/effect/hotspot
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	icon = 'icons/effects/fire.dmi'
	icon_state = "1"
	layer = GASFIRE_LAYER
	light_outer_range =  LIGHT_RANGE_FIRE
	light_color = LIGHT_COLOR_FIRE
	blend_mode = BLEND_ADD

	var/volume = 125
	var/temperature = 100+T0C
	var/just_spawned = TRUE
	var/bypassing = FALSE
	var/visual_update_tick = 0
	var/life = 20
	var/firelevel = 1 //RTD new firehotspot mechanics

//obj/effect/hotspot/extinguish() handled in other_reagents
//	if(isturf(loc))
//		new /obj/effect/temp_visual/small_smoke(src.loc)
//	qdel(src)

/obj/effect/hotspot/Initialize(mapload, starting_volume, starting_temperature, life)
	. = ..()
	SShotspots.hotspots += src

	if(!isnull(starting_volume))
		volume = starting_volume

	if(!isnull(starting_temperature))
		temperature = starting_temperature

	if(!isnull(life))
		src.life = life
	
	perform_exposure()
	setDir(pick(GLOB.cardinals))
	air_update_turf()
	addtimer(CALLBACK(src, PROC_REF(trigger_weather)), rand(5,20))

/obj/effect/hotspot/proc/try_fire_act(atom/target, added, maxstacks)
	SHOULD_CALL_PARENT(FALSE)
	target.fire_act(added, maxstacks)

/obj/effect/hotspot/proc/perform_exposure()

	var/turf/open/location = loc
	if(!istype(location))
		return

	location.active_hotspot = src

	for(var/A in location)
		var/atom/AT = A
		if(!QDELETED(AT) && AT != src) // It's possible that the item is deleted in temperature_expose
			try_fire_act(AT, 1, 20)

/obj/effect/hotspot/proc/gauss_lerp(x, x1, x2)
	var/b = (x1 + x2) * 0.5
	var/c = (x2 - x1) / 6
	return NUM_E ** -((x - b) ** 2 / (2 * c) ** 2)

/obj/effect/hotspot/proc/update_color()
	cut_overlays()

	var/heat_r = heat2colour_r(temperature)
	var/heat_g = heat2colour_g(temperature)
	var/heat_b = heat2colour_b(temperature)
	var/heat_a = 255
	var/greyscale_fire = 1 //This determines how greyscaled the fire is.

	if(temperature < 5000) //This is where fire is very orange, we turn it into the normal fire texture here.
		var/normal_amt = gauss_lerp(temperature, 1000, 3000)
		heat_r = LERP(heat_r,255,normal_amt)
		heat_g = LERP(heat_g,255,normal_amt)
		heat_b = LERP(heat_b,255,normal_amt)
		heat_a -= gauss_lerp(temperature, -5000, 5000) * 128
		greyscale_fire -= normal_amt
	if(temperature > 40000) //Past this temperature the fire will gradually turn a bright purple
		var/purple_amt = temperature < LERP(40000,200000,0.5) ? gauss_lerp(temperature, 40000, 200000) : 1
		heat_r = LERP(heat_r,255,purple_amt)
	if(temperature > 200000 && temperature < 500000) //Somewhere at this temperature nitryl happens.
		var/sparkle_amt = gauss_lerp(temperature, 200000, 500000)
		var/mutable_appearance/sparkle_overlay = mutable_appearance('icons/effects/effects.dmi', "shieldsparkles")
		sparkle_overlay.blend_mode = BLEND_ADD
		sparkle_overlay.alpha = sparkle_amt * 255
		add_overlay(sparkle_overlay)
	if(temperature > 400000 && temperature < 1500000) //Lightning because very anime.
		var/mutable_appearance/lightning_overlay = mutable_appearance(icon, "overcharged")
		lightning_overlay.blend_mode = BLEND_ADD
		add_overlay(lightning_overlay)
	if(temperature > 4500000) //This is where noblium happens. Some fusion-y effects.
		var/fusion_amt = temperature < LERP(4500000,12000000,0.5) ? gauss_lerp(temperature, 4500000, 12000000) : 1
		var/mutable_appearance/fusion_overlay = mutable_appearance('icons/effects/atmospherics.dmi', "fusion_gas")
		fusion_overlay.blend_mode = BLEND_ADD
		fusion_overlay.alpha = fusion_amt * 255
		var/mutable_appearance/rainbow_overlay = mutable_appearance('icons/mob/screen_gen.dmi', "druggy")
		rainbow_overlay.blend_mode = BLEND_ADD
		rainbow_overlay.alpha = fusion_amt * 255
		rainbow_overlay.appearance_flags = RESET_COLOR
		heat_r = LERP(heat_r,150,fusion_amt)
		heat_g = LERP(heat_g,150,fusion_amt)
		heat_b = LERP(heat_b,150,fusion_amt)
		add_overlay(fusion_overlay)
		add_overlay(rainbow_overlay)

	set_light(l_color = rgb(LERP(250,heat_r,greyscale_fire),LERP(160,heat_g,greyscale_fire),LERP(25,heat_b,greyscale_fire)))

	heat_r /= 255
	heat_g /= 255
	heat_b /= 255

	color = list(LERP(0.3, 1, 1-greyscale_fire) * heat_r,0.3 * heat_g * greyscale_fire,0.3 * heat_b * greyscale_fire, 0.59 * heat_r * greyscale_fire,LERP(0.59, 1, 1-greyscale_fire) * heat_g,0.59 * heat_b * greyscale_fire, 0.11 * heat_r * greyscale_fire,0.11 * heat_g * greyscale_fire,LERP(0.11, 1, 1-greyscale_fire) * heat_b, 0,0,0)
	alpha = heat_a

#define INSUFFICIENT(path) (!location.air.gases[path] || location.air.gases[path][MOLES] < 0.5)
/obj/effect/hotspot/process()
	if(just_spawned)
		just_spawned = FALSE
		return

	var/turf/open/location = loc
	if(!istype(location))
		qdel(src)
		return

	icon_state = "[rand(1,3)]"

	life--

	if(life <= 0)
		qdel(src)
		return
		
	perform_exposure()
	return

/obj/effect/hotspot/Destroy()
	set_light(0)
	SShotspots.hotspots -= src
	var/turf/open/T = loc
	if(istype(T) && T.active_hotspot == src)
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
	light_outer_range =  LIGHT_RANGE_FIRE

/obj/effect/hotspot/proc/handle_automatic_spread()
	///maybe add sound probably not

	for(var/obj/object in loc)
		if(QDELETED(object) || isnull(object))
			continue
		var/can_break = TRUE
		if((object.resistance_flags & INDESTRUCTIBLE) || (object.resistance_flags & FIRE_PROOF))
			can_break = FALSE
		if(!can_break)
			continue
		object.fire_act(temperature * firelevel)

	var/burn_power = 0
	var/modifier = 1
	if(SSParticleWeather.runningWeather?.target_trait == PARTICLEWEATHER_RAIN) //this does apply to indoor turfs but w/e
		var/turf/floor= get_turf(src)
		if(!floor?.outdoor_effect?.weatherproof)
			modifier = 0.5
	if(isfloorturf(get_turf(src)))
		var/turf/floor= get_turf(src)
		floor.burn_power = max(0, floor.burn_power - (1 * firelevel))
		if(floor.burn_power == 0)
			extinguish()
		burn_power += floor.burn_power
		if(prob(floor.spread_chance * modifier))
			change_firelevel(min(3, firelevel+1))

		if(burn_power)
			for(var/turf/ranged_floor in range(1, src))
				if(ranged_floor == src || !ranged_floor.burn_power)
					continue
				var/obj/effect/hotspot/located_fire = locate() in ranged_floor
				if(prob(ranged_floor.spread_chance * modifier) && !located_fire)
					new /obj/effect/hotspot(ranged_floor, volume, temperature)

/obj/effect/hotspot/proc/change_firelevel(level = 1)
	firelevel = level
	icon_state = "[firelevel]"

#undef INSUFFICIENT

/// For use with demonic T5 ability
/obj/effect/hotspot/vampiric
	life = 6
	firelevel = 3
	color = COLOR_LIME
	light_color = COLOR_LIME
	var/datum/clan/owner_clan

/obj/effect/hotspot/vampiric/Initialize(mapload, starting_volume, starting_temperature, datum/clan/owner_clan)
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
