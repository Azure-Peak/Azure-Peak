/mob/living/simple_animal/hostile/retaliate/rogue/revenant
	name = "revenant"
	desc = "A shimmering, vengeful spirit anchored to the fog."
	icon = 'icons/roguetown/mob/misc.dmi'
	icon_state = "revenant"
	alpha = 0 // Starts invisible for the spawn animation
	status_flags = CANPUSH
	faction = list("revenants")
	mob_biotypes = MOB_UNDEAD

	health = 150
	maxHealth = 150
	melee_damage_lower = 20
	melee_damage_upper = 30
	aggressive = 1
	vision_range = 9
	aggro_vision_range = 9
	retreat_distance = 0
	minimum_distance = 0
	retreat_health = 0.1
	base_intents = list(/datum/intent/simple/bite, /datum/intent/simple/claw)

	var/target_alpha = 150
	var/fade_time = 1.5 SECONDS

/mob/living/simple_animal/hostile/retaliate/rogue/revenant/Initialize()
	. = ..()
	AddComponent(/datum/component/fog_entity)
	appear_animated()
	ADD_TRAIT(src, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_KNEESTINGER_IMMUNITY, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_SILVER_WEAK, TRAIT_GENERIC)
	// We do not bleed.
	REMOVE_TRAIT(src, TRAIT_SIMPLE_WOUNDS, TRAIT_GENERIC)

/mob/living/simple_animal/hostile/retaliate/rogue/revenant/proc/appear_animated()
	move_to_delay = fade_time // Basically can't move until the animation is done!
	animate(src, alpha = target_alpha, time = fade_time, easing = EASE_IN)
	addtimer(CALLBACK(src, PROC_REF(finish_appearing)), fade_time)

/mob/living/simple_animal/hostile/retaliate/rogue/revenant/proc/disappear_animated()
	animate(src, alpha = 0, time = fade_time, easing = EASE_OUT)
	addtimer(CALLBACK(src, PROC_REF(death)), fade_time)

/mob/living/simple_animal/hostile/retaliate/rogue/revenant/proc/finish_appearing()
	move_to_delay = initial(move_to_delay)

/mob/living/simple_animal/hostile/retaliate/rogue/revenant/death(gibbed)
	..()
	qdel(src)

// Horde fodder
/mob/living/simple_animal/hostile/retaliate/rogue/revenant/weak
	health = 80
	maxHealth = 80
	melee_damage_lower = 15
	melee_damage_upper = 20
