/mob/living/carbon/human/species/kobold
	race = /datum/species/kobold

/datum/species/kobold
	name = "Kobold"
	id = "kobold"
	is_subrace = TRUE
	origin_default = /datum/virtue/origin/gronn
	origin = "Gronn"
	base_name = "Zard"
	desc = "<b>Kobold</b><br>\
	Short in stature and typically scrawny, these little lizards make up for it in their natural agility. People typically stereotype them as thieves, though...<br>\
	<span style='color: #6a8cb7;text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'><b>+1 FOR | +1 STAT of choice.</b></span><br>"
	species_traits = list(EYECOLOR,LIPS,STUBBLE,MUTCOLORS)
	possible_ages = ALL_AGES_LIST
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	limbs_icon_m = 'icons/mob/species/anthro_small_malea.dmi'
	limbs_icon_f = 'icons/mob/species/anthro_small_femalea.dmi'
	dam_icon = 'icons/roguetown/mob/bodies/dam/dam_male.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	soundpack_m = /datum/voicepack/male/elf
	soundpack_f = /datum/voicepack/female/elf
	use_f = TRUE
	custom_clothes = TRUE
	clothes_id = "dwarf"
	offset_features = list(
		OFFSET_ID = list(0,0), OFFSET_GLOVES = list(0,-3), OFFSET_WRISTS = list(0,-3),\
		OFFSET_CLOAK = list(0,0), OFFSET_FACEMASK = list(0,-4), OFFSET_HEAD = list(0,-4), \
		OFFSET_FACE = list(0,-4), OFFSET_BELT = list(0,-4), OFFSET_BACK = list(0,-3), \
		OFFSET_NECK = list(0,-4), OFFSET_MOUTH = list(0,-4), OFFSET_PANTS = list(0,0), \
		OFFSET_SHIRT = list(0,0), OFFSET_ARMOR = list(0,0), OFFSET_HANDS = list(0,-3), \
		OFFSET_ID_F = list(0,-4), OFFSET_GLOVES_F = list(0,-4), OFFSET_WRISTS_F = list(0,-4), OFFSET_HANDS_F = list(0,-4), \
		OFFSET_CLOAK_F = list(0,0), OFFSET_FACEMASK_F = list(0,-5), OFFSET_HEAD_F = list(0,-5), \
		OFFSET_FACE_F = list(0,-5), OFFSET_BELT_F = list(0,-4), OFFSET_BACK_F = list(0,-4), \
		OFFSET_NECK_F = list(0,-5), OFFSET_MOUTH_F = list(0,-5), OFFSET_PANTS_F = list(0,0), \
		OFFSET_SHIRT_F = list(0,0), OFFSET_ARMOR_F = list(0,0), OFFSET_UNDIES = list(0,-4), OFFSET_UNDIES_F = list(0,-4), \
		)
	race_bonus = list(STAT_FORTUNE = 1)

	custom_selection = list(
		"+1 FOR" = STATKEY_LCK,
		"+1 INT" = STATKEY_INT,
		"+1 CON" = STATKEY_CON,
		"+1 WIL" = STATKEY_WIL,
		"+1 PER" = STATKEY_PER,
	)

	enflamed_icon = "widefire"
	attack_verb = "slash"
	attack_sound = 'sound/blank.ogg'
	miss_sound = 'sound/blank.ogg'
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/lizard,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_TAIL = /obj/item/organ/tail/kobold,
		ORGAN_SLOT_SNOUT = /obj/item/organ/snout/lizard,
		ORGAN_SLOT_FRILLS = /obj/item/organ/frills/lizard,
		ORGAN_SLOT_HORNS = /obj/item/organ/horns,
		//ORGAN_SLOT_TESTICLES = /obj/item/organ/testicles,
		//ORGAN_SLOT_PENIS = /obj/item/organ/penis/tapered,
		//ORGAN_SLOT_BREASTS = /obj/item/organ/breasts,
		//ORGAN_SLOT_VAGINA = /obj/item/organ/vagina,
		)
	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid/bald_default,
		/datum/customizer/bodypart_feature/hair/facial/humanoid/shaved_default,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/bodypart_feature/underwear,
		/datum/customizer/bodypart_feature/legwear,
		/datum/customizer/bodypart_feature/piercing,
		/datum/customizer/organ/snout/lizard,
		/datum/customizer/organ/frills/lizard,
		/datum/customizer/organ/horns/humanoid,
		/datum/customizer/organ/testicles/anthro,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/animal,
		/datum/customizer/organ/vagina/animal,
		)
	body_marking_sets = list(
		/datum/body_marking_set/none,
		/datum/body_marking_set/kobold_scale,
	)
	body_markings = list(
		/datum/body_marking/small/plain,
		/datum/body_marking/small/sock,
		/datum/body_marking/small/socklonger,
		/datum/body_marking/small/tips,
		/datum/body_marking/small/belly,
		/datum/body_marking/small/bellyslim,
		/datum/body_marking/small/butt,
		/datum/body_marking/small/tie,
		/datum/body_marking/small/tiesmall,
		/datum/body_marking/small/backspots,
		/datum/body_marking/small/front,
		/datum/body_marking/small/spotted,
		/datum/body_marking/small/nose,
		/datum/body_marking/small/bangs,
		/datum/body_marking/small/bun,
	)
	languages = list(
		/datum/language/common,
		/datum/language/draconic
	)
	stress_examine = TRUE
	stress_desc = span_red("Thieving little kobold...")
	descriptor_choices = list(
		/datum/descriptor_choice/trait,
		/datum/descriptor_choice/stature,
		/datum/descriptor_choice/height,
		/datum/descriptor_choice/body,
		/datum/descriptor_choice/face,
		/datum/descriptor_choice/face_exp,
		/datum/descriptor_choice/scales,
		/datum/descriptor_choice/voice,
		/datum/descriptor_choice/prominent_one,
		/datum/descriptor_choice/prominent_two,
		/datum/descriptor_choice/prominent_three,
		/datum/descriptor_choice/prominent_four,
	)

/datum/species/kobold/check_roundstart_eligible()
	return TRUE

/datum/species/kobold/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/kobold/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/species/kobold/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_SAY)

/datum/species/kobold/get_random_body_markings(list/passed_features)
	return assemble_body_markings_from_set(GLOB.body_marking_sets_by_type[/datum/body_marking_set/kobold_scale], passed_features, src)

/datum/species/kobold/get_random_features()
	var/list/returned = MANDATORY_FEATURE_LIST
	var/main_color
	var/second_color
	var/random = rand(1,9)
	//Choose from a variety of draconic colors
	switch(random)
		if(1)
			main_color = "e43900"
			second_color = "ea673c"
		if(2)
			main_color = "ea6f01"
			second_color = "ea8e3c"
		if(3)
			main_color = "eaa501"
			second_color = "e7b43a"
		if(4)
			main_color = "63d100"
			second_color = "89d248"
		if(5)
			main_color = "51aa01"
			second_color = "70ae39"
		if(6)
			main_color = "00b302"
			second_color = "2eb62f"
		if(7)
			main_color = "02c33c"
			second_color = "3ac664"
		if(8)
			main_color = "00c170"
			second_color = "3fbf89"
		if(9)
			main_color = "00bc94"
			second_color = "3cbea2"
	returned["mcolor"] = main_color
	returned["mcolor2"] = second_color
	returned["mcolor3"] = second_color
	return returned
