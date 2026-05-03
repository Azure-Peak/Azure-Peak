//////////////////////////////////////////////////////////////////
/////////////////////////////////// FOLK HERO
/*
	farmer w/maxed out Luck & Will
	nearly zero actual combat skills
*/
/datum/advclass/warband/rebellion/lieutenant/folkhero
	title = "FOLK HERO"
	name = "Folk Hero"
	tutorial = "The FOLK HERO is no warrior. And yet through a string of fantastic circumstances, they've found themselves at the center-stage of the Rebellion."
	outfit = /datum/outfit/job/roguetown/warband/rebellion/lieutenant/folkhero
	traits_applied = list(TRAIT_FORMATIONFIGHTER, TRAIT_SEEDKNOW, TRAIT_NOSTINK, TRAIT_LONGSTRIDER, TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_LCK = 10,
		STATKEY_WIL = 10,
		STATKEY_CON = 2,
		STATKEY_PER = 2,
	)
	subclass_skills = list(
		/datum/skill/labor/farming = SKILL_LEVEL_EXPERT,
		/datum/skill/labor/butchering = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/tanning = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/slings = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/axes = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/shields = SKILL_LEVEL_NOVICE,		
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,	
		/datum/skill/misc/tracking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)


/datum/outfit/job/roguetown/warband/rebellion/lieutenant/folkhero/pre_equip(mob/living/carbon/human/H)
	..()
	
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/random
		cloak = /obj/item/clothing/cloak/apron/brown
	else
		pants = /obj/item/clothing/under/roguetown/tights/random
		armor = /obj/item/clothing/suit/roguetown/armor/leather/vest
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
	r_hand = /obj/item/rogueweapon/sword/long/heirloom		
	head = /obj/item/clothing/head/roguetown/armingcap
	mask = /obj/item/clothing/head/roguetown/roguehood
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather/rope
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(/obj/item/reagent_containers/glass/bottle/rogue/healthpotnew = 1, 
	/obj/item/flashlight/flare/torch = 1, 
	/obj/item/rogueweapon/huntingknife = 1, 
	/obj/item/flint = 1)
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/sweep)


////////////////////////////////////////////
/////////////////////////////////// WILDCARD
/*
	draws from a pool of every lieutenant class from every warband
	presents 3 options
	this makes it a Queer Case where we need to put the majority of its pre_equip proc after the warbands are defined, as the warbands are reliant on the classes being defined first
	at least i think so
	idk i can't code

	it's handled in random_classes() over in warband_mob_spawn.dm
*/
/datum/advclass/warband/rebellion/lieutenant/wildcard
	title = "WILDCARD"
	name = "Wildcard"
	tutorial = "So long as the WILDCARD is dedicated to the cause, they shall be a welcome ally."
	outfit = /datum/outfit/job/roguetown/warband/rebellion/lieutenant/wildcard
	traits_applied = list(TRAIT_LAWEXPERT, TRAIT_FORMATIONFIGHTER)
	subclass_stats = list(

	)
	subclass_skills = list(

	)


/datum/outfit/job/roguetown/warband/rebellion/lieutenant/wildcard/pre_equip(mob/living/carbon/human/H)
	..()
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/sweep)

/////////////////////////////////////////////
/////////////////////////////////// FIREBRAND
/*
	Evil Artificer Green Beret 
	the "Albert Fundamental" archetype
*/
/datum/advclass/warband/rebellion/lieutenant/firebrand
	title = "FIREBRAND"
	name = "Firebrand"
	tutorial = "It's said that the FIREBRAND was once a gentle, well-learned tinkerer. The revolution's crucible melted his innocence, forging him into a butcher."
	outfit = /datum/outfit/job/roguetown/warband/rebellion/lieutenant/firebrand
	traits_applied = list(TRAIT_LAWEXPERT, TRAIT_FORMATIONFIGHTER, TRAIT_LONGSTRIDER)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_WIL = 2,
		STATKEY_STR = 1,
		STATKEY_CON = 1,
		STATKEY_PER = 1
	)
	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_LEGENDARY,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/masonry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/engineering = SKILL_LEVEL_MASTER,
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_EXPERT, 
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/smelting = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/traps = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/ceramics = SKILL_LEVEL_JOURNEYMAN,
	)


/datum/outfit/job/roguetown/warband/rebellion/lieutenant/firebrand/pre_equip(mob/living/carbon/human/H)
	..()

	r_hand = /obj/item/satchel_bomb
	l_hand = /obj/item/satchel_bomb
	head = /obj/item/clothing/head/roguetown/articap
	armor = /obj/item/clothing/suit/roguetown/armor/plate/paalloy/artificer
	cloak = /obj/item/clothing/cloak/apron/waist/brown
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith
	pants = /obj/item/clothing/under/roguetown/trou/artipants
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/artificer
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/pick/militia/steel
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(/obj/item/reagent_containers/glass/bottle/rogue/healthpotnew = 1,
		/obj/item/rogueweapon/hammer/steel = 1,	
		/obj/item/lockpickring/mundane = 1,		
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/contraption/linker = 1,	
		/obj/item/flint = 1,
		/obj/item/bomb/smoke = 2,
		/obj/item/impact_grenade/explosion = 4,
		/obj/item/ammo_casing/caseless/rogue/bolt/pyro = 4
	)
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/sweep)



////////////////////////////////////////////
/////////////////////////////////// TURNCOAT
/*
	post-crashout megasquire

*/
/datum/advclass/warband/rebellion/lieutenant/turncoat
	title = "TURNCOAT"
	name = "Turncoat"
	tutorial = "Long-estranged from the Duchy's retinue, the TURNCOAT wields the experience of his service against his former employers."
	outfit = /datum/outfit/job/roguetown/warband/rebellion/lieutenant/turncoat
	traits_applied = list(TRAIT_LAWEXPERT, TRAIT_FORMATIONFIGHTER, TRAIT_HEAVYARMOR, TRAIT_SQUIRE_REPAIR, TRAIT_LONGSTRIDER)
	subclass_stats = list(
		STATKEY_STR = 4,
		STATKEY_SPD = 3,
		STATKEY_PER = 2,
		STATKEY_CON = 2,
		STATKEY_INT = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)


/datum/outfit/job/roguetown/warband/rebellion/lieutenant/turncoat/pre_equip(mob/living/carbon/human/H)
	..()
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/sweep)
	head = /obj/item/clothing/head/roguetown/helmet/heavy/bucket/iron
	backl = /obj/item/storage/backpack/rogue/satchel
	mask = /obj/item/clothing/mask/rogue/facemask/steel
	cloak = /obj/item/clothing/cloak/tabard/stabard/guardhood
	backr = /obj/item/rogueweapon/shield/iron
	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/iron
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	pants = /obj/item/clothing/under/roguetown/platelegs/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	beltr = /obj/item/rogueweapon/sword/short
	belt = /obj/item/storage/backpack/rogue/satchel/beltpack
	backpack_contents = list(/obj/item/reagent_containers/glass/bottle/rogue/healthpotnew, 
	/obj/item/rogueweapon/hammer/iron, 
	/obj/item/polishing_cream, 
	/obj/item/armor_brush)

