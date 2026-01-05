/mob/living/simple_animal/hostile/retaliate
	var/list/enemies = list()

/mob/living/simple_animal/hostile/retaliate/examine(mob/user)
	. = ..()
	if(user == target)
		. += span_danger("[src] is currently targeting you!")
	else if(user in enemies)
		. += span_danger("[src] seems hostile towards you.")

/mob/living/simple_animal/hostile/retaliate/attack_hand(mob/living/carbon/human/M)
	. = ..()
	if(M.used_intent.type == INTENT_HELP && tame)
		if(length(enemies))
			if(!(M in friends))
				to_chat(M, span_warning("[src] doesn't seem to react to your petting!"))
				return
			enemies = list()
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
			see &= enemies // Remove all entries that aren't in enemies
			return see

/mob/living/simple_animal/hostile/retaliate/proc/DismemberBody(mob/living/L)
	//Lets keep track of this to see if we start getting wounded while eating.

	//I dont know why but the do_after for health needs this to be defined like this.
	var/list/check_health = list("health" = src.health)

	if(L.stat != CONSCIOUS)
		src.visible_message(span_danger("[src] starts to rip apart [L]!"))
		if(attack_sound)
			playsound(src, pick(attack_sound), 100, TRUE, -1)
		//If their health is decreased at all during the 10 seconds the dismemberment will fail and they will lose target.
		if(do_after(user = src, delay = 10 SECONDS, target = L, extra_checks = CALLBACK(src, TYPE_PROC_REF(/mob, break_do_after_checks), check_health, FALSE)))
			//If its carbon remove a limb, if its some animal just gib it.
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
//	var/list/around = view(src, vision_range)
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
				enemies |= M

	for(var/mob/living/simple_animal/hostile/retaliate/H in around)
		if(faction_check_mob(H) && !attack_same && !H.attack_same)
			H.enemies |= enemies
	return 0


/mob/living/simple_animal/hostile/retaliate/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(. > 0 && stat == CONSCIOUS)
		Retaliate()
