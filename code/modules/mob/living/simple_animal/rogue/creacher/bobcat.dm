//Bobcats are a faster, still hostile, predator — stronger than raccoons but weaker than volfs.
/mob/living/simple_animal/hostile/retaliate/rogue/bobcat
	icon = 'icons/roguetown/mob/monster/bobcat.dmi'
	name = "lynx"
	desc = "An adorable albiet hated creacher of Azuria's northern coast, hunting livestock and vulnerable people alike."
	icon_state = "bobcat"
	icon_living = "bobcat"
	icon_dead = "bobcat_dead"
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	turns_per_move = 3
	see_in_dark = 6
	move_to_delay = 3
	base_intents = list(/datum/intent/simple/bite/volf)
	aggressive = 1
	threat_point = THREAT_LOW
	ambush_faction = "wildlife"
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1, /obj/item/natural/bone = 2, /obj/item/alch/viscera = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 2,
						/obj/item/natural/hide = 1,
						/obj/item/alch/sinew = 1,
						/obj/item/alch/bone = 1,
						/obj/item/alch/viscera = 1,
						/obj/item/natural/bone = 2)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 2,
						/obj/item/natural/hide = 2,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1,
						/obj/item/alch/viscera = 1,
						/obj/item/natural/bone = 2,
						/obj/item/natural/fur/bobcat = 1)
	faction = list(FACTION_WOLFS, FACTION_ZOMBIE)
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	remains_type = /obj/effect/decal/remains/bobcat
	health = 100
	maxHealth = 100
	melee_damage_lower = 15
	melee_damage_upper = 25
	vision_range = 7
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_NONE
	retreat_distance = 0
	minimum_distance = 0
	milkies = FALSE
	food_type = list(/obj/item/reagent_containers/food/snacks,
					/obj/item/natural/bone,
					/obj/item/natural/hide)
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	STACON = 6
	STASTR = 6
	STASPD = 15
	simple_detect_bonus = 40
	deaggroprob = 0
	defprob = 40
	del_on_deaggro = 44 SECONDS
	retreat_health = 0.3
	food = 0
	attack_sound = list('sound/vo/mobs/vw/attack (1).ogg','sound/vo/mobs/vw/attack (2).ogg','sound/vo/mobs/vw/attack (3).ogg','sound/vo/mobs/vw/attack (4).ogg')
	dodgetime = 30
	eat_forever = TRUE

//new ai, old ai off
	AIStatus = AI_OFF
	can_have_ai = FALSE
	ai_controller = /datum/ai_controller/volf
	melee_cooldown = WOLF_ATTACK_SPEED

/mob/living/simple_animal/hostile/retaliate/rogue/bobcat/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)
	AddElement(/datum/element/ai_flee_while_injured, 0.75, 0.4)
	gender = pick(MALE, FEMALE)
	update_icon()
	ai_controller.set_blackboard_key(BB_BASIC_FOODS, food_type)

/obj/effect/decal/remains/bobcat
	name = "remains"
	desc = "These are the dessicated remains of a lively lynx. It was not fast enough."
	gender = PLURAL
	icon_state = "bones"
	icon = 'icons/roguetown/mob/monster/bobcat.dmi'

/mob/living/simple_animal/hostile/retaliate/rogue/bobcat/get_sound(input)
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

/mob/living/simple_animal/hostile/retaliate/rogue/bobcat/taunted(mob/user)
	emote("aggro")
	Retaliate()
	GiveTarget(user)
	return

/mob/living/simple_animal/hostile/retaliate/rogue/bobcat/Life()
	..()
	if(pulledby)
		Retaliate()
		GiveTarget(pulledby)

/mob/living/simple_animal/hostile/retaliate/rogue/bobcat/simple_limb_hit(zone)
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
