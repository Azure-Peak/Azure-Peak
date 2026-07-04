/mob/living/simple_animal/hostile/retaliate/rogue/fae/sylph
	icon = 'icons/mob/summonable/32x32.dmi'
	name = "sylph"
	desc = "This creature shifts in the breeze as if it were constructed of fabric and \
	nothing more. Its face, owl-like, is flanked by near-draconic wings. If this is one of the \
	fae-folk, it must be one of their rulers."
	icon_state = "sylph"
	icon_living = "sylph"
	icon_dead = "vvd"
	summon_tier = 4
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	turns_per_move = 6
	see_in_dark = 6
	move_to_delay = 3
	base_intents = list(/datum/intent/simple/bite)
	butcher_results = list()
	death_loot = list(/obj/item/magic/fae/sylvanessence = 1)
	faction = list(FACTION_FAE)
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 700
	maxHealth = 700
	melee_damage_lower = 28
	melee_damage_upper = 40
	vision_range = 7
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_NONE
	simple_detect_bonus = 20
	retreat_distance = 4
	minimum_distance = 3
	food_type = list()
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	STACON = 13
	STASTR = 12
	STASPD = 8
	simple_detect_bonus = 20
	deaggroprob = 0
	defprob = 50
	candodge = TRUE
	// del_on_deaggro = 44 SECONDS
	retreat_health = 0
	food = 0
	attack_sound = null
	dodgetime = 40
	aggressive = 1
	ranged = TRUE
	rapid = 3
	projectiletype = /obj/projectile/magic/frostbolt/greater
	ranged_message = "throws icy magick"
	var/frost_cd = 0

/obj/projectile/magic/frostbolt/greater
	name = "greater frostbolt"
	min_range = 1
	damage = 36

/mob/living/simple_animal/hostile/retaliate/rogue/fae/sylph/Initialize()
	src.adjust_skillrank(/datum/skill/combat/unarmed, 5, TRUE)
	. = ..()

/mob/living/simple_animal/hostile/retaliate/rogue/fae/sylph/simple_add_wound(datum/wound/wound, silent = FALSE, crit_message = FALSE)	//no wounding the fiend
	return

/mob/living/simple_animal/hostile/retaliate/rogue/fae/sylph/AttackingTarget()
	if(SEND_SIGNAL(src, COMSIG_HOSTILE_PRE_ATTACKINGTARGET, target) & COMPONENT_HOSTILE_NO_PREATTACK)
		return FALSE
	SEND_SIGNAL(src, COMSIG_HOSTILE_ATTACKINGTARGET, target)
	in_melee = TRUE
	if(QDELETED(target))
		return
	. = target.attack_animal(src)
	if(. && isliving(target) && world.time >= frost_cd)
		frost_cd = world.time + 3 SECONDS
		var/mob/living/L = target
		apply_frost_stack(L)
		L.visible_message(span_danger("[src]'s frozen touch bites deep into [L]!"))

/mob/living/simple_animal/hostile/retaliate/rogue/fae/sylph/death(gibbed)
	..()
	update_icon()
	spill_embedded_objects()
	qdel(src)
