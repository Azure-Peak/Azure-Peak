/mob/living/carbon/human/species/elf/dark/drowraider/scourge
	threat_point = THREAT_ELITE
	dodgetime = 20
	npc_archetype = /datum/npc_archetype/drow/scourge

/mob/living/carbon/human/species/elf/dark/drowraider/scourge/after_creation()
	..()
	job = "Drow Scourge"
	real_name = "[real_name] [pick("the Scourge", "the Lasher", "the Venomed", "the Spiderkin", "the Flenser")]"
	name = real_name
	ADD_TRAIT(src, TRAIT_BADTRAINER, TRAIT_GENERIC)
