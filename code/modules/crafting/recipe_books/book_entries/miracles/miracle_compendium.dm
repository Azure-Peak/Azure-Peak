GLOBAL_LIST_EMPTY(miracle_registry)

/proc/build_miracle_registry()
	if(length(GLOB.miracle_registry))
		return
	for(var/patron_type in subtypesof(/datum/patron))
		var/datum/patron/P = new patron_type()
		if(!length(P.miracles))
			qdel(P)
			continue
		for(var/spell_path in P.miracles)
			var/tier = P.miracles[spell_path]
			var/path_key = "[spell_path]"
			if(!GLOB.miracle_registry[path_key])
				GLOB.miracle_registry[path_key] = list()
			GLOB.miracle_registry[path_key] += list(list("patron" = P.name, "tier" = tier))
		qdel(P)

/proc/generate_miracle_granted_html(spell_path)
	var/path_key = "[spell_path]"
	var/list/patrons = GLOB.miracle_registry[path_key]
	if(!length(patrons))
		return ""

	var/html = {"
		<h3>Granted By</h3>
		<table>
			<tr><th>Patron</th><th>Tier</th></tr>
	"}
	var/list/sorted_patrons = sortTim(patrons, GLOBAL_PROC_REF(cmp_miracle_patron_tier))
	for(var/list/entry in sorted_patrons)
		var/tier_label = cleric_tier_to_string(entry["tier"])
		html += "<tr><td>[entry["patron"]]</td><td>[tier_label]</td></tr>"
	html += "</table>"
	return html

/proc/cmp_miracle_patron_tier(list/a, list/b)
	if(a["tier"] != b["tier"])
		return a["tier"] - b["tier"]
	return sorttext(b["patron"], a["patron"])

/proc/cleric_tier_to_string(tier_val)
	switch(tier_val)
		if(-1)
			return "Orison"
		if(0)
			return "Tier 0"
		if(1)
			return "Tier 1"
		if(2)
			return "Tier 2"
		if(3)
			return "Tier 3"
		if(4)
			return "Tier 4"
	return "Unknown"

/proc/cleric_tier_to_short(tier_val)
	switch(tier_val)
		if(-1)
			return "Ori"
		if(0)
			return "T0"
		if(1)
			return "T1"
		if(2)
			return "T2"
		if(3)
			return "T3"
		if(4)
			return "T4"
	return "?"
