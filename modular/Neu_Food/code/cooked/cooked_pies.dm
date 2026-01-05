/* File for cooked pies and their sprites. This is for BIG PIE.
	Please do not add hand pie or something here.
*/
/obj/item/reagent_containers/food/snacks/rogue/pie
	name = "pie"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pies.dmi'
	desc = ""
	color = "#e7e2df"
	dropshrink = 0.8
	var/stunning = FALSE

/obj/item/reagent_containers/food/snacks/rogue/pie/cooked
	icon_state = "pie"
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_FILLING)
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/pieslice
	slices_num = 5
	slice_name = "pie slice"
	slice_batch = TRUE
	faretype = FARE_LAVISH //an entire pie! all to yourself!
	portable = FALSE
	warming = 10 MINUTES
	eat_effect = null
	foodtype = GRAIN | DAIRY
	chopping_sound = TRUE
	eat_effect = /datum/status_effect/buff/snackbuff
	dropshrink = 0.8

/obj/item/reagent_containers/food/snacks/rogue/pie/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(!.) //if we're not being caught
		splat(hit_atom)

/obj/item/reagent_containers/food/snacks/rogue/pie/proc/splat(atom/movable/hit_atom)
	if(isliving(loc)) //someone caught us!
		return
	var/turf/T = get_turf(hit_atom)
	new/obj/effect/decal/cleanable/food/pie_smudge(T)
	if(reagents && reagents.total_volume)
		reagents.reaction(hit_atom, TOUCH)
	if(isliving(hit_atom))
		var/mob/living/L = hit_atom
		if(stunning)
			L.Paralyze(20) //splat!
		L.adjust_blurriness(1)
		L.visible_message(span_warning("[L] is hit by [src]!"), span_danger("I'm hit by [src]!"))
	if(is_type_in_typecache(hit_atom, GLOB.creamable))
		hit_atom.AddComponent(/datum/component/creamed, src)
	qdel(src)

/obj/item/reagent_containers/food/snacks/rogue/pie/CheckParts(list/parts_list)
	..()
	for(var/obj/item/reagent_containers/food/snacks/M in parts_list)
		filling_color = M.filling_color
		update_snack_overlays(M)
		color = M.filling_color
		if(M.reagents)
			M.reagents.remove_reagent(/datum/reagent/consumable/nutriment, M.reagents.total_volume)
			M.reagents.trans_to(src, M.reagents.total_volume)
		qdel(M)

/obj/item/reagent_containers/food/snacks/rogue/pieslice
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	tastes = list("pie" = 1)
	name = "pie slice"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pies.dmi'
	desc = ""
	icon_state = "slice"
	filling_color = "#FFFFFF"
	faretype = FARE_FINE
	portable = FALSE
	foodtype = GRAIN | DAIRY
	warming = 5 MINUTES
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	color = "#e7e2df"
	rotprocess = SHELFLIFE_LONG

// -------------- MEAT PIE -----------------
/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat // bae item
	name = "meat pie"
	desc = "A delicious, homemade pie made with minced meat. Still needs to be sliced."
	eat_effect = /datum/status_effect/buff/snackbuff
	foodtype = GRAIN | DAIRY | MEAT

/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat/meat
	icon_state = "meatpie"
	tastes = list("succulent meat and crispy butterdough" = 1)
	filling_color = "#b43628"
	slice_name = "meat pie slice"

// -------------- FISH PIE -----------------
/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat/fish
	name = "fish pie"
	desc = "A delicious, homemade pie made with fresh fish. Still needs to be sliced."
	icon_state = "fishpie"
	tastes = list("baked fish and crispy butterdough" = 1)
	filling_color = "#d44197"
	slice_name = "fish pie slice"


// -------------- POT PIE -----------------
/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/pot
	name = "pot pie"
	desc = "A delicious, homemade pie. Still needs to be sliced."
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_GOOD)
	tastes = list("succulent filling and crispy butterdough" = 1)
	filling_color = "#755430"
	foodtype = GRAIN | DAIRY | MEAT
	slice_name = "pot pie slice"

// -------------- BERRY PIE -----------------
/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/berry
	name = "berry pie"
	desc = "A delicious, homemade pie made with wild berries. Still needs to be sliced."
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_GOOD)
	slices_num = 4
	tastes = list("crispy butterdough" = 1, "sweet berries" = 1)
	filling_color = "#4a62cf"
	slice_name = "berry pie slice"

// -------------- POISON PIE -----------------
/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/poison
	name = "berry pie"
	desc = "A delicious, homemade pie made with wild berries. Still needs to be sliced."
	slices_num = 4
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_GOOD, /datum/reagent/berrypoison = 12)
	tastes = list("crispy butterdough" = 1, "bitter berries" =1)
	filling_color = "#4a62cf"
	slice_name = "berry pie slice"

// -------------- APPLE PIE -----------------
/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/apple
	name = "apple pie"
	desc = "A delicious, homemade pie made with the sliced apples. Still needs to be cut."
	slices_num = 4
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_GOOD)
	tastes = list("baked apples and crispy butterdough" = 1)
	filling_color = "#947a4b"
	slice_name = "apple pie slice"

// -------------- CRAB PIE -----------------
/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/crab
	name = "crab pie"
	desc = "A delicious, homemade pie made with the inside of a crustacean. Still needs to be sliced."
	slices_num = 4
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_GOOD)
	tastes = list("crispy butterdough" = 1, "rich crab meat" = 1)
	filling_color = "#f1e0cb"
	slice_name = "crab pie slice"

// -------------- PUMPKIN PIE --------------
/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/pumpkin
	name = "pumpkin pie"
	desc = "A delicious, homemade pie made with pumpkin and cheese. Still needs to be sliced."
	icon_state = "pumpkinpie"
	filling_color = "#df7a04"
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/pieslice/pumpkin
	slices_num = 4
	slice_name = "pumpkin pie slice"
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_GOOD)
	tastes = list("crispy butterdough" = 1,"pumpkin"=1,"cheese"=1)
	foodtype = GRAIN | DAIRY | FRUIT | SUGAR
	bitesize = 8
	dropshrink = 0.85

/obj/item/reagent_containers/food/snacks/rogue/pieslice/pumpkin
	name = "pumpkin pie slice"
	desc = "A delicious slice of homemade pie, made with pumpkin and cheese."
	icon_state = "pumpkinslice"
	color = "#f5e7d8"
	filling_color = "#df7a04"
	tastes = list("crispy butterdough"=1,"pumpkin"=1,"cheese"=1)
	faretype = FARE_FINE
	portable = FALSE
	foodtype = GRAIN | DAIRY | FRUIT | SUGAR
	warming = 5 MINUTES
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	rotprocess = SHELFLIFE_LONG
