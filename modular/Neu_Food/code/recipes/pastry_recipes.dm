/datum/food_recipe/baked
	abstract_type = /datum/food_recipe/baked
	book_category = FOOD_CAT_BAKED

// Half Cookie Dough (Chocolate) + Chocolate -> Cookie Dough (Chocolate)
/datum/food_recipe/baked/cookie_dough_chocolate
	name = "Chocolate Cookie Dough"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/halfcookie_raw
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/chocolate/slice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/cookie_raw

// Half Cookie Dough (Dragée) + Dragée -> Cookie Dough (Dragée)
/datum/food_recipe/baked/cookie_dough_dragee
	name = "Dragée Cookie Dough"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/halfcookied_raw
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/dragee
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/cookied_raw

// Half Cookie Dough (Caramel) + Caramel -> Cookie Dough (Caramel)
/datum/food_recipe/baked/cookie_dough_caramel
	name = "Caramel Cookie Dough"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/halfcookiec_raw
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/caramel
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/cookiec_raw

// Half Cookie Dough (Raisin) + Raisins -> Cookie Dough (Raisin)
/datum/food_recipe/baked/cookie_dough_raisin
	name = "Raisin Cookie Dough"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/halfcookier_raw
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/raisins
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/cookier_raw

// Muffin + Cheese -> Raw Cheese Muffin
/datum/food_recipe/baked/cheese_muffin
	name = "Cheese Muffin"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/muffin
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/cheese
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/muffin/cheese

// Muffin + Honey -> Raw Honey Muffin
/datum/food_recipe/baked/honey_muffin
	name = "Honey Muffin"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/muffin
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/honey
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/muffin/honey

// Strudel + Sugar -> Coated Strudel
/datum/food_recipe/baked/sugar_strudel
	name = "Coated Strudel"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/strudel
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/sugar
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/strudel/sugar

// Bookbread Slice + Jamtallow -> Jamtallowed Bookbread Slice
/datum/food_recipe/baked/jamtallowed_bookbread
	name = "Jamtallowed Bookbread Slice"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/bookbread_slice
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/jamtallowslice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/bookbread_slice_jamtallowed

// Bookbread Slice + Marmalade -> Marmaladed Bookbread Slice
/datum/food_recipe/baked/marmaladed_bookbread
	name = "Marmaladed Bookbread Slice"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/bookbread_slice
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/marmaladeslice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/bookbread_slice_marmaladed
