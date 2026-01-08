/datum/job/roguetown/orphan
	tutorial = "The world is not a kind place, and many have lost everything in the pursuit of even a meagre existence. Vagabonds are such individuals, and start with next to nothing but their skills and wits."
	outfit = null
	outfit_female = null
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	allowed_races = RACES_ALL_KINDS

	advclass_cat_rolls = list(CTAG_VAGABOND = 20)
	wanderer_examine = TRUE
	advjob_examine = FALSE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = TRUE
	same_job_respawn_delay = 10 SECONDS
	announce_latejoin = FALSE
