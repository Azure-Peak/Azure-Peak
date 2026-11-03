/datum/npc_warband/bog_guard_deserters
	name = "Bog Deserter Patrol"
	category = FACTION_BANDITS
	faction_tag = "bandits"
	members = list(
		/mob/living/carbon/human/species/human/northern/bog_deserters/ambush = 2,
		/mob/living/carbon/human/species/human/northern/bog_deserters/better_gear/ambush = 1,
	)

/datum/npc_warband/bog_guard_deserters/hard
	name = "Bog Deserter Veterans"
	members = list(
		/mob/living/carbon/human/species/human/northern/bog_deserters/better_gear/ambush = 2,
		/mob/living/carbon/human/species/human/northern/bog_deserters/ambush = 1,
	)
