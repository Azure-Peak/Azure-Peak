#define BROWSER_STAT_PANEL_CONTROL "statwindow.stat"
#define BROWSER_STAT_PANEL_TURF_TAB "TURF"
#define BROWSER_STAT_PANEL_REFRESH_INTERVAL 200
#define BROWSER_STAT_PANEL_FAST_REFRESH_INTERVAL 50
#define BROWSER_STAT_PANEL_TABS_INTERVAL 100
#define BROWSER_STAT_PANEL_LARGE_ROUNDINFO_LABEL(label) ((label) == "MAP" || (label) == "ROUND ID" || (label) == "ROUND TIME" || (label) == "ROUND TrueTime")

/client/proc/refresh_browserpanel(force = FALSE, update_tabs)
	// Cheap bail-out checks first - avoid winexists() IPC and markup work on the common path.
	if(!force && browserpanel_init && browserpanel_tabshtml)
		if(world.time < browserpanel_nextrefresh)
			return
		if(!browserpanel_autorefresh())
			return

	if(winexists(src, BROWSER_STAT_PANEL_CONTROL) != "BROWSER")
		browserpanel_init = FALSE
		browserpanel_tabshtml = null
		browserpanel_contenthtml = null
		return
	// Validate listed-turf adjacency up front: browserpanel_noturf() clears tabshtml so the
	// decision below rebuilds tabs (drops the TURF tab) in the same refresh.
	if(mob?.listed_turf && !mob.TurfAdjacent(mob.listed_turf))
		browserpanel_noturf()
	if(isnull(update_tabs))
		update_tabs = force || !browserpanel_tabshtml || world.time >= browserpanel_nexttabs
	else if(!browserpanel_tabshtml)
		update_tabs = TRUE
	var/list/panel_markup = build_browserpanel_markup(update_tabs)
	var/tabs_markup = panel_markup["tabs"]
	var/content_markup = panel_markup["content"]
	var/force_current = browserpanel_forcetab
	browserpanel_forcetab = FALSE
	if(!browserpanel_init)
		browserpanel_tabshtml = tabs_markup
		browserpanel_contenthtml = content_markup
		src << browse_rsc('interface/fonts/chiseld.ttf', "chiseld.ttf")
		var/list/init_precache = browserpanel_precache(panel_markup["tabs_list"], panel_markup["verb_categories"], panel_markup["turf"])
		src << browse(build_browserpanel_shell(tabs_markup, content_markup, init_precache), "window=[BROWSER_STAT_PANEL_CONTROL]")
		browserpanel_init = TRUE
		browserpanel_nextrefresh = world.time + browserpanel_refresh_interval()
		return
	if(!isnull(tabs_markup) && browserpanel_tabshtml != tabs_markup)
		browserpanel_tabshtml = tabs_markup
		send_byjax(src, BROWSER_STAT_PANEL_CONTROL, "browser-stat-tabs", tabs_markup, "browserStatClearContentCache")
		var/list/updated_precache = browserpanel_precache(panel_markup["tabs_list"], panel_markup["verb_categories"], panel_markup["turf"])
		browserpanel_sendcache(updated_precache)
	if(browserpanel_contenthtml != content_markup || force_current)
		browserpanel_contenthtml = content_markup
		var/callback = force_current ? "browserStatReceiveCurrent" : "browserStatReceiveContent"
		send_byjax(src, BROWSER_STAT_PANEL_CONTROL, "browser-stat-cachefill", content_markup, callback, list(browserpanel_tab))
	browserpanel_nextrefresh = world.time + browserpanel_refresh_interval()

/client/proc/browserpanel_refresh_interval()
	if(browserpanel_tab == "RoundInfo" || browserpanel_tab == "MC" || browserpanel_tab == "SDQL2")
		return BROWSER_STAT_PANEL_FAST_REFRESH_INTERVAL
	return BROWSER_STAT_PANEL_REFRESH_INTERVAL

/client/proc/browserpanel_mapfocus()
	winset(src, "mapwindow", "focus=true")

/client/proc/browserpanel_chatverb(command)
	switch(uppertext("[command]"))
		if("ASAY", "OOC", "SAY", "IC", "LOOC", "DSAY")
			return TRUE
	return FALSE

/client/proc/browserpanel_autorefresh()
	if(browserpanel_tab == "RoundInfo" || browserpanel_tab == "MC" || browserpanel_tab == "Tickets" || browserpanel_tab == "SDQL2")
		return TRUE
	return FALSE

/client/proc/handle_browserpanel_action(list/href_list)
	var/action = href_list["browser_stat_panel"]
	if(action == "tab")
		var/requested_tab = href_list["tab"]
		if(requested_tab)
			browserpanel_tab = requested_tab
			browserpanel_forcetab = TRUE
		refresh_browserpanel(TRUE, FALSE)
		browserpanel_mapfocus()
		return

	if(action == "tab_state")
		var/requested_tab = href_list["tab"]
		if(requested_tab)
			browserpanel_tab = requested_tab
		browserpanel_mapfocus()
		return

	if(action == "verb")
		var/command = href_list["command"]
		if(command)
			winset(src, null, list2params(list("command" = command)))
		reset_browserpanelcache()
		if(!browserpanel_chatverb(command))
			browserpanel_mapfocus()
		return

	if(action == "game_prefs")
		if(prefs && mob)
			prefs.current_tab = 1
			prefs.ShowChoices(mob, 4)
		return

	if(action == "stat")
		browserpanel_stathelp(href_list["stat"])
		browserpanel_mapfocus()
		return

	if(action == "spell")
		var/obj/effect/proc_holder/spell/spell = locate(href_list["spell"])
		browserpanel_spellclick(spell)
		refresh_browserpanel(TRUE, FALSE)
		browserpanel_mapfocus()
		return

	if(action == "turf_atom")
		var/atom/target = locate(href_list["target"])
		browserpanel_turfclick(target, href_list["button"])
		browserpanel_mapfocus()
		return

	if(action == "turf_drag")
		var/atom/target = locate(href_list["target"])
		browserpanel_arm_drag(target, href_list["button"])
		return

	if(action == "turf_drop_entry")
		var/atom/src_atom = locate(href_list["source"])
		var/atom/dest_atom = locate(href_list["target"])
		browserpanel_perform_drop(src_atom, dest_atom, href_list["button"])
		browserpanel_mapfocus()
		return

	if(action == "turf_drag_cancel")
		clear_browserpanel_drag()
		return

	if(action == "turf_examine")
		var/atom/target = locate(href_list["target"])
		browserpanel_turfexamine(target)
		browserpanel_mapfocus()
		return

	if(action == "turf_path")
		var/atom/target = locate(href_list["target"])
		browserpanel_turfpath(target)
		browserpanel_mapfocus()
		return

	if(action == "focus_map")
		browserpanel_mapfocus()
		return

	if(!(holder && check_rights_for(src, R_DEBUG)))
		return

	if(action == "ticket")
		var/datum/admin_help/ticket = locate(href_list["ticket"])
		if(istype(ticket))
			ticket.TicketPanel()
		refresh_browserpanel(TRUE)
		return

	if(action == "ticket_list")
		var/state_name = href_list["state"]
		if(state_name == "active")
			GLOB.ahelp_tickets.BrowseTickets(AHELP_ACTIVE)
		else if(state_name == "closed")
			GLOB.ahelp_tickets.BrowseTickets(AHELP_CLOSED)
		else if(state_name == "resolved")
			GLOB.ahelp_tickets.BrowseTickets(AHELP_RESOLVED)
		refresh_browserpanel(TRUE)
		return

	if(action == "sdql2")
		var/datum/SDQL2_query/query = locate(href_list["query"])
		if(!istype(query) || !(query in GLOB.sdql2_queries) || !query.allow_admin_interact)
			return
		var/query_action = href_list["query_action"]
		if(query_action == "delete")
			query.admin_del(mob)
		else if(query_action == "halt")
			query.admin_halt(mob)
		else if(query_action == "run")
			query.admin_run(mob)
		refresh_browserpanel(TRUE)

/client/proc/reset_browserpanelcache()
	browserpanel_cachedverbs = null
	browserpanel_cachestamp = null
	browserpanel_renderedverbs = null
	browserpanel_renderstamp = null

/// Call after mutating a client's verb list so the browser panel re-derives categories and re-renders.
/client/proc/update_browserpanel()
	reset_browserpanelcache()
	refresh_browserpanel(TRUE)

/client/proc/browserpanel_cachestamp()
	var/base_stamp = "[length(verbs)]|[REF(holder)]|[holder?.rank?.name || "null"]|[REF(mob)]"
	if(!mob)
		return base_stamp
	base_stamp += "|[length(mob.verbs)]|[length(mob.contents)]|[browserpanel_spellstamp(mob.mob_spell_list)]|[mob.mind ? browserpanel_spellstamp(mob.mind.spell_list) : "null"]|[browserpanel_wildtongue()]|[istype(get_turf(mob), /turf/open/water/transparent)]"
	var/contentverbs = 0
	for(var/atom/movable/thing as anything in mob.contents)
		contentverbs += length(thing.verbs)
	base_stamp += "|[contentverbs]"
	return base_stamp

/client/proc/browserpanel_spellstamp(list/spells)
	if(!length(spells))
		return null
	var/list/stamp = list()
	for(var/obj/effect/proc_holder/spell/spell as anything in spells)
		if(!istype(spell))
			continue
		stamp += "[REF(spell)]:[spell.panel]:[spell.name]"
	return stamp.Join("|")

/client/proc/get_browserpanelverbs()
	var/current_stamp = browserpanel_cachestamp()
	if(browserpanel_cachedverbs && browserpanel_cachestamp == current_stamp)
		return browserpanel_cachedverbs
	browserpanel_renderedverbs = null
	browserpanel_renderstamp = null
	browserpanel_cachedverbs = collect_browserpanelverbs()
	browserpanel_cachestamp = current_stamp
	return browserpanel_cachedverbs

/// TRUE when the named tab's content rendering needs the verb-category cache.
/// Built-in tabs render from dedicated procs and don't touch `verb_categories`.
/client/proc/browserpanel_needs_verbs(tab_name, turf/current_turf)
	if(tab_name == "RoundInfo" || tab_name == "Stats" || tab_name == "MC" || tab_name == "Tickets" || tab_name == "SDQL2")
		return FALSE
	if(tab_name == BROWSER_STAT_PANEL_TURF_TAB && current_turf)
		return FALSE
	return TRUE

/client/proc/build_browserpanel_markup(update_tabs = TRUE)
	var/list/verb_categories
	var/turf/current_turf = browserpanel_turf()
	var/tabs_markup
	var/list/tabs_built
	if(update_tabs)
		verb_categories = get_browserpanelverbs()
		var/has_living = istype(mob, /mob/living)
		var/has_debug = holder && check_rights_for(src, R_DEBUG)
		var/has_sdql2 = has_debug && length(GLOB.sdql2_queries) > 0
		var/current_tabs_stamp = "[browserpanel_cachestamp]|[browserpanel_tab]|[!!current_turf]|[has_living]|[has_debug]|[has_sdql2]"
		if(browserpanel_tabshtml && browserpanel_tabsstamp == current_tabs_stamp)
			browserpanel_nexttabs = world.time + BROWSER_STAT_PANEL_TABS_INTERVAL
		else
			var/list/tabs = list("RoundInfo")
			if(has_living)
				tabs += "Stats"
			if(has_debug)
				tabs += "MC"
				tabs += "Tickets"
				if(has_sdql2)
					tabs += "SDQL2"
			if(current_turf)
				tabs += BROWSER_STAT_PANEL_TURF_TAB
			var/list/sorted_categories = list()
			for(var/category in verb_categories)
				sorted_categories += category
			sorted_categories = sortList(sorted_categories)
			for(var/category in sorted_categories)
				tabs += category

			if(!(browserpanel_tab in tabs))
				browserpanel_tab = "RoundInfo"
				browserpanel_forcetab = TRUE

			var/list/tab_markup = list()
			for(var/tab_name in tabs)
				var/tab_class = tab_name == browserpanel_tab ? "tab active" : "tab"
				var/display_name = tab_name == "RoundInfo" ? "ROUND INFO" : uppertext("[tab_name]")
				var/cache_tab = "1"
				tab_markup += "<a class='[tab_class]' data-tab='[html_encode(tab_name)]' data-cache-tab='[cache_tab]' href='byond://?src=[REF(src)];browser_stat_panel=tab;tab=[url_encode(tab_name)]' onclick='return browserStatSelectTab(this)'><span class='tab-label'>[html_encode(display_name)]</span></a>"
			tabs_markup = tab_markup.Join("")
			tabs_built = tabs
			browserpanel_nexttabs = world.time + BROWSER_STAT_PANEL_TABS_INTERVAL
			browserpanel_tabsstamp = current_tabs_stamp

	// Only build the verb category cache (which iterates mob.contents) if the active
	// tab's content actually needs it — TURF/Stats/RoundInfo/MC/Tickets/SDQL2 don't.
	if(!verb_categories && browserpanel_needs_verbs(browserpanel_tab, current_turf))
		verb_categories = get_browserpanelverbs()
	var/content_markup = browserpanel_tabcontent(browserpanel_tab, verb_categories, current_turf)
	return list(
		"tabs" = tabs_markup,
		"content" = content_markup,
		"tabs_list" = tabs_built,
		"verb_categories" = verb_categories,
		"turf" = current_turf,
	)

/client/proc/browserpanel_tabcontent(tab_name, list/verb_categories, turf/current_turf)
	if(tab_name == "RoundInfo")
		return browserpanel_roundinfo()
	if(tab_name == "Stats")
		return browserpanel_stats()
	if(tab_name == "MC")
		return browserpanel_mcinfo()
	if(tab_name == "Tickets")
		return browserpanel_tickets()
	if(tab_name == "SDQL2")
		return browserpanel_sdql2()
	if(current_turf && tab_name == BROWSER_STAT_PANEL_TURF_TAB)
		return browserpanel_turfcontents(current_turf)
	return browserpanel_cached_verbs(tab_name, verb_categories[tab_name])

/client/proc/browserpanel_precache(list/tabs, list/verb_categories, turf/current_turf)
	if(!length(tabs))
		return list()
	var/list/precache = list()
	for(var/tab_name in tabs)
		precache[tab_name] = browserpanel_tabcontent(tab_name, verb_categories, current_turf)
	return precache

/client/proc/browserpanel_sendcache(list/precache_markup)
	if(!length(precache_markup))
		return
	for(var/tab_name in precache_markup)
		send_byjax(src, BROWSER_STAT_PANEL_CONTROL, "browser-stat-cachefill", precache_markup[tab_name], "browserStatReceiveContent", list(tab_name))


/client/proc/build_browserpanel_shell(tabs_markup, content_markup, list/precache_markup)
	var/list/page = list()
	var/open_bracket = ascii2text(91)
	var/close_bracket = ascii2text(93)
	page += "<html><head><meta charset='utf-8'>"
	page += "<style>"
	page += "@font-face{font-family:'BrowserStatGothic';src:url('/chiseld.ttf'),url('chiseld.ttf');font-style:normal;font-weight:bold;}"
	page += "html,body{margin:0;padding:0;background:#000;color:#fff;font-family:'Book Antiqua','Palatino Linotype',Georgia,serif;font-weight:normal;overflow:hidden;}"
	page += ".panel{display:flex;flex-direction:column;height:100%;background:#000;}"
	page += ".tabs{display:grid;grid-template-columns:repeat(auto-fit,minmax(110px,1fr));gap:4px;padding:8px 8px 6px;border-bottom:1px solid #353535;background:linear-gradient(180deg,#080808 0%,#020202 55%,#000 100%);box-shadow:inset 0 -8px 18px rgba(0,0,0,0.45);}"
	page += ".tab{display:block;width:100%;padding:4px 9px 3px;border-width:1px;border-style:solid;border-color:#777 #2a2a2a #111 #5d5d5d;border-radius:0;background:linear-gradient(180deg,#181818 0%,#0f0f0f 52%,#050505 100%);box-shadow:inset 0 1px 0 rgba(255,255,255,0.09),inset 0 -1px 0 rgba(0,0,0,0.88),0 1px 2px rgba(0,0,0,0.45);color:#efefef;text-decoration:none;line-height:1;white-space:nowrap;text-shadow:0 1px 0 #000,0 0 5px rgba(0,0,0,0.35);font-family:'BrowserStatGothic','Copperplate Gothic Bold',sans-serif !important;font-size:15px !important;font-weight:normal !important;letter-spacing:0.05em;}"
	page += ".tab-label{font-family:'BrowserStatGothic','Copperplate Gothic Bold',sans-serif !important;font-size:15px !important;font-weight:normal !important;display:inline-block;transform:translateY(0.5px);}"
	page += ".tab.active{background:linear-gradient(180deg,#dedede 0%,#a8a8a8 52%,#6e6e6e 100%);border-color:#f2f2f2 #595959 #222 #c6c6c6;color:#080808;box-shadow:inset 0 1px 0 rgba(255,255,255,0.45),inset 0 -1px 0 rgba(0,0,0,0.35),0 1px 3px rgba(0,0,0,0.45);text-shadow:none;}"
	page += ".content{flex:1;overflow:auto;padding:8px;background:#000;}"
	page += ".line{padding:2px 0;border-bottom:1px solid rgba(255,255,255,0.08);font-size:13px;color:#fff;line-height:1.2;}"
	page += ".round-break{height:5px;margin:4px 0 5px;border-top:1px solid rgba(255,255,255,0.32);border-bottom:1px solid rgba(0,0,0,0.75);}"
	page += ".round-label{font-weight:bold;color:#f2f2f2;font-size:15px;letter-spacing:0.02em;}"
	page += ".section-title{margin:0 0 8px;color:#fff;font:18px 'Book Antiqua','Palatino Linotype',Georgia,serif;letter-spacing:0.03em;}"
	page += ".stat-label{font-weight:bold;color:#f2f2f2;font-size:15px;letter-spacing:0.02em;}"
	page += ".stat-help{text-decoration:none;cursor:pointer;}"
	page += ".stat-help:hover{text-decoration:underline;}"
	page += ".stat-label-str{color:#b18484;}"
	page += ".stat-label-spd{color:#d6c36b;}"
	page += ".stat-label-int{color:#81adc8;}"
	page += ".stat-label-con{color:#d6858b;}"
	page += ".stat-label-wil{color:#aa83b9;}"
	page += ".stat-label-for{color:#819e82;}"
	page += ".stat-label-per{color:#c0ba8d;}"
	page += ".stat-label-vitae{color:#8f1f1f;}"
	page += ".stat-value{font-weight:normal;color:#f2f2f2;}"
	page += ".patron-white{color:#f2f2f2;}"
	page += ".patron-red{color:#b18484;}"
	page += ".patron-blue{color:#81adc8;}"
	page += ".load-white{color:#f2f2f2;}"
	page += ".load-yellow{color:#d6c36b;}"
	page += ".load-red{color:#d97575;}"
	page += ".tod-night{color:#f2f2f2;}"
	page += ".tod-dawn{color:#e8dfa5;}"
	page += ".tod-day{color:#f0d24a;}"
	page += ".tod-dusk{color:#9dbfe8;}"
	page += ".subsection{margin:12px 0 6px;color:#fff;font-size:14px;font-weight:bold;}"
	page += ".verb-search{width:100%;box-sizing:border-box;margin:0 0 8px;padding:5px 9px 4px;border-width:1px;border-style:solid;border-color:#777 #2a2a2a #111 #5d5d5d;border-radius:0;background:linear-gradient(180deg,#181818 0%,#0f0f0f 52%,#050505 100%);box-shadow:inset 0 1px 0 rgba(255,255,255,0.09),inset 0 -1px 0 rgba(0,0,0,0.88),0 1px 2px rgba(0,0,0,0.45);color:#efefef;font:15px 'Book Antiqua','Palatino Linotype',Georgia,serif;font-weight:normal;letter-spacing:0.05em;text-shadow:0 1px 0 #000,0 0 5px rgba(0,0,0,0.35);outline:none;}"
	page += ".verb-search::placeholder{color:#d5d5d5;opacity:1;}"
	page += ".verb-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(116px,1fr));gap:3px;}"
	page += ".verb{position:relative;display:block;padding:3px 6px 2px;border-width:1px;border-style:solid;border-color:#686868 #242424 #0d0d0d #4d4d4d;border-radius:0;background:linear-gradient(180deg,#171717 0%,#0d0d0d 55%,#030303 100%);box-shadow:inset 0 1px 0 rgba(255,255,255,0.07),inset 0 -1px 0 rgba(0,0,0,0.78);color:#efefef;text-decoration:none;font:13px 'Book Antiqua','Palatino Linotype',Georgia,serif;font-weight:normal;letter-spacing:0.03em;line-height:1;text-shadow:0 1px 0 #000,0 0 4px rgba(0,0,0,0.35);}"
	page += ".verb-text{display:block;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;}"
	page += ".verb:hover{z-index:20;}"
	page += ".verb:hover::after{content:attr(data-verb-label);position:absolute;left:50%;top:100%;margin-top:3px;transform:translateX(-50%);background:#111;color:#fff;padding:3px 7px;border:1px solid #777;white-space:nowrap;z-index:20;font:12px 'Book Antiqua','Palatino Linotype',Georgia,serif;letter-spacing:0.02em;text-shadow:none;pointer-events:none;box-shadow:0 2px 5px rgba(0,0,0,0.65);}"
	page += ".link{color:#fff;text-decoration:none;}"
	page += ".link.ss-low{color:#8ab6ea;}"
	page += ".link.ss-mid{color:#d6c36b;}"
	page += ".link.ss-high{color:#d97575;}"
	page += ".link.ss-offline{color:#f2f2f2;}"
	page += ".link:hover{color:#fff;text-decoration:underline;}"
	page += ".pill-row{display:flex;flex-wrap:wrap;gap:6px;margin:0 0 10px;}"
	page += ".pill{display:inline-block;padding:4px 9px 3px;border-width:1px;border-style:solid;border-color:#777 #2a2a2a #111 #5d5d5d;border-radius:0;background:linear-gradient(180deg,#181818 0%,#0f0f0f 52%,#050505 100%);box-shadow:inset 0 1px 0 rgba(255,255,255,0.09),inset 0 -1px 0 rgba(0,0,0,0.88),0 1px 2px rgba(0,0,0,0.45);color:#efefef;text-decoration:none;font:15px 'Book Antiqua','Palatino Linotype',Georgia,serif;font-weight:normal;letter-spacing:0.05em;line-height:1;text-shadow:0 1px 0 #000,0 0 5px rgba(0,0,0,0.35);}"
	page += ".entry{padding:6px 0;border-bottom:1px solid rgba(255,255,255,0.1);font-size:13px;color:#fff;}"
	page += ".entry.turf-entry{display:flex;align-items:center;gap:5px;min-height:24px;padding:2px 0;}"
	page += ".turf-icon{flex:0 0 24px;width:24px;height:24px;display:flex;align-items:center;justify-content:center;}"
	page += ".turf-icon .icon{max-width:24px;max-height:24px;image-rendering:pixelated;}"
	page += ".turf-icon-fallback{width:20px;height:20px;border:1px solid #555;background:#111;}"
	page += ".turf-info{min-width:0;line-height:1.05;}"
	page += ".turf-name{font-size:13px;}"
	page += ".meta{color:#d5d5d5;font-size:11px;line-height:1.05;}"
	page += ".tab:hover{background:linear-gradient(180deg,#242424 0%,#171717 52%,#090909 100%);border-color:#9a9a9a #3a3a3a #161616 #7a7a7a;color:#fff;}"
	page += ".tab.active:hover{background:linear-gradient(180deg,#dedede 0%,#a8a8a8 52%,#6e6e6e 100%);border-color:#f2f2f2 #595959 #222 #c6c6c6;color:#080808;}"
	page += ".verb:hover,.pill:hover,.verb-search:focus{background:linear-gradient(180deg,#242424 0%,#171717 52%,#090909 100%);border-color:#9a9a9a #3a3a3a #161616 #7a7a7a;color:#fff;}"
	page += ".empty{color:#d5d5d5;font-size:13px;}"
	page += "</style>"
	page += "<script>"
	page += js_byjax
	page += "var browserStatContentCache=[json_encode(precache_markup || list())];"
	page += "var browserStatCurrentTab=[json_encode(browserpanel_tab)];"
	page += "var browserStatSearchValues={};"
	page += "var browserStatFocusedSearch=null;"
	page += "function browserStatClearContentCache(){browserStatContentCache={};browserStatRememberContent(browserStatCurrentTab);}"
	page += "function browserStatRememberContent(tab){"
	page += "  browserStatCurrentTab=tab;"
	page += "  var content=document.getElementById('browser-stat-content');"
	page += "  if(content) browserStatContentCache" + open_bracket + "tab" + close_bracket + "=content.innerHTML;"
	page += "  browserStatRestoreSearch();"
	page += "}"
	page += "function browserStatReceiveContent(tab){"
	page += "  var cachefill=document.getElementById('browser-stat-cachefill');"
	page += "  if(!cachefill)return;"
	page += "  var content=cachefill.innerHTML;"
	page += "  browserStatContentCache" + open_bracket + "tab" + close_bracket + "=content;"
	page += "  if(browserStatCurrentTab==tab){var panel=document.getElementById('browser-stat-content');if(panel)panel.innerHTML=content;browserStatRestoreSearch();}"
	page += "}"
	page += "function browserStatReceiveCurrent(tab){"
	page += "  var cachefill=document.getElementById('browser-stat-cachefill');"
	page += "  if(!cachefill)return;"
	page += "  var content=cachefill.innerHTML;"
	page += "  browserStatContentCache" + open_bracket + "tab" + close_bracket + "=content;"
	page += "  browserStatCurrentTab=tab;"
	page += "  var tabs=document.getElementsByClassName('tab');"
	page += "  for(var i=0;i<tabs.length;i++){var item=tabs.item(i);item.className=(item.getAttribute('data-tab')==tab)?'tab active':'tab';}"
	page += "  var panel=document.getElementById('browser-stat-content');"
	page += "  if(panel)panel.innerHTML=content;"
	page += "  browserStatRestoreSearch();"
	page += "}"
	page += "function browserStatSearchKey(kind){return browserStatCurrentTab+'|'+kind;}"
	page += "function browserStatSaveSearch(input,kind){browserStatFocusedSearch=kind;browserStatSearchValues" + open_bracket + "browserStatSearchKey(kind)" + close_bracket + "=input.value||'';}"
	page += "function browserStatBlurSearch(kind){setTimeout(function(){var active=document.activeElement;if(active&&active.getAttribute&&active.getAttribute('data-browser-search')==kind)return;if(active==document.body)return;browserStatFocusedSearch=null;},0);}"
	page += "function browserStatSearchInput(kind){var inputs=document.getElementsByTagName('input');for(var i=0;i<inputs.length;i++){var input=inputs.item(i);if(input.getAttribute&&input.getAttribute('data-browser-search')==kind)return input;}return null;}"
	page += "function browserStatRestoreSearch(){if(!browserStatFocusedSearch)return;var kind=browserStatFocusedSearch;var input=browserStatSearchInput(kind);if(!input)return;var value=browserStatSearchValues" + open_bracket + "browserStatSearchKey(kind)" + close_bracket + ";if(typeof(value)!='undefined')input.value=value;if(kind=='verb')filterVerbButtons(input);input.focus();}"
	page += "function filterVerbButtons(input){"
	page += "  browserStatSaveSearch(input,'verb');"
	page += "  var query=(input.value||'').toLowerCase();"
	page += "  var verbs=document.getElementsByClassName('verb');"
	page += "  var visibleCount=0;"
	page += "  for(var i=0;i<verbs.length;i++){"
	page += "    var node=verbs.item(i);"
	page += "    var label=(node.getAttribute('data-verb-label')||'').toLowerCase();"
	page += "    var show=!query||label.indexOf(query)!==-1;"
	page += "    node.style.display=show?'block':'none';"
	page += "    if(show) visibleCount++;"
	page += "  }"
	page += "  var empty=document.getElementById('verb-search-empty');"
	page += "  if(empty) empty.style.display=visibleCount?'none':'block';"
	page += "}"
	page += "function browserStatCopyPath(path){"
	page += "  if(navigator.clipboard&&navigator.clipboard.writeText){navigator.clipboard.writeText(path);return true;}"
	page += "  var input=document.createElement('textarea');input.value=path;document.body.appendChild(input);input.select();document.execCommand('copy');document.body.removeChild(input);return true;"
	page += "}"
	page += "var browserStatTopicBase='byond://?src=[REF(src)]';"
	page += "var browserStatPressedNode=null;"
	page += "var browserStatPressedButton=null;"
	page += "var browserStatDragArmed=false;"
	page += "function browserStatBtnName(b){if(b===2)return 'right';if(b===1)return 'middle';return 'left';}"
	page += "function browserStatEntryAncestor(el){while(el){if(el.classList&&el.classList.contains('turf-entry'))return el;el=el.parentNode;}return null;}"
	page += "function browserStatEntryAt(x,y){return browserStatEntryAncestor(document.elementFromPoint(x,y));}"
	page += "function browserStatTurfDown(event,node){"
	page += "  if(!event)return true;"
	page += "  if(event.shiftKey){var examine=node.getAttribute('data-examine-href');if(examine)window.location=examine;if(event.preventDefault)event.preventDefault();return false;}"
	page += "  browserStatPressedNode=node;"
	page += "  browserStatPressedButton=event.button;"
	page += "  browserStatDragArmed=false;"
	page += "  if(event.preventDefault)event.preventDefault();"
	page += "  return false;"
	page += "}"
	page += "function browserStatTurfUp(event,node){"
	page += "  if(browserStatPressedNode){"
	page += "    if(browserStatDragArmed){"
	page += "      var srcWrap=browserStatEntryAncestor(browserStatPressedNode);"
	page += "      var destWrap=browserStatEntryAt(event.clientX,event.clientY);"
	page += "      if(destWrap && destWrap!=srcWrap){"
	page += "        var srcRef=srcWrap&&srcWrap.getAttribute('data-atom-ref');"
	page += "        var destRef=destWrap.getAttribute('data-atom-ref');"
	page += "        if(srcRef&&destRef){"
	page += "          window.location=browserStatTopicBase+';browser_stat_panel=turf_drop_entry;source='+encodeURIComponent(srcRef)+';target='+encodeURIComponent(destRef)+';button='+browserStatBtnName(browserStatPressedButton);"
	page += "        }"
	page += "      } else if(destWrap){"
	page += "        window.location=browserStatTopicBase+';browser_stat_panel=turf_drag_cancel';"
	page += "      }"
	page += "    } else if(browserStatPressedNode==node){"
	page += "      var href=null;"
	page += "      if(event.button===2)href=node.getAttribute('data-right-href');"
	page += "      else if(event.button===1)href=node.getAttribute('data-middle-href');"
	page += "      else if(event.button===0)href=node.getAttribute('data-left-href');"
	page += "      if(href)window.location=href;"
	page += "    }"
	page += "  }"
	page += "  browserStatPressedNode=null;"
	page += "  browserStatPressedButton=null;"
	page += "  browserStatDragArmed=false;"
	page += "  if(event.preventDefault)event.preventDefault();"
	page += "  return false;"
	page += "}"
	page += "function browserStatTurfLeave(event,node){"
	page += "  if(browserStatPressedNode==node && browserStatPressedButton!==null && !browserStatDragArmed){"
	page += "    var dragHref=node.getAttribute('data-drag-href');"
	page += "    if(dragHref){"
	page += "      window.location=dragHref+';button='+browserStatBtnName(browserStatPressedButton);"
	page += "      browserStatDragArmed=true;"
	page += "    }"
	page += "  }"
	page += "}"
	page += "function browserStatTurfContext(event){if(event&&event.preventDefault)event.preventDefault();return false;}"
	page += "function browserStatClicked(event){"
	page += "  var target=event.target;"
	page += "  if(target&&target.getAttribute&&target.getAttribute('data-browser-search'))return;"
	page += "  var node=target;"
	page += "  while(node){if(node.tagName=='A'||node.tagName=='INPUT'||node.tagName=='TEXTAREA'||node.tagName=='SELECT')return;node=node.parentNode;}"
	page += "  window.location='byond://?src=[REF(src)];browser_stat_panel=focus_map';"
	page += "}"
	page += "function browserStatSelectTab(node){"
	page += "  var tab=node.getAttribute('data-tab')||'';"
	page += "  var cacheAllowed=node.getAttribute('data-cache-tab')=='1';"
	page += "  var cached=browserStatContentCache" + open_bracket + "tab" + close_bracket + ";"
	page += "  if(!cacheAllowed||!cached)return true;"
	page += "  var tabs=document.getElementsByClassName('tab');"
	page += "  for(var i=0;i<tabs.length;i++){tabs.item(i).className='tab';}"
	page += "  node.className='tab active';"
	page += "  browserStatFocusedSearch=null;"
	page += "  browserStatCurrentTab=tab;"
	page += "  var content=document.getElementById('browser-stat-content');"
	page += "  if(content) content.innerHTML=cached;"
	page += "  setTimeout(function(){window.location='byond://?src=[REF(src)];browser_stat_panel=tab_state;tab='+encodeURIComponent(tab);},0);"
	page += "  return false;"
	page += "}"
	page += "</script></head><body onmousedown='browserStatClicked(event)'><div class='panel'>"
	page += "<div class='tabs' id='browser-stat-tabs'>[tabs_markup]</div>"
	page += "<div class='content' id='browser-stat-content'>[content_markup]</div>"
	page += "<div id='browser-stat-cachefill' style='display:none;'></div>"
	page += "<script>browserStatRememberContent([json_encode(browserpanel_tab)]);</script>"
	page += "</div></body></html>"
	return page.Join("")

/client/proc/browserpanel_roundinfo()
	var/datum/controller/subsystem/statpanel/SS = SSstatpanel
	var/list/lines = list()
	if(SS.base_roundinfo_text)
		for(var/line in SS.base_roundinfo_text)
			var/line_text = "[line]"
			var/label_end = findtext(line_text, ":")
			var/label = label_end ? copytext(line_text, 1, label_end) : null
			if(BROWSER_STAT_PANEL_LARGE_ROUNDINFO_LABEL(label))
				lines += browserpanel_roundline(label, copytext(line_text, label_end + 1))
				if(label == "ROUND TIME")
					lines += browserpanel_roundbreak()
			else
				lines += "<div class='line'>[line]</div>"
	if(holder)
		if(SS.debug_roundinfo_text)
			for(var/line in SS.debug_roundinfo_text)
				var/line_text = "[line]"
				var/label_end = findtext(line_text, ":")
				var/label = label_end ? copytext(line_text, 1, label_end) : null
				if(BROWSER_STAT_PANEL_LARGE_ROUNDINFO_LABEL(label))
					lines += browserpanel_roundline(label, copytext(line_text, label_end + 1))
				else
					lines += "<div class='line'>[line]</div>"
	if(SS.ic_date_text)
		lines += browserpanel_roundline("IC DATE", copytext(SS.ic_date_text, length("IC DATE:") + 1))
	if(SS.timeofday_text)
		lines += browserpanel_timeline(SS.timeofday_text)
		lines += browserpanel_roundbreak()
	lines += browserpanel_tdline()
	if(check_rights_for(src, R_ADMIN))
		if(SS.admin_roundinfo_text)
			for(var/line in SS.admin_roundinfo_text)
				lines += "<div class='line'>[line]</div>"
	return lines.Join("")

/client/proc/browserpanel_roundlabel(text)
	return "<span class='round-label'>[html_encode(text)]</span>"

/client/proc/browserpanel_roundline(label, value)
	return "<div class='line'>[browserpanel_roundlabel("[label]:")] [html_encode(trim("[value]"))]</div>"

/client/proc/browserpanel_roundbreak()
	return "<div class='round-break'></div>"

/client/proc/browserpanel_loadclass(percent)
	if(!isnum(percent))
		return "load-white"
	if(percent < 25)
		return "load-white"
	if(percent < 60)
		return "load-yellow"
	return "load-red"

/client/proc/browserpanel_loadspan(percent)
	var/rounded_percent = round(percent, 1)
	return "<span class='[browserpanel_loadclass(percent)]'>[rounded_percent]%</span>"

/client/proc/browserpanel_plainpct(percent)
	return "[round(percent, 1)]%"

/client/proc/browserpanel_tdline()
	return "<div class='line'>[browserpanel_roundlabel("TIME DILATION:")] [browserpanel_loadspan(SStime_track.time_dilation_current)] [browserpanel_roundlabel("AVG:")]([browserpanel_plainpct(SStime_track.time_dilation_avg_fast)], [browserpanel_plainpct(SStime_track.time_dilation_avg)], [browserpanel_plainpct(SStime_track.time_dilation_avg_slow)]) [browserpanel_roundlabel("MAPTICK:")] [browserpanel_loadspan(world.map_cpu)]</div>"

/client/proc/browserpanel_todclass()
	if(GLOB.tod == "dawn")
		return "tod-dawn"
	if(GLOB.tod == "day")
		return "tod-day"
	if(GLOB.tod == "dusk")
		return "tod-dusk"
	return "tod-night"

/client/proc/browserpanel_timeline(timeofday_text)
	var/tod_text = capitalize(GLOB.tod)
	if(!length(tod_text))
		return "<div class='line'>[html_encode("[timeofday_text]")]</div>"
	var/tod_html = html_encode(tod_text)
	var/time_html = html_encode("[timeofday_text]")
	var/colored_tod = "<span class='[browserpanel_todclass()]'>[tod_html]</span>"
	var/colored_time = replacetext(time_html, tod_html, colored_tod)
	return "<div class='line'>[browserpanel_roundlabel("TIME:")] [copytext(colored_time, length("TIME:") + 2)]</div>"

/client/proc/browserpanel_statsstamp(mob/living/living_mob)
	if(!istype(living_mob))
		return "none"
	var/vitae_part = "none"
	if(istype(living_mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/human_mob = living_mob
		if(human_mob.mind?.has_antag_datum(/datum/antagonist/vampire))
			vitae_part = "[human_mob.bloodpool]"
	return "[REF(living_mob)]|[living_mob.STASTR]|[living_mob.STAPER]|[living_mob.STAINT]|[living_mob.STACON]|[living_mob.STAWIL]|[living_mob.STASPD]|[living_mob.STALUC]|[living_mob.patron]|[vitae_part]"

/client/proc/browserpanel_stats()
	var/mob/living/living_mob = mob
	var/current_stamp = browserpanel_statsstamp(living_mob)
	if(browserpanel_statshtml && browserpanel_statsstamp == current_stamp)
		return browserpanel_statshtml

	var/list/lines = list()
	if(!istype(living_mob))
		lines += "<div class='empty'>Stats are only available while controlling a living mob.</div>"
		browserpanel_statshtml = lines.Join("")
		browserpanel_statsstamp = current_stamp
		return browserpanel_statshtml

	lines += browserpanel_statline("STR", living_mob.STASTR, "stat-label-str")
	lines += browserpanel_statline("PER", living_mob.STAPER, "stat-label-per")
	lines += browserpanel_statline("INT", living_mob.STAINT, "stat-label-int")
	lines += browserpanel_statline("CON", living_mob.STACON, "stat-label-con")
	lines += browserpanel_statline("WIL", living_mob.STAWIL, "stat-label-wil")
	lines += browserpanel_statline("SPD", living_mob.STASPD, "stat-label-spd")
	lines += browserpanel_statline("FOR", living_mob.STALUC, "stat-label-for")
	lines += browserpanel_patronline(living_mob.patron)

	if(istype(living_mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/human_mob = living_mob
		if(human_mob.mind)
			var/datum/antagonist/vampire/vampire_datum = human_mob.mind.has_antag_datum(/datum/antagonist/vampire)
			if(vampire_datum)
				lines += "<div class='line'><span class='stat-label stat-label-vitae'>VITAE:</span> <span class='stat-value'>[human_mob.bloodpool]</span></div>"

	browserpanel_statshtml = lines.Join("")
	browserpanel_statsstamp = current_stamp
	return browserpanel_statshtml

/client/proc/browserpanel_mcinfo()
	var/list/lines = list()
	if(!(holder && check_rights_for(src, R_DEBUG)))
		lines += "<div class='empty'>Debug access required.</div>"
		return lines.Join("")

	var/turf/location = mob ? get_turf(eye) : null
	if(location)
		lines += "<div class='line'>Location: [html_encode(COORD(location))]</div>"
	for(var/line in SSstatpanel.mc_info_text)
		lines += "<div class='line'>[html_encode("[line]")]</div>"
	lines += browserpanel_mclinkline("Globals", "Edit", GLOB)
	lines += browserpanel_mclinkline("[config.name]", "Edit", config)
	if(Master)
		lines += "<div class='line'><strong>Byond</strong>: [html_encode("(FPS:[world.fps]) (TickCount:[world.time/world.tick_lag]) (TickDrift:[round(Master.tickdrift,1)]([round((Master.tickdrift/(world.time/world.tick_lag))*100,0.1)]%))")]]</div>"
		lines += browserpanel_mclinkline("Master Controller", "(TickRate:[Master.processing]) (Iteration:[Master.iteration])", Master)
	else
		lines += "<div class='line'><strong>Master Controller</strong>: ERROR</div>"
	if(Failsafe)
		lines += browserpanel_mclinkline("Failsafe Controller", "Defcon: [Failsafe.defcon_pretty()] (Interval: [Failsafe.processing_interval] | Iteration: [Failsafe.master_iteration])", Failsafe)
	else
		lines += "<div class='line'><strong>Failsafe Controller</strong>: ERROR</div>"
	lines += "<div class='line'>&nbsp;</div>"
	for(var/entry in SSstatpanel.mc_cache)
		var/title = "[entry["title"]]"
		var/message = "[entry["msg"]]"
		var/datum/controller/subsystem/subsystem = entry["subsystem"]
		if(subsystem)
			lines += browserpanel_mclinkline(title, message, subsystem)
		else
			lines += "<div class='line'><strong>[html_encode(title)]</strong>: [html_encode(message)]</div>"
	return lines.Join("")

/client/proc/browserpanel_mclinkline(title, message, datum/target)
	if(!target)
		return "<div class='line'><strong>[html_encode(title)]</strong>: [html_encode(message)]</div>"
	var/link_class = browserpanel_mclinkclass(message)
	return "<div class='line'><strong>[html_encode(title)]</strong>: <a class='link [link_class]' href='?_src_=vars;[HrefToken(TRUE)];Vars=[REF(target)]'>[html_encode(message)]</a></div>"

/client/proc/browserpanel_statline(label, value, label_class = null)
	var/label_css = "stat-label"
	if(label_class)
		label_css += " [label_class]"
	return "<div class='line'><a class='[label_css] stat-help' href='byond://?src=[REF(src)];browser_stat_panel=stat;stat=[url_encode(label)]'>[html_encode(label)]:</a> <span class='stat-value'>\Roman [value]</span></div>"

/client/proc/browserpanel_stathelp(stat_key)
	var/stat_text = browserpanel_statdesc(stat_key)
	if(!stat_text)
		return
	to_chat(src, span_notice(stat_text))

/client/proc/browserpanel_statdesc(stat_key)
	switch(uppertext("[stat_key]"))
		if("STR")
			return "STR: improves melee force, grapples, breaking doors/objects, carrying and heavy work. It also helps draw or reload bows, crossbows, and slings faster."
		if("PER")
			return "PER: improves ranged accuracy, aim speed, trap spotting, tracking, hidden target detection, travel/inspection speed, and some spell identification or avoidance rolls."
		if("INT")
			return "INT: improves skill XP and learning gains from crafting, cooking, mining, swimming, climbing, and similar work. Also helps feinting, spell scaling/accuracy, knowledge rolls, and some NPC behavior."
		if("CON")
			return "CON: improves bodypart durability, poison resistance, wound and injury tolerance, endurance, trap delay time, and your ability to withstand force."
		if("WIL")
			return "WIL: helps resist pain, death spirals, grabs, pressure, poison, and alchemy mishaps. It also matters for some divine or magic struggles."
		if("SPD")
			return "SPD: reduces climbing, movement, and equip or unequip delays. It also helps dodge rolls and improves some quick or agile weapon attacks."
		if("FOR")
			return "FOR: affects luck-based outcomes, crits, dodges, combat swing odds, poison resistance luck, NPC reactions, boon chances, and random chance smoothing."
	return null

/client/proc/browserpanel_patronline(patron_value)
	var/patron_text = "[patron_value]"
	var/patron_class = browserpanel_patronclass(patron_text)
	return "<div class='line'><span class='stat-label'>PATRON:</span> <span class='stat-value [patron_class]'>[html_encode(patron_text)]</span></div>"

/client/proc/browserpanel_patronclass(patron_text)
	if(!istext(patron_text))
		return "patron-white"
	var/normalized_patron = lowertext(patron_text)
	if(normalized_patron == "psydon")
		return "patron-white"
	if(normalized_patron in list("baotha", "zizo", "matthios", "graggar"))
		return "patron-red"
	if(normalized_patron in list("pestra", "dendor", "astrata", "noc", "eora", "malum", "ravox", "abyssor", "necra", "xylix"))
		return "patron-blue"
	return "patron-white"

/client/proc/browserpanel_mclinkclass(message)
	if(!istext(message))
		return "ss-offline"
	if(findtext(message, "OFFLINE"))
		return "ss-offline"
	var/percent_index = findtext(message, "%")
	if(!percent_index)
		return "ss-offline"
	var/pipe_index = findlasttext(message, "|", percent_index)
	if(!pipe_index)
		return "ss-offline"
	var/usage_text = copytext(message, pipe_index + 1, percent_index)
	var/usage = text2num(usage_text)
	if(!isnum(usage))
		return "ss-offline"
	if(usage < 25)
		return "ss-low"
	if(usage < 60)
		return "ss-mid"
	return "ss-high"

/client/proc/browserpanel_verbs(category_name, list/category_verbs)
	var/list/content = list()
	if(!length(category_verbs))
		content += "<div class='empty'>No verbs are currently available in this category.</div>"
		return content.Join("")

	content += "<input class='verb-search' data-browser-search='verb' type='text' placeholder='Search verbs...' onfocus='browserStatSaveSearch(this,\"verb\")' onblur='browserStatBlurSearch(\"verb\")' oninput='filterVerbButtons(this)'>"
	content += "<div class='verb-grid'>"
	for(var/list/verb_entry in category_verbs)
		var/entry_href = verb_entry["href"]
		var/verb_label = verb_entry["label"]
		if(!entry_href)
			var/verb_command = verb_entry["command"]
			entry_href = "byond://?src=[REF(src)];browser_stat_panel=verb;command=[url_encode(verb_command)]"
		content += "<a class='verb' data-verb-label='[html_encode(verb_label)]' href='[entry_href]'><span class='verb-text'>[html_encode(verb_label)]</span></a>"
	content += "</div>"
	content += "<div class='empty' id='verb-search-empty' style='display:none;'>No verbs match that search.</div>"
	return content.Join("")

/client/proc/browserpanel_cached_verbs(category_name, list/category_verbs)
	if(browserpanel_renderstamp != browserpanel_cachestamp || !browserpanel_renderedverbs)
		browserpanel_renderedverbs = list()
		browserpanel_renderstamp = browserpanel_cachestamp
	var/cached_markup = browserpanel_renderedverbs[category_name]
	if(cached_markup)
		return cached_markup
	cached_markup = browserpanel_verbs(category_name, category_verbs)
	browserpanel_renderedverbs[category_name] = cached_markup
	return cached_markup

/client/proc/browserpanel_tickets()
	var/list/content = list()
	if(!(holder && check_rights_for(src, R_DEBUG)))
		content += "<div class='empty'>Debug access required.</div>"
		return content.Join("")

	var/num_disconnected = 0
	for(var/datum/admin_help/ticket as anything in GLOB.ahelp_tickets.active_tickets)
		if(!ticket.initiator)
			num_disconnected++

	content += "<div class='pill-row'>"
	content += "<a class='pill' href='byond://?src=[REF(src)];browser_stat_panel=ticket_list;state=active'>Active: [length(GLOB.ahelp_tickets.active_tickets)]</a>"
	if(num_disconnected)
		content += "<span class='pill'>Disconnected: [num_disconnected]</span>"
	content += "<a class='pill' href='byond://?src=[REF(src)];browser_stat_panel=ticket_list;state=closed'>Closed: [length(GLOB.ahelp_tickets.closed_tickets)]</a>"
	content += "<a class='pill' href='byond://?src=[REF(src)];browser_stat_panel=ticket_list;state=resolved'>Resolved: [length(GLOB.ahelp_tickets.resolved_tickets)]</a>"
	content += "</div>"

	if(!length(GLOB.ahelp_tickets.active_tickets))
		content += "<div class='empty'>No active tickets.</div>"
		return content.Join("")

	for(var/datum/admin_help/ticket as anything in GLOB.ahelp_tickets.active_tickets)
		if(!ticket.initiator)
			continue
		content += "<div class='entry'>"
		content += "<a class='link' href='byond://?src=[REF(src)];browser_stat_panel=ticket;ticket=[url_encode(REF(ticket))]'>#[ticket.id]. [html_encode(ticket.initiator_key_name)]</a>"
		content += "<div class='meta'>[html_encode(ticket.name)]</div>"
		content += "</div>"
	return content.Join("")

/client/proc/browserpanel_sdqlcount(count_or_list)
	if(islist(count_or_list))
		return length(count_or_list)
	if(isnull(count_or_list))
		return 0
	return count_or_list

/client/proc/browserpanel_sdql2()
	var/list/content = list()
	content += "<div class='section-title'>SDQL2</div>"
	if(!(holder && check_rights_for(src, R_DEBUG)))
		content += "<div class='empty'>Debug access required.</div>"
		return content.Join("")
	if(!length(GLOB.sdql2_queries))
		content += "<div class='empty'>No SDQL2 queries are active.</div>"
		return content.Join("")

	for(var/datum/SDQL2_query/query as anything in GLOB.sdql2_queries)
		if(!query.allow_admin_interact)
			continue
		var/query_state = query.text_state()
		var/is_running = query_state == "PRESEARCH" || query_state == "SEARCHING" || query_state == "EXECUTING" || query_state == "SWITCHING"
		var/query_action = is_running ? "halt" : "run"
		var/action_label = is_running ? "Halt" : "Run"
		content += "<div class='entry'>"
		content += "<div><strong>#[query.id]</strong> [html_encode(query_state)] | ALL/ELIG/FIN [browserpanel_sdqlcount(query.obj_count_all)]/[browserpanel_sdqlcount(query.obj_count_eligible)]/[browserpanel_sdqlcount(query.obj_count_finished)]</div>"
		content += "<div class='meta'>[html_encode(query.get_query_text())]</div>"
		content += "<div class='pill-row'>"
		content += "<a class='pill' href='byond://?src=[REF(src)];browser_stat_panel=sdql2;query=[url_encode(REF(query))];query_action=[query_action]'>[action_label]</a>"
		content += "<a class='pill' href='byond://?src=[REF(src)];browser_stat_panel=sdql2;query=[url_encode(REF(query))];query_action=delete'>Delete</a>"
		content += "</div>"
		content += "</div>"
	return content.Join("")

/client/proc/browserpanel_turf()
	if(!mob)
		browserpanel_noturf()
		return null
	var/turf/current_turf = mob.listed_turf
	if(!current_turf)
		browserpanel_noturf()
		return null
	if(!mob.TurfAdjacent(current_turf))
		browserpanel_noturf()
		return null
	return current_turf

/client/proc/browserpanel_noturf()
	set_turfpanel(null)
	if(browserpanel_tab == BROWSER_STAT_PANEL_TURF_TAB)
		browserpanel_tab = "RoundInfo"
		browserpanel_forcetab = TRUE
	browserpanel_tabshtml = null
	browserpanel_contenthtml = null

/client/proc/browserpanel_open_turf(turf/current_turf)
	if(!mob || !current_turf || !mob.TurfAdjacent(current_turf))
		return
	set_turfpanel(current_turf)
	browserpanel_tab = BROWSER_STAT_PANEL_TURF_TAB
	browserpanel_forcetab = TRUE
	refresh_browserpanel(TRUE)

/client/proc/browserpanel_showentry(category, label, command)
	if(!category || !istext(category))
		return FALSE
	if(category == "Ghost")
		return FALSE
	if(category == "WILDTONGUE" && !browserpanel_wildtongue())
		return FALSE
	if(category == "Swimming")
		if(!mob || !istype(get_turf(mob), /turf/open/water/transparent))
			return FALSE
	return TRUE

/client/proc/browserpanel_wildtongue()
	return iswildkin(mob) || ishalfkin(mob) || isdullahan(mob) || isaxian(mob) || istabaxi(mob) || islupian(mob) || isdracon(mob) || iskobold(mob) || islizard(mob) || isvermin(mob) || isvulp(mob) || ismoth(mob)

/client/proc/browserpanel_turfcontents(turf/current_turf)
	var/list/content = list()
	content += browserpanel_turfentry(current_turf, "Turf")

	var/list/overrides = list()
	for(var/image/override_image in images)
		if(override_image.loc && override_image.loc.loc == current_turf && override_image.override)
			overrides += override_image.loc

	var/list/visible_atoms = list()
	for(var/atom/thing in current_turf)
		if(browserpanel_turfvisible(thing, current_turf, overrides) && !(thing in visible_atoms))
			visible_atoms += thing
	for(var/mob/thing as anything in GLOB.mob_list)
		if(browserpanel_turfvisible(thing, current_turf, overrides) && !(thing in visible_atoms))
			visible_atoms += thing

	if(!length(visible_atoms))
		content += "<div class='empty'>No visible contents on this turf.</div>"
		return content.Join("")

	for(var/atom/thing as anything in visible_atoms)
		content += browserpanel_turfentry(thing)
	return content.Join("")

/client/proc/browserpanel_turfvisible(atom/thing, turf/current_turf, list/overrides)
	if(!thing || !mob || get_turf(thing) != current_turf)
		return FALSE
	if(!ismob(thing) && !thing.mouse_opacity)
		return FALSE
	if(thing.invisibility > mob.see_invisible)
		return FALSE
	if(length(overrides) && (thing in overrides) && !ismob(thing))
		return FALSE
	return TRUE

/client/proc/browserpanel_turficon(atom/thing)
	if(!thing.icon)
		return "<div class='turf-icon-fallback'></div>"
	var/icon_html = icon2base64html(thing)
	if(!icon_html && !ismob(thing))
		icon_html = icon2base64html(getFlatIcon(thing))
	return icon_html || "<div class='turf-icon-fallback'></div>"

/client/proc/browserpanel_turfentry(atom/thing, prefix)
	var/list/content = list()
	var/icon_html = browserpanel_turficon(thing)
	var/thing_ref = REF(thing)
	var/type_text = "[thing.type]"
	var/click_href = "byond://?src=[REF(src)];browser_stat_panel=turf_atom;target=[url_encode(thing_ref)]"
	var/right_href = "byond://?src=[REF(src)];browser_stat_panel=turf_atom;target=[url_encode(thing_ref)];button=right"
	var/middle_href = "byond://?src=[REF(src)];browser_stat_panel=turf_atom;target=[url_encode(thing_ref)];button=middle"
	var/examine_href = "byond://?src=[REF(src)];browser_stat_panel=turf_examine;target=[url_encode(thing_ref)]"
	var/drag_href = "byond://?src=[REF(src)];browser_stat_panel=turf_drag;target=[url_encode(thing_ref)]"
	var/admin_tools = holder && check_rights_for(src, R_ADMIN)
	var/search_label = admin_tools ? "[thing] [type_text] [prefix]" : "[thing] [prefix]"
	var/mob/target_mob = ismob(thing) ? thing : null
	content += "<div class='entry turf-entry' data-turf-label='[html_encode(search_label)]' data-atom-ref='[thing_ref]'>"
	content += "<div class='turf-icon'>[icon_html]</div>"
	content += "<div class='turf-info'>"
	if(prefix)
		content += "<div class='meta'>[html_encode(prefix)]</div>"
	content += "<div><a class='link turf-name' href='[click_href]' data-left-href='[click_href]' data-middle-href='[middle_href]' data-right-href='[right_href]' data-examine-href='[examine_href]' data-drag-href='[drag_href]' onmousedown='return browserStatTurfDown(event,this)' onmouseup='return browserStatTurfUp(event,this)' onmouseleave='browserStatTurfLeave(event,this)' onclick='return false' oncontextmenu='return browserStatTurfContext(event)'>[html_encode("[thing]")]</a></div>"
	if(admin_tools)
		var/list/admin_links = list()
		admin_links += "<a class='link' href='?_src_=vars;[HrefToken(TRUE)];Vars=[thing_ref]'>VV</a>"
		if(target_mob?.client)
			admin_links += "<a class='link' href='?_src_=holder;[HrefToken(TRUE)];adminplayeropts=[thing_ref]'>PP</a>"
		admin_links += "<a class='link' href='byond://?src=[REF(src)];browser_stat_panel=turf_path;target=[url_encode(thing_ref)]' onclick='browserStatCopyPath([json_encode(type_text)])'>PATH</a>"
		content += "<div class='meta'>[admin_links.Join(" | ")]</div>"
	content += "</div></div>"
	return content.Join("")

/client/proc/browserpanel_turfok(atom/target)
	if(!target || !mob)
		return FALSE
	var/turf/current_turf = browserpanel_turf()
	if(!current_turf)
		return FALSE
	if(get_turf(target) != current_turf)
		return FALSE
	if(target == current_turf)
		return TRUE
	for(var/image/override_image in images)
		if(!ismob(target) && override_image.loc == target && override_image.override)
			return FALSE
	return browserpanel_turfvisible(target, current_turf, null)

/client/proc/browserpanel_turfpath(atom/target)
	if(!(holder && check_rights_for(src, R_ADMIN)))
		return
	if(!browserpanel_turfok(target))
		return
	to_chat(src, span_notice("Copied path to clipboard: [target.type]"))

/client/proc/browserpanel_turfexamine(atom/target)
	if(!browserpanel_turfok(target))
		return
	mob.examinate(target)

/client/proc/browserpanel_turfclick(atom/target, button = "left")
	if(!browserpanel_turfok(target))
		return
	switch(button)
		if("right")
			target.Click(null, null, "right=1")
		if("middle")
			target.Click(null, null, "middle=1")
		else
			target.Click(null, null, "left=1")

/**
 * Arms a drag-drop from a turf-panel entry. The browser JS calls this when the user
 * mouses down on an entry and drags the cursor off it; the next click on the map (or
 * mouseup over the map, whichever the BYOND skin delivers first) calls MouseDrop on
 * `target` against the clicked atom. Bails (and clears state) if `target` is no longer
 * a valid entry on the listed turf.
 */
/client/proc/browserpanel_arm_drag(atom/target, button)
	if(!target || !browserpanel_turfok(target))
		clear_browserpanel_drag()
		return
	browserpanel_dragatom = target
	browserpanel_dragbtn = button
	browserpanel_dragexp = world.time + 2 SECONDS

/// Clears the armed turf-panel drag (atom, button, and expiry).
/client/proc/clear_browserpanel_drag()
	browserpanel_dragatom = null
	browserpanel_dragbtn = null
	browserpanel_dragexp = 0

/**
 * Fires MouseDrop directly for a within-panel drop (one turf entry released over
 * another). Validates both atoms are still on the listed turf, clears any armed drag
 * (we don't need it — we have both refs from JS), and dispatches with the right
 * button modifier. Called from the `turf_drop_entry` topic action.
 */
/client/proc/browserpanel_perform_drop(atom/src_atom, atom/dest_atom, button)
	if(!src_atom || !dest_atom || !mob)
		return
	if(!browserpanel_turfok(src_atom) || !browserpanel_turfok(dest_atom))
		return
	clear_browserpanel_drag()
	var/drop_params = ""
	if(button == "right")
		drop_params = "right=1"
	else if(button == "middle")
		drop_params = "middle=1"
	src_atom.MouseDrop(dest_atom, get_turf(src_atom), get_turf(dest_atom), null, "mapwindow.map", drop_params)

/**
 * Consumes an armed turf-panel drag against `over_atom`, firing MouseDrop on the held
 * source atom with the appropriate button modifier (left/right/middle). Returns TRUE
 * if a drag was consumed (caller should skip its normal click handling), FALSE
 * otherwise. Bails on expired arms, missing/screen-object targets, or no mob.
 * Called from `/client/MouseDown` and `/client/MouseUp`.
 */
/client/proc/browserpanel_consume_drag(atom/over_atom, location, control, params)
	if(!browserpanel_dragatom)
		return FALSE
	if(world.time > browserpanel_dragexp)
		clear_browserpanel_drag()
		return FALSE
	if(!over_atom || !mob || istype(over_atom, /atom/movable/screen))
		return FALSE
	var/atom/src_atom = browserpanel_dragatom
	var/button = browserpanel_dragbtn
	clear_browserpanel_drag()
	var/drop_params = params
	if(button == "right")
		drop_params = "right=1"
	else if(button == "middle")
		drop_params = "middle=1"
	src_atom.MouseDrop(over_atom, get_turf(src_atom), get_turf(over_atom), null, control, drop_params)
	return TRUE

/**
 * Sets the client's mob.listed_turf, keeping `turf.panel_listeners` membership and
 * the `COMSIG_MOVABLE_MOVED` subscription on the mob in sync. Pass null to clear.
 * Idempotent: calling with the current turf still ensures listener registration, so
 * it's safe to invoke from `browserpanel_open_turf` even when `listed_turf` was
 * previously set out-of-band.
 */
/client/proc/set_turfpanel(turf/new_turf)
	if(!mob)
		return
	var/turf/old_turf = mob.listed_turf
	if(old_turf && old_turf != new_turf)
		LAZYREMOVE(old_turf.panel_listeners, src)
	mob.listed_turf = new_turf
	if(new_turf)
		LAZYADD(new_turf.panel_listeners, src)
		RegisterSignal(mob, COMSIG_MOVABLE_MOVED, PROC_REF(on_listed_move), TRUE)
	else if(old_turf)
		UnregisterSignal(mob, COMSIG_MOVABLE_MOVED)

/**
 * Signal handler for `COMSIG_MOVABLE_MOVED` on the client's mob while a turf panel is
 * open. Defers via `queue_browserpanel_refresh` (signal handlers must not sleep);
 * the refresh's adjacency check then closes the turf tab if the mob walked out of
 * range. Ignores stale firings from a previous mob (e.g., after possession swap)
 * whose signal hasn't been unregistered yet.
 */
/client/proc/on_listed_move(datum/source, atom/oldloc, dir, forced)
	SIGNAL_HANDLER
	if(source != mob)
		return
	queue_browserpanel_refresh()

/**
 * Queues a forced, content-only `refresh_browserpanel` for the next SStimer tick.
 * `TIMER_UNIQUE|TIMER_OVERRIDE` collapses multiple producers in the same tick into
 * a single refresh — important for batched events like a vendor spawning many items
 * onto a watched turf, or several stat changes from one spell effect.
 */
/client/proc/queue_browserpanel_refresh()
	addtimer(CALLBACK(src, PROC_REF(refresh_browserpanel), TRUE, FALSE), 0, TIMER_UNIQUE|TIMER_OVERRIDE)

/**
 * Reactive refresh entrypoint for the TURF tab. Called by
 * `/turf/proc/notify_browserpanel_listeners` when contents of the listed turf change.
 * No-op when the user isn't currently viewing the TURF tab, so producers can fire
 * this unconditionally.
 */
/client/proc/update_turfpanel()
	if(browserpanel_tab != BROWSER_STAT_PANEL_TURF_TAB)
		return
	queue_browserpanel_refresh()

/**
 * Reactive refresh entrypoint for the Stats tab. Called from stat-mutation sites:
 * `/mob/living/proc/change_stat`, `/mob/living/proc/set_patron`,
 * `/mob/living/proc/set_bloodpool`, `/mob/living/proc/adjust_bloodpool`. No-op when
 * the user isn't currently viewing the Stats tab.
 */
/client/proc/update_mobstatpanel()
	if(browserpanel_tab != "Stats")
		return
	queue_browserpanel_refresh()

/client/proc/browserpanel_spellclick(obj/effect/proc_holder/spell/spell)
	if(!spell || !mob)
		return
	if(!((spell in mob.mob_spell_list) || (mob.mind && (spell in mob.mind.spell_list))))
		return
	if(!spell.can_be_cast_by(mob))
		return
	spell.Click()

/client/proc/collect_browserpanelverbs()
	var/list/categorized = list()
	var/list/seen_commands = list()
	var/list/all_verbs = list()
	all_verbs += verbs
	if(mob)
		all_verbs += mob.verbs
		for(var/atom/movable/thing as anything in mob.contents)
			all_verbs += thing.verbs

	for(var/procpath/verbpath as anything in all_verbs)
		if(!verbpath)
			continue
		if(GLOB.browserpanel_hidden_verbs["[verbpath]"])
			continue

		var/category = verbpath.category
		if(!category || !istext(category))
			continue

		var/list/category_verbs = categorized[category]
		if(!category_verbs)
			category_verbs = list()
			categorized[category] = category_verbs

		var/command
		var/verb_label = "[verbpath.name]"
		if(copytext(verbpath.name, 1, 2) == "@")
			command = copytext(verbpath.name, 2)
		else
			command = replacetext(verbpath.name, " ", "-")
		if(!browserpanel_showentry(category, verb_label, command))
			continue

		var/command_key = "[category]|[command]"
		if(seen_commands[command_key])
			continue
		seen_commands[command_key] = TRUE

		category_verbs += list(list(
			"label" = verb_label,
			"command" = command,
		))

	browserpanel_addspells(categorized, seen_commands, mob?.mind?.spell_list)
	browserpanel_addspells(categorized, seen_commands, mob?.mob_spell_list)
	browserpanel_addprefs(categorized, seen_commands)
	for(var/category in categorized)
		categorized[category] = sortTim(categorized[category], GLOBAL_PROC_REF(cmp_browserpanel_label))

	return categorized

/client/proc/browserpanel_addprefs(list/categorized, list/seen_commands)
	if(!prefs || !browserpanel_showentry("Options", null, null))
		return
	var/list/options_verbs = categorized["Options"]
	if(!options_verbs)
		options_verbs = list()
		categorized["Options"] = options_verbs
	for(var/list/verb_entry in options_verbs)
		if(verb_entry["label"] == "Game Preferences")
			return
	var/command_key = "Options|game_prefs"
	if(seen_commands[command_key])
		return
	seen_commands[command_key] = TRUE
	options_verbs += list(list(
		"label" = "Game Preferences",
		"href" = "byond://?src=[REF(src)];browser_stat_panel=game_prefs",
	))

/proc/cmp_browserpanel_label(list/a, list/b)
	var/a_value = a["label"]
	var/b_value = b["label"]
	var/a_label = istext(a_value) ? a_value : "[a_value]"
	var/b_label = istext(b_value) ? b_value : "[b_value]"
	. = sorttext(lowertext(b_label), lowertext(a_label))
	if(!.)
		. = sorttext(b_label, a_label)

/client/proc/browserpanel_addspells(list/categorized, list/seen_commands, list/spells)
	if(!mob || !length(spells))
		return
	for(var/obj/effect/proc_holder/spell/spell as anything in spells)
		if(!istype(spell) || !spell.can_be_cast_by(mob))
			continue
		var/category = spell.panel
		if(!browserpanel_showentry(category, spell.name, null))
			continue
		var/list/category_verbs = categorized[category]
		if(!category_verbs)
			category_verbs = list()
			categorized[category] = category_verbs
		var/command_key = "[category]|spell|[REF(spell)]"
		if(seen_commands[command_key])
			continue
		seen_commands[command_key] = TRUE
		category_verbs += list(list(
			"label" = browserpanel_spelllabel(spell),
			"href" = "byond://?src=[REF(src)];browser_stat_panel=spell;spell=[url_encode(REF(spell))]",
		))

/client/proc/browserpanel_spelllabel(obj/effect/proc_holder/spell/spell)
	switch(spell.charge_type)
		if("recharge")
			return "[spell.name] ([round(spell.charge_counter / 10, 0.1)]/[round(spell.recharge_time / 10, 0.1)])"
		if("charges")
			return "[spell.name] ([spell.charge_counter]/[spell.recharge_time])"
		if("holdervar")
			return "[spell.name] ([spell.holder_var_type] [spell.holder_var_amount])"
	return "[spell.name]"

#undef BROWSER_STAT_PANEL_CONTROL
#undef BROWSER_STAT_PANEL_TURF_TAB
#undef BROWSER_STAT_PANEL_REFRESH_INTERVAL
#undef BROWSER_STAT_PANEL_FAST_REFRESH_INTERVAL
#undef BROWSER_STAT_PANEL_TABS_INTERVAL
#undef BROWSER_STAT_PANEL_LARGE_ROUNDINFO_LABEL
