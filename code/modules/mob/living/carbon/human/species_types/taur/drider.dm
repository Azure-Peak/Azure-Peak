// Drider — ported from Emerald Summit (including PR #167's statblock and ability pass), rebuilt on
// Valmorian Isle's taur bodypart pipeline. See lamia.dm for the pipeline notes.
//
// PR #167's Underdark origin maps to TRAIT_CAVEDWELLER here, which is Valmorian Isle's equivalent
// of ES's TRAIT_UNDERDARK (see the dark elf at species_types/roguetown/elf/elfd.dm). Web-weaving,
// web-walking and venom all ride on /obj/item/bodypart/taur/spider — see modular/taur_abilities.

/mob/living/carbon/human/species/drider
	race = /datum/species/drider

/datum/species/drider
	name = "Drider"
	id = "drider"
	is_subrace = TRUE
	origin_default = /datum/virtue/origin/racial/underdark
	origin = "Underdark"
	base_name = "Taur"
	sub_name = "Drider"
	desc_title = "Drider"
	desc = "<b>Drider</b><br>\
	A humanoid torso rising from the body of a great spider. Driders are reclusive weavers of the deep \
	woods, caverns and ruins, scuttling across walls and webs with unsettling ease. Shunned for their \
	monstrous shape, most keep to the wilds and the dark, though a rare few walk among the other races. \
	They move freely across the webs of their kin."
	//VALMORIAN: no stat or trait lines in desc - set_new_race() already prints race_bonus and
	//inherent_traits underneath it. Venom, webwalking and Weave Web come from the taur bodypart
	//rather than inherent_traits, so the auto-printer never mentions them; listed here instead.
	mechanics_explanations = list("Their spider body cannot wear boots or pants.",
		"Chewing on prey with their fangs injects venom.",
		"They can weave webs, and cross any web freely.",
		"Their chitin acts as natural armour, and mends itself over time.")
	default_color = "FFFFFF"
	species_traits = list(EYECOLOR, LIPS, HAIR, OLDGREY, MUTCOLORS)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	possible_ages = ALL_AGES_LIST
	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mt.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fm.dmi'
	dam_icon = 'icons/roguetown/mob/bodies/dam/dam_male.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	// Boots and pants are blocked dynamically by the is_taur gate in species.dm's can_equip.
	no_equip = list()
	soundpack_m = /datum/voicepack/male
	soundpack_f = /datum/voicepack/female
	offset_features = list(
		OFFSET_ID = list(0,1), OFFSET_GLOVES = list(0,1), OFFSET_WRISTS = list(0,1),\
		OFFSET_CLOAK = list(0,1), OFFSET_FACEMASK = list(0,1), OFFSET_HEAD = list(0,1), \
		OFFSET_FACE = list(0,1), OFFSET_BELT = list(0,1), OFFSET_BACK = list(0,1), \
		OFFSET_NECK = list(0,1), OFFSET_MOUTH = list(0,1), OFFSET_PANTS = list(0,0), \
		OFFSET_SHIRT = list(0,1), OFFSET_ARMOR = list(0,1), OFFSET_HANDS = list(0,1), OFFSET_UNDIES = list(0,1), \
		OFFSET_ID_F = list(0,-1), OFFSET_GLOVES_F = list(0,0), OFFSET_WRISTS_F = list(0,0), OFFSET_HANDS_F = list(0,0), \
		OFFSET_CLOAK_F = list(0,0), OFFSET_FACEMASK_F = list(0,-1), OFFSET_HEAD_F = list(0,-1), \
		OFFSET_FACE_F = list(0,-1), OFFSET_BELT_F = list(0,0), OFFSET_BACK_F = list(0,-1), \
		OFFSET_NECK_F = list(0,-1), OFFSET_MOUTH_F = list(0,-1), OFFSET_PANTS_F = list(0,0), \
		OFFSET_SHIRT_F = list(0,0), OFFSET_ARMOR_F = list(0,0), OFFSET_UNDIES_F = list(0,-1), \
		)
	inherent_traits = list(TRAIT_LONGSTRIDER, TRAIT_WILD_EATER, TRAIT_CAVEDWELLER)
	disliked_food = NONE
	race_bonus = list(STAT_CONSTITUTION = 2, STAT_SPEED = -1, STAT_PERCEPTION = -1)
	enflamed_icon = "widefire"
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/wild_tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		)
	bodypart_features = list(
		/datum/bodypart_feature/hair/head,
		/datum/bodypart_feature/hair/facial,
	)
	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid,
		/datum/customizer/bodypart_feature/hair/facial/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/bodypart_feature/underwear,
		/datum/customizer/organ/horns/anthro,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/testicles/anthro,
		/datum/customizer/organ/breasts/human,
		/datum/customizer/organ/vagina/anthro,
		)
	body_marking_sets = list(
		/datum/body_marking_set/none,
	)
	languages = list(
		/datum/language/common,
	)
	body_markings = list(
		/datum/body_marking/flushed_cheeks,
		/datum/body_marking/eyeliner,
		/datum/body_marking/plain,
		/datum/body_marking/nose,
	)
	descriptor_choices = list(
		/datum/descriptor_choice/height,
		/datum/descriptor_choice/body,
		/datum/descriptor_choice/stature,
		/datum/descriptor_choice/face,
		/datum/descriptor_choice/face_exp,
		/datum/descriptor_choice/voice,
		/datum/descriptor_choice/prominent_one_wild,
		/datum/descriptor_choice/prominent_two_wild,
		/datum/descriptor_choice/prominent_three_wild,
		/datum/descriptor_choice/prominent_four_wild,
	)

	allowed_taur_types = list(
		/obj/item/bodypart/taur/spider,
	)
	mandatory_taur_type = /obj/item/bodypart/taur/spider

/datum/species/drider/check_roundstart_eligible()
	return TRUE

/datum/species/drider/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/drider/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	// Only if they haven't got one already. copy_to() Taurizes with the player's chosen colour, and
	// this call uses the default, so an unconditional call here disagrees on colour, fails Taurize's
	// same-part short circuit, and drops+reattaches the lower body every time the species is applied.
	if(!C.get_taur_tail())
		C.Taurize(mandatory_taur_type)
	C.adjust_skillrank(/datum/skill/misc/climbing, 5, TRUE) // scuttling across walls and webs

/datum/species/drider/on_species_loss(mob/living/carbon/C)
	. = ..()
	C.ensure_not_taur()

/datum/species/drider/spec_fully_heal(mob/living/carbon/human/H)
	// Restore the lower body if it's somehow gone, but don't rebuild an existing one - that would
	// reset the player's chosen colour to the default on every heal.
	if(!H.get_taur_tail())
		H.Taurize(mandatory_taur_type)
