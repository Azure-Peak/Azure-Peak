/datum/voicepack/boar/get_sound(soundin, modifiers)
	var/used
	switch(soundin)
		if("aggro")
			used = pick('modular/Creechers/sound/pighangry.ogg', 'sound/vo/mobs/boar/boar_charge.ogg')
		if("rage")
			used = pick('sound/vo/mobs/boar/boar_attack.ogg', 'modular/Creechers/sound/pighangry.ogg')
		if("deathgurgle", "death")
			used = pick('modular/Creechers/sound/piglin.ogg')
		if("firescream", "painscream", "agony", "pain", "paincrit", "scream")
			used = pick('modular/Creechers/sound/pighangry.ogg', 'sound/vo/mobs/vw/attack (1).ogg')
		if("jump", "leap")
			used = pick('sound/vo/mobs/boar/boar_attack.ogg')
		if("idle")
			used = pick('modular/Creechers/sound/pig1.ogg', 'modular/Creechers/sound/pig2.ogg')

	return used
