/mob/living/simple_animal/hostile/retaliate/rogue/revenant/mirespider
	name = "mire crawler revenant"
	desc = "A skittering, translucent horror. The eons-old legionnaire heads have returned as vengeful spirits."
	icon = 'icons/mob/mirespider_small.dmi'
	icon_state = "revenant"
	icon_living = "revenant"
	icon_dead = "revenant"
	mob_biotypes = MOB_UNDEAD | MOB_BEAST

	turns_per_move = 2
	move_to_delay = 3
	see_in_dark = 10
	vision_range = 10
	aggro_vision_range = 9
	retreat_distance = 0
	minimum_distance = 0
	retreat_health = 0

	health = MIRESPIDER_CRAWLER_HEALTH
	maxHealth = MIRESPIDER_CRAWLER_HEALTH
	melee_damage_lower = 17
	melee_damage_upper = 26

	STACON = 7
	STASTR = 7
	STASPD = 13

	faction = list("revenants", "spiders")
	base_intents = list(/datum/intent/simple/bite/mirespider)
	attack_sound = list('sound/vo/mobs/spider/attack (1).ogg','sound/vo/mobs/spider/attack (2).ogg','sound/vo/mobs/spider/attack (3).ogg','sound/vo/mobs/spider/attack (4).ogg')

/mob/living/simple_animal/hostile/retaliate/rogue/revenant/mirespider/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NOPAINSTUN, TRAIT_GENERIC)

/mob/living/simple_animal/hostile/retaliate/rogue/revenant/mirespider_lurker
	name = "mire lurker revenant"
	desc = "A towering spectral arachnid. It no longer cares about the younglings, all that matters now is delivering death."
	icon = 'icons/mob/mirespider_big.dmi'
	icon_state = "revenant"
	icon_living = "revenant"
	icon_dead = "revenant"
	pixel_x = -4
	mob_biotypes = MOB_UNDEAD | MOB_BEAST

	move_to_delay = 3
	retreat_distance = 0
	minimum_distance = 1
	retreat_health = 0

	health = MIRESPIDER_LURKER_HEALTH
	maxHealth = MIRESPIDER_LURKER_HEALTH
	melee_damage_lower = 35
	melee_damage_upper = 70

	STACON = 9
	STASTR = 9
	STASPD = 14
	STAPER = 15

	ranged = 1
	projectiletype = /obj/projectile/bullet/spider
	ranged_cooldown_time = 100
	check_friendly_fire = 1

	faction = list("revenants", "spiders")
	base_intents = list(/datum/intent/simple/bite/mirespider_lurker)
	attack_sound = list('sound/vo/mobs/spider/attack (1).ogg','sound/vo/mobs/spider/attack (2).ogg','sound/vo/mobs/spider/attack (3).ogg','sound/vo/mobs/spider/attack (4).ogg')

/mob/living/simple_animal/hostile/retaliate/rogue/revenant/mirespider_lurker/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
