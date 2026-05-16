/datum/clan_leader/thronleer
	lord_spells = list(
		/obj/effect/proc_holder/spell/targeted/shapeshift/vampire/bat
	)
	lord_verbs = list(
		/mob/living/carbon/human/proc/punish_spawn
	)
	lord_traits = list(TRAIT_HEAVYARMOR, TRAIT_INFINITE_ENERGY, TRAIT_SEEPRICES, TRAIT_STRENGTH_UNCAPPED) //Lord is more learned than other leaders
	vitae_bonus = 500
	lord_title = "Elder"

//Completely re-done because inital Thronleer didn't really have any identity beyond, children of the Abyss but better
/datum/clan/thronleer
	name = "House Thronleer"
	desc = "Noc, facinated by your House's endless persuit of archiving knowledge has bestowed his blessing upon your cursed bloodline, yet with a bad hand dealt by Xylix the cursed nature of your bloodline has left you with fears of whismy and bad fates."
	curse = "Jesterphobia, Obsession with learning and Terrible Mood."
	clanicon = "bloodheal"
	blood_preference = BLOOD_PREFERENCE_ALL //Noc blessed, they'll eat anything that moves.
	clane_traits = list(
		TRAIT_STRONGBITE,
		TRAIT_VAMPBITE,
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
		TRAIT_DEATHLESS,
		TRAIT_NOPAIN,
		TRAIT_TOXIMMUNE,
		TRAIT_STEELHEARTED,
		TRAIT_JESTERPHOBIA, //YOU KNOW WHAT, THIS IS FUNNY SURE.
		TRAIT_BAD_MOOD, //Heavier mood debuffs, can actually effect you heavily.
		TRAIT_SELF_SUSTENANCE,
		TRAIT_GOODWRITER,
		TRAIT_JACKOFALLTRADES, //Knowledge
		TRAIT_INTELLECTUAL,
		TRAIT_NOSLEEP,
		TRAIT_VAMPMANSION,
		TRAIT_VAMP_DREAMS,
		TRAIT_DARKVISION,
		TRAIT_LIMBATTACHMENT,
		TRAIT_KEENEARS,
		TRAIT_SILVER_WEAK,
		TRAIT_ZOMBIE_IMMUNE,
	)
	clane_covens = list(
		/datum/coven/obfuscate,
		/datum/coven/auspex, //All knowing.
		/datum/coven/demonic,
	)
	leader = /datum/clan_leader/thronleer
	covens_to_select = 0

/datum/clan/thronleer/get_blood_preference_string()
	return "all blood, variety is knowledge"

/datum/clan/thronleer/get_downside_string()
	return "chronic fear of jesters, heavy mood debuffs"

/datum/clan/thronleer/apply_clan_components(mob/living/carbon/human/H)
	H.AddComponent(/datum/component/vampire_disguise)
