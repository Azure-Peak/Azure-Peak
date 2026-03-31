/*
			< ATTENTION >
	If you need to add more map_adjustment, check 'map_adjustment_include.dm'
	These 'map_adjustment.dm' files shouldn't be included in 'dme'
*/

/datum/map_adjustment/template/roguetest
	map_file_name = "roguetest.dmm"
	realm_name = "Roguetest"
	slot_adjust = list(
		/datum/job/roguetown/villager = 42,
		/datum/job/roguetown/adventurer = 69
	)
	title_adjust = list(
		/datum/job/roguetown/lord = list(display_title = "Lord Castellan", f_title = "Lady Castellan")
	)
	tutorial_adjust = list(
		/datum/job/roguetown/lord = "The Gronnmen are coming."
	)
