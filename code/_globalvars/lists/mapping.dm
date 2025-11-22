GLOBAL_LIST_INIT(cardinals, list(NORTH, SOUTH, EAST, WEST))
GLOBAL_LIST_INIT(cardinals_multiz, list(NORTH, SOUTH, EAST, WEST, UP, DOWN))
GLOBAL_LIST_INIT(diagonals, list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
GLOBAL_LIST_INIT(corners_multiz, list(UP|NORTHEAST, UP|NORTHWEST, UP|SOUTHEAST, UP|SOUTHWEST, DOWN|NORTHEAST, DOWN|NORTHWEST, DOWN|SOUTHEAST, DOWN|SOUTHWEST))
GLOBAL_LIST_INIT(diagonals_multiz, list(
	NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST,
	UP|NORTH, UP|SOUTH, UP|EAST, UP|WEST, UP|NORTHEAST, UP|NORTHWEST, UP|SOUTHEAST, UP|SOUTHWEST,
	DOWN|NORTH, DOWN|SOUTH, DOWN|EAST, DOWN|WEST, DOWN|NORTHEAST, DOWN|NORTHWEST, DOWN|SOUTHEAST, DOWN|SOUTHWEST))
GLOBAL_LIST_INIT(alldirs_multiz, list(
	NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST,
	UP, UP|NORTH, UP|SOUTH, UP|EAST, UP|WEST, UP|NORTHEAST, UP|NORTHWEST, UP|SOUTHEAST, UP|SOUTHWEST,
	DOWN, DOWN|NORTH, DOWN|SOUTH, DOWN|EAST, DOWN|WEST, DOWN|NORTHEAST, DOWN|NORTHWEST, DOWN|SOUTHEAST, DOWN|SOUTHWEST))
GLOBAL_LIST_INIT(alldirs, list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))

// the following are lookup tables!
GLOBAL_LIST_INIT(reverse_dir, list( // GLOB.reverse_dir[dir] = reverse of dir
	     2,  1,  3,  8, 10,  9, 11,  4,  6,  5,  7, 12, 14, 13, 15,
	32, 34, 33, 35, 40, 42,	41, 43, 36, 38, 37, 39, 44, 46, 45, 47,
	16, 18, 17, 19, 24, 26, 25, 27, 20, 22, 21,	23, 28, 30, 29, 31,
	48, 50, 49, 51, 56, 58, 57, 59, 52, 54, 53, 55, 60, 62, 61, 63
))
GLOBAL_LIST_INIT(adjacentdirs, list( // GLOB.adjacentdirs[dir] = list of directions adjacent to that direction
	    12, 12, 12,  3, 15, 15, 15,  3, 15, 15, 15,  3, 15, 15, 15,
	16,	28, 28, 28, 19, 31, 31, 31, 19, 31, 31, 31, 31, 31, 31, 31, // UP - Same as first line but +16
	32,	44,	44, 44, 35, 47, 47, 47, 35, 47, 47, 47, 35, 47, 47, 47, // DOWN - Same as first line but +32
	48,	60, 60,	60, 51, 63, 63, 63, 51, 63, 63, 63, 51, 63, 63, 63  // UP+DOWN - Same as first line but +48
))
GLOBAL_LIST_INIT(flip_dir, list( // GLOB.flip_dir[dir] = 180 degree rotation of dir. Unlike reverse_dir, UP remains UP and DOWN remains DOWN.
	     2,  1,  3,  8, 10,  9, 11,  4,  6,  5,  7, 12, 14, 13, 15,
	16, 18, 17, 19, 24, 26, 25, 27, 20, 22, 21, 23, 28, 30, 29, 31, // UP - Same as first line but +16
	32, 34, 33, 35, 40, 42, 41, 43, 36, 38, 37, 39, 44, 46, 45, 47, // DOWN - Same as first line but +32
	48, 50, 49, 51, 56, 58, 57, 59, 52, 54, 53, 55, 60, 62, 61, 63  // UP+DOWN - Same as first line but +48
))
GLOBAL_LIST_INIT(cw_dir, list( // GLOB.cw_dir[dir] = clockwise rotation of dir. UP remains UP and DOWN remains DOWN.
	     4,  8, 12,  2,  6, 10, 14,  1,  5,  9, 13,  3,  7, 11, 15,
	16, 20, 24, 28, 18, 22, 26, 30, 17, 21, 25, 19, 29, 23, 27, 31, // UP - Same as first line but +16
	32, 36, 40, 44, 34, 38, 42, 46, 33, 37, 41, 45, 35, 39, 43, 47, // DOWN - Same as first line but +32
	48, 52, 56, 40, 50, 54, 58, 62, 49, 53, 57, 61, 51, 55, 59, 63  // UP+DOWN - Same as first line but +48
))
GLOBAL_LIST_INIT(ccw_dir, list( // GLOB.ccw_dir[dir] = counter-clockwise rotation of dir. Unlike reverse_dir, UP remains UP & DOWN remains DOWN.
	     8,  4, 12,  1,  9,  5, 13,  2, 10,  6, 14,  3, 11,  7, 15,
	16, 24, 20, 28, 17, 25, 21, 29, 18, 26, 22, 30, 19, 27, 23, 31, // UP - Same as first line but +16
	32, 40, 36, 44, 33, 41, 37, 45, 34, 42, 38, 46, 35, 43, 39, 47, // DOWN - Same as first line but +32
	48, 56, 52, 60, 49, 57, 53, 61, 50, 58, 54, 62, 51, 59, 55, 63  // UP+DOWN - Same as first line but +48
))


GLOBAL_LIST_EMPTY(landmarks_list)				//list of all landmarks created
GLOBAL_LIST_EMPTY(start_landmarks_list)			//list of all spawn points created
GLOBAL_LIST_EMPTY(department_security_spawns)	//list of all department security spawns
GLOBAL_LIST_EMPTY(generic_event_spawns)			//handles clockwork portal+eminence teleport destinations
GLOBAL_LIST_EMPTY(jobspawn_overrides)			//These will take precedence over normal spawnpoints if created.
GLOBAL_LIST_EMPTY(quest_landmarks_list)

GLOBAL_LIST_EMPTY(wizardstart)
GLOBAL_LIST_EMPTY(nukeop_start)
GLOBAL_LIST_EMPTY(bandit_starts)
GLOBAL_LIST_EMPTY(vlord_starts)
GLOBAL_LIST_EMPTY(vspawn_starts)
GLOBAL_LIST_EMPTY(dknight_starts)
GLOBAL_LIST_EMPTY(vlordspawn_starts)
GLOBAL_LIST_EMPTY(delf_starts)
GLOBAL_LIST_EMPTY(nukeop_leader_start)
GLOBAL_LIST_EMPTY(newplayer_start)
GLOBAL_LIST_EMPTY(prisonwarp)	//admin prisoners go to these
GLOBAL_LIST_EMPTY(holdingfacility)	//captured people go here (ninja energy net)
GLOBAL_LIST_EMPTY(tdome1)
GLOBAL_LIST_EMPTY(tdome2)
GLOBAL_LIST_EMPTY(tdomeobserve)
GLOBAL_LIST_EMPTY(tdomeadmin)
GLOBAL_LIST_EMPTY(prisonwarped)	//list of players already warped
GLOBAL_LIST_EMPTY(blobstart) //stationloving objects, blobs, santa, respawning devils
GLOBAL_LIST_EMPTY(underworldspawn)
GLOBAL_LIST_EMPTY(hauntstart)
GLOBAL_LIST_EMPTY(testportals)
GLOBAL_LIST_EMPTY(traveltiles)
GLOBAL_LIST_EMPTY(migrationpoints)
GLOBAL_LIST_EMPTY(secequipment) //sec equipment lockers that scale with the number of sec players
GLOBAL_LIST_EMPTY(deathsquadspawn)
GLOBAL_LIST_EMPTY(emergencyresponseteamspawn)
GLOBAL_LIST_EMPTY(ruin_landmarks)
GLOBAL_LIST_EMPTY(secondlife_respawns)

	//away missions
GLOBAL_LIST_EMPTY(awaydestinations)	//a list of landmarks that the warpgate can take you to
GLOBAL_LIST_EMPTY(vr_spawnpoints)

	//used by jump-to-area etc. Updated by area/updateName()
GLOBAL_LIST_EMPTY(sortedAreas)
/// An association from typepath to area instance. Only includes areas with `unique` set.
GLOBAL_LIST_EMPTY_TYPED(areas_by_type, /area)
GLOBAL_LIST_EMPTY(areas)
GLOBAL_LIST_EMPTY(all_abstract_markers)

GLOBAL_LIST_EMPTY(fires_list)

GLOBAL_LIST_EMPTY(streetlamp_list)

/// List of all the maps that have been cached for /proc/load_map
GLOBAL_LIST_EMPTY(cached_maps)
