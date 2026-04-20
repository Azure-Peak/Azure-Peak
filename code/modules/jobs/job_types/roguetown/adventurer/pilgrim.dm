/datum/job/roguetown/pilgrim
	title = "Pilgrim"
	flag = PILGRIM
	department_flag = WANDERERS
	faction = "Station"
	total_positions = 0
	spawn_positions = 0 //disables round-start spawn of pilgrims but allows migrant waves
	allowed_races = RACES_ALL_KINDS
	tutorial = "Fleeing misfortune you head your way towards Azure Peak, you're not a soldier or an explorer, but a humble migrant trying to look for a better life, if you get to survive the trip that is."

	outfit = null
	outfit_female = null
	bypass_lastclass = TRUE
	bypass_jobban = FALSE
	

	advclass_cat_rolls = list(CTAG_PILGRIM = 20)
	PQ_boost_divider = 10

	announce_latejoin = FALSE
	display_order = JDO_PILGRIM
	min_pq = -20
	max_pq = null
	wanderer_examine = TRUE
	advjob_examine = TRUE
	always_show_on_latechoices = FALSE
	same_job_respawn_delay = 0
