/mob/dead/observer/Login()
	..()
	if(client)
		client.update_ooc_verb_visibility()

	if(IsAdminGhost(src))
		has_unlimited_silicon_privilege = 1

	var/turf/T = get_turf(src)
	if(isturf(T))
		update_z(T.z)
