/client/verb/toggle_command_bar_button()
	set name = "toggle-command-bar-button"
	set hidden = TRUE

	if(!holder)
		return

	var/current = winget(src, "outputwindow.input", "command")
	if(current == "say")
		set_command_bar_mode(FALSE)
	else
		set_command_bar_mode(TRUE)

/client/proc/set_command_bar_mode(say_mode = TRUE)
	if(say_mode)
		winset(src, "outputwindow.input", "command=say")
		winset(src, "outputwindow.saybutton", "text=Say;is-checked=true")
		to_chat(src, span_notice("Command bar set to <b>SAY</b> mode. All input goes to say."))
	else
		winset(src, "outputwindow.input", "command=")
		winset(src, "outputwindow.saybutton", "text=Cmd;is-checked=false")
		to_chat(src, span_notice("Command bar set to <b>COMMAND</b> mode. Type verbs directly (e.g. say, adminhelp, ooc)."))

/client/proc/show_command_bar_button()
	if(!holder)
		return
	winset(src, "outputwindow.saybutton", "is-visible=true")
	winset(src, "outputwindow.input", "anchor2=92,100")

/client/proc/hide_command_bar_button()
	winset(src, "outputwindow.saybutton", "is-visible=false")
	winset(src, "outputwindow.input", "anchor2=100,100")
	set_command_bar_mode(TRUE)

/client/proc/check_localhost_command_bar()
	show_command_bar_button()
	var/localhost_addresses = list("127.0.0.1", "::1")
	if(isnull(address) || (address in localhost_addresses))
		set_command_bar_mode(FALSE)
		to_chat(src, span_notice("Localhost detected — command bar set to <b>COMMAND</b> mode automatically."))
