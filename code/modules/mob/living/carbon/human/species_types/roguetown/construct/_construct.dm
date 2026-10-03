/datum/species/construct
	name = "Constructb"
	id = "construct"

/datum/species/construct/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/construct/get_skin_list()
	return sortList(list(
	"skin1" = "ffe0d1",
	"skin2" = "fcccb3"
	))

/datum/species/construct/get_hairc_list()
	return sortList(list(
	"black - nightsky" = "0a0707",
	"brown - treebark" = "362e25",
	"blonde - moonlight" = "dfc999",
	"red - autumn" = "a34332"
	))

