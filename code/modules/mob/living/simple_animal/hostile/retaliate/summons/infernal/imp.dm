/mob/living/simple_animal/hostile/retaliate/rogue/infernal/imp
	icon = 'icons/mob/summonable/32x32.dmi'
	name = "infernal imp"
	desc = "This is a diminutive humanoid creature capable of flight. While its claws are sharp and its movements agile, \
	it does not seem remarkably imposing."
	icon_state = "imp"
	icon_living = "imp"
	icon_dead = "vvd"
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	turns_per_move = 3
	see_in_dark = 6
	move_to_delay = 3
	base_intents = list(/datum/intent/unarmed/claw)
	butcher_results = list()
	faction = list("infernal")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 70
	maxHealth = 70
	melee_damage_lower = 15
	melee_damage_upper = 17
	vision_range = 7
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_NONE
	simple_detect_bonus = 20
	ranged = TRUE
	ranged_cooldown = 40
	projectiletype = /obj/projectile/magic/firebolt
	retreat_distance = 4
	minimum_distance = 3
	food_type = list()
	movement_type = FLYING
	pooptype = null
	STACON = 7
	STASTR = 6
	STASPD = 12
	simple_detect_bonus = 20
	deaggroprob = 0
	defprob = 40
	candodge = TRUE
	// del_on_deaggro = 44 SECONDS
	retreat_health = 0.3
	food = 0
	attack_sound = 'sound/combat/hits/bladed/smallslash (1).ogg'
	attack_verb_continuous = "claws"
	attack_verb_simple = "claw"
	dodgetime = 30
	aggressive = 1

/mob/living/simple_animal/hostile/retaliate/rogue/infernal/imp/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_SILVER_WEAK, TRAIT_GENERIC)

/obj/projectile/magic/firebolt
	name = "ball of fire"
	icon_state = "fireball"
	damage = 20
	damage_type = BURN
	nodamage = FALSE
	armor_penetration = 0
	flag = "magic"
	hitsound = 'sound/blank.ogg'

/obj/projectile/magic/firebolt/on_hit(target)
	if(ismob(target))
		var/mob/M = target
		if(M.anti_magic_check())
			M.visible_message(span_warning("[src] vanishes on contact with [target]!"))
			qdel(src)
			return BULLET_ACT_BLOCK
	. = ..()

/mob/living/simple_animal/hostile/retaliate/rogue/infernal/imp/death(gibbed)
	..()
	var/turf/deathspot = get_turf(src)
	new /obj/item/magic/infernal/ash(deathspot)
	new /obj/item/magic/infernal/ash(deathspot)
	new /obj/item/magic/infernal/ash(deathspot)
	new /obj/item/magic/infernal/ash(deathspot)
	new /obj/item/magic/infernal/ash(deathspot)
	new /obj/item/magic/infernal/ash(deathspot)
	update_icon()
	sleep(1)
	qdel(src)


/mob/living/simple_animal/hostile/retaliate/rogue/infernal/imp/taunted(mob/user)
	emote("aggro")
	Retaliate()
	GiveTarget(user)
	return

/mob/living/simple_animal/hostile/retaliate/rogue/infernal/imp/Life()
	..()
	if(pulledby)
		Retaliate()
		GiveTarget(pulledby)
