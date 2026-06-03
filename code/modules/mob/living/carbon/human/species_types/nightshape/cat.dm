/mob/living/carbon/human/species/wildshape/night_cat
	name = "Cat"
	race = /datum/species/night_cat
	footstep_type = FOOTSTEP_MOB_CLAW
	ambushable = FALSE
	skin_armor = new /obj/item/clothing/suit/roguetown/armor/skin_armor/cat_skin
	wildshape_icon = 'icons/mob/pets.dmi'
	wildshape_icon_state = "cat2"

/mob/living/carbon/human/species/wildshape/night_cat/gain_inherent_skills()
	if(src.mind)
		src.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
		src.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		src.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		src.adjust_skillrank(/datum/skill/misc/sneaking, 5, TRUE)
		src.adjust_skillrank(/datum/skill/misc/climbing, 5, TRUE)
		src.adjust_skillrank(/datum/skill/misc/stealing, 3, TRUE)
		src.adjust_skillrank(/datum/skill/misc/tracking, 1, TRUE)

		src.STASTR = 2
		src.STACON = 2
		src.STAWIL = 7
		src.STAPER = 14
		src.STASPD = 18
		src.STALUC = 12

		AddSpell(new /obj/effect/proc_holder/spell/self/catclaws)
		AddSpell(new /obj/effect/proc_holder/spell/targeted/woundlick)
		src.real_name = "cat"

/datum/species/night_cat
	name = "cat"
	id = "night_cat"
	species_traits = list(NO_UNDERWEAR, NO_ORGAN_FEATURES, NO_BODYPART_FEATURES)
	inherent_traits = list(
		TRAIT_KNEESTINGER_IMMUNITY,
		TRAIT_NOFALLDAMAGE2,
		TRAIT_WILD_EATER,
		TRAIT_HARDDISMEMBER,
		TRAIT_DODGEEXPERT,
		TRAIT_BRITTLE,
		TRAIT_LEAPER,
		TRAIT_ZJUMP,
		TRAIT_WOODWALKER
	)
	inherent_biotypes = MOB_HUMANOID
	no_equip = list(SLOT_SHIRT, SLOT_HEAD, SLOT_WEAR_MASK, SLOT_ARMOR, SLOT_GLOVES, SLOT_SHOES, SLOT_PANTS, SLOT_CLOAK, SLOT_BELT, SLOT_BACK_R, SLOT_BACK_L, SLOT_S_STORE)
	nojumpsuit = 1
	sexes = 1
	offset_features = list(OFFSET_HANDS = list(0,2), OFFSET_HANDS_F = list(0,2))
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/night_vision,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/wild_tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
	)
	languages = list(/datum/language/beast)

/datum/species/night_cat/regenerate_icons(mob/living/carbon/human/H)
	H.icon = 'icons/mob/pets.dmi'
	H.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	H.icon_state = "cat2"
	H.update_damage_overlays()
	return TRUE

/datum/species/night_cat/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/species/night_cat/update_damage_overlays(mob/living/carbon/human/H)
	H.remove_overlay(DAMAGE_LAYER)
	return TRUE
