GLOBAL_LIST_INIT(customizer_choices, build_customizer_choices())
GLOBAL_LIST_INIT(customizers, build_customizers())

/proc/build_customizer_choices()
	. = list()
	for(var/type in typesof(/datum/customizer_choice))
		if(is_abstract(type))
			continue
		.[type] = new type()
	return .

/proc/build_customizers()
	. = list()
	for(var/type in typesof(/datum/customizer))
		if(is_abstract(type))
			continue
		.[type] = new type()
	return .

/proc/color_pick_sanitized(mob/user, description, title, default_value, min_tag = 0.07, max_tag = 0.80)
	var/color = input(user, description, title, default_value) as color|null
	var/good = TRUE
	if(!color)
		return
	color = sanitize_hexcolor(color)
	var/list/hsl = rgb2hsl(hex2num(copytext(color,1,3)),hex2num(copytext(color,3,5)),hex2num(copytext(color,5,7)))
	if(hsl[3] < min_tag)
		to_chat(user, span_warning("The picked color is too dark! Raising Luminosity to minimum 20%."))
		hsl[3] = min_tag
		good = FALSE
	if(hsl[2] > max_tag)
		to_chat(user, span_warning("The picked color is too bright! Lowering Saturation to maximum 80%."))
		hsl[2] = max_tag
		good = FALSE
	if(!good)
		var/list/rgb = hsl2rgb(arglist(hsl))
		color = sanitize_hexcolor("[num2hex(rgb[1])][num2hex(rgb[2])][num2hex(rgb[3])]")

	return color
