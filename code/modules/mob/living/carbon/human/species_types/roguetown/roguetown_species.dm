/datum/species
	var/amtfail = 0

/datum/species/proc/get_accent_list(mob/living/carbon/human/H, type)
	switch(H.char_accent)
		if("No accent")
			return
		if("Dwarf accent")
			return strings("dwarfcleaner_replacement.json", type)
		if("Dwarf Gibberish accent")
			return strings("dwarf_replacement.json", type)
		if("Dark Elf accent")
			return strings("french_replacement.json", type)
		if("Elf accent")
			return strings("russian_replacement.json", type)
		if("Grenzelhoft accent")
			return strings("german_replacement.json", type)
		if("Hammerhold accent")
			return strings("Anglish.json", type)
		if("Assimar accent")
			return strings("proper_replacement.json", type)
		if("Lizard accent")
			return strings("brazillian_replacement.json", type)
		if("Tiefling accent")
			return strings("spanish_replacement.json", type)
		if("Half Orc accent")
			return strings("middlespeak.json", type)
		if("Urban Orc accent")
			return strings("norf_replacement.json", type)
		if("Hissy accent")
			return strings("hissy_replacement.json", type)
		if("Inzectoid accent")
			return strings("inzectoid_replacement.json", type)
		if("Feline accent")
			return strings("feline_replacement.json", type)
		if("Slopes accent")
			return strings("welsh_replacement.json", type)

/datum/species/proc/get_accent(mob/living/carbon/human/H)
	return get_accent_list(H,"full")

/datum/species/proc/get_accent_any(mob/living/carbon/human/H) //determines if accent replaces in-word text
	return get_accent_list(H,"syllable")

/datum/species/proc/get_accent_start(mob/living/carbon/human/H)
	return get_accent_list(H,"start")

/datum/species/proc/get_accent_end(mob/living/carbon/human/H)
	return get_accent_list(H,"end")

#define REGEX_FULLWORD 1
#define REGEX_STARTWORD 2
#define REGEX_ENDWORD 3
#define REGEX_ANY 4

/datum/species/proc/handle_speech(datum/source, mob/speech_args)
	var/message = speech_args[SPEECH_MESSAGE]

	message = autopunct_bare(message)

	speech_args[SPEECH_MESSAGE] = trim(message)

#undef REGEX_FULLWORD
#undef REGEX_STARTWORD
#undef REGEX_ENDWORD
#undef REGEX_ANY
