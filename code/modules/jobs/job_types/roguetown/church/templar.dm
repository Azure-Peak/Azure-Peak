//shield flail or longsword, tief can be this with red cross

/datum/job/roguetown/templar
	title = "Templar"
	department_flag = CHURCHMEN
	faction = "Station"
	tutorial = "Templars are warriors who have forsaken wealth and title in lieu of service to the church, due to either zealotry or a past shame. They guard the church and its bishop while keeping a watchful eye against heresy and nite-creechers. Within troubled dreams, they wonder if the blood they shed makes them holy or stained."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_patrons = ALL_DIVINE_PATRONS
	outfit = /datum/outfit/job/roguetown/templar
	min_pq = 3 //Deus vult, but only according to the proper escalation rules
	max_pq = null
	round_contrib_points = 2
	total_positions = 4
	spawn_positions = 4
	advclass_cat_rolls = list(CTAG_TEMPLAR = 20)
	display_order = JDO_TEMPLAR

	give_bank_account = TRUE
	job_traits = list(TRAIT_RITUALIST, TRAIT_STEELHEARTED, TRAIT_CLERGY)

	//No nobility for you, being a member of the clergy means you gave UP your nobility. It says this in many of the church tutorial texts.
	virtue_restrictions = list(/datum/virtue/utility/noble)
	job_subclasses = list(
		/datum/advclass/templar/monk,
		/datum/advclass/templar/crusader
	)

/datum/outfit/job/roguetown/templar
	job_bitflag = BITFLAG_HOLY_WARRIOR
	has_loadout = TRUE
	allowed_patrons = ALL_DIVINE_PATRONS

/datum/advclass/templar/monk
	name = "Monk"
	tutorial = "You are a monk of the Church, trained in pugilism and acrobatics. You bear no armor but your faith, and your hands are lethal weapons in service to your God."
	outfit = /datum/outfit/job/roguetown/templar/monk

	category_tags = list(CTAG_TEMPLAR)
	subclass_languages = list(/datum/language/grenzelhoftian)
	traits_applied = list(TRAIT_CIVILIZEDBARBARIAN)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = 2
	)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_JOURNEYMAN,
	)
	subclass_stashed_items = list(
		"The Verses and Acts of the Ten" = /obj/item/book/rogue/bibble,
	)
	extra_context = "This subclass can choose from multiple disciplines. The further your chosen discipline strays from unarmed combat, however, the greater your skills in fistfighting and wrestling will atrophy. Taking a Quarterstaff provides a minor bonus to Perception, but removes the 'Dodge Expert' trait."

/datum/outfit/job/roguetown/templar/monk/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/roguetown/psicross/undivided
	cloak = /obj/item/clothing/cloak/tabard/crusader/tief
	id = /obj/item/clothing/ring/silver
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/ritechalk = 1,
		)
	H.cmode_music = 'sound/music/cmode/church/combat_reckoning.ogg'
	switch(H.patron?.type)
		if(/datum/patron/divine/undivided)
			neck = /obj/item/clothing/neck/roguetown/psicross/undivided
			if(H.mind)
				var/cloaks = list("Cloak", "Tabard")
				var/cloakchoice = input(H,"Choose your covering", "TAKE UP FASHION") as anything in cloaks
				switch(cloakchoice)
					if("Cloak")
						cloak = /obj/item/clothing/cloak/undivided
					if("Tabard")
						cloak = /obj/item/clothing/cloak/templar/undivided
		if(/datum/patron/divine/astrata)
			neck = /obj/item/clothing/neck/roguetown/psicross/astrata
			cloak = /obj/item/clothing/cloak/tabard/crusader/astrata
		if(/datum/patron/divine/abyssor)
			neck = /obj/item/clothing/neck/roguetown/psicross/abyssor
			cloak = /obj/item/clothing/cloak/tabard/abyssortabard
		if(/datum/patron/divine/xylix)
			neck = /obj/item/clothing/neck/roguetown/luckcharm
			cloak = /obj/item/clothing/cloak/templar/xylixian
			H.cmode_music = 'sound/music/combat_jester.ogg'
		if(/datum/patron/divine/dendor)
			neck = /obj/item/clothing/neck/roguetown/psicross/dendor
			cloak = /obj/item/clothing/cloak/tabard/crusader/dendor
			H.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg'
		if(/datum/patron/divine/necra)
			neck = /obj/item/clothing/neck/roguetown/psicross/necra
			cloak = /obj/item/clothing/cloak/templar/necran
		if(/datum/patron/divine/pestra)
			neck = /obj/item/clothing/neck/roguetown/psicross/pestra
			cloak = /obj/item/clothing/cloak/templar/pestran
		if(/datum/patron/divine/eora) //Eora content from stonekeep
			neck = /obj/item/clothing/neck/roguetown/psicross/eora
			cloak = /obj/item/clothing/cloak/templar/eoran
		if(/datum/patron/divine/noc)
			neck = /obj/item/clothing/neck/roguetown/psicross/noc
			cloak = /obj/item/clothing/cloak/tabard/crusader/noc
		if(/datum/patron/divine/ravox)
			neck = /obj/item/clothing/neck/roguetown/psicross/ravox
			cloak = /obj/item/clothing/cloak/templar/ravox
			backpack_contents = list(/obj/item/ritechalk, /obj/item/book/rogue/law)
		if(/datum/patron/divine/malum)
			neck = /obj/item/clothing/neck/roguetown/psicross/malum
			cloak = /obj/item/clothing/cloak/templar/malumite
	head = /obj/item/clothing/head/roguetown/headband/monk
	wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/monk
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/black
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/monk/holy
	pants = /obj/item/clothing/under/roguetown/tights/black
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	beltr = /obj/item/storage/keyring/churchie
	shoes = /obj/item/clothing/shoes/roguetown/sandals

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)	//Capped to T2 miracles.
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_MIDDLE_CLASS, H, "Church Funding.")

/datum/outfit/job/roguetown/templar/monk/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/weapons = list("Discipline - Unarmed","Katar","Knuckledusters","Quarterstaff")
	switch(H.patron?.type)
		if(/datum/patron/divine/eora)
			weapons += "Close Caress"
		if(/datum/patron/divine/abyssor)
			weapons += "Barotrauma"

	var/weapon_choice = input(H,"Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	switch(weapon_choice)
		if("Discipline - Unarmed")
			H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, 5, TRUE)
			gloves = /obj/item/clothing/gloves/roguetown/bandages/pugilist
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
		if("Katar")
			H.put_in_hands(new /obj/item/rogueweapon/katar(H))
			gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
		if("Knuckledusters")
			H.put_in_hands(new /obj/item/rogueweapon/knuckles(H))
			gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
		if("Quarterstaff")
			H.adjust_skillrank_up_to(/datum/skill/combat/staves, 4, TRUE) //Tested with Disciples, first. Should hopefully be not too busted - reduce to Journeyman, otherwise.
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 3, TRUE)
			gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
			H.put_in_hands(new /obj/item/rogueweapon/woodstaff/quarterstaff/steel(H))
			H.put_in_hands(new /obj/item/rogueweapon/scabbard/gwstrap(H))
			H.change_stat(STATKEY_PER, 1) //Matches the Disciple's balance; exchanges the 'dodge expert' trait for additional accuracy with the staff.
		if("Close Caress")
			H.put_in_hands(new /obj/item/rogueweapon/knuckles/eora(H))
			gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
		if("Barotrauma")
			H.put_in_hands(new /obj/item/rogueweapon/katar/abyssor(H))
			gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)

	// -- Start of section for god specific bonuses --
	if(H.patron?.type == /datum/patron/divine/undivided)
		H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
	if(H.patron?.type == /datum/patron/divine/astrata)
		H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
		H.cmode_music = 'sound/music/cmode/church/combat_astrata.ogg'
	if(H.patron?.type == /datum/patron/divine/dendor)
		H.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
	if(H.patron?.type == /datum/patron/divine/noc)
		H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE) // Really good at reading... does this really do anything? No. BUT it's soulful.
		H.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE)
		H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
	if(H.patron?.type == /datum/patron/divine/abyssor)
		H.adjust_skillrank(/datum/skill/labor/fishing, 2, TRUE)
		ADD_TRAIT(H, TRAIT_WATERBREATHING, TRAIT_GENERIC)
	if(H.patron?.type == /datum/patron/divine/necra)
		ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_SOUL_EXAMINE, TRAIT_GENERIC)
		H.cmode_music = 'sound/music/cmode/church/combat_necra.ogg'
	if(H.patron?.type == /datum/patron/divine/pestra)
		H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE)
		ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
	if(H.patron?.type == /datum/patron/divine/eora)
		ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)
		H.cmode_music = 'sound/music/cmode/church/combat_eora.ogg'
	if(H.patron?.type == /datum/patron/divine/malum)
		ADD_TRAIT(H, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC) // ONE exception for the "no combat role get this" rules
		H.adjust_skillrank(/datum/skill/craft/blacksmithing, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/armorsmithing, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/smelting, 1, TRUE)
	if(H.patron?.type == /datum/patron/divine/ravox)
		H.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
	if(H.patron?.type == /datum/patron/divine/xylix)
		H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/lockpicking, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/music, 1, TRUE)
	// -- End of section for god specific bonuses --

/datum/advclass/templar/crusader
	name = "Templar"
	tutorial = "You are a templar of the Church, trained in heavy weaponry and zealous warfare. You are the instrument of your God's wrath, clad in steel and faith."
	outfit = /datum/outfit/job/roguetown/templar/crusader
	category_tags = list(CTAG_TEMPLAR)
	subclass_languages = list(/datum/language/grenzelhoftian)
	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_WIL = 3,
		STATKEY_STR = 2,
		STATKEY_CON = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/holy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,	//May tone down to 2; seems OK.
	)
	subclass_stashed_items = list(
		"The Verses and Acts of the Ten" = /obj/item/book/rogue/bibble,
	)
	extra_context = "This subclass gains Expert skill in their weapon of choice. Taking a ranged option will provide Expert skills in Crossbows and Journeyman skills in Swordsmanship, at the cost of starting with reduced armor and atrophying in all other weapon skills."

/datum/outfit/job/roguetown/templar/crusader/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/heavy/bucket
	wrists = /obj/item/clothing/neck/roguetown/psicross/astrata
	cloak = /obj/item/clothing/cloak/tabard/crusader/tief
	backr = /obj/item/rogueweapon/shield/tower/metal
	id = /obj/item/clothing/ring/silver
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/ritechalk = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/storage/keyring/churchie = 1
		)
	H.cmode_music = 'sound/music/cmode/church/combat_reckoning.ogg' // this is probably awful implementation. too bad!
	switch(H.patron?.type)
		if(/datum/patron/divine/undivided)
			wrists = /obj/item/clothing/neck/roguetown/psicross/undivided
			head = /obj/item/clothing/head/roguetown/helmet/heavy/bucket
			backr = /obj/item/rogueweapon/shield/tower/holysee
			if(H.mind)
				var/cloaks = list("Cloak", "Tabard")
				var/cloakchoice = input(H,"Choose your covering", "TAKE UP FASHION") as anything in cloaks
				switch(cloakchoice)
					if("Cloak")
						cloak = /obj/item/clothing/cloak/undivided
					if("Tabard")
						cloak = /obj/item/clothing/cloak/templar/undivided
		if(/datum/patron/divine/astrata)
			wrists = /obj/item/clothing/neck/roguetown/psicross/astrata
			head = /obj/item/clothing/head/roguetown/helmet/heavy/astratan
			cloak = /obj/item/clothing/cloak/templar/astratan
		if(/datum/patron/divine/abyssor)
			wrists = /obj/item/clothing/neck/roguetown/psicross/abyssor
			head = /obj/item/clothing/head/roguetown/helmet/heavy/abyssorgreathelm
			cloak = /obj/item/clothing/cloak/tabard/abyssortabard
		if(/datum/patron/divine/xylix)
			cloak = /obj/item/clothing/cloak/templar/xylixian
			head = /obj/item/clothing/head/roguetown/helmet/heavy/xylixhelm
			H.cmode_music = 'sound/music/combat_jester.ogg'
			var/datum/inspiration/I = new /datum/inspiration(H)
			I.grant_inspiration(H, bard_tier = BARD_T1)
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
			cloak = /obj/item/clothing/cloak/tabard/crusader/noc
		if(/datum/patron/divine/ravox)
			wrists = /obj/item/clothing/neck/roguetown/psicross/ravox
			head = /obj/item/clothing/head/roguetown/helmet/heavy/ravoxhelm
			cloak = /obj/item/clothing/cloak/templar/ravox
			mask = /obj/item/clothing/head/roguetown/roguehood/ravoxgorget
			backpack_contents = list(/obj/item/ritechalk, /obj/item/book/rogue/law, /obj/item/rogueweapon/scabbard/sheath, /obj/item/storage/belt/rogue/pouch/coins/mid, /obj/item/storage/keyring/churchie )
		if(/datum/patron/divine/malum)
			wrists = /obj/item/clothing/neck/roguetown/psicross/malum
			cloak = /obj/item/clothing/cloak/templar/malumite
			head = /obj/item/clothing/head/roguetown/helmet/heavy/malum
		if(/datum/patron/old_god)
			wrists = /obj/item/clothing/neck/roguetown/psicross
			cloak = /obj/item/clothing/cloak/tabard/crusader/psydon
	gloves = /obj/item/clothing/gloves/roguetown/chain
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	pants = /obj/item/clothing/under/roguetown/chainlegs
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = /obj/item/rogueweapon/scabbard/sword
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)	//Capped to T2 miracles.
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_MIDDLE_CLASS, H, "Church Funding.")

/datum/outfit/job/roguetown/templar/crusader/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/weapons = list("Longsword","Flail","Mace","Battle Axe","Spear","Crossbow + Shortsword")
	switch(H.patron?.type)
		if(/datum/patron/divine/astrata) //Unique patron weapons, more can be added here if wanted.
			weapons += "Solar Judgement"
		if(/datum/patron/divine/undivided)
			weapons += "Decablade"
		if(/datum/patron/divine/noc)
			weapons += "Moonlight Khopesh"
		if(/datum/patron/divine/necra)
			weapons += "Swift End"
		if(/datum/patron/divine/pestra)
			weapons += "Plaguebringer Sickles"
		if(/datum/patron/divine/malum)
			weapons += "Forgefiend"
		if(/datum/patron/divine/dendor)
			weapons += "Summer Scythe"
		if(/datum/patron/divine/xylix)
			weapons += "Cackle Lash"
		if(/datum/patron/divine/ravox)
			weapons += "Duel Settler"
		if(/datum/patron/divine/eora)
			weapons += "The Heartstring"
		if(/datum/patron/divine/abyssor)
			weapons += "Tidecleaver"
	var/weapon_choice = input(H,"Choose your WEAPON.", "TAKE UP YOUR GOD'S ARMS") as anything in weapons
	switch(weapon_choice)
		if("Longsword")
			H.put_in_hands(new /obj/item/rogueweapon/sword/long/church(H))
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/silver, SLOT_ARMOR, TRUE) //Halfplate, not fullplate.
		if("Spear")
			H.put_in_hands(new /obj/item/rogueweapon/spear/holysee(H))
			H.put_in_hands(new /obj/item/rogueweapon/scabbard/gwstrap(H))
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/silver, SLOT_ARMOR, TRUE)
		if("Flail")
			H.put_in_hands(new /obj/item/rogueweapon/flail/sflail(H))
			H.adjust_skillrank(/datum/skill/combat/whipsflails, 1, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/silver, SLOT_ARMOR, TRUE)
		if("Mace")
			H.put_in_hands(new /obj/item/rogueweapon/mace/steel(H))
			H.adjust_skillrank(/datum/skill/combat/maces, 1, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/silver, SLOT_ARMOR, TRUE)
		if("Battle Axe")
			H.put_in_hands(new /obj/item/rogueweapon/stoneaxe/battle(H))
			H.adjust_skillrank(/datum/skill/combat/axes, 1, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/silver, SLOT_ARMOR, TRUE)
		if("Crossbow + Shortsword")
			H.equip_to_slot_or_del(new /obj/item/quiver/bolts, SLOT_BELT_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/cuirass, SLOT_ARMOR, TRUE) //Cuirass, not halfplate. Slightly reduced starting armor.
			H.put_in_hands(new /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow(H))
			H.put_in_hands(new /obj/item/rogueweapon/sword/short(H), TRUE)
			H.adjust_skillrank(/datum/skill/combat/crossbows, 2, TRUE) //Expert Crossbow, but Journeyman Swords and Apprentice-level combat skills elsewhere.
			H.adjust_skillrank(/datum/skill/combat/maces, -1, TRUE)
			H.adjust_skillrank(/datum/skill/combat/axes, -1, TRUE)
			H.adjust_skillrank(/datum/skill/combat/whipsflails, -1, TRUE)
		if("Decablade")
			H.put_in_hands(new /obj/item/rogueweapon/sword/long/undivided(H))
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/silver, SLOT_ARMOR, TRUE)
		if("Solar Judgement")
			H.put_in_hands(new /obj/item/rogueweapon/sword/long/exe/astrata(H))
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/silver, SLOT_ARMOR, TRUE)
		if("Moonlight Khopesh")
			H.put_in_hands(new /obj/item/rogueweapon/sword/sabre/nockhopesh(H))
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/silver, SLOT_ARMOR, TRUE)
		if("Swift End")
			H.put_in_hands(new /obj/item/rogueweapon/flail/sflail/necraflail(H))
			H.adjust_skillrank(/datum/skill/combat/whipsflails, 1, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/silver, SLOT_ARMOR, TRUE)
		if("Plaguebringer Sickles")
			H.put_in_hands(new /obj/item/rogueweapon/huntingknife/idagger/steel/pestrasickle(H))
			H.put_in_hands(new /obj/item/rogueweapon/huntingknife/idagger/steel/pestrasickle(H))
			H.adjust_skillrank_up_to(/datum/skill/combat/knives, 4, TRUE) // actually makes them usable for the templar.
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/silver, SLOT_ARMOR, TRUE)
		if("Forgefiend")
			H.put_in_hands(new /obj/item/rogueweapon/greatsword/grenz/flamberge/malum(H))
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/silver, SLOT_ARMOR, TRUE)
		if("Summer Scythe")
			H.put_in_hands(new /obj/item/rogueweapon/halberd/bardiche/scythe(H))
			H.put_in_hands(new /obj/item/rogueweapon/scabbard/gwstrap(H))
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE) // again, needs skill to actually use the weapon
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/silver, SLOT_ARMOR, TRUE)
		if("Cackle Lash")
			H.put_in_hands(new /obj/item/rogueweapon/whip/xylix(H))
			H.adjust_skillrank(/datum/skill/combat/whipsflails, 1, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/silver, SLOT_ARMOR, TRUE)
		if("Duel Settler")
			H.put_in_hands(new /obj/item/rogueweapon/mace/goden/steel/ravox(H))
			H.adjust_skillrank(/datum/skill/combat/maces, 1, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/silver, SLOT_ARMOR, TRUE)
		if("The Heartstring")
			H.put_in_hands(new /obj/item/rogueweapon/sword/rapier/eora(H))
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/silver, SLOT_ARMOR, TRUE)
		if("Tidecleaver")
			H.put_in_hands(new /obj/item/rogueweapon/stoneaxe/battle/abyssoraxe(H))
			H.adjust_skillrank(/datum/skill/combat/axes, 1, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/silver, SLOT_ARMOR, TRUE)

	// -- Start of section for god specific bonuses --
	if(H.patron?.type == /datum/patron/divine/undivided)
		H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
	if(H.patron?.type == /datum/patron/divine/astrata)
		H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
		H.cmode_music = 'sound/music/cmode/church/combat_astrata.ogg'
	if(H.patron?.type == /datum/patron/divine/dendor)
		H.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
	if(H.patron?.type == /datum/patron/divine/noc)
		H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE) // Really good at reading... does this really do anything? No. BUT it's soulful.
		H.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE)
		H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
	if(H.patron?.type == /datum/patron/divine/abyssor)
		H.adjust_skillrank(/datum/skill/labor/fishing, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
		ADD_TRAIT(H, TRAIT_WATERBREATHING, TRAIT_GENERIC)
	if(H.patron?.type == /datum/patron/divine/necra)
		ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_SOUL_EXAMINE, TRAIT_GENERIC)
		H.cmode_music = 'sound/music/cmode/church/combat_necra.ogg'
	if(H.patron?.type == /datum/patron/divine/pestra)
		H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE)
		ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
	if(H.patron?.type == /datum/patron/divine/eora)
		ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)
		H.cmode_music = 'sound/music/cmode/church/combat_eora.ogg'
	if(H.patron?.type == /datum/patron/divine/malum)
		H.adjust_skillrank(/datum/skill/craft/blacksmithing, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/armorsmithing, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/smelting, 1, TRUE)
	if(H.patron?.type == /datum/patron/divine/ravox)
		H.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
	if(H.patron?.type == /datum/patron/divine/xylix)
		H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/lockpicking, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/music, 1, TRUE)
	// -- End of section for god specific bonuses --

