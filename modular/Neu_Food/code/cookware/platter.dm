/obj/item/cooking/platter
	name = "platter"
	desc = "For holding meals fit for kings."
	icon = 'modular/Neu_Food/icons/cookware/platter.dmi'
	lefthand_file = 'modular/Neu_Food/icons/food_lefthand.dmi'
	righthand_file = 'modular/Neu_Food/icons/food_righthand.dmi'
	icon_state = "platter"
	resistance_flags = NONE
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
	experimental_inhand = FALSE
	grid_width = 64
	grid_height = 32
	obj_flags = UNIQUE_RENAME


/obj/item/cooking/platter/examine()
	. = ..()
	. += span_info("Can be renamed with a feather. Name will be overridden by plating or finishing food.")

/*
NEW SYSTEM
What it does:
	- The platter stays intact, adds object on top of it. 
	- Examining the platter tells you what is on the platter
	- Adds food overlay to the platre
	- Can remove item with right click
	- Using it will eat the food on it
	- Use initial[name] to revert platter back to being its original name once the food is removed
*/
/*	..................   Food platter   ................... */
/obj/item/cooking/platter/attackby(obj/item/I, mob/user, params)

	if(istype(I, /obj/item/kitchen/fork))
		if(do_after(user, 0.5 SECONDS))
			attack(user, user, user.zone_selected)

	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(I, /obj/item/reagent_containers/food/snacks/))
		if(isturf(loc)&& (found_table))
			if (contents.len == 0)
				playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
				to_chat(user, span_info("I add \the [I.name] to \the [name]."))
				I.forceMove(src)
				var/obj/item/reagent_containers/food/snacks/S = I
				if(S?.faretype < FARE_LAVISH)
					S.faretype++ //Things are tastier on plates.
				update_icon()
			else
				to_chat(user, span_info("Something is already on this [initial(name)]! Remove it first."))
		else
			return ..()	


/obj/item/cooking/platter/attack(mob/living/M, mob/living/user, def_zone)
	if(contents.len > 0)
		if(istype(contents[1],  /obj/item/reagent_containers/food/snacks/))
			var/obj/item/reagent_containers/food/snacks/S = contents[1]
			S.attack(M,user,def_zone)
		update_icon()


/obj/item/cooking/platter/update_icon()
	if(contents.len > 0)
		var/matrix/M = new
		M.Scale(0.8,0.8)
		contents[1].transform = M
		contents[1].pixel_y = 3

		contents[1].vis_flags = VIS_INHERIT_ID | VIS_INHERIT_LAYER | VIS_INHERIT_PLANE
		vis_contents += contents[1]
		name = "platter of [contents[1].name]"
		desc = contents[1].desc
		//Need something better than this in future like a buff
		if(istype(contents[1],  /obj/item/reagent_containers/food/snacks/))
			var/obj/item/reagent_containers/food/snacks/S = contents[1]
			S.bonus_reagents = list(/datum/reagent/consumable/nutriment = 2)
	else
		vis_contents = 0
		name = initial(name)
		desc = initial(desc)


/obj/item/cooking/platter/attack_right(mob/user)
	if(user.get_active_held_item())
		to_chat(user, span_info("I can't do that with my hand full!"))
		return

	if(contents.len >0)
		contents[1].vis_flags = 0
		//No need to change scale since and pixel_y I think all food already resets that when you grab it
		contents[1].icon_state = initial(contents[1].icon_state)
		//sometimes food puts an item in its place!!
		if(istype(contents[1],  /obj/item/reagent_containers/food/snacks/))
			var/obj/item/reagent_containers/food/snacks/S = contents[1]
			S.bonus_reagents = list()
			if(S?.faretype > FARE_IMPOVERISHED)
				S.faretype-- //Less tasty off the plate.
		to_chat(user, span_info("I remove \the [contents[1].name] from \the [initial(name)]"))
		if(!usr.put_in_hands(contents[1]))
			var/atom/movable/S = contents[1]
			S.forceMove(get_turf(src))

	update_icon()

/obj/item/cooking/platter/aalloy
	name = "decrepit platter"
	desc = "Wrought bronze, flattened to serve. The edge remains wet with red; spilled merlot, meaty juices, or blood?"
	icon_state = "aplatter"
	color = "#bb9696"
	sellprice = 15

/obj/item/cooking/platter/copper
	name = "copper platter"
	desc = "A platter made from a sheet of copper. Known to impart a metallic taste when combined with acidic food."
	icon_state = "platter_copper"
	resistance_flags = FIRE_PROOF
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	sellprice = 5

/obj/item/cooking/platter/pewter
	name = "pewter platter"
	desc = "A tin plate that contains just a tinge of lead."
	icon_state = "platter_tin"
	resistance_flags = FIRE_PROOF
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	sellprice = 10

/obj/item/cooking/platter/silver
	name = "silver platter"
	desc = "A fancy silver plate often used by the nobility as a symbol of class."
	icon_state = "platter_silver"
	sellprice = 30
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver

/obj/item/cooking/platter/gold
	name = "gold platter"
	desc = "A fancy gold plate often used by the nobility as a symbol of class."
	icon_state = "platter_gold"
	resistance_flags = FIRE_PROOF
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	sellprice = 25
	smeltresult = /obj/item/ingot/gold
