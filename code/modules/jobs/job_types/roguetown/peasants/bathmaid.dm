/datum/job/roguetown/bathworker
	title = "Bathhouse Attendant"
	f_title = "Bathhouse Attendant"
	flag = BATHWORKER
	department_flag = PEASANTS
	selection_color = JCOLOR_PEASANT
	faction = "Station"
	total_positions = 5
	spawn_positions = 5

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED)


	tutorial = "Dancing, music, or practicioners of the body. You've worked up a reputation as an entertainer, and sometime in life, the bathmaster has chosen to onboard you for one of these talents. In the bathhouse, your place on the hierarchy is determined by how long you've been in the game - and how much mammon you're worth."

	outfit = /datum/outfit/job/roguetown/bathworker
	advclass_cat_rolls = list(CTAG_BATHWORKER = 20)
	display_order = JDO_BATHWORKER
	give_bank_account = TRUE
	can_random = FALSE
	min_pq = -10
	max_pq = null
	round_contrib_points = 2
	advjob_examine = TRUE
	cmode_music = 'sound/music/cmode/towner/combat_towner.ogg'
	job_traits = list(TRAIT_EMPATH, TRAIT_GOODLOVER, TRAIT_HOMESTEAD_EXPERT)
	job_subclasses = list(
		/datum/advclass/bathworker,
		/datum/advclass/bathworker/harlot,
		/datum/advclass/bathworker/courtesan
	)

/datum/outfit/job/roguetown/bathworker
	name = "Bathhouse Attendant"
	// This is just a base outfit, the actual outfits are defined in the advclasses

/datum/advclass/bathworker
	name = "Bath Attendant"
	tutorial = "A fresh initiate, most would decry the humble bath maid as a desperate fool tempting others into bedsheets for money--only sometimes, you say! You work underneath your betters in the communal bathhouse, keeping it and the guests in turn as tidy as they please. Wash laundry, tend mild wounds, and deftly wash your patrons with soap, for this is your craft."
	outfit = /datum/outfit/job/roguetown/bathworker/attendant
	category_tags = list(CTAG_BATHWORKER)
	traits_applied = list(TRAIT_NUTCRACKER, TRAIT_CICERONE)
	subclass_stats = list(
		STATKEY_CON = 3,
		STATKEY_WIL = 2,
		STATKEY_STR = 1
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/music = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/bathworker/attendant/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/cap
	neck = /obj/item/clothing/neck/roguetown/collar
	beltl = /obj/item/roguekey/bathworker
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/satchel
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	backpack_contents = list(
		/obj/item/soap/bath = 1
	)
	if(should_wear_femme_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/sexy/random
		pants = /obj/item/clothing/under/roguetown/skirt/brown
		belt =	/obj/item/storage/belt/rogue/leather/cloth/lady
	else
		belt = /obj/item/storage/belt/rogue/leather
		pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/shorts
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/massage)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_CLASS, H, "Savings.")

/datum/advclass/bathworker/harlot
	name = "Harlot"
	tutorial = "You're no stranger to selling your flesh, a veteran whore who's done your business in back alleys and brothels long enough to know the game. Yours has been a hard life, and you've learned a few things doing what you've needed to survive. You may not be fit for a noble's bed, but the workers and soldiers pay well enough."
	outfit = /datum/outfit/job/bathworkerghtmaiden/harlot
	category_tags = list(CTAG_BATHWORKER)

	traits_applied = list(TRAIT_LIGHT_STEP, TRAIT_NUTCRACKER)
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = 2
	)

	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/music = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
	)
	subclass_languages = list(
		/datum/language/thievescant,
	)

/datum/outfit/job/bathworkerghtmaiden/harlot/pre_equip(mob/living/carbon/human/H)
	..()
	var/pinroll = rand(1, 20)
	switch(pinroll)
		if(1 to 19)
			head = /obj/item/lockpick/goldpin
		if(20)
			head = /obj/item/lockpick/goldpin/silver
	neck = /obj/item/clothing/neck/roguetown/collar/leather
	beltl = /obj/item/roguekey/bathworker
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/satchel
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	backpack_contents = list(
		/obj/item/soap/bath = 1,
	)
	if(should_wear_femme_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/gen/sexy/random
		armor = /obj/item/clothing/suit/roguetown/armor/corset
		pants = /obj/item/clothing/under/roguetown/skirt/brown
		belt =	/obj/item/storage/belt/rogue/leather/cloth/lady
	else
		belt = /obj/item/storage/belt/rogue/leather
		pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/shorts
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/massage)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_CLASS, H, "Savings.")

/datum/advclass/bathworker/courtesan
	name = "Courtesan"
	tutorial = "Overcoming mind games, deceit and competition, you came into your own as one of the bathhouse's most prized moneymakers and socialites. Dressed in lavish gifts left behind by your patrons, not just anyone can have you. Under the matron, you do most of the social heavylifting and provide entertainment of all forms - behind a heavy price tag. "
	outfit = /datum/outfit/job/roguetown/bathworker/courtesan
	category_tags = list(CTAG_BATHWORKER)
	traits_applied = list(TRAIT_KEENEARS, TRAIT_BEAUTIFUL)
	subclass_stats = list(
		STATKEY_SPD = 3,
		STATKEY_WIL = 2,
		STATKEY_PER = 1
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/music = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/bathworker/courtesan/pre_equip(mob/living/carbon/human/H)
	..()
	var/pinroll = rand(1, 20)
	switch(pinroll)
		if(1 to 19)
			head = /obj/item/lockpick/goldpin
		if(20)
			head = /obj/item/lockpick/goldpin/silver
	var/ringroll = rand(1, 100)
	switch(ringroll)
		if(1 to 25)
			id = /obj/item/clothing/ring/gold
		if(26 to 50)
			id = /obj/item/clothing/ring/emerald
		if(51 to 80)
			id = /obj/item/clothing/ring/topaz
		if(81 to 95)
			id = /obj/item/clothing/ring/silver
		if(96 to 100)
			id = /obj/item/clothing/ring/diamond
	beltl = /obj/item/roguekey/bathworker
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/reagent_containers/powder/moondust = 2,
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 1,
		/obj/item/toy/cards/deck = 1,
	)
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/silkydress/random
		shirt = /obj/item/clothing/suit/roguetown/armor/corset
		belt = /obj/item/storage/belt/rogue/leather/cloth/lady
		shoes = /obj/item/clothing/shoes/roguetown/anklets
	else
		shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/random
		pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
		belt = /obj/item/storage/belt/rogue/leather/black
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/short

	if(H.mind)
		var/weapons = list("Harp","Lute","Accordion","Guitar","Hurdy-Gurdy","Viola","Vocal Talisman","Flute")
		var/weapon_choice = input(H, "Choose your instrument.", "TAKE UP ARMS") as anything in weapons
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/massage)
		H.set_blindness(0)
		switch(weapon_choice)
			if("Harp")
				backr = /obj/item/rogue/instrument/harp
			if("Lute")
				backr = /obj/item/rogue/instrument/lute
			if("Accordion")
				backr = /obj/item/rogue/instrument/accord
			if("Guitar")
				backr = /obj/item/rogue/instrument/guitar
			if("Hurdy-Gurdy")
				backr = /obj/item/rogue/instrument/hurdygurdy
			if("Viola")
				backr = /obj/item/rogue/instrument/viola
			if("Vocal Talisman")
				backr = /obj/item/rogue/instrument/vocals
			if("Flute")
				backr = /obj/item/rogue/instrument/flute
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_UPPER_CLASS, H, "Savings.")

/obj/item/soap/bath
	name = "herbal soap"
	desc = "A soap made from various herbs"
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "soap"
	lefthand_file = 'icons/mob/inhands/equipment/custodial_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/custodial_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	item_flags = NOBLUDGEON

/obj/item/bath/soap/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/slippery, 80)
