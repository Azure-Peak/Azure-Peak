/datum/crafting_recipe/roguetown/survival/spoon
	name = "spoon (x3)"
	category = "Houseware"
	result = list(
		/obj/item/kitchen/spoon,
		/obj/item/kitchen/spoon,
		/obj/item/kitchen/spoon,
		)
	reqs = list(/obj/item/grown/log/tree/small = 1)

/datum/crafting_recipe/roguetown/survival/fork
	name = "fork (x3)"
	category = "Houseware"
	result = list(
		/obj/item/kitchen/fork,
		/obj/item/kitchen/fork,
		/obj/item/kitchen/fork,
		)
	reqs = list(/obj/item/grown/log/tree/small = 1)

/datum/crafting_recipe/roguetown/survival/platter
	name = "platter (x2)"
	category = "Houseware"
	result = list(
		/obj/item/cooking/platter,
		/obj/item/cooking/platter,
		)
	reqs = list(/obj/item/grown/log/tree/small = 1)

/datum/crafting_recipe/roguetown/survival/rollingpin
	name = "rollingpin"
	category = "Houseware"
	result = /obj/item/kitchen/rollingpin
	reqs = list(/obj/item/grown/log/tree/small = 1)

/datum/crafting_recipe/roguetown/survival/woodbucket
	name = "wooden bucket"
	category = "Houseware"
	result = /obj/item/reagent_containers/glass/bucket
	reqs = list(/obj/item/grown/log/tree/small = 1)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/woodcup
	name = "wooden cups (x3)"
	category = "Houseware"
	result = list(
		/obj/item/reagent_containers/glass/cup/wooden/crafted,
		/obj/item/reagent_containers/glass/cup/wooden/crafted,
		/obj/item/reagent_containers/glass/cup/wooden/crafted,
		)
	reqs = list(/obj/item/grown/log/tree/small = 1)

/obj/item/reagent_containers/glass/cup/wooden/crafted
	sellprice = 3

/datum/crafting_recipe/roguetown/survival/woodtankard
	name = "tankards, wooden (x3)"
	category = "Houseware"
	result = list(
		/obj/item/reagent_containers/glass/bucket/pot/kettle/tankard,
		/obj/item/reagent_containers/glass/bucket/pot/kettle/tankard,
		/obj/item/reagent_containers/glass/bucket/pot/kettle/tankard,
		)
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/ingot/iron = 1)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/silvtankard
	name = "tankards, silver (x2)"
	category = "Houseware"
	result = list(
		/obj/item/reagent_containers/glass/bucket/pot/kettle/tankard/silver,
		/obj/item/reagent_containers/glass/bucket/pot/kettle/tankard/silver,
		)
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/ingot/silver = 1)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 4

/datum/crafting_recipe/roguetown/survival/blcktankard
	name = "tankards, blacksteel (x1)"
	category = "Houseware"
	result = list(
		/obj/item/reagent_containers/glass/bucket/pot/kettle/tankard/blacksteel
		)
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/ingot/blacksteel = 1)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 6

/datum/crafting_recipe/roguetown/survival/woodtray
	name = "wooden trays (x2)"
	category = "Houseware"
	result = list(
		/obj/item/storage/bag/tray,
		/obj/item/storage/bag/tray,
		)
	reqs = list(/obj/item/grown/log/tree/small = 1)

/datum/crafting_recipe/roguetown/survival/woodbowl
	name = "wooden bowls (x3)"
	category = "Houseware"
	result = list(
		/obj/item/reagent_containers/glass/bowl,
		/obj/item/reagent_containers/glass/bowl,
		/obj/item/reagent_containers/glass/bowl,
		)
	reqs = list(/obj/item/grown/log/tree/small = 1)

/datum/crafting_recipe/roguetown/survival/pot
	name = "stone pot"
	category = "Houseware"
	result = /obj/item/reagent_containers/glass/bucket/pot/stone
	reqs = list(/obj/item/natural/stone = 2)

/datum/crafting_recipe/roguetown/survival/soap
	name = "soap (3x)"
	category = "Houseware"
	result = list(
		/obj/item/soap,
		/obj/item/soap,
		/obj/item/soap,
		)
	reqs = list(/obj/item/reagent_containers/food/snacks/tallow = 1)

/datum/crafting_recipe/roguetown/survival/candle
	name = "candle (x3)"
	category = "Houseware"
	result = list(
		/obj/item/candle/yellow,
		/obj/item/candle/yellow,
		/obj/item/candle/yellow,
		)
	reqs = list(/obj/item/reagent_containers/food/snacks/tallow = 1)

/datum/crafting_recipe/roguetown/survival/candle/eora
	name = "eora's candle (x3)"
	category = "Houseware"
	result = list(
		/obj/item/candle/eora,
		/obj/item/candle/eora,
		/obj/item/candle/eora,
		)
	reqs = list(
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		/obj/item/alch/rosa = 1,
		/datum/reagent/water/blessed = 25,
		)
