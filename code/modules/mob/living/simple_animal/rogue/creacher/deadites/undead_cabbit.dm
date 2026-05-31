/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/cabbit/undead
	ai_controller = /datum/ai_controller/undead/cabbit
	faction = list(FACTION_UNDEAD)

	icon = 'icons/roguetown/mob/monster/deadites/cabbit_undead.dmi'
	name = "deadite cabbit"
	desc = "What is that?! Why is it moving so fast? It's going for the throat! It's going for the throat!!!."
	icon_state = "cabbit"
	icon_living = "cabbit"
	icon_dead = "cabbit_dead"
	health = CABBIT_HEALTH_UNDEAD
	maxHealth = CABBIT_HEALTH_UNDEAD
	head_butcher = /obj/item/natural/head/cabbit/undead
	defprob = 10
	dodgetime = 1
	dodge_prob = 90
	aggressive = 1
	cmode = 1
	melee_damage_upper = 12
	melee_damage_lower = 6
	base_intents = list(/datum/intent/simple/claw/cabbit_undead)

	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 2, 
							/obj/item/alch/sinew = 1,
							/obj/item/alch/bone = 1,
							/obj/item/natural/fur/rabbit = 1,
							/obj/item/natural/rabbitsfoot = 0,
							/obj/item/alch/viscera = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 3, 
							/obj/item/alch/sinew = 1,
							/obj/item/alch/bone = 1,
							/obj/item/natural/fur/rabbit = 1,
							/obj/item/natural/rabbitsfoot = 1,
							/obj/item/alch/viscera = 2)

/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/cabbit/undead/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_HEAD, BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_SKULL, BODY_ZONE_PRECISE_EARS)
			return "head"
		if(BODY_ZONE_PRECISE_NOSE, BODY_ZONE_PRECISE_MOUTH)
			return "mouth"
		if(BODY_ZONE_PRECISE_NECK)
			return "neck"
		if(BODY_ZONE_R_LEG, BODY_ZONE_PRECISE_R_FOOT, BODY_ZONE_R_ARM, BODY_ZONE_PRECISE_R_HAND)
			return "r_leg"
		if(BODY_ZONE_L_LEG, BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_L_ARM, BODY_ZONE_PRECISE_L_HAND)
			return "l_leg"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "stomach"
	return ..()

/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/cabbit/undead/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)
	AddComponent(/datum/component/deadite, 15 MINUTES, 30, 30, "cabbit_downed", 1)

/datum/intent/simple/claw/cabbit_undead
	clickcd = CABBIT_UNDEAD_ATTACK_SPEED
	name = "razor claws"
	attack_verb = list("slices", "dices", "filets")
	penfactor = PEN_LIGHT
	blade_class = BCLASS_CUT

/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/cabbit/undead/attempt_dodge(datum/intent/intenty, mob/living/user)
	if(world.time < last_dodge + dodgetime)
		return FALSE

	if(pulledby || pulling)
		return FALSE
	if(has_status_effect(/datum/status_effect/debuff/riposted))
		return FALSE
	if(has_status_effect(/datum/status_effect/debuff/exposed) || has_status_effect(/datum/status_effect/debuff/vulnerable))
		return FALSE
	if(src.loc == user.loc)
		return FALSE
	if(intenty && !intenty.candodge)
		return FALSE
	if(HAS_TRAIT(src, TRAIT_NODEF))
		return FALSE
	if(!candodge)
		return FALSE

	var/list/dirry = list()
	var/dx = x - user.x
	var/dy = y - user.y
	if(abs(dx) < abs(dy))
		if(dy > 0)
			dirry += NORTH
			dirry += WEST
			dirry += EAST
		else
			dirry += SOUTH
			dirry += WEST
			dirry += EAST
	else
		if(dx > 0)
			dirry += EAST
			dirry += SOUTH
			dirry += NORTH
		else
			dirry += WEST
			dirry += NORTH
			dirry += SOUTH

	var/turf/turfy
	if(fixedeye)
		var/dodgedir = turn(dir, 180)
		var/turf/turfcheck = get_step(src, dodgedir)
		if(turfcheck && check_dodge_turf(turfcheck))
			turfy = turfcheck

	if(!turfy)
		for(var/x in shuffle(dirry.Copy()))
			var/turf/turfcheck = get_step(src, x)
			if(turfcheck && check_dodge_turf(turfcheck))
				turfy = turfcheck
				break
	if(pulledby)
		return FALSE
	if(!turfy)
		to_chat(src, span_boldwarning("There's nowhere to dodge to!"))
		return FALSE

	if(!prob(dodge_prob))
		return FALSE

	last_dodge = world.time
	dodgecd = TRUE
	playsound(src, 'sound/combat/dodge.ogg', 100, FALSE)

	if(!HAS_TRAIT(src, TRAIT_DODGE_NO_MOVE))
		throw_at(turfy, 1, 2, src, FALSE)

	src.visible_message(span_warning("<b>[src]</b> nimbly dodges [user]'s attack!"))
	flash_fullscreen("blackflash2")
	user.aftermiss()

	dodgecd = FALSE
	return TRUE
