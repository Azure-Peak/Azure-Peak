/datum/looping_sound/reverse_bear_trap
	mid_sounds = list('sound/blank.ogg')
	mid_length = 3.5
	volume = 25


/datum/looping_sound/reverse_bear_trap_beep
	mid_sounds = list('sound/blank.ogg')
	mid_length = 60
	volume = 10

/datum/looping_sound/torchloop
	mid_sounds = list('sound/items/torchloop.ogg')
	mid_length = 75
	volume = 30
	extra_range = -1
	vary = TRUE
	//sound_group = /datum/sound_group/torches

/datum/looping_sound/boneloop
	mid_sounds = list('sound/vo/mobs/ghost/skullpile_loop.ogg')
	mid_length = 65
	volume = 100
	extra_range = -1

/datum/looping_sound/fireloop
	mid_sounds = list('sound/misc/fire_place.ogg')
	mid_length = 35
	volume = 100
	extra_range = -2
	vary = TRUE
	sound_group = /datum/sound_group/fire_loop

/datum/looping_sound/boilloop
	mid_sounds = list('sound/misc/boiling.ogg')
	mid_length = 98
	volume = 70
	extra_range = 0
	vary = TRUE

/datum/looping_sound/streetlamp1
	mid_sounds = list('sound/misc/loops/StLight1.ogg')
	mid_length = 60
	volume = 40
	extra_range = 0
	vary = TRUE
	ignore_walls = FALSE

/datum/looping_sound/streetlamp2
	mid_sounds = list('sound/misc/loops/StLight2.ogg')
	mid_length = 40
	volume = 40
	extra_range = 0
	vary = TRUE
	ignore_walls = FALSE

/datum/looping_sound/streetlamp3
	mid_sounds = list('sound/misc/loops/StLight3.ogg')
	mid_length = 50
	volume = 40
	extra_range = 0
	vary = TRUE
	ignore_walls = FALSE

/datum/looping_sound/clockloop
	mid_sounds = list('sound/misc/clockloop.ogg')
	mid_length = 20
	volume = 10
	extra_range = -3
	ignore_walls = FALSE

/datum/looping_sound/boatloop
	mid_sounds = list('sound/ambience/boat (1).ogg','sound/ambience/boat (2).ogg')
	mid_length = 60
	volume = 25
	extra_range = -1
	ignore_walls = FALSE
	filter_pref = SOUND_MIDI

/datum/looping_sound/psydonmusicboxsound
	mid_sounds = list('sound/magic/psydonmusicbox.ogg')
	mid_length = 320
	volume = 50
	extra_range = 10


/datum/looping_sound/blackmirror
	mid_sounds = list('sound/items/blackmirror_amb.ogg')
	mid_length = 30
	volume = 100
	extra_range = -3

/datum/looping_sound/blank // datum call for a blank soundloop. Useful for avoiding qdel runtimes on machines and potentially structures
	mid_sounds = list('sound/blank.ogg')
	mid_length = 0
	volume = 0
	extra_range = 0
