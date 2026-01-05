//Please use mob or src (not usr) in these procs. This way they can be called in the same fashion as procs.
/client/verb/wiki(query as text)
	set name = "wiki"
	set desc = ""
	set category = "OOC"
	var/wikiurl = CONFIG_GET(string/wikiurl)
	if(wikiurl)
		if(query)
			var/output = wikiurl + "/index.php?title=Special%3ASearch&profile=default&search=" + query
			src << link(output)
		else if (query != null)
			src << link(wikiurl)
	else
		to_chat(src, span_danger("The wiki URL is not set in the server configuration."))
	return

/client/verb/discord()
	set name = "discord"
	set desc = ""
	set category = "OOC"
	set hidden = 1
	var/discordurl = CONFIG_GET(string/discordurl)
	if(discordurl)
		if(alert("This will open the discord. Are you sure?",,"Yes","No")!="Yes")
			return
		src << link(discordurl)
	else
		to_chat(src, span_danger("The forum URL is not set in the server configuration."))
	return

/client/verb/rules()
	set name = "rules"
	set desc = ""
	set category = "OOC"
	set hidden = 1
	var/rulesurl = CONFIG_GET(string/rulesurl)
	if(rulesurl)
		if(alert("This will open the rules in your browser. Are you sure?",,"Yes","No")!="Yes")
			return
		src << link(rulesurl)
	else
		to_chat(src, span_danger("The rules URL is not set in the server configuration."))
	return

/client/verb/github()
	set name = "github"
	set desc = ""
	set category = "OOC"
	set hidden = 1
	var/githuburl = CONFIG_GET(string/githuburl)
	if(githuburl)
		if(alert("This will open the Github repository in your browser. Are you sure?",,"Yes","No")!="Yes")
			return
		src << link(githuburl)
	else
		to_chat(src, span_danger("The Github URL is not set in the server configuration."))
	return

/client/verb/mentorhelp()
	set name = "Mentorhelp"
	set desc = ""
	set category = "-Admin-"
	if(mob)
		var/msg = input("Submit your question to the Voices:", "Mentorhelp Input") as text|null
		if(msg)
			mob.schizohelp(msg)
	else
		to_chat(src, span_danger("You can't currently use Mentorhelp in the main menu."))

/client/verb/reportissue()
	set name = "report-issue"
	set desc = ""
	set category = "OOC"
	var/githuburl = CONFIG_GET(string/githuburl)
	if(githuburl)
		var/message = "This will open the Github issue reporter in your browser. Are you sure?"
		if(GLOB.revdata.testmerge.len)
			message += "<br>The following experimental changes are active and are probably the cause of any new or sudden issues you may experience. If possible, please try to find a specific thread for your issue instead of posting to the general issue tracker:<br>"
			message += GLOB.revdata.GetTestMergeInfo(FALSE)
		if(tgalert(src, message, "Report Issue","Yes","No")!="Yes")
			return
		var/static/issue_template = file2text(".github/ISSUE_TEMPLATE.md")
		var/servername = CONFIG_GET(string/servername)
		var/url_params = "Reporting client version: [byond_version].[byond_build]\n\n[issue_template]"
		if(GLOB.round_id || servername)
			url_params = "Issue reported from [GLOB.round_id ? " Round ID: [GLOB.round_id][servername ? " ([servername])" : ""]" : servername]\n\n[url_params]"
		DIRECT_OUTPUT(src, link("[githuburl]/issues/new?body=[url_encode(url_params)]"))
	else
		to_chat(src, span_danger("The Github URL is not set in the server configuration."))
	return

/client/verb/changelog()
	set name = "Changelog"
	set category = "OOC"

	if(!GLOB.changelog_tgui)
		GLOB.changelog_tgui = new /datum/changelog()

	GLOB.changelog_tgui.ui_interact(mob)
	if(prefs.lastchangelog != GLOB.changelog_hash)
		prefs.lastchangelog = GLOB.changelog_hash
		prefs.save_preferences()
		winset(src, "infobuttons.changelog", "font-style=;")

/client/verb/hotkeys_help()
	set name = "_Help-Controls"
	set category = "OOC"
	mob.hotkey_help()


/mob/proc/hotkey_help()
	var/hotkey_mode = {"<font color='purple'>
Hotkey-Mode: (hotkey-mode must be on)
\tTAB = toggle hotkey-mode
\tw = north
\ta = west
\ts = south
\td = east
\tq = left hand
\te = right hand
\tr = throw
\tf = fixed eye (strafing mode)
\tSHIFT + f = look up
\tz = drop
\tx = cancel / resist grab
\tc = parry/dodge
\tv = stand up / lay down
\t1 thru 4 = change intent (current hand)
\tmouse wheel = change aim height
\tg = give
\t<B></B>h = bite
\tj = jump
\tk = kick
\tl = steal
\tt = say something
\tALT = sprint
\tCTRL + ALT = sneak
\tLMB = Use intent/Interact (Hold to channel)
\tRMB = Special Interaction
\tMMB = give/kick/jump/steal/spell
\tMMB (no intent) = Special Interaction
\tSHIFT + LMB = Examine something
\tSHIFT + RMB = Focus
\tALT + RMB = TileAtomList
\tCTRL + RMB = Point at something
</font>"}

	to_chat(src, hotkey_mode)

/client/verb/set_fixed()
	set name = "IconSize"
	set category = "Options"

	if(winget(src, "mapwindow.map", "icon-size") == "64")
		to_chat(src, "Stretch-to-fit... OK")
		winset(src, "mapwindow.map", "icon-size=0")
	else
		to_chat(src, "64x... OK")
		winset(src, "mapwindow.map", "icon-size=64")

/client/verb/set_stretch()
	set name = "IconScaling"
	set category = "Options"
	if(prefs)
		if(prefs.crt == TRUE)
			to_chat(src, "CRT mode is on.")
			winset(src, "mapwindow.map", "zoom-mode=blur")
			return
	if(winget(src, "mapwindow.map", "zoom-mode") == "normal")
		to_chat(src, "Pixel-perfect... OK")
		winset(src, "mapwindow.map", "zoom-mode=distort")
	else
		to_chat(src, "Anti-aliased... OK")
		winset(src, "mapwindow.map", "zoom-mode=normal")

/client/verb/crtmode()
	set category = "Options"
	set name = "ToggleCRT"
	if(!prefs)
		return
	if(prefs.crt == TRUE)
		winset(src, "mapwindow.map", "zoom-mode=normal")
		prefs.crt = FALSE
		prefs.save_preferences()
		to_chat(src, "CRT... OFF")
		for(var/atom/movable/screen/scannies/S in screen)
			S.alpha = 0
	else
		winset(src, "mapwindow.map", "zoom-mode=blur")
		prefs.crt = TRUE
		prefs.save_preferences()
		to_chat(src, "CRT... ON")
		for(var/atom/movable/screen/scannies/S in screen)
			S.alpha = 70

/client/verb/grainfilter()
	set category = "Options"
	set name = "ToggleGrain"
	if(!prefs)
		return
	if(prefs.grain == TRUE)
		prefs.grain = FALSE
		prefs.save_preferences()
		to_chat(src, "Grain is <font color='gray'>OFF.</font>")
		for(var/atom/movable/screen/grain/S in screen)
			S.alpha = 0
	else
		prefs.grain = TRUE
		prefs.save_preferences()
		to_chat(src, "Grain is <font color='#007fff'>ON.</font>")
		for(var/atom/movable/screen/grain/S in screen)
			S.alpha = 55

/client/verb/triggercommend()
	set category = "OOC"
	set name = "Commend Someone"
	commendsomeone()

/client/verb/roleplay_ad_view()
	set category = "OOC"
	set name = "Roleplay Ad (View)"
	view_roleplay_ads()

/client/verb/roleplay_ad_set()
	set category = "OOC"
	set name = "Roleplay Ad (Set)"
	if(mob)
		if(!ishuman(mob))
			return
		var/mob/living/carbon/human/C = mob
		var/has_old_ad = FALSE
		if(LAZYACCESS(GLOB.roleplay_ads,C.mobid))
			to_chat(C, span_info(LAZYACCESS(GLOB.roleplay_ads,C.mobid)))
			has_old_ad = TRUE
		var/msg = input("Set an advertisement for what kind of roleplay you are looking to engage in. Others will be able to see it with the Roleplay Ad (View) command. Do not abuse this. Leave empty and press OK to remove your roleplay ad.", "I LOVE TO ROLEPLAY") as message|null
		if(msg)
			LAZYSET(GLOB.roleplay_ads,C.mobid,"<b>[C.real_name]</b> - [msg]<BR>")
			to_chat(C, span_info("Roleplay ad set."))
			log_game("[C] has set their Roleplay Ad to '[msg]'.")
			for(var/client/advertisee in (GLOB.clients - src))
				if(!(advertisee.prefs.toggles & ROLEPLAY_ADS))
					continue
				to_chat(advertisee, span_info("[C.real_name] has set a roleplay ad."))
		else if(has_old_ad)
			LAZYREMOVE(GLOB.roleplay_ads,C.mobid)
			to_chat(C, span_info("Roleplay ad removed."))

/client/verb/changefps()
	set category = "Options"
	set name = "ChangeFPS"
	if(!prefs)
		return
	var/newfps = input(usr, "Enter new FPS", "New FPS", 100) as null|num
	if (!isnull(newfps))
		prefs.clientfps = clamp(newfps, 1, 1000)
		fps = prefs.clientfps
		prefs.save_preferences()

/client/verb/set_picinchat()
	set name = "Headshot in Chat"
	set category = "Options"

	if(prefs)
		prefs.chatheadshot = !prefs.chatheadshot
		prefs.save_preferences()
		if(prefs.chatheadshot)
			to_chat(src, "Headshot in chat Enabled")
		else
			to_chat(src, "Headshot in chat Disabled")

/*
/client/verb/set_blur()
	set name = "AAOn"
	set category = "Options"

	winset(src, "mapwindow.map", "zoom-mode=blur")

/client/verb/set_normal()
	set name = "AAOff"
	set category = "Options"

	winset(src, "mapwindow.map", "zoom-mode=normal")*/
