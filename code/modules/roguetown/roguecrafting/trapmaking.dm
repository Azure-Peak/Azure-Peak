/datum/crafting_recipe/roguetown/trapmaking
	abstract_type = /datum/crafting_recipe/roguetown/trapmaking
	skillcraft = /datum/skill/craft/traps
	subtype_reqs = TRUE

/datum/crafting_recipe/roguetown/trapmaking/mantrap
	name = "mantrap"
	result = list(
		/obj/item/restraints/legcuffs/beartrap/crafted,
		/obj/item/restraints/legcuffs/beartrap/crafted,
		)
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/fibers = 2,
		/obj/item/ingot/iron = 1,
		)
	craftdiff = 1
	verbage_simple = "put together"
	verbage = "puts together"

/datum/crafting_recipe/roguetown/trapmaking/mantrapscrap
	name = "mantrap (scrap)"
	result = list(
		/obj/item/restraints/legcuffs/beartrap/crafted,
		/obj/item/restraints/legcuffs/beartrap/crafted,
		)
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/scrap = 4,
		)
	craftdiff = 1
	verbage_simple = "put together"
	verbage = "puts together"

/datum/crafting_recipe/roguetown/trapmaking/landmine
	name = "boomtrap"
	result = list(
		/obj/item/restraints/legcuffs/beartrap/crafted/landmine,
		)
	reqs = list(
		/obj/item/restraints/legcuffs/beartrap/crafted = 1,
		/obj/item/scrap = 2,
		)
	craftdiff = 3
	verbage_simple = "put together"
	verbage = "puts together"
