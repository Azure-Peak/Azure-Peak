/datum/asset/spritesheet/fishing_hud
	name = "fishing_hud"

/datum/asset/spritesheet/fishing_hud/create_spritesheets()
	var/icon/hud = 'icons/hud/fishing_hud.dmi'
	for(var/icon_state in uniqueList(icon_states(hud)))
		Insert(icon_state, hud, icon_state)
	var/list/band_colors = list(
		"completion_clean" = FISHING_CLEAN_CATCH_COLOR,
		"completion_fair" = FISHING_FAIR_CATCH_COLOR,
		"completion_poor" = FISHING_POOR_CATCH_COLOR,
	)
	for(var/sprite_name in band_colors)
		var/icon/tinted = icon(hud, "completion_overlay")
		tinted.MapColors(arglist(color_matrix_recolor(band_colors[sprite_name], FISHING_CATCH_BAND_BRIGHTNESS)))
		Insert(sprite_name, tinted)
