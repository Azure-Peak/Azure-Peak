/datum/foreign_nation/kazengun
	id = NATIONALITY_KAZENGUN
	name = "Kazengun"
	auto_discovered = FALSE
	single_word_base = TRUE
	ship_name_words = list(
		"Tsuru", "Hayabusa", "Akatsuki", "Tsuki", "Ame",
		"Sora", "Kaze", "Yume", "Hoshi", "Suzu",
		"Sakura", "Take", "Yuki", "Nami",
	)
	captain_first_names = list(
		"Masakatsu", "Yoshitaka", "Kagetora", "Tadanaga", "Hidemori",
		"Naomasa", "Tomoe", "Kaoruko", "Chiyo", "Sen",
		"Kikyō", "Tsuneyori", "Sadanobu", "Harukage", "Yorinaga",
	)
	captain_last_names = list(
		"Niwa", "Sakuma", "Kasai", "Asakura", "Andō",
		"Kurogane", "Yamashiro", "Tsukinami", "Koganei", "Akizuki",
	)
	ship_types = list(
		list("name" = "Sekibune", "tonnage" = 90, "weight" = 35),
		list("name" = "Bezaisen", "tonnage" = 120, "weight" = 40),
		list("name" = "Shuinsen", "tonnage" = 400, "weight" = 15),
		list("name" = "Atakebune", "tonnage" = 600, "weight" = 10),
	)
	name_suffixes = list(
		list("text" = "-Maru", "chance" = 75),
	)
	city_tags = list(
		"Iwoto", "Tamiro", "Kukui", "Matsuhama", "Aisataiji",
		"Bijai", "Mitihara", "Tatseshira",
	)
	city_tag_chance = 30
	city_tag_format = "of %CITY%"
	cultural_goods = list()
	preferred_imports = list()
	preferred_exports = list()
