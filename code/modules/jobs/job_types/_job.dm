/datum/job
	//The name of the job , used for preferences, bans and more. Make sure you know what you're doing before changing this.
	var/title = "NOPE"
	// Display title - If empty, uses the proper title instead
	var/display_title
	// Display only title for feminine character
	var/f_title

	//Job access. The use of minimal_access or access is determined by a config setting: config.jobs_have_minimal_access
	var/list/minimal_access = list()		//Useful for servers which prefer to only have access given to the places a job absolutely needs (Larger server population)
	var/list/access = list()				//Useful for servers which either have fewer players, so each person needs to fill more than one role, or servers which like to give more access, so players can't hide forever in their super secure departments (I'm looking at you, chemistry!)

	//Determines who can demote this position
	var/department_head = list()

	//Tells the given channels that the given mob is the new department head. See communications.dm for valid channels.
	var/list/head_announce = null

	//Bitflags for the job
	var/flag = NONE //Deprecated
	var/department_flag = NONE //Deprecated
	var/auto_deadmin_role_flags = NONE

	//Players will be allowed to spawn in as jobs that are set to "Station"
	var/faction = "None"

	//How many players can be this job
	var/total_positions = 0

	//How many players can spawn in as this job
	var/spawn_positions = 0

	//How many players have this job
	var/current_positions = 0

	//Whether this job clears a slot when you get a rename prompt.
	var/antag_job = FALSE

	//Supervisors, who this person answers to directly
	var/supervisors = ""

	//Sellection screen color
	var/selection_color = "#dbdce3"
	var/class_categories = FALSE


	//If this is set to 1, a text is printed to the player when jobs are assigned, telling him that he should let admins know that he has to disconnect.
	var/req_admin_notify

	//If you have the use_age_restriction_for_jobs config option enabled and the database set up, this option will add a requirement for players to be at least minimal_player_age days old. (meaning they first signed in at least that many days before.)
	var/minimal_player_age = 0

	var/outfit = null
	var/visuals_only_outfit = null //Handles outfits specifically for cases where you may need to prevent sensitive items from spawning. (e.g Crowns)
	var/outfit_female = null

	var/exp_requirements = 0

	var/exp_type = ""
	var/exp_type_department = ""

	//The amount of good boy points playing this role will earn you towards a higher chance to roll antagonist next round
	//can be overridden by antag_rep.txt config
	var/antag_rep = 10

	var/paycheck = PAYCHECK_MINIMAL
	var/paycheck_department = ACCOUNT_CIV

	var/display_order = JOB_DISPLAY_ORDER_DEFAULT

	//allowed sex/race for picking
	var/list/allowed_sexes = list(MALE, FEMALE)
	var/list/allowed_races = RACES_ALL_KINDS
	var/list/allowed_patrons
	var/list/allowed_ages = ALL_AGES_LIST

	/// Innate skill levels unlocked at roundstart. Format is list(/datum/skill/foo = SKILL_EXP_NOVICE) with exp as an integer or as per code/_DEFINES/skills.dm
	var/list/skills

	var/list/spells

	var/job_greet_text = TRUE
	var/tutorial = null

	var/whitelist_req = FALSE

	var/bypass_jobban = FALSE
	var/bypass_lastclass = TRUE

	var/list/peopleiknow = list()
	var/list/peopleknowme = list()

	var/plevel_req = 0
	var/min_pq = 0
	var/max_pq = 0
	var/round_contrib_points = 0 //Each 10 contributor points counts as 1 PQ, up to 10 PQ.

	var/show_in_credits = TRUE
	var/announce_latejoin = TRUE
	var/give_bank_account = FALSE
	var/noble_income = FALSE //Passive income every day from noble estate

	var/can_random = TRUE

	//is the job required for game progression
	var/required = FALSE

	/// Some jobs have unique combat mode music, because why not?
	var/cmode_music

	/// This job is a "wanderer" on examine
	var/wanderer_examine = FALSE

	/// This job uses adventurer classes on examine
	var/advjob_examine = FALSE

	/// This job always shows on latechoices
	var/always_show_on_latechoices = FALSE

	/// Cooldown for joining as this job again, if it was your last job
	var/same_job_respawn_delay = FALSE

	/// This job re-opens slots if someone dies as it
	var/job_reopens_slots_on_death = FALSE

	/// This job is immune to species-based swapped gender locks
	var/immune_to_genderswap = FALSE

	/// Jobs that are obsfuscated on actor screen
	var/obsfuscated_job = FALSE

	///Jobs that are hidden from actor screen
	var/hidden_job = FALSE

	///Jobs that change their advclass examine as the user levels up.
	var/adaptive_name = FALSE


/*
	How this works, its CTAG_DEFINE = amount_to_attempt_to_role
	EX: advclass_cat_rolls = list(CTAG_PILGRIM = 5, CTAG_ADVENTURER = 5)
	You will still need to contact the subsystem though
*/
	var/list/advclass_cat_rolls

/*
	How this works, they get one extra roll on every category per PQ amount
*/
	var/PQ_boost_divider = 0

	var/list/virtue_restrictions
	var/list/vice_restrictions

	///The job's stats
	var/list/job_stats

	///The job's traits, best used SEPARATELY from subclass traits for your own sanity.
	var/list/job_traits

	///The job's subclasses, if any. Overrides job_stats if present.
	var/list/job_subclasses

	///The job's stat UPPER ceilings, clamped after statpacks and job stats are applied.
	var/list/stat_ceilings

	///Whether this class can be clicked on for details.
	var/class_setup_examine = TRUE

	/// Whether this job is intended to give quests
	var/is_quest_giver = FALSE

	/// How many quests this job can take at once
	var/max_active_quests = 3


/datum/job/proc/special_job_check(mob/dead/new_player/player)
	return TRUE

/datum/job/proc/get_used_title(mob/player)
	var/pronouns = player.pronouns
	var/used_name = display_title || title
	if((pronouns == SHE_HER || pronouns == THEY_THEM_F) && f_title)
		used_name = f_title
	return used_name

/client/proc/job_greet(var/datum/job/greeting_job)
	if(mob.job == greeting_job.title)
		greeting_job.greet(mob)

/datum/job/proc/greet(mob/player)
	if(player?.mind?.assigned_role != title)
		return
	if(!job_greet_text)
		return
	var/used_title = get_used_title(player)
	to_chat(player, span_notice("You are the <b>[used_title]</b>"))
	if(tutorial)
		to_chat(player, span_notice("*-----------------*"))
		to_chat(player, span_notice(tutorial))

//Only override this proc
//H is usually a human unless an /equip override transformed it
/datum/job/proc/after_spawn(mob/living/H, mob/M, latejoin = FALSE, client/player_client)
	SHOULD_CALL_PARENT(TRUE)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_JOB_AFTER_SPAWN, src)
	//do actions on H but send messages to M as the key may not have been transferred_yet
	if(job_traits)
		for(var/trait in job_traits)
			ADD_TRAIT(H, trait, JOB_TRAIT)

	if(!ishuman(H))
		return

	if(spells && H.mind)
		for(var/S in spells)
			H.mind.AddSpell(new S)

	if(length(job_stats))
		for(var/stat in job_stats)
			H.change_stat(stat, job_stats[stat])

	for(var/X in peopleknowme)
		for(var/datum/mind/MF in get_minds(X))
			if(isnull(H.mind?.special_role) && (MF?.special_role in list(ROLE_VAMPIRE, ROLE_NBEAST, ROLE_BANDIT, ROLE_LICH, ROLE_WRETCH, ROLE_UNBOUND_DEATHKNIGHT)))
				continue
			H.mind.person_knows_me(MF)
	for(var/X in peopleiknow)
		for(var/datum/mind/MF in get_minds(X))
			if(isnull(H.mind?.special_role) && (MF?.special_role in list(ROLE_VAMPIRE, ROLE_NBEAST, ROLE_BANDIT, ROLE_LICH, ROLE_WRETCH, ROLE_UNBOUND_DEATHKNIGHT)))
				continue
			H.mind.i_know_person(MF)

	// Ready up bonus
	if(!H.islatejoin)
		H.adjust_triumphs(1)
		H.apply_status_effect(/datum/status_effect/buff/foodbuff)
		H.hydration = 1000 // Set higher hydration

		if(H.mind)
			H.mind?.special_items["Pouch of Coins"] = /obj/item/storage/belt/rogue/pouch/coins/readyuppouch
			if (HAS_TRAIT(H, TRAIT_MEDIUMARMOR) || HAS_TRAIT(H, TRAIT_HEAVYARMOR))
				H.mind?.special_items["Metal Scrap (Repair kit)"] = /obj/item/repair_kit/metal/bad
			else
				H.mind?.special_items["Fabric Patch (Repair kit)"] = /obj/item/repair_kit/bad

		to_chat(M, span_notice("Rising early, you made sure to pack a pouch of coins in your stash and eat a hearty breakfast before starting your day. A true TRIUMPH!"))

	if(H.islatejoin && announce_latejoin)
		var/used_title = display_title || title
		if((H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F) && f_title)
			used_title = f_title
		scom_announce("[H.real_name] the [used_title] arrives to Azure Peak.")

	if(give_bank_account)
		if(give_bank_account > 1)
			SStreasury.create_bank_account(H, give_bank_account)
			if(noble_income)
				SStreasury.noble_incomes[H] = noble_income

		else
			SStreasury.create_bank_account(H)

	if(show_in_credits)
		SScrediticons.processing += H

	if(cmode_music)
		H.cmode_music = cmode_music

	if (!hidden_job)
		var/mob_name = H.real_name
		var/mob_rank
		if (obsfuscated_job)
			mob_rank = "Adventurer"
		else
			mob_rank = H.mind.assigned_role
		GLOB.actors_list[H.mobid] = list("name" = mob_name, "rank" = mob_rank)

	if(islist(advclass_cat_rolls))
		hugboxify_for_class_selection(H)
	
	var/list/owned_triumph_buys = SStriumphs.triumph_buy_owners[player_client.ckey]
	if(length(owned_triumph_buys))
		for(var/datum/triumph_buy/T in owned_triumph_buys)
			T.on_after_spawn(H)

	log_admin("[H.key]/([H.real_name]) has joined as [H.mind.assigned_role].")

/client/verb/set_mugshot()
	set category = "OOC"
	set name = "Set Credits Mugshot"
	set hidden = FALSE
	if(mob && ishuman(mob) && mob.mind)
		var/mob/living/carbon/human/H = mob
		if(!H.mind.mugshot_set)
			to_chat(src, "Updating mugshot...")
			H.mind.mugshot_set = TRUE
			H.add_credit(TRUE)
			to_chat(src, "Mugshot updated.")
		else
			to_chat(src, "Mugshots are resource intensive. You are limited to one per character.")

/mob/living/carbon/human/proc/add_credit(generate_for_adv_class = FALSE) //Evil code to get the proper image for adv classes after they spawn in.
	if(!mind || !client)
		return
	var/thename = "[real_name]"
	var/datum/job/J = SSjob.GetJob(mind.assigned_role)
	var/used_title = get_role_title()

	GLOB.credits_icons[thename] = list()
	var/client/C = client
	var/datum/preferences/P = C.prefs
	var/icon/I
	if(generate_for_adv_class)
		I = get_flat_human_icon(null, J, P, DUMMY_HUMAN_SLOT_MANIFEST, list(SOUTH), human_gear_override = src)
	else if (P)
		I = get_flat_human_icon(null, J, P, DUMMY_HUMAN_SLOT_MANIFEST, list(SOUTH))
	if(I)
		var/icon/female_s = icon("icon"='icons/mob/clothing/under/masking_helpers.dmi', "icon_state"="credits")
		I.Blend(female_s, ICON_MULTIPLY)
		I.Scale(96,96)
		GLOB.credits_icons[thename]["title"] = used_title
		GLOB.credits_icons[thename]["icon"] = I
		GLOB.credits_icons[thename]["vc"] = voice_color

/datum/job/proc/announce(mob/living/carbon/human/H)

/datum/job/proc/override_latejoin_spawn(mob/living/carbon/human/H)		//Return TRUE to force latejoining to not automatically place the person in latejoin shuttle/whatever.
	return FALSE

//Used for a special check of whether to allow a client to latejoin as this job.
/datum/job/proc/special_check_latejoin(client/C)
	return TRUE

/datum/job/proc/GetAntagRep()
	. = CONFIG_GET(keyed_list/antag_rep)[lowertext(title)]
	if(. == null)
		return antag_rep

//Proc that returns the final outfit we should equip on someone, can be overriden for special behavior
/datum/job/proc/get_outfit(mob/living/carbon/human/wearer, visualsOnly = FALSE, announce = TRUE, latejoin = FALSE, preference_source = null)
	return outfit

//Don't override this unless the job transforms into a non-human (Silicons do this for example)
/datum/job/proc/equip(mob/living/carbon/human/H, visualsOnly = FALSE, announce = TRUE, latejoin = FALSE, datum/outfit/outfit_override = null, client/preference_source)
	if(!H)
		return FALSE
	if(CONFIG_GET(flag/enforce_human_authority) && (title in GLOB.command_positions))
		if((H.dna.species.id != "human") && (H.dna.species.id != "humen"))
			H.set_species(/datum/species/human)
			H.apply_pref_name("human", preference_source)
	if(!visualsOnly)
		var/datum/bank_account/bank_account = new(H.real_name, src)
		bank_account.payday(STARTING_PAYCHECKS, TRUE)
		H.account_id = bank_account.account_id

	//Equip the rest of the gear
	H.dna.species.before_equip_job(src, H, visualsOnly)
	if(!outfit_override && visualsOnly && visuals_only_outfit)
		outfit_override = visuals_only_outfit
	if(should_wear_femme_clothes(H))
		if(outfit_override || outfit_female)
			H.equipOutfit(outfit_override ? outfit_override : outfit_female, visualsOnly)
		else
			var/final_outfit = get_outfit(H, visualsOnly, announce, latejoin, preference_source)
			if(final_outfit)
				H.equipOutfit(final_outfit, visualsOnly)
	else
		if(outfit_override || outfit)
			H.equipOutfit(outfit_override ? outfit_override : outfit, visualsOnly)

	H.dna.species.after_equip_job(src, H, visualsOnly)

	if(!visualsOnly && announce)
		announce(H)

/datum/job/proc/get_access()
	if(!config)	//Needed for robots.
		return src.minimal_access.Copy()

	. = list()

	if(CONFIG_GET(flag/jobs_have_minimal_access))
		. = src.minimal_access.Copy()
	else
		. = src.access.Copy()

	if(CONFIG_GET(flag/everyone_has_maint_access)) //Config has global maint access set
		. |= list(ACCESS_MAINT_TUNNELS)

//If the configuration option is set to require players to be logged as old enough to play certain jobs, then this proc checks that they are, otherwise it just returns 1
/datum/job/proc/player_old_enough(client/C)
	if(available_in_days(C) == 0)
		return TRUE	//Available in 0 days = available right now = player is old enough to play.
	return FALSE


/datum/job/proc/available_in_days(client/C)
	if(!C)
		return 0
	if(!CONFIG_GET(flag/use_age_restriction_for_jobs))
		return 0
	if(!SSdbcore.Connect())
		return 0 //Without a database connection we can't get a player's age so we'll assume they're old enough for all jobs
	if(!isnum(minimal_player_age))
		return 0

	return max(0, minimal_player_age - C.player_age)

//Unused as of now
/datum/job/proc/config_check()
	return TRUE

/datum/outfit/job
	name = "Standard Gear"

	var/jobtype = null

/datum/outfit/job/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
/*	switch(H.backpack)
		if(GBACKPACK)
			back = /obj/item/storage/backpack //Grey backpack
		if(GSATCHEL)
			back = /obj/item/storage/backpack/satchel //Grey satchel
		if(GDUFFELBAG)
			back = /obj/item/storage/backpack/duffelbag //Grey Duffel bag
		if(LSATCHEL)
			back = /obj/item/storage/backpack/satchel/leather //Leather Satchel
		if(DSATCHEL)
			back = satchel //Department satchel
		if(DDUFFELBAG)
			back = duffelbag //Department duffel bag
		else
			back = backpack //Department backpack

	//converts the uniform string into the path we'll wear, whether it's the skirt or regular variant
	var/holder
	if(H.jumpsuit_style == PREF_SKIRT)
		holder = "[uniform]"
	else
		holder = "[uniform]"
	uniform = text2path(holder)*/

/datum/outfit/job/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE, client/player_client)
	if(visualsOnly)
		return

	var/datum/job/J = SSjob.GetJobType(jobtype)
	if(!J)
		J = SSjob.GetJob(H.job)

//Warden and regular officers add this result to their get_access()
/datum/job/proc/check_config_for_sec_maint()
	if(CONFIG_GET(flag/security_has_maint_access))
		return list(ACCESS_MAINT_TUNNELS)
	return list()

/datum/job/proc/clamp_stats(mob/living/carbon/human/H)
	var/list/statcl
	if(length(stat_ceilings))
		statcl = stat_ceilings
	var/datum/advclass/advclass = SSrole_class_handler.get_advclass_by_name(H.advjob)
	if(advclass && length(advclass.adv_stat_ceiling))
		statcl = advclass.adv_stat_ceiling

	if(length(statcl))
		for(var/stat in statcl)
			if(statcl[stat] < H.get_stat(stat))
				H.change_stat(stat, (statcl[stat] - H.get_stat(stat)))
				to_chat(H, "Your [stat] was reduced to \Roman[statcl[stat]] due to class limits.")

// LETHALSTONE EDIT: Helper functions for pronoun-based clothing selection
/proc/should_wear_masc_clothes(mob/living/carbon/human/H)
	return (H.pronouns == HE_HIM || H.pronouns == THEY_THEM || H.pronouns == SHE_HER_M || (H.pronouns == IT_ITS && H.gender == MALE))

/proc/should_wear_femme_clothes(mob/living/carbon/human/H)
	return (H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F || H.pronouns == HE_HIM_F || (H.pronouns == IT_ITS && H.gender == FEMALE))
// LETHALSTONE EDIT END

/datum/job/proc/get_informed_title(mob/mob)
	if(mob.gender == FEMALE && f_title)
		return f_title

	return display_title || title

/datum/job/Topic(href, list/href_list)
	if(href_list["explainjob"])
		var/list/dat = list()
		var/show_job_traits = TRUE
		var/sclass_count = 0
		if(length(job_subclasses) && length(job_stats))
			CRASH("[REF(src)] has definitions for both class and subclass stats. Likely not intended, and they will stack!")
		if(length(job_subclasses))
			dat += "This class has the following subclasses: "
			for(var/sclass in job_subclasses)
				sclass_count++
				var/datum/advclass/adv = sclass
				var/datum/advclass/adv_ref = SSrole_class_handler.get_advclass_by_name(initial(adv.name))
				dat += "<details><summary><b><font color ='#ece9e9'>[adv_ref.name]</font></b></summary>"
				dat += "<table align='center'; width='100%'; height='100%';border: 1px solid white;border-collapse: collapse>"
				dat += "<tr style='vertical-align:top'>"
				dat += "<td width = 70%><i><font color ='#ece9e9'>[adv_ref.tutorial]</font></i></td>"
				dat += "<td width = 30%; style='text-align:right'>"
				if(length(adv_ref.subclass_stats))
					dat += "<font color ='#7a4d0a'>Stat Bonuses:</font><font color ='#d4b164'>"
					for(var/stat in adv_ref.subclass_stats)
						dat += "<br>[capitalize(stat)]: <b>[adv_ref.subclass_stats[stat] < 0 ? "<font color = '#cf2a2a'>" : "<font color = '#91cf68'>"]\Roman[adv_ref.subclass_stats[stat]]</font></b>"
				dat += "<br></td></tr></table></font>"
				if(length(adv_ref.adv_stat_ceiling))
					dat += "["<font color = '#cf2a2a'><b>This subclass has the following stat limits: "]</b></font><br>"
					dat += " | "
					for(var/stat in adv_ref.adv_stat_ceiling)
						dat += "["[capitalize(stat)]: <b>\Roman[adv_ref.adv_stat_ceiling[stat]]</b>"] | "
					dat += "<i><br>Regardless of your statpacks or race choice, you will not be able to exceed these stats on spawn.</i></font>"
				if(adv_ref.subclass_spellpoints > 0)
					dat += "<font color = '#a3a7e0'>Starting Spellpoints: <b>[adv_ref.subclass_spellpoints]</b></font>"
				if(length(adv_ref.subclass_languages))
					dat += "<details><summary><i>Known Languages</i></summary>"
					for(var/i in 1 to length(adv_ref.subclass_languages))
						var/datum/language/lang = adv_ref.subclass_languages[i]
						dat += "<i>[initial(lang.name)][i == length(adv_ref.subclass_languages) ? "" : ", "]</i>"
					dat += "</details>"
				dat += "<table align='center'; width='100%'; height='100%';border: 1px solid white;border-collapse: collapse>"
				dat += "<tr style='vertical-align:top'>"
				dat += "<td width = 50%>"	//Table for SubClass Traits | Class Skills
				if(length(adv_ref.traits_applied) || (!length(adv_ref.traits_applied) && length(job_traits)))
					var/list/traitlist
					if(length(adv_ref.traits_applied))
						traitlist = adv_ref.traits_applied
						dat += "<font color ='#7a4d0a'><b>Sub</b>class Traits:</font> "
					else if(!length(adv_ref.traits_applied) && length(job_traits))
						traitlist = job_traits
						show_job_traits = FALSE
						dat += "<font color ='#7a4d0a'><b>Class</b> Traits:</font> "
					for(var/trait in traitlist)
						dat += "<details><summary><i><font color ='#ccbb82'>[trait]</font></i></summary>"
						dat += "<i><font color = '#a3ffe0'>[GLOB.roguetraits[trait]]</font></i></details>"
					dat += "</font>"
					dat += "<br>"
				if(length(adv_ref.subclass_stashed_items))
					dat += "<br><font color ='#7a4d0a'>Stashed Items:</font><font color ='#d4b164'>"
					for(var/stashed_item in adv_ref.subclass_stashed_items)
						dat += "<br> - <i>[stashed_item]</i>"
					dat += "</font>"
				dat += "</td>"	//Trait Table end
				if(length(adv_ref.subclass_skills))
					dat += "<td width = 50%; style='text-align:right'>"
					var/list/notable_skills = list()
					for(var/sk in adv_ref.subclass_skills)
						if(adv_ref.subclass_skills[sk] >= SKILL_LEVEL_JOURNEYMAN)
							notable_skills[sk] = adv_ref.subclass_skills[sk]
						else if(ispath(sk, /datum/skill/combat))
							notable_skills[sk] = adv_ref.subclass_skills[sk]
					if(!length(notable_skills))	//Nothing above Jman AND no Combat skills.
						dat += "<i>This subclass has no notable skills.</i>"
					else
						notable_skills = sortTim(notable_skills,/proc/cmp_numeric_dsc, TRUE)
						var/max_skills = 5	//We don't want to print out /all/ of them, as it messes up the formatting.
						dat += "<font color ='#7a4d0a'>Notable Skills: </font>"
						for(var/sk in notable_skills)
							if(max_skills > 0)
								var/datum/skill/skill = sk
								dat += "<font color ='#d4b164'><br>[initial(skill.name)] — [SSskills.level_names[notable_skills[sk]]]</font>"
								max_skills--
						LAZYCLEARLIST(notable_skills)
				dat += "</td></tr></table>"//Skill table end
				if(adv_ref.extra_context)
					dat += "<font color ='#a06c1e'>[adv_ref.extra_context]"
					dat += "</font>"
				dat += "</details>"
		dat += "<hr>"
		if(length(job_stats))
			dat += "Starting Stats:<font color ='#d4b164'>"
			for(var/stat in job_stats)
				dat += "<br>[capitalize(stat)]: <b>[job_stats[stat] < 0 ? "<font color = '#cf2a2a'>" : "<font color = '#91cf68'>"]\Roman[job_stats[stat]]</font></b>"
			dat += "</font>"	//Ends the stats colors
			if(length(stat_ceilings))
				dat += "["<br><font color = '#cf2a2a'><b>This class has the following stat limits:</b> "]<br>"
				dat += " | "
				for(var/stat in stat_ceilings)
					dat += "["[capitalize(stat)]: <b>\Roman[stat_ceilings[stat]]</b>"] | "
				dat += "<br><i>Regardless of your statpacks or race choice, you will not be able to exceed these stats on spawn.</i></font>"
				dat += "</font>"	//Ends the stat limit colors
		if(length(job_traits) && (show_job_traits || sclass_count > 1))
			dat += "<b>Class</b></font> Traits: "
			for(var/trait in job_traits)
				dat += "<details><summary><i><font color ='#ccbb82'>[trait]</font></i></summary>"
				dat += "<i><font color = '#a3ffe0'>[GLOB.roguetraits[trait]]</font></i></details>"
			dat += "</font>"
		dat += "<br><i>This information is not all-encompassing. Many classes have other quirks and skills that define them.</i>"
		if(istype(src,/datum/job/roguetown/jester))
			LAZYCLEARLIST(dat)
			dat = list("<font color = '#d151ab'><center>Come one, come all, where Psydon Lies! <br>Let Xylix roll the dice, <br>unto our untimely demise! <br>Ahahaha!</center>")
			dat += "<center><b><font size = 4>STR: ???</b><br>"
			dat += "<b>WIL: ???</b><br>"
			dat += "<b>CON: ???</b><br>"
			dat += "<b>PER: ???</b><br>"
			dat += "<b>INT: ???</b><br>"
			dat += "<b>FOR: ???</b><br></center></font>"
		var/height = 550
		if(sclass_count >= 10)
			height = 925
		var/datum/browser/popup = new(usr, "classhelp", "<div style='text-align: center'>[title]</div>", nwidth = 475, nheight = height)
		popup.set_content(dat.Join())
		popup.open(FALSE)
		if(winexists(usr, "classhelp"))
			winset(usr, "classhelp", "focus=true")
	if(href_list["jobsubclassinfo"])
		var/list/dat = list()
		for(var/adv in job_subclasses)
			var/datum/advclass/advpath = adv
			var/datum/advclass/subclass = SSrole_class_handler.get_advclass_by_name(initial(advpath.name))
			if(subclass.maximum_possible_slots != -1)
				dat += "[subclass.name] — <b>"
				if(subclass.total_slots_occupied >= subclass.maximum_possible_slots)
					dat += "FULL!"
				else
					dat += "[subclass.total_slots_occupied] / [subclass.maximum_possible_slots]"
				dat += "</b><br>"
		var/datum/browser/popup = new(usr, "subclassslots", "<div style='text-align: center'>[title]</div>", nwidth = 200, nheight = 300)
		popup.set_content(dat.Join())
		popup.open(FALSE)
		if(winexists(usr, "subclassslots"))
			winset(usr, "subclassslots", "focus=true")
	. = ..()

/datum/job/proc/has_limited_subclasses()
	if(length(job_subclasses) <= 0)
		return FALSE
	for(var/adv in job_subclasses)
		var/datum/advclass/subclass = adv
		if(initial(subclass.maximum_possible_slots) != -1)
			return TRUE
	return FALSE
