GLOBAL_LIST_INIT(character_accents, list("No accent",
	"Dwarf accent",
	"Dwarf Gibberish accent",
	"Dark Elf accent",
	"Elf accent",
	"Grenzelhoft accent",
	"Hammerhold accent",
	"Assimar accent",
	"Lizard accent",
	"Tiefling accent",
	"Half Orc accent",
	"Urban Orc accent",
	"Hissy accent",
	"Inzectoid accent",
	"Feline accent",
	"Slopes accent",
	// Emerald Summit accents
	"Otavan accent",
	"North Etruscan accent",
	"Lupian accent",
	"Valley accent",
	"Kazengun accent",
	"West Kazengun accent",
	"Avar accent",
	"Pirate accent",
	"Posh accent",
	"Saut al-Atash accent"))

// Accent names mapped to font span lists, applied when speaking Common.
GLOBAL_LIST_INIT(accent_spans, list(
	"Saut al-Atash accent" = list(SPAN_SANDWAUK),
	"Kazengun accent" = list(SPAN_KAZENACCENT),
	"Posh accent" = list(SPAN_POSH),
	//Add font-based accents here as needed
))
