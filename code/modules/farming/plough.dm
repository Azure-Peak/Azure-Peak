/obj/structure/plough
	name = "plough"
	desc = "A heftsome cart with an undercarriage of sloped metal, allowing even the simplest laborers to turn grass-and-dirt into fields of tilled-and-fertile soil."
	icon = 'icons/obj/structures/plough.dmi'
	icon_state = "plough"
	density = TRUE
	max_integrity = 600
	anchored = FALSE
	climbable = FALSE
	facepull = FALSE
	drag_slowdown = 2

/obj/structure/plough/get_mechanics_examine(mob/user)
	. = ..()
	. += span_notice("Control-click the till to grab it. Toggling the 'SNEAK' button while dragging the plough over grass and dirt will automatically turn it into fertile soil, perfect for agricultural work.")
	. += span_notice("If already tilled, dragging the till over such a tile will instantly create a plot for planting crops. Tilling with a plough is always instantaneous, and doesn't require the Farming skill to perform.")
	. += span_notice("Tilling gradually drains your character's stamina with each successfully-tilled tile.")

/obj/structure/plough/Moved(oldLoc, movement_dir)
	. = ..()
	if(pulledby && pulledby.m_intent == MOVE_INTENT_SNEAK)
		user_tries_tilling(pulledby, get_turf(src))

/obj/structure/plough/proc/user_tries_tilling(mob/living/user, turf/location)
	if(istype(location, /turf/open/floor/rogue/grass) || istype(location, /turf/open/floor/rogue/grassred) || istype(location, /turf/open/floor/rogue/grassyel) || istype(location, /turf/open/floor/rogue/grasscold))
		apply_farming_fatigue(user, 10)
		playsound(location,'sound/items/dig_shovel.ogg', 100, TRUE)
		location.ChangeTurf(/turf/open/floor/rogue/dirt, flags = CHANGETURF_INHERIT_AIR)
		return
	if(istype(location, /turf/open/floor/rogue/dirt))
		playsound(location,'sound/items/dig_shovel.ogg', 100, TRUE)
		var/obj/structure/soil/soil = get_soil_on_turf(location)
		if(soil)
			soil.user_till_soil(user)
		else
			apply_farming_fatigue(user, 10)
			new /obj/structure/soil(location)
		return
