/datum/foreign_nation/grenzelhoft
	id = NATIONALITY_GRENZELHOFT
	name = "Grenzelhoft"
	auto_discovered = TRUE
	roll_weight = TRADE_NATION_WEIGHT_NEIGHBOR
	ship_name_words = list(
		"Eisernen", "Sturm", "Adler", "Wolf", "Drache",
		"Schwert", "Bruder", "Krone", "Burg", "Wappen",
		"Hammer", "Nordlicht", "Falken", "Reiter", "Greif",
	)
	captain_first_names = list(
		"Heinrich", "Konrad", "Dietrich", "Ulrich", "Gerhard",
		"Hartmann", "Albrecht", "Reinhart", "Hermann", "Sigmund",
		"Adelheid", "Mechthild", "Hedwig", "Irmgard", "Kunigunde",
	)
	captain_last_names = list(
		"Faber", "Krummhorn", "Wolfsbein", "Hartwald", "von Apfelweinheim",
		"Eisenberg", "Falkenried", "Sturmwacht", "von Zenitstadt", "von Hochburg",
	)
	ship_types = list(
		list("name" = "Coaster", "tonnage" = 30, "weight" = 15),
		list("name" = "Cog", "tonnage" = 120, "weight" = 50),
		list("name" = "Hulk", "tonnage" = 250, "weight" = 25),
		list("name" = "Carrack", "tonnage" = 500, "weight" = 10),
	)
	city_tags = list(
		"Apfelweinheim", "Zenitstadt", "Eisenhafen", "Silbergrund",
		"Hochburg", "Sterneberg", "Sankt Averial",
	)
	city_tag_chance = 35
	city_tag_format = "aus %CITY%"
	cultural_goods = list()
	preferred_imports = list()
	preferred_exports = list()
