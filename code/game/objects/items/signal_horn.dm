#define WARDEN_AMBUSH_MIN 2
#define WARDEN_AMBUSH_MAX 9

/obj/item/signal_horn
	name = "signal horn"
	desc = "A horn carried by the wardens. Blowing it attracts the attention of various creechurs and rapscallions, enabling the wardens to clear them out."
	icon = 'icons/obj/items/signalhorn.dmi'
	icon_state = "signalhorn"
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_NECK
	w_class = WEIGHT_CLASS_NORMAL
	grid_height = 32
	grid_width = 64

/obj/item/signal_horn/examine()
	. = ..()
	. += span_notice("Using the horn will make you stand still and induce several ambushes to happen at once, enabling you to clear out an area. It cannot be used in rapid succession.")
	. += span_notice("Using it will leave you exhausted for a moment. Bring friends!")
	var/area/AR = get_area(src)
	var/datum/threat_region/TR = SSregionthreat.get_region(AR.threat_region)
	if(TR)
		. += span_notice("This area is a part of the " + TR.region_name + " threat region.")
	else
		. += span_notice("This area is not part of the warden's charge")

/obj/item/signal_horn/attack_self(mob/living/user)
	. = ..()
	var/area/AR = get_area(user)
	var/datum/threat_region/TR = SSregionthreat.get_region(AR.threat_region)
	if(!TR || !TR.latent_ambush || TR.fixed_ambush)
		to_chat(user, span_warning("There's no point in sounding the horn here."))
		return
	if(user.get_will_block_ambush())
		to_chat(user, span_warning("This place is too well-lit for enemies to come."))
		return
	if(!user.get_possible_ambush_spawn(min_dist = WARDEN_AMBUSH_MIN, max_dist = WARDEN_AMBUSH_MAX))
		to_chat(user, span_warning("This place is too lightly vegetated for enemies to hide."))
		return
	if(TR && TR.last_induced_ambush_time && (world.time < TR.last_induced_ambush_time + 5 MINUTES))
		to_chat(user, span_warning("Foes have been cleared out here recently, perhaps you should wait a moment before sounding the horn again."))
		return
	user.visible_message(span_userdanger("[user] is about to sound [src]!"))
	user.apply_status_effect(/datum/status_effect/debuff/clickcd, 5 SECONDS) // We don't want them to spam the message.
	if(do_after(user, 30 SECONDS)) // Enough time for any antag to kick or interrupt third party, me think
		user.Immobilize(30) // A very crude solution to kill any solo gamer
		if(sound_horn(user))
			TR.last_induced_ambush_time = world.time

/obj/item/signal_horn/proc/sound_horn(mob/living/user)
	user.visible_message(span_userdanger("[user] blows the horn!"))
	switch(user.job)
		if("Warden")
			playsound(src, 'sound/items/horn/bogguardhorn.ogg', 100, TRUE)
		if("Town Sheriff", "Watchman", "Sergeant", "Man at Arms")
			playsound(src, 'sound/items/horn/wardenhorn.ogg', 100, TRUE)
		if("Knight Captain", "Royal Guard")
			playsound(src, 'sound/items/horn/rghorn.ogg', 100, TRUE)
		else
			playsound(src, 'sound/items/horn/signalhorn.ogg', 100, TRUE)

	for(var/mob/living/player in GLOB.player_list)
		if(player.stat == DEAD)
			continue
		if(isbrain(player))
			continue

		var/turf/origin_turf = get_turf(src)

		var/distance = get_dist(player, origin_turf)
		if(distance <= 7 || distance > 21) // two screens away
			continue
		var/dirtext = " to the "
		var/direction = get_dir(player, origin_turf)
		switch(direction)
			if(NORTH)
				dirtext += "north"
			if(SOUTH)
				dirtext += "south"
			if(EAST)
				dirtext += "east"
			if(WEST)
				dirtext += "west"
			if(NORTHWEST)
				dirtext += "northwest"
			if(NORTHEAST)
				dirtext += "northeast"
			if(SOUTHWEST)
				dirtext += "southwest"
			if(SOUTHEAST)
				dirtext += "southeast"
			else //Where ARE you.
				dirtext = "although I cannot make out an exact direction"

		switch(user.job)
			if("Warden")
				player.playsound_local(get_turf(player), 'sound/items/horn/bogguardhorn.ogg', 35, FALSE, pressure_affected = FALSE)
			if("Marshall", "Watchman", "Sergeant", "Man at Arms")
				player.playsound_local(get_turf(player), 'sound/items/horn/wardenhorn.ogg', 35, FALSE, pressure_affected = FALSE)
			if("Knight Captain", "Knight")
				player.playsound_local(get_turf(player), 'sound/items/horn/rghorn.ogg', 35, FALSE, pressure_affected = FALSE)
			else
				player.playsound_local(get_turf(player), 'sound/items/horn/signalhorn.ogg', 35, FALSE, pressure_affected = FALSE)
		to_chat(player, span_warning("I hear the horn of the Wardens somewhere [dirtext]"))

	var/random_ambushes = 4 + rand(0,2) // 4 - 6 ambushes
	var/did_ambush = FALSE
	for(var/i = 0, i < random_ambushes, i++)
		var/silent = (i != 0)
		var/success = user.consider_ambush(TRUE, TRUE, min_dist = WARDEN_AMBUSH_MIN, max_dist = WARDEN_AMBUSH_MAX, silent = silent)
		if(success)
			did_ambush = TRUE
	return did_ambush

#undef WARDEN_AMBUSH_MIN
#undef WARDEN_AMBUSH_MAX
