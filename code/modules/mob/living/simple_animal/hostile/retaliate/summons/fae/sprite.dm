/mob/living/simple_animal/hostile/retaliate/rogue/fae/sprite
	anatomy_type = /datum/anatomy/winged/trash
	icon = 'icons/mob/summonable/32x32.dmi'
	name = "sprite"
	desc = "This is a sprite, a particularly small manner of fae-creature known often to surround \
	groves frequented by their kind. Often taken as a sign of good luck, although they are occasionally \
	mistaken for Will-o'-the-wisps."
	icon_state = "sprite"
	icon_living = "sprite"
	icon_dead = "vvd"
	summon_primer = "You are a sprite, a small fae. You spend time wandering the wilds. Now you've been pulled from your home into a new world, that is decidedly less wild and natural. How you react to these events, only time can tell."
	summon_tier = 1
	gender = FEMALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	turns_per_move = 6
	see_in_dark = 6
	move_to_delay = 3
	base_intents = list(/datum/intent/unarmed/claw)
	butcher_results = list()
	death_loot = list(/obj/item/magic/fae/fairydust = 4)
	faction = list(FACTION_FAE)
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 50
	maxHealth = 50
	threat_point = THREAT_TRASH
	ranged = FALSE
	melee_damage_lower = 8
	melee_damage_upper = 12
	vision_range = 8
	aggro_vision_range = 11
	environment_smash = ENVIRONMENT_SMASH_NONE
	simple_detect_bonus = 20
	retreat_distance = 0
	minimum_distance = 0
	food_type = list()
	movement_type = FLYING
	pooptype = null
	STAWIL = 6
	STACON = 6
	STASTR = 2
	STASPD = 12
	simple_detect_bonus = 20
	deaggroprob = 0
	candodge = TRUE
	// del_on_deaggro = 44 SECONDS
	retreat_health = 0
	food = 0
	attack_sound = 'sound/combat/hits/bladed/smallslash (1).ogg'
	attack_verb_continuous = "jabs"
	attack_verb_simple = "jab"
	dodgetime = 40
	aggressive = 1

	ai_controller = /datum/ai_controller/fae/skirmisher/melee
	move_base_delay = MOVEMENT_DELAY_SPD_10

/mob/living/simple_animal/hostile/retaliate/rogue/fae/sprite/Initialize(mapload)
	src.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	. = ..()

/mob/living/simple_animal/hostile/retaliate/rogue/fae/sprite/death(gibbed)
	..()
	update_icon()
	spawn(1)
		qdel(src)

/mob/living/simple_animal/hostile/retaliate/rogue/fae/sprite/taunted(mob/user)
	emote("aggro")
	Retaliate()
	GiveTarget(user)
	return
