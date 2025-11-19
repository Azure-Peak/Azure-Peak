/datum/kink/public
	name = "Public Risk"
	description = "The thrill of potentially being caught."
	intensity = 4
	category = "Fetish"

/datum/kink/public/on_process(mob/living/target)
	var/turf/turf = get_turf(target)
	var/outside = turf.outdoor_effect?.weatherproof
	var/seen_by_people = FALSE
	var/list/participants = list()
	for(var/datum/sex_session/session in GLOB.sex_sessions)
		if(session.user == target || session.target == target)
			participants |= session.user
			participants |= session.target

	for(var/mob/living/carbon/human/human in view(5, target))
		if(human in participants)
			continue
		seen_by_people = TRUE
		break
	if(outside || seen_by_people)
		target.add_stress(/datum/stress_event/public_thrill)
		SEND_SIGNAL(target, COMSIG_SEX_ADJUST_AROUSAL, 0.5)
