/client
	/// A rolling buffer of any keys held currently
	var/list/keys_held = list()
	///used to keep track of the current rolling buffer position
	var/current_key_address = 0
	/// These next two vars are to apply movement for keypresses and releases made while move delayed.
	/// Because discarding that input makes the game less responsive.
 	/// On next move, add this dir to the move that would otherwise be done
	var/next_move_dir_add
 	/// On next move, subtract this dir from the move that would otherwise be done
	var/next_move_dir_sub

// Set a client's focus to an object and override these procs on that object to let it handle keypresses

/datum/proc/key_down(key, client/user) // Called when a key is pressed down initially
	return
/datum/proc/key_up(key, client/user) // Called when a key is released
	return
/datum/proc/keyLoop(client/user) // Called once every frame
	set waitfor = FALSE
	return

/client/verb/change_macrosets()
	set name = "Switch Keybinding Mode"
	set desc = "Switch between classic and modern keybinding modes."
	set category = "OOC"

	var/list/macrosets = list(
		"Classic" = SKIN_MACROSET_CLASSIC_INPUT,
		"Modern" = SKIN_MACROSET_HOTKEYS
	)
	var/choice = input("Select a keybinding mode:") as null|anything in macrosets
	if(!choice)
		return
	winset(src, null, "mainwindow.macro=[macrosets[choice]]")

/client/verb/fix_macros()
	set name = "Fix Keybindings"
	set desc = "Re-assert all your macros/keybindings."
	set category = "OOC"
	if(!SSinput.initialized)
		to_chat(src, "<span class='warning'>Input hasn't been initialized yet. Wait a while.</span>")
		return
	to_chat(src, "<span class='danger'>Force-reasserting all macros.</span>")
	set_macros()

// removes all the existing macros
/client/proc/erase_all_macros()
	var/erase_output = ""
	var/list/macro_set = params2list(winget(src, "default.*", "command")) // The third arg doesnt matter here as we're just removing them all
	for(var/k in 1 to length(macro_set))
		var/list/split_name = splittext(macro_set[k], ".")
		var/macro_name = "[split_name[1]].[split_name[2]]" // [3] is "command"
		erase_output = "[erase_output];[macro_name].parent=null"
	winset(src, null, erase_output)

/client/proc/apply_macro_set(name, list/macroset)
	ASSERT(name)
	ASSERT(islist(macroset))
	winclone(src, "default", name)
	for(var/i in 1 to length(macroset))
		var/key = macroset[i]
		var/command = macroset[key]
		winset(src, "[name]-[REF(key)]", "parent=[name];name=[key];command=[command]")

/client/proc/ensure_keys_set(datum/preferences/prefs_override = prefs)
	if(SSinput.initialized)
		full_macro_assert(prefs_override)

/client/proc/full_macro_assert(datum/preferences/prefs_override = prefs)
	INVOKE_ASYNC(src, PROC_REF(set_macros), prefs_override)

/client/proc/set_macros(datum/preferences/prefs_override = prefs)
	set waitfor = FALSE

	// First, wipe
	keys_held.Cut()

	erase_all_macros()
	update_movement_keys()
	// First, collect sets. Make sure to COPY, as we are modifying these!	
	var/list/macrosets = prefs_override.hotkeys? list(
			SKIN_MACROSET_HOTKEYS = SSinput.macroset_hotkey.Copy()
		) : list(
			SKIN_MACROSET_CLASSIC_INPUT = SSinput.macroset_classic_input.Copy(),
			SKIN_MACROSET_CLASSIC_HOTKEYS = SSinput.macroset_classic_hotkey.Copy()
		)
	// Collect special clientside keybinds
	var/list/clientside = update_special_keybinds(prefs_override)
	// ANTI COLLISION SYSTEM:
	// If hotkey, do "standard" anti collision permutation
	// We fully permutate alt/ctrl/shift with the key and then subtract the key's actual binding.
	// Then, we set all the permutations BUT the actual binding to nonsensical things to force BYOND to not
	// be "greedy" with key matching, aka matching Shift+T for T when Shift+T isn't EXPLICITLY defined.
	// This is extremely ugly, but the alternative is arguably worse (manually binding every key instead of using ANY)
	if(prefs_override.hotkeys)
		for(var/keybind in clientside)
			var/command = clientside[keybind]
			var/alt = findtext(keybind, "Alt")
			if(alt)
				keybind = copytext(keybind, 1, alt) + copytext(keybind, alt + 3, 0)
			var/ctrl = findtext(keybind, "Ctrl")
			if(ctrl)
				keybind = copytext(keybind, 1, ctrl) + copytext(keybind, ctrl + 4, 0)
			var/shift = findtext(keybind, "Shift")
			if(shift)
				keybind = copytext(keybind, 1, shift) + copytext(keybind, shift + 5, 0)
			var/actual = "[alt? "Alt+" : ""][ctrl? "Ctrl+" : ""][shift? "Shift+" : ""][keybind]"
			var/list/overriding = keybind_modifier_permutation(keybind, alt, ctrl, shift, TRUE)
			overriding -= actual
			for(var/macroset in macrosets)
				var/list/the_set = macrosets[macroset]
				the_set[actual] = command
				for(var/i in overriding)
					the_set[i] = NONSENSICAL_VERB
	else
		// For classic mode, we just directly set things because BYOND is so jank why do we even bother?
		// What we want is to force Ctrl on for all keybinds without Ctrl or Alt set, to preserve old behavior
		for(var/keybind in clientside)
			var/command = clientside[keybind]
			var/alt = findtext(keybind, "Alt")
			if(alt)
				keybind = copytext(keybind, 1, alt) + copytext(keybind, alt + 3, 0)
			var/ctrl = findtext(keybind, "Ctrl")
			if(ctrl)
				keybind = copytext(keybind, 1, ctrl) + copytext(keybind, ctrl + 4, 0)
			var/shift = findtext(keybind, "Shift")
			if(shift)
				keybind = copytext(keybind, 1, shift) + copytext(keybind, shift + 5, 0)
			var/actual
			if(!alt && !ctrl)
				actual = "Ctrl+[keybind]"
			else
				actual = "[alt? "Alt+" : ""][ctrl? "Ctrl+" : ""][shift? "Shift+" : ""][keybind]"
			macrosets[SKIN_MACROSET_CLASSIC_HOTKEYS]["[alt? "Alt+" : ""][ctrl? "Ctrl+" : ""][shift? "Shift+" : ""][keybind]"] = command
			macrosets[SKIN_MACROSET_CLASSIC_INPUT][actual] = command
			for(var/macroset in macrosets)
				var/list/the_set = macrosets[macroset]
				the_set[actual] = command
	
	apply_macro_set(SKIN_MACROSET_HOTKEYS, SSinput.macroset_hotkey)
	apply_macro_set(SKIN_MACROSET_CLASSIC_HOTKEYS, SSinput.macroset_classic_hotkey)
	apply_macro_set(SKIN_MACROSET_CLASSIC_INPUT, SSinput.macroset_classic_input)

	set_hotkeys_preference()
	set_hotkeys_button(prefs_override.hotkeys)

/proc/keybind_modifier_permutation(key, alt = FALSE, ctrl = FALSE, shift = FALSE, self = TRUE)
	var/list/permutations = list()
	if(!shift)
		permutations += "Shift"
	if(!ctrl)
		permutations += "Ctrl"
	if(!alt)
		permutations += "Alt"
	// ALT + CTRL + SHIFT
	. = list()
	do_keybind_modifier_permutations(key, permutations, .)
	if(self)
		. += key

/proc/do_keybind_modifier_permutations(key, list/permutations = list(), list/out = list())
	. = out
	for(var/mod in permutations.Copy())
		permutations -= mod
		. += "[mod]+[key]"
		do_keybind_modifier_permutations("[mod]+[key]", permutations.Copy(), .)

/client/proc/set_hotkeys_preference(datum/preferences/prefs_override = prefs)
	if(prefs_override.hotkeys)
		winset(src, null, "map.focus=true input.background-color=[COLOR_INPUT_DISABLED] mainwindow.macro=[SKIN_MACROSET_HOTKEYS]")
	else
		winset(src, null, "input.focus=true input.background-color=[COLOR_INPUT_ENABLED] mainwindow.macro=[SKIN_MACROSET_CLASSIC_INPUT]")

/client/proc/set_hotkeys_button(toggled)
	winset(src, "hotkey_toggle", "is-checked=[toggled? "true" : "false"]")

/**
  * Updates the keybinds for special keys
  *
  * Handles adding macros for the keys that need it
  * And adding movement keys to the clients movement_keys list
  * At the time of writing this, communication(OOC, Say, IC) require macros
  * Arguments:
  * * direct_prefs - the preference we're going to get keybinds from
  *
  * Returns list of special keybind in key = Mod1Mod2Mod3Key format, NOT Mod1+Mod2+Mod3+Key format.
  */
/client/proc/update_special_keybinds(datum/preferences/direct_prefs)
	var/datum/preferences/D = direct_prefs || prefs
	if(!D?.key_bindings)
		return
	movement_keys = list()
	. = list()
	for(var/key in D.key_bindings)
		for(var/kb_name in D.key_bindings[key])
			switch(kb_name)
				if("North")
					movement_keys[key] = NORTH
				if("East")
					movement_keys[key] = EAST
				if("West")
					movement_keys[key] = WEST
				if("South")
					movement_keys[key] = SOUTH
				else
					var/datum/keybinding/KB = GLOB.keybindings_by_name[kb_name]
					if(!KB.clientside)
						continue
					.[key] = KB.clientside