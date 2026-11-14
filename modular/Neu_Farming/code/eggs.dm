/obj/item/reagent_containers/food/snacks/rogue/egg
	icon = 'modular/Neu_Food/icons/cooked/cooked_egg.dmi'
	name = "egg"
	desc = "A raw egg."
	icon_state = "egg"
	dropshrink = 0.8
	list_reagents = list(/datum/reagent/consumable/eggyolk = 5)
	cooked_type = null
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/friedegg/fried
	filling_color = "#F0E68C"
	grind_results = list()
	rotprocess = SHELFLIFE_SHORT

	var/fertile = FALSE
	var/amount_grown = 0
	var/hatch_type = /mob/living/simple_animal/hostile/retaliate/rogue/chick

/obj/item/reagent_containers/food/snacks/rogue/egg/process()
	..()
	if(QDELETED(src) || !fertile || !isturf(loc))
		return
	amount_grown += rand(1, 2)
	if(amount_grown < 100)
		return
	visible_message(span_notice("[src] hatches with a quiet cracking sound."))
	new hatch_type(loc)
	qdel(src)

/obj/item/reagent_containers/food/snacks/rogue/egg/become_rotten()
	. = ..()
	if(.)
		fertile = FALSE


/obj/item/reagent_containers/food/snacks/rogue/egg/Crossed(mob/living/carbon/human/H)
	..()
	if(istype(H))
		var/turf/T = get_turf(src)
		var/obj/O = new /obj/effect/decal/cleanable/food/egg_smudge(T)
		O.pixel_x = rand(-8,8)
		O.pixel_y = rand(-8,8)
		visible_message("<span class='warning'>[H] crushes [src] underfoot.</span>")
		qdel(src)

