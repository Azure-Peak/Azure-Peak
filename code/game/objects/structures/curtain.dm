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

/obj/structure/curtain/proc/toggle()
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
	toggle()

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
