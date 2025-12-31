/mob/living/simple_animal/hostile/retaliate/rogue/minotaur
	icon = 'icons/mob/newminotaur.dmi'
	name = "Minotaur"
	desc = "An unusually giant relative of the more familiar manners of Wild-Kin. This one looks aggressive."
	icon_state = "MinotaurMale"
	icon_living = "MinotaurMale"
	icon_dead = "MinotaurMale_dead"
	pixel_x = -16
	gender = MALE
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	emote_hear = null
	emote_see = null
	speak_chance = 1
	turns_per_move = 2
	see_in_dark = 10
	move_to_delay = 3

	STACON = 19
	STASTR = 16
	STASPD = 5
	base_intents = list(/datum/intent/simple/minotaur_unarmed)
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1,
						/obj/item/natural/hide = 1, /obj/item/natural/bundle/bone/full = 2)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 2,
						/obj/item/natural/hide = 2, /obj/item/natural/bundle/bone/full = 2,
						/obj/item/natural/head/minotaur = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 4,
						/obj/item/natural/hide = 4, /obj/item/natural/bundle/bone/full = 2,
						/obj/item/natural/head/minotaur = 1)
	faction = list("caves")

	health = MINOTAUR_HEALTH
	maxHealth = MINOTAUR_HEALTH
	melee_damage_lower = 55
	melee_damage_upper = 80
	vision_range = 3
	aggro_vision_range = 8
	limb_destroyer = 0 // seems strong
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	obj_damage = 1
	retreat_distance = 0
	minimum_distance = 0
	milkies = FALSE
	food_type = list(/obj/item/reagent_containers/food/snacks/rogue/meat, 
	//obj/item/bodypart, 
	//obj/item/organ
	)
	footstep_type = FOOTSTEP_MOB_HEAVY
	pooptype = null

	deaggroprob = 0
	defprob = 40
	retreat_health = 0
	food = 0
	attack_sound = list('sound/combat/wooshes/blunt/wooshhuge (1).ogg','sound/combat/wooshes/blunt/wooshhuge (2).ogg','sound/combat/wooshes/blunt/wooshhuge (3).ogg')
	dodgetime = 0
	aggressive = 1

//new ai, old ai off
	AIStatus = AI_OFF
	can_have_ai = FALSE
	ai_controller = /datum/ai_controller/minotaur

//	stat_attack = UNCONSCIOUS

/mob/living/simple_animal/hostile/retaliate/rogue/minotaur/Initialize()
	. = ..()
	update_icon()
	AddElement(/datum/element/ai_retaliate)
	ADD_TRAIT(src, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BASHDOORS, TRAIT_GENERIC)
	ai_controller.set_blackboard_key(BB_BASIC_FOODS, food_type)

/mob/living/simple_animal/hostile/retaliate/rogue/minotaur/female
	icon_state = "MinotaurFem"
	icon_living = "MinotaurFem"
	icon_dead = "MinotaurFem_dead"

/mob/living/simple_animal/hostile/retaliate/rogue/minotaur/axe
	icon_state = "MinotaurMale_Axe"
	icon_living = "MinotaurMale_Axe"
	icon_dead = "MinotaurMale_dead"
	base_intents = list(/datum/intent/simple/minotaur_axe)
	melee_damage_lower = 65
	melee_damage_upper = 85
	limb_destroyer = TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/minotaur/axe/female
	icon_state = "MinotaurFem_Axe"
	icon_living = "MinotaurFem_Axe"
	icon_dead = "MinotaurFem_dead"

/mob/living/simple_animal/hostile/retaliate/rogue/minotaur/death(gibbed)
	..()
	update_icon()

/mob/living/simple_animal/hostile/retaliate/rogue/minotaur/taunted(mob/user)
	emote("aggro")
	Retaliate()
	GiveTarget(user)
	return

/mob/living/simple_animal/hostile/retaliate/rogue/minotaur/Life()
	..()
	if(pulledby)
		Retaliate()
		GiveTarget(pulledby)

/mob/living/simple_animal/hostile/retaliate/rogue/minotaur/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/minotaur/minoroar.ogg','sound/vo/mobs/minotaur/minoroar2.ogg','sound/vo/mobs/minotaur/minoroar3.ogg','sound/vo/mobs/minotaur/minoroar4.ogg')
		if("pain")
			return pick('sound/vo/mobs/minotaur/minopain.ogg', 'sound/vo/mobs/minotaur/minopain2.ogg')
		if("death")
			return pick('sound/vo/mobs/minotaur/minodie.ogg', 'sound/vo/mobs/minotaur/minodie2.ogg')
		if("idle")
			return pick('sound/vo/mobs/minotaur/minoidle.ogg', 'sound/vo/mobs/minotaur/minoidle2.ogg')


/mob/living/simple_animal/hostile/retaliate/rogue/minotaur/simple_limb_hit(zone)
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

/datum/intent/simple/minotaur_unarmed
	name = "minotaur unarmed"
	icon_state = "instrike"
	attack_verb = list("punches", "strikes", "kicks", "steps on", "crushes", "bites")
	animname = "blank22"
	blade_class = BCLASS_CUT
	hitsound = "smallslash"
	chargetime = 0
	penfactor = 5
	swingdelay = 3
	candodge = TRUE
	canparry = TRUE
	item_d_type = "stab"
	clickcd = MINOTAUR_ATTACK_SPEED

/datum/intent/simple/minotaur_axe
	name = "minotaur axe"
	icon_state = "instrike"
	attack_verb = list("hacks at", "slashes", "chops", "steps on", "crushes", "bites")
	animname = "blank22"
	blade_class = BCLASS_CUT
	hitsound = "genchop"
	chargetime = 10
	penfactor = 10
	swingdelay = 3
	candodge = TRUE
	canparry = TRUE
	reach = 2 
	item_d_type = "stab"
	clickcd = MINOTAUR_AXE_ATTACK_SPEED

/mob/living/simple_animal/hostile/retaliate/rogue/minotaur/original
	AIStatus = AI_ON
	can_have_ai = TRUE

// Dungeon-taur - Less health then normal.
/mob/living/simple_animal/hostile/retaliate/rogue/minotaur/wounded
	name = "Wounded Minotaur"
	icon_state = "wminotaur"
	icon_living = "wminotaur"
	health = 400	//Regular is 600.
	maxHealth = 400

/mob/living/simple_animal/hostile/retaliate/rogue/minotaur/axe/wounded
	name = "Wounded Minotaur"
	icon_state = "wminotaur_axe"
	icon_living = "wminotaur_axe"
	health = 400	//Regular is 600.
	maxHealth = 400

//Same as usual wounded, unique for orc dungeon. Prisoner-minotaur, doesn't attack orcs for dungeon related stuff.
/mob/living/simple_animal/hostile/retaliate/rogue/minotaur/wounded/chained
	name = "Chained Minotaur"
	icon_state = "chainedminotaur"
	icon_living = "chainedminotaur"
	icon_dead = "chainedminotaur_dead"
	faction = list("orcs", "caves")
