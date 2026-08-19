/mob/living/simple_animal/hostile/retaliate/rogue/elemental/behemoth
	anatomy_type = /datum/anatomy/construct/tough
	icon = 'icons/mob/summonable/32x64.dmi'
	name = "earthen behemoth"
	desc = "A large earthen construct of dirt and rock, lumbering with the strength of eons. \
	A rare sight, said to be a sign of severe imbalance that requires correction."
	summon_primer = "You are an behemoth, a large elemental. Elementals such as yourself often lead groups of wardens in defending your plane. Now you've been pulled from your home into a new world, that is decidedly less peaceful then your carefully guarded plane. How you react to these events, only time can tell."
	summon_tier = 3
	icon_state = "behemoth"
	icon_living = "behemoth"

	icon_dead = "vvd"
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	turns_per_move = 3
	see_in_dark = 6
	move_base_delay = MOVEMENT_DELAY_CRAWLING
	move_to_delay = 15
	base_intents = list(/datum/intent/simple/elementalt2_unarmed)
	butcher_results = list()
	death_loot = list(/obj/item/magic/elemental/fragment = 1)
	faction = list(FACTION_ELEMENTAL)
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 800
	maxHealth = 800
	threat_point = 80
	melee_damage_lower = 55
	melee_damage_upper = 80
	vision_range = 7
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	simple_detect_bonus = 20
	retreat_distance = 0
	minimum_distance = 0
	food_type = list()
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	simple_detect_bonus = 20
	deaggroprob = 0
	canparry = TRUE
	// del_on_deaggro = 44 SECONDS
	retreat_health = 0
	food = 0
	attack_sound = 'sound/combat/hits/onstone/wallhit.ogg'
	dodgetime = 30
	aggressive = 1

	STACON = 17
	STAWIL = 17
	STASTR = 13
	STASPD = 5

	ai_controller = /datum/ai_controller/elemental

/mob/living/simple_animal/hostile/retaliate/rogue/elemental/behemoth/Initialize(mapload)
	src.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	. = ..()
	ADD_TRAIT(src, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	var/datum/action/cooldown/spell/telegraphed_strike/mob_ability/ground/quake/quake = new(src)
	quake.Grant(src)
	var/datum/action/cooldown/spell/telegraphed_strike/mob_ability/elemental_slam/sunder/sunder = new(src)
	sunder.Grant(src)

/mob/living/simple_animal/hostile/retaliate/rogue/elemental/behemoth/death(gibbed)
	..()
	update_icon()
	spill_embedded_objects()
	qdel(src)
