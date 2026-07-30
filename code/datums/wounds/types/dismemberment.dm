/datum/wound/dismemberment
	name = "bleeding stump"
	check_name = span_danger("<B>STUMP</B>")
	severity = WOUND_SEVERITY_CRITICAL
	whp = 120	//Emerald Summit parity — passive healing was deleting the stump (and its bleed) far too fast at 75
	sewn_whp = 25
	bleed_rate = 25
	sewn_bleed_rate = 0.25
	clotting_threshold = 3	//cauterize_wound() only reduces bleeding on wounds with a threshold; clotting_rate 0 still prevents self-clotting
	clotting_rate = 0
	sewn_clotting_threshold = null
	woundpain = 100
	sewn_woundpain = 20
	sew_threshold = 100 //absolutely awful to sew up
	mob_overlay = "dis_head"
	can_sew = TRUE
	can_cauterize = TRUE
	critical = TRUE
	sleep_healing = 0

/datum/wound/dismemberment/can_stack_with(datum/wound/other)
	if(istype(other, /datum/wound/dismemberment) && (type == other.type))
		return FALSE
	return TRUE

/datum/wound/dismemberment/head
	name = "neck stump"
	check_name = span_danger("<B>NECK STUMP</B>")
	mob_overlay = "dis_head"

/datum/wound/dismemberment/r_arm
	name = "right arm stump"
	check_name = span_danger("<B>RIGHT ARM STUMP</B>")
	mob_overlay = "dis_ra"

/datum/wound/dismemberment/l_arm
	name = "left arm stump"
	check_name = span_danger("<B>LEFT ARM STUMP</B>")
	mob_overlay = "dis_la"

/datum/wound/dismemberment/r_leg
	name = "right leg stump"
	check_name = span_danger("<B>RIGHT LEG STUMP</B>")
	mob_overlay = "dis_rl"

/datum/wound/dismemberment/l_leg
	name = "left leg stump"
	check_name = span_danger("<B>LEFT LEG STUMP</B>")
	mob_overlay = "dis_ll"

/datum/wound/dismemberment/taur
	name = "taur stump"
	check_name = span_danger("<B>TAUR STUMP</B>")
	mob_overlay = "dis_taur"
