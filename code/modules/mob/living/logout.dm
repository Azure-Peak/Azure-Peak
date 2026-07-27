/mob/living/Logout()
	update_z(null)
	UnregisterSignal(src, GLOB.sight_trait_signals)
	..()
	if(!key && mind)	//key and mind have become separated.
		mind.active = 0	//This is to stop say, a mind.transfer_to call on a corpse causing a ghost to re-enter its body.
	if(!HAS_TRAIT(src, TRAIT_NOSSDINDICATOR))
		set_ssd_indicator(TRUE)
