/datum/migrant_wave
	abstract_type = /datum/migrant_wave
	/// Name of the wave
	var/name = "MIGRANT WAVE"
	/// Which roll track this wave belongs to.
	var/track = MIGRANT_TRACK_REGULAR
	/// Assoc list of role type -> count that must all fill, or the wave aborts.
	var/list/required_roles = list()
	/// Assoc list of role type -> count, filled demand-driven by player preference. Unfilled slots vanish.
	var/list/optional_roles = list()
	/// Wave aborts if fewer than this many optional slots fill.
	var/min_optional_fills = 0
	/// Assoc list of headcount (as text key, e.g. "5") -> greet text. Pick the highest key <= final fill. Falls back to greet_text.
	var/list/greet_text_by_fill = null
	/// Earliest round time (world.time - round_start_time) this wave may roll.
	var/min_round_time = 0
	/// If TRUE, this wave is hidden from the migrant panel (rolls naturally but isn't advertised or triumph-buyable).
	var/hidden = FALSE
	/// If TRUE, this is a hostile raid (longer fail cooldown).
	var/is_raid = FALSE
	/// If defined, this is the minimum active migrants required to roll the wave
	var/min_active = null
	/// If defined, this is the maximum active migrants required to roll the wave
	var/max_active = null
	/// If defined, this is the minimum population playing the game that is required for wave to roll
	var/min_pop = null
	/// If defined, this is the maximum population playing the game that is required for wave to roll
	var/max_pop = null
	/// If defined, this is the maximum amount of times this wave can spawn
	var/max_spawns = null
	/// The relative probability this wave will be picked, from all available waves
	var/weight = 20
	/// Name of the latejoin spawn landmark for the wave to decide where to spawn
	var/spawn_landmark = "Pilgrim"
	/// Text to greet all players in the wave with
	var/greet_text
	/// Whether this wave can roll at all. If not, it can still be forced to be ran.
	var/can_roll = TRUE
	/// If defined, this will be the wave type to increment for purposes of checking `max_spawns`
	var/shared_wave_type = null
	/// Whether we want to spawn people on the rolled location, this may not be desired for bandits or other things that set the location
	var/spawn_on_location = TRUE
	/// Triumph contributions for this wave type (ckey -> amount)
	var/list/triumph_contributions = list()
	/// Total triumph invested in this wave
	var/triumph_total = 0
	/// Threshold at which this wave is guaranteed to be next
	var/triumph_threshold = 25
	/// Whether triumph contributions reset after wave spawns
	var/reset_contributions_on_spawn = TRUE

/datum/migrant_wave/proc/can_roll()
	return TRUE

/datum/migrant_wave/proc/get_roles_amount()
	var/amount = 0
	for(var/role_type in required_roles)
		amount += required_roles[role_type]
	for(var/role_type in optional_roles)
		amount += optional_roles[role_type]
	return amount

/datum/migrant_wave/proc/get_all_role_types()
	. = list()
	for(var/role_type in required_roles)
		. |= role_type
	for(var/role_type in optional_roles)
		. |= role_type

/datum/migrant_wave/pilgrim
	name = "Pilgrimage"
	track = MIGRANT_TRACK_REGULAR
	weight = 100 // It is a "default" wave
	triumph_threshold = 10
	required_roles = list(
		/datum/migrant_role/pilgrim = 1,
	)
	optional_roles = list(
		/datum/migrant_role/pilgrim = 3,
	)
	greet_text = "Fleeing from misfortune and hardship, you and a handful of survivors get closer to Azure Peak, looking for refuge and work, finally almost being there, almost..."

/datum/migrant_wave/adventurer
	name = "Adventure Party"
	track = MIGRANT_TRACK_REGULAR
	weight = 100 // Adventurers is the default spillover role and instead of just setting adventurers slots up high at roundstart we'll let people join in gradually through the round
	triumph_threshold = 15
	required_roles = list(
		/datum/migrant_role/adventurer = 1,
	)
	optional_roles = list(
		/datum/migrant_role/adventurer = 3,
	)
	greet_text = "Together with a party of trusted friends we decided to venture out, seeking thrills, glory and treasure, ending up in the misty and damp bog underneath Azure Peak, perhaps getting ourselves into more than what we bargained for."

/datum/migrant_wave/bandit
	name = "Bandit Raid"
	track = MIGRANT_TRACK_SPECIAL
	weight = 16
	min_round_time = 45 MINUTES
	is_raid = TRUE
	spawn_landmark = "Bandit"
	can_roll = FALSE
	required_roles = list(
		/datum/migrant_role/bandit = 1,
	)
	optional_roles = list(
		/datum/migrant_role/bandit = 2,
	)

/datum/migrant_wave/assassin
	name = "Assassin Hit"
	track = MIGRANT_TRACK_SPECIAL
	weight = 12
	min_round_time = 60 MINUTES
	is_raid = TRUE
	required_roles = list(
		/datum/migrant_role/assassin = 1,
	)
	optional_roles = list(
		/datum/migrant_role/assassin = 3,
	)

/datum/migrant_wave/gnolls
	name = "Gnoll raid"
	track = MIGRANT_TRACK_SPECIAL
	weight = 12
	min_round_time = 45 MINUTES
	is_raid = TRUE
	required_roles = list(
		/datum/migrant_role/gnoll = 1,
	)
	optional_roles = list(
		/datum/migrant_role/gnoll = 3,
	)

/datum/migrant_wave/gnolls/can_roll()
	if(SSgamemode.current_storyteller?.preferred_gnoll_mode == GNOLL_SCALING_NONE)
		return FALSE
	return TRUE
