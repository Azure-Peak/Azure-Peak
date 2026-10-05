// Azurian lesser-Azurcaephan knight mercenaries. Not as fancy as proper Azurcaephans, but still brawly.
/datum/advclass/mercenary/azurknight
	name = "Redplume of Heartfelt"
	tutorial = "Azurian battlemages hailing from the northern stronghold of Heartfelt trained to use any form of weaponry. Wielding sharp blades and thick maces of all lengths and shapes, these Azurian battlemages still serve their own purse before they serve the Duchy. Not truly as agile or flamboyant as the common spellblade, they instead heavily invest into their armor to protect themselves with."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/mercenary/azurknight
	class_select_category = CLASS_CAT_AZURIA
	category_tags = list(CTAG_MERCENARY, CTAG_MERCPARTY_BULWARK)
	cmode_music = 'sound/music/combat_knight.ogg'
	subclass_languages = list(/datum/language/oldazurian)
	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_SPD = -3,
		STATKEY_WIL = 2,
		STATKEY_CON = 1,
		STATKEY_PER = 3,
		STATKEY_STR = 1,
		STATKEY_LCK = -1 //heartfelt in shambles
	)
	subclass_stashed_items = list("Heartfelt Caparison" = /obj/item/caparison/heartfelt) //no free riding virtue, however. Get yo' own Saiga, dawg.
	
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 4) //no majors, no minors!
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/arcyne = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/mercenary/azurknight/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/recall_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/empower_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/bind_weapon/armament)

	H.adjust_blindness(-3)
	var/classes = list("Bladebearer","Macebearer","Flailbearer", "Axebearer", "Hookbearer") //all two-handers
	if(H.mind)
		var/classchoice = input(H, "Choose your preferences", "Available archetypes") as anything in classes
		H.set_blindness(0)
		to_chat(H, span_warning("Redplumes are trained in many a weapon, but oft find themselves favoring a type most."))
		switch(classchoice)
			if("Bladebearer")
				r_hand = /obj/item/rogueweapon/greatsword/elfgsword
			if("Macebearer")
				r_hand = /obj/item/rogueweapon/mace/goden/steel
			if("Flailbearer")
				r_hand = /obj/item/rogueweapon/flail/peasantwarflail/iron 
			if("Axebearer")
				r_hand = /obj/item/rogueweapon/greataxe/steel/knight
			if("Hookbearer")
				r_hand = /obj/item/rogueweapon/spear/billhook
				
	head = /obj/item/clothing/head/roguetown/helmet/heavy/frogmouth/greatplume/heartfelt //sorry ser. 90* cone for you.
	armor = /obj/item/clothing/suit/roguetown/armor/heartfelt/hand //The Big one. Covers all limbs (but not extremities).
	shoes = /obj/item/clothing/shoes/roguetown/boots
	wrists = /obj/item/clothing/wrists/roguetown/bracers/jackchain
	gloves = /obj/item/clothing/gloves/roguetown/leather
	//backr = 
	backl = /obj/item/storage/backpack/rogue/satchel
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	pants = /obj/item/clothing/under/roguetown/trou/leather
	neck = /obj/item/roguekey/mercenary
	belt = /obj/item/storage/belt/rogue/leather/battleskirt/faulds/red
	//beltr = 
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backpack_contents = list(
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel = 1,
		)
	
	change_origin(H, /datum/virtue/origin/azuria, "Mercenary order") //Azurknights of Heartfelt. You better be from here dawg!
	to_chat(H, span_warning("You start with Bind, Recall and Empower Weapon. Remember to Bind your weapon so you can build up Arcyne Momentum."))
	H.merctype = 0 
