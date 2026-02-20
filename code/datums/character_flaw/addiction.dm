/mob/proc/sate_addiction()
	return

/mob/living/carbon/human/sate_addiction(var/datum/charflaw/addiction/adc_vice)
	if(!adc_vice)
		return

	var/datum/charflaw/addiction/mob_vice = null
	for(var/datum/charflaw/vice in charflaws)
		if(adc_vice.type == vice.type)
			mob_vice = vice
			break

	if(!mob_vice)
		return
	if(mob_vice.sated)
		return

	to_chat(src, span_blue(mob_vice.sated_text))

	for(var/mob/living/carbon/human/L in get_hearers_in_view(2, src, RECURSIVE_CONTENTS_CLIENT_MOBS))
		if(src != L && !istype(mob_vice, /datum/charflaw/addiction/voyeur))	//Let's not have circular voyeur self-pleasing chains.
			if(L.has_flaw(/datum/charflaw/addiction/voyeur))
				for(var/datum/charflaw/cf in L.charflaws)
					if(istype(cf, /datum/charflaw/addiction/voyeur))
						L.sate_addiction(cf)
						break

	mob_vice.sated = TRUE
	mob_vice.time = initial(mob_vice.time) //reset roundstart sate offset to standard
	mob_vice.next_sate = world.time + mob_vice.time
	remove_stress(/datum/stressevent/vice)
	if(mob_vice.debuff)
		remove_status_effect(mob_vice.debuff)

/datum/charflaw/addiction
	var/next_sate = 0
	var/sated = TRUE
	var/time = 5 MINUTES
//	var/debuff = /datum/status_effect/debuff/addiction
	var/debuff //so heroin junkies can have big problems
	var/needsate_text
	var/sated_text = "That's much better..."
	var/unsate_time


/datum/charflaw/addiction/New()
	..()
	time = rand(6 MINUTES, 30 MINUTES)
	next_sate = world.time + time

/datum/charflaw/addiction/flaw_on_life(mob/user)
	if(!ishuman(user))
		return
	if(user.mind?.antag_datums)
		for(var/datum/antagonist/D in user.mind?.antag_datums)
			if(istype(D, /datum/antagonist/vampire/lord) || istype(D, /datum/antagonist/werewolf) || istype(D, /datum/antagonist/skeleton) || istype(D, /datum/antagonist/zombie) || istype(D, /datum/antagonist/lich))
				return
	var/mob/living/carbon/human/H = user
	var/oldsated = sated
	if(oldsated)
		if(next_sate)
			if(world.time > next_sate)
				sated = FALSE
	if(sated != oldsated)
		unsate_time = world.time
		if(needsate_text)
			to_chat(user, span_boldwarning("[needsate_text]"))
	if(!sated)
		H.add_stress(/datum/stressevent/vice)
		if(debuff)
			H.apply_status_effect(debuff)



/datum/status_effect/debuff/addiction
	id = "addiction"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/addiction
	effectedstats = list(STATKEY_WIL = -1,STATKEY_LCK = -1)
	duration = 100


/atom/movable/screen/alert/status_effect/debuff/addiction
	name = "Addiction"
	desc = ""
	icon_state = "debuff"


/// ALCOHOLIC

/datum/charflaw/addiction/alcoholic
	name = "Alcoholic"
	desc = "Drinking alcohol is my favorite thing."
	time = 40 MINUTES
	needsate_text = "Time for a drink."
	voyeur_descriptor = "quite the drinker"


/// KLEPTOMANIAC

/datum/charflaw/addiction/kleptomaniac
	name = "Thief-borne"
	desc = "As a child I had to rely on theft to survive. Whether that changed or not, I just can't get over it."
	time = 30 MINUTES
	needsate_text = "I need to STEAL something! I'll die if I don't!"
	voyeur_descriptor = "quick-fingered"


/// JUNKIE

/datum/charflaw/addiction/junkie
	name = "Junkie"
	desc = "I need a REAL high to take the pain of this rotten world away."
	time = 40 MINUTES
	needsate_text = "Time to get really high."
	voyeur_descriptor = "eager for a high"

/// Smoker

/datum/charflaw/addiction/smoker
	name = "Smoker"
	desc = "I need to smoke something to take the edge off."
	time = 40 MINUTES
	needsate_text = "Time for a flavorful smoke."
	voyeur_descriptor = "eager for a smoke"

/// GOD-FEARING

/datum/charflaw/addiction/godfearing
	name = "Devout Follower"
	desc = "I need to pray to my Patron in their realm, it will make me and my prayers stronger."
	time = 40 MINUTES
	needsate_text = "Time to pray to my Patron."
	voyeur_descriptor = "quite devout"

/// SADIST

/datum/charflaw/addiction/sadist
	name = "Sadist"
	desc = "There is no greater pleasure than the suffering of another."
	time = 40 MINUTES
	needsate_text = "I need to hear someone whimper."
	voyeur_descriptor = "looking to hurt"

/// MASOCHIST

/datum/charflaw/addiction/masochist
	name = "Masochist"
	desc = "I love the feeling of pain, so much I can't get enough of it."
	time = 40 MINUTES
	needsate_text = "I need someone to HURT me."
	voyeur_descriptor = "looking to be hurt"

/datum/charflaw/addiction/masochist/on_mob_creation(mob/living/living)
	living.pain_threshold += 10

/// LOVEFIEND

/datum/charflaw/addiction/lovefiend
	name = "Nymphomaniac"
	desc = "I must make love!"
	time = 90 MINUTES
	needsate_text = "I'm feeling randy."
	voyeur_descriptor = "looking lovesick"

/datum/charflaw/addiction/thrillseeker
	name = "Thrillseeker"
	desc = "Only fighting brings me pleasure."
	time = 40 MINUTES
	needsate_text = "I need a FIGHT!"
	voyeur_descriptor = "eager for a fight"

/datum/charflaw/addiction/clamorous
	name = "Clamorous"
	desc = "The noise of people and fights drowns out my misery."
	time = 20 MINUTES
	needsate_text = "It's too quiet. Where's the yelling? The fighting?"
	voyeur_descriptor = "soothed by noise"

/datum/charflaw/addiction/paranoid
	name = "Paranoid"
	desc = "I only feel comfortable around one of my own kind."
	time = 20 MINUTES
	needsate_text = "Am I the only one of my kind left?"
	voyeur_descriptor = "comforted by their own"
	var/chosen_faction

/datum/charflaw/addiction/paranoid/apply_post_equipment(mob/user)
	assign_faction(user)
	
/datum/charflaw/addiction/paranoid/proc/assign_faction(mob/user)
	var/datum/job/J = SSjob.GetJob(user.job)
	if(!J)
		CRASH("[user] had an invalid job datum associated with their job: [user.job]")
	if(J.department_flag & COURTIERS || J.department_flag & NOBLEMEN)
		chosen_faction = (COURTIERS | NOBLEMEN)
	else
		chosen_faction = J.department_flag

/datum/charflaw/addiction/paranoid/proc/check_faction(mob/living/target)
	var/datum/job/J = SSjob.GetJob(target.job)
	if(J)
		if(chosen_faction & J.department_flag)
			return TRUE
		else
			return FALSE

/datum/charflaw/addiction/voyeur
	name = "Voyeur"
	desc = "Seeing others be happy... it makes me happy, too."
	time = 30 MINUTES
	needsate_text = "I must please someone."
	voyeur_descriptor = "pleased by others"
