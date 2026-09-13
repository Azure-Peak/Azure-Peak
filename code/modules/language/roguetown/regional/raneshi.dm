/datum/language/raneshi
	name = "Sama'glos"
	desc = "The primary language of the Raneshi Empire, beginning its lyfe as a dialect of Celestial it maintains some mutual intelligibility with the parent tongue but is very much its own language."
	speech_verb = "states"
	ask_verb = "questions"
	exclaim_verb = "shouts"
	key = "j"
	space_chance = 70
	default_priority = 80
	icon_state = "raneshi"
	spans = list(SPAN_RANESHI)
	mutually_intelligible = list(/datum/language/celestial)//Come from same place apparently according to lore
	syllables = list(
		"bā", "alif", "tāʼ", "thāʼ", "jīm", "ḥāʼ", "khāʼ", "dāl", "dhāl", "rāʼ", "zayn", "zāy",
		"sīn", "shīn", "ṣād", "ʻayn", "ghayn", "fāʼ", "qāf", "kāf", "lām", "mīm", "nūn", "hāʼ",
		"wāw", "yāʼ", "alif", "maddah", "kas", "fatḥah", "lahū","qaṣr"
		)
