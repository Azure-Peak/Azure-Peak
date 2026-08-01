// Lamia — ported from Emerald Summit, rebuilt on Valmorian Isle's taur bodypart pipeline.
//
// ES runs its own /obj/item/bodypart/lamian_tail system; here the lower body is the existing
// /obj/item/bodypart/taur/lamia, which already has the clip masks wired into update_icons.dm and
// the boots/pants gate in species.dm. mandatory_taur_type keeps the tail from ever being swapped
// for legs in setup. Venom comes from the bodypart itself — see modular/taur_abilities.

/mob/living/carbon/human/species/lamia
	race = /datum/species/lamia

/datum/species/lamia
	name = "Lamia"
	id = "lamia"
	is_subrace = TRUE
	origin_default = /datum/virtue/origin/etrusca
	origin = "Etrusca"
	base_name = "Taur"
	sub_name = "Lamia"
	desc_title = "Lamia"
	desc = "<b>Lamia</b><br>\
	The monstrous spawn of Abyssor, snake and humen conjoined together, the deepkin and merfolk. \
	Sirens, mermaids, nagas and many others fall into 'lamia' categorization. While one could consider them to be of Dendor's, he had no hand in their creation. \
	Lamia are widespread in the southern coastal regions, where their tribes have settled in aeons ago, much of their written and oral history is filled with accounts \
	of grand raids on coastal regions, for they have been terrorizing any race that has dared to settle near their waters. For this, they are widely shunned by the other races, \
	with the exception of Axians and some coast-dwelling Zardmen with whom they share their natural heartlands. Many a sailor has met their end at the claws of Lamias. \
	Yet... not all of them have stayed in the depths of the abyss, for some of the clans have moved far away from the coastal regions, settling in swamps, forests and even deserts, having spread themselves far and wide aeons ago."
	//VALMORIAN: no stat or trait lines in desc - set_new_race() already prints race_bonus and
	//inherent_traits underneath it. Venom and the scaled hide come from the taur bodypart rather
	//than inherent_traits, so the auto-printer never mentions them and they're listed here.
	mechanics_explanations = list("Their tail cannot wear boots or pants.",
		"Chewing on prey with their fangs injects venom.",
		"The scales of their tail act as natural armour, and mend themselves over time.",
		"They sweep with their tail where others would kick, throwing a target twice as far.")
	default_color = "FFFFFF"
	species_traits = list(EYECOLOR, LIPS, HAIR, OLDGREY, MUTCOLORS)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	possible_ages = ALL_AGES_LIST
	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mt.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fm.dmi'
	dam_icon = 'icons/roguetown/mob/bodies/dam/dam_male.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	// Boots and pants are blocked dynamically by the is_taur gate in species.dm's can_equip.
	no_equip = list()
	soundpack_m = /datum/voicepack/male
	soundpack_f = /datum/voicepack/female
	offset_features = list(
		OFFSET_ID = list(0,1), OFFSET_GLOVES = list(0,1), OFFSET_WRISTS = list(0,1),\
		OFFSET_CLOAK = list(0,1), OFFSET_FACEMASK = list(0,1), OFFSET_HEAD = list(0,1), \
		OFFSET_FACE = list(0,1), OFFSET_BELT = list(0,1), OFFSET_BACK = list(0,1), \
		OFFSET_NECK = list(0,1), OFFSET_MOUTH = list(0,1), OFFSET_PANTS = list(0,0), \
		OFFSET_SHIRT = list(0,1), OFFSET_ARMOR = list(0,1), OFFSET_HANDS = list(0,1), OFFSET_UNDIES = list(0,1), \
		OFFSET_ID_F = list(0,-1), OFFSET_GLOVES_F = list(0,0), OFFSET_WRISTS_F = list(0,0), OFFSET_HANDS_F = list(0,0), \
		OFFSET_CLOAK_F = list(0,0), OFFSET_FACEMASK_F = list(0,-1), OFFSET_HEAD_F = list(0,-1), \
		OFFSET_FACE_F = list(0,-1), OFFSET_BELT_F = list(0,0), OFFSET_BACK_F = list(0,-1), \
		OFFSET_NECK_F = list(0,-1), OFFSET_MOUTH_F = list(0,-1), OFFSET_PANTS_F = list(0,0), \
		OFFSET_SHIRT_F = list(0,0), OFFSET_ARMOR_F = list(0,0), OFFSET_UNDIES_F = list(0,-1), \
		)
	inherent_traits = list(TRAIT_LONGSTRIDER, TRAIT_WILD_EATER)
	disliked_food = NONE
	race_bonus = list(STAT_STRENGTH = 1, STAT_SPEED = -1)
	enflamed_icon = "widefire"
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/wild_tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
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
		/datum/customizer/organ/tail_feature/anthro,
		/datum/customizer/organ/snout/lizard,
		/datum/customizer/organ/ears/lizard,
		/datum/customizer/organ/frills/anthro,
		/datum/customizer/organ/horns/anthro,
		/datum/customizer/organ/wings/anthro,
		/datum/customizer/organ/penis/lizard,
		/datum/customizer/organ/testicles/anthro,
		/datum/customizer/organ/breasts/human,
		/datum/customizer/organ/vagina/anthro,
		)
	body_marking_sets = list(
		/datum/body_marking_set/none,
		/datum/body_marking_set/belly,
		/datum/body_marking_set/bellysocks,
		/datum/body_marking_set/tiger,
		/datum/body_marking_set/tiger_dark,
	)
	languages = list(
		/datum/language/common,
		/datum/language/abyssal,
	)
	body_markings = list(
		/datum/body_marking/flushed_cheeks,
		/datum/body_marking/eyeliner,
		/datum/body_marking/plain,
		/datum/body_marking/tiger,
		/datum/body_marking/tiger/dark,
		/datum/body_marking/sock,
		/datum/body_marking/socklonger,
		/datum/body_marking/tips,
		/datum/body_marking/bellyscale,
		/datum/body_marking/bellyscaleslim,
		/datum/body_marking/bellyscalesmooth,
		/datum/body_marking/bellyscaleslimsmooth,
		/datum/body_marking/buttscale,
		/datum/body_marking/belly,
		/datum/body_marking/bellyslim,
		/datum/body_marking/butt,
		/datum/body_marking/tie,
		/datum/body_marking/tiesmall,
		/datum/body_marking/backspots,
		/datum/body_marking/front,
		/datum/body_marking/drake_eyes,
		/datum/body_marking/tonage,
		/datum/body_marking/spotted,
		/datum/body_marking/nose,
		/datum/body_marking/harlequin,
		/datum/body_marking/harlequinreversed,
		/datum/body_marking/bangs,
		/datum/body_marking/bun,
	)
	descriptor_choices = list(
		/datum/descriptor_choice/height,
		/datum/descriptor_choice/body,
		/datum/descriptor_choice/stature,
		/datum/descriptor_choice/face,
		/datum/descriptor_choice/face_exp,
		/datum/descriptor_choice/skin,
		/datum/descriptor_choice/voice,
		/datum/descriptor_choice/prominent_one_wild,
		/datum/descriptor_choice/prominent_two_wild,
		/datum/descriptor_choice/prominent_three_wild,
		/datum/descriptor_choice/prominent_four_wild,
	)

	allowed_taur_types = list(
		/obj/item/bodypart/taur/lamia,
	)
	mandatory_taur_type = /obj/item/bodypart/taur/lamia

/datum/species/lamia/check_roundstart_eligible()
	return TRUE

/datum/species/lamia/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/lamia/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	// Only if they haven't got one already. copy_to() Taurizes with the player's chosen colour, and
	// this call uses the default, so an unconditional call here disagrees on colour, fails Taurize's
	// same-part short circuit, and drops+reattaches the lower body every time the species is applied.
	if(!C.get_taur_tail())
		C.Taurize(mandatory_taur_type)

/datum/species/lamia/on_species_loss(mob/living/carbon/C)
	. = ..()
	C.ensure_not_taur()

/datum/species/lamia/spec_fully_heal(mob/living/carbon/human/H)
	// Restore the tail if it's somehow gone, but don't rebuild an existing one - that would reset
	// the player's chosen tail colour to the default on every heal.
	if(!H.get_taur_tail())
		H.Taurize(mandatory_taur_type)

/datum/species/lamia/random_name(gender, unique, lastname)
	if(gender == MALE)
		return pick(world.file2list("strings/names/roguetown/lamiamale.txt"))
	return pick(world.file2list("strings/names/roguetown/lamiafemale.txt"))

/datum/species/lamia/get_random_features()
	var/list/returned = MANDATORY_FEATURE_LIST
	var/list/palette = pick(
		list("FFFFFF", "333333", "333333"),
		list("FFFFDD", "DD6611", "AA5522"),
		list("DD6611", "FFFFFF", "DD6611"),
		list("CCCCCC", "FFFFFF", "FFFFFF"),
		list("AA5522", "CC8833", "FFFFFF"),
		list("FFFFDD", "FFEECC", "FFDDBB"),
	)
	returned["mcolor"] = palette[1]
	returned["mcolor2"] = palette[2]
	returned["mcolor3"] = palette[3]
	return returned
