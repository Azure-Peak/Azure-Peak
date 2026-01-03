/datum/job/roguetown/councillor
	title = "Councillor"
	flag = COUNCILLOR
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	allowed_ages = ALL_AGES_LIST
	allowed_races = RACES_NO_CONSTRUCT		//Nobility, so no constructs.
	allowed_sexes = list(MALE, FEMALE)
	display_order = JDO_COUNCILLOR
	tutorial = "You may have inherited this position, bought your way into it, or were appointed to it by merit--perish the thought! Whatever the case though, you work as an assistant and agent of the crown in matters of state. Whether this be aiding the steward, the sheriff, or the crown itself, or simply enjoying the free food of the keep, your duties vary day by day. You may be the lowest rung of the ladder, but that rung still towers over everyone else in town."
	whitelist_req = FALSE
	outfit = /datum/outfit/job/roguetown/councillor
	advclass_cat_rolls = list(CTAG_COUNCILLOR = 2)

	give_bank_account = TRUE
	noble_income = 20
	min_pq = 1 //Probably a bad idea to have a complete newbie advising the monarch
	max_pq = null
	round_contrib_points = 2
	cmode_music = 'sound/music/combat_noble.ogg'
	job_traits = list(TRAIT_NOBLE)
	job_subclasses = list(
		/datum/advclass/councillor/herald,
		/datum/advclass/councillor/advisor,
		/datum/advclass/councillor/cofferer,
	)

/datum/advclass/councillor/herald
	name = "Herald"
	tutorial = "While lacking in some faculties, such as wealth and courtly advice, you have the uncanny ability to spread the word of the court, and rally people to your liege's cause. The crown saw it fit to employ you as a messenger, but may still lend an ear if you speak your mind. You may be the lowest rung of the ladder, but that rung still towers over everyone else in town."
	outfit = /datum/outfit/job/roguetown/councillor/herald
	horse = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck/tame/saddled
	category_tags = list(CTAG_COUNCILLOR)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_INT = 1,
		STATKEY_PER = 1,
		STATKEY_STR = -1,
		STATKEY_CON = -1
	)

	// better movement skills
	subclass_skills = list(
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
	)


/datum/advclass/councillor/advisor
	name = "Advisor"
	tutorial = "You have a keen sense of political acumen. Much like the jester, albeit in a less farcical manner, you are well-suited to giving the court advice on daily matters. They might even listen if you tell them that a plan of theirs may have a hole in it that would sink it. You may be the lowest rung of the ladder, but that rung still towers over everyone else in town."
	outfit = /datum/outfit/job/roguetown/councillor/advisor
	category_tags = list(CTAG_COUNCILLOR)
	subclass_stats = list(
		STATKEY_INT = 3, // smart and savvy
		STATKEY_PER = 2,
		STATKEY_STR = -2,
		STATKEY_CON = -1
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
	)


/datum/advclass/councillor/cofferer
	name = "Cofferer"
	tutorial = "Whether born into wealth, or earned through working up from the bottom, you have quite the reserve of mammon at your disposal. Use your silver-tongue to acquire more, or buy more favour with the court. You may be the lowest rung of the ladder, but that rung still towers over everyone else in town."
	outfit = /datum/outfit/job/roguetown/councillor/cofferer
	category_tags = list(CTAG_COUNCILLOR)
	subclass_stats = list(
		STATKEY_WIL = 2,
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_STR = -1,
		STATKEY_CON = -2
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/councillor
	job_bitflag = BITFLAG_ROYALTY

/datum/outfit/job/roguetown/councillor/herald/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid // a mediocre pouch of coins
	shirt = /obj/item/clothing/suit/roguetown/shirt/fancyjacket
	pants = /obj/item/clothing/under/roguetown/trou/beltpants
	shoes = /obj/item/clothing/shoes/roguetown/boots
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes/steel
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/keyring/councillor
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel
	cloak = /obj/item/clothing/cloak/half/red
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_MIDDLE_CLASS, H, "Savings.") // lower starting fund, but give them a saiga
	// give them the shitty see prices trait
	ADD_TRAIT(H, TRAIT_SEEPRICES_SHITTY, JOB_TRAIT)

/datum/outfit/job/roguetown/councillor/advisor/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid // a mediocre pouch of coins
	shirt = /obj/item/clothing/suit/roguetown/shirt/fancyjacket
	pants = /obj/item/clothing/under/roguetown/trou/beltpants
	shoes = /obj/item/clothing/shoes/roguetown/boots
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes/steel
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/keyring/councillor
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel
	cloak = /obj/item/clothing/cloak/half/red
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_UPPER_CLASS, H, "Savings.")
	// give them the shitty see prices trait
	ADD_TRAIT(H, TRAIT_SEEPRICES_SHITTY, JOB_TRAIT)

/datum/outfit/job/roguetown/councillor/cofferer/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich // a fat pouch of coins
	shirt = /obj/item/clothing/suit/roguetown/shirt/fancyjacket
	pants = /obj/item/clothing/under/roguetown/trou/beltpants
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes/gold
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather/plaquesilver
	beltl = /obj/item/storage/keyring/councillor/cofferer
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel
	cloak = /obj/item/clothing/cloak/half/red
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_RICH, H, "Savings.") // wealth beyond measure
	// give them the good see prices trait
	ADD_TRAIT(H, TRAIT_SEEPRICES, JOB_TRAIT)
