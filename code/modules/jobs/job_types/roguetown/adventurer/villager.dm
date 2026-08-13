/datum/job/roguetown/villager
	title = "Towner"
	flag = VILLAGER
	department_flag = PEASANTS
	faction = "Station"
	total_positions = 75
	spawn_positions = 75
	// forbidden_races = list(RACES_DESPISED)
	tutorial = "You've lived in this shithole for effectively all your life. You are not an explorer, nor exactly a warrior in many cases. You're just some average poor bastard who thinks they'll be something someday. Respect the nobles and yeomen alike for they are your superiors - should you find yourself in trouble your Elder is your best hope."
	advclass_cat_rolls = list(CTAG_TOWNER = 20)
	outfit = null
	outfit_female = null
	bypass_lastclass = TRUE
	bypass_jobban = FALSE
	display_order = JDO_VILLAGER
	give_bank_account = TRUE
	min_pq = -15
	max_pq = null
	round_contrib_points = 2
	wanderer_examine = FALSE
	advjob_examine = TRUE
	always_show_on_latechoices = TRUE
	same_job_respawn_delay = 0
	cmode_music = 'sound/music/cmode/towner/combat_towner.ogg'
	job_subclasses = list(
		/datum/advclass/barbersurgeon,
		/datum/advclass/blacksmith,
		/datum/advclass/cheesemaker,
		/datum/advclass/drunkard,
		/datum/advclass/fisher,
		/datum/advclass/homesteader,
		/datum/advclass/hunter,
		/datum/advclass/hunter/spear,
		/datum/advclass/miner,
		/datum/advclass/minstrel,
		/datum/advclass/peasant,
		/datum/advclass/potter,
		/datum/advclass/seamstress,
		/datum/advclass/thug/goon,
		/datum/advclass/thug/wiseguy,
		/datum/advclass/thug/bigman,
		/datum/advclass/levy,
		/datum/advclass/witch,
		/datum/advclass/woodworker
	)
	default_subprefs = list("favorite_advclass" = null, "witch_type" = null, "witch_form" = null)

// towners are so many roles in a trenchcoat that we're going to _only_ render the prefs relevant to the selected advclass
/datum/job/roguetown/villager/update_subprefs_window(mob/user)
	if(!advclass_cat_rolls)
		return
	var/client/C = usr.client
	if(!C || !C.prefs)
		return
	var/list/roleprefs = get_roleprefs(C)
	var/datum/advclass/favorite = roleprefs["favorite_advclass"]
	var/favorite_name = favorite ? favorite::name : "Choose"
	var/HTML = {"
		<i>You can choose a favorite subclass here. You'll automatically select this subclass on roundstart if possible.</i><br/><br/>
		<b>Selected class:</b> <a href="?src=[REF(src)];class=1">[favorite_name]</a>"}
	if(favorite == /datum/advclass/witch)
		HTML += {"<br/><b>Witch Type:</b> <a href="?src=[REF(src)];witch_type=1">[roleprefs["witch_type"] || "Select"]</a>"}
		HTML += {"<br/><b>Second Form:</b> <a href="?src=[REF(src)];witch_form=1">[roleprefs["witch_form"] || "Select"]</a>"}
	HTML += {"
		<center><a href="?src=[REF(src)];subprefsexit=1">EXIT</a>\t\t<a href="?src=[REF(src)];subprefsreset=1">RESET</a></center>
	"}
	// the fact that the window width/height will be different each time is the main reason this isn't all done in a parent proc on /datum/job
	var/datum/browser/popup = new(user, "[JOB_SUBPREFS_WINDOW_ID]", "<div align='center'>[title] Preferences</div>", 500, 400)
	popup.set_content(HTML)
	popup.open(FALSE)
	if(winexists(usr, "[JOB_SUBPREFS_WINDOW_ID]"))
		winset(usr, "[JOB_SUBPREFS_WINDOW_ID]", "focus=true")

/datum/job/roguetown/villager/Topic(href, list/href_list)
	. = ..()
	var/list/prefs = get_roleprefs(usr.client)
	if(!prefs)
		return
	if(href_list["witch_type"])
		var/list/choices = list("Old Magick", "Godsblood", "Mystagogue")
		var/choice = tgui_input_list(usr, "How do your powers manifest?", "THE OLD WAYS", choices)
		if(choice)
			prefs["witch_type"] = choice
		update_subprefs_window(usr)
	if(href_list["witch_form"])
		var/list/choices = list("Zad", "Cat", "Cat (Black)", "Bat", "Lesser Volf", "Cabbit", "Small Rous", "Lesser Venard")
		var/choice = tgui_input_list(usr, "What form does your second skin take?", "THE OLD WAYS", choices)
		if(choice)
			prefs["witch_form"] = choice
		update_subprefs_window(usr)

