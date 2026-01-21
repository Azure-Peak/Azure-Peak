/datum/migrant_wave/heartfelt
	name = "The Court of Heartfelt"
	max_spawns = 1
	shared_wave_type = /datum/migrant_wave/heartfelt
	weight = 50
	downgrade_wave = /datum/migrant_wave/heartfelt_down_one
	roles = list(
		/datum/migrant_role/heartfelt/lord = 1,
		/datum/migrant_role/heartfelt/hand = 1,
		/datum/migrant_role/heartfelt/knight = 1,
		/datum/migrant_role/heartfelt/retinue = 4,
	)
	greet_text = "Fleeing disaster, you have come together as a court, united in a final effort to restore the former glory and promise of Heartfelt. Stay close and watch out for each other, for all of your sakes!"

/datum/migrant_wave/heartfelt_down_one
	name = "The Court of Heartfelt"
	shared_wave_type = /datum/migrant_wave/heartfelt
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/heartfelt_down_two
	roles = list(
		/datum/migrant_role/heartfelt/lord = 1,
		/datum/migrant_role/heartfelt/hand = 1,
		/datum/migrant_role/heartfelt/knight = 1,
		/datum/migrant_role/heartfelt/retinue = 3,
	)
	greet_text = "Fleeing disaster, you have come together as a court, united in a final effort to restore the former glory and promise of Heartfelt. Stay close and watch out for each other, for all of your sakes! Some of you already did not make it on the way here..."

/datum/migrant_wave/heartfelt_down_two
	name = "The Court of Heartfelt"
	shared_wave_type = /datum/migrant_wave/heartfelt
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/heartfelt_down_three
	roles = list(
		/datum/migrant_role/heartfelt/lord = 1,
		/datum/migrant_role/heartfelt/hand = 1,
		/datum/migrant_role/heartfelt/knight = 1,
		/datum/migrant_role/heartfelt/retinue = 2,
	)
	greet_text = "Fleeing disaster, you have come together as a court, united in a final effort to restore the former glory and promise of Heartfelt. Stay close and watch out for each other, for all of your sakes! Some of you already did not make it on the way here..."


/datum/migrant_wave/heartfelt_down_three
	name = "The Court of Heartfelt"
	shared_wave_type = /datum/migrant_wave/heartfelt
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/heartfelt_down_four
	roles = list(
		/datum/migrant_role/heartfelt/lord = 1,
		/datum/migrant_role/heartfelt/knight = 1,
		/datum/migrant_role/heartfelt/hand = 1,
		/datum/migrant_role/heartfelt/retinue = 1,
	)
	greet_text = "Fleeing disaster, you have come together as a court, united in a final effort to restore the former glory and promise of Heartfelt. Stay close and watch out for each other, for all of your sakes! Some of you already did not make it on the way here..."

/datum/migrant_wave/heartfelt_down_four
	name = "The Court of Heartfelt"
	shared_wave_type = /datum/migrant_wave/heartfelt
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/heartfelt_down_five
	roles = list(
		/datum/migrant_role/heartfelt/lord = 1,
		/datum/migrant_role/heartfelt/hand = 1,
		/datum/migrant_role/heartfelt/knight = 1,
	)
	greet_text = "Fleeing disaster, you have come together as a court, united in a final effort to restore the former glory and promise of Heartfelt. Stay close and watch out for each other, for all of your sakes! Some of you already did not make it on the way here..."

/datum/migrant_wave/heartfelt_down_five
	name = "The Court of Heartfelt"
	shared_wave_type = /datum/migrant_wave/heartfelt
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/heartfelt_down_six
	roles = list(
		/datum/migrant_role/heartfelt/lord = 1,
		/datum/migrant_role/heartfelt/hand = 1,
		/datum/migrant_role/heartfelt/retinue = 1,
	)
	greet_text = "Fleeing disaster, you came together as a court, united in a final effort to restore the former glory and promise of Heartfelt. Stay close and watch out for each other, for all of your sakes! Some of you already did not make it on the way here..."

/datum/migrant_wave/heartfelt_down_six
	name = "The Court of Heartfelt"
	shared_wave_type = /datum/migrant_wave/heartfelt
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/heartfelt_down_seven
	roles = list(
		/datum/migrant_role/heartfelt/lord = 1,
		/datum/migrant_role/heartfelt/retinue = 2,
	)
	greet_text = "Fleeing disaster, you came together as a court, united in a final effort to restore the former glory and promise of Heartfelt. Stay close and watch out for each other, for all of your sakes! Some of you already did not make it on the way here..."

/datum/migrant_wave/heartfelt_down_seven
	name = "The Court of Heartfelt"
	shared_wave_type = /datum/migrant_wave/heartfelt
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/heartfelt_down_eight
	roles = list(
		/datum/migrant_role/heartfelt/lord = 1,
		/datum/migrant_role/heartfelt/knight = 1,
	)
	greet_text = "Fleeing disaster, you came together as a court, united in a final effort to restore the former glory and promise of Heartfelt. Now, in the end, it is only the Lord and their trusty knight left on their lonesome..."

/datum/migrant_wave/heartfelt_down_eight
	name = "The Court of Heartfelt"
	shared_wave_type = /datum/migrant_wave/heartfelt
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/heartfelt_down_nine
	roles = list(
		/datum/migrant_role/heartfelt/lord = 1,
		/datum/migrant_role/heartfelt/hand = 1,
	)
	greet_text = "Fleeing disaster, you came together as a court, united in a final effort to restore the former glory and promise of Heartfelt. Now, in the end, it is only the Lord and their trusty Hand left on their lonesome..."

/datum/migrant_wave/heartfelt_down_nine
	name = "The Court of Heartfelt"
	shared_wave_type = /datum/migrant_wave/heartfelt
	downgrade_wave = /datum/migrant_wave/heartfelt_down_ten
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/heartfelt/lord = 1,
		/datum/migrant_role/heartfelt/retinue = 1,
	)
	greet_text = "Fleeing disaster, you have came together as a court, united in a final effort to restore the former glory and promise of Heartfelt. Now, in the end, it is only the Lord and their last loyal follower left on their lonesome..."

/datum/migrant_wave/heartfelt_down_ten
	name = "The Court of Heartfelt"
	shared_wave_type = /datum/migrant_wave/heartfelt
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/heartfelt/lord = 1,
	)
	greet_text = "Fleeing disaster, you have came together as a court, united in a final effort to restore the former glory and promise of Heartfelt. It was all for naught - in the end, only you are left, bereft of your family and men. How the mighty have fallen..."
