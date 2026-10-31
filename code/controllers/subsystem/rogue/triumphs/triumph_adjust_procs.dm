/proc/triumph_adjust_message(amt, reason)
	var/count = abs(amt)
	var/noun = count == 1 ? "TRIUMPH" : "TRIUMPHS"
	var/line = amt > 0 ? "[count] [noun] awarded." : "[count] [noun] lost."
	return "\n<font color='purple'>[reason ? "[reason]\n" : ""][line]</font>"

/*
	Keep in mind the thing stored on the mind is a key
	Thus we mus convert it to a ckey
*/
/datum/mind/proc/adjust_triumphs(amt, counted = TRUE, source, reason)
	if(!key)
		return
	var/ckeey = ckey(key)
	SStriumphs.triumph_adjust(amt, ckeey, source)
	SStriumphs.adjust_leaderboard(key)

	if(amt > 0)
		if(counted)
			record_round_statistic(STATS_TRIUMPHS_AWARDED, amt)
		if(current)
			to_chat(current, triumph_adjust_message(amt, reason))
	else if(amt < 0)
		if(counted)
			record_round_statistic(STATS_TRIUMPHS_STOLEN, amt)
		if(current)
			to_chat(current, triumph_adjust_message(amt, reason))



/*
	A client will only exist when a client is live
	So we can always get a ckey.
*/
/client/proc/adjust_triumphs(amt, counted = TRUE, source, reason)
	if(!amt)
		return

	SStriumphs.triumph_adjust(amt, ckey, source)
	SStriumphs.adjust_leaderboard(key)

	if(amt > 0)
		if(counted)
			record_round_statistic(STATS_TRIUMPHS_AWARDED, amt)
		to_chat(src, triumph_adjust_message(amt, reason))
	else if(amt < 0)
		if(counted)
			record_round_statistic(STATS_TRIUMPHS_STOLEN, amt)
		to_chat(src, triumph_adjust_message(amt, reason))

/*
	mobs also got ckeys p simple
*/
/mob/proc/adjust_triumphs(amt, counted = TRUE, source, reason)
	if(!ckey)
		return
	else
		SStriumphs.triumph_adjust(amt, ckey, source)
		SStriumphs.adjust_leaderboard(key)

	if(amt > 0)
		if(counted)
			record_round_statistic(STATS_TRIUMPHS_AWARDED, amt)
		to_chat(src, triumph_adjust_message(amt, reason))
	else if(amt < 0)
		if(counted)
			record_round_statistic(STATS_TRIUMPHS_STOLEN, amt)
		to_chat(src, triumph_adjust_message(amt, reason))
