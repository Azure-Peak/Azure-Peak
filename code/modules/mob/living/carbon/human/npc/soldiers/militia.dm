/mob/living/carbon/human/species/human/northern/militia
	npc_archetype = /datum/npc_archetype/militia
	ai_controller = /datum/ai_controller/human_npc
	d_intent = INTENT_PARRY
	faction = list(FACTION_NEUTRAL)
	ambushable = FALSE
	dodgetime = 28

/mob/living/carbon/human/species/human/northern/militia/ambush

/mob/living/carbon/human/species/human/northern/militia/guard

/mob/living/carbon/human/species/human/northern/militia/deserter
	npc_archetype = /datum/npc_archetype/militia/deserter
	threat_point = THREAT_MODERATE
	ambush_faction = "bandits"
	faction = list(FACTION_BANDITS, FACTION_STATION)
