// Azurian lesser-Azurcaephan knight mercenaries. Not as fancy as proper Azurcaephans, but still brawly.
/datum/advclass/mercenary/azurknight
	name = "Battlemages of Heartfelt"
	tutorial = "Azurian battlemages hailing from the northern stronghold of Heartfelt trained to use the iconic Stecher longsword. Wielding sharp blades of all lengths, these Azurian battlemages still serve their own purse before they serve the Duchy. Not truly as agile or flamboyant as the common spellblade, they instead heavily invest into their armor to protect themselves with."
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
	
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 4)
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

/datum/outfit/job/roguetown/mercenary/azurknight/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/recall_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/empower_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/bind_weapon)

	H.adjust_blindness(-3)
	head = /obj/item/clothing/head/roguetown/helmet/heavy/frogmouth/greatplume/heartfelt //sorry ser. 90* cone for you.
	//mask = 
	armor = /obj/item/clothing/suit/roguetown/armor/heartfelt/hand //The Big one. Covers all limbs (but not extremities).
	shoes = /obj/item/clothing/shoes/roguetown/boots
	//cloak = 
	wrists = /obj/item/clothing/wrists/roguetown/bracers/jackchain
	gloves = /obj/item/clothing/gloves/roguetown/leather
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/sword/long/ap //"A unique longsword from the highest plateaus of the Azure Peak"
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	pants = /obj/item/clothing/under/roguetown/trou/leather
	neck = /obj/item/roguekey/mercenary
	belt = /obj/item/storage/belt/rogue/leather/battleskirt/faulds/red
	//beltr = /obj/item/rogueweapon/scabbard/sword/noble
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backpack_contents = list(
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel = 1,
		)
	
	change_origin(H, /datum/virtue/origin/azuria, "Mercenary order") //Azurknights of Heartfelt. You better be from here dawg!
	to_chat(H, span_warning("You start with Bind, Recall and Empower Weapon. Remember to Bind your weapon so you can build up Arcyne Momentum."))
	H.merctype = 0 
