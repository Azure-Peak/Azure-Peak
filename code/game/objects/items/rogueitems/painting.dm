
/obj/item/rogue/painting
	name = "painting"
	icon_state = "painting"
	desc = "A guise of before."
	w_class = WEIGHT_CLASS_NORMAL
	static_price = TRUE
	sellprice = 10
	icon = 'icons/roguetown/items/misc.dmi'
	var/deployed_structure = /obj/structure/fluff/walldeco/painting

/obj/item/rogue/painting/attack_turf(turf/T, mob/living/user)
	if(isclosedturf(T))
		if(get_dir(T,user) in GLOB.cardinals)
			to_chat(user, span_warning("I place [src] on the wall."))
			var/obj/structure/S = new deployed_structure(user.loc)
			switch(get_dir(T,user))
				if(NORTH)
					S.pixel_y = -32
				if(SOUTH)
					S.pixel_y = 32
				if(WEST)
					S.pixel_x = 32
				if(EAST)
					S.pixel_x = -32
			qdel(src)
			return
	..()

/obj/structure/fluff/walldeco/painting
	name = "painting"
	desc = "The artist is unknown. The subject is unknown. Maybe a memorial to a corpse that was trampled on the trail to this reality."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "painting_deployed"
	anchored = TRUE
	density = FALSE
	max_integrity = 0
	layer = ABOVE_MOB_LAYER
	var/stolen_painting = /obj/item/rogue/painting

/obj/structure/fluff/walldeco/painting/attack_hand(mob/user)
	if(do_after(user, 30, target = src))
		var/obj/item/I = new stolen_painting(user.loc)
		user.put_in_hands(I)
		qdel(src)
		return
	..()

/obj/structure/fluff/walldeco/painting/queen
	desc = "It's Queen Samantha I of Psydonia. Her late husband would be so proud of what she has accomplished in his realm."
	icon_state = "queenpainting_deployed"
	stolen_painting = /obj/item/rogue/painting/queen

/obj/item/rogue/painting/queen
	icon_state = "queenpainting"
	desc = "It's Queen Samantha I of Psydonia. Her late husband would be so proud of what she has accomplished in his realm."
	dropshrink = 0.5
	sellprice = 20
	deployed_structure = /obj/structure/fluff/walldeco/painting/queen

/obj/item/rogue/painting/seraphina
	icon_state = "seraphinapainting"
	desc = "It's the Holy Priestess, Seraphina; first of Her name, blessed be Her name."
	dropshrink = 0.5
	sellprice = 20
	deployed_structure = /obj/structure/fluff/walldeco/painting/seraphina

/obj/structure/fluff/walldeco/painting/seraphina
	desc = "It's the Holy Priestess, Seraphina; first of Her name, blessed be Her name."
	icon_state = "seraphinapainting_deployed"
	stolen_painting = /obj/item/rogue/painting/seraphina

/obj/item/rogue/painting/skullzhg
	icon_state = "skullpainting"
	desc = "A moody scene depicting a skull and candles on a table. Memento mori."
	sellprice = 20
	deployed_structure = /obj/structure/fluff/walldeco/painting/skull

/obj/structure/fluff/walldeco/painting/skull
	desc = "A moody scene depicting a skull and candles on a table. Memento mori."
	icon_state = "skullpainting_deployed"
	stolen_painting = /obj/item/rogue/painting/skullzhg
