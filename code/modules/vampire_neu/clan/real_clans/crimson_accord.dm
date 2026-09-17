/datum/clan_leader/crimson_fang
	lord_spells = list(
		/obj/effect/proc_holder/spell/targeted/shapeshift/vampire/bat
	)
	lord_verbs = list(
		/mob/living/carbon/human/proc/punish_spawn
	)
	lord_traits = list(TRAIT_HEAVYARMOR, TRAIT_INFINITE_ENERGY, TRAIT_STRENGTH_UNCAPPED, TRAIT_KEENEARS) //Lord gets a little treat to further them from other clans.
	lord_title = "Hand of Crimson"
	vitae_bonus = 500

/// Banu Haqim from Temu, kinda.
/datum/clan/crimson_fang
	name = "Crimson Fang"
	desc = "Crimson Fangs, often seen by other kindred as dangerous assassins and diablerists, but in truth they are decendants of an ancient bloodlyne of guardians, warriors,and scholars whom in recent tymes resurfaced, compelled by their Astrata-cursed instinct of craving power and authority."
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
		TRAIT_BATTLEMASTER,
		TRAIT_LIGHT_STEP, //Assassins, you say?
		TRAIT_CICERONE,
		TRAIT_NOSLEEP,
		TRAIT_VAMPMANSION,
		TRAIT_VAMP_DREAMS,
		TRAIT_DARKVISION,
		TRAIT_LIMBATTACHMENT,
		TRAIT_SILVER_WEAK,
		TRAIT_ZOMBIE_IMMUNE,
	)
	leader = /datum/clan_leader/crimson_fang
	covens_to_select = 0

/datum/clan/crimson_fang/apply_clan_components(mob/living/carbon/human/H)
	. = ..()
	H.AddComponent(/datum/component/sunlight_vulnerability, damage = 5, drain = 3) // 5/3 to account for you having to drink those of noble blood for full benefit.

/datum/clan/crimson_fang/get_blood_preference_string()
	return "the blood of nobles, clergy, inquisition or kindred"

/datum/clan/crimson_fang/get_downside_string()
	return "burn in sunlight, you can disguise under it slightly longer than most"
