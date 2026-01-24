/obj/structure/flora/roguegrass/maneater
	name = "grass"
	desc = "Green and vivid. Was that a tendril?"
	icon = 'icons/roguetown/mob/monster/maneater.dmi'
	icon_state = "maneater-hidden"
	max_integrity = 5

/obj/structure/flora/roguegrass/maneater/update_icon()
	return

/obj/structure/flora/roguegrass/maneater/real
	var/aggroed = 0
	max_integrity = 100
	integrity_failure = 0.15
	attacked_sound = list('sound/vo/mobs/plant/pain (1).ogg','sound/vo/mobs/plant/pain (2).ogg','sound/vo/mobs/plant/pain (3).ogg','sound/vo/mobs/plant/pain (4).ogg')
	var/list/eatablez = list(/obj/item/bodypart, /obj/item/organ, /obj/item/reagent_containers/food/snacks/rogue/meat)
	var/last_eat
	buckle_lying = FALSE
	buckle_prevents_pull = TRUE
	var/seednutrition = 0
	var/max_seednutrition = 100
	var/mob/planter = null

/obj/structure/flora/roguegrass/maneater/real/process()
	if(seednutrition >= max_seednutrition)
		produce_seed()
		seednutrition = 0
	if(world.time > aggroed + 30 SECONDS && !has_buckled_mobs())
		aggroed = 0
		update_icon()
		STOP_PROCESSING(SSobj, src)
		return TRUE

/obj/structure/flora/roguegrass/maneater/real/obj_break(damage_flag)
	..()
	unbuckle_all_mobs()
	if(contents.len)
		for(var/obj/item/eaten in contents)
			var/turf/target = get_ranged_target_turf(src, pick(GLOB.alldirs), 1)
			playsound(src,'sound/misc/maneaterspit.ogg', 100)
			eaten.forceMove(target)
			contents.Remove(eaten)
	STOP_PROCESSING(SSobj, src)

/obj/structure/flora/roguegrass/maneater/real/Destroy()
	unbuckle_all_mobs()
	if(contents.len)
		for(var/obj/item/eaten in contents)
			var/turf/target = get_ranged_target_turf(src, pick(GLOB.alldirs), 1)
			playsound(src,'sound/misc/maneaterspit.ogg', 100)
			eaten.forceMove(target)
			contents.Remove(eaten)
	STOP_PROCESSING(SSobj, src)
	..()

/obj/structure/flora/roguegrass/maneater/real/Crossed(atom/movable/AM)
	..()
	if(obj_broken)
		return
	if(world.time <= last_eat + 8 SECONDS)
		return
	if(has_buckled_mobs())
		return

	if(!aggroed)
		START_PROCESSING(SSobj, src)
	aggroed = world.time
	update_icon()

	if(!isliving(AM))
		if(is_type_in_list(AM, eatablez))
			last_eat = world.time
			playsound(src,'sound/misc/eat.ogg', rand(30,60), TRUE)
			AM.forceMove(src)
			seednutrition += 10
		return

	var/mob/living/victim = AM
	if(victim == planter)
		return
	if(!victim.ambushable())
		return
	if(victim.m_intent == MOVE_INTENT_SNEAK)
		return

	buckle_mob(victim, TRUE, check_loc = FALSE)
	playsound(loc, list('sound/vo/mobs/plant/attack (1).ogg','sound/vo/mobs/plant/attack (2).ogg','sound/vo/mobs/plant/attack (3).ogg','sound/vo/mobs/plant/attack (4).ogg'), 100, FALSE, -1)
	visible_message(span_userdanger("[src] begins to gnaw on [victim]! RESIST as many times as you can or become a chew toy!"))
	addtimer(CALLBACK(src, PROC_REF(begin_eat), victim), 3 SECONDS, TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_STOPPABLE)

/obj/structure/flora/roguegrass/maneater/real/proc/begin_eat(mob/living/victim, var/chew_factor = 1)
	if(victim.loc != loc)
		return
	if(!(has_buckled_mobs() && victim.buckled))
		return

	visible_message(span_userdanger("[src] gnaws on [victim]!"))

	playsound(src,'sound/misc/eat.ogg', rand(30,60), TRUE)
	if(!iscarbon(victim))
		victim.adjustBruteLoss(20)
	else
		var/zone = pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
		var/obj/item/bodypart/limb = victim.get_bodypart(zone)
		if(!limb)
			begin_eat(victim)
		victim.flash_fullscreen("redflash3")
		playsound(loc, list('sound/vo/mobs/plant/attack (1).ogg','sound/vo/mobs/plant/attack (2).ogg','sound/vo/mobs/plant/attack (3).ogg','sound/vo/mobs/plant/attack (4).ogg'), 100, FALSE, -1)
		if(limb.get_damage() > 50)
			if(limb.dismember(damage = 20))
				seednutrition += 25
				if(!victim.mind)
					victim.gib()
					seednutrition += 25
					return
				maneater_spit_out(victim)
		else
			victim.apply_damage(60, BRUTE, zone, victim.run_armor_check(zone, BCLASS_CUT, damage = 500))

	if(victim.stat == DEAD || victim.stat == UNCONSCIOUS)
		if(!victim.mind)
			victim.gib()
			seednutrition += 50
			return
		maneater_spit_out(victim)

	last_eat = world.time
	addtimer(CALLBACK(src, PROC_REF(begin_eat), victim, chew_factor * 2), 3 SECONDS, TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_STOPPABLE)

/obj/structure/flora/roguegrass/maneater/real/proc/maneater_spit_out(mob/living/C)
	if(!C)
		return
	if(!isliving(C))
		return
	visible_message(span_danger("[src] spits out [C]!"))
	unbuckle_mob(C)
	playsound(src,'sound/misc/maneaterspit.ogg', 100)
	return TRUE

/obj/structure/flora/roguegrass/maneater/real/update_icon()
	if(obj_broken)
		name = "MANEATER"
		desc = "This cunning creature is thankfully defeated."
		icon_state = "maneater-dead"
		return
	if(aggroed)
		name = "MANEATER"
		icon_state = "maneater"
	else
		name = "grass"
		icon_state = "maneater-hidden"

/obj/structure/flora/roguegrass/maneater/real/user_unbuckle_mob(mob/living/M, mob/user, var/break_factor = 1)
	if(obj_broken)
		..()
		return
	if(!isliving(user))
		return

	var/mob/living/L = user
	var/time2mount = CLAMP((L.STASTR * 2 * break_factor), 1, 99)
	if(istype(src, /obj/structure/flora/roguegrass/maneater/real/juvenile))
		time2mount *= 2
	user.changeNext_move(CLICK_CD_FAST, override = TRUE)
	if(user != M)
		user.visible_message(span_warning("[user] tries to pull [M] free of [src]!"))
	else
		user.visible_message(span_warning("[user] tries to break free of [src]!"))

	if(!prob(time2mount))
		if(do_after(M, 0.75 SECONDS, target = src))
			user_unbuckle_mob(M, user, break_factor * 1.5)
	..()
/obj/structure/flora/roguegrass/maneater/real/user_buckle_mob(mob/living/M, mob/living/user) //Don't want them getting put on the rack other than by spiking
	return

/obj/structure/flora/roguegrass/maneater/real/attackby(obj/item/W, mob/user, params)
	..()
	var/oldagg = aggroed
	aggroed = world.time
	update_icon()

	if(!W)
		return TRUE

	// If item is one of the edible types, handle feeding behaviour
	if(is_type_in_list(W, eatablez))
		// Do not consume bodyparts — spit them out instead
		if(istype(W, /obj/item/bodypart))
			visible_message(span_danger("[src] spits out [W]!"))
			playsound(src,'sound/misc/maneaterspit.ogg', 100)
			var/turf/target = get_ranged_target_turf(src, pick(GLOB.alldirs), 1)
			W.throw_at(target,3,2)
			return TRUE

		// Otherwise, 'eat' the item like when it crosses the plant
		last_eat = world.time
		playsound(src,'sound/misc/eat.ogg', rand(30,60), TRUE)
		if(W.loc)
			W.forceMove(src)
		seednutrition += 20

		if(!oldagg)
			START_PROCESSING(SSobj, src)

		return TRUE

	return TRUE


//JUVENILE MANEATER

/obj/structure/flora/roguegrass/maneater/real/juvenile
	name = "juvenile maneater"
	desc = "Green and vivid. This one seems smaller than usual."
	icon = 'icons/roguetown/mob/monster/maneater.dmi'
	icon_state = "maneater-hidden"
	max_integrity = 50
	seednutrition = 0
	max_seednutrition = 50
	var/growth_stage = 1
	var/max_growth_stage = 3
	var/growth_time = 20 MINUTES


/obj/structure/flora/roguegrass/maneater/real/juvenile/Initialize()
	..()
	transform = transform.Scale(0.5, 0.5)  // Start at half size
	addtimer(CALLBACK(src, .proc/try_grow), growth_time)

/obj/structure/flora/roguegrass/maneater/real/juvenile/Crossed(atom/movable/AM)
	..()
	if(world.time <= last_eat + 5 SECONDS)
		return
	if(has_buckled_mobs())
		return
	if(isliving(AM))
		return

	if(is_type_in_list(AM, eatablez))
		last_eat = world.time
		playsound(src,'sound/misc/eat.ogg', rand(30,60), TRUE)
		AM.forceMove(src)
		seednutrition += 10

	return

/obj/structure/flora/roguegrass/maneater/real/juvenile/proc/try_grow()
	if(growth_stage < max_growth_stage)
		growth_stage++
		// We end up at 1.0 size by final stage
		transform = transform.Scale(1.26, 1.26)
		visible_message(span_warning("[src] grows bigger!"))
		playsound(loc, list('sound/vo/mobs/plant/attack (1).ogg','sound/vo/mobs/plant/attack (2).ogg','sound/vo/mobs/plant/attack (3).ogg','sound/vo/mobs/plant/attack (4).ogg'), 100, FALSE, -1)
		addtimer(CALLBACK(src, .proc/try_grow), growth_time)
		return

	// Replace with adult form
	visible_message(span_danger("[src] reaches full maturity!"))
	var/turf/T = get_turf(src)
	var/obj/structure/flora/roguegrass/maneater/real/myboy = new(T)
	myboy.planter = planter
	qdel(src)

/obj/structure/flora/roguegrass/maneater/real/juvenile/update_icon()
	..()
	name = "juvenile " + name


//MANEATER SEEDS

/obj/item/maneaterseed
	name = "maneater seed"
	desc = "A seed from a maneater. It looks like it could grow into something dangerous if planted in green grass or dirt."
	icon = 'icons/roguetown/mob/monster/maneater.dmi'
	icon_state = "maneater-seed"
	max_integrity = 5
	sellprice = 30

/obj/item/maneaterseed/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	var/turf/T = get_turf(target)
	if(istype(T, /turf/open/floor/rogue/dirt) || istype(T, /turf/open/floor/rogue/grass))
		if(!proximity_flag)
			return
		for(var/obj/structure/flora/roguegrass/maneater/M in T)
			to_chat(user, span_warning("The maneater plants need more space between them to grow."))
			return
		for(var/turf/adjacent in orange(2, T))
			for(var/obj/structure/flora/roguegrass/maneater/M in adjacent)
				to_chat(user, span_warning("The maneater plants need more space between them to grow."))
				return
		for(var/obj/effect/decal/D in T) //To stop planting on mapped cobble decals etc
			to_chat(user, span_warning("The ground is too uneven to plant a maneater seed here."))
			return
		user.visible_message(span_notice("[user] begins planting a maneater seed."), \
				span_notice("I begin planting the maneater seed."))
		if(do_after(user, 10 SECONDS))
			var/obj/structure/flora/roguegrass/maneater/real/juvenile/myboy = new(T)
			myboy.planter = user
			user.visible_message(span_notice("[user] plants a maneater seed."), \
				span_notice("I plant the maneater seed."))
			qdel(src)
			message_admins("[user]/([user.ckey]) plants a maneater seed at [ADMIN_VERBOSEJMP(T)]")
			return
	..()

/obj/structure/flora/roguegrass/maneater/real/proc/produce_seed()
	visible_message(span_warning("[src] spits out a seed!"))
	var/turf/target = get_ranged_target_turf(src, pick(GLOB.alldirs), rand(1,3))
	var/obj/item/maneaterseed/S = new(get_turf(src))
	S.throw_at(target,3,2)
	playsound(src,'sound/misc/maneaterspit.ogg', 100)
