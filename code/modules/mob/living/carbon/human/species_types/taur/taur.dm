// Taur — the generic centaur-kin, and the non-subrace anchor of the "Taur" race group.
//
// The race picker in preferences.dm only builds its group list from species with is_subrace = FALSE,
// so Lamia and Drider need this entry to exist for "Taur" to appear at all; they then show up under
// it in the subrace picker. Unlike them, the Taur has no fixed lower body and picks any of the four
// from the taur body chooser in setup - the hoofed ones, at least; the serpent and spider bodies are
// reserved for the Lamia and Drider subraces so that each lower body has exactly one route to it.

/mob/living/carbon/human/species/taur
	race = /datum/species/taur

/datum/species/taur
	name = "Taur"
	id = "taur"
	is_subrace = FALSE
	origin_default = /datum/virtue/origin/etrusca
	origin = "Etrusca"
	base_name = "Taur"
	sub_name = "Taur"
	desc_title = "Taur"
	desc = "<b>Taur</b><br>\
	The taur-kin are those beastvolk whose lower halves are wholly bestial - a humanoid torso rising from \
	the body of a hoofed beast. No two taur tribes agree on which beast is the truest, and so they have \
	spread across the southern reaches, some bearing the barrel and hooves of a saiga, others the cloven \
	legs of a goat. Strong of frame and long of stride, they cannot abide boots upon their hooves. \
	Their serpentine and spider-bodied cousins keep to their own kind - see the Lamia and the Drider."
	//VALMORIAN: no stat or trait lines in desc - set_new_race() already prints race_bonus and
	//inherent_traits underneath it, so anything repeated here shows up twice. Only mechanics that
	//nothing else announces belong in mechanics_explanations.
	mechanics_explanations = list("Their hooved lower body cannot wear boots or pants.")
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
	inherent_traits = list(TRAIT_LONGSTRIDER, TRAIT_WILD_EATER)
	disliked_food = NONE
	race_bonus = list(STAT_STRENGTH = 1, STAT_SPEED = -1)
	enflamed_icon = "widefire"
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
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

	// The serpent and spider bodies belong to the Lamia and Drider subraces, which carry their own
	// statblocks and abilities - offering them here too would make those species skippable.
	allowed_taur_types = list(
		/obj/item/bodypart/taur/horse,
		/obj/item/bodypart/taur/goat,
	)
	mandatory_taur_type = /obj/item/bodypart/taur/horse

/datum/species/taur/check_roundstart_eligible()
	return TRUE

/datum/species/taur/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/taur/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	// copy_to() re-runs Taurize afterwards with the player's chosen body and colour; this guarantees
	// a taur lower body on paths that never touch preferences (admin species swaps, wabbajack).
	if(!C.get_taur_tail())
		C.Taurize(mandatory_taur_type)

/datum/species/taur/on_species_loss(mob/living/carbon/C)
	. = ..()
	C.ensure_not_taur()
