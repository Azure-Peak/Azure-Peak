/datum/migrant_role/tomorzurkh/lord
	name = "Tomorzurkh Lord"
	greet_text = "You're one of many Lords of Tomorzurkh who've sworn loyalty to the Aavnic Potentate. You've come here for matters of diplomacy, conflicts, or simply passing through to assist in old alliances. You are to lead your Retinue and bring honor to the Potentate. "
	allowed_races = list(/datum/species/human/northern,/datum/species/lupian,/datum/species/demihuman,/datum/species/halforc, /datum/species/human/halfelf)
	grant_lit_torch = FALSE
	advclass_cat_rolls = list(CTAG_TOMOR_LORD = 20)
	show_wanderer_examine = FALSE

/datum/migrant_role/tomorzurkh/heir
	name = "Tomorzurkh Lord's Heir"
	greet_text = "You are the Tomorzurkh Lord's Heir, or perhaps one of many. Your parent has brought you into this venture - willingly or not - for the sake of gaining experience and knowing the realms beyond your home."
	allowed_races = list(/datum/species/human/northern,/datum/species/lupian,/datum/species/demihuman,/datum/species/halforc, /datum/species/human/halfelf)
	grant_lit_torch = FALSE
	advclass_cat_rolls = list(CTAG_TOMOR_HEIR = 20)
	show_wanderer_examine = FALSE

/datum/migrant_role/tomorzurkh/hussar
	name = "Aavnic Hussar"
	greet_text = "You're an Aavnic Hussar granted to one of the Lords of Tomorzurkh by the Potentate themselves; sworn to them by oath. You're accompanied by your retainer."
	outfit = /datum/outfit/job/roguetown/heartfelt/cloak //Is just tabard
	allowed_races = list(/datum/species/human/northern,/datum/species/lupian,/datum/species/demihuman, /datum/species/lizardfolk,/datum/species/dracon, /datum/species/tabaxi,/datum/species/halforc, /datum/species/human/halfelf,datum/species/elf/wood)
	grant_lit_torch = FALSE
	advclass_cat_rolls = list(CTAG_TOMOR_HUSSAR = 20)
	show_wanderer_examine = FALSE

/datum/migrant_role/tomorzurkh/hussar/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
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
		S.name = "hussar's tabard ([index])"
	var/prev_real_name = H.real_name
	var/prev_name = H.name
	var/honorary = "Ser"
	if(H.titles_pref == TITLES_F)
		honorary = "Dame"
	// check if they already have it to avoid stacking titles
	if(findtextEx(H.real_name, "[honorary] ") == 0)
		H.real_name = "[honorary] [prev_real_name]"
		H.name = "[honorary] [prev_name]"

/datum/migrant_role/tomorzurkh/retainer
	name = "Hussar's Retainer"
	greet_text = "You're one of the Hussars' retainers, called forth by your Knight and  your Lord into their travels - experienced in riding and tending to your Hussar's needs."
	outfit = /datum/outfit/job/roguetown/migrant/surcoat
	allowed_races = RACES_NO_CONSTRUCT
	grant_lit_torch = TRUE
	advclass_cat_rolls = list(CTAG_TOMOR_RETAINER = 20)
	show_wanderer_examine = FALSE
	horse = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck/tame/saddled

/datum/outfit/job/roguetown/migrant/surcoat/pre_equip(mob/living/carbon/human/H)
	cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat

/datum/migrant_role/tomorzurkh/retainer/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
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
			S.name = "retainer's tabard ([index])"

/datum/migrant_role/tomorzurkh/servant
	name = "Tomorzurkh Servant"
	greet_text = "You're one of the Lord's most trusted and loyal servants, taken along with them and their posse in their travels to Azuria. Your only goals are to ensure that the Lord and their Heir are comfortable and taken care of."
	allowed_races = RACES_NO_CONSTRUCT
	grant_lit_torch = TRUE
	advclass_cat_rolls = list(CTAG_TOMOR_SERVANT = 20)
	show_wanderer_examine = FALSE
