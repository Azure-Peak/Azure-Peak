/datum/advclass/chasseur
	name = "Chasseur"
	tutorial = "Psydonite skirmishers, clad in fluted steel and armed with the crossbow. A unique set of specialists, \
	considering their origins in the bowels of the militari-du-país' karst regiments."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/chasseur
	category_tags = list(CTAG_ORTHODOXIST)
	subclass_languages = list(/datum/language/otavan)
	cmode_music = 'sound/music/templarofpsydonia.ogg'
	traits_applied = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_PSYDONITE
	)
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_STR = 2,
		STATKEY_INT = 2
	)
	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/traps = SKILL_LEVEL_APPRENTICE
	)
	subclass_stashed_items = list(
		"The Book" = /obj/item/book/rogue/bibble/psy
	)

/datum/outfit/job/roguetown/chasseur
	job_bitflag = BITFLAG_HOLY_WARRIOR

/datum/outfit/job/roguetown/chasseur/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	has_loadout = TRUE
	head = /obj/item/clothing/head/roguetown/helmet/heavy/ornate/sallet
	head_decor = list(/obj/item/clothing/head/roguetown/headband/bloodied)
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/ornate
	chest_decor = list(/obj/item/clothing/cloak/tabard/psydontabard)
	shirt = /obj/item/clothing/suit/roguetown/armor/leather/studded/cuirbouilli
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/chain/psydon
	neck = /obj/item/clothing/neck/roguetown/chaincoif/full
	pants = /obj/item/clothing/under/roguetown/chainlegs
	cloak = /obj/item/storage/backpack/rogue/satchel/beltpack
	shoes = /obj/item/clothing/shoes/roguetown/boots/psydonboots
	belt = /obj/item/storage/belt/rogue/leather/black
	beltr = /obj/item/rogueweapon/shield/buckler
	backr = /obj/item/storage/backpack/rogue/satchel/otavan
	id = /obj/item/clothing/neck/roguetown/psicross/silver
	backpack_contents = list(
		/obj/item/roguekey/inquisitionmanor = 1,
		/obj/item/paper/inqslip/arrival/ortho = 1,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel/silver/psy = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/clothing/ring/signet/psy = 1
		)

	change_origin(H, /datum/virtue/origin/otava, "Holy order")

/datum/outfit/job/roguetown/chasseur/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/weapons = list("Psydonic Arming Sword", "Psydonic Shortsword", "Psydonic War Axe")
	var/weapon_choice = input(H, "Choose your WEAPON.", "TAKE UP PSYDON'S ARMS.") as anything in weapons
	switch(weapon_choice)
		if("Psydonic Arming Sword")
			H.put_in_hands(new /obj/item/rogueweapon/sword/silver/psy)
			H.put_in_hands(new /obj/item/rogueweapon/scabbard/sword)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
		if("Psydonic Shortsword")
			H.put_in_hands(new /obj/item/rogueweapon/sword/short/silver/psy)
			H.put_in_hands(new /obj/item/rogueweapon/scabbard/sword)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
		if("Psydonic War Axe")
			H.put_in_hands(new /obj/item/rogueweapon/stoneaxe/battle/silver/psy)
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)

	var/bows = list("Crossbow - Access To Special Bolts", "Siegebow - Greater Damage, Structurebreaker")
	var/bow_choice = input(H, "Choose your BOW.", "TAKE UP PSYDON'S ARCAGE.") as anything in bows
	switch(bow_choice)
		if("Crossbow - Access To Special Bolts")
			H.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow, SLOT_BACK_L, TRUE)
			var/quivers = list("Bolts - Steel-Tipped", "Sunderbolts - Silver-Tipped, Halved Damage", "Pyrobolts - Incendiary-Tipped, Minimal Damage")
			var/bolt_choice = input(H, "Choose your MUNITIONS.", "TAKE UP PSYDON'S MISSILES.") as anything in quivers
			switch(bolt_choice)
				if("Bolts - Steel-Tipped")
					H.equip_to_slot_or_del(new /obj/item/quiver/bolt/standard, SLOT_BELT_L, TRUE)
				if("Sunderbolts - Silver-Tipped, Halved Damage")
					H.equip_to_slot_or_del(new /obj/item/quiver/bolt/holy, SLOT_BELT_L, TRUE)
				if("Pyrobolts - Incendiary-Tipped, Minimal Damage")
					H.equip_to_slot_or_del(new /obj/item/quiver/bolt/pyro, SLOT_BELT_L, TRUE)
		if("Siegebow - Greater Damage, Structurebreaker")
			H.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/heavy, SLOT_BACK_L, TRUE)
			H.equip_to_slot_or_del(new /obj/item/quiver/bolt/heavy/stake, SLOT_BELT_L, TRUE)
