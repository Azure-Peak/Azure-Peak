/datum/migrant_role/czwarteki/lord
	name = "Czwarteki Lord"
	greet_text = "You are one of many Lords within the Czwarteki Commonwealth, be it to have come for Diplomacy, War, or simple passing through to assist in old alliances. You are to lead your Retinue and bring honor to the Commonwealth. "
	allowed_races = list(/datum/species/human/northern,/datum/species/lupian,/datum/species/demihuman)
	grant_lit_torch = FALSE
	advclass_cat_rolls = list(CTAG_CZWAR_LORD = 20)
	show_wanderer_examine = FALSE

/datum/migrant_role/czwarteki/heir
	name = "Czwarteki Heir"
	greet_text = "You are the Czwarteki Lords Heir. Or perhaps one of many. Brought with you by your Parent to march forth on this venture. And to gain experience in the realms beyond your home."
	allowed_races = list(/datum/species/human/northern,/datum/species/lupian,/datum/species/demihuman)
	grant_lit_torch = FALSE
	advclass_cat_rolls = list(CTAG_CZWAR_HEIR = 20)
	show_wanderer_examine = FALSE

/datum/migrant_role/czwarteki/hussar
	name = "Czwarteki Hussar"
	greet_text = "You are a Hussar of Czwarteki, under the oath of your lord. You have raised your Journeyman to come with you to cross the lands. "
	outfit = /datum/outfit/job/roguetown/heartfelt/cloak //Is just tabard
	allowed_races = list(/datum/species/human/northern,/datum/species/lupian,/datum/species/demihuman,/datum/species/tieberian, /datum/species/lizardfolk,/datum/species/anthromorph,/datum/species/dracon, /datum/species/tabaxi)
	grant_lit_torch = FALSE
	advclass_cat_rolls = list(CTAG_CZWAR_HUSSAR = 20)
	show_wanderer_examine = FALSE

/datum/migrant_role/czwarteki/hussar/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
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

/datum/migrant_role/czwarteki/journeyman
	name = "Czwarteki Journeyman"
	greet_text = "You are a Retainers of your Hussars. Called forth into action. You know well how to ride. And tend to your Hussars needs."
	outfit = /datum/outfit/job/roguetown/migrant/surcoat
	allowed_races = RACES_NO_CONSTRUCT
	grant_lit_torch = TRUE
	advclass_cat_rolls = list(CTAG_CZWAR_JOURNEYMAN = 20)
	show_wanderer_examine = FALSE
	horse = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck/tame/saddled

/datum/outfit/job/roguetown/migrant/surcoat/pre_equip(mob/living/carbon/human/H)
	cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat

/datum/migrant_role/czwarteki/journeyman/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(istype(H.cloak, /obj/item/clothing/cloak/tabard/stabard/surcoat))
			var/obj/item/clothing/S = H.cloak
			var/index = findtext(H.real_name, " ")
			if(index)
				index = copytext(H.real_name, 1,index)
			if(!index)
				index = H.real_name
			S.name = "journeyman's tabard ([index])"

/datum/migrant_role/czwarteki/servant
	name = "Czwarteki Servant"
	greet_text = "You are Servants of your Lord. Taken along upon the Journey through the Vale with the Retinue. Your only goals are but to ensure your Lord and his Heir's well being upon the trip."
	allowed_races = RACES_NO_CONSTRUCT
	grant_lit_torch = TRUE
	advclass_cat_rolls = list(CTAG_CZWAR_SERVANT = 20)
	show_wanderer_examine = FALSE
