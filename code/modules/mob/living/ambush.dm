GLOBAL_VAR_INIT(ambush_chance_pct, 20) // Please don't raise this over 100 admins :')
GLOBAL_VAR_INIT(ambush_mobconsider_cooldown, 2 MINUTES) // Cooldown for each individual mob being considered for an ambush
// Instead of setting it on area and hoping no one forgets it on area we're just doing this

/mob/living/proc/ambushable()
	if(stat)
		return FALSE
	return ambushable

/mob/living/proc/consider_ambush(always = FALSE, ignore_cooldown = FALSE, min_dist = 1, max_dist = 7, silent = FALSE)
	var/area/AR = get_area(src)
	var/datum/threat_region/TR = SSregionthreat.get_region(AR.threat_region)
	var/danger_level = DANGER_LEVEL_MODERATE // Fallback if there's no region
	if(!AR.ambush_mobs)
		return FALSE
	if(TR)
		danger_level = TR.get_danger_level()
	if(danger_level == DANGER_LEVEL_SAFE)
		if(TR.latent_ambush == 0)
			return FALSE
		if(TR.latent_ambush <= DANGER_SAFE_LIMIT && !always) // Signal horn can dip below 10
			return FALSE
	if(TR && !(always && ignore_cooldown) && ((world.time - TR.last_natural_ambush_time) < 2 MINUTES))
		return FALSE
	var/true_ambush_chance = GLOB.ambush_chance_pct
	if(TR)
		if(danger_level == DANGER_LEVEL_LOW)
			true_ambush_chance *= 0.5
		else if(danger_level == DANGER_LEVEL_DANGEROUS)
			true_ambush_chance *= 1.5
		else if(danger_level == DANGER_LEVEL_BLEAK)
			true_ambush_chance *= 2
	if(!always && prob(100 - true_ambush_chance))
		return FALSE
	if(!always)
		if(HAS_TRAIT(src, TRAIT_AZURENATIVE))
			return FALSE
		if(world.time > last_client_interact + 0.3 SECONDS)
			return FALSE // unmoving afks can't trigger random ambushes i.e. when being pulled/kicked/etc
	if(get_will_block_ambush())
		return FALSE
	if(mob_timers["ambush_check"] && !ignore_cooldown)
		if(world.time < mob_timers["ambush_check"] + GLOB.ambush_mobconsider_cooldown)
			return FALSE
	mob_timers["ambush_check"] = world.time
	var/victims = 1
	var/list/victimsa = list()
	for(var/mob/living/V in view(5, src))
		if(V != src)
			if(V.ambushable())
				victims++
				victimsa += V
			if(victims > 3)
				return
	var/list/possible_targets = get_possible_ambush_spawn(min_dist, max_dist)
	if(possible_targets.len)
		mob_timers["ambushlast"] = world.time
		for(var/mob/living/V in victimsa)
			V.mob_timers["ambushlast"] = world.time
		if(TR)
			var/scaled_reduction = TR.latent_ambush > DANGER_MODERATE_LIMIT ? 2 : 1 // Dangerous & Dire counts for 2
			TR.reduce_latent_ambush(scaled_reduction) // Remove one ambush from the ambient pool
			TR.last_natural_ambush_time = world.time
		var/list/mobs_to_spawn = list()
		var/mobs_to_spawn_single = FALSE
		var/max_spawns = 3
		var/mustype = 1
		var/spawnedtype = pickweight(AR.ambush_mobs)

		// This is the part where we scale ambush difficulty based on threat. Due to how we have a mix of
		// Ambush Config and Single Mob Ambush, I use a weird scaling system:
		// Single Mob
		// Low - 1 Mob only 
		// Moderate - 1 to 2 (This is REALLY moderate)
		// Dangerous - 2 to 3 
		// Dire - 3 to 4 
		// Ambush Difficulty Scaling:
		// Low = -1 Mob
		// Dangerous = +1 Mob
		// Dire = + 2 Mobs
		// Previous ambush system is 2 mobs, unless there's 3 victims, in which 3 mobs
		// And Ambush Config number is fixed

		if(ispath(spawnedtype, /mob/living))
			switch(danger_level)
				if(DANGER_LEVEL_SAFE) // Induced Ambush
					max_spawns = 1
				if(DANGER_LEVEL_LOW)
					max_spawns = 1
				if(DANGER_LEVEL_MODERATE)
					max_spawns = rand(1, 2) // This is lower than before, to make moderate easier to deal with
				if(DANGER_LEVEL_DANGEROUS)
					max_spawns = rand(2, 3)
				if(DANGER_LEVEL_BLEAK)
					max_spawns = rand(3, 4)
			mobs_to_spawn_single = TRUE
		else if(istype(spawnedtype, /datum/ambush_config))
			var/datum/ambush_config/A = spawnedtype
			for(var/type_path in A.mob_types)
				var/amt = A.mob_types[type_path]
				for(var/i in 1 to amt)
					mobs_to_spawn += type_path
			if(mobs_to_spawn.len > 1)
				switch(danger_level)
					if(DANGER_LEVEL_SAFE)
						var/ri = rand(1, mobs_to_spawn.len)
						mobs_to_spawn.Cut(ri, ri + 1) // Randomly remove one mob
					if(DANGER_LEVEL_LOW)
						var/ri = rand(1, mobs_to_spawn.len)
						mobs_to_spawn.Cut(ri, ri + 1) // Randomly remove one mob
					if(DANGER_LEVEL_DANGEROUS)
						mobs_to_spawn += pick(mobs_to_spawn) // Randomly add 1
					if(DANGER_LEVEL_BLEAK)
						mobs_to_spawn += pick(mobs_to_spawn) // Randomly add 2
						mobs_to_spawn += pick(mobs_to_spawn)
			max_spawns = mobs_to_spawn.len

		for(var/i in 1 to max_spawns)
			var/spawnloc = pick(possible_targets)
			if(spawnloc)
				var/mob_type
				if(mobs_to_spawn_single)
					mob_type = spawnedtype
				else
					if(!mobs_to_spawn.len)
						continue
					mob_type = mobs_to_spawn[1]
				var/mob/spawnedmob = new mob_type(spawnloc)
				if(mobs_to_spawn.len && !mobs_to_spawn_single)
					mobs_to_spawn.Cut(1, 2)
				if(istype(spawnedmob, /mob/living/simple_animal/hostile))
					var/mob/living/simple_animal/hostile/M = spawnedmob
					M.attack_same = FALSE
					M.del_on_deaggro = 44 SECONDS
					M.faction += "ambush"
					M.GiveTarget(src)
				if(istype(spawnedmob, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = spawnedmob
					H.del_on_deaggro = 44 SECONDS
					H.last_aggro_loss = world.time
					H.faction += "ambush"
					H.retaliate(src)
					mustype = 2
		if(!silent)
			if(mustype == 1)
				playsound_local(src, pick('sound/misc/jumpscare (1).ogg','sound/misc/jumpscare (2).ogg','sound/misc/jumpscare (3).ogg','sound/misc/jumpscare (4).ogg'), 100)
			else
				playsound_local(src, pick('sound/misc/jumphumans (1).ogg','sound/misc/jumphumans (2).ogg','sound/misc/jumphumans (3).ogg'), 100)
			shake_camera(src, 2, 2)
		return TURF_WET_PERMAFROST

// Return whether a mob is blocked from being ambushed
/mob/living/proc/get_will_block_ambush()
	if(!ambushable())
		return TRUE
	var/campfires = 0
	for(var/obj/machinery/light/rogue/RF in view(5, src))
		if(RF.on)
			campfires++
	if(campfires > 0)
		return TRUE

/mob/living/proc/get_possible_ambush_spawn(min_dist = 2, max_dist = 7)
	var/list/possible_targets = list()
	for(var/obj/structure/flora/roguetree/RT in orange(max_dist, src))
		if(istype(RT,/obj/structure/flora/roguetree/stump))
			continue
		if(isturf(RT.loc) && !get_dist(RT.loc, src) < min_dist)
			possible_targets += get_adjacent_ambush_turfs(RT.loc)
	for(var/obj/structure/flora/roguegrass/bush/RB in orange(max_dist, src))
		if(isturf(RB.loc) && !get_dist(RB.loc, src) < min_dist)
			possible_targets += get_adjacent_ambush_turfs(RB.loc)
	for(var/obj/structure/flora/rogueshroom/RX in orange(max_dist, src))
		if(isturf(RX.loc) && !get_dist(RX.loc, src) < min_dist)
			possible_targets += get_adjacent_ambush_turfs(RX.loc)
	for(var/obj/structure/flora/newtree/RS in orange(max_dist, src))
		if(!RS.density)
			continue
		if(isturf(RS.loc) && !get_dist(RS.loc, src) < min_dist)
			possible_targets += get_adjacent_ambush_turfs(RS.loc)

	return possible_targets

/proc/get_adjacent_ambush_turfs(turf/T)
	var/list/adjacent = list()
	for(var/turf/AT in get_adjacent_turfs(T))
		if(AT.density || T.LinkBlockedWithAccess(AT, null))
			continue
		adjacent += AT
	return adjacent
