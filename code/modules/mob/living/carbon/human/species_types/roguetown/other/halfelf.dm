/mob/living/carbon/human/species/human/halfelf
	race = /datum/species/human/halfelf

/datum/species/human/halfelf
	name = "Half-Elf"
	id = "helf"
	desc = "<b>Half Elf</b><br>\
	The child of an Elf and Humen, Half-Elves are generally frowned \
	upon by the more conservatively minded. However, as racial tensions lower, \
	the rate of Half-Elf births has continues to increase. So common has it become that some scholars \
	worry that someday it may be impossible to distinguish the Humens and Elves from one another. \
	From physical to cultural characteristics, Half-Elves are an incredibly diverse people, \
	thanks in no small part to the incredibly varied nature of their Humen halves. Indeed, no other race \
	embodies the term \"melting pot\" quite like the Half-Elves. Due to their half-breed nature, their physical \
	characteristics can be either more Elvish or more Humen, depending on which of their parents' genes \
	are more predominant. In terms of cultural identity, a Half-Elf will typically choose to lean more \
	towards either their Humen or Elvish heritages.<br>\
	(+1 Constitution, +1 Perception)" 

	skin_tone_wording = "Identity"
	max_age = 250

	default_color = "FFFFFF"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,STUBBLE,OLDGREY)
	inherent_traits = list(TRAIT_NOMOBSWAP)
	default_features = MANDATORY_FEATURE_LIST
	use_skintones = TRUE
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
		OFFSET_FACE_F = list(0,-1), OFFSET_BELT_F = list(0,-1), OFFSET_BACK_F = list(0,-1), \
		OFFSET_NECK_F = list(0,-1), OFFSET_MOUTH_F = list(0,-1), OFFSET_PANTS_F = list(0,0), \
		OFFSET_SHIRT_F = list(0,0), OFFSET_ARMOR_F = list(0,0), OFFSET_UNDIES_F = list(0,-1), \
		)
	race_bonus = list(STAT_PERCEPTION = 1, STAT_CONSTITUTION = 1)
	enflamed_icon = "widefire"
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/halfelf,
		ORGAN_SLOT_EARS = /obj/item/organ/ears/elf,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		)
	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/organ/ears/elf,
		/datum/customizer/bodypart_feature/hair/head/humanoid,
		/datum/customizer/bodypart_feature/hair/facial/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/bodypart_feature/underwear,
		/datum/customizer/bodypart_feature/legwear,
		/datum/customizer/organ/testicles/anthro,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/human,
		/datum/customizer/organ/vagina/human_anthro,
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
		/datum/language/elvish
	)

/datum/species/human/halfelf/get_skin_list()
	return list(
		"Timber-Gronn" = SKIN_COLOR_TIMBER_GRONN,
		"Giza-Azure" = SKIN_COLOR_GIZA_AZURE,
		"Walnut-Stine" = SKIN_COLOR_WALNUT_STINE,
		"Etrustcan-Dandelion" = SKIN_COLOR_ETRUSTCAN_DANDELION,
		"Naledi-Born" = SKIN_COLOR_NALEDI_BORN,
		"Naledi-Southerner" = SKIN_COLOR_NALEDI_LIGHT,
		"Kaze-Lotus" = SKIN_COLOR_KAZE_LOTUS,
		"Grenzel-Azuria" = SKIN_COLOR_GRENZEL_WOODS,
		"Etrusca-Lirvas" = SKIN_COLOR_ETRUSCA_LIRVAS,
		"Free Roamers" = SKIN_COLOR_FREE_FOLK,
		"Avar Borne"	= SKIN_COLOR_AVAR_BORNE,
		"Shalvine Roamer" = SKIN_COLOR_SHALVINE_AZURE,
		"Lalve-Steppes" = SKIN_COLOR_LALVE_NALEDI,
		"Naledi-Otava" = SKIN_COLOR_NALEDI_OTAVA,
		"Grezel-Avar" = SKIN_COLOR_GRENZEL_AVAR,
		"Hammer-Gronn" = SKIN_COLOR_HAMMER_GRONN,
		"Commorah-kin" = SKIN_COLOR_COMMORAH,
		"Gloomhaven-kin" = SKIN_COLOR_GLOOMHAVEN,
		"Darkpila-kin" = SKIN_COLOR_DARKPILA,
		"Sshanntynlan-kin" = SKIN_COLOR_SSHANNTYNLAN,
		"Llurth Dreir-kin" = SKIN_COLOR_LLURTH_DREIR,
		"Tafravma-kin" = SKIN_COLOR_TAFRAVMA,
		"Yuethindrynn-kin" = SKIN_COLOR_YUETHINDRYNN
	)

/datum/species/human/halfelf/get_hairc_list()
	return sortList(list(
	"black - oil" = "181a1d",
	"black - cave" = "201616",
	"black - rogue" = "2b201b",
	"black - midnight" = "1d1b2b",

	"brown - mud" = "362e25",
	"brown - oats" = "584a3b",
	"brown - grain" = "58433b",
	"brown - soil" = "48322a",

	"red - berry" = "48322a",
	"red - wine" = "82534c",
	"red - sunset" = "82462b",
	"red - blood" = "822b2b",

	"blond - pale" = "9d8d6e",
	"blond - dirty" = "88754f",
	"blond - drywheat" = "8f8766",
	"blond - strawberry" = "977033"

	))

/datum/species/human/halfelf/random_name(gender,unique,lastname)
	var/randname
	if(unique)
		if(gender == MALE)
			for(var/i in 1 to 10)
				randname = pick( world.file2list("strings/rt/names/elf/elfwm.txt") )
				if(!findname(randname))
					break
		if(gender == FEMALE)
			for(var/i in 1 to 10)
				randname = pick( world.file2list("strings/rt/names/elf/elfwf.txt") )
				if(!findname(randname))
					break
	else
		if(gender == MALE)
			randname = pick( world.file2list("strings/rt/names/elf/elfwm.txt") )
		if(gender == FEMALE)
			randname = pick( world.file2list("strings/rt/names/elf/elfwf.txt") )
	randname += " Halfelven"
	return randname

/datum/species/human/halfelf/random_surname()
	return ""

