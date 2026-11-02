/mob/living/simple_animal/hostile/retaliate/rogue/elemental/crawler
	anatomy_type = /datum/anatomy/construct/trash
	icon = 'icons/mob/summonable/32x32.dmi'
	name = "earthen crawler"
	desc = "This is a relatively small elemental formed of dirt, rock, and clay. It \
	clambers about with the use of too few limbs, but still reaches up to your knees."
	summon_primer = "You are an crawler, a small elemental. Elementals such as yourself spend immeasurable time wandering about within your plane. Now you've been pulled from your home into a new world, that is decidedly less peaceful then your carefully guarded plane. How you react to these events, only time can tell."
	summon_tier = 1
	icon_state = "crawler"
	icon_living = "crawler"
	icon_dead = "vvd"
	gender = MALE
	speak_chance = 1
	see_in_dark = 6
	base_intents = list(/datum/intent/simple/elemental_unarmed)
	butcher_results = list()
	death_loot = list(/obj/item/magic/elemental/mote = 4)
	faction = list(FACTION_ELEMENTAL)
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 120
	maxHealth = 120
	threat_point = 15
	melee_damage_lower = 15
	melee_damage_upper = 17
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	simple_detect_bonus = 20
	food_type = list()
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	simple_detect_bonus = 20
	deaggroprob = 0
	food = 0
	attack_sound = 'sound/combat/hits/onstone/wallhit.ogg'
	attack_verb_continuous = "pounds"
	attack_verb_simple = "pounds"
	dodgetime = 0
	aggressive = 1

	STACON = 13
	STAWIL = 13
	STASTR = 8
	STASPD = 8

	ai_controller = /datum/ai_controller/elemental
	move_base_delay = MOVEMENT_DELAY_SPD_3

/mob/living/simple_animal/hostile/retaliate/rogue/elemental/crawler/Initialize(mapload)
	src.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	. = ..()

/mob/living/simple_animal/hostile/retaliate/rogue/elemental/crawler/death(gibbed)
	..()
	update_icon()
	spawn(1)
		qdel(src)
