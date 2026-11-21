/mob/living/carbon/human/species/wildshape/night_spider //The bog glass cannon
	name = "Spider"
	race = /datum/species/night_spider
	footstep_type = FOOTSTEP_MOB_CLAW
	ambushable = FALSE
	skin_armor = new /obj/item/clothing/suit/roguetown/armor/skin_armor/spider_chitin
	wildshape_icon = 'icons/roguetown/mob/monster/spider.dmi'
	wildshape_icon_state = "honeys"

/mob/living/carbon/human/species/wildshape/night_spider/gain_inherent_skills()
	if(src.mind)
		src.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
		src.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
		src.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE) //For the bog mainly
		src.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		src.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE)
		src.adjust_skillrank(/datum/skill/misc/climbing, 5, TRUE)

		src.STASTR = 12
		src.STACON = 6
		src.STAWIL = 7
		src.STAPER = 12
		src.STASPD = 14

		AddSpell(new /obj/effect/proc_holder/spell/self/spiderfangs)
		AddSpell(new /obj/effect/proc_holder/spell/self/createhoney)
		AddSpell(new /obj/effect/proc_holder/spell/self/weaveweb)
		real_name = "beespider"
		faction += "spiders" // It IS a spider

// CAT SPECIES DATUM //
/datum/species/night_spider
	name = "spider"
	id = "night_spider"
	species_traits = list(NO_UNDERWEAR, NO_ORGAN_FEATURES, NO_BODYPART_FEATURES)
	inherent_traits = list(
		TRAIT_KNEESTINGER_IMMUNITY, //All of these are dendorite transformations, they are ALL blessed by dendor
		TRAIT_STRONGBITE,
		TRAIT_NOFALLDAMAGE1,
		TRAIT_WILD_EATER,
		TRAIT_HARDDISMEMBER, //Decapping wildshapes causes them to bug out, badly, and need admin intervention to fix. Bandaid fix.
		TRAIT_LEAPER,
		TRAIT_WEBWALK, //This IS a spider
		TRAIT_BREADY, //Ambusher
		TRAIT_ORGAN_EATER,
		TRAIT_PIERCEIMMUNE, //Prevents weapon dusting and caltrop effects when killed/stepping on shards, also 8 legs.
		TRAIT_DODGEEXPERT,
		TRAIT_LONGSTRIDER
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
		ORGAN_SLOT_GUTS = /obj/item/organ/guts,
		)

	languages = list(
		/datum/language/beast,
		/datum/language/common,
	)

/datum/species/night_spider/send_voice(mob/living/carbon/human/H)
	playsound(get_turf(H), pick('sound/vo/mobs/spider/speak (1).ogg','sound/vo/mobs/spider/speak (2).ogg','sound/vo/mobs/spider/speak (3).ogg','sound/vo/mobs/spider/speak (4).ogg'), 80, TRUE, -1)

/datum/species/night_spider/regenerate_icons(mob/living/carbon/human/H)
	H.icon = 'icons/roguetown/mob/monster/spider.dmi'
	H.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	H.icon_state = "honeys"
	H.update_damage_overlays()
	return TRUE

/datum/species/night_spider/update_damage_overlays(mob/living/carbon/human/H)
	H.remove_overlay(DAMAGE_LAYER)
	return TRUE
