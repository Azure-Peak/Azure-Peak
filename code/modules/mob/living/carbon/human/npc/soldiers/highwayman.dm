/mob/living/carbon/human/species/human/northern/highwayman
	npc_archetype = /datum/npc_archetype/highwayman
	ai_controller = /datum/ai_controller/human_npc
	faction = list(FACTION_BANDITS, FACTION_STATION)
	ambushable = FALSE
	dodgetime = 30
	d_intent = INTENT_PARRY
	blood_toll_bucket = STATS_KILLED_HIGHWAYMEN

/mob/living/carbon/human/species/human/northern/highwayman/ambush
	threat_point = THREAT_HIGH
	ambush_faction = "bandits"

/mob/living/carbon/human/species/human/northern/highwayman/mount_reaver
	npc_archetype = /datum/npc_archetype/highwayman/mount_reaver
	name = "mount reaver"
	threat_point = THREAT_TOUGH
	ambush_faction = "bandits"

/mob/living/carbon/human/species/human/northern/highwayman/archer
	npc_archetype = /datum/npc_archetype/highwayman/archer
	threat_point = THREAT_HIGH
	ambush_faction = "bandits"

/mob/living/carbon/human/species/human/northern/highwayman/crossbowman
	npc_archetype = /datum/npc_archetype/highwayman/crossbowman
	threat_point = THREAT_HIGH
	ambush_faction = "bandits"

/mob/living/carbon/human/species/human/northern/highwayman/road_knight
	npc_archetype = /datum/npc_archetype/highwayman/road_knight
	threat_point = THREAT_DEADLY
	ambush_faction = "bandits"

/mob/living/carbon/human/species/human/northern/highwayman/sharpshooter
	npc_archetype = /datum/npc_archetype/highwayman/sharpshooter
	threat_point = THREAT_DEADLY
	ambush_faction = "bandits"
