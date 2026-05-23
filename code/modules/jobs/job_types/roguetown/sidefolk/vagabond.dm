/datum/job/roguetown/vagabond
	title = "Vagabond"
	flag = VAGABOND
	department_flag = SIDEFOLK
	faction = "Station"
	total_positions = 12
	spawn_positions = 12
	townie_contract_gate_exempt = TRUE

	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	

	outfit = null
	outfit_female = null
	wanderer_examine = TRUE
	advjob_examine = FALSE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = TRUE
	same_job_respawn_delay = 10 SECONDS
	announce_latejoin = FALSE

	advclass_cat_rolls = list(CTAG_VAGABOND = 20)

	tutorial = "Dozens of people end up down on their luck in the kingdom of Psydonia every day. They sometimes make something of themselves but much more often die in the streets."

	outfit = /datum/outfit/job/roguetown/vagabond
	display_order = JDO_VAGABOND
	show_in_credits = FALSE
	min_pq = -30
	max_pq = null
	round_contrib_points = 2

	give_bank_account = TRUE

	cmode_music = 'sound/music/combat_bum.ogg'
	job_subclasses = list(
		/datum/advclass/vagabond_original,
		/datum/advclass/vagabond_beggar,
		/datum/advclass/vagabond_courier,
		/datum/advclass/vagabond_excommunicated,
		/datum/advclass/vagabond_goatherd,
		/datum/advclass/vagabond_mage,
		/datum/advclass/vagabond_runner,
		/datum/advclass/vagabond_scholar,
		/datum/advclass/vagabond_wanted,
		/datum/advclass/vagabond_unraveled
	)

/datum/job/roguetown/vagabond/New()
	. = ..()
	peopleknowme = list()

/datum/outfit/job/roguetown/vagabond/pre_equip(mob/living/carbon/human/H)
	..()
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/rags
	else if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights/vagrant
		if(prob(50))
			pants = /obj/item/clothing/under/roguetown/tights/vagrant/l
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
		if(prob(50))
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/l
	if(prob(33))
		cloak = /obj/item/clothing/cloak/half/brown
		gloves = /obj/item/clothing/gloves/roguetown/fingerless

// Proc for wanted vagabonds to select a bounty - extend this to further challenge classes with vagabond_select_bounty(H)
/proc/vagabond_select_bounty(mob/living/carbon/human/H)
	var/datum/preferences/P = H?.client?.prefs
	var/bounty_poster_key
	var/bounty_severity_key
	var/my_crime

	if(P?.preset_bounty_enabled)
		bounty_poster_key = P.preset_bounty_poster_key
		bounty_severity_key = P.preset_bounty_severity_v_key
		my_crime = P.preset_bounty_crime

	if(bounty_poster_key && !GLOB.bounty_posters[bounty_poster_key])
		bounty_poster_key = null

	if(bounty_severity_key && !GLOB.vagabond_bounty_severities[bounty_severity_key])
		bounty_severity_key = null

	if(!bounty_poster_key)
		var/list/poster_choices = list()
		for(var/key in GLOB.bounty_posters)
			poster_choices[GLOB.bounty_posters[key]] = key
		var/choice = input(H, "Who placed a bounty on you?", "Bounty Poster") as anything in poster_choices
		bounty_poster_key = poster_choices[choice]

	if(!bounty_severity_key)
		var/list/sev_choices = list()
		for(var/key in GLOB.vagabond_bounty_severities)
			sev_choices[GLOB.vagabond_bounty_severities[key]["name"]] = key
		var/choice = input(H, "How severe are your crimes?", "Bounty Amount") as anything in sev_choices
		bounty_severity_key = sev_choices[choice]

	var/bounty_poster = GLOB.bounty_posters[bounty_poster_key]

	var/list/sev_data = GLOB.vagabond_bounty_severities[bounty_severity_key]
	var/bounty_total = rand(sev_data["min"], sev_data["max"])
	if(bounty_severity_key == "HEFTY")
		if(bounty_poster_key == "AZURIA")
			GLOB.outlawed_players += H.real_name
		else
			GLOB.excommunicated_players += H.real_name
	if(!my_crime)
		my_crime = input(H, "What is your crime?", "Crime") as text|null
	if(!my_crime)
		my_crime = "crimes against the Crown"

	var/race = H.dna.species
	var/gender = H.gender
	var/list/d_list = H.get_mob_descriptors()

	var/descriptor_height = build_coalesce_description_nofluff(
		d_list, H, list(MOB_DESCRIPTOR_SLOT_HEIGHT), "%DESC1%"
	)
	var/descriptor_body = build_coalesce_description_nofluff(
		d_list, H, list(MOB_DESCRIPTOR_SLOT_BODY), "%DESC1%"
	)
	var/descriptor_voice = build_coalesce_description_nofluff(
		d_list, H, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%"
	)
	add_bounty(H.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, bounty_total, FALSE, my_crime, bounty_poster)
