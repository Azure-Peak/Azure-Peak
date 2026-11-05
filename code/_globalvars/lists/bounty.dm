GLOBAL_LIST_INIT(bounty_posters, list(
	"AZURIA" = "The Justiciary of Azuria",
	"GRENZELHOFT" = "The Grenzelhoftian Holy See",
	"OTAVAN" = "The Otavan Orthodoxy"
))

GLOBAL_LIST_INIT(wretch_severities, list(
	"MISDEED" = "Misdeed",
	"HARM" = "Harm towards lyfe",
	"ATROCITY" = "Horrific atrocities",
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
		"name" = "Meager", //T1 Debuff
		"min" = 100,
		"max" = 150
	),
	"MODERATE" = list(
		"name" = "Moderate", //T1 Debuff
		"min" = 150,
		"max" = 200
	),
	"HEFTY" = list(
		"name" = "Hefty", //T2 Debuff
		"min" = 200,
		"max" = 250
	)
))

GLOBAL_LIST_INIT(wretch_bounty_severities, list(
	"MISDEED" = list(
		"name" = "Misdeed", //T1 - T2 Debuff, random
		"min" = 100,
		"max" = 250
	),
	"HARM" = list(
		"name" = "Harm towards lyfe", //T2 - T3 Debuff, random
		"min" = 250,
		"max" = 399
	),
	"ATROCITY" = list(
		"name" = "Horrific atrocities", //Pacifism
		"min" = 400,
		"max" = 500
	),
))

GLOBAL_LIST_INIT(bandit_bounty_severities, list(
	"FISH" = list(
		"name" = "Small Fish", //T2 debuff
		"min" = 200,
		"max" = 300
	),
	"BUTCHER" = list(
		"name" = "Bay Butcher", //T3 Debuff
		"min" = 300,
		"max" = 399
	),
	"BOOGEYMAN" = list(
		"name" = "Azurean Boogeyman", //Pacifism
		"min" = 400,
		"max" = 800
	)
))
