#define CONVERSION_BONUS 20		// how many 'bonus points' you get for converting someone to tennite/ascendent
#define CONVERSION_PENALTY 10	// how many points are taken away from the faith of origin when a psydonite converts a tennite/ascendent

/datum/dominant_faith_tracker
	// adjust these to make characters belonging to this faith count more or less towards the score ranking
	var/list/weights = list(
		/datum/faith/divine = 1,
		/datum/faith/inhumen = 1,
		/datum/faith/old_god = 1
	)
	// caching these because we only have to do a full recalc very rarely
	var/list/totals = list(
		/datum/faith/divine = 0,
		/datum/faith/inhumen = 0,
		/datum/faith/old_god = 0
	)
	// these are shown to people of a given pantheon (the first index) when a given pantheon (the second index) ascends 
	var/list/reign_messages = list(
		/datum/faith/divine = list(
			/datum/faith/divine = "$patron shines bright in your Lux! The Ten are in their rightful place.",
			/datum/faith/inhumen = "The firmament feels thick. The Ten's influence wanes; the Inhumen rise.",
			/datum/faith/old_god = "The world is quiet. A soft wind blows. The divines rest, for now.",
		),
		/datum/faith/inhumen = list(
			/datum/faith/inhumen = "$patron outshines the mendacity of The Ten! Mortalkind ascend!",
			/datum/faith/divine = "The firmanent feels thick. The Ten's influence is overpowering!",
			/datum/faith/old_god = "The world is quiet. A soft wind blows. The divines rest, for now.",
		),
		/datum/faith/old_god = list( // psydonites can only tell whether they're dominant or not, here
			/datum/faith/divine = "The world is quiet. The wind has an ominous twinge.",
			/datum/faith/inhumen = "The world is quiet. The wind has an ominous twinge.",
			/datum/faith/old_god = "The world is quiet. The wind is calm and reassuring.",
		)
	)
	var/dominant_faith = /datum/faith/old_god
	var/last_announce_time = 0

/mob/living/carbon/human/proc/debug_faiths()
	GLOB.dominant_faith_tracker.last_announce_time = 0
	GLOB.dominant_faith_tracker.announce_reign()
	to_chat(world, "debugged faiths. current dominant faith: [GLOB.dominant_faith_tracker.dominant_faith]")

/datum/dominant_faith_tracker/proc/roundstart_setup()
	addtimer(CALLBACK(src, PROC_REF(calculate_dominant_faith), TRUE), 5 MINUTES) // wait a bit after roundstart spam settles down and the first wave of latejoins pops in

/datum/dominant_faith_tracker/proc/calculate_dominant_faith(force = FALSE)
	if(force)
		full_recalculate()
	if((totals[/datum/faith/inhumen] > totals[/datum/faith/divine]) && (totals[/datum/faith/inhumen] > totals[/datum/faith/old_god]))
		dominant_faith = /datum/faith/inhumen
	else if((totals[/datum/faith/divine] > totals[/datum/faith/inhumen]) && (totals[/datum/faith/divine] > totals[/datum/faith/old_god]))
		dominant_faith = /datum/faith/divine
	else // either psydonians are coping so hard they won, or the ten and inhumen are at an impasse
		dominant_faith = /datum/faith/old_god
	
	// cooldown for this is at the top of the announce_reign proc, so it's fine to call it every time we recalc
	addtimer(CALLBACK(src, PROC_REF(announce_reign), TRUE), pick(list(1,2,3,4,5)) MINUTES) // however we do a small, random delay to prevent meta'ing "this person just latejoined and then the thing switched"

/datum/dominant_faith_tracker/proc/announce_reign()
	if((last_announce_time != 0) && (world.time <= (last_announce_time + 10 MINUTES)))
		return // no announcement spam
	for(var/mob/i in GLOB.player_list)
		var/mob/living/carbon/human/H = i
		if(!istype(H) || !H.patron || ispath(H.patron.associated_faith, /datum/faith/mossmother) || ispath(H.patron.associated_faith, /datum/faith/godless) || !H.devotion)
			continue
		if(ispath(dominant_faith, /datum/faith/old_god)) // psydon messages are always 'neutral'
			to_chat(H, span_blue(replacetext(reign_messages[H.patron.associated_faith][dominant_faith], "$patron", get_god_name(H.patron))))
		else if(ispath(H.patron.associated_faith, dominant_faith))
			to_chat(H, span_boldgreen(replacetext(reign_messages[H.patron.associated_faith][dominant_faith], "$patron", get_god_name(H.patron))))
		else
			to_chat(H, span_warningbig(replacetext(reign_messages[H.patron.associated_faith][dominant_faith], "$patron", get_god_name(H.patron))))
	if(last_announce_time == 0) // this is our first announcement of the round! 14 minute bonus timer on this one because the first half hour of the round is a 'grace period' for latejoins to settle in
		last_announce_time = world.time + 14 MINUTES
	else
		last_announce_time = world.time

/datum/dominant_faith_tracker/proc/full_recalculate()
	for(var/mob/i in GLOB.player_list)
		var/mob/living/carbon/human/H = i
		if(!istype(H) || !H.patron || ispath(H.patron.associated_faith, /datum/faith/mossmother) || ispath(H.patron.associated_faith, /datum/faith/godless))
			continue
		totals[H.patron.associated_faith] += weights[H.patron.associated_faith]

// helper procs. call these when someone enters/leaves the round to update the totals accordingly
/datum/dominant_faith_tracker/proc/handle_addition(mob/living/carbon/human/H)
	if(!istype(H) || !H.patron || ispath(H.patron.associated_faith, /datum/faith/mossmother) || ispath(H.patron.associated_faith, /datum/faith/godless))
		return
	totals[H.patron.associated_faith] += weights[H.patron.associated_faith]
	calculate_dominant_faith()

/datum/dominant_faith_tracker/proc/handle_removal(mob/living/carbon/human/H)
	if(!istype(H) || !H.patron || ispath(H.patron.associated_faith, /datum/faith/mossmother) || ispath(H.patron.associated_faith, /datum/faith/godless))
		return
	totals[H.patron.associated_faith] -= weights[H.patron.associated_faith]
	calculate_dominant_faith()

/datum/dominant_faith_tracker/proc/handle_conversion(mob/living/carbon/human/H, datum/patron/old_patron)
	// no benefit from intra-pantheon conversions
	if(H.patron.associated_faith == old_patron.associated_faith)
		return
	// rescind your lot from your own faith, and cast it for your new faith
	totals[old_patron.associated_faith] -= weights[old_patron.associated_faith]
	totals[H.patron.associated_faith] += weights[H.patron.associated_faith]

	// apply a bonus for conversion, to make them feel more impactful
	if(!ispath(H.patron.associated_faith, /datum/faith/old_god))
		totals[H.patron.associated_faith] += CONVERSION_BONUS
	else
		// psydon doesn't gain influence from conversions, because he can't hear you. instead, the faith you converted from is penalized
		totals[old_patron.associated_faith] -= CONVERSION_PENALTY

GLOBAL_DATUM_INIT(dominant_faith_tracker, /datum/dominant_faith_tracker, new)

#undef CONVERSION_BONUS
#undef CONVERSION_PENALTY
