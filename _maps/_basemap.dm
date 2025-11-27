#include "map_files\generic\CentCom.dmm"

#ifndef LOWMEMORYMODE
	#ifdef ALL_MAPS
		#include "map_files\dun_world\dun_world.dmm"
		#include "map_files\roguetest\roguetest.dmm"
		#include "map_files\otherz\bandit_fortress.dmm"
		#include "map_files\otherz\dungeon.dmm"
		#include "map_files\otherz\vl_manor.dmm"

		#ifdef ALL_TEMPLATES
			#include "templates.dm"
		#endif

		#ifdef ALL_DUNGEONS
			#include "dungeons.dm"
		#endif

	#endif
#endif
