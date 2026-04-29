/datum/crafting_recipe/roguetown/alchemy/unique
	always_availible = FALSE

/datum/crafting_recipe/roguetown/alchemy/unique/ichor
	name = "Black Ichor (x1)"
	result = list(/obj/item/reagent_containers/powder/black_ichor)
	reqs = list(
				/obj/item/heart_blood_vial/filled = 1,
				/obj/item/reagent_containers/powder/ozium = 1
	)
	craftdiff = 5

/datum/crafting_recipe/roguetown/alchemy/unique/ichor_big
	name = "Black Ichor (x3)"
	result = list(/obj/item/reagent_containers/powder/black_ichor,
				  /obj/item/reagent_containers/powder/black_ichor,
				  /obj/item/reagent_containers/powder/black_ichor,
	)
	reqs = list(
				/obj/item/heart_blood_canister/filled = 1,
				/obj/item/reagent_containers/powder/ozium = 3
	)
	craftdiff = 5
