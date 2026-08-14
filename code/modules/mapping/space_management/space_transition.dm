/datum/space_level/proc/set_linkage(new_linkage)
	linkage = new_linkage
	if(linkage == SELFLOOPING)
		neigbours = list(TEXT_NORTH,TEXT_SOUTH,TEXT_EAST,TEXT_WEST)
		for(var/A in neigbours)
			neigbours[A] = src

/datum/space_level/proc/set_neigbours(list/L)
	for(var/datum/space_transition_point/P in L)
		if(P.x == xi)
			if(P.y == yi+1)
				neigbours[TEXT_NORTH] = P.spl
				P.spl.neigbours[TEXT_SOUTH] = src
			else if(P.y == yi-1)
				neigbours[TEXT_SOUTH] = P.spl
				P.spl.neigbours[TEXT_NORTH] = src
		else if(P.y == yi)
			if(P.x == xi+1)
				neigbours[TEXT_EAST] = P.spl
				P.spl.neigbours[TEXT_WEST] = src
			else if(P.x == xi-1)
				neigbours[TEXT_WEST] = P.spl
				P.spl.neigbours[TEXT_EAST] = src

/datum/space_transition_point			//this is explicitly utilitarian datum type made specially for the space map generation and are absolutely unusable for anything else
	var/list/neigbours = list()
	var/x
	var/y
	var/datum/space_level/spl

/datum/space_transition_point/New(nx, ny, list/point_grid)
	if(!point_grid)
		qdel(src)
		return
	var/list/L = point_grid[1]
	if(nx > point_grid.len || ny > L.len)
		qdel(src)
		return
	x = nx
	y = ny
	if(point_grid[x][y])
		return
	point_grid[x][y] = src

/datum/space_transition_point/proc/set_neigbours(list/grid)
	var/max_X = grid.len
	var/list/max_Y = grid[1]
	max_Y = max_Y.len
	neigbours.Cut()
	if(x+1 <= max_X)
		neigbours |= grid[x+1][y]
	if(x-1 >= 1)
		neigbours |= grid[x-1][y]
	if(y+1 <= max_Y)
		neigbours |= grid[x][y+1]
	if(y-1 >= 1)
		neigbours |= grid[x][y-1]
