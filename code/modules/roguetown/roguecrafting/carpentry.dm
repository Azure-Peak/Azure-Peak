/datum/crafting_recipe/roguetown/survival/wood_stake
	name = "stake"
	display_category = ITEM_CAT_ENG_CONSTRUCTION
	result = /obj/item/grown/log/tree/stake
	reqs = list(
		/obj/item/grown/log/tree/stick = 1,
		)
	tools = list(
		/obj/item/rogueweapon/huntingknife,
		)

/datum/crafting_recipe/roguetown/survival/lampstaff
	always_availible = FALSE
	name = "lamplighter's staff"
	result = list(/obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter = 1)
	reqs = list(/obj/item/rogueweapon/woodstaff/quarterstaff = 1, /obj/item/flashlight/flare/torch/lantern = 1, /obj/item/reagent_containers/food/snacks/tallow = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/survival/lampwarden
	always_availible = FALSE
	name = "lampwarden's staff"
	result = list(/obj/item/rogueweapon/woodstaff/quarterstaff/lampwarden = 1)
	reqs = list(/obj/item/rogueweapon/woodstaff/quarterstaff = 1, /obj/item/flashlight/flare/torch/lantern = 1, /obj/item/reagent_containers/food/snacks/tallow = 2, /obj/item/ingot/iron = 1)
	craftdiff = 3
