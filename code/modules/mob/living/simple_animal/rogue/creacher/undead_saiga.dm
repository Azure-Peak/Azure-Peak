/mob/living/simple_animal/hostile/retaliate/rogue/saiga/undead
	name = "deadite saiga"
	desc = "A deadite saiga, its eyes glow with an eerie light."
	icon = 'icons/mob/saiga_undead.dmi'
	icon_state = "saiga"
	icon_living = "saiga"
	icon_dead = "saiga_dead"
	var/icon_downed = "saiga_downed"

	// Greatly increased health
	health = SAIGA_HEALTH_UNDEAD
	maxHealth = SAIGA_HEALTH_UNDEAD
	dodgetime = 50

	var/leg_health = 150
	var/max_leg_health = 150
	var/head_health = 100
	var/max_head_health = 100
	var/reinimation_timer = 15 MINUTES

	var/is_downed = FALSE
	var/legs_broken = FALSE
	mob_biotypes = MOB_UNDEAD
	faction = list("zombie")

	base_intents = list(/datum/intent/simple/headbutt/saiga)

	melee_damage_lower = 60
	melee_damage_upper = 90

	aggressive = 1
	retreat_health = 0
	retreat_distance = 0
	minimum_distance = 0

	tame_chance = 0
	bonus_tame_chance = 0
	can_buckle = TRUE
	can_saddle = TRUE

	attack_sound = list('sound/vo/mobs/saiga/attack (1).ogg','sound/vo/mobs/saiga/attack (2).ogg')
	pixel_x = -8

	butcher_results = list(
		/obj/item/natural/bone = 6,
		/obj/item/alch/sinew = 1,
		/obj/item/alch/bone = 2,
		/obj/item/alch/viscera = 1
	)
	perfect_butcher_results = list(
		/obj/item/reagent_containers/food/snacks/fat = 1,
		/obj/item/natural/hide = 1,
		/obj/item/natural/bundle/bone/full = 2,
		/obj/item/alch/sinew = 2,
		/obj/item/alch/bone = 3,
		/obj/item/alch/viscera = 2,
	)

/mob/living/simple_animal/hostile/retaliate/rogue/saiga/undead/death()
	unbuckle_all_mobs()
	can_buckle = FALSE
	can_saddle = FALSE
	if(is_downed)
		visible_message(span_danger("[src] has their head smashed to pulp!"))
		. = ..()
		update_icon()
	else
		visible_message(span_notice("[src] falls down, body brutally battered, yet its head continues that unending stare."))
		is_downed = TRUE
		move_to_delay = 100
		icon_state = icon_downed
		icon_living = icon_downed
		adjustBruteLoss(-500)
		stat = CONSCIOUS
		update_icon()
		// If you don't kill it, it will become a threat again.
		addtimer(CALLBACK(src, .proc/reanimation), reinimation_timer)
		return

/mob/living/simple_animal/hostile/retaliate/rogue/saiga/undead/proc/reanimation()
	if(!QDELETED(src) && stat != DEAD)
		visible_message(span_danger("The deadite saiga stands back up."))
		health = maxHealth
		leg_health = max_leg_health
		head_health = max_head_health
		legs_broken = FALSE
		icon_state = "saiga"
		icon_living = "saiga"
		move_to_delay = initial(move_to_delay)
		is_downed = FALSE
		stat = CONSCIOUS
		update_icon()

/mob/living/simple_animal/hostile/retaliate/rogue/saiga/undead/apply_damage(damage, damagetype, def_zone, blocked, forced)
	. = ..()
	if(is_downed)
		if(def_zone == "head" || \
		   def_zone == "snout" || \
		   def_zone == "neck")

			head_health -= damage
			if(head_health <= 0 && stat != DEAD)
				head_health = 0
				death()

	if(def_zone == "foreleg" || def_zone == "leg")
		leg_health -= damage
		if(leg_health <= 0 && !legs_broken)
			leg_health = 0
			legs_broken = TRUE
			move_to_delay += 10
			visible_message(span_notice("[src] slows down, its broken legs dragging."))

/mob/living/simple_animal/hostile/retaliate/rogue/saiga/undead/Initialize()
	. = ..()
	REMOVE_TRAIT(src, TRAIT_SIMPLE_WOUNDS, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_RIGIDMOVEMENT, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_SILVER_WEAK, TRAIT_GENERIC)
	AddComponent(/datum/component/infection_spreader)
