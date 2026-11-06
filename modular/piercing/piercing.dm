/datum/sprite_accessory/piercing
	abstract_type = /datum/sprite_accessory/piercing
	icon = 'modular/icons/mob/sprite_accessory/piercings/rings.dmi'
	color_key_name = "Piercings"
	layer = BODY_ADJ_LAYER
	color_disabled = TRUE
	var/piercing_type

/datum/sprite_accessory/piercing/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(owner.getorganslot(ORGAN_SLOT_BREASTS))
		var/obj/item/organ/breasts/breasts = owner.getorganslot(ORGAN_SLOT_BREASTS)
		var/tag = icon_state
		pixel_y = 0
		pixel_x = 0
		if(is_species(owner,/datum/species/dwarf) || is_species(owner,/datum/species/dwarf/gnome))
			pixel_y = -3
		if(is_species(owner,/datum/species/kobold))
			pixel_y = -3
		if(is_species(owner,/datum/species/anthromorphsmall))
			pixel_y = -4
		if(is_species(owner,/datum/species/goblinp))
			pixel_y = -4
		if(is_species(owner,/datum/species/elf) && owner.gender == MALE)
			tag = tag + "_f"
			pixel_y = 8
		if((breasts.breast_size == 0) || (breasts.breast_size == 1))
			tag = tag + "-1"
		if(breasts.breast_size == 2)
			tag = tag + "-2"
		if(breasts.breast_size == 3)
			tag = tag + "-3"
		if(breasts.breast_size == 4)
			tag = tag + "-4"
		if(breasts.breast_size == 5)
			tag = tag + "-5"
		return tag
	else
		var/tag = icon_state + "-1"
		return tag


/datum/sprite_accessory/piercing/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_SUIT, OFFSET_SUIT)

/datum/sprite_accessory/piercing/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return is_human_part_visible(owner, HIDEBOOB|HIDEJUMPSUIT)

/datum/sprite_accessory/piercing/rings
	icon = 'modular/icons/mob/sprite_accessory/piercings/rings.dmi'
	name = "Rings"
	icon_state = "rings"
	piercing_type = /obj/item/piercings/rings

/datum/sprite_accessory/piercing/rings/emerald
	name = "Rings (Emerald)"
	icon_state = "rings-e"
	piercing_type = /obj/item/piercings/rings/emerald

/datum/sprite_accessory/piercing/rings/gold
	name = "Rings (Gold)"
	icon_state = "rings-g"
	piercing_type = /obj/item/piercings/rings/gold

/datum/sprite_accessory/piercing/rings/silver
	name = "Rings (Silver)"
	icon_state = "rings-s"
	piercing_type = /obj/item/piercings/rings/silver

/datum/sprite_accessory/piercing/beads
	icon = 'modular/icons/mob/sprite_accessory/piercings/beads.dmi'
	name = "Beads"
	icon_state = "beads"
	piercing_type = /obj/item/piercings/beads

/datum/sprite_accessory/piercing/beads/emerald
	name = "Beads (Emerald)"
	icon_state = "beads-e"
	piercing_type = /obj/item/piercings/beads/emerald

/datum/sprite_accessory/piercing/beads/gold
	name = "Beads (Gold)"
	icon_state = "beads-g"
	piercing_type = /obj/item/piercings/beads/gold

/datum/sprite_accessory/piercing/beads/silver
	name = "Beads (Silver)"
	icon_state = "beads-s"
	piercing_type = /obj/item/piercings/beads/silver
