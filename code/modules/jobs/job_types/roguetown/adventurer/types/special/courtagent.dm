/datum/job/roguetown/adventurer/courtagent
	title = "Court Agent"
	flag = COURTAGENT
	display_order = JDO_COURTAGENT
	allowed_races = RACES_ALL_KINDS
	total_positions = 2
	spawn_positions = 2
	round_contrib_points = 2
	tutorial = "Whether acquired by merit, shrewd negotiation or fulfilled bounties, you have found yourself under the underhanded employ of the Hand. Fulfill desires and whims of the court that they would rather not be publicly known. Your position is anything but secure, and any mistake can leave you disowned and charged like the petty criminal are. Garrison and Court members know who you are."
	min_pq = 5
	job_reopens_slots_on_death = FALSE
	always_show_on_latechoices = TRUE
	show_in_credits = TRUE
	advclass_cat_rolls = list(CTAG_COURTAGENT = 20)
	obsfuscated_job = TRUE
	class_setup_examine = FALSE

//Hooking in here does not mess with their equipment procs
/datum/job/roguetown/adventurer/courtagent/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	if(L)
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			GLOB.court_agents += H.real_name
			if(H.mind)
				H.mind.special_role = "Court Agent" //For obfuscating them in the Actors list: _job.dm L:216
			..()
