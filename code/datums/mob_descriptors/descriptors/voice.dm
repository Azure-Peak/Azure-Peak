/datum/mob_descriptor/voice
	abstract_type = /datum/mob_descriptor/voice
	slot = MOB_DESCRIPTOR_SLOT_VOICE
	verbage = "%SPEAK%"
	prefix = "a"
	suffix = "voice"

/datum/mob_descriptor/voice/proc/get_speaking_name(var/voice_gender)
	return "[name] [voice_gender]"

/datum/mob_descriptor/voice/ordinary
	name = "Ordinary"
	prefix = "an"

/datum/mob_descriptor/voice/monotone
	name = "Monotone"

/datum/mob_descriptor/voice/deep
	name = "Deep"

/datum/mob_descriptor/voice/soft
	name = "Soft"

/datum/mob_descriptor/voice/shrill
	name = "Shrill"

/datum/mob_descriptor/voice/sleepy
	name = "Sleepy"

/datum/mob_descriptor/voice/commanding
	name = "Commanding"

/datum/mob_descriptor/voice/kind
	name = "Kind"

/datum/mob_descriptor/voice/growly
	name = "Growly"

/datum/mob_descriptor/voice/androgynous
	name = "Androgynous"
	prefix = "an"

/datum/mob_descriptor/voice/androgynous/get_speaking_name(var/voice_gender)
	return "Androgynous Person"

/datum/mob_descriptor/voice/nasal
	name = "Nasal"

/datum/mob_descriptor/voice/refined
	name = "Refined"

/datum/mob_descriptor/voice/cheery
	name = "Cheery"

/datum/mob_descriptor/voice/dispassionate
	name = "Dispassionate"

/datum/mob_descriptor/voice/gravelly
	name = "Gravelly"

/datum/mob_descriptor/voice/whiny
	name = "Whiny"

/datum/mob_descriptor/voice/melodic
	name = "Melodic"

/datum/mob_descriptor/voice/drawling
	name = "Drawling"

/datum/mob_descriptor/voice/stilted
	name = "Stilted"

/datum/mob_descriptor/voice/grave
	name = "Grave"

/datum/mob_descriptor/voice/doting
	name = "Doting"

/datum/mob_descriptor/voice/booming
	name = "Booming"

/datum/mob_descriptor/voice/lisping
	name = "Lisping"

/datum/mob_descriptor/voice/honeyed
	name = "Honeyed"

/datum/mob_descriptor/voice/facetious
	name = "Facetious"

/datum/mob_descriptor/voice/snide
	name = "Snide"

/datum/mob_descriptor/voice/smoker
	name = "Smoker's"

/datum/mob_descriptor/voice/smoker/get_speaking_name(var/voice_gender)
	return "Gravelly [voice_gender]"

/datum/mob_descriptor/voice/venomous
	name = "Venomous"
