GLOBAL_LIST_EMPTY(exp_to_update)
GLOBAL_PROTECT(exp_to_update)


// Procs
/datum/job/proc/required_playtime_remaining(client/C)
	if(!C)
		return 0
	if(!CONFIG_GET(flag/use_exp_tracking))
		return 0
	if(!SSdbcore.Connect())
		return 0
	if(!exp_requirements || !exp_type)
		return 0
	if(!job_is_xp_locked(src.title))
		return 0
	if(CONFIG_GET(flag/use_exp_restrictions_admin_bypass) && check_rights_for(C,R_ADMIN))
		return 0
	var/isexempt = C.prefs.db_flags & DB_FLAG_EXEMPT
	if(isexempt)
		return 0
	var/my_exp = C.calc_exp_type(get_exp_req_type())
	var/job_requirement = get_exp_req_amount()
	if(my_exp >= job_requirement)
		return 0
	else
		return (job_requirement - my_exp)

/datum/job/proc/get_exp_req_amount()
	if(title in (GLOB.command_positions | list("AI")))
		var/uerhh = CONFIG_GET(number/use_exp_restrictions_heads_hours)
		if(uerhh)
			return uerhh * 60
	return exp_requirements

/datum/job/proc/get_exp_req_type()
	if(title in (GLOB.command_positions | list("AI")))
		if(CONFIG_GET(flag/use_exp_restrictions_heads_department) && exp_type_department)
			return exp_type_department
	return exp_type

/proc/job_is_xp_locked(jobtitle)
	if(!CONFIG_GET(flag/use_exp_restrictions_heads) && (jobtitle in GLOB.command_positions || jobtitle == "AI"))
		return FALSE
	if(!CONFIG_GET(flag/use_exp_restrictions_other) && !(jobtitle in GLOB.command_positions || jobtitle == "AI"))
		return FALSE
	return TRUE

/client/proc/calc_exp_type(exptype)
	var/list/typelist = GLOB.exp_jobsmap[exptype]
	if(!typelist)
		return -1
	var/amount = 0
	for(var/job in typelist["titles"])
		if(job in prefs.exp)
			amount += prefs.exp[job]
	return amount

/client/proc/get_exp_records()
	var/list/play_records = prefs.exp
	if(play_records.len)
		return play_records
	set_exp_from_db()
	return prefs.exp

/client/proc/get_exp_report()
	if(!CONFIG_GET(flag/use_exp_tracking))
		return "Tracking is disabled in the server configuration file."
	var/list/play_records = get_exp_records()
	if(!play_records.len)
		return "[key] has no records."
	var/return_text = list()
	return_text += "<UL>"
	var/list/exp_data = list()
	for(var/category in SSjob.name_occupations)
		if(play_records[category])
			exp_data[category] = text2num(play_records[category])
		else
			exp_data[category] = 0
	for(var/category in GLOB.exp_specialmap)
		if(category == EXP_TYPE_SPECIAL || category == EXP_TYPE_ANTAG)
			if(GLOB.exp_specialmap[category])
				for(var/innercat in GLOB.exp_specialmap[category])
					if(play_records[innercat])
						exp_data[innercat] = text2num(play_records[innercat])
					else
						exp_data[innercat] = 0
		else
			if(play_records[category])
				exp_data[category] = text2num(play_records[category])
			else
				exp_data[category] = 0
	if(prefs.db_flags & DB_FLAG_EXEMPT)
		return_text += "<LI>Exempt (all jobs auto-unlocked)</LI>"

	for(var/dep in exp_data)
		if(exp_data[dep] > 0)
			if(exp_data[EXP_TYPE_LIVING] > 0)
				var/percentage = num2text(round(exp_data[dep]/exp_data[EXP_TYPE_LIVING]*100))
				return_text += "<LI>[dep] [get_exp_format(exp_data[dep])] ([percentage]%)</LI>"
			else
				return_text += "<LI>[dep] [get_exp_format(exp_data[dep])] </LI>"
	if(CONFIG_GET(flag/use_exp_restrictions_admin_bypass) && check_rights_for(src,R_ADMIN))
		return_text += "<LI>Admin (all jobs auto-unlocked)</LI>"
	return_text += "</UL>"
	var/list/jobs_locked = list()
	var/list/jobs_unlocked = list()
	for(var/datum/job/job in SSjob.occupations)
		if(job.exp_requirements && job.exp_type)
			if(!job_is_xp_locked(job.title))
				continue
			else if(!job.required_playtime_remaining(mob.client))
				jobs_unlocked += job.title
			else
				var/xp_req = job.get_exp_req_amount()
				jobs_locked += "[job.title] [get_exp_format(text2num(calc_exp_type(job.get_exp_req_type())))] / [get_exp_format(xp_req)] as [job.get_exp_req_type()])"
	if(jobs_unlocked.len)
		return_text += "<BR><BR>Jobs Unlocked:<UL><LI>"
		return_text += jobs_unlocked.Join("</LI><LI>")
		return_text += "</LI></UL>"
	if(jobs_locked.len)
		return_text += "<BR><BR>Jobs Not Unlocked:<UL><LI>"
		return_text += jobs_locked.Join("</LI><LI>")
		return_text += "</LI></UL>"
	return return_text

/client/proc/get_exp_breakdown()
	if(!CONFIG_GET(flag/use_exp_tracking))
		return "Tracking is disabled in the server configuration file."
	var/list/play_records = get_exp_records()
	if(!play_records.len)
		return "[key] has no records."

	var/list/return_text = list()
	var/living_minutes = text2num(play_records[EXP_TYPE_LIVING])
	var/ghost_minutes = text2num(play_records[EXP_TYPE_GHOST])
	var/antag_minutes = 0
	var/role_max = 0
	var/page_size = 5
	var/list/role_records = list()
	var/list/antag_roles = GLOB.exp_specialmap[EXP_TYPE_ANTAG]
	var/list/excluded = GLOB.exp_jobsmap.Copy()
	excluded |= GLOB.exp_specialmap.Copy()
	excluded += EXP_TYPE_ADMIN

	for(var/antag_role in antag_roles)
		antag_minutes += text2num(play_records[antag_role])

	for(var/role_name in play_records)
		if(role_name in excluded)
			continue
		var/role_minutes = text2num(play_records[role_name])
		if(role_minutes <= 0)
			continue
		role_records[role_name] = role_minutes
		role_max = max(role_max, role_minutes)

	if(role_records.len > 1)
		sortTim(role_records, cmp = /proc/cmp_numeric_dsc, associative = TRUE)
	var/page_total = max(1, ceil(role_records.len / page_size))

	return_text += {"
	<style>
		html, body { margin: 0; padding: 0; background: black; color: #e3c06f; }
		.playtime-shell { font-family: Verdana, sans-serif; color: #e3c06f; background: black; padding: 14px; }
		.playtime-title { margin: 0 0 12px 0; font-size: 20px; color: #a36c63; letter-spacing: 1px; }
		.playtime-table { width: 100%; border-collapse: collapse; margin-bottom: 14px; background: #080808; }
		.playtime-table th, .playtime-table td { padding: 8px 10px; border: 1px solid #511111; }
		.playtime-table th { text-align: left; background: #160909; color: #a36c63; }
		.playtime-table td.value { text-align: right; white-space: nowrap; }
		.playtime-divider { height: 1px; margin: 10px 0 12px 0; background: #511111; }
		.playtime-empty { padding: 12px; background: #080808; border: 1px solid #511111; color: #e3c06f; }
		.playtime-nav { display: flex; align-items: center; justify-content: space-between; gap: 8px; margin: 0 0 10px 0; }
		.playtime-nav-controls { display: flex; gap: 8px; }
		.playtime-nav-link { display: inline-block; padding: 6px 10px; background: #160909; border: 1px solid #511111; color: #a36c63; text-decoration: none; }
		.playtime-nav-link:hover { background: #220d0d; }
		.playtime-nav-label { color: #a36c63; font-size: 12px; }
		.playtime-bar-track { width: 100%; height: 18px; background: #050505; border: 1px solid #511111; position: relative; }
		.playtime-bar-fill { height: 100%; background: linear-gradient(90deg, #4c1212 0%, #7a2323 100%); }
		.playtime-bar-fill.antag { background: linear-gradient(90deg, #5c0c0c 0%, #8a1d1d 100%); }
		.playtime-bar-label { position: absolute; inset: 0; display: flex; align-items: center; justify-content: center; font-size: 11px; font-weight: bold; color: #e3c06f; text-shadow: 0 1px 2px #000000; }
	</style>
	<script type='text/javascript'>
		var playtimeCurrentPage = 1;
		var playtimeTotalPages = [page_total];
		function showPlaytimePage(page) {
			if (page < 1 || page > playtimeTotalPages) {
				return false;
			}
			playtimeCurrentPage = page;
			var rows = document.getElementsByClassName('playtime-role-row');
			for (var i = 0; i < rows.length; i++) {
				rows.item(i).style.display = rows.item(i).getAttribute('data-page') == String(page) ? 'table-row' : 'none';
			}
			var label = document.getElementById('playtime-page-label');
			if (label) {
				label.innerHTML = 'Page ' + page + ' / ' + playtimeTotalPages;
			}
			return false;
		}
	</script>
	<div class='playtime-shell'>
		<h2 class='playtime-title'>PLAYTIME</h2>
		<table class='playtime-table'>
			<tr><th>Category</th><th>Hours</th></tr>
			<tr><td>Living</td><td class='value'>[get_exp_hours_format(living_minutes)]h</td></tr>
			<tr><td>Ghost</td><td class='value'>[get_exp_hours_format(ghost_minutes)]h</td></tr>
			<tr><td>Antagonist</td><td class='value'>[get_exp_hours_format(antag_minutes)]h</td></tr>
		</table>
		<div class='playtime-divider'></div>
	"}

	if(role_records.len)
		if(page_total > 1)
			return_text += "<div class='playtime-nav'><div class='playtime-nav-controls'><a href='#' class='playtime-nav-link' onclick='return showPlaytimePage(playtimeCurrentPage - 1);'>&lt;</a><a href='#' class='playtime-nav-link' onclick='return showPlaytimePage(playtimeCurrentPage + 1);'>&gt;</a></div><div class='playtime-nav-label' id='playtime-page-label'>Page 1 / [page_total]</div></div>"
		return_text += "<table class='playtime-table'><tr><th style='width:100%'>Time (Hrs)</th></tr>"
		var/role_i = 0
		for(var/role_name in role_records)
			role_i++
			var/role_minutes = role_records[role_name]
			var/page_no = ceil(role_i / page_size)
			var/bar_pct = role_max ? round((role_minutes / role_max) * 100, 1) : 0
			var/is_antag = !!antag_roles[role_name]
			var/bar_css = is_antag ? "playtime-bar-fill antag" : "playtime-bar-fill"
			var/bar_text = "[role_name]  [get_exp_hours_format(role_minutes)]h"
			var/show_row = page_no == 1 ? "table-row" : "none"
			return_text += "<tr class='playtime-role-row' data-page='[page_no]' style='display: [show_row];'><td><div class='playtime-bar-track'><div class='[bar_css]' style='width: [bar_pct]%;'></div><div class='playtime-bar-label'>[bar_text]</div></div></td></tr>"
		return_text += "</table>"
	else
		return_text += "<div class='playtime-empty'>No tracked role playtime yet.</div>"

	return_text += "</div>"

	return return_text


/client/proc/get_exp_living()
	if(!prefs.exp)
		return "No data"
	var/exp_living = text2num(prefs.exp[EXP_TYPE_LIVING])
	return get_exp_format(exp_living)

/proc/get_exp_format(expnum)
	if(expnum > 60)
		return num2text(round(expnum / 60)) + "h"
	else if(expnum > 0)
		return num2text(expnum) + "m"
	else
		return "0h"

/proc/get_exp_hours_format(expnum)
	return num2text(round((text2num(expnum) / 60), 0.1))

/datum/controller/subsystem/blackbox/proc/update_exp(mins, ann = FALSE)
	if(!SSdbcore.Connect())
		return -1
	var/should_flush_updates = FALSE
	for(var/client/L in GLOB.clients)
		if(L.is_afk())
			continue
		if(L.update_exp_list(mins,ann) > 0)
			should_flush_updates = TRUE
	if(should_flush_updates)
		addtimer(CALLBACK(SSblackbox,TYPE_PROC_REF(/datum/controller/subsystem/blackbox, update_exp_db)),20,TIMER_OVERRIDE|TIMER_UNIQUE)

/datum/controller/subsystem/blackbox/proc/update_exp_db()
	set waitfor = FALSE
	var/list/old_minutes = GLOB.exp_to_update
	GLOB.exp_to_update = null
	if(!old_minutes?.len)
		return
	SSdbcore.MassInsert(format_table_name("role_time"), old_minutes, duplicate_key = "ON DUPLICATE KEY UPDATE minutes = minutes + VALUES(minutes)")

//resets a client's exp to what was in the db.
/client/proc/set_exp_from_db()
	if(!CONFIG_GET(flag/use_exp_tracking))
		return -1
	if(!SSdbcore.Connect())
		return -1
	var/datum/DBQuery/exp_read = SSdbcore.NewQuery(
		"SELECT job, minutes FROM [format_table_name("role_time")] WHERE ckey = :ckey",
		list("ckey" = ckey)
	)
	if(!exp_read.Execute(async = TRUE))
		qdel(exp_read)
		return -1
	var/list/play_records = list()
	while(exp_read.NextRow())
		play_records[exp_read.item[1]] = text2num(exp_read.item[2])
	qdel(exp_read)

	for(var/rtype in SSjob.name_occupations)
		if(!play_records[rtype])
			play_records[rtype] = 0
	for(var/rtype in GLOB.exp_specialmap)
		if(!play_records[rtype])
			play_records[rtype] = 0

	prefs.exp = play_records

//updates player db flags
/client/proc/update_flag_db(newflag, state = FALSE)

	if(!SSdbcore.Connect())
		return -1

	if(!set_db_player_flags())
		return -1

	if((prefs.db_flags & newflag) && !state)
		prefs.db_flags &= ~newflag
	else
		prefs.db_flags |= newflag

	var/datum/DBQuery/flag_update = SSdbcore.NewQuery(
		"UPDATE [format_table_name("player")] SET flags=:flags WHERE ckey=:ckey",
		list("flags" = "[prefs.db_flags]", "ckey" = ckey)
	)

	if(!flag_update.Execute())
		qdel(flag_update)
		return -1
	qdel(flag_update)


/client/proc/update_exp_list(minutes, announce_changes = FALSE)
	if(!CONFIG_GET(flag/use_exp_tracking))
		return -1
	if (!isnum(minutes))
		return -1
	if(!isliving(mob) && !isobserver(mob))
		return 0
	var/list/play_records = list()
	var/updated_entries = 0

	if(isliving(mob))
		if(mob.stat != DEAD)
			var/rolefound = FALSE
			var/tracked_assigned_role
			var/tracked_special_role
			play_records[EXP_TYPE_LIVING] += minutes
			if(announce_changes)
				to_chat(src,span_notice("I got: [minutes] Living EXP!"))
			if(mob.mind.assigned_role)
				var/list/role_lookup = get_exp_role_lookup()
				tracked_assigned_role = role_lookup[mob.mind.assigned_role]
				if(tracked_assigned_role)
					rolefound = TRUE
					play_records[tracked_assigned_role] += minutes
					if(announce_changes)
						to_chat(src,span_notice("I got: [minutes] [tracked_assigned_role] EXP!"))
			if(mob.mind.special_role && !(mob.mind.datum_flags & DF_VAR_EDITED))
				tracked_special_role = mob.mind.special_role
				rolefound = TRUE
				if(tracked_special_role != tracked_assigned_role)
					play_records[tracked_special_role] += minutes
					if(announce_changes)
						to_chat(src,span_notice("I got: [minutes] [tracked_special_role] EXP!"))
			if(!rolefound)
				play_records["Unknown"] += minutes
		else
			if(holder && !holder.deadmined)
				play_records[EXP_TYPE_ADMIN] += minutes
				if(announce_changes)
					to_chat(src,span_notice("I got: [minutes] Admin EXP!"))
			else
				play_records[EXP_TYPE_GHOST] += minutes
				if(announce_changes)
					to_chat(src,span_notice("I got: [minutes] Ghost EXP!"))
	else if(isobserver(mob))
		play_records[EXP_TYPE_GHOST] += minutes
		if(announce_changes)
			to_chat(src,span_notice("I got: [minutes] Ghost EXP!"))

	for(var/jtype in play_records)
		var/jvalue = play_records[jtype]
		if (!jvalue)
			continue
		if (!isnum(jvalue))
			CRASH("invalid job value [jtype]:[jvalue]")
		updated_entries++
		LAZYINITLIST(GLOB.exp_to_update)
		GLOB.exp_to_update.Add(list(list(
			"job" = "'[jtype]'",
			"ckey" = "'[ckey]'",
			"minutes" = jvalue)))
		prefs.exp[jtype] += jvalue
	return updated_entries


//ALWAYS call this at beginning to any proc touching player flags, or your database admin will probably be mad
/client/proc/set_db_player_flags()
	if(!SSdbcore.Connect())
		return FALSE

	var/datum/DBQuery/flags_read = SSdbcore.NewQuery(
		"SELECT flags FROM [format_table_name("player")] WHERE ckey=:ckey",
		list("ckey" = ckey)
	)

	if(!flags_read.Execute(async = TRUE))
		qdel(flags_read)
		return FALSE

	if(flags_read.NextRow())
		prefs.db_flags = text2num(flags_read.item[1])
	else if(isnull(prefs.db_flags))
		prefs.db_flags = 0	//This PROBABLY won't happen, but better safe than sorry.
	qdel(flags_read)
	return TRUE
