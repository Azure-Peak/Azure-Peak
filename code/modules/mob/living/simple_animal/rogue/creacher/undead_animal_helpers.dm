
/datum/component/infection_spreader
	var/infection_chance = 5
	//More time than a standard infection to compensate for the fact these things will dwell in the woods.
	var/infection_timer = 5 MINUTES

/datum/component/infection_spreader/Initialize(inf_chance = 5)
	. = ..()
	if(!istype(parent, /mob/living))
		return COMPONENT_INCOMPATIBLE
	infection_chance = inf_chance
	RegisterSignal(parent, COMSIG_LIVING_DEATH, .proc/handle_early_cleanup)
	RegisterSignal(parent, COMSIG_MOB_AFTERATTACK_SUCCESS, PROC_REF(on_bite))

/datum/component/infection_spreader/proc/handle_early_cleanup(datum/source)
	SIGNAL_HANDLER
	UnregisterSignal(COMSIG_LIVING_DEATH)
	UnregisterSignal(COMSIG_MOB_AFTERATTACK_SUCCESS)
	qdel(src)

/datum/component/infection_spreader/proc/on_bite(mob/living/source, mob/living/target)
	SIGNAL_HANDLER
	if(prob(infection_chance) && ishuman(target))
		var/mob/living/carbon/human/H = target
		// This looks really weird but because checking antag statuses makes a DB call that sleeps a proc at some point, it's not allowed to run as is within a component....
		// I've solved this here by executing the check asyncrously on the next tick.
		addtimer(CALLBACK(src, PROC_REF(try_infect_human), H), 0)

/datum/component/infection_spreader/proc/try_infect_human(mob/living/carbon/human/H)
	if(QDELETED(H) || !H.zombie_check_can_convert())
		return
	to_chat(H, span_danger("A growing cold seeps into my body. I feel horrible... REALLY horrible..."))
	H.infected = TRUE
	H.apply_status_effect(/datum/status_effect/zombie_infection, infection_timer, FALSE)

GLOBAL_LIST_INIT(animal_to_undead, list(
	/mob/living/simple_animal/hostile/retaliate/rogue/saiga = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/undead,
	/mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/undead,
	/mob/living/simple_animal/hostile/retaliate/rogue/saiga/game = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/undead,
	/mob/living/simple_animal/hostile/retaliate/rogue/wolf = /mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead,
	/mob/living/simple_animal/hostile/retaliate/rogue/fox = /mob/living/simple_animal/hostile/retaliate/rogue/fox/undead,
	/mob/living/simple_animal/hostile/retaliate/rogue/boar = /mob/living/simple_animal/hostile/retaliate/rogue/boar/undead,
	/mob/living/simple_animal/hostile/retaliate/rogue/boar/undead = /mob/living/carbon/human/species/wildshape/terrorhog,
	/mob/living/simple_animal/hostile/retaliate/rogue/troll = /mob/living/simple_animal/hostile/retaliate/rogue/troll/undead,
	/mob/living/simple_animal/hostile/retaliate/rogue/troll/axe = /mob/living/simple_animal/hostile/retaliate/rogue/troll/undead,
	/mob/living/simple_animal/hostile/retaliate/rogue/troll/bog = /mob/living/simple_animal/hostile/retaliate/rogue/troll/undead,
	/mob/living/simple_animal/hostile/retaliate/rogue/troll/cave = /mob/living/simple_animal/hostile/retaliate/rogue/troll/undead,
	/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/cabbit = /mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/cabbit/undead,
	/mob/living/simple_animal/hostile/retaliate/rogue/bigrat  = /mob/living/simple_animal/hostile/retaliate/rogue/bigrat/undead,
))

#define ZOMBIE_REANIMATION_CHANCE 25
#define REANIMATION_TELL_TIME 12 SECONDS
#define ZOMBIE_REANIMATION_TIMER (15 MINUTES - REANIMATION_TELL_TIME)

/datum/component/deadite_animal_reanimation
	var/reanimation_timer
	var/undead_to_spawn

/datum/component/deadite_animal_reanimation/Initialize()
	if(!istype(parent, /mob/living/simple_animal))
		return COMPONENT_INCOMPATIBLE

	var/mob/living/simple_animal/mob = parent
	if(mob.stat != DEAD || !get_undead_type(mob.type))
		// Not an error, we don't want this logged.
		return COMPONENT_INCOMPATIBLE_SILENT

	//KEEP IN MIND. IF YOU EDIT THIS TIMER TO BE LONGER THAN THE ROT COMPONENT, YOU WILL BREAK THIS.
	reanimation_timer = addtimer(CALLBACK(src, PROC_REF(start_twitching)), get_reanimation_time(), TIMER_STOPPABLE)

/datum/component/deadite_animal_reanimation/Destroy()
	if(reanimation_timer)
		deltimer(reanimation_timer)
	return ..()

/datum/component/deadite_animal_reanimation/proc/get_undead_type(mob_type)
	var/current_mob_type = mob_type
	while(mob_type && mob_type != /mob/living/simple_animal)
		if(GLOB.animal_to_undead[mob_type])
			var/target_undead = GLOB.animal_to_undead[mob_type]
			if(target_undead == current_mob_type || current_mob_type == mob_type && target_undead == current_mob_type)
				return null
			return target_undead
		mob_type = type2parent(mob_type)
	return null

/datum/component/deadite_animal_reanimation/proc/start_twitching()
	var/mob/living/simple_animal/mob = parent
	if(!prob(get_reanimation_chance()) || QDELETED(mob) || mob.stat != DEAD)
		UnregisterFromParent()
		qdel(src)
		return

	mob.visible_message(span_warning("The corpse of [mob] begins to twitch violently, its muscles snapping abnormally!"))
	playsound(mob, 'sound/combat/fracture/fracturewet (1).ogg', 100, TRUE)
	var/orig_x = mob.pixel_x
	var/orig_y = mob.pixel_y
	animate(mob, pixel_x = orig_x + 2, pixel_y = orig_y - 1, time = 1, loop = -1)
	animate(pixel_x = orig_x - 2, pixel_y = orig_y + 2, time = 1)
	animate(pixel_x = orig_x + 1, pixel_y = orig_y + 1, time = 1)
	animate(pixel_x = orig_x - 1, pixel_y = orig_y - 2, time = 1)
	animate(pixel_x = orig_x,     pixel_y = orig_y,     time = 1)

	reanimation_timer = addtimer(CALLBACK(src, PROC_REF(reanimate)), REANIMATION_TELL_TIME, TIMER_STOPPABLE)

/datum/component/deadite_animal_reanimation/proc/reanimate()
	var/mob/living/simple_animal/mob = parent
	if(QDELETED(mob) || mob.stat != DEAD)
		UnregisterFromParent()
		return

	playsound(mob, 'sound/combat/fracture/fracturewet (2).ogg', 100, TRUE)
	animate(mob)
	var/undead_type = GLOB.animal_to_undead[mob.type]
	new undead_type(mob.loc)
	mob.visible_message(span_danger("[mob] walks again... As a terrifying deadite!"))

	qdel(mob)

/datum/component/deadite_animal_reanimation/proc/get_reanimation_chance()
	if(has_world_trait(/datum/world_trait/zizo_pet_cementery))
		return 100
	return ZOMBIE_REANIMATION_CHANCE

/datum/component/deadite_animal_reanimation/proc/get_reanimation_time()
	if(has_world_trait(/datum/world_trait/zizo_pet_cementery))
		return 1.5 MINUTES
	return ZOMBIE_REANIMATION_TIMER

#undef ZOMBIE_REANIMATION_CHANCE
#undef ZOMBIE_REANIMATION_TIMER
#undef REANIMATION_TELL_TIME
