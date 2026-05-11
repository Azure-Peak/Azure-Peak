/datum/foreign_realm/otava
	id = REALM_OTAVA
	name = "Otava"
	auto_discovered = TRUE
	roll_weight = TRADE_REALM_WEIGHT_NEIGHBOR
	ship_name_words = list(
		"Belle", "Coeur", "Lis", "Rose", "Etoile",
		"Faucon", "Lion", "Couronne", "Dame", "Chevalier",
		"Aurore", "Soleil", "Fleur", "Vent", "Vague",
	)
	proper_names = list(
		list("name" = "Astrata", "gender" = "f"),
		list("name" = "Eora", "gender" = "f"),
		list("name" = "Necra", "gender" = "f"),
		list("name" = "Pestra", "gender" = "f"),
		list("name" = "Noc", "gender" = "m"),
		list("name" = "Abyssor", "gender" = "m"),
		list("name" = "Ravox", "gender" = "m"),
		list("name" = "Malum", "gender" = "m"),
	)
	captain_first_names = list(
		"Henri", "Guillaume", "Charles", "Robert", "Aimery",
		"Jehan", "Thibault", "Gace", "Hugues", "Renaud",
		"Mahaut", "Jehanne", "Alix", "Aelis", "Sybille",
	)
	captain_last_names = list(
		"Lefèvre", "Fournier", "Mercier", "Tisserand", "Chevalier",
		"d'Esperance", "Bouchard", "Chastain", "Marchand", "le Vallouisard",
	)
	ship_types = list(
		list("name" = "Caravel", "tonnage" = 70, "weight" = 20),
		list("name" = "Galley", "tonnage" = 100, "weight" = 15),
		list("name" = "Nef", "tonnage" = 130, "weight" = 35),
		list("name" = "Great Galley", "tonnage" = 300, "weight" = 20),
		list("name" = "Galleon", "tonnage" = 600, "weight" = 10),
	)
	name_prefixes = list(
		list(
			"text_male" = "Saint-",
			"text_female" = "Sainte-",
			"chance" = 55,
			"requires_proper_name" = TRUE,
		),
		list("text_female" = "Notre-Dame de ", "chance" = 10, "requires_proper_name" = TRUE),
	)
	city_tags = list(
		"Esperance-Capitale", "Vallouise-sur-Mer", "Falaises-Rouges", "Verquent", "Noireau",
		"Vates", "Atagne", "Pais-Occitanie", "Lasquennes",
	)
	city_tag_chance = 30
	city_tag_format = "de %CITY%"
	cultural_goods = list()
