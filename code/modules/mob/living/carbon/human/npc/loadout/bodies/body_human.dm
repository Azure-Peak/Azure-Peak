/datum/npc_body/northern_commoner
	species_pool = NPC_RACES_TYPES
	male_name_file = "strings/names/first_male.txt"
	female_name_file = "strings/names/first_female.txt"

/datum/npc_body/northern_commoner/soldier
	voicepack_chance = 30
	voicepacks = list(
		list(/datum/voicepack/male/warrior, /datum/voicepack/female/warrior),
		list(/datum/voicepack/male/stern, /datum/voicepack/female/haughty),
		list(/datum/voicepack/male/foppish, /datum/voicepack/female/dainty),
		list(/datum/voicepack/male/knight, /datum/voicepack/female/haughty),
	)
