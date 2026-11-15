GLOBAL_LIST_INIT(bounty_posters, list(
	"AZURIA" = "The Justiciary of Azuria",
	"GRENZELHOFT" = "The Grenzelhoftian Holy See",
	"OTAVAN" = "The Otavan Orthodoxy"
))

GLOBAL_LIST_INIT(wretch_severities, list(
	"MISDEED" = "Misdeed",
	"HARM" = "Harm towards lyfe",
	"ATROCITY" = "Horrific atrocities",
	"UNFORGIVABLE" = "Unforgivable sins against mankind",
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
		"name" = "Hefty", //T1 Debuff
		"min" = 200,
		"max" = 250
	)
))

GLOBAL_LIST_INIT(wretch_bounty_severities, list(
	"MISDEED" = list(
		"name" = "Misdeed", //T1 Debuff
		"min" = 100,
		"max" = 250
	),
	"HARM" = list(
		"name" = "Harm towards lyfe", //T2 Debuff
		"min" = 250,
		"max" = 400
	),
	"ATROCITY" = list(
		"name" = "Horrific atrocities", //T3 Debuff
		"min" = 400,
		"max" = 500
	),
	"UNFORGIVABLE" = list(
		"name" = "Unforgivable sins against mankind", //Pacifism
		"min" = 501,
		"max" = 750
	),
))

GLOBAL_LIST_INIT(bandit_bounty_severities, list(
	"FISH" = list(
		"name" = "Small Fish", //T2 Debuff
		"min" = 250,
		"max" = 400
	),
	"BUTCHER" = list(
		"name" = "Bay Butcher", //T3 Debuff
		"min" = 400,
		"max" = 500
	),
	"BOOGEYMAN" = list(
		"name" = "Azurean Boogeyman", //Pacifism
		"min" = 501,
		"max" = 1000
	)
))
