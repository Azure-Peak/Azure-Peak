// Cooked Cabbage + Sausage -> Wiener Cabbage
/datum/food_recipe/wiener_cabbage
	name = "Wiener Cabbage"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/preserved/cabbage_fried
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/wienercabbage

// Baked Potato + Sausage -> Wiener Potato
/datum/food_recipe/wiener_potato
	name = "Wiener Potato"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/preserved/potato_baked
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/wienerpotato

// Baked Potato + Fried Poultry Cutlet -> Frybird Tato
/datum/food_recipe/frybird_tato
	name = "Frybird Tato"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/preserved/potato_baked
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/frybirdtato

// Fried Potato + Sausage -> Wiener Potato (alt)
/datum/food_recipe/wiener_potato_alt
	name = "Wiener Potato (Alt)"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/preserved/potato_fried
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/wienerpotato

// Fried Potato + Fried Poultry Cutlet -> Frybird Tato (alt)
/datum/food_recipe/frybird_tato_alt
	name = "Frybird Tato (Alt)"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/preserved/potato_fried
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/frybirdtato

// Baked Carrot + Fried Steak -> Carrot Steak
/datum/food_recipe/carrot_steak
	name = "Carrot Steak"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/preserved/carrot_baked
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/carrotsteak

// Baked Carrot + Rice Beef -> Rice Beef Carrot
/datum/food_recipe/rice_beef_carrot_baked
	name = "Rice Beef with Carrot"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/preserved/carrot_baked
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/ricebeef
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/ricebeefcar

// Fried Onion + Sausage -> Wiener Onions
/datum/food_recipe/wiener_onions
	name = "Wiener Onions"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/preserved/onion_fried
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/wieneronions

// Carved Eggplant + Beef Mince -> Unfinished Stuffed Eggplant
/datum/food_recipe/eggplant_meat
	name = "Stuffed Eggplant with Meat"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/eggplantcarved
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/eggplantmeat

// Unfinished Stuffed Eggplant + Tomato -> Raw Stuffed Eggplant
/datum/food_recipe/eggplant_tomato
	name = "Stuffed Eggplant with Tomato"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/eggplantmeat
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/tomato
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/eggplantstuffedraw

// Cooked Stuffed Eggplant + Cheese Wedge -> Stuffed Eggplant with Cheese
/datum/food_recipe/eggplant_cheese
	name = "Stuffed Eggplant with Cheese"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/preserved/eggplantstuffed
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/cheddarwedge
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/eggplantstuffedcheese
