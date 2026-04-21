/datum/clan_leader/crimson_fang
	lord_verbs = list(
		/mob/living/carbon/human/proc/punish_spawn
	)
	lord_traits = list(TRAIT_HEAVYARMOR, TRAIT_INFINITE_ENERGY, TRAIT_STRENGTH_UNCAPPED, TRAIT_KEENEARS) //Lord gets a little treat to further them from other clans.

/// Banu Haqim from Temu, kinda.
/datum/clan/crimson_fang
	name = "Crimson Fang"
	desc = "Crimson Fangs, often seen by other kindred as dangerous assassins and diablerists, but in truth they are guardians, warriors, and scholars who seek to distance themselves from politics of both vampyre and mundane worlds."
	curse = "Addiction to blood of kindred and nobility."
	clanicon = "presence"
	blood_preference = BLOOD_PREFERENCE_FANCY | BLOOD_PREFERENCE_KIN //Diablerists and assassins, mingling and betraying nobility, clergy, inquisition and kindred alike.
	clane_covens = list(
		/datum/coven/celerity,
		/datum/coven/obfuscate,
		/datum/coven/quietus
	)
	clane_traits = list(
		TRAIT_STRONGBITE,
		TRAIT_VAMPBITE,
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
		TRAIT_DEATHLESS,
		TRAIT_NOPAIN,
		TRAIT_TOXIMMUNE,
		TRAIT_STEELHEARTED,
		TRAIT_LIGHT_STEP, //Assassins, you say?
		TRAIT_CICERONE,
		TRAIT_NOSLEEP,
		TRAIT_VAMPMANSION,
		TRAIT_VAMP_DREAMS,
		TRAIT_DARKVISION,
		TRAIT_LIMBATTACHMENT,
		TRAIT_SILVER_WEAK,
	)
	covens_to_select = 0

/datum/clan/crimson_fang/get_blood_preference_string()
	return "the blood of nobles, clergy, inquisition or kindred"
