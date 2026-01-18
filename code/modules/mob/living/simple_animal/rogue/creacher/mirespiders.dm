/mob/living/simple_animal/hostile/retaliate/rogue/mirespider
	icon = 'icons/mob/mirespider_small.dmi'
	desc = "Said to have originated from the decapitated heads of fallen legionnaires from eons past, grown legs and a voracious appetite, mire crawlers are common pests in many a wetland. Occasionally hunted for their silk."
	name = "mire crawler"
	icon_state = "crawler"
	icon_living = "crawler"
	icon_dead = "crawler_dead"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	emote_hear = null
	emote_see = null
	speak_chance = 1
	turns_per_move = 2
	see_in_dark = 10
	move_to_delay = 3

	faction = list("zombie", "spiders")
	attack_sound = list('sound/vo/mobs/spider/attack (1).ogg','sound/vo/mobs/spider/attack (2).ogg','sound/vo/mobs/spider/attack (3).ogg','sound/vo/mobs/spider/attack (4).ogg')

	base_intents = list(/datum/intent/simple/bite/mirespider)
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/spider = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/spider = 1,
						/obj/item/natural/hide = 1,
						/obj/item/natural/silk = 1, 
						/obj/item/alch/viscera = 1,
						/obj/item/natural/head/mirespider = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/spider = 1,
						/obj/item/natural/hide = 1,
						/obj/item/natural/silk = 2, 
						/obj/item/alch/viscera = 1,
						/obj/item/natural/head/mirespider = 1)

	health = MIRESPIDER_CRAWLER_HEALTH
	maxHealth = MIRESPIDER_CRAWLER_HEALTH
	melee_damage_lower = 17
	melee_damage_upper = 26
	vision_range = 10
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_NONE
	retreat_distance = 0
	minimum_distance = 0
	milkies = FALSE

	STACON = 7
	STASTR = 7
	STASPD = 13
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	defprob = 40
	retreat_health = 0
	food = 0

	AIStatus = AI_OFF
	can_have_ai = FALSE
	ai_controller = /datum/ai_controller/mirespider

/mob/living/simple_animal/hostile/retaliate/rogue/mirespider/Initialize()
	. = ..()
	update_icon()
	AddElement(/datum/element/ai_retaliate)
	ADD_TRAIT(src, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_KNEESTINGER_IMMUNITY, INNATE_TRAIT)

	addtimer(CALLBACK(src, PROC_REF(find_lurker_to_follow)), 10)

/mob/living/simple_animal/hostile/retaliate/rogue/mirespider/proc/find_lurker_to_follow()
	var/mob/living/simple_animal/hostile/rogue/mirespider_lurker/lurker = null
	for(var/mob/living/simple_animal/hostile/rogue/mirespider_lurker/L in view(10, src))
	{
		lurker = L
		break
	}
	
	if(lurker && ai_controller)
		ai_controller.set_blackboard_key(BB_FOLLOW_TARGET, lurker)

/mob/living/simple_animal/hostile/retaliate/rogue/mirespider/death(gibbed)
	..()
	update_icon()

/datum/intent/simple/bite/mirespider
	clickcd = MIRESPIDER_ATTACK_SPEED

/mob/living/simple_animal/hostile/retaliate/rogue/mirespider/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/spider/aggro (1).ogg','sound/vo/mobs/spider/aggro (2).ogg','sound/vo/mobs/spider/aggro (3).ogg')
		if("pain")
			return pick('sound/vo/mobs/spider/pain.ogg')
		if("death")
			return pick('sound/vo/mobs/spider/death.ogg')
		if("idle")
			return pick('sound/vo/mobs/spider/idle (1).ogg','sound/vo/mobs/spider/idle (2).ogg','sound/vo/mobs/spider/idle (3).ogg','sound/vo/mobs/spider/idle (4).ogg')

/mob/living/simple_animal/hostile/retaliate/rogue/mirespider/taunted(mob/user)
	emote("aggro")
	Retaliate()
	GiveTarget(user)
	return

/mob/living/simple_animal/hostile/retaliate/rogue/mirespider/Life()
	..()
	if(pulledby)
		Retaliate()
		GiveTarget(pulledby)


/mob/living/simple_animal/hostile/retaliate/rogue/mirespider/simple_limb_hit(zone)
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

/mob/living/simple_animal/hostile/rogue/mirespider_lurker
	icon = 'icons/mob/mirespider_big.dmi'
	desc = "An unusually large and dangerous mire crawler, these lumbering creatures tend to find smaller specimens gravitating to them for safety - or perhaps simply to hunt more efficiently."
	name = "mire lurker"
	icon_state = "lurker"
	icon_living = "lurker"
	icon_dead = "lurker_dead"

	faction = list("zombie", "spiders")
	attack_sound = list('sound/vo/mobs/spider/attack (1).ogg','sound/vo/mobs/spider/attack (2).ogg','sound/vo/mobs/spider/attack (3).ogg','sound/vo/mobs/spider/attack (4).ogg')

	base_intents = list(/datum/intent/simple/bite/mirespider_lurker)
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/spider = 2,
						/obj/item/natural/hide = 2,
						/obj/item/natural/silk = 1, 
						/obj/item/alch/viscera = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/spider = 4,
						/obj/item/natural/hide = 3,
						/obj/item/natural/silk = 3, 
						/obj/item/alch/viscera = 4,
						/obj/item/natural/head/mirelurker = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/spider = 4,
						/obj/item/natural/hide = 4,
						/obj/item/natural/silk = 5, // You killed the mire lurker. You get all the figgy pudding . . .
						/obj/item/alch/viscera = 4,
						/obj/item/natural/head/mirelurker = 1)

	health = MIRESPIDER_LURKER_HEALTH
	maxHealth = MIRESPIDER_LURKER_HEALTH
	melee_damage_lower = 35
	melee_damage_upper = 70

	STACON = 9
	STASTR = 9
	STASPD = 14
	// These things will crit. Slow attacks, devestating consequences.
	STAPER = 15
	pixel_x = -4

	ai_controller = /datum/ai_controller/mirespider_lurker
	projectiletype = /obj/projectile/bullet/spider

	ranged = 1
	minimum_distance = 1
	ranged_cooldown_time = 100
	check_friendly_fire = 1

	var/list/mob/living/simple_animal/hostile/retaliate/rogue/mirespider/followers = list()

/mob/living/simple_animal/hostile/rogue/mirespider_lurker/mushroom
	icon = 'icons/mob/mirespider_shroom.dmi'
	desc = "Mushroom!"
	name = "mire lurker?"
	icon_state = "mushroom"
	icon_living = "mushroom"
	icon_dead = "mushroom_dead"
	health = MIRESPIDER_MUSHROOM_HEALTH
	maxHealth = MIRESPIDER_MUSHROOM_HEALTH
	pixel_x = -8

	projectiletype = /obj/projectile/bullet/spider_shroom
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/spider = 2,
						/obj/item/natural/hide = 2,
						/obj/item/natural/silk = 1, 
						/obj/item/reagent_containers/powder/ozium = 1,
						/obj/item/alch/viscera = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/spider = 4,
						/obj/item/natural/hide = 3,
						/obj/item/natural/silk = 3, 
						/obj/item/reagent_containers/powder/ozium = 2,
						/obj/item/alch/viscera = 4,
						/obj/item/natural/head/mirelurker = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/spider = 4,
						/obj/item/natural/hide = 4,
						/obj/item/natural/silk = 5, // You killed the mire lurker. You get all the figgy pudding . . .
						/obj/item/reagent_containers/powder/ozium = 2,
						/obj/item/reagent_containers/powder/herozium = 1,
						/obj/item/alch/viscera = 4,
						/obj/item/natural/head/mirelurker = 1)

/mob/living/simple_animal/hostile/rogue/mirespider_lurker/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_KNEESTINGER_IMMUNITY, INNATE_TRAIT)
	// I'll replace this with something better later. Stopgap for now to make killing them more than just a nuisance.

/mob/living/simple_animal/hostile/rogue/mirespider_lurker/death(gibbed)
	..()
	if(prob(40))
		new /obj/item/reagent_containers/food/snacks/rogue/honey(loc)
	if(prob(10))
		new /obj/item/roguegem/violet(loc)
	update_icon()

/datum/intent/simple/bite/mirespider_lurker
	clickcd = MIRESPIDER_LURKER_ATTACK_SPEED

/mob/living/simple_animal/hostile/rogue/mirespider_lurker/proc/add_follower(mob/living/simple_animal/hostile/retaliate/rogue/mirespider)
	if (!(mirespider in followers))
		followers += mirespider

/mob/living/simple_animal/hostile/rogue/mirespider_lurker/proc/clear_followers_if_any()
	if (!followers || !length(followers))
		return

	for (var/mob/living/simple_animal/hostile/retaliate/rogue/mirespider/follower in followers)
		follower.ai_controller.clear_blackboard_key(BB_FOLLOW_TARGET)
		follower.ai_controller.clear_blackboard_key(BB_TRAVEL_DESTINATION)
		follower.ai_controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
		follower.ai_controller.clear_blackboard_key(BB_BASIC_MOB_RETALIATE_LIST)
		follower.ai_controller.CancelActions()
	followers.Cut()

/mob/living/simple_animal/hostile/rogue/mirespider_paralytic
	icon = 'icons/mob/mirespider_small.dmi'
	name = "aragn"
	icon_state = "aragn"
	icon_living = "aragn"
	icon_dead = "aragn_dead"

	faction = list("zombie", "spiders")
	attack_sound = list('sound/vo/mobs/spider/attack (1).ogg','sound/vo/mobs/spider/attack (2).ogg','sound/vo/mobs/spider/attack (3).ogg','sound/vo/mobs/spider/attack (4).ogg')

	base_intents = list(/datum/intent/simple/bite/mirespider_paralytic)
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/spider = 1,
						/obj/item/natural/silk = 1, 
						/obj/item/alch/viscera = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/spider = 2,
						/obj/item/natural/hide = 1,
						/obj/item/natural/silk = 1, 
						/obj/item/alch/viscera = 1,
						/obj/item/reagent_containers/spidervenom_inert = 1, 
						/obj/item/natural/head/mirespider_paralytic = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/spider = 2,
						/obj/item/natural/hide = 1,
						/obj/item/natural/silk = 1, 
						/obj/item/alch/viscera = 1, 
						/obj/item/reagent_containers/spidervenom_inert = 2, 
						/obj/item/natural/head/mirespider_paralytic = 1)

	health = MIRESPIDER_ARAGN_HEALTH
	maxHealth = MIRESPIDER_ARAGN_HEALTH
	melee_damage_lower = 21
	melee_damage_upper = 42

	STACON = 9
	STASTR = 9
	STASPD = 12
	STAPER = 7

	ai_controller = /datum/ai_controller/mirespider_paralytic

/datum/intent/simple/bite/mirespider_paralytic
	clickcd = ARAGN_ATTACK_SPEED

/mob/living/simple_animal/hostile/rogue/mirespider_paralytic/AttackingTarget()
	. = ..()
	if(. && isliving(target))
		var/mob/living/L = target
		if(L.reagents && prob(50))
			L.reagents.add_reagent(/datum/reagent/toxin/spidervenom_paralytic, 5)

/obj/random/spider
	icon = 'icons/mob/mirespider_small.dmi'
	name = "random spider spawner"
	desc = "YOU SHOULD NOT BE SEEING THIS, GO YELL AT KETRAI."
	icon_state = "crawler"

/obj/random/spider/Initialize()
	. = ..()
	spawn_random_spider_at(loc)
	qdel(src)

/obj/random/spider/proc/spawn_random_spider_at(turf/T)
	var/newspider = list(/mob/living/simple_animal/hostile/rogue/mirespider_paralytic = 10, /mob/living/simple_animal/hostile/retaliate/rogue/mirespider = 90)
	var/spider_to_spawn = pickweight(newspider)
	new spider_to_spawn(get_turf(src))
	qdel(src)

/mob/living/simple_animal/hostile/retaliate/rogue/mirespider/angry
	faction = list("mad", "zombie")

/mob/living/simple_animal/hostile/rogue/mirespider_paralytic/angry
	faction = list("mad", "zombie")

/mob/living/simple_animal/hostile/rogue/mirespider_lurker/angry
	faction = list("mad", "zombie")
