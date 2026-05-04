//genstuff
/obj/effect/landmark/mapGenerator/rogue/bog
	mapGeneratorType = /datum/mapGenerator/bog
	endTurfX = 255
	endTurfY = 400
	startTurfX = 1
	startTurfY = 1


/datum/mapGenerator/bog
	modules = list(/datum/mapGeneratorModule/boggrassturf,/datum/mapGeneratorModule/bog,/datum/mapGeneratorModule/bogroad,/datum/mapGeneratorModule/boggrass)


/datum/mapGeneratorModule/bog
	clusterCheckFlags = CLUSTER_CHECK_NONE
	allowed_turfs = list(/turf/open/floor/rogue/dirt)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/newtree = 30,
							/obj/structure/flora/roguegrass/bush = 10,
							/obj/structure/flora/roguegrass = 26,
							/obj/structure/flora/roguegrass/maneater = 13,
							/obj/item/natural/stone = 23,
							/obj/item/natural/rock = 6,
							/obj/item/magic/artifact = 4,
							/obj/structure/leyline/powerful = 1,
							/obj/structure/voidstoneobelisk = 1,
							/obj/structure/flora/roguegrass/herb/manabloom = 4,
							/obj/item/grown/log/tree/stick = 16,
							/obj/structure/flora/roguetree/stump/log = 3,
							/obj/structure/flora/roguetree/stump = 4,
							/obj/structure/closet/dirthole/closed/loot = 3,
							/obj/structure/flora/roguegrass/swampweed = 10,
							/obj/structure/flora/roguegrass/bush/westleach = 10,
							/obj/structure/flora/roguegrass/maneater/real = 3,
							/obj/effect/hunting_track = 3)
	spawnableTurfs = list(/turf/open/floor/rogue/dirt/road=2,
						/turf/open/water/swamp=1)
	allowed_areas = list(/area/rogue/outdoors/bog)

/datum/mapGeneratorModule/bogroad
	clusterCheckFlags = CLUSTER_CHECK_NONE
	allowed_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/item/natural/stone = 9,/obj/item/grown/log/tree/stick = 6)

/datum/mapGeneratorModule/boggrassturf
	clusterCheckFlags = CLUSTER_CHECK_NONE
	allowed_turfs = list(/turf/open/floor/rogue/dirt)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableTurfs = list(/turf/open/floor/rogue/grass = 23)
	allowed_areas = list(/area/rogue/outdoors/bog)

/datum/mapGeneratorModule/boggrass
	clusterCheckFlags = CLUSTER_CHECK_NONE
	allowed_turfs = list(/turf/open/floor/rogue/grass)
	excluded_turfs = list()
	allowed_areas = list(/area/rogue/outdoors/bog)
	spawnableAtoms = list(/obj/structure/glowshroom = 20,
							/obj/structure/flora/roguetree = 30,
							/obj/structure/flora/roguetree/wise=5,
							/obj/structure/flora/roguegrass/bush = 10,
							/obj/structure/flora/roguegrass = 44,
							/obj/structure/flora/roguegrass/maneater = 15,
							/obj/structure/flora/roguegrass/maneater/real = 10,
							/obj/structure/flora/roguegrass/pumpkin = 2,
							/obj/item/natural/stone = 6,
							/obj/item/natural/rock = 1,
							/obj/item/grown/log/tree/stick = 3,
							/obj/structure/flora/roguetree/stump/log = 3,
							/obj/structure/flora/roguetree/evil = 5,
							/obj/effect/hunting_track = 3)

/datum/mapGeneratorModule/bogwater
	clusterCheckFlags = CLUSTER_CHECK_NONE
	allowed_turfs = list(/turf/open/water/swamp/deep)
	excluded_turfs = list()
	allowed_areas = list(/area/rogue/outdoors/bog)
	spawnableAtoms = list(/obj/structure/glowshroom = 44,
							/obj/item/restraints/legcuffs/beartrap/armed = 10,
							/obj/structure/flora/roguetree/stump/log = 3)
