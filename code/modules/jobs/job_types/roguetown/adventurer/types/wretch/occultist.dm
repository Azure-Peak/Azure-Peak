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

	// 8 weight total, 6 here and 2 according to patron. Not too high, this is a primarily utility class.
	subclass_stats = list(
		STATKEY_WIL = 2,
		STATKEY_INT = 2,
		STATKEY_CON = 1,
		STATKEY_FOR = 1,
	)

	// These shouldn't be remarkably strong offensively, but should have a lot of miscellaneous skills.
	// They receive expert skills in weapon types they select at roundstart.
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE, // Enough to make thin red tier potions. More with Pestra!
		/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN, // They're good cooks! Goes with their mess kit + stove.
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE, // Enough to make some basic leather goods.
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE, // Good at repairing clothes.
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_APPRENTICE, // Good at repairing metal, too!
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_NOVICE, // To go with their hatchet.
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/fishing = SKILL_LEVEL_NOVICE
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
	belt = /obj/item/storage/belt/rogue/leather/steel/tasset
	beltl = /obj/item/rogueweapon/huntingknife
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/ritechalk = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rope/chain = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		/obj/item/needle = 1,
		/obj/item/natural/bundle/cloth/bandage/full = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/stoneaxe/handaxe = 1, // Anti-structure utility, fits in a backpack or on the belt.
		/obj/item/natural/whetstone = 1,
		/obj/item/storage/gadget/messkit = 1, // You cook the wretch's meals.
		/obj/item/mobilestove = 1, // You use a stove to do it.
		/obj/item/folding_alchcauldron_stored = 1, // On the off-chance you want to moonlight in alchemy.
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

	H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk, SLOT_SHIRT, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/roguetown/chain, SLOT_GLOVES, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/wrists/roguetown/bracers/leather, SLOT_WRISTS, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/roguetown/boots/leather/reinforced, SLOT_SHOES, TRUE)
	// This (almost) invariably uses the generic overvestments. They look sufficiently monastic, and
	// it spares the class from being too hard to distinguish from heretic. If you want to be fully
	// decked out with unique patron gear, heretic is the shinier class of the two, play that.
	H.equip_to_slot_or_del(new /obj/item/clothing/cloak/tabard/stabard/crusader/heavy, SLOT_CLOAK, TRUE)

	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy, SLOT_RING, TRUE)
			H.change_stat(STATKEY_INT, 1)

		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			helmets += list("Decorated Bucket Helmet" = /obj/item/clothing/head/roguetown/helmet/heavy/bucket/gold/cleric,) // This is so stupid. - Just a little, but it does look cool!
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios, SLOT_RING, TRUE)
			H.change_stat(STATKEY_LCK, 1)
			H.change_stat(STATKEY_WIL, 1)

		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/inhumen/baotha, SLOT_RING, TRUE)
			H.change_stat(STATKEY_PER, 2)

		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar, SLOT_RING, TRUE)
			H.change_stat(STATKEY_STR, 1)

		if(/datum/patron/divine/astrata)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/astrata, SLOT_RING, TRUE)
			H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
			// Some swordskill is innate to all Astratans, as they have a miracle which gives them one.
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.mind?.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/summonrogueweapon/astratagrasp)
			helmets += list("Old Astratan Helm" = /obj/item/clothing/head/roguetown/helmet/heavy/astratahelm)
			H.change_stat(STATKEY_STR, 1)

		if(/datum/patron/divine/abyssor)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/abyssor, SLOT_RING, TRUE)
			H.adjust_skillrank(/datum/skill/labor/fishing, 2, TRUE)
			H.grant_language(/datum/language/abyssal)
			ADD_TRAIT(H, TRAIT_WATERBREATHING, TRAIT_GENERIC)
			H.change_stat(STATKEY_WIL, 1)
			H.change_stat(STATKEY_LCK, 1)

		if(/datum/patron/divine/xylix)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/xylix, SLOT_RING, TRUE)
			H.cmode_music = 'sound/music/combat_jester.ogg'
			H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/lockpicking, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/music, 1, TRUE)
			var/datum/inspiration/I = new /datum/inspiration(H) // Ordinary templars also have it. Xylix doesn't have any special miracles for T4 anyway.
			I.grant_inspiration(H, bard_tier = BARD_T1)
			H.change_stat(STATKEY_LCK, 2)

		if(/datum/patron/divine/dendor)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/dendor, SLOT_RING, TRUE)
			H.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg'
			H.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
			H.change_stat(STATKEY_SPD, 1) // May be a little oppressive, will have to see how it goes.

		if(/datum/patron/divine/necra)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/necra, SLOT_RING, TRUE)
			ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_SOUL_EXAMINE, TRAIT_GENERIC)
			helmets += list("Old Necran Helm" = /obj/item/clothing/head/roguetown/helmet/heavy/necrahelm)
			H.change_stat(STATKEY_WIL, 1)
			H.change_stat(STATKEY_LCK, 1)

		if(/datum/patron/divine/pestra)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/pestra, SLOT_RING, TRUE)
			ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
			H.adjust_skillrank_up_to(/datum/skill/misc/medicine, 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, 2, TRUE)
			H.change_stat(STATKEY_WIL, 2)

		if(/datum/patron/divine/eora)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/eora, SLOT_RING, TRUE)
			ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
			helmets += list("Old Eoran Sallet" = /obj/item/clothing/head/roguetown/helmet/sallet/eoran)
			H.change_stat(STATKEY_LCK, 1)
			H.change_stat(STATKEY_PER, 1)

		if(/datum/patron/divine/noc)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/noc, SLOT_RING, TRUE)
			H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
			H.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE)
			H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
			H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
			H.mind?.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/summonrogueweapon/nocgrasp)
			H.change_stat(STATKEY_INT, 2)

		if(/datum/patron/divine/ravox)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/ravox, SLOT_RING, TRUE)
			H.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
			H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
			H.mind?.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/summonrogueweapon/ravoxgrasp)
			H.change_stat(STATKEY_WIL, 1)
			H.change_stat(STATKEY_INT, 1)

		if(/datum/patron/divine/malum)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/malum, SLOT_RING, TRUE)
			H.adjust_skillrank(/datum/skill/craft/blacksmithing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/armorsmithing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/smelting, 1, TRUE)
			ADD_TRAIT(H, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC)
			H.change_stat(STATKEY_PER, 1)
			H.change_stat(STATKEY_WIL, 1)

		if(/datum/patron/divine/undivided)
			H.change_stat(STATKEY_WIL, 1)
			H.change_stat(STATKEY_INT, 1)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/undivided, SLOT_RING, TRUE)
			H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)

		// Psydon gets +1 weight, up to 9 total, by light of not having traditional miracles.
		if(/datum/patron/old_god)
			H.change_stat(STATKEY_WIL, 2)
			H.change_stat(STATKEY_CON, 1)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/silver, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/brigandine, SLOT_ARMOR, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq, SLOT_SHIRT, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/gloves/roguetown/chain/psydon, SLOT_GLOVES, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/roguetown/boots/psydonboots, SLOT_SHOES, TRUE)
			// The Psydonite tabard looks nearly identical to the generic overvestments anyway.
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

