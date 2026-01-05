/datum/job/roguetown/assassin
	title = "Assassin"
	flag = ASSASSIN
	department_flag = PEASANTS
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	min_pq = 10		// was going to put this higher but realized bandit's only 3 pq and wretch is fucking 10 so whatever
	max_pq = null
	antag_job = TRUE
	allowed_races = RACES_ALL_KINDS
	tutorial = "Long ago you did a crime worthy of your bounty being hung on the wall outside of the local inn. You now live with your fellow freemen in the bog, and generally get up to no good."

	outfit = null
	outfit_female = null

	obsfuscated_job = TRUE

	display_order = JDO_ASSASSIN
	announce_latejoin = FALSE
	round_contrib_points = 5

	advclass_cat_rolls = list(CTAG_ASSASSIN = 20)
	PQ_boost_divider = 10

	wanderer_examine = TRUE
	advjob_examine = FALSE	//We don't want anyone knowing what type of assassin you are.
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = FALSE

	// Base job traits, we give one-specialty trait per role.
	job_traits = list(
		TRAIT_ASSASSIN,
		TRAIT_DODGEEXPERT,
		TRAIT_STEELHEARTED,
		TRAIT_HERESIARCH,	//Just so they can use the Zurch.
		TRAIT_ANTISCRYING,
	)
	cmode_music = 'sound/music/cmode/antag/combat_assassin.ogg'
	// Choices between: Ranged build, pioson knife-fighter w/ poison knife, garrote user/kidnapper build 
	job_subclasses = list(
		/datum/advclass/assassin_ranger,
		/datum/advclass/assassin_poisoner,
		/datum/advclass/assassin_hitman,
	)

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
		addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup), "ASSASSIN"), 5 SECONDS)
		var/wanted = list("I am a notorious criminal", "I am a nobody")
		var/wanted_choice = input("Are you a known criminal?") as anything in wanted
		switch(wanted_choice)
			if("I am a notorious criminal") //Extra challenge for those who want it
				bandit_select_bounty(H)
				ADD_TRAIT(H, TRAIT_KNOWNCRIMINAL, TRAIT_GENERIC)
			if("I am a nobody") //Nothing ever happens
				return
