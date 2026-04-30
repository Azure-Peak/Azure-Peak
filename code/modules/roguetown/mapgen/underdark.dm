/obj/effect/landmark/mapGenerator/rogue/underdark
	mapGeneratorType = /datum/mapGenerator/underdark
	endTurfX = 255
	endTurfY = 450
	startTurfX = 1
	startTurfY = 1

/datum/mapGenerator/underdark
	modules = list(/datum/mapGeneratorModule/underdarkstone, /datum/mapGeneratorModule/underdarkmud)


/datum/mapGeneratorModule/underdarkstone
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/rogue/naturalstone)
	allowed_areas = list(/area/rogue/under/underdark)
	spawnableAtoms = list(/obj/structure/flora/rogueshroom/happy/random = 30,
							/obj/structure/flora/mushroomcluster = 20,
							/obj/structure/flora/tinymushrooms = 20,
							/obj/structure/roguerock = 25,
							/obj/item/natural/rock = 25,
							/obj/structure/vine = 5,
							/obj/effect/hunting_track = 5)

/datum/mapGeneratorModule/underdarkmud
	clusterCheckFlags = CLUSTER_CHECK_SAME_ATOMS
	allowed_areas = list(/area/rogue/under/underdark)
	allowed_turfs = list(/turf/open/floor/rogue/dirt)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/mushroomcluster = 20,
							/obj/structure/flora/roguegrass/thorn_bush = 10,
							/obj/structure/flora/rogueshroom/happy/random = 40,
							/obj/structure/flora/rogueshroom = 20,
							/obj/structure/flora/tinymushrooms = 20,
							/obj/structure/flora/roguegrass = 30,
							/obj/structure/flora/roguegrass/herb/random = 5,
							/obj/effect/hunting_track = 5)
