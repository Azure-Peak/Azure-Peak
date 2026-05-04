GLOBAL_DATUM_INIT(shared_typing_indicator, /obj/effect/overlay/typing_indicator, new(null))

/**
  * Displays typing indicator.
  * @param timeout_override - Sets how long until this will disappear on its own without the user finishing their message or logging out. Defaults to TYPING_INDICATOR_TIMEOUT
  * @param force - shows even if src.typing_indicator_enabled is FALSE.
  */
/mob/proc/display_typing_indicator(timeout_override = TYPING_INDICATOR_TIMEOUT, force = FALSE)
	if(((!typing_indicator_enabled || (stat != CONSCIOUS)) && !force) || typing_indicator_current)
		return
	typing_indicator_current = GLOB.shared_typing_indicator
	log_message("started typing", LOG_ATTACK)
	// KEEP_TOGETHER on the mob so vis_contents children inherit our transform (giant virtue, etc).
	if(!(appearance_flags & KEEP_TOGETHER))
		appearance_flags |= KEEP_TOGETHER
		typing_indicator_added_keep_together = TRUE
	vis_contents += typing_indicator_current
	typing_indicator_timerid = addtimer(CALLBACK(src, PROC_REF(clear_typing_indicator)), timeout_override, TIMER_STOPPABLE)

/**
  * Removes typing indicator.
  */
/mob/proc/clear_typing_indicator()
	if(!typing_indicator_current)
		return
	vis_contents -= typing_indicator_current
	if(typing_indicator_added_keep_together)
		appearance_flags &= ~KEEP_TOGETHER
		typing_indicator_added_keep_together = FALSE
	typing_indicator_current = null
	if(typing_indicator_timerid)
		deltimer(typing_indicator_timerid)
		typing_indicator_timerid = null

/// Default typing indicator
/obj/effect/overlay/typing_indicator
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	icon = 'icons/mob/typing_indicator.dmi'
	icon_state = "default0"
	appearance_flags = RESET_COLOR | TILE_BOUND | PIXEL_SCALE
	layer = HUD_LAYER
	plane = FULLSCREEN_PLANE
	alpha = 175
	vis_flags = NONE
