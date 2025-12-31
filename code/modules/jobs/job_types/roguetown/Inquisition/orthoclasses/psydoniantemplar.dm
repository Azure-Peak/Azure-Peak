/datum/advclass/psydoniantemplar // A templar, but for the Inquisition
	name = "Adjudicator"
	tutorial = "Psydonite knights, clad in fluted chainmaille and blessed with the capacity to invoke lesser miracles. In lieu of greater miracles and rituals, they compensate through martial discipline and blessed weaponry."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/psydoniantemplar
	category_tags = list(CTAG_INQUISITION)
	subclass_languages = list(/datum/language/otavan)
	cmode_music = 'sound/music/templarofpsydonia.ogg'
	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_WIL = 3,
		STATKEY_CON = 3,
		STATKEY_STR = 2,
		STATKEY_SPD = -1
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
	)
	subclass_stashed_items = list(
		"Tome of Psydon" = /obj/item/book/rogue/bibble/psy
	)
	extra_context = "This subclass can choose between two types of armor: a set of plated hauberk, and a tasseted cuirass. Selecting the latter provides less coverage and durability, but removes the innate malus to Speed."

/datum/outfit/job/roguetown/psydoniantemplar
	job_bitflag = BITFLAG_HOLY_WARRIOR

/datum/outfit/job/roguetown/psydoniantemplar/pre_equip(mob/living/carbon/human/H)
	..()
	has_loadout = TRUE
	wrists = /obj/item/clothing/neck/roguetown/psicross/silver
	cloak = /obj/item/clothing/cloak/tabard/psydontabard
	backr = /obj/item/rogueweapon/shield/tower/metal
	gloves = /obj/item/clothing/gloves/roguetown/chain/psydon
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	pants = /obj/item/clothing/under/roguetown/chainlegs
	backl = /obj/item/storage/backpack/rogue/satchel/otavan
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq
	shoes = /obj/item/clothing/shoes/roguetown/boots/psydonboots
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	id = /obj/item/clothing/ring/signet/silver
	backpack_contents = list(/obj/item/roguekey/inquisition = 1,
	/obj/item/paper/inqslip/arrival/ortho = 1)

	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1) //Capped to T2 miracles. ENDURE. WITH RESPITE.


/datum/outfit/job/roguetown/psydoniantemplar/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/helmets = list("Barbute", "Sallet", "Armet", "Bucket Helm")
	var/helmet_choice = input(H,"Choose your HELMET.", "TAKE UP PSYDON'S HELMS.") as anything in helmets
	switch(helmet_choice)
		if("Barbute")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/psydonbarbute, SLOT_HEAD, TRUE)
		if("Sallet")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/psysallet, SLOT_HEAD, TRUE)
		if("Armet")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm, SLOT_HEAD, TRUE)
		if("Bucket Helm")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/psybucket, SLOT_HEAD, TRUE)

	var/armors = list("Hauberk", "Cuirass")
	var/armor_choice = input(H, "Choose your ARMOR.", "TAKE UP PSYDON'S MANTLE.") as anything in armors
	switch(armor_choice)
		if("Hauberk")
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ornate, SLOT_ARMOR, TRUE)
		if("Cuirass")
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/ornate, SLOT_ARMOR, TRUE)
			H.change_stat(STATKEY_SPD, 1) //Less durability and coverage, but still upgradable. Balances out the innate -1 SPD debuff.

	var/weapons = list("Psydonic Longsword", "Psydonic War Axe", "Psydonic Whip", "Psydonic Flail", "Psydonic Mace", "Psydonic Spear + Handmace", "Psydonic Poleaxe + Shortsword")
	var/weapon_choice = input(H,"Choose your WEAPON.", "TAKE UP PSYDON'S ARMS.") as anything in weapons
	switch(weapon_choice)
		if("Psydonic Longsword")
			H.put_in_hands(new /obj/item/rogueweapon/sword/long/psysword(H))
			H.put_in_hands(new /obj/item/rogueweapon/scabbard/sword(H))
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
		if("Psydonic War Axe")
			H.put_in_hands(new /obj/item/rogueweapon/stoneaxe/battle/psyaxe(H))
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, 4, TRUE)
		if("Psydonic Whip")
			H.put_in_hands(new /obj/item/rogueweapon/whip/psywhip_lesser(H))
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 4, TRUE)
		if("Psydonic Flail")
			H.put_in_hands(new /obj/item/rogueweapon/flail/sflail/psyflail(H))
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 4, TRUE)
		if("Psydonic Mace")
			H.put_in_hands(new /obj/item/rogueweapon/mace/goden/psymace(H))
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, 4, TRUE)
		if("Psydonic Spear + Handmace")
			H.put_in_hands(new /obj/item/rogueweapon/spear/psyspear(H))
			H.put_in_hands(new /obj/item/rogueweapon/mace/cudgel/psy(H))
			H.put_in_hands(new /obj/item/rogueweapon/scabbard/gwstrap(H))
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
		if("Psydonic Poleaxe + Shortsword")
			H.put_in_hands(new /obj/item/rogueweapon/greataxe/psy(H))
			H.put_in_hands(new /obj/item/rogueweapon/sword/short/psy(H))
			H.put_in_hands(new /obj/item/rogueweapon/scabbard/gwstrap(H))
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, 4, TRUE)
