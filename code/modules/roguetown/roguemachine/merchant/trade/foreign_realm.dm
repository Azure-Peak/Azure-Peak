/datum/foreign_realm
	var/id
	var/name
	var/auto_discovered = FALSE
	var/roll_weight = TRADE_REALM_WEIGHT_DEFAULT
	var/list/ship_name_words = list()
	/// If TRUE, compound ship names use a single word instead of two (e.g. "Sakura-Maru" not "Sakura Sora-Maru").
	var/single_word_base = FALSE
	var/list/proper_names = list()
	var/list/captain_first_names = list()
	var/list/captain_last_names = list()
	var/list/ship_types = list()
	/// Entries support text / text_male+text_female / requires_proper_name. First entry whose chance fires wins.
	var/list/name_prefixes = list()
	var/list/name_suffixes = list()
	var/list/city_tags = list()
	var/city_tag_chance = 0
	var/list/cultural_goods = list()
	var/list/bulk_demand_pool = list()
	var/list/bulk_supply_pool = list()
	var/list/cultural_stock_pool = list()

/datum/foreign_realm/proc/pick_ship_type()
	if(!length(ship_types))
		return null
	var/list/weighted = list()
	for(var/list/entry as anything in ship_types)
		weighted[entry] = entry["weight"] || 1
	return pickweight(weighted)

/datum/foreign_realm/proc/generate_ship_name()
	var/list/picked_prefix = pick_prefix()
	var/base
	var/picked_gender
	if(picked_prefix && picked_prefix["requires_proper_name"] && length(proper_names))
		var/list/eligible = filter_proper_names_for_prefix(picked_prefix)
		var/list/proper = length(eligible) ? pick(eligible) : pick(proper_names)
		if(islist(proper))
			base = proper["name"]
			picked_gender = proper["gender"]
		else
			base = proper
	else
		base = make_compound_name()
	var/prefix_text = ""
	if(picked_prefix)
		if(picked_gender == "f" && picked_prefix["text_female"])
			prefix_text = picked_prefix["text_female"]
		else if(picked_gender == "m" && picked_prefix["text_male"])
			prefix_text = picked_prefix["text_male"]
		else if(picked_prefix["text"])
			prefix_text = picked_prefix["text"]
		else if(picked_prefix["text_male"])
			prefix_text = picked_prefix["text_male"]
	var/suffix_text = roll_simple_affix(name_suffixes)
	return "[prefix_text][base][suffix_text]"

/datum/foreign_realm/proc/generate_port_of_origin()
	if(!length(city_tags) || !prob(city_tag_chance))
		return ""
	return pick(city_tags)

/datum/foreign_realm/proc/filter_proper_names_for_prefix(list/prefix)
	var/has_male = !!prefix["text_male"]
	var/has_female = !!prefix["text_female"]
	var/has_neutral = !!prefix["text"]
	if(has_neutral && has_male && has_female)
		return proper_names
	var/list/out = list()
	for(var/list/entry as anything in proper_names)
		var/g = islist(entry) ? entry["gender"] : null
		if(!g)
			if(has_neutral)
				out += list(entry)
			continue
		if(g == "m" && has_male)
			out += list(entry)
		else if(g == "f" && has_female)
			out += list(entry)
	return out

/datum/foreign_realm/proc/make_compound_name()
	if(!length(ship_name_words))
		return "Vessel"
	if(single_word_base || length(ship_name_words) == 1)
		return pick(ship_name_words)
	var/word_a = pick(ship_name_words)
	var/word_b = pick(ship_name_words)
	while(word_b == word_a)
		word_b = pick(ship_name_words)
	return "[word_a] [word_b]"

/datum/foreign_realm/proc/pick_prefix()
	if(!length(name_prefixes))
		return null
	for(var/list/entry as anything in name_prefixes)
		var/chance = entry["chance"] || 0
		if(chance > 0 && prob(chance))
			return entry
	return null

/datum/foreign_realm/proc/roll_simple_affix(list/affixes)
	if(!length(affixes))
		return ""
	for(var/list/entry as anything in affixes)
		var/chance = entry["chance"] || 0
		if(chance > 0 && prob(chance))
			return entry["text"]
	return ""

/datum/foreign_realm/proc/generate_captain_name()
	var/first = length(captain_first_names) ? pick(captain_first_names) : "Unnamed"
	var/last = length(captain_last_names) ? pick(captain_last_names) : "Captain"
	return "[first] [last]"
