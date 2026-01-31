/mob/living/simple_animal/hostile/retaliate/rogue/revenant/dragon
	name = "drakkyn revenant"
	desc = "Even the drakkyn arise to enact revenge upon the living. Run."
	icon = 'modular/icons/mob/96x96/revenant_dragon.dmi'
	icon_state = "dragon"
	icon_living = "dragon"
	icon_dead = "dragon_dead"

	pixel_x = -32

	health = DRAGON_HEALTH
	maxHealth = DRAGON_HEALTH
	melee_damage_lower = 50
	melee_damage_upper = 70
	move_to_delay = 3
	turns_per_move = 3
	vision_range = 7
	aggro_vision_range = 9

	footstep_type = FOOTSTEP_MOB_HEAVY
	attack_sound = list('sound/combat/hits/blunt/genblunt (1).ogg','sound/combat/hits/blunt/genblunt (2).ogg','sound/combat/hits/blunt/genblunt (3).ogg','sound/combat/hits/blunt/flailhit.ogg')
	damage_coeff = list(BRUTE = 1, BURN = 0.2, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0)

	mob_biotypes = MOB_UNDEAD | MOB_BEAST
	base_intents = list(/datum/intent/simple/bite/dragon_bite)
	AIStatus = AI_OFF
	can_have_ai = FALSE
	ai_controller = /datum/ai_controller/dragon
	limb_destroyer = TRUE

	STACON = 20
	STASTR = 20
	STASPD = 13
	deaggroprob = 0
	defprob = 40
	del_on_deaggro = 9999 SECONDS
	retreat_health = 0.05
	dodgetime = 30

/mob/living/simple_animal/hostile/retaliate/rogue/revenant/dragon/Initialize()
	. = ..()

	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_INFINITE_STAMINA, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOFIRE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NIGHT_VISION, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BASHDOORS, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_STRONGBITE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	AddElement(/datum/element/ai_retaliate)

	var/datum/action/cooldown/mob_cooldown/dragon_leap/leap = new(src)
	leap.Grant(src)

	if(ai_controller)
		ai_controller.set_blackboard_key(BB_TARGETED_ACTION, leap)

/mob/living/simple_animal/hostile/retaliate/rogue/revenant/dragon/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/vw/aggro (1).ogg','sound/vo/mobs/vw/aggro (2).ogg')
		if("pain")
			return pick('sound/vo/mobs/wwolf/painscream.ogg','sound/vo/mobs/wwolf/pain (1).ogg','sound/vo/mobs/wwolf/pain (3).ogg','sound/vo/mobs/wwolf/pain (2).ogg')
		if("idle")
			return pick('sound/vo/mobs/wwolf/idle (1).ogg')
	return ..()
