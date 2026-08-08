// Outcasts: the class fantasy of 'a petty criminal, exiled and with a bounty'. Please do not add ontologically-valid superpowered classes to this it is meant to be mundane
/datum/job/roguetown/outcast
	title = "Outcast"
	flag = OUTCAST
	department_flag = ANTAGONIST
	faction = "Station"
	total_positions = 10 // they're not really antags, but not quite adventurers either. but don't want to add too many "out of town" roles
	spawn_positions = 10 // ...so 10 seems like a decent compromise since they're weaker than advs but, yk, whatever? to revisit upon TM

	tutorial = "Somewhere in your lyfe, you ended up on the wrong side of the law. Too petty a criminal to earn a lyfe sentence, you were instead exiled, and now live in the untamed outskirts, hiding from the gaze of the Crown. Thankfully, you're not alone out here; question is, are you strong enough to survive together? And more importantly - can you trust each other to?"
	outfit = null
	outfit_female = null
	display_order = JDO_OUTCAST
	show_in_credits = FALSE
	min_pq = 10
	max_pq = null

	obsfuscated_job = TRUE

	advclass_cat_rolls = list(CTAG_OUTCAST = 20)
	PQ_boost_divider = 10
	round_contrib_points = 2

	peopleiknow = list("Outcast")
	peopleknowme = list("Outcast")

	announce_latejoin = FALSE
	wanderer_examine = TRUE
	advjob_examine = TRUE
	always_show_on_latechoices = TRUE
	same_job_respawn_delay = 1 MINUTES
	job_traits = list(TRAIT_STEELHEARTED, TRAIT_OUTLAW, TRAIT_OUTCAST, TRAIT_AZURENATIVE) // they should be good at running away bcs they're not really fraggers
	job_subclasses = list(
		/datum/advclass/outcast/exile,
		/datum/advclass/outcast/highwayman,
		/datum/advclass/outcast/malpractitioner,
		/datum/advclass/outcast/poacher,
		/datum/advclass/outcast/rogue_apprentice,
		/datum/advclass/outcast/scrapper,
		/datum/advclass/outcast/skulk,
	)
	has_subprefs = TRUE
	default_subprefs = list("my_crime" = null, "favorite_advclass" = null)

// for future viewers, here's how you add subprefs to a job.
/datum/job/roguetown/outcast/Topic(href, list/href_list)
	var/client/C = usr.client // gettin the usual vars setup
	if(!C || !C.prefs)
		return
	var/list/roleprefs = get_roleprefs(C)
	if(href_list["crime"]) // here, we handle the actual user input. in this case, crime is a text input
		roleprefs["my_crime"] = tgui_input_text(usr, "What is your crime?", "Crime", roleprefs["my_crime"], multiline=TRUE, encode=FALSE) // this is filtered with html_encode later; doing so twice would lead to strangeness
		update_subprefs_window(usr) // make sure to call this every time you change data so the ui will actually reflect it!
	. = ..()

// this is where we put the actual window setup. it'll be called once each update, to keep the information up-to-date, so just read from prefs n display it
/datum/job/roguetown/outcast/update_subprefs_window(mob/user)
	var/client/C = usr.client
	if(!C || !C.prefs)
		return
	var/list/roleprefs = get_roleprefs(C)
	var/datum/advclass/favorite = roleprefs["favorite_advclass"] // note that this key is shared between a bunch of different things n is treated specially. if it's set, you'll automatically try to roll that subclass
	var/favorite_name = favorite ? favorite::name : "Choose"
	var/HTML = {"
		<i>You can choose a favorite subclass here. You'll automatically select this subclass on roundstart if possible.</i><br/><br/>
		<b>Selected class:</b> <a href="?src=[REF(src)];class=1">[favorite_name]</a><br/><br/>
		<i>Set the reason for your exile here. Only Retinue, Garrison, and Courtiers can see this; it's unlikely to get you killed on sight, unless you repeatedly violate your exile by strolling into town.</i><br/><br/>
		<b>Exile Reason:</b> <a href="?src=[REF(src)];crime=1">[roleprefs["my_crime"]?"Edit":"Unset"]</a><br/>
		[roleprefs["my_crime"]?"<hr/>[roleprefs["my_crime"]]<hr/>":""]<br/>
		<center><a href="?src=[REF(src)];subprefsexit=1">EXIT</a>\t\t<a href="?src=[REF(src)];subprefsreset=1">RESET</a></center>
	"}
	// the fact that the window width/height will be different each time is the main reason this isn't all done in a parent proc on /datum/job
	var/datum/browser/popup = new(user, "[JOB_SUBPREFS_WINDOW_ID]", "<div align='center'>[title] Preferences</div>", 500, 500)
	popup.set_content(HTML)
	popup.open(FALSE)
	if(winexists(usr, "[JOB_SUBPREFS_WINDOW_ID]"))
		winset(usr, "[JOB_SUBPREFS_WINDOW_ID]", "focus=true")

// Proc for outcasts to select a bounty
/proc/outcast_select_bounty(mob/living/carbon/human/H)
	var/datum/preferences/P = H?.client?.prefs
	var/my_crime
	var/list/roleprefs = P?.job_subprefs?["Outcast"]
	if(roleprefs && length(roleprefs))
		my_crime = roleprefs["my_crime"]
	else if(P?.preset_bounty_enabled)
		my_crime = P.preset_bounty_crime

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
	add_exile(H.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, my_crime) // you're NOT a heretic, crucially
	to_chat(H, span_danger("You are outcast: exiled, unwelcome in the civilized parts of Azuria. Lyfe in the wyld may be tough, but should you flaunt the terms of your exile, the Crown may not be so lenient this time.")) // aka "you're not ubervalid but you're unwelcome in town"
	GLOB.exiled_players += H.real_name
