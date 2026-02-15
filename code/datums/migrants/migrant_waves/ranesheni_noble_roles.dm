#define CTAG_RANESHENI_EMIR "ranesheni_emir"
#define CTAG_RANESHENI_AMIRAH "ranesheni_amirah"
#define CTAG_RANESHENI_JANISSARY "ranesheni_janissari"
#define CTAG_RANESHENI_ADVISOR "ranesheni_advisor"

/datum/migrant_role/ranesheni/emir
	name = "Emir"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	advclass_cat_rolls = list(CTAG_RANESHENI_EMIR = 20)
	greet_text = "You are an envoy from the Empire, traveling with bodyguards and a priest to represent your homeland.\
	 What exactly you have been sent here to speak about- only you know."

/datum/advclass/ranesheni_emir
	name = "Emir"
	outfit = /datum/outfit/job/roguetown/ranesheni/emir
	traits_applied = list(TRAIT_NOBLE, TRAIT_HEAVYARMOR, TRAIT_STEELHEARTED)
	category_tags = list(CTAG_RANESHENI_EMIR)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 2,
		STATKEY_PER = 1,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/ranesheni/emir/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/circlet
	mask = /obj/item/clothing/head/roguetown/roguehood/red
	neck = /obj/item/clothing/neck/roguetown/gorget
	cloak = /obj/item/clothing/cloak/half/rider/red
	armor = /obj/item/clothing/suit/roguetown/armor/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/leather
	id = /obj/item/clothing/ring/gold
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/raneshen
	pants = /obj/item/clothing/under/roguetown/trou/leather/pontifex/raneshen
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	belt = /obj/item/storage/belt/rogue/leather/plaquesilver
	backl = /obj/item/storage/backpack/rogue/satchel/short
	l_hand = /obj/item/rogueweapon/sword/sabre/shamshir
	beltl = /obj/item/rogueweapon/scabbard/sword
	beltr = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/navaja = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1, 
		/obj/item/natural/feather = 1,
		/obj/item/paper/scroll = 2,
		/obj/item/storage/belt/rogue/pouch/coins/veryrich = 2,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 2,
		)
	H.cmode_music = 'sound/music/combat_desertrider.ogg'
	H.grant_language(/datum/language/celestial)

/datum/migrant_role/ranesheni/amirah
	name = "Amirah"
	allowed_sexes = list(FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	advclass_cat_rolls = list(CTAG_RANESHENI_AMIRAH = 20)

/datum/advclass/ranesheni_amirah
	name = "Amirah"
	outfit = /datum/outfit/job/roguetown/ranesheni/amirah
	traits_applied = list(TRAIT_NOBLE, TRAIT_SEEPRICES, TRAIT_NUTCRACKER, TRAIT_GOODLOVER)
	category_tags = list(CTAG_RANESHENI_AMIRAH)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_CON = 1,
		STATKEY_WIL = 3,
		STATKEY_PER = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/stealing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/music = SKILL_LEVEL_MASTER,
	)

/datum/outfit/job/roguetown/ranesheni/amirah/pre_equip(mob/living/carbon/human/H)
	..()
	if(should_wear_femme_clothes(H))
		belt = /obj/item/storage/belt/rogue/leather/cloth/lady
		head = /obj/item/clothing/head/roguetown/nyle
		shirt = /obj/item/clothing/suit/roguetown/armor/armordress/winterdress/monarch
		id = /obj/item/scomstone/garrison
		shoes = /obj/item/clothing/shoes/roguetown/shortboots
	else if(should_wear_masc_clothes(H))
		head = /obj/item/clothing/head/roguetown/nyle
		pants = /obj/item/clothing/under/roguetown/tights
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/guard
		armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
		shoes = /obj/item/clothing/shoes/roguetown/shortboots
		belt = /obj/item/storage/belt/rogue/leather
		backr = /obj/item/storage/backpack/rogue/satchel
		id = /obj/item/clothing/ring/silver
	backl = /obj/item/storage/backpack/rogue/satchel/short
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1, 
		/obj/item/natural/feather = 1,
		/obj/item/paper/scroll = 2,
		/obj/item/storage/belt/rogue/pouch/coins/veryrich = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 1,
	)
	H.cmode_music = 'sound/music/combat_desertrider.ogg'
	H.grant_language(/datum/language/celestial)

/datum/migrant_role/ranesheni/janissary
	name = "Janissary"
	greet_text = "You are a dilligent soldier in employ of the Emir for protection and to assure that their mission goes as planned."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	advclass_cat_rolls = list(CTAG_RANESHENI_JANISSARY = 20)

/datum/advclass/ranesheni_janissary
	name = "Janissary"
	outfit = /datum/outfit/job/roguetown/ranesheni/janissary
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_STEELHEARTED)
	category_tags = list(CTAG_RANESHENI_JANISSARY)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
		STATKEY_CON = 1,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/ranesheni/janissary/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/sallet/raneshen
	mask = /obj/item/clothing/mask/rogue/facemask/steel
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	cloak = /obj/item/clothing/cloak/half/rider/red
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/raneshen
	pants = /obj/item/clothing/under/roguetown/chainlegs
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	belt = /obj/item/storage/belt/rogue/leather/shalal
	backl = /obj/item/storage/backpack/rogue/satchel/short
	backr = /obj/item/rogueweapon/shield/tower/raneshen
	l_hand = /obj/item/rogueweapon/sword/sabre/shamshir
	beltl = /obj/item/rogueweapon/scabbard/sword
	beltr = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/navaja = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 1,
		/obj/item/natural/bundle/cloth/bandage/full = 1,
		)
	H.cmode_music = 'sound/music/combat_desertrider.ogg'
	H.grant_language(/datum/language/celestial)

/datum/migrant_role/ranesheni/advisor
	name = "Advisor"
	greet_text = "You are the Emir's advisor and loyal protector."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	advclass_cat_rolls = list(CTAG_RANESHENI_ADVISOR = 20)

/datum/advclass/ranesheni_advisor
	name = "Janissary"
	outfit = /datum/outfit/job/roguetown/ranesheni/advisor
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_STEELHEARTED)
	category_tags = list(TRAIT_MEDIUMARMOR, TRAIT_DODGEEXPERT, TRAIT_PERFECT_TRACKER)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_PER = 2,
		STATKEY_INT = 2,
	)
	subclass_skills = list(
		/datum/skill/misc/tracking = SKILL_LEVEL_LEGENDARY,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/traps = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/ranesheni/advisor/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/roguehood/shalal
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/raneshen
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	belt = /obj/item/storage/belt/rogue/leather/shalal
	backl = /obj/item/storage/backpack/rogue/satchel/short
	beltl = /obj/item/flashlight/flare/torch/lantern
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	beltr = /obj/item/quiver/bolts
	cloak = /obj/item/clothing/cloak/raincloak/red
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/navaja = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/storage/belt/rogue/pouch/coins/veryrich = 1,
		)
	H.cmode_music = 'sound/music/combat_desertrider.ogg'
	H.grant_language(/datum/language/celestial)

#undef CTAG_RANESHENI_EMIR
#undef CTAG_RANESHENI_AMIRAH
#undef CTAG_RANESHENI_JANISSARY
#undef CTAG_RANESHENI_ADVISOR
