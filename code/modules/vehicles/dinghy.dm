
//a ridable boat so players can traverse water tiles without drowning

/obj/vehicle/ridden/dinghy
	name = "dinghy"
	desc = "An unpretentious craft of pitch-sealed planks."
	icon = 'icons/obj/boat.dmi'
	icon_state = "dinghy"
	can_buckle = TRUE
	layer = ABOVE_MOB_LAYER
	var/allowed_turf = /turf/open/water //includes all subtypes of water

/obj/vehicle/ridden/dinghy/Initialize(mapload)
	. = ..()
	var/datum/component/riding/D = LoadComponent(/datum/component/riding)
	D.keytype = /obj/item/rogueweapon/mace/oar
	D.allowed_turf_typecache = typecacheof(allowed_turf)

/obj/item/rogueweapon/mace/oar
	name = "oar"
	desc = "A wooden club with a flattened head for paddling boats about."
	icon = 'icons/obj/boat_accessories.dmi'
	icon_state = "oar"
	gripped_intents = null
	force = 15
	wdefense = 10
	smeltresult = null

/datum/crafting_recipe/roguetown/survival/oar
	name = "Oar"
	result = /obj/item/rogueweapon/mace/oar
	reqs = list(
		/obj/item/grown/log/tree = 1,
		/obj/item/natural/fibers = 2,
		)
	time = 15

/datum/crafting_recipe/roguetown/survival/boat
	name = "Dinghy"
	result = /obj/vehicle/ridden/dinghy
	reqs = list(
		/obj/item/grown/log/tree = 4,
		/obj/item/ash = 3,
		/obj/item/natural/fibers = 5
		)
	time = 50
