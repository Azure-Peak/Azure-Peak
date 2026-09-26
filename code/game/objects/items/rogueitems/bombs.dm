#define MT_BOMB_HIT "bomb_hit"
#define BOMB_HIT_IMMUNITY_DURATION 1 SECONDS

/obj/item/bomb
	name = "bottle bomb"
	desc = "A fiery explosion waiting to be coaxed from its glass prison."
	icon_state = "bbomb"
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	slot_flags = ITEM_SLOT_HIP
	throw_speed = 0.5
	flags_ai_inventory = AI_ITEM_THROWING
	var/fuze = null
	var/lit = FALSE
	var/exploding = FALSE
	var/prob2fail = 5
	var/PVE_damage = 75
	var/spawn_shard = TRUE
	var/tripcrit = 0
	grid_width = 32
	grid_height = 64
	var/mob/thrower

/obj/item/bomb/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-click with a torch, lamptern, flint, or another ignitioneer to light its fuse. Alternatively, the fuse can be lit by using it on a hearth, brazier, scone, or another source of ignition.")
	. += span_info("Once lit, most bombs will detonate after a very short period of time.")

/obj/item/bomb/Initialize(mapload)
	..()
	fuze = rand(40, 60)

/obj/item/bomb/spark_act()
	if(ismob(loc))
		var/mob/M = loc
		if(HAS_TRAIT(M, TRAIT_BOMBER_EXPERT) && !(src in M.held_items))
			return
	light()

/obj/item/bomb/fire_act()
	if(ismob(loc))
		var/mob/M = loc
		if(HAS_TRAIT(M, TRAIT_BOMBER_EXPERT) && !(src in M.held_items))
			return
	light()

/obj/item/bomb/ex_act()
	if(ismob(loc))
		var/mob/M = loc
		if(HAS_TRAIT(M, TRAIT_BOMBER_EXPERT) && !(src in M.held_items))
			return
	if(QDELETED(src) || exploding)
		return
	lit = TRUE
	explode(TRUE)

/obj/item/bomb/proc/light()
	if(QDELETED(src) || lit || exploding)
		return
	START_PROCESSING(SSfastprocess, src)
	icon_state += "-lit"
	lit = TRUE
	playsound(loc, 'sound/items/firelight.ogg', 100)
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_hands()

/obj/item/bomb/extinguish()
	snuff()

/obj/item/bomb/proc/snuff()
	if(QDELETED(src) || !lit || exploding)
		return
	lit = FALSE
	STOP_PROCESSING(SSfastprocess, src)
	playsound(loc, 'sound/items/firesnuff.ogg', 100)
	icon_state = "bbomb"
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_hands()

/obj/item/bomb/proc/explode(skipprob)
	if(QDELETED(src) || exploding)
		return FALSE
	exploding = TRUE
	STOP_PROCESSING(SSfastprocess, src)
	var/turf/T = get_turf(src)
	if(!T)
		return FALSE
	if(!skipprob && prob(prob2fail))
		exploding = FALSE
		snuff()
		return FALSE
	var/critbang = 0
	if(thrower)
		var/engineering = thrower.get_skill_level(/datum/skill/craft/engineering)
		var/mob/living/M = thrower
		critbang = (engineering * 10) + (M.STALUC * 2) + tripcrit
	qdel(src)
	playsound(T, 'sound/items/firesnuff.ogg', 100)
	for(var/mob/living/target in range(1, T))
		if(target == thrower && HAS_TRAIT(thrower, TRAIT_BOMBER_EXPERT))
			continue
		if(target.mob_timers[MT_BOMB_HIT] && world.time < target.mob_timers[MT_BOMB_HIT] + BOMB_HIT_IMMUNITY_DURATION)
			continue
		target.mob_timers[MT_BOMB_HIT] = world.time
		var/armor_block = target.run_armor_check(BODY_ZONE_CHEST, "fire", blade_dulling = BCLASS_BURN, damage = PVE_damage, no_debuff = TRUE)
		target.apply_damage(PVE_damage, BURN, BODY_ZONE_CHEST, armor_block)
		var/was_scorched = get_scorch_stacks(target)
		target.apply_status_effect(/datum/status_effect/debuff/staggered)
		var/leftovers = pick("smithereens", "thin gruel", "bits", "spare parts", "pieces", "kingdom come", "another timeline", "yesterday", "hell", "PSYDON's embrace", "Necra's embrace", "Zizo's embrace", "Astrata and back")
		if(was_scorched && !target.mind && prob(critbang))
			target.visible_message("<span class='crit'><b>Critical hit!</b> The explosive blasts them to [leftovers]!</span>",
				"<span class='crit'><b>Critical hit!</b> The explosive blasts them to [leftovers]!</span>")
			playsound(get_turf(target), 'sound/combat/tf2crit.ogg', 100, FALSE)
			target.gib(TRUE, TRUE, FALSE, TRUE)
			continue
		apply_scorch_stack(target, 3)
	if(spawn_shard)
		new /obj/item/natural/glass_shard(T)
	explosion(T, light_impact_range = 1, smoke = TRUE, adminlog = FALSE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg', 'sound/misc/explode/bottlebomb (2).ogg'))
	return TRUE

/obj/item/bomb/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	..()
	if(throwingdatum)
		thrower = throwingdatum.thrower
	sleep(1)
	if(QDELETED(src))
		return
	explode()

/obj/item/bomb/process()
	if(QDELETED(src) || !lit || exploding)
		return PROCESS_KILL
	fuze--
	if(fuze <= 0)
		explode(TRUE)
		return PROCESS_KILL

/obj/item/bomb/attackby(obj/item/I, mob/user, params)
	..()

	if(!istype(I, /obj/item/natural/fibers) && !istype(I, /obj/item/natural/bundle/fibers))
		return

	I.visible_message(
		span_warning("[user] begins to prepare [src].."),
		span_notice("I begin to set-up [src] with [I].")
	)

	if(istype(I, /obj/item/natural/bundle/fibers))
		var/obj/item/natural/bundle/fibers/bundle = I
		if(bundle.amount > 1)
			bundle.amount--
			bundle.update_icon()
		else
			qdel(bundle)
			new /obj/item/natural/fibers(user.loc)
	else
		qdel(I)

	var/set_time = HAS_TRAIT(user, TRAIT_BOMBER_EXPERT) ? 0.75 SECONDS : (7 SECONDS - user.get_skill_level(/datum/skill/craft/traps))
	if(!do_after(user, set_time, TRUE, src))
		to_chat(user, span_warning("I stop preparing [src]."))
		new /obj/item/natural/fibers(user.loc)
		if(prob(20) && !HAS_TRAIT(user, TRAIT_BOMBER_EXPERT))
			to_chat(user, span_warningbig("Uh oh."))
			light()
		return

	var/obj/item/bomb/tripbomb/trip = new /obj/item/bomb/tripbomb(get_turf(src))
	trip.b_type = type
	trip.icon_state = icon_state
	trip.add_overlay("tripbomb")
	trip.update_icon()
	trip.prob2fail = prob2fail
	trip.setter = user
	trip.tripcrit = tripcrit
	if(HAS_TRAIT(user, TRAIT_BOMBER_EXPERT))
		trip.alpha = 30
	var/obj/item/tripwire/wire = new /obj/item/tripwire(get_turf(user))
	wire.dir = user.dir
	wire.payload = trip
	if(HAS_TRAIT(user, TRAIT_BOMBER_EXPERT))
		wire.alpha = 30

	trip.wire_trigger.Add(wire)

	qdel(src)

	I.visible_message(
		span_warning("[user] finishes setting up [trip]."),
		span_notice("I finish setting up [trip]. I can extend it by one step longer.")
	)
	return

/obj/item/bomb/noshard
	spawn_shard = FALSE

/obj/item/bomb/tripbomb
	name = "trip bomb"
	desc = "A detonation waiting to be coaxed from its glass prison. This one lies in wait."
	icon_state = "bbomb"
	w_class = WEIGHT_CLASS_NORMAL
	anchored = TRUE
	slot_flags = ITEM_SLOT_HIP
	throw_speed = 0.5
	fuze = 1 SECONDS
	dropshrink = 0.5
	grid_width = 32
	grid_height = 64
	var/obj/item/bomb/b_type = /obj/item/bomb
	var/list/obj/item/tripwire/wire_trigger = list()
	var/mob/setter

/obj/item/bomb/tripbomb/Initialize(mapload)
	..()
	icon_state = b_type.icon_state

/obj/item/bomb/tripbomb/Destroy()
	if(wire_trigger.len)
		for(var/obj/item/tripwire/wire in wire_trigger)
			QDEL_NULL(wire)
	return ..()

/obj/item/bomb/tripbomb/light()
	if(QDELETED(src))
		return
	var/obj/item/bomb/bomb = new b_type(loc)
	bomb.fuze = HAS_TRAIT(setter, TRAIT_BOMBER_EXPERT) ? 0.25 SECONDS : 1 SECONDS
	bomb.prob2fail = prob2fail
	bomb.PVE_damage = PVE_damage + 100
	bomb.spawn_shard = spawn_shard
	bomb.tripcrit = tripcrit
	for(var/obj/item/tripwire/wire in wire_trigger)
		QDEL_NULL(wire)
	wire_trigger.Cut()
	qdel(src)
	bomb.light()

/obj/item/bomb/tripbomb/attackby(obj/item/I, mob/user, params)
	if(user.used_intent.blade_class == BCLASS_CUT && I.wlength == WLENGTH_SHORT)
		var/trap_skill = user.get_skill_level(/datum/skill/craft/traps)
		var/set_time = HAS_TRAIT(user, TRAIT_BOMBER_EXPERT) ? 0.75 SECONDS : (7 SECONDS - trap_skill)
		if(!do_after(user, set_time, TRUE, src))
			to_chat(user, span_warning("I stop slicing [src]."))
			if(!prob(trap_skill * 10))
				to_chat(user, span_warningbig("Oh no."))
				light()
			return
		for(var/obj/item/tripwire/t_wire in wire_trigger)
			QDEL_NULL(t_wire)
		var/obj/item/bomb/new_bomb = new b_type(loc)
		new_bomb.fuze = 1 SECONDS
		QDEL_NULL(src)
		return
	if(istype(I, /obj/item/natural/dirtclod))
		var/skill = user.get_skill_level(/datum/skill/craft/traps)
		alpha = (90 - skill * 10)
		qdel(I)
	..()

/obj/item/tripwire
	name = "fibre tripwire"
	desc = "You almost missed it - phew. Best cut it with a blade to disarm it."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "wire"
	anchored = TRUE
	var/obj/item/bomb/tripbomb/payload
	var/triggered = FALSE

/obj/item/tripwire/Destroy()
	var/turf/T = get_turf(src)
	if(T)
		new /obj/item/natural/fibers(T)
	return ..()

/obj/item/tripwire/attackby(obj/item/I, mob/user, params)
	if(user.used_intent.blade_class == BCLASS_CUT && I.wlength == WLENGTH_SHORT)
		if(triggered)
			return
		var/trap_skill = user.get_skill_level(/datum/skill/craft/traps)
		var/set_time = HAS_TRAIT(user, TRAIT_BOMBER_EXPERT) ? 0.75 SECONDS : (7 SECONDS - trap_skill)
		if(!do_after(user, set_time, TRUE, src))
			to_chat(user, span_warning("I stop slicing [src]."))
			if(!prob(trap_skill * 10))
				to_chat(user, span_warningbig("Oh no."))
				if(payload && !QDELETED(payload))
					payload.light()
			return
		if(payload && !QDELETED(payload))
			for(var/obj/item/tripwire/t_wire in payload.wire_trigger)
				QDEL_NULL(t_wire)
			new payload.b_type(payload.loc)
			QDEL_NULL(payload)
		return
	if(istype(I, /obj/item/natural/dirtclod))
		var/skill = user.get_skill_level(/datum/skill/craft/traps)
		alpha = (90 - skill * 10)
		qdel(I)
	..()

/obj/item/tripwire/Crossed(atom/movable/O)
	..()

	if(triggered)
		return
	if(!isliving(O))
		return
	var/mob/living/carbon/human/victim = O
	if(payload && victim == payload.setter && HAS_TRAIT(payload.setter, TRAIT_BOMBER_EXPERT))
		return
	if(victim.STALUC >= 10)
		if(prob((victim.STALUC - 10) * 10))
			to_chat(victim, span_warning("Your foot narrowly misses [src]. Be careful!"))
			return
	triggered = TRUE
	playsound(victim, 'sound/items/knife_open.ogg', 100, TRUE)
	victim.visible_message(
		span_warningbig("[victim] steps on [src]!"),
		span_warningbig("I feel the snapping of twine under my boot!")
	)
	var/obj/item/bomb/tripbomb/trip = payload
	if(QDELETED(trip))
		return
	victim.Slowdown(5)
	if(victim.STAINT <= 10 || victim.STAPER <= 10 || !victim.mind)
		victim.Immobilize(5)
		victim.emote(pick("huh","whimper","fwhine","gasp"))
	trip.tripcrit = 50
	trip.light()

/obj/item/bomb/smoke
	name = "smoke bomb"
	desc = "A soft sphere with an alchemical mixture and a dispersion mechanism hidden inside. Any pressure will detonate it."
	icon_state = "smokebomb"
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	slot_flags = ITEM_SLOT_HIP
	throw_speed = 0.5
	grid_width = 32
	grid_height = 64
	fuze = 0 SECONDS
	var/radius = 3

/obj/item/bomb/smoke/attack_self(mob/user)
	light()

/obj/item/bomb/smoke/ex_act()
	if(QDELETED(src))
		return
	light()

/obj/item/bomb/smoke/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	sleep(1)
	if(QDELETED(src))
		return
	light()

/obj/item/bomb/smoke/spark_act()
	if(ismob(loc))
		var/mob/M = loc
		if(HAS_TRAIT(M, TRAIT_BOMBER_EXPERT) && !(src in M.held_items))
			return
	return

/obj/item/bomb/smoke/fire_act()
	if(ismob(loc))
		var/mob/M = loc
		if(HAS_TRAIT(M, TRAIT_BOMBER_EXPERT) && !(src in M.held_items))
			return
	return

/obj/item/bomb/smoke/light()
	if(QDELETED(src))
		return
	explode()

/obj/item/bomb/smoke/explode()
	if(QDELETED(src))
		return FALSE
	var/turf/T = get_turf(src)
	if(!T)
		return FALSE
	playsound(loc, 'sound/items/smokebomb.ogg', 50)
	var/datum/effect_system/smoke_spread/smoke = new /datum/effect_system/smoke_spread
	smoke.set_up(radius, T)
	smoke.start()
	new /obj/item/ash(T)
	qdel(src)
	return TRUE

/obj/item/tntstick
	name = "blastpowder stick"
	desc = "A bewicked vessel, filled to the brim with explosive powder. Ignition begets eruption; a dizzying shockwave which pulverizes stone, wood, and flesh alike with little discrimination."
	icon_state = "tnt_stick"
	var/lit_state = "tnt_stick-lit"
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	slot_flags = ITEM_SLOT_HIP
	throw_speed = 0.5
	var/fuze = 50
	var/lit = FALSE
	var/prob2fail = 1
	var/PVE_damage = 160
	var/tripcrit = 0
	grid_width = 32
	grid_height = 64

/obj/item/tntstick/spark_act()
	if(ismob(loc))
		var/mob/M = loc
		if(HAS_TRAIT(M, TRAIT_BOMBER_EXPERT) && !(src in M.held_items))
			return
	light()

/obj/item/tntstick/fire_act()
	if(ismob(loc))
		var/mob/M = loc
		if(HAS_TRAIT(M, TRAIT_BOMBER_EXPERT) && !(src in M.held_items))
			return
	light()

/obj/item/tntstick/ex_act()
	if(ismob(loc))
		var/mob/M = loc
		if(HAS_TRAIT(M, TRAIT_BOMBER_EXPERT) && !(src in M.held_items))
			return
	if(QDELETED(src))
		return
	lit = TRUE
	explode(TRUE)

/obj/item/tntstick/proc/light()
	if(!lit)
		START_PROCESSING(SSfastprocess, src)
		icon_state = lit_state
		lit = TRUE
		playsound(src.loc, 'sound/items/firelight.ogg', 100)
		if(ismob(loc))
			var/mob/M = loc
			M.update_inv_hands()

/obj/item/tntstick/extinguish()
	snuff()

/obj/item/tntstick/proc/snuff()
	if(lit)
		lit = FALSE
		STOP_PROCESSING(SSfastprocess, src)
		playsound(src.loc, 'sound/items/firesnuff.ogg', 100)
		icon_state = initial(icon_state)
		if(ismob(loc))
			var/mob/M = loc
			M.update_inv_hands()

/obj/item/tntstick/proc/explode(skipprob)
	STOP_PROCESSING(SSfastprocess, src)
	var/turf/T = get_turf(src)
	if(T)
		if(lit)
			if(!skipprob && prob(prob2fail))
				snuff()
			else
				for(var/mob/living/target in range(4, T))
					if(!target.mind || istype(target, /mob/living/simple_animal))
						target.adjustFireLoss(PVE_damage) //fireball damage + 40. That
				explosion(T, devastation_range = 0, heavy_impact_range = 0, light_impact_range = 4, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))
				qdel(src) //IMPORTANT!! go into walls /turf/closed/wall/ and see /turf/closed/wall/ex_act. Its bounded with /proc/explosion. Same for /obj/structure and /obj/structure/ex_act because if you going to fuck intergity or whatever this shit called players will skin you alive for breaking their equipment and keys
		else //also /turf/open/floor/ex_act for comment above
			if(prob(prob2fail))
				snuff()

/obj/item/tntstick/process()
	fuze--
	if(fuze <= 0)
		explode(TRUE)

/obj/item/tntstick/attackby(obj/item/I, mob/user, params)
	..()

	if(!istype(I, /obj/item/natural/fibers) && !istype(I, /obj/item/natural/bundle/fibers))
		return

	I.visible_message(
		span_warning("[user] begins to prepare [src].."),
		span_notice("I begin to set-up [src] with [I].")
	)

	if(istype(I, /obj/item/natural/bundle/fibers))
		var/obj/item/natural/bundle/fibers/bundle = I
		if(bundle.amount > 1)
			bundle.amount--
			bundle.update_icon()
		else
			qdel(bundle)
			new /obj/item/natural/fibers(user.loc)
	else
		qdel(I)

	var/set_time = HAS_TRAIT(user, TRAIT_BOMBER_EXPERT) ? 0.75 SECONDS : (7 SECONDS - user.get_skill_level(/datum/skill/craft/traps))

	if(!do_after(user, set_time, TRUE, src))
		to_chat(user, span_warning("I stop preparing [src]."))
		new /obj/item/natural/fibers(user.loc)
		if(prob(20) && !HAS_TRAIT(user, TRAIT_BOMBER_EXPERT))
			to_chat(user, span_warningbig("Uh oh."))
			light()
		return

	var/obj/item/bomb/tripbomb/trip = new /obj/item/bomb/tripbomb(get_turf(src))
	trip.b_type = type
	trip.icon_state = icon_state
	trip.add_overlay("tripbomb")
	trip.update_icon()
	trip.prob2fail = prob2fail
	trip.setter = user
	trip.tripcrit = tripcrit
	if(HAS_TRAIT(user, TRAIT_BOMBER_EXPERT))
		trip.alpha = 30
	var/obj/item/tripwire/wire = new /obj/item/tripwire(get_turf(user))
	wire.dir = user.dir
	wire.payload = trip
	if(HAS_TRAIT(user, TRAIT_BOMBER_EXPERT))
		wire.alpha = 30

	trip.wire_trigger.Add(wire)

	qdel(src)

	I.visible_message(
		span_warning("[user] finishes setting up [trip]."),
		span_notice("I finish setting up [trip]. I can extend it by one step longer.")
	)
	return

/obj/item/satchel_bomb
	name = "blastpowder satchel"
	desc = "A bewicked satchel, stuffed with a multitude of explosive-filled sticks. Too heavy to throw, and too powerful to withstand - for nothing but dust and echoes will remain, once \
	the shockwave abates. </br>'When the fuse reaches its zenith, the blastpowder will detonate. The explosion will generate a temperature of almost one hundred million thermes. Don't be \
	here when it blows.'"
	icon_state = "satchel_bomb"
	var/lit_state = "satchel_bomb-lit"
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_BULKY
	throwforce = 0
	throw_range = 2
	slot_flags = ITEM_SLOT_HIP
	throw_speed = 0.3
	var/fuze = 50
	var/lit = FALSE
	var/prob2fail = 1
	var/PVE_damage = 300
	var/tripcrit = 0
	grid_width = 256
	grid_height = 256

//admin only mega bomb, should never be made craftable
/obj/item/satchel_bomb/mega
	name = "mega blastpowder satchel"
	desc = "An overfilled satchel of blastpowder originally made by Lubbin Bleat, Otava's famed sheep-kin bathhouse attendant and ruler of the slumberbeat.. \
	</br>This bomb has been outlawed by all of Psydonia's kingdoms, and labled as a threat by both the Churches of the Pantheon and Orthodoxy. \
	</br> <font color='FF0000'>IF YOU SEE A LIT WICK, YOU BEST RUN AWAY QUICK!</font>"
	icon_state = "satchel_bomb"
	lit_state = "satchel_bomb-lit"
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_BULKY
	dropshrink = 5
	throwforce = 0
	throw_range = 1
	throw_speed = 0.3
	fuze = 50
	lit = FALSE
	prob2fail = 0
	PVE_damage = 500
	grid_width = 256
	grid_height = 256

/obj/item/satchel_bomb/spark_act()
	if(ismob(loc))
		var/mob/M = loc
		if(HAS_TRAIT(M, TRAIT_BOMBER_EXPERT) && !(src in M.held_items))
			return
	light()

/obj/item/satchel_bomb/fire_act()
	if(ismob(loc))
		var/mob/M = loc
		if(HAS_TRAIT(M, TRAIT_BOMBER_EXPERT) && !(src in M.held_items))
			return
	light()

/obj/item/satchel_bomb/ex_act()
	if(ismob(loc))
		var/mob/M = loc
		if(HAS_TRAIT(M, TRAIT_BOMBER_EXPERT) && !(src in M.held_items))
			return
	if(QDELETED(src))
		return
	lit = TRUE
	explode(TRUE)

/obj/item/satchel_bomb/proc/light()
	if(!lit)
		START_PROCESSING(SSfastprocess, src)
		icon_state = lit_state
		lit = TRUE
		playsound(src.loc, 'sound/items/firelight.ogg', 100)
		if(ismob(loc))
			var/mob/M = loc
			M.update_inv_hands()

/obj/item/satchel_bomb/extinguish()
	snuff()

/obj/item/satchel_bomb/proc/snuff()
	if(lit)
		lit = FALSE
		STOP_PROCESSING(SSfastprocess, src)
		playsound(src.loc, 'sound/items/firesnuff.ogg', 100)
		icon_state = initial(icon_state)
		if(ismob(loc))
			var/mob/M = loc
			M.update_inv_hands()

/obj/item/satchel_bomb/proc/explode(skipprob)
	STOP_PROCESSING(SSfastprocess, src)
	var/turf/T = get_turf(src)
	if(T)
		if(lit)
			if(!skipprob && prob(prob2fail))
				snuff()
			else
				if(istype(src, /obj/item/satchel_bomb/mega)) //removing restrictions, may the gods have mercy on you all
					for(var/mob/living/target in range(3, T))
						target.adjustFireLoss(PVE_damage) //summary 500
					for(var/mob/living/target in range(8, T))
						target.adjustFireLoss(PVE_damage - 100)
					explosion(T, devastation_range = 10, heavy_impact_range = 15, light_impact_range = 40, adminlog = TRUE, ignorecap = TRUE, flame_range = 10, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg')) //5 times the size
					qdel(src)
				else
					for(var/mob/living/target in range(3, T))
						if(!target.mind || istype(target, /mob/living/simple_animal))
							target.adjustFireLoss(PVE_damage) //summary 500
					for(var/mob/living/target in range(8, T))
						if(!target.mind || istype(target, /mob/living/simple_animal))
							target.adjustFireLoss(PVE_damage - 100)
					explosion(T, devastation_range = 2, heavy_impact_range = 3, light_impact_range = 8, flame_range = 2, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))
					qdel(src)

		else
			if(prob(prob2fail))
				snuff()

/obj/item/satchel_bomb/process()
	fuze--
	if(fuze <= 0)
		explode(TRUE)

/obj/item/satchel_bomb/attackby(obj/item/I, mob/user, params)
	..()

	if(!istype(I, /obj/item/natural/fibers) && !istype(I, /obj/item/natural/bundle/fibers))
		return

	I.visible_message(
		span_warning("[user] begins to prepare [src].."),
		span_notice("I begin to set-up [src] with [I].")
	)

	if(istype(I, /obj/item/natural/bundle/fibers))
		var/obj/item/natural/bundle/fibers/bundle = I
		if(bundle.amount > 1)
			bundle.amount--
			bundle.update_icon()
		else
			qdel(bundle)
			new /obj/item/natural/fibers(user.loc)
	else
		qdel(I)

	var/set_time = HAS_TRAIT(user, TRAIT_BOMBER_EXPERT) ? 0.75 SECONDS : (7 SECONDS - user.get_skill_level(/datum/skill/craft/traps))

	if(!do_after(user, set_time, TRUE, src))
		to_chat(user, span_warning("I stop preparing [src]."))
		new /obj/item/natural/fibers(user.loc)
		if(prob(20) && !HAS_TRAIT(user, TRAIT_BOMBER_EXPERT))
			to_chat(user, span_warningbig("Uh oh."))
			light()
		return

	var/obj/item/bomb/tripbomb/trip = new /obj/item/bomb/tripbomb(get_turf(src))
	trip.b_type = type
	trip.icon_state = icon_state
	trip.add_overlay("tripbomb")
	trip.update_icon()
	trip.prob2fail = prob2fail
	trip.setter = user
	trip.tripcrit = tripcrit
	if(HAS_TRAIT(user, TRAIT_BOMBER_EXPERT))
		trip.alpha = 30
	var/obj/item/tripwire/wire = new /obj/item/tripwire(get_turf(user))
	wire.dir = user.dir
	wire.payload = trip
	if(HAS_TRAIT(user, TRAIT_BOMBER_EXPERT))
		wire.alpha = 30

	trip.wire_trigger.Add(wire)

	qdel(src)

	I.visible_message(
		span_warning("[user] finishes setting up [trip]."),
		span_notice("I finish setting up [trip]. I can extend it by one step longer.")
	)
	return

/obj/item/impact_grenade
	name = "impact grenade"
	desc = "A fragile canister, filled with an explosive surprise. Shards of flint line its thin sleeve, aching to ignite at the slightest disturbance."
	dropshrink = 0.6
	icon_state = "impact_grenade"
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 1
	var/PVE_damage = 160
	var/tripcrit = 0
	var/mob/thrower
	grid_width = 32
	grid_height = 32

/obj/item/impact_grenade/Initialize(mapload)
	. = ..()

// Define a base explodes() proc that subtypes can override because its now explodes proc
/obj/item/impact_grenade/proc/explodes()
	STOP_PROCESSING(SSfastprocess, src)
	qdel(src) // Delete the grenade after use boy (ALWAYS USE IT)

/obj/item/impact_grenade/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	..()
	if(throwingdatum)
		thrower = throwingdatum.thrower
	sleep(1)
	explodes()

/obj/item/impact_grenade/attack_self(mob/user)
	..()

	if(HAS_TRAIT(user, TRAIT_BOMBER_EXPERT))
		to_chat(user, span_warning("Out of all the things you'd want to be fiddling with, you choose the worst? Bad idea."))
		return

	explodes()

/obj/item/impact_grenade/attackby(obj/item/I, mob/user, params)
	..()

	if(!istype(I, /obj/item/natural/fibers) && !istype(I, /obj/item/natural/bundle/fibers))
		return

	I.visible_message(
		span_warning("[user] begins to prepare [src].."),
		span_notice("I begin to set-up [src] with [I].")
	)

	if(istype(I, /obj/item/natural/bundle/fibers))
		var/obj/item/natural/bundle/fibers/bundle = I
		if(bundle.amount > 1)
			bundle.amount--
			bundle.update_icon()
		else
			qdel(bundle)
			new /obj/item/natural/fibers(user.loc)
	else
		qdel(I)

	var/set_time = HAS_TRAIT(user, TRAIT_BOMBER_EXPERT) ? 0.75 SECONDS : (7 SECONDS - user.get_skill_level(/datum/skill/craft/traps))

	if(!do_after(user, set_time, TRUE, src))
		to_chat(user, span_warning("I stop preparing [src]."))
		new /obj/item/natural/fibers(user.loc)
		if(prob(20) && !HAS_TRAIT(user, TRAIT_BOMBER_EXPERT))
			to_chat(user, span_warningbig("Uh oh."))
			explodes()
		return

	var/obj/item/bomb/tripbomb/trip = new /obj/item/bomb/tripbomb(get_turf(src))
	trip.b_type = type
	trip.icon_state = icon_state
	trip.add_overlay("tripbomb")
	trip.update_icon()
	trip.prob2fail = 1
	trip.setter = user
	trip.tripcrit = tripcrit
	if(HAS_TRAIT(user, TRAIT_BOMBER_EXPERT))
		trip.alpha = 30
	var/obj/item/tripwire/wire = new /obj/item/tripwire(get_turf(user))
	wire.dir = user.dir
	wire.payload = trip
	if(HAS_TRAIT(user, TRAIT_BOMBER_EXPERT))
		wire.alpha = 30

	trip.wire_trigger.Add(wire)

	qdel(src)

	I.visible_message(
		span_warning("[user] finishes setting up [trip]."),
		span_notice("I finish setting up [trip]. I can extend it by one step longer.")
	)
	return

/obj/item/impact_grenade/explosion
	name = "impact grenade"
	desc = "A fragile canister, filled with an explosive surprise. Shards of flint line its thin sleeve, aching to ignite at the slightest disturbance."

/obj/item/impact_grenade/explosion/explodes()
	STOP_PROCESSING(SSfastprocess, src)
	var/turf/T = get_turf(src)
	if(T)
		var/critbang = 0
		if(thrower)
			var/engineering = thrower.get_skill_level(/datum/skill/craft/engineering)
			var/mob/living/M = thrower
			critbang = (engineering * 10) + (M.STALUC * 2) + tripcrit
		for(var/mob/living/target in range(2, T))
			if(!target.mind || istype(target, /mob/living/simple_animal))
				target.adjustFireLoss(PVE_damage) //fireball damage + 40. That
				if(prob(critbang))
					var/leftovers = pick("smithereens", "thin gruel", "bits", "spare parts", "pieces", "kingdom come", "another timeline", "yesterday", "hell", "PSYDON's embrace", "Necra's embrace", "Zizo's embrace", "Astrata and back")
					target.visible_message("<span class='crit'><b>Critical hit!</b> The explosive blasts them to [leftovers]!</span>", "<span class='crit'><b>Critical hit!</b> The explosive blasts them to [leftovers]!</span>")
					playsound(get_turf(target), 'sound/combat/tf2crit.ogg', 100, FALSE)
					target.gib(TRUE, TRUE, FALSE, TRUE)
		explosion(T, heavy_impact_range = 1, light_impact_range = 3, flame_range = 2, smoke = TRUE, adminlog = FALSE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))
	qdel(src)

/obj/item/smokeshell
	name = "gas belcher shell"
	desc = "A vented canister, bereft of its noxious payload. How long can you hold your breath?"
	dropshrink = 0.6
	icon_state = "smokeshell_blank"
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 1
	grid_width = 32
	grid_height = 32

/obj/item/impact_grenade/smoke
	name = "gas belcher"
	desc = "A vented canister, filled with an obfuscating payload. Wisps of charsmoke occassionally escape from its ported maw."
	dropshrink = 0.6
	icon_state = "smokeshell_blue"
	var/datum/effect_system/smoke_spread/smoke_type = /datum/effect_system/smoke_spread
	grid_width = 32
	grid_height = 32

/obj/item/impact_grenade/smoke/attack_self(mob/user) // the only exception
	..()
	explodes()

/obj/item/impact_grenade/smoke/explodes()
	var/turf/T = get_turf(src)
	playsound(T, 'sound/misc/explode/incendiary (1).ogg', 100)
	var/datum/effect_system/smoke_spread/smoke = new smoke_type
	new /obj/item/smokeshell(get_turf(src.loc)) //leaving the empty case behind
	smoke.set_up(2, T) // radius of 2 around T
	smoke.start()
	..() // stop processing and delete self

/obj/item/impact_grenade/smoke/poison_gas
	name = "poison gas belcher"
	desc = "A vented canister, filled with a noxious payload. Even a mere whiff of its verdant surprise threatens to choke you apart."
	icon_state = "smokeshell_green"
	smoke_type = /datum/effect_system/smoke_spread/poison_gas

/obj/item/impact_grenade/smoke/healing_gas
	name = "healing gas belcher"
	desc = "A vented canister, filled with a medicinal payload. The crimson smoke tickles your lips; a taste not unlike sweetened lifeblood."
	icon_state = "smokeshell_red"
	smoke_type = /datum/effect_system/smoke_spread/healing_gas


/obj/item/impact_grenade/smoke/fire_gas
	name = "burning gas belcher"
	desc = "A vented canister, filled with a fiery payload. It feels uncomfortably hot in your palm, and carries a curious scent - not unlike roasted frybirds."
	icon_state = "smokeshell_orange"
	smoke_type = /datum/effect_system/smoke_spread/fire_gas

/obj/item/impact_grenade/smoke/blind_gas
	name = "blinding gas belcher"
	desc = "A vented canister, filled with an irritating payload. Your eyes are already watering from its ebbed fumes, and the numbness threatens to shutter your lids without resistance."
	icon_state = "smokeshell_blue"
	smoke_type = /datum/effect_system/smoke_spread/blind_gas

/obj/item/impact_grenade/smoke/mute_gas
	name = "silent gas belcher"
	desc = "A vented canister, filled with a numbing payload. A strange prickling sensation graces your mind and throat, not unlike the 'pins and needles' of a sleeping limb."
	icon_state = "smokeshell_purple"
	smoke_type = /datum/effect_system/smoke_spread/mute_gas

#undef MT_BOMB_HIT
#undef BOMB_HIT_IMMUNITY_DURATION
