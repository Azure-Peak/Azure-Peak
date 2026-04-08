/*
A Star pathfinding algorithm
Returns a list of tiles forming a path from A to B, taking dense objects as well as walls, and the orientation of
windows along the route into account.
Use:
your_list = AStar(start location, end location, moving atom, distance proc, max nodes, maximum node depth, minimum distance to target, adjacent proc, atom id, turfs to exclude, check only simulated)

Optional extras to add on (in order):
Distance proc : the distance used in every A* calculation (length of path and heuristic)
MaxNodes: The maximum number of nodes the returned path can be (0 = infinite)
Maxnodedepth: The maximum number of nodes to search (default: 30, 0 = infinite)
Mintargetdist: Minimum distance to the target before path returns, could be used to get
near a target, but not right to it - for an AI mob with a gun, for example.
Adjacent proc : returns the turfs to consider around the actually processed node
Simulated only : whether to consider unsimulated turfs or not (used by some Adjacent proc)

Also added 'exclude' turf to avoid travelling over; defaults to null

*/
#define PF_TIEBREAKER 0.005
//tiebreker weight.To help to choose between equal paths
//////////////////////
//datum/PathNode object
//////////////////////


//A* nodes variables
/datum/PathNode
	var/turf/source //turf associated with the PathNode
	var/datum/PathNode/prevNode //link to the parent PathNode
	var/f		//A* Node weight (f = g + heuristic)
	var/g		//A* movement cost variable
	var/heuristic		//A* heuristic variable
	var/nodes_traversed //count the number of Nodes traversed
	var/bf		//bitflag for dir to expand.Some sufficiently advanced motherfuckery

/datum/PathNode/New(s,p,pg,ph,pnt,_bf)
	source = s
	setp(p, pg, ph, pnt)
	bf = _bf

/datum/PathNode/proc/setp(p,pg,ph,pnt)
	prevNode = p
	g = pg
	heuristic = ph
	calc_f()
	nodes_traversed = pnt

/datum/PathNode/proc/calc_f()
	f = g + heuristic*(1 + PF_TIEBREAKER)

//////////////////////
//A* procs
//////////////////////

//the weighting function, used in the A* algorithm
/proc/PathWeightCompare(datum/PathNode/a, datum/PathNode/b)
	return a.f - b.f

//reversed so that the Heap is a MinHeap rather than a MaxHeap
/proc/HeapPathWeightCompare(datum/PathNode/a, datum/PathNode/b)
	return b.f - a.f

//wrapper that returns an empty list if A* failed to find a path
/proc/get_path_to(caller, end, dist, maxnodes, maxnodedepth = 30, mintargetdist, adjacent = TYPE_PROC_REF(/turf, reachableTurftest), id=null, turf/exclude=null, allow_multiz = TRUE)
	var/l = SSpathfinder.mobs.getfree(caller)
	while(!l)
		stoplag(3)
		l = SSpathfinder.mobs.getfree(caller)
	var/list/path = AStar(caller, end, dist, maxnodes, maxnodedepth, mintargetdist, adjacent,id, exclude)

	SSpathfinder.mobs.found(l)
	if(!path)
		path = list()
	return path

/proc/cir_get_path_to(caller, end, dist, maxnodes, maxnodedepth = 30, mintargetdist, adjacent = TYPE_PROC_REF(/turf, reachableTurftest), id=null, turf/exclude=null, allow_multiz = TRUE)
	var/l = SSpathfinder.circuits.getfree(caller)
	while(!l)
		stoplag(3)
		l = SSpathfinder.circuits.getfree(caller)
	var/list/path = AStar(caller, end, dist, maxnodes, maxnodedepth, mintargetdist, adjacent, id, exclude, allow_multiz)
	SSpathfinder.circuits.found(l)
	if(!path)
		path = list()
	return path

/proc/AStar(caller, _end, dist, maxnodes, maxnodedepth = 30, mintargetdist, adjacent = TYPE_PROC_REF(/turf, reachableTurftest), id=null, turf/exclude=null, allow_multiz = TRUE)
	//sanitation
	var/turf/end = get_turf(_end)
	var/turf/start = get_turf(caller)
	if(!start || !end)
		stack_trace("Invalid A* start or destination")
		return FALSE
	if(start == end) // pointless!
		return FALSE
	if(!allow_multiz && start.z != end.z) //no pathfinding between z levels with multiz off
		return FALSE
	if(maxnodes)
		//if start turf is farther than maxnodes from end turf, no need to do anything
		if(call(start, dist)(end, caller) > maxnodes)
			return FALSE
		maxnodedepth = maxnodes //no need to consider path longer than maxnodes
	var/datum/Heap/open = new /datum/Heap(/proc/HeapPathWeightCompare) //the open list
	var/list/openc = new() //open list for node check
	var/list/path = null //the returned path, if any
	//initialization
	var/const/ALL_DIRS = NORTH|SOUTH|EAST|WEST
	var/datum/PathNode/cur = new /datum/PathNode(start,null,0,call(start,dist)(end, caller),0,ALL_DIRS,1)//current processed turf
	open.Insert(cur)
	openc[start] = cur
	//then run the main loop
	while(caller && !open.IsEmpty() && !path)
		cur = open.Pop() //get the lower f turf in the open list
		//get the lower f node on the open list
		//if we only want to get near the target, check if we're close enough
		var/closeenough
		if(mintargetdist) // we let you stop early if you aren't on the same z-level because that enables fun shenanigans like taunting and climbing
			// I lied, this one is also hardcoded; we don't want to use the heuristic for our termination condition,
			// only the actual distance.
			closeenough = cur.source.Distance_cardinal_3d(end, caller) <= mintargetdist



		//found the target turf (or close enough), let's create the path to it
		if(cur.source == end || closeenough)
			path = list(cur.source)
			while(cur.prevNode)
				cur = cur.prevNode
				path.Add(cur.source)
			break
		if(maxnodedepth && (cur.nodes_traversed > maxnodedepth)) //if too many steps, don't process that path
			cur.bf = 0
			CHECK_TICK
			continue
		//get adjacents turfs using the adjacent proc, checking for access with id
		for(var/dir_to_check in GLOB.cardinals)
			if(!(cur.bf & dir_to_check)) // we can't proceed in this direction
				continue
			// get the turf we end up at if we move in dir_to_check; this may have special handling for multiz moves
			var/T = get_step(cur.source, dir_to_check)
			// when leaving a turf with stairs on it, we can change Z, so take that into account
			// this handles both upwards and downwards moves depending on the dir
			var/obj/structure/stairs/source_stairs = locate(/obj/structure/stairs) in cur.source
			if(source_stairs)
				T = source_stairs.get_transit_destination(dir_to_check)
			if(T != exclude)
				var/datum/PathNode/CN = openc[T]  //current checking turf
				var/reverse = GLOB.reverse_dir[dir_to_check]
				var/newg = cur.g + call(cur.source,dist)(T, caller) // add the travel distance between these two tiles to the distance so far
				if(CN)
				//is already in open list, check if it's a better way from the current turf
					CN.bf &= ALL_DIRS^reverse //we have no closed, so just cut off exceed dir.00001111 ^ reverse_dir.We don't need to expand to checked turf.
					if((newg < CN.g))
						if(call(cur.source,adjacent)(caller, T, id))
							CN.setp(cur,newg,CN.heuristic,cur.nodes_traversed+1)
							open.ReSort(CN)//reorder the changed element in the list
				else
				//is not already in open list, so add it
					if(call(cur.source,adjacent)(caller, T, id)) 
						CN = new(T,cur,newg,call(T,dist)(end, caller),cur.nodes_traversed+1, ALL_DIRS^reverse)
						open.Insert(CN)
						openc[T] = CN
		cur.bf = 0
		CHECK_TICK
	//reverse the path to get it from start to finish
	if(path)
		for(var/i = 1 to round(0.5*path.len))
			path.Swap(i,path.len-i+1)
	openc = null
	//cleaning after us
	return path

/// returns TRUE if there exists a way for caller to (safely) move from src to T. non-z-aware
/turf/proc/reachableTurftest(caller, turf/T, ID)
	if(T && !T.density && T.can_traverse_safely(caller) && !LinkBlockedWithAccess(T,caller, ID))
		return TRUE

/// returns TRUE if there exists a way for caller to (safely) move from src to T. z-aware
/turf/proc/reachableTurftest3d(caller, turf/T, ID, recursive_call = 0)
	if(!T || T.density)
		return FALSE
	if(!T.can_traverse_safely(caller)) // dangerous turf! lava or openspace (or others in the future)
		return FALSE
	var/z_distance = abs(T.z - z)
	if(!z_distance) // standard check for same-z pathing
		return !LinkBlockedWithAccess(T, caller, ID)
	if(z_distance != 1) // no single movement lets you move more than one z-level at a time (currently; update if this changes)
		return FALSE
	var/obj/structure/stairs/source_stairs = locate(/obj/structure/stairs) in src
	var/mob/mob_caller = caller
	if(ismob(caller) && HAS_TRAIT(mob_caller, TRAIT_ZJUMP)) // where we're going, we don't need stairs!
		return TRUE
	if(T.z < z) // going down
		if(source_stairs?.get_target_loc(GLOB.reverse_dir[source_stairs.dir]) == T)
			return TRUE
	else // heading DOWN stairs was handled earlier, so now handle going UP stairs
		if(source_stairs?.get_target_loc(source_stairs.dir) == T)
			return TRUE
	return FALSE

/turf/proc/LinkBlockedWithAccess(turf/T, caller, ID)
	var/adir = get_dir(src, T)
	var/rdir = GLOB.reverse_dir[adir]
	for(var/obj/O in T)
		if(!O.CanAStarPass(ID, rdir, caller))
			return TRUE
	for(var/obj/O in src)
		if(!O.CanAStarPass(ID, adir, caller))
			return TRUE
	for(var/mob/living/M in T)
		if(!M.CanPass(caller, src))
			return TRUE
	return FALSE

/proc/get_dist_3d(atom/source, atom/target)
	var/turf/source_turf = get_turf(source)
	return source_turf.Distance3D(get_turf(target))

// Add a helper function to compute 3D Manhattan distance
/turf/proc/Distance3D(turf/T)
	if (!T || !istype(T))
		return 0
	var/dx = abs(x - T.x)
	var/dy = abs(y - T.y)
	var/dz = abs(z - T.z) * 5 // Weight z-level differences higher
	return (dx + dy + dz)
