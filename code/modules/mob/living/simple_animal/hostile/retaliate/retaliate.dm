/mob/living/simple_animal/hostile/retaliate
	var/list/enemies = list()

/mob/living/simple_animal/hostile/retaliate/Destroy()
	enemies.Cut()
	return ..()

/mob/living/simple_animal/hostile/retaliate/proc/add_enemy(mob/living/M)
	if(M == src)
		return
	enemies |= WEAKREF(M)

/mob/living/simple_animal/hostile/retaliate/proc/clear_enemies()
	enemies.Cut()

/// Resolve weakrefs in enemies list, pruning dead/null entries. Returns a list of living mobs.
/mob/living/simple_animal/hostile/retaliate/proc/resolve_enemies()
	var/list/resolved = list()
	for(var/datum/weakref/ref in enemies)
		var/mob/living/M = ref.resolve()
		if(M)
			resolved += M
		else
			enemies -= ref
	return resolved

/mob/living/simple_animal/hostile/retaliate/examine(mob/user)
	. = ..()
	if(user == target)
		. += span_danger("[src] is currently targeting you!")
	else if(WEAKREF(user) in enemies)
		. += span_danger("[src] seems hostile towards you.")

/mob/living/simple_animal/hostile/retaliate/attack_hand(mob/living/carbon/human/M)
	. = ..()
	if(M.used_intent.type == INTENT_HELP && tame)
		if(length(enemies))
			if(!(M in friends))
				to_chat(M, span_warning("[src] doesn't seem to react to your petting!"))
				return
			clear_enemies()
			visible_message(span_notice("[src] calms down."))
			LoseTarget()
		else
			if(!(M in friends))
				friends += M
				visible_message(span_notice("[src] seems to like [M]."))

/mob/living/simple_animal/hostile/retaliate
	var/aggressive = 0

/mob/living/simple_animal/hostile/retaliate/ListTargets()
	if(!(AIStatus == NPC_AI_OFF))
		if(aggressive)
			return ..()
		else
			if(!enemies.len)
				return list()
			var/list/see = ..()
			var/list/resolved = resolve_enemies()
			see &= resolved
			return see

/mob/living/simple_animal/hostile/retaliate/proc/DismemberBody(mob/living/L)
	var/list/check_health = list("health" = src.health)

	if(L.stat != CONSCIOUS)
		src.visible_message(span_danger("[src] starts to rip apart [L]!"))
		if(attack_sound)
			playsound(src, pick(attack_sound), 100, TRUE, -1)
		if(do_after(user = src, delay = 10 SECONDS, target = L, extra_checks = CALLBACK(src, TYPE_PROC_REF(/mob, break_do_after_checks), check_health, FALSE)))
			if(iscarbon(L))
				var/mob/living/carbon/C = L
				var/obj/item/bodypart/limb
				var/list/limb_list = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
				for(var/zone in limb_list)
					limb = C.get_bodypart(zone)
					if(limb)
						limb.dismember()
						return TRUE
				limb = C.get_bodypart(BODY_ZONE_HEAD)
				if(limb)
					limb.dismember()
					return TRUE
				limb = C.get_bodypart(BODY_ZONE_CHEST)
				if(limb)
					if(!limb.dismember())
						C.gib()
					return TRUE
			else
				L.gib()
				return TRUE
		LoseTarget()

/mob/living/simple_animal/hostile/retaliate/proc/Retaliate()
	toggle_ai(AI_ON)
	var/list/around = hearers(vision_range, src)

	for(var/atom/movable/A in around)
		if(A == src)
			continue
		if(A in friends)
			continue
		if(isliving(A))
			var/mob/living/M = A
			if(faction_check_mob(M) && attack_same || !faction_check_mob(M))
				add_enemy(M)

	for(var/mob/living/simple_animal/hostile/retaliate/H in around)
		if(faction_check_mob(H) && !attack_same && !H.attack_same)
			for(var/mob/living/E in resolve_enemies())
				H.add_enemy(E)
	return 0


/mob/living/simple_animal/hostile/retaliate/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(. > 0 && stat == CONSCIOUS)
		Retaliate()
