
#define CHESS_WHITE "w"
#define CHESS_BLACK "b"

#define BOARD_MODE_CHESS "chess"
#define BOARD_MODE_CHECKERS "checkers"
#define BOARD_MODE_NARDS "nards"
#define BOARD_MODE_NONE "none"

//Sounds are defined in  __DEFINES/chess.dm, this is to make replacing sounds easier.

#define CHESS_PAWN   "p"
#define CHESS_ROOK   "r"
#define CHESS_KNIGHT "n"
#define CHESS_BISHOP "b"
#define CHESS_QUEEN  "q"
#define CHESS_KING   "k"

#define CHECKERS_MAN  "m"
#define CHECKERS_KING "k"

#define CHESS_UI_ACTIVE_WINDOW (30 SECONDS)
#define CHESS_OBSERVER_RESET_TIME (20 SECONDS)
#define CHESS_PACK_BOARD_TIME (15 SECONDS)
#define CHESS_FLIP_BOARD_TIME (7 SECONDS)

/proc/chess_square_index(file, rank)
	return (((rank - 1) << 3) + file)

/proc/chess_square_file(idx)
	return (((idx - 1) & 7) + 1)

/proc/chess_square_rank(idx)
	return (((idx - 1) >> 3) + 1)

/proc/chess_square_name(idx)
	return "[ascii2text(96 + chess_square_file(idx))][chess_square_rank(idx)]"

/proc/chess_wrap_point_24(point)
	point = text2num("[point]")
	while(point < 1)
		point += 24
	while(point > 24)
		point -= 24
	return point

/proc/chess_side_name(color)
	if(color == CHESS_WHITE)
		return "White"
	if(color == CHESS_BLACK)
		return "Black"
	return "Nobody"

/proc/chess_piece_color(piece)
	if(!istext(piece) || length(piece) < 2)
		return null
	return copytext(piece, 1, 2)

/proc/chess_piece_type(piece)
	if(!istext(piece) || length(piece) < 2)
		return null
	return copytext(piece, 2, 3)

/proc/chess_piece_letter(piece_type)
	switch(piece_type)
		if(CHESS_KING)
			return "K"
		if(CHESS_QUEEN)
			return "Q"
		if(CHESS_ROOK)
			return "R"
		if(CHESS_BISHOP)
			return "B"
		if(CHESS_KNIGHT)
			return "N"
		if(CHESS_PAWN)
			return ""
	return "?"

/proc/chess_display_name(mob/user)
	if(!user)
		return "Unknown"
	if(user.real_name)
		return user.real_name
	return user.name

/proc/chess_assoc_get(list/source, key, default_value)
	if(!islist(source))
		return default_value
	if(!(key in source))
		return default_value
	var/value = source[key]
	if(isnull(value))
		return default_value
	return value

/obj/item/chessboard_folded
	name = "folded chessboard"
	desc = "A wooden checkered board folded in half. It is designed for games such as chess, checkers, and backgammon."
	w_class = WEIGHT_CLASS_NORMAL
	grid_width = 96
	grid_height = 64
	icon = 'icons/chess/chess.dmi'
	icon_state = "chessboard_folded"

/obj/item/chessboard_folded/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Use the board in hand to lay it out.")

/obj/item/chessboard_folded/attack_self(mob/user)
	if(!user)
		return
	var/turf/target_turf = get_step(user, user.dir)
	if(!target_turf)
		target_turf = get_turf(user)
	if(!target_turf)
		return
	new /obj/structure/chessboard(target_turf)
	user.visible_message(span_notice("[user] unfolds the chessboard."), span_notice("You unfold the chessboard."))
	qdel(src)

/obj/structure/chessboard
	name = "chessboard"
	desc = "A wooden checkered board laid open. It is designed for games such as chess, checkers, and backgammon."
	anchored = TRUE
	density = FALSE
	layer = OBJ_LAYER

	icon = 'icons/chess/chess.dmi'
	icon_state = "chessboard_unfolded"

	var/datum/chess_match/match
	var/rotation_degrees = 0
	var/list/selected_squares = list()
	var/last_ui_message = null
	var/list/active_ui_ckeys = list()

/obj/structure/chessboard/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left click on the board with an empty hand to open the UI.")
	. += span_info("Right click the board to rotate it.")
	. += span_info("Fold the board once more by clicking on PACK BOARD in the board's UI.")

/obj/structure/chessboard/Initialize(mapload)
	. = ..()
	match = new(src)
	selected_squares = list()
	last_ui_message = null
	active_ui_ckeys = list()
	rotation_degrees = 0
	update_board_art()

/obj/structure/chessboard/Destroy()
	QDEL_NULL(match)
	selected_squares = null
	active_ui_ckeys = null
	return ..()

/obj/structure/chessboard/attack_hand(mob/user)
	if(!user)
		return ..()
	ui_interact(user)
	return TRUE

/obj/structure/chessboard/attack_ghost(mob/dead/observer/user)
	if(!in_range(src, user))
		return ..()
	ui_interact(user)
	return TRUE

/obj/structure/chessboard/AltClick(mob/user)
	return ..()

/obj/structure/chessboard/attack_right(mob/user)
	if(!user)
		return ..()
	if(!user.canUseTopic(src, be_close = TRUE))
		return ..()
	rotate_board_clockwise(user)
	return TRUE

/obj/structure/chessboard/ui_interact(mob/user, datum/tgui/ui)
	mark_viewer_active(user)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChessBoard", name)
		ui.open()

/obj/structure/chessboard/ui_data(mob/user)
	mark_viewer_active(user)
	var/list/data = list()
	var/my_side = match.side_for_user(user)
	var/selected = get_selection(user)
	if(!selected && my_side && my_side == match.turn && match.game_mode == BOARD_MODE_CHECKERS && match.forced_capture_from)
		selected = match.forced_capture_from

	data["board_title"] = "Chessboard"
	data["white_player_name"] = match.white_player_name ? match.white_player_name : "Available"
	data["black_player_name"] = match.black_player_name ? match.black_player_name : "Available"
	data["my_side"] = my_side ? chess_side_name(my_side) : "Observer"
	data["my_side_key"] = my_side
	data["turn"] = chess_side_name(match.turn)
	data["turn_key"] = match.turn
	data["paused"] = match.paused
	data["can_resign"] = match.can_resign(user)
	data["result_text"] = match.result_text
	data["selected_square"] = selected
	data["status_text"] = match.get_status_text()
	data["last_message"] = last_ui_message
	data["can_resume"] = match.can_resume()
	data["can_pack"] = match.can_pack_up()
	data["board"] = build_board_data(user, selected)
	data["history"] = build_history_rows()
	data["promotion_choices"] = list("queen", "rook", "bishop", "knight")
	data["game_mode"] = match.game_mode
	data["game_mode_label"] = match.get_game_mode_label()
	data["current_rules_text"] = match.get_current_rules_text()
	data["checkers_flying_kings"] = match.checkers_flying_kings
	data["nards_long_rules"] = match.nards_long_rules
	data["mode_options"] = match.get_mode_options()
	data["switch_mode_target_key"] = match.other_mode()
	data["switch_mode_target_label"] = match.get_mode_label(match.other_mode())
	data["mode_switch_pending"] = !!match.pending_mode
	data["mode_switch_pending_text"] = match.get_mode_switch_text()
	data["can_confirm_mode_switch"] = match.can_confirm_mode_switch(user)
	data["can_cancel_mode_switch"] = match.can_cancel_mode_switch(user)
	data["reset_pending_text"] = match.get_reset_request_text()
	data["can_confirm_reset_request"] = match.can_confirm_reset_request(user)
	data["can_cancel_reset_request"] = match.can_cancel_reset_request(user)
	data["can_flip_board"] = match.can_flip_board()
	data["nards"] = (match.game_mode == BOARD_MODE_NARDS) ? build_nards_data(user) : null
	return data

/obj/structure/chessboard/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = usr
	if(!user)
		return FALSE
	if(!user.canUseTopic(src, be_close = TRUE))
		return FALSE

	switch(action)
		if("claim_side")
			play_notify_sound()
			var/color = params["color"]
			if(match.claim_side(color, user))
				clear_all_selections()
				last_ui_message = "[chess_display_name(user)] takes the [chess_side_name(color)] seat."
				queue_ui_update()
				return TRUE
			return FALSE

		if("release_side")
			play_notify_sound()
			var/release_color = params["color"]
			if(match.release_side(release_color, user))
				clear_all_selections()
				last_ui_message = "[chess_display_name(user)] leaves the [chess_side_name(release_color)] seat."
				queue_ui_update()
				return TRUE
			return FALSE

		if("pause_game")
			play_notify_sound()
			if(match.pause_game(user))
				clear_all_selections()
				last_ui_message = "The game has been paused."
				queue_ui_update()
				return TRUE
			return FALSE

		if("resume_game")
			play_notify_sound()
			if(match.resume_game(user))
				last_ui_message = "The game has resumed."
				queue_ui_update()
				return TRUE
			return FALSE

		if("resign_game")
			play_notify_sound()
			if(match.resign_game(user))
				clear_all_selections()
				last_ui_message = null
				queue_ui_update()
				return TRUE
			return FALSE

		if("reset_board")
			play_notify_sound()
			if(handle_reset_request(user))
				queue_ui_update()
				return TRUE
			return FALSE

		if("confirm_reset_board")
			play_notify_sound()
			if(handle_confirm_reset_request(user))
				queue_ui_update()
				return TRUE
			return FALSE

		if("cancel_reset_board")
			play_notify_sound()
			if(handle_cancel_reset_request(user))
				queue_ui_update()
				return TRUE
			return FALSE

		if("request_mode_switch")
			play_notify_sound()
			var/target_mode = params["mode"]
			var/checkers_flying_kings = !!text2num(params["checkers_flying_kings"])
			var/nards_long_rules = !!text2num(params["nards_long_rules"])
			if(match.request_mode_switch(target_mode, user, checkers_flying_kings, nards_long_rules))
				clear_all_selections()
				if(match.pending_mode)
					last_ui_message = match.get_mode_switch_text()
				else
					last_ui_message = "Mode switched to [match.get_game_mode_label()]."
				queue_ui_update()
				return TRUE
			return FALSE

		if("confirm_mode_switch")
			play_notify_sound()
			if(match.confirm_mode_switch(user))
				clear_all_selections()
				last_ui_message = "Mode switched to [match.get_game_mode_label()]."
				queue_ui_update()
				return TRUE
			return FALSE

		if("cancel_mode_switch")
			play_notify_sound()
			if(match.cancel_mode_switch(user))
				last_ui_message = "The mode change request was canceled."
				queue_ui_update()
				return TRUE
			return FALSE

		if("pack_board")
			play_notify_sound()
			if(!match.can_pack_up())
				to_chat(user, span_warning("The board can only be packed away when no game is in progress."))
				return FALSE
			notify_seated_players("[chess_display_name(user)] is packing up the board.", user.ckey)
			user.visible_message(span_notice("[user] starts packing up the board."), span_notice("You start packing up the board."))
			if(!do_after(user, CHESS_PACK_BOARD_TIME, target = src))
				to_chat(user, span_warning("You stop packing up the board."))
				return FALSE
			if(QDELETED(src) || !match || !match.can_pack_up())
				return FALSE
			playsound(src, CHESS_SOUND_PICKUP, 70, FALSE)
			new /obj/item/chessboard_folded(get_turf(src))
			user.visible_message(span_notice("[user] folds the board for travel."), span_notice("You fold the board for travel."))
			qdel(src)
			return TRUE

		if("flip_board")
			play_notify_sound()
			if(handle_flip_board(user))
				queue_ui_update()
				return TRUE
			return FALSE

		if("select_square")
			var/square = text2num(params["square"])
			if(handle_square_selection(user, square))
				queue_ui_update()
				return TRUE
			return FALSE

		if("move_piece")
			var/from_idx = text2num(params["from"])
			var/to_idx = text2num(params["to"])
			var/promotion = params["promotion"]
			if(handle_piece_move(user, from_idx, to_idx, promotion))
				queue_ui_update()
				return TRUE
			return FALSE

		if("roll_nards_dice")
			if(match.roll_nards_dice(user))
				last_ui_message = match.last_action_message
				queue_ui_update()
				return TRUE
			return FALSE


		if("select_nards_point")
			var/point = text2num(params["point"])
			if(match.select_nards_point(user, point))
				last_ui_message = match.last_action_message
				queue_ui_update()
				return TRUE
			return FALSE

		if("select_nards_bar")
			if(match.select_nards_bar(user))
				last_ui_message = match.last_action_message
				queue_ui_update()
				return TRUE
			return FALSE

		if("move_nards_checker")
			var/to_point = text2num(params["to_point"])
			var/to_off = text2num(params["to_off"])
			if(match.move_nards_checker(user, to_point, !!to_off))
				last_ui_message = match.last_action_message
				queue_ui_update()
				return TRUE
			return FALSE

	return FALSE

/obj/structure/chessboard/proc/queue_ui_update()
	update_board_art()
	SStgui.update_uis(src)

/obj/structure/chessboard/proc/play_notify_sound()
	playsound(src, CHESS_SOUND_NOTIFY, 50, FALSE)

/obj/structure/chessboard/proc/rotate_board_clockwise(mob/user)
	rotation_degrees = (rotation_degrees + 90) % 360
	update_board_art()
	if(user)
		to_chat(user, span_notice("You rotate the board."))

/obj/structure/chessboard/proc/update_board_transform()
	transform = turn(matrix(), rotation_degrees)

/obj/structure/chessboard/proc/get_world_icon_state()
	if(!match || match.game_mode == BOARD_MODE_NONE)
		return "chessboard_unfolded"
	if(match.game_mode == BOARD_MODE_CHESS)
		return "chessboard_unfolded_chess"
	if(match.game_mode == BOARD_MODE_CHECKERS)
		return "chessboard_unfolded_checkers"
	if(match.game_mode == BOARD_MODE_NARDS)
		return "chessboard_unfolded_nards"
	return "chessboard_unfolded"

/obj/structure/chessboard/proc/update_board_art()
	icon = 'icons/chess/chess.dmi'
	icon_state = get_world_icon_state()
	update_board_transform()

/obj/structure/chessboard/proc/mark_viewer_active(mob/user)
	if(!user || !user.ckey)
		return
	if(!active_ui_ckeys)
		active_ui_ckeys = list()
	active_ui_ckeys[user.ckey] = world.time

/obj/structure/chessboard/proc/is_ckey_actively_viewing(ckey)
	if(!ckey || !active_ui_ckeys)
		return FALSE
	var/last_seen = active_ui_ckeys[ckey]
	if(isnull(last_seen))
		return FALSE
	return (world.time - text2num("[last_seen]")) <= CHESS_UI_ACTIVE_WINDOW

/obj/structure/chessboard/proc/is_side_actively_viewing(color)
	if(color == CHESS_WHITE)
		return is_ckey_actively_viewing(match.white_player_ckey)
	if(color == CHESS_BLACK)
		return is_ckey_actively_viewing(match.black_player_ckey)
	return FALSE

/obj/structure/chessboard/proc/find_mob_by_ckey(ckey)
	if(!ckey)
		return null
	for(var/client/C)
		if(C.ckey == ckey)
			return C.mob
	return null

/obj/structure/chessboard/proc/notify_seated_players(message, exclude_ckey = null)
	if(!message || !match)
		return
	var/list/notified = list()
	for(var/target_ckey in list(match.white_player_ckey, match.black_player_ckey))
		if(!target_ckey || target_ckey == exclude_ckey)
			continue
		if(target_ckey in notified)
			continue
		var/mob/target_mob = find_mob_by_ckey(target_ckey)
		if(target_mob)
			to_chat(target_mob, span_warning(message))
		notified += target_ckey

/obj/structure/chessboard/proc/handle_reset_request(mob/user)
	var/user_side = match.side_for_user(user)
	if(user_side)
		if(match.should_require_player_reset_confirmation(src, user))
			if(match.request_reset_confirmation(user))
				notify_seated_players("[chess_display_name(user)] requests a board reset. A second player must confirm.", user.ckey)
				last_ui_message = match.get_reset_request_text()
				return TRUE
			return FALSE
		if(match.reset_game(user))
			clear_all_selections()
			last_ui_message = "The board has been reset and both player seats are now open."
			playsound(src, CHESS_SOUND_RESET, 70, FALSE)
			return TRUE
		return FALSE

	if(match.begin_observer_reset(user))
		notify_seated_players("[chess_display_name(user)] requests a board reset. The game and player seats will be reset in 20 seconds unless the request is canceled.", user.ckey)
		last_ui_message = match.get_reset_request_text()
		return TRUE
	return FALSE

/obj/structure/chessboard/proc/handle_confirm_reset_request(mob/user)
	if(match.confirm_reset_request(user))
		clear_all_selections()
		last_ui_message = "The board has been reset and both player seats are now open."
		playsound(src, CHESS_SOUND_RESET, 70, FALSE)
		return TRUE
	return FALSE

/obj/structure/chessboard/proc/handle_cancel_reset_request(mob/user)
	if(match.cancel_reset_request(user))
		last_ui_message = "The board reset request was canceled."
		return TRUE
	return FALSE

/obj/structure/chessboard/proc/handle_flip_board(mob/user)
	if(!match.can_flip_board())
		to_chat(user, span_warning("The board cannot be flipped right now."))
		return FALSE
	notify_seated_players("[chess_display_name(user)] is about to flip the board.", user.ckey)
	user.visible_message(span_warning("[user] grabs the board, preparing to flip it."), span_warning("You grab the board."))
	if(!do_after(user, CHESS_FLIP_BOARD_TIME, target = src))
		to_chat(user, span_warning("You decide not to flip the board."))
		return FALSE
	if(QDELETED(src) || !match || !match.can_flip_board())
		return FALSE
	if(match.overturn_board(user))
		playsound(src, CHESS_SOUND_RAGE, 70, FALSE)
		clear_all_selections()
		last_ui_message = match.last_action_message
		return TRUE
	return FALSE

/obj/structure/chessboard/proc/clear_selection(mob/user)
	if(!user || !user.ckey)
		return
	selected_squares[user.ckey] = null

/obj/structure/chessboard/proc/clear_all_selections()
	selected_squares = list()

/obj/structure/chessboard/proc/get_selection(mob/user)
	if(!user || !user.ckey)
		return 0
	var/value = selected_squares[user.ckey]
	if(isnull(value))
		return 0
	return text2num("[value]")

/obj/structure/chessboard/proc/set_selection(mob/user, square)
	if(!user || !user.ckey)
		return
	selected_squares[user.ckey] = square

/obj/structure/chessboard/proc/build_board_data(mob/user, selected_override = 0)
	var/list/board_data = list()
	if(match.game_mode == BOARD_MODE_NARDS)
		return board_data
	var/selected = selected_override
	if(!selected)
		selected = get_selection(user)

	var/list/legal_targets = list()
	var/my_side = match.side_for_user(user)
	if(selected && my_side && my_side == match.turn && !match.paused && !match.result_text)
		legal_targets = match.get_legal_targets(selected)

	for(var/rank = 8, rank >= 1, rank--)
		for(var/file = 1, file <= 8, file++)
			var/index = chess_square_index(file, rank)
			var/list/cell = list(
				"index" = index,
				"file" = file,
				"rank" = rank,
				"piece" = match.board[index],
				"light" = ((file + rank) % 2),
				"selected" = (index == selected),
				"lastmove" = (index == match.last_from || index == match.last_to),
				"target" = (index in legal_targets),
				"pose" = match.get_display_pose(index),
				"offset_x" = match.get_display_offset_x(index),
				"offset_y" = match.get_display_offset_y(index),
				"angle" = match.get_display_angle(index)
			)
			board_data += list(cell)
	return board_data

/obj/structure/chessboard/proc/build_history_rows()
	var/list/rows = list()
	var/turn_number = 1
	for(var/i = 1, i <= match.move_history.len, i += 2)
		var/list/row = list(
			"turn" = turn_number,
			"white" = match.move_history[i],
			"black" = (i + 1 <= match.move_history.len) ? match.move_history[i + 1] : null
		)
		rows += list(row)
		turn_number++
	return rows


/obj/structure/chessboard/proc/build_nards_data(mob/user)
	var/list/points = list()
	for(var/point = 1, point <= 24, point++)
		var/list/entry = list(
			"point" = point,
			"color" = match.nards_point_color(point),
			"count" = match.nards_point_count(point)
		)
		points += list(entry)

	return list(
		"points" = points,
		"bar_white" = match.nards_bar_white,
		"bar_black" = match.nards_bar_black,
		"off_white" = match.nards_off_white,
		"off_black" = match.nards_off_black,
		"die_one" = match.nards_die_one,
		"die_two" = match.nards_die_two,
		"roll_nonce" = match.nards_roll_nonce,
		"can_roll" = match.can_roll_nards_dice(user),
		"selected_point" = match.nards_selected_point,
		"selected_bar" = match.nards_selected_from_bar,
		"legal_targets" = match.get_nards_legal_targets_for_user(user),
		"can_select_bar" = match.nards_bar_count(match.side_for_user(user)) > 0,
		"available_rolls" = match.nards_available_rolls ? match.nards_available_rolls.Copy() : list(),
		"is_long_rules" = match.nards_long_rules,
		"overturned" = match.overturned,
		"scatter" = match.get_nards_scatter_data(),
		"scatter_dice" = match.get_nards_scatter_dice_data()
	)

/obj/structure/chessboard/proc/handle_square_selection(mob/user, square)
	if(square < 1 || square > 64)
		return FALSE
	if(match.paused)
		to_chat(user, span_warning("The game is paused."))
		return FALSE
	if(match.overturned)
		to_chat(user, span_warning("The board has been flipped. Reset it first."))
		return FALSE
	if(match.result_text)
		to_chat(user, span_warning("The game has already ended."))
		return FALSE

	var/color = match.side_for_user(user)
	if(!color)
		to_chat(user, span_warning("You are not seated at this board."))
		return FALSE
	if(color != match.turn)
		to_chat(user, span_warning("It is not your turn."))
		return FALSE

	var/selected = get_selection(user)
	var/piece = match.board[square]

	if(!selected)
		if(piece && chess_piece_color(piece) == color)
			if(match.can_select_piece(square, color))
				set_selection(user, square)
			else
				to_chat(user, span_warning("You can only move a different piece right now."))
			return TRUE
		return FALSE

	if(selected == square)
		clear_selection(user)
		return TRUE

	if(piece && chess_piece_color(piece) == color)
		if(match.can_select_piece(square, color))
			set_selection(user, square)
		else
			to_chat(user, span_warning("You can only move a different piece right now."))
		return TRUE

	return FALSE

/obj/structure/chessboard/proc/handle_piece_move(mob/user, from_idx, to_idx, promotion_choice)
	if(from_idx < 1 || from_idx > 64 || to_idx < 1 || to_idx > 64)
		return FALSE

	if(match.try_move(from_idx, to_idx, user, promotion_choice))
		clear_all_selections()
		if(match.game_mode == BOARD_MODE_CHECKERS && match.forced_capture_from && match.turn == match.side_for_user(user))
			set_selection(user, match.forced_capture_from)
		last_ui_message = match.last_action_message
		return TRUE
	return FALSE

/obj/structure/chessboard/proc/play_sound_for_ckey(ckey, sound_file, volume = 60)
	if(!ckey || !sound_file)
		return
	var/mob/target_mob = find_mob_by_ckey(ckey)
	if(target_mob)
		playsound(target_mob, sound_file, volume, FALSE)

/obj/structure/chessboard/proc/play_sound_for_active_viewers(sound_file, volume = 60, list/exclude_ckeys = null)
	if(!sound_file || !active_ui_ckeys)
		return
	for(var/target_ckey in active_ui_ckeys)
		if(exclude_ckeys && (target_ckey in exclude_ckeys))
			continue
		if(!is_ckey_actively_viewing(target_ckey))
			continue
		play_sound_for_ckey(target_ckey, sound_file, volume)

/obj/structure/chessboard/proc/play_win_loss_sounds(winner_color)
	if(!match)
		return
	var/loser_color = (winner_color == CHESS_WHITE) ? CHESS_BLACK : CHESS_WHITE
	var/winner_ckey = (winner_color == CHESS_WHITE) ? match.white_player_ckey : match.black_player_ckey
	var/loser_ckey = (loser_color == CHESS_WHITE) ? match.white_player_ckey : match.black_player_ckey
	if(loser_ckey)
		play_sound_for_ckey(loser_ckey, CHESS_SOUND_LOSS, 65)
	var/list/exclude = list()
	if(loser_ckey)
		exclude += loser_ckey
	if(winner_ckey)
		play_sound_for_ckey(winner_ckey, CHESS_SOUND_WIN, 65)
	play_sound_for_active_viewers(CHESS_SOUND_WIN, 65, exclude)

/obj/structure/chessboard/proc/play_check_alert()
	play_sound_for_active_viewers(CHESS_SOUND_CHECK, 55)

/datum/chess_match
	var/obj/structure/chessboard/owner
	var/list/board = list()

	var/game_mode = BOARD_MODE_NONE
	var/turn = CHESS_WHITE
	var/paused = TRUE
	var/game_started = FALSE
	var/result_text = null

	var/white_player_ckey = null
	var/black_player_ckey = null
	var/white_player_name = null
	var/black_player_name = null

	var/list/move_history = list()
	var/list/repetition_counts = list()
	var/last_from = 0
	var/last_to = 0
	var/fullmove_number = 1
	var/last_action_message = null

	// Chess state
	var/white_castle_king = TRUE
	var/white_castle_queen = TRUE
	var/black_castle_king = TRUE
	var/black_castle_queen = TRUE
	var/en_passant_square = 0
	var/halfmove_clock = 0

	// Checkers state
	var/forced_capture_from = 0
	var/pending_turn_notation = null
	var/checkers_flying_kings = FALSE

	// Shared mode-switch request
	var/pending_mode = null
	var/pending_checkers_flying_kings = FALSE
	var/pending_nards_long_rules = FALSE
	var/pending_mode_requester_ckey = null
	var/pending_mode_requester_name = null
	var/pending_reset_requester_ckey = null
	var/pending_reset_requester_name = null
	var/pending_observer_reset_ckey = null
	var/pending_observer_reset_name = null
	var/pending_observer_reset_at = 0
	var/overturned = FALSE
	var/list/overturn_poses = list()
	var/list/overturn_offset_x = list()
	var/list/overturn_offset_y = list()
	var/list/overturn_angle = list()
	var/list/nards_scatter = list()
	var/list/nards_scatter_dice = list()

	// Nards state
	var/list/nards_points = list()
	var/nards_bar_white = 0
	var/nards_bar_black = 0
	var/nards_off_white = 0
	var/nards_off_black = 0
	var/nards_die_one = 0
	var/nards_die_two = 0
	var/nards_roll_nonce = 0
	var/list/nards_available_rolls = list()
	var/nards_selected_point = 0
	var/nards_selected_from_bar = FALSE
	var/nards_long_rules = FALSE
	var/nards_head_moves_this_turn = 0

/datum/chess_match/New(obj/structure/chessboard/new_owner)
	owner = new_owner
	reset_position()
	return ..()

/datum/chess_match/proc/get_mode_label(mode)
	if(mode == BOARD_MODE_NONE)
		return "Not selected"
	if(mode == BOARD_MODE_CHESS)
		return "Chess"
	if(mode == BOARD_MODE_CHECKERS)
		return "Checkers"
	if(mode == BOARD_MODE_NARDS)
		return "Backgammon"
	return "Unknown"

/datum/chess_match/proc/get_mode_label_with_rules(mode, use_checkers_flying_kings = checkers_flying_kings, use_nards_long_rules = nards_long_rules)
	if(mode == BOARD_MODE_CHECKERS)
		return use_checkers_flying_kings ? "Checkers (flying kings)" : "Checkers (short kings)"
	if(mode == BOARD_MODE_NARDS)
		return use_nards_long_rules ? "Backgammon (long rules)" : "Backgammon (short rules)"
	return get_mode_label(mode)

/datum/chess_match/proc/get_game_mode_label()
	return get_mode_label_with_rules(game_mode)

/datum/chess_match/proc/get_current_rules_text()
	if(game_mode == BOARD_MODE_CHECKERS)
		return checkers_flying_kings ? "Kings can move any distance along a diagonal." : "Kings can move only one square at a time."
	if(game_mode == BOARD_MODE_NARDS)
		return nards_long_rules ? "Long backgammon rules are in use." : "Short backgammon rules are in use."
	return null

/datum/chess_match/proc/other_mode()
	if(game_mode == BOARD_MODE_NONE)
		return BOARD_MODE_CHESS
	if(game_mode == BOARD_MODE_CHESS)
		return BOARD_MODE_CHECKERS
	if(game_mode == BOARD_MODE_CHECKERS)
		return BOARD_MODE_NARDS
	return BOARD_MODE_CHESS

/datum/chess_match/proc/get_mode_options()
	return list(
		list("key" = BOARD_MODE_CHESS, "label" = get_mode_label(BOARD_MODE_CHESS)),
		list("key" = BOARD_MODE_CHECKERS, "label" = get_mode_label(BOARD_MODE_CHECKERS)),
		list("key" = BOARD_MODE_NARDS, "label" = get_mode_label(BOARD_MODE_NARDS))
	)

/datum/chess_match/proc/clear_mode_switch_request()
	pending_mode = null
	pending_mode_requester_ckey = null
	pending_mode_requester_name = null
	pending_checkers_flying_kings = FALSE
	pending_nards_long_rules = FALSE

/datum/chess_match/proc/clear_reset_requests()
	pending_reset_requester_ckey = null
	pending_reset_requester_name = null
	pending_observer_reset_ckey = null
	pending_observer_reset_name = null
	pending_observer_reset_at = 0

/datum/chess_match/proc/get_reset_request_text()
	if(pending_reset_requester_ckey)
		var/requester = pending_reset_requester_name ? pending_reset_requester_name : "One of the players"
		return "[requester] requests a board reset. The other player must confirm."
	if(pending_observer_reset_ckey && pending_observer_reset_at > world.time)
		var/requester2 = pending_observer_reset_name ? pending_observer_reset_name : "An observer"
		var/seconds_left = max(1, round((pending_observer_reset_at - world.time) / 10))
		return "[requester2] started a board reset. The board will reset in [seconds_left] seconds. The request can be canceled."
	return null

/datum/chess_match/proc/can_confirm_reset_request(mob/user)
	if(!pending_reset_requester_ckey || !user || !user.ckey)
		return FALSE
	if(pending_reset_requester_ckey == user.ckey)
		return FALSE
	return !!side_for_user(user)

/datum/chess_match/proc/can_cancel_reset_request(mob/user)
	if(!user || !user.ckey)
		return FALSE
	if(pending_reset_requester_ckey)
		if(pending_reset_requester_ckey == user.ckey)
			return TRUE
		return !!side_for_user(user)
	if(pending_observer_reset_ckey && pending_observer_reset_at > world.time)
		if(pending_observer_reset_ckey == user.ckey)
			return TRUE
		return !!side_for_user(user)
	return FALSE

/datum/chess_match/proc/should_require_player_reset_confirmation(obj/structure/chessboard/board_obj, mob/user)
	if(!board_obj || !user || !side_for_user(user))
		return FALSE
	if(!white_player_ckey || !black_player_ckey)
		return FALSE
	return board_obj.is_side_actively_viewing(CHESS_WHITE) && board_obj.is_side_actively_viewing(CHESS_BLACK)

/datum/chess_match/proc/request_reset_confirmation(mob/user)
	if(!user || !user.ckey)
		return FALSE
	if(pending_reset_requester_ckey)
		if(pending_reset_requester_ckey == user.ckey)
			to_chat(user, span_warning("A board reset request has already been sent."))
		return FALSE
	clear_reset_requests()
	pending_reset_requester_ckey = user.ckey
	pending_reset_requester_name = chess_display_name(user)
	last_action_message = get_reset_request_text()
	return TRUE

/datum/chess_match/proc/confirm_reset_request(mob/user)
	if(!can_confirm_reset_request(user))
		return FALSE
	clear_reset_requests()
	return reset_game(user)

/datum/chess_match/proc/cancel_reset_request(mob/user)
	if(!can_cancel_reset_request(user))
		return FALSE
	clear_reset_requests()
	last_action_message = "The board reset request was canceled."
	return TRUE

/datum/chess_match/proc/begin_observer_reset(mob/user)
	if(!user || !user.ckey)
		return FALSE
	if(side_for_user(user))
		return FALSE
	if(pending_reset_requester_ckey || (pending_observer_reset_ckey && pending_observer_reset_at > world.time))
		to_chat(user, span_warning("A reset has already been requested."))
		return FALSE
	pending_observer_reset_ckey = user.ckey
	pending_observer_reset_name = chess_display_name(user)
	pending_observer_reset_at = world.time + CHESS_OBSERVER_RESET_TIME
	last_action_message = get_reset_request_text()
	spawn(CHESS_OBSERVER_RESET_TIME)
		if(QDELETED(src) || !owner)
			return
		if(!pending_observer_reset_ckey || pending_observer_reset_ckey != user.ckey)
			return
		if(world.time < pending_observer_reset_at)
			return
		var/requester_name = pending_observer_reset_name
		reset_game(null)
		owner.clear_all_selections()
		owner.last_ui_message = "Observer [requester_name] reset the board. The game has ended and both player seats are open."
		playsound(owner, CHESS_SOUND_RESET, 70, FALSE)
		clear_reset_requests()
		owner.queue_ui_update()
	return TRUE

/datum/chess_match/proc/get_display_pose(index)
	if(!overturned || !overturn_poses)
		return "standing"
	var/pose = overturn_poses[index]
	if(!pose)
		return "standing"
	return pose

/datum/chess_match/proc/get_display_offset_x(index)
	if(!overturned || !overturn_offset_x)
		return 0
	var/value = overturn_offset_x[index]
	if(isnull(value))
		return 0
	return text2num("[value]")

/datum/chess_match/proc/get_display_offset_y(index)
	if(!overturned || !overturn_offset_y)
		return 0
	var/value = overturn_offset_y[index]
	if(isnull(value))
		return 0
	return text2num("[value]")

/datum/chess_match/proc/get_display_angle(index)
	if(!overturned || !overturn_angle)
		return 0
	var/value = overturn_angle[index]
	if(isnull(value))
		return 0
	return text2num("[value]")

/datum/chess_match/proc/can_flip_board()
	if(overturned || game_mode == BOARD_MODE_NONE)
		return FALSE
	if(game_mode == BOARD_MODE_NARDS)
		return (nards_total_checkers() > 0)
	for(var/i = 1, i <= 64, i++)
		if(board[i])
			return TRUE
	return FALSE

/datum/chess_match/proc/clear_players()
	white_player_ckey = null
	black_player_ckey = null
	white_player_name = null
	black_player_name = null

/datum/chess_match/proc/overturn_board(mob/user)
	if(overturned)
		to_chat(user, span_warning("The board has already been flipped."))
		return FALSE

	if(game_mode == BOARD_MODE_NARDS)
		build_nards_scatter()
	else
		var/list/pieces = list()
		for(var/i = 1, i <= 64, i++)
			if(board[i])
				pieces += board[i]
		board = list()
		board.len = 64
		overturn_poses = list()
		overturn_poses.len = 64
		overturn_offset_x = list()
		overturn_offset_x.len = 64
		overturn_offset_y = list()
		overturn_offset_y.len = 64
		overturn_angle = list()
		overturn_angle.len = 64
		var/list/free_squares = list()
		for(var/index = 1, index <= 64, index++)
			free_squares += index
		for(var/piece in pieces)
			var/chosen_index = pick(free_squares)
			free_squares -= chosen_index
			board[chosen_index] = piece
			var/pose = pick("standing", "standing", "fallen_left", "fallen_right")
			overturn_poses[chosen_index] = pose
			if(pose == "standing")
				overturn_offset_x[chosen_index] = rand(-8, 8)
				overturn_offset_y[chosen_index] = rand(-6, 8)
				overturn_angle[chosen_index] = rand(-18, 18)
			else
				overturn_offset_x[chosen_index] = rand(-14, 14)
				overturn_offset_y[chosen_index] = rand(-12, 12)
				overturn_angle[chosen_index] = rand(-22, 22)

	overturned = TRUE
	paused = TRUE
	result_text = "The board has been flipped. Reset it to put the pieces back in place."
	forced_capture_from = 0
	pending_turn_notation = null
	clear_mode_switch_request()
	clear_reset_requests()
	last_from = 0
	last_to = 0
	last_action_message = "[chess_display_name(user)] flips the board. The pieces scatter across it."
	if(owner)
		owner.visible_message(span_warning("[user] flips the board! The pieces scatter across it."), span_warning("You flip the board! The pieces scatter across it."))
	return TRUE

/datum/chess_match/proc/build_nards_scatter()
	nards_scatter = list()
	nards_scatter_dice = list()
	var/list/colors = list()
	for(var/point = 1, point <= 24, point++)
		var/color = nards_point_color(point)
		var/count = nards_point_count(point)
		if(!color || count <= 0)
			continue
		for(var/i = 1, i <= count, i++)
			colors += color
	for(var/i = 1, i <= nards_bar_white, i++)
		colors += CHESS_WHITE
	for(var/i = 1, i <= nards_bar_black, i++)
		colors += CHESS_BLACK
	for(var/i = 1, i <= nards_off_white, i++)
		colors += CHESS_WHITE
	for(var/i = 1, i <= nards_off_black, i++)
		colors += CHESS_BLACK

	while(colors.len)
		var/pick_index = rand(1, colors.len)
		var/color = colors[pick_index]
		colors.Cut(pick_index, pick_index + 1)
		var/pose = pick("standing", "standing", "fallen_left", "fallen_right")
		var/list/entry = list(
			"color" = color,
			"pose" = pose,
			"left" = rand(4, 336),
			"top" = rand(4, 356),
			"angle" = (pose == "standing") ? rand(-20, 20) : rand(-28, 28),
			"z" = rand(1, 200)
		)
		nards_scatter += list(entry)

	for(var/die_index = 1, die_index <= 2, die_index++)
		var/list/die_entry = list(
			"face" = rand(1, 6),
			"left" = rand(22, 322),
			"top" = rand(18, 338),
			"angle" = rand(-35, 35),
			"z" = rand(201, 260)
		)
		nards_scatter_dice += list(die_entry)

/datum/chess_match/proc/get_nards_scatter_data() as /list
	if(!overturned || game_mode != BOARD_MODE_NARDS || !nards_scatter)
		return list()
	return nards_scatter.Copy()

/datum/chess_match/proc/get_nards_scatter_dice_data() as /list
	if(!overturned || game_mode != BOARD_MODE_NARDS || !nards_scatter_dice)
		return list()
	return nards_scatter_dice.Copy()

/datum/chess_match/proc/get_mode_switch_text()
	if(!pending_mode)
		return null
	var/requester = pending_mode_requester_name ? pending_mode_requester_name : "One of the players"
	return "[requester] proposes switching to [get_mode_label_with_rules(pending_mode, pending_checkers_flying_kings, pending_nards_long_rules)]. The other player must confirm the mode change."

/datum/chess_match/proc/active_game_in_progress()
	if(game_mode == BOARD_MODE_NONE)
		return FALSE
	if(result_text)
		return FALSE
	if(move_history.len)
		return TRUE
	return FALSE

/datum/chess_match/proc/can_confirm_mode_switch(mob/user)
	if(!pending_mode || !user || !user.ckey)
		return FALSE
	if(!white_player_ckey || !black_player_ckey)
		return FALSE
	if(pending_mode_requester_ckey == user.ckey)
		return FALSE
	return !!side_for_user(user)

/datum/chess_match/proc/can_cancel_mode_switch(mob/user)
	if(!pending_mode || !user || !user.ckey)
		return FALSE
	if(pending_mode_requester_ckey == user.ckey)
		return TRUE
	return !!side_for_user(user)

/datum/chess_match/proc/request_mode_switch(target_mode, mob/user, requested_checkers_flying_kings = checkers_flying_kings, requested_nards_long_rules = nards_long_rules)
	if(overturned)
		to_chat(user, span_warning("Reset the board after it has been flipped first."))
		return FALSE
	if(target_mode != BOARD_MODE_CHESS && target_mode != BOARD_MODE_CHECKERS && target_mode != BOARD_MODE_NARDS)
		return FALSE
	requested_checkers_flying_kings = !!requested_checkers_flying_kings
	requested_nards_long_rules = !!requested_nards_long_rules
	if(target_mode == game_mode && requested_checkers_flying_kings == checkers_flying_kings && requested_nards_long_rules == nards_long_rules)
		to_chat(user, span_warning("This mode and these rules are already selected."))
		return FALSE

	if(active_game_in_progress())
		if(!paused)
			to_chat(user, span_warning("Pause the current game first."))
			return FALSE
		if(!white_player_ckey || !black_player_ckey)
			to_chat(user, span_warning("Both seats must be occupied to change modes during a game."))
			return FALSE
		if(!side_for_user(user))
			to_chat(user, span_warning("Only players seated at the board can agree to a mode change."))
			return FALSE
		if(pending_mode == target_mode && pending_checkers_flying_kings == requested_checkers_flying_kings && pending_nards_long_rules == requested_nards_long_rules)
			if(pending_mode_requester_ckey == user.ckey)
				to_chat(user, span_warning("A mode change request has already been sent."))
				return FALSE
			return confirm_mode_switch(user)

		pending_mode = target_mode
		pending_checkers_flying_kings = requested_checkers_flying_kings
		pending_nards_long_rules = requested_nards_long_rules
		pending_mode_requester_ckey = user.ckey
		pending_mode_requester_name = chess_display_name(user)
		last_action_message = get_mode_switch_text()
		return TRUE

	switch_game_mode(target_mode, requested_checkers_flying_kings, requested_nards_long_rules)
	last_action_message = "Mode switched to [get_game_mode_label()]."
	return TRUE

/datum/chess_match/proc/confirm_mode_switch(mob/user)
	if(!can_confirm_mode_switch(user))
		return FALSE
	switch_game_mode(pending_mode, pending_checkers_flying_kings, pending_nards_long_rules)
	last_action_message = "Mode switched to [get_game_mode_label()]."
	return TRUE

/datum/chess_match/proc/cancel_mode_switch(mob/user)
	if(!can_cancel_mode_switch(user))
		return FALSE
	clear_mode_switch_request()
	last_action_message = "The mode change request was canceled."
	return TRUE

/datum/chess_match/proc/switch_game_mode(new_mode, new_checkers_flying_kings = checkers_flying_kings, new_nards_long_rules = nards_long_rules)
	game_mode = new_mode
	checkers_flying_kings = !!new_checkers_flying_kings
	nards_long_rules = !!new_nards_long_rules
	clear_mode_switch_request()
	clear_reset_requests()
	reset_position()

/datum/chess_match/proc/reset_position()
	board = list()
	board.len = 64
	turn = CHESS_WHITE
	paused = TRUE
	game_started = FALSE
	result_text = null
	move_history = list()
	repetition_counts = list()
	last_from = 0
	last_to = 0
	fullmove_number = 1
	last_action_message = null
	overturned = FALSE
	overturn_poses = list()
	overturn_poses.len = 64

	white_castle_king = TRUE
	white_castle_queen = TRUE
	black_castle_king = TRUE
	black_castle_queen = TRUE
	en_passant_square = 0
	halfmove_clock = 0

	nards_points = list()
	nards_points.len = 24
	nards_bar_white = 0
	nards_bar_black = 0
	nards_off_white = 0
	nards_off_black = 0
	nards_die_one = 0
	nards_die_two = 0
	nards_roll_nonce = 0
	nards_available_rolls = list()
	nards_selected_point = 0
	nards_selected_from_bar = FALSE
	nards_scatter = list()
	nards_scatter_dice = list()
	nards_head_moves_this_turn = 0

	forced_capture_from = 0
	pending_turn_notation = null

	if(game_mode == BOARD_MODE_CHESS)
		setup_chess_position()
		register_position()
	else if(game_mode == BOARD_MODE_CHECKERS)
		setup_checkers_position()
	else if(game_mode == BOARD_MODE_NARDS)
		setup_nards_position()

	clear_mode_switch_request()
	clear_reset_requests()
	if(owner)
		owner.update_board_art()

/datum/chess_match/proc/setup_chess_position()
	setup_chess_side(CHESS_WHITE)
	setup_chess_side(CHESS_BLACK)

/datum/chess_match/proc/setup_chess_side(color)
	var/back_rank
	var/pawn_rank
	if(color == CHESS_WHITE)
		back_rank = 1
		pawn_rank = 2
	else
		back_rank = 8
		pawn_rank = 7

	board[chess_square_index(1, back_rank)] = "[color][CHESS_ROOK]"
	board[chess_square_index(2, back_rank)] = "[color][CHESS_KNIGHT]"
	board[chess_square_index(3, back_rank)] = "[color][CHESS_BISHOP]"
	board[chess_square_index(4, back_rank)] = "[color][CHESS_QUEEN]"
	board[chess_square_index(5, back_rank)] = "[color][CHESS_KING]"
	board[chess_square_index(6, back_rank)] = "[color][CHESS_BISHOP]"
	board[chess_square_index(7, back_rank)] = "[color][CHESS_KNIGHT]"
	board[chess_square_index(8, back_rank)] = "[color][CHESS_ROOK]"
	for(var/file = 1, file <= 8, file++)
		board[chess_square_index(file, pawn_rank)] = "[color][CHESS_PAWN]"

/datum/chess_match/proc/setup_checkers_position()
	for(var/rank = 1, rank <= 3, rank++)
		for(var/file = 1, file <= 8, file++)
			if((file + rank) % 2)
				board[chess_square_index(file, rank)] = "[CHESS_WHITE][CHECKERS_MAN]"

	for(var/rank2 = 6, rank2 <= 8, rank2++)
		for(var/file2 = 1, file2 <= 8, file2++)
			if((file2 + rank2) % 2)
				board[chess_square_index(file2, rank2)] = "[CHESS_BLACK][CHECKERS_MAN]"


/datum/chess_match/proc/setup_nards_position()
	if(nards_long_rules)
		nards_set_point(24, CHESS_WHITE, 15)
		nards_set_point(12, CHESS_BLACK, 15)
		return
	nards_set_point(24, CHESS_WHITE, 2)
	nards_set_point(13, CHESS_WHITE, 5)
	nards_set_point(8, CHESS_WHITE, 3)
	nards_set_point(6, CHESS_WHITE, 5)
	nards_set_point(1, CHESS_BLACK, 2)
	nards_set_point(12, CHESS_BLACK, 5)
	nards_set_point(17, CHESS_BLACK, 3)
	nards_set_point(19, CHESS_BLACK, 5)

/datum/chess_match/proc/nards_set_point(point, color, count)
	if(point < 1 || point > 24)
		return
	nards_points[point] = list("color" = color, "count" = count)

/datum/chess_match/proc/nards_point_color(point)
	if(point < 1 || point > 24)
		return null
	var/list/entry = nards_points[point]
	if(!islist(entry))
		return null
	return entry["color"]

/datum/chess_match/proc/nards_point_count(point)
	if(point < 1 || point > 24)
		return 0
	var/list/entry = nards_points[point]
	if(!islist(entry))
		return 0
	return entry["count"]

/datum/chess_match/proc/nards_head_point(color)
	if(color == CHESS_WHITE)
		return 24
	if(nards_long_rules)
		return 12
	return 1

/datum/chess_match/proc/nards_point_is_in_home(color, point)
	if(color == CHESS_WHITE)
		return (point >= 1 && point <= 6)
	if(nards_long_rules)
		return (point >= 13 && point <= 18)
	return (point >= 19 && point <= 24)

/datum/chess_match/proc/nards_bear_off_exact_value(color, from_point)
	if(color == CHESS_WHITE)
		return from_point
	if(nards_long_rules)
		return from_point - 12
	return 25 - from_point

/datum/chess_match/proc/opposite(color)
	if(color == CHESS_WHITE)
		return CHESS_BLACK
	return CHESS_WHITE

/datum/chess_match/proc/side_for_user(mob/user)
	if(!user || !user.ckey)
		return null
	if(white_player_ckey == user.ckey)
		return CHESS_WHITE
	if(black_player_ckey == user.ckey)
		return CHESS_BLACK
	return null

/datum/chess_match/proc/claim_side(color, mob/user)
	if(!user || !user.ckey)
		return FALSE
	if(color != CHESS_WHITE && color != CHESS_BLACK)
		return FALSE
	if(!paused && move_history.len)
		to_chat(user, span_warning("Pause the game before switching seats."))
		return FALSE
	if(color == CHESS_WHITE && black_player_ckey == user.ckey)
		to_chat(user, span_warning("You cannot occupy both seats at the board."))
		return FALSE
	if(color == CHESS_BLACK && white_player_ckey == user.ckey)
		to_chat(user, span_warning("You cannot occupy both seats at the board."))
		return FALSE

	var/display_name = chess_display_name(user)
	if(color == CHESS_WHITE)
		white_player_ckey = user.ckey
		white_player_name = display_name
	else
		black_player_ckey = user.ckey
		black_player_name = display_name

	if(pending_mode && !can_confirm_mode_switch(user) && pending_mode_requester_ckey != user.ckey)
		clear_mode_switch_request()
	clear_reset_requests()
	return TRUE

/datum/chess_match/proc/release_side(color, mob/user)
	if(color != CHESS_WHITE && color != CHESS_BLACK)
		return FALSE
	if(!paused && move_history.len)
		to_chat(user, span_warning("Pause the game before changing players."))
		return FALSE

	if(color == CHESS_WHITE)
		white_player_ckey = null
		white_player_name = null
	else
		black_player_ckey = null
		black_player_name = null

	if(pending_mode)
		clear_mode_switch_request()
	clear_reset_requests()
	return TRUE

/datum/chess_match/proc/pause_game(mob/user)
	paused = TRUE
	return TRUE

/datum/chess_match/proc/can_resign(mob/user)
	if(!game_started || result_text || !side_for_user(user))
		return FALSE

	var/opponent = opposite(side_for_user(user))
	var/opponent_ckey = (opponent == CHESS_WHITE) ? white_player_ckey : black_player_ckey
	return !!opponent_ckey

/datum/chess_match/proc/resign_game(mob/user)
	if(!can_resign(user))
		return FALSE

	var/resigning_side = side_for_user(user)
	var/winning_side = opposite(resigning_side)

	paused = TRUE
	result_text = "Resignation. [chess_side_name(winning_side)] wins."
	owner.play_win_loss_sounds(winning_side)
	return TRUE

/datum/chess_match/proc/resume_game(mob/user)
	if(result_text)
		to_chat(user, span_warning("The game has already ended. Reset the board first."))
		return FALSE
	if(!white_player_ckey || !black_player_ckey)
		to_chat(user, span_warning("Both seats must be occupied before resuming."))
		return FALSE
	paused = FALSE
	game_started = TRUE
	return TRUE

/datum/chess_match/proc/reset_game(mob/user)
	clear_players()
	reset_position()
	return TRUE

/datum/chess_match/proc/can_pack_up()
	if(!paused)
		return FALSE
	if(move_history.len && !result_text && !overturned)
		return FALSE
	return TRUE

/datum/chess_match/proc/can_resume()
	if(game_mode == BOARD_MODE_NONE)
		return FALSE
	if(result_text || overturned)
		return FALSE
	if(!white_player_ckey || !black_player_ckey)
		return FALSE
	return paused

/datum/chess_match/proc/can_select_piece(square, color)
	var/piece = board[square]
	if(!piece || chess_piece_color(piece) != color)
		return FALSE
	if(game_mode == BOARD_MODE_NARDS)
		return FALSE
	if(game_mode == BOARD_MODE_CHECKERS && forced_capture_from && square != forced_capture_from)
		return FALSE
	return TRUE

/datum/chess_match/proc/get_status_text()
	var/list/parts = list()
	parts += "Mode: [get_game_mode_label()]."
	var/current_rules_text = get_current_rules_text()
	if(current_rules_text)
		parts += "[current_rules_text]"

	if(game_mode == BOARD_MODE_NONE)
		parts += "Choose a game using the mode switch button."
		return jointext(parts, " ")

	if(overturned)
		parts += "The board has been flipped. Reset it to put the pieces back in place."
		return jointext(parts, " ")

	if(result_text)
		parts += result_text
		return jointext(parts, " ")

	if(paused)
		parts += "The game is paused."
	else
		parts += "[chess_side_name(turn)] to move."

	if(game_mode == BOARD_MODE_CHESS)
		if(!result_text && !paused && is_in_check(turn))
			parts += "Check."
	else if(game_mode == BOARD_MODE_CHECKERS)
		if(!result_text && !paused && forced_capture_from)
			parts += "[chess_side_name(turn)] must continue capturing with the piece on [chess_square_name(forced_capture_from)]."
	else if(game_mode == BOARD_MODE_NARDS)
		if(nards_available_rolls && nards_available_rolls.len)
			parts += "Available dice: [jointext(nards_available_rolls, ", ")]."
		else if(nards_die_one && nards_die_two)
			parts += "Last roll: [nards_die_one] and [nards_die_two]."
		else
			parts += "Roll the dice to begin your turn."

	return jointext(parts, " ")

/datum/chess_match/proc/move_requires_promotion(from_idx, to_idx)
	if(game_mode != BOARD_MODE_CHESS)
		return FALSE
	var/piece = board[from_idx]
	if(!piece || chess_piece_type(piece) != CHESS_PAWN)
		return FALSE
	var/rank = chess_square_rank(to_idx)
	var/color = chess_piece_color(piece)
	if(color == CHESS_WHITE && rank == 8)
		return TRUE
	if(color == CHESS_BLACK && rank == 1)
		return TRUE
	return FALSE

/datum/chess_match/proc/get_legal_targets(from_idx)
	if(overturned)
		return list()
	if(game_mode == BOARD_MODE_CHECKERS)
		return get_checkers_legal_targets(from_idx)
	return get_chess_legal_targets(from_idx)

/datum/chess_match/proc/try_move(from_idx, to_idx, mob/user, promotion_choice)
	if(game_mode == BOARD_MODE_NARDS)
		return FALSE
	if(game_mode == BOARD_MODE_CHECKERS)
		return try_checkers_move(from_idx, to_idx, user)
	return try_chess_move(from_idx, to_idx, user, promotion_choice)

/datum/chess_match/proc/get_chess_legal_targets(from_idx)
	var/list/targets = list()
	var/piece = board[from_idx]
	if(!piece)
		return targets
	for(var/to_idx = 1, to_idx <= 64, to_idx++)
		if(is_chess_legal_move(from_idx, to_idx, null))
			targets += to_idx
	return targets

/datum/chess_match/proc/try_chess_move(from_idx, to_idx, mob/user, promotion_choice)
	if(overturned)
		to_chat(user, span_warning("The board has been flipped. Reset it first."))
		return FALSE
	if(paused || result_text)
		return FALSE
	if(!is_chess_legal_move(from_idx, to_idx, promotion_choice))
		to_chat(user, span_warning("That move is not legal."))
		return FALSE

	var/list/move_info = apply_chess_move(from_idx, to_idx, promotion_choice)
	last_from = from_idx
	last_to = to_idx
	turn = opposite(turn)
	if(turn == CHESS_WHITE)
		fullmove_number++

	register_position()
	resolve_chess_end_state(move_info)
	if(move_info["captured"])
		playsound(owner, CHESS_SOUND_CAPTURE, 60, FALSE)
	else
		playsound(owner, CHESS_SOUND_MOVE, 55, FALSE)
	last_action_message = "Move played: [move_info["notation"]]."
	return TRUE

/datum/chess_match/proc/resolve_chess_end_state(list/move_info)
	var/enemy = turn
	var/gives_check = is_in_check(enemy)
	var/no_moves = !has_any_chess_legal_move(enemy)

	if(no_moves)
		if(gives_check)
			result_text = "Checkmate. [chess_side_name(opposite(enemy))] wins."
		else
			result_text = "Draw by stalemate."
			paused = TRUE


	if(!result_text)
		var/key = position_key()
		var/current_count = chess_assoc_get(repetition_counts, key, 0)
		if(current_count >= 3)
			result_text = "Draw by threefold repetition."
			paused = TRUE

	var/notation = move_info["notation"]
	if(gives_check)
		if(result_text && findtext(result_text, "Checkmate"))
			notation += "#"
		else
			notation += "+"
	move_history += notation

	if(result_text)
		paused = TRUE
		if(findtext(result_text, "Checkmate"))
			owner.play_win_loss_sounds(opposite(enemy))
	else if(gives_check)
		owner.play_check_alert()

/datum/chess_match/proc/register_position()
	if(game_mode != BOARD_MODE_CHESS)
		return
	var/key = position_key()
	var/current_count = chess_assoc_get(repetition_counts, key, 0)
	repetition_counts[key] = current_count + 1

/datum/chess_match/proc/position_key()
	var/key = ""
	for(var/i = 1, i <= 64, i++)
		if(board[i])
			key += "[board[i]]"
		else
			key += "--"
	key += "|[turn]|[white_castle_king]|[white_castle_queen]|[black_castle_king]|[black_castle_queen]|[en_passant_square]"
	return key

/datum/chess_match/proc/find_king(color)
	for(var/i = 1, i <= 64, i++)
		if(board[i] == "[color][CHESS_KING]")
			return i
	return 0

/datum/chess_match/proc/is_in_check(color)
	var/king_square = find_king(color)
	if(!king_square)
		return FALSE
	return is_square_attacked(king_square, opposite(color))

/datum/chess_match/proc/is_square_attacked(square, by_color)
	var/file = chess_square_file(square)
	var/rank = chess_square_rank(square)
	var/pawn_rank_offset = (by_color == CHESS_WHITE) ? -1 : 1

	for(var/file_delta in list(-1, 1))
		var/pawn_file = file + file_delta
		var/pawn_rank = rank + pawn_rank_offset
		if(pawn_file >= 1 && pawn_file <= 8 && pawn_rank >= 1 && pawn_rank <= 8)
			if(board[chess_square_index(pawn_file, pawn_rank)] == "[by_color][CHESS_PAWN]")
				return TRUE

	var/list/knight_steps = list(
		list(1, 2), list(2, 1), list(-1, 2), list(-2, 1),
		list(1, -2), list(2, -1), list(-1, -2), list(-2, -1)
	)
	for(var/list/step in knight_steps)
		var/nf = file + step[1]
		var/nr = rank + step[2]
		if(nf < 1 || nf > 8 || nr < 1 || nr > 8)
			continue
		if(board[chess_square_index(nf, nr)] == "[by_color][CHESS_KNIGHT]")
			return TRUE

	if(ray_attacked(square, by_color, list(1, 0), list(CHESS_ROOK, CHESS_QUEEN))) return TRUE
	if(ray_attacked(square, by_color, list(-1, 0), list(CHESS_ROOK, CHESS_QUEEN))) return TRUE
	if(ray_attacked(square, by_color, list(0, 1), list(CHESS_ROOK, CHESS_QUEEN))) return TRUE
	if(ray_attacked(square, by_color, list(0, -1), list(CHESS_ROOK, CHESS_QUEEN))) return TRUE
	if(ray_attacked(square, by_color, list(1, 1), list(CHESS_BISHOP, CHESS_QUEEN))) return TRUE
	if(ray_attacked(square, by_color, list(1, -1), list(CHESS_BISHOP, CHESS_QUEEN))) return TRUE
	if(ray_attacked(square, by_color, list(-1, 1), list(CHESS_BISHOP, CHESS_QUEEN))) return TRUE
	if(ray_attacked(square, by_color, list(-1, -1), list(CHESS_BISHOP, CHESS_QUEEN))) return TRUE

	for(var/df = -1, df <= 1, df++)
		for(var/dr = -1, dr <= 1, dr++)
			if(!df && !dr)
				continue
			var/kf = file + df
			var/kr = rank + dr
			if(kf < 1 || kf > 8 || kr < 1 || kr > 8)
				continue
			if(board[chess_square_index(kf, kr)] == "[by_color][CHESS_KING]")
				return TRUE

	return FALSE

/datum/chess_match/proc/ray_attacked(square, by_color, list/delta, list/threat_types)
	var/file = chess_square_file(square)
	var/rank = chess_square_rank(square)
	var/df = delta[1]
	var/dr = delta[2]
	var/cf = file + df
	var/cr = rank + dr

	while(cf >= 1 && cf <= 8 && cr >= 1 && cr <= 8)
		var/piece = board[chess_square_index(cf, cr)]
		if(piece)
			if(chess_piece_color(piece) == by_color && (chess_piece_type(piece) in threat_types))
				return TRUE
			return FALSE
		cf += df
		cr += dr

	return FALSE

/datum/chess_match/proc/has_any_chess_legal_move(color)
	var/original_turn = turn
	turn = color

	for(var/from_idx = 1, from_idx <= 64, from_idx++)
		var/piece = board[from_idx]
		if(!piece || chess_piece_color(piece) != color)
			continue
		for(var/to_idx = 1, to_idx <= 64, to_idx++)
			if(is_chess_legal_move(from_idx, to_idx, null))
				turn = original_turn
				return TRUE

	turn = original_turn
	return FALSE

/datum/chess_match/proc/is_chess_legal_move(from_idx, to_idx, promotion_choice)
	if(from_idx == to_idx)
		return FALSE
	var/piece = board[from_idx]
	if(!piece)
		return FALSE

	var/color = chess_piece_color(piece)
	if(color != turn)
		return FALSE

	var/target = board[to_idx]
	if(target && chess_piece_color(target) == color)
		return FALSE

	if(!is_chess_pseudo_legal_move(from_idx, to_idx))
		return FALSE

	var/list/snapshot = make_snapshot()
	apply_chess_move(from_idx, to_idx, promotion_choice, TRUE)
	var/in_check = is_in_check(color)
	restore_snapshot(snapshot)
	return !in_check

/datum/chess_match/proc/is_chess_pseudo_legal_move(from_idx, to_idx)
	var/piece = board[from_idx]
	var/color = chess_piece_color(piece)
	var/piece_type = chess_piece_type(piece)
	var/from_file = chess_square_file(from_idx)
	var/from_rank = chess_square_rank(from_idx)
	var/to_file = chess_square_file(to_idx)
	var/to_rank = chess_square_rank(to_idx)
	var/file_diff = to_file - from_file
	var/rank_diff = to_rank - from_rank
	var/target = board[to_idx]

	switch(piece_type)
		if(CHESS_PAWN)
			var/dir = (color == CHESS_WHITE) ? 1 : -1
			var/start_rank = (color == CHESS_WHITE) ? 2 : 7
			if(!file_diff)
				if(rank_diff == dir && !target)
					return TRUE
				if(rank_diff == (dir * 2) && from_rank == start_rank && !target)
					var/intermediate_rank = from_rank + dir
					if(!board[chess_square_index(from_file, intermediate_rank)])
						return TRUE
			else if(abs(file_diff) == 1 && rank_diff == dir)
				if(target && chess_piece_color(target) != color)
					return TRUE
				if(to_idx == en_passant_square)
					return TRUE
			return FALSE

		if(CHESS_ROOK)
			if(file_diff && rank_diff)
				return FALSE
			return is_path_clear(from_idx, to_idx)

		if(CHESS_BISHOP)
			if(abs(file_diff) != abs(rank_diff))
				return FALSE
			return is_path_clear(from_idx, to_idx)

		if(CHESS_QUEEN)
			if(file_diff && rank_diff && abs(file_diff) != abs(rank_diff))
				return FALSE
			return is_path_clear(from_idx, to_idx)

		if(CHESS_KNIGHT)
			if((abs(file_diff) == 2 && abs(rank_diff) == 1) || (abs(file_diff) == 1 && abs(rank_diff) == 2))
				return TRUE
			return FALSE

		if(CHESS_KING)
			if(abs(file_diff) <= 1 && abs(rank_diff) <= 1)
				return TRUE
			if(!rank_diff && abs(file_diff) == 2)
				return can_castle(color, from_idx, to_idx)
			return FALSE

	return FALSE

/datum/chess_match/proc/is_path_clear(from_idx, to_idx)
	var/from_file = chess_square_file(from_idx)
	var/from_rank = chess_square_rank(from_idx)
	var/to_file = chess_square_file(to_idx)
	var/to_rank = chess_square_rank(to_idx)
	var/step_file = sign(to_file - from_file)
	var/step_rank = sign(to_rank - from_rank)
	var/file = from_file + step_file
	var/rank = from_rank + step_rank

	while(file != to_file || rank != to_rank)
		if(board[chess_square_index(file, rank)])
			return FALSE
		file += step_file
		rank += step_rank

	return TRUE

/datum/chess_match/proc/can_castle(color, from_idx, to_idx)
	if(is_in_check(color))
		return FALSE

	var/rank = (color == CHESS_WHITE) ? 1 : 8
	if(from_idx != chess_square_index(5, rank))
		return FALSE

	if(to_idx == chess_square_index(7, rank))
		if(color == CHESS_WHITE && !white_castle_king)
			return FALSE
		if(color == CHESS_BLACK && !black_castle_king)
			return FALSE
		if(board[chess_square_index(6, rank)] || board[chess_square_index(7, rank)])
			return FALSE
		if(is_square_attacked(chess_square_index(6, rank), opposite(color)))
			return FALSE
		if(is_square_attacked(chess_square_index(7, rank), opposite(color)))
			return FALSE
		if(board[chess_square_index(8, rank)] != "[color][CHESS_ROOK]")
			return FALSE
		return TRUE

	if(to_idx == chess_square_index(3, rank))
		if(color == CHESS_WHITE && !white_castle_queen)
			return FALSE
		if(color == CHESS_BLACK && !black_castle_queen)
			return FALSE
		if(board[chess_square_index(2, rank)] || board[chess_square_index(3, rank)] || board[chess_square_index(4, rank)])
			return FALSE
		if(is_square_attacked(chess_square_index(4, rank), opposite(color)))
			return FALSE
		if(is_square_attacked(chess_square_index(3, rank), opposite(color)))
			return FALSE
		if(board[chess_square_index(1, rank)] != "[color][CHESS_ROOK]")
			return FALSE
		return TRUE

	return FALSE

/datum/chess_match/proc/make_snapshot()
	return list(
		"board" = board.Copy(),
		"turn" = turn,
		"white_castle_king" = white_castle_king,
		"white_castle_queen" = white_castle_queen,
		"black_castle_king" = black_castle_king,
		"black_castle_queen" = black_castle_queen,
		"en_passant_square" = en_passant_square,
		"halfmove_clock" = halfmove_clock,
		"fullmove_number" = fullmove_number,
		"last_from" = last_from,
		"last_to" = last_to
	)

/datum/chess_match/proc/restore_snapshot(list/snapshot)
	board = snapshot["board"]
	turn = snapshot["turn"]
	white_castle_king = snapshot["white_castle_king"]
	white_castle_queen = snapshot["white_castle_queen"]
	black_castle_king = snapshot["black_castle_king"]
	black_castle_queen = snapshot["black_castle_queen"]
	en_passant_square = snapshot["en_passant_square"]
	halfmove_clock = snapshot["halfmove_clock"]
	fullmove_number = snapshot["fullmove_number"]
	last_from = snapshot["last_from"]
	last_to = snapshot["last_to"]

/datum/chess_match/proc/apply_chess_move(from_idx, to_idx, promotion_choice, dry_run = FALSE)
	var/piece = board[from_idx]
	var/color = chess_piece_color(piece)
	var/piece_type = chess_piece_type(piece)
	var/target_piece = board[to_idx]
	var/captured_piece = target_piece
	var/was_capture = !!target_piece
	var/was_castle = FALSE
	var/was_kingside_castle = FALSE
	var/from_file = chess_square_file(from_idx)
	var/from_rank = chess_square_rank(from_idx)
	var/to_file = chess_square_file(to_idx)
	var/to_rank = chess_square_rank(to_idx)

	var/old_en_passant = en_passant_square
	en_passant_square = 0

	if(piece_type == CHESS_PAWN && to_idx == old_en_passant && !target_piece && abs(to_file - from_file) == 1)
		var/capture_rank = (color == CHESS_WHITE) ? (to_rank - 1) : (to_rank + 1)
		var/capture_idx = chess_square_index(to_file, capture_rank)
		captured_piece = board[capture_idx]
		board[capture_idx] = null
		was_capture = TRUE

	board[to_idx] = piece
	board[from_idx] = null

	if(piece_type == CHESS_KING)
		if(color == CHESS_WHITE)
			white_castle_king = FALSE
			white_castle_queen = FALSE
		else
			black_castle_king = FALSE
			black_castle_queen = FALSE

		if(abs(to_file - from_file) == 2)
			was_castle = TRUE
			var/rank = from_rank
			if(to_file > from_file)
				was_kingside_castle = TRUE
				board[chess_square_index(6, rank)] = board[chess_square_index(8, rank)]
				board[chess_square_index(8, rank)] = null
			else
				board[chess_square_index(4, rank)] = board[chess_square_index(1, rank)]
				board[chess_square_index(1, rank)] = null

	if(piece_type == CHESS_ROOK)
		if(color == CHESS_WHITE)
			if(from_idx == chess_square_index(1, 1))
				white_castle_queen = FALSE
			if(from_idx == chess_square_index(8, 1))
				white_castle_king = FALSE
		else
			if(from_idx == chess_square_index(1, 8))
				black_castle_queen = FALSE
			if(from_idx == chess_square_index(8, 8))
				black_castle_king = FALSE

	if(captured_piece == "[CHESS_WHITE][CHESS_ROOK]")
		if(to_idx == chess_square_index(1, 1))
			white_castle_queen = FALSE
		if(to_idx == chess_square_index(8, 1))
			white_castle_king = FALSE
	if(captured_piece == "[CHESS_BLACK][CHESS_ROOK]")
		if(to_idx == chess_square_index(1, 8))
			black_castle_queen = FALSE
		if(to_idx == chess_square_index(8, 8))
			black_castle_king = FALSE

	var/promoted_to = null
	if(piece_type == CHESS_PAWN)
		if(abs(to_rank - from_rank) == 2)
			en_passant_square = chess_square_index(from_file, from_rank + ((to_rank - from_rank) / 2))
		if((color == CHESS_WHITE && to_rank == 8) || (color == CHESS_BLACK && to_rank == 1))
			promoted_to = normalize_promotion_choice(promotion_choice)
			board[to_idx] = "[color][promoted_to]"

	if(piece_type == CHESS_PAWN || was_capture)
		halfmove_clock = 0
	else
		halfmove_clock++

	var/notation = build_move_notation(piece, from_idx, to_idx, was_capture, was_castle, was_kingside_castle, promoted_to)
	return list(
		"piece" = piece,
		"captured" = captured_piece,
		"notation" = notation
	)

/datum/chess_match/proc/normalize_promotion_choice(choice)
	if(!choice)
		return CHESS_QUEEN
	switch(LOWER_TEXT("[choice]"))
		if("queen")
			return CHESS_QUEEN
		if("rook")
			return CHESS_ROOK
		if("bishop")
			return CHESS_BISHOP
		if("knight")
			return CHESS_KNIGHT
	return CHESS_QUEEN

/datum/chess_match/proc/build_move_notation(piece, from_idx, to_idx, was_capture, was_castle, was_kingside_castle, promoted_to)
	if(was_castle)
		if(was_kingside_castle)
			return "O-O"
		return "O-O-O"

	var/piece_type = chess_piece_type(piece)
	var/text = chess_piece_letter(piece_type)
	if(piece_type == CHESS_PAWN && was_capture)
		text = ascii2text(96 + chess_square_file(from_idx))
	if(was_capture)
		text += "x"
	text += chess_square_name(to_idx)
	if(promoted_to)
		text += "="
		text += chess_piece_letter(promoted_to)
	return text

/datum/chess_match/proc/get_checkers_legal_targets(from_idx)
	var/list/targets = list()
	var/piece = board[from_idx]
	if(!piece)
		return targets
	if(chess_piece_color(piece) != turn)
		return targets
	if(forced_capture_from && from_idx != forced_capture_from)
		return targets

	var/must_capture = checkers_any_capture(turn)
	if(must_capture)
		return get_checkers_capture_targets(from_idx)
	return get_checkers_simple_targets(from_idx)

/datum/chess_match/proc/get_checkers_simple_targets(from_idx)
	var/list/targets = list()
	var/piece = board[from_idx]
	if(!piece)
		return targets

	var/color = chess_piece_color(piece)
	var/piece_type = chess_piece_type(piece)
	var/from_file = chess_square_file(from_idx)
	var/from_rank = chess_square_rank(from_idx)

	if(piece_type == CHECKERS_KING && checkers_flying_kings)
		for(var/list/step in list(list(1, 1), list(-1, 1), list(1, -1), list(-1, -1)))
			var/to_file = from_file + step[1]
			var/to_rank = from_rank + step[2]
			while(to_file >= 1 && to_file <= 8 && to_rank >= 1 && to_rank <= 8)
				var/to_idx = chess_square_index(to_file, to_rank)
				if(board[to_idx])
					break
				targets += to_idx
				to_file += step[1]
				to_rank += step[2]
		return targets

	var/list/dirs = list()
	if(piece_type == CHECKERS_KING)
		dirs += list(list(1, 1), list(-1, 1), list(1, -1), list(-1, -1))
	else
		var/forward = (color == CHESS_WHITE) ? 1 : -1
		dirs += list(list(1, forward), list(-1, forward))

	for(var/list/step in dirs)
		var/to_file = from_file + step[1]
		var/to_rank = from_rank + step[2]
		if(to_file < 1 || to_file > 8 || to_rank < 1 || to_rank > 8)
			continue
		var/to_idx = chess_square_index(to_file, to_rank)
		if(!board[to_idx])
			targets += to_idx

	return targets

/datum/chess_match/proc/get_checkers_capture_targets(from_idx)
	var/list/targets = list()
	var/piece = board[from_idx]
	if(!piece)
		return targets

	var/color = chess_piece_color(piece)
	var/piece_type = chess_piece_type(piece)
	var/from_file = chess_square_file(from_idx)
	var/from_rank = chess_square_rank(from_idx)

	if(piece_type == CHECKERS_KING && checkers_flying_kings)
		for(var/list/step in list(list(1, 1), list(-1, 1), list(1, -1), list(-1, -1)))
			var/to_file = from_file + step[1]
			var/to_rank = from_rank + step[2]
			var/enemy_found = FALSE
			while(to_file >= 1 && to_file <= 8 && to_rank >= 1 && to_rank <= 8)
				var/to_idx = chess_square_index(to_file, to_rank)
				var/target_piece = board[to_idx]
				if(!target_piece)
					if(enemy_found)
						targets += to_idx
				else if(chess_piece_color(target_piece) == color)
					break
				else
					if(enemy_found)
						break
					enemy_found = TRUE
				to_file += step[1]
				to_rank += step[2]
		return targets

	var/list/dirs = list()
	if(piece_type == CHECKERS_KING)
		dirs += list(list(1, 1), list(-1, 1), list(1, -1), list(-1, -1))
	else
		var/forward = (color == CHESS_WHITE) ? 1 : -1
		dirs += list(list(1, forward), list(-1, forward))

	for(var/list/step in dirs)
		var/mid_file = from_file + step[1]
		var/mid_rank = from_rank + step[2]
		var/to_file = from_file + (step[1] * 2)
		var/to_rank = from_rank + (step[2] * 2)

		if(to_file < 1 || to_file > 8 || to_rank < 1 || to_rank > 8)
			continue
		var/mid_idx = chess_square_index(mid_file, mid_rank)
		var/to_idx = chess_square_index(to_file, to_rank)
		var/mid_piece = board[mid_idx]
		if(mid_piece && chess_piece_color(mid_piece) == opposite(color) && !board[to_idx])
			targets += to_idx

	return targets

/datum/chess_match/proc/checkers_piece_has_capture(from_idx)
	var/list/targets = get_checkers_capture_targets(from_idx)
	return !!targets.len

/datum/chess_match/proc/checkers_any_capture(color)
	for(var/i = 1, i <= 64, i++)
		var/piece = board[i]
		if(!piece || chess_piece_color(piece) != color)
			continue
		if(checkers_piece_has_capture(i))
			return TRUE
	return FALSE

/datum/chess_match/proc/get_checkers_captured_index(from_idx, to_idx)
	var/piece = board[from_idx]
	if(!piece)
		return 0
	var/piece_type = chess_piece_type(piece)
	var/from_file = chess_square_file(from_idx)
	var/from_rank = chess_square_rank(from_idx)
	var/to_file = chess_square_file(to_idx)
	var/to_rank = chess_square_rank(to_idx)

	if(piece_type == CHECKERS_KING && checkers_flying_kings)
		var/step_file = sign(to_file - from_file)
		var/step_rank = sign(to_rank - from_rank)
		if(!step_file || !step_rank || abs(to_file - from_file) != abs(to_rank - from_rank))
			return 0
		var/file = from_file + step_file
		var/rank = from_rank + step_rank
		var/captured_idx = 0
		while(file != to_file || rank != to_rank)
			var/test_idx = chess_square_index(file, rank)
			var/test_piece = board[test_idx]
			if(test_piece)
				if(chess_piece_color(test_piece) == chess_piece_color(piece))
					return 0
				if(captured_idx)
					return 0
				captured_idx = test_idx
			file += step_file
			rank += step_rank
		return captured_idx

	if(abs(to_file - from_file) == 2 && abs(to_rank - from_rank) == 2)
		return chess_square_index(from_file + ((to_file - from_file) / 2), from_rank + ((to_rank - from_rank) / 2))
	return 0

/datum/chess_match/proc/is_checkers_legal_move(from_idx, to_idx)
	if(from_idx == to_idx)
		return FALSE
	var/piece = board[from_idx]
	if(!piece)
		return FALSE
	if(chess_piece_color(piece) != turn)
		return FALSE
	if(board[to_idx])
		return FALSE
	if(forced_capture_from && from_idx != forced_capture_from)
		return FALSE

	var/list/legal_targets = get_checkers_legal_targets(from_idx)
	return (to_idx in legal_targets)

/datum/chess_match/proc/has_any_checkers_legal_move(color)
	var/original_turn = turn
	var/original_forced = forced_capture_from
	turn = color
	forced_capture_from = 0

	for(var/i = 1, i <= 64, i++)
		var/piece = board[i]
		if(!piece || chess_piece_color(piece) != color)
			continue
		var/list/targets = get_checkers_legal_targets(i)
		if(targets.len)
			turn = original_turn
			forced_capture_from = original_forced
			return TRUE

	turn = original_turn
	forced_capture_from = original_forced
	return FALSE

/datum/chess_match/proc/try_checkers_move(from_idx, to_idx, mob/user)
	if(overturned)
		to_chat(user, span_warning("The board has been flipped. Reset it first."))
		return FALSE
	if(paused || result_text)
		return FALSE
	if(!is_checkers_legal_move(from_idx, to_idx))
		to_chat(user, span_warning("That move is not legal."))
		return FALSE

	var/list/move_info = apply_checkers_move(from_idx, to_idx)
	last_from = from_idx
	last_to = to_idx

	var/notation = move_info["notation"]
	var/was_capture = move_info["was_capture"]
	var/continue_capture = move_info["continue_capture"]
	playsound(owner, was_capture ? CHESS_SOUND_CAPTURE : CHESS_SOUND_CHECKERS_MOVE, 55, FALSE)

	if(was_capture)
		if(!pending_turn_notation)
			pending_turn_notation = notation
		else
			pending_turn_notation += "x[chess_square_name(to_idx)]"
	else
		pending_turn_notation = null
		move_history += notation

	if(continue_capture)
		forced_capture_from = to_idx
		last_action_message = "Continue capturing with the same checker from [chess_square_name(to_idx)]."
		return TRUE

	forced_capture_from = 0
	if(was_capture)
		move_history += pending_turn_notation
		pending_turn_notation = null

	turn = opposite(turn)
	if(turn == CHESS_WHITE)
		fullmove_number++

	resolve_checkers_end_state()
	if(result_text)
		last_action_message = result_text
	else
		last_action_message = "Turn complete."
	return TRUE

/datum/chess_match/proc/apply_checkers_move(from_idx, to_idx)
	var/piece = board[from_idx]
	var/color = chess_piece_color(piece)
	var/piece_type = chess_piece_type(piece)
	var/to_rank = chess_square_rank(to_idx)

	var/was_capture = FALSE
	var/captured_idx = get_checkers_captured_index(from_idx, to_idx)
	if(captured_idx)
		board[captured_idx] = null
		was_capture = TRUE

	board[to_idx] = piece
	board[from_idx] = null

	var/promoted = FALSE
	if(piece_type == CHECKERS_MAN)
		if((color == CHESS_WHITE && to_rank == 8) || (color == CHESS_BLACK && to_rank == 1))
			board[to_idx] = "[color][CHECKERS_KING]"
			promoted = TRUE

	var/continue_capture = FALSE
	if(was_capture && !promoted && checkers_piece_has_capture(to_idx))
		continue_capture = TRUE

	var/separator = was_capture ? "x" : "-"
	var/notation = "[chess_square_name(from_idx)][separator][chess_square_name(to_idx)]"

	return list(
		"notation" = notation,
		"was_capture" = was_capture,
		"continue_capture" = continue_capture
	)

/datum/chess_match/proc/count_pieces(color)
	var/count = 0
	for(var/i = 1, i <= 64, i++)
		if(board[i] && chess_piece_color(board[i]) == color)
			count++
	return count

/datum/chess_match/proc/resolve_checkers_end_state()
	var/enemy = turn
	if(count_pieces(enemy) <= 0)
		result_text = "Game over. [chess_side_name(opposite(enemy))] wins."
	else if(!has_any_checkers_legal_move(enemy))
		result_text = "[chess_side_name(enemy)] has no legal moves. [chess_side_name(opposite(enemy))] wins."

	if(result_text)
		paused = TRUE
		owner.play_win_loss_sounds(opposite(enemy))

/datum/chess_match/proc/can_roll_nards_dice(mob/user)
	if(game_mode != BOARD_MODE_NARDS || paused || result_text || overturned)
		return FALSE
	if(!user)
		return FALSE
	var/side = side_for_user(user)
	if(!side || side != turn)
		return FALSE
	if(nards_available_rolls && nards_available_rolls.len)
		return FALSE
	return TRUE

/datum/chess_match/proc/roll_nards_dice(mob/user)
	if(!can_roll_nards_dice(user))
		if(user)
			to_chat(user, span_warning("You cannot roll the dice right now."))
		return FALSE
	nards_die_one = rand(1, 6)
	nards_die_two = rand(1, 6)
	nards_roll_nonce++
	playsound(owner, pick(CHESS_SOUND_DICE1, CHESS_SOUND_DICE2, CHESS_SOUND_DICE3), 60, FALSE)
	nards_available_rolls = list()
	if(nards_die_one == nards_die_two)
		for(var/i = 1, i <= 4, i++)
			nards_available_rolls += nards_die_one
	else
		nards_available_rolls += nards_die_one
		nards_available_rolls += nards_die_two
	nards_selected_point = 0
	nards_selected_from_bar = FALSE
	last_action_message = "[chess_display_name(user)] rolls the dice: [nards_die_one] and [nards_die_two]."
	if(!nards_has_any_legal_move(turn))
		last_action_message += " No legal moves; the turn passes to the opponent."
		nards_end_turn()
	return TRUE

/datum/chess_match/proc/nards_bar_count(color)
	if(color == CHESS_WHITE)
		return nards_bar_white
	if(color == CHESS_BLACK)
		return nards_bar_black
	return 0

/datum/chess_match/proc/nards_set_bar_count(color, value)
	value = max(0, text2num("[value]"))
	if(color == CHESS_WHITE)
		nards_bar_white = value
	else if(color == CHESS_BLACK)
		nards_bar_black = value

/datum/chess_match/proc/nards_set_off_count(color, value)
	value = max(0, text2num("[value]"))
	if(color == CHESS_WHITE)
		nards_off_white = value
	else if(color == CHESS_BLACK)
		nards_off_black = value

/datum/chess_match/proc/nards_total_checkers()
	return nards_bar_white + nards_bar_black + nards_off_white + nards_off_black + nards_total_on_points()

/datum/chess_match/proc/nards_total_on_points()
	var/total = 0
	for(var/point = 1, point <= 24, point++)
		total += nards_point_count(point)
	return total

/datum/chess_match/proc/nards_clear_selection()
	nards_selected_point = 0
	nards_selected_from_bar = FALSE

/datum/chess_match/proc/get_nards_legal_targets_for_user(mob/user) as /list
	var/list/targets = list()
	if(game_mode != BOARD_MODE_NARDS || paused || result_text || overturned)
		return targets
	if(!user)
		return targets
	var/side = side_for_user(user)
	if(!side || side != turn)
		return targets
	if(nards_selected_from_bar)
		return get_nards_legal_targets(side, 0, TRUE)
	if(nards_selected_point)
		return get_nards_legal_targets(side, nards_selected_point, FALSE)
	return targets

/datum/chess_match/proc/nards_points_for_color(color)
	var/list/out = list()
	for(var/point = 1, point <= 24, point++)
		if(nards_point_color(point) == color)
			out += point
	return out

/datum/chess_match/proc/nards_all_in_home(color)
	if(!nards_long_rules && nards_bar_count(color) > 0)
		return FALSE
	for(var/point = 1, point <= 24, point++)
		if(nards_point_color(point) != color)
			continue
		if(!nards_point_is_in_home(color, point))
			return FALSE
	return TRUE

/datum/chess_match/proc/nards_has_farther_checker_for_bear_off(color, from_point)
	if(color == CHESS_WHITE)
		for(var/point = from_point + 1, point <= 6, point++)
			if(nards_point_color(point) == color)
				return TRUE
	else if(nards_long_rules)
		for(var/point = from_point + 1, point <= 18, point++)
			if(nards_point_color(point) == color)
				return TRUE
	else
		for(var/point = 19, point < from_point, point++)
			if(nards_point_color(point) == color)
				return TRUE
	return FALSE

/datum/chess_match/proc/nards_can_land_on_point(color, point)
	if(point < 1 || point > 24)
		return FALSE
	var/target_color = nards_point_color(point)
	var/target_count = nards_point_count(point)
	if(!target_color || !target_count)
		return TRUE
	if(target_color == color)
		return TRUE
	if(nards_long_rules)
		return FALSE
	return target_count <= 1

/datum/chess_match/proc/nards_get_destination_for_die(color, from_point, die, from_bar = FALSE)
	die = text2num("[die]")
	if(die <= 0)
		return null
	if(nards_long_rules)
		if(from_bar)
			return null
		return chess_wrap_point_24(from_point - die)
	if(from_bar)
		if(color == CHESS_WHITE)
			return 25 - die
		return die
	if(color == CHESS_WHITE)
		return from_point - die
	return from_point + die

/datum/chess_match/proc/nards_can_bear_off_with_die(color, from_point, die)
	if(!nards_all_in_home(color))
		return FALSE
	var/exact = nards_bear_off_exact_value(color, from_point) - die
	if(exact == 0)
		return TRUE
	if(exact < 0 && !nards_has_farther_checker_for_bear_off(color, from_point))
		return TRUE
	return FALSE

/datum/chess_match/proc/get_nards_legal_targets(color, from_point, from_bar = FALSE) as /list
	var/list/targets = list()
	if(game_mode != BOARD_MODE_NARDS || !nards_available_rolls || !nards_available_rolls.len)
		return targets
	if(from_bar)
		if(nards_long_rules)
			return targets
		if(nards_bar_count(color) <= 0)
			return targets
	else
		if(from_point < 1 || from_point > 24)
			return targets
		if(nards_point_color(from_point) != color || nards_point_count(from_point) <= 0)
			return targets
		if(!nards_long_rules && nards_bar_count(color) > 0)
			return targets
		if(nards_long_rules && from_point == nards_head_point(color) && nards_head_moves_this_turn >= 1)
			return targets
	var/all_in_home = !from_bar && nards_all_in_home(color)
	for(var/die in nards_available_rolls)
		var/d = text2num("[die]")
		if(!from_bar && nards_can_bear_off_with_die(color, from_point, d))
			if(!(0 in targets))
				targets += 0
			if(nards_long_rules)
				continue
		if(nards_long_rules && all_in_home)
			var/raw_destination = from_point - d
			if(!nards_point_is_in_home(color, raw_destination))
				continue
			if(nards_can_land_on_point(color, raw_destination) && !(raw_destination in targets))
				targets += raw_destination
			continue
		var/destination = nards_get_destination_for_die(color, from_point, d, from_bar)
		if(destination >= 1 && destination <= 24)
			if(nards_can_land_on_point(color, destination) && !(destination in targets))
				targets += destination
	return targets

/datum/chess_match/proc/nards_find_die_for_move(color, from_point, to_point, from_bar = FALSE, to_off = FALSE)
	var/list/candidates = list()
	for(var/die in nards_available_rolls)
		var/d = text2num("[die]")
		var/destination = nards_get_destination_for_die(color, from_point, d, from_bar)
		if(to_off)
			if(!from_bar && nards_can_bear_off_with_die(color, from_point, d))
				candidates += d
		else if(destination == to_point)
			candidates += d
	if(!candidates.len)
		return 0
	if(to_off)
		var/exact = nards_bear_off_exact_value(color, from_point)
		for(var/value in candidates)
			if(text2num("[value]") == exact)
				return exact
		var/best = 0
		for(var/value2 in candidates)
			var/num = text2num("[value2]")
			if(!best || num < best)
				best = num
		return best
	return text2num("[candidates[1]]")

/datum/chess_match/proc/nards_consume_die(value)
	if(!nards_available_rolls || !nards_available_rolls.len)
		return
	for(var/i = 1, i <= nards_available_rolls.len, i++)
		if(text2num("[nards_available_rolls[i]]") == value)
			nards_available_rolls.Cut(i, i + 1)
			return

/datum/chess_match/proc/nards_end_turn()
	nards_clear_selection()
	nards_available_rolls = list()
	nards_head_moves_this_turn = 0
	turn = opposite(turn)
	if(turn == CHESS_WHITE)
		fullmove_number++

/datum/chess_match/proc/nards_has_any_legal_move(color)
	if(!nards_available_rolls || !nards_available_rolls.len)
		return FALSE
	if(nards_bar_count(color) > 0)
		var/list/bar_targets = get_nards_legal_targets(color, 0, TRUE)
		return bar_targets.len > 0
	for(var/point = 1, point <= 24, point++)
		if(nards_point_color(point) != color || nards_point_count(point) <= 0)
			continue
		var/list/point_targets = get_nards_legal_targets(color, point, FALSE)
		if(point_targets.len)
			return TRUE
	return FALSE

/datum/chess_match/proc/select_nards_point(mob/user, point)
	if(game_mode != BOARD_MODE_NARDS || paused || result_text || overturned)
		return FALSE
	var/color = side_for_user(user)
	if(!color || color != turn)
		return FALSE
	if(point < 1 || point > 24)
		return FALSE
	if(!nards_long_rules && nards_bar_count(color) > 0)
		to_chat(user, span_warning("Move a checker in from the bar first."))
		return FALSE
	if(nards_long_rules && point == nards_head_point(color) && nards_head_moves_this_turn >= 1)
		to_chat(user, span_warning("In long backgammon, you can move only one checker off the starting point per turn."))
		return FALSE
	if(nards_point_color(point) != color || nards_point_count(point) <= 0)
		return FALSE
	nards_selected_point = point
	nards_selected_from_bar = FALSE
	last_action_message = "Point [point] selected."
	return TRUE

/datum/chess_match/proc/select_nards_bar(mob/user)
	if(game_mode != BOARD_MODE_NARDS || paused || result_text || overturned)
		return FALSE
	if(nards_long_rules)
		return FALSE
	var/color = side_for_user(user)
	if(!color || color != turn)
		return FALSE
	if(nards_bar_count(color) <= 0)
		return FALSE
	nards_selected_from_bar = TRUE
	nards_selected_point = 0
	last_action_message = "The bar is selected."
	return TRUE

/datum/chess_match/proc/move_nards_checker(mob/user, to_point, to_off = FALSE)
	if(game_mode != BOARD_MODE_NARDS || paused || result_text || overturned)
		return FALSE
	var/color = side_for_user(user)
	if(!color || color != turn)
		return FALSE
	var/from_bar = nards_selected_from_bar
	var/from_point = nards_selected_point
	if(from_bar)
		if(nards_long_rules)
			return FALSE
		from_point = 0
	else if(from_point < 1 || from_point > 24)
		to_chat(user, span_warning("Select a checker first."))
		return FALSE
	var/list/legal = get_nards_legal_targets(color, from_point, from_bar)
	var/desired = to_off ? 0 : to_point
	if(!(desired in legal))
		to_chat(user, span_warning("That move is not legal."))
		return FALSE
	var/die = nards_find_die_for_move(color, from_point, to_point, from_bar, to_off)
	if(die <= 0)
		to_chat(user, span_warning("Could not determine which die to use for this move."))
		return FALSE
	if(from_bar)
		nards_set_bar_count(color, nards_bar_count(color) - 1)
	else
		nards_set_point(from_point, color, max(0, nards_point_count(from_point) - 1))
		if(nards_point_count(from_point) <= 0)
			nards_points[from_point] = null
		if(nards_long_rules && from_point == nards_head_point(color))
			nards_head_moves_this_turn++
	if(!to_off)
		var/target_color = nards_point_color(to_point)
		var/target_count = nards_point_count(to_point)
		if(!nards_long_rules && target_color == opposite(color) && target_count == 1)
			nards_points[to_point] = null
			nards_set_bar_count(opposite(color), nards_bar_count(opposite(color)) + 1)
		nards_set_point(to_point, color, nards_point_count(to_point) + 1)
	else
		nards_set_off_count(color, (color == CHESS_WHITE ? nards_off_white : nards_off_black) + 1)
	var/source_name = from_bar ? "the bar" : "point [from_point]"
	var/dest_name = to_off ? "home" : "point [to_point]"
	last_action_message = "[chess_display_name(user)] moves a checker from [source_name] to [dest_name]."
	nards_consume_die(die)
	if(nards_off_white >= 15)
		result_text = "Game over. White wins."
		paused = TRUE
		nards_clear_selection()
		owner.play_win_loss_sounds(CHESS_WHITE)
		return TRUE
	if(nards_off_black >= 15)
		result_text = "Game over. Black wins."
		paused = TRUE
		nards_clear_selection()
		owner.play_win_loss_sounds(CHESS_BLACK)
		return TRUE
	if(nards_available_rolls.len && nards_has_any_legal_move(color))
		if(!nards_long_rules && nards_bar_count(color) > 0)
			nards_selected_from_bar = TRUE
			nards_selected_point = 0
		else if(!to_off)
			nards_selected_point = to_point
			nards_selected_from_bar = FALSE
		else
			nards_clear_selection()
	else
		nards_end_turn()
	return TRUE

#undef CHESS_WHITE
#undef CHESS_BLACK
#undef BOARD_MODE_CHESS
#undef BOARD_MODE_CHECKERS
#undef BOARD_MODE_NARDS
#undef BOARD_MODE_NONE
#undef CHESS_PAWN
#undef CHESS_ROOK
#undef CHESS_KNIGHT
#undef CHESS_BISHOP
#undef CHESS_QUEEN
#undef CHESS_KING
#undef CHECKERS_MAN
#undef CHECKERS_KING
#undef CHESS_UI_ACTIVE_WINDOW
#undef CHESS_OBSERVER_RESET_TIME
#undef CHESS_PACK_BOARD_TIME
#undef CHESS_FLIP_BOARD_TIME
