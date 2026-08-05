#define PROGRESSBAR_HEIGHT 6
#define PROGRESSBAR_ANIMATION_TIME 5

/datum/progressbar
	var/goal = 1
	var/last_progress = 0
	var/last_percent = 0
	var/image/bar
	var/shown = 0
	var/mob/user
	var/listindex
	/// our current cell grid
	var/datum/cell_tracker/our_cells

/datum/progressbar/New(mob/User, goal_number, atom/target)
	. = ..()
	if (!istype(target))
		EXCEPTION("Invalid target given")
	if (goal_number)
		goal = goal_number
	bar = image('icons/effects/progessbar.dmi', target, "prog_bar_0", HUD_LAYER)
	bar.plane = ABOVE_HUD_PLANE
	bar.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	user = User
	our_cells = new(world.view, world.view, 1)
	set_new_cells()
	// late log-ins or walking into the range afterwards are handled by the cell tracker
	for(var/mob/M in our_cells.get_type_members(SPATIAL_GRID_CONTENTS_TYPE_CLIENTS))
		if(M.client)
			M.client.images |= bar
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(set_new_cells))

	LAZYINITLIST(user.progressbars)
	LAZYINITLIST(user.progressbars[bar.loc])
	var/list/bars = user.progressbars[bar.loc]
	bars.Add(src)
	listindex = bars.len
	bar.pixel_y = 0
	bar.alpha = 0
	animate(bar, pixel_y = 32 + (PROGRESSBAR_HEIGHT * (listindex - 1)), alpha = 255, time = PROGRESSBAR_ANIMATION_TIME, easing = SINE_EASING)

/datum/progressbar/proc/update(progress)
	progress = CLAMP(progress, 0, goal)
	last_progress = progress
	var/percent = round(((progress / goal) * 100), 5)
	if(percent != last_percent)
		last_percent = percent
		bar.icon_state = "prog_bar_[percent]"
	if (!shown)
		shown = TRUE

/datum/progressbar/proc/shiftDown()
	--listindex
	bar.pixel_y = 32 + (PROGRESSBAR_HEIGHT * (listindex - 1))
	var/dist_to_travel = 32 + (PROGRESSBAR_HEIGHT * (listindex - 1)) - PROGRESSBAR_HEIGHT
	animate(bar, pixel_y = dist_to_travel, time = PROGRESSBAR_ANIMATION_TIME, easing = SINE_EASING)

/datum/progressbar/Destroy()
	if(last_progress != goal)
		bar.icon_state = "[bar.icon_state]_fail"
	for(var/I in user.progressbars[bar.loc])
		var/datum/progressbar/P = I
		if(P != src && P.listindex > listindex)
			P.shiftDown()

	var/list/bars = user.progressbars[bar.loc]
	bars.Remove(src)
	if(!bars.len)
		LAZYREMOVE(user.progressbars, bar.loc)

	animate(bar, alpha = 0, time = PROGRESSBAR_ANIMATION_TIME)
	addtimer(CALLBACK(src, PROC_REF(remove_from_clients)), PROGRESSBAR_ANIMATION_TIME, TIMER_CLIENT_TIME)
	// this may not be necessary but i'm not sure
	var/list/cell_collection = our_cells.member_cells
	for(var/datum/grid as anything in cell_collection)
		UnregisterSignal(grid, SPATIAL_GRID_CELL_ENTERED(SPATIAL_GRID_CONTENTS_TYPE_CLIENTS))
	our_cells = null
	return ..()

/datum/progressbar/proc/set_new_cells()
	SIGNAL_HANDLER
	var/turf/our_turf = get_turf(bar.loc)
	if(isnull(our_turf))
		return

	var/list/cell_collections = our_cells.recalculate_cells(our_turf)

	for(var/datum/old_grid as anything in cell_collections[2])
		UnregisterSignal(old_grid, SPATIAL_GRID_CELL_ENTERED(SPATIAL_GRID_CONTENTS_TYPE_CLIENTS))

	for(var/datum/spatial_grid_cell/new_grid as anything in cell_collections[1])
		RegisterSignal(new_grid, SPATIAL_GRID_CELL_ENTERED(SPATIAL_GRID_CONTENTS_TYPE_CLIENTS), PROC_REF(on_client_enter))

// we never remove these when clients exit, they all get cleaned up when the mob leaves
/datum/progressbar/proc/on_client_enter(datum/source, mob/client_holder)
	SIGNAL_HANDLER
	if(!istype(client_holder) || !client_holder.client)
		return
	client_holder.client.images |= bar

/datum/progressbar/proc/remove_from_clients()
	for(var/client/C in GLOB.clients) // this is genuinely faster than tracking clients we've sent it to
		C.images -= bar
	if(bar?.loc)
		UnregisterSignal(bar.loc, COMSIG_MOVABLE_MOVED, PROC_REF(set_new_cells))
	bar = null

#undef PROGRESSBAR_ANIMATION_TIME
#undef PROGRESSBAR_HEIGHT
