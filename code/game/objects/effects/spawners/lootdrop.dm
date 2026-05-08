/obj/effect/spawner/lootdrop
	icon = 'icons/roguetown/helpers/spawnerhelpers.dmi'
	icon_state = "cot"
	layer = OBJ_LAYER
	/// How many items will be spawned
	var/lootcount = 1
	/// If the same item can be spawned twice
	var/lootdoubles = TRUE
	/// Weighted list of actual loot to spawn e.g. list(/obj/item/rogueweapon/sword = 3, /obj/item/rogueweapon/mace = 5)
	var/list/loot
	/// Weighted list of junk to spawn when this spawner loses the budget lottery. Each spawner defines its own contextual junk.
	var/list/junk_loot
	/// Whether the items should be distributed to offsets 0,1,-1,2,-2,3,-3.. This overrides pixel_x/y on the spawner itself
	var/fan_out_items = TRUE
	var/probby = 100
	var/list/spawned
	/// Expected mammon value of what this spawner rolls. Used by the loot pool budget system.
	var/loot_value = 5

/obj/effect/spawner/lootdrop/Initialize(mapload)
	..()
	// Spawners inside containers (e.g. loot chests) fire immediately - they can't participate in area pools
	if(!isturf(loc))
		spawn_loot()
		return INITIALIZE_HINT_QDEL
	// Spawners created after map init (e.g. from butchering) resolve immediately - loot pools have already processed
	if(!mapload)
		spawn_loot()
		return INITIALIZE_HINT_QDEL
	GLOB.loot_spawners_pending += src
	return INITIALIZE_HINT_LATELOAD

/obj/effect/spawner/lootdrop/LateInitialize()
	return

/// Spawns items from the loot table at this spawner's location
/obj/effect/spawner/lootdrop/proc/spawn_loot()
	if(!loot || !loot.len)
		return
	var/turf/T = loc
	var/loot_spawned = 0
	while((lootcount-loot_spawned) && loot.len)
		var/lootspawn = pickweight(loot)
		while(islist(lootspawn))
			lootspawn = pickweight(lootspawn)
		if(!lootdoubles)
			loot.Remove(lootspawn)

		if(lootspawn)
			var/atom/movable/spawned_loot = new lootspawn(T)
			if (!fan_out_items)
				if (pixel_x != 0)
					spawned_loot.pixel_x = pixel_x
				if (pixel_y != 0)
					spawned_loot.pixel_y = pixel_y
			else
				if (loot_spawned)
					spawned_loot.pixel_x = spawned_loot.pixel_y = ((!(loot_spawned%2)*loot_spawned/2)*-1)+((loot_spawned%2)*(loot_spawned+1)/2*1)
		loot_spawned++
	do_spawn()

/// Called by the pool when this spawner loses the budget lottery - spawns junk from its own junk_loot list
/obj/effect/spawner/lootdrop/proc/spawn_junk()
	if(!junk_loot || !length(junk_loot))
		return
	var/turf/T = loc
	if(T)
		var/junk_type = pickweight(junk_loot)
		new junk_type(T)

/obj/effect/spawner/lootdrop/proc/do_spawn()
	if(prob(probby))
		if(!spawned)
			return
		var/obj/new_type = pick(spawned)
		new new_type(get_turf(src))
