/datum/voicepack/female/hag/get_sound(soundin, modifiers)
	var/used
	switch(soundin)
		if("cackle")
			used = list('sound/hag/hag_cackles_short.ogg')
		if("chuckle")
			used = list('sound/hag/hag_cackles_short.ogg')
	if(!used)
		used = ..(soundin, modifiers)
	return used

/datum/voicepack/male/hag/get_sound(soundin, modifiers)
	var/used
	switch(soundin)
		if("cackle")
			used = list('sound/hag/hag_cackles_short.ogg')
		if("chuckle")
			used = list('sound/hag/hag_cackles_short.ogg')
	if(!used)
		used = ..(soundin, modifiers)
	return used
