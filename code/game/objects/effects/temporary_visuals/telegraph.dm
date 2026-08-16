/obj/effect/temp_visual/telegraph
	icon = 'icons/effects/telegraph.dmi'
	icon_state = "warning"
	layer = HUD_LAYER
	plane = ABOVE_LIGHTING_PLANE
	randomdir = FALSE
	light_outer_range = 2
	duration = 3 SECONDS
	var/fade_in = FALSE

/obj/effect/temp_visual/telegraph/Initialize(mapload, custom_duration)
	if(custom_duration)
		duration = custom_duration
	. = ..()
	if(fade_in)
		var/target_alpha = alpha
		alpha = 0
		animate(src, alpha = target_alpha, time = duration)
