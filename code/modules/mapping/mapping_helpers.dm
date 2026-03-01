//Landmarks and other helpers which speed up the mapping process and reduce the number of unique instances/subtypes of items/turf/ect



/obj/effect/baseturf_helper //Set the baseturfs of every turf in the /area/ it is placed.
	name = "baseturf editor"
	icon = 'icons/effects/mapping_helpers.dmi'
	icon_state = ""

	var/list/baseturf_to_replace
	var/baseturf

	layer = POINT_LAYER

/obj/effect/baseturf_helper/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/baseturf_helper/LateInitialize()
	if(!baseturf_to_replace)
		baseturf_to_replace = typecacheof(list(/turf/baseturf_bottom))
	else if(!length(baseturf_to_replace))
		baseturf_to_replace = list(baseturf_to_replace = TRUE)
	else if(baseturf_to_replace[baseturf_to_replace[1]] != TRUE) // It's not associative
		var/list/formatted = list()
		for(var/i in baseturf_to_replace)
			formatted[i] = TRUE
		baseturf_to_replace = formatted

	var/area/our_area = get_area(src)
	for(var/i in get_area_turfs(our_area, z))
		replace_baseturf(i)

	qdel(src)

/obj/effect/baseturf_helper/proc/replace_baseturf(turf/thing)
	if(length(thing.baseturfs))
		var/list/baseturf_cache = thing.baseturfs.Copy()
		for(var/i in baseturf_cache)
			if(baseturf_to_replace[i])
				baseturf_cache -= i
		thing.baseturfs = baseturfs_string_list(baseturf_cache, thing)
		if(!baseturf_cache.len)
			thing.assemble_baseturfs(baseturf)
		else
			thing.PlaceOnBottom(null, baseturf)
	else if(baseturf_to_replace[thing.baseturfs])
		thing.assemble_baseturfs(baseturf)
	else
		thing.PlaceOnBottom(null, baseturf)

/obj/effect/baseturf_helper/lava
	name = "lava baseturf editor"
	baseturf = /turf/open/lava/smooth

/obj/effect/baseturf_helper/lava_land/surface
	name = "lavaland baseturf editor"
	baseturf = /turf/open/lava/smooth/lava_land_surface


/obj/effect/mapping_helpers
	icon = 'icons/effects/mapping_helpers.dmi'
	icon_state = ""
	var/late = FALSE

/obj/effect/mapping_helpers/Initialize()
	..()
	return late ? INITIALIZE_HINT_LATELOAD : INITIALIZE_HINT_QDEL


//needs to do its thing before spawn_rivers() is called
INITIALIZE_IMMEDIATE(/obj/effect/mapping_helpers/no_lava)

/obj/effect/mapping_helpers/no_lava
	icon_state = "no_lava"

/obj/effect/mapping_helpers/no_lava/Initialize()
	. = ..()
	var/turf/T = get_turf(src)
	T.flags_1 |= NO_LAVA_GEN_1

//This helper applies components to things on the map directly.
/obj/effect/mapping_helpers/component_injector
	name = "Component Injector"
	late = TRUE
	var/target_type
	var/target_name
	var/component_type

//Late init so everything is likely ready and loaded (no warranty)
/obj/effect/mapping_helpers/component_injector/LateInitialize()
	if(!ispath(component_type,/datum/component))
		CRASH("Wrong component type in [type] - [component_type] is not a component")
	var/turf/T = get_turf(src)
	for(var/atom/A in T.GetAllContents())
		if(A == src)
			continue
		if(target_name && A.name != target_name)
			continue
		if(target_type && !istype(A,target_type))
			continue
		var/cargs = build_args()
		A._AddComponent(arglist(cargs))
		qdel(src)
		return

/obj/effect/mapping_helpers/component_injector/proc/build_args()
	return list(component_type)

/obj/effect/mapping_helpers/dead_body_placer
	name = "Dead Body placer"
	late = TRUE
	icon_state = "deadbodyplacer"
	var/bodycount = 2 //number of bodies to spawn

/obj/effect/mapping_helpers/dead_body_placer/LateInitialize()
	var/list/trays = list()
	if(!trays.len)
		log_mapping("[src] at [x],[y] could not find any morgues.")
		return
	for (var/i = 1 to bodycount)
		var/mob/living/carbon/human/h = new /mob/living/carbon/human(get_turf(src), 1)
		h.death()
		for (var/part in h.internal_organs) //randomly remove organs from each body, set those we keep to be in stasis
			if (prob(40))
				qdel(part)
			else
				var/obj/item/organ/O = part
				O.organ_flags |= ORGAN_FROZEN
	qdel(src)

//This is our map object, which just gets placed anywhere on the map. A .dm file is linked to it to set the templates list.
//If there's only one template in the list, it will only pick that (useful for editing parts of maps without editing the WHOLE map)
/obj/effect/landmark/map_load_mark
	name = "map loader landmark"
	var/list/templates //List of templates we're trying to pick from (must be a list, even if there's only one entry)

/obj/effect/landmark/map_load_mark/Initialize()
	. = ..()
	LAZYADD(SSmapping.map_load_marks,src)

/obj/effect/mapping_helpers/access
	name = "access helper parent"
	layer = DOOR_HELPER_LAYER
	late = TRUE

/obj/effect/mapping_helpers/access/LateInitialize()
	var/static/list/valid = list(
		/obj/structure/mineral_door, \
		/obj/structure/closet, \
		/obj/structure/roguemachine/vendor, \
	)

	// Get the first thing we find starting with doors and closets
	for(var/thing as anything in valid)
		var/obj/found = locate(thing) in loc
		if(found)
			payload(found)
			qdel(src)
			return

	log_mapping("[src] failed to find a target at [AREACOORD(src)]")
	qdel(src)

/obj/effect/mapping_helpers/access/proc/payload(obj/payload)
	return

/obj/effect/mapping_helpers/access/locker
	name = "access lock helper"
	icon_state = "door_locker"

/obj/effect/mapping_helpers/access/locker/payload(obj/payload)
	if(istype(payload, /obj/structure/mineral_door))
		var/obj/structure/mineral_door/door = payload
		door.lock_toggle()
	else if(istype(payload, /obj/structure/closet))
		var/obj/structure/closet/closet = payload
		closet.locked = TRUE
	else if(istype(payload, /obj/structure/roguemachine/vendor))
		var/obj/structure/roguemachine/vendor/vendor = payload
		vendor.locked = TRUE

/obj/effect/mapping_helpers/secret_door_creator
	name = "Secret door creator: Turns the given wall into a hidden door with a random password."
	icon = 'icons/effects/hidden_door.dmi'
	icon_state = "hidden_door"

	var/redstone_id

	var/obj/structure/mineral_door/secret/door_type = /obj/structure/mineral_door/secret
	var/override_floor = TRUE //Will only use the below as the floor tile if true. Source turf have at least 1 baseturf to use false
	var/turf/open/floor_turf = /turf/open/floor/rogue/blocks

/obj/effect/mapping_helpers/secret_door_creator/Initialize()
	if(!isclosedturf(get_turf(src)))
		return ..()
	var/turf/closed/source_turf = get_turf(src)
	var/obj/structure/mineral_door/secret/new_door = new door_type(source_turf)

	new_door.name = source_turf.name
	new_door.desc = source_turf.desc
	new_door.icon = source_turf.icon
	new_door.icon_state = source_turf.icon_state

	if(redstone_id)
		new_door.redstone_id = redstone_id
		GLOB.redstone_objs += new_door
		new_door.LateInitialize()

	if(override_floor || length(source_turf.baseturfs) < 1)
		source_turf.ChangeTurf(floor_turf)
	else
		source_turf.ChangeTurf(source_turf.baseturfs[1])

	. = ..()
