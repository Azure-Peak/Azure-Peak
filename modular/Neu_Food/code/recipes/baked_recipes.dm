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

/datum/food_recipe/baked/apple_loaf
	name = "Apple Loaf"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/dough
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/fruit/apple_sliced,
		/obj/item/reagent_containers/food/snacks/rogue/fruit/apple_sliced,
	)
	step_visuals = list(
		list('modular/Neu_Food/icons/cooked/cooked_baked.dmi', "dough_apple"), 
		list('modular/Neu_Food/icons/cooked/cooked_baked.dmi', "applebread_uncooked"), 
	)
	cook_method = COOK_BAKE
	result_type = /obj/item/reagent_containers/food/snacks/rogue/applebread

/datum/food_recipe/baked/buttered_dough
	name = "Buttered Dough"
	hidden = TRUE
	base_item = /obj/item/reagent_containers/food/snacks/rogue/dough
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/butterslice,
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/butterdough

/datum/food_recipe/baked/pear_bookbread
	name = "Pear Bookbread"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/butterdough
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/fruit/pear)
	step_visuals = list(list('modular/Neu_Food/icons/raw/raw_dough.dmi', "butterdough_pear"))
	cook_method = COOK_BAKE
	result_type = /obj/item/reagent_containers/food/snacks/rogue/pearbookbread

/datum/food_recipe/baked/plum_bookbread
	name = "Plum Bookbread"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/butterdough
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/fruit/plum)
	step_visuals = list(list('modular/Neu_Food/icons/raw/raw_dough.dmi', "butterdough_plum"))
	cook_method = COOK_BAKE
	result_type = /obj/item/reagent_containers/food/snacks/rogue/plumbookbread

/datum/food_recipe/baked/lemon_bookbread
	name = "Lemon Bookbread"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/butterdough
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/fruit/lemon)
	step_visuals = list(list('modular/Neu_Food/icons/raw/raw_dough.dmi', "butterdough_lemon"))
	cook_method = COOK_BAKE
	result_type = /obj/item/reagent_containers/food/snacks/rogue/lemonbookbread

/datum/food_recipe/baked/tangerine_bookbread
	name = "Tangerine Bookbread"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/butterdough
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/fruit/tangerine)
	step_visuals = list(list('modular/Neu_Food/icons/raw/raw_dough.dmi', "butterdough_tangerine"))
	cook_method = COOK_BAKE
	result_type = /obj/item/reagent_containers/food/snacks/rogue/tangerinebookbread

/datum/food_recipe/baked/blackberry_bookbread
	name = "Blackberry Bookbread"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/butterdough
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry)
	step_visuals = list(list('modular/Neu_Food/icons/raw/raw_dough.dmi', "butterdough_blackberry"))
	cook_method = COOK_BAKE
	result_type = /obj/item/reagent_containers/food/snacks/rogue/blackberrybookbread

/datum/food_recipe/baked/raspberry_bookbread
	name = "Raspberry Bookbread"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/butterdough
	ingredients = list(/obj/item/reagent_containers/food/snacks/grown/fruit/raspberry)
	step_visuals = list(list('modular/Neu_Food/icons/raw/raw_dough.dmi', "butterdough_raspberry"))
	cook_method = COOK_BAKE
	result_type = /obj/item/reagent_containers/food/snacks/rogue/raspberrybookbread

// Chocolate Bookbread uses an ANY-OF group: a whole bar OR a slice both satisfy the one step.
/datum/food_recipe/baked/chocolate_bookbread
	name = "Chocolate Bookbread"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/butterdough
	ingredients = list(
		list(
			/obj/item/reagent_containers/food/snacks/chocolate,
			/obj/item/reagent_containers/food/snacks/chocolate/slice,
		),
	)
	step_visuals = list(list('modular/Neu_Food/icons/raw/raw_dough.dmi', "butterdough_chocolate"))
	cook_method = COOK_BAKE
	result_type = /obj/item/reagent_containers/food/snacks/rogue/chocolatebookbread
