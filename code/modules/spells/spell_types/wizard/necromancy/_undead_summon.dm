/datum/action/cooldown/spell/conjure_summon/undead
	button_icon = 'icons/mob/actions/zizomiracles.dmi'
	spell_color = GLOW_COLOR_ZIZO
	secondary_resource_cost = 300
	recoil_severity = CONJURE_RECOIL_LIGHT
	reclaim_recoil = FALSE
	var/undead_type

/datum/action/cooldown/spell/conjure_summon/undead/spawn_summon(turf/T, mob/living/user)
	var/turf/dest = T
	if(summons_per_cast > 1)
		var/list/open = list()
		for(var/turf/open/candidate in range(1, T))
			if(!candidate.is_blocked_turf())
				open += candidate
		if(length(open))
			dest = pick(open)
	var/mob/living/carbon/human/species/skeleton/conjured/undead/skeleton = new undead_type(dest)
	skeleton.summoner_ref = WEAKREF(user)
	skeleton.loadout = modes[current_mode]["loadout"]
	return skeleton
