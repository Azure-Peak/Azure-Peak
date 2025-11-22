/*
	A fun fact is that it is important to note triumph procs all used key, whilas player quality likes to use ckey
	It doesn't help that the params to insert a json key in both are just key to go with byond clients having a ckey and key

	As to how it currently saves, loads, and decides what decides to get wiped. Here is the following information:

	When client joins -
		We get their triumphs from their saved file
		If the version number is below the current wipe season we put them back to 0
		It is then cached into a global list attached to their ckey

	Was running into issues saving this all at server reboot
	Thusly triumphs all jus save into individual files everytime its ran into
	triumph_adjust()

	Simple enough
*/

// To note any triumph files that try to be loaded in at a lower number than current wipe season get wiped.
// Also we have to handle this here cause the triumphs ss might get loaded too late to handle clients joining fast enough
GLOBAL_VAR_INIT(triumph_wipe_season, get_triumph_wipe_season())
/proc/get_triumph_wipe_season()
	var/current_wipe_season
	var/json_file = file("data/triumph_wipe_season.json")
	if(!fexists(json_file))
		var/list/uhh_ohhh = list("current_wipe_season" = 1)
		current_wipe_season = 1
		WRITE_FILE(json_file, json_encode(uhh_ohhh))
		return current_wipe_season

	var/list/json = json_decode(file2text(json_file))
	current_wipe_season = json["current_wipe_season"]

	return current_wipe_season

// I need some shit early v early, so uhhh enjoy having lists on the define
SUBSYSTEM_DEF(triumphs)
	name = "Triumphs"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_TRIUMPHS

	/// List of top ten for display in browser page on button click
	var/list/triumph_leaderboard = list()
	var/triumph_leaderboard_positions_tracked = 20
	// A cache for triumphs. Basically when client first hops in for the session we will cram their ckey in and retrieve from file
	// When the server session is about to end we will write it all in.
	var/list/triumph_amount_cache = list()
	/// Similiar to the triumph amount cache, but stores triumph buys the ckey has bought
	var/list/triumph_buy_owners = list()

/*
	TRIUMPH BUY MENU THINGS
*/
	// Whether triumph buys are enabled
	var/triumph_buys_enabled = TRUE
	//init list to hold triumph buy menus for the session (aka menu data)
	// Assc list "ckey" = datum
	var/list/active_triumph_menus = list()

	// display limit per page in a category on the user menu
	var/page_display_limit = 14

	// This represents the triumph buy organization on the main SS for triumphs
	// Each key is a category name
	// And then the list will have a number in a string that leads to a list of datums
	var/list/list/list/central_state_data = list(
		TRIUMPH_CAT_CHARACTER = 0,
		TRIUMPH_CAT_STORYTELLER = 0,
		TRIUMPH_CAT_MISC = 0,
		TRIUMPH_CAT_COMMUNAL = 0,
		TRIUMPH_CAT_ACTIVE_DATUMS = 0,
	)
	var/list/legacy_triumphs = null


/*
	TRIUMPH BUY DATUM THINGS
*/

	//this is basically the total list of triumph buy datums on init
	var/list/triumph_buy_datums = list()
	// This is a list of all active datums
	var/list/active_triumph_buy_queue = list()
	/// This tracks the remaining stock for limited triumph buys
	var/list/triumph_buy_stocks = list()
	/// Tracks contributions to communal triumph buys - format: list(type = list(ckey = amount))
	var/list/communal_contributions = list()
	/// Tracks pool totals for communal buys - format: list(type = amount)
	var/list/communal_pools = list()

/datum/controller/subsystem/triumphs/Initialize()
	. = ..()

	prep_the_triumphs_leaderboard()


	for(var/cur_path in subtypesof(/datum/triumph_buy))
		var/datum/triumph_buy/cur_datum = new cur_path // We will do this
		if(isnull(cur_datum.triumph_buy_id))
			continue
		triumph_buy_datums += cur_datum
		central_state_data[cur_datum.category] += 1
	
	for(var/datum/triumph_buy/cur_datum in triumph_buy_datums)
		if(cur_datum.limited)
			triumph_buy_stocks[cur_datum.type] = cur_datum.stock

	var/list/copy_list = triumph_buy_datums.Copy()

	// Figure out how many lists we are about to make to represent the pages
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
	if(ref_datum.limited && triumph_buy_stocks[ref_datum.type] <= 0)
		to_chat(C, span_warning("The item is out of stock!"))
		return FALSE
	if(get_triumphs(C.ckey) < ref_datum.triumph_cost)
		to_chat(C, span_warning("You don't have enough triumphs to buy this item!"))
		return FALSE
	if(!ref_datum.allow_multiple_buys && C.has_triumph_buy(ref_datum.triumph_buy_id))
		to_chat(C, span_warning("You already have this item!"))
		return FALSE

	C.adjust_triumphs(ref_datum.triumph_cost * -1, counted = FALSE)

	if(ref_datum.limited)
		triumph_buy_stocks[ref_datum.type]--

	var/datum/triumph_buy/triumph_buy = new ref_datum.type

	triumph_buy.ckey_of_buyer = C.ckey

	if(!triumph_buy_owners[C.ckey])
		triumph_buy_owners[C.ckey] = list()
	triumph_buy_owners[C.ckey] += triumph_buy

	active_triumph_buy_queue += triumph_buy

	to_chat(C, span_notice("You have bought [triumph_buy.name] for [ref_datum.triumph_cost] triumph\s."))

	if(triumph_buy.conflicts_with.len)
		for(var/cur_check_path in triumph_buy.conflicts_with)
			for(var/datum/triumph_buy/active_datum in active_triumph_buy_queue)
				if(ispath(cur_check_path, active_datum.type))
					attempt_to_unbuy_triumph_condition(C, active_datum, reason = "CONFLICTS")

	triumph_buy.on_buy()
	call_menu_refresh()
	return TRUE

/*
	This occurs when you try to unbuy a triumph condition and removes it
*/
/datum/controller/subsystem/triumphs/proc/attempt_to_unbuy_triumph_condition(client/C, datum/triumph_buy/triumph_buy, reason = "\improper REFUND", force = FALSE)
	var/previous_owner_ckey = triumph_buy.ckey_of_buyer
	if(previous_owner_ckey != C?.ckey)
		if(C)
			to_chat(C, span_warning("You can't refund someone else's triumph buy!"))
		return FALSE
	if(!force && triumph_buy.activated)
		if(C)
			to_chat(C, span_warning("You can't refund a triumph buy that was already activated!"))
		return FALSE
	var/refund_amount = triumph_buy.triumph_cost
	if(C?.ckey)
		C.adjust_triumphs(refund_amount, counted = FALSE)
		to_chat(C, span_redtext("You were refunded [refund_amount] triumph\s due to \a [reason]."))
	else if(previous_owner_ckey)
		triumph_adjust(refund_amount, previous_owner_ckey)
	if(triumph_buy.limited)
		triumph_buy_stocks[triumph_buy.type]++
	if(triumph_buy_owners[triumph_buy.ckey_of_buyer])
		triumph_buy_owners[triumph_buy.ckey_of_buyer] -= triumph_buy
	triumph_buy.on_removal()
	active_triumph_buy_queue -= triumph_buy
	return TRUE

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

/*
	We save everything when its time for reboot
*/
/datum/controller/subsystem/triumphs/proc/end_triumph_saving_time()
	to_chat(world, span_boldannounce(" Recording VICTORIES to the WORLD END MACHINE. "))
	//for(var/target_ckey in triumph_amount_cache)
	//	var/list/saving_data = list()
	//	// this will be for example "data/player_saves/a/ass/triumphs.json" if their ckey was ass
	//	var/target_file = file("data/player_saves/[target_ckey[1]]/[target_ckey]/triumphs.json")
	//	if(fexists(target_file))
	//		fdel(target_file)
//
//		saving_data["triumph_wipe_season"] = GLOB.triumph_wipe_season
//		saving_data["triumph_count"] = triumph_amount_cache[target_ckey]
//
//		WRITE_FILE(target_file, json_encode(saving_data))

	// handle the leaderboard here too i guess
	var/leaderboard_file = file("data/triumph_leaderboards/triumphs_leaderboard_season_[GLOB.triumph_wipe_season].json")
	if(fexists(leaderboard_file))
		fdel(leaderboard_file)
	WRITE_FILE(leaderboard_file, json_encode(triumph_leaderboard))



// Adjust triumphs
/datum/controller/subsystem/triumphs/proc/triumph_adjust(amt, target_ckey)
	if(!target_ckey)
		return
	if(target_ckey in triumph_amount_cache)
		triumph_amount_cache[target_ckey] += amt
		log_game("TRIUMPHS: [target_ckey] received [amt] triumph\s. They have a total of [triumph_amount_cache[target_ckey]] triumph\s now. Checked with cache.")
		var/list/saving_data = list()
		var/target_file = file("data/player_saves/[target_ckey[1]]/[target_ckey]/triumphs.json")
		var/backup_file = file("data/player_saves/[target_ckey[1]]/[target_ckey]/triumphs.backup.json")

		saving_data["triumph_wipe_season"] = GLOB.triumph_wipe_season
		saving_data["triumph_count"] = triumph_amount_cache[target_ckey]
		if(fexists(backup_file))
			fdel(backup_file)

		WRITE_FILE(backup_file, json_encode(saving_data))
		fcopy("[backup_file]", "[target_file]") //This sucks
		fdel(backup_file)
	else
		var/target_file = file("data/player_saves/[target_ckey[1]]/[target_ckey]/triumphs.json")
		if(fexists(target_file))
			var/list/not_new_guy = json_decode(file2text(target_file))
			var/cur_client_triumph_count = not_new_guy["triumph_count"]
			triumph_amount_cache[target_ckey] = cur_client_triumph_count + amt

			log_game("TRIUMPHS: [target_ckey] received [amt] triumph\s. They have a total of [triumph_amount_cache[target_ckey]] triumph\s now. Checked with player save.")
			var/list/saving_data = list()
			saving_data["triumph_wipe_season"] = GLOB.triumph_wipe_season
			saving_data["triumph_count"] = triumph_amount_cache[target_ckey]
			fdel(target_file)
			WRITE_FILE(target_file, json_encode(saving_data))
		else
			message_admins("TRIUMPHS: [target_ckey] was not found in the triumph cache and had no player save, they would otherwise receive [amt] triumphs.")


// Wipe the triumphs of one person
/datum/controller/subsystem/triumphs/proc/wipe_target_triumphs(target_ckey)
	if(target_ckey)
		if(!(target_ckey in triumph_amount_cache))
			return
		else
			triumph_amount_cache[target_ckey] = 0
			log_game("TRIUMPHS: [target_ckey] was wiped of all triumphs!")

/// Clears the leaderboard of all entries, keeping the current season and player's triumphs
/datum/controller/subsystem/triumphs/proc/reset_leaderboard()
	triumph_leaderboard = list()

/// Wipe the entire list and adjust the season up by 1 too so anyone behind gets wiped if they rejoin later
// /datum/controller/subsystem/triumphs/proc/wipe_all_triumphs()
// 	triumph_amount_cache = list()

// 	var/target_file = file("data/triumph_wipe_season.json")
// 	GLOB.triumph_wipe_season += 1
// 	var/list/wipe_season = list("current_wipe_season" = GLOB.triumph_wipe_season)
// 	fdel(target_file)
// 	WRITE_FILE(target_file, json_encode(wipe_season))

// 	// Wipe the leaderboard list, time for a fresh season.
// 	// But leave the old leaderboard file in, we mite do somethin w it later
// 	reset_leaderboard()

/// Gets the legacy triumph value to inherit the old triumphs for the first season, assuming legacy data was converted to ckeys
/datum/controller/subsystem/triumphs/proc/get_legacy_triumph_value(target_ckey)
	if(!target_ckey)
		return 0
	if(legacy_triumphs == null)
		var/json_file = file("data/triumphs.json")
		if(!fexists(json_file))
			return 0
		var/list/json = json_decode(file2text(json_file))
		var/list/new_legacy = list()
		for(var/player_key in json)
			new_legacy[ckey(player_key)] = json[player_key]
		legacy_triumphs = new_legacy
	if(legacy_triumphs[target_ckey])
		return legacy_triumphs[target_ckey]
	return 0

// Return a value of the triumphs they got
/datum/controller/subsystem/triumphs/proc/get_triumphs(target_ckey)
	if(!(target_ckey in triumph_amount_cache))
		var/target_file = file("data/player_saves/[target_ckey[1]]/[target_ckey]/triumphs.json")
		if(!fexists(target_file)) // no file or new player, write them in something
			var/triumph_amount = 0
			// If it is the first triumph wipe season, inherit previous triumphs
			if(GLOB.triumph_wipe_season <= 1)
				triumph_amount = get_legacy_triumph_value(target_ckey)

			var/list/new_guy = list("triumph_count" = triumph_amount, "triumph_wipe_season" = GLOB.triumph_wipe_season)

			WRITE_FILE(target_file, json_encode(new_guy))
			triumph_amount_cache[target_ckey] = triumph_amount
			return triumph_amount

		// This is not a new guy
		var/list/not_new_guy = json_decode(file2text(target_file))
		if(GLOB.triumph_wipe_season > not_new_guy["triumph_wipe_season"]) // Their file is behind in wipe seasons, time to be set to 0
			triumph_amount_cache[target_ckey] = 0
			return 0

		var/cur_client_triumph_count = not_new_guy["triumph_count"]
		triumph_amount_cache[target_ckey] = cur_client_triumph_count
		return cur_client_triumph_count

	return triumph_amount_cache[target_ckey]


/*
	TRIUMPH LEADERBOARD STUFF
*/
/// Displays leaderboard browser popup
/datum/controller/subsystem/triumphs/proc/show_triumph_leaderboard(client/C)
	var/webpage = "<div style='text-align:center'>Current Season: [GLOB.triumph_wipe_season]</div>"
	webpage += "<hr>"

	if(triumph_leaderboard.len)
		var/position_number = 0
		for(var/key in triumph_leaderboard)
			position_number++
			webpage += "[position_number]. [key] - [triumph_leaderboard[key]]<br>"
			if(position_number >= triumph_leaderboard_positions_tracked)
				break
	else
		webpage += "The hall of triumphs is quite empty, Yes?"

	var/datum/browser/popup = new(C, "triumph_leaderboard", "CHAMPIONS OF PSYDONIA", 300, 570)
	popup.set_content(webpage)
	popup.open(FALSE)

/// Prepare the leaderboard by getting it and sorting it
/datum/controller/subsystem/triumphs/proc/prep_the_triumphs_leaderboard()
	var/json_file = file("data/triumph_leaderboards/triumphs_leaderboard_season_[GLOB.triumph_wipe_season].json")
	if(!fexists(json_file))
		return

	triumph_leaderboard = json_decode(file2text(json_file))

	sort_leaderboard()

// Adjust leaderboard
// I want a key here so it looks pretty
/datum/controller/subsystem/triumphs/proc/adjust_leaderboard(CLIENT_KEY_not_CKEY)
	var/user_key = CLIENT_KEY_not_CKEY
	var/triumph_total = triumph_amount_cache[ckey(user_key)]

	for(var/existing_key in triumph_leaderboard)
		if(ckey(existing_key) == ckey(user_key))
			triumph_leaderboard.Remove(existing_key)

	// You automatically get added in if we haven't filled in all the crap
	if(triumph_leaderboard_positions_tracked > triumph_leaderboard.len)
		triumph_leaderboard[user_key] = triumph_total

	else
		// Guy in last place is still greater than this guy
		if(triumph_leaderboard[triumph_leaderboard[triumph_leaderboard.len]] > triumph_total)
			return

	triumph_leaderboard.Cut(triumph_leaderboard.len)
	triumph_leaderboard[user_key] = triumph_total
	sort_leaderboard()
	
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
