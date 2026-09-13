/*
	Helper(s) for getting cooking speed.
	Eventually a universal recipe system should be implemented instead of calling this proc everywhere
	But for now this will do
	+50% Cooking Speed (except -25% for lowest level) is super
*/

#define SKILL_LEVEL_NONE_DIVISOR 0.75
#define SKILL_LEVEL_NOVICE_DIVISOR 1
#define SKILL_LEVEL_APPRENTICE_DIVISOR 1.5
#define SKILL_LEVEL_JOURNEYMAN_DIVISOR 2
#define SKILL_LEVEL_EXPERT_DIVISOR 2.5
#define SKILL_LEVEL_MASTER_DIVISOR 3
#define SKILL_LEVEL_LEGENDARY_DIVISOR 3.5

// Technically this is also a multiplier depending on what proc you're calling it on lmao
/proc/get_cooktime_divisor(skill_level = SKILL_LEVEL_NONE)
	var/divisor = SKILL_LEVEL_NONE_DIVISOR
	switch(skill_level)
		if(SKILL_LEVEL_NONE)
			divisor = SKILL_LEVEL_NONE_DIVISOR
		if(SKILL_LEVEL_NOVICE)
			divisor = SKILL_LEVEL_NOVICE_DIVISOR
		if(SKILL_LEVEL_APPRENTICE)
			divisor = SKILL_LEVEL_APPRENTICE_DIVISOR
		if(SKILL_LEVEL_JOURNEYMAN)
			divisor = SKILL_LEVEL_JOURNEYMAN_DIVISOR
		if(SKILL_LEVEL_EXPERT)
			divisor = SKILL_LEVEL_EXPERT_DIVISOR
		if(SKILL_LEVEL_MASTER)
			divisor = SKILL_LEVEL_MASTER_DIVISOR
		if(SKILL_LEVEL_LEGENDARY)
			divisor = SKILL_LEVEL_LEGENDARY_DIVISOR

	return divisor

#undef SKILL_LEVEL_NONE_DIVISOR
#undef SKILL_LEVEL_NOVICE_DIVISOR
#undef SKILL_LEVEL_APPRENTICE_DIVISOR
#undef SKILL_LEVEL_JOURNEYMAN_DIVISOR
#undef SKILL_LEVEL_EXPERT_DIVISOR
#undef SKILL_LEVEL_MASTER_DIVISOR
#undef SKILL_LEVEL_LEGENDARY_DIVISOR
