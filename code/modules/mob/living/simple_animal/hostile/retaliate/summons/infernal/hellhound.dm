
/mob/living/simple_animal/hostile/retaliate/rogue/infernal/hellhound
	anatomy_type = /datum/anatomy/quadruped/standard/hellhound
	threat_point = THREAT_MODERATE
	icon = 'icons/mob/summonable/32x32.dmi'
	name = "hell hound"
	desc = "This is a canine-shaped creature formed of billowing heat and snaking flames! Its maw resembles a furnace; \
	better not fall into it."
	icon_state = "hellhound"
	icon_living = "hellhound"
	icon_dead = "vvd"
	summon_primer = "You are a hellhound, a moderate sized canine made of heat and flame. You spend time in the infernal plane hunting and incinerating things to your hearts content. Now you've been pulled from your home into a new world, that is decidedly lacking in fire. How you react to these events, only time can tell."
	summon_tier = 2
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	turns_per_move = 6
	see_in_dark = 6
	move_to_delay = 3
	base_intents = list(/datum/intent/simple/bite)
	butcher_results = list()
	death_loot = list(/obj/item/magic/infernal/fang = 2)
	faction = list(FACTION_INFERNAL)
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 270
	maxHealth = 270
	melee_damage_lower = 22
	melee_damage_upper = 32
	vision_range = 7
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	simple_detect_bonus = 20
	retreat_distance = 0
	minimum_distance = 0
	food_type = list()
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	STACON = 7
	STASTR = 9
	STASPD = 13
	simple_detect_bonus = 20
	deaggroprob = 0
	candodge = TRUE
	// del_on_deaggro = 44 SECONDS
	retreat_health = 0
	food = 0
	attack_sound = list('sound/vo/mobs/vw/attack (1).ogg','sound/vo/mobs/vw/attack (2).ogg','sound/vo/mobs/vw/attack (3).ogg','sound/vo/mobs/vw/attack (4).ogg')
	dodgetime = 30
	aggressive = 1

	ai_controller = /datum/ai_controller/infernal/hound
	move_base_delay = MOVEMENT_DELAY_SPD_17

	var/scorch_cooldown = 10 SECONDS
	var/next_scorch = 0

/mob/living/simple_animal/hostile/retaliate/rogue/infernal/hellhound/death(gibbed)
	..()
	update_icon()
	spill_embedded_objects()
	qdel(src)

/mob/living/simple_animal/hostile/retaliate/rogue/infernal/hellhound/AttackingTarget()
	. = ..()
	if(!. || !isliving(target) || world.time < next_scorch)
		return
	if(BODY_ZONE_HEAD in broken_parts)
		return
	next_scorch = world.time + scorch_cooldown
	var/mob/living/seared = target
	apply_scorch_stack(seared, 1)
	seared.visible_message(span_danger("[src] sears [seared] with hellfire!"))
