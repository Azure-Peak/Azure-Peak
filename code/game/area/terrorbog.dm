/area/rogue/outdoors/bog
	name = "The Terrorbog"
	icon_state = "bog"
	warden_area = TRUE
	ambientsounds = AMB_BOGDAY
	ambientnight = AMB_BOGNIGHT
	spookysounds = SPOOKY_FROG
	spookynight = SPOOKY_GEN
	droning_sound = 'sound/music/area/bog.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ambush_times = list("night","dawn","dusk","day")
	//Minotaurs too strong for the lazy amount of places this area covers
	ambush_mobs = list(
				// Singles — budget filler across all factions present in the bog
				/mob/living/simple_animal/hostile/retaliate/rogue/troll/bog = 20,
				/mob/living/simple_animal/hostile/retaliate/rogue/spider = 40,
				/mob/living/carbon/human/species/skeleton/npc/bogguard = 20,
				/mob/living/carbon/human/species/goblin/npc/ambush/cave = 30,
				/mob/living/carbon/human/species/human/northern/bog_deserters/ambush = 15,
				/mob/living/carbon/human/species/human/northern/bog_deserters/better_gear/ambush = 10,
				// Packs — big-ticket purchases for high budgets
				new /datum/ambush_config/bog_guard_deserters = 50,
				new /datum/ambush_config/bog_guard_deserters/hard = 25,
				new /datum/ambush_config/mirespiders_ambush = 110,
				new /datum/ambush_config/mirespiders_crawlers = 25,
				new /datum/ambush_config/mirespiders_aragn = 10,
				new /datum/ambush_config/mirespiders_unfair = 5)
	first_time_text = "THE TERRORBOG"
	converted_type = /area/rogue/indoors/shelter/bog
	threat_region = THREAT_REGION_TERRORBOG
	deathsight_message = "a wretched, fetid bog"
	detail_text = DETAIL_TEXT_TERRORBOG
	var/list/recent_intruders = list()

/area/rogue/outdoors/bog/Entered(atom/movable/AM)
	..()
	if(!GLOB.active_hags.len)
		return

	var/mob/living/L = AM
	if(!istype(L) || !L.client || L.stat == DEAD)
		return

	if(L in GLOB.active_hags)
		return

	if(recent_intruders[L] && recent_intruders[L] > world.time)
		return

	recent_intruders[L] = world.time + 1 MINUTES
	for(var/mob/living/H in GLOB.active_hags)
		to_chat(H, span_boldwarning("The roots of your sanctum shiver... a soul named [L.name] has stepped within [src.name]."))

/area/rogue/indoors/shelter/bog
	icon_state = "bog"
	droning_sound = 'sound/music/area/bog.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	deathsight_message = "a wretched, fetid bog"

/area/rogue/outdoors/bog/north
	name = "Northern Terrorbog"

/area/rogue/outdoors/bog/south
	name = "Southern Terrorbog"

/area/rogue/indoors/shelter/bog_hag
	name = "Hag hut"
	icon_state = "bog"
	first_time_text = "A HUT BETWIXT THE ROOTS"
	droning_sound = 'sound/music/area/bog.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	deathsight_message = "a nasty wicked place deep betwixt the roots of the bog"
	var/list/recent_intruders = list()

/area/rogue/indoors/shelter/bog_hag/Entered(atom/movable/AM)
	..()
	if(!GLOB.active_hags.len)
		return

	var/mob/living/L = AM
	if(!istype(L) || !L.client || L.stat == DEAD)
		return

	if(L in GLOB.active_hags)
		return

	if(recent_intruders[L] && recent_intruders[L] > world.time)
		return

	recent_intruders[L] = world.time + 1 MINUTES
	for(var/mob/living/H in GLOB.active_hags)
		to_chat(H, span_boldwarning("The roots of your sanctum shiver... a soul has stepped within [src.name]."))
