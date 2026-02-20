/client/proc/local_lightsout()
	set category = "-GameMaster-"
	set name = "Local Lightsout"

	if(!check_rights(R_ADMIN))
		return

	for(var/obj/O in view(usr.client))
		O.extinguish()
		if(O.type == /obj/machinery/light/roguestreet/)
			var/obj/machinery/light/roguestreet/streetlamp = O
			streetlamp.lights_out()
	var/turf/loc = usr.loc
	message_admins(span_adminnotice("[key_name_admin(usr)] turned the lights out at [loc.x], [loc.y], [loc.z]"))
