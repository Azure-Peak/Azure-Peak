
/datum/job/roguetown/heartfelt/lord
	title = "Lord of Heartfelt"
	tutorial = "You are the Lord of Heartfelt, ruler of a prosperous borderlands now in Azuria. \
	However, with the increase in banditry, necromancy, deadite risings, and increasing sea raider raids, there are rumors abound that Heartfelt is not what it used to be. \
	Travellers often warn of Heartfelt having fallen already, and words of secretive cultists isn't unheard of."
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED)
	outfit = null
	total_positions = 1
	spawn_positions = 0
	job_traits = list(TRAIT_NOBLE, TRAIT_HEAVYARMOR, TRAIT_HEARTFELT)
	noble_income = 50
	advclass_cat_rolls = list(CTAG_HFT_LORD)
	job_subclasses = list(
		/datum/advclass/heartfelt/lord/lord,
		/datum/advclass/heartfelt/lord/archmage,
		/datum/advclass/heartfelt/lord/chief,
		)

// DEFAULT - STANDARD OLD CLASS

/datum/advclass/heartfelt/lord/lord
	name = "Lord of Heartfelt"
	tutorial = "You are the Lord of Heartfelt, ruler of a prosperous borderlands now in Azuria. \
	However, with the increase in banditry, necromancy, deadite risings, and increasing sea raider raids, there are rumors abound that Heartfelt is not what it used to be. \
	Travellers often warn of Heartfelt having fallen already, and words of secretive cultists isn't unheard of."
	category_tags = list(CTAG_HFT_LORD)
	maximum_possible_slots = 1
	outfit = /datum/outfit/job/heartfelt/lord/lord
	pickprob = 100
	class_select_category = CLASS_CAT_HFT_COURT
	traits_applied = list(TRAIT_NOBLE, TRAIT_HEAVYARMOR, TRAIT_HEARTFELT)

	subclass_stashed_items = list("Heartfelt Caparison" = /obj/item/caparison/heartfelt)
	subclass_virtues = list(
		/datum/virtue/utility/riding
	)

	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_LCK = 5,
	)

	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/heartfelt/lord/lord/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	belt = /obj/item/storage/belt/rogue/leather/black
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	pants = /obj/item/clothing/under/roguetown/tights/black
	armor = /obj/item/clothing/suit/roguetown/armor/heartfelt
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	beltl = /obj/item/rogueweapon/scabbard/sword/noble
	r_hand = /obj/item/rogueweapon/sword/long/marlin
	beltr = /obj/item/rogueweapon/huntingknife
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel // Paper and Feather
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rogueweapon/scabbard/sheath/noble = 1,
		/obj/item/storage/belt/rogue/pouch/coins/veryrich = 2,
		/obj/item/natural/feather = 1,
		/obj/item/paper/scroll = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 2,
		)
	id = /obj/item/scomstone
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/heartfelt)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/heartfelt/retreat)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/heartfelt/bolster)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/heartfelt/charge)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/heartfelt/forheartfelt)
		H.verbs |= list(/mob/living/carbon/human/mind/proc/setordersheartfelt)

/datum/advclass/heartfelt/lord/archmage
	name = "Archmagos of Heartfelt"
	tutorial = "You are the Archmagos of Heartfelt, ruler of a acryne-borderlands in Azuria. \
	However, with the increase in banditry, necromancy, deadite risings, and increasing sea raider raids, there are rumors abound that Heartfelt is not what it used to be. \
	Travellers often warn of Heartfelt having fallen already, and words of secretive cultists isn't unheard of."
	category_tags = list(CTAG_HFT_LORD)
	maximum_possible_slots = 1
	outfit = /datum/outfit/job/heartfelt/lord/archmage
	pickprob = 100
	class_select_category = CLASS_CAT_HFT_COURT
	traits_applied = list(TRAIT_NOBLE, TRAIT_ARCYNE, TRAIT_INTELLECTUAL, TRAIT_HEARTFELT, TRAIT_ALCHEMY_EXPERT)

	subclass_stashed_items = list("Heartfelt Caparison" = /obj/item/caparison/heartfelt)
	subclass_virtues = list(
		/datum/virtue/utility/riding
	)

	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 2,
		STATKEY_LCK = 5,
	)

	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/heartfelt/lord/archmage/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	belt = /obj/item/storage/belt/rogue/leather/black
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	pants = /obj/item/clothing/under/roguetown/tights/black
	armor = /obj/item/clothing/cloak/poncho/fancycoat
	neck = /obj/item/storage/belt/rogue/pouch/coins/veryrich
	beltl = /obj/item/flashlight/flare/torch/lantern
	r_hand = /obj/item/rogueweapon/woodstaff/implement/grand
	beltr = /obj/item/rogueweapon/huntingknife
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel // Paper and Feather
	backpack_contents = list(
		/obj/item/recipe_book/alchemy,
		/obj/item/book/spellbook,
		/obj/item/rogueweapon/huntingknife/idagger/silver/arcyne,
		/obj/item/natural/feather = 1,
		/obj/item/paper/scroll = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/strongmanapot = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 1,
		/obj/item/chalk = 1,
	)
	id = /obj/item/scomstone
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/heartfelt)
		H.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 1, "minor" = 1, "utilities" = 4, "ward" = TRUE))
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.change_stat("speed", -1)
		H.change_stat("intelligence", 1)
		H.change_stat("perception", 1)
		if(H.mind?.mage_aspect_config)
			H.mind.mage_aspect_config["utilities"] += 2
			H.mind.check_learnspell()

// Funny role I thought I'd make. Reminded me of Canute and his Jarldom

/datum/advclass/heartfelt/lord/chief
	name = "Chieftain of Heartfelt"
	tutorial = "You are the Chieftain of Heartfelt, Chieftain of a once tribal lands over Azuria. Now, you rule it under the watchful gaze of the Grand Duchy. \
	However, with the increase in banditry, necromancy, deadite risings, and increasing sea raider raids, there are rumors abound that Heartfelt is not what it used to be. \
	Travellers often warn of Heartfelt having fallen already, and words of secretive cultists isn't unheard of."
	category_tags = list(CTAG_HFT_LORD)
	maximum_possible_slots = 1
	outfit = /datum/outfit/job/heartfelt/lord/chief
	pickprob = 100
	class_select_category = CLASS_CAT_HFT_COURT
	traits_applied = list(TRAIT_NOBLE, TRAIT_MEDIUMARMOR, TRAIT_CIVILIZEDBARBARIAN, TRAIT_STRONGBITE, TRAIT_HEARTFELT)

	subclass_stashed_items = list("Heartfelt Caparison" = /obj/item/caparison/heartfelt)
	subclass_virtues = list(
		/datum/virtue/utility/riding
	)

	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_WIL = 3,
		STATKEY_CON = 2,
		STATKEY_PER = -2,
		STATKEY_INT = -1,
		STATKEY_LCK = 5,
	)

	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/heartfelt/lord/chief/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/sallet/beastskull
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	belt = /obj/item/storage/belt/rogue/leather/battleskirt/faulds
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	cloak = /obj/item/clothing/cloak/darkcloak/minotaur/red
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine
	neck = /obj/item/clothing/neck/roguetown/leather
	beltr = /obj/item/rogueweapon/huntingknife
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel // Paper and Feather
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rogueweapon/scabbard/sheath/noble = 1,
		/obj/item/storage/belt/rogue/pouch/coins/veryrich = 1,
		/obj/item/natural/feather = 1,
		/obj/item/paper/scroll = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 1,
		)
	id = /obj/item/scomstone
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/heartfelt)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/heartfelt/retreat)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/heartfelt/bolster)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/heartfelt/charge)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/heartfelt/forheartfelt)
		H.verbs |= list(/mob/living/carbon/human/mind/proc/setordersheartfelt)
	var/weapons = list("Double-Headed Greataxe", "Great Mace", "Battle Axe + Shield", , "Warhammer + Shield")
	var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Double-Headed Greataxe")
			r_hand = /obj/item/rogueweapon/greataxe/steel/doublehead
		if("Great Mace")
			r_hand = /obj/item/rogueweapon/mace/goden/steel
		if("Battle Axe + Shield")
			r_hand = /obj/item/rogueweapon/stoneaxe/battle
			l_hand = /obj/item/rogueweapon/shield/tower/metal
		if("Warhammer + Shield")
			r_hand = /obj/item/rogueweapon/mace/warhammer
			l_hand = /obj/item/rogueweapon/shield/tower/metal
		else //In case they DC or don't choose close the panel, etc
			r_hand = /obj/item/rogueweapon/greataxe/steel/doublehead
