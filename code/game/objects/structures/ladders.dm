// Basic ladder. By default links to the z-level above/below.
/obj/structure/ladder
	name = "ladder"
	desc = "'This would be easier if not for gravity' is what you <b>would</b> think were \
	you aware of the theory of gravity."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "ladder11"
	anchored = TRUE
	var/obj/structure/ladder/down	//the ladder below this one
	var/obj/structure/ladder/up		//the ladder above this one
	obj_flags = BLOCK_Z_OUT_DOWN
	max_integrity = 0

/obj/structure/ladder/Initialize(mapload, obj/structure/ladder/up, obj/structure/ladder/down)
	..()
	if (up)
		src.up = up
		up.down = src
		up.update_icon()
	if (down)
		src.down = down
		down.up = src
		down.update_icon()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/ladder/Destroy(force)
	if ((resistance_flags & INDESTRUCTIBLE) && !force)
		return QDEL_HINT_LETMELIVE
	disconnect()
	return ..()

/obj/structure/ladder/LateInitialize()
	// By default, discover ladders above and below us vertically
	var/turf/T = get_turf(src)
	var/obj/structure/ladder/L

	if (!down)
		L = locate() in GET_TURF_BELOW(T)
		if (L)
			down = L
			L.up = src	// Don't waste effort looping the other way
			L.update_icon()
	if (!up)
		L = locate() in GET_TURF_ABOVE(T)
		if (L)
			up = L
			L.down = src	// Don't waste effort looping the other way
			L.update_icon()

	update_icon()

/obj/structure/ladder/proc/disconnect()
	if(up && up.down == src)
		up.down = null
		up.update_icon()
	if(down && down.up == src)
		down.up = null
		down.update_icon()
	up = down = null

/obj/structure/ladder/update_icon()
	if(up && down)
		icon_state = "ladder11"

	else if(up)
		icon_state = "ladder10"

	else if(down)
		icon_state = "ladder01"

	else	//wtf make your ladders properly assholes
		icon_state = "ladder00"

/obj/structure/ladder/proc/travel(going_up, mob/user, is_ghost, obj/structure/ladder/ladder)
	if(is_ghost)
		return

	if(!is_ghost)
		playsound(src, 'sound/foley/ladder.ogg', 100, FALSE)
		if(!do_after(user, 30, TRUE, src))
			return

	if(!is_ghost)
		show_fluff_message(going_up, user)
		ladder.add_fingerprint(user)
	var/turf/T = get_turf(ladder)
	movable_travel_z_level(user, T)

/obj/structure/ladder/proc/use(mob/user, is_ghost=FALSE)
	if(!in_range(src, user))
		return

	if(user.buckled)
		return

	if (up && down)
		var/result = alert(user, "Go up or down [src]?", "Ladder", "Up", "Down", "Cancel")
		if (!in_range(src, user))
			return	// nice try
		switch(result)
			if("Up")
				travel(TRUE, user, is_ghost, up)
			if("Down")
				travel(FALSE, user, is_ghost, down)
			if("Cancel")
				return
	else if(up)
		travel(TRUE, user, is_ghost, up)
	else if(down)
		travel(FALSE, user, is_ghost, down)
	else
		to_chat(user, "<span class='warning'>[src] doesn't seem to lead anywhere!</span>")

	if(!is_ghost)
		add_fingerprint(user)

/obj/structure/ladder/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	use(user)

/obj/structure/ladder/attackby(obj/item/W, mob/user, params)
	return use(user)

//ATTACK GHOST IGNORING PARENT RETURN VALUE
/obj/structure/ladder/attack_ghost(mob/dead/observer/user)
	use(user, TRUE)
	return ..()

/obj/structure/ladder/proc/show_fluff_message(going_up, mob/user)
	if(going_up)
		user.visible_message("<span class='notice'>[user] climbs up [src].</span>", "<span class='notice'>I climb up [src].</span>")
	else
		user.visible_message("<span class='notice'>[user] climbs down [src].</span>", "<span class='notice'>I climb down [src].</span>")


// Indestructible away mission ladders which link based on a mapped ID and height value rather than X/Y/Z.
/obj/structure/ladder/unbreakable
	name = "sturdy ladder"
	desc = ""
	resistance_flags = INDESTRUCTIBLE
	var/id
	var/height = 0	// higher numbers are considered physically higher

/obj/structure/ladder/unbreakable/Initialize(mapload)
	GLOB.ladders += src
	return ..()

/obj/structure/ladder/unbreakable/Destroy()
	. = ..()
	if (. != QDEL_HINT_LETMELIVE)
		GLOB.ladders -= src

/obj/structure/ladder/unbreakable/LateInitialize()
	// Override the parent to find ladders based on being height-linked
	if (!id || (up && down))
		update_icon()
		return

	for (var/O in GLOB.ladders)
		var/obj/structure/ladder/unbreakable/L = O
		if (L.id != id)
			continue	// not one of our pals
		if (!down && L.height == height - 1)
			down = L
			L.up = src
			L.update_icon()
			if (up)
				break	// break if both our connections are filled
		else if (!up && L.height == height + 1)
			up = L
			L.down = src
			L.update_icon()
			if (down)
				break	// break if both our connections are filled

	update_icon()

/obj/structure/ladder/earth
	icon_state = "ladderearth"

/obj/structure/ladder/earth/update_icon()
	if(up && down)
		icon_state = "ladder11"

	else if(up)
		icon_state = "ladder10"

	else if(down)
		icon_state = "ladderearth"

	else	//wtf make your ladders properly assholes
		icon_state = "ladder00"

/obj/structure/wallladder
	name = "wall ladder"
	desc = ""
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "ladderwall"
	anchored = TRUE
	var/obj/structure/ladder/down	//the ladder below this one
	var/obj/structure/ladder/up		//the ladder above this one
	obj_flags = BLOCK_Z_OUT_DOWN
	max_integrity = 200
	blade_dulling = DULLING_BASHCHOP



/obj/structure/wallladder/OnCrafted(dirin)
	dir = dirin
	layer = BELOW_MOB_LAYER
	switch(dir)
		if(NORTH)
			pixel_y = 16
		if(SOUTH)
			layer = ABOVE_MOB_LAYER
		if(WEST)
			pixel_x = -4
		if(EAST)
			pixel_x = 4
	. = ..()

/obj/structure/rope_ladder
	name = "rope"
	desc = "A length of rope that has been lowered to allow climbing."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "pillar"
	anchored = TRUE
	obj_flags = BLOCK_Z_OUT_DOWN
	max_integrity = 50
	blade_dulling = DULLING_BASHCHOP

/obj/structure/rope_ladder/attack_hand(mob/user) //no idea why this wasnt a feature before, but ok
	. = ..()
	if(!isliving(user) || user.get_active_held_item()) //we dont want dead people climbing ropes.
		return
	var/mob/living/living_user = user
	if(!in_range(src, living_user) || living_user.buckled) //no climbing buckled
		return
	var/turf/above_turf = GET_TURF_ABOVE(get_turf(src)) //get the turf above the rope
	var/turf/landing_turf //the turf on which we actually end up climbing on.
	for(var/turf/adjacent_turf in get_adjacent_turfs(above_turf)) //get adjacent turfs
		if(!istype(adjacent_turf, /turf/open/floor) || adjacent_turf.is_blocked_turf(source_atom = living_user))
			continue //if its blocked or if it isnt a floor on which we can stand do nothing
		landing_turf = adjacent_turf //otherwise set adjacent turf as landing turf.
		break //if we have multiple adjacent climbable turfs, it picks the first one, this might cause some funky climbing, I dont see this happening often, and if it does happen other than looking weird, i dont see a situation where it causes an issue.
	if(!landing_turf) //no climbable turf, no climbing.
		to_chat(living_user, span_warning("I am unable to climb up."))
		return
	playsound(src, 'sound/foley/noose_idle.ogg', 100, FALSE) //noise used for hanging mobs, but its the one used for rope assisted climbing of walls.
	to_chat(living_user, span_warning("I begin climbing up [src]..."))
	if(!do_after(living_user, 90, TRUE, src)) //9 seconds, a while, but not too long, finding a wall is still better.
		return
	if(!in_range(src, living_user) || living_user.buckled)
		return
	living_user.visible_message(span_notice("[living_user] climbs up [src]."), span_notice("I climb up [src]."))
	movable_travel_z_level(living_user, landing_turf)

/obj/structure/rope_ladder/get_mechanics_examine(mob/user)
	. = ..()
	. += "The rope can be retrieved by dragging it onto yourself."
	. += "The rope makes walls easier to climb."
	. += "Even if there are no walls around, you are still able to climb up the rope, albeit it takes longer."

/obj/structure/rope_ladder/MouseDrop(atom/over)
	if(usr != over)
		return ..()
	var/mob/living/living_user = usr
	if(!Adjacent(living_user))
		return
	living_user.visible_message(span_notice("[living_user] begins removing the rope ladder from the wall..."), span_notice("You begin removing the rope ladder from the wall..."))
	if(do_after(living_user, 5 SECONDS, TRUE, src))
		var/obj/item/rope/rope = new(src.loc)
		living_user.put_in_hands(rope)
		living_user.visible_message(span_notice("[living_user] removes the rope ladder from the wall."), span_notice("You remove the rope ladder from the wall."))
		qdel(src)

// Entirely decorative ladder structure. Does nothing functionally.
/obj/structure/decorativeladder
	name = "ladder"
	desc = "'This would be easier if not for gravity' is what you <b>would</b> think were \
	you aware of the theory of gravity."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "ladder11"
	anchored = TRUE
	max_integrity = 0
