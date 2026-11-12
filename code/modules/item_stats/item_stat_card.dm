GLOBAL_LIST_EMPTY(item_stat_cards)
GLOBAL_DATUM(item_preview, /datum/item_preview)

/proc/item_has_stat_card(path)
	if(!ispath(path, /obj/item))
		return FALSE
	if(ispath(path, /obj/item/rogueweapon))
		return TRUE
	if(ispath(path, /obj/item/clothing))
		return TRUE
	if(ispath(path, /obj/item/ammo_casing/caseless/rogue))
		return TRUE
	return FALSE

/proc/get_item_stat_card(path)
	if(!item_has_stat_card(path))
		return null
	var/key = "[path]"
	var/list/card = GLOB.item_stat_cards[key]
	if(card)
		return card
	var/obj/item/sample = new path(null)
	card = sample.build_stat_card()
	qdel(sample)
	GLOB.item_stat_cards[key] = card
	return card

/proc/show_item_stats(mob/user, paths)
	if(!user?.client)
		return FALSE
	var/list/requested = islist(paths) ? paths : list(paths)
	var/list/valid = list()
	for(var/path in requested)
		if(!item_has_stat_card(path))
			continue
		if(path in valid)
			continue
		valid += path
	if(!length(valid))
		return FALSE
	if(!GLOB.item_preview)
		GLOB.item_preview = new /datum/item_preview()
	GLOB.item_preview.show(user, valid)
	return TRUE

/proc/stat_card_row(label, value, tier, max_tier)
	var/list/row = list("label" = label)
	if(!isnull(value))
		row["value"] = "[value]"
	if(!isnull(tier))
		row["tier"] = tier
		row["max_tier"] = max_tier || 4
	return row

/proc/stat_card_speed(clickcd)
	if(clickcd <= CLICK_CD_FAST)
		return "Very Quick"
	if(clickcd <= CLICK_CD_QUICK)
		return "Quick"
	if(clickcd <= CLICK_CD_MELEE)
		return "Normal"
	if(clickcd <= CLICK_CD_CHARGED)
		return "Sluggish"
	if(clickcd <= CLICK_CD_HEAVY)
		return "Very Sluggish"
	if(clickcd <= CLICK_CD_MASSIVE)
		return "Extremely Sluggish"
	return "Glacial"

/proc/stat_card_intents(list/intents)
	var/list/out = list()
	for(var/entry in intents)
		var/datum/intent/intent_path = entry
		if(istype(entry, /datum/intent))
			var/datum/intent/instance = entry
			intent_path = instance.type
		if(!ispath(intent_path, /datum/intent))
			continue
		var/datum/intent/intent = new intent_path()
		var/list/rows = list()
		if(intent.reach != 1)
			rows += list(stat_card_row("Reach", "[intent.reach] paces"))
		if(intent.effective_range)
			var/suffix
			switch(intent.effective_range_type)
				if(EFF_RANGE_EXACT)
					suffix = "exactly"
				if(EFF_RANGE_ABOVE)
					suffix = "at and beyond"
				if(EFF_RANGE_BELOW)
					suffix = "at and within"
				else
					suffix = "not usable"
			rows += list(stat_card_row("Effective Range", "[suffix] [intent.effective_range] paces"))
		if(intent.damfactor != 1)
			rows += list(stat_card_row("Damage", intent.damfactor))
		if(intent.penfactor > PEN_NONE)
			rows += list(stat_card_row("Armor Penetration", uppertext(intent.item_d_type), clamp(intent.penfactor, 0, 4), 4))
		else
			rows += list(stat_card_row("Armor Penetration", "NONE"))
		if(intent.get_chargetime())
			rows += list(stat_card_row("Charge Time"))
		if(intent.movement_interrupt)
			rows += list(stat_card_row("Interrupted by Movement"))
		if(intent.no_early_release)
			rows += list(stat_card_row("No Early Release"))
		if(intent.chargedrain)
			rows += list(stat_card_row("Drain While Charged", intent.chargedrain))
			if(intent.hold_grace)
				rows += list(stat_card_row("Free Hold", DisplayTimeText(intent.get_hold_grace())))
		if(intent.releasedrain)
			rows += list(stat_card_row("Drain On Release", intent.releasedrain))
		if(intent.misscost)
			rows += list(stat_card_row("Drain On Miss", intent.misscost))
		rows += list(stat_card_row("Attack Speed", stat_card_speed(intent.clickcd)))
		if(!intent.allow_offhand)
			rows += list(stat_card_row("This intent requires a free off-hand."))
		if(intent.blade_class == BCLASS_EFFECT)
			rows += list(stat_card_row("This intent will apply a status effect on a successful hit. Damage dealt is not required."))
			if(length(intent.target_parts))
				var/parts_text = ""
				for(var/part in intent.target_parts)
					parts_text += "|[bodyzone2readablezone(part)]|"
				rows += list(stat_card_row("Works on these bodyparts", parts_text))
		if(intent.intent_intdamage_factor != 1)
			rows += list(stat_card_row("Integrity[intent.intent_intdamage_factor < 1 ? " / Part" : ""] Damage", "[intent.intent_intdamage_factor * 100]%"))
		if(intent.demolition_mod != 1)
			rows += list(stat_card_row("Demolition Modifier", "[intent.demolition_mod * 100]%"))
		if(intent.sharpness_penalty)
			rows += list(stat_card_row("This intent will cost some sharpness for every attack made."))
		if(intent.swingdelay > 0)
			var/delay_text = "Heavy"
			if(intent.swingdelay <= 4)
				delay_text = "Moderate"
			else if(intent.swingdelay <= 8)
				delay_text = "Significant"
			switch(intent.swingdelay_type)
				if(SWINGDELAY_NORMAL)
					delay_text += " | Type: Normal"
				if(SWINGDELAY_PENALTY)
					delay_text += " | Type: Difficult"
				if(SWINGDELAY_CANCEL, SWINGDELAY_CANCELSLOW)
					delay_text += " | Type: Rigid"
			rows += list(stat_card_row("Attack Delay", delay_text))
		var/pattern = null
		var/datum/cleave_pattern/cleave = intent.cleave
		if(istype(cleave))
			rows += list(stat_card_row("Cleave", cleave.desc))
			rows += list(stat_card_row("Max additional targets", cleave.max_targets ? cleave.max_targets : "Unlimited"))
			rows += list(stat_card_row("Prioritizes living targets over dead."))
			if(cleave.diagonal_desc)
				rows += list(stat_card_row(cleave.diagonal_desc))
			pattern = cleave.get_pattern_display()
		out += list(list(
			"name" = "[intent.name] intent",
			"desc" = intent.desc,
			"rows" = rows,
			"pattern" = pattern,
		))
		qdel(intent)
	return out

/obj/item/proc/build_stat_card()
	var/list/card = list()
	card["name"] = name
	card["desc"] = desc
	card["icon"] = "[icon]"
	card["icon_state"] = icon_state
	var/list/stats = list()
	if(minstr)
		stats += list(stat_card_row("MIN.STR", minstr))
	if(minstr_req)
		stats += list(stat_card_row("NO HALVING ON WIELD"))
	if(force)
		stats += list(stat_card_row("FORCE", "[get_force_string(force_dynamic)] ([force_dynamic])"))
	if(gripped_intents && force_wielded)
		stats += list(stat_card_row("WIELDED FORCE", "[get_force_string(force_wielded)] ([force_wielded])"))
	if(wbalance)
		stats += list(stat_card_row("BALANCE", get_altgrip_balance(wbalance)))
	if(wlength != WLENGTH_NORMAL)
		stats += list(stat_card_row("LENGTH", get_altgrip_length(wlength)))
	var/shaft_text = get_blade_dulling_text(src, verbose = TRUE)
	if(shaft_text)
		stats += list(stat_card_row("SHAFT", shaft_text))
	if(gripped_intents)
		stats += list(stat_card_row("TWO-HANDED"))
	if(twohands_required)
		stats += list(stat_card_row("BULKY"))
	if(can_parry)
		stats += list(stat_card_row("DEFENSE", wdefense_dynamic))
	if(max_blade_int)
		stats += list(stat_card_row("SHARPNESS", "100% ([max_blade_int])"))
	if(intdamage_factor != 1 && force >= 5)
		stats += list(stat_card_row("INTEGRITY DAMAGE", "[intdamage_factor * 100]%"))
	if(antibeast_factor != 1 && force >= 5)
		stats += list(stat_card_row("ANTI-BEAST MODIFIER", "[antibeast_factor * 100]%"))
	if(max_integrity)
		stats += list(stat_card_row("DURABILITY", "100% ([floor(max_integrity - (max_integrity * integrity_failure))])"))
	card["stats"] = stats

	var/list/skills = list()
	if(associated_skill)
		var/datum/skill/primary = associated_skill
		skills += "[initial(primary.name)] (1x)"
	for(var/secondary_path in secondary_skills)
		var/datum/skill/secondary = secondary_path
		skills += "[initial(secondary.name)] ([secondary_skills[secondary_path]]x)"
	card["skills"] = skills
	card["armor"] = list()
	card["coverage"] = list()
	card["groups"] = list()
	card["special"] = null
	return card

/obj/item/rogueweapon/build_stat_card()
	var/list/card = ..()
	var/list/stats = card["stats"]
	var/list/groups = list()
	var/list/base_intents = stat_card_intents(possible_item_intents)
	if(length(base_intents))
		groups += list(list(
			"title" = length(gripped_intents) ? "One-handed" : "Attacks",
			"note" = "",
			"changes" = list(),
			"intents" = base_intents,
		))
	var/list/wielded_intents = stat_card_intents(gripped_intents)
	if(length(wielded_intents))
		groups += list(list(
			"title" = "Two-handed",
			"note" = "",
			"changes" = list(),
			"intents" = wielded_intents,
		))
	if(has_altgrip_modes())
		stats += list(stat_card_row("ALT-GRIP (RCLICK/HOTKEY(B)/CTRL+SCRLWHL)"))
	for(var/index in 1 to length(alt_grips))
		var/datum/alt_grip/grip = get_altgrip_state(index)
		if(!grip)
			continue
		var/trait_text = grip.get_trait_text()
		var/list/notes = list()
		var/datum/skill/grip_skilltype = grip.grip_skilltype(src, null)
		if(grip_skilltype)
			notes += "\[[uppertext(initial(grip_skilltype.name))] ([grip.skill_factor(src, grip_skilltype)]x)\]"
		notes += "Hands: [grip.is_two_handed(src) ? "Two-handed" : "One-handed"]"
		notes += "Required Trait: [trait_text ? trait_text : "None"]"
		var/list/changes = splittext(format_altgrip_stats(grip, grip.get_var_overrides(src)), "<br>")
		groups += list(list(
			"title" = grip.name,
			"note" = jointext(notes, " | "),
			"changes" = changes,
			"intents" = stat_card_intents(grip.get_grip_intents(src)),
		))
	card["groups"] = groups

	if(special)
		var/datum/special_intent/special_path = special
		var/special_name
		var/special_desc
		var/special_range
		var/special_wielding
		if(ispath(special_path))
			special_name = initial(special_path.name)
			special_desc = initial(special_path.desc)
			special_range = initial(special_path.range)
			special_wielding = initial(special_path.requires_wielding)
		else
			special_name = special_path.name
			special_desc = special_path.desc
			special_range = special_path.range
			special_wielding = special_path.requires_wielding
		var/list/special_lines = list()
		if(special_range)
			special_lines += "Max Range: ["\Roman [special_range]"]"
		if(special_wielding)
			special_lines += "Requires wielding if the weapon can be held in two hands."
		special_lines += "This ability can be used by right clicking while in STRONG stance or by using the Special MMB."
		card["special"] = list("name" = special_name, "desc" = special_desc, "lines" = special_lines)

	if(istype(src, /obj/item/rogueweapon/shield))
		var/obj/item/rogueweapon/shield/shield = src
		stats += list(stat_card_row("PASSIVE PROJECTILE BLOCK", "[shield.coverage]%"))
	return card

/obj/item/clothing/build_stat_card()
	var/list/card = ..()
	var/list/stats = card["stats"]
	var/datum/armor/rating = armor
	if(istype(rating) && (rating.blunt || rating.slash || rating.stab || rating.piercing))
		var/list/armor_rows = list()
		armor_rows += list(stat_card_row("ABSORB", "BLUNT", clamp(rating.blunt, 0, 5), 5))
		armor_rows += list(stat_card_row("REDUCE", "BURN", clamp(rating.fire, 0, 5), 5))
		armor_rows += list(stat_card_row("BLOCK", "SLASH", clamp(rating.slash, 0, 4), 4))
		armor_rows += list(stat_card_row("", "STAB", clamp(rating.stab, 0, 4), 4))
		armor_rows += list(stat_card_row("", "PIERCING", clamp(rating.piercing, 0, 4), 4))
		card["armor"] = armor_rows
	else
		card["armor"] = list(stat_card_row("NO ARMOR!"))
	var/list/coverage = list()
	if(body_parts_covered)
		for(var/zone in body_parts_covered2organ_names(body_parts_covered))
			coverage += capitalize(zone)
	card["coverage"] = coverage
	var/class_text = "None"
	var/speed_cap
	switch(armor_class)
		if(ARMOR_CLASS_LIGHT)
			class_text = "Light"
			speed_cap = AC_LIGHT_SPDCAP
		if(ARMOR_CLASS_MEDIUM)
			class_text = "Medium"
			speed_cap = AC_MEDIUM_SPDCAP
		if(ARMOR_CLASS_HEAVY)
			class_text = "Heavy"
			speed_cap = AC_HEAVY_SPDCAP
	stats += list(stat_card_row("ARMOR CLASS", class_text))
	stats += list(stat_card_row("MOVEMENT SPD CAP", speed_cap ? speed_cap : "None"))
	return card

/obj/item/ammo_casing/caseless/rogue/build_stat_card()
	var/list/card = ..()
	var/list/stats = card["stats"]
	if(!BB)
		return card
	if(BB.damage)
		stats += list(stat_card_row("PROJECTILE DAMAGE", BB.damage))
	if(BB.armor_penetration > PEN_NONE)
		stats += list(stat_card_row("Armor Penetration", uppertext("[BB.flag]"), clamp(BB.armor_penetration, 0, 4), 4))
	else
		stats += list(stat_card_row("Armor Penetration", "NONE"))
	if(BB.min_range)
		stats += list(stat_card_row("MINIMUM EFFECTIVE RANGE", "[BB.min_range] tile(s)"))
	if(BB.max_range)
		stats += list(stat_card_row("MAXIMUM EFFECTIVE RANGE", "[BB.max_range] tile(s)"))
	if(BB.dam_falloff_factor)
		stats += list(stat_card_row("DAMAGE FALLOFF", get_falloff_string(BB.dam_falloff_factor)))
	if(BB.antibeast_factor != 1)
		stats += list(stat_card_row("ANTI-BEAST MODIFIER", "[BB.antibeast_factor * 100]%"))
	return card

/datum/item_preview
	var/list/user_states = list()

/datum/item_preview/proc/show(mob/user, list/paths)
	if(!user?.client || !length(paths))
		return
	user_states[user.client.ckey] = list("paths" = paths, "current" = paths[1])
	ui_interact(user)

/datum/item_preview/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ItemPreview", "Item Properties")
		ui.open()
		ui.set_autoupdate(FALSE)

/datum/item_preview/ui_state(mob/user)
	return GLOB.always_state

/datum/item_preview/ui_data(mob/user)
	var/list/data = list()
	var/list/choices = list()
	data["card"] = null
	data["current"] = null
	data["choices"] = choices
	var/ckey = user.client?.ckey
	var/list/state = ckey ? user_states[ckey] : null
	if(!state)
		return data
	var/current = state["current"]
	data["card"] = get_item_stat_card(current)
	data["current"] = "[current]"
	for(var/path in state["paths"])
		var/atom/choice = path
		choices += list(list("path" = "[path]", "name" = initial(choice.name)))
	return data

/datum/item_preview/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/ckey = usr?.client?.ckey
	var/list/user_state = ckey ? user_states[ckey] : null
	if(!user_state)
		return
	if(action == "pick")
		var/path = text2path(params["path"])
		var/list/paths = user_state["paths"]
		if(path && (path in paths))
			user_state["current"] = path
			return TRUE
