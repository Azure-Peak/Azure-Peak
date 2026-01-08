/datum/advclass/vagabond_unraveled
    name = "The Unraveled"
    tutorial = "Once you sought to understand the mind’s decay — now you live within it, a wandering physician bound to his own affliction."
    allowed_sexes = list(MALE, FEMALE)
    allowed_races = RACES_NO_CONSTRUCT
    outfit = /datum/outfit/job/roguetown/vagabond/unraveled
    category_tags = list(CTAG_VAGABOND)
    traits_applied = list(TRAIT_PSYCHOSIS, TRAIT_NOSTINK)
    subclass_stats = list(
        STATKEY_INT = -2,
        STATKEY_LCK = -2,
    )
    subclass_skills = list(
        /datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
        /datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
        /datum/skill/misc/climbing = SKILL_LEVEL_EXPERT
    )
    extra_context = "Constantly hallucinates."

/datum/outfit/job/roguetown/vagabond/unraveled/pre_equip(mob/living/carbon/human/human)
    ..()
    
    if(should_wear_femme_clothes(human))
        armor = /obj/item/clothing/suit/roguetown/shirt/rags
    
    pants = /obj/item/clothing/under/roguetown/loincloth
    r_hand = /obj/item/rogueweapon/woodstaff

    if(prob(33))
        cloak = /obj/item/clothing/cloak/half/brown
        gloves = /obj/item/clothing/gloves/roguetown/fingerless

    human.hallucination = INFINITY
