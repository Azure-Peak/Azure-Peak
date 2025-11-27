/datum/threat_region
	var/region_name = "Generic Region Scream At Coder"
	var/latent_ambush = DANGER_SAFE_FLOOR
	var/min_ambush = DANGER_SAFE_FLOOR
	var/max_ambush = DANGER_BLEAK_LIMIT
	var/fixed_ambush = FALSE // Some region like Underdark cannot be reduced in danger
	var/lowpop_tick = 1 // How much ambush to tick up every iteration <= 30 pop
	var/highpop_tick = 2 // How much ambush to tick up every iteration > 30 pop
	var/last_natural_ambush_time = 0
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

// Special proc because danger level is dependent on the number of latent ambush
/datum/threat_region/proc/get_danger_level()
	if(latent_ambush <= DANGER_SAFE_LIMIT)
		return DANGER_LEVEL_SAFE
	else if(latent_ambush <= DANGER_LOW_LIMIT)
		return DANGER_LEVEL_LOW
	else if(latent_ambush <= DANGER_MODERATE_LIMIT)
		return DANGER_LEVEL_MODERATE
	else if(latent_ambush <= DANGER_DANGEROUS_LIMIT)
		return DANGER_LEVEL_DANGEROUS
	else if(latent_ambush <= DANGER_BLEAK_LIMIT)
		return DANGER_LEVEL_BLEAK
	else
		return DANGER_LEVEL_SAFE

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
