/datum/controller/subsystem/treasury/proc/init_decrees()
	for(var/path in subtypesof(/datum/decree))
		var/datum/decree/D = new path()
		decrees[D.id] = D

/datum/controller/subsystem/treasury/proc/get_decree(decree_id)
	return decrees[decree_id]

/datum/controller/subsystem/treasury/proc/set_decree_active(decree_id, new_active)
	var/datum/decree/D = get_decree(decree_id)
	if(!D)
		return FALSE
	if(!D.can_change_state())
		return FALSE
	return D.set_state(new_active)
