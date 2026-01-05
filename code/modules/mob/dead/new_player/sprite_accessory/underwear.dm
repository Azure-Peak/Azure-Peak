/datum/sprite_accessory/underwear
	abstract_type = /datum/sprite_accessory/underwear
	icon = 'icons/mob/sprite_accessory/underwear.dmi'
	color_key_name = "Underwear"
	var/underwear_type
	///Whether this underwear includes a top (Because gender = FEMALE doesn't actually apply here.). Hides breasts, nothing more.
	var/hides_breasts = FALSE

/datum/sprite_accessory/underwear/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_UNDIES, OFFSET_UNDIES_F)

/datum/sprite_accessory/underwear/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(hides_breasts)
		if(is_human_part_visible(owner, HIDECROTCH) || is_human_part_visible(owner, HIDEBOOB))
			return TRUE	
	return is_human_part_visible(owner, HIDECROTCH)

/datum/sprite_accessory/underwear/briefs
	name = "Briefs"
	icon_state = "male_reg"
	underwear_type = /obj/item/undies

/datum/sprite_accessory/underwear/briefs/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(is_species(owner,/datum/species/dwarf))
		return "maledwarf_reg"
	if(owner.gender == FEMALE)
		return "maleelf_reg"
	return "male_reg"

/datum/sprite_accessory/underwear/bikini
	name = "Bikini"
	icon_state = "female_bikini"
	underwear_type = /obj/item/undies/bikini
	hides_breasts = TRUE

/datum/sprite_accessory/underwear/bikini/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(owner.getorganslot(ORGAN_SLOT_BREASTS))
		var/obj/item/organ/breasts/breasts = owner.getorganslot(ORGAN_SLOT_BREASTS)
		var/tag = "bikini_f"
		if(breasts.breast_size == 0)
			tag = tag + "_0"
		if(breasts.breast_size == 1)
			tag = tag + "_1"
		if(breasts.breast_size == 2)
			tag = tag + "_2"
		if(breasts.breast_size == 3)
			tag = tag + "_3"
		if(breasts.breast_size == 4)
			tag = tag + "_4"
		if(breasts.breast_size == 5)
			tag = tag + "_5"
		return tag
	else
		return "bikini_f_0"

/datum/sprite_accessory/underwear/panties
	name = "Panties"
	icon_state = "panties"
	underwear_type = /obj/item/undies/panties

/datum/sprite_accessory/underwear/leotard
	name = "Leotard"
	icon_state = "female_leotard"
	underwear_type = /obj/item/undies/leotard
	hides_breasts = TRUE

/datum/sprite_accessory/underwear/leotard/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(owner.getorganslot(ORGAN_SLOT_BREASTS))
		var/obj/item/organ/breasts/breasts = owner.getorganslot(ORGAN_SLOT_BREASTS)
		var/tag = "female_leotard"
		if(breasts.breast_size == 0)
			tag = tag + "_0"
		if(breasts.breast_size == 1)
			tag = tag + "_1"
		if(breasts.breast_size == 2)
			tag = tag + "_2"
		if(breasts.breast_size == 3)
			tag = tag + "_3"
		if(breasts.breast_size == 4)
			tag = tag + "_4"
		if(breasts.breast_size == 5)
			tag = tag + "_5"
		return tag
	else
		return "male_leotard"

/datum/sprite_accessory/underwear/athletic_leotard
	name = "Athletic Leotard"
	icon_state = "female_sleeved_leotard"
	underwear_type = /obj/item/undies/athletic_leotard
	hides_breasts = TRUE

/datum/sprite_accessory/underwear/athletic_leotard/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(owner.gender == MALE)
		return "male_athletic_leotard"
	return "female_athletic_leotard"

/datum/sprite_accessory/underwear/braies
	name = "Braies"
	icon_state = "braies"
	underwear_type = /obj/item/undies

/datum/sprite_accessory/underwear/braies/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(owner.gender == FEMALE)
		return "braies_f"
	return "braies"

/datum/sprite_accessory/legwear
	abstract_type = /datum/sprite_accessory/legwear
	icon = 'icons/obj/items/clothes/on_mob/stockings.dmi'
	color_key_name = "Legwear"
	layer = LEGWEAR_LAYER
	var/legwear_type
	//Whether this underwear includes a top (Because gender = FEMALE doesn't actually apply here.). Hides breasts, nothing more.
	var/hides_breasts = FALSE

/datum/sprite_accessory/legwear/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
    var/tag = icon_state
    pixel_y = -1
    if(owner.gender == FEMALE)
        tag = tag + "_f"
        pixel_y = 0
    if(is_species(owner,/datum/species/dwarf))
        tag = tag + "_dwarf"
        pixel_y = 0
    if(is_species(owner,/datum/species/elf) && owner.gender == MALE)
        tag = tag + "_f"
        pixel_y = -2
    return tag

/datum/sprite_accessory/legwear/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_PANTS, OFFSET_PANTS_F)

/datum/sprite_accessory/legwear/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return is_human_part_visible(owner, HIDEJUMPSUIT)

/datum/sprite_accessory/legwear/stockings
	name = "stockings"
	icon_state = "stockings"
	legwear_type = /obj/item/legwears

/datum/sprite_accessory/legwear/stockings/silk
	name = "silk stockings"
	icon_state = "silk"
	legwear_type = /obj/item/legwears/silk
//Fishnets
/datum/sprite_accessory/legwear/stockings/fishnet
	name = "fishnet stockings"
	icon_state = "fishnet"
	legwear_type = /obj/item/legwears/fishnet

/datum/sprite_accessory/legwear/stockings/thigh_high
	name = "thigh-high stockings"
	icon_state = "thigh"
	legwear_type = /obj/item/legwears/thigh_high

/datum/sprite_accessory/legwear/stockings/knee_high
	name = "knee-high stockings"
	icon_state = "knee"
	legwear_type = /obj/item/legwears/knee_high
