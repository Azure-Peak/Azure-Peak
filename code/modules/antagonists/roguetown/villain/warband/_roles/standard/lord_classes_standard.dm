/datum/advclass/warband/standard/warlord/lord
	title = "RIVAL LORD"
	name = "Rival Lord"
	tutorial = "Psydonia shan't last long enough for new history books. \
	A terrible shame; for the RIVAL LORD would've cut a worthy figure into its fables."
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_NOBLE, TRAIT_FORMATIONFIGHTER, TRAIT_LAWEXPERT, TRAIT_COMBAT_AWARE)
	subclass_stats = list(
		STATKEY_LCK = 5,
		STATKEY_CON = 3,
		STATKEY_INT = 3,
		STATKEY_WIL = 3,
		STATKEY_PER = 2,
		STATKEY_SPD = 1,
		STATKEY_STR = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
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
	outfit = /datum/outfit/job/roguetown/warband/standard/warlord/lord
	horse = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/tame/saddled 

/datum/outfit/job/roguetown/warband/standard/warlord/lord/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/blacksteel/modern
	neck = /obj/item/clothing/neck/roguetown/coif/heavypadding
	beltr = /obj/item/rogueweapon/sword/long/dec
	beltl = /obj/item/rogueweapon/scabbard/sword
	belt = /obj/item/storage/belt/rogue/leather/black
	id = /obj/item/clothing/ring/statrontz
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	pants = /obj/item/clothing/under/roguetown/platelegs/blacksteel/modern
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/blacksteel/modern
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/rival
	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/blacksteel/modern
	gloves = /obj/item/clothing/gloves/roguetown/plate/blacksteel/modern
	backr = /obj/item/clothing/cloak/volfmantle
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern/prelit,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpotnew,
		/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette,
		/obj/item/reagent_containers/glass/bottle/waterskin
	)
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/sweep)
