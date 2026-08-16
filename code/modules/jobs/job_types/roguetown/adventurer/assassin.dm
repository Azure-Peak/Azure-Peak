/datum/job/roguetown/assassin
	title = "Assassin"
	flag = ASSASSIN
	department_flag = ANTAGONIST
	selection_color = JCOLOR_ANTAGONIST
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	min_pq = 10		// was going to put this higher but realized bandit's only 3 pq and wretch is fucking 10 so whatever
	max_pq = null
	antag_job = TRUE


	tutorial = "\"A MAN SPEAKS A NAME. WE DO THE REST!\", a common parlance from your cursed dagger. Whether puppeted by dark forces or by \
	choice, you have become a devout of the Sinistar. As His devout pray for His wrath, you dispense it, skin-thiefing and soul-taking those \
	deemed worthy of a blood-hunt."

	outfit = null
	outfit_female = null

	obsfuscated_job = TRUE
	give_bank_account = FALSE

	display_order = JDO_ASSASSIN
	announce_latejoin = FALSE
	round_contrib_points = 5

	advclass_cat_rolls = list(CTAG_ASSASSIN = 20)
	PQ_boost_divider = 10

	wanderer_examine = TRUE
	advjob_examine = FALSE	//We don't want anyone knowing what type of assassin you are.
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = FALSE

	// JOB TRAITS == prev. job traits are now granted on datum-gain.

	virtue_restrictions = list(
		/datum/virtue/utility/feytouched
	)
	cmode_music = 'sound/music/cmode/antag/combat_deadlyshadows.ogg'
	// Choices between: Ranged build, pioson knife-fighter w/ poison knife, garrote user/kidnapper build
	job_subclasses = list(
		/datum/advclass/assassin_ranger,
		/datum/advclass/assassin_poisoner,
		/datum/advclass/assassin_hitman,
	)

	vice_restrictions = list(/datum/charflaw/hunted, /datum/charflaw/targeted)

/datum/job/roguetown/assassin/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/mob/living/carbon/human/H = L
		if(!H.mind)
			return
		H.ambushable = FALSE

/datum/outfit/job/roguetown/assassin/post_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		var/datum/antagonist/new_antag = new /datum/antagonist/assassin()
		H.mind.add_antag_datum(new_antag)
		H.grant_language(/datum/language/thievescant)
		var/wanted = list("I am a notorious criminal", "I am a nobody")
		var/wanted_choice = input(H, "Are you a known criminal?") as anything in wanted
		switch(wanted_choice)
			if("I am a notorious criminal") //Extra challenge for those who want it
				bandit_select_bounty(H)
				ADD_TRAIT(H, TRAIT_KNOWNCRIMINAL, TRAIT_GENERIC)
			if("I am a nobody") //Nothing ever happens
				return
