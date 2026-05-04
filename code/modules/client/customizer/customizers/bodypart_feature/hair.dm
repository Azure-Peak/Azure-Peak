/proc/hairmask_clean(mask)
	if(!istext(mask))
		return null
	var/mask_length = length(mask)
	if(!mask_length)
		return null
	mask = lowertext(mask)
	if(mask_length != 256)
		return null
	for(var/i in 1 to mask_length)
		var/char_code = text2ascii(mask, i)
		if(char_code < 48)
			return null
		if(char_code <= 57)
			continue
		if(char_code < 97 || char_code > 102)
			return null
	return mask

/proc/hairmask_hex_value(mask, index)
	if(!istext(mask) || index < 1 || index > length(mask))
		return -1
	var/char_code = text2ascii(mask, index)
	if(char_code >= 48 && char_code <= 57)
		return char_code - 48
	if(char_code >= 97 && char_code <= 102)
		return char_code - 87
	if(char_code >= 65 && char_code <= 70)
		return char_code - 55
	return -1

/proc/hair_preview_dirs()
	var/static/list/dirs = list(SOUTH, WEST, NORTH, EAST)
	return dirs

/proc/hair_dir_valid(preview_dir)
	return preview_dir in hair_preview_dirs()

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
		var/mask = hairmask_normalize(layer["mask"])
		if(mask)
			mapped[color] = mask
	return mapped.len ? mapped : null

/proc/hairmask_valid(mask)
	return istext(mask) && length(mask) == 256

/proc/hairmask_normalize(mask)
	return hairmask_valid(mask) ? mask : hairmask_clean(mask)

/proc/hairmask_get_fast(masks, preview_dir)
	if(!islist(masks))
		return null
	var/key = hair_dir_key(preview_dir)
	var/mask = masks[key]
	return hairmask_valid(mask) ? mask : null

/proc/hairmask_list_fast(masks)
	if(!islist(masks))
		return null
	var/list/out = list()
	for(var/preview_dir in hair_preview_dirs())
		var/key = hair_dir_key(preview_dir)
		var/mask = masks[key]
		if(hairmask_valid(mask))
			out[key] = mask
	return out.len ? out : null

/proc/hairmask_layers_fast(layers)
	if(!islist(layers))
		return null
	var/list/out = list()
	for(var/color in layers)
		var/safe_color = sanitize_hexcolor(color, 6, TRUE)
		var/list/masks = hairmask_list_fast(layers[color])
		if(safe_color && masks?.len)
			out[safe_color] = masks
	return out.len ? out : null

/proc/hairmask_put_fast(masks, preview_dir, mask)
	if(!islist(masks))
		masks = list()
	var/key = hair_dir_key(preview_dir)
	masks[key] = hairmask_valid(mask) ? mask : null
	return hairmask_list_fast(masks)

/proc/hairmask_set_fast(mask, pixel_x, pixel_y, state)
	if(pixel_x < 1 || pixel_x > 32 || pixel_y < 1 || pixel_y > 32)
		return hairmask_valid(mask) ? mask : null
	if(!hairmask_valid(mask))
		mask = repeat_string(256, "0")
	var/pixel_index = ((pixel_y - 1) * 32) + (pixel_x - 1)
	var/hex_index = (pixel_index >> 2) + 1
	var/bit_index = pixel_index & 3
	var/hex_value = hairmask_hex_value(mask, hex_index)
	if(state)
		hex_value |= (1 << bit_index)
	else
		hex_value &= ~(1 << bit_index)
	return copytext(mask, 1, hex_index) + num2hex(hex_value, 1) + copytext(mask, hex_index + 1)

/proc/hairmask_bit_fast(mask, pixel_x, pixel_y)
	if(!hairmask_valid(mask) || pixel_x < 1 || pixel_x > 32 || pixel_y < 1 || pixel_y > 32)
		return FALSE
	var/pixel_index = ((pixel_y - 1) * 32) + (pixel_x - 1)
	var/hex_index = (pixel_index >> 2) + 1
	var/bit_index = pixel_index & 3
	var/hex_value = hairmask_hex_value(mask, hex_index)
	return !!(hex_value & (1 << bit_index))

/proc/hairmask_set(mask, pixel_x, pixel_y, state)
	return hairmask_set_fast(hairmask_clean(mask), pixel_x, pixel_y, state)

/proc/hair_dir_key(preview_dir)
	var/static/list/dir_keys = list(
		"[SOUTH]" = "s",
		"[WEST]" = "w",
		"[NORTH]" = "n",
		"[EAST]" = "e",
	)
	return dir_keys["[preview_dir]"]

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

/proc/hairmask_list(masks)
	if(!islist(masks))
		return null
	var/list/out = list()
	for(var/preview_dir in hair_preview_dirs())
		var/key = hair_dir_key(preview_dir)
		var/mask = hairmask_clean(masks[key])
		if(mask)
			out[key] = mask
	return out.len ? out : null

/proc/hairmask_get(masks, preview_dir)
	if(!islist(masks))
		return null
	var/key = hair_dir_key(preview_dir)
	return hairmask_clean(masks[key])

/proc/hairmask_put(masks, preview_dir, mask)
	return hairmask_put_fast(masks, preview_dir, hairmask_clean(mask))

/proc/hairmask_plot(masks, preview_dir, pixel_x, pixel_y, state)
	return hairmask_put_fast(masks, preview_dir, hairmask_set_fast(hairmask_get_fast(masks, preview_dir), pixel_x, pixel_y, state))

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
			var/value_a = hairmask_hex_value(mask_a, index)
			var/value_b = hairmask_hex_value(mask_b, index)
			row_text += num2hex(value_a | value_b, 1)
		rows += row_text
	return jointext(rows, "")

/proc/hairmask_layers(layers)
	if(!islist(layers))
		return null
	var/list/out = list()
	for(var/color in layers)
		var/safe_color = sanitize_hexcolor(color, 6, TRUE)
		var/list/masks = hairmask_list(layers[color])
		if(safe_color && masks?.len)
			out[safe_color] = masks
	return out.len ? out : null

/proc/hairmask_layer_get(layers, color, preview_dir)
	if(!islist(layers))
		return null
	color = sanitize_hexcolor(color, 6, TRUE)
	if(!color)
		return null
	return hairmask_get(layers[color], preview_dir)

/proc/hairmask_layer_put(layers, color, preview_dir, mask)
	color = sanitize_hexcolor(color, 6, TRUE)
	if(!color)
		return hairmask_layers(layers)
	if(!islist(layers))
		layers = list()
	var/list/updated = hairmask_put(layers[color], preview_dir, mask)
	if(updated)
		layers[color] = updated
	else
		layers -= color
	return hairmask_layers(layers)

/proc/hairmask_layer_plot(layers, color, preview_dir, pixel_x, pixel_y, state)
	color = sanitize_hexcolor(color, 6, TRUE)
	if(!color)
		return hairmask_layers(layers)
	if(!islist(layers))
		layers = list()
	var/current_mask = hairmask_get_fast(layers[color], preview_dir)
	var/list/updated = hairmask_put_fast(layers[color], preview_dir, hairmask_set_fast(current_mask, pixel_x, pixel_y, state))
	if(updated)
		layers[color] = updated
	else
		layers -= color
	return hairmask_layers(layers)

/proc/hairmask_layers_any(layers)
	return !!hairmask_layers_fast(layers)

/proc/hairmask_dir_any(layers, preview_dir)
	if(!islist(layers))
		return FALSE
	for(var/color in layers)
		if(hairmask_get_fast(layers[color], preview_dir))
			return TRUE
	return FALSE

/proc/hairmask_dir_data(layers, preview_dir)
	layers = hairmask_layers_fast(layers)
	if(!layers)
		return null
	var/list/data = list()
	for(var/color in layers)
		var/mask = hairmask_get_fast(layers[color], preview_dir)
		if(mask)
			data += list(list(
				"color" = color,
				"mask" = mask,
			))
	return data.len ? data : null

/proc/hairmask_clear_px(layers, preview_dir, pixel_x, pixel_y)
	layers = hairmask_layers_fast(layers) || hairmask_layers(layers)
	if(!layers)
		return null
	var/list/colors = list()
	for(var/color in layers)
		colors += color
	for(var/color in colors)
		var/list/masks = layers[color]
		var/current_mask = hairmask_get_fast(masks, preview_dir)
		var/list/updated = hairmask_put_fast(masks, preview_dir, hairmask_set_fast(current_mask, pixel_x, pixel_y, FALSE))
		if(updated)
			layers[color] = updated
		else
			layers -= color
	return hairmask_layers_fast(layers)

/proc/hairmask_layer_merge(layers, color, masks)
	color = sanitize_hexcolor(color, 6, TRUE)
	masks = hairmask_list_fast(masks) || hairmask_list(masks)
	if(!color || !masks)
		return hairmask_layers(layers)
	if(!islist(layers))
		layers = list()
	var/list/existing = hairmask_list_fast(layers[color]) || hairmask_list(layers[color])
	var/list/merged = list()
	for(var/preview_dir in hair_preview_dirs())
		var/mask = hairmask_union(hairmask_get_fast(existing, preview_dir), hairmask_get_fast(masks, preview_dir))
		var/key = hair_dir_key(preview_dir)
		if(mask)
			merged[key] = mask
	if(merged.len)
		layers[color] = merged
	else
		layers -= color
	return hairmask_layers(layers)

/proc/hairmask_dir_replace(layers, preview_dir, dir_layers)
	if(!hair_dir_valid(preview_dir))
		return hairmask_layers(layers)
	var/list/current_layers = hairmask_layers_fast(layers)
	if(!current_layers)
		current_layers = hairmask_layers(layers)
	var/list/replaced = hairmask_dir_map(dir_layers)
	var/list/next_layers = list()
	var/list/colors = list()
	if(islist(current_layers))
		for(var/color in current_layers)
			if(!(color in colors))
				colors += color
	if(islist(replaced))
		for(var/color in replaced)
			if(color && !(color in colors))
				colors += color
	for(var/color in colors)
		var/list/color_masks = current_layers?[color]
		var/mask = replaced?[color]
		var/list/updated = hairmask_put_fast(color_masks, preview_dir, mask)
		if(updated)
			next_layers[color] = updated
	return hairmask_layers_fast(next_layers)

/proc/hairmask_has_bits(mask)
	mask = hairmask_normalize(mask)
	if(!mask)
		return FALSE
	var/mask_length = length(mask)
	for(var/i in 1 to mask_length)
		if(text2ascii(mask, i) != 48)
			return TRUE
	return FALSE

/proc/hairmask_crop_y(mask, min_y, max_y)
	mask = hairmask_normalize(mask)
	if(!mask)
		return null
	min_y = clamp(round(min_y), 1, 32)
	max_y = clamp(round(max_y), 1, 32)
	if(min_y > max_y)
		return null
	var/prefix_len = (min_y - 1) << 3
	var/suffix_len = (32 - max_y) << 3
	var/keep_start = prefix_len + 1
	var/keep_end = (max_y << 3) + 1
	var/body = copytext(mask, keep_start, keep_end)
	var/has_bits = FALSE
	var/body_length = length(body)
	for(var/i in 1 to body_length)
		if(text2ascii(body, i) != 48)
			has_bits = TRUE
			break
	if(!has_bits)
		return null
	return "[repeat_string(prefix_len, "0")][body][repeat_string(suffix_len, "0")]"

/proc/hair_entry_masks(datum/customizer_entry/hair/hair_entry)
	if(!hair_entry)
		return null
	var/list/colormasks = hairmask_layers_fast(hair_entry.colormasks)
	if(!colormasks)
		colormasks = hairmask_layers(hair_entry.colormasks)
	hair_entry.colormasks = colormasks
	var/list/addmasks = hairmask_list_fast(hair_entry.addmasks)
	if(!addmasks)
		addmasks = hairmask_list(hair_entry.addmasks)
	hair_entry.addmasks = addmasks
	if(hair_entry.addmasks)
		var/legacy_colour = sanitize_hexcolor(hair_entry.pix_color, 6, TRUE, hair_entry.hair_color)
		hair_entry.colormasks = hairmask_layer_merge(hair_entry.colormasks, legacy_colour, hair_entry.addmasks)
		hair_entry.addmasks = null
	hair_entry.colormasks = hairmask_palette_layers(hair_entry.colormasks, hair_entry)
	return hair_entry.colormasks

/proc/hair_entry_prepare(datum/customizer_entry/hair/hair_entry, norm_color = FALSE)
	if(!hair_entry)
		return null
	hair_entry.colormasks = hair_entry_masks(hair_entry)
	hair_entry.addmasks = null
	hair_entry.rmmasks = null
	if(norm_color)
		hair_entry.pix_color = hair_palette_colour(hair_entry.pix_color, hair_entry)
	return hair_entry

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

/proc/hair_palette(datum/customizer_entry/hair/hair_entry)
	var/list/entries = hair_palette_entries(hair_entry)
	var/list/palette = list()
	for(var/list/entry in entries)
		var/colour = sanitize_hexcolor(entry["color"], 6, TRUE)
		if(colour && !(colour in palette))
			palette += colour
	return palette.len ? palette : list("#FFFFFF")

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
		var/palette_red = hex2num(copytext(palette_colour, 2, 4))
		var/palette_green = hex2num(copytext(palette_colour, 4, 6))
		var/palette_blue = hex2num(copytext(palette_colour, 6, 8))
		var/delta_red = red - palette_red
		var/delta_green = green - palette_green
		var/delta_blue = blue - palette_blue
		var/score = (delta_red * delta_red) + (delta_green * delta_green) + (delta_blue * delta_blue)
		if(score < best_score)
			best_score = score
			best_colour = palette_colour
	return best_colour

/proc/hair_palette_key(datum/customizer_entry/hair/hair_entry)
	if(!hair_entry)
		return null
	return "[sanitize_hexcolor(hair_entry.hair_color, 6, TRUE, "#FFFFFF")]|[hair_entry.natural_gradient]|[sanitize_hexcolor(hair_entry.natural_color, 6, TRUE, "#FFFFFF")]|[hair_entry.dye_gradient]|[sanitize_hexcolor(hair_entry.dye_color, 6, TRUE, "#FFFFFF")]"

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
	return palette

/proc/hair_palette_colour(colour, datum/customizer_entry/hair/hair_entry)
	var/list/palette = hair_palette(hair_entry)
	return hair_nearest_colour(colour, palette)

/proc/hairmask_palette_layers(layers, datum/customizer_entry/hair/hair_entry)
	layers = hairmask_layers_fast(layers)
	if(!layers)
		layers = hairmask_layers(layers)
	if(!layers || !hair_entry)
		return layers
	var/list/merged = null
	for(var/colour in layers)
		merged = hairmask_layer_merge(merged, hair_palette_colour(colour, hair_entry), layers[colour])
	return hairmask_layers_fast(merged)

/proc/hair_pack(datum/customizer_entry/hair/hair_entry)
	if(!hair_entry)
		return
	hair_entry_masks(hair_entry)
	hair_entry.maskjson = hair_entry.colormasks ? json_encode(hair_entry.colormasks) : null
	hair_entry.addjson = null
	hair_entry.rmjson = null
	hair_entry.colormasks = null
	hair_entry.addmasks = null
	hair_entry.rmmasks = null

/proc/hair_unpack(datum/customizer_entry/hair/hair_entry)
	if(!hair_entry)
		return
	if(!hair_entry.colormasks && hair_entry.maskjson)
		hair_entry.colormasks = hairmask_palette_layers(safe_json_decode(hair_entry.maskjson), hair_entry)
	if(!hair_entry.addmasks && hair_entry.addjson)
		hair_entry.addmasks = hairmask_list(safe_json_decode(hair_entry.addjson))
	if(!hair_entry.rmmasks && hair_entry.rmjson)
		hair_entry.rmmasks = hairmask_list(safe_json_decode(hair_entry.rmjson))
	hair_entry.maskjson = null
	hair_entry.addjson = null
	hair_entry.rmjson = null

/proc/hair_clear(datum/customizer_entry/hair/hair_entry)
	if(!hair_entry)
		return
	hair_entry.colormasks = null
	hair_entry.addmasks = null
	hair_entry.rmmasks = null
	hair_entry.maskjson = null
	hair_entry.addjson = null
	hair_entry.rmjson = null
	hair_entry.custom_mask_version++


/proc/hairmask_bits(icon/target_icon, mask, fillcolor)
	if(!target_icon)
		return null
	mask = hairmask_clean(mask)
	if(!mask)
		return target_icon
	return hairmask_bits_fast(target_icon, mask, fillcolor)

/proc/hairmask_bits_fast(icon/target_icon, mask, fillcolor)
	if(!target_icon || !hairmask_valid(mask))
		return target_icon
	for(var/pixel_y in 1 to 32)
		var/run_start = 0
		var/pixel_x = 1
		var/row_hex_index = ((pixel_y - 1) << 3) + 1
		for(var/hex_offset in 0 to 7)
			var/hex_value = hairmask_hex_value(mask, row_hex_index + hex_offset)
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

/proc/hairmask_drawbits(icon/target_icon, mask, fillcolor)
	fillcolor = sanitize_hexcolor(fillcolor, 6, TRUE, "#FFFFFF")
	return hairmask_bits(target_icon, mask, fillcolor)

/proc/hairmask_drawbits_fast(icon/target_icon, mask, fillcolor)
	fillcolor = sanitize_hexcolor(fillcolor, 6, TRUE, "#FFFFFF")
	return hairmask_bits_fast(target_icon, mask, fillcolor)

/proc/hairmask_clearbits(icon/target_icon, mask)
	return hairmask_bits(target_icon, mask, null)

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
	return list(
		"s_band" = hair_band_layers(overlays, SOUTH),
		"w_band" = hair_band_layers(overlays, WEST),
		"n_band" = hair_band_layers(overlays, NORTH),
		"e_band" = hair_band_layers(overlays, EAST),
	)

/proc/hair_band_cache(list/cache, preview_dir)
	if(!islist(cache))
		return null
	var/key = hair_dir_key(preview_dir)
	if(!key)
		return null
	var/icon/band_icon = cache["[key]_band"]
	if(!band_icon)
		return null
	return band_icon

/proc/hair_icon_colors(icon/source_icon, list/colors)
	if(!source_icon)
		return colors
	if(!islist(colors))
		colors = list()
	for(var/pixel_y in 1 to 32)
		for(var/pixel_x in 1 to 32)
			var/pixel = source_icon.GetPixel(pixel_x, pixel_y)
			if(!pixel)
				continue
			pixel = sanitize_hexcolor(pixel, 6, TRUE)
			if(!(pixel in colors))
				colors += pixel
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
	for(var/preview_dir in hair_preview_dirs())
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
		var/icon/gradient_icon = icon(blended_gradient)
		gradient_icon.Blend(gradient_color, ICON_MULTIPLY)
		cached_colors = hair_icon_colors(gradient_icon, cached_colors)
	gradient_cache[cache_key] = cached_colors
	return cached_colors

/proc/hair_gradient_colors(list/colors, datum/sprite_accessory/accessory, gradient_type, gradient_color)
	var/list/gradient_colors = hair_gradient_palette(accessory, gradient_type, gradient_color)
	if(!islist(gradient_colors))
		return colors
	for(var/color in gradient_colors)
		if(!(color in colors))
			colors += color
	return colors

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
	for(var/preview_dir in hair_preview_dirs())
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
	return colors

/proc/hair_cache_key(datum/customizer_entry/hair/hair_entry, customizer_type)
	if(!hair_entry)
		return null
	return "[customizer_type]|[hair_entry.accessory_type]|[sanitize_hexcolor(hair_entry.hair_color, 6, TRUE, "#FFFFFF")]|[hair_entry.natural_gradient]|[sanitize_hexcolor(hair_entry.natural_color, 6, TRUE, "#FFFFFF")]|[hair_entry.dye_gradient]|[sanitize_hexcolor(hair_entry.dye_color, 6, TRUE, "#FFFFFF")]"

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

/proc/hair_edit_count(datum/customizer_entry/hair/hair_entry)
	if(!hair_entry)
		return 0
	var/list/colormasks = hair_entry_masks(hair_entry)
	var/count = 0
	for(var/preview_dir in hair_preview_dirs())
		if(hairmask_dir_any(colormasks, preview_dir))
			count++
	return count

/proc/hair_edit_band(icon/diricon)
	if(!diricon)
		return list("minX" = 7, "maxX" = 26, "minY" = 11, "maxY" = 32)
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
		return list("minX" = 7, "maxX" = 26, "minY" = 11, "maxY" = 32)
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
	var/max_x = min_x + window_width - 1
	var/max_y = top_y + top_padding
	if(max_y < window_height)
		max_y = window_height
	if(max_y > 32)
		max_y = 32
	var/min_y = max_y - window_height + 1
	return list(
		"minX" = min_x,
		"maxX" = max_x,
		"minY" = min_y,
		"maxY" = max_y,
	)

/datum/customizer/bodypart_feature/hair
	abstract_type = /datum/customizer/bodypart_feature/hair

/datum/customizer_choice/bodypart_feature/hair
	abstract_type = /datum/customizer_choice/bodypart_feature/hair
	customizer_entry_type = /datum/customizer_entry/hair
	allows_accessory_color_customization = FALSE //Customized through hair color
	var/natgrad = TRUE
	var/dyegrad = TRUE

/datum/customizer_choice/bodypart_feature/hair/customize_feature(datum/bodypart_feature/feature, mob/living/carbon/human/human, datum/preferences/prefs, datum/customizer_entry/hair/entry)
	var/datum/bodypart_feature/hair/hair_feature = feature
	hair_entry_prepare(entry)
	hair_feature.hair_color = entry.hair_color
	hair_feature.accessory_colors = entry.hair_color
	hair_feature.natural_color = entry.natural_color
	hair_feature.hair_dye_color = entry.dye_color
	hair_feature.natural_gradient = entry.natural_gradient
	hair_feature.hair_dye_gradient = entry.dye_gradient
	hair_feature.colormasks = entry.colormasks
	hair_feature.custom_mask_version = entry.custom_mask_version

/datum/customizer_choice/bodypart_feature/hair/validate_entry(datum/preferences/prefs, datum/customizer_entry/entry)
	..()
	var/datum/customizer_entry/hair/hair_entry = entry
	hair_unpack(hair_entry)
	hair_entry.hair_color = sanitize_hexcolor(hair_entry.hair_color, 6, TRUE, initial(hair_entry.hair_color))
	hair_entry.natural_color = sanitize_hexcolor(hair_entry.natural_color, 6, TRUE, initial(hair_entry.natural_color))
	hair_entry.dye_color = sanitize_hexcolor(hair_entry.dye_color, 6, TRUE, initial(hair_entry.dye_color))
	hair_entry.pix_color = hair_palette_colour(hair_entry.pix_color, hair_entry)
	hair_entry_prepare(hair_entry)

/datum/customizer_choice/bodypart_feature/hair/generate_pref_choices(list/dat, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	..()
	var/datum/customizer_entry/hair/hair_entry = entry
	dat += "<br>Hair Color: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=hair_color''><span class='color_holder_box' style='background-color:[hair_entry.hair_color]'></span></a>"
	if(natgrad)
		var/datum/hair_gradient/gradient = HAIR_GRADIENT(hair_entry.natural_gradient)
		dat += "<br>Natural Gradient: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=natural_gradient'>[gradient.name]</a>"
		if(hair_entry.natural_gradient != /datum/hair_gradient/none)
			dat += "<br>Natural Color: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=natural_gradient_color''><span class='color_holder_box' style='background-color:[hair_entry.natural_color]'></span></a>"
	if(dyegrad)
		var/datum/hair_gradient/gradient = HAIR_GRADIENT(hair_entry.dye_gradient)
		dat += "<br>Dye Gradient: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=dye_gradient'>[gradient.name]</a>"
		if(hair_entry.dye_gradient != /datum/hair_gradient/none)
			dat += "<br>Dye Color: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=dye_gradient_color''><span class='color_holder_box' style='background-color:[hair_entry.dye_color]'></span></a>"

/datum/customizer_choice/bodypart_feature/hair/handle_topic(mob/user, list/href_list, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	..()
	var/datum/customizer_entry/hair/hair_entry = entry
	switch(href_list["customizer_task"])
		if("hair_color")
			var/new_color = color_pick_sanitized(user, "Choose your hair color:", "Character Preference", hair_entry.hair_color)
			if(!new_color)
				return
			hair_entry.hair_color = sanitize_hexcolor(new_color, 6, TRUE)
			prefs.clear_hair_cache(customizer_type)
			var/list/colors = hair_colors(hair_entry)
			hair_entry.pix_color = (hair_entry.pix_color in colors) ? hair_entry.pix_color : colors[1]
		if("natural_gradient")
			if(!natgrad)
				return
			var/list/choice_list = hair_gradient_types()
			var/chosen_input = input(user, "Choose your natural gradient:", "Character Preference")  as null|anything in choice_list
			if(!chosen_input)
				return
			hair_entry.natural_gradient = choice_list[chosen_input]
			prefs.clear_hair_cache(customizer_type)
		if("natural_gradient_color")
			if(!natgrad)
				return
			var/new_color = color_pick_sanitized(user, "Choose your natural gradient color:", "Character Preference", hair_entry.natural_color)
			if(!new_color)
				return
			hair_entry.natural_color = sanitize_hexcolor(new_color, 6, TRUE)
			prefs.clear_hair_cache(customizer_type)
		if("dye_gradient")
			if(!dyegrad)
				return
			var/list/choice_list = hair_gradient_types()
			var/chosen_input = input(user, "Choose your dye gradient:", "Character Preference")  as null|anything in choice_list
			if(!chosen_input)
				return
			hair_entry.dye_gradient = choice_list[chosen_input]
			prefs.clear_hair_cache(customizer_type)
		if("dye_gradient_color")
			if(!dyegrad)
				return
			var/new_color = color_pick_sanitized(user, "Choose your dye gradient color:", "Character Preference", hair_entry.dye_color)
			if(!new_color)
				return
			hair_entry.dye_color = sanitize_hexcolor(new_color, 6, TRUE)
			prefs.clear_hair_cache(customizer_type)

/datum/customizer_choice/bodypart_feature/hair/set_accessory_type(datum/preferences/prefs, newtype, datum/customizer_entry/entry)
	var/old_accessory = entry.accessory_type
	..()
	if(old_accessory != entry.accessory_type)
		prefs.clear_hair_cache(entry.customizer_type)
		var/datum/customizer_entry/hair/hair_entry = entry
		hair_clear(hair_entry)
		var/datum/custom_hair_ui/ui = prefs?.hair_uis?[entry.customizer_type]
		if(ui)
			ui.invalidate_entry_caches()
			ui.edit_bands = list()
		var/list/colors = hair_colors(hair_entry)
		hair_entry.pix_color = colors[1]

/datum/customizer_entry/hair
	var/hair_color = "#FFFFFF"
	var/pix_color = "#FFFFFF"
	var/natural_gradient = /datum/hair_gradient/none
	var/natural_color = "#FFFFFF"
	var/dye_gradient = /datum/hair_gradient/none
	var/dye_color = "#FFFFFF"
	var/list/colormasks
	var/custom_mask_version = 0
	var/list/addmasks
	var/list/rmmasks
	var/maskjson
	var/addjson
	var/rmjson

/datum/customizer_entry/hair/facial

/datum/customizer/bodypart_feature/hair/head
	abstract_type = /datum/customizer/bodypart_feature/hair/head
	name = "Hair"

/datum/customizer_choice/bodypart_feature/hair/head
	abstract_type = /datum/customizer_choice/bodypart_feature/hair/head
	name = "Hair"
	feature_type = /datum/bodypart_feature/hair/head

/datum/customizer_choice/bodypart_feature/hair/head/generate_pref_choices(list/dat, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	..()
	var/datum/customizer_entry/hair/hair_entry = entry
	dat += "<br><a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=custom_hair_editor'>Customise</a>"
	if(hairmask_layers_any(hair_entry_masks(hair_entry)))
		dat += " | <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=custom_hair_clear'>Clear</a>"

/datum/customizer_choice/bodypart_feature/hair/head/handle_topic(mob/user, list/href_list, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	if(href_list["customizer_task"] == "custom_hair_editor")
		prefs.open_hair_editor(user, customizer_type)
		return
	if(href_list["customizer_task"] == "custom_hair_clear")
		var/datum/customizer_entry/hair/hair_entry = entry
		hair_clear(hair_entry)
		return
	..()

/datum/preferences
	var/tmp/list/hairprev_cache = list()
	var/tmp/list/hair_uis = list()

/datum/preferences/proc/clear_hair_cache(customizer_type)
	if(!hairprev_cache)
		return
	var/prefix = "[customizer_type]|"
	var/prefix_end = length(prefix) + 1
	var/list/clear_keys = list()
	for(var/cache_key in hairprev_cache)
		if(cache_key == "[customizer_type]" || findtext("[cache_key]", prefix, 1, prefix_end) == 1)
			clear_keys += cache_key
	for(var/cache_key in clear_keys)
		hairprev_cache -= cache_key

/datum/preferences/proc/hair_cache(datum/customizer_entry/hair/hair_entry, cache_key, reuse_cache)
	var/list/cache = reuse_cache ? hairprev_cache[cache_key] : null
	if(hair_band_cache(cache, SOUTH) && hair_band_cache(cache, WEST) && hair_band_cache(cache, NORTH) && hair_band_cache(cache, EAST))
		return cache
	hair_entry_prepare(hair_entry)
	cache = hair_bands(hair_entry)
	if(!cache)
		return null
	hairprev_cache[cache_key] = cache
	return cache

/datum/preferences/proc/open_hair_editor(mob/user, customizer_type)
	if(!user?.client)
		return
	if(!hair_uis)
		hair_uis = list()
	var/key = "[customizer_type]"
	var/datum/custom_hair_ui/ui = hair_uis[key]
	if(QDELETED(ui))
		hair_uis -= key
		ui = null
	if(!ui)
		ui = new(src, customizer_type)
		hair_uis[key] = ui
	ui.ui_interact(user)

/datum/preferences/proc/refresh_hair_windows(mob/user, current_tab)
	if(!user?.client)
		return
	if(current_tab == 0 && winexists(user, "preferences_browser"))
		ShowChoices(user, current_tab)
	if(winexists(user, "customization"))
		ShowCustomizers(user)

/datum/custom_hair_ui
	/// Preferences owner that resolves the active entry and preview cache.
	var/datum/preferences/prefs
	/// Customizer identifier used to fetch the current hair entry.
	var/customizer_type
	/// Direction currently shown and edited by the UI.
	var/active_dir = SOUTH
	/// Tracks whether the editor changed data that needs saving when closed.
	var/dirty = FALSE
	/// Cached edit bounds per direction, keyed by preview dir.
	var/list/edit_bands = list()
	/// Whether mask normalization and legacy add-mask folding already ran this session tick.
	var/masks_ready = FALSE
	/// Whether pix_color has already been snapped to the current palette.
	var/pix_ready = FALSE
	/// Cached palette entries for the current palette key.
	var/list/pal_entries
	/// Cached flat list of palette colours derived from pal_entries.
	var/list/pal_colours
	/// Palette fingerprint used to invalidate cached palette-derived state.
	var/pal_key
	/// Cached UI state for the edited/not-edited directional buttons.
	var/list/dir_states
	/// Direction that active_masks currently represents.
	var/masks_dir
	/// Cached active direction payload sent to TGUI for painting.
	var/list/active_masks

/datum/custom_hair_ui/New(datum/preferences/prefdata, kind)
	prefs = prefdata
	customizer_type = kind

/datum/custom_hair_ui/Destroy(force)
	if(prefs?.hair_uis)
		prefs.hair_uis -= "[customizer_type]"
	prefs = null
	customizer_type = null
	edit_bands = null
	pal_entries = null
	pal_colours = null
	dir_states = null
	active_masks = null
	return ..()

/datum/custom_hair_ui/proc/get_entry()
	if(!prefs)
		return null
	return prefs.get_customizer_entry_for_customizer_type(customizer_type)

/datum/custom_hair_ui/proc/invalidate_entry_caches()
	masks_ready = FALSE
	pix_ready = FALSE
	pal_entries = null
	pal_colours = null
	pal_key = null
	dir_states = null
	masks_dir = null
	active_masks = null

/datum/custom_hair_ui/proc/prepare_entry_masks()
	var/datum/customizer_entry/hair/hair_entry = get_entry()
	if(!hair_entry)
		return null
	if(masks_ready)
		return hair_entry
	hair_entry.colormasks = hair_entry_masks(hair_entry)
	hair_entry.addmasks = null
	hair_entry.rmmasks = null
	masks_ready = TRUE
	return hair_entry

/datum/custom_hair_ui/proc/get_palette_entries()
	var/datum/customizer_entry/hair/hair_entry = get_entry()
	if(!hair_entry)
		return list(list("label" = "Hair", "color" = "#FFFFFF"))
	var/local_key = hair_palette_key(hair_entry)
	if(local_key != pal_key)
		pal_key = local_key
		pal_entries = hair_palette_entries(hair_entry)
		pal_colours = null
		pix_ready = FALSE
	return pal_entries

/datum/custom_hair_ui/proc/get_palette_colours()
	if(!islist(pal_colours))
		var/list/entries = get_palette_entries()
		pal_colours = list()
		for(var/list/entry in entries)
			var/colour = sanitize_hexcolor(entry["color"], 6, TRUE)
			if(colour && !(colour in pal_colours))
				pal_colours += colour
		if(!pal_colours.len)
			pal_colours += "#FFFFFF"
	return pal_colours

/datum/custom_hair_ui/proc/get_direction_states()
	if(islist(dir_states))
		return dir_states
	var/datum/customizer_entry/hair/hair_entry = prepare_entry()
	if(!hair_entry)
		return list()
	dir_states = list()
	for(var/preview_dir in hair_preview_dirs())
		var/edited = !!hairmask_dir_any(hair_entry.colormasks, preview_dir)
		dir_states += list(list(
			"dir" = preview_dir,
			"label" = hair_dir_label(preview_dir),
			"edited" = edited,
		))
	return dir_states

/datum/custom_hair_ui/proc/get_color_masks(preview_dir)
	if(masks_dir == preview_dir && islist(active_masks))
		return active_masks
	var/datum/customizer_entry/hair/hair_entry = prepare_entry()
	if(!hair_entry)
		return list()
	masks_dir = preview_dir
	active_masks = hairmask_dir_data(hair_entry.colormasks, preview_dir) || list()
	return active_masks

/datum/custom_hair_ui/proc/prepare_entry(norm_color = FALSE)
	var/datum/customizer_entry/hair/hair_entry = prepare_entry_masks()
	if(!hair_entry)
		return null
	if(norm_color && !pix_ready)
		hair_entry.pix_color = nearest_palette_colour(hair_entry.pix_color)
		pix_ready = TRUE
	return hair_entry

/datum/custom_hair_ui/proc/nearest_palette_colour(colour)
	var/list/palette = get_palette_colours()
	return hair_nearest_colour(colour, palette)

/datum/custom_hair_ui/proc/get_icons(reuse_cache = TRUE)
	var/datum/customizer_entry/hair/hair_entry = prepare_entry()
	if(!hair_entry || !hair_entry.accessory_type)
		return null
	var/cache_key = hair_cache_key(hair_entry, customizer_type)
	if(!cache_key)
		return null
	return prefs.hair_cache(hair_entry, cache_key, reuse_cache)

/datum/custom_hair_ui/proc/get_guide_icon(preview_dir, list/base_icons = null, mob/user = null)
	if(!hair_dir_valid(preview_dir))
		return null
	if(!base_icons)
		base_icons = get_icons()
	if(!base_icons)
		return null
	var/key = hair_dir_key(preview_dir)
	if(!key)
		return null
	var/url_key = "[key]_url"
	var/asset_key = "[key]_asset"
	if(base_icons[asset_key])
		if(base_icons[url_key])
			if(user?.client)
				SSassets.transport.send_assets(user, base_icons[asset_key])
			return base_icons[url_key]
		var/asset_url = hair_asset_url(base_icons[asset_key], user)
		if(!asset_url)
			return null
		base_icons[url_key] = asset_url
		return asset_url
	queue_guide_icon(preview_dir, base_icons)
	return null

/datum/custom_hair_ui/proc/queue_guide_icon(preview_dir, list/base_icons = null)
	if(!hair_dir_valid(preview_dir))
		return
	if(!base_icons)
		base_icons = get_icons()
	if(!base_icons)
		return
	var/key = hair_dir_key(preview_dir)
	if(!key)
		return
	var/pending_key = "[key]_pending"
	if(base_icons["[key]_asset"] || base_icons[pending_key])
		return
	base_icons[pending_key] = TRUE
	INVOKE_ASYNC(src, PROC_REF(build_guide_icon), preview_dir)

/datum/custom_hair_ui/proc/build_guide_icon(preview_dir)
	var/key = hair_dir_key(preview_dir)
	var/list/base_icons = (hair_dir_valid(preview_dir) && prefs) ? get_icons() : null
	if(!key || !base_icons)
		return
	var/pending_key = "[key]_pending"
	var/asset_key = "[key]_asset"
	var/url_key = "[key]_url"
	if(base_icons[asset_key])
		base_icons -= pending_key
		SStgui.update_uis(src)
		return
	var/datum/customizer_entry/hair/hair_entry = prepare_entry()
	if(!hair_entry)
		base_icons -= pending_key
		return
	hair_entry_prepare(hair_entry)
	var/list/saved_colormasks = hair_entry.colormasks
	var/list/saved_remove = hair_entry.rmmasks
	hair_entry.colormasks = null
	hair_entry.rmmasks = null
	var/mob/living/carbon/human/dummy/mannequin = generate_or_wait_for_human_dummy(DUMMY_HUMAN_SLOT_PREFERENCES)
	var/icon/cached_icon
	if(mannequin)
		prefs.copy_to(mannequin, 1, TRUE, TRUE)
		cached_icon = hair_preview_icon(mannequin, preview_dir)
		unset_busy_human_dummy(DUMMY_HUMAN_SLOT_PREFERENCES)
	hair_entry.colormasks = saved_colormasks
	hair_entry.rmmasks = saved_remove
	if(cached_icon)
		base_icons[asset_key] = hair_asset(cached_icon)
		base_icons[url_key] = hair_asset_url(base_icons[asset_key])
	base_icons -= pending_key
	SStgui.update_uis(src)

/datum/custom_hair_ui/proc/get_edit_band(preview_dir, list/base_icons = null)
	if(!hair_dir_valid(preview_dir))
		return null
	var/key = "[preview_dir]"
	var/list/edit_band = edit_bands?[key]
	if(edit_band)
		return edit_band
	if(!base_icons)
		base_icons = get_icons()
	if(!base_icons)
		return null
	edit_band = hair_edit_band(hair_band_cache(base_icons, preview_dir))
	if(!edit_bands)
		edit_bands = list()
	edit_bands[key] = edit_band
	return edit_band

/datum/custom_hair_ui/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "HairEditor", "Custom Hair")
		ui.open()

/datum/custom_hair_ui/ui_state(mob/user)
	return GLOB.tgui_always_state

/datum/custom_hair_ui/ui_static_data(mob/user)
	var/datum/customizer_entry/hair/hair_entry = prepare_entry(TRUE)
	if(!hair_entry || !hair_entry.accessory_type)
		return list("ready" = FALSE)
	var/list/base_icons = get_icons()
	if(!base_icons)
		return list("ready" = FALSE)
	var/list/direction_icons = list()
	for(var/preview_dir in hair_preview_dirs())
		var/list/edit_band = get_edit_band(preview_dir, base_icons)
		if(!edit_band)
			return list("ready" = FALSE)
		direction_icons += list(list(
			"dir" = preview_dir,
			"label" = hair_dir_label(preview_dir),
			"icon" = (preview_dir == active_dir) ? get_guide_icon(preview_dir, base_icons, user) : null,
			"editMinX" = edit_band["minX"],
			"editMaxX" = edit_band["maxX"],
			"editMinY" = edit_band["minY"],
			"editMaxY" = edit_band["maxY"],
		))
	return list(
		"ready" = TRUE,
		"baseColor" = hair_entry.hair_color,
		"directionIcons" = direction_icons,
	)

/datum/custom_hair_ui/ui_data(mob/user)
	var/datum/customizer_entry/hair/hair_entry = prepare_entry(TRUE)
	if(!hair_entry || !hair_entry.accessory_type)
		return list("ready" = FALSE)
	return list(
		"ready" = TRUE,
		"activeDir" = active_dir,
		"activeLabel" = hair_dir_label(active_dir),
		"baseColor" = hair_entry.hair_color,
		"palette" = get_palette_entries(),
		"paintColor" = hair_entry.pix_color,
		"activeGuideIcon" = get_guide_icon(active_dir, user = user),
		"activeColorMasks" = get_color_masks(active_dir),
		"directions" = get_direction_states(),
	)

/datum/custom_hair_ui/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE
	var/datum/customizer_entry/hair/hair_entry = prepare_entry(TRUE)
	if(!hair_entry)
		return TRUE
	var/dir = text2num(params["dir"])
	if(!hair_dir_valid(dir))
		dir = active_dir
	switch(action)
		if("set_dir")
			active_dir = dir
			return TRUE
		if("set_color")
			hair_entry.pix_color = nearest_palette_colour(params["color"])
			pix_ready = TRUE
			return TRUE
		if("clear")
			hair_clear(hair_entry)
			invalidate_entry_caches()
			prepare_entry(TRUE)
			dirty = TRUE
			return TRUE
		if("plot_commit")
			var/list/base_icons = get_icons()
			if(!base_icons)
				return TRUE
			var/list/edit_band = get_edit_band(dir, base_icons)
			if(!edit_band)
				return TRUE
			var/list/dir_layers = list()
			var/list/color_masks = params["colorMasks"]
			if(islist(color_masks))
				for(var/list/layer in color_masks)
					if(!islist(layer))
						continue
					var/color = nearest_palette_colour(layer["color"])
					var/mask = hairmask_crop_y(layer["mask"], edit_band["minY"], edit_band["maxY"])
					if(!color || !mask)
						continue
					dir_layers += list(list(
						"color" = color,
						"mask" = mask,
					))
			active_dir = dir
			var/list/next_colormasks = hairmask_dir_replace(hair_entry.colormasks, dir, dir_layers)
			if(next_colormasks != hair_entry.colormasks)
				hair_entry.custom_mask_version++
			hair_entry.colormasks = next_colormasks
			hair_entry.rmmasks = null
			invalidate_entry_caches()
			prepare_entry(TRUE)
			dirty = TRUE
			return TRUE
		if("close")
			if(ui)
				ui.close()
			else
				qdel(src)
			return TRUE
	return FALSE

/datum/custom_hair_ui/ui_close(mob/user)
	. = ..()
	if(!prefs || !dirty || !user?.client)
		QDEL_IN(src, 1)
		return
	var/datum/preferences/local_prefs = prefs
	var/current_tab = local_prefs.current_tab
	INVOKE_ASYNC(local_prefs, TYPE_PROC_REF(/datum/preferences, refresh_hair_windows), user, current_tab)
	QDEL_IN(src, 1)

/datum/customizer/bodypart_feature/hair/facial
	abstract_type = /datum/customizer/bodypart_feature/hair/facial
	name = "Facial Hair"

/datum/customizer/bodypart_feature/hair/facial/is_allowed(datum/preferences/prefs)
	return (prefs.gender == MALE)

/datum/customizer_choice/bodypart_feature/hair/facial
	abstract_type = /datum/customizer_choice/bodypart_feature/hair/facial
	name = "Facial Hair"
	feature_type = /datum/bodypart_feature/hair/facial
	customizer_entry_type = /datum/customizer_entry/hair/facial

/datum/customizer/bodypart_feature/hair/head/humanoid
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)

/datum/customizer_choice/bodypart_feature/hair/head/humanoid
	sprite_accessories = list(
		/datum/sprite_accessory/hair/head/bald,
		/datum/sprite_accessory/hair/head/shorthaireighties,
		/datum/sprite_accessory/hair/head/shorthaireighties_alt,
		/datum/sprite_accessory/hair/head/afro,
		/datum/sprite_accessory/hair/head/afro2,
		/datum/sprite_accessory/hair/head/afro_large,
		/datum/sprite_accessory/hair/head/astolfo,
		/datum/sprite_accessory/hair/head/antenna,
		/datum/sprite_accessory/hair/head/balding,
		/datum/sprite_accessory/hair/head/bedhead,
		/datum/sprite_accessory/hair/head/bedhead2,
		/datum/sprite_accessory/hair/head/bedhead3,
		/datum/sprite_accessory/hair/head/bedheadlong,
		/datum/sprite_accessory/hair/head/badlycut,
		/datum/sprite_accessory/hair/head/beehive,
		/datum/sprite_accessory/hair/head/beehive2,
		/datum/sprite_accessory/hair/head/bob,
		/datum/sprite_accessory/hair/head/bob2,
		/datum/sprite_accessory/hair/head/bob3,
		/datum/sprite_accessory/hair/head/bob4,
		/datum/sprite_accessory/hair/head/bobcurl,
		/datum/sprite_accessory/hair/head/boddicker,
		/datum/sprite_accessory/hair/head/bowlcut,
		/datum/sprite_accessory/hair/head/bowlcut2,
		/datum/sprite_accessory/hair/head/braid,
		/datum/sprite_accessory/hair/head/front_braid,
		/datum/sprite_accessory/hair/head/not_floorlength_braid,
		/datum/sprite_accessory/hair/head/lowbraid,
		/datum/sprite_accessory/hair/head/shortbraid,
		/datum/sprite_accessory/hair/head/braided,
	    /datum/sprite_accessory/hair/head/braided_sidetail,
		/datum/sprite_accessory/hair/head/braidtail,
		/datum/sprite_accessory/hair/head/bun,
		/datum/sprite_accessory/hair/head/bun2,
		/datum/sprite_accessory/hair/head/bun3,
		/datum/sprite_accessory/hair/head/lowbun,
		/datum/sprite_accessory/hair/head/largebun,
		/datum/sprite_accessory/hair/head/manbun,
		/datum/sprite_accessory/hair/head/tightbun,
		/datum/sprite_accessory/hair/head/business,
		/datum/sprite_accessory/hair/head/business2,
		/datum/sprite_accessory/hair/head/business3,
		/datum/sprite_accessory/hair/head/business4,
		/datum/sprite_accessory/hair/head/buzz,
		/datum/sprite_accessory/hair/head/cia,
		/datum/sprite_accessory/hair/head/coffeehouse,
		/datum/sprite_accessory/hair/head/combover,
		/datum/sprite_accessory/hair/head/comet,
		/datum/sprite_accessory/hair/head/cornrows1,
		/datum/sprite_accessory/hair/head/cornrows2,
		/datum/sprite_accessory/hair/head/cornrowbraid,
		/datum/sprite_accessory/hair/head/cornrowbun,
		/datum/sprite_accessory/hair/head/cornrowdualtail,
		/datum/sprite_accessory/hair/head/crew,
		/datum/sprite_accessory/hair/head/cut,
		/datum/sprite_accessory/hair/head/dandpompadour,
		/datum/sprite_accessory/hair/head/devillock,
		/datum/sprite_accessory/hair/head/doublebun,
		/datum/sprite_accessory/hair/head/dreadlocks,
		/datum/sprite_accessory/hair/head/drillhair,
		/datum/sprite_accessory/hair/head/drillhairextended,
		/datum/sprite_accessory/hair/head/emo,
		/datum/sprite_accessory/hair/head/emo2,
		/datum/sprite_accessory/hair/head/emofringe,
		/datum/sprite_accessory/hair/head/longemo,
		/datum/sprite_accessory/hair/head/nofade,
		/datum/sprite_accessory/hair/head/lowfade,
		/datum/sprite_accessory/hair/head/medfade,
		/datum/sprite_accessory/hair/head/highfade,
		/datum/sprite_accessory/hair/head/baldfade,
		/datum/sprite_accessory/hair/head/father,
		/datum/sprite_accessory/hair/head/feather,
		/datum/sprite_accessory/hair/head/flair,
		/datum/sprite_accessory/hair/head/flattop,
		/datum/sprite_accessory/hair/head/flattop_big,
		/datum/sprite_accessory/hair/head/flow_hair,
		/datum/sprite_accessory/hair/head/gelled,
		/datum/sprite_accessory/hair/head/gentle,
		/datum/sprite_accessory/hair/head/halfbang,
		/datum/sprite_accessory/hair/head/halfbang2,
		/datum/sprite_accessory/hair/head/halfshaved,
		/datum/sprite_accessory/hair/head/hedgehog,
		/datum/sprite_accessory/hair/head/himecut,
		/datum/sprite_accessory/hair/head/himecut2,
		/datum/sprite_accessory/hair/head/shorthime,
		/datum/sprite_accessory/hair/head/himeup,
		/datum/sprite_accessory/hair/head/hitop,
		/datum/sprite_accessory/hair/head/jade,
		/datum/sprite_accessory/hair/head/jensen,
		/datum/sprite_accessory/hair/head/joestar,
		/datum/sprite_accessory/hair/head/keanu,
		/datum/sprite_accessory/hair/head/kusangi,
		/datum/sprite_accessory/hair/head/long,
		/datum/sprite_accessory/hair/head/long2,
		/datum/sprite_accessory/hair/head/long3,
		/datum/sprite_accessory/hair/head/long_over_eye,
		/datum/sprite_accessory/hair/head/longbangs,
		/datum/sprite_accessory/hair/head/longfringe,
		/datum/sprite_accessory/hair/head/sidepartlongalt,
		/datum/sprite_accessory/hair/head/megaeyebrows,
		/datum/sprite_accessory/hair/head/messy,
		/datum/sprite_accessory/hair/head/modern,
		/datum/sprite_accessory/hair/head/modern2,
		/datum/sprite_accessory/hair/head/mohawk,
		/datum/sprite_accessory/hair/head/reversemohawk,
		/datum/sprite_accessory/hair/head/shavedmohawk,
		/datum/sprite_accessory/hair/head/unshavenmohawk,
		/datum/sprite_accessory/hair/head/mulder,
		/datum/sprite_accessory/hair/head/nitori,
		/datum/sprite_accessory/hair/head/newyou,
		/datum/sprite_accessory/hair/head/odango,
		/datum/sprite_accessory/hair/head/ombre,
		/datum/sprite_accessory/hair/head/oneshoulder,
		/datum/sprite_accessory/hair/head/over_eye,
		/datum/sprite_accessory/hair/head/oxton,
		/datum/sprite_accessory/hair/head/parted,
		/datum/sprite_accessory/hair/head/partedside,
		/datum/sprite_accessory/hair/head/pigtails,
		/datum/sprite_accessory/hair/head/pigtails2,
		/datum/sprite_accessory/hair/head/pigtails3,
		/datum/sprite_accessory/hair/head/kagami,
		/datum/sprite_accessory/hair/head/pixie,
		/datum/sprite_accessory/hair/head/pompadour,
		/datum/sprite_accessory/hair/head/bigpompadour,
		/datum/sprite_accessory/hair/head/ponytail1,
		/datum/sprite_accessory/hair/head/ponytail2,
		/datum/sprite_accessory/hair/head/ponytail3,
		/datum/sprite_accessory/hair/head/ponytail4,
		/datum/sprite_accessory/hair/head/ponytail5,
		/datum/sprite_accessory/hair/head/ponytail6,
		/datum/sprite_accessory/hair/head/ponytail7,
		/datum/sprite_accessory/hair/head/ponytail8,
		/datum/sprite_accessory/hair/head/highponytail,
		/datum/sprite_accessory/hair/head/longponytail,
		/datum/sprite_accessory/hair/head/stail,
		/datum/sprite_accessory/hair/head/countryponytail,
		/datum/sprite_accessory/hair/head/fringetail,
		/datum/sprite_accessory/hair/head/sidetail,
		/datum/sprite_accessory/hair/head/sidetail2,
		/datum/sprite_accessory/hair/head/sidetail3,
		/datum/sprite_accessory/hair/head/sidetail4,
		/datum/sprite_accessory/hair/head/spikyponytail,
		/datum/sprite_accessory/hair/head/poofy,
		/datum/sprite_accessory/hair/head/quiff,
		/datum/sprite_accessory/hair/head/ronin,
		/datum/sprite_accessory/hair/head/shaved,
		/datum/sprite_accessory/hair/head/shavedpart,
		/datum/sprite_accessory/hair/head/shortbangs,
		/datum/sprite_accessory/hair/head/short,
		/datum/sprite_accessory/hair/head/shorthair2,
		/datum/sprite_accessory/hair/head/shorthair3,
		/datum/sprite_accessory/hair/head/shorthair6,
		/datum/sprite_accessory/hair/head/shorthair7,
		/datum/sprite_accessory/hair/head/rosa,
		/datum/sprite_accessory/hair/head/shoulderlength,
		/datum/sprite_accessory/hair/head/sidecut,
		/datum/sprite_accessory/hair/head/skinhead,
		/datum/sprite_accessory/hair/head/protagonist,
		/datum/sprite_accessory/hair/head/spiky,
		/datum/sprite_accessory/hair/head/spiky2,
		/datum/sprite_accessory/hair/head/spiky3,
		/datum/sprite_accessory/hair/head/swept,
		/datum/sprite_accessory/hair/head/swept2,
		/datum/sprite_accessory/hair/head/thinning,
		/datum/sprite_accessory/hair/head/thinningfront,
		/datum/sprite_accessory/hair/head/thinningrear,
		/datum/sprite_accessory/hair/head/topknot,
		/datum/sprite_accessory/hair/head/tressshoulder,
		/datum/sprite_accessory/hair/head/trimmed,
		/datum/sprite_accessory/hair/head/trimflat,
		/datum/sprite_accessory/hair/head/twintails,
		/datum/sprite_accessory/hair/head/undercut,
		/datum/sprite_accessory/hair/head/undercutleft,
		/datum/sprite_accessory/hair/head/undercutright,
		/datum/sprite_accessory/hair/head/unkept,
		/datum/sprite_accessory/hair/head/updo,
		/datum/sprite_accessory/hair/head/longer,
		/datum/sprite_accessory/hair/head/longest,
		/datum/sprite_accessory/hair/head/longest2,
		/datum/sprite_accessory/hair/head/veryshortovereye,
		/datum/sprite_accessory/hair/head/longestalt,
		/datum/sprite_accessory/hair/head/volaju,
		/datum/sprite_accessory/hair/head/wisp,
		/datum/sprite_accessory/hair/head/hyenamane,
		/datum/sprite_accessory/hair/head/forelock,
		/datum/sprite_accessory/hair/head/pirate,
		/datum/sprite_accessory/hair/head/shavedmohawk,
		/datum/sprite_accessory/hair/head/baldfade,
		/datum/sprite_accessory/hair/head/rogue,
		/datum/sprite_accessory/hair/head/romantic,
		/datum/sprite_accessory/hair/head/runt,
		/datum/sprite_accessory/hair/head/son,
		/datum/sprite_accessory/hair/head/bog,
		/datum/sprite_accessory/hair/head/scout,
		/datum/sprite_accessory/hair/head/son2,
		/datum/sprite_accessory/hair/head/long4,
		/datum/sprite_accessory/hair/head/amazon,
		/datum/sprite_accessory/hair/head/longstraightponytail,
		/datum/sprite_accessory/hair/head/barmaid,
		/datum/sprite_accessory/hair/head/bob_rt,
		/datum/sprite_accessory/hair/head/messy_rt,
		/datum/sprite_accessory/hair/head/homely,
		/datum/sprite_accessory/hair/head/longtails,
		/datum/sprite_accessory/hair/head/hime,
		/datum/sprite_accessory/hair/head/tied,
		/datum/sprite_accessory/hair/head/tied2,
		/datum/sprite_accessory/hair/head/fatherless,
		/datum/sprite_accessory/hair/head/fatherless2,
		/datum/sprite_accessory/hair/head/kepthair,
		/datum/sprite_accessory/hair/head/singlebraid,
		/datum/sprite_accessory/hair/head/gloomy,
		/datum/sprite_accessory/hair/head/gloomylong,
		/datum/sprite_accessory/hair/head/shortmessy,
		/datum/sprite_accessory/hair/head/mediumessy,
		/datum/sprite_accessory/hair/head/zone,
		/datum/sprite_accessory/hair/head/inari,
		/datum/sprite_accessory/hair/head/ziegler,
		/datum/sprite_accessory/hair/head/gronnbraid,
		/datum/sprite_accessory/hair/head/grenzelcut,
		/datum/sprite_accessory/hair/head/fluffy,
		/datum/sprite_accessory/hair/head/fluffyshort,
		/datum/sprite_accessory/hair/head/fluffylong,
		/datum/sprite_accessory/hair/head/jay,
		/datum/sprite_accessory/hair/head/hairfre,
		/datum/sprite_accessory/hair/head/dawn,
		/datum/sprite_accessory/hair/head/morning,
		/datum/sprite_accessory/hair/head/kobeni_1,
		/datum/sprite_accessory/hair/head/kobeni_2,
		/datum/sprite_accessory/hair/head/kobeni_tail,
		/datum/sprite_accessory/hair/head/gloomy_short,
		/datum/sprite_accessory/hair/head/gloomy_medium,
		/datum/sprite_accessory/hair/head/gloomy_long,
		/datum/sprite_accessory/hair/head/emo_long,
		/datum/sprite_accessory/hair/head/twintail_floor,
		/datum/sprite_accessory/hair/head/sideways_ponytail,
		/datum/sprite_accessory/hair/head/dreadlocks_long,
		/datum/sprite_accessory/hair/head/rows1,
		/datum/sprite_accessory/hair/head/rows2,
		/datum/sprite_accessory/hair/head/rowbraid,
		/datum/sprite_accessory/hair/head/rowdualtail,
		/datum/sprite_accessory/hair/head/rowbun,
		/datum/sprite_accessory/hair/head/long_over_eye_alt,
		/datum/sprite_accessory/hair/head/diagonalbangs,
		/datum/sprite_accessory/hair/head/sabitsuki,
		/datum/sprite_accessory/hair/head/sabitsuki_ponytail,
		/datum/sprite_accessory/hair/head/cotton,
		/datum/sprite_accessory/hair/head/cottonalt,
		/datum/sprite_accessory/hair/head/bushy,
		/datum/sprite_accessory/hair/head/bushy_alt,
		/datum/sprite_accessory/hair/head/curtains,
		/datum/sprite_accessory/hair/head/glamourh,
		/datum/sprite_accessory/hair/head/emma,
		/datum/sprite_accessory/hair/head/damsel,
		/datum/sprite_accessory/hair/head/wavylong,
		/datum/sprite_accessory/hair/head/wavyovereye,
		/datum/sprite_accessory/hair/head/straightovereye,
		/datum/sprite_accessory/hair/head/straightside,
		/datum/sprite_accessory/hair/head/straightshort,
		/datum/sprite_accessory/hair/head/straightlong,
		/datum/sprite_accessory/hair/head/fluffball,
		/datum/sprite_accessory/hair/head/halfshave_long,
		/datum/sprite_accessory/hair/head/halfshave_long_alt,
		/datum/sprite_accessory/hair/head/halfshave_messy,
		/datum/sprite_accessory/hair/head/halfshave_messylong,
		/datum/sprite_accessory/hair/head/halfshave_messy_alt,
		/datum/sprite_accessory/hair/head/halfshave_messylong_alt,
		/datum/sprite_accessory/hair/head/halfshave_glamorous,
		/datum/sprite_accessory/hair/head/halfshave_glamorous_alt,
		/datum/sprite_accessory/hair/head/thicklong,
		/datum/sprite_accessory/hair/head/thickshort,
		/datum/sprite_accessory/hair/head/thickcurly,
		/datum/sprite_accessory/hair/head/thicklong_alt,
		/datum/sprite_accessory/hair/head/baum,
		/datum/sprite_accessory/hair/head/mcsqueeb,
		/datum/sprite_accessory/hair/head/highlander,
		/datum/sprite_accessory/hair/head/royalcurls,
		/datum/sprite_accessory/hair/head/dreadlocksmessy,
		/datum/sprite_accessory/hair/head/suave,
		/datum/sprite_accessory/hair/head/dave,
		/datum/sprite_accessory/hair/head/mediumbraid,
		/datum/sprite_accessory/hair/head/countryponytailalt,
		/datum/sprite_accessory/hair/head/ponytailwitcher,
		/datum/sprite_accessory/hair/head/spicy,
		/datum/sprite_accessory/hair/head/stacy,
		/datum/sprite_accessory/hair/head/stacybun,
		/datum/sprite_accessory/hair/head/zoey,
		/datum/sprite_accessory/hair/head/kusanagi_alt,
		/datum/sprite_accessory/hair/head/bubblebraids,
		/datum/sprite_accessory/hair/head/bubblebraids_v2,
		/datum/sprite_accessory/hair/head/heiress,
		/datum/sprite_accessory/hair/head/longbraids,
		/datum/sprite_accessory/hair/head/knots,
		/datum/sprite_accessory/hair/head/mediumlocs,
		/datum/sprite_accessory/hair/head/shortlocs,
		/datum/sprite_accessory/hair/head/poofycurls,
		/datum/sprite_accessory/hair/head/messylocs,
		/datum/sprite_accessory/hair/head/dualtwists,
		/datum/sprite_accessory/hair/head/twistbun,
		/datum/sprite_accessory/hair/head/kandake,
		/datum/sprite_accessory/hair/head/sidebraid,
		/datum/sprite_accessory/hair/head/playful,
		/datum/sprite_accessory/hair/head/adventurer,
		/datum/sprite_accessory/hair/head/amazon_f,
		/datum/sprite_accessory/hair/head/archivist,
		/datum/sprite_accessory/hair/head/barbarian_f,
		/datum/sprite_accessory/hair/head/beartails_f,
		/datum/sprite_accessory/hair/head/berserker,
		/datum/sprite_accessory/hair/head/bob_f,
		/datum/sprite_accessory/hair/head/boss,
		/datum/sprite_accessory/hair/head/buns_f,
		/datum/sprite_accessory/hair/head/cavehead,
		/datum/sprite_accessory/hair/head/conscript,
		/datum/sprite_accessory/hair/head/courtier,
		/datum/sprite_accessory/hair/head/curly_f,
		/datum/sprite_accessory/hair/head/darkknight,
		/datum/sprite_accessory/hair/head/dome,
		/datum/sprite_accessory/hair/head/druid,
		/datum/sprite_accessory/hair/head/empress_f,
		/datum/sprite_accessory/hair/head/fancy_elf,
		/datum/sprite_accessory/hair/head/fancy_elf_f,
		/datum/sprite_accessory/hair/head/forester,
		/datum/sprite_accessory/hair/head/foreigner,
		/datum/sprite_accessory/hair/head/forged,
		/datum/sprite_accessory/hair/head/forsaken,
		/datum/sprite_accessory/hair/head/grumpy_f,
		/datum/sprite_accessory/hair/head/gnomish_f,
		/datum/sprite_accessory/hair/head/graceful,
		/datum/sprite_accessory/hair/head/heroic,
		/datum/sprite_accessory/hair/head/hearth_f,
		/datum/sprite_accessory/hair/head/hunter,
		/datum/sprite_accessory/hair/head/homely_f,
		/datum/sprite_accessory/hair/head/junia_tief_f,
		/datum/sprite_accessory/hair/head/lady_f,
		/datum/sprite_accessory/hair/head/landlord,
		/datum/sprite_accessory/hair/head/lion,
		/datum/sprite_accessory/hair/head/loosebraid_f,
		/datum/sprite_accessory/hair/head/lover_tief_m,
		/datum/sprite_accessory/hair/head/maid_f,
		/datum/sprite_accessory/hair/head/maiden_f,
		/datum/sprite_accessory/hair/head/martial,
		/datum/sprite_accessory/hair/head/majestic,
		/datum/sprite_accessory/hair/head/majestic_dwarf,
		/datum/sprite_accessory/hair/head/majestic_elf,
		/datum/sprite_accessory/hair/head/majestic_f,
		/datum/sprite_accessory/hair/head/messy_f,
		/datum/sprite_accessory/hair/head/monk,
		/datum/sprite_accessory/hair/head/miner,
		/datum/sprite_accessory/hair/head/mystery_f,
		/datum/sprite_accessory/hair/head/mysterious_elf,
		/datum/sprite_accessory/hair/head/nobility,
		/datum/sprite_accessory/hair/head/noblesse_f,
		/datum/sprite_accessory/hair/head/nomadic,
		/datum/sprite_accessory/hair/head/orc_f,
		/datum/sprite_accessory/hair/head/performer_tief_f,
		/datum/sprite_accessory/hair/head/plain_f,
		/datum/sprite_accessory/hair/head/princely,
		/datum/sprite_accessory/hair/head/pixie_f,
		/datum/sprite_accessory/hair/head/scribe,
		/datum/sprite_accessory/hair/head/soilbride_f,
		/datum/sprite_accessory/hair/head/shrine_f,
		/datum/sprite_accessory/hair/head/southern,
		/datum/sprite_accessory/hair/head/swain,
		/datum/sprite_accessory/hair/head/squire_f,
		/datum/sprite_accessory/hair/head/squire,
		/datum/sprite_accessory/hair/head/tails_f,
		/datum/sprite_accessory/hair/head/troubadour,
		/datum/sprite_accessory/hair/head/tiedlong,
		/datum/sprite_accessory/hair/head/tsidecut,
		/datum/sprite_accessory/hair/head/tied_f,
		/datum/sprite_accessory/hair/head/tiedup_f,
		/datum/sprite_accessory/hair/head/updo_f,
		/datum/sprite_accessory/hair/head/warrior,
		/datum/sprite_accessory/hair/head/wisp_f,
		/datum/sprite_accessory/hair/head/wildside,
		/datum/sprite_accessory/hair/head/woodsman_elf,
		/datum/sprite_accessory/hair/head/queenly_f,
		/datum/sprite_accessory/hair/head/zybantu,
		/datum/sprite_accessory/hair/head/chair_ponytail6,
		/datum/sprite_accessory/hair/head/chair_manbun,
		/datum/sprite_accessory/hair/head/fatherless_elf_f,
		/datum/sprite_accessory/hair/head/samurai,
		/datum/sprite_accessory/hair/head/yakuza,
		/datum/sprite_accessory/hair/head/novice,
		/datum/sprite_accessory/hair/head/steppeman,
		/datum/sprite_accessory/hair/head/bishonen,
		/datum/sprite_accessory/hair/head/emperor,
		/datum/sprite_accessory/hair/head/female,
		/datum/sprite_accessory/hair/head/empress,
		/datum/sprite_accessory/hair/head/warlady,
		/datum/sprite_accessory/hair/head/waterfield,
		/datum/sprite_accessory/hair/head/homewaifu,
		/datum/sprite_accessory/hair/head/casual,
		/datum/sprite_accessory/hair/head/martyr,
		/datum/sprite_accessory/hair/head/neuter,
		/datum/sprite_accessory/hair/head/hprotagonist,
		/datum/sprite_accessory/hair/head/alsoprotagonist,
		/datum/sprite_accessory/hair/head/ghast,
		/datum/sprite_accessory/hair/head/scruffy,
		)

/datum/customizer_choice/bodypart_feature/hair/head/humanoid/get_random_accessory(datum/customizer_entry/entry, datum/preferences/prefs)
	return pick(sprite_accessories)

/datum/customizer_choice/bodypart_feature/hair/head/humanoid/on_randomize_entry(datum/customizer_entry/entry, datum/preferences/prefs)
	var/datum/customizer_entry/hair/hair_entry = entry
	var/color = pick(HAIR_COLOR_LIST)
	hair_entry.hair_color = color

/datum/customizer/bodypart_feature/hair/head/humanoid/bald_default
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/hair/head/humanoid/bald_default)

/datum/customizer_choice/bodypart_feature/hair/head/humanoid/bald_default/get_random_accessory(datum/customizer_entry/entry, datum/preferences/prefs)
	return /datum/sprite_accessory/hair/head/bald

/datum/customizer/bodypart_feature/hair/facial/humanoid
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/hair/facial/humanoid)

/datum/customizer_choice/bodypart_feature/hair/facial/humanoid
	sprite_accessories = list(
		/datum/sprite_accessory/hair/facial/shaved,
		/datum/sprite_accessory/hair/facial/abe,
		/datum/sprite_accessory/hair/facial/brokenman,
		/datum/sprite_accessory/hair/facial/chinstrap,
		/datum/sprite_accessory/hair/facial/dwarf,
		/datum/sprite_accessory/hair/facial/fullbeard,
		/datum/sprite_accessory/hair/facial/croppedfullbeard,
		/datum/sprite_accessory/hair/facial/gt,
		/datum/sprite_accessory/hair/facial/hip,
		/datum/sprite_accessory/hair/facial/jensen,
		/datum/sprite_accessory/hair/facial/neckbeard,
		/datum/sprite_accessory/hair/facial/vlongbeard,
		/datum/sprite_accessory/hair/facial/muttonmus,
		/datum/sprite_accessory/hair/facial/martialartist,
		/datum/sprite_accessory/hair/facial/chinlessbeard,
		/datum/sprite_accessory/hair/facial/moonshiner,
		/datum/sprite_accessory/hair/facial/longbeard,
		/datum/sprite_accessory/hair/facial/volaju,
		/datum/sprite_accessory/hair/facial/threeoclock,
		/datum/sprite_accessory/hair/facial/fiveoclock,
		/datum/sprite_accessory/hair/facial/sevenoclock,
		/datum/sprite_accessory/hair/facial/sevenoclockm,
		/datum/sprite_accessory/hair/facial/stubble,
		/datum/sprite_accessory/hair/facial/pipe,
		/datum/sprite_accessory/hair/facial/knightly,
		/datum/sprite_accessory/hair/facial/manly,
		/datum/sprite_accessory/hair/facial/viking,
		/datum/sprite_accessory/hair/facial/moustache,
		/datum/sprite_accessory/hair/facial/fiveoclockmoustache,
		/datum/sprite_accessory/hair/facial/pencilstache,
		/datum/sprite_accessory/hair/facial/smallstache,
		/datum/sprite_accessory/hair/facial/walrus,
		/datum/sprite_accessory/hair/facial/fu,
		/datum/sprite_accessory/hair/facial/hogan,
		/datum/sprite_accessory/hair/facial/selleck,
		/datum/sprite_accessory/hair/facial/chaplin,
		/datum/sprite_accessory/hair/facial/vandyke,
		/datum/sprite_accessory/hair/facial/watson,
		/datum/sprite_accessory/hair/facial/sideburn,
		/datum/sprite_accessory/hair/facial/burns,
		/datum/sprite_accessory/hair/facial/elvis,
		/datum/sprite_accessory/hair/facial/mutton,
		)

/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/get_random_accessory(datum/customizer_entry/entry, datum/preferences/prefs)
	if(prefs.gender == MALE)
		return pick(sprite_accessories)
	else
		return /datum/sprite_accessory/hair/facial/shaved

/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/on_randomize_entry(datum/customizer_entry/entry, datum/preferences/prefs)
	var/datum/customizer_entry/hair/hair_entry = entry
	var/color = pick(HAIR_COLOR_LIST)
	hair_entry.hair_color = color

/datum/customizer/bodypart_feature/hair/facial/humanoid/shaved_default
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/shaved_default)

/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/shaved_default/get_random_accessory(datum/customizer_entry/entry, datum/preferences/prefs)
	return /datum/sprite_accessory/hair/facial/shaved

/datum/customizer/bodypart_feature/hair/head/humanoid/vulpkian
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/hair/head/humanoid/vulpkian)

/datum/customizer_choice/bodypart_feature/hair/head/humanoid/vulpkian
	sprite_accessories = list(
		/datum/sprite_accessory/hair/head/bald,
		/datum/sprite_accessory/hair/head/shorthaireighties,
		/datum/sprite_accessory/hair/head/shorthaireighties_alt,
		/datum/sprite_accessory/hair/head/afro,
		/datum/sprite_accessory/hair/head/afro2,
		/datum/sprite_accessory/hair/head/afro_large,
		/datum/sprite_accessory/hair/head/antenna,
		/datum/sprite_accessory/hair/head/balding,
		/datum/sprite_accessory/hair/head/bedhead,
		/datum/sprite_accessory/hair/head/bedhead2,
		/datum/sprite_accessory/hair/head/bedhead3,
		/datum/sprite_accessory/hair/head/bedheadlong,
		/datum/sprite_accessory/hair/head/badlycut,
		/datum/sprite_accessory/hair/head/beehive,
		/datum/sprite_accessory/hair/head/beehive2,
		/datum/sprite_accessory/hair/head/bob,
		/datum/sprite_accessory/hair/head/bob2,
		/datum/sprite_accessory/hair/head/bob3,
		/datum/sprite_accessory/hair/head/bob4,
		/datum/sprite_accessory/hair/head/bobcurl,
		/datum/sprite_accessory/hair/head/boddicker,
		/datum/sprite_accessory/hair/head/bowlcut,
		/datum/sprite_accessory/hair/head/bowlcut2,
		/datum/sprite_accessory/hair/head/braid,
		/datum/sprite_accessory/hair/head/front_braid,
		/datum/sprite_accessory/hair/head/not_floorlength_braid,
		/datum/sprite_accessory/hair/head/lowbraid,
		/datum/sprite_accessory/hair/head/shortbraid,
		/datum/sprite_accessory/hair/head/braided,
		/datum/sprite_accessory/hair/head/braidtail,
		/datum/sprite_accessory/hair/head/bun,
		/datum/sprite_accessory/hair/head/bun2,
		/datum/sprite_accessory/hair/head/bun3,
		/datum/sprite_accessory/hair/head/lowbun,
		/datum/sprite_accessory/hair/head/largebun,
		/datum/sprite_accessory/hair/head/manbun,
		/datum/sprite_accessory/hair/head/tightbun,
		/datum/sprite_accessory/hair/head/business,
		/datum/sprite_accessory/hair/head/business2,
		/datum/sprite_accessory/hair/head/business3,
		/datum/sprite_accessory/hair/head/business4,
		/datum/sprite_accessory/hair/head/buzz,
		/datum/sprite_accessory/hair/head/cia,
		/datum/sprite_accessory/hair/head/coffeehouse,
		/datum/sprite_accessory/hair/head/combover,
		/datum/sprite_accessory/hair/head/comet,
		/datum/sprite_accessory/hair/head/cornrows1,
		/datum/sprite_accessory/hair/head/cornrows2,
		/datum/sprite_accessory/hair/head/cornrowbraid,
		/datum/sprite_accessory/hair/head/cornrowbun,
		/datum/sprite_accessory/hair/head/cornrowdualtail,
		/datum/sprite_accessory/hair/head/crew,
		/datum/sprite_accessory/hair/head/cut,
		/datum/sprite_accessory/hair/head/dandpompadour,
		/datum/sprite_accessory/hair/head/devillock,
		/datum/sprite_accessory/hair/head/doublebun,
		/datum/sprite_accessory/hair/head/dreadlocks,
		/datum/sprite_accessory/hair/head/drillhair,
		/datum/sprite_accessory/hair/head/drillhairextended,
		/datum/sprite_accessory/hair/head/emo,
		/datum/sprite_accessory/hair/head/emo2,
		/datum/sprite_accessory/hair/head/emofringe,
		/datum/sprite_accessory/hair/head/longemo,
		/datum/sprite_accessory/hair/head/nofade,
		/datum/sprite_accessory/hair/head/lowfade,
		/datum/sprite_accessory/hair/head/medfade,
		/datum/sprite_accessory/hair/head/highfade,
		/datum/sprite_accessory/hair/head/baldfade,
		/datum/sprite_accessory/hair/head/father,
		/datum/sprite_accessory/hair/head/feather,
		/datum/sprite_accessory/hair/head/flair,
		/datum/sprite_accessory/hair/head/flattop,
		/datum/sprite_accessory/hair/head/flattop_big,
		/datum/sprite_accessory/hair/head/flow_hair,
		/datum/sprite_accessory/hair/head/gelled,
		/datum/sprite_accessory/hair/head/gentle,
		/datum/sprite_accessory/hair/head/halfbang,
		/datum/sprite_accessory/hair/head/halfbang2,
		/datum/sprite_accessory/hair/head/halfshaved,
		/datum/sprite_accessory/hair/head/hedgehog,
		/datum/sprite_accessory/hair/head/himecut,
		/datum/sprite_accessory/hair/head/himecut2,
		/datum/sprite_accessory/hair/head/shorthime,
		/datum/sprite_accessory/hair/head/himeup,
		/datum/sprite_accessory/hair/head/hitop,
		/datum/sprite_accessory/hair/head/jade,
		/datum/sprite_accessory/hair/head/jensen,
		/datum/sprite_accessory/hair/head/joestar,
		/datum/sprite_accessory/hair/head/keanu,
		/datum/sprite_accessory/hair/head/kusangi,
		/datum/sprite_accessory/hair/head/long,
		/datum/sprite_accessory/hair/head/long2,
		/datum/sprite_accessory/hair/head/long3,
		/datum/sprite_accessory/hair/head/long_over_eye,
		/datum/sprite_accessory/hair/head/longbangs,
		/datum/sprite_accessory/hair/head/longfringe,
		/datum/sprite_accessory/hair/head/sidepartlongalt,
		/datum/sprite_accessory/hair/head/megaeyebrows,
		/datum/sprite_accessory/hair/head/messy,
		/datum/sprite_accessory/hair/head/modern,
		/datum/sprite_accessory/hair/head/mohawk,
		/datum/sprite_accessory/hair/head/reversemohawk,
		/datum/sprite_accessory/hair/head/shavedmohawk,
		/datum/sprite_accessory/hair/head/unshavenmohawk,
		/datum/sprite_accessory/hair/head/mulder,
		/datum/sprite_accessory/hair/head/nitori,
		/datum/sprite_accessory/hair/head/odango,
		/datum/sprite_accessory/hair/head/ombre,
		/datum/sprite_accessory/hair/head/oneshoulder,
		/datum/sprite_accessory/hair/head/over_eye,
		/datum/sprite_accessory/hair/head/oxton,
		/datum/sprite_accessory/hair/head/parted,
		/datum/sprite_accessory/hair/head/partedside,
		/datum/sprite_accessory/hair/head/pigtails,
		/datum/sprite_accessory/hair/head/pigtails2,
		/datum/sprite_accessory/hair/head/pigtails3,
		/datum/sprite_accessory/hair/head/kagami,
		/datum/sprite_accessory/hair/head/pixie,
		/datum/sprite_accessory/hair/head/pompadour,
		/datum/sprite_accessory/hair/head/bigpompadour,
		/datum/sprite_accessory/hair/head/ponytail1,
		/datum/sprite_accessory/hair/head/ponytail2,
		/datum/sprite_accessory/hair/head/ponytail3,
		/datum/sprite_accessory/hair/head/ponytail4,
		/datum/sprite_accessory/hair/head/ponytail5,
		/datum/sprite_accessory/hair/head/ponytail6,
		/datum/sprite_accessory/hair/head/ponytail7,
		/datum/sprite_accessory/hair/head/highponytail,
		/datum/sprite_accessory/hair/head/longponytail,
		/datum/sprite_accessory/hair/head/stail,
		/datum/sprite_accessory/hair/head/countryponytail,
		/datum/sprite_accessory/hair/head/fringetail,
		/datum/sprite_accessory/hair/head/sidetail,
		/datum/sprite_accessory/hair/head/sidetail2,
		/datum/sprite_accessory/hair/head/sidetail3,
		/datum/sprite_accessory/hair/head/sidetail4,
		/datum/sprite_accessory/hair/head/spikyponytail,
		/datum/sprite_accessory/hair/head/poofy,
		/datum/sprite_accessory/hair/head/quiff,
		/datum/sprite_accessory/hair/head/ronin,
		/datum/sprite_accessory/hair/head/shaved,
		/datum/sprite_accessory/hair/head/shavedpart,
		/datum/sprite_accessory/hair/head/shortbangs,
		/datum/sprite_accessory/hair/head/short,
		/datum/sprite_accessory/hair/head/shorthair2,
		/datum/sprite_accessory/hair/head/shorthair3,
		/datum/sprite_accessory/hair/head/shorthair7,
		/datum/sprite_accessory/hair/head/rosa,
		/datum/sprite_accessory/hair/head/shoulderlength,
		/datum/sprite_accessory/hair/head/sidecut,
		/datum/sprite_accessory/hair/head/skinhead,
		/datum/sprite_accessory/hair/head/protagonist,
		/datum/sprite_accessory/hair/head/spiky,
		/datum/sprite_accessory/hair/head/spiky2,
		/datum/sprite_accessory/hair/head/spiky3,
		/datum/sprite_accessory/hair/head/swept,
		/datum/sprite_accessory/hair/head/swept2,
		/datum/sprite_accessory/hair/head/thinning,
		/datum/sprite_accessory/hair/head/thinningfront,
		/datum/sprite_accessory/hair/head/thinningrear,
		/datum/sprite_accessory/hair/head/topknot,
		/datum/sprite_accessory/hair/head/tressshoulder,
		/datum/sprite_accessory/hair/head/trimmed,
		/datum/sprite_accessory/hair/head/trimflat,
		/datum/sprite_accessory/hair/head/twintails,
		/datum/sprite_accessory/hair/head/undercut,
		/datum/sprite_accessory/hair/head/undercutleft,
		/datum/sprite_accessory/hair/head/undercutright,
		/datum/sprite_accessory/hair/head/unkept,
		/datum/sprite_accessory/hair/head/updo,
		/datum/sprite_accessory/hair/head/longer,
		/datum/sprite_accessory/hair/head/longest,
		/datum/sprite_accessory/hair/head/longest2,
		/datum/sprite_accessory/hair/head/veryshortovereye,
		/datum/sprite_accessory/hair/head/longestalt,
		/datum/sprite_accessory/hair/head/volaju,
		/datum/sprite_accessory/hair/head/wisp,
		/datum/sprite_accessory/hair/head/hyenamane,
		/datum/sprite_accessory/hair/head/forelock,
		/datum/sprite_accessory/hair/head/pirate,
		/datum/sprite_accessory/hair/head/shavedmohawk,
		/datum/sprite_accessory/hair/head/baldfade,
		/datum/sprite_accessory/hair/head/rogue,
		/datum/sprite_accessory/hair/head/romantic,
		/datum/sprite_accessory/hair/head/runt,
		/datum/sprite_accessory/hair/head/son,
		/datum/sprite_accessory/hair/head/bog,
		/datum/sprite_accessory/hair/head/scout,
		/datum/sprite_accessory/hair/head/son2,
		/datum/sprite_accessory/hair/head/long4,
		/datum/sprite_accessory/hair/head/amazon,
		/datum/sprite_accessory/hair/head/longstraightponytail,
		/datum/sprite_accessory/hair/head/barmaid,
		/datum/sprite_accessory/hair/head/bob_rt,
		/datum/sprite_accessory/hair/head/messy_rt,
		/datum/sprite_accessory/hair/head/homely,
		/datum/sprite_accessory/hair/head/longtails,
		/datum/sprite_accessory/hair/head/hime,
		/datum/sprite_accessory/hair/head/tied,
		/datum/sprite_accessory/hair/head/tied2,
		/datum/sprite_accessory/hair/head/fatherless,
		/datum/sprite_accessory/hair/head/fatherless2,
		/datum/sprite_accessory/hair/head/kepthair,
		/datum/sprite_accessory/hair/head/singlebraid,
		/datum/sprite_accessory/hair/head/gloomy,
		/datum/sprite_accessory/hair/head/gloomylong,
		/datum/sprite_accessory/hair/head/shortmessy,
		/datum/sprite_accessory/hair/head/mediumessy,
		/datum/sprite_accessory/hair/head/zone,
		/datum/sprite_accessory/hair/head/inari,
		/datum/sprite_accessory/hair/head/ziegler,
		/datum/sprite_accessory/hair/head/gronnbraid,
		/datum/sprite_accessory/hair/head/grenzelcut,
		/datum/sprite_accessory/hair/head/fluffy,
		/datum/sprite_accessory/hair/head/fluffyshort,
		/datum/sprite_accessory/hair/head/fluffylong,
		/datum/sprite_accessory/hair/head/jay,
		/datum/sprite_accessory/hair/head/hairfre,
		/datum/sprite_accessory/hair/head/dawn,
		/datum/sprite_accessory/hair/head/morning,
		/datum/sprite_accessory/hair/head/kobeni_1,
		/datum/sprite_accessory/hair/head/kobeni_2,
		/datum/sprite_accessory/hair/head/vulpkian/anita,
		/datum/sprite_accessory/hair/head/vulpkian/jagged,
		/datum/sprite_accessory/hair/head/vulpkian/kajam1,
		/datum/sprite_accessory/hair/head/vulpkian/kajam2,
		/datum/sprite_accessory/hair/head/vulpkian/keid,
		/datum/sprite_accessory/hair/head/vulpkian/mizar,
		/datum/sprite_accessory/hair/head/vulpkian/raine,
		)


/datum/customizer/bodypart_feature/hair/head/vox
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/hair/head/vox)

/datum/customizer_choice/bodypart_feature/hair/head/vox
	sprite_accessories = list(
		/datum/sprite_accessory/hair/head/bald,
		/datum/sprite_accessory/hair/head/vox/afro,
		/datum/sprite_accessory/hair/head/vox/crestedquills,
		/datum/sprite_accessory/hair/head/vox/emperorquills,
		/datum/sprite_accessory/hair/head/vox/horns,
		/datum/sprite_accessory/hair/head/vox/keelquills,
		/datum/sprite_accessory/hair/head/vox/keetquills,
		/datum/sprite_accessory/hair/head/vox/kingly,
		/datum/sprite_accessory/hair/head/vox/mohawk,
		/datum/sprite_accessory/hair/head/vox/nights,
		/datum/sprite_accessory/hair/head/vox/razorclipped,
		/datum/sprite_accessory/hair/head/vox/razor,
		/datum/sprite_accessory/hair/head/vox/shortquills,
		/datum/sprite_accessory/hair/head/vox/tielquills,
		/datum/sprite_accessory/hair/head/vox/yasu,
		)

/datum/customizer/bodypart_feature/hair/facial/vox
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/hair/facial/vox)

/datum/customizer_choice/bodypart_feature/hair/facial/vox
	sprite_accessories = list(
		/datum/sprite_accessory/hair/facial/shaved,
		/datum/sprite_accessory/hair/facial/vox/beard,
		/datum/sprite_accessory/hair/facial/vox/colonel,
		/datum/sprite_accessory/hair/facial/vox/fu,
		/datum/sprite_accessory/hair/facial/vox/neck,
		)
