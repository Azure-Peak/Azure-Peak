/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad
	anatomy_type = /datum/anatomy/dryad
	icon = 'icons/mob/summonable/32x64.dmi'
	name = "dryad"
	desc = "A human-like figure formed of the flesh and bark of a tree, easier taller than a man. Guardians \
	of fae groves, and well-reputed for their vicioussness in the prosectuion of their duty."
	icon_state = "dryad"
	icon_living = "dryad"
	icon_dead = "vvd"
	summon_primer = "You are a dryad, a large sized fae. You spend time tending to forests, guarding sacred ground from trespassers. Now you've been pulled from your home into a new world, that is decidedly less wild and natural. How you react to these events, only time can tell."
	summon_tier = 3
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	see_in_dark = 6
	move_base_delay = MOVEMENT_DELAY_CRAWLING
	base_intents = list(/datum/intent/simple/elementalt2_unarmed)
	butcher_results = list()
	death_loot = list(/obj/item/magic/fae/heartwoodcore = 1)
	faction = list(FACTION_FAE)
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 650
	maxHealth = 650
	threat_point = THREAT_DEADLY
	melee_damage_lower = 20
	melee_damage_upper = 30
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	simple_detect_bonus = 20
	food_type = list()
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	STACON = 18
	STASTR = 14
	STASPD = 4
	simple_detect_bonus = 20
	deaggroprob = 0
	canparry = TRUE
	food = 0
	attack_sound = "plantcross"
	dodgetime = 30
	aggressive = 1
	ranged = FALSE

	ai_controller = /datum/ai_controller/fae

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/Initialize(mapload)
	src.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	. = ..()
	ADD_TRAIT(src, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	var/datum/action/cooldown/spell/projectile/log_throw/hurl = new(src)
	hurl.Grant(src)

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/death(gibbed)
	..()
	update_icon()
	spill_embedded_objects()
	qdel(src)
