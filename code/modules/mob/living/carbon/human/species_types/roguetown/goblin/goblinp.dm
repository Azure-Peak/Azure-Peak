/mob/living/carbon/human/species/goblinp
	race = /datum/species/goblinp

/datum/species/goblinp
	name = "Goblin"
	id = "goblinp"
	desc = "<b>Goblin</b><br>\
	Goblins are a short race of humanoids with large ears and typically green skin. \
	Supposedly formed from the blood spilled by the savage War God Graggar’s conquest, \
	the prehistory of the Goblin race is spent in mindless servitude to the Conqueror God. \
	With Graggar’s defeat, Goblins were at last able to exercise free will, \
	with those farthest from the mindless hordes of fodder creating various tribes and villages across the face of Psydonia \
	while keeping themselves mostly isolated due to the persecution from other mortal races. \
	Only recently in the past few centuries have sapient Goblins been moving out of their isolated villages and tribes \
	and seeking their future in civilised society, \
	despite the discrimination and persecution from Church, State, and People almost universally across Psydonia. \
	Having been formed to be fodder for the War God’s armies, Goblins were blessed with extremely rapid adaptability, \
	with each generation of Goblins being more adapted to its environment than the last. \
	Most goblins appear as green skinned, but many tribes have adapted to different environments, \
	resulting in varied colours from gray to blue to bronze and even red - \
	though this often comes with other environmental adaptations befitting the home of such a tribe. \
	Goblins are also known to have an instinctual form of tribalism, \
	wherein a large group of Goblins in an area seem to universally act in more primitive ways, \
	often resulting in mischief - and sometimes violence.<br>\
	(+1 Speed)" 
	species_traits = list(EYECOLOR,LIPS,STUBBLE)
	possible_ages = ALL_AGES_LIST
	use_skintones = TRUE
	skin_tone_wording = "Skin Color"
	limbs_icon_m = 'icons/mob/species/anthro_small_male.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fd.dmi'
	dam_icon = 'icons/roguetown/mob/bodies/dam/dam_male.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	soundpack_m = /datum/voicepack/male/goblin
	soundpack_f = /datum/voicepack/female/goblin
	custom_clothes = TRUE
	use_f = TRUE
	clothes_id = "dwarf"
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		//ORGAN_SLOT_TESTICLES = /obj/item/organ/testicles,
		//ORGAN_SLOT_PENIS = /obj/item/organ/penis,
		//ORGAN_SLOT_BREASTS = /obj/item/organ/breasts,
		//ORGAN_SLOT_VAGINA = /obj/item/organ/vagina,
		)
	offset_features = list(
		OFFSET_ID = list(0,-4), OFFSET_GLOVES = list(0,-4), OFFSET_WRISTS = list(0,-4),\
		OFFSET_CLOAK = list(0,0), OFFSET_FACEMASK = list(0,-5), OFFSET_HEAD = list(0,-4), \
		OFFSET_FACE = list(0,-5), OFFSET_BELT = list(0,-4), OFFSET_BACK = list(0,-4), \
		OFFSET_NECK = list(0,-4), OFFSET_MOUTH = list(0,-4), OFFSET_PANTS = list(0,0), \
		OFFSET_SHIRT = list(0,0), OFFSET_ARMOR = list(0,0), OFFSET_HANDS = list(0,-3), OFFSET_UNDIES = list(0,-4), \
		OFFSET_ID_F = list(0,-5), OFFSET_GLOVES_F = list(0,-4), OFFSET_WRISTS_F = list(0,-4), OFFSET_HANDS_F = list(0,-4), \
		OFFSET_CLOAK_F = list(0,0), OFFSET_FACEMASK_F = list(0,-5), OFFSET_HEAD_F = list(0,-5), \
		OFFSET_FACE_F = list(0,-5), OFFSET_BELT_F = list(0,-4), OFFSET_BACK_F = list(0,-5), \
		OFFSET_NECK_F = list(0,-5), OFFSET_MOUTH_F = list(0,-5), OFFSET_PANTS_F = list(0,0), \
		OFFSET_SHIRT_F = list(0,0), OFFSET_ARMOR_F = list(0,0), OFFSET_UNDIES_F = list(0,-4), \
		)
	race_bonus = list(STAT_SPEED = 1)
	enflamed_icon = "widefire"
	attack_verb = "slash"
	attack_sound = 'sound/blank.ogg'
	miss_sound = 'sound/blank.ogg'
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
		/datum/customizer/organ/vagina/human_anthro,
		/datum/customizer/organ/ears/goblin,
		/datum/customizer/organ/horns/tusks,
		)
	languages = list(
		/datum/language/common,
		/datum/language/orcish
	)
	stress_examine = TRUE
	stress_desc = span_red("Horrid little goblin...")
	descriptor_choices = list(
		/datum/descriptor_choice/trait,
		/datum/descriptor_choice/height,
		/datum/descriptor_choice/body,
		/datum/descriptor_choice/stature,
		/datum/descriptor_choice/face,
		/datum/descriptor_choice/face_exp,
		/datum/descriptor_choice/skin_all,
		/datum/descriptor_choice/voice,
		/datum/descriptor_choice/prominent_one_wild,
		/datum/descriptor_choice/prominent_two_wild,
		/datum/descriptor_choice/prominent_three_wild,
		/datum/descriptor_choice/prominent_four_wild,
	)

/datum/species/goblinp/check_roundstart_eligible()
	return TRUE

/datum/species/goblinp/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/goblinp/get_skin_list()
	return list(
		"Ochre" = SKIN_COLOR_OCHRE,
		"Meadow" = SKIN_COLOR_MEADOW,
		"Olive" = SKIN_COLOR_OLIVE,
		"Green" = SKIN_COLOR_GREEN,
		"Moss" = SKIN_COLOR_MOSS,
		"Taiga" = SKIN_COLOR_TAIGA,
		"Bronze" = SKIN_COLOR_BRONZE,
		"Red" = SKIN_COLOR_RED,
		"Frost" = SKIN_COLOR_FROST,
		"Abyss" = SKIN_COLOR_ABYSS,
		"Teal" = SKIN_COLOR_TEAL,
		"Hadal" = SKIN_COLOR_HADAL
	)

/datum/species/goblinp/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	C.cmode_music = 'sound/music/combat_gronn.ogg'
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/species/goblinp/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_SAY)
