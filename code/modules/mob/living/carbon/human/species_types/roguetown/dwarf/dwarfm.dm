/mob/living/carbon/human/species/dwarf/mountain
	race = /datum/species/dwarf/mountain

/datum/species/dwarf/mountain
	name = "Dwarf"
	id = "dwarfm"
	clothes_id = "dwarf"
	desc = "<b>Dwarf</b><br>\
	A proud and robust race of short mountain folk, \
	the dwarves are known for their pride in martial strength \
	and the tenacity with which they adhere to their ancient traditions. \
	A Dwarf, much like the rock that they carve their fortresses out of, \
	is stubborn and ancient, with their race being the longest lived of all \
	of the Weeping God's creations. They, like stone, also rarely change \
	and tend to shun the modernization of the world around them. \
	Instead, a Dwarf looks to their ancestorial heritage for guidance on \
	the various challenges they face. Even if, ironically, this behaviour \
	leads their kind towards technological advacement as they continue \
	to improve their crafts, both in engineering workshops and the forges. \
	Dwarves are hearty, but are not known for their speed or eyesight... \
	Each dwarf hails from a ancient fortress named after the most plentiful mineral.<br>\
	(+1 Constitution, +1 Willpower)"

	skin_tone_wording = "Dwarf Fortress"

	default_color = "FFFFFF"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,YOUNGBEARD,STUBBLE,OLDGREY)
	inherent_traits = list(TRAIT_DRUNK_HEALING)
	possible_ages = ALL_AGES_LIST
	default_features = MANDATORY_FEATURE_LIST
	use_skintones = TRUE
	disliked_food = NONE
	liked_food = NONE
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	limbs_icon_m = 'icons/roguetown/mob/bodies/m/md.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fd.dmi'
	dam_icon = 'icons/roguetown/mob/bodies/dam/dam_male.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	hairyness = "t3"
	soundpack_m = /datum/voicepack/male/dwarf
	soundpack_f = /datum/voicepack/female/dwarf
	custom_clothes = TRUE
	offset_features = list(
		OFFSET_ID = list(0,0), OFFSET_GLOVES = list(0,0), OFFSET_WRISTS = list(0,0),\
		OFFSET_CLOAK = list(0,0), OFFSET_FACEMASK = list(0,-4), OFFSET_HEAD = list(0,-4), \
		OFFSET_FACE = list(0,-4), OFFSET_BELT = list(0,-5), OFFSET_BACK = list(0,-4), \
		OFFSET_NECK = list(0,-4), OFFSET_MOUTH = list(0,-4), OFFSET_PANTS = list(0,0), \
		OFFSET_SHIRT = list(0,0), OFFSET_ARMOR = list(0,0), OFFSET_HANDS = list(0,-3), \
		OFFSET_ID_F = list(0,-4), OFFSET_GLOVES_F = list(0,-4), OFFSET_WRISTS_F = list(0,-4), OFFSET_HANDS_F = list(0,-4), \
		OFFSET_CLOAK_F = list(0,0), OFFSET_FACEMASK_F = list(0,-5), OFFSET_HEAD_F = list(0,-5), \
		OFFSET_FACE_F = list(0,-5), OFFSET_BELT_F = list(0,-5), OFFSET_BACK_F = list(0,-5), \
		OFFSET_NECK_F = list(0,-5), OFFSET_MOUTH_F = list(0,-5), OFFSET_PANTS_F = list(0,0), \
		OFFSET_SHIRT_F = list(0,0), OFFSET_ARMOR_F = list(0,0), OFFSET_UNDIES = list(0,-4), OFFSET_UNDIES_F = list(0,-4), \
		)
	race_bonus = list(STAT_CONSTITUTION = 1, STAT_WILLPOWER = 1)
	enflamed_icon = "widefire"
	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid,
		/datum/customizer/bodypart_feature/hair/facial/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/bodypart_feature/underwear,
		/datum/customizer/bodypart_feature/legwear,
		/datum/customizer/organ/testicles/anthro,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/human,
		/datum/customizer/organ/vagina/human,
		)
	body_markings = list(
	)

/datum/species/dwarf/mountain/check_roundstart_eligible()
	return TRUE

/datum/species/dwarf/mountain/get_span_language(datum/language/message_language)
	if(!message_language)
		return
	if(message_language.type == /datum/language/dwarvish)
		return list(SPAN_DWARF)
//	if(message_language.type == /datum/language/common)
//		return list(SPAN_DWARF)
	return message_language.spans

/datum/species/dwarf/mountain/get_skin_list()
	return list(
		"Platinum" = SKIN_COLOR_PLATINUM,
		"Aurum" = SKIN_COLOR_AURUM,
		"Quicksilver" = SKIN_COLOR_QUICKSILVER,
		"Brass" = SKIN_COLOR_BRASS,
		"Iron" = SKIN_COLOR_IRON,
		"Malachite" = SKIN_COLOR_MALACHITE,
		"Obsidian" = SKIN_COLOR_OBSIDIAN,
		"Brimstone" = SKIN_COLOR_BRIMSTONE,
		"Jade" = SKIN_COLOR_JADE,
		"Ceragyrite" = SKIN_COLOR_CERAGYRITE
	)

/datum/species/dwarf/mountain/random_name(gender,unique,lastname)

	var/randname
	if(unique)
		if(gender == MALE)
			for(var/i in 1 to 10)
				randname = pick( world.file2list("strings/rt/names/dwarf/dwarmm.txt") )
				if(!findname(randname))
					break
		if(gender == FEMALE)
			for(var/i in 1 to 10)
				randname = pick( world.file2list("strings/rt/names/dwarf/dwarmf.txt") )
				if(!findname(randname))
					break
	else
		if(gender == MALE)
			randname = pick( world.file2list("strings/rt/names/dwarf/dwarmm.txt") )
		if(gender == FEMALE)
			randname = pick( world.file2list("strings/rt/names/dwarf/dwarmf.txt") )
	return randname

/datum/species/dwarf/mountain/random_surname()
	return " [pick(world.file2list("strings/rt/names/dwarf/dwarmlast.txt"))]"
