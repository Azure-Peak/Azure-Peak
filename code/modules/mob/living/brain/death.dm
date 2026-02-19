/mob/living/brain/death(gibbed)
	if(stat == DEAD)
		return
	stat = DEAD

	return ..()

/mob/living/brain/gib(no_brain = FALSE, no_organs = FALSE, no_bodyparts = FALSE)
	if(loc)
		if(istype(loc, /obj/item/organ/brain))
			qdel(loc)//Gets rid of the brain item
	..()
