/datum/component/deadite
	var/reanimation_timer = 15 MINUTES
	var/is_downed = FALSE
	var/icon_downed = "saiga_downed"
	var/stored_icon_living
	var/reanim_timer_id

/datum/component/deadite/Initialize(reanim_time = 15 MINUTES, downed_state, inf_chance = 20)
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE

	var/mob/living/L = parent
	reanimation_timer = reanim_time
	if(downed_state)
		icon_downed = downed_state

	ADD_TRAIT(L, TRAIT_RIGIDMOVEMENT, TRAIT_GENERIC)
	ADD_TRAIT(L, TRAIT_SILVER_WEAK, TRAIT_GENERIC)
	ADD_TRAIT(L, TRAIT_BLOODLOSS_IMMUNE, TRAIT_GENERIC)
	L.AddComponent(/datum/component/infection_spreader, inf_chance)

	L.mob_biotypes |= MOB_UNDEAD
	L.faction |= list(FACTION_ZOMBIE)

	// We only need to listen to damage!
	RegisterSignal(L, COMSIG_MOB_APPLY_DAMGE, PROC_REF(on_apply_damage))

/datum/component/deadite/Destroy()
	if(reanim_timer_id)
		deltimer(reanim_timer_id)
		reanim_timer_id = null
	var/mob/living/L = parent
	L.faction -= list(FACTION_ZOMBIE)
	return ..()

/datum/component/deadite/proc/on_apply_damage(mob/living/simple_animal/L, damage, damagetype, def_zone, blocked, forced)
	SIGNAL_HANDLER

	if(is_downed)
		return
	if((L.health - damage) > 0)
		return
	// A destroyed head leaves nothing to get back up.
	if(L.no_reanimate)
		return

	// Prevent the standard damage from going through so the mob doesn't die right now
	. = COMPONENT_DAMAGE_HANDLED
	INVOKE_ASYNC(src, PROC_REF(go_down), L)

/datum/component/deadite/proc/go_down(mob/living/simple_animal/L)
	L.unbuckle_all_mobs()
	L.can_buckle = FALSE
	L.can_saddle = FALSE
	L.visible_message(span_notice("[L] falls down, body brutally battered, yet its head continues that unending stare."))
	is_downed = TRUE
	L.set_resting(TRUE)
	stored_icon_living = L.icon_living
	L.icon_state = icon_downed
	L.icon_living = icon_downed

	var/datum/wound/cripple/limb/topple/toppled = L.has_wound(/datum/wound/cripple/limb/topple)
	toppled?.stand_upright(L)

	L.adjustBruteLoss(-L.maxHealth)
	L.update_icon()

	reanim_timer_id = addtimer(CALLBACK(src, PROC_REF(reanimation)), reanimation_timer, flags = TIMER_STOPPABLE)

/datum/component/deadite/proc/reanimation()
	var/mob/living/simple_animal/L = parent
	reanim_timer_id = null
	if(QDELETED(L) || L.stat == DEAD || L.no_reanimate)
		return

	L.visible_message(span_danger("The [L.name] stands back up."))
	L.health = L.maxHealth
	is_downed = FALSE
	L.reset_part_damage()
	L.set_resting(FALSE)

	L.can_buckle = initial(L.can_buckle)
	L.can_saddle = initial(L.can_saddle)
	L.icon_state = initial(L.icon_state)
	L.icon_living = stored_icon_living ? stored_icon_living : initial(L.icon_living)

	L.set_stat(CONSCIOUS)
	L.update_icon()
