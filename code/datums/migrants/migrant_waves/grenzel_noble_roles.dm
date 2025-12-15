#define CTAG_GRENZEL_ENVOY "grenzel_envoy"
#define CTAG_GRENZEL_GUARD "grenzel_guard"
#define CTAG_GRENZEL_PRIEST "grenzel_priest"

/datum/migrant_role/grenzel/envoy
	name = "Envoy"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	greet_text = "You are a Grenzelhoftian envoy, traveling with bodyguards and a priest to represent your homeland.\
	 What exactly you have been sent here to speak about- only you know."
	advclass_cat_rolls = list(CTAG_GRENZEL_ENVOY = 20)

/datum/advclass/grenzel_envoy
	name = "Envoy"
	outfit = /datum/outfit/job/roguetown/grenzel/envoy
	traits_applied = list(TRAIT_NOBLE, TRAIT_HEAVYARMOR, TRAIT_STEELHEARTED)
	category_tags = list(CTAG_GRENZEL_ENVOY)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 2,
		STATKEY_PER = 1,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/swords= SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces= SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives= SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling= SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed= SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming= SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing= SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics= SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields= SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/misc/medicine= SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing= SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding= SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/grenzel/envoy/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/circlet
	neck = /obj/item/clothing/neck/roguetown/gorget
	cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/bailiff
	armor = /obj/item/clothing/suit/roguetown/armor/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves
	id = /obj/item/clothing/ring/gold
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants
	shoes = /obj/item/clothing/shoes/roguetown/grenzelhoft
	belt = /obj/item/storage/belt/rogue/leather/plaquesilver
	backl = /obj/item/storage/backpack/rogue/satchel/short
	l_hand = /obj/item/rogueweapon/sword/long
	beltl = /obj/item/rogueweapon/scabbard/sword
	beltr = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1, 
		/obj/item/natural/feather = 1,
		/obj/item/paper/scroll = 2
		)
	H.cmode_music = 'sound/music/combat_grenzelhoft.ogg'
	H.grant_language(/datum/language/grenzelhoftian)

/datum/migrant_role/grenzel/bodyguard
	name = "Leibwachter"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	advclass_cat_rolls = list(CTAG_GRENZEL_GUARD = 20)

/datum/advclass/grenzel_guard
	name = "Leibwachter"
	tutorial = "You are a dilligent soldier in employ of the Envoy for protection and to assure that their mission goes as planned."
	outfit = /datum/outfit/job/roguetown/grenzel/doppel
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_STEELHEARTED)
	category_tags = list(CTAG_GRENZEL_GUARD)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
		STATKEY_CON = 3,
		STATKEY_PER = 1,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/swimming= SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing= SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking= SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces= SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows= SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling= SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed= SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords= SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields= SKILL_LEVEL_NOVICE,
		/datum/skill/combat/polearms= SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/whipsflails= SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives= SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading= SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics= SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/grenzel/doppel/pre_equip(mob/living/carbon/human/H)
	..()
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/flashlight/flare/torch
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft
	head = /obj/item/clothing/head/roguetown/grenzelhofthat
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/blacksteel
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants
	shoes = /obj/item/clothing/shoes/roguetown/grenzelhoft
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves
	backr = /obj/item/storage/backpack/rogue/satchel/short
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	r_hand = /obj/item/rogueweapon/greatsword/grenz
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/huntingknife/idagger = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	H.cmode_music = 'sound/music/combat_grenzelhoft.ogg'
	H.grant_language(/datum/language/grenzelhoftian)

/datum/migrant_role/grenzel/priest
	name = "Envoy Priest"
	greet_text = "Nominally the envoy's spiritual advisor, your real power extends beyond religious matters. Protect interests of the Holy See of the Ten."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	advclass_cat_rolls = list(CTAG_GRENZEL_PRIEST = 20)

/datum/advclass/grenzel_priest
	name = "Envoy Priest"
	outfit = /datum/outfit/job/roguetown/grenzel/doppel
	traits_applied = list(TRAIT_CHOSEN, TRAIT_RITUALIST, TRAIT_GRAVEROBBER)
	category_tags = list(CTAG_GRENZEL_PRIEST)
	subclass_stats = list(
		STATKEY_STR = -1,
		STATKEY_INT = 3,
		STATKEY_WIL = 3,
		STATKEY_SPD = -1,
	)
	subclass_stats = list(
		/datum/skill/combat/wrestling= SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed= SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_LEGENDARY,
		/datum/skill/craft/alchemy= SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine= SKILL_LEVEL_EXPERT,
		/datum/skill/magic/holy= SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/grenzel/priest/pre_equip(mob/living/carbon/human/H)
	..()
	H.set_patron(/datum/patron/divine/undivided)
	neck = /obj/item/clothing/neck/roguetown/psicross/astrata
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest
	pants = /obj/item/clothing/under/roguetown/tights/black
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/storage/belt/rogue/pouch/coins/rich
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/priest
	cloak = /obj/item/clothing/cloak/chasuble
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/needle/pestra = 1,
	)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, start_maxed = TRUE)

#undef CTAG_GRENZEL_ENVOY
#undef CTAG_GRENZEL_GUARD
#undef CTAG_GRENZEL_PRIEST
