/datum/sprite_accessory/underwear_bottom
	abstract_type = /datum/sprite_accessory/underwear_bottom
	icon = 'icons/mob/sprite_accessory/underwear_bottom.dmi'
	color_key_name = "Underwear"
	///Whether this underwear includes a top (Because gender = FEMALE doesn't actually apply here.). Hides breasts, nothing more.
	var/hides_breasts = FALSE

// Underwear comes in two cuts: a bulky one (mt/ft_muscular) and a slim one, the latter suffixed _f or named
// after the elf body it was drawn for. Which cut fits is a question about the body, not the character's gender,
// so these follow is_bulky_body() the same way worn clothing does.
// Remaining donor garments select their own states below.

/datum/sprite_accessory/underwear_bottom/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_UNDIES, OFFSET_UNDIES_F)

/datum/sprite_accessory/underwear_bottom/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(hides_breasts)
		if(is_human_part_visible(owner, HIDECROTCH) || is_human_part_visible(owner, HIDEBOOB))
			return TRUE
	return is_human_part_visible(owner, HIDECROTCH)

/datum/sprite_accessory/underwear_bottom/briefs
	name = "Briefs"
	icon_state = "male_reg"

/datum/sprite_accessory/underwear_bottom/briefs/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(is_species(owner,/datum/species/dwarf))
		return "maledwarf_reg"
	if(!owner.is_bulky_body())
		return "maleelf_reg"
	return "male_reg"

/datum/sprite_accessory/underwear_bottom/bikini_bottom
	name = "Bikini Bottom"
	icon = 'icons/obj/items/clothes/on_mob/underwear_bottom.dmi'
	icon_state = "bikini"

/datum/sprite_accessory/underwear_bottom/panties
	name = "Panties"
	icon_state = "panties"

/datum/sprite_accessory/underwear_bottom/braies
	name = "Braies"
	icon_state = "braies"

/datum/sprite_accessory/underwear_bottom/braies/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(!owner.is_bulky_body())
		return "braies_f"
	return "braies"

/datum/sprite_accessory/underwear_bottom/briefs/eoran
	name = "Briefs - Eoran"
	icon_state = "eoran_reg"

/datum/sprite_accessory/underwear_bottom/briefs/eoran/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(is_species(owner,/datum/species/dwarf))
		return "eoran_dwarf"
	if(!owner.is_bulky_body())
		return "eoran_elf"
	return "eoran_reg"

/datum/sprite_accessory/underwear_bottom/bandages
	name = "Bandages"
	icon_state = "bandages"
	hides_breasts = TRUE

/datum/sprite_accessory/underwear_bottom/bandages/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
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
	name = "Stockings"
	icon_state = "stockings"
	legwear_type = /obj/item/clothing/legwears

/datum/sprite_accessory/legwear/stockings/silk
	name = "Silk stockings"
	icon_state = "silk"
	legwear_type = /obj/item/clothing/legwears/silk
//Fishnets
/datum/sprite_accessory/legwear/stockings/fishnet
	name = "Fishnet stockings"
	icon_state = "fishnet"
	legwear_type = /obj/item/clothing/legwears/fishnet

/datum/sprite_accessory/legwear/stockings/thigh_high
	name = "Thigh-high stockings"
	icon_state = "thigh"
	legwear_type = /obj/item/clothing/legwears/thigh_high

/datum/sprite_accessory/legwear/stockings/thigh_high_silk
	name = "Thigh-high stockings - silk"
	icon_state = "thigh_silk"
	legwear_type = /obj/item/clothing/legwears/thigh_high_silk

/datum/sprite_accessory/legwear/stockings/knee_high
	name = "Knee-high stockings"
	icon_state = "knee"
	legwear_type = /obj/item/clothing/legwears/knee_high

/datum/sprite_accessory/legwear/stockings/knee_high_silk
	name = "Knee-high stockings - silk"
	icon_state = "knee_silk"
	legwear_type = /obj/item/clothing/legwears/knee_high_silk

/datum/sprite_accessory/legwear/stockings/sleeve_knee_silk
	name = "Knee-high sleeves - silk"
	icon_state = "sleeve_k_silk"
	legwear_type = /obj/item/clothing/legwears/sleeve_knee_silk

/datum/sprite_accessory/legwear/stockings/sleeve_stir_knee_silk
	name = "Knee-high sleeves (stirrup) - silk"
	icon_state = "sleeve_ks_silk"
	legwear_type = /obj/item/clothing/legwears/sleeve_stir_knee_silk

/datum/sprite_accessory/legwear/stockings/sleeve_stir_thigh_silk
	name = "Thigh-high sleeves (stirrup) - silk"
	icon_state = "sleeve_ts_silk"
	legwear_type = /obj/item/clothing/legwears/sleeve_stir_thigh_silk

/datum/sprite_accessory/legwear/stockings/sleeve_stir_ankle_silk
	name = "Ankle-high sleeves (stirrup) - silk"
	icon_state = "sleeve_as_silk"
	legwear_type = /obj/item/clothing/legwears/sleeve_stir_ankle_silk
	legwear_type = /obj/item/clothing/legwears/knee_high_silk
