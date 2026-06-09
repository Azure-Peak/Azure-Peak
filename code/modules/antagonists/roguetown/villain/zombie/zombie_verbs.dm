/mob/living/carbon/human/proc/zombie_seek()
	set name = "Seek Brains"
	set category = "ZOMBIE"

	if(!mind.has_antag_datum(/datum/antagonist/zombie))
		return FALSE
	if(stat >= UNCONSCIOUS)
		return FALSE
	var/closest_dist
	var/the_dir
	for(var/mob/living/carbon/human/humie as anything in GLOB.human_list)
		if(humie == src)
			continue
		if(humie.mob_biotypes & MOB_UNDEAD)
			continue
		if(humie.stat >= DEAD)
			continue
		var/total_distance = get_dist(src, humie)
		if(!closest_dist)
			closest_dist = total_distance
			the_dir = get_dir(src, humie)
		else
			if(total_distance < closest_dist)
				closest_dist = total_distance
				the_dir = get_dir(src, humie)
	if(!closest_dist)
		to_chat(src, span_warning("I failed to smell anything..."))
		return FALSE
	to_chat(src, span_warning("[closest_dist] meters away, [dir2text(the_dir)]..."))
	return TRUE
