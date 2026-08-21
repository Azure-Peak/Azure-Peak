///For the Nosferatu Vampire Lord transformationn
/mob/living/simple_animal/hostile/retaliate/smallrat
	threat_point = THREAT_TRASH
	anatomy_type = /datum/anatomy/quadruped/trash
	attack_aim = MOB_AIM_GROUND
	name = "rat"
	desc = ""
	icon_state = "srat"
	icon = 'icons/roguetown/mob/monster/rat.dmi'
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak = list("squeaks")
	speak_chance = 1
	maxHealth = SMALLRAT_HEALTH
	health = SMALLRAT_HEALTH
	melee_damage_lower = 5
	melee_damage_upper = 5
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	response_help_continuous = "pets"
	response_help_simple = "pet"
	density = FALSE
	ventcrawler = VENTCRAWLER_ALWAYS
	faction = list(FACTION_HOSTILE)
	attack_sound = 'sound/blank.ogg'
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	mob_size = MOB_SIZE_TINY

	var/stepped_sound = 'sound/blank.ogg'
