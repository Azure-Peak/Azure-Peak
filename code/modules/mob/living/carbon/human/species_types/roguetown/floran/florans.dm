/mob/living/carbon/human/species/floran/florans
	race = /datum/species/floran/florans

/datum/species/floran/florans
	name = "Floran"
	id = "florans"
	is_subrace = TRUE
	desc_title = "Floran"
	desc = "Bearing a strong resemblance to dangerous maneaters, Florans are often frowned upon and are not welcome in many places. Most of them growing up in packs and tribes further reinforce prejudices, becoming hostile to outsiders and performing raids on nearby settlements to sustain themselves. Those who end up raised by others or exceptionally curious Florans can be a lot more friendly and cooperative, though they must fight prejudice to secure their place in Psydonia."
	limbs_icon_m = 'icons/mob/species/floran_male.dmi'
	limbs_icon_f = 'icons/mob/species/floran_female.dmi'
	allowed_body_builds = null
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain/floran,
		ORGAN_SLOT_HEART = /obj/item/organ/heart/floran,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs/floran,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/floran,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/floran,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver/floran,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach/floran,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_GUTS = /obj/item/organ/guts/floran,
		)
	// Private parts stay this bark-brown, whatever the customizer says.
	forced_genital_color = "#525041"
	offset_features = OFFSET_FEATURES_SLIM_REFERENCE
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
		/datum/customizer/bodypart_feature/pubes,
		/datum/customizer/bodypart_feature/pits,
		/datum/customizer/organ/horns/petals,
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
		/datum/body_marking/waist,
		/datum/body_marking/womb_tattoo,
		/datum/body_marking/butterfly,
		/datum/body_marking/carni/overgrowth,
		)

/datum/species/floran/florans/check_roundstart_eligible()
	return TRUE

// The bodies carry their own painted colours, so only the untinted white is offered.
/datum/species/floran/florans/get_skin_list()
	return list("Floran" = "FFFFFF")
