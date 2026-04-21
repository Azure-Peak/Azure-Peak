
/mob/living/simple_animal/hostile/retaliate/rogue/elemental/warden
	icon = 'icons/mob/summonable/32x32.dmi'
	name = "earthen Warden"
	desc = "An ever-watchful warden, a manner of earthen elemental dutiful in its protection \
	of its native plane. As a consequence of their competence, they are often summoned to Psydonia \
	by ambitious conjurers to serve their bidding instead."
	icon_state = "warden"
	icon_living = "warden"
	icon_dead = "vvd"
	summon_primer = "You are an warden, a moderate elemental. Elementals such as yourself guard your plane from intrusion zealously. Now you've been pulled from your home into a new world, that is decidedly less peaceful then your carefully guarded plane. How you react to these events, only time can tell."
	summon_tier = 2
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	turns_per_move = 3
	see_in_dark = 6
	move_to_delay = 12
	base_intents = list(/datum/intent/simple/elemental_unarmed)
	butcher_results = list()
	death_loot = list(/obj/item/magic/elemental/shard = 2)
	faction = list(FACTION_ELEMENTAL)
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 340
	maxHealth = 340
	melee_damage_lower = 25
	melee_damage_upper = 30
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
	defprob = 30
	// del_on_deaggro = 44 SECONDS
	retreat_health = 0
	food = 0
	rapid = TRUE
	attack_sound = 'sound/combat/hits/onstone/wallhit.ogg'
	dodgetime = 30
	aggressive = 1

	STACON = 15
	STAWIL = 15
	STASTR = 10
	STASPD = 6

/mob/living/simple_animal/hostile/retaliate/rogue/elemental/warden/Initialize()
	src.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	. = ..()

/mob/living/simple_animal/hostile/retaliate/rogue/elemental/warden/death(gibbed)
	..()
	update_icon()
	spill_embedded_objects()
	qdel(src)
