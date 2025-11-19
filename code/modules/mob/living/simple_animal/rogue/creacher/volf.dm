

/mob/living/simple_animal/hostile/retaliate/rogue/wolf
	icon = 'icons/roguetown/mob/monster/vol.dmi'
	name = "volf"
	desc = "A snarling beast of mangy fur and yellowed teeth. Volves are known to attack hapless travelers in the deep forests when prey is scarce."
	icon_state = "vv"
	icon_living = "vv"
	icon_dead = "vvd"
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	turns_per_move = 3
	see_in_dark = 6
	move_to_delay = 3
	base_intents = list(/datum/intent/simple/bite/volf)
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf = 1, /obj/item/alch/viscera = 1, /obj/item/alch/sinew = 1, /obj/item/natural/bone = 2)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf = 2,
						/obj/item/natural/hide = 2,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1,
						/obj/item/alch/viscera = 1,
						/obj/item/natural/fur/wolf = 1,
						/obj/item/natural/bone = 3,
						/obj/item/natural/head/volf = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf = 2,
						/obj/item/natural/hide = 2,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1,
						/obj/item/alch/viscera = 1,
						/obj/item/natural/fur/wolf = 2,
						/obj/item/natural/bone = 4,
						/obj/item/natural/head/volf = 1)
	faction = list("wolfs", "zombie")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = WOLF_HEALTH
	maxHealth = WOLF_HEALTH
	melee_damage_lower = 19
	melee_damage_upper = 29
	vision_range = 7
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_NONE
	retreat_distance = 0
	minimum_distance = 0
	milkies = FALSE
	food_type = list(/obj/item/reagent_containers/food/snacks,
					//obj/item/bodypart,
					//obj/item/organ,
					/obj/item/natural/bone,
					/obj/item/natural/hide)
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	STACON = 7
	STASTR = 7
	STASPD = 12
	simple_detect_bonus = 20
	deaggroprob = 0
	defprob = 40
	del_on_deaggro = 44 SECONDS
	retreat_health = 0.3
	food = 0
	attack_sound = list('sound/vo/mobs/vw/attack (1).ogg','sound/vo/mobs/vw/attack (2).ogg','sound/vo/mobs/vw/attack (3).ogg','sound/vo/mobs/vw/attack (4).ogg')
	dodgetime = 30
	aggressive = 1
//	stat_attack = UNCONSCIOUS
	remains_type = /obj/effect/decal/remains/wolf
	eat_forever = TRUE
	var/chomp_cd = 0
	var/chomp_roll = 0

//new ai, old ai off
	AIStatus = AI_OFF
	can_have_ai = FALSE
	ai_controller = /datum/ai_controller/volf
	melee_cooldown = WOLF_ATTACK_SPEED

/mob/living/simple_animal/hostile/retaliate/rogue/wolf/AttackingTarget() //7+1d6 vs con to knock ppl down
	. = ..()

	if(. && prob(8) && iscarbon(target))
		var/mob/living/carbon/C = target
		if(world.time >= chomp_cd + 120 SECONDS) //they can do it Once basically
			chomp_roll = STASTR + (rand(0,6))
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


/obj/effect/decal/remains/wolf
	name = "remains"
	desc = "Whether by starvation, disease, inter-pack conflict, or an unlucky kick from a saiga, this volf has died."
	gender = PLURAL
	icon_state = "bones"
	icon = 'icons/roguetown/mob/monster/vol.dmi'

/mob/living/simple_animal/hostile/retaliate/rogue/wolf/Initialize()
	. = ..()
	AddElement(/datum/element/ai_retaliate)
	AddElement(/datum/element/ai_flee_while_injured, 0.75, 0.4)
	gender = MALE
	if(prob(33))
		gender = FEMALE
	update_icon()
	ai_controller.set_blackboard_key(BB_BASIC_FOODS, food_type)


/mob/living/simple_animal/hostile/retaliate/rogue/wolf/death(gibbed)
	..()
	update_icon()
	if(!QDELETED(src))
		AddComponent(/datum/component/deadite_animal_reanimation)

/* Eyes that glow in the dark. They float over kybraxor pits at the moment.
/mob/living/simple_animal/hostile/retaliate/rogue/wolf/update_icon()
	cut_overlays()
	..()
	if(stat != DEAD)
		var/mutable_appearance/eye_lights = mutable_appearance(icon, "vve")
		eye_lights.plane = 19
		eye_lights.layer = 19
		add_overlay(eye_lights)*/

/mob/living/simple_animal/hostile/retaliate/rogue/wolf/get_sound(input)
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

/mob/living/simple_animal/hostile/retaliate/rogue/wolf/taunted(mob/user)
	emote("aggro")
	Retaliate()
	GiveTarget(user)
	return

/mob/living/simple_animal/hostile/retaliate/rogue/wolf/Life()
	..()
	if(pulledby)
		Retaliate()
		GiveTarget(pulledby)

/mob/living/simple_animal/hostile/retaliate/rogue/wolf/simple_limb_hit(zone)
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

/datum/intent/simple/bite/volf
	clickcd = WOLF_ATTACK_SPEED
