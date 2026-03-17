/datum/threat_region
	var/region_name = "Generic Region Scream At Coder"
	var/latent_ambush = 0
	var/min_ambush = 0
	var/max_ambush = 150
	var/fixed_ambush = FALSE // Some region like Underdark cannot be reduced in danger
	var/lowpop_tick = 3 // How much TP to tick up every 15 min (<= 30 pop)
	var/highpop_tick = 5 // How much TP to tick up every 15 min (> 30 pop)
	var/last_natural_ambush_time = -AMBUSH_REGION_COOLDOWN // Pre-expired so start-of-round doesn't block ambushes
	var/last_induced_ambush_time = 0 // Time between now and the previous ambush triggered by horn

/datum/threat_region/New(_region_name, _latent_ambush, _min_ambush, _max_ambush, _fixed_ambush, _lowpop_tick, _highpop_tick)
	region_name = _region_name
	latent_ambush = _latent_ambush
	min_ambush = _min_ambush
	max_ambush = _max_ambush
	fixed_ambush = _fixed_ambush
	lowpop_tick = _lowpop_tick
	highpop_tick = _highpop_tick

/datum/threat_region/proc/reduce_latent_ambush(amount)
	if(fixed_ambush)
		return
	if(latent_ambush - amount < min_ambush)
		latent_ambush = min_ambush
	else
		latent_ambush -= amount

/datum/threat_region/proc/increase_latent_ambush(amount)
	if(fixed_ambush)
		return
	if(latent_ambush + amount > max_ambush)
		latent_ambush = max_ambush
	else
		latent_ambush += amount

/// Danger level for display — based on percentage of this region's max_ambush.
/datum/threat_region/proc/get_danger_level()
	if(!max_ambush)
		return DANGER_LEVEL_SAFE
	var/pct = (latent_ambush / max_ambush) * 100
	if(pct <= DANGER_PCT_SAFE)
		return DANGER_LEVEL_SAFE
	else if(pct <= DANGER_PCT_LOW)
		return DANGER_LEVEL_LOW
	else if(pct <= DANGER_PCT_MODERATE)
		return DANGER_LEVEL_MODERATE
	else if(pct <= DANGER_PCT_DANGEROUS)
		return DANGER_LEVEL_DANGEROUS
	else
		return DANGER_LEVEL_BLEAK

/datum/threat_region/proc/get_danger_color(level)
	switch(get_danger_level())
		if(DANGER_LEVEL_SAFE)
			return "#00FF00"
		if(DANGER_LEVEL_LOW)
			return "#FFFF00"
		if(DANGER_LEVEL_MODERATE)
			return "#FFA500"
		if(DANGER_LEVEL_DANGEROUS)
			return "#FF0000"
		if(DANGER_LEVEL_BLEAK)
			return "#800080"
		else
			return "#FFFFFF"
