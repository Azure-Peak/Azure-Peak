/datum/migrant_role/heartfelt/count
	name = "Count of Heartfelt"
	advclass_cat_rolls = list(CTAG_HFT_COUNT = 20)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED RACES_HEARTFELT)
	show_wanderer_examine = FALSE

/datum/migrant_role/heartfelt/hand
	name = "Hand of Heartfelt"
	advclass_cat_rolls = list(CTAG_HFT_HAND = 20)
	forbidden_races = list(RACES_DESPISED RACES_HEARTFELT)
	grant_lit_torch = TRUE
	show_wanderer_examine = FALSE
	advjob_examine = FALSE

/datum/migrant_role/heartfelt/knight
	name = "Knight of Heartfelt"
	advclass_cat_rolls = list(CTAG_HFT_KNIGHT = 20)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED RACES_HEARTFELT)
	grant_lit_torch = FALSE
	show_wanderer_examine = FALSE
	outfit = /datum/outfit/job/roguetown/heartfelt/cloak

/datum/outfit/job/roguetown/heartfelt/cloak/pre_equip(mob/living/carbon/human/H)
	cloak = /obj/item/clothing/cloak/tabard


/datum/migrant_role/heartfelt/knight/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(!ishuman(L))
		return
	var/mob/living/carbon/human/H = L
	if(istype(H.cloak, /obj/item/clothing/cloak/tabard))
		var/obj/item/clothing/S = H.cloak
		var/index = findtext(H.real_name, " ")
		if(index)
			index = copytext(H.real_name, 1,index)
		if(!index)
			index = H.real_name
		S.name = "knight's tabard ([index])"
	var/prev_real_name = H.real_name
	var/prev_name = H.name
	var/honorary = "Ser"
	if(H.titles_pref == TITLES_F)
		honorary = "Dame"
	// check if they already have it to avoid stacking titles
	if(findtextEx(H.real_name, "[honorary] ") == 0)
		H.real_name = "[honorary] [prev_real_name]"
		H.name = "[honorary] [prev_name]"

/datum/migrant_role/heartfelt/retinue
	name = "Heartfelt Retinue"
	advclass_cat_rolls = list(CTAG_HFT_RETINUE = 20)
	forbidden_races = list(RACES_DESPISED RACES_HEARTFELT)
	grant_lit_torch = FALSE
	show_wanderer_examine = FALSE
