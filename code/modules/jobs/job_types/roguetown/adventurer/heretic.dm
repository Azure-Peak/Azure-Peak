// Heretic, higher-power "ontologically valid" soft antagonists. Limited to ascendent rounds w no major antag, because they barely avoided being axed entirely
/datum/job/roguetown/heretic
	title = "Heretic"
	flag = HERETIC
	department_flag = ANTAGONIST
	faction = "Station"
	total_positions = 0
	spawn_positions = 0

	tutorial = "I've been touched by the truth of Psydonia. Lyfe as we understand cannot persist under the Ten or the pretense of Psydon. Something must change. Yet the ignorant stand in my way, again and again. Fine; by fyre and steel, then, will change be wrought."
	outfit = null
	outfit_female = null
	display_order = JDO_HERETIC
	show_in_credits = FALSE
	min_pq = 10
	max_pq = null

	obsfuscated_job = TRUE
	class_categories = TRUE

	advclass_cat_rolls = list(CTAG_WRETCH = 20)
	PQ_boost_divider = 10
	round_contrib_points = 2

	announce_latejoin = FALSE
	wanderer_examine = TRUE
	advjob_examine = TRUE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = FALSE
	same_job_respawn_delay = 1 MINUTES
	virtue_restrictions = list(/datum/virtue/heretic/zchurch_keyholder, /datum/virtue/combat/second_chance) // automatic, n wouldn't make sense
	job_traits = list(TRAIT_STEELHEARTED, TRAIT_OUTLAW, TRAIT_HERESIARCH, TRAIT_SELF_SUSTENANCE, TRAIT_ZURCH)
	job_subclasses = list(
		/datum/advclass/heretic/necromancer,
		/datum/advclass/heretic/heretic, // yes, i know. this is the 'heretic paladin' that gets heavy armor
		/datum/advclass/heretic/heretic/spy,
		/datum/advclass/heretic/heretic_spellblade,
		/datum/advclass/heretic/ancient_spellblade,
		/datum/advclass/heretic/ancient_deathknight,
	)
	has_subprefs = TRUE
	default_subprefs = list("bounty_poster_key" = null, "bounty_severity_key" = null, "my_crime" = null, "favorite_advclass" = null)

// for future viewers, here's how you add subprefs to a job. adventurer provides a simpler example for how to merely add subclass favoriting.
/datum/job/roguetown/heretic/Topic(href, list/href_list)
	var/client/C = usr.client // gettin the usual vars setup
	if(!C || !C.prefs)
		return
	var/list/roleprefs = get_roleprefs(C)
	if(href_list["poster"]) // here, we handle the actual user input. in this case, poster is a tgui select
		var/list/poster_choices = list()
		for(var/key in GLOB.bounty_posters)
			poster_choices[GLOB.bounty_posters[key]] = key
		roleprefs["bounty_poster_key"] = poster_choices[tgui_input_list(usr, "Who placed a bounty on you?", "Bounty Poster", poster_choices)]
		update_subprefs_window(usr) // make sure to call this every time you change data so the ui will actually reflect it!
	if(href_list["severity"]) // ...and same for severity
		var/list/sev_choices = list()
		for(var/key in GLOB.wretch_severities)
			sev_choices[GLOB.wretch_severities[key]] = key
		roleprefs["bounty_severity_key"] = sev_choices[tgui_input_list(usr, "How severe are your crimes?", "Bounty Amount", sev_choices)]
		update_subprefs_window(usr)
	if(href_list["crime"])
		roleprefs["my_crime"] = tgui_input_text(usr, "What is your crime?", "Crime", roleprefs["my_crime"], multiline=TRUE, encode=FALSE) // this is filtered with html_encode later; doing so twice would lead to strangeness
		update_subprefs_window(usr)
	. = ..()

// this is where we put the actual window setup. it'll be called once each update, to keep the information up-to-date, so just read from prefs n display it
/datum/job/roguetown/heretic/update_subprefs_window(mob/user)
	var/client/C = usr.client
	if(!C || !C.prefs)
		return
	var/list/roleprefs = get_roleprefs(C)
	var/datum/advclass/favorite = roleprefs["favorite_advclass"] // note that this key is shared between a bunch of different things n is treated specially. if it's set, you'll automatically try to roll that subclass
	var/favorite_name = favorite ? favorite::name : "Choose"
	var/HTML = {"
		<i>You can choose a favorite subclass here. You'll automatically select this subclass on roundstart if possible.</i><br/><br/>
		<b>Selected class:</b> <a href="?src=[REF(src)];class=1">[favorite_name]</a><br/><br/>
		<i>Set your [title]-specific bounty here. If a global bounty is set, this will override it.</i><br><i>Any fields set here will not prompt you at roundstart.</i><br/><br/>
		<b>Bounty Poster:</b> <a href="?src=[REF(src)];poster=1">[roleprefs["bounty_poster_key"]?GLOB.bounty_posters[roleprefs["bounty_poster_key"]]:"Unset"]</a><br/>
		<b>Bounty Severity:</b> <a href="?src=[REF(src)];severity=1">[roleprefs["bounty_severity_key"]?GLOB.wretch_severities[roleprefs["bounty_severity_key"]]:"Unset"]</a><br/>
		<b>Bounty Reason:</b> <a href="?src=[REF(src)];crime=1">[roleprefs["my_crime"]?"Edit":"Unset"]</a><br/>
		[roleprefs["my_crime"]?"<hr/>[roleprefs["my_crime"]]<hr/>":""]<br/>
		<center><a href="?src=[REF(src)];subprefsexit=1">EXIT</a>\t\t<a href="?src=[REF(src)];subprefsreset=1">RESET</a></center>
	"}
	// the fact that the window width/height will be different each time is the main reason this isn't all done in a parent proc on /datum/job
	var/datum/browser/popup = new(user, "[JOB_SUBPREFS_WINDOW_ID]", "<div align='center'>[title] Preferences</div>", 500, 500)
	popup.set_content(HTML)
	popup.open(FALSE)
	if(winexists(usr, "[JOB_SUBPREFS_WINDOW_ID]"))
		winset(usr, "[JOB_SUBPREFS_WINDOW_ID]", "focus=true")

/datum/job/roguetown/heretic/special_job_check(mob/dead/new_player/player)
	if(is_storyteller_soft_antag_blocked(TRUE))
		return FALSE
	return ..()

/datum/job/roguetown/heretic/special_check_latejoin(client/C)
	if(is_storyteller_soft_antag_blocked(TRUE))
		return FALSE
	return ..()

/datum/job/roguetown/heretic/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/mob/living/carbon/human/H = L
		// Assign wretch antagonist datum so wretches appear in antag list
		if(H.mind && !H.mind.has_antag_datum(/datum/antagonist/heretic))
			var/datum/antagonist/new_antag = new /datum/antagonist/heretic()
			H.mind.add_antag_datum(new_antag)

/datum/job/roguetown/heretic/on_round_removal(mob/M)
	// Respawn delay applies immediately
	if(same_job_respawn_delay && M.ckey)
		GLOB.job_respawn_delays[M.ckey] = world.time + same_job_respawn_delay
	// Delayed slot reopen after 1 hour — subclass always reopens, global slot only if garrison criteria met
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(heretic_delayed_slot_reopen), M.advjob), 1 HOURS)

/proc/heretic_select_bounty(mob/living/carbon/human/H)
	var/datum/preferences/P = H?.client?.prefs
	var/bounty_poster_key
	var/bounty_severity_key
	var/my_crime
	var/list/roleprefs = P?.job_subprefs?["Heretic"]
	if(roleprefs && length(roleprefs))
		bounty_poster_key = roleprefs["bounty_poster_key"]
		bounty_severity_key = roleprefs["bounty_severity_key"]
		my_crime = roleprefs["my_crime"]
	else if(P?.preset_bounty_enabled)
		bounty_poster_key = P.preset_bounty_poster_key
		bounty_severity_key = P.preset_bounty_severity_key
		my_crime = P.preset_bounty_crime

	if(bounty_poster_key && !GLOB.bounty_posters[bounty_poster_key])
		bounty_poster_key = null

	if(bounty_severity_key && !GLOB.wretch_bounty_severities[bounty_severity_key])
		bounty_severity_key = null

	if(!bounty_poster_key)
		var/list/poster_choices = list()
		for(var/key in GLOB.bounty_posters)
			poster_choices[GLOB.bounty_posters[key]] = key
		var/choice = input(H, "Who placed a bounty on you?", "Bounty Poster") as anything in poster_choices
		bounty_poster_key = poster_choices[choice]

	if(!bounty_severity_key)
		var/list/sev_choices = list()
		for(var/key in GLOB.wretch_bounty_severities)
			sev_choices[GLOB.wretch_bounty_severities[key]["name"]] = key
		var/choice = input(H, "How severe are your crimes?", "Bounty Amount") as anything in sev_choices
		bounty_severity_key = sev_choices[choice]

	var/bounty_poster = GLOB.bounty_posters[bounty_poster_key]

	var/list/sev_data = GLOB.wretch_bounty_severities[bounty_severity_key]
	var/bounty_total = rand(sev_data["min"], sev_data["max"])
	if(bounty_severity_key == "ATROCITY")
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
	to_chat(H, span_danger("You are playing an Antagonist role. By choosing to spawn as a Heretic, you are expected to actively create conflict with other players. Failing to play this role with the appropriate gravitas may result in punishment for Low Roleplay standards."))

/proc/update_heretic_slots(override_player_count)
	var/datum/job/heretic_job = SSjob.GetJob("Heretic")
	if(!heretic_job)
		return
	if(heretic_job.admin_slot_override)
		return
	var/slots = SSgamemode.current_storyteller?.heretic_slots
	if(!SSgamemode.allow_vote && !isnull(SSgamemode.admin_slots["Heretic"]))
		slots = max(0, SSgamemode.admin_slots["Heretic"])
	if(isnull(slots))
		slots = 2
	// Never reduce below current occupancy
	heretic_job.total_positions = max(heretic_job.current_positions, slots)
	heretic_job.spawn_positions = max(heretic_job.current_positions, slots)

/// Called after 1 hour delay when a heretic leaves the round.
/// Always reopens the subclass slot. Only reopens the global slot if garrison criteria make sense.
/proc/heretic_delayed_slot_reopen(advclass_name)
	// Always reopen the subclass slot
	if(advclass_name)
		var/datum/advclass/target_class = SSrole_class_handler.get_advclass_by_name(advclass_name)
		if(target_class)
			SSrole_class_handler.adjust_class_amount(target_class, -1)

	var/datum/job/heretic_job = SSjob.GetJob("Heretic")
	if(!heretic_job)
		return
	heretic_job.current_positions = max(0, heretic_job.current_positions - 1)
	update_scaling_slots()
