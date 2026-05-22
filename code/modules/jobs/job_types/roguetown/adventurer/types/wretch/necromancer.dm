/datum/advclass/wretch/necromancer
	name = "Necromancer"
	tutorial = "You have been ostracized and hunted by society for your dark magics and perversion of life."
	allowed_sexes = list(MALE, FEMALE)
	
	outfit = /datum/outfit/job/roguetown/wretch/necromancer
	cmode_music = 'sound/music/combat_heretic.ogg'
	class_select_category = CLASS_CAT_MAGE
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_ZOMBIE_IMMUNE, TRAIT_NOSTINK, TRAIT_GRAVEROBBER, TRAIT_ARCYNE, TRAIT_ALCHEMY_EXPERT, TRAIT_MEDICINE_EXPERT)
	maximum_possible_slots = 2 // Going from 1 to 2, because skeleton that are summoned count AGAINST antagonist cap and they don't always shows up
	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_PER = 2,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1
	)
	age_mod = /datum/class_age_mod/wretch/rogue_mage
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 1, "minor" = 1, "utilities" = 4, "ward" = TRUE)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/arcane = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN, //For lux extractions.
	)
	subclass_stashed_items = list(
        "Sewing Kit" =  /obj/item/repair_kit,
    )

/datum/outfit/job/roguetown/wretch/necromancer/pre_equip(mob/living/carbon/human/H)
	head = /obj/item/clothing/head/roguetown/roguehood/black
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/black
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/reagent_containers/glass/bottle/rogue/manapot
	neck = /obj/item/clothing/neck/roguetown/gorget
	beltl = /obj/item/rogueweapon/huntingknife
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/book/spellbook = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/necro_relics/necro_crystal = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		/obj/item/chalk = 1,
		)
	H.dna.species.soundpack_m = new /datum/voicepack/male/wizard()
	if(H.mind)
		backr = choose_implement(H, "greater")
		H.set_patron(/datum/patron/inhumen/zizo)
		H.mind.AddSpell(new /datum/action/cooldown/spell/eyebite)
		H.mind.AddSpell(new /datum/action/cooldown/spell/bonechill)
		H.mind.AddSpell(new /datum/action/cooldown/spell/bonemend)
		H.mind.AddSpell(new /datum/action/cooldown/spell/minion_order)
		H.mind.AddSpell(new /datum/action/cooldown/spell/gravemark)
		H.mind.AddSpell(new /datum/action/cooldown/spell/raise_undead_formation/necromancer)
		H.mind.AddSpell(new /datum/action/cooldown/spell/raise_undead_guard/necromancer)
		H.mind.AddSpell(new /datum/action/cooldown/spell/convert_heretic/arcyne)
		H.mind.AddSpell(new /datum/action/cooldown/spell/lacrima)
		H.mind.AddSpell(new /datum/action/cooldown/spell/tame_undead)
		H.mind.AddSpell(new /datum/action/cooldown/spell/raise_deadite)
		wretch_select_bounty(H)
	H.grant_language(/datum/language/undead)
