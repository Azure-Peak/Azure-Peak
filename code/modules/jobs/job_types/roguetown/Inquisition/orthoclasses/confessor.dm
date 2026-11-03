/datum/advclass/confessor
	name = "Confessor"
	tutorial = "Psydonite hunters, unmatched in the fields of subterfuge and investigation. There is no suspect too powerful to investigate, no room too guarded to infiltrate, and no weakness too hidden to exploit."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/confessor
	category_tags = list(CTAG_ORTHODOXIST)
	subclass_languages = list(/datum/language/otavan)
	cmode_music = 'sound/music/cmode/antag/combat_deadlyshadows.ogg'
	traits_applied = list(
		TRAIT_DODGEEXPERT,
		TRAIT_BLACKBAGGER,
		TRAIT_PERFECT_TRACKER,
		TRAIT_PSYDONITE
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
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN, //Ensures that captured individuals are less likely to die, if subdued with harsher force.
		/datum/skill/misc/sneaking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/traps = SKILL_LEVEL_JOURNEYMAN
	)
	subclass_stashed_items = list(
		"The Book" = /obj/item/book/rogue/bibble/psy
	)

/datum/outfit/job/roguetown/confessor
	job_bitflag = BITFLAG_HOLY_WARRIOR

/datum/outfit/job/roguetown/confessor/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	has_loadout = TRUE
	head = /obj/item/clothing/head/roguetown/roguehood/psydon/confessor
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/confessor
	cloak = /obj/item/storage/backpack/rogue/satchel/beltpack
	wrists = /obj/item/clothing/neck/roguetown/psicross/silver
	gloves = /obj/item/clothing/gloves/roguetown/otavan/psygloves
	neck = /obj/item/clothing/neck/roguetown/gorget
	backr = /obj/item/storage/backpack/rogue/satchel/otavan
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/black/silver/psy/preblessed
	beltr = /obj/item/storage/belt/rogue/pouch/coins/mid
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	shoes = /obj/item/clothing/shoes/roguetown/boots/psydonboots
	mask = /obj/item/clothing/mask/rogue/facemask/steel/confessor
	id = /obj/item/clothing/ring/signet/psy
	backpack_contents = list(
		/obj/item/roguekey/inquisitionmanor = 1,
		/obj/item/rope/inqarticles/inquirycord = 1,
		/obj/item/lockpickring/mundane = 1,
		/obj/item/clothing/head/inqarticles/blackbag = 1,
		/obj/item/inqarticles/garrote = 1,
		/obj/item/grapplinghook = 1,
		/obj/item/paper/inqslip/arrival/ortho = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel/silver/psy = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)

	add_verb(H, /mob/living/carbon/human/proc/faith_test)
	add_verb(H, /mob/living/carbon/human/proc/torture_victim)

	change_origin(H, /datum/virtue/origin/otava, "Holy order")

/datum/outfit/job/roguetown/confessor/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/shirts = list("Inquisitorial Leather Tunic", "Cuir-Bouilli Vest")
	var/shirt_choice = input(H, "Choose your UNDERLAYER.", "TAKE UP PSYDON'S VESTMENTS.") as anything in shirts
	switch(shirt_choice)
		if("Inquisitorial Leather Tunic")
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq, SLOT_SHIRT, TRUE)
		if("Cuir-Bouilli Vest")
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/leather/studded/cuirbouilli, SLOT_SHIRT, TRUE)

	var/weapons = list("Psydonic Rapier", "Psydonic Shortsword", "Psydonic Tomahawk", "Psydonic Cudgel", "Psydonic Flanged Mace", "Psydonic Whip")
	var/weapon_choice = input(H,"Choose your WEAPON.", "TAKE UP PSYDON'S ARMS.") as anything in weapons
	switch(weapon_choice)
		if("Psydonic Rapier")
			H.put_in_hands(new /obj/item/rogueweapon/sword/rapier/silver/psy)
			H.put_in_hands(new /obj/item/rogueweapon/scabbard/sword)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
		if("Psydonic Shortsword")
			H.put_in_hands(new /obj/item/rogueweapon/sword/short/silver/psy)
			H.put_in_hands(new /obj/item/rogueweapon/scabbard/sword)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
		if("Psydonic Tomahawk")
			H.put_in_hands(new /obj/item/rogueweapon/stoneaxe/handaxe/silver/psy)
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
		if("Psydonic Cudgel")
			H.put_in_hands(new /obj/item/rogueweapon/mace/cudgel/psy)
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
		if("Psydonic Flanged Mace")
			H.put_in_hands(new /obj/item/rogueweapon/mace/cudgel/flanged/silver/psy)
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
		if("Psydonic Whip")
			H.put_in_hands(new /obj/item/rogueweapon/whip/silver/psy)
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)

	var/rangedweapons = list("Slurbow - Lesser Damage, Rapid & Accurate", "Crossbow - Access To Special Bolts")
	var/rangedweapon_choice = input(H,"Choose your BOW.", "TAKE UP PSYDON'S ARCAGE.") as anything in rangedweapons
	switch(rangedweapon_choice)
		if("Slurbow - Lesser Damage, Rapid & Accurate")
			H.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow, SLOT_BACK_L, TRUE)
			var/lightquivers = list("Light Bolts - Steel-Tipped", "Light Sunderbolts - Silver-Tipped, Halved Damage")
			var/lightboltchoice = input(H,"Choose your MUNITIONS.", "TAKE UP PSYDON'S MISSILES.") as anything in lightquivers
			switch(lightboltchoice)
				if("Light Bolts - Steel-Tipped")
					H.equip_to_slot_or_del(new /obj/item/quiver/bolt/light, SLOT_BELT_L, TRUE)
				if("Light Sunderbolts - Silver-Tipped, Halved Damage")
					H.equip_to_slot_or_del(new /obj/item/quiver/bolt/lightholy, SLOT_BELT_L, TRUE)
		if("Crossbow - Access To Special Bolts")
			H.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow, SLOT_BACK_L, TRUE)
			var/quivers = list("Bolts - Steel-Tipped", "Sunderbolts - Silver-Tipped, Halved Damage", "Pyrobolts - Incendiary-Tipped, Minimal Damage")
			var/boltchoice = input(H,"Choose your MUNITIONS.", "TAKE UP PSYDON'S MISSILES.") as anything in quivers
			switch(boltchoice)
				if("Bolts - Steel-Tipped")
					H.equip_to_slot_or_del(new /obj/item/quiver/bolt/standard, SLOT_BELT_L, TRUE)
				if("Sunderbolts - Silver-Tipped, Halved Damage")
					H.equip_to_slot_or_del(new /obj/item/quiver/bolt/holy, SLOT_BELT_L, TRUE)
				if("Pyrobolts - Incendiary-Tipped, Minimal Damage")
					H.equip_to_slot_or_del(new /obj/item/quiver/bolt/pyro, SLOT_BELT_L, TRUE)
