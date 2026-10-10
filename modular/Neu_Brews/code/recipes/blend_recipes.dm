/datum/crafting_recipe/roguetown/cooking/blend
	abstract_type = /datum/crafting_recipe/roguetown/cooking/blend
	category = FOOD_CAT_BLENDS
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	verbage_simple = "blend"
	verbage = "blends"
	req_table = TRUE
	structurecraft = /obj/structure/table

/datum/crafting_recipe/roguetown/cooking/blend/raneshenbitters
	name = "Raneshen bitters blend"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_ground = 1,
		/obj/item/alch/artemisia = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/blend/raneshenbitters
	craftdiff = 3

/datum/crafting_recipe/roguetown/cooking/blend/eoragrace
	name = "Eora's grace blend"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 1,
		/obj/item/alch/calendula = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/blend/eoragrace
	craftdiff = 2

/datum/crafting_recipe/roguetown/cooking/blend/eoralovefake
	name = "Eora's love blend (Fake)"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/rogue/blend/eoragrace = 1,
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/blend/eoralovefake
	craftdiff = 3

/datum/crafting_recipe/roguetown/cooking/blend/eoralove
	name = "Eora's love blend"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/rogue/blend/eoragrace = 1,
		/obj/item/reagent_containers/food/snacks/rogue/honey/spider = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/blend/eoralove
	craftdiff = 4

/datum/crafting_recipe/roguetown/cooking/blend/ravoxcalm
	name = "Ravox's calm blend"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/coffeebeansroasted = 1,
		/obj/item/alch/taraxacum = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/blend/ravoxcalm
	craftdiff = 3

/datum/crafting_recipe/roguetown/cooking/blend/mocha
	name = "veranda coffee blend"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/coffeebeansroasted = 1,
		/obj/item/reagent_containers/food/snacks/chocolate/slice = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/blend/mocha
	craftdiff = 3

/datum/crafting_recipe/roguetown/cooking/blend/gerevine
	name = "gerevine blend"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/rogue/raisins = 1,
		/obj/item/alch/benedictus = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/blend/gerevine
	craftdiff = 2

/datum/crafting_recipe/roguetown/cooking/blend/schorle
	name = "apfelschorle preparation"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/rogue/fruit/apple_sliced = 1,
		/obj/item/reagent_containers/food/snacks/grown/manabloom = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/blend/schorle
	craftdiff = 3

/datum/crafting_recipe/roguetown/cooking/blend/baothablend
	name = "void blend"
	reqs = list(
		/obj/item/reagent_containers/lux_impure = 1,
		/obj/item/alch/atropa = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/blend/baothablend
	craftdiff = 4

/datum/crafting_recipe/roguetown/cooking/blend/forgottenlove
	name = "Sister's tea blend"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/rogue/blend/baothablend = 1,
		/obj/item/reagent_containers/food/snacks/grown/rogue/blend/eoralove = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/blend/forgottenlove
	craftdiff = 6

/datum/crafting_recipe/roguetown/cooking/blend/chai
	name = "chai blend"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_ground = 1,
		/obj/item/reagent_containers/powder/rocknut = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/blend/chai
	craftdiff = 3

/datum/crafting_recipe/roguetown/cooking/blend/volfmilk
	name = "vargmjölk syrup"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/rogue/raisins = 1,
		/obj/item/reagent_containers/food/snacks/rogue/raisins/raspberry = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/blend/volfmilk
	craftdiff = 3

/datum/crafting_recipe/roguetown/cooking/blend/frukkte
	name = "frukkte preparation"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/rogue/raisins = 1,
		/obj/item/reagent_containers/food/snacks/rogue/raisins/blackberry = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/blend/frukkte
	craftdiff = 3

/datum/crafting_recipe/roguetown/cooking/blend/barleytea
	name = "barley tea preparation"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/wheat = 1,
		/obj/item/alch/artemisia = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/blend/barleytea
	craftdiff = 3

/datum/crafting_recipe/roguetown/cooking/blend/kvass
	name = "kvass preparation"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/rogue/toastcrumbs = 1,
		/obj/item/reagent_containers/food/snacks/rogue/raisins = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/blend/kvass
	craftdiff = 3

/datum/crafting_recipe/roguetown/cooking/blend/avantare
	name = "avantare preparation"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/lemon = 1,
		/obj/item/alch/mentha = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/blend/avantare
	craftdiff = 3
