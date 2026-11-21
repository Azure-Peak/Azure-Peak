/obj/structure/curtain
	name = "curtain"
	desc = ""
	icon = 'icons/roguetown/misc/structure.dmi'
	var/icon_type = "curtain" // used in making the icon state
	icon_state = "curtain-open"
	color = "#ffffff" // Default color, mappers can easily change it.
	alpha = 255 // Mappers can set this to 200 if they want it slightly see-through
	layer = LARGE_MOB_LAYER 
	plane = GAME_PLANE_UPPER
	anchored = TRUE
	opacity = 0
	density = FALSE
	var/open = TRUE
	var/directional = FALSE

/obj/structure/curtain/proc/toggle(mob/user)
	if(directional && (!user || get_dir(src, user) != dir))
		to_chat(user, span_notice("I cannot reach the curtain from this side."))
		return
	open = !open
	update_icon()

/obj/structure/curtain/update_icon()
	if(!open)
		icon_state = "[icon_type]-closed"
		layer = LARGE_MOB_LAYER 
		set_opacity(TRUE)
		open = FALSE

	else
		icon_state = "[icon_type]-open"
		layer = LARGE_MOB_LAYER 
		set_opacity(FALSE)
		open = TRUE

/obj/structure/curtain/wrench_act(mob/living/user, obj/item/I)
	..()
	default_unfasten_wrench(user, I, 50)
	return TRUE

/obj/structure/curtain/wirecutter_act(mob/living/user, obj/item/I)
	..()
	if(anchored)
		return TRUE

	user.visible_message("<span class='warning'>[user] cuts apart [src].</span>",
		"<span class='notice'>I start to cut apart [src].</span>", "<span class='hear'>I hear cutting.</span>")
	if(I.use_tool(src, user, 50, volume=100) && !anchored)
		to_chat(user, "<span class='notice'>I cut apart [src].</span>")
		deconstruct()

	return TRUE


/obj/structure/curtain/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	playsound(loc, 'sound/foley/doors/curtain.ogg', 50, TRUE)
	toggle(user)

/obj/structure/curtain/deconstruct(disassembled = TRUE)
	qdel(src)

/obj/structure/curtain/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(src.loc, 'sound/blank.ogg', 80, TRUE)
			else
				playsound(loc, 'sound/blank.ogg', 50, TRUE)
		if(BURN)
			playsound(loc, 'sound/blank.ogg', 80, TRUE)

/obj/structure/curtain/bounty
	icon_type = "bounty"
	icon_state = "bounty-open"
	color = null
	alpha = 255

/obj/structure/curtain/red
	color = "#a32121"

/obj/structure/curtain/blue
	color = CLOTHING_BLUE

/obj/structure/curtain/green
	color = CLOTHING_DARK_GREEN

/obj/structure/curtain/brown
	color = CLOTHING_BROWN

/obj/structure/curtain/purple
	color = "#8747b1"

/obj/structure/curtain/magenta
	color = "#962e5c"

/obj/structure/curtain/black
	color = "#414143"

/obj/structure/curtain/fancy
	name = "fancy blue curtain"
	icon_type = "curtain_blue"
	icon_state = "curtain_blue-open"
	icon = 'icons/obj/watercloset.dmi'
	color = null

/obj/structure/curtain/fancy/Initialize(mapload)
	. = ..()
	update_icon()

/obj/structure/curtain/fancy/dir
	directional = TRUE
	icon_state = "curtain_bluedir"

/obj/structure/curtain/fancy/cyan
	name = "fancy cyan curtain"
	icon_type = "curtain_cyan"
	icon_state = "curtain_cyan-open"

/obj/structure/curtain/fancy/cyan/dir
	directional = TRUE
	icon_state = "curtain_cyandir"

/obj/structure/curtain/fancy/brown
	name = "fancy brown curtain"
	icon_type = "curtain_brown"
	icon_state = "curtain_brown-open"

/obj/structure/curtain/fancy/brown/dir
	directional = TRUE
	icon_state = "curtain_browndir"

/obj/structure/curtain/fancy/green
	name = "fancy green curtain"
	icon_type = "curtain_green"
	icon_state = "curtain_green-open"

/obj/structure/curtain/fancy/green/dir
	directional = TRUE
	icon_state = "curtain_greendir"

/obj/structure/curtain/fancy/purple
	name = "fancy purple curtain"
	icon_type = "curtain_purple"
	icon_state = "curtain_purple-open"

/obj/structure/curtain/fancy/purple/dir
	directional = TRUE
	icon_state = "curtain_purpledir"

/obj/structure/curtain/fancy/red
	name = "fancy red curtain"
	icon_type = "curtain_red"
	icon_state = "curtain_red-open"

/obj/structure/curtain/fancy/red/dir
	directional = TRUE
	icon_state = "curtain_reddir"

/obj/structure/curtain/fancy/noc
	name = "fancy navy curtain"
	desc = "Decorative navy curtains, popular amongst Noccites."
	icon_type = "curtain_noc"
	icon_state = "curtain_noc-open"

/obj/structure/curtain/fancy/noc/dir
	directional = TRUE
	icon_state = "curtain_nocdir"

/obj/structure/curtain/old
	name = "old brown curtain"
	icon_type = "curtain_old"
	icon_state = "curtain_old-open"
	icon = 'icons/obj/watercloset.dmi'
	color = null

/obj/structure/curtain/old/Initialize(mapload)
	. = ..()
	update_icon()

/obj/structure/curtain/old/dir
	directional = TRUE
	icon_state = "curtain_olddir"

/obj/structure/curtain/old/beige
	name = "old beige curtain"
	icon_type = "curtain_oldbeige"
	icon_state = "curtain_oldbeige-open"

/obj/structure/curtain/old/beige/dir
	directional = TRUE
	icon_state = "curtain_oldbeigedir"

/obj/structure/curtain/old/red
	name = "old red curtain"
	icon_type = "curtain_oldred"
	icon_state = "curtain_oldred-open"

/obj/structure/curtain/old/red/dir
	directional = TRUE
	icon_state = "curtain_oldreddir"

/obj/structure/curtain/old/blue
	name = "old blue curtain"
	icon_type = "curtain_oldblue"
	icon_state = "curtain_oldblue-open"

/obj/structure/curtain/old/blue/dir
	directional = TRUE
	icon_state = "curtain_oldbluedir"

/obj/structure/curtain/old/green
	name = "old green curtain"
	icon_type = "curtain_oldgreen"
	icon_state = "curtain_oldgreen-open"

/obj/structure/curtain/old/green/dir
	directional = TRUE
	icon_state = "curtain_oldgreendir"

/obj/structure/curtain/old/purple
	name = "old purple curtain"
	icon_type = "curtain_oldpurple"
	icon_state = "curtain_oldpurple-open"

/obj/structure/curtain/old/purple/dir
	directional = TRUE
	icon_state = "curtain_oldpurpledir"

/obj/structure/curtain/fancy/sun
	name = "sun curtain"
	icon_type = "curtain_sun"
	icon_state = "curtain_sun-open"

/obj/structure/curtain/fancy/sun/dir
	directional = TRUE
	icon_state = "curtain_sundir"
