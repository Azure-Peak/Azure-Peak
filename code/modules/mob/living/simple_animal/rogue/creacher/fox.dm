//Subtype of wolf, but non-hostile until attacked instead of default hostile.
/mob/living/simple_animal/hostile/retaliate/rogue/fox
	attack_aim = MOB_AIM_LOW
	icon = 'icons/roguetown/mob/monster/fox.dmi'
	name = "venard"
	desc = "A majestic beast of Dendor's realm, hopping through the local fauna."
	anatomy_type = /datum/anatomy/quadruped/trash
	icon_state = "fox"
	icon_living = "fox"
	icon_dead = "fox_dead"
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	turns_per_move = 3
	see_in_dark = 6
	move_to_delay = 3
	base_intents = list(/datum/intent/simple/bite/volf)	//Same as volf, simplicity is key
	aggressive = 1
	threat_point = THREAT_TRASH
	ambush_faction = "wildlife"
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1, /obj/item/alch/viscera = 1, /obj/item/natural/bone = 3)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 2,
						/obj/item/natural/hide = 1,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1,
						/obj/item/alch/viscera = 1,
						/obj/item/natural/fur/fox = 1,
						/obj/item/natural/bone = 4)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 3,
						/obj/item/natural/hide = 2,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1,
						/obj/item/alch/viscera = 1,
						/obj/item/natural/fur/fox = 2,
						/obj/item/natural/bone = 4)
	head_butcher = /obj/item/natural/head/fox
	faction = list(FACTION_WOLFS, FACTION_ZOMBIE)
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	remains_type = /obj/effect/decal/remains/fox
	health = FOX_HEALTH
	maxHealth = FOX_HEALTH		//Wolf is 120
	melee_damage_lower = 10		//Wolf is 19
	melee_damage_upper = 20		//Wolf is 29
	vision_range = 7
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_NONE
	retreat_distance = 0
	minimum_distance = 0
	milkies = FALSE
	food_type = list(/obj/item/reagent_containers/food/snacks,
					//obj/item/bodypart,
					//obj/item/organ,
					/obj/item/natural/bone,
					/obj/item/natural/hide)
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	STACON = 6
	STASTR = 5
	STASPD = 13	//Fast
	ai_controller = null
	simple_detect_bonus = 20
	deaggroprob = 0
	del_on_deaggro = 44 SECONDS
	retreat_health = 0.3
	food = 0
	attack_sound = list('sound/vo/mobs/vw/attack (1).ogg','sound/vo/mobs/vw/attack (2).ogg','sound/vo/mobs/vw/attack (3).ogg','sound/vo/mobs/vw/attack (4).ogg')
	dodgetime = 30
	aggressive = 1
	eat_forever = TRUE

//new ai, old ai off
	AIStatus = AI_OFF
	can_have_ai = FALSE
	ai_controller = /datum/ai_controller/volf
	move_base_delay = MOVEMENT_DELAY_SPD_3
	melee_cooldown = WOLF_ATTACK_SPEED

/mob/living/simple_animal/hostile/retaliate/rogue/fox/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)

/obj/effect/decal/remains/fox
	name = "remains"
	desc = "A wily fox perished here. Never is a beast spry or clever enough, in the end."
	gender = PLURAL
	icon_state = "bones"
	icon = 'icons/roguetown/mob/monster/fox.dmi'

/mob/living/simple_animal/hostile/retaliate/rogue/fox/get_sound(input)
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

/mob/living/simple_animal/hostile/retaliate/rogue/fox/taunted(mob/user)
	if(aggressive == FALSE)
		return
	else
		emote("aggro")
		Retaliate()
		GiveTarget(user)
		return

/mob/living/simple_animal/hostile/retaliate/rogue/fox/Life()
	..()
	if(aggressive == FALSE)
		return
	else
		if(pulledby)
			Retaliate()
			GiveTarget(pulledby)



/mob/living/simple_animal/hostile/retaliate/rogue/fox/guildpet
	name = "Mimi the Fox"
	desc = "An adorable creechur adopted by the Guild of Craft as their mascot."
	density = 0 // You can walk through them
	aggressive = FALSE
	ai_controller = /datum/ai_controller/generic
	move_base_delay = MOVEMENT_DELAY_SLOW

/mob/living/simple_animal/hostile/retaliate/rogue/fox/guildpet/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/vw/aggro (1).ogg','sound/vo/mobs/vw/aggro (2).ogg')
		if("pain")
			return pick('sound/vo/mobs/vw/pain (1).ogg','sound/vo/mobs/vw/pain (2).ogg','sound/vo/mobs/vw/pain (3).ogg')
		if("death")
			return pick('sound/vo/mobs/vw/death (1).ogg','sound/vo/mobs/vw/death (2).ogg','sound/vo/mobs/vw/death (3).ogg','sound/vo/mobs/vw/death (4).ogg','sound/vo/mobs/vw/death (5).ogg')
		if("idle")
			return pick('sound/vo/mobs/venard/fox1.ogg','sound/vo/mobs/venard/fox2.ogg','sound/vo/mobs/venard/fox3.ogg','sound/vo/mobs/venard/fox4.ogg','sound/vo/mobs/venard/fox5.ogg','sound/vo/mobs/venard/fox6.ogg','sound/vo/mobs/venard/fox7.ogg','sound/vo/mobs/venard/fox8.ogg','sound/vo/mobs/venard/fox9.ogg','sound/vo/mobs/venard/fox10.ogg','sound/vo/mobs/venard/fox11.ogg','sound/vo/mobs/venard/fox12.ogg','sound/vo/mobs/venard/fox13.ogg')
		if("cidle")
			return pick('sound/vo/mobs/vw/bark (1).ogg','sound/vo/mobs/vw/bark (2).ogg','sound/vo/mobs/vw/bark (3).ogg','sound/vo/mobs/vw/bark (4).ogg','sound/vo/mobs/vw/bark (5).ogg','sound/vo/mobs/vw/bark (6).ogg','sound/vo/mobs/vw/bark (7).ogg')

/mob/living/simple_animal/hostile/retaliate/rogue/fox/death(gibbed)
	. = ..()
	if(!QDELETED(src) && !gibbed)
		src.AddComponent(/datum/component/deadite_animal_reanimation)
