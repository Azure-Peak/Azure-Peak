/mob/living/simple_animal/hostile/rogue/dragger
	icon = 'icons/roguetown/underworld/enigma_dragger.dmi'
	icon_state = "dragger"
	icon_living = "dragger"
	icon_dead = "dragger_dead"
	name = "dragger"
	desc = "A husk of the once-dead."
	pixel_x = -8
	mob_biotypes = MOB_UNDEAD|MOB_HUMANOID
	movement_type = GROUND
	environment_smash = ENVIRONMENT_SMASH_NONE
	pass_flags = PASSTABLE|PASSGRILLE
	base_intents = list(/datum/intent/simple/dragger)
	gender = FEMALE
	speak_chance = 0
	turns_per_move = 5
	response_help_continuous = "passes through"
	response_help_simple = "pass through"
	maxHealth = DRAGGER_HEALTH
	health = DRAGGER_HEALTH
	stat_attack = UNCONSCIOUS
	robust_searching = 1
	speed = 1
	move_to_delay = 5 //delay for the automated movement.
	harm_intent_damage = 1
	obj_damage = 1
	melee_damage_lower = 30
	melee_damage_upper = 45
	attack_same = FALSE
	attack_sound = 'sound/combat/wooshes/bladed/wooshmed (1).ogg'
	dodge_sound = 'sound/combat/dodge.ogg'
	parry_sound = "bladedmedium"
	d_intent = INTENT_PARRY
	speak_emote = list("growls")
	limb_destroyer = 1
	del_on_death = FALSE
	STALUC = 11
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	faction = list(FACTION_UNDEAD)
	footstep_type = null
	defprob = 50 //decently skilled
	canparry = TRUE
	retreat_health = null

	can_have_ai = FALSE //disable native ai
	AIStatus = AI_OFF
	ai_controller = /datum/ai_controller/dragger

/mob/living/simple_animal/hostile/rogue/dragger/electrocute_act(shock_damage, source, siemens_coeff = 1, flags = NONE)
	return FALSE

/mob/living/simple_animal/hostile/rogue/dragger/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_NOSE)
			return "head"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "head"
		if(BODY_ZONE_PRECISE_SKULL)
			return "head"
		if(BODY_ZONE_PRECISE_EARS)
			return "head"
		if(BODY_ZONE_PRECISE_NECK)
			return "neck"
		if(BODY_ZONE_PRECISE_L_HAND)
			return "hand"
		if(BODY_ZONE_PRECISE_R_HAND)
			return "hand"
		if(BODY_ZONE_PRECISE_L_FOOT)
			return "tail"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "tail"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "body"
		if(BODY_ZONE_PRECISE_GROIN)
			return "body"
		if(BODY_ZONE_PRECISE_R_INHAND)
			return "body"
		if(BODY_ZONE_PRECISE_L_INHAND)
			return "body"
		if(BODY_ZONE_HEAD)
			return "head"
		if(BODY_ZONE_R_LEG)
			return "tail"
		if(BODY_ZONE_L_LEG)
			return "tail"
		if(BODY_ZONE_R_ARM)
			return "arm"
		if(BODY_ZONE_L_ARM)
			return "arm"
		if(BODY_ZONE_CHEST)
			return "chest"

	return ..()

/mob/living/simple_animal/hostile/rogue/dragger/taunted(mob/user)
	GiveTarget(user)
	return

/mob/living/simple_animal/hostile/rogue/dragger/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)
	set_light(2, 2, 2, l_color = "#c0523f")
	ADD_TRAIT(src, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_SILVER_WEAK, TRAIT_GENERIC)


/mob/living/simple_animal/hostile/rogue/dragger/death(gibbed)
	emote("death")
	..()

/mob/living/simple_animal/hostile/rogue/dragger/Life()
	. = ..()

/mob/living/simple_animal/hostile/rogue/dragger/get_sound(input)
	switch(input)
		if("laugh")
			return pick('sound/vo/mobs/ghost/laugh (1).ogg','sound/vo/mobs/ghost/laugh (2).ogg','sound/vo/mobs/ghost/laugh (3).ogg','sound/vo/mobs/ghost/laugh (4).ogg','sound/vo/mobs/ghost/laugh (5).ogg','sound/vo/mobs/ghost/laugh (6).ogg')
		if("moan")
			return pick('sound/vo/mobs/ghost/moan (1).ogg','sound/vo/mobs/ghost/laugh (2).ogg','sound/vo/mobs/ghost/laugh (3).ogg')
		if("death")
			return 'sound/vo/mobs/ghost/death.ogg'
		if("whisper")
			return pick('sound/vo/mobs/ghost/whisper (1).ogg','sound/vo/mobs/ghost/whisper (2).ogg','sound/vo/mobs/ghost/whisper (3).ogg')
		if("aggro")
			return pick('sound/vo/mobs/ghost/aggro (1).ogg','sound/vo/mobs/ghost/aggro (2).ogg','sound/vo/mobs/ghost/aggro (3).ogg','sound/vo/mobs/ghost/aggro (4).ogg','sound/vo/mobs/ghost/aggro (5).ogg','sound/vo/mobs/ghost/aggro (6).ogg')

/mob/living/simple_animal/hostile/rogue/dragger/AttackingTarget()
	. = ..()
	if(. && prob(8) && iscarbon(target))
		var/mob/living/carbon/C = target
		C.Immobilize(50)
		C.visible_message(span_danger("\The [src] paralyzes \the [C] in fear!"), \
				span_danger("\The [src] paralyzes me!"))
		emote("laugh")


/obj/effect/landmark/underworldsafe/Crossed(atom/movable/AM, oldloc)
	if(istype(AM, /mob/living/simple_animal/hostile/rogue/dragger))
		for(var/mob/living/carbon/human/A in view(4))
			to_chat(A, "The monster's form dematerializes as it nears the Carriage.")
		qdel(AM)

/datum/intent/simple/dragger
	name = "chop"
	icon_state = "inchop"
	attack_verb = list("cuts", "slashes")
	animname = "cut"
	blade_class = BCLASS_CHOP
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	chargetime = 0
	penfactor = PEN_NONE
	swingdelay = 3
	clickcd = DRAGGER_ATTACK_SPEED
