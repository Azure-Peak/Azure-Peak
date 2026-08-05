/// Turns a color string such as "#FFFFFF#00FFFF" into a list of ("#FFFFFF", #00FFFF)
/proc/color_string_to_list(color_string)
	if(!color_string)
		return null
	. = list()
	var/list/split_colors = splittext(color_string, "#")
	for(var/color in 2 to length(split_colors))
		. += "#[split_colors[color]]"

/// Turns a list such as ("#FFFFFF", #00FFFF) into a color string of "#FFFFFF#00FFFF"
/proc/color_list_to_string(list/color_list)
	if(!islist(color_list))
		return null
	. = ""
	for(var/color in color_list)
		. += color
