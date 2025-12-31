GLOBAL_LIST_EMPTY(chosen_music)

GLOBAL_LIST_INIT(roguetown_areas_typecache, typecacheof(/area/rogue/indoors/town,/area/rogue/outdoors/town,/area/rogue/under/town)) //hey

/area/rogue
	name = "roguetown"
	icon_state = "rogue"
	ambientsounds = null
	always_unpowered = TRUE
	poweralm = FALSE
	power_environ = TRUE
	power_equip = TRUE
	power_light = TRUE
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	requires_power = FALSE
//	var/previous_ambient = ""
	var/town_area = FALSE
	var/keep_area = FALSE
	var/tavern_area = FALSE
	var/warden_area = FALSE
	var/holy_area = FALSE
	var/cell_area = FALSE
	var/ceiling_protected = FALSE //Prevents tunneling into these from above

/area/rogue/Entered(mob/living/carbon/human/guy)
	. = ..()
	if((src.town_area == TRUE) && HAS_TRAIT(guy, TRAIT_GUARDSMAN) && !guy.has_status_effect(/datum/status_effect/buff/guardbuffone)) //man at arms
		guy.apply_status_effect(/datum/status_effect/buff/guardbuffone)
	if((src.tavern_area == TRUE) && HAS_TRAIT(guy, TRAIT_TAVERN_FIGHTER) && !guy.has_status_effect(/datum/status_effect/buff/barkeepbuff)) // THE FIGHTER
		guy.apply_status_effect(/datum/status_effect/buff/barkeepbuff)
	if((src.warden_area == TRUE) && HAS_TRAIT(guy, TRAIT_WOODSMAN) && !guy.has_status_effect(/datum/status_effect/buff/wardenbuff)) // Warden
		guy.apply_status_effect(/datum/status_effect/buff/wardenbuff)
	if((src.holy_area == TRUE) && HAS_TRAIT(guy, TRAIT_UNDIVIDED)) // get a long-lingering mood buff so long as we visit the church daily as Undivided.
		guy.add_stress(/datum/stressevent/seeblessed)

/area/rogue/indoors
	name = "indoors rt"
	icon_state = "indoors"
	ambientrain = RAIN_IN
	ambientsounds = AMB_INGEN
	ambientnight = AMB_INGEN
	spookysounds = SPOOKY_GEN
	spookynight = SPOOKY_GEN
	droning_sound = 'sound/music/area/towngen.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	soundenv = 2
	plane = INDOOR_PLANE
	converted_type = /area/rogue/outdoors

/area/rogue/indoors/banditcamp
	name = "Bandit Camp"
	droning_sound = 'sound/music/area/banditcamp.ogg'
	droning_sound_dusk = 'sound/music/area/banditcamp.ogg'
	droning_sound_night = 'sound/music/area/banditcamp.ogg'

/area/rogue/indoors/vampire_manor
	name = "Vampire Manor"
	droning_sound = 'sound/music/area/manor2.ogg'

/area/rogue/indoors/ravoxarena
	name = "Ravox's Arena"
	deathsight_message = "an arena of justice"

/area/rogue/indoors/ravoxarena/can_craft_here()
	return FALSE

/area/rogue/indoors/ravoxarena/proc/cleanthearena(var/turf/returnzone)
	for(var/obj/item/trash in src)
		do_teleport(trash, returnzone)
	GLOB.arenafolks.len = list()

/area/rogue/indoors/eventarea
	name = "Event Area"
	deathsight_message = "a place shielded from mortal eyes"

///// OUTDOORS AREAS //////

/area/rogue/outdoors
	name = "Outdoors Roguetown"
	icon_state = "outdoors"
	outdoors = TRUE
	ambientrain = RAIN_OUT
//	ambientsounds = list('sound/ambience/wamb.ogg')
	ambientsounds = AMB_TOWNDAY
	ambientnight = AMB_TOWNNIGHT
	spookysounds = SPOOKY_CROWS
	spookynight = SPOOKY_GEN
	droning_sound = 'sound/music/area/townstreets.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	converted_type = /area/rogue/indoors/shelter
	soundenv = 16
	deathsight_message = "somewhere in the wilds"

/area/rogue/outdoors/banditcamp
	name = "Bandit Camp"
	droning_sound = 'sound/music/area/banditcamp.ogg'
	droning_sound_dusk = 'sound/music/area/banditcamp.ogg'
	droning_sound_night = 'sound/music/area/banditcamp.ogg'
	deathsight_message = "somewhere in the wilds"

/area/rogue/indoors/shelter
	icon_state = "shelter"
	droning_sound = 'sound/music/area/townstreets.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	deathsight_message = "somewhere in the wilds, under a roof"

/area/rogue/outdoors/mountains
	name = "Mountains"
	icon_state = "mountains"
	ambientsounds = AMB_MOUNTAIN
	ambientnight = AMB_MOUNTAIN
	spookysounds = SPOOKY_GEN
	spookynight = SPOOKY_GEN
	droning_sound = 'sound/music/area/townstreets.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	warden_area = TRUE
	soundenv = 17
	converted_type = /area/rogue/indoors/shelter/mountains
	deathsight_message = "a twisted tangle of soaring peaks"
	// I SURE HOPE NO ONE USE THIS HUH


/area/rogue/indoors/shelter/mountains
	icon_state = "mountains"
	droning_sound = 'sound/music/area/townstreets.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	deathsight_message = "a twisted tangle of soaring peaks"

/area/rogue/outdoors/rtfield
	name = "Azure Basin"
	icon_state = "rtfield"
	soundenv = 19
	ambush_times = list("night")
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf/badger = 10,
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf/raccoon = 25,
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf/bobcat = 20,
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 30,
				/mob/living/simple_animal/hostile/retaliate/rogue/fox = 30,
				/mob/living/carbon/human/species/skeleton/npc/supereasy = 30)
	first_time_text = "AZURE BASIN"
	droning_sound = 'sound/music/area/field.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	converted_type = /area/rogue/indoors/shelter/rtfield
	deathsight_message = "somewhere in the wilds, next to towering walls"
	warden_area = TRUE
	threat_region = THREAT_REGION_AZURE_BASIN

/area/rogue/druidsgrove
	name = "Druids grove"
	icon_state = "rtfield"
	first_time_text = "Druids grove"
	droning_sound = list('sound/ambience/riverday (1).ogg','sound/ambience/riverday (2).ogg','sound/ambience/riverday (3).ogg')
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = list ('sound/ambience/rivernight (1).ogg','sound/ambience/rivernight (2).ogg','sound/ambience/rivernight (3).ogg' )

/area/rogue/indoors/shelter/rtfield
	icon_state = "rtfield"
	droning_sound = 'sound/music/area/field.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'

//// UNDER AREAS (no indoor rain sound usually)

// these don't get a rain sound because they're underground
/area/rogue/under
	name = "basement"
	icon_state = "under"
	droning_sound = 'sound/music/area/towngen.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	soundenv = 8
	plane = INDOOR_PLANE
	converted_type = /area/rogue/outdoors/exposed

/area/rogue/outdoors/exposed
	icon_state = "exposed"
	droning_sound = 'sound/music/area/towngen.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'

/area/rogue/under/cavelava
	name = "cavelava"
	icon_state = "cavelava"
	first_time_text = "MOUNT DECAPITATION"
	ambientsounds = AMB_CAVELAVA
	ambientnight = AMB_CAVELAVA
	spookysounds = SPOOKY_CAVE
	spookynight = SPOOKY_CAVE
	ambush_times = list("night","dawn","dusk","day")
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 10,
				/mob/living/carbon/human/species/skeleton/npc/ambush = 20,
				/mob/living/carbon/human/species/goblin/npc/hell = 25,
				/mob/living/simple_animal/hostile/retaliate/rogue/minotaur = 15)
	droning_sound = 'sound/music/area/decap.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/exposed/decap

/area/rogue/outdoors/exposed/decap
	icon_state = "decap"
	droning_sound = 'sound/music/area/decap.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/under/lake
	name = "underground lake"
	icon_state = "lake"
	ambientsounds = AMB_BEACH
	ambientnight = AMB_BEACH
	spookysounds = SPOOKY_CAVE
	spookynight = SPOOKY_GEN

/area/rogue/under/cave/licharena
	name = "lich's domain"
	icon_state = "under"
	first_time_text = "LICH'S DOMAIN"
	droning_sound = 'sound/music/area/dragonden.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ceiling_protected = TRUE
	detail_text = DETAIL_TEXT_LICH_DOMAIN

/area/rogue/under/cave/licharena/bossroom
	name = "the lich's lair"
	first_time_text = "THE LICH"

/area/rogue/under/cave/licharena/bossroom/can_craft_here()
	return FALSE

/area/rogue/under/cave/undeadmanor
	name = "skelemansion"
	icon_state = "spidercave"
	first_time_text = "ABANDONED MANOR"
	droning_sound = 'sound/music/area/dungeon2.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ceiling_protected = TRUE

///// outside

/area/rogue/outdoors/town
	name = "outdoors"
	icon_state = "town"
	soundenv = 16
	droning_sound = 'sound/music/area/townstreets.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	converted_type = /area/rogue/indoors/shelter/town
	first_time_text = "THE CITY OF AZURE PEAK"
	town_area = TRUE

/area/rogue/indoors/shelter/town
	icon_state = "town"
	droning_sound = 'sound/music/area/townstreets.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'


/area/rogue/outdoors/town/sargoth
	name = "outdoors"
	icon_state = "sargoth"
	soundenv = 16
	droning_sound = 'sound/music/area/sargoth.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/indoors/shelter/town/sargoth
	first_time_text = "SARGOTH"
/area/rogue/indoors/shelter/town/sargoth
	icon_state = "sargoth"
	droning_sound = 'sound/music/area/sargoth.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "SARGOTH"

/area/rogue/outdoors/town/roofs
	name = "roofs"
	icon_state = "roofs"
	ambientsounds = AMB_MOUNTAIN
	ambientnight = AMB_MOUNTAIN
	spookysounds = SPOOKY_GEN
	spookynight = SPOOKY_GEN
	droning_sound = 'sound/music/area/field.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	soundenv = 17
	converted_type = /area/rogue/indoors/shelter/town/roofs

/area/rogue/outdoors/town/roofs/keep
	name = "Keep Rooftops"
	icon_state = "manor"
	keep_area = TRUE
	town_area = TRUE

/area/rogue/indoors/shelter/town/roofs
	icon_state = "roofs"
	droning_sound = 'sound/music/area/field.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'

/area/rogue/outdoors/town/dwarf
	name = "dwarven quarter"
	icon_state = "dwarf"
	droning_sound = 'sound/music/area/dwarf.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "The Dwarven Quarter"
	soundenv = 16
	converted_type = /area/rogue/indoors/shelter/town/dwarf
/area/rogue/indoors/shelter/town/dwarf
	icon_state = "dwarf"
	droning_sound = 'sound/music/area/dwarf.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

// underworld
/area/rogue/underworld
	name = "underworld"
	icon_state = "underworld"
	droning_sound = 'sound/music/area/underworlddrone.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "The Forest of Repentence"

/area/rogue/underworld/dream
	name = "dream realm"
	icon_state = "dream"
	first_time_text = "Abyssal Dream"
