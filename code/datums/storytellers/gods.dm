/// Divine pantheon storytellers
#define DIVINE_STORYTELLERS list( \
	/datum/storyteller/astrata, \
	/datum/storyteller/noc, \
	/datum/storyteller/ravox, \
	/datum/storyteller/abyssor, \
	/datum/storyteller/xylix, \
	/datum/storyteller/necra, \
	/datum/storyteller/pestra, \
	/datum/storyteller/malum, \
	/datum/storyteller/eora, \
	/datum/storyteller/dendor, \
	/datum/storyteller/psydon, \
)

//Yeah-yeah, he's not the same pantheon but suck it up, buttercup. We not makin' more defines.

/// Inhumen pantheon storytellers
#define INHUMEN_STORYTELLERS list( \
	/datum/storyteller/zizo, \
	/datum/storyteller/baotha, \
	/datum/storyteller/graggar, \
	/datum/storyteller/matthios, \
)

/// All storytellers
#define STORYTELLERS_ALL (DIVINE_STORYTELLERS + INHUMEN_STORYTELLERS)

/datum/storyteller/psydon
	name = "Psydon"
	vote_desc = "Peace reigns. No villains will be present. His children can rest easy, for they have earned their respite"
	desc = "Mundane and moderate events fire 1.2x more often. No antagonists, no divine intervention. Gnolls absent."
	welcome_text = "A temperate breeze rolls through the quiet streets.."
	weight = 6
	always_votable = TRUE
	color_theme = "#80ced8"
	preferred_gnoll_mode = GNOLL_SCALING_NONE
	wretch_slot_cap = 0
	guarantees_roundstart_roleset = FALSE
	roundstart_prob = 0

	//Has no influence, your actions will not impact him his spawn rates. Cus he's asleep.
	//Tl;dr - higher event spawn rates to keep stuff interesting, no god intervention, no antags. (Raids and omens will still happen at normal rate.)
	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1.2,
		EVENT_TRACK_MODERATE = 1.2,
		EVENT_TRACK_INTERVENTION = 0,			//No god intervention, cus he's asleep.
		EVENT_TRACK_CHARACTER_INJECTION = 0,	//No antagonist spawns.
	)

/datum/storyteller/astrata
	name = "Astrata"
	vote_desc = "Order reigns. No great villains will rise, and gnolls do not stalk her daelight. Her favor shines upon nobility and their decrees."
	desc = "Bandits, liches, werewolves, and vampire lords cannot roll. Masquerade is the only roundstart hard antag and gets a 1.5x weight bump. Gnolls absent. Wretches scale normally."
	welcome_text = "The warmth of daelight rouses you from your slumber.."
	weight = 6
	always_votable = TRUE
	follower_modifier = LOWER_FOLLOWER_MODIFIER
	color_theme = "#FFD700"
	preferred_gnoll_mode = GNOLL_SCALING_NONE
	guarantees_roundstart_roleset = FALSE
	roundstart_prob = 0

	starting_point_multipliers = list(
		EVENT_TRACK_CHARACTER_INJECTION = 0,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_CHARACTER_INJECTION = 0,	//No antagonist spawns under Her order.
	)

	influence_sets = list(
	"Set 1" = list(
		STATS_LAWS_AND_DECREES_MADE = list("name" = "Laws and decrees:", "points" = 2.75, "capacity" = 45),
	),
	"Set 2" = list(
		STATS_ALIVE_NOBLES = list("name" = "Number of nobles:", "points" = 2.5, "capacity" = 60),
	),
	"Set 3" = list(
		STATS_NOBLE_DEATHS = list("name" = "Noble deaths:", "points" = -3.75, "capacity" = -60),
		STATS_PEOPLE_SMITTEN = list("name" = "People smitten:", "points" = 4, "capacity" = 40),
	),
	"Set 4" = list(
		STATS_ASTRATA_REVIVALS = list("name" = "Holy revivals:", "points" = 6, "capacity" = 75),
		STATS_PRAYERS_MADE = list("name" = "Prayers made:", "points" = 2.25, "capacity" = 65),
	),
	"Set 5" = list(
		STATS_TAXES_COLLECTED = list("name" = "Taxes collected:", "points" = 0.2, "capacity" = 80),
	))

/datum/storyteller/noc
	name = "Noc"
	vote_desc = "Knowledge reigns. Occurrences are tame, but remain suspectable to arcyne intervention. His favor shines upon those who dream for greater ambitions."
	desc = "Magical events fire 1.2x more often, haunted 1.1x. Higher event cost variance. No antag pool changes. Single gnoll possible."
	welcome_text = "The air crackles with arcyne energy.."
	weight = 4
	always_votable = TRUE
	color_theme = "#F0F0F0"
	preferred_gnoll_mode = GNOLL_SCALING_SINGLE

	tag_multipliers = list(
		TAG_MAGICAL = 1.2,
		TAG_HAUNTED = 1.1,
	)
	cost_variance = 25

	influence_sets = list(
		"Set 1" = list(
			STATS_BOOKS_PRINTED = list("name" = "Books printed:", "points" = 2, "capacity" = 40),
		),
		"Set 2" = list(
			STATS_LITERACY_TAUGHT = list("name" = "Literacy taught:", "points" = 20, "capacity" = 140),
		),
		"Set 3" = list(
			STATS_BOOKS_BURNED = list("name" = "Books burned:", "points" = -2, "capacity" = -50),
		),
		"Set 4" = list(
			STATS_SKILLS_DREAMED = list("name" = "Skills dreamed:", "points" = 0.325, "capacity" = 100),
		),
		"Set 5" = list(
			STATS_VOYEURS = list("name" = "Voyeurs:", "points" = 5, "capacity" = 50),
		),
	)

/datum/storyteller/ravox
	name = "Ravox"
	vote_desc = "Glory reigns. Raids and omens are more likely to occur. His favor shines upon clashing steel and the cries of war - though no villains nor gnolls answer His call."
	desc = "Raids fire 2x more often (track gain) and raid events get a 1.3x weight bump. No antagonists at all. Mundane and personal events suppressed. Gnolls absent."
	welcome_text = "\"The trumpets of Zericho are echoing in the distance..\""
	weight = 4
	always_votable = TRUE
	color_theme = "#228822"
	preferred_gnoll_mode = GNOLL_SCALING_NONE
	guarantees_roundstart_roleset = FALSE
	roundstart_prob = 0

	tag_multipliers = list(
		TAG_RAID = 1.3,
	)

	starting_point_multipliers = list(
		EVENT_TRACK_CHARACTER_INJECTION = 0,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 0.75,
		EVENT_TRACK_PERSONAL = 0.9,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 1,
		EVENT_TRACK_CHARACTER_INJECTION = 0,	//No antagonist spawns - raids and omens carry the conflict.
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 2,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_COMBAT_SKILLS = list("name" = "Combat skills learned:", "points" = 1.065, "capacity" = 90),
		),
		"Set 2" = list(
			STATS_PARRIES = list("name" = "Parries made:", "points" = 0.052, "capacity" = 100),
		),
		"Set 3" = list(
			STATS_WARCRIES = list("name" = "Warcries made:", "points" = 0.35, "capacity" = 50),
		),
		"Set 4" = list(
			STATS_YIELDS = list("name" = "Yields made:", "points" = -4.25, "capacity" = -40),
		),
		"Set 5" = list(
			STATS_THRILLSEEKERS = list("name" = "Thrillseekers:", "points" = 5, "capacity" = 50)
		)
	)

/datum/storyteller/abyssor
	name = "Abyssor"
	vote_desc = "Water reigns. Occurrences are tame, though their temperance oft-sways with the tide's flow. His favor shines upon the fished, leeched, and drowned - dreamwalkers ride the deep, but no gnolls dare His shores."
	desc = "Water events get a 1.3x weight bump, trade 1.2x. Dreamwalker gets a 1.5x weight bump in the antag pool. Gnolls absent."
	welcome_text = "The horizon grows dark, as its clouds gather for a coming storm.."
	weight = 4
	always_votable = TRUE
	color_theme = "#3366CC"
	preferred_gnoll_mode = GNOLL_SCALING_NONE

	tag_multipliers = list(
		TAG_WATER = 1.3,
		TAG_TRADE = 1.2,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_FISH_CAUGHT = list("name" = "Fish caught:", "points" = 1.75, "capacity" = 85),
		),
		"Set 2" = list(
			STATS_WATER_CONSUMED = list("name" = "Water consumed:", "points" = 0.014, "capacity" = 90),
		),
		"Set 3" = list(
			STATS_ABYSSOR_REMEMBERED = list("name" = "Abyssor remembered:", "points" = 1.1, "capacity" = 50),
			STATS_ALIVE_AXIAN = list("name" = "Number of axians:", "points" = 8, "capacity" = 70),
		),
		"Set 4" = list(
			STATS_LEECHES_EMBEDDED = list("name" = "Leeches embedded:", "points" = 0.75, "capacity" = 70),
		),
		"Set 5" = list(
			STATS_PEOPLE_DROWNED = list("name" = "People drowned:", "points" = 12, "capacity" = 75),
			STATS_BATHS_TAKEN = list("name" = "Baths taken:", "points" = 4.5, "capacity" = 60),
		)
	)

/datum/storyteller/xylix
	name = "Xylix"
	vote_desc = "Unpredictability reigns. Nothing is set in stone, yet everything is possible. His favor shines upon acts of chance and whimsy."
	desc = "Forced events bypass population prerequisites and any event that's already fired this round drops to its full repetition penalty immediately. Intervention 1.75x; character injection, omens and raids suppressed to 0. All roundstart hard antags get a 1.5x weight bump. Gnoll mode randomized."
	welcome_text = "\"..well, that's what happens out of too much spice and wine!\""
	weight = 4
	always_votable = TRUE
	event_repetition_multiplier = 0
	forced = TRUE
	color_theme = "#AA8888"
	preferred_gnoll_mode = GNOLL_SCALING_RANDOM

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1.1,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 1.75,
		EVENT_TRACK_CHARACTER_INJECTION = 0,
		EVENT_TRACK_OMENS = 0,
		EVENT_TRACK_RAIDS = 0,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_LAUGHS_MADE = list("name" = "Laughs had:", "points" = 0.225, "capacity" = 85),
		),
		"Set 2" = list(
			STATS_PEOPLE_MOCKED = list("name" = "People mocked:", "points" = 5, "capacity" = 60),
		),
		"Set 3" = list(
			STATS_CRITS_MADE = list("name" = "Crits made:", "points" = 0.26, "capacity" = 90),
		),
		"Set 4" = list(
			STATS_SONGS_PLAYED = list("name" = "Songs played:", "points" = 0.675, "capacity" = 70),
			STATS_MOAT_FALLERS = list("name" = "Moat fallers:", "points" = 4, "capacity" = 50),
		)
	)

/datum/storyteller/necra
	name = "Necra"
	vote_desc = "Death reigns. Occurrences happen less often, and villains are less likely. Her favor shines upon those who put the deathless back into their graves."
	desc = "Haunted events get a 1.3x weight bump. Antag track and raid track gain points half as fast; personal events also slowed. Mundane and moderate events fire 1.25x more often. Single gnoll possible."
	welcome_text = "\"In the fief of Zenmarke, there was the odor of decay..\""
	weight = 4
	always_votable = TRUE
	color_theme = "#888888"
	preferred_gnoll_mode = GNOLL_SCALING_SINGLE

	tag_multipliers = list(
		TAG_HAUNTED = 1.3,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1.25,
		EVENT_TRACK_PERSONAL = 0.7,
		EVENT_TRACK_MODERATE = 1.25,
		EVENT_TRACK_INTERVENTION = 1.25,
		EVENT_TRACK_CHARACTER_INJECTION = 0.5,
		EVENT_TRACK_OMENS = 1.25,
		EVENT_TRACK_RAIDS = 0.5,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_DEATHS = list("name" = "Total deaths:", "points" = 1.35, "capacity" = 100),
		),
		"Set 2" = list(
			STATS_GRAVES_CONSECRATED = list("name" = "Graves consecrated:", "points" = 6.25, "capacity" = 80),
		),
		"Set 3" = list(
			STATS_GRAVES_ROBBED = list("name" = "Graves robbed:", "points" = -3.75, "capacity" = -40),
		),
		"Set 4" = list(
			STATS_DEADITES_KILLED = list("name" = "Deadites killed:", "points" = 6.25, "capacity" = 90),
		),
		"Set 5" = list(
			STATS_VAMPIRES_KILLED = list("name" = "Vampires killed:", "points" = 12.5, "capacity" = 70),
		),
		"Set 6" = list(		
			STATS_SKELETONS_KILLED = list("name" = "Skeletons killed:", "points" = 5, "capacity" = 50),
		)
	)

/datum/storyteller/pestra
	name = "Pestra"
	vote_desc = "Health reigns. Occurrences are tame, yet swayable with practiced hands. Her favor shines upon stitches and alchemists"
	desc = "Alchemy and medical events get a 1.2x weight bump, nature 1.1x. All hard antags roll at flat equal weight - no preference between bandits, liches, werewolves, or vampire lords. Single gnoll possible."
	welcome_text = "The clattering of instruments, and the churning of alchemical wonders.."
	color_theme = "#AADDAA"
	preferred_gnoll_mode = GNOLL_SCALING_SINGLE

	tag_multipliers = list(
		TAG_ALCHEMY = 1.2,
		TAG_MEDICAL = 1.2,
		TAG_NATURE = 1.1,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_POTIONS_BREWED = list("name" = "Potions brewed:", "points" = 5.25, "capacity" = 80),
		),
		"Set 2" = list(
			STATS_WOUNDS_SEWED = list("name" = "Wounds sewed up:", "points" = 0.48, "capacity" = 100),
		),
		"Set 3" = list(
			STATS_LUX_HARVESTED = list("name" = "Lux extracted:", "points" = 8, "capacity" = 70),
		),
		"Set 4" = list(
			STATS_LUX_REVIVALS = list("name" = "Lux revivals:", "points" = 16, "capacity" = 70),
		),
		"Set 5" = list(
			STATS_ROT_CURED = list("name" = "Rot cured:", "points" = 5, "capacity" = 70),
		),
		"Set 6" = list(
			STATS_FOOD_ROTTED = list("name" = "Food rotted:", "points" = 0.26, "capacity" = 80),
		)
	)

/datum/storyteller/malum
	name = "Malum"
	vote_desc = "Effort reigns. Divine intervention occurs more often. His favor shines upon masterworks and mineshafts."
	desc = "Work-tagged events get a 1.5x weight bump. Divine intervention fires 2x more often, personal events 1.2x. All hard antags roll at flat equal weight. Single gnoll possible."
	welcome_text = "The pounding of red-hot steel, and the laboring of a hundred calloused hands.."
	color_theme = "#D4A56C"
	preferred_gnoll_mode = GNOLL_SCALING_SINGLE

	tag_multipliers = list(
		TAG_WORK = 1.5,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1.2,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 2,
		EVENT_TRACK_CHARACTER_INJECTION = 1,
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 1,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_MASTERWORKS_FORGED = list("name" = "Masterworks forged:", "points" = 7, "capacity" = 85),
		),
		"Set 2" = list(
			STATS_ROCKS_MINED = list("name" = "Rocks mined:", "points" = 0.26, "capacity" = 100),
		),
		"Set 3" = list(
			STATS_CRAFT_SKILLS = list("name" = "Craft skills learned:", "points" = 0.4, "capacity" = 80),
		),
		"Set 4" = list(
			STATS_CRAFTED_ITEMS = list("name" = "Crafted items:", "points" = 0.1, "capacity" = 100), //So he doesn't reign every round
		),
		"Set 5" = list(
			STATS_BEARDS_SHAVED = list("name" = "Beards shaved:", "points" = -4, "capacity" = -40),
			STATS_ALIVE_DWARVES = list("name" = "Number of dwarfs:", "points" = 4, "capacity" = 45),
		),
	)

/datum/storyteller/eora
	name = "Eora"
	vote_desc = " Love reigns. Positive affairs occur more often, and She wills for none to be ill. No villains, no gnolls; only a small handful of wretches lurk at the fringe. Her favor shines upon romance."
	desc = "Widespread events get a 1.5x weight bump, boons 1.2x. No antagonists, no raids. Divine intervention fires 2x more often, personal events 1.4x. Wretches hard-capped at 5 slots. Gnolls absent."
	welcome_text = "\"Love is in the air? Nay; tis the smell of freshly-baked pies upon the windowsills!\""
	color_theme = "#9966CC"
	preferred_gnoll_mode = GNOLL_SCALING_NONE
	wretch_slot_cap = 5
	guarantees_roundstart_roleset = FALSE
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

	tag_multipliers = list(
		TAG_WIDESPREAD = 1.5,
		TAG_BOON = 1.2,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1.4,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 2,
		EVENT_TRACK_CHARACTER_INJECTION = 0,	//No antagonist spawns.
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 0,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_HUGS_MADE = list("name" = "Hugs made:", "points" = 2.5, "capacity" = 70),
		),
		"Set 2" = list(
			STATS_KISSES_MADE = list("name" = "Kisses made:", "points" = 7, "capacity" = 70),
		),
		"Set 3" = list(
			STATS_CLINGY_PEOPLE = list("name" = "Clingy people:", "points" = 6.5, "capacity" = 75),
		),
		"Set 4" = list(		
			STATS_BEAUTIFUL_PEOPLE = list("name" = "Beautiful people:", "points" = 9, "capacity" = 50),
		),
		"Set 5" = list(
			STATS_MARRIAGES_MADE = list("name" = "Marriages made:", "points" = 20, "capacity" = 80), //Rare so worth a ton.
		)
	)

/datum/storyteller/dendor
	name = "Dendor"
	vote_desc = " Nature reigns. Overgrowth and Verevolves are more likely to occur. His favor shines upon harvests and lycanthropes - gnolls keep their distance from His wilds."
	desc = "Nature events get a 1.5x weight bump. Werewolf is the only roundstart hard antag and gets a 1.5x weight bump - bandits, liches, and vampire lords cannot roll. Intervention fires 2x more often. Gnolls absent."
	welcome_text = "The cackling of perched zads, and the glimmer of morning dew.."
	weight = 4
	always_votable = TRUE
	color_theme = "#664422"
	preferred_gnoll_mode = GNOLL_SCALING_NONE

	tag_multipliers = list(
		TAG_NATURE = 1.5,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 0.8,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 2,
		EVENT_TRACK_CHARACTER_INJECTION = 1,
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 1,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_TREES_CUT = list("name" = "Trees felled:", "points" = -0.35, "capacity" = -45),
		),
		"Set 2" = list(
			STATS_PLANTS_HARVESTED = list("name" = "Plants harvested:", "points" = 0.75, "capacity" = 100),
		),
		"Set 3" = list(
			STATS_ANIMALS_TAMED = list("name" = "Animals tamed:", "points" = 3, "capacity" = 90),
		),
		"Set 4" = list(
			STATS_FOREST_DEATHS = list("name" = "Forest deaths:", "points" = 6, "capacity" = 90),
		),
		"Set 5" = list(
			STATS_WEREVOLVES = list("name" = "Number of werevolves:", "points" = 12.5, "capacity" = 65),
		),
	)

// INHUMEN

/datum/storyteller/zizo
	name = "Zizo"
	vote_desc = "Chaos reigns. Liches stir more readily than under any other god, and Deadites are far more vicious. Her favor shines upon corpses; be they holy, noble, or reanimated."
	desc = "Magical, gamble, trickery, and unexpected events get weight bumps (1.2x to 1.5x). Lich is guaranteed roundstart - bandits, werewolves, and vampire lords cannot roll. High event cost variance. Flat gnoll spawn (15% chance, 2 cap). Wretch T2 garrison expansion can fire."
	welcome_text = "A breeze of morbid air, ferrying the howls of the damned.."
	weight = 4
	always_votable = TRUE
	color_theme = "#CC4444"
	preferred_gnoll_mode = GNOLL_SCALING_FLAT
	wretch_slot_cap = 15

	tag_multipliers = list(
		TAG_MAGICAL = 1.2,
		TAG_GAMBLE = 1.5,
		TAG_TRICKERY = 1.3,
		TAG_UNEXPECTED = 1.2,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1.2,
		EVENT_TRACK_MODERATE = 1.1,
		EVENT_TRACK_INTERVENTION = 1.5,
		EVENT_TRACK_CHARACTER_INJECTION = 1,
		EVENT_TRACK_OMENS = 1.3,
		EVENT_TRACK_RAIDS = 0.8,
	)

	cost_variance = 50  // Events will be highly variable in cost

	influence_sets = list(
		"Set 1" = list(
			STATS_HUMEN_DEATHS = list("name" = "Humen killed:", "points" = 5.5, "capacity" = 80),
			STATS_CLERGY_DEATHS = list("name" = "Clergy killed:", "points" = 12, "capacity" = 70),
		),
		"Set 2" = list(
			STATS_DEADITES_WOKEN_UP = list("name" = "Deadites woken up:", "points" = 4, "capacity" = 85),
		),
		"Set 3" = list(
			STATS_DEADITES_ALIVE = list("name" = "Deadites alive:", "points" = 1, "capacity" = 40),
		),
		"Set 4" = list(
			STATS_LUX_HARVESTED = list("name" = "Clergy killed:", "points" = 12, "capacity" = 70),
		),
		"Set 5" = list(
			STATS_TORTURES = list("name" = "Tortures performed:", "points" = 5.25, "capacity" = 70),
		),
		"Set 6" = list(
			STATS_BOOKS_BURNED = list("name" = "Books burned:", "points" = 5, "capacity" = 50), //We actually gain influence from it
		),
	)

/datum/storyteller/baotha
	name = "Baotha"
	vote_desc = "Spice reigns. Occurrences are more erratic and negative. Her favor shines upon drunkards and addicts."
	desc = "Insanity, magic, and disaster events get weight bumps (1.1x to 1.4x). Vampire Lord is guaranteed roundstart - bandits, liches, and werewolves cannot roll. All event tracks accelerated. Gnoll mode randomized. Wretch T2 garrison expansion can fire."
	welcome_text = "The sickly sweet aromas of liqour and spice fills the air.."
	weight = 4
	always_votable = TRUE
	color_theme = "#9933FF"
	preferred_gnoll_mode = GNOLL_SCALING_RANDOM
	wretch_slot_cap = 15

	tag_multipliers = list(
		TAG_INSANITY = 1.4,
		TAG_MAGIC = 1.2,
		TAG_DISASTER = 1.1,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1.1,
		EVENT_TRACK_PERSONAL = 1.2,
		EVENT_TRACK_MODERATE = 1.3,
		EVENT_TRACK_INTERVENTION = 2,
		EVENT_TRACK_CHARACTER_INJECTION = 0.7,
		EVENT_TRACK_OMENS = 1.5,
		EVENT_TRACK_RAIDS = 1.2,
	)

	cost_variance = 30  // Makes events more erratic in timing

	influence_sets = list(
		"Set 1" = list(
			STATS_JUNKIES = list("name" = "Number of junkies:", "points" = 9, "capacity" = 70),
		),
		"Set 2" = list(
			STATS_DRUGS_SNORTED = list("name" = "Drugs snorted:", "points" = 4, "capacity" = 85),
		),
		"Set 3" = list(
			STATS_ALCOHOLICS = list("name" = "Number of alcoholics:", "points" = 3.25, "capacity" = 60),
		),
		"Set 4" = list(
			STATS_ALCOHOL_CONSUMED = list("name" = "Alcohol consumed:", "points" = 0.042, "capacity" = 90),
		),
		"Set 5" = list(
			STATS_NYMPHOMANIACS = list("name" = "Number of nymphomaniacs:", "points" = 6, "capacity" = 30),
		),
		"Set 6" = list(
			STATS_PLEASURES = list("name" = "Pleasures had:", "points" = 5, "capacity" = 50),
		),
	)

/datum/storyteller/graggar
	name = "Graggar"
	vote_desc = " Inhumenity reigns. Gnolls and assassins prowl more eagerly than under any other god, and raids occur far more often. His favor shines upon bloodshed and cannibalism."
	desc = "Battle, blood, and war events get weight bumps (1.2x to 1.6x). Gnolls and Assassins are guaranteed roundstart. Raid track gains 2.5x faster. Dynamic gnoll scaling - packs grow with population. Wretch T2 garrison expansion can fire."
	welcome_text = "Plumes of smoke are blown through the streets, reeking of ash and blood.."
	weight = 4
	always_votable = TRUE
	color_theme = "#8B3A3A"
	preferred_gnoll_mode = GNOLL_SCALING_DYNAMIC
	wretch_slot_cap = 15

	tag_multipliers = list(
		TAG_BATTLE = 1.6,
		TAG_BLOOD = 1.3,
		TAG_WAR = 1.2,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 0.8,
		EVENT_TRACK_PERSONAL = 0.7,
		EVENT_TRACK_MODERATE = 1.2,
		EVENT_TRACK_INTERVENTION = 1.5,
		EVENT_TRACK_CHARACTER_INJECTION = 1,
		EVENT_TRACK_OMENS = 0.9,
		EVENT_TRACK_RAIDS = 2.5,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_BLOOD_SPILT = list("name" = "Blood spilt:", "points" = 0.03, "capacity" = 60),
		),
		"Set 2" = list(
			STATS_ORGANS_EATEN = list("name" = "Organs eaten:", "points" = 5, "capacity" = 70),
		),
		"Set 3" = list(
			STATS_DEATHS = list("name" = "Deaths:", "points" = 5, "capacity" = 115),
		),
		"Set 4" = list(
			STATS_ASSASSINATIONS = list("name" = "Sucessful assassinations:", "points" = 20, "capacity" = 100),
		),
		"Set 5" = list(
			STATS_PEOPLE_GIBBED = list("name" = "People gibbed:", "points" = 3.5, "capacity" = 55),
		)
	)

	cost_variance = 10  // Less randomness, more direct

/datum/storyteller/matthios
	name = "Matthios"
	vote_desc = "Thievery reigns. Bandit incursions are far more common than under other gods. His favor shines upon thefts and offerings to a certain shrine."
	desc = "Trade, corruption, and loot events get weight bumps (1.2x to 1.4x). Bandits are guaranteed roundstart - liches, werewolves, and vampire lords cannot roll. Antag track gains 1.5x faster. Gnoll mode randomized. Wretch T2 garrison expansion can fire."
	welcome_text = "The jingling of mammons, and the dripping of ink from freshly-signed bounties.."
	weight = 4
	always_votable = TRUE
	color_theme = "#8B4513"
	preferred_gnoll_mode = GNOLL_SCALING_RANDOM
	wretch_slot_cap = 15

	tag_multipliers = list(
		TAG_TRADE = 1.4,
		TAG_CORRUPTION = 1.3,
		TAG_LOOT = 1.2,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1.1,
		EVENT_TRACK_MODERATE = 1.2,
		EVENT_TRACK_INTERVENTION = 1.3,
		EVENT_TRACK_CHARACTER_INJECTION = 1.5,
		EVENT_TRACK_OMENS = 1.1,
		EVENT_TRACK_RAIDS = 0.6,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_NOBLE_DEATHS = list("name" = "Nobles killed:", "points" = 5.5, "capacity" = 80),
		),
		"Set 2" = list(
			STATS_SHRINE_VALUE = list("name" = "Value offered to his idol:", "points" = 0.08, "capacity" = 70),
		),
		"Set 3" = list(
			STATS_GREEDY_PEOPLE = list("name" = "Number of greedy people:", "points" = 6.5, "capacity" = 70),
			STATS_INDEBTED = list("name"= "Number of indebted people:", "points" = 5, "capacity" = 25),
		),
		"Set 4" = list(		
			STATS_ITEMS_PICKPOCKETED = list("name" = "Items pickpocketed:", "points" = 4.5, "capacity" = 80),
		),
		"Set 5" = list(
			STATS_LOCKS_PICKED = list("name" = "Locks picked:", "points" = 3.75, "capacity" = 80),
		)
	)

	cost_variance = 15  // Keeps a balance between predictability and randomness

#undef DIVINE_STORYTELLERS
#undef INHUMEN_STORYTELLERS
#undef STORYTELLERS_ALL
