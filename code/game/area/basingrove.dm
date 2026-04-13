/area/rogue/outdoors/rtfield
	name = "Azure Basin"
	icon_state = "rtfield"
	soundenv = 19
	ambush_times = list("night")
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/bobcat = 20,
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
	detail_text = DETAIL_TEXT_AZURE_BASIN

/area/rogue/druidsgrove
	name = "Druid's Grove"
	icon_state = "rtfield"
	first_time_text = "DRUID'S GROVE"
	droning_sound = list('sound/ambience/riverday (1).ogg','sound/ambience/riverday (2).ogg','sound/ambience/riverday (3).ogg')
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = list ('sound/ambience/rivernight (1).ogg','sound/ambience/rivernight (2).ogg','sound/ambience/rivernight (3).ogg' )
	detail_text = DETAIL_TEXT_DRUIDS_GROVE
