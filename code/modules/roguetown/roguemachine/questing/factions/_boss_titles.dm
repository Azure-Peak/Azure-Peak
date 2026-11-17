GLOBAL_LIST_INIT(boss_class_titles, list(
	BOSS_CLASS_TANK = list("%N the Bulwark", "%N the Shield", "%N the Bastion", "%N the Wall"),
	BOSS_CLASS_DUELIST = list("%N the Fencer", "%N the Duelist", "%N the Champion", "%N the Warrior"),
	BOSS_CLASS_RANGER = list("%N the Bow", "%N the Hunter", "%N the Archer", "%N the Scout"),
	BOSS_CLASS_PYROMANCER = list("%N the Pyromancer", "%N the Firebrand", "%N the Inferno", "%N the Flame"),
	BOSS_CLASS_FULGURMANCER = list("%N the Fulgurmancer", "%N the Lightning", "%N the Storm", "%N the Thunder"),
	BOSS_CLASS_GEOMANCER = list("%N the Geomancer", "%N the Rock", "%N the Earthmover", "%N the Stone"),
	BOSS_CLASS_TELOMANCER = list("%N the Telomancer", "%N the Arcanist", "%N the Archwyzzard", "%N the Blaster"),
	BOSS_CLASS_CRYOMANCER = list("%N the Cryomancer", "%N the Frozen One", "%N the Chill", "%N the Ice"),
	BOSS_CLASS_SPELLBLADE = list("%N the Spellblade", "%N the Mageblade", "%N the Caedoist"),
	BOSS_CLASS_PHALANGITE = list("%N the Phalangite", "%N the Spellpike", "%N the Spellberdier"),
	BOSS_CLASS_MACEBEARER = list("%N the Macebearer", "%N the Magehammer", "%N the Spellhammer"),
	BOSS_CLASS_SPELLFIST = list("%N the Spellfist", "%N the Magefist", "%N the Disciple of Naledi", "%N, Master of Arcyne Fist"),
))

/proc/get_boss_class_titles(boss_type)
	if(!ispath(boss_type, /mob/living))
		return null
	var/mob/living/boss_path = boss_type
	var/boss_class = initial(boss_path.boss_class)
	if(!boss_class)
		return null
	. = list()
	for(var/title in GLOB.boss_class_titles[boss_class])
		if(title)
			. += title
