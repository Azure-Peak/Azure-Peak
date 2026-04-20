///so this is the most important step of the dungeon maker if you don't put these down right your gonna obliterate the dungeon
/obj/effect/dungeon_directional_helper
	name = "Dungeon Direction Helper"
	icon = 'icons/effects/dungeon_helper.dmi'
	icon_state = "helper"
	invisibility = INVISIBILITY_ABSTRACT
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = TRUE
	var/top = FALSE

/obj/effect/dungeon_directional_helper/Initialize(mapload)
	. = ..()
	if(mapload)
		SSdungeon_generator.markers |= src
	
	alpha = 0

/obj/effect/dungeon_directional_helper/Destroy()
	SSdungeon_generator.markers -= src
	return ..()

/obj/effect/dungeon_directional_helper/south
	dir = SOUTH
/obj/effect/dungeon_directional_helper/north
	dir = NORTH
/obj/effect/dungeon_directional_helper/east
	dir = EAST
/obj/effect/dungeon_directional_helper/west
	dir = WEST