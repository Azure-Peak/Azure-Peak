/mob/living/simple_animal/hostile/retaliate/rogue/fae/glimmerwing
	anatomy_type = /datum/anatomy/winged/standard
	icon = 'icons/mob/summonable/32x32.dmi'
	name = "glimmerwing"
	desc = "A middlingly-sized fae-creature, held aloft upon fluttering wings and glimmering with unearthly \
	light. Both wonderous and capricious, and the subjects of many cautionary tales."
	icon_state = "glimmerwing"
	icon_living = "glimmerwing"
	icon_dead = "vvd"
	summon_primer = "You are a glimmerwing, a moderate sized fae. You spend time wandering forests, cursing unweary travellers. Now you've been pulled from your home into a new world, that is decidedly less wild and natural. How you react to these events, only time can tell."
	summon_tier = 2
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	turns_per_move = 6
	see_in_dark = 6
	move_to_delay = 6
	base_intents = list(/datum/intent/simple/bite)
	butcher_results = list()
	death_loot = list(/obj/item/magic/fae/iridescentscale = 2)
	faction = list(FACTION_FAE)
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 220
	maxHealth = 220
	threat_point = THREAT_HIGH
	melee_damage_lower = 18
	melee_damage_upper = 25
	vision_range = 7
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	simple_detect_bonus = 20
	ranged = FALSE
	retreat_distance = 0
	minimum_distance = 0
	food_type = list()
	movement_type = FLYING
	pooptype = null
	STACON = 7
	STASTR = 9
	STASPD = 15
	simple_detect_bonus = 20
	deaggroprob = 0
	candodge = TRUE
	// del_on_deaggro = 44 SECONDS
	retreat_health = 0
	food = 0
	attack_sound = 'sound/blank.ogg'
	dodgetime = 40
	aggressive = 1

	ai_controller = /datum/ai_controller/fae/skirmisher/melee/reactive
	move_base_delay = MOVEMENT_DELAY_SPD_10

/mob/living/simple_animal/hostile/retaliate/rogue/fae/glimmerwing/Initialize(mapload)
	src.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	. = ..()

/mob/living/simple_animal/hostile/retaliate/rogue/fae/glimmerwing/death(gibbed)
	..()
	update_icon()
	spill_embedded_objects()
	qdel(src)
