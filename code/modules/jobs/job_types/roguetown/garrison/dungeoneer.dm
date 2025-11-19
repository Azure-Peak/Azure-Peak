/datum/job/roguetown/dungeoneer
	title = "Dungeoneer"
	flag = DUNGEONEER
	department_flag = GARRISON
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_races = ACCEPTED_RACES
	allowed_sexes = list(MALE, FEMALE)

	job_traits = list(TRAIT_STEELHEARTED, TRAIT_DUNGEONMASTER, TRAIT_GUARDSMAN, TRAIT_PURITAN_ADVENTURER) //'PURITAN_ADVENTURER' is the codename. Presents as 'INTERROGATOR', in-game. Doesn't provide any Inquisition-related boons, but gives instrucitons on how to use certain mechanics.
	display_order = JDO_DUNGEONEER
	advclass_cat_rolls = list(CTAG_DUNGEONEER = 2)

	tutorial = "Sometimes at night you stare into the vacant room and feel the loneliness of your existence crawl into whatever remains of your loathsome soul. \
				You will never know hunger, thirst or want for anything with the mammons you make: Just as you’ll never forget the sounds a saw makes cutting through the bone, what a drowning man will gurgle out between the blood and teeth strangling his breath. \
				You fall under the garrison's command, obeying orders of the Sergeant, Knight Captain, Marshal, and the Crown. Tending to those awaiting condemning and dishing punishment are your specialties.."

	announce_latejoin = FALSE
	outfit = /datum/outfit/job/roguetown/dungeoneer
	give_bank_account = TRUE
	min_pq = 0
	max_pq = null
	round_contrib_points = 2

	cmode_music = 'sound/music/combat_dungeoneer.ogg'
	job_subclasses = list(
		/datum/advclass/dungeoneer
	)

/datum/job/roguetown/dungeoneer/New()
	. = ..()
	peopleknowme = list()
	for(var/X in GLOB.garrison_positions)
		peopleknowme += X
	for(var/X in GLOB.noble_positions)
		peopleknowme += X
	for(var/X in GLOB.courtier_positions)
		peopleknowme += X

/datum/outfit/job/roguetown/dungeoneer
	job_bitflag = BITFLAG_GARRISON

/datum/advclass/dungeoneer
	name = "Dungeoneer"
	tutorial = "Penance, filthy sense of sadism or a queer outlook on justice, something has led you to don the shunned mask and fulfill the whims of the Nobility. Their whims are your guidance, as you've no 'moral quandaries' to care for."
	outfit = /datum/outfit/job/roguetown/dungeoneer/base

	category_tags = list(CTAG_DUNGEONEER)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 1
	)
	subclass_skills = list(
		/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_MASTER, //hilarious
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,//Enough for majority of surgeries without grinding.
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/traps = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
	)
	adv_stat_ceiling = list(STAT_STRENGTH = 16, STAT_CONSTITUTION = 16, STAT_WILLPOWER = 16)

/datum/outfit/job/roguetown/dungeoneer/base/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	H.verbs |= /mob/living/carbon/human/proc/faith_test
	H.verbs |= /mob/living/carbon/human/proc/torture_victim
	pants = /obj/item/clothing/under/roguetown/trou/leather/mourning
	shoes = /obj/item/clothing/shoes/roguetown/boots
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/councillor//Just so I don't have to make another subtype just for it to start black.
	armor = /obj/item/clothing/suit/roguetown/armor/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	belt = /obj/item/storage/belt/rogue/leather/black
	beltr = /obj/item/rogueweapon/whip/antique
	beltl = /obj/item/storage/keyring/dungeoneer
	backr = /obj/item/storage/backpack/rogue/satchel/black
	id = /obj/item/scomstone/bad/garrison
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 2,
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/clothing/neck/roguetown/psicross/silver = 1,
		) //No armoury access
	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
	//Torture victim is for inquisition - doesn't even work without a psicross anymore so maybe come up with a variant for him specifically?
	switch(H.patron?.type)
		if(/datum/patron/divine/necra)
			head = /obj/item/clothing/head/roguetown/necrahood
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/necra
		else
			cloak = /obj/item/clothing/cloak/stabard/dungeon
			head = /obj/item/clothing/head/roguetown/menacing
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_MIDDLE_CLASS, H, "Savings.")
