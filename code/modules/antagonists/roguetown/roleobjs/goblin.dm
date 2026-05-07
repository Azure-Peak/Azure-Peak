
/datum/antagonist/goblin //So admins can track goblin antags from their spawned in ones as well as friend to foe consistancy like goblins/skeletons, not you can actually hide your appearance but whatever.
	name = "Goblin"
	increase_votepwr = FALSE

/datum/antagonist/goblin/get_antag_cap_weight()
	return 0

/datum/antagonist/goblin/examine_friendorfoe(datum/antagonist/examined_datum,mob/examiner,mob/examined)
	if(istype(examined_datum, /datum/antagonist/goblin))
		return span_boldnotice("Another of Graggar's annointed. My ally.") //Sure why not, keep them a little TDM as you're basically here to fight as one and die as one.

/datum/antagonist/goblin/greet()
	owner.announce_objectives()
	..()

/datum/antagonist/goblin/roundend_report()
	return
