/mob/Logout()
	log_message("[key_name(src)] is no longer owning mob [src]([src.type])", LOG_OWNERSHIP)
	SStgui.on_logout(src)
	if(client)
		client.clear_soundloop_tracking()
	unset_machine()
	clear_typing_indicator()
	GLOB.player_list -= src

	SEND_SIGNAL(src, COMSIG_MOB_LOGOUT)
	..()

	if(loc)
		loc.on_log(FALSE)

	if(client)
		for(var/foo in client.player_details.post_logout_callbacks)
			var/datum/callback/CB = foo
			CB.Invoke()

	clear_important_client_contents(client)
	return TRUE
