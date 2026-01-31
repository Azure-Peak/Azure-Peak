/mob/living/simple_animal/hostile/retaliate/rogue/revenant/wolf
	name = "volf revenant"
	desc = "A snarling beast of mangy fur and yellowed teeth. This one's hunger has outlasted its life, returning as a shimmering predator in the fog."
	icon = 'icons/roguetown/mob/monster/vol.dmi'
	icon_state = "revenant"
	icon_living = "revenant"
	icon_dead = "revenant"
	mob_biotypes = MOB_UNDEAD | MOB_BEAST

	turns_per_move = 3
	move_to_delay = 3
	see_in_dark = 6
	vision_range = 7
	aggro_vision_range = 9
	retreat_distance = 0
	minimum_distance = 0
	retreat_health = 0.3

	health = WOLF_HEALTH
	maxHealth = WOLF_HEALTH
	melee_damage_lower = 19
	melee_damage_upper = 29

	STACON = 7
	STASTR = 7
	STASPD = 12
	simple_detect_bonus = 20
	defprob = 40
	dodgetime = 30

	faction = list("revenants", "wolfs")
	ai_controller = /datum/ai_controller/volf
	base_intents = list(/datum/intent/simple/bite/volf)
	melee_cooldown = WOLF_ATTACK_SPEED
	attack_sound = list('sound/vo/mobs/vw/attack (1).ogg','sound/vo/mobs/vw/attack (2).ogg','sound/vo/mobs/vw/attack (3).ogg','sound/vo/mobs/vw/attack (4).ogg')

	// Chomp Logic Vars
	var/chomp_cd = 0
	var/chomp_roll = 0

/mob/living/simple_animal/hostile/retaliate/rogue/revenant/wolf/AttackingTarget()
	. = ..()
	// Exact copy of the knockdown logic
	if(. && prob(8) && iscarbon(target))
		var/mob/living/carbon/C = target
		if(world.time >= chomp_cd + 120 SECONDS)
			chomp_roll = STASTR + (rand(0,6))
			if(chomp_roll > C.STACON)
				C.Knockdown(20)
				C.visible_message(
					span_danger("\The [src] chomps \the [C]'s legs, knocking them down!"),
					span_danger("\The [src] tugs me to the ground! I'm winded!")
				)
				C.adjustOxyLoss(10)
				C.emote("gasp")
				playsound(C, 'sound/foley/zfall.ogg', 100, FALSE)
			else
				C.visible_message(span_danger("\The [src] fails to drag \the [C] down!"))
			chomp_cd = world.time

/mob/living/simple_animal/hostile/retaliate/rogue/revenant/wolf/get_sound(input)
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

/mob/living/simple_animal/hostile/retaliate/rogue/revenant/wolf/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_SKULL, BODY_ZONE_PRECISE_EARS, BODY_ZONE_HEAD)
			return "head"
		if(BODY_ZONE_PRECISE_NOSE)
			return "nose"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "mouth"
		if(BODY_ZONE_PRECISE_NECK)
			return "neck"
		if(BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_R_ARM, BODY_ZONE_L_ARM)
			return "foreleg"
		if(BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_PRECISE_R_FOOT, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG)
			return "leg"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "stomach"
		if(BODY_ZONE_PRECISE_GROIN)
			return "tail"
	return ..()
