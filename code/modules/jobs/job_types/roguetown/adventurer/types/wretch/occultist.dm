/datum/advclass/wretch/occultist
	name = "Occultist"
	tutorial = "Every community, even the most craven, has need of steady shields and reliable hands. You have spent \
	many a yil discreetly sequestered in the corners of society, and now emerge experienced in the arts of \
	medicine and a half-dozen other crafts, laden in maille and capable of channelling the will of your God \
	through brilliant miracles. Ensure the safety of your misbegotten flock from the world that cast them away."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/wretch/occultist
	class_select_category = CLASS_CAT_CLERIC
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_RITUALIST, TRAIT_HOMESTEAD_EXPERT, TRAIT_MEDIUMARMOR, TRAIT_EMPATH)
	maximum_possible_slots = 2

	// 7 weight, as they are a caster with a lot of utility.
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_WIL = 2,
		STATKEY_CON = 1,
		STATKEY_FOR = 1,
	)

	// These shouldn't be remarkably strong offensively, but should have a lot of miscellaneous skills.
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE
	)
	subclass_stashed_items = list(
		"Armor Plates" = /obj/item/repair_kit/metal,
	)

	extra_context = "This subclass gain the Wound Heal miracle and the Convert Heretic spell."

/datum/outfit/job/roguetown/wretch/occultist
	has_loadout = TRUE

/datum/outfit/job/roguetown/wretch/occultist/pre_equip(mob/living/carbon/human/H)
	..()
	H.set_blindness(0)
	if(H.mind)
		H.mind?.current.faction += "[H.name]_faction"
		var/weapons = list("Flanged Mace", "Flail", "Shortsword", "Warhammer", "Staff & Dagger")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)

			if("Flanged Mace")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
				if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
					r_hand = /obj/item/rogueweapon/mace/cudgel/psy
				else
					r_hand = /obj/item/rogueweapon/mace/cudgel/flanged

			if("Flail")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
				if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
					r_hand = /obj/item/rogueweapon/flail/sflail/psyflail
				else
					r_hand = /obj/item/rogueweapon/flail/sflail

			if("Shortsword")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				beltr = /obj/item/rogueweapon/scabbard/sword
				if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
					r_hand = /obj/item/rogueweapon/sword/short/psy
				else
					r_hand = /obj/item/rogueweapon/sword/short

			if("Warhammer")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/mace/warhammer/steel

			// Staves aren't all that strong, so you get a dagger too as consolation.
			if("Staff & Dagger")
				H.adjust_skillrank_up_to(/datum/skill/combat/staves, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltr = /obj/item/rogueweapon/scabbard/sheath
				l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/rondel
				if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
					r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/psy
				else
					r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/steel

		var/datum/devotion/C = new /datum/devotion(H, H.patron)
		C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, start_maxed = TRUE)
		wretch_select_bounty(H)

	// You can convert those the church has shunned.
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/convert_heretic)
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/wound_heal)

	neck = /obj/item/clothing/neck/roguetown/chaincoif/full
	pants = /obj/item/clothing/under/roguetown/chainlegs
	backl = /obj/item/storage/backpack/rogue/backpack // For carrying stuff for crafting!
	backr = /obj/item/rogueweapon/shield/tower/metal
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/rogueweapon/huntingknife
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/ritechalk = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rope/chain = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		/obj/item/needle = 1,
		/obj/item/natural/bundle/cloth/bandage/full = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		)

/datum/outfit/job/roguetown/wretch/occultist/choose_loadout(mob/living/carbon/human/H)
	. = ..()

	var/helmets = list(
			"Guard Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard,
			"Barred Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff,
			"Bucket Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
			"Visored Sallet"	= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
			"Sugarloaf Helmet"	= /obj/item/clothing/head/roguetown/helmet/heavy/bucket/crusader,
			"Slitted Kettle"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
			"Kettle Helmet"		= /obj/item/clothing/head/roguetown/helmet/kettle,
			"Visored Barbute" 	= /obj/item/clothing/head/roguetown/helmet/heavy/barbute/visor,
			"Great Barbute"		= /obj/item/clothing/head/roguetown/helmet/heavy/barbute/great,
	)

	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy, SLOT_RING, TRUE)

		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			helmets += list("Decorated Bucket Helmet" = /obj/item/clothing/head/roguetown/helmet/heavy/bucket/gold/cleric,) // This is so stupid. - Just a little, but it does look cool!
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios, SLOT_RING, TRUE)

		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/inhumen/baotha, SLOT_RING, TRUE)

		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar, SLOT_RING, TRUE)

		if(/datum/patron/divine/astrata)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/astrata, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/templar/astratan, SLOT_CLOAK, TRUE)
			H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
			// Some swordskill is innate to all Astratans, as they have a miracle which gives them one.
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.mind?.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/summonrogueweapon/astratagrasp)
			helmets += list("Old Astratan Helm" = /obj/item/clothing/head/roguetown/helmet/heavy/astratahelm)

		if(/datum/patron/divine/abyssor)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/abyssor, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/tabard/abyssortabard, SLOT_CLOAK, TRUE)
			H.adjust_skillrank(/datum/skill/labor/fishing, 2, TRUE)
			H.grant_language(/datum/language/abyssal)
			ADD_TRAIT(H, TRAIT_WATERBREATHING, TRAIT_GENERIC)

		if(/datum/patron/divine/xylix)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/xylix, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/templar/xylixian, SLOT_CLOAK, TRUE)
			H.cmode_music = 'sound/music/combat_jester.ogg'
			H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/lockpicking, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/music, 1, TRUE)
			var/datum/inspiration/I = new /datum/inspiration(H) // Ordinary templars also have it. Xylix doesn't have any special miracles for T4 anyway.
			I.grant_inspiration(H, bard_tier = BARD_T1)

		if(/datum/patron/divine/dendor)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/dendor, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/tabard/crusader/dendor, SLOT_CLOAK, TRUE)
			H.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg'
			H.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)

		if(/datum/patron/divine/necra)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/necra, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/templar/necran, SLOT_CLOAK, TRUE)
			ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_SOUL_EXAMINE, TRAIT_GENERIC)
			helmets += list("Old Necran Helm" = /obj/item/clothing/head/roguetown/helmet/heavy/necrahelm)

		if(/datum/patron/divine/pestra)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/pestra, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/templar/pestran, SLOT_CLOAK, TRUE)
			ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
			H.adjust_skillrank_up_to(/datum/skill/misc/medicine, 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, 2, TRUE)

		if(/datum/patron/divine/eora)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/eora, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/templar/eoran, SLOT_CLOAK, TRUE)
			ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)
			helmets += list("Old Eoran Sallet" = /obj/item/clothing/head/roguetown/helmet/sallet/eoran)

		if(/datum/patron/divine/noc)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/noc, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/tabard/crusader/noc, SLOT_CLOAK, TRUE)
			H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
			H.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE)
			H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
			H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
			H.mind?.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/summonrogueweapon/nocgrasp)

		if(/datum/patron/divine/ravox)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/ravox, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/templar/ravox, SLOT_CLOAK, TRUE)
			H.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
			H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
			H.mind?.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/summonrogueweapon/ravoxgrasp)

		if(/datum/patron/divine/malum)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/malum, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/templar/malumite, SLOT_CLOAK, TRUE)
			H.adjust_skillrank(/datum/skill/craft/blacksmithing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/armorsmithing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/smelting, 1, TRUE)
			ADD_TRAIT(H, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC)

		if(/datum/patron/divine/undivided)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/undivided, SLOT_RING, TRUE)
			H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
			if(H.mind)
				var/cloaks = list("Cloak", "Tabard")
				var/cloakchoice = input(H,"Choose your covering", "TAKE UP FASHION") as anything in cloaks
				switch(cloakchoice)
					if("Cloak")
						H.equip_to_slot_or_del(new /obj/item/clothing/cloak/undivided, SLOT_CLOAK, TRUE)
					if("Tabard")
						H.equip_to_slot_or_del(new /obj/item/clothing/cloak/templar/undivided, SLOT_CLOAK, TRUE)

		if(/datum/patron/old_god)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/silver, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/brigandine, SLOT_ARMOR, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq, SLOT_SHIRT, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/gloves/roguetown/chain/psydon, SLOT_GLOVES, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/roguetown/boots/psydonboots, SLOT_SHOES, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/tabard/psydontabard, SLOT_CLOAK, TRUE)
			helmets += list("Psydonic Barbute" = /obj/item/clothing/head/roguetown/helmet/heavy/psydonbarbute,
				"Psydonic Sallet" = /obj/item/clothing/head/roguetown/helmet/heavy/psysallet,
				"Psydonic Armet" = /obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm,
				"Psydonic Bucket Helm" = /obj/item/clothing/head/roguetown/helmet/heavy/psybucket)

	if(H.mind)
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		if(helmchoice != "None")
			var/helmet = helmets[helmchoice]
			H.equip_to_slot_if_possible(new helmet, SLOT_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk, SLOT_SHIRT, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/roguetown/chain, SLOT_GLOVES, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/wrists/roguetown/bracers/leather, SLOT_WRISTS, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/roguetown/boots/leather/reinforced, SLOT_SHOES, TRUE)

