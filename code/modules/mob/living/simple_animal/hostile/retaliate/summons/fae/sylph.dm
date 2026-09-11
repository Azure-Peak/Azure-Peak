/mob/living/simple_animal/hostile/retaliate/rogue/fae/sylph
	anatomy_type = /datum/anatomy/winged/apex
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
	health = 1200
	maxHealth = 1200
	threat_point = THREAT_APEX
	melee_damage_lower = 28
	melee_damage_upper = 40
	vision_range = 7
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_NONE
	simple_detect_bonus = 20
	retreat_distance = 4
	minimum_distance = 3
	food_type = list()
	movement_type = FLYING
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	STACON = 13
	STASTR = 12
	STASPD = 8
	simple_detect_bonus = 20
	deaggroprob = 0
	candodge = TRUE
	// del_on_deaggro = 44 SECONDS
	retreat_health = 0
	food = 0
	attack_sound = null
	dodgetime = 40
	aggressive = 1

	ai_controller = /datum/ai_controller/fae/skirmisher
	move_base_delay = MOVEMENT_DELAY_SPD_23

	var/frost_cooldown = 3 SECONDS
	var/next_frost = 0

/obj/projectile/magic/frostbolt/greater
	name = "greater frostbolt"
	min_range = 1
	damage = 36

/mob/living/simple_animal/hostile/retaliate/rogue/fae/sylph/Initialize(mapload)
	src.adjust_skillrank(/datum/skill/combat/unarmed, 5, TRUE)
	. = ..()
	var/datum/action/cooldown/spell/projectile/frost_lance/lance = new(src)
	lance.Grant(src)

/mob/living/simple_animal/hostile/retaliate/rogue/fae/sylph/AttackingTarget()
	. = ..()
	if(!. || !isliving(target) || world.time < next_frost)
		return
	if(BODY_ZONE_HEAD in broken_parts)
		return
	next_frost = world.time + frost_cooldown
	var/mob/living/chilled = target
	apply_frost_stack(chilled)
	chilled.visible_message(span_danger("[src]'s frozen touch bites deep into [chilled]!"))

/mob/living/simple_animal/hostile/retaliate/rogue/fae/sylph/death(gibbed)
	..()
	update_icon()
	spill_embedded_objects()
	qdel(src)
