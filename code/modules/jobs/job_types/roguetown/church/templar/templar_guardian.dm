/datum/advclass/templar/guardian
	name = "Guardian"
	tutorial = "You are heavily armoured temple guardian clad in plate. A holy knight maintaining order wherever he might be."
	outfit = /datum/outfit/job/roguetown/templar/guardian
	category_tags = list(CTAG_TEMPLAR)
	subclass_languages = list(/datum/language/grenzelhoftian)
	maximum_possible_slots = 1
	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 3,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/holy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
	)
	subclass_stashed_items = list(
		"The Verses and Acts of the Ten" = /obj/item/book/rogue/bibble,
	)
	extra_context = "This subclass gains Expert skill in their weapon of choice."

/datum/outfit/job/roguetown/templar/guardian/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/heavy/bucket
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	cloak = /obj/item/clothing/cloak/tabard/crusader/tief
	armor = /obj/item/clothing/suit/roguetown/armor/plate/silver
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	wrists = /obj/item/clothing/neck/roguetown/psicross/astrata
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	belt = /obj/item/storage/belt/rogue/leather/steel/tasset
	pants = /obj/item/clothing/under/roguetown/platelegs/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	id = /obj/item/clothing/ring/silver
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/shield/tower/holysee
	backpack_contents = list(
		/obj/item/ritechalk = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/storage/keyring/acolyte = 1
		)
	H.cmode_music = 'sound/music/cmode/church/combat_reckoning.ogg' // this is probably awful implementation. too bad!
	switch(H.patron?.type)
		if(/datum/patron/divine/undivided)
			wrists = /obj/item/clothing/neck/roguetown/psicross/undivided
			head = /obj/item/clothing/head/roguetown/helmet/heavy/undivided_alt
			if(H.mind)
				var/cloaks = list("Cloak", "Tabard")
				var/cloakchoice = input(H,"Choose your covering", "TAKE UP FASHION") as anything in cloaks
				switch(cloakchoice)
					if("Cloak")
						cloak = /obj/item/clothing/cloak/undivided
					if("Tabard")
						cloak = /obj/item/clothing/cloak/templar/undivided_alt
		if(/datum/patron/divine/astrata)
			wrists = /obj/item/clothing/neck/roguetown/psicross/astrata
			head = /obj/item/clothing/head/roguetown/helmet/heavy/astratan
			cloak = /obj/item/clothing/cloak/templar/astratan
		if(/datum/patron/divine/abyssor)
			wrists = /obj/item/clothing/neck/roguetown/psicross/abyssor
			head = /obj/item/clothing/head/roguetown/helmet/heavy/abyssorgreathelm
			cloak = /obj/item/clothing/cloak/tabard/abyssorite
		if(/datum/patron/divine/xylix)
			cloak = /obj/item/clothing/cloak/templar/xylixian
			head = /obj/item/clothing/head/roguetown/helmet/heavy/xylixhelm
			H.cmode_music = 'sound/music/combat_jester.ogg'
		if(/datum/patron/divine/dendor)
			wrists = /obj/item/clothing/neck/roguetown/psicross/dendor
			head = /obj/item/clothing/head/roguetown/helmet/heavy/dendorhelm
			cloak = /obj/item/clothing/cloak/tabard/crusader/dendor
			H.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg'
		if(/datum/patron/divine/necra)
			wrists = /obj/item/clothing/neck/roguetown/psicross/necra
			head = /obj/item/clothing/head/roguetown/helmet/heavy/necran
			cloak = /obj/item/clothing/cloak/templar/necran
		if(/datum/patron/divine/pestra)
			wrists = /obj/item/clothing/neck/roguetown/psicross/pestra
			head = /obj/item/clothing/head/roguetown/helmet/heavy/pestran
			cloak = /obj/item/clothing/cloak/templar/pestran
		if(/datum/patron/divine/eora) //Eora content from stonekeep
			wrists = /obj/item/clothing/neck/roguetown/psicross/eora
			head = /obj/item/clothing/head/roguetown/helmet/heavy/eoran
			cloak = /obj/item/clothing/cloak/templar/eoran
		if(/datum/patron/divine/noc)
			wrists = /obj/item/clothing/neck/roguetown/psicross/noc
			head = /obj/item/clothing/head/roguetown/helmet/heavy/nochelm
			cloak = /obj/item/clothing/cloak/tabard/devotee/noc
		if(/datum/patron/divine/ravox)
			wrists = /obj/item/clothing/neck/roguetown/psicross/ravox
			head = /obj/item/clothing/head/roguetown/helmet/heavy/ravoxhelm
			cloak = /obj/item/clothing/cloak/templar/ravox
			mask = /obj/item/clothing/head/roguetown/roguehood/ravoxgorget
		if(/datum/patron/divine/malum)
			wrists = /obj/item/clothing/neck/roguetown/psicross/malum
			cloak = /obj/item/clothing/cloak/templar/malumite
			head = /obj/item/clothing/head/roguetown/helmet/heavy/malum
		if(/datum/patron/old_god)
			wrists = /obj/item/clothing/neck/roguetown/psicross
			cloak = /obj/item/clothing/cloak/tabard/crusader/psydon
	// Patron dagger in satchel
	var/patron_dagger = get_templar_patron_dagger(H)
	if(patron_dagger)
		backpack_contents += patron_dagger

	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_1)	//Capped to T2 miracles with paladin devotion.
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_MIDDLE_CLASS, H, "Church Funding.")

/datum/outfit/job/roguetown/templar/guardian/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/weapons = list("Longsword","Flail","Mace","Battle Axe","Spear")
	switch(H.patron?.type)
		if(/datum/patron/divine/astrata) //Unique patron weapons, more can be added here if wanted.
			weapons += "Solar Judgement"
		if(/datum/patron/divine/undivided)
			weapons += "Decablade"
		if(/datum/patron/divine/noc)
			weapons += "Moonlight Khopesh"
			weapons += "Moonlight Kriegmesser"
		if(/datum/patron/divine/necra)
			weapons += "Swift End"
		if(/datum/patron/divine/pestra)
			weapons += "Plaguebringer Sickles"
			weapons += "Lance of Boils"
			weapons += "Cleansing Edge"
		if(/datum/patron/divine/malum)
			weapons += "Forgefiend"
			weapons += "Kargrund Maul"
		if(/datum/patron/divine/dendor)
			weapons += "Summer Scythe"
		if(/datum/patron/divine/xylix)
			weapons += "Cackle Lash"
		if(/datum/patron/divine/ravox)
			weapons += "Duel Settler"
			weapons += "Censure"
		if(/datum/patron/divine/eora)
			weapons += "The Heartstring"
		if(/datum/patron/divine/abyssor)
			weapons += "Tidecleaver"
	var/weapon_choice = input(H,"Choose your WEAPON.", "TAKE UP YOUR GOD'S ARMS") as anything in weapons
	switch(weapon_choice)
		if("Longsword")
			H.put_in_hands(new /obj/item/rogueweapon/sword/long/church(H))
			H.adjust_skillrank(/datum/skill/combat/swords, SKILL_LEVEL_NOVICE, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_L, TRUE)
		if("Spear")
			H.put_in_hands(new /obj/item/rogueweapon/spear/holysee(H))
			H.put_in_hands(new /obj/item/rogueweapon/scabbard/gwstrap(H))
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
		if("Flail")
			H.put_in_hands(new /obj/item/rogueweapon/flail/sflail(H))
			H.adjust_skillrank(/datum/skill/combat/whipsflails, SKILL_LEVEL_NOVICE, TRUE)
		if("Mace")
			H.put_in_hands(new /obj/item/rogueweapon/mace/steel(H))
			H.adjust_skillrank(/datum/skill/combat/maces, SKILL_LEVEL_NOVICE, TRUE)
		if("Battle Axe")
			H.put_in_hands(new /obj/item/rogueweapon/stoneaxe/battle(H))
			H.adjust_skillrank(/datum/skill/combat/axes, SKILL_LEVEL_NOVICE, TRUE)
		if("Decablade")
			H.put_in_hands(new /obj/item/rogueweapon/sword/long/undivided(H))
			H.adjust_skillrank(/datum/skill/combat/swords, SKILL_LEVEL_NOVICE, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_L, TRUE)
		if("Solar Judgement")
			H.put_in_hands(new /obj/item/rogueweapon/sword/long/exe/astrata(H))
			H.adjust_skillrank(/datum/skill/combat/swords, SKILL_LEVEL_NOVICE, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_L, TRUE)
		if("Moonlight Khopesh")
			H.put_in_hands(new /obj/item/rogueweapon/sword/sabre/nockhopesh(H))
			H.adjust_skillrank(/datum/skill/combat/swords, SKILL_LEVEL_NOVICE, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_L, TRUE)
		if("Moonlight Kriegmesser")
			H.put_in_hands(new /obj/item/rogueweapon/sword/long/kriegmesser/noc(H))
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_L, TRUE)
		if("Swift End")
			H.put_in_hands(new /obj/item/rogueweapon/flail/sflail/necraflail(H))
			H.adjust_skillrank(/datum/skill/combat/whipsflails, SKILL_LEVEL_NOVICE, TRUE)
		if("Plaguebringer Sickles")
			H.put_in_hands(new /obj/item/rogueweapon/huntingknife/idagger/steel/pestrasickle(H))
			H.put_in_hands(new /obj/item/rogueweapon/huntingknife/idagger/steel/pestrasickle(H))
			H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE) // actually makes them usable for the templar.
		if("Lance of Boils")
			H.put_in_hands(new /obj/item/rogueweapon/halberd/pestran(H))
			H.put_in_hands(new /obj/item/rogueweapon/scabbard/gwstrap(H))
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
		if("Cleansing Edge")
			H.put_in_hands(new /obj/item/rogueweapon/sword/long/kriegmesser/pestran(H))
			H.adjust_skillrank(/datum/skill/combat/swords, SKILL_LEVEL_NOVICE, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_L, TRUE)
		if("Forgefiend")
			H.put_in_hands(new /obj/item/rogueweapon/greatsword/grenz/flamberge/malum(H))
			H.adjust_skillrank(/datum/skill/combat/swords, SKILL_LEVEL_NOVICE, TRUE)
		if("Kargrund Maul")
			H.put_in_hands(new /obj/item/rogueweapon/mace/maul/grand/malum(H), TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/scabbard/gwstrap(H), FALSE)
			H.adjust_skillrank(/datum/skill/combat/maces, SKILL_LEVEL_NOVICE, TRUE)
		if("Summer Scythe")
			H.put_in_hands(new /obj/item/rogueweapon/halberd/bardiche/scythe(H))
			H.put_in_hands(new /obj/item/rogueweapon/scabbard/gwstrap(H))
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE) // again, needs skill to actually use the weapon
		if("Cackle Lash")
			H.put_in_hands(new /obj/item/rogueweapon/whip/xylix(H))
			H.adjust_skillrank(/datum/skill/combat/whipsflails, SKILL_LEVEL_NOVICE, TRUE)
		if("Duel Settler")
			H.put_in_hands(new /obj/item/rogueweapon/mace/goden/steel/ravox(H))
			H.adjust_skillrank(/datum/skill/combat/maces, SKILL_LEVEL_NOVICE, TRUE)
		if("Censure")
			H.put_in_hands(new /obj/item/rogueweapon/greatsword/grenz/flamberge/ravox(H), TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/scabbard/gwstrap(H), FALSE)
			H.adjust_skillrank(/datum/skill/combat/swords, SKILL_LEVEL_NOVICE, TRUE)
		if("The Heartstring")
			H.put_in_hands(new /obj/item/rogueweapon/sword/rapier/eora(H))
			H.adjust_skillrank(/datum/skill/combat/swords, SKILL_LEVEL_NOVICE, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_L, TRUE)
		if("Tidecleaver")
			H.put_in_hands(new /obj/item/rogueweapon/stoneaxe/battle/abyssoraxe(H))
			H.adjust_skillrank(/datum/skill/combat/axes, SKILL_LEVEL_NOVICE, TRUE)

	// -- Start of section for god specific bonuses --
	if(H.patron?.type == /datum/patron/divine/undivided)
		H.adjust_skillrank(/datum/skill/magic/holy, SKILL_LEVEL_NOVICE, TRUE)
	if(H.patron?.type == /datum/patron/divine/astrata)
		H.adjust_skillrank(/datum/skill/magic/holy, SKILL_LEVEL_NOVICE, TRUE)
		H.cmode_music = 'sound/music/cmode/church/combat_astrata.ogg'
	if(H.patron?.type == /datum/patron/divine/dendor)
		H.adjust_skillrank(/datum/skill/labor/farming, SKILL_LEVEL_NOVICE, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, SKILL_LEVEL_NOVICE, TRUE)
	if(H.patron?.type == /datum/patron/divine/noc)
		H.adjust_skillrank(/datum/skill/misc/reading, SKILL_LEVEL_JOURNEYMAN, TRUE) // Really good at reading... does this really do anything? No. BUT it's soulful.
		H.adjust_skillrank(/datum/skill/craft/alchemy, SKILL_LEVEL_NOVICE, TRUE)
		H.adjust_skillrank(/datum/skill/magic/arcane, SKILL_LEVEL_NOVICE, TRUE)
		ADD_TRAIT(H, TRAIT_ALCHEMY_EXPERT, TRAIT_GENERIC)
	if(H.patron?.type == /datum/patron/divine/abyssor)
		H.adjust_skillrank(/datum/skill/labor/fishing, SKILL_LEVEL_APPRENTICE, TRUE)
		H.adjust_skillrank(/datum/skill/misc/swimming, SKILL_LEVEL_NOVICE, TRUE)
		ADD_TRAIT(H, TRAIT_WATERBREATHING, TRAIT_GENERIC)
		H.grant_language(/datum/language/abyssal)
	if(H.patron?.type == /datum/patron/divine/necra)
		ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_SOUL_EXAMINE, TRAIT_GENERIC)
		H.cmode_music = 'sound/music/cmode/church/combat_necra.ogg'
	if(H.patron?.type == /datum/patron/divine/pestra)
		H.adjust_skillrank(/datum/skill/misc/medicine, SKILL_LEVEL_NOVICE, TRUE)
		H.adjust_skillrank(/datum/skill/craft/alchemy, SKILL_LEVEL_NOVICE, TRUE)
		ADD_TRAIT(H, TRAIT_ALCHEMY_EXPERT, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
	if(H.patron?.type == /datum/patron/divine/eora)
		ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)
		H.cmode_music = 'sound/music/cmode/church/combat_eora.ogg'
	if(H.patron?.type == /datum/patron/divine/malum)
		H.adjust_skillrank(/datum/skill/craft/blacksmithing, SKILL_LEVEL_NOVICE, TRUE)
		H.adjust_skillrank(/datum/skill/craft/armorsmithing, SKILL_LEVEL_NOVICE, TRUE)
		H.adjust_skillrank(/datum/skill/craft/weaponsmithing, SKILL_LEVEL_NOVICE, TRUE)
		H.adjust_skillrank(/datum/skill/craft/smelting, SKILL_LEVEL_NOVICE, TRUE)
		H.adjust_skillrank(/datum/skill/labor/lumberjacking, SKILL_LEVEL_APPRENTICE, TRUE)
	if(H.patron?.type == /datum/patron/divine/ravox)
		H.adjust_skillrank(/datum/skill/misc/athletics, SKILL_LEVEL_NOVICE, TRUE)
	if(H.patron?.type == /datum/patron/divine/xylix)
		H.adjust_skillrank(/datum/skill/misc/climbing, SKILL_LEVEL_NOVICE, TRUE)
		H.adjust_skillrank(/datum/skill/misc/lockpicking, SKILL_LEVEL_NOVICE, TRUE)
		H.adjust_skillrank(/datum/skill/misc/music, SKILL_LEVEL_NOVICE, TRUE)
	// -- End of section for god specific bonuses --
