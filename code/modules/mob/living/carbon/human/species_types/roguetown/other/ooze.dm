/datum/species/ooze
	name = "Murkling"
	id = "ooze"
	desc_title = "Murkling"
	desc = "Few know the true origins of the Murklings. Ancient records place their beginnings deep within the cold caverns of the Underdark \
	where primordial ooze infested tunnels and defended its spawning pits with relentless hostility. \
	For centuries, Dark Elves and Dwarven delvers alike sealed these regions away, leaving the living mire undisturbed. \
	Only within the last century did the ooze begin to change. \
	What emerged were crude humanoid figures that were somehow sentient. \
	They now stood in the shape of humens, two-legged, speaking, and curious to an unsettling degree. Once mindless sludge, they had become something new. \
	As their spawning pools withered like parents releasing their young, the Murklings formed colonies of their own. \
	Though hardened by the violent depths, they remain volatile and naive, struggling to understand a surface world that often sees them as monsters. \
	True to their nature, Murklings rapidly adapt to their surroundings, their forms shifting to match the lands they inhabit. \
	Yet this adaptability carries a curse: their bodies absorb more than shape. \
	Dusts, spirits, and smoke can alter them beyond recovery - breeding a severe dependence, \
	having consumed enough for their bodies to recreate and secrete the very substance that sustains them. \
	Caught now in the struggles of surface faiths and kingdoms, Murklings search for purpose beyond their primordial mothers. \
	Some turn to gods as they are susceptible to faith to fill the gaps their spawning pools left, and others reject them entirely. \
	Yet all carry the memory of the deep: the silent, all-encompassing love and will from which they were born."
	blood_color = "#00FFFF" //Defaults to blue, but we recolor this later to match the slime person's body color.
	origin_default = /datum/virtue/origin/racial/underdark
	base_name = "Ooze"
	origin = "Underdark"
	default_color = "79F299"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,MUTCOLORS)
	restricted_virtues = list(/datum/virtue/utility/feral_appetite, /datum/virtue/utility/noble)
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
	race_bonus = list(STAT_CONSTITUTION = 1, STAT_INTELLIGENCE = 1)
	inherent_traits = list(
						TRAIT_NASTY_EATER,
						TRAIT_EASYDISMEMBER,
						TRAIT_REGROW_LIMBS,
						TRAIT_ZOMBIE_IMMUNE,
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
		/datum/customizer/organ/snout/anthro/slime,
		/datum/customizer/organ/tail/slime,
		/datum/customizer/organ/ears/slime,
		/datum/customizer/organ/wings/slime,
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
	
	mechanics_explanations = list("Have no bones to break. However, upon suffering a severe blunt wound, or when a limb would experience a bone fracture, the limb melts. Lost limbs similarly melt off.",
		"Can regenerate lost limbs by sleeping, at a great cost to their bodily nutrition.",
		"Have uniquely colored blood that matches the color of their bodies.")

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

//Set slime blood color to match body color.
/datum/species/ooze/on_species_gain(mob/living/carbon/C, datum/species/old_species, datum/preferences/pref_load)
	. = ..()
	blood_color = C.dna.features["mcolor"]
	blood_color = "#[blood_color]"

/datum/species/ooze/random_name(gender,unique,lastname)

	var/randname
	if(unique)
		if(gender == MALE)
			for(var/i in 1 to 10)
				randname = pick( world.file2list("strings/rt/names/other/oozem.txt") )
				if(!findname(randname))
					break
		if(gender == FEMALE)
			for(var/i in 1 to 10)
				randname = pick( world.file2list("strings/rt/names/other/oozef.txt") )
				if(!findname(randname))
					break
	else
		if(gender == MALE)
			randname = pick( world.file2list("strings/rt/names/other/oozem.txt") )
		if(gender == FEMALE)
			randname = pick( world.file2list("strings/rt/names/other/oozef.txt") )
	return randname

/datum/species/ooze/random_surname()
	return
