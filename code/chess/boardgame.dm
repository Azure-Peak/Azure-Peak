#define CHESS_WHITE "w"
#define CHESS_BLACK "b"

#define BOARD_CHESS "chess"
#define BOARD_CHECKERS "checkers"
#define BOARD_NARDS "nards"

#define CHESS_PAWN "p"
#define CHESS_ROOK "r"
#define CHESS_KNIGHT "n"
#define CHESS_BISHOP "b"
#define CHESS_QUEEN "q"
#define CHESS_KING "k"

#define CHECKERS_MAN "m"
#define CHECKERS_KING "k"

#define CASTLE_WK (1<<0)
#define CASTLE_WQ (1<<1)
#define CASTLE_BK (1<<2)
#define CASTLE_BQ (1<<3)

/// Backgammon selection value for the bar
#define NARDS_BAR 25

#define CHESS_RESETTIME (20 SECONDS)
#define CHESS_PACKTIME (15 SECONDS)
#define CHESS_FLIPTIME (7 SECONDS)

#define SQ_INDEX(file, rank) (((rank) - 1) * 8 + (file))
#define SQ_FILE(idx) ((((idx) - 1) % 8) + 1)
#define SQ_RANK(idx) ((((idx) - 1) >> 3) + 1)
#define SQ_NAME(idx) "[ascii2text(96 + SQ_FILE(idx))][SQ_RANK(idx)]"
#define ONBOARD(file, rank) ((file) >= 1 && (file) <= 8 && (rank) >= 1 && (rank) <= 8)
#define PIECE_SIDE(piece) copytext(piece, 1, 2)
#define PIECE_TYPE(piece) copytext(piece, 2, 3)
#define SIDE_NAME(side) ((side) == CHESS_WHITE ? "White" : "Black")
#define OTHER_SIDE(side) ((side) == CHESS_WHITE ? CHESS_BLACK : CHESS_WHITE)
#define NARDS_SIGN(side) ((side) == CHESS_WHITE ? 1 : -1)

/obj/item/chessboard_folded
	name = "folded chessboard"
	desc = "A wooden checkered board folded in half. It is designed for games such as chess, checkers, and backgammon."
	icon = 'icons/chess/chess.dmi'
	icon_state = "chessboard_folded"
	w_class = WEIGHT_CLASS_NORMAL
	grid_width = 96
	grid_height = 64

/obj/item/chessboard_folded/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Use the board in hand to lay it out in front of you.")

/obj/item/chessboard_folded/attack_self(mob/user)
	var/turf/target = get_step(user, user.dir)
	if(!target || target.density)
		target = get_turf(user)
	new /obj/structure/chessboard(target)
	user.visible_message(span_notice("[user] unfolds the chessboard."), span_notice("You unfold the chessboard."))
	qdel(src)

/obj/structure/chessboard
	name = "chessboard"
	desc = "A wooden checkered board laid open. It is designed for games such as chess, checkers, and backgammon."
	icon = 'icons/chess/chess.dmi'
	icon_state = "chessboard_unfolded"
	anchored = TRUE
	density = FALSE
	layer = OBJ_LAYER
	/// Game on the board
	var/datum/boardgame/game
	/// Seated ckeys by side
	var/list/ckeys = list()
	/// Seated character names by side
	var/list/names = list()
	/// Latest notable event
	var/message
	var/pending_mode
	var/pending_variant = FALSE
	var/mode_ckey
	var/mode_name
	var/reset_ckey
	var/reset_name
	var/reset_timer
	/// Board rotation in degrees
	var/spin = 0

/obj/structure/chessboard/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Use the board with an empty hand to sit down at it.")
	. += span_info("Right click the board to rotate it.")
	. += span_info("Take both seats to play against yourself.")
	. += span_info("Fold the board away with Pack up once no game is in progress.")

/obj/structure/chessboard/Destroy()
	QDEL_NULL(game)
	deltimer(reset_timer)
	return ..()

/obj/structure/chessboard/attack_hand(mob/user)
	ui_interact(user)
	return TRUE

/obj/structure/chessboard/attack_ghost(mob/dead/observer/user)
	if(!in_range(src, user))
		return ..()
	ui_interact(user)
	return TRUE

/obj/structure/chessboard/attack_right(mob/user)
	if(!user.canUseTopic(src, be_close = TRUE))
		return ..()
	spin = (spin + 90) % 360
	transform = turn(matrix(), spin)
	to_chat(user, span_notice("You rotate the board."))
	return TRUE

/obj/structure/chessboard/update_icon_state()
	icon_state = game ? "chessboard_unfolded_[game.key]" : "chessboard_unfolded"
	return ..()

/obj/structure/chessboard/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChessBoard", name)
		ui.open()

/obj/structure/chessboard/ui_data(mob/user)
	var/side = side_for(user)
	var/list/viewers = onlookers()
	var/list/seats = list()
	for(var/seat in list(CHESS_WHITE, CHESS_BLACK))
		var/ckey = ckeys[seat]
		seats += list(list("name" = names[seat], "mine" = !!ckey && ckey == user.ckey, "away" = !!ckey && !(ckey in viewers)))
	var/list/rows = list()
	var/status = "Choose a game to begin."
	if(game)
		var/moves = length(game.history)
		for(var/i in 1 to moves step 2)
			rows += list(list(game.history[i], i < moves ? game.history[i + 1] : null))
		if(game.result)
			status = game.result
		else if(game.paused)
			status = game.started ? "The game is paused." : "Take your seats, then start the game."
		else
			var/detail = game.status()
			status = "[SIDE_NAME(game.turn)] to move.[detail ? " [detail]" : ""]"
	return list(
		"mode" = game?.key,
		"label" = game && label(game.key, game.variant),
		"rules" = game?.rules(),
		"variant" = game?.variant,
		"seats" = seats,
		"side" = side,
		"solo" = ckeys[CHESS_WHITE] && ckeys[CHESS_WHITE] == ckeys[CHESS_BLACK],
		"turn" = game?.turn,
		"live" = game?.live(),
		"started" = game?.started,
		"result" = game?.result,
		"status" = status,
		"message" = message,
		"history" = rows,
		"pending_label" = pending_mode && label(pending_mode, pending_variant),
		"pending_mode" = pending_mode,
		"pending_variant" = pending_variant,
		"mode_name" = mode_name,
		"can_answer_mode" = pending_mode && side && mode_ckey != user.ckey,
		"can_cancel_mode" = pending_mode && (side || mode_ckey == user.ckey),
		"reset_name" = reset_name,
		"reset_left" = reset_timer ? CEILING(timeleft(reset_timer) / 10, 1) : 0,
		"can_answer_reset" = reset_ckey && !reset_timer && side && reset_ckey != user.ckey,
		"can_cancel_reset" = reset_ckey && (side || reset_ckey == user.ckey),
		"can_start" = side && can_start(),
		"can_pause" = side && game?.live(),
		"can_resign" = can_resign(user),
		"can_pack" = can_pack(),
		"can_flip" = game?.can_flip(),
		"board" = game?.ui_board(side)
	)

/obj/structure/chessboard/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/user = usr
	if(!user.canUseTopic(src, be_close = TRUE))
		return FALSE
	var/side = side_for(user)
	var/who = user.real_name || user.name
	switch(action)
		if("sit")
			var/seat = params["side"]
			if(seat != CHESS_WHITE && seat != CHESS_BLACK)
				return FALSE
			if(ckeys[seat])
				to_chat(user, span_warning("That seat is taken."))
				return FALSE
			if(game?.midgame() && !game.paused)
				to_chat(user, span_warning("Pause the game before changing seats."))
				return FALSE
			ckeys[seat] = user.ckey
			names[seat] = who
			drop_requests()
			message = "[who] sits down as [SIDE_NAME(seat)]."
		if("stand")
			var/seat = params["side"]
			var/ckey = ckeys[seat]
			if(!ckey)
				return FALSE
			if(ckey != user.ckey && (ckey in onlookers()))
				to_chat(user, span_warning("[names[seat]] is still at the board."))
				return FALSE
			if(game?.midgame() && !game.paused)
				to_chat(user, span_warning("Pause the game before changing seats."))
				return FALSE
			message = ckey == user.ckey ? "[names[seat]] gets up from the [LOWER_TEXT(SIDE_NAME(seat))] seat." : "[who] clears [names[seat]] from the [LOWER_TEXT(SIDE_NAME(seat))] seat."
			ckeys[seat] = null
			names[seat] = null
			drop_requests()
		if("start")
			if(!side || !can_start())
				return FALSE
			message = "[who] [game.started ? "resumes" : "starts"] the game."
			game.paused = FALSE
			game.started = TRUE
		if("pause")
			if(!side || !game?.live())
				return FALSE
			game.paused = TRUE
			message = "[who] pauses the game."
		if("resign")
			if(!can_resign(user))
				return FALSE
			game.finish("[SIDE_NAME(side)] resigns. [SIDE_NAME(OTHER_SIDE(side))] wins.", OTHER_SIDE(side))
		if("reset")
			if(!side)
				if(reset_ckey)
					to_chat(user, span_warning("A reset has already been requested."))
					return FALSE
				reset_ckey = user.ckey
				reset_name = who
				reset_timer = addtimer(CALLBACK(src, PROC_REF(lapse)), CHESS_RESETTIME, TIMER_STOPPABLE)
				notify("[who] will reset the board and clear the seats in [CHESS_RESETTIME / 10] seconds unless you cancel it.", user.ckey)
				message = "[who] reaches to reset the board."
			else if(reset_ckey && !reset_timer)
				if(reset_ckey == user.ckey)
					to_chat(user, span_warning("You have already asked to reset the board."))
					return FALSE
				wipe("The players agree to reset the board.")
			else
				var/other = ckeys[OTHER_SIDE(side)]
				if(!other || other == user.ckey || !(other in onlookers()))
					wipe("[who] resets the board.")
				else
					deltimer(reset_timer)
					reset_timer = null
					reset_ckey = user.ckey
					reset_name = who
					notify("[who] asks to reset the board.", user.ckey)
					message = "[who] asks to reset the board."
		if("cancel_reset")
			if(!reset_ckey || (reset_ckey != user.ckey && !side))
				return FALSE
			message = "[who] calls off the reset."
			reset_ckey = null
			reset_name = null
			deltimer(reset_timer)
			reset_timer = null
		if("mode")
			var/mode = params["mode"]
			if(!(mode in list(BOARD_CHESS, BOARD_CHECKERS, BOARD_NARDS)))
				return FALSE
			var/variant = mode != BOARD_CHESS && !!text2num(params["variant"])
			if(game?.flipped)
				to_chat(user, span_warning("Reset the board first."))
				return FALSE
			if(game && game.key == mode && game.variant == variant)
				to_chat(user, span_warning("That game is already set up."))
				return FALSE
			var/same = pending_mode == mode && pending_variant == variant
			var/ask = FALSE
			if(game?.midgame())
				if(!game.paused)
					to_chat(user, span_warning("Pause the game first."))
					return FALSE
				if(!side)
					to_chat(user, span_warning("Only the players can change the game mid-match."))
					return FALSE
				var/other = ckeys[OTHER_SIDE(side)]
				ask = other && other != user.ckey && !(same && mode_ckey && mode_ckey != user.ckey)
			if(ask)
				if(same && mode_ckey == user.ckey)
					to_chat(user, span_warning("You have already proposed that."))
					return FALSE
				pending_mode = mode
				pending_variant = variant
				mode_ckey = user.ckey
				mode_name = who
				notify("[who] proposes switching to [label(mode, variant)].", user.ckey)
				message = "[who] proposes switching to [label(mode, variant)]."
			else
				set_game(mode, variant)
				message = "The board is set up for [label(mode, variant)]."
		if("cancel_mode")
			if(!pending_mode || (mode_ckey != user.ckey && !side))
				return FALSE
			message = "[who] declines [label(pending_mode, pending_variant)]."
			pending_mode = null
			pending_variant = FALSE
			mode_ckey = null
			mode_name = null
		if("flip")
			if(!game?.can_flip())
				return FALSE
			notify("[who] is about to flip the board!", user.ckey)
			user.visible_message(span_warning("[user] grabs the board, preparing to flip it."), span_warning("You grab the board."))
			if(!do_after(user, CHESS_FLIPTIME, target = src) || QDELETED(src) || !game?.can_flip())
				to_chat(user, span_warning("You decide not to flip the board."))
				return FALSE
			game.flip()
			drop_requests()
			playsound(src, CHESS_SOUND_RAGE, 70, FALSE)
			user.visible_message(span_warning("[user] flips the board! The pieces scatter across it."), span_warning("You flip the board! The pieces scatter across it."))
			message = "[who] flips the board."
		if("pack")
			if(!can_pack())
				to_chat(user, span_warning("The board can only be packed away when no game is in progress."))
				return FALSE
			notify("[who] is packing up the board.", user.ckey)
			user.visible_message(span_notice("[user] starts packing up the board."), span_notice("You start packing up the board."))
			if(!do_after(user, CHESS_PACKTIME, target = src) || QDELETED(src) || !can_pack())
				to_chat(user, span_warning("You stop packing up the board."))
				return FALSE
			playsound(src, CHESS_SOUND_PICKUP, 70, FALSE)
			new /obj/item/chessboard_folded(loc)
			user.visible_message(span_notice("[user] folds the board for travel."), span_notice("You fold the board for travel."))
			qdel(src)
			return FALSE
		else
			. = game?.act(action, params, user, side)
			if(.)
				update_icon()
			return
	playsound(src, CHESS_SOUND_NOTIFY, 50, FALSE)
	update_icon()
	return TRUE

/obj/structure/chessboard/proc/label(mode, variant)
	switch(mode)
		if(BOARD_CHESS)
			return "Chess"
		if(BOARD_CHECKERS)
			return variant ? "Checkers, flying kings" : "Checkers, short kings"
		if(BOARD_NARDS)
			return variant ? "Long backgammon" : "Short backgammon"

/obj/structure/chessboard/proc/side_for(mob/user)
	var/ckey = user?.ckey
	if(!ckey)
		return null
	var/white = ckeys[CHESS_WHITE] == ckey
	if(white && ckeys[CHESS_BLACK] == ckey)
		return game ? game.turn : CHESS_WHITE
	if(white)
		return CHESS_WHITE
	if(ckeys[CHESS_BLACK] == ckey)
		return CHESS_BLACK
	return null

/obj/structure/chessboard/proc/onlookers()
	. = list()
	for(var/datum/tgui/ui as anything in open_uis)
		if(ui.user?.ckey)
			. |= ui.user.ckey

/obj/structure/chessboard/proc/notify(text, exclude)
	for(var/ckey in uniqueList(list(ckeys[CHESS_WHITE], ckeys[CHESS_BLACK])))
		if(!ckey || ckey == exclude)
			continue
		var/client/C = GLOB.directory[ckey]
		if(C)
			to_chat(C.mob, span_warning(text))

/obj/structure/chessboard/proc/drop_requests()
	pending_mode = null
	pending_variant = FALSE
	mode_ckey = null
	mode_name = null
	reset_ckey = null
	reset_name = null
	deltimer(reset_timer)
	reset_timer = null

/obj/structure/chessboard/proc/set_game(mode, variant)
	var/static/list/types = list(BOARD_CHESS = /datum/boardgame/grid/chess, BOARD_CHECKERS = /datum/boardgame/grid/checkers, BOARD_NARDS = /datum/boardgame/nards)
	QDEL_NULL(game)
	var/path = types[mode]
	if(path)
		game = new path(src, variant)
	drop_requests()

/obj/structure/chessboard/proc/wipe(text, unseat = FALSE)
	if(unseat)
		ckeys = list()
		names = list()
	set_game(game?.key, game?.variant)
	message = text
	playsound(src, CHESS_SOUND_RESET, 70, FALSE)
	update_icon()
	SStgui.update_uis(src)

/obj/structure/chessboard/proc/lapse()
	reset_timer = null
	wipe("[reset_name] resets the board and clears the seats.", TRUE)

/obj/structure/chessboard/proc/can_start()
	return game && game.paused && !game.result && ckeys[CHESS_WHITE] && ckeys[CHESS_BLACK]

/obj/structure/chessboard/proc/can_resign(mob/user)
	var/side = side_for(user)
	return side && game?.started && !game.result && ckeys[OTHER_SIDE(side)]

/obj/structure/chessboard/proc/can_pack()
	return !game || (game.paused && !game.midgame())

/datum/boardgame
	var/obj/structure/chessboard/owner
	/// Mode key, also the suffix of the board's laid out icon_state
	var/key
	/// Rule variant
	var/variant = FALSE
	var/turn = CHESS_WHITE
	var/paused = TRUE
	var/started = FALSE
	/// Outcome text, set once the game ends
	var/result
	/// Notation of each turn, alternating white and black
	var/list/history = list()
	var/flipped = FALSE
	/// Where the pieces landed when the board was flipped
	var/list/scatter

/datum/boardgame/New(obj/structure/chessboard/board, variant)
	owner = board
	src.variant = !!variant
	setup()

/datum/boardgame/Destroy()
	owner = null
	return ..()

/datum/boardgame/proc/setup()
	return

/datum/boardgame/proc/rules()
	return null

/datum/boardgame/proc/status()
	return null

/datum/boardgame/proc/ui_board(side)
	return null

/datum/boardgame/proc/act(action, list/params, mob/user, side)
	return FALSE

/datum/boardgame/proc/can_flip()
	return !flipped

/datum/boardgame/proc/flip()
	flipped = TRUE
	finish("The board has been flipped. Reset it to set the pieces back up.")

/datum/boardgame/proc/live()
	return started && !paused && !result

/datum/boardgame/proc/midgame()
	return !result && length(history)

/datum/boardgame/proc/finish(text, winner)
	result = text
	paused = TRUE
	owner.message = text
	if(!winner)
		return
	var/winckey = owner.ckeys[winner]
	var/loseckey = owner.ckeys[OTHER_SIDE(winner)]
	var/list/hearers = owner.onlookers()
	if(winckey)
		hearers |= winckey
	if(loseckey)
		hearers |= loseckey
	for(var/ckey in hearers)
		var/client/C = GLOB.directory[ckey]
		C?.mob?.playsound_local(get_turf(C.mob), (ckey == loseckey && ckey != winckey) ? CHESS_SOUND_LOSS : CHESS_SOUND_WIN, 65)

/datum/boardgame/proc/can_play(mob/user, side)
	var/problem
	if(result)
		problem = flipped ? "The board has been flipped. Reset it first." : "The game is over."
	else if(paused)
		problem = started ? "The game is paused." : "Start the game first."
	else if(!side)
		problem = "You are not seated at this board."
	else if(side != turn)
		problem = "It is not your turn."
	else
		return TRUE
	to_chat(user, span_warning(problem))
	return FALSE

/datum/boardgame/grid
	/// Squares a1 to h8, each a side letter plus a piece letter, or null
	var/list/cells
	var/selected = 0
	var/last_from = 0
	var/last_to = 0

/datum/boardgame/grid/New(obj/structure/chessboard/board, variant)
	cells = new /list(64)
	return ..()

/datum/boardgame/grid/proc/targets(from)
	return list()

/datum/boardgame/grid/proc/can_pick(idx)
	return TRUE

/datum/boardgame/grid/proc/move(from, dest, promote)
	return FALSE

/datum/boardgame/grid/ui_board(side)
	return list(
		"cells" = cells,
		"selected" = selected,
		"targets" = (selected && side == turn && live()) ? targets(selected) : list(),
		"last" = list(last_from, last_to),
		"scatter" = scatter
	)

/datum/boardgame/grid/act(action, list/params, mob/user, side)
	if(action != "square")
		return FALSE
	var/idx = text2num(params["square"])
	if(!idx || idx < 1 || idx > 64 || !can_play(user, side))
		return FALSE
	var/piece = cells[idx]
	if(piece && PIECE_SIDE(piece) == side)
		if(idx == selected)
			selected = 0
		else if(can_pick(idx))
			selected = idx
		else
			to_chat(user, span_warning("You must keep capturing with the same piece."))
			return FALSE
		return TRUE
	if(!selected)
		return FALSE
	if(!(idx in targets(selected)))
		selected = 0
		return TRUE
	return move(selected, idx, params["promote"])

/datum/boardgame/grid/can_flip()
	if(flipped)
		return FALSE
	for(var/piece in cells)
		if(piece)
			return TRUE
	return FALSE

/datum/boardgame/grid/flip()
	var/list/free = list()
	for(var/i in 1 to 64)
		free += i
	var/list/old = cells
	cells = new /list(64)
	scatter = new /list(64)
	for(var/piece in old)
		if(!piece)
			continue
		var/idx = pick_n_take(free)
		cells[idx] = piece
		if(prob(50))
			scatter[idx] = list(0, rand(-8, 8), rand(-6, 8), rand(-18, 18))
		else
			scatter[idx] = list(pick(-90, 90), rand(-14, 14), rand(-12, 12), rand(-22, 22))
	selected = 0
	last_from = 0
	last_to = 0
	return ..()

/datum/boardgame/grid/chess
	key = BOARD_CHESS
	var/castling = CASTLE_WK | CASTLE_WQ | CASTLE_BK | CASTLE_BQ
	/// Square a pawn may capture onto en passant this turn
	var/passant = 0
	/// Times each position has occurred, for threefold repetition
	var/list/seen = list()

/datum/boardgame/grid/chess/setup()
	var/static/list/back = list(CHESS_ROOK, CHESS_KNIGHT, CHESS_BISHOP, CHESS_QUEEN, CHESS_KING, CHESS_BISHOP, CHESS_KNIGHT, CHESS_ROOK)
	for(var/file in 1 to 8)
		cells[SQ_INDEX(file, 1)] = "[CHESS_WHITE][back[file]]"
		cells[SQ_INDEX(file, 2)] = "[CHESS_WHITE][CHESS_PAWN]"
		cells[SQ_INDEX(file, 7)] = "[CHESS_BLACK][CHESS_PAWN]"
		cells[SQ_INDEX(file, 8)] = "[CHESS_BLACK][back[file]]"
	seen[position()] = 1

/datum/boardgame/grid/chess/status()
	return in_check(turn) ? "Check!" : null

/datum/boardgame/grid/chess/ui_board(side)
	. = ..()
	.["check"] = (live() && in_check(turn)) ? cells.Find("[turn][CHESS_KING]") : 0

/datum/boardgame/grid/chess/proc/position()
	. = "[turn][castling][passant]"
	for(var/piece in cells)
		. += piece || "--"

/datum/boardgame/grid/chess/proc/in_check(side)
	var/king = cells.Find("[side][CHESS_KING]")
	return king && attacked(king, OTHER_SIDE(side))

/datum/boardgame/grid/chess/proc/attacked(idx, by)
	var/static/list/jumps = list(list(1, 2), list(2, 1), list(-1, 2), list(-2, 1), list(1, -2), list(2, -1), list(-1, -2), list(-2, -1))
	var/static/list/rays = list(list(1, 0), list(-1, 0), list(0, 1), list(0, -1), list(1, 1), list(1, -1), list(-1, 1), list(-1, -1))
	var/file = SQ_FILE(idx)
	var/rank = SQ_RANK(idx)
	var/behind = by == CHESS_WHITE ? -1 : 1
	for(var/df in list(-1, 1))
		if(ONBOARD(file + df, rank + behind) && cells[SQ_INDEX(file + df, rank + behind)] == "[by][CHESS_PAWN]")
			return TRUE
	for(var/list/vec in jumps)
		if(ONBOARD(file + vec[1], rank + vec[2]) && cells[SQ_INDEX(file + vec[1], rank + vec[2])] == "[by][CHESS_KNIGHT]")
			return TRUE
	for(var/i in 1 to 8)
		var/list/vec = rays[i]
		var/slider = i <= 4 ? CHESS_ROOK : CHESS_BISHOP
		var/f = file + vec[1]
		var/r = rank + vec[2]
		var/near = TRUE
		while(ONBOARD(f, r))
			var/piece = cells[SQ_INDEX(f, r)]
			if(piece)
				var/kind = PIECE_TYPE(piece)
				if(PIECE_SIDE(piece) == by && (kind == slider || kind == CHESS_QUEEN || (near && kind == CHESS_KING)))
					return TRUE
				break
			f += vec[1]
			r += vec[2]
			near = FALSE
	return FALSE

/datum/boardgame/grid/chess/proc/clear_path(from, dest)
	var/stride = sign(SQ_FILE(dest) - SQ_FILE(from)) + 8 * sign(SQ_RANK(dest) - SQ_RANK(from))
	for(var/idx = from + stride, idx != dest, idx += stride)
		if(cells[idx])
			return FALSE
	return TRUE

/datum/boardgame/grid/chess/targets(from)
	. = list()
	var/piece = cells[from]
	if(!piece)
		return
	var/side = PIECE_SIDE(piece)
	var/kind = PIECE_TYPE(piece)
	var/home = side == CHESS_WHITE ? 1 : 8
	var/ahead = side == CHESS_WHITE ? 1 : -1
	for(var/dest in 1 to 64)
		var/target = cells[dest]
		if(target && PIECE_SIDE(target) == side)
			continue
		var/df = SQ_FILE(dest) - SQ_FILE(from)
		var/dr = SQ_RANK(dest) - SQ_RANK(from)
		var/ok = FALSE
		switch(kind)
			if(CHESS_PAWN)
				if(df)
					ok = abs(df) == 1 && dr == ahead && (target || dest == passant)
				else
					ok = !target && (dr == ahead || (dr == 2 * ahead && SQ_RANK(from) == home + ahead && !cells[from + 8 * ahead]))
			if(CHESS_KNIGHT)
				ok = abs(df * dr) == 2
			if(CHESS_KING)
				ok = abs(df) <= 1 && abs(dr) <= 1
				if(!ok && !dr && abs(df) == 2 && from == SQ_INDEX(5, home))
					var/stride = df > 0 ? 1 : -1
					var/rook = SQ_INDEX(df > 0 ? 8 : 1, home)
					var/right = side == CHESS_WHITE ? (df > 0 ? CASTLE_WK : CASTLE_WQ) : (df > 0 ? CASTLE_BK : CASTLE_BQ)
					var/foe = OTHER_SIDE(side)
					ok = (castling & right) && cells[rook] == "[side][CHESS_ROOK]" && clear_path(from, rook) && !attacked(from, foe) && !attacked(from + stride, foe) && !attacked(from + 2 * stride, foe)
			if(CHESS_ROOK)
				ok = (!df || !dr) && clear_path(from, dest)
			if(CHESS_BISHOP)
				ok = abs(df) == abs(dr) && clear_path(from, dest)
			if(CHESS_QUEEN)
				ok = (!df || !dr || abs(df) == abs(dr)) && clear_path(from, dest)
		if(!ok)
			continue
		var/list/saved = cells.Copy()
		var/oldcastling = castling
		var/oldpassant = passant
		apply(from, dest)
		if(!in_check(side))
			. += dest
		cells = saved
		castling = oldcastling
		passant = oldpassant

/datum/boardgame/grid/chess/proc/apply(from, dest, promote)
	var/static/list/corners = list("1" = CASTLE_WQ, "8" = CASTLE_WK, "57" = CASTLE_BQ, "64" = CASTLE_BK)
	var/piece = cells[from]
	var/side = PIECE_SIDE(piece)
	var/kind = PIECE_TYPE(piece)
	var/captured = cells[dest]
	var/df = SQ_FILE(dest) - SQ_FILE(from)
	var/note
	var/into
	if(kind == CHESS_PAWN && dest == passant && !captured)
		var/victim = dest + (side == CHESS_WHITE ? -8 : 8)
		captured = cells[victim]
		cells[victim] = null
	passant = 0
	cells[dest] = piece
	cells[from] = null
	castling &= ~(corners["[from]"] | corners["[dest]"])
	switch(kind)
		if(CHESS_KING)
			castling &= ~(side == CHESS_WHITE ? (CASTLE_WK | CASTLE_WQ) : (CASTLE_BK | CASTLE_BQ))
			if(abs(df) == 2)
				var/rook = df > 0 ? from + 3 : from - 4
				cells[from + sign(df)] = cells[rook]
				cells[rook] = null
				note = df > 0 ? "O-O" : "O-O-O"
		if(CHESS_PAWN)
			if(abs(dest - from) == 16)
				passant = (from + dest) / 2
			if(SQ_RANK(dest) == 1 || SQ_RANK(dest) == 8)
				into = (promote in list(CHESS_QUEEN, CHESS_ROOK, CHESS_BISHOP, CHESS_KNIGHT)) ? promote : CHESS_QUEEN
				cells[dest] = "[side][into]"
	if(!note)
		note = kind == CHESS_PAWN ? (captured ? copytext(SQ_NAME(from), 1, 2) : "") : uppertext(kind)
		note += "[captured ? "x" : ""][SQ_NAME(dest)][into ? "=[uppertext(into)]" : ""]"
	return list(note, captured)

/datum/boardgame/grid/chess/move(from, dest, promote)
	var/list/info = apply(from, dest, promote)
	var/note = info[1]
	var/mover = turn
	selected = 0
	last_from = from
	last_to = dest
	turn = OTHER_SIDE(mover)
	var/key = position()
	seen[key] = seen[key] + 1
	var/check = in_check(turn)
	playsound(owner, info[2] ? CHESS_SOUND_CAPTURE : CHESS_SOUND_MOVE, 55, FALSE)
	var/stuck = TRUE
	for(var/idx in 1 to 64)
		var/piece = cells[idx]
		if(piece && PIECE_SIDE(piece) == turn && length(targets(idx)))
			stuck = FALSE
			break
	if(stuck)
		history += "[note][check ? "#" : ""]"
		if(check)
			finish("Checkmate. [SIDE_NAME(mover)] wins.", mover)
		else
			finish("Draw by stalemate.")
		return TRUE
	note += check ? "+" : ""
	history += note
	if(seen[key] >= 3)
		finish("Draw by threefold repetition.")
		return TRUE
	owner.message = "[SIDE_NAME(mover)] plays [note]."
	if(check)
		for(var/ckey in owner.onlookers())
			var/client/C = GLOB.directory[ckey]
			C?.mob?.playsound_local(get_turf(C.mob), CHESS_SOUND_CHECK, 55)
	return TRUE

/datum/boardgame/grid/checkers
	key = BOARD_CHECKERS
	/// Piece midway through a multi-capture, which must keep jumping
	var/chain = 0
	/// Notation of the capture sequence in progress
	var/chain_note

/datum/boardgame/grid/checkers/setup()
	for(var/idx in 1 to 64)
		var/rank = SQ_RANK(idx)
		if((SQ_FILE(idx) + rank) % 2)
			continue
		if(rank <= 3)
			cells[idx] = "[CHESS_WHITE][CHECKERS_MAN]"
		else if(rank >= 6)
			cells[idx] = "[CHESS_BLACK][CHECKERS_MAN]"

/datum/boardgame/grid/checkers/rules()
	return "Captures are compulsory. [variant ? "Kings fly any distance along a diagonal." : "Kings move one square at a time."]"

/datum/boardgame/grid/checkers/status()
	return chain ? "Keep capturing from [SQ_NAME(chain)]." : null

/datum/boardgame/grid/checkers/can_pick(idx)
	return !chain || idx == chain

/datum/boardgame/grid/checkers/proc/dirs(piece)
	if(PIECE_TYPE(piece) == CHECKERS_KING)
		return list(list(1, 1), list(-1, 1), list(1, -1), list(-1, -1))
	var/ahead = PIECE_SIDE(piece) == CHESS_WHITE ? 1 : -1
	return list(list(1, ahead), list(-1, ahead))

/datum/boardgame/grid/checkers/proc/jumps(from)
	. = list()
	var/piece = cells[from]
	var/side = PIECE_SIDE(piece)
	var/fly = variant && PIECE_TYPE(piece) == CHECKERS_KING
	for(var/list/vec in dirs(piece))
		var/f = SQ_FILE(from) + vec[1]
		var/r = SQ_RANK(from) + vec[2]
		var/foe = FALSE
		while(ONBOARD(f, r))
			var/other = cells[SQ_INDEX(f, r)]
			if(other)
				if(foe || PIECE_SIDE(other) == side)
					break
				foe = TRUE
			else if(foe)
				. += SQ_INDEX(f, r)
				if(!fly)
					break
			else if(!fly)
				break
			f += vec[1]
			r += vec[2]

/datum/boardgame/grid/checkers/targets(from)
	. = list()
	var/piece = cells[from]
	if(!piece || (chain && from != chain))
		return
	for(var/idx in 1 to 64)
		var/other = cells[idx]
		if(other && PIECE_SIDE(other) == PIECE_SIDE(piece) && length(jumps(idx)))
			return jumps(from)
	var/fly = variant && PIECE_TYPE(piece) == CHECKERS_KING
	for(var/list/vec in dirs(piece))
		var/f = SQ_FILE(from) + vec[1]
		var/r = SQ_RANK(from) + vec[2]
		while(ONBOARD(f, r) && !cells[SQ_INDEX(f, r)])
			. += SQ_INDEX(f, r)
			if(!fly)
				break
			f += vec[1]
			r += vec[2]

/datum/boardgame/grid/checkers/move(from, dest, promote)
	var/piece = cells[from]
	var/side = PIECE_SIDE(piece)
	var/stride = sign(SQ_FILE(dest) - SQ_FILE(from)) + 8 * sign(SQ_RANK(dest) - SQ_RANK(from))
	var/taken = FALSE
	for(var/idx = from + stride, idx != dest, idx += stride)
		if(cells[idx])
			cells[idx] = null
			taken = TRUE
	var/crowned = PIECE_TYPE(piece) == CHECKERS_MAN && SQ_RANK(dest) == (side == CHESS_WHITE ? 8 : 1)
	cells[from] = null
	cells[dest] = crowned ? "[side][CHECKERS_KING]" : piece
	last_from = from
	last_to = dest
	playsound(owner, taken ? CHESS_SOUND_CAPTURE : CHESS_SOUND_CHECKERS_MOVE, 55, FALSE)
	if(taken)
		chain_note = chain_note ? "[chain_note]x[SQ_NAME(dest)]" : "[SQ_NAME(from)]x[SQ_NAME(dest)]"
		if(!crowned && length(jumps(dest)))
			chain = dest
			selected = dest
			owner.message = "[SIDE_NAME(side)] must keep capturing from [SQ_NAME(dest)]."
			return TRUE
		history += chain_note
	else
		history += "[SQ_NAME(from)]-[SQ_NAME(dest)]"
	chain = 0
	chain_note = null
	selected = 0
	turn = OTHER_SIDE(side)
	var/pieces = 0
	for(var/idx in 1 to 64)
		var/other = cells[idx]
		if(!other || PIECE_SIDE(other) != turn)
			continue
		if(length(targets(idx)))
			owner.message = "[SIDE_NAME(side)] plays [history[length(history)]]."
			return TRUE
		pieces++
	finish("[SIDE_NAME(turn)] has no [pieces ? "moves" : "pieces"] left. [SIDE_NAME(side)] wins.", side)
	return TRUE

/datum/boardgame/grid/checkers/flip()
	chain = 0
	chain_note = null
	return ..()

/datum/boardgame/nards
	key = BOARD_NARDS
	/// Checkers on points 1 to 24
	var/list/stacks
	var/list/bar = list(CHESS_WHITE = 0, CHESS_BLACK = 0)
	var/list/off = list(CHESS_WHITE = 0, CHESS_BLACK = 0)
	var/list/dice = list(0, 0)
	/// Dice values still unused this turn
	var/list/rolls = list()
	/// Bumped on every roll so the UI can animate it
	var/nonce = 0
	/// Selected point
	var/selected = 0
	/// Checkers moved off the head point this turn
	var/headmoves = 0
	var/list/turnlog = list()
	var/list/scatter_dice

/datum/boardgame/nards/setup()
	stacks = list()
	for(var/i in 1 to 24)
		stacks += 0
	if(variant)
		stacks[24] = 15
		stacks[12] = -15
		return
	stacks[24] = 2
	stacks[13] = 5
	stacks[8] = 3
	stacks[6] = 5
	stacks[1] = -2
	stacks[12] = -5
	stacks[17] = -3
	stacks[19] = -5

/datum/boardgame/nards/rules()
	return variant ? "No hitting. Only one checker may leave the head point each turn." : "A lone checker can be hit onto the bar."

/datum/boardgame/nards/status()
	return length(rolls) ? "Dice left: [jointext(rolls, ", ")]." : "Roll the dice."

/datum/boardgame/nards/ui_board(side)
	var/mine = live() && side == turn
	return list(
		"points" = stacks,
		"bar" = list(bar[CHESS_WHITE], bar[CHESS_BLACK]),
		"off" = list(off[CHESS_WHITE], off[CHESS_BLACK]),
		"dice" = dice,
		"nonce" = nonce,
		"rolls" = rolls,
		"can_roll" = mine && !length(rolls),
		"selected" = selected,
		"targets" = mine ? targets(side, selected) : list(),
		"scatter" = scatter,
		"scatter_dice" = scatter_dice
	)

/// Distance from bearing off along the side's path, 24 on its head point
/datum/boardgame/nards/proc/pip(side, point)
	if(side == CHESS_WHITE)
		return point
	if(variant)
		return point <= 12 ? point + 12 : point - 12
	return 25 - point

/datum/boardgame/nards/proc/spot(side, pip)
	if(side == CHESS_WHITE)
		return pip
	if(variant)
		return pip > 12 ? pip - 12 : pip + 12
	return 25 - pip

/datum/boardgame/nards/proc/side_at(point)
	if(stacks[point] > 0)
		return CHESS_WHITE
	if(stacks[point] < 0)
		return CHESS_BLACK
	return null

/datum/boardgame/nards/proc/can_bear(side, start, die)
	if(bar[side])
		return FALSE
	for(var/point in 1 to 24)
		if(side_at(point) != side)
			continue
		var/dist = pip(side, point)
		if(dist > 6 || (die > start && dist > start))
			return FALSE
	return TRUE

/datum/boardgame/nards/proc/targets(side, from)
	. = list()
	var/start
	if(from == NARDS_BAR)
		if(!bar[side])
			return
		start = 25
	else
		if(from < 1 || from > 24 || side_at(from) != side || bar[side])
			return
		if(variant && headmoves && from == spot(side, 24))
			return
		start = pip(side, from)
	for(var/die in rolls)
		var/land = start - die
		if(land >= 1)
			var/point = spot(side, land)
			var/count = stacks[point] * NARDS_SIGN(side)
			if(count >= 0 || (!variant && count == -1))
				. |= point
		else if(start != 25 && can_bear(side, start, die))
			. |= 0

/datum/boardgame/nards/proc/has_moves(side)
	if(bar[side])
		return length(targets(side, NARDS_BAR))
	for(var/point in 1 to 24)
		if(side_at(point) == side && length(targets(side, point)))
			return TRUE
	return FALSE

/datum/boardgame/nards/act(action, list/params, mob/user, side)
	if((action != "roll" && action != "point") || !can_play(user, side))
		return FALSE
	if(action == "roll")
		if(length(rolls))
			to_chat(user, span_warning("Use the dice you have first."))
			return FALSE
		dice = list(rand(1, 6), rand(1, 6))
		nonce++
		rolls = dice[1] == dice[2] ? list(dice[1], dice[1], dice[1], dice[1]) : dice.Copy()
		selected = 0
		turnlog = list("[dice[1]]-[dice[2]]:")
		playsound(owner, pick(CHESS_SOUND_DICE1, CHESS_SOUND_DICE2, CHESS_SOUND_DICE3), 60, FALSE)
		owner.message = "[SIDE_NAME(side)] rolls [dice[1]] and [dice[2]]."
		if(!has_moves(side))
			owner.message += " No legal moves, the turn passes."
			turnlog += "pass"
			end_turn()
		else if(bar[side])
			selected = NARDS_BAR
		return TRUE
	if(!length(rolls))
		to_chat(user, span_warning("Roll the dice first."))
		return FALSE
	var/dest = text2num(params["point"]) || 0
	var/from = selected
	if(!from || !(dest in targets(side, from)))
		if(dest == from || dest < 1 || dest > NARDS_BAR || (dest == NARDS_BAR ? !bar[side] : side_at(dest) != side))
			if(!from)
				return FALSE
			selected = 0
			return TRUE
		if(dest != NARDS_BAR && bar[side])
			to_chat(user, span_warning("Bring your checker in from the bar first."))
			return FALSE
		if(variant && headmoves && dest == spot(side, 24))
			to_chat(user, span_warning("Only one checker may leave the head point each turn."))
			return FALSE
		selected = dest
		return TRUE
	var/start = from == NARDS_BAR ? 25 : pip(side, from)
	var/die = 0
	for(var/value in rolls)
		if(dest)
			if(start - value >= 1 && spot(side, start - value) == dest)
				die = value
				break
		else if(start - value <= 0 && can_bear(side, start, value) && (!die || value < die || value == start))
			die = value
			if(value == start)
				break
	if(!die)
		return FALSE
	rolls -= die
	var/sign = NARDS_SIGN(side)
	if(from == NARDS_BAR)
		bar[side] -= 1
	else
		stacks[from] -= sign
		if(variant && from == spot(side, 24))
			headmoves++
	if(dest)
		if(stacks[dest] == -sign)
			stacks[dest] = 0
			bar[OTHER_SIDE(side)] += 1
		stacks[dest] += sign
	else
		off[side] += 1
	var/note = "[from == NARDS_BAR ? "bar" : from]/[dest || "off"]"
	turnlog += note
	owner.message = "[SIDE_NAME(side)] moves [note]."
	if(off[side] >= 15)
		history += jointext(turnlog, " ")
		finish("[SIDE_NAME(side)] bears off every checker and wins.", side)
		return TRUE
	if(length(rolls) && has_moves(side))
		selected = bar[side] ? NARDS_BAR : ((dest && length(targets(side, dest))) ? dest : 0)
	else
		end_turn()
	return TRUE

/datum/boardgame/nards/proc/end_turn()
	history += jointext(turnlog, " ")
	turnlog = list()
	rolls = list()
	selected = 0
	headmoves = 0
	turn = OTHER_SIDE(turn)

/datum/boardgame/nards/flip()
	var/list/sides = list()
	for(var/point in 1 to 24)
		for(var/i in 1 to abs(stacks[point]))
			sides += side_at(point)
	for(var/side in list(CHESS_WHITE, CHESS_BLACK))
		for(var/i in 1 to bar[side] + off[side])
			sides += side
	shuffle_inplace(sides)
	scatter = list()
	for(var/side in sides)
		var/fallen = prob(50)
		scatter += list(list(side, fallen ? pick(-90, 90) : 0, rand(4, 336), rand(4, 356), fallen ? rand(-28, 28) : rand(-20, 20)))
	scatter_dice = list()
	for(var/i in 1 to 2)
		scatter_dice += list(list(rand(1, 6), rand(22, 322), rand(18, 338), rand(-35, 35)))
	rolls = list()
	selected = 0
	return ..()

#undef CHESS_WHITE
#undef CHESS_BLACK
#undef BOARD_CHESS
#undef BOARD_CHECKERS
#undef BOARD_NARDS
#undef CHESS_PAWN
#undef CHESS_ROOK
#undef CHESS_KNIGHT
#undef CHESS_BISHOP
#undef CHESS_QUEEN
#undef CHESS_KING
#undef CHECKERS_MAN
#undef CHECKERS_KING
#undef CASTLE_WK
#undef CASTLE_WQ
#undef CASTLE_BK
#undef CASTLE_BQ
#undef NARDS_BAR
#undef CHESS_RESETTIME
#undef CHESS_PACKTIME
#undef CHESS_FLIPTIME
#undef SQ_INDEX
#undef SQ_FILE
#undef SQ_RANK
#undef SQ_NAME
#undef ONBOARD
#undef PIECE_SIDE
#undef PIECE_TYPE
#undef SIDE_NAME
#undef OTHER_SIDE
#undef NARDS_SIGN
