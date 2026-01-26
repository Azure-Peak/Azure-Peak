/obj/item/reagent_containers/food/snacks/egg
	icon = 'modular/Neu_Food/icons/cooked/cooked_egg.dmi'
	name = "egg"
	desc = "A raw egg."
	icon_state = "egg"
	dropshrink = 0.8
	list_reagents = list(/datum/reagent/consumable/eggyolk = 5)
	cooked_type = null
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/friedegg
	filling_color = "#F0E68C"
	foodtype = MEAT
	grind_results = list()
	rotprocess = SHELFLIFE_SHORT

	var/fertile = FALSE

/obj/item/reagent_containers/food/snacks/egg/become_rotten()
	. = ..()
	if(.)
		fertile = FALSE


/obj/item/reagent_containers/food/snacks/egg/Crossed(mob/living/carbon/human/H)
	..()
	if(istype(H))
		var/turf/T = get_turf(src)
		var/obj/O = new /obj/effect/decal/cleanable/food/egg_smudge(T)
		O.pixel_x = rand(-8,8)
		O.pixel_y = rand(-8,8)
		visible_message("<span class='warning'>[H] crushes [src] underfoot.</span>")
		qdel(src)

/obj/item/reagent_containers/food/snacks/egg/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/cheddarwedge))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/stuffedegg(loc)
				qdel(I)
				qdel(src)
	else
		return ..()
