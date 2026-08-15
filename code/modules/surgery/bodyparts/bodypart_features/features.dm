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
	/// Cached content fingerprint of `colormasks`, see get_custom_mask_hash().
	var/custom_mask_hash
	/// Version of custom masks the cached derivatives were built from.
	var/custom_overlay_key = -1
	/// Fallback reference check in case future code mutates masks without bumping a version.
	var/list/custom_overlay_ref

/datum/bodypart_feature/hair/bodypart_icon(mutable_appearance/standing)
	return

/datum/bodypart_feature/hair/bodypart_overlays(mutable_appearance/standing)
	add_gradient_overlay(standing, natural_gradient, natural_color)
	add_gradient_overlay(standing, hair_dye_gradient, hair_dye_color)

/// Check for obscure flags.
/datum/bodypart_feature/hair/proc/custom_pixels_covered(obj/item/bodypart/bodypart)
	var/mob/living/carbon/human/human = bodypart?.owner
	if(!istype(human))
		return FALSE
	if(human.head && occludes_hair(human.head))
		return TRUE
	if(human.wear_mask && occludes_hair(human.wear_mask))
		return TRUE
	return FALSE

/datum/bodypart_feature/hair/proc/occludes_hair(obj/item/clothing/worn)
	if(worn.body_parts_covered_dynamic & (HEAD|FACE))
		return TRUE
	if(worn.flags_inv & HAIR_OCCLUDING_FLAGS)
		return TRUE
	return FALSE

/datum/bodypart_feature/hair/extra_bodypart_overlays(obj/item/bodypart/bodypart)
	var/icon/custom_icon = get_custom_overlay_icon()
	if(!custom_icon)
		return
	var/pixel_layer = custom_pixels_covered(bodypart) ? CUSTOM_HAIR_COVERED_LAYER : CUSTOM_HAIR_LAYER
	return list(mutable_appearance(custom_icon, layer = -pixel_layer))

/// Derives cache from bodyparts_covered.
/datum/bodypart_feature/hair/get_cache_key(obj/item/bodypart/bodypart)
	. = "[accessory_type]-[accessory_colors]-[natural_gradient]-[natural_color]-[hair_dye_gradient]-[hair_dye_color]"
	var/mask_hash = get_custom_mask_hash()
	if(!mask_hash)
		return .
	return "[.]-[mask_hash]-[custom_pixels_covered(bodypart)]"

/// Drops the cached mask derivatives when they no longer describe the current mask data.
/datum/bodypart_feature/hair/proc/validate_custom_cache()
	if(custom_overlay_key == custom_mask_version && custom_overlay_ref == colormasks)
		return
	custom_overlay_icon = null
	custom_mask_hash = null
	custom_overlay_key = custom_mask_version
	custom_overlay_ref = colormasks

/// Fingerprint of the painted pixels. The limb icon cache this feeds is shared by every mob on the
/// server, so the key has to describe the actual mask content: an edit counter collides between any
/// two characters that painted the same number of times on the same style and colour.
/datum/bodypart_feature/hair/proc/get_custom_mask_hash()
	if(!length(colormasks))
		return null
	validate_custom_cache()
	if(!custom_mask_hash)
		custom_mask_hash = md5(json_encode(colormasks))
	return custom_mask_hash

/// Composes (and caches) the painted pixels of every direction into a single directional icon.
/datum/bodypart_feature/hair/proc/get_custom_overlay_icon()
	if(!length(colormasks))
		return null
	validate_custom_cache()
	if(custom_overlay_icon)
		return custom_overlay_icon
	var/list/custom_masks = hairmask_layers(colormasks)
	if(!custom_masks)
		return null
	var/static/icon/blank_overlay_icon
	if(!blank_overlay_icon)
		blank_overlay_icon = icon('icons/effects/effects.dmi', "nothing")
	if(!blank_overlay_icon)
		return null
	var/icon/custom_icon = icon(blank_overlay_icon)
	if(!custom_icon)
		return null
	for(var/preview_dir in GLOB.hair_preview_dirs)
		var/icon/partial = icon(blank_overlay_icon)
		if(!partial)
			continue
		for(var/color in custom_masks)
			var/mask = hairmask_get(custom_masks[color], preview_dir)
			if(mask)
				hairmask_drawbits(partial, mask, color)
		custom_icon.Insert(partial, dir = preview_dir)
	custom_overlay_icon = custom_icon
	return custom_icon

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
		trim_cache(blended_gradient_cache, HAIR_GRADIENT_ICON_CACHE_LEN)
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
