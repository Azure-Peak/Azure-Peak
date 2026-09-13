/mob/living/carbon/human/species/dwarf
	race = /datum/species/dwarf

/datum/species/dwarf
	name = "Dwarfb"
	id = "dwarf"
	max_age = 200
	languages = list(
		/datum/language/common,
		/datum/language/dwarvish
	)

/datum/species/dwarf/after_creation(mob/living/carbon/C)
	..()
	to_chat(C, "<span class='info'>I can speak Dwarfish with ,d before my speech.</span>")

/datum/species/dwarf/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/dwarf/get_skin_list()
	return sortList(list(
	"skin1" = "ffe0d1",
	"skin2" = "fcccb3"
	))

/datum/species/dwarf/get_hairc_list()
	return sortList(list(
	"black - nightsky" = "0a0707",
	"brown - treebark" = "362e25",
	"blonde - moonlight" = "dfc999",
	"red - autumn" = "a34332"
	))

