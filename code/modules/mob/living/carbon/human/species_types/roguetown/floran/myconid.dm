/mob/living/carbon/human/species/floran/myconid
	race = /datum/species/floran/myconid

/datum/species/floran/myconid
	name = "Myconid"
	id = "myconid"
	is_subrace = TRUE
	custom_clothes = TRUE
	clothes_id = "dwarf"
	race_bonus = list()
	inherent_traits = list(TRAIT_PERMAMUTE, TRAIT_BONELESS, TRAIT_EASYDISMEMBER, TRAIT_REGROW_LIMBS, TRAIT_ZOMBIE_IMMUNE, TRAIT_NOBREATH, TRAIT_NOHUNGER, TRAIT_ALCOHOL_INTOLERANCE)
	limbs_icon_m = 'icons/mob/species/myconids_male.dmi'
	limbs_icon_f = 'icons/mob/species/myconides_female.dmi'
	allowed_body_builds = null
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain/myconid,
		ORGAN_SLOT_HEART = /obj/item/organ/heart/myconid,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs/myconid,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/myconid,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/myconid,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver/myconid,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach/myconid,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_GUTS = /obj/item/organ/guts/myconid,
		)
	offset_features = list(
		OFFSET_ID = list(0,0), OFFSET_GLOVES = list(0,0), OFFSET_WRISTS = list(0,0),\
		OFFSET_CLOAK = list(0,0), OFFSET_FACEMASK = list(0,-4), OFFSET_HEAD = list(0,-4), \
		OFFSET_FACE = list(0,-4), OFFSET_BELT = list(0,-5), OFFSET_BACK = list(0,-4), \
		OFFSET_NECK = list(0,-4), OFFSET_MOUTH = list(0,-4), OFFSET_PANTS = list(0,0), \
		OFFSET_SHIRT = list(0,0), OFFSET_ARMOR = list(0,0), OFFSET_HANDS = list(0,-3), \
		OFFSET_UNDIES = list(0,-4), \
		)
	species_traits = list(EYECOLOR,LIPS,NOBLOOD)
	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/myco_hat,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/bodypart_feature/underwear,
		/datum/customizer/bodypart_feature/legwear,
		/datum/customizer/bodypart_feature/piercing,
		/datum/customizer/organ/testicles/anthro,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/human,
		/datum/customizer/organ/vagina/human_anthro,
		/datum/customizer/bodypart_feature/pubes,
		/datum/customizer/bodypart_feature/pits,
		)
	desc_title = "Myconid"
	desc = "Sneaky denizens of the Underdark, the myconids have remained hidden in caves for many eons, avoided by most and rarely communicating with outsiders. Only recently have they become much more active, and, due to a growing population, they’ve started to wander outside, meeting both cave dwellers and surface people alike. Being able to communicate only by telepathy, their first contacts were filled with unease and fear, but now many myconids have proven themselves trustworthy and wise, albeit strange."
	mechanics_explanations = list("They never breathe and have no blood to spill: cuts open without bleeding.",
		"Use telepathy ability for speaking instead of normal",
		"A myconid at rest can draw lost limbs forth anew from its body. They eat nothing, so each regrowth instead draws on their vitality for a time, leaving them slower of body and will until it passes.",
		"The tough cap grown atop their skull refuses to be parted from them, and it alone shelters a myconid's head - coifs, hoods and helmets lend them no protection. Can be restored by *meditate",
		"Alcohol is poison to their fungal flesh, lethal in large quantities")

/datum/species/floran/myconid/check_roundstart_eligible()
	return TRUE

/datum/species/floran/myconid/get_skin_list()
	return list("Myconid" = "FFFFFF")

/datum/species/floran/myconid/on_species_gain(mob/living/carbon/C, datum/species/old_species, datum/preferences/pref_load)
	. = ..()
	if(!C.HasSpell(/obj/effect/proc_holder/spell/targeted/myconid_telepathy))
		C.AddSpell(new /obj/effect/proc_holder/spell/targeted/myconid_telepathy)
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		if(!H.get_item_by_slot(SLOT_HEAD))
			H.equip_to_slot_if_possible(new /obj/item/clothing/head/roguetown/helmet/leather/advanced/mycohelm, SLOT_HEAD, qdel_on_fail = TRUE, disable_warning = TRUE, bypass_equip_delay_self = TRUE)

/datum/species/floran/myconid/after_equip_job(datum/job/J, mob/living/carbon/human/H)
	. = ..()
	if(!H.get_item_by_slot(SLOT_HEAD))
		H.equip_to_slot_if_possible(new /obj/item/clothing/head/roguetown/helmet/leather/advanced/mycohelm, SLOT_HEAD, qdel_on_fail = TRUE, disable_warning = TRUE, bypass_equip_delay_self = TRUE)

/datum/species/floran/myconid/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	C.RemoveSpell(/obj/effect/proc_holder/spell/targeted/myconid_telepathy)
	var/obj/item/clothing/head/roguetown/helmet/leather/advanced/mycohelm/helm = C.get_item_by_slot(SLOT_HEAD)
	if(helm)
		REMOVE_TRAIT(helm, TRAIT_NODROP, CURSED_ITEM_TRAIT)
		C.dropItemToGround(helm)
	. = ..()
