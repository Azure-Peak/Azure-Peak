/mob/living/simple_animal/hostile/retaliate/rogue/mossback
	icon = 'icons/roguetown/mob/monster/boglobster.dmi'
	name = "mossback"
	desc = "Much feared by all those who live on Psydonia's coasts, these creatures are said to be the envoys of Abyssor. They engender respect for the ocean through the violence they inflict to the unwary, and provide rich meals to those able to hunt them; as the seas take from the unready, they give back to those deserving."
	icon_state = "mossback"
	icon_living = "mossback"
	icon_dead = "mossback_dead"
	speak_emote = list("clicks")
	emote_hear = list("clicks.")
	emote_see = list("clacks.")
	gender = MALE
	emote_hear = null
	emote_see = null
	turns_per_move = 3
	see_in_dark = 10
	move_to_delay = 3
	base_intents = list(/datum/intent/simple/claw/mossback)
	botched_butcher_results = list (/obj/item/reagent_containers/food/snacks/rogue/meat/crab = 1, /obj/item/alch/viscera = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/crab = 3, 
							/obj/item/alch/viscera = 2)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/crab = 5, 
									/obj/item/alch/viscera = 2)
	faction = list("crabs")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = MOSSBACK_HEALTH
	maxHealth = MOSSBACK_HEALTH
	melee_damage_lower = 35
	melee_damage_upper = 50
	vision_range = 4
	aggro_vision_range = 3
	retreat_distance = 0
	minimum_distance = 0
	milkies = FALSE
	food_type = list(/obj/item/reagent_containers/food/snacks/rogue/meat, 
	//obj/item/bodypart, 
	//obj/item/organ
	)
	pooptype = null
	deaggroprob = 0
	defprob = 40
	del_on_deaggro = 10 SECONDS
	retreat_health = 0
	food = 0
	attack_sound = list('sound/combat/wooshes/blunt/wooshhuge (1).ogg','sound/combat/wooshes/blunt/wooshhuge (2).ogg','sound/combat/wooshes/blunt/wooshhuge (3).ogg')
	dodgetime = 0
	aggressive = 1
	
//	stat_attack = UNCONSCIOUS

	can_have_ai = FALSE //disable native ai
	AIStatus = AI_OFF
	ai_controller = /datum/ai_controller/mossback
	melee_cooldown = MOSSBACK_ATTACK_SPEED

/mob/living/simple_animal/hostile/retaliate/rogue/mossback/Initialize(mapload, mob/user, townercrab = FALSE)
	. = ..()
	AddElement(/datum/element/ai_retaliate)
	ai_controller.set_blackboard_key(BB_BASIC_FOODS, food_type)
	if(user)
		summoner = user.mind.current.real_name
		if (townercrab)
			faction = list("neutral", "[summoner]_faction")
			tamed(user)

/mob/living/simple_animal/hostile/retaliate/rogue/mossback/get_sound(input)
	switch(input)
		if("idle")
			return pick('sound/vo/mobs/crab/crab noise (1).ogg','sound/vo/mobs/crab/crab noise (2).ogg','sound/vo/mobs/crab/crab noise (3).ogg')
		if("death")
			return pick('sound/vo/mobs/crab/crab death.ogg')

/mob/living/simple_animal/hostile/retaliate/rogue/mossback/death(gibbed)
	..()
	update_icon()

/mob/living/simple_animal/hostile/retaliate/rogue/mossback/taunted(mob/user)
	emote("aggro")
	Retaliate()
	GiveTarget(user)
	return

/mob/living/simple_animal/hostile/retaliate/rogue/mossback/Life()
	..()
	if(pulledby)
		Retaliate()
		GiveTarget(pulledby)

/mob/living/simple_animal/hostile/retaliate/rogue/mossback/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_NOSE)
			return "nose"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "mouth"
		if(BODY_ZONE_PRECISE_SKULL)
			return "head"
		if(BODY_ZONE_PRECISE_EARS)
			return "head"
		if(BODY_ZONE_PRECISE_NECK)
			return "neck"
		if(BODY_ZONE_PRECISE_L_HAND)
			return "foreleg"
		if(BODY_ZONE_PRECISE_R_HAND)
			return "foreleg"
		if(BODY_ZONE_PRECISE_L_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "stomach"
		if(BODY_ZONE_PRECISE_GROIN)
			return "tail"
		if(BODY_ZONE_HEAD)
			return "head"
		if(BODY_ZONE_R_LEG)
			return "leg"
		if(BODY_ZONE_L_LEG)
			return "leg"
		if(BODY_ZONE_R_ARM)
			return "foreleg"
		if(BODY_ZONE_L_ARM)
			return "foreleg"
	return ..()

/datum/intent/simple/claw/mossback
	clickcd = MOSSBACK_ATTACK_SPEED
