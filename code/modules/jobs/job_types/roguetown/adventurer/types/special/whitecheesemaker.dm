/datum/advclass/whitecheese
	name = "WHITE CHEESE"
	allowed_sexes = list(MALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/whitecheese
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_BREADY, TRAIT_STEELHEARTED, TRAIT_ARCYNE_T2)
	// oh god oh fuck this dont seem very safe to do
	// this looks kinda op so imma just leave it at patreon level 1 until someone puts this behind a different lock
	maximum_possible_slots = 1

	horse = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck/tame/saddled
	category_tags = list(CTAG_DISABLED)
	subclass_stats = list(
		STATKEY_STR = 4,
		STATKEY_CON = 4,
		STATKEY_WIL = 4,
		STATKEY_INT = 3,
		STATKEY_SPD = 2,
	)
	subclass_spellpoints = 9
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/bows = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_MASTER,
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/adventurer/whitecheese
	name = "WHITE CHEESE"

/datum/outfit/job/roguetown/adventurer/whitecheese/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_skillrank(/datum/skill/craft/carpentry, rand(4,5), TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, rand(1,2), TRUE)


	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/tights/black
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	gloves = /obj/item/clothing/gloves/roguetown/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
	beltl = /obj/item/storage/belt/rogue/pouch/coins/rich

	H.dna.species.soundpack_m = new /datum/voicepack/male/evil/blkknight()
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/lightningbolt)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/fetch)

	H.ambushable = FALSE
