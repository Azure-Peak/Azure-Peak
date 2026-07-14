/datum/bodypart_feature/hair
	var/hair_color = "#FFFFFF"
	var/natural_gradient = /datum/hair_gradient/none
	var/natural_color = "#FFFFFF"
	var/hair_dye_gradient = /datum/hair_gradient/none
	var/hair_dye_color = "#FFFFFF"
	var/list/colormasks
	/// Incremented by the customizer entry whenever custom masks change.
	var/custom_mask_version = 0
	/// Cached composed custom hair overlay for the current `colormasks` list.
	var/icon/custom_overlay_icon
	/// Version of custom masks used to build custom_overlay_icon.
	var/custom_overlay_key = -1
	/// Fallback reference check in case future code mutates masks without bumping a version.
	var/list/custom_overlay_ref

/datum/bodypart_feature/hair/bodypart_icon(mutable_appearance/standing)
	return

/datum/bodypart_feature/hair/bodypart_overlays(mutable_appearance/standing)
	add_gradient_overlay(standing, natural_gradient, natural_color)
	add_gradient_overlay(standing, hair_dye_gradient, hair_dye_color)
	add_custom_overlay(standing)

/datum/bodypart_feature/hair/get_cache_key()
	return "[accessory_type]-[accessory_colors]-[natural_gradient]-[natural_color]-[hair_dye_gradient]-[hair_dye_color]-[custom_mask_version]"

/datum/bodypart_feature/hair/proc/get_custom_mask()
	var/list/custom_masks = hairmask_layers_fast(colormasks)
	if(custom_masks)
		return custom_masks
	return hairmask_layers(colormasks)

/datum/bodypart_feature/hair/proc/add_custom_overlay(mutable_appearance/standing)
	if(!islist(colormasks) || !colormasks.len)
		custom_overlay_icon = null
		custom_overlay_key = -1
		custom_overlay_ref = null
		return
	var/icon/custom_icon = custom_overlay_icon
	if(!custom_icon || custom_overlay_key != custom_mask_version || custom_overlay_ref != colormasks)
		var/list/custom_masks = get_custom_mask()
		if(!custom_masks)
			custom_overlay_icon = null
			custom_overlay_key = -1
			custom_overlay_ref = null
			return
		var/static/icon/blank_overlay_icon
		if(!blank_overlay_icon)
			blank_overlay_icon = icon('icons/effects/effects.dmi', "nothing")
		if(!blank_overlay_icon)
			return
		custom_icon = icon(blank_overlay_icon)
		if(!custom_icon)
			return
		for(var/preview_dir in hair_preview_dirs())
			var/icon/partial = icon(blank_overlay_icon)
			if(!partial)
				continue
			for(var/color in custom_masks)
				var/mask = hairmask_get_fast(custom_masks[color], preview_dir)
				if(mask)
					hairmask_drawbits_fast(partial, mask, color)
			custom_icon.Insert(partial, dir = preview_dir)
		custom_overlay_icon = custom_icon
		custom_overlay_key = custom_mask_version
		custom_overlay_ref = colormasks
	var/mutable_appearance/custom_appear = mutable_appearance(custom_icon)
	custom_appear.pixel_x = -standing.pixel_x
	custom_appear.pixel_y = -standing.pixel_y
	standing.overlays += custom_appear

/datum/bodypart_feature/hair/proc/add_gradient_overlay(mutable_appearance/standing, gradient_type, gradient_color)
	if(gradient_type == /datum/hair_gradient/none || isnull(gradient_type))
		return
	var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(accessory_type)
	if(!accessory?.icon || !accessory.icon_state)
		return
	var/datum/hair_gradient/gradient = HAIR_GRADIENT(gradient_type)
	if(!gradient?.icon || !gradient.icon_state)
		return
	var/static/list/blended_gradient_cache = list()
	var/cache_key = "[gradient_type]|[accessory.icon]|[accessory.icon_state]"
	var/icon/blended_gradient = blended_gradient_cache[cache_key]
	if(!blended_gradient)
		var/icon/gradient_icon = icon(gradient.icon, gradient.icon_state)
		var/icon/hair_icon = icon(accessory.icon, accessory.icon_state)
		if(!gradient_icon || !hair_icon)
			return
		gradient_icon.Blend(hair_icon, ICON_ADD)
		blended_gradient = gradient_icon
		blended_gradient_cache[cache_key] = blended_gradient
	var/mutable_appearance/gradient_appear = mutable_appearance(blended_gradient)
	gradient_appear.color = sanitize_hexcolor(gradient_color, 6, TRUE, "#FFFFFF")
	standing.overlays += gradient_appear

/datum/bodypart_feature/hair/head
	name = "Hair"
	feature_slot = BODYPART_FEATURE_HAIR
	body_zone = BODY_ZONE_HEAD

/datum/bodypart_feature/hair/facial
	name = "Facial Hair"
	feature_slot = BODYPART_FEATURE_FACIAL_HAIR
	body_zone = BODY_ZONE_HEAD

/datum/bodypart_feature/face_detail
	name = "Face Detail"
	feature_slot = BODYPART_FEATURE_FACE_DETAIL
	body_zone = BODY_ZONE_HEAD

/datum/bodypart_feature/accessory
	name = "Accessory"
	feature_slot = BODYPART_FEATURE_ACCESSORY
	body_zone = BODY_ZONE_HEAD

/datum/bodypart_feature/crest
	name = "Crest"
	feature_slot = BODYPART_FEATURE_CREST
	body_zone = BODY_ZONE_HEAD

/datum/bodypart_feature/underwear
	name = "Underwear"
	feature_slot = BODYPART_FEATURE_UNDERWEAR
	body_zone = BODY_ZONE_CHEST
	var/obj/item/undies/underwear_item

/datum/bodypart_feature/underwear/set_accessory_type(new_accessory_type, colors, mob/living/carbon/owner)
	accessory_type = new_accessory_type
	var/datum/sprite_accessory/underwear/accessory = SPRITE_ACCESSORY(accessory_type)
	if(!isnull(colors))
		accessory_colors = colors
	else
		accessory_colors = accessory.get_default_colors(color_key_source_list_from_carbon(owner))
	accessory_colors = accessory.validate_color_keys_for_owner(owner, colors)
	underwear_item = new accessory.underwear_type(owner)
	if(owner.underwear)
		qdel(owner.underwear)
	owner.underwear = underwear_item
	underwear_item.undies_feature = src
	underwear_item.color = accessory_colors

/datum/bodypart_feature/legwear
	name = "Legwear"
	feature_slot = BODYPART_FEATURE_LEGWEAR
	body_zone = BODY_ZONE_CHEST
	var/obj/item/legwears/legwear_item

/datum/bodypart_feature/legwear/set_accessory_type(new_accessory_type, colors, mob/living/carbon/owner)
	accessory_type = new_accessory_type
	var/datum/sprite_accessory/legwear/accessory = SPRITE_ACCESSORY(accessory_type)
	if(!isnull(colors))
		accessory_colors = colors
	else
		accessory_colors = accessory.get_default_colors(color_key_source_list_from_carbon(owner))
	accessory_colors = accessory.validate_color_keys_for_owner(owner, colors)
	legwear_item = new accessory.legwear_type(owner)
	if(owner.legwear_socks)
		qdel(owner.legwear_socks)
	owner.legwear_socks = legwear_item
	legwear_item.legwears_feature = src
	legwear_item.color = accessory_colors
