/datum/sprite_accessory/underwear
	abstract_type = /datum/sprite_accessory/underwear
	icon = 'icons/mob/sprite_accessory/underwear.dmi'
	color_key_name = "Underwear"
	var/underwear_type
	///Whether this underwear includes a top (Because gender = FEMALE doesn't actually apply here.). Hides breasts, nothing more.
	var/hides_breasts = FALSE

// Underwear comes in two cuts: a bulky one (mt/ft_muscular) and a slim one, the latter suffixed _f or named
// after the elf body it was drawn for. Which cut fits is a question about the body, not the character's gender,
// so these follow is_bulky_body() the same way worn clothing does. Garments that only exist in one cut — the
// bikini and the sized leotard — stay driven by the breasts organ, so they remain wearable on any build.

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
	if(!owner.is_bulky_body())
		return "maleelf_reg"
	return "male_reg"

/datum/sprite_accessory/underwear/bikini
	name = "Bikini"
	icon_state = "female_bikini"
	preview_states = list("bikini_f_0")
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
	preview_states = list("female_leotard_0")
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
	preview_states = list("female_athletic_leotard")
	underwear_type = /obj/item/undies/athletic_leotard
	hides_breasts = TRUE

/datum/sprite_accessory/underwear/athletic_leotard/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(owner.is_bulky_body())
		return "male_athletic_leotard"
	return "female_athletic_leotard"

/datum/sprite_accessory/underwear/braies
	name = "Braies"
	icon_state = "braies"
	underwear_type = /obj/item/undies

/datum/sprite_accessory/underwear/braies/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(!owner.is_bulky_body())
		return "braies_f"
	return "braies"

/datum/sprite_accessory/underwear/briefs/eoran
	name = "Briefs - Eoran"
	icon_state = "eoran_reg"
	underwear_type = /obj/item/undies

/datum/sprite_accessory/underwear/briefs/eoran/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(is_species(owner,/datum/species/dwarf))
		return "eoran_dwarf"
	if(!owner.is_bulky_body())
		return "eoran_elf"
	return "eoran_reg"

/datum/sprite_accessory/underwear/bandages
	name = "Bandages"
	icon_state = "bandages"
	underwear_type = /obj/item/undies/bandages
	hides_breasts = TRUE

/datum/sprite_accessory/underwear/bandages/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(!owner.is_bulky_body())
		return "bandages_f"
	return "bandages"


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
	// The _f cut is the slim silhouette, which is why elf males always needed it by hand; the body build decides
	// it now, so it covers slim males of every race. Within that cut the male (mem) and female (fm) bodies still
	// sit a couple of pixels apart, so the nudge stays gendered even though the sprite doesn't.
	if(!owner.is_bulky_body())
		tag = tag + "_f"
		// No build shift here: legwear hangs off the legs, which stay planted on a raised build.
		pixel_y = (owner.gender == MALE) ? -2 : 0
	if(is_species(owner,/datum/species/dwarf) || is_species(owner,/datum/species/kobold) || is_species(owner,/datum/species/dwarf/gnome) || is_species(owner,/datum/species/goblinp))
		pixel_y = 0
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

/datum/sprite_accessory/legwear/stockings/thigh_high_silk
	name = "thigh-high stockings - silk"
	icon_state = "thigh_silk"
	legwear_type = /obj/item/legwears/thigh_high_silk

/datum/sprite_accessory/legwear/stockings/knee_high
	name = "knee-high stockings"
	icon_state = "knee"
	legwear_type = /obj/item/legwears/knee_high

/datum/sprite_accessory/legwear/stockings/knee_high_silk
	name = "knee-high stockings - silk"
	icon_state = "knee_silk"
	legwear_type = /obj/item/legwears/knee_high_silk

/datum/sprite_accessory/legwear/stockings/sleeve_knee_silk
	name = "knee-high sleeves - silk"
	icon_state = "sleeve_k_silk"
	legwear_type = /obj/item/legwears/sleeve_knee_silk

/datum/sprite_accessory/legwear/stockings/sleeve_stir_knee_silk
	name = "knee-high sleeves (stirrup) - silk"
	icon_state = "sleeve_ks_silk"
	legwear_type = /obj/item/legwears/sleeve_stir_knee_silk

/datum/sprite_accessory/legwear/stockings/sleeve_stir_thigh_silk
	name = "thigh-high sleeves (stirrup) - silk"
	icon_state = "sleeve_ts_silk"
	legwear_type = /obj/item/legwears/sleeve_stir_thigh_silk

/datum/sprite_accessory/legwear/stockings/sleeve_stir_ankle_silk
	name = "ankle-high sleeves (stirrup) - silk"
	icon_state = "sleeve_as_silk"
	legwear_type = /obj/item/legwears/sleeve_stir_ankle_silk
