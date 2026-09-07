/*
	Keep in mind the thing stored on the mind is a key
	Thus we mus convert it to a ckey
*/
/datum/mind/proc/adjust_triumphs(amt, counted = TRUE, source)
	if(!key)
		return
	var/ckeey = ckey(key)
	SStriumphs.triumph_adjust(amt, ckeey, source)
	SStriumphs.adjust_leaderboard(key)

	if(amt > 0)
		if(counted)
			record_round_statistic(STATS_TRIUMPHS_AWARDED, amt)
		if(current)
			to_chat(current, "\n<font color='purple'>[amt] TRIUMPH(S) awarded.</font>")
	else if(amt < 0)
		if(counted)
			record_round_statistic(STATS_TRIUMPHS_STOLEN, amt)
		if(current)
			to_chat(current, "\n<font color='purple'>[amt*-1] TRIUMPH(S) lost.</font>")



/*
	A client will only exist when a client is live
	So we can always get a ckey.
*/
/client/proc/adjust_triumphs(amt, counted = TRUE, source)
	if(!amt)
		return

	SStriumphs.triumph_adjust(amt, ckey, source)
	SStriumphs.adjust_leaderboard(key)

	if(amt > 0)
		if(counted)
			record_round_statistic(STATS_TRIUMPHS_AWARDED, amt)
		to_chat(src, "\n<font color='purple'>[amt] TRIUMPH(S) awarded.</font>")
	else if(amt < 0)
		if(counted)
			record_round_statistic(STATS_TRIUMPHS_STOLEN, amt)
		to_chat(src, "\n<font color='purple'>[amt*-1] TRIUMPH(S) lost.</font>")

/*
	mobs also got ckeys p simple
*/
/mob/proc/adjust_triumphs(amt, counted = TRUE, source)
	if(!ckey)
		return
	else
		SStriumphs.triumph_adjust(amt, ckey, source)
		SStriumphs.adjust_leaderboard(key)

	if(amt > 0)
		if(counted)
			record_round_statistic(STATS_TRIUMPHS_AWARDED, amt)
		to_chat(src, "\n<font color='purple'>[amt] TRIUMPH(S) awarded.</font>")
	else if(amt < 0)
		if(counted)
			record_round_statistic(STATS_TRIUMPHS_STOLEN, amt)
		to_chat(src, "\n<font color='purple'>[amt*-1] TRIUMPH(S) lost.</font>")
