// Misc Areas for things I cannot be bothered to categorize elsewhere
/area/rogue/outdoors/abisland
	name = "abyssors grasp"
	icon_state = "island"
	ambientsounds = AMB_ABISLAND
	ambientnight = AMB_ABISLAND
	droning_sound = 'sound/music/area/morosewaters.ogg'
	droning_sound_dusk = 'sound/music/area/morosewaters.ogg'
	droning_sound_night = 'sound/music/area/angrywaters.ogg'
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/rogue/deepone = 50,
		/mob/living/simple_animal/hostile/rogue/deepone/spit = 30
	)
	first_time_text = "ABYSSOR'S GRASP"
	deathsight_message = "amidst abyssor's grasp"
	detail_text = DETAIL_TEXT_ABYSSORS_GRASP
	area_sniff_message = "You smell the sea and wet stone."
