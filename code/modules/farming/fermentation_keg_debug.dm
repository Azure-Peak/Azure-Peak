/obj/structure/fermentation_keg/debug
	name = "debug keg"
	desc = "Spawns already brewed. Drag it onto a ship fulfillment crate to sell it as a keg, or strike it with a bottlin' kit to fill bottles."
	var/debug_recipe = /datum/brewing_recipe/cider

/obj/structure/fermentation_keg/debug/Initialize()
	. = ..()
	if(!debug_recipe)
		return
	selected_recipe = new debug_recipe
	ready_to_bottle = TRUE
	made_item = selected_recipe.name
	sellprice = selected_recipe.sell_value + initial(sellprice)
	icon_state = "barrel_tapless_ready"
	update_overlays()

/obj/structure/fermentation_keg/debug/beer
	debug_recipe = /datum/brewing_recipe/beer

/obj/structure/fermentation_keg/debug/mead
	debug_recipe = /datum/brewing_recipe/mead

/obj/structure/fermentation_keg/debug/jackwine
	debug_recipe = /datum/brewing_recipe/jack_wine

/obj/structure/fermentation_keg/distiller/debug
	name = "debug distiller"
	desc = "Spawns already distilled. Strike it with a bottlin' kit to fill sealed spirit bottles, then deposit those onto a ship fulfillment crate."
	var/debug_recipe = /datum/brewing_recipe/aqua_vitae

/obj/structure/fermentation_keg/distiller/debug/Initialize()
	. = ..()
	if(!debug_recipe)
		return
	selected_recipe = new debug_recipe
	ready_to_bottle = TRUE
	made_item = selected_recipe.name
	sellprice = selected_recipe.sell_value + initial(sellprice)
	update_overlays()

/obj/structure/fermentation_keg/distiller/debug/brandy
	debug_recipe = /datum/brewing_recipe/brandy

/obj/structure/fermentation_keg/distiller/debug/gin
	debug_recipe = /datum/brewing_recipe/liquor

/obj/structure/fermentation_keg/distiller/debug/ricespirit
	debug_recipe = /datum/brewing_recipe/liquor/ricespirit

/obj/structure/fermentation_keg/distiller/debug/limoncello
	debug_recipe = /datum/brewing_recipe/limoncello
