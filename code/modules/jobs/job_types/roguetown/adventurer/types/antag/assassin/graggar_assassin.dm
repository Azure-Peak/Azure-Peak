/datum/advclass/assassin/
	name = "Assassin"
	tutorial = "The SINISTAR demands blood and YOU have been chosen. Your infernal dagger whispers to you the names of those who \
	must perish. Hunt them down and put them in the ground... or face the Dark Star's punishment."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/assassin/
	category_tags = list(CTAG_ASSASSIN)
	// Weighted 14
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_CON = 1, // dont instantly bleed out
		STATKEY_SPD = 3, // be swift...
		STATKEY_PER = 2,
		STATKEY_WIL = 2, // gives them some more stam
		STATKEY_INT = 1,
	)
	subclass_skills = list(
		// MAIN WEAPON SKILLS
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT, // you will ALWAYS be good with your knife.
		// everything else is apprentice at a minimum. you ARE a murder-antag. let it go up w/ choices, perhaps.
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		// ZIZO
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT, // for the love of god i gave them 11 str may this not be a mistake
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		// RANGED WEAPONS
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/slings = SKILL_LEVEL_APPRENTICE, // unlikely but slingsassin would be funny
		// PHYSICALITY -- STAMINA, MOVEMENT, ETC.
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER,
		/datum/skill/misc/climbing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		// INFILTRATION -- YOURE VERY GOOD AT THIS. THIS IS YOUR THING.
		/datum/skill/misc/sneaking = SKILL_LEVEL_MASTER, // + light steps
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_MASTER, // + your evil ass pick
		// MISC
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE, // what
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE, // what
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/traps = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_MASTER
	)

/datum/outfit/job/roguetown/assassin
	// Assassins will get to pick their outfit from this list. Unfortuately I dont have a better way to do this right now. So...
	// It's handled in the pre-equip.
	var/static/alist/disguises = alist(
	"Naked" = /datum/outfit/job/roguetown/assassin/assassin_disguise,
	"Assassin" = /datum/outfit/job/roguetown/assassin/assassin_disguise/assassin,
	"Beggar" = /datum/outfit/job/roguetown/assassin/assassin_disguise/beggar,
	)

/datum/outfit/job/roguetown/assassin/pre_equip(mob/living/carbon/human/H)
	..()

	var/choice = tgui_input_list(H, "Choose disguise", "Disguise", disguises)
	H.equipOutfit(choice)

	H.adjust_blindness(-3)
	if(H.mind)
		H.set_blindness(0)

	if(!istype(H.patron, /datum/patron/inhumen/graggar))
		to_chat(H, span_warning("My former deity has abandoned me.. Graggar is my new master.")) // i am the beast i worship
		H.set_patron(/datum/patron/inhumen/graggar)
