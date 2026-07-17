/datum/examine_effect/proc/trigger(mob/user)
	return

/datum/examine_effect/proc/get_examine_line(mob/user)
	return

/proc/title_case(t)
	if(!t)
		return t
	var/list/parts = splittext(t, " ")
	for(var/i in 1 to length(parts))
		parts[i] = capitalize(parts[i])
	return jointext(parts, " ")

/obj/item/proc/quality_examine_suffix()
	if(!has_item_quality)
		return null
	var/qpct = round(ITEM_QUALITY_MULT(item_quality) * 100)
	var/word
	var/style = "info"
	switch(item_quality)
		if(ITEM_QUALITY_LOOTED)
			word = "scavenged"
			style = "warning"
		if(ITEM_QUALITY_RUINED)
			word = "ruined"
			style = "warning"
		if(ITEM_QUALITY_AWFUL)
			word = "awful"
			style = "warning"
		if(ITEM_QUALITY_CRUDE)
			word = "crude"
			style = "warning"
		if(ITEM_QUALITY_ROUGH)
			word = "rough"
		if(ITEM_QUALITY_STANDARD)
			word = "standard"
		if(ITEM_QUALITY_FINE)
			word = "fine"
		if(ITEM_QUALITY_FLAWLESS)
			word = "flawless"
			style = "green"
		if(ITEM_QUALITY_MASTERWORK)
			word = "masterwork"
			style = "green"
	if(!word)
		return null
	return list("text" = "Quality: <b>[capitalize(word)]</b> ([qpct]% value)", "style" = style)

/obj/item/examine(mob/user)
	. = ..()
	. += integrity_check()

	var/derived_cat = GLOB.derived_categories ? GLOB.derived_categories[type] : null
	var/display_cat = derived_cat
	if(derived_cat)
		var/bucket = get_navigator_bucket_for_item(src, derived_cat)
		if(bucket && bucket != NAVIGATOR_BUCKET_REFUSED_FOOD && bucket != NAVIGATOR_BUCKET_REFUSED_BULK)
			display_cat = bucket
	var/list/quality_data = quality_examine_suffix()
	var/cat_tag = display_cat ? "<b>[display_cat]</b>" : ""

	// The price traits gate ONLY the mammon value - category and quality are always shown.
	var/value_line = "Value: Unknown"
	if(HAS_TRAIT(user, TRAIT_SEEPRICES) || simpleton_price || isobserver(user))
		var/appraised_value = appraise_price()
		if(appraised_value > 0)
			value_line = "Value: [appraised_value] mammon"
	else if(HAS_TRAIT(user, TRAIT_SEEPRICES_SHITTY))
		var/real_value = appraise_price()
		if(real_value > 0)
			var/static/fumbling_seed = text2num(GLOB.rogue_round_id)
			var/fumbled_value = max(1, round(real_value + (real_value * clamp(noise_hash(real_value, fumbling_seed) - 0.25, -0.25, 0.25)), 1))
			value_line = "Value: ~[fumbled_value] mammon (uncertain)"

	// Category always rides along with the value line.
	. += span_info("[value_line][cat_tag ? " - [cat_tag]" : ""].")

	if(quality_data)
		switch(quality_data["style"])
			if("warning")
				. += span_warning("[quality_data["text"]].")
			if("green")
				. += span_green("[quality_data["text"]].")
			else
				. += span_info("[quality_data["text"]].")

	var/list/seals = list()
	if(atc_sealed)
		seals += "ATC seal"
	if(unmintable)
		seals += "town-property stamp"
	if(length(seals))
		. += span_info("Marked with [english_list(seals)] - the navigator will not take it.")
	else if(was_crafted)
		. += span_info("It appears to be crafted by the hand of a local artisan.")
	else if(is_carved)
		. += span_info("It is a carved item.")

	var/show_craft = TRUE
	if(isliving(user))
		var/mob/living/L = user
		if(L.STAINT < 9)
			show_craft = FALSE
	if(show_craft)
		var/list/craft_lines = list()
		if(anvilrepair)
			var/datum/skill/S = anvilrepair
			craft_lines += "Repair: Hammer (<b>[initial(S.name)]</b>)"
		if(sewrepair)
			craft_lines += "Repair: Needle (<b>Sewing</b>)"
		if(salvage_result && salvage_amount && sewrepair)
			var/atom/A = salvage_result
			craft_lines += "Salvage: <b>[salvage_amount] [title_case(initial(A.name))]</b> (scissors)"
		if(smeltresult)
			var/obj/item/smelted = smeltresult
			craft_lines += "Smelt: <b>[title_case(initial(smelted.name))]</b>"
		if(length(craft_lines))
			. += span_info(craft_lines.Join(" - "))

	. += span_info(weight_tier_examine_line())

	var/examine_highlight_status = get_examine_highlight_status()
	if(examine_highlight_status)
		var/severity = examine_highlight_status[1]
		var/heresy_desc = get_examine_highlight_description(examine_highlight_status, itis = TRUE, allcaps = FALSE)
		var/heresy_tooltip = get_examine_highlight_explanation(severity)
		. += span_info(SPAN_TOOLTIP_DANGEROUS_HTML(heresy_tooltip, heresy_desc))

	for(var/datum/examine_effect/E in examine_effects)
		E.trigger(user)

/obj/item/proc/integrity_check(elaborate = FALSE)
	if(!max_integrity)
		return
	if(obj_integrity == max_integrity)
		return

	var/int_percent = round(((obj_integrity / max_integrity) * 100), 1)
	var/result
	if(elaborate && int_percent < 100)
		return span_warning("([int_percent]%)")
	if(obj_broken)
		return span_warning("It's broken.")
	switch(int_percent)
		if(1 to 15)
			result = span_warning("It's nearly broken.")
		if(16 to 30)
			result = span_warning("It's severely damaged.")
		if(31 to 80)
			result = span_warning("It's damaged.")
		if(80 to 99)
			result = span_warning("It's a little damaged.")
	return result

/obj/item/clothing/integrity_check(elaborate = FALSE, guarded = FALSE)
	if(obj_broken)
		return span_warning("It's broken.")

	if(guarded)
		return ""

	var/eff_maxint = max_integrity - (max_integrity * integrity_failure)
	var/eff_currint = max(obj_integrity - (max_integrity * integrity_failure), 0)
	var/ratio =	(eff_currint / eff_maxint)
	var/percent = round((ratio * 100), 1)
	var/result
	if(percent < 100)
		if(elaborate)
			return span_warning("([percent]%)")
		else
			switch(percent)
				if(1 to 15)
					result = span_warning("It's nearly broken.")
				if(16 to 30)
					result = span_warning("It's severely damaged.")
				if(31 to 80)
					result = span_warning("It's damaged.")
				if(80 to 99)
					result = span_warning("It's a little damaged.")
	return result
	