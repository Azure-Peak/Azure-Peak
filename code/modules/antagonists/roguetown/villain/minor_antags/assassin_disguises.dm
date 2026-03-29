datum/outfit/job/roguetown/assassin_disguise
	var/extra_info

datum/outfit/job/roguetown/assassin_disguise/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	// Some disguises may get a little extra if they have Cool Lore or some shit. IDFK. Why not.
	if(extra_info)
		to_chat(H, extra_info)
