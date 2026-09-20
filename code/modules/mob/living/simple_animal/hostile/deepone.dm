/mob/living/simple_animal/hostile/rogue/deepone
	anatomy_type = /datum/anatomy/biped
	name = "Deep One"
	desc = "It is said that, when the world was young and Abyssor did not yet dream, he took a mass of humenity \
	in his hand and brought them to the abyss, sculpting from them speechless men in his own image."
	icon = 'icons/roguetown/mob/monster/fishman.dmi'
	icon_state = "deep1"
	icon_living = "deep1"
	icon_dead = "deep1_d"
	gender = MALE
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	robust_searching = 1
	turns_per_move = 2
	move_to_delay = 3
	STACON = 11
	STASTR = 13
	STASPD = 9
	maxHealth = DEEPONE_HEALTH
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/crab = 2,
									/obj/item/alch/viscera = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/crab = 3,
							/obj/item/alch/viscera = 2)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/crab = 5,
							/obj/item/alch/viscera = 2)
	health = DEEPONE_HEALTH
	harm_intent_damage = 20
	melee_damage_lower = 10
	melee_damage_upper = 25
	vision_range = 7
	aggro_vision_range = 9
	retreat_distance = 0
	minimum_distance = 0
	limb_destroyer = 0
	base_intents = list(/datum/intent/simple/claw/deepone_unarmed)
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/combat/wooshes/punch/punchwoosh (1).ogg'
	d_intent = INTENT_DODGE
	speak_emote = list("burbles")
	faction = list(FACTION_DEEPONE)
	threat_point = THREAT_HIGH
	ambush_faction = "deepones"
	footstep_type = FOOTSTEP_MOB_BAREFOOT

	can_have_ai = FALSE
	AIStatus = AI_OFF

	ai_controller = /datum/ai_controller/deepone
	move_base_delay = MOVEMENT_DELAY_SPD_10

/mob/living/simple_animal/hostile/rogue/deepone/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)

/mob/living/simple_animal/hostile/rogue/deepone/arm
	name = "Deep One"
	icon = 'icons/roguetown/mob/monster/fishman.dmi'
	icon_state = "deep1_arm"
	health = DEEPONE_HEALTH * 1.4
	harm_intent_damage = 25
	melee_damage_lower = 15
	melee_damage_upper = 30
	limb_destroyer = 1
	attack_verb_continuous = "mauls"
	attack_verb_simple = "maul"

/mob/living/simple_animal/hostile/rogue/deepone/spit
	threat_point = THREAT_TOUGH
	name = "Deep One"
	icon = 'icons/roguetown/mob/monster/fishman.dmi'
	icon_state = "deep1_spit"
	icon_living = "deep1_spit"
	icon_dead = "deep1_d"
	projectiletype = /obj/projectile/bullet/reusable/deepone
	projectilesound = 'sound/combat/wooshes/punch/punchwoosh (1).ogg'
	ranged = 1
	retreat_distance = 2
	minimum_distance = 5
	ranged_cooldown_time = 40
	check_friendly_fire = 1
	ai_controller = /datum/ai_controller/deepone_ranged
	move_base_delay = MOVEMENT_DELAY_SPD_3

/mob/living/simple_animal/hostile/rogue/deepone/wiz
	threat_point = THREAT_TOUGH
	name = "Deep One Devout"
	icon = 'icons/roguetown/mob/monster/fishman.dmi'
	icon_state = "deep1_wiz"
	icon_living = "deep1_wiz"
	icon_dead = "deep1_d"
	projectiletype = /obj/projectile/magic
	projectilesound = 'sound/magic/fireball.ogg'
	ranged = 1
	retreat_distance = 2
	minimum_distance = 5
	ranged_cooldown_time = 70
	check_friendly_fire = 1
	ai_controller = /datum/ai_controller/deepone_ranged
	move_base_delay = MOVEMENT_DELAY_SPD_3
	var/allowed_projectile_types = list(/obj/projectile/magic/frostbolt, /obj/projectile/energy/rogue3)

/mob/living/simple_animal/hostile/rogue/deepone/wiz/Shoot()
	projectiletype = pick(allowed_projectile_types)
	..()
/mob/living/simple_animal/hostile/rogue/deepone/wiz/boss
	wander = FALSE
/mob/living/simple_animal/hostile/rogue/deepone/spit/boss
	wander = FALSE
/mob/living/simple_animal/hostile/rogue/deepone/arm/boss
	wander = FALSE
/mob/living/simple_animal/hostile/rogue/deepone/boss
	wander = FALSE
/datum/intent/simple/claw/deepone_unarmed
	attack_verb = list("claws", "strikes")
	blade_class = BCLASS_CHOP
	animname = "cut"
	hitsound = 'sound/combat/hits/bladed/smallslash (1).ogg'
	clickcd = DEEPONE_ATTACK_SPEED
	penfactor = PEN_NONE
	chargetime = 2
/datum/intent/simple/claw/deepone_boss
	attack_verb = list("smashes", "slams")
	blade_class = BCLASS_CHOP
	animname = "cut"
	hitsound = 'sound/combat/hits/blunt/metalblunt (1).ogg'
	clickcd = DEEPONE_ATTACK_SPEED
	penfactor = PEN_NONE
	chargetime = 2

/mob/living/simple_animal/hostile/rogue/deepone/hound
	anatomy_type = /datum/anatomy/quadruped/standard
	name = "depth hound"
	desc = "Fish? Beast? How about both. It is said deep ones throw these dogs at birds to obtain such a rare delicacy."
	icon = 'icons/roguetown/mob/monster/fishman.dmi'
	icon_state = "deep_hound"
	icon_living = "deep_hound"
	icon_dead = "deep_hound_dead"
	gender = MALE
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	STACON = 10
	STASTR = 12
	STASPD = 12
	health = DEEPONE_HOUND_HEALTH
	maxHealth = DEEPONE_HOUND_HEALTH
	harm_intent_damage = 18
	melee_damage_lower = 12
	melee_damage_upper = 32
	move_base_delay = MOVEMENT_DELAY_SPD_17
	ai_controller = /datum/ai_controller/deepone_hound
	var/pounce_type = /datum/action/cooldown/spell/telegraphed_strike/mob_ability/deepone_pounce

/mob/living/simple_animal/hostile/rogue/deepone/hound/Initialize(mapload)
	. = ..()
	var/datum/action/cooldown/spell/telegraphed_strike/mob_ability/deepone_pounce/pounce = new pounce_type(src)
	pounce.Grant(src)

/mob/living/simple_animal/pet/depth_hound
	anatomy_type = /datum/anatomy/quadruped/standard
	name = "depth doggy"
	desc = "Good boy?"
	icon = 'icons/roguetown/mob/monster/fishman.dmi'
	icon_state = "deep_hound"
	icon_living = "deep_hound"
	icon_dead = "deep_hound_dead"
	gender = MALE
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak = list("Gurgle...", "Chrk-chrk!", "Glub!", "Squeeech!")
	speak_emote = list("gurgles", "clicks its teeth", "snarls softly")
	emote_hear = list("clicks its jaws.", "makes a low wet gurgle.")
	emote_see = list("shakes sea foam from its back.", "scratches its webbed ears.")
	speak_chance = 2
	turns_per_move = 4
	see_in_dark = 6
	health = DEEPONE_HOUND_HEALTH
	maxHealth = DEEPONE_HOUND_HEALTH
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	gold_core_spawnable = FRIENDLY_SPAWN
	footstep_type = FOOTSTEP_MOB_CLAW
