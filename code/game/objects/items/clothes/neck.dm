// Activate the devotion prayer verb from MMB
/obj/item/clothing/neck/roguetown/psicross/MiddleClick(mob/user)
	if (.)
		return
	
	user.changeNext_move(CLICK_CD_MELEE)
	var/prayer = locate(/mob/living/carbon/human/proc/clericpray) in user.verbs
	if (prayer)
		call(user, prayer)()
