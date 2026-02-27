/**
  * # area
  *
  * A grouping of tiles into a logical space, mostly used by map editors
  */
/area
	level = null
	name = "unknown"
	icon = 'icons/turf/areas.dmi'
	icon_state = "unknown"
	layer = AREA_LAYER
	//Keeping this on the default plane, GAME_PLANE, will make area overlays fail to render on FLOOR_PLANE.
	plane = BLACKNESS_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	invisibility = INVISIBILITY_LIGHTING

	var/map_name // Set in New(); preserves the name set by the map maker, even if renamed by the Blueprints.

	var/valid_territory = TRUE // If it's a valid territory for cult summoning or the CRAB-17 phone to spawn
	var/blob_allowed = TRUE // If blobs can spawn there and if it counts towards their score.

	var/fire = null
//	var/atmos = TRUE
	var/atmosalm = FALSE
	var/poweralm = TRUE
	var/lightswitch = TRUE

	var/totalbeauty = 0 //All beauty in this area combined, only includes indoor area.
	var/beauty = 0 // Beauty average per open turf in the area
	var/beauty_threshold = 150 //If a room is too big it doesn't have beauty.

	var/requires_power = TRUE
	var/always_unpowered = FALSE	// This gets overridden to 1 for space in area/Initialize().

	var/outdoors = FALSE //For space, the asteroid, lavaland, etc. Used with blueprints to determine if we are adding a new area (vs editing a station room)

	var/areasize = 0 //Size of the area in open turfs, only calculated for indoors areas.

	/// Bonus mood for being in this area
	var/mood_bonus = 0
	/// Mood message for being here, only shows up if mood_bonus != 0
	var/mood_message = span_nicegreen("This area is pretty nice!\n")

	var/power_equip = TRUE
	var/power_light = TRUE
	var/power_environ = TRUE
	var/used_equip = 0
	var/used_light = 0
	var/used_environ = 0
	var/static_equip
	var/static_light = 0
	var/static_environ

	///Are you forbidden from teleporting to the area? (centcom, mobs, wizard, hand teleporter)
	var/noteleport = FALSE
	///Hides area from player Teleport function.
	var/hidden = FALSE
	///Is the area teleport-safe: no space / radiation / aggresive mobs / other dangers
	var/safe = FALSE
	/// If false, loading multiple maps with this area type will create multiple instances.
	var/unique = TRUE

//	var/no_air = null

	var/parallax_movedir = 0

	var/list/ambientsounds = GENERIC
	var/list/ambientrain = null
	var/list/ambientnight = null

	var/min_ambience_cooldown = 70 SECONDS
	var/max_ambience_cooldown = 120 SECONDS

	var/we_droning_here = TRUE
	var/we_looping_here = TRUE

	var/droning_sound_current = null
	var/droning_sound_dawn = null
	var/droning_sound = null
	var/droning_sound_dusk = null
	var/droning_sound_night = null
	var/droning_vary = 0
	var/droning_repeat = TRUE
	var/droning_wait = 0
	var/droning_volume = 100
	var/droning_channel = CHANNEL_BUZZ
	var/droning_frequency = 0

	var/list/spookysounds = null
	var/list/spookynight = null

	flags_1 = CAN_BE_DIRTY_1 | CULT_PERMITTED_1
	var/soundenv = 0

	/// The text displayed on top of the screen the first time a player enter an area in a round
	var/first_time_text = null
	/// Detail text. When a player enter an area, a small message appears in chat with a href. see area_detail_txt.dm for style guidee
	var/detail_text = null

	var/list/firedoors
	var/list/cameras
	var/list/firealarms
	var/firedoors_last_closed_on = 0
	/// Can the Xenobio management console transverse this area by default?
	var/xenobiology_compatible = FALSE
	/// typecache to limit the areas that atoms in this area can smooth with, used for shuttles IIRC
	var/list/canSmoothWithAreas

	var/list/ambush_mobs
	var/list/ambush_times

	var/converted_type

	var/threat_region = "" // Key used to look up threat region this area belongs to
	/// Message used for deathsight. Try to be deliberately obtuse but not too obtuse.
	var/deathsight_message = "a locale wreathed in enigmatic fog"

	var/coven_protected = FALSE
	/// Whether or not an area protects against Necra's vengeful fog
	var/fog_protected = FALSE


/**
  * A list of teleport locations
  *
  * Adding a wizard area teleport list because motherfucking lag -- Urist
  * I am far too lazy to make it a proper list of areas so I'll just make it run the usual telepot routine at the start of the game
  */
GLOBAL_LIST_EMPTY(teleportlocs)

/**
  * Generate a list of turfs you can teleport to from the areas list
  *
  * Includes areas if they're not a shuttle or not not teleport or have no contents
  *
  * The chosen turf is the first item in the areas contents that is a station level
  *
  * The returned list of turfs is sorted by name
  */
/proc/process_teleport_locs()
	for(var/V in GLOB.sortedAreas)
		var/area/AR = V
		if(AR.noteleport)
			continue
		if(GLOB.teleportlocs[AR.name])
			continue
		if (!AR.contents.len)
			continue
		var/turf/picked = AR.contents[1]
		if (picked && is_station_level(picked.z))
			GLOB.teleportlocs[AR.name] = AR

	sortTim(GLOB.teleportlocs, GLOBAL_PROC_REF(cmp_text_asc))

/**
  * Called when an area loads
  *
  *  Adds the item to the GLOB.areas_by_type list based on area type
  */
/area/New()
	// This interacts with the map loader, so it needs to be set immediately
	// rather than waiting for atoms to initialize.
	if (unique)
		GLOB.areas_by_type[type] = src
	GLOB.areas += src
	return ..()

/area/proc/can_craft_here()
	return TRUE

/**
  * Initalize this area
  *
  * intializes the dynamic area lighting and also registers the area with the z level via
  * reg_in_areas_in_z
  *
  * returns INITIALIZE_HINT_LATELOAD
  */
/area/Initialize()
	if(!outdoors)
		plane = INDOOR_PLANE
		icon_state = "mask"
	else
		icon_state = ""
	layer = AREA_LAYER
	map_name = name // Save the initial (the name set in the map) name of the area.
	canSmoothWithAreas = typecacheof(canSmoothWithAreas)

	if(requires_power)
		luminosity = 0
	else
		power_light = TRUE
		power_equip = TRUE
		power_environ = TRUE

		if(dynamic_lighting == DYNAMIC_LIGHTING_FORCED)
			dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
			luminosity = 0
		else if(dynamic_lighting != DYNAMIC_LIGHTING_IFSTARLIGHT)
			dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	if(dynamic_lighting == DYNAMIC_LIGHTING_IFSTARLIGHT)
		dynamic_lighting = CONFIG_GET(flag/starlight) ? DYNAMIC_LIGHTING_ENABLED : DYNAMIC_LIGHTING_DISABLED

	. = ..()

//	blend_mode = BLEND_MULTIPLY // Putting this in the constructor so that it stops the icons being screwed up in the map editor.

	if(!IS_DYNAMIC_LIGHTING(src))
		add_overlay(/obj/effect/fullbright)

	reg_in_areas_in_z()

	return INITIALIZE_HINT_LATELOAD

/**
  * Sets machine power levels in the area
  */
/area/LateInitialize()
	update_beauty()

/**
  * Register this area as belonging to a z level
  *
  * Ensures the item is added to the SSmapping.areas_in_z list for this z
  *
  * It also goes through every item in this areas contents and sets the area level z to it
  * breaking the exat first time it does this, this seems crazy but what would I know, maybe
  * areas don't have a valid z themself or something
  */
/area/proc/reg_in_areas_in_z()
	if(contents.len)
		var/list/areas_in_z = SSmapping.areas_in_z
		var/z
		update_areasize()
		for(var/i in 1 to contents.len)
			var/atom/thing = contents[i]
			if(!thing)
				continue
			z = thing.z
			break
		if(!z)
			WARNING("No z found for [src]")
			return
		if(!areas_in_z["[z]"])
			areas_in_z["[z]"] = list()
		areas_in_z["[z]"] += src

/**
  * Destroy an area and clean it up
  *
  * Removes the area from GLOB.areas_by_type and also stops it processing on SSobj
  *
  * This is despite the fact that no code appears to put it on SSobj, but
  * who am I to argue with old coders
  */
/area/Destroy()
	if(GLOB.areas_by_type[type] == src)
		GLOB.areas_by_type[type] = null
	GLOB.areas -= src
	STOP_PROCESSING(SSobj, src)
	return ..()

/**
  * Update the icon state of the area
  *
  * Im not sure what the heck this does, somethign to do with weather being able to set icon
  * states on areas?? where the heck would that even display?
  */
/area/update_icon_state()
//	var/weather_icon
///	for(var/V in SSweather.curweathers)
//	/	var/datum/weather/W = V
//		if(W.stage != END_STAGE && (src in W.impacted_areas))
//			W.update_areas()
//			weather_icon = TRUE
//	if(!weather_icon)
//		icon_state = null
	return

/**
  * Update the icon of the area (overridden to always be null for space
  */
/area/space/update_icon_state()
	icon_state = null


/**
  * Returns int 1 or 0 if the area has power for the given channel
  *
  * evalutes a mixture of variables mappers can set, requires_power, always_unpowered and then
  * per channel power_equip, power_light, power_environ
  */
/area/proc/powered(chan)		// return true if the area has power to given channel

	if(!requires_power)
		return 1
	if(always_unpowered)
		return 0
	switch(chan)
		if(EQUIP)
			return power_equip
		if(LIGHT)
			return power_light
		if(ENVIRON)
			return power_environ

	return 0

/**
  * Space is not powered ever, so this returns 0
  */
/area/space/powered(chan) //Nope.avi
	return 0

/**
  * Return the usage of power per channel
  */
/area/proc/usage(chan)
	var/used = 0
	switch(chan)
		if(LIGHT)
			used += used_light
		if(EQUIP)
			used += used_equip
		if(ENVIRON)
			used += used_environ
		if(TOTAL)
			used += used_light + used_equip + used_environ
		if(STATIC_EQUIP)
			used += static_equip
		if(STATIC_LIGHT_A)
			used += static_light
		if(STATIC_ENVIRON)
			used += static_environ
	return used

/**
  * Add a static amount of power load to an area
  *
  * Possible channels
  * *STATIC_EQUIP
  * *STATIC_LIGHT
  * *STATIC_ENVIRON
  */
/area/proc/addStaticPower(value, powerchannel)
	switch(powerchannel)
		if(STATIC_EQUIP)
			static_equip += value
		if(STATIC_LIGHT_A)
			static_light += value
		if(STATIC_ENVIRON)
			static_environ += value

/**
  * Clear all power usage in area
  *
  * Clears all power used for equipment, light and environment channels
  */
/area/proc/clear_usage()
	used_equip = 0
	used_light = 0
	used_environ = 0

/**
  * Add a power value amount to the stored used_x variables
  */
/area/proc/use_power(amount, chan)

	switch(chan)
		if(EQUIP)
			used_equip += amount
		if(LIGHT)
			used_light += amount
		if(ENVIRON)
			used_environ += amount

/**
  * Call back when an atom enters an area
  *
  * Sends signals COMSIG_AREA_ENTERED and COMSIG_ENTER_AREA (to the atom)
  *
  * If the area has ambience, then it plays some ambience music to the ambience channel
  */
/area/Entered(atom/movable/M, atom/OldLoc)
	set waitfor = FALSE
	SEND_SIGNAL(src, COMSIG_AREA_ENTERED, M)
	SEND_SIGNAL(M, COMSIG_ENTER_AREA, src) //The atom that enters the area
	if(!isliving(M))
		return

	var/mob/living/L = M
	if(!L.ckey || L.stat == DEAD)
		return

	if(first_time_text)
		L.intro_area(src)
	if(SSevent_scheduler.fog_active)
		SSevent_scheduler.update_mob_fog_status(M, fog_protected)

/client
	var/musicfading = 0

/mob/living/proc/intro_area(area/A)
	if(!mind)
		return
	if(!client)
		return
	if(A.first_time_text && A.detail_text)
		to_chat(client, span_info("You enter <a href='?src=[REF(A)];getdescription=1'>[A.name]</a>."))
	else if (A.first_time_text) // Avoid trivial introduction
		to_chat(client, span_info("You enter [A.name]."))
	if(A.first_time_text in mind.areas_entered)
		return
	mind.areas_entered += A.first_time_text
	var/atom/movable/screen/area_text/T = new()
	client.screen += T
	T.maptext = {"<span style='vertical-align:top; text-align:center;
				color: #820000; font-size: 300%;
				text-shadow: 1px 1px 2px black, 0 0 1em black, 0 0 0.2em black;
				font-family: "Blackmoor LET", "Pterra";'>[A.first_time_text]</span>"}
	T.maptext_width = 205
	T.maptext_height = 209
	T.maptext_x = 12
	T.maptext_y = 64
	playsound_local(src, 'sound/misc/area.ogg', 100, FALSE)
	animate(T, alpha = 255, time = 10, easing = EASE_IN)
	addtimer(CALLBACK(src, PROC_REF(clear_area_text), T), 35)

/mob/living/proc/clear_area_text(atom/movable/screen/A)
	if(!A)
		return
	if(!client)
		return
	animate(A, alpha = 0, time = 10, easing = EASE_OUT)
	sleep(11)
	if(client)
		if(client.screen && A)
			client.screen -= A
			qdel(A)

/mob/living/proc/clear_time_icon(atom/movable/screen/A)
	if(!A)
		return
	if(!client)
		return
	animate(A, alpha = 0, time = 20, easing = EASE_OUT)
	sleep(21)
	if(client)
		if(client.screen && A)
			client.screen -= A
			qdel(A)

///Divides total beauty in the room by roomsize to allow us to get an average beauty per tile.
/area/proc/update_beauty()
	if(!areasize)
		beauty = 0
		return FALSE
	if(areasize >= beauty_threshold)
		beauty = 0
		return FALSE //Too big
	beauty = totalbeauty / areasize


/**
  * Called when an atom exits an area
  *
  * Sends signals COMSIG_AREA_EXITED and COMSIG_EXIT_AREA (to the atom)
  */
/area/Exited(atom/movable/M)
	SEND_SIGNAL(src, COMSIG_AREA_EXITED, M)
	SEND_SIGNAL(M, COMSIG_EXIT_AREA, src) //The atom that exits the area

/**
  * Reset the played var to false on the client
  */

/**
  * Setup an area (with the given name)
  *
  * Sets the area name, sets all status var's to false and adds the area to the sorted area list
  */
/area/proc/setup(a_name)
	name = a_name
	power_equip = FALSE
	power_light = FALSE
	power_environ = FALSE
	always_unpowered = FALSE
	valid_territory = FALSE
	blob_allowed = FALSE
	addSorted()
/**
  * Set the area size of the area
  *
  * This is the number of open turfs in the area contents, or FALSE if the outdoors var is set
  *
  */
/area/proc/update_areasize()
	if(outdoors)
		return FALSE
	areasize = 0
	for(var/turf/open/T in contents)
		areasize++

/**
  * Causes a runtime error
  */
/area/AllowDrop()
	CRASH("Bad op: area/AllowDrop() called")

/**
  * Causes a runtime error
  */
/area/drop_location()
	CRASH("Bad op: area/drop_location() called")

/// A hook so areas can modify the incoming args (of what??)
/area/proc/PlaceOnTopReact(list/new_baseturfs, turf/fake_turf_type, flags)
	return flags

/area/proc/on_joining_game(mob/living/boarder)
	return

/area/proc/reconnect_game(mob/living/boarder)
	return

/area/on_joining_game(mob/living/boarder)
	. = ..()
	if(istype(boarder) && boarder.client)
		SSdroning.area_entered(src, boarder.client)
		boarder.client.update_ambience_pref()
		SSdroning.play_loop(src, boarder.client)
		var/found = FALSE
		for(var/datum/weather/rain/R in SSweather.curweathers)
			found = TRUE
		if(found)
			SSdroning.play_rain(get_area(boarder.client), boarder.client)

/area/reconnect_game(mob/living/boarder)
	. = ..()
	if(istype(boarder) && boarder.client)
		SSdroning.area_entered(src, boarder.client)
		SSdroning.play_loop(src, boarder.client)
		var/found = FALSE
		for(var/datum/weather/rain/R in SSweather.curweathers)
			found = TRUE
		if(found)
			SSdroning.play_rain(get_area(boarder.client), boarder.client)

/area/Topic(href, href_list)
	..()
	if(href_list["getdescription"])
		if(detail_text)
			to_chat(usr, span_info("[detail_text]"))
