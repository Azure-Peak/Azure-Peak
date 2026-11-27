/mob/living/carbon/human
	var/list/stat_ledger
	var/list/skill_ledger

/mob/living/carbon/human/reset_stats()
	. = ..()
	stat_ledger = null

/mob/living/carbon/human/proc/current_true_stats()
	. = list()
	for(var/stat in MOBSTATS)
		.[stat] = get_stat(stat)
	for(var/datum/status_effect/effect as anything in status_effects)
		for(var/stat in effect.effectedstats)
			.[stat] -= effect.effectedstats[stat]

/mob/living/carbon/human/proc/current_skill_levels()
	. = list()
	for(var/datum/skill/skill as anything in skills?.known_skills)
		.[skill.type] = skills.known_skills[skill]

/mob/living/carbon/human/proc/snapshot_build()
	return list(
		"stats" = current_true_stats(),
		"skills" = current_skill_levels(),
		"stat_ledger" = build_ledger_totals(stat_ledger),
		"skill_ledger" = build_ledger_totals(skill_ledger),
	)

/mob/living/carbon/human/proc/record_build_changes(source, list/snapshot)
	if(!snapshot)
		return
	var/list/stat_changes = build_window_changes(snapshot["stats"], current_true_stats(), snapshot["stat_ledger"], build_ledger_totals(stat_ledger))
	var/list/skill_changes = build_window_changes(snapshot["skills"], current_skill_levels(), snapshot["skill_ledger"], build_ledger_totals(skill_ledger))
	if(length(stat_changes))
		LAZYINITLIST(stat_ledger)
		build_ledger_add(stat_ledger, source, stat_changes)
	if(length(skill_changes))
		LAZYINITLIST(skill_ledger)
		build_ledger_add(skill_ledger, source, skill_changes)
	return skill_changes

/proc/build_ledger_totals(list/ledger)
	. = list()
	for(var/source in ledger)
		var/list/bucket = ledger[source]
		for(var/key in bucket)
			.[key] += bucket[key]

/proc/build_window_changes(list/before, list/after, list/ledger_before, list/ledger_after)
	. = list()
	for(var/key in before | after)
		var/delta = (after[key] || 0) - (before[key] || 0) - ((ledger_after[key] || 0) - (ledger_before[key] || 0))
		if(delta)
			.[key] = delta

/proc/build_ledger_add(list/ledger, source, list/changes)
	var/list/bucket = ledger[source]
	if(!bucket)
		bucket = list()
		ledger[source] = bucket
	for(var/key in changes)
		bucket[key] += changes[key]
