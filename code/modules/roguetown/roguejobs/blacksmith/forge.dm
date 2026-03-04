
/obj/machinery/light/rogue/forge
	icon = 'icons/roguetown/misc/forge.dmi'
	name = "stone forge"
	desc = "This forge sings of war and creation."
	icon_state = "forge0"
	base_state = "forge"
	density = TRUE
	anchored = TRUE
	on = FALSE
	roundstart_forbid = TRUE
	climbable = TRUE
	climb_time = 0
	var/heat_time = 20 SECONDS

/obj/machinery/light/rogue/forge/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("When held with a pair of tongs, left-clicking the forge with an ingot will temporarily heat it up. Heated-up ingots can then be placed on an anvil and pounded into a variety of recipes.")
	. += span_info("Left-clicking the forge with a torch, lamptern, flint, or other type of ignitioneer will light it back up. Fuel - like wood and books - can be added by left-clicking the forge with it.")

/obj/machinery/light/rogue/forge/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/rogueweapon/tongs) && on)
		var/obj/item/rogueweapon/tongs/T = W
		if(T.hingot)
			var/tyme = world.time
			T.hott = tyme
			addtimer(CALLBACK(T, TYPE_PROC_REF(/obj/item/rogueweapon/tongs, make_unhot), tyme), heat_time)
			T.update_icon()
			user.visible_message(span_info("[user] heats the bar."))
			var/obj/item/rogueweapon/tongs/heldstuff = user.get_active_held_item()
			if(istype(heldstuff, /obj/item/rogueweapon/tongs/stone))
				heldstuff.obj_integrity -= 1
				if(heldstuff.obj_integrity <= 0)
					heldstuff.hingot.forceMove(get_turf(user))
					heldstuff.hingot = null
					heldstuff.hott = FALSE
					heldstuff.obj_break()
			return
	return ..()
