/datum/species/ooze
	name = "Murkling"
	id = "ooze"
	desc = "<b>Murkling</b><br>\
	A curious, 'young' species typically associated with Pestra due to their inclinations to the goddess of plague and healing.  \
	Some say they’re older than most races in Psydonia, \
	but they’ve only just recently evolved into something considered potentially ‘humen’. \
	Little is known about where the Murklings come from, but their unique biology makes them dangerously adaptive. \
	Newly-sprouting colonies have been found anywhere from the freezing mountains of Hammerhold to the desert sands of Naledi, \
	though they are most commonly associated with the underdark - their first recorded sightings in its suffocating, lightless depths.<br>\
	<span style='color: #6a8cb7;text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'><b>+1 CON | -1 INT | -1 SPD<br>\
	Easy Dismember | Limb Regrowth | No Bones | No Blood</b></span><br><br>"
	base_name = "Godtouched"
	is_subrace = TRUE
	origin_default = /datum/virtue/origin/racial/underdark
	origin = "Underdark"
	default_color = "79F299"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,MUTCOLORS,NOBLOOD)
	default_features = MANDATORY_FEATURE_LIST
	use_skintones = FALSE
	possible_ages = ALL_AGES_LIST
	disliked_food = NONE
	liked_food = NONE
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mt.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fm.dmi'
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
		OFFSET_TAUR = list(-16,0), OFFSET_TAUR_F = list(-16,0), \
		)
	race_bonus = list(STAT_CONSTITUTION = 1, STAT_INTELLIGENCE = -1, STAT_SPEED = -1)
	inherent_traits = list(
						TRAIT_NASTY_EATER,
						TRAIT_EASYDISMEMBER,
						TRAIT_REGROW_LIMBS,
						TRAIT_ZOMBIE_IMMUNE,
						TRAIT_BLOODLOSS_IMMUNE
						)
	enflamed_icon = "widefire"
	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid/slime,
		/datum/customizer/bodypart_feature/hair/facial/humanoid/slime,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/bodypart_feature/underwear,
		/datum/customizer/bodypart_feature/legwear,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/human,
		/datum/customizer/organ/vagina/human_anthro,
		/datum/customizer/organ/testicles/anthro,
		)
	body_marking_sets = list(
		/datum/body_marking_set/none,
		/datum/body_marking_set/belly,
		/datum/body_marking_set/bellysocks,
		/datum/body_marking_set/tiger,
		/datum/body_marking_set/tiger_dark,
		/datum/body_marking_set/gradient,
	)
	body_markings = list(
		/datum/body_marking/flushed_cheeks,
		/datum/body_marking/eyeliner,
		/datum/body_marking/tonage,
		/datum/body_marking/nose,
		/datum/body_marking/bangs,
		/datum/body_marking/bun,
	)
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain/ooze,
		ORGAN_SLOT_HEART = /obj/item/organ/heart/ooze,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs/ooze,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/ooze,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/wild_tongue/ooze,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver/ooze,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach/ooze,
		)

////// ORGAN SPRITES, provided by VelSlime
/obj/item/organ/brain/ooze
	name = "Ooze Neural Core"
	icon = 'icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC
	decoy_override = TRUE

/obj/item/organ/lungs/ooze
	name = "Ooze Breathing Sac"
	icon = 'icons/obj/velslime.dmi'
	icon_state = "liver" //No lungs sprite, re-using the liver sprite instead.
	organ_flags = ORGAN_ORGANIC

/obj/item/organ/heart/ooze
	name = "Ooze Fluid Pump"
	icon = 'icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC

/obj/item/organ/eyes/ooze
	name = "Ooze Ocular Sensors"
	icon = 'icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC

/obj/item/organ/tongue/wild_tongue/ooze
	name = "Ooze Taste Buds"
	icon = 'icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC

/obj/item/organ/stomach/ooze
	name = "Ooze Digestive Chamber"
	icon = 'icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC

/obj/item/organ/liver/ooze
	name = "Ooze Detoxification Organelle"
	icon = 'icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC

/datum/species/ooze/check_roundstart_eligible()
	return TRUE
