////// SORCERER-KING
/datum/advclass/warband/wizard/warlord/sorcerer
	title = "SORCERER-KING"
	name = "Sorcerer-King"
	tutorial = ""
	traits_applied = list(TRAIT_FORMATIONFIGHTER, TRAIT_LAWEXPERT, TRAIT_ARCYNE_T4, TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_LCK = 3,
		STATKEY_WIL = 4,
		STATKEY_PER = 3,
		STATKEY_INT = 8,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_MASTER,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,		
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,		
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
	)

	outfit = /datum/outfit/job/roguetown/warband/wizard/warlord/sorcerer


/datum/outfit/job/roguetown/warband/wizard/warlord/sorcerer/pre_equip(mob/living/carbon/human/H)
	..()
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/sweep)

	if(should_wear_femme_clothes(H))
		head = /obj/item/clothing/head/roguetown/witchhat/thrall
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/tabardblack/alt
	else
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/wizard	
		head = /obj/item/clothing/head/roguetown/wizhat

	neck = /obj/item/clothing/neck/roguetown/bevor
	mask = /obj/item/clothing/mask/rogue/lordmask/l
	cloak = /obj/item/clothing/cloak/thrall/warlord
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	pants = /obj/item/clothing/under/roguetown/chainlegs/skirt
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/blacksteel/modern/plategloves
	shoes = /obj/item/clothing/shoes/roguetown/boots/blacksteel/modern/plateboots
	belt = /obj/item/storage/belt/rogue/leather/plaquesilver
	beltr = /obj/item/rogueweapon/scabbard/sword
	beltl = /obj/item/storage/magebag
	id = /obj/item/clothing/ring/statdorpel // Necessary 4 Sauron Gameplay
	r_hand = /obj/item/rogueweapon/woodstaff/riddle_of_steel
	l_hand = /obj/item/rogueweapon/sword/decorated
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/rogue/poison, 
		/obj/item/reagent_containers/glass/bottle/rogue/healthpotnew,
		/obj/item/recipe_book/magic,
		/obj/item/book/spellbook,
		/obj/item/rogueweapon/huntingknife/idagger/silver/arcyne
	)

	if(H.mind)
		H.mind.adjust_spellpoints(36)
