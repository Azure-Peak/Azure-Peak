/datum/job/roguetown/adventurer/courtagent
	title = "Court Agent"
	flag = COURTAGENT
	display_order = JDO_COURTAGENT


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
	townie_contract_gate_exempt = TRUE
	class_setup_examine = FALSE
	has_subprefs = TRUE
	default_subprefs = list("codename" = null, "hand_file_notes" = null, "hand_file_notes_raw" = null)

/datum/job/roguetown/adventurer/courtagent/Topic(href, list/href_list)
	var/client/C = usr.client
	if(!C || !C.prefs)
		return
	var/list/subprefs = get_roleprefs(C)
	if(href_list["codename"])
		subprefs["codename"] = tgui_input_text(usr, "By what are you addressed?", "CODENAME", subprefs["codename"], MAX_NAME_LEN)
		update_subprefs_window(usr)
	if(href_list["hand_file_notes"])
		subprefs["hand_file_notes_raw"] = tgui_input_text(usr, "What does your file say?", "THY DEEDS ARE KNOWN", subprefs["hand_file_notes_raw"], multiline = TRUE, encode = FALSE)
		subprefs["hand_file_notes"] = parsemarkdown(subprefs["hand_file_notes_raw"], usr)
		update_subprefs_window(usr)
	if(href_list["markdownhelp"])
		var/list/dat = list()
		dat +="You can use backslash (\\) to escape special characters.<br>"
		dat += "<br>"
		dat += "# text : Defines a header.<br>"
		dat += "|text| : Centers the text.<br>"
		dat += "**text** : Makes the text <b>bold</b>.<br>"
		dat += "*text* : Makes the text <i>italic</i>.<br>"
		dat += "^text^ : Increases the <font size = \"4\">size</font> of the text.<br>"
		dat += "((text)) : Decreases the <font size = \"1\">size</font> of the text.<br>"
		dat += "* item : An unordered list item.<br>"
		dat += "--- : Adds a horizontal rule.<br>"
		dat += "-=FFFFFFtext=- : Adds a specific <font color = '#FFFFFF'>colour</font> to text.<br><br>"
		var/datum/browser/popup = new(usr, "Formatting Help", nwidth = 400, nheight = 350)
		popup.set_content(dat.Join())
		popup.open(FALSE)
	. = ..()

/datum/job/roguetown/adventurer/courtagent/update_subprefs_window(mob/user)
	var/client/C = usr.client
	if(!C)
		return
	var/datum/preferences/prefs = C.prefs
	if(!prefs)
		return
	if(!prefs.job_subprefs || !islist(prefs.job_subprefs))
		prefs.job_subprefs = list()
	if(!prefs.job_subprefs[title])
		prefs.job_subprefs[title] = list("codename" = null, "hand_file_notes" = null, "favorite_advclass" = null)
	var/list/subprefs = prefs.job_subprefs[title]
	var/datum/advclass/favorite = subprefs["favorite_advclass"]
	var/favorite_name = favorite ? favorite::name : "Choose"
	var/HTML = {"
		You can define a codename and the contents of the Hand's file on you here. Keep codenames sensible, please.<br/>
		In addition to what you write here, the Hand's file will contain your name, descriptors, species, and subclass.<br/><br/>
		The Hand file is an IC document, but should be used like OOC notes to provide RP hooks specific to the Hand. Some suggestions:<br/>
		<ul>
			<li>- How you ended up in the Hand's employ/what leverage they have over you. Are you a criminal serving an unorthodox sentence? A debtor? An old friend?</li>
			<li>- Your specialties, strengths, weaknesses; what kind of work you, OOC, want to do. Keep in mind they can already see your class.</li>
			<li>- Anything else the Hand would know about you, but nobody else. Do you have a habit of encoding your communiques with a pre-established method? Do you have a shared past? Be reasonable, as always.</li>
		</ul><br/>
		<b>Codename:</b> <a href="?src=[REF(src)];codename=1">[subprefs["codename"]?subprefs["codename"]:"Unset"]</a><br/>
		<b>Hand Notes:</b> <a href="?src=[REF(src)];hand_file_notes=1">Edit</a> <a href="?src=[REF(src)];markdownhelp=1">\[?\]</a><br/>
		[subprefs["hand_file_notes_raw"]?parsemarkdown("---[subprefs["hand_file_notes_raw"]]\n---",usr):""]
		<i>You can choose a favorite subclass here. You'll automatically select this subclass on roundstart if possible.</i><br/>
		<b>Selected class:</b> <a href="?src=[REF(src)];class=1">[favorite_name]</a>
		<center><a href="?src=[REF(src)];subprefsexit=1">EXIT</a>\t\t<a href="?src=[REF(src)];subprefsreset=1">RESET</a></center>
	"}
	var/datum/browser/popup = new(user, "[JOB_SUBPREFS_WINDOW_ID]", "<div align='center'>[title] Preferences</div>", 600, 900)
	popup.set_content(HTML)
	popup.open(FALSE)
	if(winexists(usr, "[JOB_SUBPREFS_WINDOW_ID]"))
		winset(usr, "[JOB_SUBPREFS_WINDOW_ID]", "focus=true")

//Hooking in here does not mess with their equipment procs
/datum/job/roguetown/adventurer/courtagent/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	if(L)
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			GLOB.court_agents[H.real_name] = H
			if(H.mind)
				H.mind.special_role = "Court Agent" //For obfuscating them in the Actors list: _job.dm L:216
				add_verb(H, /datum/job/roguetown/adventurer/courtagent/proc/remember_employer)
				var/list/agent_prefs = H.mind.job_subprefs["Court Agent"]
				if(!agent_prefs)
					agent_prefs = list("codename" = null, "hand_file_notes" = null, "hand_file_notes_raw" = null)
					H.mind.job_subprefs["Court Agent"] = agent_prefs
				if(!agent_prefs["hand_file_notes"]) // someone forgot to set their prefs, whuh oh!
					to_chat(H, span_notice("Set your class preferences for Court Agent to disable this popup!"))
					agent_prefs["hand_file_notes"] = parsemarkdown(tgui_input_text(H, "What does your file say?", "THY DEEDS ARE KNOWN", multiline = TRUE, encode = FALSE))
					agent_prefs["codename"] = tgui_input_text(H, "Do you have a codename?", "CODENAME", null, MAX_NAME_LEN)
			addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living/carbon/human, know_employer)), 1 MINUTES) // give roundstart a bit to settle
			addtimer(CALLBACK(src, PROC_REF(give_zadcage), H), 1 MINUTES) // this needs to happen after equipment ideally
			..()

/datum/job/roguetown/adventurer/courtagent/proc/give_zadcage(mob/living/carbon/human/H)
	var/datum/component/storage/bag
	var/obj/item/zadcage/cagent/cage = new /obj/item/zadcage/cagent(H.drop_location())
	if(GLOB.hand_zadcote)
		var/obj/item/roguemachine/zadcote/hand/handcote = GLOB.hand_zadcote
		for(var/datum/zadlink/link in handcote.slots)
			if(link.cage_ref && link.cage_ref.resolve() == src)
				link.display_name = H.real_name
				break
	if(H.backr && H.backr.GetComponent(/datum/component/storage))
		bag = H.backr.GetComponent(/datum/component/storage)
		if(!bag.handle_item_insertion(cage, TRUE))
			bag = null
	if(!bag && H.backl && H.backl.GetComponent(/datum/component/storage)) // some classes have bag on the left
		bag = H.backl.GetComponent(/datum/component/storage)
		if(!bag.handle_item_insertion(cage, TRUE))
			bag = null
	if(!bag) // ...if all else fails, just throw it in their hands or drop it
		H.put_in_hands(cage)
	to_chat(H, span_notice("I feel the reassuring weight of my zadcage[bag?" in my bag":""]. It is my lifeline; it risks exposing me. I must keep it safe and hidden."))

/mob/living/carbon/human/proc/know_employer()
	if(!GLOB.court_spymaster.len)
		to_chat(src, span_boldnotice("I currently have no spymaster."))
	else
		to_chat(src, span_boldnotice("My spymaster is:"))
		for(var/name in GLOB.court_spymaster)
			to_chat(src, span_greentext(name))
			var/mob/living/carbon/human/hand = GLOB.court_spymaster[name]
			if(hand && istype(hand) && hand.mind)
				hand.mind.i_know_person(src)
				src.mind.i_know_person(hand)

/datum/job/roguetown/adventurer/courtagent/proc/remember_employer()
	set name = "Remember Spymaster"
	set category = "RoleUnique.Subterfuge"

	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/H = usr
	H.know_employer()
	return
