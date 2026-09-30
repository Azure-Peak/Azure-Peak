/datum/advclass/ranger
	name = "Sentinel"
	tutorial = "You are a ranger well-versed in traversing untamed lands, with years of experience taking odd jobs as a pathfinder and bodyguard in areas of wilderness untraversable to common soldiery."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/adventurer/ranger
	class_select_category = CLASS_CAT_RANGER
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander3.ogg'
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_OUTDOORSMAN, TRAIT_EXPERT_HUNTER)
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT, CTAG_LICKER_WRETCH)
	townie_contract_gate_exempt = TRUE
	townie_contract_gate_hide_in_list = TRUE
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_SPD = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/fishing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/traps = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/hunting = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/ranger/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are a ranger well-versed in traversing untamed lands, with years of experience taking odd jobs as a pathfinder and bodyguard in areas of wilderness untraversable to common soldiery."))
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/darkgreen
	neck = /obj/item/clothing/neck/roguetown/coif
	armor = /obj/item/clothing/suit/roguetown/armor/leather/hide
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/green
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/leather
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather
	backl = /obj/item/storage/backpack/rogue/satchel
	beltr = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/bait = 1,
		/obj/item/rogueweapon/huntingknife/combat = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	if(H.mind)
		var/weapons = list("Bow","Crossbow")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Bow")
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
				beltl = /obj/item/quiver/arrows
			if("Crossbow")
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_EXPERT, TRUE)
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				beltl = /obj/item/quiver/bolt/standard

/datum/advclass/ranger/wayfarer
	name = "Wayfarer"
	tutorial = "You've spent countless years homing many trades; man-hunting, picking locks, breaking into places you had no right being.. but you are no mere thief. You are trained to track men and recover stolen goods. And Azuria is a prime paycheck.."
	outfit = /datum/outfit/job/roguetown/adventurer/assassin
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander.ogg'
	subclass_languages = list(/datum/language/thievescant)
	traits_applied = list(TRAIT_DODGEEXPERT)
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_SPD = 2,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/traps = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/assassin/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You've lived the life of a hired killer and have spent your time training with blades and crossbows alike."))
	shoes = /obj/item/clothing/shoes/roguetown/boots
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/iron
	armor = /obj/item/clothing/suit/roguetown/armor/leather
	cloak = /obj/item/clothing/cloak/raincloak/mortus
	backl = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel
	beltr = /obj/item/quiver/bolt/standard
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	H.set_blindness(0)

/datum/advclass/ranger/bombadier
	name = "Bombadier"
	tutorial = "Bombs? You've got them. Plenty of them - and the skills to make more. You've spent years training under skilled alchemists and have found the perfect mix to create some chaos - now go blow something up!"
	outfit = /datum/outfit/job/roguetown/adventurer/bombadier
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander2.ogg'
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_ALCHEMY_EXPERT, TRAIT_EXPLOSIVE_SUPPLY, TRAIT_BOMBER_EXPERT) // Bombardier get an exception - alchemy is part of the gimmick.
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_INT = 2,
		STATKEY_CON = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/traps = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/engineering = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/adventurer/bombadier/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("Bombs? You've got them. Plenty of them - and the skills to make more. You've spent years training under skilled alchemists and have found the perfect mix to create some chaos - now go blow something up!"))
	shoes = /obj/item/clothing/shoes/roguetown/boots
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	head = /obj/item/clothing/head/roguetown/roguehood
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/mageorange
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
	belt = /obj/item/storage/belt/rogue/leather
	backr = /obj/item/twstrap/bombstrap/firebomb
	backl = /obj/item/storage/backpack/rogue/satchel
	beltr = /obj/item/flashlight/flare/torch/lantern
	beltl = /obj/item/rogueweapon/mace/cudgel
	backpack_contents = list(
		/obj/item/bomb = 4,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/flint = 1,
		)
	H.set_blindness(0)

/datum/advclass/ranger/bwanderer
	name = "Biome Wanderer"
	tutorial = "You have crossed forests, marshes, and open country, learning to find food, shelter, and a way through each. Your weapons and armor suit the dangers you expect to face."
	outfit = /datum/outfit/job/roguetown/adventurer/bwanderer
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander4.ogg'
	traits_applied = list(TRAIT_OUTDOORSMAN, TRAIT_SURVIVAL_EXPERT, TRAIT_EXPERT_HUNTER)
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_INT = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/traps = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/fishing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/hunting = SKILL_LEVEL_APPRENTICE,
	)
	extra_context = "Choose an iron melee weapon, then a bow, crossbow, sling, or no ranged weapon (+1 CON). Your Wits relies on iron javelins, tossblades, a net, padded wrappings, and iron knuckles; it grants Journeyman wrestling and unarmed, Apprentice polearms and knives, plus Expert Pugilist. Light armor grants Dodge Expert and +1 SPD; medium armor grants Maille Training and +1 STR. Each armor tier has two equipment sets."

/datum/outfit/job/roguetown/adventurer/bwanderer/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You have crossed forests, marshes, and open country, learning to find food, shelter, and a way through each."))
	head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
	mask = /obj/item/clothing/head/roguetown/roguehood
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic
	armor = /obj/item/clothing/suit/roguetown/armor/leather/hide
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	neck = /obj/item/clothing/neck/roguetown/coif/padded
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	belt = /obj/item/storage/belt/rogue/leather
	cloak = /obj/item/clothing/cloak/raincloak/green
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/huntingknife/combat/iron = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/flint = 1,
		/obj/item/bait = 1,
		/obj/item/rope = 1,
		)
	H.set_blindness(0)
	if(H.mind)
		var/weapons = list("Iron Axe", "Iron Hunting Sword", "Iron Bastard Sword", "Iron Short Spear", "Iron Quarterstaff", "Your Wits - javelins, tossblades, net & knuckles (Expert Pugilist)")
		var/weapon_choice = input(H, "Choose your weapon.\nYour Wits: iron javelins, a tossblade belt, a net, padded wrappings, and iron knuckles. Grants Journeyman Wrestling and Unarmed, Apprentice Polearms and Knives, plus Expert Pugilist. This kit replaces the separate ranged weapon choice.", "TAKE UP ARMS") as anything in weapons
		var/uses_wits = (weapon_choice == "Your Wits - javelins, tossblades, net & knuckles (Expert Pugilist)")
		var/long_weapon = FALSE
		switch(weapon_choice)
			if("Iron Axe")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltr = /obj/item/rogueweapon/stoneaxe/woodcut
			if("Iron Hunting Sword")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltr = /obj/item/rogueweapon/sword/short/messer/hunting
			if("Iron Bastard Sword")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/sword/long/iron
				long_weapon = TRUE
			if("Iron Short Spear")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/spear/short
				long_weapon = TRUE
			if("Iron Quarterstaff")
				H.adjust_skillrank_up_to(/datum/skill/combat/staves, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/iron
				long_weapon = TRUE
			if("Your Wits - javelins, tossblades, net & knuckles (Expert Pugilist)")
				to_chat(H, span_notice("You trust your wits over a single weapon: snare your quarry with a net, harry it with javelins and tossblades, then close in with wrapped arms and iron knuckles."))
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_APPRENTICE, TRUE)
				ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
				belt = /obj/item/storage/belt/rogue/leather/knifebelt/iron
				beltl = /obj/item/quiver/javelin/iron
				beltr = /obj/item/net
		if(!uses_wits)
			var/ranged_weapons = list("Bow", "Crossbow", "Sling", "No Ranged Weapon (+1 CON)")
			var/ranged_choice = input(H, "Choose your ranged weapon.", "TAKE UP ARMS") as anything in ranged_weapons
			switch(ranged_choice)
				if("Bow")
					H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_JOURNEYMAN, TRUE)
					backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
					beltl = /obj/item/quiver/arrows
				if("Sling")
					H.adjust_skillrank_up_to(/datum/skill/combat/slings, SKILL_LEVEL_JOURNEYMAN, TRUE)
					beltl = /obj/item/quiver/sling/iron
					l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
				if("Crossbow")
					H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_JOURNEYMAN, TRUE)
					backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
					beltl = /obj/item/quiver/bolt/standard
				if("No Ranged Weapon (+1 CON)")
					H.change_stat(STATKEY_CON, 1)
			if(long_weapon)
				if(backr)
					l_hand = backr
				backr = /obj/item/rogueweapon/scabbard/gwstrap
		var/armor_tiers = list("Light Armor", "Medium Armor")
		var/armor_tier = input(H, "Choose your armor weight.", "TAKE UP ARMOR") as anything in armor_tiers
		switch(armor_tier)
			if("Light Armor")
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
				H.change_stat(STATKEY_SPD, 1)
				var/light_sets = list("Hide Armor", "Padded Gambeson")
				var/light_choice = input(H, "Choose your light armor.", "TAKE UP ARMOR") as anything in light_sets
				switch(light_choice)
					if("Hide Armor")
						armor = /obj/item/clothing/suit/roguetown/armor/leather/hide
						pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
					if("Padded Gambeson")
						armor = /obj/item/clothing/suit/roguetown/armor/gambeson
						pants = /obj/item/clothing/under/roguetown/trou/leather
						head = /obj/item/clothing/head/roguetown/armingcap/padded
			if("Medium Armor")
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
				H.change_stat(STATKEY_STR, 1)
				head = /obj/item/clothing/head/roguetown/helmet/kettle/iron
				pants = /obj/item/clothing/under/roguetown/chainlegs/iron
				var/medium_sets = list("Iron Mail", "Iron Breastplate")
				var/medium_choice = input(H, "Choose your medium armor.", "TAKE UP ARMOR") as anything in medium_sets
				switch(medium_choice)
					if("Iron Mail")
						armor = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
						neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
						gloves = /obj/item/clothing/gloves/roguetown/chain/iron
					if("Iron Breastplate")
						armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron
						shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
						neck = /obj/item/clothing/neck/roguetown/coif/padded
		if(uses_wits)
			wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/monk
			gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
