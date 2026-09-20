GLOBAL_LIST_INIT(anatomy_profiles, init_anatomy_profiles())

/proc/init_anatomy_profiles()
	. = list()
	for(var/profile_type in typesof(/datum/anatomy))
		.[profile_type] = new profile_type()

/datum/anatomy
	var/list/zones
	var/list/limb_names
	/// Grants TRAIT_BLOODLOSS_IMMUNE on spawn.
	var/bloodless = FALSE
	/// Per-blade-class multiplier on part damage.
	var/list/bclass_part_mult
	/// Noun the penetration hit message drives into.
	var/pen_flavor = "flesh"

/datum/anatomy/New()
	. = ..()
	zones = list()
	build_zones()

/datum/anatomy/proc/build_zones()
	return

/datum/anatomy/proc/add_zone(zone, damage_mult = 1, part_health_fraction = 0.4, part_health_minimum = 20, break_wound, hint, melee_hit_bonus = 0, ranged_hit_bonus = 0, requires_prone = FALSE, list/requires_broken, exposed_message)
	var/datum/anatomy_zone/new_zone = new()
	new_zone.zone = zone
	new_zone.damage_mult = damage_mult
	new_zone.part_health_fraction = part_health_fraction
	new_zone.part_health_minimum = part_health_minimum
	new_zone.break_wound = break_wound
	new_zone.hint = hint
	new_zone.melee_hit_bonus = melee_hit_bonus
	new_zone.ranged_hit_bonus = ranged_hit_bonus
	new_zone.requires_prone = requires_prone
	new_zone.requires_broken = requires_broken
	new_zone.exposed_message = exposed_message
	zones[zone] = new_zone

/datum/anatomy/proc/get_zone(zone_precise)
	if(!zone_precise || !length(zones))
		return null
	. = zones[zone_precise]
	if(.)
		return .
	return zones[check_zone(zone_precise)]

/datum/anatomy/proc/get_part_damage_mult(bclass)
	if(!bclass || !length(bclass_part_mult))
		return 1
	return bclass_part_mult[bclass] || 1

/datum/anatomy/proc/get_pen_part_mult(penfactor, bclass)
	if(!penfactor || !bclass || !(bclass in PEN_PART_BCLASSES))
		return 1
	switch(penfactor)
		if(PEN_LIGHT)
			return PEN_PART_MULT_LIGHT
		if(PEN_MEDIUM)
			return PEN_PART_MULT_MEDIUM
		if(PEN_HEAVY)
			return PEN_PART_MULT_HEAVY
		if(PEN_BSTEEL)
			return PEN_PART_MULT_BSTEEL
	return 1

/datum/anatomy_zone
	var/zone
	var/damage_mult = 1
	var/part_health_fraction = 0.4
	var/part_health_minimum = 20
	var/break_wound
	var/hint
	var/melee_hit_bonus = 0
	var/ranged_hit_bonus = 0
	/// Takes no part damage at all unless the mob is prone.
	var/requires_prone = FALSE
	/// Zones that must already be broken before this one takes any part damage.
	var/list/requires_broken
	/// Announced once, the moment requires_broken is satisfied.
	var/exposed_message

/datum/anatomy_zone/proc/is_exposed(list/broken_parts)
	if(!length(requires_broken))
		return TRUE
	for(var/zone_needed in requires_broken)
		if(!(zone_needed in broken_parts))
			return FALSE
	return TRUE
