// This is a set of WIP code made with the intent on giving dungeon creators more tools in their toolbox when making PVE dungeons. :3


/obj/structure/dungeontool/trigger // A hidden obj that sends a redstone trigger when crossed by a mob with a mind
	name = "invisible trigger plate"
	desc = "Used for quietly triggering redstone structures. Only triggered by mobs with a mind"
	icon = 'icons/roguetown/misc/traps.dmi'
	icon_state = "pressureplate"
	max_integrity = 9999 
	damage_deflection = 100
	opacity = FALSE
	density = FALSE
	anchored = TRUE
	invisibility = 101

/obj/structure/dungeontool/trigger/Crossed(atom/movable/AM)
	. = ..()
	if(!anchored)
		return
	if(ismob(AM) && AM:mind)
		triggerquiet()

/obj/structure/dungeontool/trigger/proc/triggerquiet()
	for(var/obj/structure/O in redstone_attached)
		spawn(0) O.redstone_triggered()

/obj/structure/dungeontool/triggered // A simple obj that does a thing when activated by redstone. Create subtypes, do not use this parent obj
	name = "triggered obj"
	desc = "Does a thing when triggered"
	icon = 'icons/roguetown/misc/traps.dmi'
	icon_state = "base_trap_plate"
	max_integrity = 9999
	damage_deflection = 100
	opacity = FALSE
	density = FALSE
	anchored = TRUE
	alpha = 0 // needs to do multiple things but not be interacted with directly by mobs
	mouse_opacity = 0					// ^^^^
	nomouseover = TRUE					// ^^^^
	redstone_id = "" 
	var/activated = FALSE // checking if the triggered should trigger once or indefinitely

/obj/structure/dungeontool/triggered/redstone_triggered() //simple obj's thing that it does when triggered. Create subtypes, do not use parent triggered effect
	if(obj_broken)
		return
	if(!activated)
		playsound(src, 'sound/blank.ogg', 100) 
		visible_message("sends a message to chat in screen wide range from object by default")
		activated = TRUE

/obj/structure/dungeontool/triggered/thiefdaddmobs
	name = "triggered for addmobs trigger"
	redstone_id = "addmobs" 

/obj/structure/dungeontool/triggered/thiefdaddmobs/redstone_triggered()
	if(obj_broken)
		return
	if(!activated)
		activated = TRUE
		playsound(src, 'sound/foley/smash_rock.ogg', 100)
		sleep(15)
		playsound(src, 'sound/foley/smash_rock.ogg', 70)
		sleep(15)
		playsound(src, 'sound/foley/smash_rock.ogg', 40)
		visible_message("That sounded pretty loud...")

/obj/structure/dungeontool/triggered/barracksalert
	name = "triggered for barracks alert trigger"
	redstone_id = "barracks" 

/obj/structure/dungeontool/triggered/barracksalert/redstone_triggered()
	if(obj_broken)
		return
	if(!activated)
		playsound(src, 'sound/foley/equip/equip_armor_chain.ogg', 100)

/obj/structure/dungeontool/triggered/invisibleshutterclosed //useful monster closets
	name = "invisible shutter (closed)"
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "shutter0"
	desc = "Can only be opened, but not closed by a redstone trigger."
	density = TRUE
	opacity = TRUE
	dir = SOUTH
	invisibility = 101 //cannot be seen or interacted with and has density and opacity until triggered
	activated = FALSE
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	obj_flags = BLOCK_Z_OUT_DOWN | BLOCK_Z_OUT_UP | BLOCK_Z_IN_DOWN | BLOCK_Z_IN_UP

/obj/structure/dungeontool/triggered/invisibleshutterclosed/redstone_triggered()
	if(obj_broken)
		return
	if(!activated)
		activated = TRUE
		density = FALSE
		opacity = FALSE

/obj/structure/dungeontool/mover //moves mobs and objs in the dir, checks every 1.5 seconds, used for monster closet
	name = "mob mover"
	desc = "moves a mob in the direction indicated."
	icon = 'icons/blanks/32x32.dmi'
	icon_state = "dir_indicator"
	density = FALSE
	opacity = FALSE
	invisibility = 101
	anchored = TRUE

/obj/structure/dungeontool/mover/New()
	..()
	START_PROCESSING(SSobj, src)

/obj/structure/dungeontool/mover/process()
	. = ..()
	move_mobs()

/obj/structure/dungeontool/mover/proc/move_mobs()
	var/turf/T = loc
	if(!istype(T, /turf))
		return
	for(var/mob/M in T.contents)
		step(M, dir)
