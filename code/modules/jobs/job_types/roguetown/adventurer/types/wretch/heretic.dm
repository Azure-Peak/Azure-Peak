/datum/advclass/wretch/heretic
	name = "Heretic"
	tutorial = "You father your unholy cause through the most time-tested of ways: hard, heavy steel in both arms and armor."
	allowed_sexes = list(MALE, FEMALE)
	
	outfit = /datum/outfit/job/roguetown/wretch/heretic
	class_select_category = CLASS_CAT_CLERIC
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_RITUALIST, TRAIT_HEAVYARMOR)
	maximum_possible_slots = 2 //Ppl dont like heavy armor antags.
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 1,
		STATKEY_LCK = 1
	)
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
	)
	subclass_stashed_items = list(
        "Armor Plates" =  /obj/item/repair_kit/metal,
    )

	extra_context = "This subclass gain the Wound Heal miracle and the Convert Heretic spell."
	tempo_capable = FALSE

/datum/outfit/job/roguetown/wretch/heretic
	has_loadout = TRUE

/datum/outfit/job/roguetown/wretch/heretic/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You father your unholy cause through the most time-tested of ways: hard, heavy steel in both arms and armor."))
	H.set_blindness(0)
	if(H.mind)
		var/weapons = list("Longsword", "Mace", "Flail", "Battle Axe", "Billhook")
		if(!HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT)) //Remove Regular Axe BEFORE choice, is picked (so we don't mislead)
			weapons += "Steel Axe"
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Longsword")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				beltr = /obj/item/rogueweapon/scabbard/sword
				if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
					r_hand = /obj/item/rogueweapon/sword/long/psysword
				else
					r_hand = /obj/item/rogueweapon/sword/long
			if("Mace")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
				if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
					r_hand = /obj/item/rogueweapon/mace/goden/psymace
					l_hand = /obj/item/rogueweapon/scabbard/gwstrap
				else
					beltr = /obj/item/rogueweapon/mace/steel
			if("Flail")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
				if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
					beltr = /obj/item/rogueweapon/flail/sflail/psyflail
				else
					beltr = /obj/item/rogueweapon/flail/sflail
			if("Steel Axe")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
				beltr = /obj/item/rogueweapon/stoneaxe/woodcut/steel
			if("Battle Axe")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
				if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
					beltr = /obj/item/rogueweapon/stoneaxe/battle/psyaxe
				else
					beltr = /obj/item/rogueweapon/stoneaxe/battle
			if("Billhook")
				l_hand = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
				if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
					r_hand = /obj/item/rogueweapon/spear/psyspear
				else
					r_hand = /obj/item/rogueweapon/spear/billhook
		var/datum/devotion/C = new /datum/devotion(H, H.patron)
		if(istype(H.patron, /datum/patron/divine))
			C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)	//Capped to T2 miracles. Templar equivalent.
		else
			C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, start_maxed = TRUE)	//Minor regen, starts maxed out.
		wretch_select_bounty(H)

	// You can convert those the church has shunned.
	H.mind?.AddSpell(new /datum/action/cooldown/spell/convert_heretic)
	if (istype (H.patron, /datum/patron/inhumen/zizo))
		if(H.mind)
			H.mind.AddSpell(new /datum/action/cooldown/spell/minion_order)
			add_verb(H, /mob/living/carbon/human/proc/revelations)
			H.mind.AddSpell(new /datum/action/cooldown/spell/gravemark)
			H.mind?.current.faction += "[H.name]_faction"
		ADD_TRAIT(H, TRAIT_GRAVEROBBER, TRAIT_GENERIC)
	mask = /obj/item/clothing/mask/rogue/facemask/steel
	neck = /obj/item/clothing/neck/roguetown/gorget
	pants = /obj/item/clothing/under/roguetown/chainlegs
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/shield/tower/metal
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/rogueweapon/huntingknife
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/ritechalk = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
		)
/datum/outfit/job/roguetown/wretch/heretic/choose_loadout(mob/living/carbon/human/H)
	. = ..()

		// This list exists here so it can be overwritten later. This is really stupid and should probably
		// be done in the pre-equip. Too bad!
	var/helmets = list(
			"Pigface Bascinet" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
			"Guard Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard,
			"Barred Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff,
			"Bucket Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
			"Knight Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight,
			"Visored Sallet"	= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
			"Armet"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
			"Sugarloaf Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket/crusader,
			"Knight's Armet"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight,
			"Knight's Helmet"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight/old,
			"Knight's Greatplumed Armet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/greatplume,
			"Hounskull Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
			"Klappvisier Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
			"Slitted Kettle" = /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
			"Visored Barbute" = /obj/item/clothing/head/roguetown/helmet/heavy/barbute/visor,
			"Great Barbute" = /obj/item/clothing/head/roguetown/helmet/heavy/barbute/great,
			"Volfskulle Bascinet" = /obj/item/clothing/head/roguetown/helmet/heavy/volfplate,
			"None"
		)

	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy, SLOT_RING, TRUE)
			H.change_stat(STATKEY_CON, 1)
			H.change_stat(STATKEY_STR, 1)
			H.change_stat(STATKEY_PER, 1)
		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			helmets += list("Decorated Bucket Helmet" = /obj/item/clothing/head/roguetown/helmet/heavy/bucket/gold/cleric,) // This is so stupid. - Just a little, but it does look cool!
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios, SLOT_RING, TRUE)
			H.change_stat(STATKEY_WIL, 2)
			H.change_stat(STATKEY_STR, 1)
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/inhumen/baotha, SLOT_RING, TRUE)
			H.change_stat(STATKEY_INT, 1)
			H.change_stat(STATKEY_PER, 3)
		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar, SLOT_RING, TRUE)
			H.change_stat(STATKEY_STR, 2)
			H.change_stat(STATKEY_WIL, 1)
		if(/datum/patron/divine/astrata)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/astrata, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/templar/astratan, SLOT_CLOAK, TRUE)
			H.change_stat(STATKEY_INT, 2)
			H.change_stat(STATKEY_PER, 2)
			H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
			helmets += list("Old Astratan Helm" = /obj/item/clothing/head/roguetown/helmet/heavy/astratahelm)
		if(/datum/patron/divine/abyssor)
			H.change_stat(STATKEY_INT, 2)
			H.change_stat(STATKEY_PER, 2)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/abyssor, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/tabard/abyssorite, SLOT_CLOAK, TRUE)
			H.adjust_skillrank(/datum/skill/labor/fishing, 2, TRUE)
			H.grant_language(/datum/language/abyssal)
			ADD_TRAIT(H, TRAIT_WATERBREATHING, TRAIT_GENERIC)
		if(/datum/patron/divine/xylix)
			H.change_stat(STATKEY_INT, 2)
			H.change_stat(STATKEY_PER, 2)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/xylix, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/templar/xylixian, SLOT_CLOAK, TRUE)
			H.cmode_music = 'sound/music/combat_jester.ogg'
			H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/lockpicking, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/music, 1, TRUE)
		if(/datum/patron/divine/dendor)
			H.change_stat(STATKEY_INT, 2)
			H.change_stat(STATKEY_PER, 2)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/dendor, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/tabard/crusader/dendor, SLOT_CLOAK, TRUE)
			H.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg'
			H.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
		if(/datum/patron/divine/necra)
			H.change_stat(STATKEY_INT, 2)
			H.change_stat(STATKEY_PER, 2)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/necra, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/templar/necran, SLOT_CLOAK, TRUE)
			ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_SOUL_EXAMINE, TRAIT_GENERIC)
			helmets += list("Old Necran Helm" = /obj/item/clothing/head/roguetown/helmet/heavy/necrahelm)
		if(/datum/patron/divine/pestra)
			H.change_stat(STATKEY_INT, 2)
			H.change_stat(STATKEY_PER, 2)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/pestra, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/templar/pestran, SLOT_CLOAK, TRUE)
			ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_ALCHEMY_EXPERT, TRAIT_GENERIC)
			H.adjust_skillrank_up_to(/datum/skill/misc/medicine, 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, 2, TRUE)
		if(/datum/patron/divine/eora)
			H.change_stat(STATKEY_INT, 2)
			H.change_stat(STATKEY_PER, 2)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/eora, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/templar/eoran, SLOT_CLOAK, TRUE)
			ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)
			helmets += list("Old Eoran Sallet" = /obj/item/clothing/head/roguetown/helmet/sallet/eoran)
		if(/datum/patron/divine/noc)
			H.change_stat(STATKEY_INT, 2)
			H.change_stat(STATKEY_PER, 2)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/noc, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/tabard/crusader/noc, SLOT_CLOAK, TRUE)
			ADD_TRAIT(H, TRAIT_ALCHEMY_EXPERT, TRAIT_GENERIC)
			H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE) // Really good at reading... does this really do anything? No. BUT it's soulful.
			H.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE)
			H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
			H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
		if(/datum/patron/divine/ravox)
			H.change_stat(STATKEY_INT, 2)
			H.change_stat(STATKEY_PER, 2)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/ravox, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/templar/ravox, SLOT_CLOAK, TRUE)
			H.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
			H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
		if(/datum/patron/divine/malum)
			H.change_stat(STATKEY_INT, 2)
			H.change_stat(STATKEY_PER, 2)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/malum, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/templar/malumite, SLOT_CLOAK, TRUE)
			H.adjust_skillrank(/datum/skill/craft/blacksmithing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/armorsmithing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/smelting, 1, TRUE)
			H.adjust_skillrank(/datum/skill/labor/lumberjacking, 2, TRUE)
			ADD_TRAIT(H, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC)
		if(/datum/patron/divine/undivided)
			H.change_stat(STATKEY_INT, 2)
			H.change_stat(STATKEY_PER, 2)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/undivided, SLOT_RING, TRUE)
			H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
			if(H.mind) //To make it obviously not clergy related
				var/cloaks = list("Cloak", "Tabard")
				var/cloakchoice = input(H,"Choose your covering", "TAKE UP FASHION") as anything in cloaks
				switch(cloakchoice)
					if("Cloak")
						H.equip_to_slot_or_del(new /obj/item/clothing/cloak/undividedcleric, SLOT_CLOAK, TRUE)
					if("Tabard")
						H.equip_to_slot_or_del(new /obj/item/clothing/cloak/templar/undividedcleric, SLOT_CLOAK, TRUE)
		if(/datum/patron/old_god)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/silver, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ornate, SLOT_ARMOR, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq, SLOT_SHIRT, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/gloves/roguetown/chain/psydon, SLOT_GLOVES, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/roguetown/boots/psydonboots, SLOT_SHOES, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/tabard/psydontabard/black, SLOT_CLOAK, TRUE)
			H.change_stat(STATKEY_WIL, 2)
			H.change_stat(STATKEY_CON, 2)
			helmets += list("Psydonic Barbute" = /obj/item/clothing/head/roguetown/helmet/heavy/psydonbarbute,
				"Psydonic Sallet" = /obj/item/clothing/head/roguetown/helmet/heavy/psysallet,
				"Psydonic Armet" = /obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm,
				"Psydonic Bucket Helm" = /obj/item/clothing/head/roguetown/helmet/heavy/psybucket)
	if(H.mind)
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		if(helmchoice != "None")
			var/helmet = helmets[helmchoice]
			H.equip_to_slot_if_possible(new helmet, SLOT_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/cuirass, SLOT_ARMOR, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk, SLOT_SHIRT, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/roguetown/chain, SLOT_GLOVES, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/wrists/roguetown/bracers, SLOT_WRISTS, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/roguetown/boots/armor, SLOT_SHOES, TRUE)

/datum/advclass/wretch/heretic/spy
	name = "Heretic Spy"
	tutorial = "Nimble of dagger and foot both, you are the shadowy herald of the cabal. They will not see you coming."
	outfit = /datum/outfit/job/roguetown/wretch/hereticspy
	maximum_possible_slots = 2 //Ppl dont like rogue antags.
	traits_applied = list(TRAIT_RITUALIST, TRAIT_DODGEEXPERT)
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = 2,
		STATKEY_INT = 1,
		STATKEY_LCK = 1
	)
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/traps = SKILL_LEVEL_JOURNEYMAN,
	)
	subclass_stashed_items = list(
        "Sewing Kit" =  /obj/item/repair_kit,
    )
	extra_context = "This subclass gain the Wound Heal miracle and the Convert Heretic spell."
	tempo_capable = FALSE


/datum/outfit/job/roguetown/wretch/hereticspy
	has_loadout = TRUE

/datum/outfit/job/roguetown/wretch/hereticspy/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("Nimble of dagger and foot both, you are the shadowy herald of the cabal. They will not see you coming."))
	cloak = /obj/item/clothing/cloak/raincloak/mortus
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/clothing/neck/roguetown/gorget
	mask =  HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT)?/obj/item/clothing/mask/rogue/facemask/steel/confessor : /obj/item/clothing/mask/rogue/ragmask/black
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/lockpickring/mundane = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/roguebag = 1,
		/obj/item/ritechalk = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
		)
	H.cmode_music = 'sound/music/cmode/antag/combat_cutpurse.ogg'
	if(H.mind)
		var/weapons = list("Daggers", "Rapier", "Sabre", "Bow", "Crossbow", "Slurbow")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Daggers")
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
					l_hand = /obj/item/rogueweapon/huntingknife/idagger/silver/psydagger
				else if(istype(H.patron, /datum/patron/inhumen/zizo))
					l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/zizo
				else
					l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/rondel
				r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/parrying
				beltl = /obj/item/rogueweapon/scabbard/sheath
				beltr = /obj/item/rogueweapon/scabbard/sheath
			if("Rapier")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
					l_hand = /obj/item/rogueweapon/sword/rapier/psy //Fuck you it's aura
				else
					l_hand = /obj/item/rogueweapon/sword/rapier
				beltl = /obj/item/rogueweapon/scabbard/sword
			if("Sabre")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				l_hand = /obj/item/rogueweapon/sword/sabre
				beltl = /obj/item/rogueweapon/scabbard/sword
			if("Bow")
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltr = /obj/item/quiver/arrows
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				beltl = /obj/item/rogueweapon/scabbard/sheath
				if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
					l_hand = /obj/item/rogueweapon/huntingknife/idagger/silver/psydagger
				else if(istype(H.patron, /datum/patron/inhumen/zizo))
					l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/zizo
				else
					l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel
			if("Crossbow")
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_JOURNEYMAN, TRUE) //have to specifically go into bows/crossbows unlike outlaw
				beltr = /obj/item/quiver/bolt/standard
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				beltl = /obj/item/rogueweapon/scabbard/sheath
				if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
					l_hand = /obj/item/rogueweapon/huntingknife/idagger/silver/psydagger
				else if(istype(H.patron, /datum/patron/inhumen/zizo))
					l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/zizo
				else
					l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel
			if("Slurbow")
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_JOURNEYMAN, TRUE) // I think this is a very good alternative to the crossbow, given that this role involves mobile combat.
				beltr = /obj/item/quiver/bolt/light
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				beltl = /obj/item/rogueweapon/scabbard/sheath
				if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
					l_hand = /obj/item/rogueweapon/huntingknife/idagger/silver/psydagger
				else if(istype(H.patron, /datum/patron/inhumen/zizo))
					l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/zizo
				else
					l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel
		var/datum/devotion/C = new /datum/devotion(H, H.patron)
		if(istype(H.patron, /datum/patron/divine))
			C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)	//Capped to T2 miracles. Templar equivalent.
		else
			C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, start_maxed = TRUE)	//Minor regen, starts maxed out.
		wretch_select_bounty(H)

	if (istype (H.patron, /datum/patron/inhumen/zizo))
		if(H.mind)
			H.mind.AddSpell(new /datum/action/cooldown/spell/minion_order)
			H.mind.AddSpell(new /datum/action/cooldown/spell/gravemark)
			H.mind?.current.faction += "[H.name]_faction"
		ADD_TRAIT(H, TRAIT_GRAVEROBBER, TRAIT_GENERIC)
	H.mind?.AddSpell(new /datum/action/cooldown/spell/convert_heretic)

/datum/outfit/job/roguetown/wretch/hereticspy/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy, SLOT_RING, TRUE)
		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios, SLOT_RING, TRUE)
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/inhumen/baotha, SLOT_RING, TRUE)
		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar, SLOT_RING, TRUE)
		if(/datum/patron/divine/astrata)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/astrata, SLOT_RING, TRUE)
			H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
		if(/datum/patron/divine/abyssor)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/abyssor, SLOT_RING, TRUE)
			H.adjust_skillrank(/datum/skill/labor/fishing, 2, TRUE)
			H.grant_language(/datum/language/abyssal)
			ADD_TRAIT(H, TRAIT_WATERBREATHING, TRAIT_GENERIC)
		if(/datum/patron/divine/xylix)
			H.cmode_music = 'sound/music/combat_jester.ogg'
			H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/lockpicking, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/music, 1, TRUE)
		if(/datum/patron/divine/dendor)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/dendor, SLOT_RING, TRUE)
			H.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg'
			H.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
		if(/datum/patron/divine/necra)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/necra, SLOT_RING, TRUE)
			ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_SOUL_EXAMINE, TRAIT_GENERIC)
		if(/datum/patron/divine/pestra)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/pestra, SLOT_RING, TRUE)
			ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_ALCHEMY_EXPERT, TRAIT_GENERIC)
			H.adjust_skillrank_up_to(/datum/skill/misc/medicine, 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, 2, TRUE)
		if(/datum/patron/divine/eora)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/eora, SLOT_RING, TRUE)
			ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)
		if(/datum/patron/divine/noc)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/noc, SLOT_RING, TRUE)
			ADD_TRAIT(H, TRAIT_ALCHEMY_EXPERT, TRAIT_GENERIC)
			H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE) // Really good at reading... does this really do anything? No. BUT it's soulful.
			H.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE)
			H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
		if(/datum/patron/divine/ravox)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/ravox, SLOT_RING, TRUE)
			H.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
		if(/datum/patron/divine/malum)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/malum, SLOT_RING, TRUE)
			H.adjust_skillrank(/datum/skill/craft/blacksmithing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/armorsmithing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/smelting, 1, TRUE)
			H.adjust_skillrank(/datum/skill/labor/lumberjacking, 2, TRUE)
		if(/datum/patron/divine/undivided)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/undivided, SLOT_RING, TRUE)
			H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
		if(/datum/patron/old_god)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/silver, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/roguehood/psydon/confessor, SLOT_HEAD, TRUE) // You do not get the NVGs. Explode.
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/confessor, SLOT_ARMOR, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq, SLOT_SHIRT, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/gloves/roguetown/otavan/psygloves, SLOT_GLOVES, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/roguetown/boots/psydonboots, SLOT_SHOES, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan, SLOT_PANTS, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/roguetown/heavy_leather_pants, SLOT_PANTS, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat, SLOT_ARMOR, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/gambeson, SLOT_SHIRT, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/roguetown/fingerless_leather, SLOT_GLOVES, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/roguetown/boots/leather/reinforced, SLOT_SHOES, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/wrists/roguetown/bracers/leather/heavy, SLOT_WRISTS, TRUE)

/mob/living/carbon/human/proc/revelations()
	set name = "Revelations"
	set category = "RoleUnique.Cleric"
	var/obj/item/grabbing/I = get_active_held_item()
	var/mob/living/carbon/human/H
	var/obj/item/S = get_inactive_held_item()
	var/found = null
	if(!istype(I) || !ishuman(I.grabbed))
		to_chat(src, span_warning("I don't have a victim in my hands!"))
		return
	H = I.grabbed
	if(H == src)
		to_chat(src, span_warning("I already torture myself."))
		return
	if (!H.restrained())
		to_chat(src, span_warning ("My victim needs to be restrained in order to do this!"))
		return
	if(!istype(S, /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy))
		to_chat(src, span_warning("I need to be holding a zcross to extract this divination!"))
		return
	for(var/obj/structure/fluff/psycross/zizocross/N in oview(5, src))
		found = N
	if(!found)
		to_chat(src, span_warning("I need a large profane shrine structure nearby to extract this divination!"))
		return
	if(!H.stat)
		var/static/list/faith_lines = list(
			"THE TRUTH SHALL SET YOU FREE!",
			"WHO IS YOUR GOD!?",
			"ARE YOU FAITHFUL!?",
			"WHO IS YOUR SHEPHERD!?",
		)
		src.visible_message(span_warning("[src] shoves the decrepit zcross into [H]'s lux!"))
		if(HAS_TRAIT(src, TRAIT_UNFORGIVABLE))
			say(pick(faith_lines), spans = list("bloody"))//Vheslynites aren't people.
		else
			say(pick(faith_lines), spans = list("torture"))
		H.emote("agony", forced = TRUE)

		if(!(do_mob(src, H, 10 SECONDS)))
			return
		H.confess_sins("patron")
		return
	to_chat(src, span_warning("This one is not in a ready state to be questioned..."))
