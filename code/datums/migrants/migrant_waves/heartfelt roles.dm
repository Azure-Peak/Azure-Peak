/datum/migrant_role/heartfelt/lord
	name = "Lord of Heartfelt"
	advclass_cat_rolls = list(CTAG_HFT_LORD = 20)
	allowed_races = RACES_NO_CONSTRUCT
	show_wanderer_examine = FALSE

/datum/migrant_role/heartfelt/hand
	name = "Hand of Heartfelt"
	advclass_cat_rolls = list(CTAG_HFT_HAND = 20)
	allowed_races = ACCEPTED_RACES
	grant_lit_torch = TRUE
	show_wanderer_examine = FALSE
	advjob_examine = FALSE

/datum/migrant_role/heartfelt/knight
	name = "Knight of Heartfelt"
	advclass_cat_rolls = list(CTAG_HFT_KNIGHT = 20)
	allowed_races = RACES_NO_CONSTRUCT
	grant_lit_torch = FALSE
	show_wanderer_examine = FALSE

/datum/migrant_role/heartfelt/knight/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(istype(H.cloak, /obj/item/clothing/cloak/tabard/knight/guard))
			var/obj/item/clothing/S = H.cloak
			var/index = findtext(H.real_name, " ")
			if(index)
				index = copytext(H.real_name, 1,index)
			if(!index)
				index = H.real_name
			S.name = "knight tabard ([index])"
		var/prev_real_name = H.real_name
		var/prev_name = H.name
		var/honorary = "Ser"
		if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
			honorary = "Dame"
		GLOB.chosen_names -= prev_real_name
		H.real_name = "[honorary] [prev_real_name]"
		H.name = "[honorary] [prev_name]"
		GLOB.chosen_names += H.real_name

/datum/migrant_role/heartfelt/retinue
	name = "Heartfeltian Retinue"
	advclass_cat_rolls = list(CTAG_HFT_RETINUE = 20)
	allowed_races = ACCEPTED_RACES
	grant_lit_torch = FALSE
	show_wanderer_examine = FALSE
