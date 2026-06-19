/proc/prune_patronage_list(list/the_list)
	if(!the_list)
		return
	for(var/mob/living/M in the_list)
		if(QDELETED(M) || M.stat == DEAD)
			the_list -= M
