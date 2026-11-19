/datum/storyteller/psydon
	name = "Psydon"
	color_theme = "#80ced8"

	//Has no influence, your actions will not impact him his spawn rates. Cus he's asleep.

/datum/storyteller/astrata
	name = "Astrata"
	follower_modifier = LOWER_FOLLOWER_MODIFIER
	color_theme = "#FFD700"

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
	color_theme = "#F0F0F0"

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
	color_theme = "#228822"

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
	color_theme = "#3366CC"

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
	color_theme = "#AA8888"

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
	color_theme = "#888888"

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
	color_theme = "#AADDAA"

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
	color_theme = "#D4A56C"

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
	color_theme = "#9966CC"

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
	color_theme = "#664422"

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
	color_theme = "#CC4444"

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
	color_theme = "#9933FF"

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
	color_theme = "#8B3A3A"

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

/datum/storyteller/matthios
	name = "Matthios"
	color_theme = "#8B4513"

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
			STATS_LOCKS_PICKED = list("name" = "Locks picked:", "points" = 3.75, "capacity" = 80),
		)
	)
