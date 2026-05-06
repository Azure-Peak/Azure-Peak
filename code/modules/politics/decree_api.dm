/datum/controller/subsystem/treasury/proc/init_decrees()
	for(var/path in subtypesof(/datum/decree))
		var/datum/decree/D = new path()
		decrees[D.id] = D
	steward_machine?.enforce_wage_floors()

/datum/controller/subsystem/treasury/proc/get_decree(decree_id)
	return decrees[decree_id]

/datum/controller/subsystem/treasury/proc/can_change_decree_state(new_active)
	if(new_active)
		return decree_restore_used_day != GLOB.dayspassed
	return decree_revoke_used_day != GLOB.dayspassed

/datum/controller/subsystem/treasury/proc/set_decree_active(decree_id, new_active)
	var/datum/decree/D = get_decree(decree_id)
	if(!D)
		return FALSE
	// Bankruptcy lock: charters suspended by receivership are immutable through this path,
	// and the Golden Bull cannot be revoked while the Crown is in receivership.
	if(!can_mutate_decree(decree_id, new_active))
		return FALSE
	if(!D.can_change_state())
		return FALSE
	if(D.active == new_active)
		return FALSE
	if(!can_change_decree_state(new_active))
		return FALSE
	if(!D.set_state(new_active))
		return FALSE
	if(new_active)
		decree_restore_used_day = GLOB.dayspassed
	else
		decree_revoke_used_day = GLOB.dayspassed
	log_game("CHARTER: [usr ? key_name(usr) : "system"] [new_active ? "restored" : "revoked"] [D.name]")
	return TRUE
