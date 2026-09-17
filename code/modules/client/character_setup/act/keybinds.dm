/datum/preferences/proc/ui_act_keybinds(action, list/params, datum/tgui/ui, datum/ui_state/state)
	var/mob/user = ui.user

	switch(action)
		if("keybindings_capture")
			var/datum/keybinding/kb = GLOB.keybindings_by_name[params["keybinding"]]
			if(!kb)
				return TRUE
			var/old_key = params["old_key"]
			CaptureKeybinding(user, kb, old_key)
			return TRUE

		if("keybindings_set")
			KeybindingSet(
				user,
				params["keybinding"],
				text2num(params["clear_key"]),
				params["old_key"],
				params["key"],
				text2num(params["alt"]),
				text2num(params["ctrl"]),
				text2num(params["shift"]),
				text2num(params["numpad"])
			)
			return TRUE

		if("keybindings_reset")
			var/choice = tgalert(user, "Do you really want to reset your keybindings?", "Setup keybindings", "Do It", "Cancel")
			if(choice == "Cancel")
				return TRUE
			key_bindings = deepCopyList(GLOB.hotkey_keybinding_list_by_key)
			user.client.update_movement_keys()
			return TRUE

/datum/preferences/proc/CaptureKeybinding(mob/user, datum/keybinding/kb, old_key)
	var/HTML = {"
	<div id='focus' style="outline: 0;" tabindex=0>Keybinding: [kb.full_name]<br>[kb.description]<br><br><b>Press any key to change<br>Press ESC to clear</b></div>
	<script>
	var deedDone = false;
	document.onkeyup = function(e) {
		if(deedDone){ return; }
		var alt = e.altKey ? 1 : 0;
		var ctrl = e.ctrlKey ? 1 : 0;
		var shift = e.shiftKey ? 1 : 0;
		var numpad = (95 < e.keyCode && e.keyCode < 112) ? 1 : 0;
		var escPressed = e.keyCode == 27 ? 1 : 0;
		var url = 'byond://?_src_=prefs;preference=keybindings_set;keybinding=[kb.name];old_key=[old_key];clear_key='+escPressed+';key='+e.key+';alt='+alt+';ctrl='+ctrl+';shift='+shift+';numpad='+numpad+';key_code='+e.keyCode;
		window.location=url;
		deedDone = true;
	}
	document.getElementById('focus').focus();
	</script>
	"}
	winshow(user, "capturekeypress", TRUE)
	var/datum/browser/noclose/popup = new(user, "capturekeypress", "<div align='center'>Keybindings</div>", 350, 300)
	popup.set_content(HTML)
	popup.open(FALSE)
	onclose(user, "capturekeypress", src)

/datum/preferences/proc/KeybindingSet(mob/user, kb_name, clear_key, old_key, new_key, alt_mod, ctrl_mod, shift_mod, numpad)
	// no matter what we gotta kill the window because it only fires once ever
	user << browse(null, "window=capturekeypress")

	if(!kb_name)
		return

	if(clear_key)
		if(key_bindings[old_key])
			key_bindings[old_key] -= kb_name
			if(!length(key_bindings[old_key]))
				key_bindings -= old_key
		parent.update_movement_keys()
		save_preferences()
		// the keybindings capture window is outside of the tgui flow
		ShowChoices(user)
		return

	new_key = uppertext(new_key)
	var/AltMod = alt_mod ? "Alt" : ""
	var/CtrlMod = ctrl_mod ? "Ctrl" : ""
	var/ShiftMod = shift_mod ? "Shift" : ""
	var/NPad = numpad ? "Numpad" : ""

	if(GLOB._kbMap[new_key])
		new_key = GLOB._kbMap[new_key]

	var/full_key
	switch(new_key)
		if("Alt")
			full_key = "[new_key][CtrlMod][ShiftMod]"
		if("Ctrl")
			full_key = "[AltMod][new_key][ShiftMod]"
		if("Shift")
			full_key = "[AltMod][CtrlMod][new_key]"
		else
			full_key = "[AltMod][CtrlMod][ShiftMod][NPad][new_key]"

	if(key_bindings[old_key])
		key_bindings[old_key] -= kb_name
		if(!length(key_bindings[old_key]))
			key_bindings -= old_key
	key_bindings[full_key] += list(kb_name)
	key_bindings[full_key] = sortList(key_bindings[full_key])

	parent.update_movement_keys()
	save_preferences()
	// the keybindings capture window is outside of the tgui flow
	ShowChoices(user)
