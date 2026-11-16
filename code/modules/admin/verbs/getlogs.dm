/// Log files bigger than this are only offered for download
#define LOGVIEW_MAX_BYTES (64 * 1024 * 1024)
/// Bytes split at a time while parsing, a power of two so offsets stay exact past 16MB
#define LOGVIEW_CHUNK 65536
/// Entries sent to the viewer per page
#define LOGVIEW_PAGE 200
/// Parsed rounds kept in memory between viewers
#define LOGVIEW_ROUNDS 3
/// Players one viewer can filter by at once
#define LOGVIEW_PLAYERS 20
/// Tick usage past which the viewer's background work waits for the next tick
#define LOGVIEW_TICK 40
/// Yields once the tick is past LOGVIEW_TICK, so parsing and filtering never crowd out the MC
#define LOGVIEW_YIELD (TICK_USAGE > min(LOGVIEW_TICK, Master.current_ticklimit) ? stoplag() : 0)

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
/// Parsed json sources of the live round by file path, fed new entries by the logger
GLOBAL_LIST_EMPTY(logview_live)
GLOBAL_PROTECT(logview_live)

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
	/// Date of each entry as YYYY-MM-DD. Times are kept as numbers since BYOND's string table chokes on hundreds of thousands of timestamp strings
	var/list/days = list()
	/// Second of the day of each entry
	var/list/secs = list()
	/// Millisecond of each entry
	var/list/msecs = list()
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
	/// Whether the logger feeds this source new entries, so it never needs re-reading
	var/fed = FALSE
	/// Entries logged while this source was loading, added once it finishes
	var/list/queue = list()

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
	var/text = file2text(path)
	var/carry = ""
	var/at = 1
	var/count = 0
	try
		while(TRUE)
			var/piece = copytext(text, at, at + LOGVIEW_CHUNK)
			if(!length(piece))
				break
			at += LOGVIEW_CHUNK
			var/list/rows = splittext(carry + piece, "\n")
			carry = rows[length(rows)]
			rows.len--
			for(var/line in rows)
				LOGVIEW_YIELD
				if(++count <= lines || !length(line))
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
		queue = list()
		throw E
	for(var/list/row in queue)
		add_entry(arglist(row))
	lines = max(lines, count) + length(queue)
	queue = list()
	state = LOGVIEW_READY

/datum/log_source/proc/feed(datum/log_entry/entry)
	if(state != LOGVIEW_LOADING && state != LOGVIEW_READY)
		return
	var/list/row = list(entry.timestamp, entry.category, "[entry.message]", isnull(entry.data) ? null : json_encode(entry.data))
	if(state == LOGVIEW_LOADING)
		queue += list(row)
		return
	add_entry(arglist(row))
	lines++

/datum/log_source/proc/when(i)
	var/s = secs[i]
	return "[days[i]] [copytext("0[round(s / 3600)]", -2)]:[copytext("0[round(s / 60) % 60]", -2)]:[copytext("0[s % 60]", -2)].[copytext("00[msecs[i]]", -3)]"

/datum/log_source/proc/add_entry(stamp, cat, msg, data)
	var/static/regex/login = regex(@"^Login: (.+?)(?:/\(.*?\))? from ")
	days += copytext(stamp, 1, 11)
	secs += text2num(copytext(stamp, 12, 14)) * 3600 + text2num(copytext(stamp, 15, 17)) * 60 + text2num(copytext(stamp, 18, 20))
	msecs += text2num(copytext("[copytext(stamp, 21, 24)]000", 1, 4))
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
	var/last = 1
	var/at = findtextEx(msg, "/(")
	while(at)
		var/stop = findtextEx(msg, ")", at + 2)
		if(!stop)
			return
		var/key = copytext(msg, max(last, findlasttextEx(msg, " ", at) + 1, findlasttextEx(msg, "\n", at) + 1, findlasttextEx(msg, "\t", at) + 1), at)
		if(copytext(key, -4) == "\[DC]")
			key = copytext(key, 1, -4)
		if(stop == at + 2 || !length(key))
			at = findtextEx(msg, "/(", at + 2)
			continue
		var/who = ckey(key)
		var/what = copytext(msg, at + 2, stop)
		if(who && ckey(what) != who)
			LAZYOR(names[who], what)
		last = stop + 1
		at = findtextEx(msg, "/(", last)

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
	read_dir("profiler/")
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
			if(json && path == "[GLOB.log_directory]/")
				source.fed = TRUE
				GLOB.logview_live[source.path] = source
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
	/// Whether the worker should re-read files that grew since they were parsed
	var/regrow = FALSE
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
			"ts" = source.when(i),
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
			regrow = TRUE
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
		if(old.path == "[GLOB.log_directory]/")
			GLOB.logview_live = list()

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
			var/reread = regrow
			regrow = FALSE
			for(var/name in shown)
				var/datum/log_source/source = folder.sources[name]
				var/fresh = source?.state != LOGVIEW_READY
				if(!source || !(fresh || (reread && !source.fed)))
					continue
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
	return h * 3600 + m * 60 + s

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
	var/list/exact = list()
	var/list/loose = list()
	if(length(players))
		var/list/people = people()
		for(var/who in players)
			var/list/person = people[ckey(who)]
			if(!person)
				loose |= who
				continue
			exact |= who
			exact |= person["key"]
			if(chars)
				exact |= person["names"]
		marks |= loose | exact

	var/loday
	var/hiday
	if(isnum(lo) || isnum(hi))
		var/today
		var/start
		var/tomorrow
		for(var/name in folder.sources)
			var/datum/log_source/source = folder.sources[name]
			var/n = length(source.days)
			if(source.state != LOGVIEW_READY || !n)
				continue
			var/day = source.days[1]
			if(!today || day < today || (day == today && source.secs[1] < start))
				today = day
				start = source.secs[1]
			if(!tomorrow || source.days[n] > tomorrow)
				tomorrow = source.days[n]
		if(today)
			if(isnum(lo))
				loday = lo < start ? tomorrow : today
			if(isnum(hi))
				hiday = hi < start ? tomorrow : today

	var/key = json_encode(list(search, pattern, nots, exact, loose, lo, hi, loday, hiday))
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
		var/list/days = source.days
		var/list/secs = source.secs
		var/list/msgs = source.msgs
		var/stop = length(msgs)
		for(var/i in scanned[source] + 1 to stop)
			LOGVIEW_YIELD
			if(loday && (days[i] < loday || (days[i] == loday && secs[i] < lo)))
				continue
			if(hiday && (days[i] > hiday || (days[i] == hiday && secs[i] > hi)))
				continue
			var/msg = msgs[i]
			if(finder)
				if(!finder.Find(msg))
					continue
			else if(search && !findtext(msg, search))
				continue
			if(length(exact) || length(loose))
				var/hit = FALSE
				for(var/needle in exact)
					if(findtextEx(msg, needle))
						hit = TRUE
						break
				if(!hit)
					for(var/needle in loose)
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
				LOGVIEW_YIELD
				if(!hidden[cats[i]])
					visible += i
		srcs += source
		picks += list(visible)

	var/k = length(srcs)
	var/list/at = new /list(k)
	var/list/heads = new /list(k)
	var/list/moments = new /list(k)
	for(var/j in 1 to k)
		at[j] = 1
		var/list/got = picks[j]
		var/datum/log_source/source = srcs[j]
		if(length(got))
			heads[j] = source.days[got[1]]
			moments[j] = source.secs[got[1]] + source.msecs[got[1]] / 1000
	while(TRUE)
		var/best = 0
		var/topday
		var/topmark
		for(var/j in 1 to k)
			var/day = heads[j]
			if(day && (!best || day < topday || (day == topday && moments[j] < topmark)))
				best = j
				topday = day
				topmark = moments[j]
		if(!best)
			break
		var/list/chosen = picks[best]
		var/datum/log_source/source = srcs[best]
		var/pos = at[best]
		hsrc += source
		hidx += chosen[pos]
		at[best] = ++pos
		if(pos > length(chosen))
			heads[best] = null
		else
			var/i = chosen[pos]
			heads[best] = source.days[i]
			moments[best] = source.secs[i] + source.msecs[i] / 1000
		LOGVIEW_YIELD

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
		out += "\[[source.when(i)]\] [uppertext(source.cats[i])]: [source.msgs[i]]"
		LOGVIEW_YIELD
	var/path = "tmp/logview.[owner].txt"
	rustg_file_write(jointext(out, "\n"), path)
	if(!user)
		return
	message_admins("[key_name_admin(user)] exported [length(out)] filtered log entries from [folder?.path]")
	log_admin("[key_name(user)] exported [length(out)] filtered log entries from [folder?.path]")
	user << ftp(file(path), "[folder?.label]-filtered.txt")

#undef LOGVIEW_MAX_BYTES
#undef LOGVIEW_CHUNK
#undef LOGVIEW_PAGE
#undef LOGVIEW_ROUNDS
#undef LOGVIEW_PLAYERS
#undef LOGVIEW_TICK
#undef LOGVIEW_YIELD
#undef LOGVIEW_IDLE
#undef LOGVIEW_LOADING
#undef LOGVIEW_READY
#undef LOGVIEW_HUGE
#undef LOGVIEW_GONE
