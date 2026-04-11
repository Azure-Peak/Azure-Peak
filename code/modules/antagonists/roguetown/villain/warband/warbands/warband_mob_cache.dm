/*	
	NPC CACHE
	- retrieves pre-equipped goons from a shared cache, or spawns fresh ones if the cache is empty

	1 - GET CACHED GRUNT		// attempts to retrieve a goon NPC from the cache
	2 - HAS COMPATIBLE CACHE	// checks if two managers share the same warband/subtype
	3 - SHARE CACHE WITH		// links caches together
	4 - GET GRUNT CACHE			// returns the root goon cache list to use
*/

/atom/movable/screen/warband/manager/proc/get_cached_grunt(turf/spawn_location, mob/owner)
	var/list/cache_to_use = get_grunt_cache()
	var/mob/living/carbon/human/species/human/northern/goon/grunt
	if(cache_to_use.len)
		grunt = cache_to_use[1]
		cache_to_use -= grunt
		grunt.forceMove(spawn_location)
		grunt.mode = NPC_AI_IDLE
		grunt.warband_ID = src.warband_ID
		grunt.faction = list()  // clear any old factions
		grunt.faction |= list("warband_[src.warband_ID]")
		START_PROCESSING(SShumannpc, grunt)
	else
		grunt = new /mob/living/carbon/human/species/human/northern/goon(spawn_location)
		grunt.warband = src.selected_warband
		if(src.selected_subtype)
			grunt.subtype = src.selected_subtype
		grunt.warband_ID = src.warband_ID
		grunt.equip_for_warband()
	return grunt

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// NPC CACHE SHARING
/* 
	when a warband spawns, we want to check if they have a compatible cache with any other warband
	(aka if their NPC squads would be identical)
	
	if so, both warbands share a single cache
*/
/atom/movable/screen/warband/manager/proc/has_compatible_cache(atom/movable/screen/warband/manager/other_manager)
	if(src.selected_warband.type != other_manager.selected_warband.type)
		return FALSE
	
	if(src.selected_subtype?.type != other_manager.selected_subtype?.type)
		return FALSE
	
	return TRUE // we'll assume they're compatible if they have the same warband and subtype

/atom/movable/screen/warband/manager/proc/share_cache_with(atom/movable/screen/warband/manager/source_manager)
	if(!source_manager)
		return FALSE
	
	var/atom/movable/screen/warband/manager/root_source = source_manager
	while(root_source.cache_source) 
		root_source = root_source.cache_source 
	
	src.cache_source = root_source
	root_source.cache_dependents += src
	return TRUE

/atom/movable/screen/warband/manager/proc/get_grunt_cache()
	if(src.cache_source)
		return src.cache_source.assigned_grunt_cache
	return src.assigned_grunt_cache
