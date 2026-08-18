/// Code-defined gamemode presets. These replace the old storyteller gods. Players vote between them (grouped
/// into three pools - see GAMEMODE_POOL_* in __DEFINES/storytellers.dm) or admins fine-tune the roundstart
/// antag config directly. A preset's vote pool is set by preset_pool, independent of its type hierarchy.

/datum/storyteller/gamemode
	always_votable = TRUE
	hag_slots = 1

// -----------------------------------------------------------------------------
// PSYDON pool - lowest intensity. No hard antags, no heretics/wretches/lyckers.
// -----------------------------------------------------------------------------
/datum/storyteller/gamemode/extended
	name = "Extended"
	vote_desc = "Maybe we were the true antagonists after all."
	desc = "No hard antags, no soft antags (lycker/wretch/heretic/gnoll/assassin), no dreamwalker. Hag present."
	welcome_text = "A temperate breeze rolls through the quiet streets.."
	color_theme = "#80ced8"
	preset_pool = GAMEMODE_POOL_EXTENDED
	block_external_soft = TRUE // gimme a round with NUTHIN
	block_internal_soft = TRUE
	block_external_hard = TRUE
	block_internal_hard = TRUE
	allow_dreamwalker = FALSE
	preferred_gnoll_mode = GNOLL_SCALING_NONE
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
	block_external_soft = FALSE
	block_internal_soft = FALSE
	block_external_hard = FALSE
	block_internal_hard = FALSE
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

// --------------------------------------------------------------------------------------------
// ASCENDANT pool - high is a guaranteed roundstart hard antag, medium is heretic+wretch slots.
// --------------------------------------------------------------------------------------------
/datum/storyteller/gamemode/guaranteed_antag
	name = "High Intensity"
	vote_desc = "Guaranteed hard antagonist. Less wretch/heretic slots."
	desc = "Guaranteed roundstart external antag (Lich/VL/WW/Bandits). Heretic max 2, wretches max 4. Gnolls max 2. Lycker max 2. Hag present."
	welcome_text = "A cold dread settles over the town..."
	color_theme = "#a43c3c"
	preset_pool = GAMEMODE_POOL_GUARANTEED
	guaranteed_hard = TRUE
	guarantees_roundstart_roleset = TRUE
	roundstart_prob = 100
	block_external_soft = FALSE
	block_internal_soft = FALSE
	block_external_hard = FALSE
	block_internal_hard = FALSE
	allow_dreamwalker = FALSE
	preferred_gnoll_mode = GNOLL_SCALING_FLAT	// max 2
	lycker_slots = 2
	heretic_slots = 2
	wretch_slot_cap = 4

/datum/storyteller/gamemode/guaranteed_antag/wretch
	name = "Tempered Intensity"
	vote_desc = "More wretch and heretic slots, but no hard antag."
	desc = "No hard antag. Heretics up to 4 and Wretches up to 10. Lycker max 4. Gnoll max 3. Hag present."
	color_theme = "#7a1f1f"
	guaranteed_hard = FALSE
	guarantees_roundstart_roleset = FALSE
	block_external_soft = FALSE
	block_internal_soft = FALSE
	block_external_hard = TRUE
	block_internal_hard = TRUE
	allow_dreamwalker = FALSE
	preferred_gnoll_mode = GNOLL_SCALING_DYNAMIC	// max 3
	heretic_slots = 4
	wretch_slot_cap = 10
	lycker_slots = 4

// -------------------------------------------------------------------------------------------------------------
// TEN pool - no external antags, internal threats only. Low is the lighter option, Medium the default fallback.
// -------------------------------------------------------------------------------------------------------------
/datum/storyteller/gamemode/no_antag	// DEFAULT (inconclusive-vote fallback)
	name = "Medium Intensity"
	vote_desc = "Most antagonists blocked. Internal threats possible. Soft antagonists scale reasonably."
	desc = "No external hard antags, no heretics. Wretches max 5. Lyckers max 2, or 4 if no roundstart antag. Gnolls max 3. May roll peasant rebel/masquerade/extra lycker slots."
	welcome_text = "The warmth of daelight rouses you from your slumber.."
	color_theme = "#2b8c87"
	preset_pool = GAMEMODE_POOL_NOANTAG
	block_external_soft = FALSE
	block_internal_soft = FALSE
	block_external_hard = TRUE
	block_internal_hard = FALSE
	allow_dreamwalker = FALSE
	preferred_gnoll_mode = GNOLL_SCALING_DYNAMIC	// max 3
	roundstart_prob = 50
	guarantees_roundstart_roleset = FALSE
	lycker_slots = 2
	wretch_slot_cap = 5

/datum/storyteller/gamemode/no_antag/standard
	name = "Low Intensity"
	vote_desc = "No hard antagonists. A light spread of soft antagonists."
	desc = "No hard antags, wretches, or heretics. Lyckers max 2. Gnolls max 2. Hag present."
	color_theme = "#37b3a6"
	preset_pool = GAMEMODE_POOL_EXTENDED // it'll never get voted otherwise
	allow_dreamwalker = FALSE
	block_internal_hard = TRUE
	preferred_gnoll_mode = GNOLL_SCALING_FLAT	// max 2
	lycker_slots = 2
