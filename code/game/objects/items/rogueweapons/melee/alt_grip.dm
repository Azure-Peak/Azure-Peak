/obj/item/proc/has_altgrip_modes()
	return length(alt_grips) > 0

/obj/item/proc/knows_altgrip(mob/user)
	if(!associated_skill || !istype(user, /mob/living/carbon))
		return FALSE
	var/mob/living/carbon/carbon_user = user
	return carbon_user.get_skill_level(associated_skill) >= SKILL_LEVEL_JOURNEYMAN

/obj/item/proc/get_altgrip_holder()
	if(istype(loc, /mob/living/carbon))
		return loc
	return null

/obj/item/proc/can_see_altgrip_name(mob/viewer, mob/living/carbon/wielder = null)
	if(!wielder)
		wielder = get_altgrip_holder()
	if(wielder && HAS_TRAIT(wielder, TRAIT_DECEIVING_MEEKNESS))
		return FALSE
	if(viewer && HAS_TRAIT(viewer, TRAIT_COMBAT_AWARE))
		return TRUE
	return knows_altgrip(viewer)

/obj/item/proc/altgrip_name(datum/alt_grip/grip, mob/user, mob/living/carbon/wielder = null)
	if(!grip)
		return "alternate grip"
	if(!can_see_altgrip_name(user, wielder))
		return "alternate grip"
	if(grip.name)
		return grip.name
	return "alternate grip"

/obj/item/proc/get_altgrip_names(mob/user)
	if(!has_altgrip_modes())
		return null
	var/list/grip_names = list()
	for(var/index in 1 to length(alt_grips))
		var/datum/alt_grip/grip = get_altgrip_state(index)
		if(!grip?.usable_by(src, user))
			continue
		var/grip_name = altgrip_name(grip, user)
		var/required_traits_text = grip.get_trait_text()
		if(required_traits_text)
			grip_name += span_info(" [required_traits_text]")
		if(grip.is_two_handed(src))
			grip_name += span_danger(" (2H)")
		grip_names += grip_name
	if(!length(grip_names))
		return null
	return jointext(grip_names, ", ")

/obj/item/proc/get_altgrip_lines(atom/link_source, mob/user, href_key = "showaltgrip")
	if(!has_altgrip_modes())
		return null
	var/list/lines = list()
	for(var/index in 1 to length(alt_grips))
		var/datum/alt_grip/grip = get_altgrip_state(index)
		if(!grip)
			continue
		var/list/parts = list()
		parts += "<span style='margin-left: 1.2em'>- <b>[altgrip_name(grip, user)]</b></span>"
		parts += "<span class='info'><a href='?src=[REF(link_source)];[href_key]=[index]'>{?}</a></span>"
		if(grip.is_two_handed(src))
			parts += span_danger("(2H)")
		else
			parts += span_notice("(1H)")
		var/required_traits_text = grip.get_trait_text()
		if(required_traits_text)
			parts += span_info(required_traits_text)
		if(!grip.usable_by(src, user))
			parts += span_danger("(Unavailable)")
		lines += jointext(parts, " ")
	if(!length(lines))
		return null
	return lines

/obj/item/proc/show_altgrip(mob/user, index)
	var/output = get_altgrip_text(user, index)
	if(!output)
		return FALSE
	output = span_info(output)
	if(user?.client && !user.client.prefs.no_examine_blocks)
		output = examine_block(output)
	to_chat(user, output)
	return TRUE

/obj/item/proc/get_altgrip_text(mob/user, index)
	if(!has_altgrip_modes())
		return null
	if(!isnum(index))
		index = text2num("[index]")
	if(!index)
		return null
	var/datum/alt_grip/grip = get_altgrip_state(index)
	if(!grip)
		return null
	var/list/overrides = grip.get_var_overrides(src)
	var/list/text = list()
	text += "<b>[altgrip_name(grip, user)]</b>"
	text += "<br><b>Hands:</b> [grip.is_two_handed(src) ? "Two-handed" : "One-handed"]"
	var/trait_text = grip.get_trait_text()
	text += "<br><b>Required Trait:</b> [trait_text ? trait_text : "None"]"
	var/skill_text = grip.get_skill_text(src)
	text += "<br><b>Weapon Skill:</b> [skill_text ? skill_text : "None"]"
	text += "<br><b>Intents:</b> [format_altgrip_intents(grip.get_grip_intents(src))]"
	text += "<br><b>Weapon Stat Changes:</b> [format_altgrip_stats(grip, overrides)]"
	return text.Join("")

/obj/item/proc/format_altgrip_intents(list/intents)
	if(!length(intents))
		return "Uses the weapon's normal intents."
	var/list/intent_lines = list()
	for(var/intent_entry as anything in intents)
		intent_lines += format_altgrip_intent(intent_entry)
	return jointext(intent_lines, "<br>")

/obj/item/proc/format_altgrip_intent(intent_entry)
	var/intent_name = "Unknown"
	var/damfactor = 1
	var/penfactor = PEN_NONE
	var/reach = 1
	var/item_d_type = "blunt"
	if(ispath(intent_entry, /datum/intent))
		var/datum/intent/intent_path = intent_entry
		intent_name = initial(intent_path.name)
		damfactor = initial(intent_path.damfactor)
		penfactor = initial(intent_path.penfactor)
		reach = initial(intent_path.reach)
		item_d_type = initial(intent_path.item_d_type)
	else if(istype(intent_entry, /datum/intent))
		var/datum/intent/intent_datum = intent_entry
		intent_name = intent_datum.name
		damfactor = intent_datum.damfactor
		penfactor = intent_datum.penfactor
		reach = intent_datum.reach
		item_d_type = intent_datum.item_d_type
	var/list/details = list("[intent_name]")
	if(damfactor != 1)
		details += "Damage x[damfactor]"
	if(penfactor > PEN_NONE)
		details += "AP [colorgrade_rating(uppertext(item_d_type), penfactor)]"
	else
		details += "AP <font color='#808080'>NONE</font>"
	if(reach != 1)
		details += "Reach [reach]"
	return jointext(details, " | ")

/obj/item/proc/format_altgrip_stats(datum/alt_grip/grip, list/overrides)
	var/list/stat_lines = list()
	var/base_force = get_altgrip_base_value("force", force)
	var/grip_force = get_altgrip_force(grip, overrides)
	if(grip_force != base_force)
		stat_lines += "Force: [base_force] -> [grip_force]"
	var/base_defense = get_altgrip_base_value("wdefense", wdefense)
	var/grip_defense = get_altgrip_defense(grip, overrides)
	if(grip_defense != base_defense)
		stat_lines += "Defense: [base_defense] -> [grip_defense]"
	var/base_length = get_altgrip_base_value("wlength", wlength)
	var/grip_length = get_altgrip_value(overrides, "wlength", base_length)
	if(grip_length != base_length)
		stat_lines += "Length: [get_altgrip_length(base_length)] -> [get_altgrip_length(grip_length)]"
	var/base_balance = get_altgrip_base_value("wbalance", wbalance)
	var/grip_balance = get_altgrip_value(overrides, "wbalance", base_balance)
	if(grip_balance != base_balance)
		stat_lines += "Balance: [get_altgrip_balance(base_balance)] -> [get_altgrip_balance(grip_balance)]"
	if(!length(stat_lines))
		return "No direct weapon stat changes."
	return jointext(stat_lines, "<br>")

/obj/item/proc/get_altgrip_base_value(var_name, fallback)
	if(length(alt_grip_restore_vars) && (var_name in alt_grip_restore_vars))
		return alt_grip_restore_vars[var_name]
	return fallback

/obj/item/proc/get_altgrip_force(datum/alt_grip/grip, list/overrides)
	var/base_force = get_altgrip_base_value("force", force)
	var/grip_force = get_altgrip_value(overrides, "force", base_force)
	return grip_force

/obj/item/proc/get_altgrip_defense(datum/alt_grip/grip, list/overrides)
	var/base_defense = get_altgrip_base_value("wdefense", wdefense)
	var/grip_defense = get_altgrip_value(overrides, "wdefense", base_defense)
	return grip_defense

/obj/item/proc/get_altgrip_value(list/overrides, var_name, fallback)
	if(islist(overrides) && (var_name in overrides))
		return overrides[var_name]
	return fallback

/obj/item/proc/get_altgrip_length(length_value)
	switch(length_value)
		if(WLENGTH_SHORT)
			return "Short"
		if(WLENGTH_LONG)
			return "Long"
		if(WLENGTH_GREAT)
			return "Great"
	return "Normal"

/obj/item/proc/get_altgrip_balance(balance_value)
	switch(balance_value)
		if(WBALANCE_HEAVY)
			return "Heavy"
		if(WBALANCE_SWIFT)
			return "Swift"
	return "Normal"

/obj/item/proc/get_altgrip_intents()
	if(!current_alt_grip)
		return possible_item_intents
	var/list/intents = current_alt_grip.get_grip_intents(src)
	if(length(intents))
		return intents
	return possible_item_intents


/obj/item/proc/get_altgrip_message(mob/user)
	if(!current_alt_grip)
		return null
	var/grip_name = altgrip_name(current_alt_grip, user)
	var/two_handed_text = ""
	if(current_alt_grip.is_two_handed(src))
		two_handed_text = " with both hands"
	if(grip_name)
		if(grip_name == "alternate grip")
			return "I shift [src] into an [grip_name][two_handed_text]."
		return "I shift [src] into a [grip_name][two_handed_text]."

/obj/item/proc/get_altgrip_balloon(mob/user)
	if(!current_alt_grip)
		return "normal grip"
	var/balloon_name = altgrip_name(current_alt_grip, user)
	if(balloon_name != "alternate grip")
		if(length(balloon_name) > 5 && lowertext(copytext(balloon_name, length(balloon_name) - 4)) == " grip")
			balloon_name = copytext(balloon_name, 1, length(balloon_name) - 4)
	return "[balloon_name]!"

/obj/item/proc/altgrip_balloon_text(text)
	if(!text)
		return null
	return "<font color='#cc9900'>[text]</font>"

/obj/item/proc/can_see_altgrip_balloon(mob/living/carbon/viewer, mob/living/carbon/user)
	if(!viewer || !user || viewer == user)
		return FALSE
	if(HAS_TRAIT(user, TRAIT_DECEIVING_MEEKNESS))
		return FALSE
	if(HAS_TRAIT(viewer, TRAIT_COMBAT_AWARE))
		return TRUE
	return knows_altgrip(viewer)

/obj/item/proc/show_altgrip_balloon(mob/living/carbon/user, message = null)
	if(!user)
		return
	var/self_message = message
	if(!message)
		self_message = get_altgrip_balloon(user)
	if(!self_message)
		return
	self_message = altgrip_balloon_text(self_message)
	user.balloon_alert(user, self_message)
	for(var/mob/living/carbon/human/viewer in get_hearers_in_view(DEFAULT_MESSAGE_RANGE, user, RECURSIVE_CONTENTS_CLIENT_MOBS))
		if(!can_see_altgrip_balloon(viewer, user))
			continue
		user.balloon_alert(viewer, self_message)

/obj/item/proc/get_altgrip_state(index)
	if(!length(alt_grips))
		return null
	var/entry = alt_grips[index]
	if(ispath(entry, /datum/alt_grip))
		entry = new entry()
		alt_grips[index] = entry
	if(istype(entry, /datum/alt_grip))
		return entry
	return null

/obj/item/proc/set_altgrip_state(index)
	if(!length(alt_grips))
		return FALSE
	var/datum/alt_grip/state = get_altgrip_state(index)
	if(!state)
		return FALSE
	if(!state.is_two_handed(src) && wielded)
		clear_grip_state()
	else
		clear_altgrip_state()
	current_alt_grip = state
	current_alt_grip_index = index
	state.apply_to(src)
	wielded = state.is_two_handed(src)
	clear_altgrip_onmob()
	update_force_dynamic()
	update_wdefense_dynamic()
	return TRUE

/obj/item/proc/clear_altgrip_state()
	if(current_alt_grip)
		current_alt_grip.remove_from(src)
	if(length(alt_grip_restore_vars))
		for(var/var_name in alt_grip_restore_vars)
			vars[var_name] = alt_grip_restore_vars[var_name]
	alt_grip_restore_vars = null
	current_alt_grip = null
	current_alt_grip_index = 0
	clear_altgrip_onmob()
	update_force_dynamic()
	update_wdefense_dynamic()

/obj/item/proc/clear_altgrip_onmob()
	if(!onprop)
		return
	onprop.Remove("altgrip")


/datum/alt_grip
	var/name = "alternate grip"
	/// Whether this grip state counts as being wielded with both hands.
	var/two_handed = FALSE
	/// Intents exposed while this grip state is active.
	var/list/grip_intents
	/// Traits that allow a mob to use this grip state. Null means unrestricted.
	var/list/trait_applied = null
	/// Minimum associated weapon skill level required to use this grip. SKILL_LEVEL_NONE means unrestricted.
	var/skill_req = SKILL_LEVEL_NONE
	/// On-mob sprite prop overrides keyed by the requested getonmobprop tag.
	var/list/onmobprop_overrides
	/// Map of item var names to replacement override values applied while this state is active.
	var/list/var_overrides
	/// Map of item var names to additive override values applied on top of the item's base values.
	var/list/additive_var_overrides

/datum/alt_grip/proc/get_grip_intents(obj/item/source)
	if(!grip_intents)
		return null
	return grip_intents.Copy()

/datum/alt_grip/proc/is_two_handed(obj/item/source)
	return two_handed

/datum/alt_grip/proc/usable_by(obj/item/source, mob/living/carbon/user)
	if(length(trait_applied))
		if(!user)
			return FALSE
		var/has_trait = FALSE
		for(var/trait in trait_applied)
			if(HAS_TRAIT(user, trait))
				has_trait = TRUE
				break
		if(!has_trait)
			return FALSE
	if(skill_req)
		if(!user || !source?.associated_skill)
			return FALSE
		if(user.get_skill_level(source.associated_skill) < skill_req)
			return FALSE
	return TRUE

/datum/alt_grip/proc/get_trait_text()
	if(!length(trait_applied))
		return null
	return "([jointext(trait_applied, "/")])"

/datum/alt_grip/proc/get_skill_text(obj/item/source)
	if(!skill_req)
		return null
	if(!source?.associated_skill)
		return skill_to_string(skill_req)
	if(ispath(source.associated_skill, /datum/skill))
		var/datum/skill/skill_path = source.associated_skill
		return "[initial(skill_path.name)]: [skill_to_string(skill_req)]"
	if(istype(source.associated_skill, /datum/skill))
		var/datum/skill/skill_datum = source.associated_skill
		return "[skill_datum.name]: [skill_to_string(skill_req)]"
	return skill_to_string(skill_req)

/datum/alt_grip/proc/getonmobprop(obj/item/source, tag)
	if(!tag || !onmobprop_overrides)
		return null
	var/list/prop = onmobprop_overrides[tag]
	if(!islist(prop))
		return null
	return prop.Copy()

/datum/alt_grip/proc/get_var_overrides(obj/item/source)
	if(!var_overrides && !additive_var_overrides)
		return null
	var/list/overrides = var_overrides ? var_overrides.Copy() : list()
	if(length(additive_var_overrides))
		for(var/var_name in additive_var_overrides)
			var/base_value = get_override_base_value(source, var_name, overrides)
			var/additive_value = additive_var_overrides[var_name]
			if(isnum(base_value) && isnum(additive_value))
				overrides[var_name] = base_value + additive_value
			else
				overrides[var_name] = additive_value
	return overrides

/datum/alt_grip/proc/get_override_base_value(obj/item/source, var_name, list/overrides = null)
	if(islist(overrides) && (var_name in overrides))
		return overrides[var_name]
	if(source?.alt_grip_restore_vars && (var_name in source.alt_grip_restore_vars))
		return source.alt_grip_restore_vars[var_name]
	if(source)
		return source.vars[var_name]
	return null

/datum/alt_grip/proc/apply_to(obj/item/source)
	var/list/overrides = get_var_overrides(source)
	if(!length(overrides))
		return
	if(!source.alt_grip_restore_vars)
		source.alt_grip_restore_vars = list()
	for(var/override_name in overrides)
		if(!(override_name in source.alt_grip_restore_vars))
			source.alt_grip_restore_vars[override_name] = source.vars[override_name]
		var/new_value = overrides[override_name]
		if(islist(new_value))
			var/list/override_list = new_value
			source.vars[override_name] = override_list.Copy()
		else
			source.vars[override_name] = new_value

/datum/alt_grip/proc/remove_from(obj/item/source)
	return


/datum/alt_grip/mordhau
	name = "mordhau"
	two_handed = TRUE

/datum/alt_grip/mordhau/sword
	grip_intents = list(
		/datum/intent/sword/strike,
		/datum/intent/sword/bash,
		/datum/intent/effect/daze
	)
	onmobprop_overrides = list(
		"altgrip" = list(
			"shrink" = 0.6,
			"sx" = 2,
			"sy" = 3,
			"nx" = -7,
			"ny" = 1,
			"wx" = -8,
			"wy" = 0,
			"ex" = 8,
			"ey" = -1,
			"northabove" = 0,
			"southabove" = 1,
			"eastabove" = 1,
			"westabove" = 0,
			"nturn" = -135,
			"sturn" = -35,
			"wturn" = 45,
			"eturn" = 145,
			"nflip" = 8,
			"sflip" = 8,
			"wflip" = 1,
			"eflip" = 0,
		),
	)
	var_overrides = list(
		"wlength" = WLENGTH_SHORT
	)

/datum/alt_grip/mordhau/sword/frei

/datum/alt_grip/mordhau/broadsword
	grip_intents = list(
		/datum/intent/sword/strike,
		/datum/intent/sword/bash,
		/datum/intent/effect/daze,
		/datum/intent/sword/cut/broadsword
	)
	onmobprop_overrides = list(
		"altgrip" = list(
			"shrink" = 0.6,
			"sx" = 2,
			"sy" = 3,
			"nx" = -7,
			"ny" = 1,
			"wx" = -8,
			"wy" = 0,
			"ex" = 8,
			"ey" = -1,
			"northabove" = 0,
			"southabove" = 1,
			"eastabove" = 1,
			"westabove" = 0,
			"nturn" = -135,
			"sturn" = -35,
			"wturn" = 45,
			"eturn" = 145,
			"nflip" = 8,
			"sflip" = 8,
			"wflip" = 1,
			"eflip" = 0,
		),
	)

/datum/alt_grip/mordhau/greatsword
	grip_intents = list(
		/datum/intent/sword/strike,
		/datum/intent/sword/bash,
		/datum/intent/effect/daze
	)
	onmobprop_overrides = list(
		"altgrip" = list(
			"shrink" = 0.6,
			"sx" = 4,
			"sy" = 0,
			"nx" = -7,
			"ny" = 1,
			"wx" = -8,
			"wy" = 0,
			"ex" = 8,
			"ey" = -1,
			"northabove" = 0,
			"southabove" = 1,
			"eastabove" = 1,
			"westabove" = 0,
			"nturn" = -135,
			"sturn" = -35,
			"wturn" = 45,
			"eturn" = 145,
			"nflip" = 8,
			"sflip" = 8,
			"wflip" = 1,
			"eflip" = 0,
		),
	)
	var_overrides = list(
		"wlength" = WLENGTH_NORMAL
	)

/datum/alt_grip/mordhau/broadsword/forgotten_blade
	grip_intents = list(
		/datum/intent/effect/daze,
		/datum/intent/sword/strike,
		/datum/intent/sword/bash
	)
	onmobprop_overrides = list(
		"altgrip" = list(
			"shrink" = 0.6,
			"sx" = 4,
			"sy" = 0,
			"nx" = -7,
			"ny" = 1,
			"wx" = -8,
			"wy" = 0,
			"ex" = 8,
			"ey" = -1,
			"northabove" = 0,
			"southabove" = 1,
			"eastabove" = 1,
			"westabove" = 0,
			"nturn" = -135,
			"sturn" = -35,
			"wturn" = 45,
			"eturn" = 145,
			"nflip" = 8,
			"sflip" = 8,
			"wflip" = 1,
			"eflip" = 0,
		),
	)
	var_overrides = null

/datum/alt_grip/mordhau/broadsword/dream_broadsword
	grip_intents = list(
		/datum/intent/effect/daze,
		/datum/intent/sword/strike,
		/datum/intent/sword/bash
	)
	onmobprop_overrides = list(
		"altgrip" = list(
			"shrink" = 0.6,
			"sx" = 4,
			"sy" = 0,
			"nx" = -7,
			"ny" = 1,
			"wx" = -8,
			"wy" = 0,
			"ex" = 8,
			"ey" = -1,
			"northabove" = 0,
			"southabove" = 1,
			"eastabove" = 1,
			"westabove" = 0,
			"nturn" = -135,
			"sturn" = -35,
			"wturn" = 45,
			"eturn" = 145,
			"nflip" = 8,
			"sflip" = 8,
			"wflip" = 1,
			"eflip" = 0,
		),
	)
	var_overrides = null

/datum/alt_grip/halfsword
	name = "halfsword"
	two_handed = TRUE
	skill_req = SKILL_LEVEL_JOURNEYMAN
	grip_intents = list(
		/datum/intent/sword/thrust/long/halfsword,
		/datum/intent/sword/thrust/long/halfsword/jab
	)
	onmobprop_overrides = list(
		"altgrip" = list(
			"shrink" = 0.6,
			"sx" = 0,
			"sy" = 3,
			"nx" = -1,
			"ny" = 1,
			"wx" = -8,
			"wy" = 0,
			"ex" = 8,
			"ey" = -1,
			"northabove" = 0,
			"southabove" = 1,
			"eastabove" = 1,
			"westabove" = 0,
			"nturn" = -49,
			"sturn" = -139,
			"wturn" = 118,
			"eturn" = 67,
			"nflip" = 8,
			"sflip" = 8,
			"wflip" = 1,
			"eflip" = 0,
		),
	)
	var_overrides = list(
		"wlength" = WLENGTH_SHORT
	)
	additive_var_overrides = list(
		"wdefense" = 2
	)

/datum/alt_grip/halfsword/frei
	trait_applied = list(TRAIT_LONGSWORDSMAN)
	additive_var_overrides = list(
		"wdefense" = 3
	)
	grip_intents = list(
		/datum/intent/sword/thrust/long/halfsword/frei,
		/datum/intent/effect/daze/longsword/clinch,
		/datum/intent/effect/daze/longsword2h
	)

/datum/alt_grip/roof_guard
	name = "roof guard"
	two_handed = TRUE
	trait_applied = list(TRAIT_LONGSWORDSMAN)
	grip_intents = list(
		/datum/intent/sword/cut/master,
		/datum/intent/sword/thrust/long/master,
		/datum/intent/effect/daze/longsword
	)
	onmobprop_overrides = list(
		"altgrip" = list(
			"shrink" = 0.6,
			"sx" = -2,
			"sy" = 9,
			"nx" = 5,
			"ny" = 5,
			"wx" = 0,
			"wy" = 7,
			"ex" = -2,
			"ey" = 7,
			"northabove" = 0,
			"southabove" = 1,
			"eastabove" = 1,
			"westabove" = 0,
			"nturn" = 117,
			"sturn" = -301,
			"wturn" = -75,
			"eturn" = -110,
			"nflip" = 8,
			"sflip" = 8,
			"wflip" = 1,
			"eflip" = 0,
		),
	)

/datum/alt_grip/halfsword/greatsword
	grip_intents = list(
		/datum/intent/sword/thrust/long/halfsword
	)
	onmobprop_overrides = list(
		"altgrip" = list(
			"shrink" = 0.6,
			"sx" = 0,
			"sy" = 3,
			"nx" = -1,
			"ny" = 4,
			"wx" = -5,
			"wy" = 3,
			"ex" = 4,
			"ey" = 6,
			"northabove" = 0,
			"southabove" = 1,
			"eastabove" = 1,
			"westabove" = 0,
			"nturn" = -86,
			"sturn" = -156,
			"wturn" = 75,
			"eturn" = 90,
			"nflip" = 8,
			"sflip" = 8,
			"wflip" = 1,
			"eflip" = 0,
		),
	)
	additive_var_overrides = list(
		"wdefense" = 2,
	)
	var_overrides = list(
		"wlength" = WLENGTH_NORMAL
	)
