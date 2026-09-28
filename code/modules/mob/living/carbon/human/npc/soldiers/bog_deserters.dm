/mob/living/carbon/human/species/human/northern/bog_deserters
	npc_archetype = /datum/npc_archetype/bog_deserter/mixed
	ai_controller = /datum/ai_controller/human_npc
	faction = list(FACTION_BANDITS)
	ambushable = FALSE
	cmode = 1
	setparrytime = 30
	a_intent = INTENT_HELP
	d_intent = INTENT_PARRY
	possible_mmb_intents = list(INTENT_BITE, INTENT_JUMP, INTENT_KICK, INTENT_SPECIAL)
	blood_toll_bucket = STATS_KILLED_BOGMEN

/mob/living/carbon/human/species/human/northern/bog_deserters/ambush
	threat_point = THREAT_DANGEROUS
	ambush_faction = "bandits"

/mob/living/carbon/human/species/human/northern/bog_deserters/better_gear
	npc_archetype = /datum/npc_archetype/bog_deserter/better_gear
	faction = list(FACTION_BANDITS, FACTION_STATION)

/mob/living/carbon/human/species/human/northern/bog_deserters/better_gear/ambush
	threat_point = THREAT_DANGEROUS

/mob/living/carbon/human/species/human/northern/bog_deserters/tosser
	npc_archetype = /datum/npc_archetype/bog_deserter/tosser

/mob/living/carbon/human/species/human/northern/bog_deserters/tosser/ambush
	threat_point = THREAT_DANGEROUS
	ambush_faction = "bandits"

/mob/living/carbon/human/species/human/northern/bog_deserters/tosser/better_gear
	npc_archetype = /datum/npc_archetype/bog_deserter/tosser/better_gear

/mob/living/carbon/human/species/human/northern/bog_deserters/tosser/better_gear/ambush
	threat_point = THREAT_DANGEROUS

/mob/living/carbon/human/species/human/northern/bog_deserters/archer
	npc_archetype = /datum/npc_archetype/bog_deserter/archer

/mob/living/carbon/human/species/human/northern/bog_deserters/archer/ambush
	threat_point = THREAT_DANGEROUS
	ambush_faction = "bandits"

/mob/living/carbon/human/species/human/northern/bog_deserters/crossbowman
	npc_archetype = /datum/npc_archetype/bog_deserter/crossbowman

/mob/living/carbon/human/species/human/northern/bog_deserters/crossbowman/ambush
	threat_point = THREAT_DANGEROUS
	ambush_faction = "bandits"

/mob/living/carbon/human/species/human/northern/bog_deserters/marshal
	npc_archetype = /datum/npc_archetype/bog_deserter/better_gear/marshal
	threat_point = THREAT_ELITE

/mob/living/carbon/human/species/human/northern/bog_deserters/marshal/ambush
	threat_point = THREAT_ELITE
	ambush_faction = "bandits"
