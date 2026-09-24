/mob/living/carbon/human/species/human/northern/border_reiver/
	gm_hidden = TRUE
	ai_controller = /datum/ai_controller/human_npc
	faction = list(FACTION_REIVER)
	ambushable = FALSE
	cmode = 1
	setparrytime = 30
	a_intent = INTENT_HELP
	d_intent = INTENT_PARRY
	possible_mmb_intents = list(INTENT_BITE, INTENT_JUMP, INTENT_KICK, INTENT_SPECIAL)

/mob/living/carbon/human/species/human/northern/border_reiver/lowgear
	gm_hidden = FALSE
	npc_archetype = /datum/npc_archetype/border_reiver/lowgear

/mob/living/carbon/human/species/human/northern/border_reiver/lowgear/ambush

/mob/living/carbon/human/species/human/northern/border_reiver/midgear
	gm_hidden = FALSE
	npc_archetype = /datum/npc_archetype/border_reiver/midgear

/mob/living/carbon/human/species/human/northern/border_reiver/midgear/ambush

/mob/living/carbon/human/species/human/northern/border_reiver/highgear
	gm_hidden = FALSE
	npc_archetype = /datum/npc_archetype/border_reiver/highgear

/mob/living/carbon/human/species/human/northern/border_reiver/highgear/ambush

//Simple Mobs

/mob/living/simple_animal/hostile/rogue/border_reiver_crossbow
	name = "Reiver Crossbowman"
	icon = 'icons/mob/border_reivers.dmi'
	faction = list(FACTION_REIVER)
	icon_state = "reiver_crossbow"
	icon_living = "reiver_crossbow"
	icon_dead = "reiver_crossbow_dead"
	projectiletype = /obj/projectile/bullet/reusable/bolt
	projectilesound = 'sound/combat/Ranged/crossbow-small-shot-01.ogg'
	ranged = 1
	retreat_distance = 2
	minimum_distance = 5
	ranged_cooldown_time = 150
	check_friendly_fire = 1
	health = 200
	maxHealth = 200
	ai_controller = /datum/ai_controller/reiver_crossbow
	gender = MALE
	mob_biotypes = MOB_HUMANOID
	robust_searching = 1
	turns_per_move = 1
	move_to_delay = 3
	STACON = 13
	STASTR = 14
	STASPD = 14
	vision_range = 7
	aggro_vision_range = 9
	limb_destroyer = 0
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bash"
	attack_sound = 'sound/blank.ogg'
	canparry = TRUE
	d_intent = INTENT_PARRY
	defprob = 50
	speak_emote = list("grunts")
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	del_on_death = FALSE

/mob/living/simple_animal/hostile/rogue/border_reiver_lance_rider
	name = "Reiver Rider"
	faction = list(FACTION_REIVER)
	icon = 'icons/roguetown/mob/monster/reiver_rider.dmi'
	base_intents = list(/datum/intent/simple/spear/reiver_rider_lancer,)
	icon_state = "lance_rider"
	icon_living = "lance_rider"
	icon_dead = "lance_rider_dead"
	attack_sound = 'sound/foley/pierce.ogg'
	ai_controller = /datum/ai_controller/reiver_rider/lance
	health = 650
	maxHealth = 650
	gender = MALE
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	robust_searching = 1
	turns_per_move = 5
	move_to_delay = 13
	STACON = 15
	STASTR = 12
	STASPD = 18
	melee_damage_lower = 60
	melee_damage_upper = 90
	vision_range = 7
	aggro_vision_range = 9
	retreat_distance = 0
	minimum_distance = 0
	limb_destroyer = 0
	canparry = TRUE
	d_intent = INTENT_PARRY
	defprob = 60
	speak_emote = list("grunts")
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	del_on_death = FALSE
	pixel_x = -16

/mob/living/simple_animal/hostile/rogue/border_reiver_lance_rider/sabre
	ai_controller = /datum/ai_controller/reiver_rider
	base_intents = list(/datum/intent/simple/reiver_rider_sabre,)
	icon_state = "sabre_rider"
	icon_living = "sabre_rider"
	icon_dead = "sabre_rider_dead"
	melee_damage_lower = 30
	melee_damage_upper = 45
	attack_sound = 'sound/combat/hits/bladed/genslash (1).ogg'

/datum/intent/simple/spear/reiver_rider_lancer
	reach = 2
	clickcd = REIVER_LANCE_ATTACK_SPEED
	chargetime = 1
	animname = "stab"
	penfactor = PEN_MEDIUM

/datum/intent/simple/reiver_rider_sabre
	name = "hack"
	icon_state = "instrike"
	attack_verb = list("hacks at", "chops at", "bashes")
	animname = "cut"
	blade_class = BCLASS_CUT
	hitsound = list("genchop", "genslash")
	chargetime = 0
	penfactor = PEN_NONE
	swingdelay = 2
	candodge = TRUE
	canparry = TRUE
	item_d_type = "slash"
	clickcd = REIVER_SABRE_ATTACK_SPEED
