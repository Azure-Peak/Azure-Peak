///////////////////////////////////////////
/////////////////////////////////// VETERAN
/*
	bog standard grunt
	it's just a Guy
*/
/datum/advclass/warband/standard/grunt/veteran
	title = "VETERAN"
	name = "Foreign Veteran"
	tutorial = "Courtesy of the VETERAN's extensive experience and service, their Lieutenant favors them above the usual rank and file."
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_FORMATIONFIGHTER, TRAIT_STEELHEARTED, TRAIT_COMBAT_AWARE)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_SPD = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_PER = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_NOVICE,
	)
	outfit = /datum/outfit/job/roguetown/warband/standard/grunt/veteran



/datum/outfit/job/roguetown/warband/standard/grunt/veteran/pre_equip(mob/living/carbon/human/H)
	..()

	head = /obj/item/clothing/head/roguetown/helmet/kettle/iron
	mask = /obj/item/clothing/mask/rogue/facemask
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	neck = /obj/item/clothing/neck/roguetown/gorget
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	beltl = /obj/item/rogueweapon/mace/warhammer/steel
	beltr = /obj/item/rogueweapon/shield/buckler
	belt = /obj/item/storage/belt/rogue/leather/black
	backr = /obj/item/storage/backpack/rogue/satchel/black
	cloak = /obj/item/clothing/cloak/tabard/stabard/warband
	r_hand = /obj/item/rogueweapon/halberd


	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpotnew = 1,
		/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette = 1,
		/obj/item/reagent_containers/glass/bottle/waterskin = 1
		)

/////////////////////////////////////////
/////////////////////////////////// SCOUT
/*
	low con ranger w/longstrider
*/
/datum/advclass/warband/standard/grunt/scout
	title = "SCOUT"
	name = "Scout"
	tutorial = "The SCOUT relies on a swift pair of legs and keen eyes. Should they find themselves cornered into a proper fight, they'll have hell to pay."
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_MEDIUMARMOR, TRAIT_WOODWALKER, TRAIT_LONGSTRIDER, TRAIT_FORMATIONFIGHTER, TRAIT_KEENEARS)
	subclass_stats = list(
		STATKEY_SPD = 3,
		STATKEY_CON = -4,
		STATKEY_WIL = 2,
		STATKEY_PER = 6,
	)
	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_MASTER,
		/datum/skill/combat/slings = SKILL_LEVEL_MASTER,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)
	outfit = /datum/outfit/job/roguetown/warband/standard/grunt/scout



/datum/outfit/job/roguetown/warband/standard/grunt/scout/pre_equip(mob/living/carbon/human/H)
	head = /obj/item/clothing/head/roguetown/helmet/leather/advanced
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	gloves = /obj/item/clothing/gloves/roguetown/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather/black
	backr = /obj/item/storage/backpack/rogue/satchel/black
	cloak = /obj/item/clothing/cloak/tabard/stabard/warband
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
	wrists = /obj/item/clothing/wrists/roguetown/bracers/brigandine
	beltr = /obj/item/quiver/bodkin
	beltl = /obj/item/quiver/bodkin
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve

	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special,
		/obj/item/flashlight/flare/torch/lantern/prelit,
		/obj/item/rogueweapon/scabbard/sheath,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpotnew,
		/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette = 1,
		/obj/item/reagent_containers/glass/bottle/waterskin = 1
		)

/////////////////////////////////////////
/////////////////////////////////// RIDER
/*
	cavalry
	ain't much to say
*/
/datum/advclass/warband/standard/grunt/rider
	title = "RIDER"
	name = "Rider"
	tutorial = "Together, the RIDER and his war-saiga form a single, inseparable instrument. Skulls shall burst before the man's lance, and formations shall crumble beneath the beast's hooves."
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_STEELHEARTED)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_SPD = 1,
		STATKEY_CON = 2,
		STATKEY_WIL = 3,
		STATKEY_INT = 1,
		STATKEY_PER = 2,
	)
	subclass_skills = list(
		/datum/skill/misc/riding = SKILL_LEVEL_MASTER,
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
	)
	outfit = /datum/outfit/job/roguetown/warband/standard/grunt/rider
	horse = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/tame/saddled 


/datum/outfit/job/roguetown/warband/standard/grunt/rider/pre_equip(mob/living/carbon/human/H)
	head = /obj/item/clothing/head/roguetown/helmet/winged
	cloak = /obj/item/clothing/cloak/tabard/stabard/warband
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson	
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale	
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	neck = /obj/item/clothing/neck/roguetown/bevor/iron
	gloves = /obj/item/clothing/gloves/roguetown/chain/iron
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = /obj/item/rogueweapon/sword/sabre
	beltr = /obj/item/quiver/javelin/steel
	backr = /obj/item/storage/backpack/rogue/satchel/black
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	r_hand = /obj/item/rogueweapon/spear/lance
	l_hand = /obj/item/rogueweapon/shield/tower/metal

	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special,
		/obj/item/flashlight/flare/torch/lantern/prelit,
		/obj/item/rogueweapon/scabbard/sheath,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpotnew,
		/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette,
		/obj/item/reagent_containers/glass/bottle/waterskin
		)

	var/helmets = list(
	"Simple Helmet" 	= /obj/item/clothing/head/roguetown/helmet,
	"Kettle Helmet" 	= /obj/item/clothing/head/roguetown/helmet/kettle,
	"Bascinet Helmet"	= /obj/item/clothing/head/roguetown/helmet/bascinet,
	"Sallet Helmet"		= /obj/item/clothing/head/roguetown/helmet/sallet,
	"Winged Helmet" 	= /obj/item/clothing/head/roguetown/helmet/winged,
	"Skull Cap"			= /obj/item/clothing/head/roguetown/helmet/skullcap,
	"None"
	)
	var/helmchoice = input("Choose your Helm.", "TAKE UP HELMS") as anything in helmets
	if(helmchoice != "None")
		head = helmets[helmchoice]

//////////////////////////////////////////////////
/////////////////////////////////// SIEGE ENGINEER
/*
	a crafter w/high crossbow skills
*/
/datum/advclass/warband/standard/grunt/sapper
	title = "SIEGE ENGINEER"
	name = "Siege Engineer"
	tutorial = "The rules of war change by the yil, and men like the SIEGE ENGINEER are at the head of these innovations. There will always be a new tactic; a new weapon; a new death."
	outfit = /datum/outfit/job/roguetown/warband/standard/grunt/sapper

	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_STEELHEARTED, TRAIT_FORMATIONFIGHTER, TRAIT_TRAINED_SMITH)
	subclass_stats = list(
		STATKEY_SPD = 1,
		STATKEY_CON = 1,
		STATKEY_WIL = 4,
		STATKEY_INT = 4,
		STATKEY_PER = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_MASTER,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/carpentry = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/masonry = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/sewing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/traps = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/engineering = SKILL_LEVEL_EXPERT,
		/datum/skill/labor/mining = SKILL_LEVEL_EXPERT,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/smelting = SKILL_LEVEL_APPRENTICE,
	)


/datum/outfit/job/roguetown/warband/standard/grunt/sapper/pre_equip(mob/living/carbon/human/H)
	..()
	r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	backr = /obj/item/quiver/bolt/standard
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/stoneaxe/woodcut/steel
	beltl = /obj/item/rogueweapon/pick/steel
	backl = /obj/item/storage/backpack/rogue/satchel
	mask = /obj/item/clothing/mask/rogue/spectacles/golden
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
	wrists = /obj/item/clothing/wrists/roguetown/bracers/brigandine
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	pants = /obj/item/clothing/under/roguetown/splintlegs
	neck = /obj/item/clothing/neck/roguetown/gorget
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots
	cloak = /obj/item/clothing/cloak/tabard/stabard/warband
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special,
		/obj/item/flashlight/flare/torch/lantern/prelit,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpotnew,
		/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette,
		/obj/item/reagent_containers/glass/bottle/waterskin
		)
