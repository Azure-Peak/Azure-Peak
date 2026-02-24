/mob/living/carbon/human/species/tieberian
	race = /datum/species/tieberian

/datum/species/tieberian
	name = "Tiefling"
	id = "tiefling"
	origin_default = /datum/virtue/origin/etrusca
	origin = "Etrusca"
	base_name = "Godtouched"
	is_subrace = TRUE
	desc = "<b>Tiefling</b><br>\
	The offspring of demons with mortal races, a consequence of demonic incursions into the mortal realm and dark pacts. \
	Their origins dating back to the demonic invasion of Archdevil Vheslyn who pillaged and ravaged the mortal lands and its people before being stopped by Psydon. \
	These offspring of demon and mortal races came to be known as 'Tieflings', largely despised by most people for centuries for their unnatural origins and appearances. \
	It was only recently that they became more tolerated, even if the Church still watches them with a weary eye. \
	When a Tiefling has offspring, no matter the race of their partner, the child would always be a pureblooded Tiefling. \
	The taint of their very being going back generations, and no amount of cleansing can be rid of it. \
	As over a millennium a simple handful of Tieflings have created extended bloodlines linking back to their infernal progenitors. Some Tieflings embrace their demonic origin, while other shun it. \
	No matter if they embrace their demonic ancestors or not, Tieflings have formed an importance upon their bloodline and family due to often being shunned and hunted through out time in which only those of their blood and kin they could truly trust. <br>\
	<span style='color: #6a8cb7;text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'><b>+1 CON | +1 INT </b></span><br>"

	skin_tone_wording = "Progenitor"
	use_skin_tone_wording_for_examine = FALSE

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
		OFFSET_FACE_F = list(0,-1), OFFSET_BELT_F = list(0,0), OFFSET_BACK_F = list(0,-1), \
		OFFSET_NECK_F = list(0,-1), OFFSET_MOUTH_F = list(0,-1), OFFSET_PANTS_F = list(0,0), \
		OFFSET_SHIRT_F = list(0,0), OFFSET_ARMOR_F = list(0,0), OFFSET_UNDIES_F = list(0,-1), \
		)
	race_bonus = list(STAT_INTELLIGENCE = 1, STAT_CONSTITUTION = 1)
	enflamed_icon = "widefire"
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_EARS = /obj/item/organ/ears/tiefling,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		//ORGAN_SLOT_TAIL = /obj/item/organ/tail/tiefling,
		//ORGAN_SLOT_HORNS = /obj/item/organ/horns/tiefling, We don't need these. No duplicate horns!
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
		/datum/customizer/bodypart_feature/legwear,
		/datum/customizer/bodypart_feature/piercing,
		/datum/customizer/organ/horns/anthro,
		/datum/customizer/organ/tail/tiefling,
		/datum/customizer/organ/testicles/anthro,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/human,
		/datum/customizer/organ/vagina/human_anthro,
		/datum/customizer/organ/ears/tiefling,
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
		/datum/body_marking/bangs,
		/datum/body_marking/bun,
	)
	languages = list(
		/datum/language/common,
		/datum/language/hellspeak,
	)
	stress_examine = TRUE
	stress_desc = span_red("Helldweller... better stay away.")

/datum/species/tieberian/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/species/tieberian/after_creation(mob/living/carbon/C)
	..()
	to_chat(C, "<span class='info'>I can speak Infernal with ,h before my speech.</span>")

/datum/species/tieberian/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_SAY)

/datum/species/tieberian/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/tieberian/get_skin_list()
	return list(
		"Jehoel" = SKIN_COLOR_JEHOEL,
		"Urvix" = SKIN_COLOR_URVIX,
		"Sarvyra" = SKIN_COLOR_SARVYRA,
		"Vheslyn" = SKIN_COLOR_VHESLYN,
		"Arlenneth" = SKIN_COLOR_ARLENNETH,
		"Nessyss" = SKIN_COLOR_NESSYSS,
		"Helixia" = SKIN_COLOR_HELIXIA,
		"Nymsea" = SKIN_COLOR_NYMSEA,
		"Vodyanev" = SKIN_COLOR_ABYSS,
		"Calvus" = SKIN_COLOR_CALVUS,
		"Voibion" = SKIN_COLOR_VOIBION,
		"Chyerno" = SKIN_COLOR_CHYERNO,
		"Drema"	= SKIN_COLOR_DREMA,
		"Chir"	= SKIN_COLOR_CHIR,
		"Vesyl"	= SKIN_COLOR_VESYL,
		"Krosec" = SKIN_COLOR_KROSEC,
		"Asza" = SKIN_COLOR_ASZA,
		"Krizzsha" = SKIN_COLOR_KRIZZSHA,
		"Tosiz" = SKIN_COLOR_TOSIZ,
		"Velothel" = SKIN_COLOR_VELOTHEL,
		"Xir" = SKIN_COLOR_XIR,
		"Esse" = SKIN_COLOR_ESSE
	)

/datum/species/tieberian/get_hairc_list()
	return sortList(list(
	"black - oil" = "181a1d",
	"black - cave" = "201616",
	"black - rogue" = "2b201b",
	"black - midnight" = "1d1b2b"
	))

/datum/species/tieberian/random_name(gender,unique,lastname)

	var/randname
	if(unique)
		if(gender == MALE)
			for(var/i in 1 to 10)
				randname = pick( world.file2list("strings/rt/names/other/tiefm.txt") )
				if(!findname(randname))
					break
		if(gender == FEMALE)
			for(var/i in 1 to 10)
				randname = pick( world.file2list("strings/rt/names/other/tieff.txt") )
				if(!findname(randname))
					break
	else
		if(gender == MALE)
			randname = pick( world.file2list("strings/rt/names/other/tiefm.txt") )
		if(gender == FEMALE)
			randname = pick( world.file2list("strings/rt/names/other/tieff.txt") )
	return randname

/datum/species/tieberian/random_surname()
	return " [pick(world.file2list("strings/rt/names/other/tieflast.txt"))]"
