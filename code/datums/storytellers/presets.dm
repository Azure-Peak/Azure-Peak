/// Code-defined gamemode presets. These replace the old storyteller gods. Players vote between them (grouped
/// into three pools - see GAMEMODE_POOL_* in __DEFINES/storytellers.dm) or admins fine-tune the roundstart
/// antag config directly. A preset's vote pool is set by preset_pool, independent of its type hierarchy.

/datum/storyteller/gamemode
	always_votable = TRUE
	hag_slots = 1

// ----------------------------------------------------------------------------------------------------------
// PSYDON pool - lowest intensity. No hard antags. Extended opens nothing; Low Intensity opens a few wretches.
// (Low Intensity is defined further down as no_antag/small_wretch but votes in this pool via preset_pool.)
// ----------------------------------------------------------------------------------------------------------
/datum/storyteller/gamemode/extended
	name = "Extended"
	vote_desc = "Maybe we were the true antagonists after all."
	desc = "No hard antags, no soft antags (wretch/gnoll/assassin), no dreamwalker. Hag present."
	welcome_text = "A temperate breeze rolls through the quiet streets.."
	color_theme = "#80ced8"
	preset_pool = GAMEMODE_POOL_EXTENDED
	block_hard = TRUE
	block_soft = TRUE
	allow_dreamwalker = FALSE
	preferred_gnoll_mode = GNOLL_SCALING_NONE
	wretch_slot_cap = 0
	roundstart_prob = 0
	guarantees_roundstart_roleset = FALSE
	starting_point_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 1,
		EVENT_TRACK_CHARACTER_INJECTION = 0,
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 1,
	)
	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 1,
		EVENT_TRACK_CHARACTER_INJECTION = 0,
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 1,
	)

// ----------------------------------------------------------------------------------------------------------
// Admin sandbox - NOT votable. Admins pick before the 120s mark to disable player vote and
// insert their own antags in.
// ----------------------------------------------------------------------------------------------------------
/datum/storyteller/gamemode/admin
	name = "Admin Sandbox"
	vote_desc = "The Gods among us have taken the wheel."
	desc = "Admin sandbox. Soft antags default to the standard No-Antag baseline; admins open hard antags and adjust slots directly."
	welcome_text = "The threads of fate bend to an unseen hand.."
	color_theme = "#c8a13a"
	preset_pool = null
	always_votable = FALSE
	block_hard = FALSE
	block_soft = FALSE
	allow_dreamwalker = TRUE
	guaranteed_hard = FALSE
	guarantees_roundstart_roleset = FALSE
	roundstart_prob = 0
	preferred_gnoll_mode = GNOLL_SCALING_DYNAMIC	// max 3
	wretch_slot_cap = 12

	starting_point_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 1,
		EVENT_TRACK_CHARACTER_INJECTION = 0,
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 1,
	)
	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 1,
		EVENT_TRACK_CHARACTER_INJECTION = 0,
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 1,
	)

// ----------------------------------------------------------------------------------------------------------
// ASCENDANT pool - guaranteed roundstart hard antag. At least one main antag will be selected.
// ----------------------------------------------------------------------------------------------------------
/datum/storyteller/gamemode/guaranteed_antag
	name = "High Intensity"
	vote_desc = "Guaranteed hard antagonist. Some soft antagonists remain."
	desc = "Guaranteed roundstart hard antag. Wretches up to 8. Gnolls max 2. Hag present. Dreamwalker may roll."
	welcome_text = "A cold dread settles over the town.."
	color_theme = "#a43c3c"
	preset_pool = GAMEMODE_POOL_GUARANTEED
	guaranteed_hard = TRUE
	guarantees_roundstart_roleset = TRUE
	roundstart_prob = 100
	block_hard = FALSE
	block_soft = FALSE
	allow_dreamwalker = TRUE
	preferred_gnoll_mode = GNOLL_SCALING_FLAT	// max 2
	wretch_slot_cap = 9

/datum/storyteller/gamemode/guaranteed_antag/low_wretch
	name = "Tempered Intensity"
	vote_desc = "Guaranteed hard antagonist of a random variety. A few soft antagonists too."
	desc = "Guaranteed roundstart hard antag with more aggressive pop scaling. Wretches up to 4. Gnoll max 1. Hag present. No dreamwalker."
	color_theme = "#7a1f1f"
	hard_mult = 2
	block_soft = FALSE
	allow_dreamwalker = FALSE
	preferred_gnoll_mode = GNOLL_SCALING_SINGLE	// max 1
	wretch_slot_cap = 4

// ----------------------------------------------------------------------------------------------------------
// TEN pool - no hard antags, soft antags only. Standard is the lighter option, Medium the default fallback.
// ----------------------------------------------------------------------------------------------------------
/datum/storyteller/gamemode/no_antag	// DEFAULT (inconclusive-vote fallback)
	name = "Medium Intensity"
	vote_desc = "No hard antagonists. Soft antagonists scale reasonably."
	desc = "No hard antags. Wretches scale normally (5 -> 12). Gnolls max 3. Hag present. Dreamwalker may roll."
	welcome_text = "The warmth of daelight rouses you from your slumber.."
	color_theme = "#2b8c87"
	preset_pool = GAMEMODE_POOL_NOANTAG
	block_hard = TRUE
	block_soft = FALSE
	allow_dreamwalker = TRUE
	preferred_gnoll_mode = GNOLL_SCALING_DYNAMIC	// max 3
	wretch_slot_cap = 12
	roundstart_prob = 50
	guarantees_roundstart_roleset = FALSE

/datum/storyteller/gamemode/no_antag/standard
	name = "Standard Intensity"
	vote_desc = "No hard antagonists. A moderate spread of soft antagonists."
	desc = "No hard antags. Wretches up to 6. Gnolls max 2. Hag present. No dreamwalker."
	color_theme = "#37b3a6"
	allow_dreamwalker = FALSE
	preferred_gnoll_mode = GNOLL_SCALING_FLAT	// max 2
	wretch_slot_cap = 6

// Low Intensity - votes in the PSYDON pool (see preset_pool) despite being a no_antag subtype.
/datum/storyteller/gamemode/no_antag/small_wretch
	name = "Low Intensity"
	vote_desc = "No hard antagonists. Only a handful of soft antagonists are present.."
	desc = "No hard antags. Wretches fixed at 4. No gnolls. Hag present. No dreamwalker."
	color_theme = "#1f6b67"
	preset_pool = GAMEMODE_POOL_EXTENDED
	allow_dreamwalker = FALSE
	preferred_gnoll_mode = GNOLL_SCALING_NONE
	wretch_slot_cap = 4
	roundstart_prob = 0

	starting_point_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 1,
		EVENT_TRACK_CHARACTER_INJECTION = 0,
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 1,
	)
	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 1,
		EVENT_TRACK_CHARACTER_INJECTION = 0,
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 1,
	)
