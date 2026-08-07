#define TRIUMPH_LEADERBOARD_FILE "data/triumph_leaderboards/triumphs_leaderboard.json"

SUBSYSTEM_DEF(triumphs)
	name = "Triumphs"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_TRIUMPHS

	// List of top ten for display in browser page on button click
	var/list/triumph_leaderboard = list()
	var/triumph_leaderboard_positions_tracked = 21

	// A cache for triumphs
	// Basically when client first hops in for the session we will cram their ckey in and retrieve from file
	// When the server session is about to end we will write it all in.
	var/list/triumph_amount_cache = list()

/*
	TRIUMPH BUY MENU THINGS
*/
	// Whether triumph buys are enabled
	var/triumph_buys_enabled = FALSE
	//init list to hold triumph buy menus for the session (aka menu data)
	// Assc list "ckey" = datum
	var/list/active_triumph_menus = list()

	// display limit per page in a category on the user menu
	var/page_display_limit = 12

	// This represents the triumph buy organization on the main SS for triumphs
	// Each key is a category name
	// And then the list will have a number in a string that leads to a list of datums
	var/list/list/list/central_state_data = list(
		TRIUMPH_CAT_ROUND_EFX = 0,
		TRIUMPH_CAT_CHARACTER = 0,
		TRIUMPH_CAT_MISC = 0,
		TRIUMPH_CAT_ACTIVE_DATUMS = 0
	)
	var/list/legacy_triumphs = null


/*
	TRIUMPH BUY DATUM THINGS
*/

	var/current_refund_percentage = 0.50 // Current refund percentage is 50%
	//this is basically the total list of triumph buy datums on init
	var/list/triumph_buy_datums = list()

	// This is a list of all active datums
	var/list/active_triumph_buy_queue = list()

	// These get on_activate() called in /datum/outfit/job/roguetown/post_equip() in roguetown.dm
	var/list/post_equip_calls = list()

/datum/controller/subsystem/triumphs/Initialize()
	. = ..()

	prep_the_triumphs_leaderboard()


	for(var/cur_path in subtypesof(/datum/triumph_buy))
		var/datum/triumph_buy/cur_datum = new cur_path // We will do this
		triumph_buy_datums += cur_datum
		central_state_data[cur_datum.category] += 1 // Tally up the totals here to save on a total of one loop

	// Make a local copy I guess?
	var/list/copy_list = triumph_buy_datums.Copy()

	//Figure out how many lists we are about to make to represent the pages
	for(var/catty_key in central_state_data)
		var/page_count = ceil(central_state_data[catty_key]/page_display_limit) // Get the page count total
		central_state_data[catty_key] = list() // Now we swap the numbers out for lists on each cat as it will contain lists representing one page

		// Now fill in the lists starting at index "1"
		for(var/page_numba in 1 to page_count)
			central_state_data[catty_key]["[page_numba]"] = list()
			for(var/ii = copy_list.len, ii > 0, ii--)
				var/datum/triumph_buy/current_triumph_buy_datum = copy_list[ii]
				if(current_triumph_buy_datum.category == catty_key)
					central_state_data[catty_key]["[page_numba]"] += current_triumph_buy_datum
					copy_list -= current_triumph_buy_datum
				if(central_state_data[catty_key]["[page_numba]"].len == page_display_limit)
					break

/*
	This occurs when you try to buy a triumph condition and sets it up
*/
/datum/controller/subsystem/triumphs/proc/attempt_to_buy_triumph_condition(client/C, datum/triumph_buy/ref_datum)
	// This segments the payment part
	var/triumph_amount = get_triumphs(C.ckey) - ref_datum.triumph_cost
	if(triumph_amount >= 0)
		triumph_adjust(ref_datum.triumph_cost*-1, C.ckey, "triumph buy: [ref_datum.type]")

		var/datum/triumph_buy/stick_it_in = new ref_datum.type

		stick_it_in.key_of_buyer = C.key
		stick_it_in.ckey_of_buyer = C.ckey
		active_triumph_buy_queue += stick_it_in

		// The thing someone is buying conflicts with things
		if(stick_it_in.conflicts_with.len)
			for(var/cur_check_path in stick_it_in.conflicts_with) // Time to refund anything already bought it personally hates
				for(var/datum/triumph_buy/active_datum in active_triumph_buy_queue)
					if(ispath(cur_check_path, active_datum.type))
						// Give the person who originally bought it a 50% refund
						var/ckey_cur_owna = active_datum.ckey_of_buyer
						var/refund_amount = round(active_datum.triumph_cost * current_refund_percentage)
						triumph_adjust(refund_amount, ckey_cur_owna, "conflict refund: [active_datum.type]")

						if(GLOB.directory[ckey_cur_owna]) // If they are still logged into the game, inform them they got refunded
							to_chat(GLOB.directory[ckey_cur_owna], span_redtext("You were refunded [refund_amount] triumphs due to CONFLICTS."))

						// Cleanup Time
						active_datum.on_removal()
						active_triumph_buy_queue -= active_datum


		stick_it_in.on_buy()
		call_menu_refresh()
/*
	This occurs when you try to unbuy a triumph condition and removes it
*/
/datum/controller/subsystem/triumphs/proc/attempt_to_unbuy_triumph_condition(client/C, datum/triumph_buy/pull_it_out)
	var/triumph_amount = get_triumphs(C.ckey) - pull_it_out.triumph_cost
	if(triumph_amount >= 0)
		triumph_adjust(pull_it_out.triumph_cost*-1, C.ckey, "triumph unbuy: [pull_it_out.type]")

		// Give the person who originally bought it a 50% refund
		var/ckey_prev_owna = pull_it_out.ckey_of_buyer
		var/refund_amount = round(pull_it_out.triumph_cost * current_refund_percentage)
		triumph_adjust(refund_amount, ckey_prev_owna, "unbuy refund: [pull_it_out.type]")

		if(GLOB.directory[ckey_prev_owna]) // If they are still logged into the game, inform them they got refunded
			to_chat(GLOB.directory[ckey_prev_owna], span_redtext("You were refunded [refund_amount] triumphs due to a UNBUY."))

		pull_it_out.on_removal()

		active_triumph_buy_queue -= pull_it_out

// Same deal as the role class stuff, we are only really just caching this to update displays as people buy stuff.
// So we have to be careful to not leave it in when unneeded otherwise we will have to keep track of which menus are actually open.
/datum/controller/subsystem/triumphs/proc/startup_triumphs_menu(client/C)
	if(!triumph_buys_enabled)
		return
	if(C)
		var/datum/triumph_buy_menu/check_this = active_triumph_menus[C.ckey]
		if(check_this)
			check_this.linked_client = C
			check_this.triumph_menu_startup_slop()
		else
			var/datum/triumph_buy_menu/BIGBOY = new()
			BIGBOY.linked_client = C
			active_triumph_menus[C.ckey] = BIGBOY
			BIGBOY.triumph_menu_startup_slop()

/*
	This tells all alive triumph datums to re_update their visuals, shitty but ya
*/
/datum/controller/subsystem/triumphs/proc/call_menu_refresh()
	for(var/MENS in active_triumph_menus)
		var/datum/triumph_buy_menu/current_view = active_triumph_menus[MENS]
		if(!current_view) // Insure we actually have something yes?
			active_triumph_menus.Remove(MENS)
			continue

		if(!current_view.linked_client) // We have something and it has no client
			active_triumph_menus.Remove(MENS)
			qdel(current_view)
			continue

		current_view.show_menu()


// We cleanup the datum thats just holding the stuff for displaying the menu.
/datum/controller/subsystem/triumphs/proc/remove_triumph_buy_menu(client/C)
	if(C && active_triumph_menus[C.ckey])
		var/datum/triumph_buy_menu/me_local = active_triumph_menus[C.ckey]
		C << browse(null, "window=triumph_buy_window")
		active_triumph_menus.Remove(C.ckey)
		qdel(me_local)

// Called from the place its slopped in in SSticker, this will occur right after the gamemode starts ideally, aka roundstart.
/datum/controller/subsystem/triumphs/proc/fire_on_PostSetup()
	call_menu_refresh()

/datum/controller/subsystem/triumphs/proc/end_triumph_saving_time()
	to_chat(world, span_boldannounce(" Recording VICTORIES to the WORLD END MACHINE. "))
	var/encoded = json_encode(triumph_leaderboard)
	if(!length(encoded))
		return
	rustg_file_write(encoded, TRIUMPH_LEADERBOARD_FILE)



/datum/controller/subsystem/triumphs/proc/triumph_save_dir(target_ckey)
	return "data/player_saves/[copytext(target_ckey, 1, 2)]/[target_ckey]/"

/datum/controller/subsystem/triumphs/proc/read_triumph_file(path)
	if(!fexists(path))
		return null
	var/raw = trim(file2text(path))
	if(!length(raw))
		return null
	var/list/decoded
	try
		decoded = json_decode(raw)
	catch
		return null
	if(!islist(decoded) || !isnum(decoded["triumph_count"]))
		return null
	return decoded

/datum/controller/subsystem/triumphs/proc/save_triumphs(target_ckey, amount)
	if(!target_ckey || !isnum(amount))
		return FALSE
	var/encoded = json_encode(list("triumph_count" = amount))
	if(!length(encoded))
		return FALSE
	var/dir = triumph_save_dir(target_ckey)
	var/target_file = "[dir]triumphs.json"
	if(read_triumph_file(target_file))
		var/backup_file = "[dir]triumphs.bak.json"
		fdel(backup_file)
		fcopy(target_file, backup_file)
	rustg_file_write(encoded, target_file)
	return TRUE

/datum/controller/subsystem/triumphs/proc/triumph_adjust(amt, target_ckey)
	if(!target_ckey || !amt)
		return
	if(!(target_ckey in triumph_amount_cache))
		get_triumphs(target_ckey)
	if(!(target_ckey in triumph_amount_cache))
		return
	triumph_amount_cache[target_ckey] += amt
	save_triumphs(target_ckey, triumph_amount_cache[target_ckey])

/// Gets the legacy triumph value to inherit the old triumphs, assuming legacy data was converted to ckeys
/datum/controller/subsystem/triumphs/proc/get_legacy_triumph_value(target_ckey)
	if(legacy_triumphs == null)
		legacy_triumphs = list()
		var/legacy_path = "data/triumphs.json"
		if(fexists(legacy_path))
			var/raw = trim(file2text(legacy_path))
			var/list/json
			if(length(raw))
				try
					json = json_decode(raw)
				catch
					json = null
			for(var/player_key in json)
				legacy_triumphs[ckey(player_key)] = json[player_key]
	if(isnum(legacy_triumphs[target_ckey]))
		return legacy_triumphs[target_ckey]
	return 0

/datum/controller/subsystem/triumphs/proc/get_triumphs(target_ckey)
	if(!target_ckey)
		return 0
	if(target_ckey in triumph_amount_cache)
		return triumph_amount_cache[target_ckey]

	var/dir = triumph_save_dir(target_ckey)
	var/target_file = "[dir]triumphs.json"
	var/had_file = fexists(target_file)

	var/list/stored = read_triumph_file(target_file)
	var/recovered = FALSE
	if(!stored)
		for(var/fallback in list("[dir]triumphs.bak.json", "[dir]triumphs.backup.json"))
			stored = read_triumph_file(fallback)
			if(stored)
				recovered = TRUE
				log_admin("TRIUMPHS: recovered [target_ckey] from [fallback] ([stored["triumph_count"]]).")
				break

	var/triumph_amount
	if(stored)
		triumph_amount = stored["triumph_count"]
	else
		triumph_amount = get_legacy_triumph_value(target_ckey)
		if(had_file)
			recovered = TRUE
			log_admin("TRIUMPHS: [target_ckey] had an unreadable file, rebuilt at [triumph_amount].")

	triumph_amount_cache[target_ckey] = triumph_amount
	if(recovered || !had_file)
		save_triumphs(target_ckey, triumph_amount)
	return triumph_amount


/*
	TRIUMPH LEADERBOARD STUFF
*/
// Display leaderboard browser popup
/datum/controller/subsystem/triumphs/proc/show_triumph_leaderboard(client/C)

	var/webpagu = "<B>CHAMPIONS OF AZURE</B><br>"
	webpagu += "<hr><br>"

	if(triumph_leaderboard.len)
		var/position_number = 0
		for(var/key in triumph_leaderboard)
			position_number++
			webpagu += "[position_number]. [key] - [triumph_leaderboard[key]]<br>"
			if(position_number >= triumph_leaderboard_positions_tracked)
				break
	else
		webpagu += "The hall of triumphs is quite empty, Yes?"

	C << browse(webpagu, "window=triumph_leaderboard;size=300x500")

// PREP THE BOARD
/datum/controller/subsystem/triumphs/proc/prep_the_triumphs_leaderboard()
	var/board_path = TRIUMPH_LEADERBOARD_FILE
	if(!fexists(board_path))
		board_path = find_legacy_leaderboard()
	if(!board_path)
		return

	var/raw = trim(file2text(board_path))
	if(!length(raw))
		return
	var/list/decoded
	try
		decoded = json_decode(raw)
	catch
		return
	if(!islist(decoded))
		return

	triumph_leaderboard = decoded
	sort_leaderboard()

/datum/controller/subsystem/triumphs/proc/find_legacy_leaderboard()
	var/regex/season_board = regex("^triumphs_leaderboard_season_(\\d+)\\.json$")
	var/best_path
	var/best_season = 0
	for(var/entry in flist("data/triumph_leaderboards/"))
		if(!season_board.Find(entry))
			continue
		var/season = text2num(season_board.group[1])
		if(season > best_season)
			best_season = season
			best_path = "data/triumph_leaderboards/[entry]"
	return best_path

// Adjust leaderboard
// I want a key here so it looks pretty
/datum/controller/subsystem/triumphs/proc/adjust_leaderboard(CLIENT_KEY_not_CKEY)
	var/user_key = CLIENT_KEY_not_CKEY
	var/triumph_total = triumph_amount_cache[ckey(CLIENT_KEY_not_CKEY)]

	if(5 > triumph_total) // You aren't tracked at all unless you got at least 5, no iterating a bunch of losers repeatedly
		return

	// You automatically get added in if we haven't filled in all the crap
	if(triumph_leaderboard_positions_tracked > triumph_leaderboard.len)
		triumph_leaderboard[user_key] = triumph_total

	else
		// Guy in last place is still greater than this guy
		if(triumph_leaderboard[triumph_leaderboard[triumph_leaderboard.len]] > triumph_total)
			return

		triumph_leaderboard.Cut(triumph_leaderboard.len) // Cut the end
		triumph_leaderboard[user_key] = triumph_total // Add our guy to the end

	sort_leaderboard() // Now sort it, sort it NOW!

// Sort what we got
/datum/controller/subsystem/triumphs/proc/sort_leaderboard()
	if(triumph_leaderboard.len > 1) // If we got more than one guy in here time to sort lol
		var/list/sorted_list = list()
		for(var/cache_key in triumph_leaderboard)
			if(!sorted_list.len)
				sorted_list[cache_key] = triumph_leaderboard[cache_key]

			for(var/sorted_key in sorted_list)
				if(sorted_list[sorted_key] < triumph_leaderboard[cache_key])
					sorted_list.Insert(sorted_list.Find(sorted_key), cache_key)
					sorted_list[cache_key] = triumph_leaderboard[cache_key]
					break

			if(sorted_list.Find(cache_key))
				continue

		triumph_leaderboard = sorted_list

#undef TRIUMPH_LEADERBOARD_FILE
