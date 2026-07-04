/datum/action/cooldown/spell/telegraphed_strike/spellblade/shatter
	name = "Shatter"
	desc = "What the blade cannot cut, the mace breaks - and Shatter does whichever your bound weapon favours. Wind up a blow, then strike a line straight ahead of you, hurling those struck back a tile. A cutting edge cleaves for full force; a blunt head lands slightly softer. \
		The strike will not carry through walls, but it batters any structure in its path. \
		At 3+ momentum: consumes 3 to double damage. Builds momentum on a multi-target hit. Can be deflected by Defend stance."
	button_icon_state = "shatter"
	invocations = list("Frange!")
	damage = 40
	empowered_mult = 2
	windup_time = TELEGRAPH_DODGEABLE
	sweep_step = 0
	push_dist = 1
	sound = null
	detonate_sound = null
	momentum_on_hit = 0
	momentum_on_surge = 1
	var/line_length = 3

/datum/action/cooldown/spell/telegraphed_strike/spellblade/shatter/get_pattern_offsets()
	var/list/offsets = list()
	for(var/i in 1 to line_length)
		offsets += list(list(0, i))
	return offsets
