GLOBAL_LIST_INIT(bounty_posters, list(
	"AZURIA" = "The Justiciary of Azuria",
	"GRENZELHOFT" = "The Grenzelhoftian Holy See",
	"OTAVAN" = "The Otavan Orthodoxy"
))

GLOBAL_LIST_INIT(wretch_severities, list(
	"MISDEED" = "Misdeed",
	"HARM" = "Harm towards lyfe",
	"ATROCITY" = "Horrific atrocities"
))

GLOBAL_LIST_INIT(vagabond_severities, list(
	"MEAGER" = "Meager",
	"MODERATE" = "Moderate",
	"HEFTY" = "Hefty"
))

GLOBAL_LIST_INIT(bandit_severities, list(
	"FISH" = "Small Fish",
	"BUTCHER" = "Bay Butcher",
	"BOOGEYMAN" = "Azurean Boogeyman"
))

GLOBAL_LIST_INIT(vagabond_bounty_severities, list(
	"MEAGER" = list(
		"name" = "Meager",
		"min" = 60, 		// 60 minimal, you're not off-the-hook
		"max" = 80
	),
	"MODERATE" = list(
		"name" = "Moderate",
		"min" = 100,
		"max" = 150
	),
	"HEFTY" = list(
		"name" = "Hefty",
		"min" = 200,
		"max" = 250			// Goes up slightly with bringing them in alive being difficult + memechads that take crit weakness + DNR
	)
))

GLOBAL_LIST_INIT(wretch_bounty_severities, list(
	"MISDEED" = list(
		"name" = "Misdeed",
		"min" = 100, 		// Felinid said we should gate it at 100 or so on at the lowest, so that wretch cannot ezmode it.
		"max" = 200
	),
	"HARM" = list(
		"name" = "Harm towards lyfe",
		"min" = 200,
		"max" = 300
	),
	"ATROCITY" = list(
		"name" = "Horrific atrocities",
		"min" = 300,
		"max" = 400
	)
))

GLOBAL_LIST_INIT(bandit_bounty_severities, list(
	"FISH" = list(
		"name" = "Small Fish",
		"min" = 300,
		"max" = 400
	),
	"BUTCHER" = list(
		"name" = "Bay Butcher",
		"min" = 400,
		"max" = 500
	),
	"BOOGEYMAN" = list(
		"name" = "Azurean Boogeyman",
		"min" = 500,
		"max" = 600
	)
))
