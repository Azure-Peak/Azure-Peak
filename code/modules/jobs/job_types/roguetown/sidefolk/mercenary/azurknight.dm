// Azurian lesser-Azurcaephan knight mercenaries. Not as fancy as proper Azurcaephans, but still brawly.
/datum/advclass/mercenary/azurknight
	name = "Azurknight of Heartfelt"
	tutorial = "Azurian mercenary-knights hailing from the northern stronghold of Heartfelt wielding sharp blades of all lengths. Not truly as agile as the common spellblades, they instead heavily invest into their armor to protect themselves with."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/mercenary/azurknight
	class_select_category = CLASS_CAT_AZURIA
	category_tags = list(CTAG_MERCENARY, CTAG_MERCPARTY_BULWARK)
	cmode_music = 'sound/music/combat_knight.ogg'
	subclass_languages = list(/datum/language/oldazurian)
	traits_applied = list(TRAIT_ARCYNE, TRAIT_HEAVYARMOR, TRAIT_HEARTFELT)
	subclass_stats = list(
		STATKEY_INT = 1,
		STATKEY_PER = 1,
		STATKEY_STR = 1,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
	)
	subclass_stashed_items = list("Heartfelt Caparison" = /obj/item/caparison/heartfelt) //no free riding virtue, however. Get yo' own Saiga, dawg.
	
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 1, "utilities" = 3)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN,
	)
/datum/outfit/job/roguetown/mercenary/azurknight
/datum/outfit/job/roguetown/mercenary/azurknight/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/recall_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/empower_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/bind_weapon)
		
		to_chat(H, span_warning("You are an Azurknight heeding from the bastion of Heartfelt, an Azurian spellblade returning to the heartland to find employ and coin."))
		var/helmets = list(
			"Roundface Bascinet"	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/roundface,
			"Snouted Roundface Bascinet"	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/roundface/snouted,
			)
		var/helmchoice = input(H, "Choose your Helm.", "Adorn Your Head") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]
		
		var/weapons = list("Stecher (Longsword)", "Broadsword", "Sabre")
		var/weapon_choice = input(H, "Choose your WEAPON.", "Adorn Your Scabbard") as anything in weapons
		switch(weapon_choice)
			if("Stecher (Longsword)")
				r_hand = /obj/item/rogueweapon/sword/long/ap //"A unique longsword from the highest plateaus of the Azure Peak"
			if("Broadsword")
				r_hand = /obj/item/rogueweapon/sword/long/broadsword/steel
			if("Sabre")
				r_hand = /obj/item/rogueweapon/sword/sabre

	H.adjust_blindness(-3)
	//head = occupied by helmet choice
	mask = /obj/item/clothing/head/roguetown/roguehood/shroudscarlet
	armor = /obj/item/clothing/suit/roguetown/armor/heartfelt/hand //The Big one. Covers all limbs (but not extremities).
	shoes = /obj/item/clothing/shoes/roguetown/boots
	//cloak = 
	//wrists = 
	gloves = /obj/item/clothing/gloves/roguetown/leather
	backl = /obj/item/storage/backpack/rogue/satchel
	//backr = 
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	pants = /obj/item/clothing/under/roguetown/trou/leather
	//neck = 
	belt = /obj/item/storage/belt/rogue/leather/steel/tasset
	//beltl = 
	beltr = /obj/item/rogueweapon/scabbard/sword
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/roguekey/mercenary = 1,
		)
	
	change_origin(H, /datum/virtue/origin/azuria, "Mercenary order") //Azurknights of Heartfelt. You better be from here dawg!

	to_chat(H, span_warning("You start with Bind, Recall and Empower Weapon. Remember to Bind your weapon so you can build up Arcyne Momentum."))

	
	H.merctype = 0 
