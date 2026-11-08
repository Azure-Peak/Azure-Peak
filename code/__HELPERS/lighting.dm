/proc/emissive_appearance(icon, icon_state = "", layer = FLOAT_LAYER, alpha = 255, appearance_flags = EMISSIVE_APPEARANCE_FLAGS)
	var/mutable_appearance/appearance = mutable_appearance(icon, icon_state, layer, EMISSIVE_PLANE, alpha)
	appearance.appearance_flags = appearance_flags
	appearance.color = EMISSIVE_COLOR
	return appearance
