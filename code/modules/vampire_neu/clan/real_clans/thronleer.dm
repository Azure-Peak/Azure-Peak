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
	desc = "Noc, facinated by your House's endless persuit of archiving knowledge has bestowed his blessing upon your cursed bloodline, yet Astrata's scorn and ire only grows at what your clan has achieved."
	curse = "suffer in the sun."
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
	return "suffer in the sun"

/datum/clan/thronleer/apply_clan_components(mob/living/carbon/human/H)
	H.AddComponent(/datum/component/sunlight_vulnerability, damage = 5, drain = 10) //largest damage buildup of all clans.
	H.AddComponent(/datum/component/vampire_disguise)
