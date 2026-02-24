/mob/living/carbon/human/species/moth
	race = /datum/species/moth

/datum/species/moth
	name = "Fluvian"
	id = "moth"
	is_subrace = TRUE
	origin_default = /datum/virtue/origin/racial/underdark
	origin = "the Underdark"
	base_name = "Beastvolk"
	desc = "Many comparisons have been made to the common moths in an attempt to describe this unique species. From the appetite for clothing to the disconcertingly insectoid appearance, the name 'Moth' is forever stamped onto the common vocabulary. The comparison, however, falls short on the matter of flight.<br>\
	<span style='color: #6a8cb7;text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'><b>+1 SPD</b></span><br>"
	species_traits = list(EYECOLOR,LIPS,STUBBLE,MUTCOLORS,HAIR)
	possible_ages = ALL_AGES_LIST
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	limbs_icon_m = 'icons/mob/species/moth_male.dmi'
	limbs_icon_f = 'icons/mob/species/moth_female.dmi'
	dam_icon = 'icons/roguetown/mob/bodies/dam/dam_male.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	soundpack_m = /datum/voicepack/male/moth
	soundpack_f = /datum/voicepack/female/moth
	offset_features = list(
		OFFSET_ID = list(0,1), OFFSET_GLOVES = list(0,1), OFFSET_WRISTS = list(0,1),\
		OFFSET_CLOAK = list(0,1), OFFSET_FACEMASK = list(0,1), OFFSET_HEAD = list(0,1), \
		OFFSET_FACE = list(0,0), OFFSET_BELT = list(0,1), OFFSET_BACK = list(0,1), \
		OFFSET_NECK = list(0,1), OFFSET_MOUTH = list(0,1), OFFSET_PANTS = list(0,1), \
		OFFSET_SHIRT = list(0,1), OFFSET_ARMOR = list(0,1), OFFSET_HANDS = list(0,1), OFFSET_UNDIES = list(0,1), \
		OFFSET_ID_F = list(0,-1), OFFSET_GLOVES_F = list(0,0), OFFSET_WRISTS_F = list(0,0), OFFSET_HANDS_F = list(0,0), \
		OFFSET_CLOAK_F = list(0,0), OFFSET_FACEMASK_F = list(0,-1), OFFSET_HEAD_F = list(0,-1), \
		OFFSET_FACE_F = list(0,-1), OFFSET_BELT_F = list(0,0), OFFSET_BACK_F = list(0,-1), \
		OFFSET_NECK_F = list(0,-1), OFFSET_MOUTH_F = list(0,-1), OFFSET_PANTS_F = list(0,0), \
		OFFSET_SHIRT_F = list(0,0), OFFSET_ARMOR_F = list(0,0), OFFSET_UNDIES_F = list(0,-1), \
		)
	race_bonus = list(STAT_SPEED = 1)
	enflamed_icon = "widefire"
	attack_verb = "slash"
	attack_sound = 'sound/blank.ogg'
	miss_sound = 'sound/blank.ogg'
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/moth,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/moth,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_ANTENNAS = /obj/item/organ/antennas/moth,
		ORGAN_SLOT_NECK_FEATURE = /obj/item/organ/neck_feature/moth_fluff,
		ORGAN_SLOT_WINGS = /obj/item/organ/wings/moth,
		//ORGAN_SLOT_TESTICLES = /obj/item/organ/testicles,
		//ORGAN_SLOT_PENIS = /obj/item/organ/penis/tapered,
		//ORGAN_SLOT_BREASTS = /obj/item/organ/breasts,
		//ORGAN_SLOT_VAGINA = /obj/item/organ/vagina,
		)
	bodypart_features = list(
		/datum/bodypart_feature/hair/head,
		/datum/bodypart_feature/hair/facial,
	)
	customizers = list(
		/datum/customizer/organ/eyes/moth,
		/datum/customizer/bodypart_feature/hair/head/humanoid,
		/datum/customizer/bodypart_feature/hair/facial/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/bodypart_feature/underwear,
		/datum/customizer/bodypart_feature/legwear,
		/datum/customizer/bodypart_feature/piercing,
		/datum/customizer/organ/wings/moth,
		/datum/customizer/organ/antennas/moth,
		/datum/customizer/organ/neck_feature/moth_fluff,
		/datum/customizer/organ/testicles/anthro,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/animal,
		/datum/customizer/organ/vagina/animal,
		)
	body_marking_sets = list(
		/datum/body_marking_set/none,
		/datum/body_marking_set/moth/reddish,
		/datum/body_marking_set/moth/royal,
		/datum/body_marking_set/moth/gothic,
		/datum/body_marking_set/moth/whitefly,
		/datum/body_marking_set/moth/burnt_off,
		/datum/body_marking_set/moth/deathhead,
		/datum/body_marking_set/moth/poison,
		/datum/body_marking_set/moth/ragged,
		/datum/body_marking_set/moth/moonfly,
		/datum/body_marking_set/moth/oakworm,
		/datum/body_marking_set/moth/jungle,
		/datum/body_marking_set/moth/witchwing,
		/datum/body_marking_set/moth/lovers,
		/datum/body_marking_set/belly,
		/datum/body_marking_set/bellysocks,
		/datum/body_marking_set/tiger,
		/datum/body_marking_set/tiger_dark,
		/datum/body_marking_set/gradient,
	)
	body_markings = list(
		/datum/body_marking/moth/grayscale/reddish,
		/datum/body_marking/moth/grayscale/royal,
		/datum/body_marking/moth/grayscale/gothic,
		/datum/body_marking/moth/grayscale/whitefly,
		/datum/body_marking/moth/grayscale/burnt_off,
		/datum/body_marking/moth/grayscale/deathhead,
		/datum/body_marking/moth/grayscale/poison,
		/datum/body_marking/moth/grayscale/ragged,
		/datum/body_marking/moth/grayscale/moonfly,
		/datum/body_marking/moth/grayscale/oakworm,
		/datum/body_marking/moth/grayscale/jungle,
		/datum/body_marking/moth/grayscale/witchwing,
		/datum/body_marking/moth/grayscale/lovers,
		/datum/body_marking/plain,
		/datum/body_marking/tiger,
		/datum/body_marking/tiger/dark,
		/datum/body_marking/nose,
		/datum/body_marking/flushed_cheeks,
		/datum/body_marking/eyeliner,
		/datum/body_marking/belly,
		/datum/body_marking/bellyslim,
		/datum/body_marking/gradient,
		/datum/body_marking/tonage,
		/datum/body_marking/bangs,
		/datum/body_marking/bun,
	)
	descriptor_choices = list(
		/datum/descriptor_choice/trait,
		/datum/descriptor_choice/stature,
		/datum/descriptor_choice/height,
		/datum/descriptor_choice/body,
		/datum/descriptor_choice/face,
		/datum/descriptor_choice/face_exp,
		/datum/descriptor_choice/chitin,
		/datum/descriptor_choice/voice,
		/datum/descriptor_choice/prominent_one,
		/datum/descriptor_choice/prominent_two,
		/datum/descriptor_choice/prominent_three,
		/datum/descriptor_choice/prominent_four,
	)

/datum/species/moth/check_roundstart_eligible()
	return TRUE

/datum/species/moth/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/moth/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/species/moth/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_SAY)

/datum/species/moth/get_random_body_markings(list/passed_features)
	return assemble_body_markings_from_set(GLOB.body_marking_sets_by_type[pick(body_marking_sets)], passed_features, src)

/datum/species/moth/get_random_features()
	var/list/returned = MANDATORY_FEATURE_LIST
	var/main_color
	var/second_color
	var/random = rand(1,1)
	switch(random)
		if(1)
			main_color = "edcf7e"
			second_color = "2b2a24"
	returned["mcolor"] = main_color
	returned["mcolor2"] = second_color
	returned["mcolor3"] = second_color
	return returned
