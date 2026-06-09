/mob
	var/tgui_multiline = TRUE

/mob/verb/toggle_tgui_multiline()
	set name = "Toggle TGUI Multiline"
	set category = "Options"

	tgui_multiline = !tgui_multiline
	to_chat(src,span_notice("TGUI Multiline is now [tgui_multiline ? "Enabled" : "Disabled"]"))
