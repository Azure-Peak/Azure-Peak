
/datum/crafting_recipe/roguetown/structure
	abstract_type = /datum/crafting_recipe/roguetown/structure
	req_table = FALSE
	subtype_reqs = TRUE
	craftsound = 'sound/foley/Building-01.ogg'

/datum/crafting_recipe/roguetown/structure/TurfCheck(mob/user, turf/T)
	if(istype(T,/turf/open/transparent/openspace))
		return FALSE
	if(istype(T, /turf/open/water))
		return FALSE
	return ..()

/datum/crafting_recipe/roguetown/structure/handcart
	name = "handcart"
	category = "Misc"
	result = /obj/structure/handcart
	reqs = list(/obj/item/grown/log/tree/small = 3,
				/obj/item/rope = 1)
	verbage_simple = "construct"
	verbage = "constructs"
/*	- Disabled. Because you people can't be trusted.. Mapped-in only.
/datum/crafting_recipe/roguetown/structure/noose
	name = "noose"
	result = /obj/structure/noose
	reqs = list(/obj/item/rope = 1)
	verbage = "tie"
	craftsound = 'sound/foley/noose_idle.ogg'
	ontile = TRUE

/datum/crafting_recipe/roguetown/structure/noose/TurfCheck(mob/user, turf/T)
	var/turf/checking = get_step_multiz(T, UP)
	if(!checking)
		return FALSE
	if(!isopenturf(checking))
		return FALSE
	if(istype(checking,/turf/open/transparent/openspace))
		return FALSE
	return TRUE
*/
/datum/crafting_recipe/roguetown/structure/psycrss
	name = "wooden cross"
	category = "Misc"
	result = /obj/structure/fluff/psycross/crafted
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/grown/log/tree/stake = 3)
	verbage_simple = "construct"
	verbage = "constructs"

/datum/crafting_recipe/roguetown/structure/psycruci
	name = "wooden psydonic cross"
	category = "Misc"
	result = /obj/structure/fluff/psycross/psycrucifix
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/grown/log/tree/stake = 3)
	verbage_simple = "construct"
	verbage = "constructs"

/datum/crafting_recipe/roguetown/structure/stonepsycruci
	name = "stone psydonic cross"
	category = "Misc"
	result = /obj/structure/fluff/psycross/psycrucifix/stone
	reqs =	list(/obj/item/natural/stone = 3)
	verbage_simple = "construct"
	verbage = "constructs"

/datum/crafting_recipe/roguetown/structure/silverpsycruci
	name = "silver psydonic cross"
	category = "Misc"
	result = /obj/structure/fluff/psycross/psycrucifix/silver
	reqs = list(/obj/item/ingot/silverblessed = 1,
				/obj/item/ingot/steel = 2)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/masonry
	craftdiff = 3

/datum/crafting_recipe/roguetown/structure/stonepsycrss
	name = "stone cross"
	category = "Misc"
	result = /obj/structure/fluff/psycross
	reqs = list(/obj/item/natural/stone = 2)
	verbage_simple = "construct"
	verbage = "constructs"

/datum/crafting_recipe/roguetown/structure/zizo_shrine
	name = "profane shrine"
	category = "Misc"
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/stone = 2,
		/obj/item/grown/log/tree/stake = 2
	)
	result = /obj/structure/fluff/psycross/zizocross

/datum/crafting_recipe/roguetown/structure/swing_door
	name = "swing door"
	category = "Doors"
	result = /obj/structure/mineral_door/swing_door
	reqs = list(/obj/item/grown/log/tree/small = 2)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry

/datum/crafting_recipe/roguetown/structure/door
	name = "wooden door"
	category = "Doors"
	result = /obj/structure/mineral_door/wood
	reqs = list(/obj/item/grown/log/tree/small = 2)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry

/datum/crafting_recipe/roguetown/structure/stonedoor
	name = "stone door"
	category = "Doors"
	result = /obj/structure/mineral_door/wood/donjon/stone
	reqs = list(/obj/item/natural/stone = 2)
	verbage_simple = "build"
	verbage = "builds"
	skillcraft = /datum/skill/craft/masonry

/datum/crafting_recipe/roguetown/structure/doorbolt
	name = "wooden door (deadbolt)"
	category = "Doors"
	result = /obj/structure/mineral_door/wood/deadbolt
	reqs = list(/obj/item/grown/log/tree/small = 2,
				/obj/item/grown/log/tree/stick = 1)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 2

/datum/crafting_recipe/roguetown/structure/fancydoor
	name = "fancy door"
	category = "Doors"
	result = /obj/structure/mineral_door/wood/fancywood
	reqs = list(/obj/item/grown/log/tree/small = 2)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 3

/datum/crafting_recipe/roguetown/structure/barrel
	name = "wooden barrel"
	category = "Containers"
	result = /obj/structure/fermentation_keg/crafted
	reqs = list(/obj/item/grown/log/tree/small = 1)
	verbage_simple = "make"
	verbage = "makes"
	skillcraft = /datum/skill/craft/carpentry

/datum/crafting_recipe/roguetown/structure/display_stand
	name = "display stand"
	category = "Displays"
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/grown/log/tree/stick = 2)
	result = /obj/structure/mannequin
	verbage_simple = "construct"
	verbage = "constructs"
	craftdiff = 2
	skillcraft = /datum/skill/craft/carpentry

/datum/crafting_recipe/roguetown/structure/mannequin_female
	name = "mannequin (female)"
	category = "Displays"
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/grown/log/tree/stick = 2)
	result = /obj/structure/mannequin/male/female
	verbage_simple = "construct"
	verbage = "constructs"
	craftdiff = 2
	skillcraft = /datum/skill/craft/carpentry

/datum/crafting_recipe/roguetown/structure/mannequin_male
	name = "mannequin (male)"
	category = "Displays"
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/grown/log/tree/stick = 2)
	result = /obj/structure/mannequin/male
	verbage_simple = "construct"
	verbage = "constructs"
	craftdiff = 2
	skillcraft = /datum/skill/craft/carpentry

/obj/structure/fermentation_keg/crafted
	sellprice = 6

/datum/crafting_recipe/roguetown/structure/meathook
	name = "meathook"
	category = "Misc"
	result = /obj/structure/meathook
	reqs = list(/obj/item/grown/log/tree/small = 2,
				/obj/item/rope = 1)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/crafting
	craftdiff = 2

/datum/crafting_recipe/roguetown/roguebin
	name = "wooden bin"
	category = "Containers"
	result = /obj/item/roguebin
	reqs = list(/obj/item/grown/log/tree/small = 2)
	verbage_simple = "make"
	verbage = "makes"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 0

/datum/crafting_recipe/roguetown/structure/chair
	name = "wooden chair"
	category = "Seats"
	result = /obj/item/chair/rogue/crafted
	reqs = list(/obj/item/grown/log/tree/small = 1)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry

/datum/crafting_recipe/roguetown/structure/chairthrone
	name = "small throne"
	category = "Seats"
	result = /obj/structure/chair/wood/rogue/throne
	reqs = list(/obj/item/natural/wood/plank = 2, /obj/item/natural/silk = 2)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry

/obj/item/chair/rogue/crafted
	sellprice = 6

/datum/crafting_recipe/roguetown/structure/parkbenchleft
	name = "park bench (left)"
	category = "Seats"
	result = /obj/structure/chair/hotspring_bench/left
	reqs = list(/obj/item/grown/log/tree/small = 1)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry

/datum/crafting_recipe/roguetown/structure/parkbenchmiddle
	name = "park bench (middle)"
	category = "Seats"
	result = /obj/structure/chair/hotspring_bench
	reqs = list(/obj/item/grown/log/tree/small = 1)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry

/datum/crafting_recipe/roguetown/structure/parkbenchright
	name = "park bench (right)"
	category = "Seats"
	result = /obj/structure/chair/hotspring_bench/right
	reqs = list(/obj/item/grown/log/tree/small = 1)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry

/datum/crafting_recipe/roguetown/structure/fancychair
	name = "fancy wooden chair"
	category = "Seats"
	result = /obj/item/chair/rogue/fancy/crafted
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/natural/silk = 1)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry

///----Couches---

/datum/crafting_recipe/roguetown/structure/couchleft
	name = "couch (left)"
	category = "Seats"
	result = /obj/structure/chair/bench/couch
	reqs = list(/obj/item/natural/wood/plank = 3,
				/obj/item/natural/silk = 2)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 4

/datum/crafting_recipe/roguetown/structure/couchright
	name = "couch (right)"
	category = "Seats"
	result = /obj/structure/chair/bench/couch/r
	reqs = list(/obj/item/natural/wood/plank = 3,
				/obj/item/natural/silk = 2)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 4

/datum/crafting_recipe/roguetown/structure/blackcouchleft
	name = "black couch (left)"
	category = "Seats"
	result = /obj/structure/chair/bench/couchablack
	reqs = list(/obj/item/natural/wood/plank = 3,
				/obj/item/natural/silk = 2)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 4

/datum/crafting_recipe/roguetown/structure/blackcouchright
	name = "black couch (right)"
	category = "Seats"
	result = /obj/structure/chair/bench/couchablack/r
	reqs = list(/obj/item/natural/wood/plank = 3,
				/obj/item/natural/silk = 2)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 4

/datum/crafting_recipe/roguetown/structure/ultimacouchleft
	name = "ultima couch (left)"
	category = "Seats"
	result = /obj/structure/chair/bench/ultimacouch
	reqs = list(/obj/item/natural/wood/plank = 3,
				/obj/item/natural/silk = 2)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 4

/datum/crafting_recipe/roguetown/structure/ultimacouchright
	name = "ultima couch (right)"
	category = "Seats"
	result = /obj/structure/chair/bench/ultimacouch/r
	reqs = list(/obj/item/natural/wood/plank = 3,
				/obj/item/natural/silk = 2)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 4

/datum/crafting_recipe/roguetown/structure/ultimacouchleft
	name = "ultima couch (left)"
	category = "Seats"
	result = /obj/structure/chair/bench/ultimacouch
	reqs = list(/obj/item/natural/wood/plank = 3,
				/obj/item/natural/silk = 2)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 4

/datum/crafting_recipe/roguetown/structure/ultimacouchright
	name = "ultima couch (right)"
	category = "Seats"
	result = /obj/structure/chair/bench/ultimacouch/r
	reqs = list(/obj/item/natural/wood/plank = 3,
				/obj/item/natural/silk = 2)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 4

/datum/crafting_recipe/roguetown/structure/altcouchleft
	name = "couch alt (left)"
	category = "Seats"
	result = /obj/structure/chair/bench/coucha
	reqs = list(/obj/item/natural/wood/plank = 3,
				/obj/item/natural/silk = 2)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 4

/datum/crafting_recipe/roguetown/structure/altcouchright
	name = "couch alt (right)"
	category = "Seats"
	result = /obj/structure/chair/bench/coucha/r
	reqs = list(/obj/item/natural/wood/plank = 3,
				/obj/item/natural/silk = 2)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 4

/datum/crafting_recipe/roguetown/structure/magentacouchleft
	name = "magenta couch (left)"
	category = "Seats"
	result = /obj/structure/chair/bench/couchamagenta
	reqs = list(/obj/item/natural/wood/plank = 3,
				/obj/item/natural/silk = 2)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 4

/datum/crafting_recipe/roguetown/structure/magentacouchright
	name = "magenta couch (right)"
	category = "Seats"
	result = /obj/structure/chair/bench/couchamagenta/r
	reqs = list(/obj/item/natural/wood/plank = 3,
				/obj/item/natural/silk = 2)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 4
//------------

//---Pillows---
/datum/crafting_recipe/roguetown/structure/redpillows
	name = "red pillows"
	category = "Misc"
	result = /obj/structure/fluff/pillow/red
	reqs = list(/obj/item/natural/silk = 1,
				/obj/item/natural/cloth = 2)
	skillcraft = /datum/skill/craft/carpentry
	verbage_simple = "construct"
	verbage = "constructs"
	craftdiff = 3

/datum/crafting_recipe/roguetown/structure/bluepillows
	name = "blue pillows"
	category = "Misc"
	result = /obj/structure/fluff/pillow/blue
	reqs = list(/obj/item/natural/silk = 1,
				/obj/item/natural/cloth = 2)
	skillcraft = /datum/skill/craft/carpentry
	verbage_simple = "construct"
	verbage = "constructs"
	craftdiff = 3

/datum/crafting_recipe/roguetown/structure/greenpillows
	name = "green pillows"
	category = "Misc"
	result = /obj/structure/fluff/pillow/green
	reqs = list(/obj/item/natural/silk = 1,
				/obj/item/natural/cloth = 2)
	skillcraft = /datum/skill/craft/carpentry
	verbage_simple = "construct"
	verbage = "constructs"
	craftdiff = 3

/datum/crafting_recipe/roguetown/structure/brownpillows
	name = "brown pillows"
	category = "Misc"
	result = /obj/structure/fluff/pillow/brown
	reqs = list(/obj/item/natural/silk = 1,
				/obj/item/natural/cloth = 2)
	skillcraft = /datum/skill/craft/carpentry
	verbage_simple = "construct"
	verbage = "constructs"
	craftdiff = 3

/datum/crafting_recipe/roguetown/structure/magentapillows
	name = "magenta pillows"
	category = "Misc"
	result = /obj/structure/fluff/pillow/magenta
	reqs = list(/obj/item/natural/silk = 1,
				/obj/item/natural/cloth = 2)
	skillcraft = /datum/skill/craft/carpentry
	verbage_simple = "construct"
	verbage = "constructs"
	craftdiff = 3

/datum/crafting_recipe/roguetown/structure/purplepillows
	name = "purple pillows"
	category = "Misc"
	result = /obj/structure/fluff/pillow/purple
	reqs = list(/obj/item/natural/silk = 1,
				/obj/item/natural/cloth = 2)
	skillcraft = /datum/skill/craft/carpentry
	verbage_simple = "construct"
	verbage = "constructs"
	craftdiff = 3

/datum/crafting_recipe/roguetown/structure/blackpillows
	name = "black pillows"
	category = "Misc"
	result = /obj/structure/fluff/pillow/black
	reqs = list(/obj/item/natural/silk = 1,
				/obj/item/natural/cloth = 2)
	skillcraft = /datum/skill/craft/carpentry
	verbage_simple = "construct"
	verbage = "constructs"
	craftdiff = 3

//---------

//---mirrors---
/datum/crafting_recipe/roguetown/structure/mirror
	name = "mirror (north)"
	category = "Displays"
	result = /obj/structure/mirror
	reqs = list(/obj/item/natural/wood/plank = 2,
				/obj/item/ingot/iron = 1,
				/obj/item/natural/glass = 1)
	skillcraft = /datum/skill/craft/carpentry
	verbage_simple = "construct"
	verbage = "constructs"
	wallcraft = TRUE
	craftdiff = 4

/datum/crafting_recipe/roguetown/structure/fancymirror
	name = "fancy mirror (north)"
	category = "Displays"
	result = /obj/structure/mirror/fancy
	reqs = list(/obj/item/natural/wood/plank = 1,
				/obj/item/ingot/silver = 1,
				/obj/item/ingot/gold = 1,
				/obj/item/natural/glass = 1)
	skillcraft = /datum/skill/craft/carpentry
	verbage_simple = "construct"
	verbage = "constructs"
	wallcraft = TRUE
	craftdiff = 5

//---------

/obj/item/chair/rogue/fancy/crafted
	sellprice = 12

/datum/crafting_recipe/roguetown/structure/stool
	name = "wooden stool"
	category = "Seats"
	result = /obj/item/chair/stool/bar/rogue/crafted
	reqs = list(/obj/item/grown/log/tree/small = 1)
	skillcraft = /datum/skill/craft/carpentry
	verbage_simple = "construct"
	verbage = "constructs"

/obj/item/chair/stool/bar/rogue/crafted
	sellprice = 6

/datum/crafting_recipe/roguetown/structure/anvil
	name = "anvil"
	category = "Misc"
	result = /obj/machinery/anvil
	reqs = list(/obj/item/ingot/iron = 1)
	skillcraft = /datum/skill/craft/blacksmithing
	verbage_simple = "forge"
	verbage = "forges"

/datum/crafting_recipe/roguetown/structure/smelter
	name = "ore furnace"
	category = "Misc"
	result = /obj/machinery/light/rogue/smelter
	reqs = list(/obj/item/natural/stone = 4,
			/obj/item/rogueore/coal = 1)
	verbage_simple = "build"
	verbage = "builds"
	craftsound = null

/datum/crafting_recipe/roguetown/structure/smelterhiron
	name = "iron bloomery"
	category = "Misc"
	result = /obj/machinery/light/rogue/smelter/hiron
	reqs = list(/obj/item/natural/stone = 7,
			/obj/item/rogueore/coal = 2,
			/obj/item/rogueore/iron = 1)
	verbage_simple = "build"
	verbage = "builds"
	craftsound = null

/datum/crafting_recipe/roguetown/structure/smelterbronze
	name = "bronze melter"
	category = "Misc"
	result = /obj/machinery/light/rogue/smelter/bronze
	reqs = list(/obj/item/natural/stone = 6,
			/obj/item/rogueore/coal = 1,
			/obj/item/rogueore/iron = 1)
	verbage_simple = "build"
	verbage = "builds"
	craftsound = null

/datum/crafting_recipe/roguetown/structure/greatsmelter
	name = "great furnace"
	category = "Misc"
	result = /obj/machinery/light/rogue/smelter/great
	reqs = list(/obj/item/ingot/iron = 2,
				/obj/item/riddleofsteel = 1,
				/obj/item/rogueore/coal = 1)
	verbage_simple = "build"
	verbage = "builds"
	craftsound = null
	craftdiff = 2

/datum/crafting_recipe/roguetown/structure/forge
	name = "forge"
	category = "Misc"
	result = /obj/machinery/light/rogue/forge
	reqs = list(/obj/item/natural/stone = 4,
				/obj/item/rogueore/coal = 1)
	verbage_simple = "build"
	verbage = "builds"
	craftsound = null

/datum/crafting_recipe/roguetown/structure/sharpwheel
	name = "sharpening wheel"
	category = "Misc"
	result = /obj/structure/fluff/grindwheel
	reqs = list(/obj/item/ingot/iron = 1,
				/obj/item/natural/stone = 1)
	skillcraft = /datum/skill/craft/blacksmithing
	verbage_simple = "build"
	verbage = "builds"
	craftsound = null

/datum/crafting_recipe/roguetown/structure/loom
	name = "loom"
	category = "Misc"
	result = /obj/machinery/loom
	reqs = list(/obj/item/grown/log/tree/small = 2,
				/obj/item/grown/log/tree/stick = 2,
				/obj/item/natural/fibers = 2)
	verbage_simple = "construct"
	verbage = "constructs"
	craftdiff = 2

/datum/crafting_recipe/roguetown/structure/alch
	name = "alchemy station"
	category = "Misc"
	result = /obj/structure/fluff/alch
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/stone = 4,
				/obj/item/grown/log/tree/small = 1)
	skillcraft = /datum/skill/craft/alchemy
	craftdiff = 0
	verbage_simple = "assemble"
	verbage = "assembles"

/datum/crafting_recipe/roguetown/structure/dyestation
	name = "dye station"
	category = "Displays"
	result = /obj/machinery/gear_painter
	reqs = list(/obj/item/natural/stone = 2)
	verbage_simple = "make"
	verbage = "makes"
	craftdiff = 0
/*
/datum/crafting_recipe/roguetown/structure/stairs
	name = "stairs (up)"
	result = /obj/structure/stairs
	reqs = list(/obj/item/grown/log/tree/small = 1)

	verbage = "constructs"
	craftsound = 'sound/foley/Building-01.ogg'
	ontile = TRUE

/datum/crafting_recipe/roguetown/structure/stairs/TurfCheck(mob/user, turf/T)
	var/turf/checking = get_step_multiz(T, UP)
	if(!checking)
		return FALSE
	if(!istype(checking,/turf/open/transparent/openspace))
		return FALSE
	checking = get_step(checking, user.dir)
	if(!checking)
		return FALSE
	if(!isopenturf(checking))
		return FALSE
	if(istype(checking,/turf/open/transparent/openspace))
		return FALSE
	for(var/obj/structure/S in checking)
		if(istype(S, /obj/structure/stairs))
			return FALSE
		if(S.density)
			return FALSE
	return TRUE
*/
/datum/crafting_recipe/roguetown/structure/stairsd
	name = "wooden stairs (down)"
	category = "Stairs"
	result = /obj/structure/stairs/d
	reqs = list(/obj/item/grown/log/tree/small = 2)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 2
	verbage_simple = "construct"
	verbage = "constructs"
	ontile = TRUE

/datum/crafting_recipe/roguetown/structure/stairsd/TurfCheck(mob/user, turf/T)
	var/turf/checking = get_step(T, user.dir)
	if(!checking)
		return FALSE
	if(!istype(checking,/turf/open/transparent/openspace))
		return FALSE
	checking = get_step_multiz(checking, DOWN)
	if(!checking)
		return FALSE
	if(!isopenturf(checking))
		return FALSE
	if(istype(checking,/turf/open/transparent/openspace))
		return FALSE
	for(var/obj/structure/S in checking)
		if(istype(S, /obj/structure/stairs))
			return FALSE
		if(S.density)
			return FALSE
	return TRUE

/datum/crafting_recipe/roguetown/structure/stonestairsd
	name = "stone stairs (down)"
	category = "Stairs"
	result = /obj/structure/stairs/stone/d
	reqs = list(/obj/item/natural/stone = 2)
	skillcraft = /datum/skill/craft/masonry
	craftdiff = 2
	verbage_simple = "builds"
	verbage = "builds"
	ontile = TRUE

/datum/crafting_recipe/roguetown/structure/stonestairsd/TurfCheck(mob/user, turf/T)
	var/turf/checking = get_step(T, user.dir)
	if(!checking)
		return FALSE
	if(!istype(checking,/turf/open/transparent/openspace))
		return FALSE
	checking = get_step_multiz(checking, DOWN)
	if(!checking)
		return FALSE
	if(!isopenturf(checking))
		return FALSE
	if(istype(checking,/turf/open/transparent/openspace))
		return FALSE
	for(var/obj/structure/S in checking)
		if(istype(S, /obj/structure/stairs))
			return FALSE
		if(S.density)
			return FALSE
	return TRUE

/datum/crafting_recipe/roguetown/structure/bordercorner
	name = "border corner"
	category = "Railings"
	result = /obj/structure/fluff/railing/corner
	reqs = list(/obj/item/natural/wood/plank = 1)
	ontile = TRUE
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	buildsame = TRUE
	diagonal = TRUE
	craftdiff = 1

/datum/crafting_recipe/roguetown/structure/border
	name = "border"
	category = "Railings"
	result = /obj/structure/fluff/railing/border
	reqs = list(/obj/item/natural/wood/plank = 1)
	ontile = TRUE
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	buildsame = TRUE
	craftdiff = 1

/datum/crafting_recipe/roguetown/structure/railing
	name = "railing"
	category = "Railings"
	result = /obj/structure/fluff/railing/wood
	reqs = list(/obj/item/grown/log/tree/small = 1)
	ontile = TRUE
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	buildsame = TRUE

/datum/crafting_recipe/roguetown/structure/fence
	name = "palisade (stake x2)"
	category = "Railings"
	result = /obj/structure/fluff/railing/fence
	reqs = list(/obj/item/grown/log/tree/stake = 2)
	ontile = TRUE
	verbage_simple = "set up"
	verbage = "sets up"
	buildsame = TRUE

/datum/crafting_recipe/roguetown/structure/headstake
	name = "head stake"
	category = "Displays"
	result = /obj/structure/fluff/headstake
	reqs = list(/obj/item/grown/log/tree/stake = 1,
				/obj/item/bodypart/head = 1)
	parts = list(/obj/item/bodypart/head = 1,
			/obj/item/grown/log/tree/stake = 1)
	verbage_simple = "set up"
	verbage = "sets up"
	craftdiff = 0


/datum/crafting_recipe/roguetown/structure/fencealt
	name = "palisade (small log)"
	category = "Railings"
	result = /obj/structure/fluff/railing/fence
	reqs = list(/obj/item/grown/log/tree/small = 1)
	ontile = TRUE
	verbage_simple = "set up"
	verbage = "sets up"
	buildsame = TRUE

/datum/crafting_recipe/roguetown/structure/rack
	name = "rack"
	category = "Displays"
	result = /obj/structure/rack/rogue
	reqs = list(/obj/item/grown/log/tree/stick = 3)
	verbage_simple = "construct"
	verbage = "constructs"
	craftdiff = 0

/datum/crafting_recipe/roguetown/structure/chest
	name = "chest"
	category = "Containers"
	result = /obj/structure/closet/crate/chest/crafted
	reqs = list(/obj/item/grown/log/tree/small = 1)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 0

/obj/structure/closet/crate/chest/crafted
	keylock = FALSE
	sellprice = 6

/datum/crafting_recipe/roguetown/structure/closet
	name = "closet"
	category = "Containers"
	result = /obj/structure/closet/crate/roguecloset
	reqs = list(/obj/item/grown/log/tree/small = 2)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry

/datum/crafting_recipe/roguetown/structure/coffin
	name = "wooden coffin"
	category = "Containers"
	result = /obj/structure/closet/crate/coffin
	reqs = list(/obj/item/grown/log/tree/small = 2)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

/datum/crafting_recipe/roguetown/structure/sleepcoffin
	name = "sleep coffin"
	category = "Containers"
	result = /obj/structure/closet/crate/coffin/vampire
	reqs = list(/obj/item/natural/wood/plank = 2, /obj/item/natural/silk = 1)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

/obj/structure/closet/crate/roguecloset/crafted
	sellprice = 6

/datum/crafting_recipe/roguetown/structure/campfire
	name = "campfire"
	category = "Misc"
	result = /obj/machinery/light/rogue/campfire
	reqs = list(/obj/item/grown/log/tree/stick = 2)
	verbage_simple = "build"
	verbage = "builds"
	craftdiff = 0

/datum/crafting_recipe/roguetown/structure/densefire
	name = "greater campfire"
	category = "Misc"
	result = /obj/machinery/light/rogue/campfire/densefire
	reqs = list(/obj/item/grown/log/tree/stick = 2,
				/obj/item/natural/stone = 2)
	verbage_simple = "build"
	verbage = "builds"

/datum/crafting_recipe/roguetown/structure/cookpit
	name = "hearth"
	category = "Misc"
	result = /obj/machinery/light/rogue/hearth
	reqs = list(/obj/item/grown/log/tree/stick = 1,
				/obj/item/natural/stone = 3)
	verbage_simple = "build"
	verbage = "builds"

/datum/crafting_recipe/roguetown/structure/brazier
	name = "brazier"
	category = "Lighting"
	result = /obj/machinery/light/rogue/firebowl/stump
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/rogueore/coal = 1)
	verbage_simple = "assembles"
	verbage = "assembles"

/datum/crafting_recipe/roguetown/structure/standing
	name = "standing fire"
	category = "Lighting"
	result = /obj/machinery/light/rogue/firebowl/standing
	reqs = list(/obj/item/natural/stone = 1,
				/obj/item/rogueore/coal = 1)
	verbage_simple = "construct"
	verbage = "constructs"

/datum/crafting_recipe/roguetown/structure/standingblue
	name = "standing fire (blue)"
	category = "Lighting"
	result = /obj/machinery/light/rogue/firebowl/standing/blue
	reqs = list(/obj/item/natural/stone = 1,
				/obj/item/rogueore/coal = 1,
				/obj/item/ash = 1)
	verbage_simple = "construct"
	verbage = "constructs"

/datum/crafting_recipe/roguetown/structure/oven
	name = "oven"
	category = "Misc"
	result = /obj/machinery/light/rogue/oven
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/natural/stone = 3)
	verbage_simple = "build"
	verbage = "builds"
	skillcraft = /datum/skill/craft/masonry
	wallcraft = TRUE

/datum/crafting_recipe/roguetown/structure/fireplace
	name = "Fireplace (North)"
	category = "Misc"
	result = /obj/machinery/light/rogue/campfire/fireplace
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/natural/stoneblock = 3)
	verbage_simple = "build"
	verbage = "builds"
	skillcraft = /datum/skill/craft/masonry
	wallcraft = TRUE

/datum/crafting_recipe/roguetown/structure/tanningrack
	name = "drying rack"
	category = "Misc"
	result = /obj/machinery/tanningrack
	reqs = list(/obj/item/grown/log/tree/stick = 3)
	verbage_simple = "construct"
	verbage = "constructs"
	craftdiff = 0

/datum/crafting_recipe/roguetown/structure/strawbed
	name = "bed, straw"
	category = "Beds"
	result = /obj/structure/bed/rogue/shit
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/natural/fibers = 1)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 0

/datum/crafting_recipe/roguetown/structure/bed
	name = "bed, nice"
	category = "Beds"
	result = /obj/structure/bed/rogue/inn
	reqs = list(/obj/item/grown/log/tree/small = 2,
				/obj/item/natural/cloth = 2)
	tools = list(/obj/item/needle)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

/datum/crafting_recipe/roguetown/structure/woolbed
	name = "bed, wood"
	category = "Beds"
	result = /obj/structure/bed/rogue/inn/wool
	reqs = list(/obj/item/grown/log/tree/small = 2,
				/obj/item/natural/cloth = 1)
	tools = list(/obj/item/needle)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

/datum/crafting_recipe/roguetown/structure/doublebed
	name = "bed, double"
	category = "Beds"
	result = /obj/structure/bed/rogue/inn/double
	reqs = list(/obj/item/grown/log/tree/small = 3,
				/obj/item/natural/cloth = 4)
	tools = list(/obj/item/needle)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 2


/datum/crafting_recipe/roguetown/structure/wooldoublebed
	name = "bed, double wool"
	category = "Beds"
	result = /obj/structure/bed/rogue/inn/wooldouble
	reqs = list(/obj/item/grown/log/tree/small = 3,
				/obj/item/natural/cloth = 3)
	tools = list(/obj/item/needle)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 2

/datum/crafting_recipe/roguetown/structure/table
	name = "wooden table"
	category = "Tables"
	result = /obj/structure/table/wood/crafted
	reqs = list(/obj/item/grown/log/tree/small = 1)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry

/datum/crafting_recipe/roguetown/structure/fancytableblack
	name = "fancy wooden table(black)"
	category = "Tables"
	result = /obj/structure/table/wood/fancy/black
	reqs = list(/obj/item/natural/wood/plank = 1, /obj/item/natural/silk = 1)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 3

/datum/crafting_recipe/roguetown/structure/fancytableblue
	name = "fancy wooden table(blue)"
	category = "Tables"
	result = /obj/structure/table/wood/fancy/blue
	reqs = list(/obj/item/natural/wood/plank = 1, /obj/item/natural/silk = 1)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 3

/datum/crafting_recipe/roguetown/structure/fancytablecyan
	name = "fancy wooden table(cyan)"
	category = "Tables"
	result = /obj/structure/table/wood/fancy/cyan
	reqs = list(/obj/item/natural/wood/plank = 1, /obj/item/natural/silk = 1)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 3

/datum/crafting_recipe/roguetown/structure/fancytablegreen
	name = "fancy wooden table(green)"
	category = "Tables"
	result = /obj/structure/table/wood/fancy/green
	reqs = list(/obj/item/natural/wood/plank = 1, /obj/item/natural/silk = 1)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 3

/datum/crafting_recipe/roguetown/structure/fancytableorange
	name = "fancy wooden table(orange)"
	category = "Tables"
	result = /obj/structure/table/wood/fancy/orange
	reqs = list(/obj/item/natural/wood/plank = 1, /obj/item/natural/silk = 1)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 3

/datum/crafting_recipe/roguetown/structure/fancytablepurple
	name = "fancy wooden table(purple)"
	category = "Tables"
	result = /obj/structure/table/wood/fancy/purple
	reqs = list(/obj/item/natural/wood/plank = 1, /obj/item/natural/silk = 1)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 3

/datum/crafting_recipe/roguetown/structure/fancytablered
	name = "fancy wooden table(red)"
	category = "Tables"
	result = /obj/structure/table/wood/fancy/red
	reqs = list(/obj/item/natural/wood/plank = 1, /obj/item/natural/silk = 1)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 3

/datum/crafting_recipe/roguetown/structure/fancytableroyalblack
	name = "fancy wooden table(royal black)"
	category = "Tables"
	result = /obj/structure/table/wood/fancy/royalblack
	reqs = list(/obj/item/natural/wood/plank = 1, /obj/item/natural/silk = 1)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 4

/datum/crafting_recipe/roguetown/structure/fancytableroyalblue
	name = "fancy wooden table(royal blue)"
	category = "Tables"
	result = /obj/structure/table/wood/fancy/royalblue
	reqs = list(/obj/item/natural/wood/plank = 1, /obj/item/natural/silk = 1)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 4

/datum/crafting_recipe/roguetown/structure/longtable
	name = "nice long table"
	category = "Tables"
	result = /obj/structure/table/wood/long_table
	reqs = list(/obj/item/natural/wood/plank = 2)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 4

/datum/crafting_recipe/roguetown/structure/longtablealt
	name = "nice long table(middle)"
	category = "Tables"
	result = /obj/structure/table/wood/long_table/mid/alt
	reqs = list(/obj/item/natural/wood/plank = 2)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 4

/datum/crafting_recipe/roguetown/structure/largetable
	name = "large table"
	category = "Tables"
	result = /obj/structure/table/wood/large_table
	reqs = list(/obj/item/natural/wood/plank = 2)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 3

/datum/crafting_recipe/roguetown/structure/operatingtable
	name = "operating table"
	category = "Beds"
	result = /obj/structure/table/optable
	reqs = list(/obj/item/grown/log/tree/small = 2)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 2

/datum/crafting_recipe/roguetown/structure/stonetable
	name = "stone table"
	category = "Tables"
	result = /obj/structure/table/church
	reqs = list(/obj/item/natural/stone = 1)
	verbage_simple = "build"
	verbage = "builds"
	skillcraft = /datum/skill/craft/masonry

/datum/crafting_recipe/roguetown/structure/finestonetable
	name = "fine stone table"
	category = "Tables"
	result = /obj/structure/table/finestone
	reqs = list(/obj/item/natural/stoneblock = 1)
	verbage_simple = "build"
	verbage = "builds"
	skillcraft = /datum/skill/craft/masonry

/datum/crafting_recipe/roguetown/structure/millstone
	name = "millstone"
	category = "Misc"
	result = /obj/item/millstone
	reqs = list(/obj/item/natural/stone = 3)
	verbage = "assembles"
	craftsound = null
	skillcraft = /datum/skill/craft/masonry

/datum/crafting_recipe/roguetown/structure/sign
	name = "custom sign"
	category = "Displays"
	result = /obj/structure/fluff/customsign
	reqs = list(/obj/item/grown/log/tree/small = 1)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

/datum/crafting_recipe/roguetown/structure/dummy
	name = "training dummy"
	category = "Misc"
	result = /obj/structure/fluff/statue/tdummy
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/grown/log/tree/stick = 1,
				/obj/item/natural/fibers = 1)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

/datum/crafting_recipe/roguetown/structure/wallladder
	name = "wall ladder"
	category = "Stairs"
	result = /obj/structure/wallladder
	reqs = list(/obj/item/grown/log/tree/small = 1)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	wallcraft = TRUE
	craftdiff = 2

/datum/crafting_recipe/roguetown/structure/torchholder
	name = "sconce"
	category = "Lighting"
	result = /obj/machinery/light/rogue/torchholder
	reqs = list(/obj/item/natural/stone = 2)
	verbage_simple = "build"
	verbage = "builds"
	skillcraft = /datum/skill/craft/masonry
	wallcraft = TRUE
	craftdiff = 0

/datum/crafting_recipe/roguetown/structure/stonelantern
	name = "stone lantern (ground)"
	category = "Lighting"
	result = /obj/machinery/light/rogue/torchholder/hotspring
	reqs = list(/obj/item/natural/stone = 2)
	verbage_simple = "build"
	verbage = "builds"
	wallcraft = FALSE
	skillcraft = /datum/skill/craft/masonry

/datum/crafting_recipe/roguetown/structure/stonelanternstanding
	name = "stone lantern (standing)"
	category = "Lighting"
	result = /obj/machinery/light/rogue/torchholder/hotspring/standing
	reqs = list(/obj/item/natural/stone = 2)
	verbage_simple = "build"
	verbage = "builds"
	wallcraft = FALSE
	skillcraft = /datum/skill/craft/masonry

/datum/crafting_recipe/roguetown/structure/wallcandle
	name = "wall candles"
	category = "Lighting"
	result = /obj/machinery/light/rogue/candle
	reqs = list(/obj/item/natural/stone = 1, /obj/item/candle/yellow = 1)
	verbage_simple = "build"
	verbage = "builds"
	skillcraft = /datum/skill/craft/masonry
	wallcraft = TRUE
	craftdiff = 0

/datum/crafting_recipe/roguetown/structure/wallcandleblue
	name = "wall candles (blue)"
	category = "Lighting"
	result = /obj/machinery/light/rogue/candle/blue
	reqs = list(/obj/item/natural/stone = 1, /obj/item/candle/yellow = 1, /obj/item/ash = 1)
	verbage_simple = "build"
	verbage = "builds"
	skillcraft = /datum/skill/craft/masonry
	wallcraft = TRUE
	craftdiff = 0

/datum/crafting_recipe/roguetown/structure/stonewalldeco
	name = "stone wall decoration"
	category = "Misc"
	result = /obj/structure/fluff/walldeco/stone
	reqs = list(/obj/item/natural/stone = 1)
	verbage_simple = "build"
	verbage = "builds"
	skillcraft = /datum/skill/craft/masonry
	wallcraft = TRUE
	craftdiff = 2

/datum/crafting_recipe/roguetown/structure/statue
	name = "statue"
	category = "Misc"
	result = /obj/structure/fluff/statue/femalestatue //TODO: Add sculpting
	reqs = list(/obj/item/natural/stone = 3)
	verbage_simple = "build"
	verbage = "builds"
	skillcraft = /datum/skill/craft/masonry
	craftdiff = 3

// SCOM is not constructable, only the receive only version is constructable to prevent unactionable sneeding.
/datum/crafting_recipe/roguetown/structure/rcom
	name = "RCOM"
	category = "Misc"
	result = /obj/structure/roguemachine/scomm/receive_only
	reqs = list(/obj/item/ingot/iron = 1,
					/obj/item/reagent_containers/food/snacks/smallrat = 1)
	verbage_simple = "assemble"
	verbage = "assembles"
	skillcraft = /datum/skill/magic/arcane
	craftdiff = 3
	wallcraft = TRUE
	ontile = TRUE

/datum/crafting_recipe/roguetown/structure/cauldronalchemy
	name = "alchemy cauldron"
	category = "Misc"
	result = /obj/machinery/light/rogue/cauldron
	reqs = list(/obj/item/ingot/iron = 1)
	verbage_simple = "assemble"
	verbage = "assembles"
	skillcraft = /datum/skill/craft/alchemy
	craftdiff = 1

/datum/crafting_recipe/roguetown/structure/ceramicswheel
	name = "potter's wheel"
	category = "Misc"
	result = /obj/structure/fluff/ceramicswheel
	reqs = list(/obj/item/natural/stone = 2, /obj/item/grown/log/tree/small = 2, /obj/item/roguegear = 1)
	verbage_simple = "construct"
	craftdiff = 2
	verbage = "constructs"

/datum/crafting_recipe/roguetown/structure/bearrug
	name = "bearpelt rug"
	category = "Floors"
	result = /obj/structure/bearpelt
	reqs = list(/obj/item/natural/fur/direbear = 2, /obj/item/natural/head/direbear = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/structure/foxrug
	name = "foxpelt rug"
	category = "Floors"
	result = /obj/structure/foxpelt
	reqs = list(/obj/item/natural/fur/fox = 2, /obj/item/natural/head/fox = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/structure/bobcatrug
	name = "lynxpelt rug"
	category = "Floors"
	result = /obj/structure/bobcatpelt
	reqs = list(/obj/item/natural/fur/bobcat = 2)	//Gives no head for lynx, plus it's the smallest rug anyway.
	craftdiff = 0

/datum/crafting_recipe/roguetown/structure/curtain
	name = "curtain"
	category = "Misc"
	result = /obj/structure/curtain
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 0
	ignoredensity = TRUE

/datum/crafting_recipe/roguetown/structure/curtainblack
	name = "curtain(black)"
	category = "Misc"
	result = /obj/structure/curtain/black
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk= 1 )
	craftdiff = 3
	ignoredensity = TRUE

/datum/crafting_recipe/roguetown/structure/curtainblue
	name = "curtain(blue)"
	category = "Misc"
	result = /obj/structure/curtain/blue
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk= 1 )
	craftdiff = 3
	ignoredensity = TRUE

/datum/crafting_recipe/roguetown/structure/curtainbrown
	name = "curtain(brown)"
	category = "Misc"
	result = /obj/structure/curtain/brown
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk= 1 )
	craftdiff = 3
	ignoredensity = TRUE

/datum/crafting_recipe/roguetown/structure/curtaingreen
	name = "curtain(green)"
	category = "Misc"
	result = /obj/structure/curtain/green
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk= 1 )
	craftdiff = 3
	ignoredensity = TRUE

/datum/crafting_recipe/roguetown/structure/curtainmagenta
	name = "curtain(magenta)"
	category = "Misc"
	result = /obj/structure/curtain/magenta
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk= 1 )
	craftdiff = 3
	ignoredensity = TRUE

/datum/crafting_recipe/roguetown/structure/curtainpurple
	name = "curtain(purple)"
	category = "Misc"
	result = /obj/structure/curtain/purple
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk= 1 )
	craftdiff = 3
	ignoredensity = TRUE

/datum/crafting_recipe/roguetown/structure/curtainred
	name = "curtain(red)"
	category = "Misc"
	result = /obj/structure/curtain/red
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk= 1 )
	craftdiff = 3
	ignoredensity = TRUE

/datum/crafting_recipe/roguetown/structure/apiary
	name = "apiary"
	category = "Misc"
	result = /obj/structure/apiary
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/grown/log/tree/stick = 4)
	verbage_simple = "build"
	verbage = "builds"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 2

// Here for now until we get a new file for anything trap related.
/datum/crafting_recipe/roguetown/structure/spike_pit
	name = "spike pit (Dirt Floor needed)"
	category = "Misc"
	result = list(/obj/structure/spike_pit)
	tools = list(/obj/item/rogueweapon/shovel = 1)
	reqs = list(/obj/item/grown/log/tree/stake = 3)
	skillcraft = /datum/skill/craft/crafting
	craftdiff = 1	//Low skill, but at least some. Kinda decently strong after all w/ combat.

/datum/crafting_recipe/roguetown/structure/spike_pit/TurfCheck(mob/user, turf/T)
	var/turf/to_check = get_step(user.loc, user.dir)
	if(!istype(to_check, /turf/open/floor/rogue/dirt))
		to_chat(user, span_info("I need a dirt floor to do this."))
		return FALSE
	for(var/obj/O in T.contents)
		if(istype(O, /obj/structure/spike_pit))
			to_chat(user, span_info("There's already a pit of spikes here."))
			return FALSE
	return TRUE

/datum/crafting_recipe/roguetown/structure/wicker
	name = "wicker basket"
	category = "Containers"
	result = /obj/structure/closet/crate/chest/wicker
	reqs = list(/obj/item/grown/log/tree/stick = 4,
				/obj/item/natural/fibers = 3)
	verbage_simple = "weave"
	verbage = "weaves"
	craftdiff = 0
