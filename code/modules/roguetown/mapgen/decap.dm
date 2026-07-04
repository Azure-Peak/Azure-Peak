//genstuff
/obj/effect/landmark/mapGenerator/rogue/decap
	mapGeneratorType = /datum/mapGenerator/decap
	endTurfX = 255
	endTurfY = 255
	startTurfX = 1
	startTurfY = 1


/datum/mapGenerator/decap
	modules = list(/datum/mapGeneratorModule/decapsnow,/datum/mapGeneratorModule/decaproad, /datum/mapGeneratorModule/decapgrass)


/datum/mapGeneratorModule/decapsnow
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/rogue/snow)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/grass/both = 15,
	/obj/structure/flora/grass/brown = 20,
	/obj/structure/flora/grass/green = 20,
	/obj/item/grown/log/tree/stick = 16,
	/obj/structure/flora/roguegrass/pyroclasticflowers = 3,
	/obj/structure/flora/roguegrass/maneater/real=3,
	/obj/structure/flora/roguegrass/herb/random = 5,
	/obj/structure/leyline/normal/decap = 2,
	/obj/effect/hunting_track = 3)
	spawnableTurfs = list(/turf/open/floor/rogue/snowpatchy=15)
	allowed_areas = list(/area/rogue/outdoors/mountains/decap)

/datum/mapGeneratorModule/decaproad
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/item/natural/stone = 15,/obj/item/natural/rock = 3,/obj/item/grown/log/tree/stick = 6)
	allowed_areas = list(/area/rogue/outdoors/mountains/decap)

/datum/mapGeneratorModule/decapgrass
	clusterCheckFlags =  CLUSTER_CHECK_SAME_ATOMS
	allowed_turfs = list(/turf/open/floor/rogue/grass, /turf/open/floor/rogue/grassred, /turf/open/floor/rogue/grassyel, /turf/open/floor/rogue/grasscold)
	excluded_turfs = list()
	allowed_areas = list(/area/rogue/outdoors/mountains/decap)
	spawnableAtoms = list(/obj/structure/flora/roguegrass = 25,
							/obj/structure/flora/roguegrass/herb/random = 2,
							/obj/structure/flora/roguegrass/bush/westleach = 2,
							/obj/item/natural/stone = 6,
							/obj/item/natural/rock = 1,
							/obj/item/grown/log/tree/stick = 3,
							/obj/effect/hunting_track = 3)
