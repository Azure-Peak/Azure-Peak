/datum/advclass/sfighter
	name = "Battlemaster"
	tutorial = "You are a seasoned weapon specialist, clad in maille, with years of experience in warfare and battle under your belt."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/sfighter
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander2.ogg'
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_MEDIUMARMOR)
	class_select_category = CLASS_CAT_WARRIOR
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT, CTAG_LICKER_WRETCH)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 1,
		STATKEY_CON = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/sfighter/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are a seasoned weapon specialist, clad in maille, with years of experience in warfare and battle under your belt."))
	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
	H.set_blindness(0)
	if(H.mind)
		var/weapons = list("Short Sword & Iron Shield","Arming Sword & Wood Shield","Longsword & +1 Wrestling","Battle Axe & Wood Shield","Mace & Iron Shield","Flail & Iron Shield","Billhook")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Short Sword & Iron Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				backr = /obj/item/rogueweapon/shield/iron
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/short
			if("Arming Sword & Wood Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltr = /obj/item/rogueweapon/scabbard/sword
				backr = /obj/item/rogueweapon/shield/wood
				r_hand = /obj/item/rogueweapon/sword
			if("Longsword & +1 Wrestling")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_JOURNEYMAN, TRUE)
				backr = /obj/item/rogueweapon/sword/long
				beltr = /obj/item/rogueweapon/scabbard/sword
			if("Battle Axe & Wood Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				backr = /obj/item/rogueweapon/shield/wood
				beltr = /obj/item/rogueweapon/stoneaxe/battle
			if("Mace & Iron Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltr = /obj/item/rogueweapon/mace/steel //All the other weapons are steel too.
				backr = /obj/item/rogueweapon/shield/iron
			if("Flail & Iron Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltr = /obj/item/rogueweapon/flail/sflail
				backr = /obj/item/rogueweapon/shield/iron
			if("Billhook")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/spear/billhook
				backr = /obj/item/rogueweapon/scabbard/gwstrap
		var/armors = list("Chainmaille Set","Iron Breastplate","Gambeson & Helmet","Light Raneshi Armor")
		var/armor_choice = input(H, "Choose your armor.", "TAKE UP ARMOR") as anything in armors
		switch(armor_choice)
			if("Chainmaille Set")
				armor = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
				shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/random//giving them something to wear under their armors
				pants = /obj/item/clothing/under/roguetown/chainlegs/iron
				neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
				gloves = /obj/item/clothing/gloves/roguetown/chain/iron
			if("Iron Breastplate")
				armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron
				neck = /obj/item/clothing/neck/roguetown/coif/heavypadding
				shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/random
				pants = /obj/item/clothing/under/roguetown/splintlegs/iron
				gloves = /obj/item/clothing/gloves/roguetown/angle
			if("Gambeson & Helmet")
				armor = /obj/item/clothing/suit/roguetown/armor/gambeson
				neck = /obj/item/clothing/neck/roguetown/coif/padded//neck cover
				shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/random
				wrists = /obj/item/clothing/wrists/roguetown/splintarms/iron//adding it since this set feels far too weak compared to the other two, gets one helmet and arm cover at least
				pants = /obj/item/clothing/under/roguetown/trou/leather
				head = /obj/item/clothing/head/roguetown/helmet/kettle
				gloves = /obj/item/clothing/gloves/roguetown/angle
			if("Light Raneshi Armor")
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/raneshen
				pants = /obj/item/clothing/under/roguetown/trou/leather/pontifex/raneshen
				head = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab
				gloves = /obj/item/clothing/gloves/roguetown/angle
	belt = /obj/item/storage/belt/rogue/leather
	backl = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/brown
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)

/datum/advclass/sfighter/duelist
	name = "Duelist"
	tutorial = "You are an esteemed swordsman who foregoes armor in exchange for a more nimble fighting style."
	outfit = /datum/outfit/job/roguetown/adventurer/duelist
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander2.ogg'
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_DODGEEXPERT, TRAIT_DECEIVING_MEEKNESS)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_STR = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/duelist/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are an esteemed swordsman who foregoes armor in exchange for a more nimble fighting style."))
	H.set_blindness(0)
	if(H.mind)
		var/weapons = list("Rapier & Parrying Dagger","Sabre & Buckler","Messer & Buckler","Dagger & Parrying Dagger","Dual Wield Shortswords")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Rapier & Parrying Dagger")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)//So it actually parries with said dagger.
				l_hand = /obj/item/rogueweapon/sword/rapier
				r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/parrying
				backr = /obj/item/rogueweapon/scabbard/sword
			if("Sabre & Buckler")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				l_hand = /obj/item/rogueweapon/sword/sabre
				r_hand = /obj/item/rogueweapon/shield/buckler
				beltr = /obj/item/rogueweapon/scabbard/sword
			if("Messer & Buckler")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				l_hand = /obj/item/rogueweapon/sword/short/messer/duelist
				r_hand = /obj/item/rogueweapon/shield/buckler
				beltr = /obj/item/rogueweapon/scabbard/sword
			if("Dagger & Parrying Dagger")
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel
				r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/parrying
				beltr = /obj/item/rogueweapon/scabbard/sheath
			if("Dual Wield Shortswords")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
				l_hand = /obj/item/rogueweapon/sword/short
				r_hand = /obj/item/rogueweapon/sword/short
				beltr = /obj/item/rogueweapon/scabbard/sword
				beltl = /obj/item/rogueweapon/scabbard/sword

		var/armors = list("Classical Set","Cuirass Set")
		var/armor_choice = input(H, "Choose your armor.", "TAKE UP ARMOR") as anything in armors
		switch(armor_choice)
			if("Classical Set")
				mask = /obj/item/clothing/mask/rogue/duelmask
				cloak = /obj/item/clothing/cloak/half
				armor = /obj/item/clothing/suit/roguetown/armor/leather
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
				gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
			if("Cuirass Set")
				cloak = /obj/item/clothing/suit/roguetown/armor/longcoat
				armor = /obj/item/clothing/suit/roguetown/armor/leather/cuirass
				shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/white
				gloves = /obj/item/clothing/gloves/roguetown/leather

	head = /obj/item/clothing/head/roguetown/duelhat
	neck = /obj/item/clothing/neck/roguetown/gorget
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)

/datum/advclass/sfighter/barbarian
	name = "Barbarian"
	tutorial = "You are a brutal warrior, who has foregone armor in favor of pure strength. Crush your enemies, see them driven before you, and hear the lamentations of their women! Oh, and you can specialize in unarmed combat and wrestling."
	outfit = /datum/outfit/job/roguetown/adventurer/barbarian
	cmode_music = 'sound/music/cmode/antag/combat_darkstar.ogg'
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_CRITICAL_RESISTANCE, TRAIT_NOPAINSTUN)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_CON = 2,
		STATKEY_WIL = 1,
		STATKEY_INT = -2,
	)
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
	)
	extra_context = "This subclass has two disciplines to choose from: one provides Expert skills in fistfighting and the 'Expert Pugilist' trait, while the other provides unique equipment and a one-point exchange of Speed for Perception."

/datum/outfit/job/roguetown/adventurer/barbarian/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	to_chat(H, span_warning("You are a brutal warrior, who has foregone armor in favor of pure strength. Crush your enemies, see them driven before you, and hear the lamentations of their women! Oh, and you can specialize in unarmed combat and wrestling."))
	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
	H.set_blindness(0)
	if(H.mind)
		var/weapons = list("Bronze Katar","Bronze Sword","Bronze Axe","Bronze Mace","Bronze Spear","Discipline - Whiphunter","Discipline - Unarmed")
		var/weapon_choice = input(H, "Choose your WEAPON.", "TAKE UP ARMS.") as anything in weapons
		switch(weapon_choice)
			if("Bronze Katar")
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
				head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
				r_hand = /obj/item/rogueweapon/katar/bronze
				gloves = /obj/item/clothing/gloves/roguetown/bandages
			if("Bronze Axe")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
				head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
				r_hand = /obj/item/rogueweapon/stoneaxe/woodcut/bronze
				gloves = /obj/item/clothing/gloves/roguetown/bandages
			if("Bronze Sword")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/bronze
				gloves = /obj/item/clothing/gloves/roguetown/bandages
			if("Bronze Mace")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
				head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
				r_hand = /obj/item/rogueweapon/mace/bronze
				gloves = /obj/item/clothing/gloves/roguetown/bandages
			if("Bronze Spear")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
				r_hand = /obj/item/rogueweapon/spear/bronze
				gloves = /obj/item/clothing/gloves/roguetown/bandages
			if("Discipline - Whiphunter")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
				head = /obj/item/clothing/head/roguetown/headband/monk/barbarian
				armor = /obj/item/clothing/suit/roguetown/armor/leather/hide
				r_hand = /obj/item/rogueweapon/whip/bronze
				gloves = /obj/item/clothing/gloves/roguetown/bandages
				H.change_stat(STATKEY_SPD, -1) //Little more protection, little less speed.
				H.change_stat(STATKEY_PER, 1) //Allows for more critical usage of the Whip's strengths.
			if ("Discipline - Unarmed")
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
				ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
				head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
				gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
		belt = /obj/item/storage/belt/rogue/leather/battleskirt/barbarian
		pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/bronzeskirt
		shoes = /obj/item/clothing/shoes/roguetown/boots/furlinedboots
		wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	if(should_wear_masc_clothes(H))
		H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
		backl = /obj/item/storage/backpack/rogue/satchel
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/armor/leather/bikini
		backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife/bronze = 1,
		)

/datum/advclass/sfighter/ironclad
	name = "Ironclad"
	tutorial = "You are a warrior who puts their trust in durable armor. The best offense is a good defense."
	outfit = /datum/outfit/job/roguetown/adventurer/ironclad
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
		STATKEY_CON = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/ironclad/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	if(H.mind)
		to_chat(H, span_warning("You put your trust into your durable armor. The best offense is a good defense."))
		var/helmets = list(
			"Sallet"			= /obj/item/clothing/head/roguetown/helmet/sallet/iron,
			"Visored Sallet"	= /obj/item/clothing/head/roguetown/helmet/sallet/visored/iron,
			"Kettle Helmet"		= /obj/item/clothing/head/roguetown/helmet/kettle/iron,
			"Bucket Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket/iron,
			"Knight Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/iron,
			"None"
			)
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]

		var/armors = list(
			"Breastplate + Hauberk",
			"Half-Plate + Light Gambeson"
			)
		var/armorchoice = input(H, "Choose your armor.", "TAKE UP ARMOR") as anything in armors
		switch(armorchoice)
			if("Breastplate + Hauberk")
				armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
			if("Half-Plate + Light Gambeson")
				armor = /obj/item/clothing/suit/roguetown/armor/plate/iron
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light

		var/legs = list(
			"Chain Chausses"	= /obj/item/clothing/under/roguetown/chainlegs/iron,
			"Chain Kilt"		= /obj/item/clothing/under/roguetown/chainlegs/iron/kilt
			)
		var/legschoice = input(H, "Choose your Pants.", "TAKE UP PANTS") as anything in legs
		pants = legs[legschoice]
	gloves = /obj/item/clothing/gloves/roguetown/chain/iron
	neck = /obj/item/clothing/neck/roguetown/bevor/iron
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	belt = /obj/item/storage/belt/rogue/leather/battleskirt/black
	backl = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/repair_kit/metal/bad = 1,
		)
	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
	H.set_blindness(0)
	if(H.mind)
		var/weapons = list("Executioner's Sword","Warhammer + Shield","Flail + Shield","Lucerne","Greataxe")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Executioner's Sword")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				backr = /obj/item/rogueweapon/sword/long/exe
			if("Warhammer + Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltr = /obj/item/rogueweapon/mace/warhammer
				backr = /obj/item/rogueweapon/shield/iron
			if("Flail + Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltr = /obj/item/rogueweapon/flail
				backr = /obj/item/rogueweapon/shield/iron
			if("Lucerne")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/eaglebeak/lucerne
				backr = /obj/item/rogueweapon/scabbard/gwstrap
			if("Greataxe")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/greataxe
				backr = /obj/item/rogueweapon/scabbard/gwstrap

/datum/advclass/sfighter/mhunter
	name = "Exorcist"
	tutorial = "You are a specialist who hunts terrible monsters; nitebeasts, vampyres, deadites and more. Your humenity might be limiting - but with silver weapons and steel maille, you may yet slight the odds in your favor."
	outfit = /datum/outfit/job/roguetown/adventurer/mhunter
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander2.ogg'
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_PURITAN_ADVENTURER, TRAIT_ALCHEMY_EXPERT)
	maximum_possible_slots = 5 //Not a Wretch or Towner, but still conditionally lethal for an Adventurer - especially with steel coverage and round-start access to silver weapons. Adjust the amount of available slots as needed.
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_PER = 2,
		STATKEY_WIL = 1,
	) //Follows the Adventurer's seven-point statblock rule. Adds an eighth point to an unoccupied statkey, when a discipline is selected.

	age_mod = /datum/class_age_mod/exorcist

	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		)
	extra_context = "This subclass can choose a silver weapon to spawn with, and has three disciplines to pick from: each one provides a different level of armor training, a unique trait, and a minor one-point boon to certain stats. 'Old' characters are more proficient in this subclass."

/datum/outfit/job/roguetown/adventurer/mhunter/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	to_chat(H, span_warning("You are a specialist who hunts terrible monsters; nitebeasts, vampyres, deadites and more. Your humenity might be limiting - but with silver weapons and steel maille, you may yet slight the odds in your favor."))
	H.verbs |= /mob/living/carbon/human/proc/faith_test //Allows the Exorcist to interrogate others for their faith. Trait's agnostically worded, to allow more flexiable usage by Pantheoneers and Ascendants in this role.
	H.verbs |= /mob/living/carbon/human/proc/torture_victim //Not as scary as it sounds. Mostly. Okay, just a little bit.
	if(H.mind)
		var/silver = list("Silver Dagger","Silver Shortsword","Silver Arming Sword","Silver Rapier","Silver Longsword","Silver Broadsword","Silver Mace","Silver Warhammer","Silver Morningstar","Silver Whip","Silver War Axe","Silver Poleaxe","Silver Spear","Silver Quarterstaff")
		var/silver_choice = input(H, "Choose your WEAPON.", "PREPARE YOUR ARMS.") as anything in silver //Trim down to five or six choices, later? See what's the most popular, first. Gives people a chance to experiment with all of the new silver weapons.
		switch(silver_choice)
			if("Silver Dagger")
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/huntingknife/idagger/silver
				beltr = /obj/item/rogueweapon/scabbard/sheath
			if("Silver Shortsword")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/sword/short/silver
				beltr = /obj/item/rogueweapon/scabbard/sword
			if("Silver Arming Sword")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/sword/silver
				beltr = /obj/item/rogueweapon/scabbard/sword
			if("Silver Rapier")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/sword/rapier/silver
				beltr = /obj/item/rogueweapon/scabbard/sword
			if("Silver Longsword")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/sword/long/silver
				beltr = /obj/item/rogueweapon/scabbard/sword
			if("Silver Broadsword")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/sword/long/kriegmesser/silver
				beltr = /obj/item/rogueweapon/scabbard/sword
			if("Silver Mace")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/mace/steel/silver
			if("Silver Warhammer")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/mace/warhammer/steel/silver
			if("Silver Morningstar")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/flail/sflail/silver
			if("Silver Whip")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/whip/silver
			if("Silver War Axe")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/stoneaxe/woodcut/silver
			if("Silver Poleaxe")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/greataxe/silver
				backr = /obj/item/rogueweapon/scabbard/gwstrap
			if("Silver Spear")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/spear/silver
				backr = /obj/item/rogueweapon/scabbard/gwstrap
			if("Silver Quarterstaff")
				H.adjust_skillrank_up_to(/datum/skill/combat/staves, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/silver
				backr = /obj/item/rogueweapon/scabbard/gwstrap

		var/sidearm = list("Dagger", "Parrying Dagger", "Seax", "Blessed Silver Stake", "Blessed Silver Shovel", "Greatshield")
		var/sidearm_choice = input(H, "Choose your SIDEARM.", "SAY YOUR PRAYERS.") as anything in sidearm
		switch(sidearm_choice)
			if("Dagger")
				l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if("Parrying Dagger")
				l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/parrying
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if("Seax")
				l_hand = /obj/item/rogueweapon/huntingknife/combat
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if("Blessed Silver Stake")
				l_hand = /obj/item/rogueweapon/huntingknife/idagger/silver/stake/preblessed
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if("Blessed Silver Shovel")
				l_hand = /obj/item/rogueweapon/shovel/silver/preblessed //Unlocks the secret 'Shovel Knight' subclass. No dagger skills if you take this. Doesn't scale off anything, I think. Raw style.
			if("Greatshield")
				l_hand = /obj/item/rogueweapon/shield/tower/metal
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)

		var/discipline = list("Traditionalist - Bewitched Alchemics + Hauberk", "Reformist - Dodge Expert + Haubergeon", "Orthodoxist - Plate Training + Cuirass")
		var/discipline_choice = input(H, "Choose your DISCIPLINE.", "FACE YOUR NIGHTMARE.") as anything in discipline
		switch(discipline_choice)
			if("Traditionalist - Bewitched Alchemics + Hauberk")
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_SILVER_BLESSED, TRAIT_GENERIC) //'Witcher' archetype. Weaponized alchemy gifts both immunity to nitebeastly curses and a self-suppliable +3 statboost. Well-rounded in almost every facet, but leaves less to chance.
				H.change_stat(STATKEY_INT, 1)
				H.change_stat(STATKEY_LCK, -1)
				head = /obj/item/clothing/head/roguetown/puritan/armored
				armor = /obj/item/clothing/suit/roguetown/shirt/undershirt/puritan
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
				belt = /obj/item/storage/belt/rogue/leather/black
				beltl = pick(
					/obj/item/reagent_containers/glass/bottle/alchemical/strpot,
					/obj/item/reagent_containers/glass/bottle/alchemical/conpot,
					/obj/item/reagent_containers/glass/bottle/alchemical/endpot,
					/obj/item/reagent_containers/glass/bottle/alchemical/spdpot,
					/obj/item/reagent_containers/glass/bottle/alchemical/perpot,
					/obj/item/reagent_containers/glass/bottle/alchemical/intpot,
					/obj/item/reagent_containers/glass/bottle/alchemical/lucpot,
					)
			if("Reformist - Dodge Expert + Haubergeon")
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC) //'Puritan' archetype. Closer to the Roguetown-era Inquisitor in portrayal. No armor training, but overprepared with silver throwing daggers and excellent evasive maneuvers.
				H.change_stat(STATKEY_SPD, 1)
				H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_JOURNEYMAN, TRUE)
				head = /obj/item/clothing/head/roguetown/puritan
				armor = /obj/item/clothing/suit/roguetown/shirt/undershirt/puritan
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
				belt = /obj/item/storage/belt/rogue/leather/knifebelt/black/silver
			if("Orthodoxist - Plate Training + Cuirass")
				ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_ZOMBIE_IMMUNE, TRAIT_GENERIC) //'Templar' archetype. Blessings protect from the Rot, while opening the opportunity for heavy armor usage. Well-protected and resilient, but slower and visibly identifiable as a prioritable threat.
				H.change_stat(STATKEY_CON, 1)
				H.change_stat(STATKEY_SPD, -1)
				armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/puritan
				belt = /obj/item/storage/belt/rogue/leather/black
				var/helmets = list("Puritan's Armored Hat", "Visored Sallet", "Volfskulle Bascinet", "Fluted Armet")
				var/helmet_choice = input(H, "Choose your VISAGE.", "GET PSYCHED.") as anything in helmets
				switch(helmet_choice)
					if("Puritan's Armored Hat")
						head = /obj/item/clothing/head/roguetown/puritan/armored
					if("Visored Sallet")
						head = /obj/item/clothing/head/roguetown/helmet/sallet/visored
					if("Volfskulle Bascinet")
						head = /obj/item/clothing/head/roguetown/helmet/heavy/volfplate/puritan
					if("Fluted Armet")
						head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/fluted

	backl = /obj/item/storage/backpack/rogue/satchel
	wrists = /obj/item/clothing/neck/roguetown/psicross/silver
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	pants = /obj/item/clothing/under/roguetown/tights/puritan
	cloak = /obj/item/clothing/cloak/cape/puritan
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	gloves = /obj/item/clothing/gloves/roguetown/angle
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/metal = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife = 1, //Ensures that Exorcists who take the Shovel can still butcher wildlife. Minor oversight on my part.
		)
	//Old people get the option to become glass cannons. Expert Knives + Expert in their chosen weapon, but a permenant -I STR, -I PER, -2 SPD and -2 CON debuff.

/datum/advclass/sfighter/deprived
	name = "Deprived"
	tutorial = "You are a vagrant. Your skin itches at the thought of wearing proper armor. Not after everything was taken from you. Armed with a piece of wood, it's only through your body that you endure. At least you aren't bothered by the lack of comfort like most others."
	outfit = /datum/outfit/job/roguetown/adventurer/deprived
	cmode_music = 'sound/music/cmode/antag/combat_darkstar.ogg'
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_CRITICAL_RESISTANCE, TRAIT_NOPAINSTUN, TRAIT_SHIRTLESS, TRAIT_WILD_EATER, TRAIT_OUTDOORSMAN, TRAIT_HOMESTEAD_EXPERT)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_CON = 2,
		STATKEY_WIL = 1,
		STATKEY_LCK = 1, // A single point of fortune over barbarian.
		STATKEY_INT = -2,
	)
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN
	)
	extra_context = "Challenge class. You don't get natural armor nor possessions save for a club and a wooden shield. You are ascetic in nature, requiring little for comfort."

/datum/outfit/job/roguetown/adventurer/deprived/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	to_chat(H, span_warning("The haze clears from your mind as some clarity floods back. Everything was taken from you. Mortal possessions have shown only betrayal. Your skin itches at the thought of ever trusting armor to protect your chest again."))
	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
	H.set_blindness(0)
	if(H.mind)
		r_hand = /obj/item/rogueweapon/mace/woodclub/deprived
		l_hand = /obj/item/rogueweapon/shield/wood/deprived
		pants = /obj/item/clothing/under/roguetown/loincloth/deprived
