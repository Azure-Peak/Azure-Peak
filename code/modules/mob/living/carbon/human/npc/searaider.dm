/mob/living/carbon/human/species/human/northern/searaider
	npc_archetype = /datum/npc_archetype/searaider
	ai_controller = /datum/ai_controller/human_npc
	d_intent = INTENT_PARRY
	faction = list(FACTION_GRONNMEN, FACTION_STATION)
	ambushable = FALSE
	dodgetime = 30
	blood_toll_bucket = STATS_KILLED_GRONNMEN

/mob/living/carbon/human/species/human/northern/searaider/ambush
	threat_point = THREAT_TOUGH
	ambush_faction = "raiders"

/mob/living/carbon/human/species/human/northern/searaider/archer
	npc_archetype = /datum/npc_archetype/searaider/archer

/mob/living/carbon/human/species/human/northern/searaider/archer/scarce
	npc_archetype = /datum/npc_archetype/searaider/archer/scarce

/mob/living/carbon/human/species/human/northern/searaider/archer/ambush
	threat_point = THREAT_TOUGH
	ambush_faction = "raiders"

/mob/living/carbon/human/species/human/northern/searaider/archer/ambush/reaver
	npc_archetype = /datum/npc_archetype/searaider/archer/reaver

/mob/living/carbon/human/species/human/northern/searaider/huscarl
	npc_archetype = /datum/npc_archetype/searaider/huscarl
	threat_point = THREAT_DEADLY

/mob/living/carbon/human/species/human/northern/searaider/huscarl/ambush
	threat_point = THREAT_DEADLY
	ambush_faction = "raiders"

/mob/living/carbon/human/species/human/northern/searaider/caster
	npc_archetype = /datum/npc_archetype/searaider/caster/mixed
	threat_point = THREAT_DANGEROUS
	ambush_faction = "raiders"

/mob/living/carbon/human/species/human/northern/searaider/caster/pyromancer
	npc_archetype = /datum/npc_archetype/searaider/caster/pyromancer

/mob/living/carbon/human/species/human/northern/searaider/caster/ferramancer
	npc_archetype = /datum/npc_archetype/searaider/caster/ferramancer
