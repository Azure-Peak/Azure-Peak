/proc/noble_rank_examine_line(rank)
	switch(rank)
		if(NOBLE_RANK_ROYAL)
			return "A royal - directly related to, or fostered by the Grand Duke."
		if(NOBLE_RANK_PEER)
			return "A peer, one of the many great magnates of this land with plenty of influence and wealth."
		if(NOBLE_RANK_GENTRY)
			return "One of the gentries, a knight, foreigner, or someone with minor holdings."
	return null
