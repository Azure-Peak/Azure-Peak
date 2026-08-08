//skulk: generic thief archetype. basically an advmage with a slightly better loadout n worse skills
/datum/advclass/outcast/skulk
	name = "Skulk"
	tutorial = "You are a scoundrel and a thief. A master in getting into places you shouldn't be and taking things that aren't rightfully yours. Sadly, your luck eventually ran out, and so did your days of easy pickings in town. Out here, marks are tougher, but maybe the rewards are worth it."
	outfit = /datum/outfit/job/roguetown/outcast/skulk
	subclass_languages = list(/datum/language/thievescant)
	cmode_music = 'sound/music/cmode/antag/combat_cutpurse.ogg'
	traits_applied = list(TRAIT_DODGEEXPERT) // may regret this. can be nuked later if it's overbearing
	subclass_stats = list( // 6 statweight, worse than adv thief
		STATKEY_STR = -1,
		STATKEY_INT = 1,
		STATKEY_PER = 2,
		STATKEY_WIL = 1,
		STATKEY_SPD = 2,
	)
	subclass_skills = list( // knocked down a skill level or two from adv-thief in most of the important stuff. if dexpert gets nuked, probably undo this
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/traps = SKILL_LEVEL_JOURNEYMAN,
	)
	maximum_possible_slots = 2 // dexpert. nuff said

// changes from advmage: cudgel gone, steel dagger to iron, water arrows swapped for iron broadheads
/datum/outfit/job/roguetown/outcast/skulk/pre_equip(mob/living/carbon/human/H)
	..()
	armor = /obj/item/clothing/suit/roguetown/armor/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	backl = /obj/item/storage/backpack/rogue/backpack
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/iron
	cloak = /obj/item/clothing/cloak/raincloak/mortus
	beltl = /obj/item/quiver/broadhead
	beltr = /obj/item/rogueweapon/huntingknife/idagger
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/lockpickring/mundane = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	outcast_select_bounty(H)
