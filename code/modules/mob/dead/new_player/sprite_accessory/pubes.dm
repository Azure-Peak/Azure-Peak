// Original sprites by Gug1234
/datum/sprite_accessory/proc/small_race_aware_gender_feature_adjust(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner, masc_key, fem_key)
	var/mob/living/carbon/human/humie = owner
	if(istype(humie) && humie.dna?.species?.clothes_id == "dwarf")
		return
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, masc_key, fem_key)

/datum/sprite_accessory/pubes
	abstract_type = /datum/sprite_accessory/pubes
	icon = 'icons/mob/sprite_accessory/genitals/pubes.dmi'
	color_key_name = "Color"
	color_key_defaults = list(KEY_HAIR_COLOR)
	layer = BODY_ADJ_LAYER + 0.5

/datum/sprite_accessory/pubes/proc/get_pubes_suffix(mob/living/carbon/owner)
	var/datum/species/species = owner?.dna?.species
	if(species?.clothes_id == "dwarf")
		return owner.gender == FEMALE ? "d_f" : "d_m"
	// The elven body (met.dmi/mem.dmi) only exists on the slim family of builds - an elf on the
	// bulky build shares mt.dmi with every other species and should use the generic art like they do.
	if(is_species(owner, /datum/species/elf) && owner.gender == MALE && !owner.is_bulky_body())
		return "e_m"
	if(is_species(owner, /datum/species/halforc))
		return owner.gender == FEMALE ? "h_ft" : "h_mt"
	return owner.gender == FEMALE ? "h_f" : "h_m"

/datum/sprite_accessory/pubes/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return "[icon_state]_[get_pubes_suffix(owner)]"

/datum/sprite_accessory/pubes/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	small_race_aware_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_BELT, OFFSET_BELT_F)

/datum/sprite_accessory/pubes/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(owner.underwear)
		return FALSE
	return is_human_part_visible(owner, HIDEJUMPSUIT|HIDECROTCH)

/datum/sprite_accessory/pubes/hairy
	icon_state = "pubes_hairy"
	preview_states = list("pubes_hairy_h_m")
	name = "Hairy"

/datum/sprite_accessory/pubes/trim
	icon_state = "pubes_trim"
	preview_states = list("pubes_trim_h_m")
	name = "Trimmed"

/datum/sprite_accessory/pubes/strip
	icon_state = "pubes_strip"
	preview_states = list("pubes_strip_h_m")
	name = "Landing Strip"

/datum/sprite_accessory/pubes/heart
	icon_state = "pubes_heart"
	preview_states = list("pubes_heart_h_m")
	name = "Heart"

/datum/sprite_accessory/pubes/extreme
	icon_state = "pubes_extreme"
	preview_states = list("pubes_extreme_h_m")
	name = "La coupe à la Otavaise"

/datum/sprite_accessory/pubes/cross
	icon_state = "pubes_cross"
	preview_states = list("pubes_cross_h_m")
	name = "Psycross"


/datum/sprite_accessory/pits
	abstract_type = /datum/sprite_accessory/pits
	icon = 'icons/mob/sprite_accessory/genitals/pits.dmi'
	color_key_name = "Color"
	color_key_defaults = list(KEY_HAIR_COLOR)
	layer = BODY_ADJ_LAYER + 0.5

/datum/sprite_accessory/pits/proc/get_pits_suffix(mob/living/carbon/owner)
	var/datum/species/species = owner?.dna?.species
	if(species?.clothes_id == "dwarf")
		return owner.gender == FEMALE ? "d_f" : "d_m"
	// The elven body (met.dmi/mem.dmi) only exists on the slim family of builds - an elf on the
	// bulky build shares mt.dmi with every other species and should use the generic art like they do.
	if(is_species(owner, /datum/species/elf) && owner.gender == MALE && !owner.is_bulky_body())
		return "e_m"
	if(is_species(owner, /datum/species/halforc))
		return owner.gender == FEMALE ? "h_ft" : "h_mt"
	return owner.gender == FEMALE ? "h_f" : "h_m"

/datum/sprite_accessory/pits/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return "[icon_state]_[get_pits_suffix(owner)]"

/datum/sprite_accessory/pits/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	small_race_aware_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_ID, OFFSET_ID_F)

/datum/sprite_accessory/pits/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(owner.underwear && owner.underwear.covers_breasts)
		return FALSE
	return is_human_part_visible(owner, HIDEBOOB|HIDEJUMPSUIT)

/datum/sprite_accessory/pits/trim
	icon_state = "pits_trim"
	preview_states = list("pits_trim_h_m")
	name = "Trim"

/datum/sprite_accessory/pits/moderate
	icon_state = "pits"
	preview_states = list("pits_h_m")
	name = "Moderate"

/datum/sprite_accessory/pits/hairy
	icon_state = "pits_hairy"
	preview_states = list("pits_hairy_h_m")
	name = "Hairy"

// Excluded from this port: pits/extreme ("La coupe à la Otavaise") Psydonia is not ready
