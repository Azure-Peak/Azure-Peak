//////////////////////////////////////////////////////////////////
/////////////////////////////////// MILITIAMAN
/*
	guy w/militia weapons
	combined with a Towner class of their choice
*/
/datum/advclass/warband/rebellion/grunt/militiaman
	title = "MILITIAMAN"
	name = "Militiaman"
	tutorial = "In the coming tide of peasantry, scythes and pitchforks will be wielded in the hundreds. \
	Within every mob, one is held by a MILITIAMAN, whose skills are honed enough to strike true." // DELETENOTE
	outfit = /datum/outfit/job/roguetown/warband/rebellion/grunt/militiaman
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_FORMATIONFIGHTER)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_SPD = 1,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_INT = -1,
		STATKEY_PER = 2,
	)
	subclass_skills = list(
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/slings = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_NOVICE,
	)


/datum/outfit/job/roguetown/warband/rebellion/grunt/militiaman/pre_equip(mob/living/carbon/human/H)
	..()

	head = /obj/item/clothing/head/roguetown/armingcap
	mask = /obj/item/clothing/head/roguetown/roguehood
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather/rope
	backl = /obj/item/storage/backpack/rogue/satchel
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	neck = /obj/item/clothing/neck/roguetown/coif
	pants =	/obj/item/clothing/under/roguetown/heavy_leather_pants

	var/background = list("Farmer","Hunter","Blacksmith","Fisherman","Cook","Tailor","Alchemist","Miner","Bum")
	var/background_choice = input("I was once a...", "I REMEMBER") as anything in background
	switch(background_choice)
		if("Farmer")
			H.adjust_skillrank_up_to(/datum/skill/labor/farming = 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/butchering = 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/tanning = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/crafting = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/carpentry = 2, TRUE)
			H.change_stat("strength", 1)
			H.change_stat("constitution", 1)
			H.change_stat("endurance", 1)
			ADD_TRAIT(H, TRAIT_SEEDKNOW, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
		if("Hunter")
			H.adjust_skillrank_up_to(/datum/skill/combat/bows = 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/butchering = 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/tanning = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/slings = 2, TRUE)		
			H.adjust_skillrank_up_to(/datum/skill/misc/swimming = 2, TRUE)		
			H.adjust_skillrank_up_to(/datum/skill/craft/crafting = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/sewing = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/fishing = 1, TRUE)
			H.change_stat("perception", 2)
			ADD_TRAIT(H, TRAIT_LONGSTRIDER, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_OUTDOORSMAN, TRAIT_GENERIC)
		if("Blacksmith")
			H.adjust_skillrank_up_to(/datum/skill/craft/blacksmithing = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/armorsmithing = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/weaponsmithing = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/smelting = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/crafting = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/engineering = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/masonry = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/reading = 1, TRUE)
			H.change_stat("strength", 1)
			H.change_stat("endurance", 1)
			ADD_TRAIT(H, TRAIT_TRAINED_SMITH, TRAIT_GENERIC)
		if("Fisherman")
			H.adjust_skillrank_up_to(/datum/skill/misc/swimming = 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/fishing = 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/butchering = 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms = 1, TRUE)
			backr = /obj/item/fishingrod
			H.change_stat("intelligence", 1)
			H.change_stat("perception", 2)
		if("Cook")
			H.adjust_skillrank_up_to(/datum/skill/craft/cooking = 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/knives = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/butchering = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/farming = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/crafting = 1, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/sewing = 1, TRUE)
			H.change_stat("endurance", 1)
			H.change_stat("constitution", 1)
			ADD_TRAIT(H, TRAIT_CICERONE, TRAIT_GENERIC)
		if("Tailor")
			H.adjust_skillrank_up_to(/datum/skill/craft/sewing = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/tanning = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/knives = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/crafting = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/reading = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/medicine = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/farming = 1, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/cooking = 1, TRUE)
			beltl = /obj/item/rogueweapon/huntingknife/scissors/steel
			H.change_stat("intelligence", 1)
			H.change_stat("speed", 1)
		if("Alchemist")
			H.adjust_skillrank_up_to(/datum/skill/misc/medicine = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/alchemy = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/reading = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/knives = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/sewing = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/wrestling = 1, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/crafting = 1, TRUE)
			H.change_stat("intelligence", 1)
		if("Miner")
			H.adjust_skillrank_up_to(/datum/skill/craft/smelting = 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/mining = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/masonry = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/axes = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/athletics = 1, TRUE)
			H.change_stat("endurance", 3)
			H.change_stat("strength", 1)
			ADD_TRAIT(H, TRAIT_DARKVISION, TRAIT_GENERIC)
		if("Bum")
			H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking = 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/stealing = 4, TRUE)
			H.change_stat("strength", -3)
			H.change_stat("constitution", -3)
			H.change_stat("endurance", -3)
			H.change_stat("perception", -2)
			H.change_stat("intelligence", -2)			
			H.STALUC = rand(1, 20)
			ADD_TRAIT(H, TRAIT_LIMPDICK, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)

	var/weapons = list("Flail & Shield","Heavy Flail","Spiked Greatclub","Axe","Spear","Scythe","Pick","Falchion","Sling")
	var/weapon_choice = input("I abandoned my peace and took up a...", "TAKE UP ARMS") as anything in weapons
	switch(weapon_choice)
		if("Heavy Flail")
			r_hand = /obj/item/rogueweapon/flail/peasantwarflail
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails = 1, TRUE)
		if("Flail")
			r_hand = /obj/item/rogueweapon/flail/militia
			l_hand = /obj/item/rogueweapon/shield/heater
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails = 1, TRUE)
		if("Spiked Greatclub")
			r_hand = /obj/item/rogueweapon/woodstaff/militia
			H.adjust_skillrank_up_to(/datum/skill/combat/maces = 1, TRUE)
		if("Axe")
			r_hand = /obj/item/rogueweapon/greataxe/militia
			H.adjust_skillrank_up_to(/datum/skill/combat/axes = 1, TRUE)
		if("Spear")
			r_hand = /obj/item/rogueweapon/spear/militia
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms = 1, TRUE)
		if("Scythe")
			r_hand = /obj/item/rogueweapon/scythe
			H.adjust_skillrank_up_to(/datum/skill/labor/farming = 1, TRUE)
		if("Pick")
			r_hand = /obj/item/rogueweapon/pick/militia/steel
			l_hand = /obj/item/rogueweapon/shield/heater
			H.adjust_skillrank_up_to(/datum/skill/labor/mining = 1, TRUE)
		if("Falchion")
			r_hand = /obj/item/rogueweapon/sword/falchion/militia
			l_hand = /obj/item/rogueweapon/shield/heater
			beltr = /obj/item/rogueweapon/scabbard
			H.adjust_skillrank_up_to(/datum/skill/combat/swords = 1, TRUE)
		if("Sling")
			r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
			beltr = /obj/item/quiver/sling/iron
			H.adjust_skillrank_up_to(/datum/skill/combat/slings = 1, TRUE)
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)

///////////////////////////////////////////////
/////////////////////////////////// CONSPIRATOR
/*
	a rogue
	otherwise appears as a regular towner & spawns with the keys to their associated job

*/

/datum/advclass/warband/rebellion/grunt/conspirator
	title = "CONSPIRATOR"
	name = "Conspirator"
	tutorial = "The CONSPIRATOR is a citizen of the Azure Peak swayed to a new cause. A valuable thing - for in times like these, there's nothing deadlier than a friendly face."
	outfit = /datum/outfit/job/roguetown/warband/rebellion/grunt/conspirator
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_LIGHT_STEP, TRAIT_KEENEARS)
	subclass_stats = list(
		STATKEY_SPD = 4,
		STATKEY_CON = -2,
		STATKEY_INT = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
	)
	subclass_stashed_items = list(
		"Dagger" = /obj/item/rogueweapon/huntingknife/idagger/steel,
	)

/datum/outfit/job/roguetown/warband/rebellion/grunt/conspirator/pre_equip(mob/living/carbon/human/H)
	..()

	var/coverclass = list("Servant","Churchling","Guildsman","Farmer","Surgeon")
	var/coverclass_choice = input("Before I was inspired to join the Rebellion, I was an unremarkable...", "I REMEMBER") as anything in coverclass
	switch(coverclass_choice)
		if("Servant")
			if(should_wear_femme_clothes(H))
				head = /obj/item/clothing/head/roguetown/armingcap
				armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/black
				shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
				cloak = /obj/item/clothing/cloak/apron/waist
				H.job = "Maid"
				H.advjob = "Maid"
			else
				pants = /obj/item/clothing/under/roguetown/trou
				shoes = /obj/item/clothing/shoes/roguetown/shortboots
				armor = /obj/item/clothing/suit/roguetown/armor/workervest
				gloves = /obj/item/clothing/gloves/roguetown/fingerless
				H.job = "Servant"
				H.advjob = "Servant"
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/guard
			backl = /obj/item/storage/backpack/rogue/satchel
			belt = /obj/item/storage/belt/rogue/leather
			beltr = /obj/item/storage/keyring/servant
			beltl = /obj/item/storage/belt/rogue/pouch/coins/poor

			H.adjust_skillrank_up_to(/datum/skill/craft/cooking = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/crafting = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/sewing = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/medicine = 1, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/reading = 1, TRUE)
			H.change_stat("intelligence", 1)
			H.change_stat("perception", 2)
			ADD_TRAIT(H, TRAIT_CICERONE, TRAIT_GENERIC)


		if("Churchling")
			if(H.patron.type == /datum/patron/divine/undivided)
				neck = /obj/item/clothing/neck/roguetown/psicross/undivided
			if(H.patron.type == /datum/patron/divine/astrata)
				neck = /obj/item/clothing/neck/roguetown/psicross/astrata
			if(H.patron.type == /datum/patron/divine/noc)
				neck = /obj/item/clothing/neck/roguetown/psicross/noc
				backpack_contents = (/obj/item/reagent_containers/glass/bottle/rogue/strongmanapot)
			if(H.patron.type == /datum/patron/divine/ravox)
				neck = /obj/item/clothing/neck/roguetown/psicross/ravox
				backpack_contents = (/obj/item/book/rogue/law)
			if(H.patron.type == /datum/patron/divine/necra)
				neck = /obj/item/clothing/neck/roguetown/psicross/necra
				backpack_contents = list(/obj/item/rogueweapon/shovel/small, /obj/item/natural/bundle/stick)
			if(H.patron.type == /datum/patron/divine/abyssor)
				neck = /obj/item/clothing/neck/roguetown/psicross/abyssor
			if(H.patron.type == /datum/patron/divine/dendor)
				neck = /obj/item/clothing/neck/roguetown/psicross/dendor
			if(H.patron.type == /datum/patron/divine/malum)
				neck = /obj/item/clothing/neck/roguetown/psicross/malum
			if(H.patron.type == /datum/patron/divine/xylix)
				neck = /obj/item/clothing/neck/roguetown/luckcharm
			if(H.patron.type == /datum/patron/divine/eora)
				neck = /obj/item/clothing/neck/roguetown/psicross/eora
			if(H.patron.type == /datum/patron/divine/pestra)
				neck = /obj/item/clothing/neck/roguetown/psicross/pestra
				backpack_contents = list(/obj/item/natural/bundle/cloth, /obj/item/needle)
			if(H.patron.type == /datum/patron/inhumen/zizo)
				neck = /obj/item/clothing/neck/roguetown/psicross
			if(H.patron.type == /datum/patron/inhumen/graggar)
				neck = /obj/item/clothing/neck/roguetown/psicross
			if(H.patron.type == /datum/patron/inhumen/matthios)
				neck = /obj/item/clothing/neck/roguetown/psicross
			if(H.patron.type == /datum/patron/inhumen/baotha)
				neck = /obj/item/clothing/neck/roguetown/psicross
			if(H.patron.type == /datum/patron/old_god)
				neck = /obj/item/clothing/neck/roguetown/psicross
			var/datum/devotion/C = new /datum/devotion(H, H.patron)
			C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_3)
			if(should_wear_femme_clothes(H))
				head = /obj/item/clothing/head/roguetown/armingcap
				armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
			else
				armor = /obj/item/clothing/suit/roguetown/shirt/robe
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
				pants = /obj/item/clothing/under/roguetown/tights
			
			backl = /obj/item/storage/backpack/rogue/satchel
			belt = /obj/item/storage/belt/rogue/leather/rope
			shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
			beltl = /obj/item/storage/keyring/churchie
			H.adjust_skillrank_up_to(/datum/skill/misc/medicine = 1, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/magic/holy = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/sewing = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/reading = 1, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/crafting = 1, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/cooking = 1, TRUE)
			H.job = "Churchling"
			H.advjob = "Churchling"

		if("Guildsman")
			var/guild = list("Smith","Artificer","Architect")
			var/guild_choice = input("I was a...", "I REMEMBER") as anything in guild
			switch(guild_choice)
				if("Smith")
					if(prob(50))
						head = /obj/item/clothing/head/roguetown/hatblu
					H.adjust_skillrank_up_to(/datum/skill/craft/crafting = 3, TRUE)
					H.adjust_skillrank_up_to(/datum/skill/combat/wrestling = 3, TRUE)
					H.adjust_skillrank_up_to(/datum/skill/craft/blacksmithing = 5, TRUE)
					H.adjust_skillrank_up_to(/datum/skill/craft/armorsmithing = 5, TRUE)
					H.adjust_skillrank_up_to(/datum/skill/craft/weaponsmithing = 5, TRUE)
					H.adjust_skillrank_up_to(/datum/skill/craft/smelting = 4, TRUE)
					H.adjust_skillrank_up_to(/datum/skill/craft/engineering = 1, TRUE)
					H.adjust_skillrank_up_to(/datum/skill/misc/reading = 2, TRUE)
					ADD_TRAIT(H, TRAIT_TRAINED_SMITH, TRAIT_GENERIC)				
					if(should_wear_femme_clothes(H))
						armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
						shoes = /obj/item/clothing/shoes/roguetown/shortboots
					else if(should_wear_masc_clothes(H))
						shoes = /obj/item/clothing/shoes/roguetown/boots/leather
						shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt
					pants = /obj/item/clothing/under/roguetown/trou
					belt = /obj/item/storage/belt/rogue/leather
					beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
					beltr = /obj/item/roguekey/crafterguild
					cloak = /obj/item/clothing/cloak/apron/blacksmith
					backr = /obj/item/storage/backpack/rogue/satchel
					backpack_contents = list(
						/obj/item/rogueweapon/hammer/iron = 1,
						/obj/item/rogueweapon/tongs = 1,
						/obj/item/recipe_book/blacksmithing = 1,
						)
					H.job = "Guild Blacksmith"
					H.advjob = "Guild Blacksmith"
				if("Artificer")
					H.adjust_skillrank_up_to(/datum/skill/craft/crafting = 4, TRUE)
					H.adjust_skillrank_up_to(/datum/skill/craft/smelting = 4, TRUE)
					H.adjust_skillrank_up_to(/datum/skill/craft/engineering = 4, TRUE)
					H.adjust_skillrank_up_to(/datum/skill/craft/ceramics = 3, TRUE)
					H.adjust_skillrank_up_to(/datum/skill/craft/blacksmithing = 2, TRUE)
					H.adjust_skillrank_up_to(/datum/skill/craft/armorsmithing = 2, TRUE)
					H.adjust_skillrank_up_to(/datum/skill/craft/weaponsmithing = 2, TRUE)
					H.adjust_skillrank_up_to(/datum/skill/magic/arcane = 2, TRUE)
					H.adjust_skillrank_up_to(/datum/skill/craft/traps = 2, TRUE)
					H.adjust_skillrank_up_to(/datum/skill/misc/reading = 2, TRUE)

					head = /obj/item/clothing/head/roguetown/articap
					armor = /obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket
					cloak = /obj/item/clothing/cloak/apron/waist/brown
					gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith
					pants = /obj/item/clothing/under/roguetown/trou/artipants
					shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/artificer
					shoes = /obj/item/clothing/shoes/roguetown/boots/leather
					belt = /obj/item/storage/belt/rogue/leather
					beltr = /obj/item/storage/belt/rogue/pouch/coins/mid
					beltl = /obj/item/roguekey/crafterguild
					backl = /obj/item/storage/backpack/rogue/backpack
					backpack_contents = list(
						/obj/item/rogueweapon/hammer/steel = 1,
						/obj/item/lockpickring/mundane = 1,
						/obj/item/recipe_book/blacksmithing = 1,
						/obj/item/recipe_book/engineering = 1,
						/obj/item/recipe_book/ceramics = 1,
						/obj/item/recipe_book/builder = 1,
						/obj/item/recipe_book/survival = 1,
						/obj/item/clothing/mask/rogue/spectacles/golden = 1,
						/obj/item/contraption/linker = 1,
						)
					if(H.mind)
						H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
						H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/enchant_weapon)
					ADD_TRAIT(H, TRAIT_ARCYNE_T1, TRAIT_GENERIC)
					H.change_stat("strength", 1)
					H.change_stat("intelligence", 3)
					H.change_stat("endurance", 2)
					H.change_stat("constitution", 1)
					H.change_stat("perception", 1)
					H.job = "Artificer"
					H.advjob = "Artificer"
				if("Architect")
					H.adjust_skillrank_up_to(/datum/skill/misc/athletics = 4, TRUE)
					H.adjust_skillrank_up_to(/datum/skill/craft/crafting = 4, TRUE)
					H.adjust_skillrank_up_to(/datum/skill/craft/carpentry = 4, TRUE)
					H.adjust_skillrank_up_to(/datum/skill/craft/masonry = 4, TRUE)
					H.adjust_skillrank_up_to(/datum/skill/craft/engineering = 4, TRUE)
					H.adjust_skillrank_up_to(/datum/skill/labor/lumberjacking = 3, TRUE)
					H.adjust_skillrank_up_to(/datum/skill/labor/mining = 3, TRUE)
					H.adjust_skillrank_up_to(/datum/skill/misc/swimming = 2, TRUE)
					H.adjust_skillrank_up_to(/datum/skill/craft/traps = 2, TRUE)
					H.adjust_skillrank_up_to(/datum/skill/misc/reading = 2, TRUE)
					H.adjust_skillrank_up_to(/datum/skill/craft/ceramics = 2, TRUE)
					head = /obj/item/clothing/head/roguetown/hatblu
					armor = /obj/item/clothing/suit/roguetown/armor/leather/vest
					cloak = /obj/item/clothing/cloak/apron/waist/bar
					pants = /obj/item/clothing/under/roguetown/trou
					shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
					shoes = /obj/item/clothing/shoes/roguetown/boots/leather
					belt = /obj/item/storage/belt/rogue/leather
					beltr = /obj/item/flashlight/flare/torch/lantern
					beltl = /obj/item/rogueweapon/pick/steel
					backr = /obj/item/rogueweapon/stoneaxe/woodcut/steel/woodcutter
					backl = /obj/item/storage/backpack/rogue/backpack
					backpack_contents = list(
						/obj/item/rogueweapon/hammer/steel = 1,
						/obj/item/rogueweapon/handsaw = 1,
						/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
						/obj/item/rogueweapon/chisel = 1,
						/obj/item/flashlight/flare/torch = 1,
						/obj/item/flint = 1,
						/obj/item/rogueweapon/huntingknife = 1,
						/obj/item/rogueweapon/handsaw = 1,
						/obj/item/dye_brush = 1,
						/obj/item/recipe_book/engineering = 1,
						/obj/item/recipe_book/builder = 1,
						/obj/item/recipe_book/survival = 1,
						/obj/item/roguekey/crafterguild = 1
						)
					H.change_stat("strength", 1)
					H.change_stat("intelligence", 2)
					H.change_stat("endurance", 2)
					H.change_stat("constitution", 1)
					H.change_stat("fortune", 2)
					H.job = "Architect"
					H.advjob = "Architect"
		if("Farmer")
			if(should_wear_femme_clothes(H))
				armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
				shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/random
				cloak = /obj/item/clothing/cloak/apron/brown
				H.job = "Soilbride"
				H.advjob = "Soilbride"				
			else
				pants = /obj/item/clothing/under/roguetown/tights/random
				armor = /obj/item/clothing/suit/roguetown/armor/leather/vest
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
				H.job = "Soilson"
				H.advjob = "Soilson"	
			head = /obj/item/clothing/head/roguetown/armingcap
			mask = /obj/item/clothing/head/roguetown/roguehood
			neck = /obj/item/storage/belt/rogue/pouch/coins/poor
			wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
			shoes = /obj/item/clothing/shoes/roguetown/boots/leather
			belt = /obj/item/storage/belt/rogue/leather/rope
			beltr = /obj/item/storage/keyring/soilson
			backr = /obj/item/storage/backpack/rogue/satchel
			backpack_contents = list(/obj/item/recipe_book/survival = 1, /obj/item/flashlight/flare/torch = 1, /obj/item/rogueweapon/huntingknife = 1, /obj/item/flint = 1)
			H.adjust_skillrank_up_to(/datum/skill/labor/farming = 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/butchering = 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/wrestling = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/unarmed = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/tanning = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/riding = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/crafting = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/carpentry = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails = 1, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/knives = 1, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/medicine = 1, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/sewing = 1, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/cooking = 1, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/masonry = 1, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/reading = 1, TRUE)
			H.change_stat("strength", 3)
			H.change_stat("constitution", 1)
			ADD_TRAIT(H, TRAIT_SEEDKNOW, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
		if("Surgeon")
			head = /obj/item/clothing/head/roguetown/roguehood/black
			pants = /obj/item/clothing/under/roguetown/trou/apothecary
			shirt = /obj/item/clothing/suit/roguetown/shirt/apothshirt
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/black
			belt = /obj/item/storage/belt/rogue/leather/rope
			neck = /obj/item/storage/belt/rogue/pouch/coins/poor
			beltl = /obj/item/storage/belt/rogue/surgery_bag/full/physician
			beltr = /obj/item/roguekey/physician
			id = /obj/item/scomstone/bad
			r_hand = /obj/item/rogueweapon/woodstaff/
			shoes = /obj/item/clothing/shoes/roguetown/boots/leather
			backr = /obj/item/storage/backpack/rogue/satchel
			backpack_contents = list(
				/obj/item/natural/worms/leech/cheele = 1,
				/obj/item/recipe_book/alchemy = 1,
				/obj/item/clothing/mask/rogue/physician = 1,
			)
			H.adjust_skillrank_up_to(/datum/skill/misc/medicine = 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/reading = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/alchemy = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/sewing = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/wrestling = 1, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/crafting = 1, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/athletics = 1, TRUE)
			H.change_stat("intelligence", 3)
			H.change_stat("perception", 2)
			ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
			if(H.mind)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)	
			H.job = "Apothecary"
			H.advjob = "Apothecary"
