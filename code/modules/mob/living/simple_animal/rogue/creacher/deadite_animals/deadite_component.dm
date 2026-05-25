/datum/component/deadite
	var/reanimation_timer = 15 MINUTES
	var/is_downed = FALSE
	var/legs_broken = FALSE
	var/leg_health = 150
	var/max_leg_health = 150
	var/head_health = 100
	var/max_head_health = 100
	var/icon_downed = "saiga_downed"
	var/stored_icon_living
	var/reanim_timer_id

/datum/component/deadite/Initialize(reanim_time = 15 MINUTES, leg_hp = 150, head_hp = 100, downed_state, inf_chance = 20)
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE

	var/mob/living/L = parent
	reanimation_timer = reanim_time
	leg_health = leg_hp
	max_leg_health = leg_hp
	head_health = head_hp
	max_head_health = head_hp
	if(downed_state)
		icon_downed = downed_state

	REMOVE_TRAIT(L, TRAIT_SIMPLE_WOUNDS, TRAIT_GENERIC)
	ADD_TRAIT(L, TRAIT_RIGIDMOVEMENT, TRAIT_GENERIC)
	ADD_TRAIT(L, TRAIT_SILVER_WEAK, TRAIT_GENERIC)
	L.AddComponent(/datum/component/infection_spreader, inf_chance)

	L.mob_biotypes |= MOB_UNDEAD
	L.faction |= list(FACTION_ZOMBIE)

	// We only need to listen to damage!
	RegisterSignal(L, COMSIG_MOB_APPLY_DAMGE, .proc/on_apply_damage)
	//RegisterSignal(L, COMSIG_PARENT_QDELETING, .proc/handle_early_cleanup)

/datum/component/deadite/Destroy()
	if(reanim_timer_id)
		deltimer(reanim_timer_id)
		reanim_timer_id = null
	var/mob/living/L = parent
	L.faction -= list(FACTION_ZOMBIE)
	return ..()

/datum/component/deadite/proc/handle_early_cleanup(datum/source)
	SIGNAL_HANDLER
	if(reanim_timer_id)
		deltimer(reanim_timer_id)
		reanim_timer_id = null
	qdel(src)

/datum/component/deadite/proc/on_apply_damage(mob/living/simple_animal/L, damage, damagetype, def_zone, blocked, forced)
	SIGNAL_HANDLER

	//to_chat(world, span_danger("Hit them in the [def_zone]")) uncomment for debugging

	// Hit the head when downed for a kill.
	if(is_downed)
		if(def_zone in list(BODY_ZONE_HEAD, BODY_ZONE_PRECISE_SKULL, BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_NECK, BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_PRECISE_NOSE))
			head_health -= damage
			if(head_health <= 0 && L.stat != DEAD)
				head_health = 0
				L.visible_message(span_danger("[L] has their head smashed to pulp!"))
				L.death() // Mechanically die now
				UnregisterSignal(COMSIG_MOB_APPLY_DAMGE)
				if(reanim_timer_id)
					deltimer(reanim_timer_id)
					reanim_timer_id = null
				qdel(src)
		return

	// If we're not in our downed state, we get crippled, but don't die. Leaving us alive means we get back up eventually.
	if((L.health - damage) <= 0)
		// Prevent the standard damage from going through so the mob doesn't die right now
		. = COMPONENT_DAMAGE_HANDLED 

		L.unbuckle_all_mobs()
		L.can_buckle = FALSE
		L.can_saddle = FALSE
		L.visible_message(span_notice("[L] falls down, body brutally battered, yet its head continues that unending stare."))
		is_downed = TRUE
		if(L.ai_controller)
			L.ai_controller.movement_delay += 10 SECONDS
		else
			L.move_to_delay += 100
		stored_icon_living = L.icon_living
		L.icon_state = icon_downed
		L.icon_living = icon_downed

		L.adjustBruteLoss(-L.maxHealth)
		L.update_icon()

		reanim_timer_id = addtimer(CALLBACK(src, .proc/reanimation), reanimation_timer, flags = TIMER_STOPPABLE)
		return

	// hit in the legs? Our legs might break, slowing us down significantly
	if(def_zone in list(BODY_ZONE_R_LEG, BODY_ZONE_L_LEG, BODY_ZONE_R_ARM, BODY_ZONE_L_ARM))
		leg_health -= damage
		if(leg_health <= 0 && !legs_broken)
			leg_health = 0
			legs_broken = TRUE
			if(L.ai_controller)
				L.ai_controller.movement_delay += 0.5 SECONDS
			else
				L.move_to_delay += 10
			L.visible_message(span_notice("[L] slows down, its broken legs dragging."))
			playsound(L, 'sound/combat/fracture/fracturedry (1).ogg', 100, TRUE)

/datum/component/deadite/proc/reanimation()
	var/mob/living/simple_animal/L = parent
	if(QDELETED(L) || L.stat == DEAD)
		return

	L.visible_message(span_danger("The [L.name] stands back up."))
	L.health = L.maxHealth
	leg_health = max_leg_health
	head_health = max_head_health
	legs_broken = FALSE
	is_downed = FALSE

	L.icon_state = initial(L.icon_state)
	L.icon_living = stored_icon_living ? stored_icon_living : initial(L.icon_living)
	if(L.ai_controller)
		L.ai_controller.movement_delay = initial(L.ai_controller.movement_delay)
	else
		L.move_to_delay = initial(L.move_to_delay)

	L.set_stat(CONSCIOUS)
	L.update_icon()
