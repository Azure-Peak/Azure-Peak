#define ADDICT_TIME_STANDARD 70 MINUTES
#define ADDICT_TIME_OFTEN 50 MINUTES
#define ADDICT_TIME_FREQUENT 30 MINUTES

/mob/proc/sate_addiction()
	return

/mob/living/carbon/human/sate_addiction(datum/charflaw/addiction/adc_vice)
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
		if(mob_vice.partial_sating)
			if(mob_vice.partial_sate < world.time)
				mob_vice.partial_sate = world.time + (15 MINUTES)
				to_chat(src, span_blue("<i>This will do... for now...</i>"))
				mob_vice.next_sate = world.time + max((initial(mob_vice.time) / 1.5), 1)
				remove_stress(/datum/stressevent/vice)	// These are just in case we ended up here w/ unsated vice debuffs
				if(mob_vice.debuff)
					remove_status_effect(mob_vice.debuff)
				sate_voyeurs(mob_vice)
		return

	to_chat(src, span_blue(mob_vice.sated_text))

	sate_voyeurs(mob_vice)

	mob_vice.sated = TRUE
	mob_vice.time = initial(mob_vice.time) //reset roundstart sate offset to standard
	mob_vice.partial_sate = world.time + (5 MINUTES)
	mob_vice.next_sate = world.time + max(mob_vice.time, 1)
	remove_stress(/datum/stressevent/vice)
	if(mob_vice.debuff)
		remove_status_effect(mob_vice.debuff)

/mob/living/carbon/human/proc/sate_voyeurs(datum/charflaw/addiction/mob_vice)
	for(var/mob/living/carbon/human/L in get_hearers_in_view(2, src, RECURSIVE_CONTENTS_CLIENT_MOBS))
		if(src != L && !istype(mob_vice, /datum/charflaw/addiction/voyeur))	//Let's not have circular voyeur self-pleasing chains.
			if(L.has_flaw(/datum/charflaw/addiction/voyeur))
				for(var/datum/charflaw/cf in L.charflaws)
					if(istype(cf, /datum/charflaw/addiction/voyeur))
						L.sate_addiction(cf)
						break

/datum/charflaw/addiction
	/// The world.time for our next sate proc.
	var/next_sate = 0
	/// The world.time snapshot for when we'll see a partial sate message again.
	var/partial_sate = 0
	/// Whether the vice is sated.
	var/sated = TRUE
	/// The delay between sate procs, partial sates can override this.
	var/time = 5 MINUTES
	var/debuff = /datum/status_effect/debuff/addiction
	var/needsate_text
	var/sated_text = "That's much better..."
	var/unsate_time
	var/partial_sating = TRUE


/datum/charflaw/addiction/on_mob_creation(mob/user)
	. = ..()
	time = rand(time - 5 MINUTES, time + 5 MINUTES)
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
		if(next_sate && world.time >= next_sate)
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
	effectedstats = list(STAT_FORTUNE = -1)
	duration = 100


/atom/movable/screen/alert/status_effect/debuff/addiction
	name = "Addiction"
	desc = ""
	icon_state = "addiction"
	icon = 'icons/mob/screen_alert_addiction.dmi'


/// ALCOHOLIC

/datum/charflaw/addiction/alcoholic
	name = "Alcoholic"
	desc = "Drinking alcohol is my favorite thing."
	time = ADDICT_TIME_STANDARD
	needsate_text = "Time for a drink."
	voyeur_descriptor = "quite the drinker"
	debuff = /datum/status_effect/debuff/addiction/alcoholic

/datum/status_effect/debuff/addiction/alcoholic
	id = "addiction_alcoholic"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/addiction/alcoholic
	effectedstats = list(STATKEY_INT = -1, STATKEY_WIL = -1)

/atom/movable/screen/alert/status_effect/debuff/addiction/alcoholic
	name = "Alcohol Withdrawal"
	desc = "I've started to feel hungover. The best way to chase a hangover is another drink."
	icon_state = "alcoholic"


/// KLEPTOMANIAC

/datum/charflaw/addiction/kleptomaniac
	name = "Thief-born"
	desc = "As a child I had to rely on theft to survive. Whether that changed or not, I just can't get over it."
	time = ADDICT_TIME_OFTEN
	needsate_text = "I need to STEAL something! I'll die if I don't!"
	voyeur_descriptor = "quick-fingered"


/// JUNKIE

/datum/charflaw/addiction/junkie
	name = "Junkie"
	desc = "I need a REAL high to take the pain of this rotten world away."
	time = ADDICT_TIME_STANDARD
	needsate_text = "Time to get really high."
	voyeur_descriptor = "eager for a high"
	debuff = /datum/status_effect/debuff/addiction/junkie

/datum/status_effect/debuff/addiction/junkie
	id = "addiction_junkie"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/addiction/junkie
	effectedstats = list(STATKEY_STR = -1, STATKEY_CON = -1)

/atom/movable/screen/alert/status_effect/debuff/addiction/junkie
	name = "Drug Withdrawal"
	desc = "It's been too long since my last bump. I need a hit of something strong."
	icon_state = "junkie"

/// Smoker

/datum/charflaw/addiction/smoker
	name = "Smoker"
	desc = "I need to smoke something to take the edge off."
	time = ADDICT_TIME_STANDARD
	needsate_text = "Time for a flavorful smoke."
	voyeur_descriptor = "eager for a smoke"
	debuff = /datum/status_effect/debuff/addiction/smoker

/datum/status_effect/debuff/addiction/smoker
	id = "addiction_smoker"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/addiction/smoker
	effectedstats = list(STATKEY_STR = -1, STATKEY_CON = -1)

/atom/movable/screen/alert/status_effect/debuff/addiction/smoker
	name = "Blacklung"
	desc = "I need a smoke. Gotta take the edge off."
	icon_state = "smoker"

/// CAFFIEND

/datum/charflaw/addiction/caffiend
	name = "Caffiend"
	desc = "I can't start my day without a cup of tea or coffee."
	time = ADDICT_TIME_STANDARD
	needsate_text = "I need a hot brew."
	voyeur_descriptor = "in need of a brew"
	debuff = /datum/status_effect/debuff/addiction/caffiend

/datum/status_effect/debuff/addiction/caffiend
	id = "addiction_caffiend"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/addiction/caffiend
	effectedstats = list(STATKEY_WIL = -1, STATKEY_INT = -1)

/atom/movable/screen/alert/status_effect/debuff/addiction/caffiend
	name = "The Ticks"
	desc = "Where's my cup? I feel all wrong without it."
	icon_state = "caffiend"

/// GOD-FEARING

/datum/charflaw/addiction/godfearing
	name = "Devout Follower"
	desc = "I need to pray to my Patron in their realm, it will make me and my prayers stronger."
	time = ADDICT_TIME_STANDARD
	needsate_text = "Time to pray to my Patron."
	voyeur_descriptor = "quite devout"
	debuff = /datum/status_effect/debuff/addiction/godfearing

/datum/status_effect/debuff/addiction/godfearing
	id = "addiction_godfearing"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/addiction/godfearing
	effectedstats = list(STATKEY_WIL = -2)

/atom/movable/screen/alert/status_effect/debuff/addiction/godfearing
	name = "Godfearing"
	desc = "It's been too long since my last prayer. My patron is going to turn their gaze away from me."
	icon_state = "godfearing"

/// SADIST

/datum/charflaw/addiction/sadist
	name = "Sadist"
	desc = "There is no greater pleasure than the suffering of another."
	time = ADDICT_TIME_STANDARD
	needsate_text = "I need to hear someone whimper."
	voyeur_descriptor = "looking to hurt"
	debuff = /datum/status_effect/debuff/addiction/sadist

/datum/status_effect/debuff/addiction/sadist
	id = "addiction_sadist"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/addiction/sadist
	effectedstats = list(STATKEY_WIL = -1, STATKEY_LCK = -1)

/atom/movable/screen/alert/status_effect/debuff/addiction/sadist
	name = "Sadist"
	desc = "I need to hear someone whimper. Only the cries of another will make me feel better."
	icon_state = "sadist"

/// MASOCHIST

/datum/charflaw/addiction/masochist
	name = "Masochist"
	desc = "I love the feeling of pain, so much I can't get enough of it."
	time = ADDICT_TIME_STANDARD
	needsate_text = "I need someone to HURT me."
	voyeur_descriptor = "looking to be hurt"
	debuff = /datum/status_effect/debuff/addiction/masochist
	partial_sating = FALSE

/datum/status_effect/debuff/addiction/masochist
	id = "addiction_masochist"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/addiction/masochist
	effectedstats = list(STATKEY_CON = -1, STATKEY_WIL = -1)

/atom/movable/screen/alert/status_effect/debuff/addiction/masochist
	name = "Masochist"
	desc = "I deserve to suffer. No, I NEED to suffer."
	icon_state = "masochist"

/datum/charflaw/addiction/masochist/on_mob_creation(mob/living/living)
	living.pain_threshold += 10

/// LOVEFIEND

/datum/charflaw/addiction/lovefiend
	name = "Nymphomaniac"
	desc = "I must make love!"
	time = ADDICT_TIME_STANDARD
	needsate_text = "I'm feeling randy."
	voyeur_descriptor = "looking lovesick"
	debuff = /datum/status_effect/debuff/addiction/nympho

/datum/status_effect/debuff/addiction/nympho
	id = "addiction_nympho"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/addiction/nympho
	effectedstats = list(STATKEY_WIL = -1, STATKEY_LCK = -1)

/atom/movable/screen/alert/status_effect/debuff/addiction/nympho
	name = "Nymphomania"
	desc = "I must make love. My loins burn with unsated desire."
	icon_state = "nymphomaniac"

/datum/charflaw/addiction/thrillseeker
	name = "Thrillseeker"
	desc = "Only fighting brings me pleasure."
	time = ADDICT_TIME_OFTEN
	debuff = null
	needsate_text = "I need a FIGHT!"
	voyeur_descriptor = "eager for a fight"

/datum/charflaw/addiction/clamorous
	name = "Clamorous"
	desc = "The noise of people and fights drowns out my misery."
	time = ADDICT_TIME_FREQUENT
	needsate_text = "It's too quiet. Where's the yelling? The fighting?"
	voyeur_descriptor = "soothed by noise"
	debuff = null
	partial_sating = FALSE

/datum/charflaw/addiction/paranoid
	name = "Paranoid"
	desc = "I only feel comfortable around one of my own kind."
	time = ADDICT_TIME_OFTEN
	needsate_text = "Am I the only one of my kind left?"
	voyeur_descriptor = "comforted by their own"
	partial_sating = FALSE
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
	time = ADDICT_TIME_OFTEN
	needsate_text = "I must please someone."
	voyeur_descriptor = "pleased by others"
	partial_sating = FALSE

#undef ADDICT_TIME_STANDARD
#undef ADDICT_TIME_OFTEN
#undef ADDICT_TIME_FREQUENT
