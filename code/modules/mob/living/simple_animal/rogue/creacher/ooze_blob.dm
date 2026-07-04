//Sprites contributed by VelSlime

/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob
	name = "ooze"
	desc = "A strange, amorphous animated blob of ooze."
	icon_state = "ooze"
	icon_living = "ooze"
	icon_dead = "ooze_dead"
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	turns_per_move = 3
	see_in_dark = 6
	move_to_delay = 3
	base_intents = list(/datum/intent/simple/bite/volf)
	botched_butcher_results = list(/obj/item/alch/viscera = 1)
	butcher_results = list(/obj/item/alch/waterdust = 2, 
							/obj/item/alch/viscera = 2)
	perfect_butcher_results = list(/obj/item/reagent_containers/lux_impure = 1, 
									/obj/item/alch/waterdust = 3, 
									/obj/item/alch/viscera = 3)
	head_butcher = null
	faction = list("zombie")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = WOLF_HEALTH
	maxHealth = WOLF_HEALTH
	melee_damage_lower = 19
	melee_damage_upper = 29
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
	footstep_type = FOOTSTEP_MOB_SLIME
	pooptype = null
	STACON = 13
	STASTR = 7
	STASPD = 9
	simple_detect_bonus = 20
	deaggroprob = 0
	defprob = 40
	del_on_deaggro = 44 SECONDS
	retreat_health = 0.3
	food = 0
	attack_sound = list('sound/gore/flesh_eat_01.ogg','sound/gore/flesh_eat_02.ogg','sound/gore/flesh_eat_03.ogg')
	dodgetime = 30
	aggressive = 1
//	stat_attack = UNCONSCIOUS
	remains_type = null
	eat_forever = TRUE
	var/chomp_cd = 0
	var/chomp_roll = 0
	AIStatus = AI_OFF
	can_have_ai = FALSE
	ai_controller = /datum/ai_controller/volf
	melee_cooldown = WOLF_ATTACK_SPEED
	color = "#88ff7d"

/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/AttackingTarget() //7+1d6 vs con to knock ppl down
	. = ..()
	if(. && prob(8) && iscarbon(target))
		var/mob/living/carbon/C = target
		if(world.time >= chomp_cd + 120 SECONDS) //they can do it Once basically
			chomp_roll = STASTR + (rand(0,6))
			if(chomp_roll > C.STACON)
				C.Knockdown(20)
				C.visible_message(
					span_danger("\The [src] chomps \the [C]'s legs, knocking them down!"),
					span_danger("\The [src] tugs me to the ground! I'm winded!")
				)
				C.adjustOxyLoss(10) //less punishing than zfall bc simplemob
				C.emote("gasp")
				playsound(C, 'sound/foley/zfall.ogg', 100, FALSE)
			else
				C.visible_message(span_danger("\The [src] fails to drag \the [C] down!"))
			chomp_cd = world.time

/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/Initialize()
	. = ..()
	AddElement(/datum/element/ai_retaliate)
	AddElement(/datum/element/ai_flee_while_injured, 0.75, 0.4)
	gender = MALE
	if(prob(33))
		gender = FEMALE
	update_icon()
	ai_controller.set_blackboard_key(BB_BASIC_FOODS, food_type)


/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/death(gibbed)
	..()
	update_icon()
	if(!QDELETED(src))
		AddComponent(/datum/component/deadite_animal_reanimation)

/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/foley/gross.ogg')
		if("pain")
			return pick('sound/foley/butcher.ogg')
		if("death")
			return pick('sound/foley/bubb (1).ogg')
		if("idle")
			return pick('sound/foley/water_land2.ogg','sound/foley/water_land3.ogg')
		if("cidle")
			return pick('sound/foley/water_land2.ogg','sound/foley/water_land3.ogg')

/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/taunted(mob/user)
	emote("aggro")
	Retaliate()
	GiveTarget(user)
	return

/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/Life()
	..()
	if(pulledby)
		Retaliate()
		GiveTarget(pulledby)

/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/simple_limb_hit(zone) // BLOB :D
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "blob"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "blob"
		if(BODY_ZONE_PRECISE_NOSE)
			return "blob"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "blob"
		if(BODY_ZONE_PRECISE_SKULL)
			return "blob"
		if(BODY_ZONE_PRECISE_EARS)
			return "blob"
		if(BODY_ZONE_PRECISE_NECK)
			return "blob"
		if(BODY_ZONE_PRECISE_L_HAND)
			return "blob"
		if(BODY_ZONE_PRECISE_R_HAND)
			return "blob"
		if(BODY_ZONE_PRECISE_L_FOOT)
			return "blob"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "blob"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "blob"
		if(BODY_ZONE_PRECISE_GROIN)
			return "blob"
		if(BODY_ZONE_HEAD)
			return "blob"
		if(BODY_ZONE_R_LEG)
			return "blob"
		if(BODY_ZONE_L_LEG)
			return "blob"
		if(BODY_ZONE_R_ARM)
			return "blob"
		if(BODY_ZONE_L_ARM)
			return "blob"
	return ..()
