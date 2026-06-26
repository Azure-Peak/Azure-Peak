/datum/job/roguetown/squire
	title = "Squire"
	flag = SQUIRE
	department_flag = RETINUE
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	forbidden_races = list(RACES_DESPISED)
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT)
	advclass_cat_rolls = list(CTAG_SQUIRE = 20)
	job_traits = list(TRAIT_SQUIRE_REPAIR, TRAIT_EXPERT_HUNTER)

	tutorial = "Your folks said you were going to be something, they had better aspirations for you than the life of a peasant. You practiced the basics \
		in the field alongside your friends, swordfighting with sticks, chasing rabbits with grain flail, and helping around the house lifting heavy \
		bags of grain. The Knight took notice of your potential and brought you on as his personal ward. You're going to be something someday."
	outfit = /datum/outfit/job/roguetown/squire
	display_order = JDO_SQUIRE
	give_bank_account = TRUE
	min_pq = -5 //squires aren't great but they can do some damage
	max_pq = null
	round_contrib_points = 2

	cmode_music = 'sound/music/combat_squire.ogg'
	job_subclasses = list(
		/datum/advclass/squire/lancer,
		/datum/advclass/squire/footman,
		/datum/advclass/squire/skirmisher
	)

/datum/outfit/job/roguetown/squire
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/guard
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/keyring/squire
	id = /obj/item/scomstone/bad/garrison
	job_bitflag = BITFLAG_GARRISON

/datum/job/roguetown/squire/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		addtimer(CALLBACK(L, TYPE_PROC_REF(/mob, cloak_and_title_setup)), 50)

/datum/advclass/squire/lancer
	name = "Cavalier Squire"
	tutorial = "A hopeful for the next generation of knightly mounted lancers and infantry pike specialists, \
	your training with polearms sets you apart from other squires."
	outfit = /datum/outfit/job/roguetown/squire/lancer

	category_tags = list(CTAG_SQUIRE)
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_SPD = 1,
		STATKEY_PER = 1,
		STATKEY_CON = 1,
		STATKEY_INT = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/hunting = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/squire/lancer/pre_equip(mob/living/carbon/human/H)
	. = ..()
	add_verb(H, /mob/proc/haltyell_exhausting)
	r_hand = /obj/item/rogueweapon/spear
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
	gloves = /obj/item/clothing/gloves/roguetown/leather
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	backr = /obj/item/storage/backpack/rogue/satchel
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger,
		/obj/item/rogueweapon/scabbard/sheath,
		/obj/item/storage/belt/rogue/pouch,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot,
		/obj/item/rogueweapon/hammer/copper
	)
	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_WORKING_CLASS, H)

/datum/advclass/squire/footman
	name = "Squire at Arms"
	tutorial = "Your training has been singularly focused on the fine techniques of melee, suited to to your \
	future dominance on the battlefield."
	outfit = /datum/outfit/job/roguetown/squire/footman

	category_tags = list(CTAG_SQUIRE)
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_SPD = 1,
		STATKEY_PER = 1,
		STATKEY_CON = 1,
		STATKEY_INT = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/hunting = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/squire/footman/pre_equip(mob/living/carbon/human/H)
	. = ..()
	add_verb(H, /mob/proc/haltyell_exhausting)
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
	gloves = /obj/item/clothing/gloves/roguetown/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger,
		/obj/item/rogueweapon/scabbard/sheath,
		/obj/item/storage/belt/rogue/pouch,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot,
		/obj/item/rogueweapon/hammer/copper
	)
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Iron Sword","Cudgel",)
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Iron Sword")
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/iron
			if("Cudgel")
				beltr = /obj/item/rogueweapon/mace/cudgel
	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_WORKING_CLASS, H)

/datum/advclass/squire/skirmisher
	name = "Irregular Squire"
	tutorial = "As militaries become more flexible and tactics more moderne the importance of irregular troops \
	has become more apparent, and hopefuls such as yourself have been trained into the future of elite skirmisher \
	troops."
	outfit = /datum/outfit/job/roguetown/squire/skirmisher

	category_tags = list(CTAG_SQUIRE)
	traits_applied = list(TRAIT_DODGEEXPERT)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_PER = 1,
		STATKEY_CON = 1,
		STATKEY_INT = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/slings = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/hunting = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/squire/skirmisher/pre_equip(mob/living/carbon/human/H)
	. = ..()
	add_verb(H, /mob/proc/haltyell_exhausting)
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy
	pants = /obj/item/clothing/under/roguetown/trou/leather
	gloves = /obj/item/clothing/gloves/roguetown/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	backr = /obj/item/storage/backpack/rogue/satchel
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	beltr = /obj/item/quiver/arrows
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger,
		/obj/item/storage/belt/rogue/pouch,
		/obj/item/rogueweapon/scabbard/sheath,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot,
		/obj/item/rogueweapon/hammer/copper
		)
	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_WORKING_CLASS , H)
