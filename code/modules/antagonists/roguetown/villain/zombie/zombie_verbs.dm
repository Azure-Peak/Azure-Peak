var/SEEK_BRAINS_COOLDOWN = 30 SECONDS
//var/last_seek_brains_use varable is found in carbon_defines.dm
//this will certainly bite me in the ass inevitably, but whatever.
//you can't spam this verb inhumanly fast and lag us on highpop w/checks at least.

/mob/living/carbon/human/proc/zombie_seek()
	set name = "Seek Brains"
	set category = "RoleUnique.Zombie"

	if(world.time < src.last_seek_brains_use + SEEK_BRAINS_COOLDOWN)
		var/remaining = round((src.last_seek_brains_use + SEEK_BRAINS_COOLDOWN - world.time) / 10, 1)
		to_chat(src, span_warning("You must wait [remaining] seconds before using Seek again!"))
		return

	//set cooldown
	src.last_seek_brains_use = world.time
	//we do this before the checks because if we have this as a non-zombie, something is VERY wrong.
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
		if(HAS_TRAIT(humie, TRAIT_ZOMBIE_IMMUNE)) //no point hunting what you can't convert
			continue
		if(HAS_TRAIT(humie, TRAIT_NPC_EXAMINE)) //no point hunting NPCs
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
	to_chat(src, span_warning("[pick("Flesh","Consume","Food","Lyving","Find it","Rasping thing")] [closest_dist] meters away, [dir2text(the_dir)]..."))
	src.playsound_local(loc, 'sound/misc/notice.ogg', 30, TRUE)
	return TRUE
