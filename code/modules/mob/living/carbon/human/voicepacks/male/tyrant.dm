/datum/voicepack/male/tyrant/get_sound(soundin, modifiers)
	var/used
	switch(soundin)
		if("laugh")
			used = 'sound/vo/male/tyrant/laugh.ogg'
	if(!used)
		used = ..(soundin, modifiers)
	return used
