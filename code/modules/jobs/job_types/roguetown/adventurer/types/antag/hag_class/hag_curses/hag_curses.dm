/datum/hag_boon/buff/curse
	hag_curse = TRUE
	transmutable = FALSE
	status_type = null

/datum/hag_boon/buff/curse/choking_moss
	name = "Choking Shroud"
	desc = "Whilst on grass, dirt and snow, the bearer will grow a suffocating moss that needs to be burnt off every now and then."
	points = 40
	status_type = /datum/status_effect/buff/hag_boon/creeping_moss/curse

/datum/hag_boon/buff/curse/waterlogged
	name = "Waterlogged"
	desc = "Whilst standing in water tiles, the water itself will try to drag the bearer down, looking for entry inside of them to drown them."
	points = 25
	status_type = /datum/status_effect/curse/waterlogged

/datum/hag_boon/buff/curse/slumber
	name = "Somnabulance"
	desc = "The bearer will not find rest, each night they are sent to the dream briefly to experience the terrors of the deep."
	points = 20
	status_type = /datum/status_effect/curse/hag_slumber
