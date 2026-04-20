#define LOWMEMORYMODE //uncomment this to load centcom and runtime station and thats it.

#include "map_files\generic\CentCom.dmm"
#include "map_files\otherz\warbands.dmm"

#ifndef LOWMEMORYMODE
	#ifdef ALL_MAPS
		#include "map_files\dun_world\dun_world.dmm"
		#include "map_files\roguetest\roguetest.dmm"
		#include "map_files\otherz\dungeon.dmm"
		#include "map_files\otherz\wretch_coast.dmm"
		#include "map_files\otherz\warbands.dmm"

		#ifdef ALL_TEMPLATES
			#include "templates.dm"
		#endif

		#ifdef ALL_DUNGEONS
			#include "dungeons.dm"
		#endif

	#endif
#endif
