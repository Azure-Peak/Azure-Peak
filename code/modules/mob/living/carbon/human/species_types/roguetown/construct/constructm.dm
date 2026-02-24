/mob/living/carbon/human/species/construct/metal
	race = /datum/species/construct/metal
	construct = 1

/datum/species/construct/metal
	name = "Metal Construct"
	id = "constructm"
	origin_default = /datum/virtue/origin/naledi
	origin = "Naledi"
	base_name = "Godtouched"
	is_subrace = TRUE
	desc = "<b>Metallic Construct</b><br>\
	Masterworks of artifice, metal constructs are as the name implies- entirely constructed by mortal hands. They are beings not of flesh and blood, but cold metal and the arcyne. Constructs are said to originate from works of Zizo, and they hail from the far-off lands of the Southern Empty- a great city of artifice, where the only artificers capable of understanding what is necessary to create the constructs live. For some reason, they have found themselves travelling out of the empty, as of late. Children of the Resonator Siphon.<br>\
	<span style='color: #6a8cb7;text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'><b>+1 WIL | -2 SPD | Insomnia | No Hunger | No Bleeding </b></span><br><br>"

	construct = 1
	skin_tone_wording = "Material"
	use_skin_tone_wording_for_examine = FALSE
	default_color = "FFFFFF"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,STUBBLE,OLDGREY,NOBLOOD)
	default_features = MANDATORY_FEATURE_LIST
	use_skintones = TRUE
	possible_ages = ALL_AGES_LIST
	skinned_type = /obj/item/ingot/steel
	disliked_food = NONE
	liked_food = NONE
	inherent_traits = list(
		TRAIT_NOHUNGER,
		TRAIT_BLOODLOSS_IMMUNE,
		TRAIT_NOBREATH,
		TRAIT_ZOMBIE_IMMUNE
		)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mcom.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fcom.dmi'
	dam_icon = 'icons/roguetown/mob/bodies/dam/dam_male.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	soundpack_m = /datum/voicepack/male
	soundpack_f = /datum/voicepack/female
	offset_features = list(
		OFFSET_ID = list(0,1), OFFSET_GLOVES = list(0,1), OFFSET_WRISTS = list(0,1),\
		OFFSET_CLOAK = list(0,1), OFFSET_FACEMASK = list(0,1), OFFSET_HEAD = list(0,1), \
		OFFSET_FACE = list(0,1), OFFSET_BELT = list(0,1), OFFSET_BACK = list(0,1), \
		OFFSET_NECK = list(0,1), OFFSET_MOUTH = list(0,1), OFFSET_PANTS = list(0,1), \
		OFFSET_SHIRT = list(0,1), OFFSET_ARMOR = list(0,1), OFFSET_HANDS = list(0,1), OFFSET_UNDIES = list(0,1), \
		OFFSET_ID_F = list(0,-1), OFFSET_GLOVES_F = list(0,0), OFFSET_WRISTS_F = list(0,0), OFFSET_HANDS_F = list(0,0), \
		OFFSET_CLOAK_F = list(0,0), OFFSET_FACEMASK_F = list(0,-1), OFFSET_HEAD_F = list(0,-1), \
		OFFSET_FACE_F = list(0,-1), OFFSET_BELT_F = list(0,0), OFFSET_BACK_F = list(0,-1), \
		OFFSET_NECK_F = list(0,-1), OFFSET_MOUTH_F = list(0,-1), OFFSET_PANTS_F = list(0,0), \
		OFFSET_SHIRT_F = list(0,0), OFFSET_ARMOR_F = list(0,0), OFFSET_UNDIES_F = list(0,-1), \
		)
	race_bonus = list(STAT_WILLPOWER = 1, STAT_SPEED = -2)
	enflamed_icon = "widefire"
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain/construct,
		ORGAN_SLOT_HEART = /obj/item/organ/heart/construct,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs/construct,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/construct,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/construct,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver/construct,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach/construct,
		)
	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid,
		/datum/customizer/bodypart_feature/hair/facial/humanoid,
		/datum/customizer/bodypart_feature/crest,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/bodypart_feature/underwear,
		/datum/customizer/bodypart_feature/legwear,
		/datum/customizer/bodypart_feature/piercing,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/human,
		/datum/customizer/organ/vagina/human_anthro,
		)
	body_marking_sets = list(
		/datum/body_marking_set/none,
		/datum/body_marking_set/construct_plating_light,
		/datum/body_marking_set/construct_plating_medium,
		/datum/body_marking_set/construct_plating_heavy,
		)
	body_markings = list(
		/datum/body_marking/eyeliner,
		/datum/body_marking/tonage,
		/datum/body_marking/nose,
		/datum/body_marking/construct_plating_light,
		/datum/body_marking/construct_plating_medium,
		/datum/body_marking/construct_plating_heavy,
		/datum/body_marking/construct_head_standard,
		/datum/body_marking/construct_head_round,
		/datum/body_marking/construct_standard_eyes,
		/datum/body_marking/construct_visor_eyes,
		/datum/body_marking/construct_psyclops_eye,
	)

	restricted_virtues = list(/datum/virtue/utility/noble, /datum/virtue/utility/deathless)

/datum/species/construct/metal/check_roundstart_eligible()
	return TRUE
	
/datum/species/construct/metal/get_skin_list()
	return list(
		"BRASS" = "dfbd6c",
		"IRON" = "525352",
		"STEEL" = "babbb9",
		"BRONZE" = "e2a670",
		"GOLD" = "bf9b30",
		"WOOD" = "8B4513",
		"PORCELAIN" = "FFF5EE",
	)

/datum/species/construct/metal/get_hairc_list()
	return sortList(list(

	"black - midnight" = "1d1b2b",

	"red - blood" = "822b2b"

	))

