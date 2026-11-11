// Command bar for non-admins. Only runs verbs that show up in the player's stat panel tabs.
// The typed text is never sent back to the client, only the matched verb's own name plus arguments.

#define PLAYER_COMMAND_BAR_COOLDOWN 2

/client/var/player_command_bar_active = FALSE
/client/var/next_player_command_bar_use = 0
/client/var/list/player_command_bar_cycle
/client/var/player_command_bar_cycle_index = 0
/client/var/player_command_bar_last_completion

/client/verb/player_command_bar(command as command_text)
	set name = "player-command-bar"
	set hidden = TRUE

	if(world.time < next_player_command_bar_use)
		return
	next_player_command_bar_use = world.time + PLAYER_COMMAND_BAR_COOLDOWN

	hide_player_command_bar_suggestions()
	player_command_bar_cycle = null

	command = trim(copytext(command, 1, MAX_MESSAGE_LEN))
	if(!length(command))
		return

	var/list/match = find_player_command_bar_verb(command)
	if(!match)
		var/space = findtext(command, " ")
		var/attempted = space ? copytext(command, 1, space) : command
		to_chat(src, span_warning("<b>[html_encode(attempted)]</b> is not a command in my verb tabs."))
		return

	var/procpath/matched_verb = match[1]
	var/dispatch = replacetext(matched_verb.name, " ", "-")
	var/arguments = sanitize_player_command_bar_arguments(copytext(command, match[2] + 1))
	if(length(arguments))
		dispatch += " [arguments]"

	winset(src, null, list2params(list("command" = dispatch)))

// Same filter as init_verbs()
/client/proc/get_player_command_bar_verbs()
	var/list/candidates = verbs.Copy()
	if(mob)
		candidates += mob.verbs
		for(var/atom/movable/thing as anything in mob.contents)
			candidates += thing.verbs

	var/list/visible = list()
	for(var/procpath/candidate as anything in candidates)
		if(!candidate || candidate.hidden)
			continue
		if(!istext(candidate.category))
			continue
		if(!istext(candidate.name) || !length(candidate.name))
			continue
		if(copytext(candidate.name, 1, 2) == ".")
			continue
		visible |= candidate
	return visible

/client/proc/find_player_command_bar_verb(command)
	var/lowered = LOWER_TEXT(command)
	var/procpath/best_verb
	var/best_length = 0

	for(var/procpath/candidate as anything in get_player_command_bar_verbs())
		var/spaced_name = LOWER_TEXT(candidate.name)
		var/hyphen_name = replacetext(spaced_name, " ", "-")
		for(var/form in list(spaced_name, hyphen_name))
			var/form_length = length(form)
			if(form_length <= best_length)
				continue
			if(copytext(lowered, 1, form_length + 1) != form)
				continue
			// so "say" doesn't match "sayhello"
			if(length(lowered) > form_length && copytext(lowered, form_length + 1, form_length + 2) != " ")
				continue
			best_verb = candidate
			best_length = form_length

	if(!best_verb)
		return null
	return list(best_verb, best_length)

/client/proc/sanitize_player_command_bar_arguments(arguments)
	var/list/control_characters = list()
	for(var/i in 1 to length(arguments))
		var/code = text2ascii(arguments, i)
		if(code < 32 || code == 127)
			control_characters |= ascii2text(code)
	for(var/control_character in control_characters)
		arguments = replacetext(arguments, control_character, " ")
	return trim(arguments)

// Tab is bound to this while the command bar is active, see set_player_command_bar_tab_macro()
/client/verb/player_command_bar_tab()
	set name = "player-command-bar-tab"
	set hidden = TRUE

	if(!player_command_bar_active)
		set_player_command_bar_tab_macro(FALSE)
		return

	var/focused = winget(src, "outputwindow.cmdinput", "focus") == "true"
	var/current_text = focused ? winget(src, "outputwindow.cmdinput", "text") : ""

	if(focused && length(trim(current_text)))
		complete_player_command_bar(current_text)
		return

	hide_player_command_bar_suggestions()

	switch(winget(src, "mainwindow", "macro"))
		if(SKIN_MACROSET_CLASSIC_INPUT)
			winset(src, null, "mainwindow.macro=[SKIN_MACROSET_CLASSIC_HOTKEYS];map.focus=true")
		if(SKIN_MACROSET_CLASSIC_HOTKEYS)
			winset(src, null, "mainwindow.macro=[SKIN_MACROSET_CLASSIC_INPUT];outputwindow.cmdinput.focus=true")
		else
			if(focused)
				winset(src, "map", "focus=true")
			else
				winset(src, "outputwindow.cmdinput", "focus=true")

/client/proc/complete_player_command_bar(current_text)
	if(length(player_command_bar_cycle) > 1 && current_text == player_command_bar_last_completion)
		player_command_bar_cycle_index = (player_command_bar_cycle_index % length(player_command_bar_cycle)) + 1
		set_player_command_bar_text("[player_command_bar_cycle[player_command_bar_cycle_index]] ")
		show_player_command_bar_suggestions()
		return

	player_command_bar_cycle = null
	player_command_bar_cycle_index = 0

	var/typed = trim(current_text)
	if(findtext(typed, " ") && find_player_command_bar_verb(typed))
		hide_player_command_bar_suggestions()
		return

	var/prefix = LOWER_TEXT(replacetext(typed, " ", "-"))
	var/prefix_length = length(prefix)
	var/list/matches = list()
	for(var/procpath/candidate as anything in get_player_command_bar_verbs())
		var/hyphen_name = replacetext(candidate.name, " ", "-")
		if(LOWER_TEXT(copytext(hyphen_name, 1, prefix_length + 1)) == prefix)
			matches |= hyphen_name

	if(!length(matches))
		hide_player_command_bar_suggestions()
		return

	sortTim(matches, GLOBAL_PROC_REF(cmp_text_asc))

	if(length(matches) == 1)
		hide_player_command_bar_suggestions()
		set_player_command_bar_text("[matches[1]] ")
		return

	player_command_bar_cycle = matches

	var/common = matches[1]
	for(var/match in matches)
		while(length(common) && LOWER_TEXT(copytext(match, 1, length(common) + 1)) != LOWER_TEXT(common))
			common = copytext(common, 1, length(common))
	if(length(common) > prefix_length)
		player_command_bar_cycle_index = 0
		set_player_command_bar_text(common)
		show_player_command_bar_suggestions()
		return

	player_command_bar_cycle_index = 1
	set_player_command_bar_text("[matches[1]] ")
	show_player_command_bar_suggestions()

/client/proc/set_player_command_bar_text(new_text)
	player_command_bar_last_completion = new_text
	winset(src, "outputwindow.cmdinput", list2params(list("text" = new_text, "focus" = "true")))

/client/proc/show_player_command_bar_suggestions()
	var/list/rows = list()
	for(var/i in 1 to length(player_command_bar_cycle))
		var/name = player_command_bar_cycle[i]
		var/selected = (i == player_command_bar_cycle_index) ? " class='sel'" : ""
		rows += "<a href='byond://?player_command_bar_pick=[url_encode(name)]'[selected]>[html_encode(name)]</a>"

	var/html = {"<html><head><meta charset='utf-8'><style>
		html, body {margin: 0; padding: 0; background: #140d05; overflow-x: hidden;}
		body {border: 1px solid #6b5326; font: 12px Verdana, sans-serif;}
		a {display: block; padding: 1px 6px; height: 16px; color: #e0b85a; text-decoration: none; white-space: nowrap;}
		a:hover, a.sel {background: #3a2a10; color: #fff3d0;}
		</style></head><body>[jointext(rows, "")]
		<script>var s = document.querySelector('.sel'); if(s) s.scrollIntoView({block: 'nearest'});</script>
		</body></html>"}
	src << browse(html, "window=cmdsuggest")

	var/height = min(length(rows), 8) * 18 + 2
	var/list/input_pos = splittext(winget(src, "outputwindow.cmdinput", "pos"), ",")
	var/x = text2num(input_pos[1]) || 0
	var/y = (length(input_pos) > 1 ? text2num(input_pos[2]) : 0) - height
	winset(src, "outputwindow.cmdsuggest", "pos=[x],[max(y, 0)];size=240x[height];is-visible=true")

/client/proc/hide_player_command_bar_suggestions()
	winset(src, "outputwindow.cmdsuggest", "is-visible=false")

/client/proc/pick_player_command_bar_suggestion(name)
	if(!player_command_bar_active || !istext(name))
		return
	for(var/procpath/candidate as anything in get_player_command_bar_verbs())
		var/hyphen_name = replacetext(candidate.name, " ", "-")
		if(hyphen_name == name)
			player_command_bar_cycle = null
			player_command_bar_cycle_index = 0
			hide_player_command_bar_suggestions()
			set_player_command_bar_text("[hyphen_name] ")
			return

/client/proc/set_player_command_bar_tab_macro(active)
	var/list/macro_sets = list(
		SKIN_MACROSET_HOTKEYS = SSinput.macroset_hotkey,
		SKIN_MACROSET_CLASSIC_HOTKEYS = SSinput.macroset_classic_hotkey,
		SKIN_MACROSET_CLASSIC_INPUT = SSinput.macroset_classic_input,
	)
	for(var/set_name in macro_sets)
		var/list/macro_set = macro_sets[set_name]
		if(!macro_set?["Tab"])
			continue
		var/command = active ? "player-command-bar-tab" : macro_set["Tab"]
		// id format from apply_macro_set()
		winset(src, "[set_name]-[REF("Tab")]", "command=[command]")

/client/verb/toggle_player_command_bar()
	set name = "toggle-player-command-bar"
	set hidden = TRUE

	if(holder)
		return
	set_player_command_bar(!player_command_bar_active)

/client/proc/set_player_command_bar(active, silent = FALSE)
	var/was_active = player_command_bar_active
	player_command_bar_active = active
	player_command_bar_cycle = null
	player_command_bar_last_completion = null
	hide_player_command_bar_suggestions()
	if(active != was_active)
		set_player_command_bar_tab_macro(active)
	if(active)
		winset(src, "outputwindow.input", "is-visible=false")
		winset(src, "outputwindow.cmdinput", "is-visible=true;focus=true")
		winset(src, "outputwindow.cmdbarbutton", "text=Cmd;is-checked=true")
		if(!silent)
			to_chat(src, span_notice("Command bar set to <b>COMMAND</b> mode. Only commands from my verb tabs work here."))
	else
		winset(src, "outputwindow.cmdinput", "is-visible=false")
		winset(src, "outputwindow.input", "is-visible=true;focus=true")
		winset(src, "outputwindow.cmdbarbutton", "text=Say;is-checked=false")
		if(!silent)
			to_chat(src, span_notice("Command bar set to <b>SAY</b> mode."))

/client/proc/show_player_command_bar_button()
	if(holder)
		return
	winset(src, "outputwindow.cmdbarbutton", "is-visible=true")
	winset(src, "outputwindow.input", "anchor2=92,100")
	set_player_command_bar(FALSE, TRUE)

/client/proc/hide_player_command_bar_button()
	set_player_command_bar(FALSE, TRUE)
	winset(src, "outputwindow.cmdbarbutton", "is-visible=false")
	winset(src, "outputwindow.input", "anchor2=100,100")

#undef PLAYER_COMMAND_BAR_COOLDOWN
