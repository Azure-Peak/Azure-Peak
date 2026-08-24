/*
 * Helpers for the custom hair painter.
 *
 * A "mask" is a 32x32 monochrome bitmap flattened to 256 lowercase hex characters, four pixels per
 * character, read left to right and bottom row first. Masks are grouped per direction ("s"/"w"/"n"/
 * "e") and those groups are grouped per colour, giving the `colormasks` layer list that both the
 * editor and the renderer consume.
 *
 * Anything arriving from a client, a savefile or JSON is untrusted and goes through hairmask_clean()
 * once. Internal round-trips pass `trusted = TRUE` to skip that per-character pass, which is the
 * difference between a length check and 256 range checks on every render.
 */

GLOBAL_LIST_INIT(hair_preview_dirs, list(SOUTH, WEST, NORTH, EAST))

/proc/hair_dir_valid(preview_dir)
	return preview_dir in GLOB.hair_preview_dirs

/proc/hair_dir_key(preview_dir)
	switch(preview_dir)
		if(SOUTH)
			return "s"
		if(WEST)
			return "w"
		if(NORTH)
			return "n"
		if(EAST)
			return "e"
	return null

/proc/hair_dir_label(preview_dir)
	switch(preview_dir)
		if(SOUTH)
			return "South"
		if(WEST)
			return "West"
		if(NORTH)
			return "North"
		if(EAST)
			return "East"
	return "South"

/// Cheap structural check. Says nothing about the contents, only that the shape is right.
/proc/hairmask_valid(mask)
	return istext(mask) && length(mask) == 256

/// Full validation for untrusted input. Returns a normalized lowercase mask, or null if unusable.
/proc/hairmask_clean(mask)
	if(!istext(mask) || length(mask) != 256)
		return null
	mask = LOWER_TEXT(mask)
	for(var/i in 1 to 256)
		var/char_code = text2ascii(mask, i)
		if(char_code < 48)
			return null
		if(char_code <= 57)
			continue
		if(char_code < 97 || char_code > 102)
			return null
	return mask

/// Value of a single hex digit, or -1. Masks are lowercased by hairmask_clean() before they get
/// here, so only 0-9 and a-f are accepted.
/proc/hairmask_hex_value(mask, index)
	if(!istext(mask) || index < 1 || index > length(mask))
		return -1
	var/char_code = text2ascii(mask, index)
	if(char_code >= 48 && char_code <= 57)
		return char_code - 48
	if(char_code >= 97 && char_code <= 102)
		return char_code - 87
	return -1

/proc/hairmask_get(masks, preview_dir)
	if(!islist(masks))
		return null
	var/mask = masks[hair_dir_key(preview_dir)]
	return hairmask_valid(mask) ? mask : null

/// Normalizes a per-direction mask list, dropping directions that fail validation.
/proc/hairmask_list(masks, trusted = FALSE)
	if(!islist(masks))
		return null
	var/list/out = list()
	for(var/preview_dir in GLOB.hair_preview_dirs)
		var/key = hair_dir_key(preview_dir)
		var/mask = masks[key]
		if(trusted)
			if(!hairmask_valid(mask))
				continue
		else
			mask = hairmask_clean(mask)
			if(!mask)
				continue
		out[key] = mask
	return out.len ? out : null

/// Normalizes a full colour -> direction -> mask layer list.
/proc/hairmask_layers(layers, trusted = FALSE)
	if(!islist(layers))
		return null
	var/list/out = list()
	for(var/color in layers)
		var/safe_color = sanitize_hexcolor(color, 6, TRUE)
		if(!safe_color)
			continue
		var/list/masks = hairmask_list(layers[color], trusted)
		if(masks?.len)
			out[safe_color] = masks
	return out.len ? out : null

/proc/hairmask_layers_any(layers)
	return !!hairmask_layers(layers, TRUE)

/// Client-supplied list of {color, mask} pairs for one direction.
/proc/hairmask_dir_map(dir_layers)
	if(!islist(dir_layers))
		return null
	var/list/mapped = list()
	for(var/list/layer in dir_layers)
		if(!islist(layer))
			continue
		var/color = sanitize_hexcolor(layer["color"], 6, TRUE)
		if(!color)
			continue
		var/mask = hairmask_clean(layer["mask"])
		if(mask)
			mapped[color] = mask
	return mapped.len ? mapped : null

/proc/hairmask_put(masks, preview_dir, mask)
	if(!islist(masks))
		masks = list()
	masks[hair_dir_key(preview_dir)] = hairmask_valid(mask) ? mask : null
	return hairmask_list(masks, TRUE)

/proc/hairmask_dir_any(layers, preview_dir)
	if(!islist(layers))
		return FALSE
	for(var/color in layers)
		if(hairmask_get(layers[color], preview_dir))
			return TRUE
	return FALSE

/proc/hairmask_dir_data(layers, preview_dir)
	layers = hairmask_layers(layers, TRUE)
	if(!layers)
		return null
	var/list/data = list()
	for(var/color in layers)
		var/mask = hairmask_get(layers[color], preview_dir)
		if(mask)
			data += list(list(
				"color" = color,
				"mask" = mask,
			))
	return data.len ? data : null

/// Bitwise OR of two masks. Both are cleaned first: this is the one place two independently sourced
/// masks meet, so neither can be assumed normalized.
/proc/hairmask_union(mask_a, mask_b)
	mask_a = hairmask_clean(mask_a)
	mask_b = hairmask_clean(mask_b)
	if(!mask_a)
		return mask_b
	if(!mask_b)
		return mask_a
	if(mask_a == mask_b)
		return mask_a
	var/static/empty_row = "00000000"
	var/static/list/hex_digits = list("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f")
	var/list/rows = list()
	for(var/row in 1 to 32)
		var/row_start = ((row - 1) << 3) + 1
		var/row_end = row_start + 8
		var/row_a = copytext(mask_a, row_start, row_end)
		var/row_b = copytext(mask_b, row_start, row_end)
		if(row_a == row_b)
			rows += row_a
			continue
		if(row_a == empty_row)
			rows += row_b
			continue
		if(row_b == empty_row)
			rows += row_a
			continue
		var/row_text = ""
		for(var/hex_offset in 0 to 7)
			var/index = row_start + hex_offset
			// Table lookup keeps the result lowercase; num2hex() would emit uppercase and force a
			// second pass over the whole 256 character string to fix it up.
			row_text += hex_digits[(hairmask_hex_value(mask_a, index) | hairmask_hex_value(mask_b, index)) + 1]
		rows += row_text
	return jointext(rows, "")

/proc/hairmask_layer_merge(layers, color, masks)
	color = sanitize_hexcolor(color, 6, TRUE)
	masks = hairmask_list(masks, TRUE) || hairmask_list(masks)
	if(!color || !masks)
		return hairmask_layers(layers)
	if(!islist(layers))
		layers = list()
	var/list/existing = hairmask_list(layers[color], TRUE) || hairmask_list(layers[color])
	var/list/merged = list()
	for(var/preview_dir in GLOB.hair_preview_dirs)
		var/mask = hairmask_union(hairmask_get(existing, preview_dir), hairmask_get(masks, preview_dir))
		if(mask)
			merged[hair_dir_key(preview_dir)] = mask
	if(merged.len)
		layers[color] = merged
	else
		layers -= color
	return hairmask_layers(layers)

/proc/hairmask_dir_replace(layers, preview_dir, dir_layers)
	if(!hair_dir_valid(preview_dir))
		return hairmask_layers(layers)
	var/list/current_layers = hairmask_layers(layers, TRUE) || hairmask_layers(layers)
	var/list/replaced = hairmask_dir_map(dir_layers)
	var/list/next_layers = list()
	var/list/colors = list()
	if(islist(current_layers))
		for(var/color in current_layers)
			colors[color] = TRUE
	if(islist(replaced))
		for(var/color in replaced)
			if(color)
				colors[color] = TRUE
	for(var/color in colors)
		var/list/updated = hairmask_put(current_layers?[color], preview_dir, replaced?[color])
		if(updated)
			next_layers[color] = updated
	return hairmask_layers(next_layers, TRUE)

/// Blanks every row outside [min_y, max_y]. This is the gate the painter's client-supplied strokes
/// come through, so the mask is fully validated rather than merely length checked.
/proc/hairmask_crop_y(mask, min_y, max_y)
	mask = hairmask_clean(mask)
	if(!mask)
		return null
	min_y = clamp(round(min_y), 1, 32)
	max_y = clamp(round(max_y), 1, 32)
	if(min_y > max_y)
		return null
	var/prefix_len = (min_y - 1) << 3
	var/suffix_len = (32 - max_y) << 3
	var/body = copytext(mask, prefix_len + 1, (max_y << 3) + 1)
	var/has_bits = FALSE
	for(var/i in 1 to length(body))
		if(text2ascii(body, i) != 48)
			has_bits = TRUE
			break
	if(!has_bits)
		return null
	return "[repeat_string(prefix_len, "0")][body][repeat_string(suffix_len, "0")]"

/// Paints a mask onto an icon, coalescing horizontal runs into single DrawBox calls.
/proc/hairmask_drawbits(icon/target_icon, mask, fillcolor)
	if(!target_icon || !hairmask_valid(mask))
		return target_icon
	fillcolor = sanitize_hexcolor(fillcolor, 6, TRUE, "#FFFFFF")
	for(var/pixel_y in 1 to 32)
		var/run_start = 0
		var/pixel_x = 1
		var/row_hex_index = (pixel_y - 1) << 3
		for(var/hex_offset in 1 to 8)
			// Decoded inline rather than through hairmask_hex_value(): this runs 256 times per mask
			// per direction and the call overhead dominates the actual work.
			var/char_code = text2ascii(mask, row_hex_index + hex_offset)
			var/hex_value = 0
			if(char_code >= 48 && char_code <= 57)
				hex_value = char_code - 48
			else if(char_code >= 97 && char_code <= 102)
				hex_value = char_code - 87
			for(var/bit_index in 0 to 3)
				if(hex_value & (1 << bit_index))
					if(!run_start)
						run_start = pixel_x
				else if(run_start)
					target_icon.DrawBox(fillcolor, run_start, pixel_y, pixel_x - 1, pixel_y)
					run_start = 0
				pixel_x++
		if(run_start)
			target_icon.DrawBox(fillcolor, run_start, pixel_y, 32, pixel_y)
	return target_icon

/proc/hair_entry_masks(datum/customizer_entry/hair/hair_entry)
	if(!hair_entry)
		return null
	hair_entry.colormasks = hairmask_layers(hair_entry.colormasks, TRUE) || hairmask_layers(hair_entry.colormasks)
	// Legacy savefiles stored a single-colour add-mask alongside the layer list; fold it in once.
	var/list/addmasks = hairmask_list(hair_entry.addmasks, TRUE) || hairmask_list(hair_entry.addmasks)
	if(addmasks)
		var/legacy_colour = sanitize_hexcolor(hair_entry.pix_color, 6, TRUE, hair_entry.hair_color)
		hair_entry.colormasks = hairmask_layer_merge(hair_entry.colormasks, legacy_colour, addmasks)
	hair_entry.addmasks = null
	hair_entry.colormasks = hairmask_palette_layers(hair_entry.colormasks, hair_entry)
	return hair_entry.colormasks


/proc/hair_pack(datum/customizer_entry/hair/hair_entry)
	if(!hair_entry)
		return
	hair_entry_masks(hair_entry)
	hair_entry.maskjson = hair_entry.colormasks ? json_encode(hair_entry.colormasks) : null
	hair_entry.addjson = null
	hair_entry.colormasks = null
	hair_entry.addmasks = null

/proc/hair_unpack(datum/customizer_entry/hair/hair_entry)
	if(!hair_entry)
		return
	if(!hair_entry.colormasks && hair_entry.maskjson)
		hair_entry.colormasks = hairmask_palette_layers(safe_json_decode(hair_entry.maskjson), hair_entry)
	if(!hair_entry.addmasks && hair_entry.addjson)
		hair_entry.addmasks = hairmask_list(safe_json_decode(hair_entry.addjson))
	hair_entry.maskjson = null
	hair_entry.addjson = null

/proc/hair_clear(datum/customizer_entry/hair/hair_entry)
	if(!hair_entry)
		return
	hair_entry.colormasks = null
	hair_entry.addmasks = null
	hair_entry.maskjson = null
	hair_entry.addjson = null
	hair_entry.custom_mask_version++

/proc/hair_colour_mix(colour, target, amount)
	colour = sanitize_hexcolor(colour, 6, TRUE)
	if(!colour)
		return null
	amount = clamp(amount, 0, 1)
	var/red = hex2num(copytext(colour, 2, 4))
	var/green = hex2num(copytext(colour, 4, 6))
	var/blue = hex2num(copytext(colour, 6, 8))
	red = round(red + ((target - red) * amount))
	green = round(green + ((target - green) * amount))
	blue = round(blue + ((target - blue) * amount))
	return "#[num2hex(clamp(red, 0, 255), 2)][num2hex(clamp(green, 0, 255), 2)][num2hex(clamp(blue, 0, 255), 2)]"

/proc/hair_palette_key(datum/customizer_entry/hair/hair_entry)
	if(!hair_entry)
		return null
	return "[sanitize_hexcolor(hair_entry.hair_color, 6, TRUE, "#FFFFFF")]|[hair_entry.natural_gradient]|[sanitize_hexcolor(hair_entry.natural_color, 6, TRUE, "#FFFFFF")]|[hair_entry.dye_gradient]|[sanitize_hexcolor(hair_entry.dye_color, 6, TRUE, "#FFFFFF")]"

/// Labelled swatches offered by the painter: the hair colour plus each active gradient colour, each
/// with a darker and lighter variant.
/proc/hair_palette_entries(datum/customizer_entry/hair/hair_entry)
	if(!hair_entry)
		return list(list("label" = "Hair", "color" = "#FFFFFF"))
	var/palette_key = hair_palette_key(hair_entry)
	var/static/list/palette_entries_cache = list()
	var/list/cached_entries = palette_entries_cache[palette_key]
	if(islist(cached_entries))
		return cached_entries
	var/list/palette = list()
	var/base = sanitize_hexcolor(hair_entry.hair_color, 6, TRUE, "#FFFFFF")
	palette += list(list("label" = "Base Hair", "color" = base))
	palette += list(list("label" = "Darker Base Hair", "color" = hair_colour_mix(base, 0, 0.25)))
	palette += list(list("label" = "Lighter Base Hair", "color" = hair_colour_mix(base, 255, 0.25)))
	if(hair_entry.natural_gradient != /datum/hair_gradient/none)
		var/natural = sanitize_hexcolor(hair_entry.natural_color, 6, TRUE)
		if(natural)
			palette += list(list("label" = "Natural Gradient", "color" = natural))
			palette += list(list("label" = "Darker Natural Gradient", "color" = hair_colour_mix(natural, 0, 0.25)))
			palette += list(list("label" = "Lighter Natural Gradient", "color" = hair_colour_mix(natural, 255, 0.25)))
	if(hair_entry.dye_gradient != /datum/hair_gradient/none)
		var/dye = sanitize_hexcolor(hair_entry.dye_color, 6, TRUE)
		if(dye)
			palette += list(list("label" = "Dye Gradient", "color" = dye))
			palette += list(list("label" = "Darker Dye Gradient", "color" = hair_colour_mix(dye, 0, 0.25)))
			palette += list(list("label" = "Lighter Dye Gradient", "color" = hair_colour_mix(dye, 255, 0.25)))
	palette_entries_cache[palette_key] = palette
	trim_cache(palette_entries_cache, HAIR_COLOUR_CACHE_LEN)
	return palette

/// Flat list of the palette's colours, cached against the same key as the entries it derives from.
/proc/hair_palette(datum/customizer_entry/hair/hair_entry)
	var/palette_key = hair_palette_key(hair_entry)
	var/static/list/palette_cache = list()
	var/list/cached = palette_key ? palette_cache[palette_key] : null
	if(islist(cached))
		return cached
	var/list/palette = list()
	for(var/list/entry in hair_palette_entries(hair_entry))
		var/colour = sanitize_hexcolor(entry["color"], 6, TRUE)
		if(colour && !(colour in palette))
			palette += colour
	if(!palette.len)
		palette += "#FFFFFF"
	if(palette_key)
		palette_cache[palette_key] = palette
		trim_cache(palette_cache, HAIR_COLOUR_CACHE_LEN)
	return palette

/// Snaps an arbitrary colour to the nearest palette entry by squared RGB distance.
/proc/hair_nearest_colour(colour, list/palette)
	colour = sanitize_hexcolor(colour, 6, TRUE)
	if(!islist(palette) || !palette.len)
		return colour || "#FFFFFF"
	if(!colour)
		return palette[1]
	var/red = hex2num(copytext(colour, 2, 4))
	var/green = hex2num(copytext(colour, 4, 6))
	var/blue = hex2num(copytext(colour, 6, 8))
	var/best_colour = palette[1]
	var/best_score = INFINITY
	for(var/palette_colour in palette)
		var/delta_red = red - hex2num(copytext(palette_colour, 2, 4))
		var/delta_green = green - hex2num(copytext(palette_colour, 4, 6))
		var/delta_blue = blue - hex2num(copytext(palette_colour, 6, 8))
		var/score = (delta_red * delta_red) + (delta_green * delta_green) + (delta_blue * delta_blue)
		if(score < best_score)
			best_score = score
			best_colour = palette_colour
	return best_colour

/proc/hair_palette_colour(colour, datum/customizer_entry/hair/hair_entry)
	return hair_nearest_colour(colour, hair_palette(hair_entry))

/proc/hairmask_palette_layers(layers, datum/customizer_entry/hair/hair_entry)
	layers = hairmask_layers(layers, TRUE) || hairmask_layers(layers)
	if(!layers || !hair_entry)
		return layers
	var/list/merged = null
	for(var/colour in layers)
		merged = hairmask_layer_merge(merged, hair_palette_colour(colour, hair_entry), layers[colour])
	return hairmask_layers(merged, TRUE)

/// Collects the distinct colours of an icon. Keys are used as a set, so membership stays O(1)
/// instead of a linear scan per pixel.
/proc/hair_icon_colors(icon/source_icon, list/colors)
	if(!islist(colors))
		colors = list()
	if(!source_icon)
		return colors
	for(var/pixel_y in 1 to 32)
		for(var/pixel_x in 1 to 32)
			var/pixel = source_icon.GetPixel(pixel_x, pixel_y)
			if(!pixel)
				continue
			var/safe_colour = sanitize_hexcolor(pixel, 6, TRUE)
			if(safe_colour)
				colors[safe_colour] = TRUE
	return colors

/proc/hair_gradient_palette(datum/sprite_accessory/accessory, gradient_type, gradient_color)
	if(gradient_type == /datum/hair_gradient/none || isnull(gradient_type))
		return null
	var/datum/hair_gradient/gradient = HAIR_GRADIENT(gradient_type)
	if(!gradient?.icon || !gradient.icon_state || !accessory?.icon || !accessory.icon_state)
		return null
	gradient_color = sanitize_hexcolor(gradient_color, 6, TRUE, "#FFFFFF")
	var/static/list/gradient_cache = list()
	var/static/list/blended_gradient_cache = list()
	var/cache_key = "[gradient_type]|[gradient_color]|[accessory.icon]|[accessory.icon_state]"
	var/list/cached_colors = gradient_cache[cache_key]
	if(islist(cached_colors))
		return cached_colors
	cached_colors = list()
	for(var/preview_dir in GLOB.hair_preview_dirs)
		var/blended_key = "[gradient_type]|[accessory.icon]|[accessory.icon_state]|[preview_dir]"
		var/icon/blended_gradient = blended_gradient_cache[blended_key]
		if(!blended_gradient)
			var/icon/gradient_icon_base = icon(gradient.icon, gradient.icon_state, dir = preview_dir)
			var/icon/hair_icon = icon(accessory.icon, accessory.icon_state, dir = preview_dir)
			if(!gradient_icon_base || !hair_icon)
				continue
			gradient_icon_base.Blend(hair_icon, ICON_ADD)
			blended_gradient = gradient_icon_base
			blended_gradient_cache[blended_key] = blended_gradient
			trim_cache(blended_gradient_cache, HAIR_GRADIENT_ICON_CACHE_LEN)
		var/icon/gradient_icon = icon(blended_gradient)
		gradient_icon.Blend(gradient_color, ICON_MULTIPLY)
		cached_colors = hair_icon_colors(gradient_icon, cached_colors)
	gradient_cache[cache_key] = cached_colors
	trim_cache(gradient_cache, HAIR_COLOUR_CACHE_LEN)
	return cached_colors

/proc/hair_gradient_colors(list/colors, datum/sprite_accessory/accessory, gradient_type, gradient_color)
	var/list/gradient_colors = hair_gradient_palette(accessory, gradient_type, gradient_color)
	if(!islist(gradient_colors))
		return colors
	for(var/color in gradient_colors)
		colors[color] = TRUE
	return colors

/// Every colour the finished hair can actually show, which is what the painter snaps strokes to.
/proc/hair_colors(datum/customizer_entry/hair/hair_entry)
	if(!hair_entry)
		return list("#ffffff")
	var/fillcolor = sanitize_hexcolor(hair_entry.hair_color, 6, TRUE, "#FFFFFF")
	if(!hair_entry.accessory_type)
		return list(fillcolor)
	var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(hair_entry.accessory_type)
	if(!accessory || !accessory.icon_state)
		return list(fillcolor)
	var/natural_gradient = hair_entry.natural_gradient
	var/natural_color = sanitize_hexcolor(hair_entry.natural_color, 6, TRUE, "#FFFFFF")
	var/dye_gradient = hair_entry.dye_gradient
	var/dye_color = sanitize_hexcolor(hair_entry.dye_color, 6, TRUE, "#FFFFFF")
	var/static/list/hair_colors_cache = list()
	var/cache_key = "[hair_entry.accessory_type]|[fillcolor]|[natural_gradient]|[natural_color]|[dye_gradient]|[dye_color]"
	var/list/cached_colors = hair_colors_cache[cache_key]
	if(islist(cached_colors))
		return cached_colors
	var/list/colors = list(fillcolor)
	for(var/preview_dir in GLOB.hair_preview_dirs)
		var/icon/palette_icon = icon(accessory.icon, accessory.icon_state, dir = preview_dir)
		if(!palette_icon)
			continue
		palette_icon.Blend(fillcolor, ICON_MULTIPLY)
		colors = hair_icon_colors(palette_icon, colors)
	if(natural_gradient != /datum/hair_gradient/none)
		colors = hair_gradient_colors(colors, accessory, natural_gradient, natural_color)
	if(dye_gradient != /datum/hair_gradient/none)
		colors = hair_gradient_colors(colors, accessory, dye_gradient, dye_color)
	if(!colors.len)
		colors = list(fillcolor)
	hair_colors_cache[cache_key] = colors
	trim_cache(hair_colors_cache, HAIR_COLOUR_CACHE_LEN)
	return colors

/proc/hair_cache_key(datum/customizer_entry/hair/hair_entry, customizer_type)
	if(!hair_entry)
		return null
	return "[customizer_type]|[hair_entry.accessory_type]|[sanitize_hexcolor(hair_entry.hair_color, 6, TRUE, "#FFFFFF")]|[hair_entry.natural_gradient]|[sanitize_hexcolor(hair_entry.natural_color, 6, TRUE, "#FFFFFF")]|[hair_entry.dye_gradient]|[sanitize_hexcolor(hair_entry.dye_color, 6, TRUE, "#FFFFFF")]"

/proc/hair_preview_icon(mob/living/carbon/human/human, preview_dir)
	if(!human)
		return null
	return getFlatIcon(human, defdir = preview_dir, no_anim = TRUE)

/proc/hair_band_layers(list/overlays, preview_dir)
	if(!overlays?.len)
		return null
	var/icon/band_icon = icon('icons/effects/effects.dmi', "nothing")
	for(var/mutable_appearance/appearance as anything in overlays)
		var/icon/layer_icon = icon(appearance.icon, appearance.icon_state, dir = preview_dir)
		if(!layer_icon)
			continue
		if(appearance.pixel_x > 0)
			layer_icon.Shift(EAST, appearance.pixel_x)
		else if(appearance.pixel_x < 0)
			layer_icon.Shift(WEST, -appearance.pixel_x)
		if(appearance.pixel_y > 0)
			layer_icon.Shift(NORTH, appearance.pixel_y)
		else if(appearance.pixel_y < 0)
			layer_icon.Shift(SOUTH, -appearance.pixel_y)
		band_icon.Blend(layer_icon, ICON_OVERLAY)
	return band_icon

/proc/hair_bands(datum/customizer_entry/hair/hair_entry)
	if(!hair_entry?.accessory_type)
		return null
	var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(hair_entry.accessory_type)
	if(!accessory?.icon_state)
		return null
	var/list/overlays = accessory.get_overlay(accessory.icon_state, hair_entry.hair_color)
	if(!overlays?.len)
		return null
	var/list/bands = list()
	for(var/preview_dir in GLOB.hair_preview_dirs)
		bands["[hair_dir_key(preview_dir)]_band"] = hair_band_layers(overlays, preview_dir)
	return bands

/proc/hair_band_cache(list/cache, preview_dir)
	if(!islist(cache))
		return null
	var/key = hair_dir_key(preview_dir)
	if(!key)
		return null
	return cache["[key]_band"]

/proc/hair_asset(icon/preview_icon)
	if(!isicon(preview_icon))
		return null
	var/list/name_ref = generate_and_hash_rsc_file(preview_icon, FALSE)
	var/asset_name = "[name_ref[3]].png"
	if(!SSassets.cache[asset_name])
		SSassets.transport.register_asset(asset_name, name_ref[1], name_ref[2])
	return asset_name

/proc/hair_asset_url(asset_name, mob/user = null)
	if(!asset_name || !SSassets.cache[asset_name])
		return null
	if(user?.client)
		SSassets.transport.send_assets(user, asset_name)
	return SSassets.transport.get_asset_url(asset_name)

/// Window of the sprite the painter lets you draw in: centred on the hair's horizontal extent and
/// anchored just above its topmost pixel.
/proc/hair_edit_band(icon/diricon)
	var/static/list/default_band = list("minX" = 7, "maxX" = 26, "minY" = 11, "maxY" = 32)
	if(!diricon)
		return default_band.Copy()
	var/left_x = 0
	var/right_x = 0
	var/top_y = 0
	for(var/pixel_y in 32 to 1 step -1)
		for(var/pixel_x in 1 to 32)
			if(!diricon.GetPixel(pixel_x, pixel_y))
				continue
			if(!left_x || pixel_x < left_x)
				left_x = pixel_x
			if(pixel_x > right_x)
				right_x = pixel_x
			if(!top_y)
				top_y = pixel_y
	if(!top_y)
		return default_band.Copy()
	if(!left_x)
		left_x = 7
	if(!right_x)
		right_x = 26
	var/window_width = 20
	var/top_padding = 2
	var/window_height = window_width + top_padding
	var/min_x = round((left_x + right_x - window_width) / 2)
	if(min_x < 1)
		min_x = 1
	if(min_x + window_width - 1 > 32)
		min_x = 32 - window_width + 1
	var/max_y = max(top_y + top_padding, window_height)
	if(max_y > 32)
		max_y = 32
	return list(
		"minX" = min_x,
		"maxX" = min_x + window_width - 1,
		"minY" = max_y - window_height + 1,
		"maxY" = max_y,
	)
