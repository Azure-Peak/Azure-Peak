/datum/crafting_recipe/roguetown/leather/container
	abstract_type = /datum/crafting_recipe/roguetown/leather/container
	category = "Container"

/datum/crafting_recipe/roguetown/leather/container/pouch
	name = "pouch x2"
	result = list(/obj/item/storage/belt/rogue/pouch,
				/obj/item/storage/belt/rogue/pouch)
	reqs = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers = 1)
	sellprice = 6
	craftdiff = 0

/datum/crafting_recipe/roguetown/leather/container/magepouch
	name = "summoner's pouch"
	reqs = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fibers = 1,
	)
	result = /obj/item/storage/magebag
	craftdiff = 1

/datum/crafting_recipe/roguetown/leather/container/meatbag
	name = "game satchel"
	reqs = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/cloth = 1,
	)
	result = /obj/item/storage/meatbag
	craftdiff = 1

/datum/crafting_recipe/roguetown/leather/container/satchel
	name = "satchel"
	result = /obj/item/storage/backpack/rogue/satchel
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 1)

/datum/crafting_recipe/roguetown/leather/container/satchelshort
	name = "short satchel"
	result = /obj/item/storage/backpack/rogue/satchel/short
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 1)
	sellprice = 15

/datum/crafting_recipe/roguetown/leather/container/backpack
	name = "backpack"
	result = /obj/item/storage/backpack/rogue/backpack
	reqs = list(/obj/item/natural/hide/cured = 3,
				/obj/item/natural/fibers = 1)

/datum/crafting_recipe/roguetown/leather/container/waterskin
	name = "waterskin"
	result = /obj/item/reagent_containers/glass/bottle/waterskin
	reqs = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers = 2)

/datum/crafting_recipe/roguetown/leather/container/quiver
	name = "quiver"
	result = /obj/item/quiver
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 2)

/datum/crafting_recipe/roguetown/leather/container/javelinbag
	name = "javelin bag"
	result = /obj/item/quiver/javelin
	reqs = list(/obj/item/reagent_containers/food/snacks/tallow = 1,
				/obj/item/rope = 1)

/datum/crafting_recipe/roguetown/leather/container/gwstrap
	name = "greatweapon strap"
	result = /obj/item/rogueweapon/scabbard/gwstrap
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/rope = 1)

/datum/crafting_recipe/roguetown/leather/container/twstrap
	name = "bandolier"
	result = /obj/item/twstrap
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/rope = 1)

/datum/crafting_recipe/roguetown/leather/container/grenstrap
	name = "grenadier bandolier"
	result = /obj/item/twstrap/bombstrap
	reqs = list(/obj/item/natural/hide/cured = 3,
				/obj/item/rope = 1)

/datum/crafting_recipe/roguetown/leather/container/belt
	name = "leather belt"
	result = /obj/item/storage/belt/rogue/leather
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 2)

/datum/crafting_recipe/roguetown/leather/container/belt/black
	name = "black leather belt"
	result = /obj/item/storage/belt/rogue/leather/black
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 2)

/datum/crafting_recipe/roguetown/leather/container/belt/knifebelt
	name = "tossblade belt"
	result = /obj/item/storage/belt/rogue/leather/knifebelt
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 2)

/datum/crafting_recipe/roguetown/leather/container/belt/surgicalbag
	name = "surgeon's bag"
	result = list(/obj/item/storage/belt/rogue/surgery_bag/empty)
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/leather/container/scabbard/sword
	name = "sword scabbard"
	result = list(/obj/item/rogueweapon/scabbard/sword)
	reqs = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fibers = 3,
		/obj/item/grown/log/tree/small = 1,
		/obj/item/rope = 1
	)
	craftdiff = 2

/datum/crafting_recipe/roguetown/leather/container/scabbard/dagger
	name = "dagger sheath"
	result = list(/obj/item/rogueweapon/scabbard/sheath)
	reqs = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/grown/log/tree/stick = 2,
	)
	craftdiff = 2
