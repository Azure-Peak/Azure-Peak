/datum/advclass/wretch/plaguebearer
	name = "Malpractitioner"
	tutorial = "A disgraced physician forced into exile and years of hardship, you have turned to a private practice. Operating beyond the bounds of the law, you work with traitors, heretics, and common criminals as easily as your peers would treat a peasant or craftsman."
	
	outfit = /datum/outfit/job/roguetown/wretch/plaguebearer
	cmode_music = 'sound/music/combat_physician.ogg'
	class_select_category = CLASS_CAT_ROGUE
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_CICERONE, TRAIT_NOSTINK, TRAIT_MEDICINE_EXPERT, TRAIT_ALCHEMY_EXPERT)
	maximum_possible_slots = 2
	extra_context = "This subclass gets a set of poisonable daggers, and a bow with poison arrows."
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 3,
		STATKEY_CON = 2,
		STATKEY_WIL = 2
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN, // To escape grapplers, fuck you
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/carpentry = SKILL_LEVEL_JOURNEYMAN, //Build your gooncave 
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_MASTER, //Disgraced medicine man. 
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_MASTER, // This is literally their whole thing
		/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN, // Farm ingredients so you have something to do that isn't grinding skills
	)
	subclass_stashed_items = list(
        "Sewing Kit" =  /obj/item/repair_kit,
		"Poison Arrows Quiver" = /obj/item/quiver/poisonarrows,
    )

/datum/outfit/job/roguetown/wretch/plaguebearer/pre_equip(mob/living/carbon/human/H)
	head = /obj/item/clothing/head/roguetown/physician
	mask = /obj/item/clothing/mask/rogue/physician/plaguebearer
	neck = /obj/item/clothing/neck/roguetown/chaincoif 
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	cloak = /obj/item/clothing/suit/roguetown/shirt/robe/physician
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	backl = /obj/item/storage/backpack/rogue/satchel
	l_hand = /obj/item/storage/belt/rogue/surgery_bag/full/physician
	belt = /obj/item/storage/belt/rogue/leather/black
	gloves = /obj/item/clothing/gloves/roguetown/angle
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/stampoison = 1,
		/obj/item/recipe_book/alchemy = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/strongpoison = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		/obj/item/natural/worms/leech/cheele = 1,
		/obj/item/reagent_containers/powder/black_ichor = 1,
		)
	H.dna.species.soundpack_m = new /datum/voicepack/male/wizard()
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
		H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
		// These end up in your belt.
		backpack_contents += /obj/item/rogueweapon/huntingknife/idagger/steel/corroded
		backpack_contents += /obj/item/rogueweapon/huntingknife/idagger/steel/rotfang
		backpack_contents += /obj/item/reagent_containers/powder/black_ichor
		backpack_contents += /obj/item/reagent_containers/powder/black_ichor
		backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
		beltr = /obj/item/quiver/poisonarrows
		beltl = /obj/item/storage/magebag
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/unique/ichor)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/alchemy/unique/ichor_big)
		wretch_select_bounty(H)

/obj/item/clothing/mask/rogue/physician/plaguebearer
	desc = "What better laboratory than the blood-soaked battlefield? This one seems to be uniquely armored."
	armor = ARMOR_PLATE
	// Less than an actual steel mask.
	max_integrity = 160
	// Consistency with other masks.
	body_parts_covered = FACE
	blocksound = PLATEHIT
