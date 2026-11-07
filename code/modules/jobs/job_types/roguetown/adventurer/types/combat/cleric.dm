/datum/advclass/cleric
	name = "Monk"
	tutorial = "You are a wandering acolyte, versed in both miracles and martial arts. You forego the hauberk that paladins wear in favor of humbling your foes through bloodless strikes. Your satchel hangs heavy, too, with ample provisions for the pilgrimage you're upon."
	allowed_sexes = list(MALE, FEMALE)

	vampcompat = FALSE
	outfit = /datum/outfit/job/roguetown/adventurer/cleric
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)
	townie_contract_gate_exempt = TRUE
	townie_contract_gate_hide_in_list = TRUE
	class_select_category = CLASS_CAT_CLERIC
	traits_applied = list(TRAIT_CIVILIZEDBARBARIAN)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
		STATKEY_CON = 1
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
	)
	// One of you is gonna look at me and act like I am stupid. It is a form of disguise.
	// Also because the alternative is not very clean codewise.
	subclass_stashed_items = list(
		"The Verses and Acts of the Ten" = /obj/item/book/rogue/bibble,
		"The Book" = /obj/item/book/rogue/bibble/psy
	)
	extra_context = "This subclass can choose from multiple disciplines. The further your chosen discipline strays from unarmed combat, however, the greater your skills in fistfighting and wrestling will atrophy. Taking a Quarterstaff provides a minor bonus to Perception, but removes the 'Dodge Expert' trait."

/datum/outfit/job/roguetown/adventurer/cleric
	allowed_patrons = ALL_PATRONS

/datum/outfit/job/roguetown/adventurer/cleric/pre_equip(mob/living/carbon/human/H)
	..()

	// Add druidic skill for Dendor followers
	if(istype(H.patron, /datum/patron/divine/dendor))
		H.adjust_skillrank(/datum/skill/magic/druidic, SKILL_LEVEL_JOURNEYMAN, TRUE)
		to_chat(H, span_notice("As a follower of Dendor, you have innate knowledge of druidic magic."))

	to_chat(H, span_warning("You are a wandering acolyte, versed in both miracles and martial arts. You forego the hauberk that paladins wear in favor of humbling your foes through bloodless strikes. Your satchel hangs heavy, too, with ample provisions for the pilgrimage you're upon."))
	head = /obj/item/clothing/head/roguetown/headband/monk
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/monk
	pants = /obj/item/clothing/under/roguetown/tights/black
	shoes = /obj/item/clothing/shoes/roguetown/footwraps/padded
	backl = /obj/item/storage/backpack/rogue/satchel
	wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/monk
	belt = /obj/item/storage/belt/rogue/leather/rope/upgraded
	beltr = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/reagent_containers/food/snacks/rogue/meat/salami = 1,
		/obj/item/reagent_containers/food/snacks/rogue/bread = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/beer = 1, //Plays into the classic stereotype of beer-loving monks and well-stocked pilgrims.
		)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_1)	//Capped to T1 miracles. Better passive regeneration.
	if(H.mind)
		var/weapons = list("Penance - Unarmored","Pugilist","Katar","Knuckledusters","Quarterstaff")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Penance - Unarmored") // Loses Dodge Expert, gains Enduring, swaps light armor for skin armor.
				ADD_TRAIT(H, TRAIT_NOPAINSTUN, JOB_TRAIT)
				H.change_stat(STATKEY_CON, 1)
				if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
					armor = /obj/item/clothing/suit/roguetown/armor/manual/tool/needle/chest/monke //a leather armor. Sewing repair.
					shirt = /obj/item/clothing/suit/roguetown/armor/manual/tool/needle/body/monke //a gambeson.
					H.adjust_skillrank_up_to(/datum/skill/craft/sewing, SKILL_LEVEL_NOVICE, TRUE) //since enduring makes psydonic willpower redundant.
					H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_NOVICE, TRUE)
				else
					armor = /obj/item/clothing/suit/roguetown/armor/manual/meditation/chest/monk //a leather armor. Meditation repair.
					shirt = /obj/item/clothing/suit/roguetown/armor/manual/meditation/body/monk //a gambeson.
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT, TRUE)
				gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
			if("Pugilist")
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, JOB_TRAIT)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT, TRUE)
				gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
			if("Katar")
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, JOB_TRAIT)
				beltl = /obj/item/rogueweapon/katar/bronze
				gloves = /obj/item/clothing/gloves/roguetown/bandages
			if("Knuckledusters")
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, JOB_TRAIT)
				if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
					r_hand = /obj/item/clothing/gloves/roguetown/knuckles/silver/psy/old
				else
					r_hand = /obj/item/clothing/gloves/roguetown/knuckles/bronze
			if("Quarterstaff")
				H.adjust_skillrank_up_to(/datum/skill/combat/staves, SKILL_LEVEL_JOURNEYMAN, TRUE) //On par with the new Quarterstaff-centric virtue. A monk can take said-virtue if they want the best of both worlds.
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, JOB_TRAIT)
				r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/iron
				l_hand = /obj/item/rogueweapon/scabbard/gwstrap
				wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
				gloves = /obj/item/clothing/gloves/roguetown/bandages
	H.cmode_music = 'sound/music/combat_holy.ogg' // left in bc i feel like monk players want their darktide TRAIT_DODGEEXPERT
	switch(H.patron?.type)
		if(/datum/patron/old_god)
			cloak = /obj/item/clothing/cloak/tabard/psydontabard/black
			mask = /obj/item/clothing/head/roguetown/roguehood/psydon/black
		if(/datum/patron/divine/astrata)
			mask = /obj/item/clothing/head/roguetown/roguehood/astrata
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/astrata
		if(/datum/patron/divine/noc)
			mask =	/obj/item/clothing/head/roguetown/roguehood/nochood
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/noc
		if(/datum/patron/divine/abyssor)
			mask = /obj/item/clothing/head/roguetown/roguehood/abyssor_painter
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/abyssor_painter
		if(/datum/patron/divine/dendor)
			mask = /obj/item/clothing/head/roguetown/dendormask
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/dendor
		if(/datum/patron/divine/necra)
			mask = /obj/item/clothing/head/roguetown/necrahood
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/necra
		if (/datum/patron/divine/malum)
			mask = /obj/item/clothing/head/roguetown/roguehood //placeholder
			cloak = /obj/item/clothing/cloak/tabard/devotee/malum
		if (/datum/patron/divine/eora)
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/eora
			mask = /obj/item/clothing/head/roguetown/eoramask
		if (/datum/patron/divine/xylix)
			cloak = /obj/item/clothing/cloak/tabard/devotee/xylix
		if (/datum/patron/divine/undivided)
			mask = /obj/item/clothing/head/roguetown/roguehood/undividedcleric
			if(H.mind)
				var/cloaks = list("Cloak", "Tabard", "Robes")
				var/cloakchoice = input(H,"Choose your covering", "TAKE UP FASHION") as anything in cloaks
				switch(cloakchoice)
					if("Cloak")
						H.equip_to_slot_or_del(new /obj/item/clothing/cloak/undividedcleric, SLOT_CLOAK, TRUE)
					if("Tabard")
						H.equip_to_slot_or_del(new /obj/item/clothing/cloak/templar/undividedcleric, SLOT_CLOAK, TRUE)
					if("Robes")
						H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/shirt/robe/undividedcleric, SLOT_CLOAK, TRUE)
		else
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe //placeholder, anyone who doesn't have cool patron drip sprites just gets generic robes
			mask = /obj/item/clothing/head/roguetown/roguehood
	neck = apply_cleric_pre_equip(H)

/datum/advclass/cleric/paladin
	name = "Paladin"
	tutorial = "You are a holy knight, clad in maille and armed with steel. Where others of the clergy may have spent their free time studying scriptures, you devoted yourself towards fighting Psydonia's evils - a longsword in one hand, and a clenched psycross in the other."
	outfit = /datum/outfit/job/roguetown/adventurer/paladin
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
	)
	subclass_stashed_items = list(
		"The Verses and Acts of the Ten" = /obj/item/book/rogue/bibble,
		"The Book" = /obj/item/book/rogue/bibble/psy
	)
	extra_context = "This subclass can choose to take one of two bonus kits to take along: a potion of lifeblood, unique needle, and Novice skills in Medicine; or a blessed longsword that gives Journeyman skills in Swordsmanship."

/datum/outfit/job/roguetown/adventurer/paladin/pre_equip(mob/living/carbon/human/H)
	// This list exists here so it can be overwritten later.
	var/helmets = list(
		"Pigface Bascinet"	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
		"Guard Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard,
		"Barred Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff,
		"Bucket Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
		"Sugarloaf Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket/crusader,
		"Knight's Armet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight,
		"Knight's Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/old,
		"Knight's Greatplumed Armet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/greatplume,
		"Visored Sallet"	= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
		"Snouted Visored Sallet"	= /obj/item/clothing/head/roguetown/helmet/sallet/visored/snouted,
		"Armet"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
		"Snouted Armet"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/snouted,
		"Hounskull Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
		"Klappvisier Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
		"Slitted Kettle" = /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
		"Great Barbute" = /obj/item/clothing/head/roguetown/helmet/heavy/barbute/great,
		"Snouted Burgonet" = /obj/item/clothing/head/roguetown/helmet/heavy/burgonet,
		"Volfskulle Bascinet"		= /obj/item/clothing/head/roguetown/helmet/heavy/volfplate,
		"None"
	)

	to_chat(H, span_warning("You are a holy knight, clad in maille and armed with steel. Where others of the clergy may have spent their free time studying scriptures, you devoted yourself towards fighting Psydonia's evils - a longsword in one hand, and a clenched psycross in the other."))
	belt = /obj/item/storage/belt/rogue/leather
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/shield/iron
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	pants = /obj/item/clothing/under/roguetown/chainlegs
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	gloves = /obj/item/clothing/gloves/roguetown/chain
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/metal = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		)
	H.cmode_music = 'sound/music/cmode/church/combat_reckoning.ogg'

	//Armor varients here
	var/armors = list("Hauberk")
	if(H.patron?.type != /datum/patron/old_god)
		armors += list("Cuirass")
		shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	if(H.patron?.type == /datum/patron/old_god)
		armors += list("Psydonic Cuirass")
		shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq/cleric

	var/armor_choice = input(H, "Choose your MAILLE.", "STAND BEFORE THE DARKNESS.") as anything in armors //
	switch(armor_choice)
		if("Hauberk")
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
		if("Cuirass")
			armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted
		if("Psydonic Cuirass")
			armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/ornate

	//helmets and cloaks here
	switch(H.patron?.type)
		if(/datum/patron/old_god)
			cloak = /obj/item/clothing/cloak/tabard/psydontabard/black
			helmets += list(
				"Psydonic Armet" = /obj/item/clothing/head/roguetown/helmet/heavy/ornate,
				"Psydonic Bucket Helm" = /obj/item/clothing/head/roguetown/helmet/heavy/ornate/bucket,
				"Psydonic Volfskulle Bascinet" = /obj/item/clothing/head/roguetown/helmet/heavy/ornate/volfhelm,
				"Greatplumed Psydonic Armet" = /obj/item/clothing/head/roguetown/helmet/heavy/ornate/knight/greatplume)
		if(/datum/patron/divine/astrata)
			cloak = /obj/item/clothing/cloak/templar/astratancleric
			helmets += list(
				"Old Astratan Helm" = /obj/item/clothing/head/roguetown/helmet/heavy/astratahelm,
				"Astratan Plumed Helm" = /obj/item/clothing/head/roguetown/helmet/heavy/astratahelm/cleric
				)
		if(/datum/patron/divine/noc)
			cloak = /obj/item/clothing/cloak/tabard/devotee/noc
		if(/datum/patron/divine/abyssor)
			cloak = /obj/item/clothing/cloak/tabard/devotee/abyssor
		if(/datum/patron/divine/dendor)
			cloak = /obj/item/clothing/cloak/tabard/devotee/dendor
		if(/datum/patron/divine/necra)
			cloak = /obj/item/clothing/cloak/templar/necrancleric
			helmets += list("Old Necran Helm" = /obj/item/clothing/head/roguetown/helmet/heavy/necrahelm)
		if (/datum/patron/divine/malum)
			cloak = /obj/item/clothing/cloak/tabard/devotee/malum
		if (/datum/patron/divine/eora)
			cloak = /obj/item/clothing/cloak/tabard/devotee/eora
			helmets += list("Old Eoran Sallet" = /obj/item/clothing/head/roguetown/helmet/sallet/eoran)
		if (/datum/patron/divine/ravox)
			cloak = /obj/item/clothing/cloak/templar/ravoxcleric
			helmets += list("Ravox Helmet" = /obj/item/clothing/head/roguetown/helmet/heavy/ravoxhelm/cleric)
		if (/datum/patron/divine/xylix)
			cloak = /obj/item/clothing/cloak/tabard/devotee/xylix
		if (/datum/patron/divine/pestra)
			cloak = /obj/item/clothing/cloak/tabard/devotee/pestra
		else
			cloak = /obj/item/clothing/cloak/tabard/stabard/crusader/undivided
			helmets += list("Decorated Sugarloaf Helmet" = /obj/item/clothing/head/roguetown/helmet/heavy/bucket/crusader/gold/cleric)
	H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/knight]
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1)	//Capped to T1 miracles.
	if(H.mind)
		// HELM CHOICE.
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]
		// WEAPON CHOICE.
		var/weapons = list("Arming Sword","Longsword","Broadsword","Mace","Flail","Flail, Studded","Whip","Spear","Axe")
		var/weapon_choice = input(H, "Choose your WEAPON.", "TAKE UP YOUR GOD'S ARMS.") as anything in weapons
		switch(weapon_choice)
			if("Arming Sword")
				beltr = /obj/item/rogueweapon/sword
				r_hand = /obj/item/rogueweapon/scabbard/sword
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if("Longsword")
				if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
					beltr = /obj/item/rogueweapon/sword/long/oldpsysword
				else
					beltr = /obj/item/rogueweapon/sword/long
				r_hand = /obj/item/rogueweapon/scabbard/sword
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if("Broadsword")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/scabbard/sword
				beltr = /obj/item/rogueweapon/sword/long/broadsword
			if("Mace")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
				if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
					beltr = /obj/item/rogueweapon/mace/cudgel/psy/old
				else
					beltr = /obj/item/rogueweapon/mace
			if("Flail")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltr = /obj/item/rogueweapon/flail
			if("Flail, Studded")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltr = /obj/item/rogueweapon/flail/alt
			if("Whip")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltr = /obj/item/rogueweapon/whip
			if("Spear")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
					r_hand = /obj/item/rogueweapon/spear/silver/psy/old
				else
					r_hand = /obj/item/rogueweapon/spear
			if("Axe")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/stoneaxe/woodcut
		var/oaths = list("Cleric - Medicine Training + Supplies","Crusader - Anointed Weapon","None")
		var/oath_choice = input(H, "Choose your OATH.", "PROFESS YOUR BLESSINGS.") as anything in oaths
		switch(oath_choice)
			if("Cleric - Medicine Training + Supplies")
				H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_APPRENTICE, TRUE)
				l_hand = /obj/item/needle/thorn/cleric //Unique to the Cleric. Far worse than a traditional iron needle, but better than a regular thorn needle - with 10 uses, instead of 5 (or 20, in the former's case).
				beltl = /obj/item/reagent_containers/glass/bottle/rogue/healthpot //No cloth, but a basic potion of lifeblood - similar to the Sorcerer's manna potion. Take the 'Physician's Apprentice' virtue for that, uncapped skills, and more.
			if("Crusader - Anointed Weapon")
				var/silver = list("Anointed Dagger","Anointed Longsword","Anointed Mace","Anointed Morningstar","Anointed Whip","Anointed War Axe","Anointed Spear")
				var/silver_choice = input(H, "Choose your ARM.", "STAND AGAINST PERDITION.") as anything in silver //Trimmed down from the exorcist's usual list, only one option of each weapon-type.
				switch(silver_choice)
					if("Anointed Dagger")
						H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
						l_hand = /obj/item/rogueweapon/huntingknife/idagger/cleric
					if("Anointed Longsword")
						H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
						l_hand = /obj/item/rogueweapon/sword/long/cleric
					if("Anointed Mace")
						H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
						l_hand = /obj/item/rogueweapon/mace/cleric
					if("Anointed Morningstar")
						H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
						l_hand = /obj/item/rogueweapon/flail/cleric
					if("Anointed Whip")
						H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
						l_hand = /obj/item/rogueweapon/whip/cleric
					if("Anointed War Axe")
						H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
						l_hand = /obj/item/rogueweapon/stoneaxe/woodcut/cleric
					if("Anointed Spear")
						H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
						l_hand = /obj/item/rogueweapon/spear/cleric
			if("None")
				id = /obj/item/clothing/ring/silver/cleric //Minor restoration of the old silver ring that Clerics could get. Worth less than the other two alternatives, but offers a choice for those who want to remain unspecialized.

	H.set_blindness(0)
	wrists = apply_cleric_pre_equip(H)

/datum/advclass/cleric/cantor
	name = "Cantor"
	tutorial = "You were a bard once - but you've found a new calling. Your eyes have been opened to the divine, now you wander from city to city singing songs and telling tales of your patron's greatness."
	outfit = /datum/outfit/job/roguetown/adventurer/cantor
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_EMPATH)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 2,
	)
	subclass_skills = list(
		/datum/skill/misc/music = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
	)
	subclass_stashed_items = list(
		"The Verses and Acts of the Ten" = /obj/item/book/rogue/bibble,
		"The Book" = /obj/item/book/rogue/bibble/psy
	)
	extra_context = "This subclass has two choice: You can choose T2 miracles or Bardic Inspirations. Taking songs lower your miracles to T1."

/datum/outfit/job/roguetown/adventurer/cantor/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You were a bard once - but you've found a new calling. Your eyes have been opened to the divine, now you wander from city to city singing songs and telling tales of your patron's greatness."))
	head = /obj/item/clothing/head/roguetown/bardhat
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest
	backl = /obj/item/storage/backpack/rogue/satchel
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/iron
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel/special
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	var/is_bard = FALSE
	if(H.mind)
		var/callings = list("Devotion","Inspiration")
		var/calling_choice = input(H, "Devote yourself wholly to your patron, or take up the bard's songs? You cannot walk both paths.", "YOUR CALLING") as anything in callings
		is_bard = (calling_choice == "Inspiration")
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	if(is_bard)
		C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1)
		var/datum/inspiration/I = new /datum/inspiration(H)
		I.grant_inspiration(H, bard_tier = BARD_T1)
		H.mind?.AddSpell(new /datum/action/cooldown/spell/projectile/vicious_mockery)
	else
		C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_2)
		if (istype (H.patron, /datum/patron/inhumen/zizo))
			if(H.mind)
				H.mind.AddSpell(new /datum/action/cooldown/spell/minion_order)
				H.mind.AddSpell(new /datum/action/cooldown/spell/minion_mark)
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	H.cmode_music = 'sound/music/cmode/church/combat_reckoning.ogg'
	switch(H.patron?.type)
		if(/datum/patron/old_god)
			if(H.mind)
				var/cloaks = list("Robe", "Tabard")
				var/cloakchoice = input(H,"Choose your covering", "DON THY VESTAMENTS") as anything in cloaks
				switch(cloakchoice)
					if("Robe")
						H.equip_to_slot_or_del(new /obj/item/clothing/cloak/absolutionistrobe/black, SLOT_CLOAK, TRUE)
					if("Tabard")
						H.equip_to_slot_or_del(new /obj/item/clothing/cloak/tabard/psydontabard/black, SLOT_CLOAK, TRUE)
		if(/datum/patron/divine/astrata)
			cloak = /obj/item/clothing/cloak/templar/astratancleric
		if(/datum/patron/divine/noc)
			cloak = /obj/item/clothing/cloak/tabard/devotee/noc
		if(/datum/patron/divine/abyssor)
			cloak = /obj/item/clothing/cloak/tabard/devotee/abyssor
		if(/datum/patron/divine/dendor)
			cloak = /obj/item/clothing/cloak/tabard/devotee/dendor
		if(/datum/patron/divine/necra)
			cloak = /obj/item/clothing/cloak/templar/necrancleric
		if (/datum/patron/divine/malum)
			cloak = /obj/item/clothing/cloak/tabard/devotee/malum
		if (/datum/patron/divine/eora)
			cloak = /obj/item/clothing/cloak/tabard/devotee/eora
		if (/datum/patron/divine/ravox)
			cloak = /obj/item/clothing/cloak/templar/ravoxcleric
		if (/datum/patron/divine/xylix)
			cloak = /obj/item/clothing/cloak/tabard/devotee/xylix
		if (/datum/patron/divine/pestra)
			cloak = /obj/item/clothing/cloak/tabard/devotee/pestra
		if (/datum/patron/divine/undivided)
			if(H.mind)
				var/cloaks = list("Cloak", "Tabard")
				var/cloakchoice = input(H,"Choose your covering", "TAKE UP FASHION") as anything in cloaks
				switch(cloakchoice)
					if("Cloak")
						H.equip_to_slot_or_del(new /obj/item/clothing/cloak/undividedcleric, SLOT_CLOAK, TRUE)
					if("Tabard")
						H.equip_to_slot_or_del(new /obj/item/clothing/cloak/templar/undividedcleric, SLOT_CLOAK, TRUE)
		else
			cloak = /obj/item/clothing/cloak/cape/crusader
	H.set_blindness(0)
	if(H.mind)
		var/instruments = list("Harp","Lute","Accordion","Guitar","Hurdy-Gurdy","Viola","Vocal Talisman", "Psyaltery", "Flute", "Drum", "Shamisen")
		var/instrument_choice = tgui_input_list(H, "Choose your instrument.", "TAKE UP ARMS", instruments)
		switch(instrument_choice)
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
			if("Psyaltery")
				backr = /obj/item/rogue/instrument/psyaltery
			if("Flute")
				backr = /obj/item/rogue/instrument/flute
			if("Drum")
				backr = /obj/item/rogue/instrument/drum
			if("Shamisen")
				backr = /obj/item/rogue/instrument/shamisen
	neck = apply_cleric_pre_equip(H)

/datum/advclass/cleric/missionary
	name = "Missionary"
	tutorial = "You are a devout worshipper of the divine with a strong connection to your patron god. You've spent years studying scriptures and serving your deity - now you wander into foreign lands, spreading the word of your faith."
	outfit = /datum/outfit/job/roguetown/adventurer/missionary
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN, //always better than cleric oathed paladin
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
	)
	subclass_stashed_items = list(
		"The Verses and Acts of the Ten" = /obj/item/book/rogue/bibble,
		"The Book" = /obj/item/book/rogue/bibble/psy
	)
	extra_context = "This subclass has access to T3 miracles, but is weak in martial combat."

/datum/outfit/job/roguetown/adventurer/missionary/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are a devout worshipper of the divine with a strong connection to your patron god. You've spent years studying scriptures and serving your deity - now you wander into foreign lands, spreading the word of your faith."))
	backl = /obj/item/storage/backpack/rogue/satchel
	pants = /obj/item/clothing/under/roguetown/trou/leather
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/needle/thorn/cleric = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		)
	H.cmode_music = 'sound/music/cmode/church/combat_acolyte.ogg' // our cleric pre_equip handles cmode music
	switch(H.patron?.type)
		if(/datum/patron/old_god)
			head = /obj/item/clothing/head/roguetown/roguehood/psydon/black
			shoes = /obj/item/clothing/shoes/roguetown/sandals/toga
			belt = /obj/item/storage/belt/rogue/leather/rope/upgraded/dark
			shirt = /obj/item/clothing/suit/roguetown/armor/vestments_padded
			if(H.mind)
				var/cloaks = list("Robe + Tabard", "Robe", "Tabard")
				var/cloakchoice = input(H,"Choose your covering", "DON THY VESTAMENTS") as anything in cloaks
				switch(cloakchoice)
					if("Robe + Tabard")
						H.equip_to_slot_or_del(new /obj/item/clothing/cloak/absolutionistrobe/black, SLOT_CLOAK, TRUE)
						H.equip_to_slot_or_del(new /obj/item/clothing/cloak/tabard/psydontabard/black, SLOT_ARMOR, TRUE) //it looks nicer layered this way and stands out from cantor more
					if("Robe")
						H.equip_to_slot_or_del(new /obj/item/clothing/cloak/absolutionistrobe/black, SLOT_CLOAK, TRUE) //OG choice
					if("Tabard")
						H.equip_to_slot_or_del(new /obj/item/clothing/cloak/tabard/psydontabard/black, SLOT_CLOAK, TRUE) //OG choice
		if(/datum/patron/divine/undivided)
			head = /obj/item/clothing/head/roguetown/roguehood/undividedcleric
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/undividedcleric //Only exclusion cause it looks bad without the cloak over it
			shoes = /obj/item/clothing/shoes/roguetown/sandals
			belt = /obj/item/storage/belt/rogue/leather/rope/upgraded
			shirt = /obj/item/clothing/suit/roguetown/armor/vestments_padded
			if(H.mind)
				var/cloaks = list("Cloak", "Tabard")
				var/cloakchoice = input(H,"Choose your covering", "TAKE UP FASHION") as anything in cloaks
				switch(cloakchoice)
					if("Cloak")
						H.equip_to_slot_or_del(new /obj/item/clothing/cloak/undividedcleric, SLOT_CLOAK, TRUE)
					if("Tabard")
						H.equip_to_slot_or_del(new /obj/item/clothing/cloak/templar/undividedcleric, SLOT_CLOAK, TRUE)
			H.adjust_skillrank(/datum/skill/magic/holy, SKILL_LEVEL_NOVICE, TRUE)
			ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
		if(/datum/patron/divine/astrata)
			head = /obj/item/clothing/head/roguetown/roguehood/astrata
			cloak = /obj/item/clothing/cloak/templar/astratancleric
			shoes = /obj/item/clothing/shoes/roguetown/sandals
			belt = /obj/item/storage/belt/rogue/leather/rope/upgraded
			H.adjust_skillrank(/datum/skill/magic/holy, SKILL_LEVEL_NOVICE, TRUE)
			ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
			shirt = /obj/item/clothing/suit/roguetown/armor/vestments_padded
		if(/datum/patron/divine/noc)
			head = /obj/item/clothing/head/roguetown/roguehood/white
			mask = /obj/item/clothing/mask/rogue/facemask/steel/visor/cleric //trust the plan, see the reference, know the vision.
			cloak = /obj/item/clothing/cloak/tabard/devotee/noc
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/lunar
			wrists = /obj/item/clothing/wrists/roguetown/nocwrappings
			shirt = /obj/item/clothing/suit/roguetown/armor/vestments_padded
			shoes = /obj/item/clothing/shoes/roguetown/sandals
			belt = /obj/item/storage/belt/rogue/leather/rope/upgraded
			H.adjust_skillrank(/datum/skill/misc/reading, SKILL_LEVEL_JOURNEYMAN, TRUE) // Really good at reading... does this really do anything? No. BUT it's soulful.
			H.adjust_skillrank(/datum/skill/craft/alchemy, SKILL_LEVEL_APPRENTICE, TRUE)
			ADD_TRAIT(H, TRAIT_ALCHEMY_EXPERT, TRAIT_GENERIC) // we keep this one since adventuring cleric doesnt get it like the regular acolyte.
			H.adjust_skillrank(/datum/skill/magic/arcane, SKILL_LEVEL_APPRENTICE, TRUE) // for their arcane spells, very little CDR and cast speed.
			if(H.mind)
				H.mind.AddSpell(new /datum/action/cooldown/spell/touch/prestidigitation)
			ADD_TRAIT(H, TRAIT_ARCYNE, TRAIT_GENERIC) // So that they can take arcyne potential and not break.
		if(/datum/patron/divine/abyssor)
			head = /obj/item/clothing/head/roguetown/roguehood/abyssor_painter
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/abyssor_painter
			shoes = /obj/item/clothing/shoes/roguetown/sandals
			belt = /obj/item/storage/belt/rogue/leather/rope/upgraded
			shirt = /obj/item/clothing/suit/roguetown/armor/vestments_padded
			l_hand = /obj/item/abyssal_marker/tidal
			H.adjust_skillrank(/datum/skill/labor/fishing, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank(/datum/skill/misc/swimming, SKILL_LEVEL_JOURNEYMAN, TRUE)
			ADD_TRAIT(H, TRAIT_WATERBREATHING, TRAIT_GENERIC)
			H.grant_language(/datum/language/abyssal)
		if(/datum/patron/divine/dendor)
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/dendor
			wrists = /obj/item/clothing/wrists/roguetown/wrappings
			shoes = /obj/item/clothing/shoes/roguetown/sandals //So you can't grief them with shards at spawn
			shirt = /obj/item/clothing/suit/roguetown/armor/vestments_padded
			belt = /obj/item/storage/belt/rogue/leather/rope/upgraded
			H.adjust_skillrank(/datum/skill/labor/farming, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/climbing, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank(/datum/skill/misc/hunting, SKILL_LEVEL_NOVICE, TRUE)
			ADD_TRAIT(H, TRAIT_EXPERT_HUNTER, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_OUTDOORSMAN, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_SEEDKNOW, TRAIT_GENERIC) //no free woodwalker, no.

			var/helms = list("Briar Mask (Classic)","Saiga Skull","Antler Hood")
			var/helm_choice = input(H, "Choose your HEADWEAR.", "DENDOR. FATHER. SPIRIT-GUIDE.") as anything in helms
			switch(helm_choice)
				if("Briar Mask (Classic)")
					head = /obj/item/clothing/head/roguetown/dendormask
				if("Saiga Skull")
					head = /obj/item/clothing/head/roguetown/helmet/leather/saiga/druid
				if("Antler Hood")
					head = /obj/item/clothing/head/roguetown/antlerhood

		if(/datum/patron/divine/necra)
			head = /obj/item/clothing/head/roguetown/necrahood
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/necra
			cloak = /obj/item/clothing/cloak/raincloak/mortus //cheaper look than the flowy cloak and robes of the See's Necrans
			shoes = /obj/item/clothing/shoes/roguetown/boots
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light/dark //looks better
			belt = /obj/item/storage/belt/rogue/leather/rope/upgraded/dark
			ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_SOUL_EXAMINE, TRAIT_GENERIC)
			H.adjust_skillrank(/datum/skill/misc/athletics, SKILL_LEVEL_APPRENTICE, TRUE) // digging graves and carrying bodies builds muscles probably.
			backpack_contents += list(
		/obj/item/burial_shroud = 1,
		)
			var/list/necra_tools = list("Shovel", "Scythe")
			var/tool_choice = input(H, "A reaper, or a digger?", "HOW WILL YOU APPEASE THE UNDERMAIDEN?") as anything in necra_tools
			switch(tool_choice) // choose wisely... larp or effectiveness?
				if("Shovel")
					l_hand = /obj/item/rogueweapon/shovel
				if("Scythe") // o lawd we farmin
					backr = /obj/item/rogueweapon/scabbard/gwstrap
					l_hand = /obj/item/rogueweapon/scythe
		if (/datum/patron/divine/malum)
			head = /obj/item/clothing/head/roguetown/roguehood //placeholder
			wrists = /obj/item/clothing/wrists/roguetown/wrappings
			cloak = /obj/item/clothing/cloak/tabard/devotee/malum
			shoes = /obj/item/clothing/shoes/roguetown/sandals
			belt = /obj/item/storage/belt/rogue/leather/rope/upgraded
			shirt = /obj/item/clothing/suit/roguetown/armor/vestments_padded
			ADD_TRAIT(H, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC)
			H.adjust_skillrank(/datum/skill/craft/blacksmithing, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank(/datum/skill/craft/armorsmithing, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank(/datum/skill/craft/weaponsmithing, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank(/datum/skill/craft/smelting, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank(/datum/skill/labor/lumberjacking, SKILL_LEVEL_APPRENTICE, TRUE)
		if (/datum/patron/divine/eora)
			backpack_contents[/obj/item/clothing/head/roguetown/eoramask] = 1
			backpack_contents[/obj/item/reagent_containers/eoran_seed] = 1
			l_hand = /obj/item/rogueweapon/huntingknife/scissors
			shoes = /obj/item/clothing/shoes/roguetown/sandals
			belt = /obj/item/storage/belt/rogue/leather/rope/upgraded
			shirt = /obj/item/clothing/suit/roguetown/armor/vestments_padded
			ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)
			// 90% of eorans i see are farming to tend to their tree and/or cooking. they also get sewing -- arts and crafts.
			H.adjust_skillrank(/datum/skill/craft/sewing, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank(/datum/skill/labor/farming, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank(/datum/skill/craft/cooking, SKILL_LEVEL_APPRENTICE, TRUE)
			var/robes = list("Modest","Exposed")
			var/robe_choice = input(H, "Choose your ROBES.", "TAKE UP ROBES.") as anything in robes
			switch(robe_choice) // This feels wrong to do but I am unsure how else to do it
				if("Modest")
					cloak = /obj/item/clothing/suit/roguetown/shirt/robe/eora
				if("Exposed")
					cloak = /obj/item/clothing/suit/roguetown/shirt/robe/eora/alt
		if (/datum/patron/divine/xylix) //we need more Xylix stuff for advs, this fit is horrible
			head = /obj/item/clothing/head/roguetown/roguehood/white
			mask = /obj/item/clothing/mask/rogue/xylixmask
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/white
			wrists = /obj/item/clothing/wrists/roguetown/wrappings
			cloak = /obj/item/clothing/cloak/tabard/devotee/xylix
			shoes = /obj/item/clothing/shoes/roguetown/sandals
			belt = /obj/item/storage/belt/rogue/leather/rope/upgraded
			shirt = /obj/item/clothing/suit/roguetown/armor/vestments_padded
			H.adjust_skillrank_up_to(/datum/skill/misc/climbing, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank(/datum/skill/misc/lockpicking, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/music, SKILL_LEVEL_EXPERT, TRUE)
			H.cmode_music = 'sound/music/combat_jester.ogg'
			var/datum/inspiration/I = new /datum/inspiration(H)
			I.grant_inspiration(H, bard_tier = BARD_T2) //(NGL Xylix needs better high-end miracles vs clutching off this system, until then, untouched)
			if(H.mind)
				var/instruments = list("Harp","Lute","Accordion","Guitar","Hurdy-Gurdy","Viola","Vocal Talisman", "Psyaltery", "Flute", "Drum", "Shamisen")
				var/instrument_choice = tgui_input_list(H, "Choose your instrument.", "TAKE UP ARMS", instruments)
				H.set_blindness(0)
				switch(instrument_choice)
					if("Harp")
						l_hand = /obj/item/rogue/instrument/harp
					if("Lute")
						l_hand = /obj/item/rogue/instrument/lute
					if("Accordion")
						l_hand = /obj/item/rogue/instrument/accord
					if("Guitar")
						l_hand = /obj/item/rogue/instrument/guitar
					if("Hurdy-Gurdy")
						l_hand = /obj/item/rogue/instrument/hurdygurdy
					if("Viola")
						l_hand = /obj/item/rogue/instrument/viola
					if("Vocal Talisman")
						l_hand = /obj/item/rogue/instrument/vocals
					if("Psyaltery")
						l_hand = /obj/item/rogue/instrument/psyaltery
					if("Flute")
						l_hand = /obj/item/rogue/instrument/flute
					if("Drum")
						l_hand = /obj/item/rogue/instrument/drum
					if("Shamisen")
						l_hand = /obj/item/rogue/instrument/shamisen
		if (/datum/patron/divine/pestra)
			head = /obj/item/clothing/head/roguetown/roguehood/black
			cloak = /obj/item/clothing/cloak/tabard/devotee/pestra
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/phys
			gloves = /obj/item/clothing/gloves/roguetown/angle/phys/cleric
			shoes = /obj/item/clothing/shoes/roguetown/boots
			belt = /obj/item/storage/belt/rogue/leather/black
			shirt = /obj/item/clothing/suit/roguetown/armor/vestments_padded
			H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, SKILL_LEVEL_JOURNEYMAN, TRUE)
			ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
		if (/datum/patron/divine/ravox)
			head = /obj/item/clothing/head/roguetown/roguehood/ravox
			cloak = /obj/item/clothing/cloak/templar/ravoxcleric
			belt = /obj/item/storage/belt/rogue/leather/rope/upgraded
			shoes = /obj/item/clothing/shoes/roguetown/gladiator //ARE YOU NOT ENTERTAINED?!!
			shirt = /obj/item/clothing/suit/roguetown/armor/vestments_padded
			H.adjust_skillrank(/datum/skill/misc/athletics, SKILL_LEVEL_JOURNEYMAN, TRUE)
			ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
		if(/datum/patron/inhumen/zizo)
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/black //evil ass cultist mage look
			head = /obj/item/clothing/head/roguetown/roguehood/black
			shoes = /obj/item/clothing/shoes/roguetown/boots
			belt = /obj/item/storage/belt/rogue/leather/rope/upgraded/dark
			shirt = /obj/item/clothing/suit/roguetown/armor/vestments_padded
			H.mind?.AddSpell(new /datum/action/cooldown/spell/minion_order)
			H.mind?.AddSpell(new /datum/action/cooldown/spell/minion_mark)
		if(/datum/patron/inhumen/graggar)
			shoes = /obj/item/clothing/shoes/roguetown/boots/furlinedboots //tribal-esc shaman look
			gloves = /obj/item/clothing/gloves/roguetown/angle/gronnfur/cleric //role-unique
			belt = /obj/item/storage/belt/rogue/leather/rope/upgraded/dark
			shirt = /obj/item/clothing/suit/roguetown/armor/vestments_padded
			cloak = /obj/item/clothing/cloak/raincloak/furcloak/brown

			var/helms = list("Skull Mask + Hood (Classic)","Saiga Skull","Antler Hood")
			var/helm_choice = input(H, "Choose your HEADWEAR.", "SHATTER YOUR BINDS.") as anything in helms
			switch(helm_choice) //like dendor, consider these as "lesser trophies" and asimilar of a shaman
				if("Skull Mask + Hood (Classic)")
					head = /obj/item/clothing/head/roguetown/roguehood/black
					mask = /obj/item/clothing/mask/rogue/skullmask
				if("Saiga Skull")
					head = /obj/item/clothing/head/roguetown/helmet/leather/saiga/druid
				if("Antler Hood")
					head = /obj/item/clothing/head/roguetown/antlerhood
		else
			belt = /obj/item/storage/belt/rogue/leather/rope/upgraded
			shoes = /obj/item/clothing/shoes/roguetown/sandals
			armor = /obj/item/clothing/suit/roguetown/shirt/robe //placeholder, anyone who doesn't have cool patron drip sprites just gets generic robes
			head = /obj/item/clothing/head/roguetown/roguehood
			shirt = /obj/item/clothing/suit/roguetown/armor/vestments_padded
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T3, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_3)	//Minor regen, capped to T3, parity with other Holy and/or Arcyne caster - no others spend 15 minutes idling only to unlock their entire potencial.
	if(H.mind)
		var/weapons = list("Woodstaff", "Quarterstaff")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Woodstaff")
				r_hand = /obj/item/rogueweapon/woodstaff
			if("Quarterstaff")
				r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/iron
	if(istype(H.patron, /datum/patron/divine))
		H.mind?.AddSpell(new /datum/action/cooldown/spell/projectile/divine_blast)
	if(istype(H.patron, /datum/patron/inhumen))
		H.mind?.AddSpell(new /datum/action/cooldown/spell/projectile/unholy_blast)
	if(istype(H.patron, /datum/patron/old_god))
		H.mind?.AddSpell(new /datum/action/cooldown/spell/psydon/enduring_blast) //99% rock chance, 1% boulder, hilarious.
	neck = apply_cleric_pre_equip(H)
	if(istype(H.patron, /datum/patron/divine/dendor)) // ONLY missionary gets this, its meant to be a limited language.
		H.grant_language (/datum/language/beast)

	beltr = /obj/item/flashlight/flare/torch/lantern //post-belt application we put this onto your hip


/datum/advclass/cleric/zealot
	name = "Zealot"
	tutorial = "A fervent servant of the divine, devoted to the mastery of miracles and the art of war. You forsake armor and the safety of evasion, offering your body and soul to the fires of battle. Every wound you suffer is a testament to your faith, and every blow you strike, a lesson to the unbelievers. You shall make your faith known, through holy words or the might of your arms."
	outfit = /datum/outfit/job/roguetown/adventurer/cleric/zealot
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT, TRAIT_NOPAINSTUN, TRAIT_BLOOD_RESISTANCE)
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)
	townie_contract_gate_exempt = TRUE
	townie_contract_gate_hide_in_list = TRUE
	class_select_category = CLASS_CAT_CLERIC
	subclass_stats = list(
		STATKEY_WIL = 4,
		STATKEY_SPD = 2,
		STATKEY_LCK = 1,
	)
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
	)
	extra_context = "Zealots start with a skill that allows them to perform a god-based war cry that further emboldens themselves and all allies of the same clerical faction."

/datum/outfit/job/roguetown/adventurer/cleric/zealot
	allowed_patrons = ALL_PATRONS

/datum/outfit/job/roguetown/adventurer/cleric/zealot/pre_equip(mob/living/carbon/human/H)
	head = /obj/item/clothing/head/roguetown/headband/monk
	armor = /obj/item/clothing/suit/roguetown/armor/vestments_padded
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	belt = /obj/item/storage/belt/rogue/leather/rope/upgraded
	backl = /obj/item/storage/backpack/rogue/satchel
	beltr = /obj/item/flashlight/flare/torch/lantern
	neck = /obj/item/clothing/neck/roguetown/gorget
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/book/rogue/bibble = 1,
		/obj/item/book/rogue/bibble/psy = 1,
	)

	if(istype(H.patron, /datum/patron/divine/dendor))
		H.adjust_skillrank_up_to(/datum/skill/magic/druidic, SKILL_LEVEL_JOURNEYMAN, TRUE)

	H.mind?.AddSpell(new /datum/action/cooldown/spell/sacrifice)
	H.mind?.AddSpell(new /datum/action/cooldown/spell/preach)

	var/miracle_tier = CLERIC_T2
	var/weapon_rank = SKILL_LEVEL_JOURNEYMAN

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = miracle_tier, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_1)

	var/list/weapon_options = list(
		"Sword" = list(/datum/skill/combat/swords, /obj/item/rogueweapon/sword/iron),
		"Greatswords" = list(/datum/skill/combat/swords, /obj/item/rogueweapon/greatsword/iron, /obj/item/rogueweapon/scabbard/gwstrap),
		"Axes" = list(/datum/skill/combat/axes, /obj/item/rogueweapon/stoneaxe/woodcut),
		"Maces" = list(/datum/skill/combat/maces, /obj/item/rogueweapon/mace),
		"Knives" = list(/datum/skill/combat/knives, /obj/item/rogueweapon/huntingknife/combat),
		"Polearms" = list(/datum/skill/combat/polearms, /obj/item/rogueweapon/spear, /obj/item/rogueweapon/scabbard/gwstrap),
		"Whips" = list(/datum/skill/combat/whipsflails, /obj/item/rogueweapon/whip),
		"Quarterstaves" = list(/datum/skill/combat/staves, /obj/item/rogueweapon/woodstaff/quarterstaff/iron),
	)

	var/weapon_choice = tgui_input_list(H, "Choose a weapon discipline.", "TAKE UP ARMS", weapon_options)
	if(weapon_choice)
		var/list/selected_weapon = weapon_options[weapon_choice]
		H.adjust_skillrank_up_to(selected_weapon[1], weapon_rank, TRUE)

		for(var/i in 2 to length(selected_weapon))
			var/obj/item/weapon = selected_weapon[i]
			H.mind?.special_items[capitalize(initial(weapon.name))] = weapon

		to_chat(H, "Weapon added to your STASH!")

	H.cmode_music = 'sound/music/combat_holy.ogg'
	id = apply_cleric_pre_equip(H)

/datum/action/cooldown/spell/preach
	name = "Fervorous Prayer"
	desc = "Proclaim your faith and inspire those who share it, granting +1 CON, +2 WIL, +1 SPD and +2 FOR, a mood buff and also protecting them from panic and heart attacks."
	fluff_desc = "Raise your voice in prayer, and let the faithful find strength in their shared devotion."
	button_icon_state = "bcry"
	sound = 'sound/magic/ravox_withstand.ogg'
	glow_intensity = GLOW_INTENSITY_VERY_HIGH

	click_to_activate = FALSE
	cast_range = SPELL_RANGE_GROUND

	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = 5

	secondary_resource_type = SPELL_COST_STAMINA
	secondary_resource_cost = SPELLCOST_STAT_BUFF + 20

	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = 1 SECONDS
	charge_slowdown = 1
	charge_swingdelay_type = SWINGDELAY_PENALTY
	cooldown_time = 10 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/list/patron_invocations = list(
		/datum/patron/divine/undivided = list(
			"UNITED WE STAND, TOGETHER WE RIDE!!",
			"THE TEN STAND AS ONE, AND NONE SHALL BREAK US!!",
			"OUR FAITH BINDS US, OUR UNITY MAKES US STRONG!!",
			"STAND SHOULDER TO SHOULDER, AND FEAR NO EVIL!!",
			"TOGETHER IN FAITH, TOGETHER IN BATTLE!!",
			"LET NO DIVISION TEAR ASUNDER WHAT THE TEN HAVE UNITED!!",
		),
		/datum/patron/divine/astrata = list(
			"HER RADIANCE SHALL GUIDE US THROUGH ALL!!",
			"BY THE SUN'S HOLY FIRE, LET OUR ENEMIES BURN!!",
			"RAISE YOUR HEADS, FOR HER LIGHT SHINES UPON US!!",
			"NO SHADOW CAN ENDURE THE GLORY OF ASTRATA!!",
			"LET HER GOLDEN RAYS STEEL OUR HEARTS!!",
			"IN HER LIGHT, WE SHALL NEVER KNEEL TO DARKNESS!!",
		),
		/datum/patron/divine/noc = list(
			"HIS KNOWLEDGE SHALL GUIDE US THROUGH ALL!!",
			"UNDER NOC'S WATCH, NO SECRET SHALL LEAD US ASTRAY!!",
			"LET THE NIGHT HIDE US, AND HIS WISDOM GUIDE US!!",
			"THE STARS ABOVE BEAR WITNESS TO OUR RESOLVE!!",
			"IN DARKNESS, WE FIND THE PATH THAT OTHERS FEAR!!",
			"KEEP YOUR WITS SHARP, FOR NOC SEES WHAT OTHERS MISS!!",
		),
		/datum/patron/divine/dendor = list(
			"CLARITY IN MADNESS, LOOSE YOUR PRIMAL SOUL!!",
			"LET THE WILD ROOT DEEP WITHIN YOUR HEARTS!!",
			"TEAR DOWN YOUR FEAR, AND LET NATURE TAKE ITS COURSE!!",
			"BY THORN AND ROOT, WE SHALL NOT BE CAST ASUNDER!!",
			"LET THE BEAST WITHIN ROAR LOUDER THAN YOUR DOUBTS!!",
			"THE WILD DOES NOT YIELD, AND NEITHER SHALL WE!!",
		),
		/datum/patron/divine/abyssor = list(
			"AWAKEN FROM THY DREAM, RAGE AS A STORM!!",
			"LET THE DEEP RISE AND DROWN OUR FOES!!",
			"LIKE THE TIDE, WE SHALL RETURN STRONGER THAN BEFORE!!",
			"FEAR NOT THE STORM, FOR WE ARE ITS WRATH!!",
			"LET THE ABYSS SHAKE THE EARTH BENEATH THEIR FEET!!",
			"BY SALT AND SURGING WAVE, WE SHALL RAGE!!",
		),
		/datum/patron/divine/ravox = list(
			"STAND FIRM, STAND TALL! WE ARE JUSTICE!!",
			"LET NO COWARDICE SOIL THE HONOR OF OUR CAUSE!!",
			"RAISE YOUR WEAPONS, FOR JUSTICE DOES NOT STRIKE ITSELF!!",
			"THE RIGHTEOUS SHALL NOT FALTER BEFORE THE UNJUST!!",
			"LET OUR DEEDS SPEAK LOUDER THAN OUR ENEMIES' LIES!!",
			"FIGHT WITH HONOR, AND LET THE GUILTY TREMBLE!!",
			"NEVER SHOW FEAR, NO MATTER THE ODDS!", // (++)larp, (--)the fact it's now 1/6 chance, rip
		),
		/datum/patron/divine/necra = list(
			"THE UNDERMAIDEN IS WITH US!!",
			"DEATH WAITS FOR ALL, BUT OUR HOUR IS NOT YET!!",
			"LET THE DEAD REST, AND THE LIVING FIGHT ON!!",
			"DO NOT FEAR THE GRAVE, FOR ITS MISTRESS KNOWS US ALL!!",
			"OUR THREADS ARE NOT YET CUT, SO STAND AND FIGHT!!",
			"THE UNDERMAIDEN HAS NOT CALLED US HOME!!",
		),
		/datum/patron/divine/xylix = list(
			"ROLL THE DICE! FLIP THE TABLE!!",
			"FORTUNE FAVORS THE BOLD, SO LET US BE BOLD!!",
			"THE GAME IS NOT OVER UNTIL THE LAST CARD FALLS!!",
			"LAUGH IN THE FACE OF FATE, AND CHANGE THE RULES!!",
			"LET CHAOS DEAL THE CARDS, AND COURAGE PLAY THE HAND!!",
			"ONE MORE THROW, ONE MORE CHANCE! LET US MAKE IT COUNT!!",
		),
		/datum/patron/divine/pestra = list(
			"PAIN IS WEAKNESS LEAVING THE BODY!!",
			"ENDURE THE HURT, AND LET IT TEACH YOU STRENGTH!!",
			"NO WOUND SHALL BREAK THE SPIRIT THAT PESTRA SUSTAINS!!",
			"WE HAVE SUFFERED WORSE, AND WE SHALL SUFFER NO MORE!!",
			"LET OUR SCARS BE PROOF THAT WE STILL STAND!!",
			"THROUGH AFFLICTION, WE LEARN THE CURE!!",
		),
		/datum/patron/divine/malum = list(
			"FOR ROCK AND STONE!!", // 1/5 chance is fair ok! :c
			"LET THE HAMMER FALL, AND LET OUR ENEMIES CRUMBLE!!",
			"THROUGH FIRE AND LABOR, WE SHALL BE MADE STRONG!!",
			"NO TASK TOO GREAT, NO BURDEN TOO HEAVY!!",
			"PUT YOUR BACKS INTO IT, AND MAKE THE WORLD YIELD!!",
			"LET OUR HANDS BE STEADY AND OUR WILL UNBREAKABLE!!",
		),
		/datum/patron/divine/eora = list(
			"LOVE SHALL SEE US THROUGH!!",
			"STAND FOR THOSE BESIDE YOU, AND THEY SHALL STAND FOR YOU!!",
			"LET COMPASSION GIVE US COURAGE, AND COURAGE GIVE US STRENGTH!!",
			"NO HEART STANDS ALONE WHILE WE STILL DRAW BREATH!!",
			"PROTECT ONE ANOTHER, FOR THAT IS THE GREATEST ACT OF LOVE!!",
			"LET KINDNESS STEEL OUR HANDS AGAINST CRUELTY!!",
		),
		/datum/patron/inhumen/zizo = list(
			"HER KNOWLEDGE SHALL GUIDE US THROUGH ALL!!",
			"WISDOM BELONGS TO THOSE WITH THE WILL TO TAKE IT!!",
			"LET THE IGNORANT TREMBLE BEFORE WHAT WE KNOW!!",
			"THROUGH ESOTERICA, WE SHALL TRANSCEND!!",
			"THE WORLD FEARS WHAT IT CANNOT UNDERSTAND!!",
			"LET OUR AMBITION OUTLIVE EVERY LAW AND LIMIT!!",
		),
		/datum/patron/inhumen/graggar = list(
			"STAND FIRM, STAND TALL! MIGHT MAKES RIGHT!!",
			"THE STRONG TAKE WHAT THEY DESERVE!!",
			"LET OUR FOES LEARN THE PRICE OF WEAKNESS!!",
			"POWER IS PROVEN IN BLOOD, NOT WORDS!!",
			"CRUSH THE FEEBLE, AND LET THE STRONG PREVAIL!!",
			"LET NO CHAIN HOLD THOSE BORN TO CONQUER!!",
		),
		/datum/patron/inhumen/matthios = list(
			"HER RADIANCE SHALL SERVE US THROUGH ALL!!",
			"TAKE WHAT IS YOURS, AND LET NONE STAND IN YOUR WAY!!",
			"THE WORLD OWES US NOTHING, SO WE SHALL TAKE EVERYTHING!!",
			"LET THEIR GOLD FILL OUR PURSES AND THEIR PRIDE FILL OUR GRAVES!!",
			"EVERY LOCK HAS A KEY, AND EVERY FOOL HAS A PRICE!!",
			"WHY BEG FOR BLESSINGS WHEN WE CAN STEAL THE FIRE ITSELF!!",
		),
		/datum/patron/inhumen/baotha = list(
			"PASSION SHALL SEE US THROUGH!!",
			"LET EVERY RESTRAINT BREAK BENEATH THE FORCE OF OUR DESIRES!!",
			"FEEL EVERYTHING, FEAR NOTHING, AND HOLD NOTHING BACK!!",
			"LET OUR FERVOR BURN HOTTER THAN THEIR REASON!!",
			"THE WORLD CANNOT TAME WHAT IT CANNOT CONTROL!!",
			"CAST OFF YOUR CHAINS, AND LET YOUR TRUE NATURE ROAR!!",
		),
		/datum/patron/old_god = list(
			"THE ALLFATHER'S LIGHT IS MY TORCH!!",
			"HE GAVE EVERYTHING SO THAT WE MIGHT ENDURE!!",
			"THOUGH HE ANSWERS NOT, HIS SACRIFICE SHALL NOT BE FORGOTTEN!!",
			"WE ARE HIS CHILDREN, AND WE SHALL NOT ABANDON HIS LEGACY!!",
			"LET NO FALSE GOD OUTSHINE THE ONE WHO GAVE HIS ALL!!",
			"IN HIS SILENCE, WE FIND OUR DUTY; IN HIS SACRIFICE, OUR STRENGTH!!",
		),
	)

/datum/action/cooldown/spell/preach/cast(atom/cast_on)
	. = ..()

	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!H.patron)
		return FALSE

	var/list/valid_patron_groups

	if(H.patron.type in ALL_DIVINE_PATRONS)
		valid_patron_groups = ALL_DIVINE_PATRONS
	else if(H.patron.type in ALL_INHUMEN_PATRONS)
		valid_patron_groups = ALL_INHUMEN_PATRONS
	else if(H.patron.type in OLD_GOD_PATRON)
		valid_patron_groups = OLD_GOD_PATRON
	else
		return FALSE

	var/invocation
	for(var/patron_type in patron_invocations)
		if(istype(H.patron, patron_type))
			invocation = pick(patron_invocations[patron_type])
			break

	if(invocation)
		H.say(invocation)

	var/turf/center = get_turf(H)
	if(!center)
		return FALSE

	for(var/mob/living/carbon/target in view(cast_range, center))
		if(!target.patron)
			continue

		var/eligible = FALSE
		for(var/patron_type in valid_patron_groups)
			if(istype(target.patron, patron_type))
				eligible = TRUE
				break

		if(!eligible)
			continue

		target.apply_status_effect(/datum/status_effect/buff/preach)
		target.add_stress(/datum/stressevent/zealot_cry)

	return TRUE

/datum/status_effect/buff/preach
	id = "preach"
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/buff/preach
	duration = 3 MINUTES
	effectedstats = list(STATKEY_CON = 1, STATKEY_WIL = 2, STATKEY_SPD = 1, STATKEY_LCK = 2)

/atom/movable/screen/alert/status_effect/buff/preach
	name = "Fervorous Prayer"
	desc = "I am inspired by a crazed madman's war cry! I can do anything!"
	icon_state = "ten_united"

/datum/status_effect/buff/preach/on_apply()
	. = ..()
	to_chat(owner, span_nicegreen("My faith burns bright, and my heart stands firm!"))
	ADD_TRAIT(owner, TRAIT_RALLIED, "preach")
	ADD_TRAIT(owner, TRAIT_STEELHEARTED, "preach")

/datum/status_effect/buff/preach/on_remove()
	. = ..()
	to_chat(owner, span_notice("The fervor of my prayer fades."))
	REMOVE_TRAIT(owner, TRAIT_RALLIED, "preach")
	REMOVE_TRAIT(owner, TRAIT_STEELHEARTED, "preach")

/datum/action/cooldown/spell/sacrifice
	name = "Sacrifice"
	desc = "Invoke your faith and empower your next strike. The more wounded you are, the greater the damage you inflict, up to 40 bonus damage."
	fluff_desc = "Offer your suffering as tribute, and let your wounds become the instrument of your enemy's ruin."
	button_icon_state = "judgement"
	sound = 'sound/magic/ravox_withstand.ogg'
	glow_intensity = GLOW_INTENSITY_HIGH

	click_to_activate = FALSE
	cast_range = SPELL_RANGE_ADJACENT
	self_cast_possible = TRUE

	primary_resource_cost = SPELLCOST_MIRACLE
	secondary_resource_cost = SPELLCOST_CANTRIP

	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	cooldown_time = 1 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/list/patron_invocations = list(
		/datum/patron/divine/undivided = list(
			"LET OUR SUFFERING BIND US, AND OUR ENEMIES BREAK!!",
			"THE TEN WITNESS OUR SACRIFICE!!",
		),
		/datum/patron/divine/astrata = list(
			"BY HER FLAME, LET MY WOUNDS BURN BRIGHT!!",
			"SUNLIGHT, CONSUME MY PAIN AND SMITE MY FOES!!",
			"HALLOWED FLAMES CONSUME YOU!!"
		),
		/datum/patron/divine/noc = list(
			"BY HIS WISDOM, LET MY SUFFERING FIND PURPOSE!!",
			"FROM THE DARKEST NIGHT, LET JUDGEMENT STRIKE!!",
			"NIGHT'S VEIL CONSUME YOU!!"
		),
		/datum/patron/divine/dendor = list(
			"LET MY BLOOD FEED THE WILD!!",
			"BY THORN AND ROOT, LET MY PAIN BECOME WRATH!!",
			"BREAK LIKE THE PREY YOU ARE!!"
		),
		/datum/patron/divine/abyssor = list(
			"LET THE ABYSS DRINK DEEP OF MY SUFFERING!!",
			"BY THE RAGING TIDE, LET MY FOES BE SWEPT AWAY!!",
			"SINK IN A SEA OF YOUR OWN BLOOD!!"
		),
		/datum/patron/divine/ravox = list(
			"JUSTICAR, LET MY WOUNDS DELIVER JUSTICE!!",
			"MY PAIN IS MY PROOF, MY STRIKE MY JUDGEMENT!!",
			"FOR JUSTICE!!"
		),
		/datum/patron/divine/necra = list(
			"MY HOUR HAS NOT COME, BUT YOURS MAY!!",
			"BY THE UNDERMAIDEN, LET DEATH CLAIM ITS DUE!!",
			"INVITATION TO THE UNDERWORLD!!"
		),
		/datum/patron/divine/xylix = list(
			"LET FATE WAGER WITH MY BLOOD!!",
			"ONE LAST THROW, AND LET THE DICE RUN RED!!",
			"EVEN THE ODDS!!"
		),
		/datum/patron/divine/pestra = list(
			"LET EVERY WOUND TEACH MY ENEMIES AGONY!!",
			"ROTMOTHER! LET SUFFERING BE RETURNED IN FULL!!",
			"ROT APART AND BE REBORN!!"
		),
		/datum/patron/divine/malum = list(
			"LET MY PAIN TEMPER THE HAMMER OF MY WILL!!",
			"BY FIRE AND IRON, LET MY FOES CRUMBLE!!",
			"FOR ROCK AND STONE!!"
		),
		/datum/patron/divine/eora = list(
			"LET MY SUFFERING SHIELD THOSE I LOVE!!",
			"IN THE NAME OF LOVE, I SHALL PUNISH YOU!!",
			"FOR LOVE!!"
		),
		/datum/patron/inhumen/zizo = list(
			"DO WHAT IT TAKES, NO SACRIFICE IS TOO SMALL!!",
			"LET PAIN BE THE PRICE OF TRANSCENDENCE!!",
			"FOR THE GREAT WORK!!"
		),
		/datum/patron/inhumen/graggar = list(
			"MY WOUNDS PROVE MY STRENGTH, AND MY STRENGTH SHALL CRUSH YOU!!",
			"LET THE WEAK BLEED BENEATH MY MIGHT!!",
			"SHATTER MY LIMITS, SHATTER MY BINDS!!"
		),
		/datum/patron/inhumen/matthios = list(
			"NO AGONY SHALL BAR THE FREE!!",
			"THIS FYRE BURNS FOR MORTALKIND!!",
			"BURN DOWN THE DOGMA!!"
		),
		/datum/patron/inhumen/baotha = list(
			"LET MY PASSION TURN MY PAIN INTO FURY!!",
			"NO WOUND SHALL QUENCH THE FIRE WITHIN ME!!",
			"FALL FOR ME!!"
		),
		/datum/patron/old_god = list(
			"ALLFATHER! ONLY IN DEATH DOES DUTY END!!",
			"WITH EVERY BROKEN BONE, I NEEDN'T SWEAR, I LIVE!!",
			"ENDURE THIS!!",
		),
	)

/datum/action/cooldown/spell/sacrifice/cast(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/carbon/human/H = owner
	if(!istype(H) || !H.patron)
		return FALSE

	var/invocation
	for(var/patron_type in patron_invocations)
		if(istype(H.patron, patron_type))
			invocation = pick(patron_invocations[patron_type])
			break

	if(invocation)
		H.say(invocation)

	H.apply_status_effect(/datum/status_effect/sacrifice, H.get_active_held_item())
	return TRUE

/atom/movable/screen/alert/status_effect/buff/sacrifice
	name = "Sacrifice"
	desc = "My suffering shall fuel my next strike. The more wounded I am, the harder I shall hit."
	icon_state = "judgement"

/datum/status_effect/sacrifice
	id = "sacrifice"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 10 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/sacrifice
	on_remove_on_mob_delete = TRUE

	var/datum/weakref/buffed_item

/datum/status_effect/sacrifice/on_creation(mob/living/new_owner, obj/item/I)
	. = ..()
	if(!.)
		return

	if(istype(I) && !(I.item_flags & ABSTRACT))
		buffed_item = WEAKREF(I)
		RegisterSignal(I, COMSIG_ITEM_AFTERATTACK, PROC_REF(item_afterattack))
	else
		RegisterSignal(owner, COMSIG_MOB_ATTACK_HAND, PROC_REF(hand_attack))

/datum/status_effect/sacrifice/on_remove()
	. = ..()
	UnregisterSignal(owner, COMSIG_MOB_ATTACK_HAND)

	if(buffed_item)
		var/obj/item/I = buffed_item.resolve()
		if(I)
			UnregisterSignal(I, COMSIG_ITEM_AFTERATTACK)

/datum/status_effect/sacrifice/proc/get_sacrifice_damage(mob/living/carbon/human/H)
	var/suffering = H.getBruteLoss()
	suffering += H.getFireLoss()
	suffering += H.getToxLoss()
	suffering += H.getOxyLoss()
	suffering += H.getCloneLoss()
	suffering += ((BLOOD_VOLUME_NORMAL - H.blood_volume) / 4)

	return min(40, round(suffering * 0.5))

/datum/status_effect/sacrifice/proc/item_afterattack(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag || user != owner || !isliving(target))
		return

	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return

	var/mob/living/D = target
	var/bonus_damage = get_sacrifice_damage(H)
	var/obj/item/I = source

	if(bonus_damage > 0)
		arcyne_strike(H, D, I, bonus_damage, H.zone_selected, null, null, "Sacrifice", FALSE, FALSE, FALSE, BRUTE, 1, 1)
		D.visible_message(span_warning("[H]'s suffering fuels a devastating strike against [D]!"), vision_distance = COMBAT_MESSAGE_RANGE)

	qdel(src)

/datum/status_effect/sacrifice/proc/hand_attack(datum/source, mob/living/carbon/human/user, mob/living/carbon/human/D, datum/martial_art/attacker_style)
	if(user != owner || !istype(user) || !istype(D))
		return
	if(!istype(user.used_intent, INTENT_HARM))
		return
	var/bonus_damage = get_sacrifice_damage(user)
	if(bonus_damage > 0)
		arcyne_strike(user, D, null, bonus_damage, user.zone_selected, BCLASS_BLUNT, 0, "Sacrifice", FALSE, FALSE, FALSE, BRUTE, 1, 1)
		D.visible_message(span_warning("[user]'s suffering fuels a devastating strike against [D]!"), vision_distance = COMBAT_MESSAGE_RANGE)
	qdel(src)
