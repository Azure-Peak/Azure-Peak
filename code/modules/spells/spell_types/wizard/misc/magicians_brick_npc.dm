#define CONJURE_THROW_NPC_SCORE 60
#define CONJURE_THROW_NPC_WINDUP (0.7 SECONDS)
#define CONJURE_THROW_NPC_VOLLEY_GAP (1 SECONDS)
#define CONJURE_THROW_NPC_MIN_RANGE 2

/datum/action/cooldown/spell/proc/npc_conjure_throw_score(atom/target, obj/item/held, obj/item/conjured)
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return 0
	if(get_dist(H, target) < CONJURE_THROW_NPC_MIN_RANGE)
		return held ? 0 : CONJURE_THROW_NPC_SCORE
	if(!held && !length(H.get_empty_held_indexes()))
		return 0
	if(held && held != conjured)
		return 0
	if(npc_line_blocked(target))
		return 0
	return CONJURE_THROW_NPC_SCORE

/datum/action/cooldown/spell/proc/npc_queue_conjured_throw(datum/ai_controller/controller)
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(QDELETED(target))
		return
	addtimer(CALLBACK(src, PROC_REF(npc_hurl_conjured), target), CONJURE_THROW_NPC_WINDUP)
	for(var/datum/action/cooldown/spell/spare in owner.actions)
		if(spare != src && spare.type == type && spare.IsAvailable())
			controller.set_blackboard_key(BB_CASTER_NEXT_CAST, world.time + CONJURE_THROW_NPC_VOLLEY_GAP)
			return

/datum/action/cooldown/spell/proc/npc_conjured_throwable()
	return null

/datum/action/cooldown/spell/proc/npc_hurl_conjured(atom/target)
	var/mob/living/carbon/human/H = owner
	var/obj/item/thrown = npc_conjured_throwable()
	if(!istype(H) || H.client || H.stat != CONSCIOUS || H.incapacitated())
		return
	if(QDELETED(target) || QDELETED(thrown) || !H.is_holding(thrown))
		return
	var/dist = get_dist(H, target)
	if(dist < CONJURE_THROW_NPC_MIN_RANGE || !can_see(H, target, thrown.throw_range))
		return
	if(npc_line_blocked(target))
		return
	H.face_atom(target)
	var/turf/aim = npc_lead_turf(target, dist * 2 / max(thrown.throw_speed, 1)) || get_turf(target)
	H.throw_item(aim, H.get_active_held_item() != thrown)

/datum/action/cooldown/spell/magicians_brick
	npc_max_range = 7

/datum/action/cooldown/spell/magicians_brick/npc_cast_target(atom/target)
	return owner

/datum/action/cooldown/spell/magicians_brick/npc_conjured_throwable()
	return conjured_brick

/datum/action/cooldown/spell/magicians_brick/npc_use_chance(atom/target)
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return 0
	var/obj/item/rogueweapon/magicbrick/held = locate() in H.held_items
	return npc_conjure_throw_score(target, held, conjured_brick)

/datum/action/cooldown/spell/magicians_brick/npc_after_cast(datum/ai_controller/controller)
	npc_queue_conjured_throw(controller)

/datum/action/cooldown/spell/aetherknife
	npc_max_range = 7

/datum/action/cooldown/spell/aetherknife/npc_cast_target(atom/target)
	return owner

/datum/action/cooldown/spell/aetherknife/npc_conjured_throwable()
	return conjured_knife

/datum/action/cooldown/spell/aetherknife/npc_use_chance(atom/target)
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return 0
	var/obj/item/rogueweapon/huntingknife/throwingknife/aetherknife/held = locate() in H.held_items
	return npc_conjure_throw_score(target, held, conjured_knife)

/datum/action/cooldown/spell/aetherknife/npc_after_cast(datum/ai_controller/controller)
	npc_queue_conjured_throw(controller)

#undef CONJURE_THROW_NPC_SCORE
#undef CONJURE_THROW_NPC_WINDUP
#undef CONJURE_THROW_NPC_VOLLEY_GAP
#undef CONJURE_THROW_NPC_MIN_RANGE
