/datum/admins/proc/admin_show_character_panel(mob/living/M in GLOB.mob_list)
	set name = "Show Character Panel"
	set category = "Game Master.Misc"

	if(!check_rights(R_ADMIN))
		return

	show_character_panel(M)

/client/proc/show_character_panel(mob/M)
	holder?.show_character_panel(M)

/datum/admins/proc/show_character_panel(mob/living/M)
	if(!check_rights(R_ADMIN))
		return
	if(!isliving(M) || QDELETED(M))
		to_chat(usr, span_warning("That isn't a living mob."))
		return

	log_admin("[key_name(usr)] opened the character panel for [key_name(M)].")
	var/datum/character_panel/panel = new(M)
	panel.ui_interact(usr)

/datum/character_panel
	var/mob/living/target

/datum/character_panel/New(mob/living/new_target)
	target = new_target
	RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(on_target_deleted))

/datum/character_panel/Destroy(force)
	if(target)
		UnregisterSignal(target, COMSIG_PARENT_QDELETING)
	target = null
	SStgui.close_uis(src)
	return ..()

/datum/character_panel/proc/on_target_deleted(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/datum/character_panel/ui_state(mob/user)
	return ADMIN_STATE(R_ADMIN)

/datum/character_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CharacterPanel", "Character: [target.real_name]")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/character_panel/ui_close(mob/user)
	qdel(src)

/datum/character_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("refresh")
			update_static_data(ui.user, ui)
			return TRUE

/datum/character_panel/ui_static_data(mob/user)
	var/mob/living/carbon/human/H = ishuman(target) ? target : null
	return list(
		"name" = target.real_name,
		"ckey" = target.ckey,
		"job" = target.job,
		"advjob" = target.advjob,
		"patron" = target.patron?.name,
		"species" = H?.dna?.species?.name,
		"age" = H?.age,
		"statpack" = build_statpack_data(H),
		"virtues" = build_virtue_data(H),
		"quirks" = build_quirk_data(H),
		"vices" = build_vice_data(H),
		"stats" = build_stat_data(H),
		"skills" = build_skill_data(H),
		"traits" = build_trait_data(),
		"effects" = build_effect_data(),
	)

/datum/character_panel/proc/build_statpack_data(mob/living/carbon/human/H)
	if(!H?.statpack)
		return null
	var/list/rolls = list()
	for(var/stat in H.statpack_rolls)
		rolls += list(list("stat" = stat, "value" = H.statpack_rolls[stat]))
	var/rolled_something = FALSE
	for(var/stat in H.statpack_rolls)
		if(H.statpack_rolls[stat])
			rolled_something = TRUE
			break
	return list(
		"name" = H.statpack.name,
		"rolls" = rolls,
		"wiped" = rolled_something && !LAZYACCESS(H.stat_ledger, BUILD_SOURCE_STATPACK),
	)

/datum/character_panel/proc/build_virtue_data(mob/living/carbon/human/H)
	var/list/out = list()
	for(var/datum/virtue_record/record as anything in H?.virtue_records)
		var/list/skills = list()
		for(var/datum/skill/skill_type as anything in record.skills_gained)
			skills += list(list("name" = initial(skill_type.name), "amount" = record.skills_gained[skill_type]))
		var/list/choices = list()
		for(var/choice in record.picked_choices)
			choices += "[choice]"
		out += list(list(
			"name" = record.name,
			"source" = record.source,
			"is_origin" = ispath(record.virtue_type, /datum/virtue/origin),
			"choices" = choices,
			"skills" = skills,
			"triumphs" = record.triumphs_spent,
		))
	return out

/datum/character_panel/proc/build_quirk_data(mob/living/carbon/human/H)
	var/list/out = list()
	for(var/datum/quirk/quirk_type as anything in H?.applied_quirks)
		out += list(list("name" = initial(quirk_type.name), "desc" = initial(quirk_type.desc)))
	return out

/datum/character_panel/proc/build_vice_data(mob/living/carbon/human/H)
	var/list/out = list()
	for(var/datum/charflaw/flaw as anything in H?.charflaws)
		out += list(list("name" = flaw.name, "desc" = flaw.desc))
	return out

/datum/character_panel/proc/build_stat_data(mob/living/carbon/human/H)
	var/list/ledger = H?.stat_ledger
	var/list/ledger_totals = build_ledger_totals(ledger)
	var/list/effect_totals = list()
	for(var/datum/status_effect/effect as anything in target.status_effects)
		for(var/stat in effect.effectedstats)
			effect_totals[stat] += effect.effectedstats[stat]

	var/list/out = list()
	for(var/stat in MOBSTATS)
		var/current = target.get_stat(stat)
		var/from_effects = effect_totals[stat] || 0
		out += list(list(
			"stat" = stat,
			"current" = current,
			"statpack" = ledger_value(ledger, BUILD_SOURCE_STATPACK, stat),
			"race" = ledger_value(ledger, BUILD_SOURCE_RACE, stat),
			"job" = ledger_value(ledger, BUILD_SOURCE_JOB, stat),
			"virtues" = ledger_value(ledger, BUILD_SOURCE_VIRTUES, stat),
			"effects" = from_effects,
			"other" = current - 10 - from_effects - (ledger_totals[stat] || 0),
		))
	return out

/datum/character_panel/proc/build_skill_data(mob/living/carbon/human/H)
	var/list/ledger = H?.skill_ledger
	var/list/out = list()
	for(var/datum/skill/skill as anything in target.skills?.known_skills)
		var/level = target.skills.known_skills[skill]
		if(!level)
			continue
		var/from_job = ledger_value(ledger, BUILD_SOURCE_JOB, skill.type)
		var/from_virtues = ledger_value(ledger, BUILD_SOURCE_VIRTUES, skill.type)
		out += list(list(
			"name" = skill.name,
			"level" = level,
			"level_name" = skill_to_string(level),
			"job" = from_job,
			"virtues" = from_virtues,
			"other" = level - from_job - from_virtues,
		))
	return out

/datum/character_panel/proc/ledger_value(list/ledger, source, key)
	var/list/bucket = LAZYACCESS(ledger, source)
	return LAZYACCESS(bucket, key) || 0

/datum/character_panel/proc/build_trait_data()
	var/list/out = list()
	for(var/trait in target.status_traits)
		var/list/sources = list()
		for(var/source in target.status_traits[trait])
			sources += describe_trait_source(source)
		out += list(list(
			"name" = trait,
			"desc" = GLOB.roguetraits[trait],
			"sources" = sources,
		))
	return out

/datum/character_panel/proc/describe_trait_source(source)
	if(!istext(source))
		return "[source]"
	if(findtext(source, "\[0x") == 1)
		var/datum/thing = locate(source)
		if(thing)
			return "[thing]"
	return source

/datum/character_panel/proc/build_effect_data()
	var/list/out = list()
	for(var/datum/status_effect/effect as anything in target.status_effects)
		var/list/stats = list()
		for(var/stat in effect.effectedstats)
			stats += list(list("stat" = stat, "value" = effect.effectedstats[stat]))
		out += list(list(
			"name" = effect.linked_alert?.name || effect.id,
			"desc" = effect.linked_alert?.desc,
			"remaining" = effect.duration == -1 ? -1 : max(0, round((effect.duration - world.time) / 10)),
			"stats" = stats,
		))
	return out
