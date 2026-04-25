/mob/living/simple_animal/hostile/retaliate/rogue/boar
	icon = 'icons/roguetown/mob/monster/boar.dmi'
	name = "bramblesnout"
	desc = "The ever terrifying bramblesnout. Not just large, but its many tusks hook into flesh to create grievous wounds. Being charged is a surefire way to perish."
	icon_state = "boar"
	icon_living = "boar"
	icon_dead = "boar_dead"
	pixel_x = -8
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	turns_per_move = 2
	see_in_dark = 6
	move_to_delay = 5
	base_intents = list(/datum/intent/simple/claw/boar)
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 2, /obj/item/alch/viscera = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 3,
						/obj/item/natural/hide = 2,
						/obj/item/natural/fur = 1,
						/obj/item/natural/bone = 3,
						/obj/item/alch/sinew = 3,
						/obj/item/alch/bone = 1,
						/obj/item/alch/viscera = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 5,
						/obj/item/natural/hide = 3,
						/obj/item/natural/fur = 2,
						/obj/item/natural/bone = 3,
						/obj/item/alch/sinew = 3,
						/obj/item/alch/bone = 1,
						/obj/item/alch/viscera = 1)
	head_butcher = /obj/item/natural/head/mole
	faction = list(FACTION_BOARS)
	threat_point = THREAT_ELITE
	ambush_faction = "wildlife"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = BOAR_HEALTH
	maxHealth = BOAR_HEALTH
	melee_damage_lower = 30
	melee_damage_upper = 40
	vision_range = 7
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	retreat_distance = 0
	minimum_distance = 0
	milkies = FALSE
	food_type = list(/obj/item/reagent_containers/food/snacks/rogue/meat, 
	)
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	STASTR = 15
	STASPD = 13
	deaggroprob = 0
	defprob = 40
	del_on_deaggro = 44 SECONDS
	retreat_health = 0.3
	food = 0
	attack_sound = list('sound/vo/mobs/vw/attack (1).ogg','sound/vo/mobs/vw/attack (2).ogg','sound/vo/mobs/vw/attack (3).ogg','sound/vo/mobs/vw/attack (4).ogg')
	dodgetime = 30
	aggressive = 1
	remains_type = /obj/effect/decal/remains/mole
	AIStatus = AI_OFF
	can_have_ai = FALSE
	ai_controller = /datum/ai_controller/boar

/mob/living/simple_animal/hostile/retaliate/rogue/boar/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)
	gender = MALE
	if(prob(33))
		gender = FEMALE
	update_icon()
	ai_controller.set_blackboard_key(BB_BASIC_FOODS, food_type)

/mob/living/simple_animal/hostile/retaliate/rogue/boar/death(gibbed)
	..()
	update_icon()

/mob/living/simple_animal/hostile/retaliate/rogue/boar/get_sound(input)//my media player does not work please add new .ogg
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/vw/aggro (1).ogg','sound/vo/mobs/vw/aggro (2).ogg')
		if("pain")
			return pick('sound/vo/mobs/vw/pain (1).ogg','sound/vo/mobs/vw/pain (2).ogg','sound/vo/mobs/vw/pain (3).ogg')
		if("death")
			return pick('sound/vo/mobs/vw/death (1).ogg','sound/vo/mobs/vw/death (2).ogg','sound/vo/mobs/vw/death (3).ogg','sound/vo/mobs/vw/death (4).ogg','sound/vo/mobs/vw/death (5).ogg')
		if("idle")
			return pick('sound/vo/mobs/vw/idle (1).ogg','sound/vo/mobs/vw/idle (2).ogg','sound/vo/mobs/vw/idle (3).ogg','sound/vo/mobs/vw/idle (4).ogg')
		if("cidle")
			return pick('sound/vo/mobs/vw/bark (1).ogg','sound/vo/mobs/vw/bark (2).ogg','sound/vo/mobs/vw/bark (3).ogg','sound/vo/mobs/vw/bark (4).ogg','sound/vo/mobs/vw/bark (5).ogg','sound/vo/mobs/vw/bark (6).ogg','sound/vo/mobs/vw/bark (7).ogg')

/mob/living/simple_animal/hostile/retaliate/rogue/boar/taunted(mob/user)
	emote("aggro")
	Retaliate()
	GiveTarget(user)
	return

/mob/living/simple_animal/hostile/retaliate/rogue/boar/Life()
	..()
	if(pulledby)
		Retaliate()
		GiveTarget(pulledby)

/mob/living/simple_animal/hostile/retaliate/rogue/boar/simple_limb_hit(zone)
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

/datum/intent/simple/claw/boar
	clickcd = BOAR_ATTACK_SPEED
	name = "tusks"
	attack_verb = list("gores", "impales", "eviscerates")
	penfactor = PEN_HEAVY
	blade_class = BCLASS_STAB
