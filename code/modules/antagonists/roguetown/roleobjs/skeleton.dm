
/datum/antagonist/skeleton
	name = "Skeleton"
	increase_votepwr = FALSE

/datum/antagonist/skeleton/get_antag_cap_weight()
	return 0

/datum/antagonist/skeleton/examine_friendorfoe(datum/antagonist/examined_datum,mob/examiner,mob/examined)
	if(istype(examined_datum, /datum/antagonist/vampire))
		if(!SEND_SIGNAL(examined_datum.owner, COMSIG_DISGUISE_STATUS))
			return span_boldnotice("Another deadite.")
	if(istype(examined_datum, /datum/antagonist/zombie))
		return span_boldnotice("Another deadite.")
	if(istype(examined_datum, /datum/antagonist/skeleton))
		return span_boldnotice("Another deadite. My ally.")

/datum/antagonist/skeleton/on_gain()
//	if(!(locate(/datum/objective/escape) in objectives))
//		var/datum/objective/escape/boat/escape_objective = new
//		escape_objective.owner = owner
//		objectives += escape_objective
//		return
	ADD_TRAIT(owner.current, TRAIT_SILVER_WEAK, TRAIT_GENERIC)
	return ..()

/datum/antagonist/skeleton/on_removal()
	REMOVE_TRAIT(owner.current, TRAIT_SILVER_WEAK, TRAIT_GENERIC)
	return ..()

/datum/antagonist/skeleton/greet()
	owner.announce_objectives()
	..()

/datum/antagonist/skeleton/roundend_report()
	return
