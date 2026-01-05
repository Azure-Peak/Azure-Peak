//I'm not calling this undead_volf I want code to be searchable kthx

/mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead
//I'm not inhereting base wolf either because it uses cursed elements and AI.
	icon = 'icons/mob/wolf_undead.dmi'
	name = "deadite volf"
	desc = "A volf that was claimed for undeath, defiantly snarling with a hunger for fresh meat."
	icon_state = "wolf"
	icon_living = "wolf"
	icon_dead = "wolf_dead"
	var/icon_downed = "wolf_downed"
	gender = NEUTER
	emote_hear = null
	emote_see = null
	speak_chance = 1
	turns_per_move = 3
	see_in_dark = 6
	move_to_delay = 3
	base_intents = list(/datum/intent/simple/bite/volf)
	botched_butcher_results = list(/obj/item/alch/viscera = 1, /obj/item/alch/sinew = 1, /obj/item/natural/bone = 2)
	butcher_results = list(/obj/item/natural/hide = 1,
						/obj/item/alch/sinew = 1,
						/obj/item/alch/bone = 1,
						/obj/item/alch/viscera = 1,
						/obj/item/natural/bone = 3)
	perfect_butcher_results = list(/obj/item/natural/hide = 1,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1,
						/obj/item/alch/viscera = 1,
						/obj/item/natural/fur/wolf = 1,
						/obj/item/natural/bone = 4)

	faction = list("zombie")
	mob_biotypes = MOB_UNDEAD
	melee_damage_lower = 24
	melee_damage_upper = 34
	health = WOLF_HEALTH_UNDEAD
	maxHealth = WOLF_HEALTH_UNDEAD
	dodgetime = 40
	vision_range = 7
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_NONE
	retreat_distance = 0
	minimum_distance = 0
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	STACON = 7
	STASTR = 7
	STASPD = 12
	simple_detect_bonus = 20
	deaggroprob = 0
	defprob = 40
	del_on_deaggro = 44 SECONDS
	aggressive = 1
	remains_type = /obj/effect/decal/remains/wolf

	var/leg_health = 100
	var/max_leg_health = 100
	var/head_health = 75
	var/max_head_health = 75
	var/reinimation_timer = 15 MINUTES
	var/is_downed = FALSE
	var/legs_broken = FALSE

	var/chomp_cd = 0
	var/chomp_roll = 0

	retreat_health = 0
	attack_sound = list('sound/vo/mobs/vw/attack (1).ogg','sound/vo/mobs/vw/attack (2).ogg','sound/vo/mobs/vw/attack (3).ogg','sound/vo/mobs/vw/attack (4).ogg')

	AIStatus = AI_OFF
	can_have_ai = FALSE
	ai_controller = /datum/ai_controller/undead/wolf

/mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead/AttackingTarget() //7+1d6 vs con to knock ppl down
	. = ..()

	if(. && prob(8) && iscarbon(target))
		var/mob/living/carbon/C = target
		if(world.time >= chomp_cd + 120 SECONDS) //they can do it Once basically
			chomp_roll = STASTR + (rand(1,6))
			if(chomp_roll > C.STACON)
				C.Knockdown(20)
				C.visible_message(
					span_danger("\The [src] chomps \the [C]'s legs, knocking them down!"),
					span_danger("\The [src] tugs me to the ground! I'm winded!")
				)
				C.adjustOxyLoss(10) //less punishing than zfall bc simplemob
				C.emote("gasp")
				playsound(C, 'sound/foley/zfall.ogg', 100, FALSE)
			else
				C.visible_message(span_danger("\The [src] fails to drag \the [C] down!"))
		chomp_cd = world.time //this goes here i think? ...sure

/mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead/Initialize()
	. = ..()
	REMOVE_TRAIT(src, TRAIT_SIMPLE_WOUNDS, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_RIGIDMOVEMENT, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_SILVER_WEAK, TRAIT_GENERIC)
	AddComponent(/datum/component/infection_spreader)

/mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead/death()
	if(is_downed)
		visible_message(span_danger("[src] has their head smashed to pulp!"))
		. = ..()
		update_icon()
		ai_controller.set_ai_status(AI_STATUS_OFF)
	else
		visible_message(span_notice("[src] falls down, body brutally battered, yet its head continues that unending stare."))
		is_downed = TRUE
		ai_controller.movement_delay = 100
		icon_state = icon_downed
		icon_living = icon_downed
		adjustBruteLoss(-250)
		stat = CONSCIOUS
		update_icon()
		// If you don't kill it, it will become a threat again.
		addtimer(CALLBACK(src, .proc/reanimation), reinimation_timer)
		return

/mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead/proc/reanimation()
	if(!QDELETED(src) && stat != DEAD)
		visible_message(span_danger("The [src] stands back up."))
		health = maxHealth
		leg_health = max_leg_health
		head_health = max_head_health
		legs_broken = FALSE
		icon_state = "wolf"
		icon_living = "wolf"
		ai_controller.movement_delay = initial(ai_controller.movement_delay)
		is_downed = FALSE
		stat = CONSCIOUS
		update_icon()

/mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead/apply_damage(damage, damagetype, def_zone, blocked, forced)
	. = ..()
	if(is_downed)
		if(def_zone == "head" || \
		   def_zone == "nose" || \
		   def_zone == "mouth" || \
		   def_zone == "neck")

			head_health -= damage
			if(head_health <= 0 && stat != DEAD)
				head_health = 0
				death()

	if(def_zone == "foreleg" || def_zone == "leg")
		leg_health -= damage
		if(leg_health <= 0 && !legs_broken)
			leg_health = 0
			legs_broken = TRUE
			ai_controller.movement_delay += 10
			visible_message(span_notice("[src] slows down, its broken legs dragging."))

/mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/vw/aggro (1).ogg','sound/vo/mobs/vw/aggro (2).ogg')
		if("pain")
			return pick('sound/vo/mobs/vw/pain (1).ogg','sound/vo/mobs/vw/pain (2).ogg','sound/vo/mobs/vw/pain (3).ogg')
		if("death")
			return pick('sound/vo/mobs/vw/death (1).ogg','sound/vo/mobs/vw/death (2).ogg','sound/vo/mobs/vw/death (3).ogg','sound/vo/mobs/vw/death (4).ogg','sound/vo/mobs/vw/death (5).ogg')
		if("idle")
			return pick('sound/vo/mobs/vw/idle (1).ogg','sound/vo/mobs/vw/idle (2).ogg','sound/vo/mobs/vw/idle (3).ogg','sound/vo/mobs/vw/idle (4).ogg')
		if("cidle")
			return pick('sound/vo/mobs/vw/bark (1).ogg','sound/vo/mobs/vw/bark (2).ogg','sound/vo/mobs/vw/bark (3).ogg','sound/vo/mobs/vw/bark (4).ogg','sound/vo/mobs/vw/bark (5).ogg','sound/vo/mobs/vw/bark (6).ogg','sound/vo/mobs/vw/bark (7).ogg')

/mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_NOSE)
			return "nose"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "mouth"
		if(BODY_ZONE_PRECISE_SKULL)
			return "head"
		if(BODY_ZONE_PRECISE_EARS)
			return "head"
		if(BODY_ZONE_PRECISE_NECK)
			return "neck"
		if(BODY_ZONE_PRECISE_L_HAND)
			return "foreleg"
		if(BODY_ZONE_PRECISE_R_HAND)
			return "foreleg"
		if(BODY_ZONE_PRECISE_L_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "stomach"
		if(BODY_ZONE_PRECISE_GROIN)
			return "tail"
		if(BODY_ZONE_HEAD)
			return "head"
		if(BODY_ZONE_R_LEG)
			return "leg"
		if(BODY_ZONE_L_LEG)
			return "leg"
		if(BODY_ZONE_R_ARM)
			return "foreleg"
		if(BODY_ZONE_L_ARM)
			return "foreleg"
	return ..()
