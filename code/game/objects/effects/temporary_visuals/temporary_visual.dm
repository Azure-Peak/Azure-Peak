//temporary visual effects
/obj/effect/temp_visual
	icon_state = "nothing"
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/duration = 10 //in deciseconds
	var/randomdir = TRUE
	/// how long to fade away, if null, will disappear instantly.
	var/fade_time

/obj/effect/temp_visual/Initialize(mapload)
	. = ..()
	if(randomdir)
		setDir(pick(GLOB.cardinals))

	addtimer(CALLBACK(src, PROC_REF(timed_out)), duration)

/obj/effect/temp_visual/proc/timed_out()
	if(fade_time)
		animate(src, time = fade_time, alpha = 0)
		QDEL_IN(src, fade_time)
	else
		qdel(src)

/obj/effect/temp_visual/ex_act()
	return

/obj/effect/temp_visual/dir_setting
	randomdir = FALSE

/obj/effect/temp_visual/dir_setting/Initialize(mapload, set_dir)
	if(set_dir)
		setDir(set_dir)
	. = ..()

/obj/effect/temp_visual/swingdelay
	randomdir = FALSE
	icon = 'icons/effects/effects.dmi'
	icon_state = "blip"

/obj/effect/temp_visual/swingdelay/Initialize(mapload, set_dur)
	if(set_dur)
		duration = set_dur
	. = ..()

/obj/effect/temp_visual/special_intent/Initialize(mapload, customdur)
	if(customdur)
		duration = customdur
	. = ..()

/obj/effect/temp_visual/special_intent
	layer = HUD_LAYER
	plane = ABOVE_LIGHTING_PLANE

/obj/effect/temp_visual/armor_chunk
	randomdir = FALSE
	icon = 'icons/effects/effects.dmi'
	icon_state = "chunkfall"
	layer = HUD_LAYER
	plane = ABOVE_LIGHTING_PLANE

/obj/effect/temp_visual/armor_chunk/Initialize(mapload, customdur, customcolor, customstate)
	if(customdur)
		duration = customdur
	if(customstate)
		icon_state = customstate
	if(customcolor)
		add_atom_colour(customcolor, FIXED_COLOUR_PRIORITY)
	. = ..()
