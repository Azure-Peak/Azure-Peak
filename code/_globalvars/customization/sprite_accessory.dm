GLOBAL_LIST_INIT(sprite_accessories, build_sprite_accessory_list())

/proc/build_sprite_accessory_list()
	// Here we build the global list for all accessories
	var/list/accessory_list = list()
	for(var/path in typesof(/datum/sprite_accessory))
		if(is_abstract(path))
			continue
		accessory_list[path] = new path()
	return accessory_list
