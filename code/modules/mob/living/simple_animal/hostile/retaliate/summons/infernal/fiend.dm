/mob/living/simple_animal/hostile/retaliate/rogue/infernal/fiend
	anatomy_type = /datum/anatomy/biped/tough/fiend
	icon = 'icons/mob/summonable/32x32.dmi'
	name = "fiend"
	desc = "A much larger relative of the common infernal imp, this otherworldly creature stands to an impressive height \
	and breadth. Whenever it ceases to move its body freezes to a complete standstill, as if it were a gargoyle."
	icon_state = "fiend"
	icon_living = "fiend"
	icon_dead = "vvd"
	summon_primer = "You are fiend, a large sized demon from the infernal plane. You have imps and hounds at your beck and call, able to do whatever you wished. Now you've been pulled from your home into a new world, that is decidedly lacking in fire. How you react to these events, only time can tell."
	summon_tier = 4
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	turns_per_move = 3
	see_in_dark = 6
	move_to_delay = 10
	base_intents = list(/datum/intent/simple/bite)
	butcher_results = list()
	death_loot = list(/obj/item/magic/infernal/flame = 1)
	faction = list(FACTION_INFERNAL)
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 1400
	maxHealth = 1400
	threat_point = THREAT_APEX
	obj_damage = 150
	melee_damage_lower = 40
	melee_damage_upper = 55
	vision_range = 7
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	simple_detect_bonus = 20
	retreat_distance = 0
	minimum_distance = 0
	food_type = list()
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	STAWIL = 15
	STACON = 13
	STASTR = 12
	STASPD = 8
	simple_detect_bonus = 20
	deaggroprob = 0
	canparry = TRUE
	// del_on_deaggro = 44 SECONDS
	retreat_health = 0
	food = 0
	attack_sound = list('sound/misc/lava_death.ogg')
	dodgetime = 30
	aggressive = 1

	ai_controller = /datum/ai_controller/infernal
	move_base_delay = MOVEMENT_DELAY_SLOW

/mob/living/simple_animal/hostile/retaliate/rogue/infernal/fiend/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	var/datum/action/cooldown/spell/telegraphed_strike/mob_ability/ground/meteor_storm/storm = new(src)
	storm.Grant(src)
	var/datum/action/cooldown/spell/call_infernals/call_them = new(src)
	call_them.Grant(src)

/mob/living/simple_animal/hostile/retaliate/rogue/infernal/fiend/death(gibbed)
	..()
	update_icon()
	spill_embedded_objects()
	qdel(src)
