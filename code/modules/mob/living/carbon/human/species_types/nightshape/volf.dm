/mob/living/carbon/human/species/wildshape/night_volf
	name = "Volf"
	race = /datum/species/night_wolf
	footstep_type = FOOTSTEP_MOB_CLAW
	ambushable = FALSE
	skin_armor = new /obj/item/clothing/suit/roguetown/armor/skin_armor/wolf_skin
	wildshape_icon = 'icons/roguetown/mob/monster/volf.dmi'
	wildshape_icon_state = "volf_brown"

/mob/living/carbon/human/species/wildshape/night_volf/gain_inherent_skills()	
	if(src.mind)
		src.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
		src.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
		src.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		src.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		src.adjust_skillrank(/datum/skill/misc/tracking, 4, TRUE)
		src.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE)
		src.adjust_skillrank(/datum/skill/misc/hunting, 4, TRUE)

		src.STASTR = 7
		src.STACON = 7
		src.STAPER = 12
		src.STASPD = 13

		AddSpell(new /obj/effect/proc_holder/spell/self/wolfclaws)
		AddSpell(new /obj/effect/proc_holder/spell/self/howl/call_of_the_moon)
		src.real_name = "volf"
		src.faction += "wolfs"

/datum/species/night_wolf
	name = "volf"
	id = "night_wolf"
	species_traits = list(NO_UNDERWEAR, NO_ORGAN_FEATURES, NO_BODYPART_FEATURES)
	inherent_traits = list(
		TRAIT_KNEESTINGER_IMMUNITY,
		TRAIT_STRONGBITE,
		TRAIT_STEELHEARTED,
		TRAIT_BREADY,
		TRAIT_ORGAN_EATER,
		TRAIT_WILD_EATER,
		TRAIT_HARDDISMEMBER,
		TRAIT_PIERCEIMMUNE,
		TRAIT_LONGSTRIDER,
		TRAIT_PERFECT_TRACKER
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

/datum/species/night_wolf/send_voice(mob/living/carbon/human/H)
	playsound(get_turf(H), pick('sound/vo/mobs/vw/idle (1).ogg','sound/vo/mobs/vw/idle (2).ogg','sound/vo/mobs/vw/bark (1).ogg','sound/vo/mobs/vw/bark (2).ogg','sound/vo/mobs/vw/idle (3).ogg'), 80, TRUE, -1)

/datum/species/night_wolf/regenerate_icons(mob/living/carbon/human/H)
	H.icon = 'icons/roguetown/mob/monster/volf.dmi'
	H.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	H.icon_state = "volf_brown"
	H.update_damage_overlays()
	return TRUE

/datum/species/night_wolf/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/species/night_wolf/update_damage_overlays(mob/living/carbon/human/H)
	H.remove_overlay(DAMAGE_LAYER)
	return TRUE
