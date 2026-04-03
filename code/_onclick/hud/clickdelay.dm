/atom/movable/screen/action_bar

/atom/movable/screen/action_bar/Destroy()
	STOP_PROCESSING(SShuds, src)
	return ..()

/atom/movable/screen/action_bar/proc/mark_dirty()
	var/mob/living/L = hud?.mymob
	if(L?.client && update_to_mob(L))
		START_PROCESSING(SShuds, src)

/atom/movable/screen/action_bar/process()
	var/mob/living/L = hud?.mymob
	if(!L?.client || !update_to_mob(L))
		return PROCESS_KILL

/atom/movable/screen/action_bar/proc/update_to_mob(mob/living/L)
	return FALSE

/datum/hud
	var/atom/movable/screen/action_bar/clickdelay/left/cdleft
	var/atom/movable/screen/action_bar/clickdelay/right/cdright
	var/atom/movable/screen/action_bar/clickdelay/cdmid
	var/atom/movable/screen/action_bar/defensedelay/defdelay

/atom/movable/screen/action_bar/clickdelay
	name = "click delay"
	icon = 'icons/mob/roguehud.dmi'
	icon_state = ""
	mouse_opacity = 0
	layer = HUD_LAYER + 1
	plane = HUD_PLANE
	alpha = 230

/atom/movable/screen/action_bar/clickdelay/update_to_mob(mob/living/L)
	if(world.time >= L.next_move)
		icon_state = ""
		return FALSE
	icon_state = "resiswait"
	return TRUE

/atom/movable/screen/action_bar/clickdelay/left/update_to_mob(mob/living/L)
	if(world.time >= L.next_lmove)
		icon_state = ""
		return FALSE
	icon_state = "resiswait"
	return TRUE

/atom/movable/screen/action_bar/clickdelay/right/update_to_mob(mob/living/L)
	if(world.time >= L.next_rmove)
		icon_state = ""
		return FALSE
	icon_state = "resiswait"
	return TRUE

/atom/movable/screen/action_bar/defensedelay
	name = "defense readiness"
	desc = "My readiness to defend. If the light is gone, I cannot dodge or parry."
	icon = 'icons/mob/roguehud.dmi'
	icon_state = "defdelay0"
	mouse_opacity = TRUE
	layer = ABOVE_HUD_LAYER
	plane = HUD_PLANE
	alpha = 230

/atom/movable/screen/action_bar/defensedelay/defdelay/update_to_mob(mob/living/L)
	switch(L.d_intent)
		if(INTENT_DODGE)
			if((L.last_dodge + L.dodgetime) > world.time)
				icon_state = "defdelay1"
				return TRUE
		if(INTENT_PARRY)
			if((L.last_parry + L.parrydelay) > world.time)
				icon_state = "defdelay1"
				return TRUE
	icon_state = "defdelay0"
	return FALSE

/datum/hud/var/atom/movable/screen/action_bar/resistdelay/resistdelay

/atom/movable/screen/action_bar/resistdelay
	name = "resist delay"
	icon = 'icons/mob/roguehud.dmi'
	icon_state = ""

/atom/movable/screen/action_bar/resistdelay/update_to_mob(mob/living/L)
	if(world.time >= L.last_special)
		icon_state = ""
		return FALSE
	icon_state = "resiswait"
	return TRUE

