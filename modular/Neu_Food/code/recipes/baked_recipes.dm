/datum/food_recipe/sandwich
	abstract_type = /datum/food_recipe/sandwich
	book_category = FOOD_CAT_SANDWICH

// Hardtack + Chocolate -> Half Cookie (Chocolate)
/datum/food_recipe/baked/half_cookie_chocolate
	name = "Chocolate Cookie Dough"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/hardtack_raw
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/chocolate/slice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/halfcookie_raw

// Hardtack + Raisins -> Half Cookie (Raisin)
/datum/food_recipe/baked/half_cookie_raisin
	name = "Raisin Cookie Dough"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/hardtack_raw
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/raisins
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/halfcookier_raw

// Hardtack + Caramel -> Half Cookie (Caramel)
/datum/food_recipe/baked/half_cookie_caramel
	name = "Caramel Cookie Dough"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/hardtack_raw
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/caramel
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/halfcookiec_raw

// Hardtack + Dragée -> Half Cookie (Dragée)
/datum/food_recipe/baked/half_cookie_dragee
	name = "Dragée Cookie Dough"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/hardtack_raw
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/dragee
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/halfcookied_raw

// Bread Slice + Salami -> Salumoi Sandwich
/datum/food_recipe/sandwich/salami
	name = "Salumoi Bread"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/breadslice
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/salami/slice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/sandwich/salami

// Bread Slice + Cheese Slice -> Cheese Bread
/datum/food_recipe/sandwich/cheese
	name = "Cheese Bread"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/breadslice
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/cheddarslice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/sandwich/cheese

// Bread Slice + Salo -> Salo Bread
/datum/food_recipe/sandwich/salo
	name = "Salo Bread"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/breadslice
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/fat/salo/slice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/sandwich/salo

// Bread Slice + Bacon -> Bacon Bread
/datum/food_recipe/sandwich/bacon
	name = "Bacon Bread"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/breadslice
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/bacon/fried
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/sandwich/bacon

// Toast + Butter -> Buttered Toast
/datum/food_recipe/sandwich/buttered_toast
	name = "Buttered Toast"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/breadslice/toast
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/butterslice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/breadslice/toast/buttered

// Toast + Fried Egg -> Egg Toast
/datum/food_recipe/sandwich/egg_toast
	name = "Egg Toast"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/breadslice/toast
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/friedegg/fried
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/sandwich/egg

// Toast + Jamtallow Slice -> Jamtallowed Toast
/datum/food_recipe/sandwich/jamtallowed_toast
	name = "Jamtallowed Toast"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/breadslice/toast
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/jamtallowslice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/breadslice/toast/jamtallowed_slice

// Toast + Marmalade Slice -> Marmaladed Toast
/datum/food_recipe/sandwich/marmaladed_toast
	name = "Marmaladed Toast"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/breadslice/toast
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/marmaladeslice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/breadslice/toast/marmaladed_slice

// Toast + Ham -> Ham Bread
/datum/food_recipe/sandwich/ham
	name = "Ham Bread"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/breadslice/toast
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/ham/sliced
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/sandwich/ham

// Bun + Sausage -> Grenzelbun (Hotdog)
/datum/food_recipe/sandwich/grenzelbun
	name = "Grenzelbun"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/bun
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/bun_grenz

// Bun + Cheese Wedge -> Raston
/datum/food_recipe/sandwich/raston
	name = "Raston"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/bun
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/cheddarwedge
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/bun_raston

// Bun + Jamtallow Slice -> Jamtallowed Bun
/datum/food_recipe/sandwich/jamtallowed_bun
	name = "Jamtallowed Bun"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/bun
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/jamtallowslice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/bun_jamtallow

// Bun + Marmalade Slice -> Marmaladed Bun
/datum/food_recipe/sandwich/marmaladed_bun
	name = "Marmaladed Bun"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/bun
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/marmaladeslice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/bun_marmalade

// Crossbun + Jamtallow -> Jamtallowed Crossbun
/datum/food_recipe/sandwich/jamtallowed_crossbun
	name = "Jamtallowed Crossbun"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/crossbun
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/jamtallowslice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/crossbun_jamtallowed

// Crossbun + Marmalade -> Marmaladed Crossbun
/datum/food_recipe/sandwich/marmaladed_crossbun
	name = "Marmaladed Crossbun"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/crossbun
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/marmaladeslice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/crossbun_marmaladed

// Psycrossbun + Jamtallow -> Jamtallowed Psycrossbun
/datum/food_recipe/sandwich/jamtallowed_psycrossbun
	name = "Jamtallowed Psycrossbun"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/psycrossbun
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/jamtallowslice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/psycrossbun_jamtallowed

// Psycrossbun + Marmalade -> Marmaladed Psycrossbun
/datum/food_recipe/sandwich/marmaladed_psycrossbun
	name = "Marmaladed Psycrossbun"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/psycrossbun
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/marmaladeslice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/psycrossbun_marmaladed

// Half Raisin Dough + Raisins -> Raw Raisin Loaf
/datum/food_recipe/baked/raisin_bread_complete
	name = "Complete Raisin Dough"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/rbread_half
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/raisins
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/rbreaduncooked

// Half Apple Dough + Apple Slices -> Raw Apple Loaf
/datum/food_recipe/baked/apple_bread_complete
	name = "Complete Apple Dough"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/abread_half
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/fruit/apple_sliced
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/abreaduncooked
