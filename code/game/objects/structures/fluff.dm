//Fluff structures serve no purpose and exist only for enriching the environment. They can be destroyed with a wrench.

/obj/structure/fluff
	name = "fluff structure"
	desc = ""
	icon_state = "minibar"
	anchored = TRUE
	density = FALSE
	opacity = 0
	blade_dulling = DULLING_BASHCHOP
	max_integrity = 150
	var/deconstructible = TRUE

/obj/structure/fluff/pillow
	name = "pillows"
	desc = "Soft plush pillows. Resting your head on one is so relaxing."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "pillow"
	density = FALSE

/obj/structure/fluff/pillow/red
	color = CLOTHING_RED

/obj/structure/fluff/pillow/blue
	color = CLOTHING_BLUE

/obj/structure/fluff/pillow/green
	color = CLOTHING_DARK_GREEN

/obj/structure/fluff/pillow/brown
	color = CLOTHING_BROWN

/obj/structure/fluff/pillow/magenta
	color = CLOTHING_MAGENTA

/obj/structure/fluff/pillow/purple
	color = CLOTHING_PURPLE

/obj/structure/fluff/pillow/black
	color = CLOTHING_BLACK

/obj/structure/fluff/drake_statue //Ash drake status spawn on either side of the necropolis gate in lavaland.
	name = "drake statue"
	desc = "Possibly the only time you'll ever see its likeness up close and live to tell the tale."
	icon = 'icons/effects/64x64.dmi'
	icon_state = "drake_statue"
	pixel_x = -16
	density = TRUE
	deconstructible = FALSE
	layer = EDGED_TURF_LAYER

/obj/structure/fluff/drake_statue/falling //A variety of statue in disrepair; parts are broken off and a gemstone is missing
	desc = ""
	icon_state = "drake_statue_falling"

/obj/structure/fluff/paper/corner
	icon_state = "papercorner"

/obj/structure/fluff/paper/stack
	name = "dense stack of papers"
	desc = "You can already feel your eyes glazing over and the boredom creeping in."
	icon_state = "paperstack"

/obj/structure/fluff/divine
	name = "Miracle"
	icon = 'icons/obj/hand_of_god_structures.dmi'
	anchored = TRUE
	density = TRUE

/obj/structure/fluff/divine/nexus
	name = "nexus"
	desc = ""
	icon_state = "nexus"

/obj/structure/fluff/divine/conduit
	name = "conduit"
	desc = ""
	icon_state = "conduit"

/obj/structure/fluff/divine/convertaltar
	name = "conversion altar"
	desc = ""
	icon_state = "convertaltar"
	density = FALSE
	can_buckle = 1

/obj/structure/fluff/divine/powerpylon
	name = "power pylon"
	desc = ""
	icon_state = "powerpylon"
	can_buckle = 1

/obj/structure/fluff/divine/defensepylon
	name = "defense pylon"
	desc = ""
	icon_state = "defensepylon"

/obj/structure/fluff/divine/shrine
	name = "shrine"
	desc = ""
	icon_state = "shrine"

/obj/structure/fluff/big_chain
	name = "giant chain"
	desc = ""
	icon = 'icons/effects/32x96.dmi'
	icon_state = "chain"
	layer = ABOVE_OBJ_LAYER
	anchored = TRUE
	density = TRUE
	deconstructible = FALSE

/obj/structure/fluff/railing
	name = "railing"
	desc = "A simple barrier of wood meant to prevent falls."
	icon = 'icons/obj/railing.dmi'
	icon_state = "railing"
	density = FALSE
	anchored = TRUE
	deconstructible = FALSE
	flags_1 = ON_BORDER_1
	climbable = TRUE
	layer = ABOVE_MOB_LAYER
	/// Living mobs can lay down to go past
	var/pass_crawl = TRUE
	/// Projectiles can go past
	var/pass_projectile = TRUE
	/// Throwing atoms can go past
	var/pass_throwing = TRUE
	/// Throwing/Flying non mobs can always exit the turf regardless of other flags
	var/allow_flying_outwards = TRUE

/obj/structure/fluff/railing/Initialize()
	. = ..()
	init_connect_loc_element()
	var/lay = getwlayer(dir)
	if(lay)
		layer = lay

/obj/structure/fluff/railing/proc/init_connect_loc_element()
	var/static/list/loc_connections = list(COMSIG_ATOM_EXIT = PROC_REF(on_exit))
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/fluff/railing/proc/getwlayer(dirin)
	switch(dirin)
		if(NORTH)
			layer = BELOW_MOB_LAYER-0.01
		if(WEST)
			layer = BELOW_MOB_LAYER
		if(EAST)
			layer = BELOW_MOB_LAYER
		if(SOUTH)
			layer = ABOVE_MOB_LAYER
			plane = GAME_PLANE_UPPER

/obj/structure/fluff/railing/CanPass(atom/movable/mover, turf/target)
//	if(istype(mover) && (mover.pass_flags & PASSTABLE))
//		return 1
	if(istype(mover, /obj/projectile))
		return 1
	if(mover.throwing)
		return 1
	if(isobserver(mover))
		return 1
	if(isliving(mover))
		var/mob/living/M = mover
		if(!(M.mobility_flags & MOBILITY_STAND))
			if(pass_crawl)
				return TRUE
	if(icon_state == "woodrailing" && (dir in CORNERDIRS))
		var/list/baddirs = list()
		switch(dir)
			if(SOUTHEAST)
				baddirs = list(SOUTHEAST, SOUTH, EAST)
			if(SOUTHWEST)
				baddirs = list(SOUTHWEST, SOUTH, WEST)
			if(NORTHEAST)
				baddirs = list(NORTHEAST, NORTH, EAST)
			if(NORTHWEST)
				baddirs = list(NORTHWEST, NORTH, WEST)
		if(get_dir(loc, target) in baddirs)
			return 0
	else if(get_dir(loc, target) == dir)
		return 0
	return 1

/obj/structure/fluff/railing/proc/on_exit(datum/source, atom/movable/leaving, atom/new_location)
	SIGNAL_HANDLER

	if(dir in CORNERDIRS)
		return

	if(isobserver(leaving))
		return

	if(get_dir(leaving.loc, new_location) != dir)
		return

	if(pass_projectile && istype(leaving, /obj/projectile))
		return

	if(pass_throwing && leaving.throwing)
		return

	if(pass_crawl && isliving(leaving))
		var/mob/living/M = leaving
		if(!(M.mobility_flags & MOBILITY_STAND))
			return

	leaving.Bump(src)
	return COMPONENT_ATOM_BLOCK_EXIT

/obj/structure/fluff/railing/OnCrafted(dirin)
	. = ..()
	var/lay = getwlayer(dir)
	if(lay)
		layer = lay

/obj/structure/fluff/railing/border/north
	dir = 1

/obj/structure/fluff/railing/border/east
	dir = 4

/obj/structure/fluff/railing/border/west
	dir = 8

/obj/structure/fluff/railing/corner
	icon_state = "border"
	density = FALSE
	dir = 9

/obj/structure/fluff/railing/corner/init_connect_loc_element()
	return

/obj/structure/fluff/railing/corner/north_east
	dir = 5

/obj/structure/fluff/railing/corner/south_west
	dir = 10

/obj/structure/fluff/railing/corner/south_east
	dir = 6

/obj/structure/fluff/railing/wood
	icon_state = "woodrailing"
	blade_dulling = DULLING_BASHCHOP
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/railing/wood/north
	dir = 1

/obj/structure/fluff/railing/wood/east
	dir = 4

/obj/structure/fluff/railing/wood/west
	dir = 8

/obj/structure/fluff/railing/stonehedge
	icon_state = "stonehedge"
	blade_dulling = DULLING_BASHCHOP
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/railing/border
	name = "border"
	desc = ""
	icon_state = "border"
	pass_crawl = FALSE

/obj/structure/fluff/railing/fence
	name = "palisade"
	desc = "A rudimentary barrier that might keep the monsters at bay."
	icon = 'icons/roguetown/misc/structure.dmi'
	attacked_sound = 'sound/misc/woodhit.ogg'
	destroy_sound = 'sound/misc/treefall.ogg'
	icon_state = "fence"
	density = TRUE
	opacity = TRUE
	anchored = TRUE
	layer = 2.91
	climbable = FALSE
	max_integrity = 400
	pass_crawl = FALSE
	climb_offset = 6

/obj/structure/fluff/railing/fence/Initialize()
	. = ..()
	smooth_fences()

/obj/structure/fluff/railing/fence/Destroy()
	..()
	smooth_fences()

/obj/structure/fluff/railing/fence/OnCrafted(dirin)
	. = ..()
	smooth_fences()

/obj/structure/fluff/railing/fence/proc/smooth_fences(neighbors)
	cut_overlays()
	if((dir == WEST) || (dir == EAST))
		var/turf/T = get_step(src, NORTH)
		if(T)
			for(var/obj/structure/fluff/railing/fence/F in T)
				if(F.dir == dir)
					if(!neighbors)
						F.smooth_fences(TRUE)
					var/mutable_appearance/MA = mutable_appearance(icon,"fence_smooth_above")
					MA.dir = dir
					add_overlay(MA)
		T = get_step(src, SOUTH)
		if(T)
			for(var/obj/structure/fluff/railing/fence/F in T)
				if(F.dir == dir)
					if(!neighbors)
						F.smooth_fences(TRUE)
					var/mutable_appearance/MA = mutable_appearance(icon,"fence_smooth_below")
					MA.dir = dir
					add_overlay(MA)

/obj/structure/fluff/railing/fence/CanPass(atom/movable/mover, turf/target)
	if(get_dir(loc, target) == dir)
		return 0
	return 1

/obj/structure/bars
	name = "bars"
	desc = "Rigid metal bars, intended to impair access to somewhere."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "bars"
	density = TRUE
	anchored = TRUE
	blade_dulling = DULLING_BASHCHOP
	max_integrity = 700
	damage_deflection = 12
	integrity_failure = 0.15
	dir = SOUTH
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN
	attacked_sound = list("sound/combat/hits/onmetal/metalimpact (1).ogg", "sound/combat/hits/onmetal/metalimpact (2).ogg")

/obj/structure/bars/obj_break(damage_flag)
	loud_message("A sickening, metallic scrape of bars getting broken rings out", hearing_distance = 14)
	. = ..()

/obj/structure/bars/CanPass(atom/movable/mover, turf/target)
	if(isobserver(mover))
		return 1
	if(istype(mover) && (mover.pass_flags & PASSGRILLE))
		return 1
	if(mover.throwing && !ismob(mover))
		return prob(66)
	return ..()

/obj/structure/bars/shop
	icon_state = "barsbent"
	layer = BELOW_OBJ_LAYER

/obj/structure/bars/shop/bronze
	color = "#ff9c1a"

/obj/structure/bars/chainlink
	icon_state = "chainlink"

/obj/structure/bars/steel
	name = "steel bars"
	max_integrity = 2000

/obj/structure/bars/tough
	max_integrity = 9000
	damage_deflection = 40

/*
/obj/structure/bars/CheckExit(atom/movable/O, turf/target)
	if(istype(O) && (O.pass_flags & PASSGRILLE))
		return 1
	if(O.throwing && !ismob(O))
		return 1
	return !density
	..()
*/
/obj/structure/bars/obj_break(damage_flag)
	icon_state = "[initial(icon_state)]b"
	density = FALSE
	..()

/obj/structure/bars/cemetery
	icon_state = "cemetery"

/obj/structure/bars/passage
	icon_state = "passage0"
	desc = "This looks like it can open and close!"
	density = TRUE
	max_integrity = 1500
	redstone_structure = TRUE

/obj/structure/bars/passage/steel
	name = "steel bars"
	max_integrity = 2000

/obj/structure/bars/passage/redstone_triggered()
	if(obj_broken)
		return
	if(density)
		icon_state = "passage1"
		density = FALSE
	else
		icon_state = "passage0"
		density = TRUE

/obj/structure/bars/passage/shutter
	icon_state = "shutter0"
	density = TRUE
	opacity = TRUE
	redstone_structure = TRUE

/obj/structure/bars/passage/shutter/redstone_triggered()
	if(obj_broken)
		return
	if(density)
		icon_state = "shutter1"
		density = FALSE
		opacity = FALSE
	else
		icon_state = "shutter0"
		density = TRUE
		opacity = TRUE

/obj/structure/bars/passage/shutter/open
	icon_state = "shutter1"
	density = FALSE
	opacity = FALSE

/obj/structure/bars/passage/attackby(obj/item/I, mob/user, params)
	. = ..()
	var/obj/item = user.get_active_held_item()
	if(user.used_intent.type == /datum/intent/chisel )
		if (user.get_skill_level(/datum/skill/craft/engineering) <= 3)
			to_chat(user, span_warning("I need more skill to carve a name into this passage."))
			return
		playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
		user.visible_message("<span class='info'>[user] Carves a name into the passage.</span>")
		if(do_after(user, 10))
			var/passagename
			passagename = input("What name would you like to carve into the passage?")
			if (passagename)
				name = passagename + "(passage)"
				desc = "a passage with a name carved into it"
			else
				name = "passage"
				desc = "a passage with a carving scratched out"
			playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
		return
	else if(istype(item, /obj/item/rogueweapon/chisel/assembly))
		to_chat(user, span_warning("You most use both hands to rename the passage."))

/obj/structure/bars/grille
	name = "grille"
	desc = ""
	icon_state = "floorgrille"
	density = FALSE
	layer = TABLE_LAYER
	plane = GAME_PLANE
	damage_deflection = 5
	blade_dulling = DULLING_BASHCHOP
	obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP
	attacked_sound = list('sound/combat/hits/onmetal/grille (1).ogg', 'sound/combat/hits/onmetal/grille (2).ogg', 'sound/combat/hits/onmetal/grille (3).ogg')
	var/togg = FALSE
	redstone_structure = TRUE

/obj/structure/bars/grille/Initialize()
	AddComponent(/datum/component/squeak, list('sound/foley/footsteps/FTMET_A1.ogg','sound/foley/footsteps/FTMET_A2.ogg','sound/foley/footsteps/FTMET_A3.ogg','sound/foley/footsteps/FTMET_A4.ogg'), 40)
	dir = pick(GLOB.cardinals)
	return ..()

/obj/structure/bars/grille/obj_break(damage_flag)
	obj_flags = CAN_BE_HIT
	..()

/obj/structure/bars/grille/redstone_triggered()
	if(obj_broken)
		return

	togg = !togg
	playsound(src, 'sound/foley/trap_arm.ogg', 100)
	if(togg)

		icon_state = "floorgrilleopen"
		obj_flags = CAN_BE_HIT
		var/turf/T = loc
		if(istype(T))
			for(var/mob/living/M in loc)
				T.Entered(M)
	else

		icon_state = "floorgrille"
		obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP

/obj/structure/bars/grille/attackby(obj/item/I, mob/user, params)
	. = ..()
	var/obj/item = user.get_active_held_item()
	if(user.used_intent.type == /datum/intent/chisel )
		if (user.get_skill_level(/datum/skill/craft/engineering) <= 3)
			to_chat(user, span_warning("I need more skill to carve a name into this grille."))
			return
		playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
		user.visible_message("<span class='info'>[user] Carves a name into the grille.</span>")
		if(do_after(user, 10))
			var/grillename
			grillename = input("What name would you like to carve into the grille?")
			if (grillename)
				name = grillename + "(grille)"
				desc = "a grille with a name carved into it"
			else
				name = "grille"
				desc = "a grille with a carving scratched out"
			playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
		return
	else if(istype(item, /obj/item/rogueweapon/chisel/assembly))
		to_chat(user, span_warning("You most use both hands to rename the grille."))

/obj/structure/bars/pipe
	name = "bronze pipe"
	desc = ""
	icon_state = "pipe"
	density = FALSE
	layer = TABLE_LAYER
	plane = GAME_PLANE
	damage_deflection = 5
	blade_dulling = DULLING_BASHCHOP
	obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP
	attacked_sound = list('sound/combat/hits/onmetal/grille (1).ogg', 'sound/combat/hits/onmetal/grille (2).ogg', 'sound/combat/hits/onmetal/grille (3).ogg')
	var/togg = FALSE

/obj/structure/bars/pipe/left
	name = "bronze pipe"
	desc = ""
	icon_state = "pipe2"
	dir = WEST
	pixel_x = 19

//===========================

/obj/structure/fluff/clock
	name = "clock"
	desc = "A large grandfather clock; the cutting edge of modern technology."
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "clock"
	density = FALSE
	anchored = FALSE
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	blade_dulling = DULLING_BASHCHOP
	max_integrity = 100
	integrity_failure = 0.5
	dir = SOUTH
	break_sound = "glassbreak"
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = 'sound/combat/hits/onglass/glasshit.ogg'
	var/datum/looping_sound/clockloop/soundloop
	drag_slowdown = 3

/obj/structure/fluff/clock/Initialize()
	soundloop = new(src, FALSE)
	soundloop.start()
	. = ..()
	var/static/list/loc_connections = list(COMSIG_ATOM_EXIT = PROC_REF(on_exit))
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/fluff/clock/Destroy()
	if(soundloop)
		soundloop.stop()
	..()

/obj/structure/fluff/clock/obj_break(damage_flag)
	icon_state = "b[initial(icon_state)]"
	if(soundloop)
		soundloop.stop()
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
	..()

/obj/structure/fluff/clock/attack_right(mob/user)
	handle_special_items_retrieval(user, src)
	return

/obj/structure/fluff/clock/examine(mob/user)
	. = ..()
	if(obj_broken)
		return
	var/day = "... actually, WHAT dae is it?"
	switch(GLOB.dayspassed)
		if(1)
			day = "Moon's dae."
		if(2)
			day = "Tiw's dae."
		if(3)
			day = "Wedding's dae."
		if(4)
			day = "Thule's dae."
		if(5)
			day = "Freyja's dae."
		if(6)
			day = "Saturn's dae."
		if(7)
			day = "Sun's dae."
	. += "Oh no, it's [station_time_timestamp("hh:mm")] on a [day]"
//		if(SSshuttle.emergency.mode == SHUTTLE_DOCKED)
//			if(SSshuttle.emergency.timeLeft() < 30 MINUTES)
//				. += span_warning("The last boat will leave in [round(SSshuttle.emergency.timeLeft()/600)] minutes.")

/obj/structure/fluff/clock/CanAStarPass(ID, to_dir, caller)
	if(to_dir == dir)
		return FALSE // don't even bother climbing over it
	return ..()

/obj/structure/fluff/clock/CanPass(atom/movable/mover, turf/target)
	if(get_dir(loc, mover) == dir)
		return 0
	return 1

/obj/structure/fluff/clock/proc/on_exit(datum/source, atom/movable/leaving, atom/new_location)
	SIGNAL_HANDLER
	if(get_dir(leaving.loc, new_location) == dir)
		leaving.Bump(src)
		return COMPONENT_ATOM_BLOCK_EXIT

/obj/structure/fluff/wallclock
	name = "clock"
	desc = "Second greatest of all tyrants."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "wallclock"
	density = FALSE
	anchored = TRUE
	layer = BELOW_MOB_LAYER
	blade_dulling = DULLING_BASHCHOP
	max_integrity = 100
	integrity_failure = 0.5
	var/datum/looping_sound/clockloop/soundloop
	break_sound = "glassbreak"
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = 'sound/combat/hits/onglass/glasshit.ogg'
	pixel_y = 32

/obj/structure/fluff/wallclock/attack_right(mob/user)
	handle_special_items_retrieval(user, src)
	return

/obj/structure/fluff/wallclock/Destroy()
	if(soundloop)
		soundloop.stop()
	..()

/obj/structure/fluff/wallclock/examine(mob/user)
	. = ..()
	if(obj_broken)
		return
	var/day = "... actually, WHAT dae is it?"
	switch(GLOB.dayspassed)
		if(1)
			day = "Moon's dae."
		if(2)
			day = "Tiw's dae."
		if(3)
			day = "Wedding's dae."
		if(4)
			day = "Thule's dae."
		if(5)
			day = "Freyja's dae."
		if(6)
			day = "Saturn's dae."
		if(7)
			day = "Sun's dae."
	. += "Oh no, it's [station_time_timestamp("hh:mm")] on a [day]"

/obj/structure/fluff/wallclock/Initialize()
	soundloop = new(src, FALSE)
	soundloop.start()
	. = ..()

/obj/structure/fluff/wallclock/obj_break(damage_flag)
	icon_state = "b[initial(icon_state)]"
	if(soundloop)
		soundloop.stop()
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
	..()

/obj/structure/fluff/wallclock/l
	pixel_y = 0
	pixel_x = -32
/obj/structure/fluff/wallclock/r
	pixel_y = 0
	pixel_x = 32
//vampire
/obj/structure/fluff/wallclock/vampire
	name = "ancient clock"
	desc = ""
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "wallclockvampire"
	density = FALSE
	anchored = TRUE
	layer = BELOW_MOB_LAYER
	blade_dulling = DULLING_BASHCHOP
	max_integrity = 100
	integrity_failure = 0.5
	pixel_y = 32

/obj/structure/fluff/wallclock/vampire/l
	pixel_y = 0
	pixel_x = -32
/obj/structure/fluff/wallclock/vampire/r
	pixel_y = 0
	pixel_x = 32

/obj/structure/fluff/signage
	name = "sign"
	desc = ""
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "shitsign"
	density = TRUE
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	blade_dulling = DULLING_BASHCHOP
	max_integrity = 500
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')

/obj/structure/fluff/signage/examine(mob/user)
	. = ..()
	if(!user.is_literate())
		. += "I have no idea what it says."
	else
		. += "It says \"AZURE PEAK\""

/obj/structure/fluff/buysign
	icon_state = "signwrote"
	name = "sign"
	desc = ""
	icon = 'icons/roguetown/misc/structure.dmi'
/obj/structure/fluff/buysign/examine(mob/user)
	. = ..()
	if(!user.is_literate())
		. += "I have no idea what it says."
	else
		. += "It says \"IMPORTS\""

/obj/structure/fluff/sellsign
	icon_state = "signwrote"
	name = "sign"
	desc = ""
	icon = 'icons/roguetown/misc/structure.dmi'
/obj/structure/fluff/sellsign/examine(mob/user)
	. = ..()
	if(!user.is_literate())
		. += "I have no idea what it says."
	else
		. += "It says \"EXPORTS\""


/obj/structure/fluff/customsign
	name = "sign"
	desc = ""
	icon_state = "sign"
	var/wrotesign
	max_integrity = 500
	blade_dulling = DULLING_BASHCHOP
	icon = 'icons/roguetown/misc/structure.dmi'

/obj/structure/fluff/customsign/examine(mob/user)
	. = ..()
	if(wrotesign)
		if(!user.is_literate())
			. += "I have no idea what it says."
		else
			. += "It says \"[wrotesign]\"."

/obj/structure/fluff/customsign/attackby(obj/item/W, mob/user, params)
	if(!user.cmode)
		if(!user.is_literate())
			to_chat(user, span_warning("I do not know how to write."))
			return
		if((user.used_intent.blade_class == BCLASS_STAB) && (W.wlength == WLENGTH_SHORT))
			if(wrotesign)
				to_chat(user, span_warning("Something is already carved here."))
				return
			else
				var/inputty = stripped_input(user, "What would you like to carve here?", "", null, 200)
				if(inputty && !wrotesign)
					wrotesign = inputty
					icon_state = "signwrote"
		else
			to_chat(user, span_warning("Alas, this will not work. I could carve words, if I stabbed at this with something posessing a short, sharp point. A knife comes to mind."))
			return
	..()

/obj/structure/fluff/alch
	name = "alchemical lab"
	desc = ""
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "alch"
	density = TRUE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	blade_dulling = DULLING_BASHCHOP
	max_integrity = 450
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = list("sound/combat/hits/onmetal/metalimpact (1).ogg", "sound/combat/hits/onmetal/metalimpact (2).ogg")

/obj/structure/fluff/alch/folding
	name = "folding alchemical lab"
	desc = "A compact laboratory. Laid out and ready to work."
	icon = 'icons/roguetown/misc/gadgets.dmi'
	icon_state = "foldingAlchstationDeployed"
	max_integrity = 350
	debris = list(/obj/item/grown/log/tree/small = 2)
	climbable = TRUE
	climb_offset = 10

/obj/structure/fluff/alch/folding/examine()
	. = ..()
	. += span_blue("Right-Click to fold the lab.")

/obj/structure/fluff/alch/folding/attack_right(mob/user)
	if(do_after(user, 5 SECONDS, target = src))
		user.visible_message(span_notice("[user] folds [src]."), span_notice("You fold [src]."))
		new /obj/item/folding_alchstation_stored(drop_location())
		qdel(src)
		return ..()

/obj/structure/fluff/statue
	name = "statue"
	desc = ""
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "bstatue"
	density = FALSE
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	blade_dulling = DULLING_BASH
	max_integrity = 300
	dir = SOUTH

/obj/structure/fluff/statue/Initialize()
	. = ..()
	var/static/list/loc_connections = list(COMSIG_ATOM_EXIT = PROC_REF(on_exit))
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/fluff/statue/OnCrafted(dirin, user)
	dirin = turn(dirin, 180)
	. = ..()

/obj/structure/fluff/statue/attack_right(mob/user)
	handle_special_items_retrieval(user, src)

/obj/structure/fluff/statue/CanPass(atom/movable/mover, turf/target)
	if(get_dir(loc, mover) == dir)
		return 0
	return !density

/obj/structure/fluff/statue/CanAStarPass(ID, to_dir, caller)
	if(to_dir == dir)
		return FALSE // don't even bother climbing over it
	return ..()

/obj/structure/fluff/statue/proc/on_exit(datum/source, atom/movable/leaving, atom/new_location)
	SIGNAL_HANDLER
	if(get_dir(leaving.loc, new_location) == dir)
		leaving.Bump(src)
		return COMPONENT_ATOM_BLOCK_EXIT

/obj/structure/fluff/statue/gargoyle
	icon_state = "gargoyle"

/obj/structure/fluff/statue/aasimar
	icon_state = "aasimar"

/obj/structure/fluff/statue/gargoyle/candles
	icon_state = "gargoyle_candles"

/obj/structure/fluff/statue/gargoyle/moss
	icon_state = "mgargoyle"

/obj/structure/fluff/statue/gargoyle/moss/candles
	icon_state = "mgargoyle_candles"

/obj/structure/fluff/statue/knight
	name = "knightly statue"
	desc = "No eyes are visible behind its visor."
	icon_state = "knightstatue_l"

/obj/structure/fluff/statue/astrata
	name = "astrata statue"
	desc = "A stone statue of the sun Goddess Astrata. Bless."
	icon_state = "astrata"
	icon = 'icons/roguetown/misc/tallandwide.dmi'

/obj/structure/fluff/statue/astrata/gold
	name = "ornamental astrata statue"
	desc = "An ornamental stone statue of the sun Goddess Astrata, decorated with golden jewelry. Bless."
	icon_state = "astrata_bling"

//Why are all of these in one giant file.
/obj/structure/fluff/statue/abyssor
	name = "abyssor statue"
	desc = "A slate statue of the ancient god abyssor. One of many depictions drawn from a dream no doubt. This particular one is horrifying to look at."
	icon_state = "abyssor"
	icon = 'icons/roguetown/misc/tallandwide.dmi'
	pixel_x = -16

/obj/structure/fluff/statue/abyssor/dolomite
	name = "abyssor statue"
	desc = "A rare dolomite statue of the ancient god abyssor. Hewn from bleached rock as if the shimmer makes his faceless gaze any less terrifying."
	icon_state = "abyssor_dolomite"

/obj/structure/fluff/statue/knight/r
	icon_state = "knightstatue_r"

/obj/structure/fluff/statue/knight/interior
	icon_state = "oknightstatue_l"

/obj/structure/fluff/statue/knight/interior/r
	icon_state = "oknightstatue_r"

/obj/structure/fluff/statue/knight/interior/r/bronze
	color = "#ff9c1a"

/obj/structure/fluff/statue/knightalt
	name = "knightly statue"
	desc = "Ever-watchful, faceless, and without independent will. An ideal of chivalry."
	icon_state = "knightstatue2_l"

/obj/structure/fluff/statue/knightalt/r
	icon_state = "knightstatue2_r"


/obj/structure/fluff/statue/myth
	icon_state = "myth"
	density = TRUE

/obj/structure/fluff/statue/psy
	icon_state = "psy"
	icon = 'icons/roguetown/misc/96x96.dmi'
	pixel_x = -32

/obj/structure/fluff/statue/psybloody
	icon_state = "psy_bloody"
	icon = 'icons/roguetown/misc/96x96.dmi'
	pixel_x = -32


/obj/structure/fluff/statue/small
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "elfs"

/obj/structure/fluff/statue/pillar
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "pillar"

/obj/structure/fluff/statue/femalestatue
	icon = 'icons/roguetown/misc/ay.dmi'
	icon_state = "1"
	pixel_x = -32
	pixel_y = -16

/obj/structure/fluff/statue/femalestatue1
	icon = 'icons/roguetown/misc/ay.dmi'
	icon_state = "2"
	pixel_x = -32
	pixel_y = -16

/obj/structure/fluff/statue/femalestatue2
	icon = 'icons/roguetown/misc/ay.dmi'
	icon_state = "5"
	pixel_x = -32
	pixel_y = -16

/obj/structure/fluff/statue/femalestatue/zizo
	icon = 'icons/roguetown/misc/ay.dmi'
	icon_state = "4"
	pixel_x = -32
	pixel_y = -16

/obj/structure/fluff/statue/scare
	name = "scarecrow"
	icon_state = "td"

/obj/structure/fluff/statue/tdummy
	name = "practice dummy"
	icon_state = "p_dummy"
	icon = 'icons/roguetown/misc/structure.dmi'

/obj/structure/fluff/statue/tdummy/attack_hand(mob/user)
	if(user.cmode || !user.mind || !isliving(user))
		return ..()
	practice(user, /datum/skill/combat/unarmed, ATTACK_EFFECT_PUNCH)

/obj/structure/fluff/statue/tdummy/attackby(obj/item/attacking_weapon, mob/user, params)
	if(user.cmode || !attacking_weapon.associated_skill || !user.mind || !isliving(user))
		return ..()
	if(attacking_weapon.max_blade_int)
		attacking_weapon.remove_bintegrity(5)
	if(!ispath(attacking_weapon.associated_skill, /datum/skill/combat))
		to_chat(user, span_warning("I don't think this weapon's skill cannot be practiced on a dummy..."))
		return
	practice(user, attacking_weapon.associated_skill, user.used_intent.animname)

/obj/structure/fluff/statue/tdummy/proc/practice(var/mob/living/living_mob, var/associated_skill, var/attack_animation)
	living_mob.changeNext_move(CLICK_CD_MELEE)
	living_mob.stamina_add(rand(4, 6))

	var/probby = (living_mob.STALUC / 10) * 100
	probby = min(probby, 99)
	if(!(living_mob.mobility_flags & MOBILITY_STAND))
		probby = 0
	if(living_mob.STAINT < 3)
		probby = 0
	if(prob(probby) && !living_mob.buckled)
		living_mob.do_attack_animation(src, attack_animation)
		living_mob.visible_message(span_info("[living_mob] trains on [src]!"))
		var/amt2raise = living_mob.STAINT * 0.35
		if(!can_train_combat_skill(living_mob, associated_skill, SKILL_LEVEL_APPRENTICE))
			to_chat(living_mob, span_warning("I've learned all I can from doing this, it's time for the real thing."))
			amt2raise = 0
		if(amt2raise > 0)
			living_mob.mind.add_sleep_experience(associated_skill, amt2raise, FALSE)
		playsound(loc, pick('sound/combat/hits/onwood/education1.ogg', 'sound/combat/hits/onwood/education2.ogg', 'sound/combat/hits/onwood/education3.ogg'), rand(50,100), FALSE)
	else
		living_mob.visible_message(span_danger("[living_mob] trains on [src], but [src] ripostes!"))
		living_mob.AdjustKnockdown(1)
		living_mob.throw_at(get_step(living_mob, get_dir(src,living_mob)), 2, 2, living_mob, spin = FALSE)
		playsound(loc, 'sound/combat/hits/kick/stomp.ogg', 100, TRUE, -1)
	flick(pick("p_dummy_smashed", "p_dummy_smashedalt"), src)

/obj/structure/fluff/statue/spider
	name = "mother"
	icon_state = "spidercore"

/obj/structure/fluff/statue/spider/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/reagent_containers/food/snacks/rogue/honey/spider))
		if(user.mind)
			if(user.mind.special_role == "Dark Elf")
				playsound(loc,'sound/misc/eat.ogg', rand(30,60), TRUE)
				SSmapping.retainer.delf_contribute += 1
				if(SSmapping.retainer.delf_contribute >= SSmapping.retainer.delf_goal)
					say("YOU HAVE DONE WELL, MY CHILD.",language = /datum/language/elvish)
				else
					say("BRING ME [SSmapping.retainer.delf_goal - SSmapping.retainer.delf_contribute] MORE. I HUNGER.",language = /datum/language/elvish)
				qdel(W)
				return TRUE
	..()

/obj/structure/fluff/statue/evil
	name = "idol"
	desc = "A statue built to the robber-god, Matthios, who stole the gift of fire from the underworld. It is said that he grants the wishes of those pagan bandits (free folk) who feed him money and valuable metals."
	icon_state = "evilidol"
	icon = 'icons/roguetown/misc/structure.dmi'
// What items the idol will accept
	var/treasuretypes = list(
		/obj/item/roguecoin,
		/obj/item/roguegem,
		/obj/item/clothing/ring,
		/obj/item/ingot/gold,
		/obj/item/ingot/silver,
		/obj/item/ingot/blacksteel,
		/obj/item/clothing/neck/roguetown/psicross,
		/obj/item/reagent_containers/glass/cup,
		/obj/item/candle/gold,
		/obj/item/candle/silver,
		/obj/item/candle/candlestick/silver,
		/obj/item/candle/candlestick/gold,
		/obj/item/kitchen/fork/silver,
		/obj/item/kitchen/fork/gold,
        /obj/item/kitchen/spoon/silver,
		/obj/item/kitchen/spoon/gold,
		/obj/item/roguestatue,
		/obj/item/riddleofsteel,
		/obj/item/listenstone,
		/obj/item/clothing/neck/roguetown/shalal,
		/obj/item/clothing/neck/roguetown/horus,
		/obj/item/rogue/painting,
		/obj/item/clothing/head/roguetown/crown/serpcrown,
		/obj/item/clothing/head/roguetown/vampire,
		/obj/item/scomstone,
		/obj/item/reagent_containers/lux
	)

/obj/structure/fluff/statue/evil/attackby(obj/item/W, mob/user, params)
	if(!HAS_TRAIT(user, TRAIT_COMMIE))
		return
	var/donatedamnt = W.get_real_price()
	if(user.mind)
		if(user)
			if(W.flags_1 & HOARDMASTER_SPAWNED_1)
				to_chat(user, span_warning("This item is from the Hoard!"))
				return
			if(W.sellprice <= 0)
				to_chat(user, span_warning("This item is worthless."))
				return
			var/proceed_with_offer = FALSE
			for(var/TT in treasuretypes)
				if(istype(W, TT))
					proceed_with_offer = TRUE
					break
			if(proceed_with_offer)
				playsound(loc,'sound/items/carvty.ogg', 50, TRUE)
				qdel(W)
				for(var/mob/player in GLOB.player_list)
					if(player.mind)
						if(player.mind.has_antag_datum(/datum/antagonist/bandit))
							var/datum/antagonist/bandit/bandit_players = player.mind.has_antag_datum(/datum/antagonist/bandit)
							record_round_statistic(STATS_SHRINE_VALUE, W.get_real_price())
							bandit_players.favor += donatedamnt
							bandit_players.totaldonated += donatedamnt
							to_chat(player, ("<font color='yellow'>[user.name] donates [donatedamnt] to the shrine! You now have [bandit_players.favor] favor.</font>"))

			else
				to_chat(user, span_warning("This item isn't a good offering."))
				return
	..()

/obj/structure/fluff/psycross
	name = "pantheon cross"
	desc = "Symbol of the Divine Pantheon, the religion of ten - formerly eleven - deities which reigns throughout most of the known world. Their divine order must be maintained."
	icon_state = "psycross"
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	break_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
	density = FALSE
	anchored = TRUE
	blade_dulling = DULLING_BASHCHOP
	layer = BELOW_MOB_LAYER
	max_integrity = 100
	var/chance2hear = 30
	buckleverb = "crucifie"
	can_buckle = 1
	buckle_lying = 0
	breakoutextra = 10 MINUTES
	dir = NORTH
	buckle_requires_restraints = 1
	buckle_prevents_pull = 1
	var/divine = TRUE
	obj_flags = UNIQUE_RENAME | CAN_BE_HIT

/obj/structure/fluff/psycross/Initialize()
	. = ..()
	become_hearing_sensitive()
	var/static/list/loc_connections = list(COMSIG_ATOM_EXIT = PROC_REF(on_exit))
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/fluff/psycross/Destroy()
	lose_hearing_sensitivity()
	return ..()

/obj/structure/fluff/psycross/post_buckle_mob(mob/living/M)
	..()
	M.set_mob_offsets("bed_buckle", _x = 0, _y = 2)
	M.setDir(SOUTH)

/obj/structure/fluff/psycross/post_unbuckle_mob(mob/living/M)
	..()
	M.reset_offsets("bed_buckle")

/obj/structure/fluff/psycross/CanPass(atom/movable/mover, turf/target)
	if(istype(mover, /mob/camera))
		return TRUE
	if(get_dir(loc, mover) == dir)
		return FALSE
	return !density

/obj/structure/fluff/psycross/CanAStarPass(ID, to_dir, caller)
	if(to_dir == dir)
		return FALSE // don't even bother climbing over it
	return ..()

/obj/structure/fluff/psycross/proc/on_exit(datum/source, atom/movable/leaving, atom/new_location)
	SIGNAL_HANDLER
	if(get_dir(leaving.loc, new_location) == dir)
		leaving.Bump(src)
		return COMPONENT_ATOM_BLOCK_EXIT

/obj/structure/fluff/psycross/copper
	name = "pantheon cross"
	icon_state = "psycrosschurch"
	break_sound = null
	attacked_sound = list("sound/combat/hits/onmetal/metalimpact (1).ogg", "sound/combat/hits/onmetal/metalimpact (2).ogg")
	chance2hear = 66

/obj/structure/fluff/psycross/crafted
	name = "wooden pantheon cross"
	icon_state = "psycrosscrafted"
	max_integrity = 80
	chance2hear = 10

/obj/structure/fluff/psycross/psycrucifix
	name = "wooden psydonic crucifix"
	desc = "A rarely seen symbol of absolute and devoted certainty, more common in Otava: HE yet lyves. HE yet breathes."
	icon_state = "psycruci"
	max_integrity = 80
	chance2hear = 10

/obj/structure/fluff/psycross/psycrucifix/stone
	name = "stone psydonic crucifix"
	desc = "Formed of stone, this great Psycross symbolises that HE is forever ENDURING. Considered a rare sight upon the Peaks."
	icon_state = "psycruci_r"
	max_integrity = 120
	chance2hear = 10

/obj/structure/fluff/psycross/psycrucifix/silver
	name = "silver psydonic crucifix"
	icon_state = "psycruci_s"
	desc = "Constructed of Blessed Silver, this crucifix symbolises absolute faith in the ONE - For PSYDON WEEPS, for all mortal ilk. PSYDON WEEPS, for all who walk upon the soil. PSYDON WEEPS..."
	attacked_sound = list("sound/combat/hits/onmetal/metalimpact (1).ogg", "sound/combat/hits/onmetal/metalimpact (2).ogg")
	max_integrity = 450
	chance2hear = 10

/obj/structure/fluff/psycross/zizocross
	name = "inverted cross"
	desc = "An unholy symbol. Blasphemy for most, reverence for few."
	icon_state = "invertedcross"
	divine = FALSE

/obj/structure/fluff/psycross/attackby(obj/item/W, mob/user, params)
	if(user.mind)
		if(user.mind.assigned_role == "Bishop")
			if(istype(W, /obj/item/reagent_containers/food/snacks/grown/apple))
				if(!istype(get_area(user), /area/rogue/indoors/town/church/chapel))
					to_chat(user, span_warning("I need to do this in the chapel."))
					return FALSE
				var/marriage
				var/obj/item/reagent_containers/food/snacks/grown/apple/A = W
				//The MARRIAGE TEST BEGINS
				if(A.bitten_names.len)
					if(A.bitten_names.len == 2)
						//Groom provides the surname that the bride will take
						var/mob/living/carbon/human/thegroom
						var/mob/living/carbon/human/thebride
						//Did anyone get cold feet on the wedding?
						for(var/mob/M in viewers(src, 7))

							if(thegroom && thebride)
								break
							if(!ishuman(M))
								continue
							var/mob/living/carbon/human/C = M
							/*
							* This is for making the first biters name
							* always be applied to the groom.
							* second. This seems to be the best way
							* to use the least amount of variables.
							*/
							var/name_placement = 1
							for(var/X in A.bitten_names)
								//I think that guy is dead.
								if(C.stat == DEAD)
									continue
								//That person is not a player or afk.
								if(!C.client)
									continue
								//Gotta get a divorce first
								if(C.marriedto)
									continue
								if(C.real_name == X)
									//I know this is very sloppy but its alot less code.
									switch(name_placement)
										if(1)
											if(thegroom)
												continue
											thegroom = C
										if(2)
											if(thebride)
												continue
											thebride = C

									name_placement++

						//WE FOUND THEM LETS GET THIS SHOW ON THE ROAD!
						if(!thegroom || !thebride)

							return
						//Alright now for the boring surname formatting.
						var/surname2use
						var/index = findtext(thegroom.real_name, " ")
						var/bridefirst
						thegroom.original_name = thegroom.real_name
						thebride.original_name = thebride.real_name
						if(!index)
							surname2use = thegroom.dna.species.random_surname()
						else
							/*
							* This code prevents inheriting the last name of
							* " of wolves" or " the wolf"
							* remove this if you want "Skibbins of wolves" to
							* have his bride become "Sarah of wolves".
							*/
							if(findtext(thegroom.real_name, " of ") || findtext(thegroom.real_name, " the "))
								surname2use = thegroom.dna.species.random_surname()
								thegroom.change_name(copytext(thegroom.real_name, 1,index))
							else
								surname2use = copytext(thegroom.real_name, index)
								thegroom.change_name(copytext(thegroom.real_name, 1,index))
						index = findtext(thebride.real_name, " ")
						if(index)
							thebride.change_name(copytext(thebride.real_name, 1,index))
						bridefirst = thebride.real_name
						thegroom.change_name(thegroom.real_name + surname2use)
						thebride.change_name(thebride.real_name + surname2use)
						thegroom.marriedto = thebride.real_name
						thebride.marriedto = thegroom.real_name
						thegroom.adjust_triumphs(1)
						thebride.adjust_triumphs(1)
						//Bite the apple first if you want to be the groom.
						priority_announce("[thegroom.real_name] has married [bridefirst]!", title = "Holy Union!", sound = 'sound/misc/bell.ogg')
						marriage = TRUE
						qdel(A)

				if(!marriage)
					A.burn()
					return
	return ..()


/obj/structure/fluff/psycross/copper/Destroy()
	addomen("psycross")
	..()

/obj/structure/fluff/psycross/proc/AOE_flash(mob/user, range = 15, power = 5, targeted = FALSE)
	var/list/mob/targets = get_flash_targets(get_turf(src), range, FALSE)
	for(var/mob/living/carbon/C in targets)
		flash_carbon(C, user, power, targeted, TRUE)
	return TRUE

/obj/structure/fluff/psycross/proc/get_flash_targets(atom/target_loc, range = 15)
	if(!target_loc)
		target_loc = loc
	if(isturf(target_loc) || (ismob(target_loc) && isturf(target_loc.loc)))
		return viewers(range, get_turf(target_loc))
	else
		return typecache_filter_list(target_loc.GetAllContents(), GLOB.typecache_living)

/obj/structure/fluff/psycross/proc/flash_carbon(mob/living/carbon/M, mob/user, power = 15, targeted = TRUE, generic_message = FALSE)
	if(!istype(M))
		return
	if(user)
		log_combat(user, M, "[targeted? "flashed(targeted)" : "flashed(AOE)"]", src)
	else //caused by emp/remote signal
		M.log_message("was [targeted? "flashed(targeted)" : "flashed(AOE)"]",LOG_ATTACK)
	if(generic_message && M != user)
		to_chat(M, span_danger("[src] emits a blinding light!"))
	if(M.flash_act())
		var/diff = power - M.confused
		M.confused += min(power, diff)

/obj/structure/fluff/beach_umbrella/security
	icon_state = "hos_brella"

/obj/structure/fluff/beach_umbrella/science
	icon_state = "rd_brella"

/obj/structure/fluff/beach_umbrella/engine
	icon_state = "ce_brella"

/obj/structure/fluff/beach_umbrella/cap
	icon_state = "cap_brella"

/obj/structure/fluff/beach_umbrella/syndi
	icon_state = "syndi_brella"

/obj/structure/fluff/clockwork
	name = "Clockwork Fluff"
	icon = 'icons/obj/clockwork_objects.dmi'
	deconstructible = FALSE

/obj/structure/fluff/clockwork/alloy_shards
	name = "replicant alloy shards"
	desc = ""
	icon_state = "alloy_shards"

/obj/structure/fluff/clockwork/alloy_shards/small
	icon_state = "shard_small1"

/obj/structure/fluff/clockwork/alloy_shards/medium
	icon_state = "shard_medium1"

/obj/structure/fluff/clockwork/alloy_shards/medium_gearbit
	icon_state = "gear_bit1"

/obj/structure/fluff/clockwork/alloy_shards/large
	icon_state = "shard_large1"

/obj/structure/fluff/clockwork/blind_eye
	name = "blind eye"
	desc = ""
	icon_state = "blind_eye"

/obj/structure/fluff/clockwork/fallen_armor
	name = "fallen armor"
	desc = ""
	icon_state = "fallen_armor"

/obj/structure/fluff/clockwork/clockgolem_remains
	name = "clockwork golem scrap"
	desc = ""
	icon_state = "clockgolem_dead"

/obj/structure/fluff/headstake
	name = "head on a stake"
	desc = ""
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "headstake"
	density = FALSE
	anchored = TRUE
	dir = SOUTH
	var/obj/item/grown/log/tree/stake/stake
	var/obj/item/bodypart/head/victim


/obj/structure/fluff/headstake/CheckParts(list/parts_list)
	..()
	victim = locate(/obj/item/bodypart/head) in parts_list
	name = "[victim.name] on a stake"
	update_icon()
	stake = locate(/obj/item/grown/log/tree/stake) in parts_list

///obj/structure/fluff/headstake/Initialize()
//	. = ..()

/obj/structure/fluff/headstake/OnCrafted(dirin, user)
	dir = SOUTH
	pixel_x = rand(-8, 8)
	return

/obj/structure/fluff/headstake/update_icon()
	..()
	var/obj/item/bodypart/head/H = locate() in contents
	var/mutable_appearance/MA = new()
	if(H)
		MA.copy_overlays(H)
		H.pixel_y = rand(9, 11)
		H.pixel_x = pixel_x
		H.dir = SOUTH
		add_overlay(H)

/obj/structure/fluff/headstake/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	to_chat(user, span_notice("I take down [src]."))
	victim.forceMove(drop_location())
	victim = null
	stake.forceMove(drop_location())
	stake = null
	qdel(src)
