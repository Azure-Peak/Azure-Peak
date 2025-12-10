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

/datum/crafting_recipe/roguetown/trapmaking/sawbladetrap
	name = "saw blades trap"
	result = /obj/structure/trap/saw_blades
	reqs =  list(/obj/item/restraints/legcuffs/beartrap/crafted = 1, 
				/obj/item/scrap = 2,
				/obj/item/rope = 1,
				/obj/item/alch/irondust = 1,
	)
	craftdiff = 4

/datum/crafting_recipe/roguetown/trapmaking/flametrap
	name = "flame trap"
	result = /obj/structure/trap/flame
	reqs =  list(/obj/item/flint = 1, 
				/obj/item/scrap = 2,
				/obj/item/alch/irondust = 1,
				/obj/item/bomb = 1,
	)
	craftdiff = 4

/datum/crafting_recipe/roguetown/trapmaking/bombtrap
	name = "bomb trap"
	result = /obj/structure/trap/bomb
	reqs =  list(/obj/item/flint = 1, 
				/obj/item/scrap = 2,
				/obj/item/alch/irondust = 1,
				/obj/item/impact_grenade/explosion = 1,
	)
	craftdiff = 4

/datum/crafting_recipe/roguetown/trapmaking/shocktrap
	name = "shock trap"
	result = /obj/structure/trap/shock
	reqs =  list(/obj/item/scrap = 2, 
				/obj/item/natural/clay = 1,
				/obj/item/alch/airdust = 2,
				/obj/item/alch/irondust = 1,
				/obj/item/natural/whetstone = 1,
	)
	craftdiff = 4

/datum/crafting_recipe/roguetown/trapmaking/rocktrap
	name = "rock trap"
	result = /obj/structure/trap/rock_fall
	reqs =  list(/obj/item/restraints/legcuffs/beartrap/crafted = 1,
				/obj/item/scrap = 2, 
				/obj/item/natural/rock = 1,
				/obj/item/alch/irondust = 2,
	)
	craftdiff = 4