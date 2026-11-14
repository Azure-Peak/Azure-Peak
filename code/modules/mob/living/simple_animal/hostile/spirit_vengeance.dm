/mob/living/simple_animal/hostile/rogue/spirit_vengeance
	name = "rancor spirit"
	desc = "A vengeful spirit that refused to pass away. Only after venting those lingering dark emotions, it may finally rest easy..."
	icon = 'icons/mob/spirit_vengeance.dmi'
	icon_state = "spirit_vengeance"
	icon_living = "spirit_vengeance"
	gender = MALE
	mob_biotypes = MOB_HUMANOID
	STACON = 9
	STASTR = 9
	STASPD = 14
	maxHealth = 50
	health = 50
	harm_intent_damage = 5
	melee_damage_lower = 5
	melee_damage_upper = 7
	limb_destroyer = 1
	base_intents = list(/datum/intent/simple/bite)
	attack_verb_continuous = "hacks"
	attack_verb_simple = "hack"
	attack_sound = 'sound/blank.ogg'
	d_intent = INTENT_DODGE
	speak_emote = list("growls")
	footstep_type = null
	del_on_death = TRUE
	ai_controller = /datum/ai_controller/spirit_vengeance
	move_base_delay = MOVEMENT_DELAY_SPD_23

/mob/living/simple_animal/hostile/rogue/spirit_vengeance/get_sound(input)
	switch(input)
		if("laugh")
			return pick('sound/vo/mobs/ghost/laugh (1).ogg','sound/vo/mobs/ghost/laugh (2).ogg','sound/vo/mobs/ghost/laugh (3).ogg','sound/vo/mobs/ghost/laugh (4).ogg','sound/vo/mobs/ghost/laugh (5).ogg','sound/vo/mobs/ghost/laugh (6).ogg')
		if("moan")
			return pick('sound/vo/mobs/ghost/moan (1).ogg','sound/vo/mobs/ghost/laugh (2).ogg','sound/vo/mobs/ghost/laugh (3).ogg')
		if("death")
			return 'sound/vo/mobs/ghost/death.ogg'
		if("whisper")
			return pick('sound/vo/mobs/ghost/whisper (1).ogg','sound/vo/mobs/ghost/whisper (2).ogg','sound/vo/mobs/ghost/whisper (3).ogg')
		if("aggro")
			return pick('sound/vo/mobs/ghost/aggro (1).ogg','sound/vo/mobs/ghost/aggro (2).ogg','sound/vo/mobs/ghost/aggro (3).ogg','sound/vo/mobs/ghost/aggro (4).ogg','sound/vo/mobs/ghost/aggro (5).ogg','sound/vo/mobs/ghost/aggro (6).ogg')

/mob/living/simple_animal/hostile/rogue/spirit_vengeance/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/simple_animal, death), TRUE), 15 SECONDS)

/datum/targetting_datum/vengeful_spirit/can_attack(mob/living/living_mob, atom/the_target, vision_range)
	var/mob/living/simple_animal/hostile/rogue/spirit_vengeance/avenging/spirit = living_mob
	if(!istype(spirit) || QDELETED(the_target))
		return FALSE
	return the_target == spirit.chase_target_ref?.resolve()

/datum/ai_controller/spirit_vengeance/avenging
	blackboard = list(BB_TARGETTING_DATUM = new /datum/targetting_datum/vengeful_spirit())
	planning_subtrees = list(/datum/ai_planning_subtree/basic_melee_attack_subtree)

/mob/living/simple_animal/hostile/rogue/spirit_vengeance/avenging
	ai_controller = /datum/ai_controller/spirit_vengeance/avenging
	var/datum/weakref/chase_target_ref
	var/crow_form = FALSE
	var/lifespan = 15 SECONDS
	var/latched = FALSE

/mob/living/simple_animal/hostile/rogue/spirit_vengeance/avenging/Initialize(mapload, mob/living/summoner, crow)
	. = ..(mapload)
	crow_form = crow
	var/list/icon_data = get_vengeful_form_icon(crow_form)
	icon = icon_data[1]
	icon_state = icon_data[2]
	icon_living = icon_state
	QDEL_IN(src, lifespan)

/mob/living/simple_animal/hostile/rogue/spirit_vengeance/avenging/proc/assign_target(mob/living/target)
	chase_target_ref = WEAKREF(target)
	pin_target(target)

/mob/living/simple_animal/hostile/rogue/spirit_vengeance/avenging/proc/pin_target(mob/living/target)
	if(!ai_controller)
		return
	if(ai_controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET] != target)
		ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, target)

/mob/living/simple_animal/hostile/rogue/spirit_vengeance/avenging/Life()
	. = ..()
	if(latched || QDELETED(src))
		return
	var/mob/living/target = chase_target_ref?.resolve()
	if(!target || QDELETED(target) || target.stat == DEAD)
		dissipate()
		return
	pin_target(target)

/mob/living/simple_animal/hostile/rogue/spirit_vengeance/avenging/Bump(atom/bumped)
	. = ..()
	if(prob(50)) // bit of a reaction time mercy, these things are vicious
		return
	if(try_latch(bumped))
		return
	if(!latched && isliving(bumped))
		var/turf/pass_turf = get_turf(bumped)
		if(pass_turf)
			forceMove(pass_turf)

/mob/living/simple_animal/hostile/rogue/spirit_vengeance/avenging/AttackingTarget(atom/attacked_target)
	try_latch(attacked_target)
	return FALSE

/mob/living/simple_animal/hostile/rogue/spirit_vengeance/avenging/proc/try_latch(atom/bumped)
	if(latched || QDELETED(src) || stat == DEAD)
		return FALSE
	var/mob/living/target = chase_target_ref?.resolve()
	if(!target || bumped != target || target.stat == DEAD)
		return FALSE
	latched = TRUE
	if(target.has_status_effect(/datum/status_effect/buff/clash))
		repel(target)
		return TRUE
	target.apply_status_effect(/datum/status_effect/debuff/vengeful_spirit, crow_form)
	qdel(src)
	return TRUE

/mob/living/simple_animal/hostile/rogue/spirit_vengeance/avenging/proc/repel(mob/living/target)
	target.visible_message(span_warning("[target] backhands [src] away!"), span_notice("I backhand [src] away!"))
	var/away_dir = get_dir(target, src) || pick(GLOB.alldirs)
	throw_at(get_edge_target_turf(src, away_dir), 3, 2, target)
	QDEL_IN(src, 0.7 SECONDS)

/mob/living/simple_animal/hostile/rogue/spirit_vengeance/avenging/proc/dissipate()
	if(QDELETED(src))
		return
	visible_message(span_notice("[src] fades away to tranquility..."))
	qdel(src)
