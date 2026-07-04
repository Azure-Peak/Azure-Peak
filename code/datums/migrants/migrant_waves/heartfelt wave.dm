/datum/migrant_wave/heartfelt
	name = "The Court of Heartfelt"
	track = MIGRANT_TRACK_SPECIAL
	max_spawns = 1
	weight = 50
	required_roles = list(
		/datum/migrant_role/heartfelt/lord = 1,
	)
	optional_roles = list(
		/datum/migrant_role/heartfelt/hand = 1,
		/datum/migrant_role/heartfelt/knight = 1,
		/datum/migrant_role/heartfelt/retinue = 4,
	)
	min_optional_fills = 2
	greet_text = "You're the mighty Count of Heartfelt, the second most powerful lord of Azuria. Whether compelled by an invasion at the border, a sheer desire to sightsee and visit the Capital, or some political plot known only to you and your court, you have come to visit the capital of Azuria with a small, elite picked retinue."
	greet_text_by_fill = list(
		"5" = "You're the mighty Count of Heartfelt, the second most powerful lord of Azuria. Whether compelled by an invasion at the border, a sheer desire to sightsee and visit the Capital, or some political plot known only to you and your court, you have come to visit the capital of Azuria with a small, elite picked retinue.",
		"3" = "You're the mighty Count of Heartfelt, the second most powerful lord of Azuria. Whether compelled by an invasion at the border, a sheer desire to sightsee and visit the Capital, or some political plot known only to you and your court, you have come to visit the capital of Azuria with a small, elite picked retinue. Unfortunately, a few of your retinue seems to have forgotten their luggage and had to turn back.",
	)
