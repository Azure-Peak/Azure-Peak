/mob/living/carbon/human/species/aasimar
	race = /datum/species/aasimar

/datum/species/aasimar
	name = "Aasimar"
	id = "aasimar"
	origin_default = /datum/virtue/origin/otava
	origin = "Otava"
	base_name = "Godtouched"
	desc_title = "Aasimar"
	desc = "Creations of the gods and their angels, most Aasimar bear bindings and compulsions, placed \
	upon them by their creators; they are ageless so long as they abide by these. Aasimar of the Four do not bear bindings. \
	It is believed to be inevitable that an Aasimar will eventually break these bindings, and begin to age, for as the Yils pass they will grow more and more \
	independent, until they are as people fully. Rare Aasimar resulting from offspring of an Aasimar (or angel) and a mortal are ageless \
	without bindings. In extremely rare cases, Aasimar may be created from a divine blessing placed upon a mortal. \
	Aasimar vary wildly in appearance, being made of anything from starstone to metal, flesh, clay, or wood. Some are made of beauty and love incarnate, \
	others cold and pale but living flesh. Some bear the pointed ears of Elves, from heritage. Some may also be born with wings, though \
	a number of these Aasimar purposefully remove their own wings, particularly those among the Psydonic, for they believe removing them \
	brings them closer to Humenity and in some cases that they are undeserving of something that brings them closer to angels."

	max_age = "???"

	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,STUBBLE,OLDGREY)
	inherent_traits = list(TRAIT_NOMOBSWAP)
	default_features = MANDATORY_FEATURE_LIST
	use_skintones = TRUE
	disliked_food = NONE
	liked_food = NONE
	possible_ages = ALL_AGES_LIST
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mt.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fm.dmi'
	dam_icon = 'icons/roguetown/mob/bodies/dam/dam_male.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	soundpack_m = /datum/voicepack/male/elf
	soundpack_f = /datum/voicepack/female/elf
	offset_features = list(
		OFFSET_ID = list(0,1), OFFSET_GLOVES = list(0,1), OFFSET_WRISTS = list(0,1),\
		OFFSET_CLOAK = list(0,1), OFFSET_FACEMASK = list(0,1), OFFSET_HEAD = list(0,1), \
		OFFSET_FACE = list(0,1), OFFSET_BELT = list(0,1), OFFSET_BACK = list(0,1), \
		OFFSET_NECK = list(0,1), OFFSET_MOUTH = list(0,1), OFFSET_PANTS = list(0,1), \
		OFFSET_SHIRT = list(0,1), OFFSET_ARMOR = list(0,1), OFFSET_HANDS = list(0,1), OFFSET_UNDIES = list(0,1), \
		OFFSET_ID_F = list(0,-1), OFFSET_GLOVES_F = list(0,0), OFFSET_WRISTS_F = list(0,0), OFFSET_HANDS_F = list(0,0), \
		OFFSET_CLOAK_F = list(0,0), OFFSET_FACEMASK_F = list(0,-1), OFFSET_HEAD_F = list(0,-1), \
		OFFSET_FACE_F = list(0,-1), OFFSET_BELT_F = list(0,-1), OFFSET_BACK_F = list(0,-1), \
		OFFSET_NECK_F = list(0,-1), OFFSET_MOUTH_F = list(0,-1), OFFSET_PANTS_F = list(0,0), \
		OFFSET_SHIRT_F = list(0,0), OFFSET_ARMOR_F = list(0,0), OFFSET_UNDIES_F = list(0,-1), \
		)
	race_bonus = list(STAT_FORTUNE = 1)
	enflamed_icon = "widefire"
	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid,
		/datum/customizer/bodypart_feature/hair/facial/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/bodypart_feature/underwear,
		/datum/customizer/bodypart_feature/legwear,
		/datum/customizer/bodypart_feature/piercing,
		/datum/customizer/organ/testicles/anthro,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/human,
		/datum/customizer/organ/vagina/human_anthro,
		/datum/customizer/organ/wings/anthro,
		/datum/customizer/organ/ears/wings,
		/datum/customizer/organ/horns/wings,
		/datum/customizer/organ/snout/wings,
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
		/datum/body_marking/flushed_cheeks, //Azure > Hearth
		/datum/body_marking/eyeliner,
		/datum/body_marking/tonage,
		/datum/body_marking/waist,
		/datum/body_marking/womb_tattoo,
		/datum/body_marking/butterfly
	)
	languages = list(
		/datum/language/common,
		/datum/language/celestial
	)

	custom_selection = list(
		"+1 FOR" = STATKEY_LCK,
		"+1 INT" = STATKEY_INT,
		"+1 CON" = STATKEY_CON,
		"+1 WIL" = STATKEY_WIL,
		"+1 PER" = STATKEY_PER,
		"No Hunger & Thirst" = TRAIT_NOHUNGER
	)
	mechanics_explanations = list("Are the only race whose lux is already purified when extracted. However, their lux takes far longer to regrow than every other races.")

/datum/species/aasimar/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))


/datum/species/aasimar/after_creation(mob/living/carbon/C)
	..()
	to_chat(C, "<span class='info'>I can speak Celestial with ,c before my speech.</span>")

/datum/species/aasimar/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_SAY)

/datum/species/aasimar/get_skin_list()
	return list(
		"Cultor" = SKIN_COLOR_CULTOR,
		"Spiritus" = SKIN_COLOR_SPIRITUS,
		"Planetar" = SKIN_COLOR_PLANETAR,
		"Deva"	   = SKIN_COLOR_DEVA,
		"Solar" = SKIN_COLOR_SOLAR,
		"Empyrea" = SKIN_COLOR_EMPYREA,
		"Gaeia" = SKIN_COLOR_GAEIA,
		"Celestial" = SKIN_COLOR_CELESTIAL,
		"Olympia" = SKIN_COLOR_OLYMPIA,
		"Necral" = SKIN_COLOR_NECRAL,
		"Abyssal" = SKIN_COLOR_ABYSSAL,
		"Figulus" = SKIN_COLOR_FIGULUS,
	)

/datum/species/aasimar/get_hairc_list()
	return sortList(list(
	"white - silver" = "d3d9e3",
	"white - alabaster" = "fffffc",
	"white - skies" = "a1b4d4",
	"yellow - sunlight" = "f3f797",
	"red - flame" = "ab4637"
	))

/datum/species/tieberian/random_name(gender,unique,lastname)

	var/randname
	if(unique)
		if(gender == MALE)
			for(var/i in 1 to 10)
				randname = pick( world.file2list("strings/rt/names/other/aasm.txt") )
				if(!findname(randname))
					break
		if(gender == FEMALE)
			for(var/i in 1 to 10)
				randname = pick( world.file2list("strings/rt/names/other/aasf.txt") )
				if(!findname(randname))
					break
	else
		if(gender == MALE)
			randname = pick( world.file2list("strings/rt/names/other/aasm.txt") )
		if(gender == FEMALE)
			randname = pick( world.file2list("strings/rt/names/other/aasf.txt") )
	return randname

/datum/species/aasimar/random_surname()
	return

/datum/species/aasimar/get_string_bonus_stats(return_null_if_no_stats = FALSE, end_with_glue = FALSE)
	return ..(TRUE, TRUE) + "CHOOSE: +1 bonus stat of your choosing, OR No Hunger & Thirst"
