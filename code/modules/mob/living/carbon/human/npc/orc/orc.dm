/mob/living/carbon/human/species/orc/
	name = "orc"
	skin_tone = SKIN_COLOR_GROONN
	hairstyle = "Bald"
	facial_hairstyle = "Shaved"

	race = /datum/species/orc
	gender = MALE
	blood_toll_bucket = STATS_KILLED_ORCS
	bodyparts = list(/obj/item/bodypart/chest, /obj/item/bodypart/head, /obj/item/bodypart/l_arm,
						/obj/item/bodypart/r_arm, /obj/item/bodypart/r_leg, /obj/item/bodypart/l_leg)
	ambushable = FALSE

	base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB, /datum/intent/unarmed/claw)
	a_intent = INTENT_HELP
	d_intent = INTENT_PARRY
	possible_mmb_intents = list(INTENT_SPECIAL, INTENT_JUMP, INTENT_KICK, INTENT_BITE)

/mob/living/carbon/human/species/orc/npc
	npc_archetype = /datum/npc_archetype/orc/savage
	faction = list(FACTION_ORCS, FACTION_STATION)
	ai_controller = /datum/ai_controller/human_npc
	cmode_music = FALSE
	ambush_faction = "orcs"

/mob/living/carbon/human/species/orc/npc/archer
	npc_archetype = /datum/npc_archetype/orc/savage/archer
	threat_point = THREAT_HIGH

/mob/living/carbon/human/species/orc/npc/footsoldier
	npc_archetype = /datum/npc_archetype/orc/footsoldier
	threat_point = THREAT_HIGH
	ambush_faction = "orcs"

/mob/living/carbon/human/species/orc/npc/marauder
	npc_archetype = /datum/npc_archetype/orc/marauder
	threat_point = THREAT_DANGEROUS

/mob/living/carbon/human/species/orc/npc/berserker
	npc_archetype = /datum/npc_archetype/orc/berserker
	threat_point = THREAT_DANGEROUS

/mob/living/carbon/human/species/orc/npc/warlord
	npc_archetype = /datum/npc_archetype/orc/warlord
	threat_point = THREAT_DEADLY

/mob/living/carbon/human/species/orc/npc/juggernaut
	npc_archetype = /datum/npc_archetype/orc/warlord/juggernaut
	threat_point = THREAT_ELITE
	ambush_faction = "orcs"
