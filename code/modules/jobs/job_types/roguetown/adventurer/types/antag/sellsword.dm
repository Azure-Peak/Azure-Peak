/datum/advclass/sellsword //Hybrid STR / SPD class with specialized weapon options
	name = "Sellsword"
	tutorial = "Anything for coin rings true for many but only you pushed it to it's ultimate conclusion, a band of merrymen at your back and any morals left behind - you will retire in wealth or die as a mere footnote in history."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/bandit/sellsword
	category_tags = list(CTAG_BANDIT)
	cmode_music = 'sound/music/cmode/antag/combat_cutpurse.ogg' // cutpurse or deadly shadows...?
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = 2,
		STATKEY_CON = 1,
		STATKEY_LCK = 1
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,		
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/bandit/sellsword/pre_equip(mob/living/carbon/human/H)
	..()
	if (!(istype(H.patron, /datum/patron/inhumen/matthios)))	//This is the only class that forces Matthios. Needed for miracles + limited slot.
		to_chat(H, span_warning("Matthios embraces me.. I must uphold his creed. I am his light in the darkness."))
		H.set_patron(/datum/patron/inhumen/matthios)
	head = /obj/item/clothing/head/roguetown/helmet/sallet/visored/iron
	neck = /obj/item/clothing/neck/roguetown/bevor/iron
	cloak = /obj/item/clothing/cloak/tabard/stabard/dungeon
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
					/obj/item/needle/thorn = 1,
					/obj/item/natural/cloth = 1,
					/obj/item/flashlight/flare/torch = 1,
					)

	id = /obj/item/mattcoin
	H.adjust_blindness(-3)
	var/weapons = list("Kriegmesser & Buckler","Falchion & Kite Shield","Sword & Crossbow")
	if(H.mind)
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Kriegmesser & Buckler") //Grenzel
				r_hand = /obj/item/rogueweapon/sword/long/kriegmesser
				backl= /obj/item/rogueweapon/shield/buckler
				beltr = /obj/item/rogueweapon/scabbard/sword
			if("Falchion & Kite Shield") //Otavan
				r_hand = /obj/item/rogueweapon/sword/short/falchion
				backl= /obj/item/rogueweapon/shield/tower/metal
				beltr = /obj/item/rogueweapon/scabbard/sword
			if("Sword & Crossbow") //Etruscan
				backl= /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				beltr = /obj/item/quiver/bolts
				r_hand = /obj/item/rogueweapon/sword
				beltl = /obj/item/rogueweapon/scabbard/sword
