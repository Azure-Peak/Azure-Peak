/// Log files bigger than this are only offered for download
#define LOGVIEW_MAX_BYTES (64 * 1024 * 1024)
/// Entries sent to the viewer per page
#define LOGVIEW_PAGE 200
/// Parsed rounds kept in memory between viewers
#define LOGVIEW_ROUNDS 3
/// Players one viewer can filter by at once
#define LOGVIEW_PLAYERS 20

/// Source not parsed yet
#define LOGVIEW_IDLE 0
/// Source being parsed
#define LOGVIEW_LOADING 1
/// Source parsed and searchable
#define LOGVIEW_READY 2
/// Source too large to parse in game
#define LOGVIEW_HUGE 3
/// Source file vanished
#define LOGVIEW_GONE 4

/// Parsed rounds by folder path, shared between admins
GLOBAL_LIST_EMPTY(logview_rounds)
GLOBAL_PROTECT(logview_rounds)
/// Open log viewers by admin ckey
GLOBAL_LIST_EMPTY(logviewers)
GLOBAL_PROTECT(logviewers)

/client/proc/getserverlogs()
	set name = "Get Server Logs"
	set desc = "Browse, search and filter the logs of any round."
	set category = "Server"

	if(!check_rights(R_ADMIN|R_BAN))
		return
	var/datum/log_viewer/viewer = GLOB.logviewers[ckey]
	if(!viewer)
		viewer = new(ckey)
		GLOB.logviewers[ckey] = viewer
	viewer.ui_interact(mob)

/// One log file of a round, parsed into parallel entry lists
/datum/log_source
	/// Name shown in the viewer, the file path inside the round without extension
	var/name
	/// File path inside the round folder
	var/file
	/// Full path on disk
	var/path
	/// Whether the file is json lines rather than readable text
	var/json = FALSE
	/// LOGVIEW_ load state
	var/state = LOGVIEW_IDLE
	/// Size on disk when last checked
	var/bytes = 0
	/// Size on disk when last parsed
	var/seen = -1
	/// Lines already parsed, so a growing file only parses what was appended
	var/lines = 0
	/// Timestamp of each entry
	var/list/stamps = list()
	/// Category of each entry
	var/list/cats = list()
	/// Message of each entry
	var/list/msgs = list()
	/// Json of each entry's extra data, or null
	var/list/datas = list()
	/// Category -> entry count
	var/list/counts = list()
	/// ckey -> key, from logins
	var/list/keys = list()
	/// ckey -> names seen next to that key
	var/list/names = list()
	/// ckey -> jobs from the manifest
	var/list/jobs = list()

GENERAL_PROTECT_DATUM(/datum/log_source)

/datum/log_source/New(name, file, path, json)
	src.name = name
	src.file = file
	src.path = path
	src.json = json

/datum/log_source/proc/load()
	if(state == LOGVIEW_LOADING)
		UNTIL(state != LOGVIEW_LOADING)
		return
	if(!fexists(path))
		state = LOGVIEW_GONE
		return
	bytes = length(file(path))
	if(bytes > LOGVIEW_MAX_BYTES)
		state = LOGVIEW_HUGE
		return
	if(bytes == seen)
		return
	var/static/regex/stamp = regex(@"^\[(\d{4}-\d\d-\d\d \d\d:\d\d:\d\d(?:\.\d+)?)\] (?:([A-Z][A-Z0-9 _-]{0,23}): )?(.*)$")
	state = LOGVIEW_LOADING
	seen = bytes
	var/list/rows = splittext(rustg_file_read(path), "\n")
	var/stop = length(rows) - 1
	try
		for(var/i in lines + 1 to stop)
			CHECK_TICK
			var/line = rows[i]
			if(!length(line))
				continue
			if(!json)
				if(stamp.Find(line))
					add_entry(stamp.group[1], stamp.group[2] ? LOWER_TEXT(stamp.group[2]) : name, stamp.group[3], null)
				else if(length(msgs))
					msgs[length(msgs)] += "\n[line]"
				continue
			var/list/row
			try
				row = json_decode(line)
			catch
				continue
			if(!islist(row) || !row["ts"])
				continue
			var/data = row["data"]
			add_entry(row["ts"], row["cat"] || name, "[row["msg"]]", isnull(data) ? null : json_encode(data))
	catch(var/exception/E)
		state = LOGVIEW_IDLE
		seen = -1
		throw E
	lines = max(lines, stop)
	state = LOGVIEW_READY

/datum/log_source/proc/add_entry(stamp, cat, msg, data)
	var/static/regex/login = regex(@"^Login: (.+?)(?:/\(.*?\))? from ")
	var/static/regex/pair = regex(@"(\S+?)(?:\[DC\])?/\(([^)]+)\)", "g")
	stamps += stamp
	cats += cat
	msgs += msg
	datas.len++
	datas[length(datas)] = data
	counts[cat] += 1
	if(cat == "manifest")
		var/list/bits = splittext(msg, " \\ ")
		var/who = ckey(bits[1])
		if(length(bits) < 3 || !who)
			return
		LAZYOR(names[who], bits[2])
		var/job = bits[3]
		if(length(bits) >= 4 && bits[4] != "NONE")
			job += " ([bits[4]])"
		LAZYOR(jobs[who], job)
		return
	if(copytext(msg, 1, 8) == "Login: " && login.Find(msg))
		var/key = login.group[1]
		keys[ckey(key)] = key
	if(!findtext(msg, "/("))
		return
	var/at = 1
	while(pair.Find(msg, at))
		at = pair.next
		var/who = ckey(pair.group[1])
		var/what = pair.group[2]
		if(who && ckey(what) != who)
			LAZYOR(names[who], what)

/// A round's log folder and its parsed sources
/datum/log_round
	/// Folder path ending in a slash
	var/path
	/// Folder name shown in the viewer
	var/label
	/// Name -> /datum/log_source
	var/list/sources = list()
	/// Files that are not logs, offered for download only
	var/list/others = list()
	/// world.time of last use, for eviction
	var/used = 0

GENERAL_PROTECT_DATUM(/datum/log_round)

/datum/log_round/New(path)
	src.path = path
	var/list/bits = splittext(path, "/")
	label = (length(bits) >= 2) ? bits[length(bits) - 1] : path
	scan()

/datum/log_round/proc/scan()
	others = list()
	read_dir("")
	read_dir("secret/")
	sources = sortList(sources)

/datum/log_round/proc/read_dir(sub)
	var/list/found = flist("[path][sub]")
	for(var/fname in found)
		if(copytext(fname, -1) == "/")
			continue
		var/rel = "[sub][fname]"
		var/json = endswith(fname, ".log.json")
		if(!json && !endswith(fname, ".log"))
			others += rel
			continue
		if(!json && ("[fname].json" in found))
			continue
		var/name = copytext(rel, 1, json ? -9 : -4)
		var/datum/log_source/source = sources[name]
		if(!source)
			source = new(name, rel, "[path][rel]", json)
			sources[name] = source
		source.bytes = length(file(source.path))

/// One admin's open log viewer
/datum/log_viewer
	/// ckey of the admin using this viewer
	var/owner
	/// Day folders as YYYY/MM/DD, newest first
	var/list/days
	/// Selected day, null when the live round lives outside a day folder
	var/day
	/// Round folder names of the selected day
	var/list/rounds = list()
	/// Selected round
	var/datum/log_round/folder
	/// Source names whose entries are shown
	var/list/shown = list()
	/// Categories unticked by the admin
	var/list/hidden = list()
	/// Text an entry must contain
	var/search = ""
	/// Whether search is a regex
	var/pattern = FALSE
	/// Comma separated phrases that hide an entry
	var/exclude = ""
	/// Earliest clock time shown, HH:MM:SS
	var/from = ""
	/// Latest clock time shown, HH:MM:SS
	var/till = ""
	/// ckeys or free text naming the players to show
	var/list/players = list()
	/// Whether a picked player also matches their character names
	var/chars = TRUE
	/// Whether the newest entries come first
	var/newest = FALSE
	/// Current page
	var/page = 1
	/// Source of each matched entry
	var/list/hsrc = list()
	/// Index into its source of each matched entry
	var/list/hidx = list()
	/// Text highlighted in the viewer
	var/list/marks = list()
	/// Filters the picked cache was built for
	var/sig
	/// Source -> indices passing the text, player and time filters
	var/list/picked = list()
	/// Source -> entries already run through those filters
	var/list/scanned = list()
	/// Entry to jump to once filtering finishes, as list(source, index)
	var/list/want
	/// Entry jumped to, as "source:index"
	var/focus
	/// Whether the worker is running
	var/busy = FALSE
	/// Whether the worker must run again
	var/dirty = FALSE
	/// Problem to show the admin
	var/error

GENERAL_PROTECT_DATUM(/datum/log_viewer)

/datum/log_viewer/New(owner)
	src.owner = owner
	days = list_days()
	open_live()

/datum/log_viewer/Destroy(force)
	GLOB.logviewers -= owner
	return ..()

/datum/log_viewer/ui_state(mob/user)
	return ADMIN_STATE(R_ADMIN|R_BAN)

/datum/log_viewer/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ServerLogs", "Server Logs")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/log_viewer/ui_close(mob/user)
	qdel(src)

/datum/log_viewer/ui_static_data(mob/user)
	return list("days" = days)

/datum/log_viewer/ui_data(mob/user)
	var/list/data = list()
	data["day"] = day
	data["rounds"] = rounds
	data["round"] = folder?.label
	data["live"] = folder?.path == "[GLOB.log_directory]/"
	data["busy"] = busy
	data["error"] = error
	data["search"] = search
	data["pattern"] = pattern
	data["exclude"] = exclude
	data["from"] = from
	data["till"] = till
	data["players"] = players
	data["chars"] = chars
	data["newest"] = newest
	data["marks"] = marks
	data["focus"] = focus

	var/list/srcs = list()
	var/list/folk = list()
	if(folder)
		for(var/name in folder.sources)
			var/datum/log_source/source = folder.sources[name]
			var/list/cats = list()
			for(var/cat in source.counts)
				cats += list(list("name" = cat, "count" = source.counts[cat], "on" = !hidden[cat]))
			srcs += list(list(
				"name" = name,
				"file" = source.file,
				"state" = source.state,
				"bytes" = source.bytes,
				"on" = !!shown[name],
				"cats" = cats,
			))
		var/list/people = people()
		for(var/who in people)
			folk += list(people[who])
		data["others"] = folder.others
	data["sources"] = srcs
	data["people"] = folk

	var/total = length(hidx)
	var/pages = max(1, CEILING(total / LOGVIEW_PAGE, 1))
	page = clamp(page, 1, pages)
	var/list/rows = list()
	var/first = (page - 1) * LOGVIEW_PAGE + 1
	for(var/n in first to min(total, first + LOGVIEW_PAGE - 1))
		var/pos = newest ? total - n + 1 : n
		var/datum/log_source/source = hsrc[pos]
		var/i = hidx[pos]
		rows += list(list(
			"src" = source.name,
			"i" = i,
			"ts" = source.stamps[i],
			"cat" = source.cats[i],
			"msg" = source.msgs[i],
			"data" = source.datas[i],
		))
	data["rows"] = rows
	data["total"] = total
	data["page"] = page
	data["pages"] = pages
	return data

/datum/log_viewer/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("day")
			var/pick = params["day"]
			if(!(pick in days))
				return
			day = pick
			rounds = list_rounds(day)
			return TRUE
		if("round")
			var/pick = params["round"]
			if(!day || !(pick in list_rounds(day)))
				return
			open("data/logs/[day]/[pick]/")
			return TRUE
		if("live")
			open_live()
			return TRUE
		if("refresh")
			days = list_days()
			if(day)
				rounds = list_rounds(day)
			folder?.scan()
			update_static_data(usr, ui)
			kick()
			return TRUE
		if("source")
			var/name = params["name"]
			if(!istext(name) || !folder?.sources[name])
				return
			if(shown[name])
				shown -= name
			else
				shown[name] = TRUE
			kick()
			return TRUE
		if("cat")
			var/cat = params["name"]
			if(!istext(cat))
				return
			if(hidden[cat])
				hidden -= cat
			else
				var/known = FALSE
				for(var/name in folder?.sources)
					var/datum/log_source/source = folder.sources[name]
					if(source.counts[cat])
						known = TRUE
						break
				if(!known)
					return
				hidden[cat] = TRUE
			kick()
			return TRUE
		if("filter")
			search = clean(params["search"], 300)
			pattern = !!params["pattern"]
			exclude = clean(params["exclude"], 300)
			from = clean(params["from"], 9)
			till = clean(params["till"], 9)
			page = 1
			focus = null
			kick()
			return TRUE
		if("player")
			var/who = clean(params["who"], 64)
			if(!who)
				return
			if(who in players)
				players -= who
			else if(length(players) < LOGVIEW_PLAYERS)
				players += who
			else
				return
			page = 1
			kick()
			return TRUE
		if("chars")
			chars = !chars
			kick()
			return TRUE
		if("newest")
			newest = !newest
			page = 1
			return TRUE
		if("page")
			page = round(text2num("[params["page"]]")) || 1
			return TRUE
		if("clear")
			unfilter()
			hidden = list()
			page = 1
			focus = null
			kick()
			return TRUE
		if("context")
			var/name = params["src"]
			var/datum/log_source/source = istext(name) ? folder?.sources[name] : null
			var/i = round(text2num("[params["i"]]"))
			if(!source || !i || i < 1 || i > length(source.msgs))
				return
			unfilter()
			want = list(source, i)
			kick()
			return TRUE
		if("download")
			var/rel = params["file"]
			if(!folder || !istext(rel))
				return
			var/listed = (rel in folder.others)
			for(var/name in folder.sources)
				var/datum/log_source/source = folder.sources[name]
				if(source.file == rel)
					listed = TRUE
					break
			if(!listed)
				return
			var/client/user = usr.client
			if(user.file_spam_check())
				return
			var/path = "[folder.path][rel]"
			message_admins("[key_name_admin(usr)] downloaded log file [path]")
			log_admin("[key_name(usr)] downloaded log file [path]")
			if(params["open"])
				user << run(file(path))
			else
				user << ftp(file(path), "[folder.label]-[replacetext(rel, "/", "-")]")
			return TRUE
		if("export")
			if(!length(hidx) || busy)
				return
			var/client/user = usr.client
			if(user.file_spam_check())
				return
			INVOKE_ASYNC(src, PROC_REF(export), user)
			return TRUE

/datum/log_viewer/proc/clean(value, cap)
	return istext(value) ? trim(value, cap) : ""

/datum/log_viewer/proc/unfilter()
	search = ""
	pattern = FALSE
	exclude = ""
	from = ""
	till = ""
	players = list()

/datum/log_viewer/proc/list_days()
	var/static/regex/year = regex(@"^\d{4}/$")
	var/static/regex/part = regex(@"^\d\d/$")
	var/list/out = list()
	for(var/y in flist("data/logs/"))
		if(!year.Find(y))
			continue
		for(var/m in flist("data/logs/[y]"))
			if(!part.Find(m))
				continue
			for(var/d in flist("data/logs/[y][m]"))
				if(part.Find(d))
					out += copytext("[y][m][d]", 1, -1)
	return sortList(out, /proc/cmp_text_dsc)

/datum/log_viewer/proc/list_rounds(day)
	var/list/out = list()
	for(var/name in flist("data/logs/[day]/"))
		if(copytext(name, 1, 7) == "round-" && copytext(name, -1) == "/")
			out += copytext(name, 1, -1)
	return sortList(out, /proc/cmp_text_dsc)

/datum/log_viewer/proc/open_live()
	var/static/regex/dated = regex(@"^data/logs/(\d{4}/\d\d/\d\d)/")
	var/path = "[GLOB.log_directory]/"
	day = dated.Find(path) ? dated.group[1] : null
	rounds = day ? list_rounds(day) : list()
	open(path)

/datum/log_viewer/proc/open(path)
	var/datum/log_round/logs = GLOB.logview_rounds[path]
	if(logs)
		logs.scan()
	else
		logs = new(path)
		GLOB.logview_rounds[path] = logs
	folder = logs
	logs.used = world.time
	evict()
	shown = list()
	sig = null
	picked = list()
	scanned = list()
	from = ""
	till = ""
	page = 1
	focus = null
	want = null
	hsrc = list()
	hidx = list()
	log_admin("[owner] opened the logs of [path] in the log viewer.")
	kick()

/datum/log_viewer/proc/evict()
	var/list/cache = GLOB.logview_rounds
	while(length(cache) > LOGVIEW_ROUNDS)
		var/datum/log_round/old
		for(var/path in cache)
			var/datum/log_round/logs = cache[path]
			if(old && logs.used >= old.used)
				continue
			var/taken = FALSE
			for(var/who in GLOB.logviewers)
				var/datum/log_viewer/viewer = GLOB.logviewers[who]
				if(viewer.folder == logs)
					taken = TRUE
					break
			if(!taken)
				old = logs
		if(!old)
			return
		cache -= old.path

/datum/log_viewer/proc/people()
	var/list/known = list()
	for(var/name in folder.sources)
		var/datum/log_source/source = folder.sources[name]
		for(var/who in source.keys)
			known[who] = source.keys[who]
		for(var/who in source.jobs)
			if(!known[who])
				known[who] = who
	var/list/out = list()
	for(var/who in sortList(known))
		var/list/named = list()
		var/list/worked = list()
		for(var/name in folder.sources)
			var/datum/log_source/source = folder.sources[name]
			if(source.names[who])
				named |= source.names[who]
			if(source.jobs[who])
				worked |= source.jobs[who]
		out[who] = list("ckey" = who, "key" = known[who], "names" = named, "jobs" = worked)
	return out

/datum/log_viewer/proc/kick()
	dirty = TRUE
	if(busy)
		return
	busy = TRUE
	INVOKE_ASYNC(src, PROC_REF(work))

/datum/log_viewer/proc/work()
	try
		while(dirty && folder && !QDELETED(src))
			dirty = FALSE
			for(var/name in shown)
				var/datum/log_source/source = folder.sources[name]
				if(!source)
					continue
				var/fresh = source.state != LOGVIEW_READY
				source.load()
				if(fresh && !QDELETED(src))
					SStgui.update_uis(src)
			if(!QDELETED(src))
				refilter()
	catch(var/exception/E)
		sig = null
		error = "The log viewer broke: [E]"
		stack_trace("log viewer failed: [E] on [E.file]:[E.line]")
	busy = FALSE
	if(!QDELETED(src))
		SStgui.update_uis(src)

/datum/log_viewer/proc/clock(text, upper)
	var/static/regex/hms = regex(@"^(\d{1,2}):(\d\d)(?::(\d\d))?$")
	if(!length(text))
		return ""
	if(!hms.Find(text))
		return null
	var/h = text2num(hms.group[1])
	var/m = text2num(hms.group[2])
	var/s = hms.group[3] ? text2num(hms.group[3]) : (upper ? 59 : 0)
	if(h > 23 || m > 59 || s > 59)
		return null
	return "[h < 10 ? "0" : ""][h]:[m < 10 ? "0" : ""][m]:[s < 10 ? "0" : ""][s]"

/datum/log_viewer/proc/refilter()
	error = null
	hsrc = list()
	hidx = list()
	marks = list()
	if(!folder)
		return
	var/lo = clock(from, FALSE)
	var/hi = clock(till, TRUE)
	if(isnull(lo) || isnull(hi))
		error = "Times must look like 14:05 or 14:05:30."
		return
	var/regex/finder
	if(search && pattern)
		try
			finder = regex(search, "i")
		catch(var/exception/E)
			error = "Bad regex: [E]"
			return
	if(search && !pattern)
		marks += search
	var/list/nots = list()
	for(var/bit in splittext(exclude, ","))
		bit = trim(bit)
		if(bit)
			nots += bit
	var/list/needles = list()
	if(length(players))
		var/list/people = people()
		for(var/who in players)
			needles |= who
			var/list/person = people[ckey(who)]
			if(!person)
				continue
			needles |= person["key"]
			if(chars)
				needles |= person["names"]
		marks |= needles

	if(lo || hi)
		var/first
		var/last
		for(var/name in folder.sources)
			var/datum/log_source/source = folder.sources[name]
			if(source.state != LOGVIEW_READY || !length(source.stamps))
				continue
			if(!first || source.stamps[1] < first)
				first = source.stamps[1]
			if(!last || source.stamps[length(source.stamps)] > last)
				last = source.stamps[length(source.stamps)]
		if(first)
			var/start = copytext(first, 12, 20)
			var/today = copytext(first, 1, 11)
			var/tomorrow = copytext(last, 1, 11)
			if(lo)
				lo = "[lo < start ? tomorrow : today] [lo]"
			if(hi)
				hi = "[hi < start ? tomorrow : today] [hi].999"

	var/key = json_encode(list(search, pattern, nots, needles, lo, hi))
	if(key != sig)
		sig = key
		picked = list()
		scanned = list()

	var/list/srcs = list()
	var/list/picks = list()
	for(var/name in shown)
		var/datum/log_source/source = folder.sources[name]
		if(source?.state != LOGVIEW_READY)
			continue
		var/list/got = picked[source] || list()
		picked[source] = got
		var/list/stamps = source.stamps
		var/list/msgs = source.msgs
		var/stop = length(msgs)
		for(var/i in scanned[source] + 1 to stop)
			CHECK_TICK
			if((lo && stamps[i] < lo) || (hi && stamps[i] > hi))
				continue
			var/msg = msgs[i]
			if(finder)
				if(!finder.Find(msg))
					continue
			else if(search && !findtext(msg, search))
				continue
			if(length(needles))
				var/hit = FALSE
				for(var/needle in needles)
					if(findtext(msg, needle))
						hit = TRUE
						break
				if(!hit)
					continue
			var/hide = FALSE
			for(var/bit in nots)
				if(findtext(msg, bit))
					hide = TRUE
					break
			if(hide)
				continue
			got += i
		scanned[source] = stop
		var/list/visible = got
		if(length(hidden))
			visible = list()
			var/list/cats = source.cats
			for(var/i in got)
				if(!hidden[cats[i]])
					visible += i
		srcs += source
		picks += list(visible)

	var/k = length(srcs)
	var/list/at = new /list(k)
	for(var/j in 1 to k)
		at[j] = 1
	while(TRUE)
		var/best = 0
		var/top
		for(var/j in 1 to k)
			var/list/got = picks[j]
			if(at[j] > length(got))
				continue
			var/datum/log_source/source = srcs[j]
			var/stamp = source.stamps[got[at[j]]]
			if(!best || stamp < top)
				best = j
				top = stamp
		if(!best)
			break
		var/list/chosen = picks[best]
		hsrc += srcs[best]
		hidx += chosen[at[best]]
		at[best]++
		CHECK_TICK

	if(want)
		var/datum/log_source/target = want[1]
		var/index = want[2]
		want = null
		var/total = length(hidx)
		for(var/pos in 1 to total)
			if(hidx[pos] == index && hsrc[pos] == target)
				var/rank = newest ? total - pos + 1 : pos
				page = CEILING(rank / LOGVIEW_PAGE, 1)
				focus = "[target.name]:[index]"
				break

/datum/log_viewer/proc/export(client/user)
	var/list/out = list()
	for(var/pos in 1 to length(hidx))
		var/datum/log_source/source = hsrc[pos]
		var/i = hidx[pos]
		out += "\[[source.stamps[i]]\] [uppertext(source.cats[i])]: [source.msgs[i]]"
		CHECK_TICK
	var/path = "tmp/logview.[owner].txt"
	rustg_file_write(jointext(out, "\n"), path)
	if(!user)
		return
	message_admins("[key_name_admin(user)] exported [length(out)] filtered log entries from [folder?.path]")
	log_admin("[key_name(user)] exported [length(out)] filtered log entries from [folder?.path]")
	user << ftp(file(path), "[folder?.label]-filtered.txt")

#undef LOGVIEW_MAX_BYTES
#undef LOGVIEW_PAGE
#undef LOGVIEW_ROUNDS
#undef LOGVIEW_PLAYERS
#undef LOGVIEW_IDLE
#undef LOGVIEW_LOADING
#undef LOGVIEW_READY
#undef LOGVIEW_HUGE
#undef LOGVIEW_GONE
