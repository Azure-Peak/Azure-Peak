/datum/advclass/confessor
	name = "Confessor"
	tutorial = "Psydonite hunters, unmatched in the fields of subterfuge and investigation. There is no suspect too powerful to investigate, no room too guarded to infiltrate, and no weakness too hidden to exploit."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/confessor
	category_tags = list(CTAG_INQUISITION)
	subclass_languages = list(/datum/language/otavan)
	cmode_music = 'sound/music/cmode/antag/combat_deadlyshadows.ogg'
	traits_applied = list(
		TRAIT_DODGEEXPERT,
		TRAIT_BLACKBAGGER,
		TRAIT_PERFECT_TRACKER,
		TRAIT_PSYDONITE,
	)
	subclass_stats = list(
		STATKEY_SPD = 3,
		STATKEY_WIL = 3,
		STATKEY_PER = 2,
		STATKEY_STR = -1
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN, //Should rely on the seizing garrote to properly subdue foes.
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT, 
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN, //Ensures that captured individuals are less likely to die, if subdued with harsher force.
		/datum/skill/misc/sneaking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/stealing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
	)
	subclass_stashed_items = list(
		"Tome of Psydon" = /obj/item/book/rogue/bibble/psy
	)
	extra_context = "This subclass can choose between two specialities: the slurbow or crossbow. Taking the latter will provide Master skills for their ranged weapon and a minor increase to all physical stats, but imparts a heavy Speed malus and removes the 'Dodge Expert' trait."

/datum/outfit/job/roguetown/confessor
	job_bitflag = BITFLAG_HOLY_WARRIOR

/datum/outfit/job/roguetown/confessor/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	if(H.mind)
		var/weapons = list("Blessed Psydonic Dagger", "Psydonic Handmace", "Psydonic Shortsword")
		var/weapon_choice = input(H,"Choose your WEAPON.", "TAKE UP PSYDON'S ARMS.") as anything in weapons
		switch(weapon_choice)
			if("Blessed Psydonic Dagger")
				l_hand = /obj/item/rogueweapon/huntingknife/idagger/silver/psydagger
				r_hand = /obj/item/rogueweapon/scabbard/sheath
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, 4, TRUE)
			if("Psydonic Handmace")
				l_hand = /obj/item/rogueweapon/mace/cudgel/psy
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, 4, TRUE)	
			if("Psydonic Shortsword")
				l_hand = /obj/item/rogueweapon/sword/short/psy
				r_hand = /obj/item/rogueweapon/scabbard/sword
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
		var/armors = list("Confessor - Slurbow, Leather Maillecoat", "Arbalist - Crossbow, Psydonic Chestplate")
		var/armor_choice = input(H, "Choose your ARCHETYPE.", "TAKE UP PSYDON'S DUTY.") as anything in armors
		switch(armor_choice)
			if("Confessor - Slurbow, Leather Maillecoat")
				head = /obj/item/clothing/head/roguetown/roguehood/psydon/confessor
				armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/confessor
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow
			if("Arbalist - Crossbow, Psydonic Chestplate")
				head = /obj/item/clothing/head/roguetown/headband/bloodied
				armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer/psydon
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				REMOVE_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, 5, TRUE)
				H.change_stat(STATKEY_CON, 1)
				H.change_stat(STATKEY_STR, 2)
				H.change_stat(STATKEY_PER, 1) //Applies a base statblock of 11/11/11/13 to CON, STR, SPD and PER - compared to the standard 10/9/13/12 + DODGE EXPERT. Physically adept and capable of higher ranged damage..
				H.change_stat(STATKEY_SPD, -2) //..but with a massive loss to mobility and damage evasion, alongside the naturally low defense of their sidearms.
		var/quivers = list("Bolts - Steel-Tipped", "Sunderbolts - Silver-Tipped, Halved Damage")
		var/boltchoice = input(H,"Choose your MUNITIONS.", "TAKE UP PSYDON'S MISSILES.") as anything in quivers
		switch(boltchoice)
			if("Bolts - Steel-Tipped")
				beltl = /obj/item/quiver/bolts
			if("Sunderbolts - Silver-Tipped, Halved Damage")
				beltl = /obj/item/quiver/holybolts

	cloak = /obj/item/storage/backpack/rogue/satchel/beltpack
	wrists = /obj/item/clothing/neck/roguetown/psicross/silver
	gloves = /obj/item/clothing/gloves/roguetown/otavan/psygloves
	neck = /obj/item/clothing/neck/roguetown/gorget
	backr = /obj/item/storage/backpack/rogue/satchel/otavan
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/black/psydon
	beltr = /obj/item/storage/belt/rogue/pouch/coins/mid
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	shoes = /obj/item/clothing/shoes/roguetown/boots/psydonboots
	mask = /obj/item/clothing/mask/rogue/facemask/steel/confessor
	id = /obj/item/clothing/ring/signet/silver
	backpack_contents = list(
		/obj/item/roguekey/inquisition = 1,
		/obj/item/rope/inqarticles/inquirycord = 1,
		/obj/item/lockpickring/mundane = 1,
		/obj/item/clothing/head/inqarticles/blackbag = 1,
		/obj/item/inqarticles/garrote = 1,
		/obj/item/grapplinghook = 1,
		/obj/item/paper/inqslip/arrival/ortho = 1
		)
