/datum/voicepack/hag/get_sound(soundin, modifiers)
	var/used
	switch(soundin)
		if("cackle")
			used = list('sound/hag/hag_cackles_short.ogg')
		if("chuckle")
			used = list('sound/hag/hag_cackles_short.ogg')
	return used
