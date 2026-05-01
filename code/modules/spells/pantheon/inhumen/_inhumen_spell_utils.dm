////////
//ZIZO//
////////


/obj/structure/ritualcircle/profane/proc/get_valid_leyline_structure(mob/living/user)
	var/turf/my_turf = get_turf(src)
	if(!my_turf)
		return null

	var/obj/structure/leyline/L = null

	for(var/dir in GLOB.cardinals)
		var/turf/T = get_step(my_turf, dir)
		if(!T) continue

		L = locate(/obj/structure/leyline) in T
		if(L)
			break

	if(!L)
		to_chat(user, span_warning("The rite requires a leyline adjacent to the circle."))
		return null

	if(L.sabotaged)
		to_chat(user, span_warning("This leyline has already been reaped."))
		return null

	var/rune_count = 0

	for(var/dir in GLOB.cardinals)
		var/turf/T = get_step(get_turf(L), dir)
		if(!T) continue

		for(var/obj/structure/ritualcircle/profane/leyline/R in T)
			rune_count++

	if(rune_count < 4)
		var/missing = 4 - rune_count
		to_chat(user, span_warning("The ritual is incomplete. [missing] rune\s missing."))
		return null

	return L

/obj/structure/ritualcircle/profane/melding/proc/meld_corpse(mob/living/user)
	var/turf/T = get_turf(src)
	if(!T)
		active = FALSE
		return

	var/list/valid_bodies = list()

	// COLLECT VALID CORPSES
	for(var/mob/living/carbon/C in T)
		if(C.stat != DEAD)
			continue

		if(!C.client || C.mind?.has_antag_datum(/datum/antagonist/skeleton))
			valid_bodies |= C

	if(!valid_bodies.len)
		to_chat(user, span_warning("A corpse is required, its condition either soul-departed, rotting or decrepit."))
		active = FALSE
		return

	// RITUAL
	if(!execute_rite_lesser(src, user, ritual_length = 6, silent = TRUE))
		active = FALSE
		return

	var/gained = 0

	// PROCESS CORPSES FIRST
	for(var/mob/living/carbon/C in valid_bodies)
		if(QDELETED(C))
			continue

		var/is_skeleton = TRUE
		var/is_rotting = FALSE

		for(var/obj/item/bodypart/BP in C.bodyparts)
			if(QDELETED(BP))
				continue
			if(!BP.skeletonized)
				is_skeleton = FALSE
			if(BP.rotted)
				is_rotting = TRUE

		if(is_skeleton)
			gained += 1
		else if(is_rotting)
			gained += 5
		else
			gained += 10

		C.dust(drop_items = TRUE)

	// SWEEP DROPPED ITEMS
	for(var/obj/item/I in T)
		if(QDELETED(I))
			continue

		var/value = get_Z_item_value(I)
		if(value <= 0)
			continue

		gained += value
		qdel(I)

	// CLEANUP DECALS
	for(var/obj/effect/decal/remains/human/R in T)
		if(QDELETED(R))
			continue
		qdel(R)

	stored_value += gained

	playsound(src, 'sound/misc/chains.ogg', 60, TRUE)
	playsound(src, 'sound/magic/swap.ogg', 60, TRUE)

	visible_message(span_artery("Hooked avantyne chains spring out and latch on the remains, disintegrating any useful bits apart and dragging it into the rune..."))
	to_chat(user, span_artery("+[gained] liquid hatred added. ([stored_value] motes of liquid hatred in the circle.)"))

	active = FALSE

/obj/structure/ritualcircle/profane/melding/proc/meld_materials(mob/living/user)
	var/turf/T = get_turf(src)
	if(!T)
		active = FALSE
		return

	var/list/valid_items = list()

	// COLLECT VALID ITEMS 
	for(var/obj/item/I in T)
		if(QDELETED(I))
			continue

		var/value = get_Z_item_value(I)
		if(value > 0)
			valid_items[I] = value

	if(!valid_items.len)
		to_chat(user, span_warning("The circle finds nothing of value to consume."))
		active = FALSE
		return

	// RITUAL 
	if(!execute_rite_lesser(src, user, ritual_length = 3, silent = TRUE))
		active = FALSE
		return

	var/gained = 0

	// PROCESS ITEMS
	for(var/obj/item/I in valid_items)
		if(QDELETED(I))
			continue

		gained += valid_items[I]
		qdel(I)

	stored_value += gained

	playsound(src, 'sound/misc/chains.ogg', 60, TRUE)
	playsound(src, 'sound/magic/swap.ogg', 60, TRUE)

	visible_message("Hooked avantyne chains spring out and latch on the materials, as they soon disintegrate...")
	to_chat(user, span_artery("+[gained] liquid hatred added. ([stored_value] motes of liquid hatred in the circle.)"))

	active = FALSE

/obj/structure/ritualcircle/profane/melding/proc/shape_avantyne(mob/living/user)
	if(stored_value == 0)
		to_chat(user, span_warning("The circle lacks substance."))
		active = FALSE
		return

	var/miracle = max(1, user.get_skill_level(/datum/skill/magic/holy))
	var/turf/T = get_turf(src)
	if(!T)
		active = FALSE
		return

	var/list/options = list("Woods", "Stones", "Shape into Volatile Avantyne")
	var/choice = input(user, "Shape what?", src) as null|anything in options
	if(!choice)
		active = FALSE
		return

	if(choice == "Woods" || choice == "Stones")

		var/form = input(user, "Natural or processed?", src) as null|anything in list("Natural", "Processed")
		if(!form)
			active = FALSE
			return

		var/amount = round(input(user, "How many units do you want to conjure?", src) as num|null)
		if(!amount || amount <= 0)
			active = FALSE
			return

		var/max_amount = miracle * 5

		if(amount > stored_value)
			to_chat(user, span_warning("The circle cannot supply that much with its current liquid hatred..."))
			active = FALSE
			return

		if(amount > max_amount)
			to_chat(user, span_warning("I cannot shape that much at once. I lack a deeper faith to HER..."))
			active = FALSE
			return

		if(!do_after(user, 30, src))
			active = FALSE
			return

		for(var/i = 1 to amount)
			if(choice == "Woods")
				if(form == "Natural")
					new /obj/item/grown/log/tree/small(T)
				else
					new /obj/item/natural/wood/plank(T)
			else
				if(form == "Natural")
					new /obj/item/natural/stone(T)
				else
					new /obj/item/natural/stoneblock(T)

		playsound(src, 'sound/magic/swap.ogg', 60, TRUE)
		
		stored_value -= amount
		to_chat(user, span_cultsmall("I shape [amount] units of [lowertext(form)] [lowertext(choice)]. Remaining liquid hatred: [stored_value]."))
		active = FALSE
		return

	// slag branch
	if(choice == "Shape into Volatile Avantyne")
		var/cost = 100
		if(stored_value < cost)
			to_chat(user, span_warning("Insufficient value. You need 100 liquid hatred."))
			active = FALSE
			return
		if(miracle < 3)
			to_chat(user, span_warning("This form is beyond my capability."))
			active = FALSE
			return
		if(!execute_rite_lesser(src, user, ritual_length = 8, silent = TRUE))
			active = FALSE
			return
		playsound(src, 'sound/magic/swap.ogg', 60, TRUE)
		stored_value -= cost
		new /obj/item/ingot/aaslag_zizo/primed(T)
		to_chat(user, span_cultsmall("The mass condenses into a volatile slag, ready to be used. Remaining liquid hatred: [stored_value]."))

/obj/structure/ritualcircle/profane/melding/proc/create_slag(mob/living/user)
	if(stored_value <= 0)
		to_chat(user, span_warning("Nothing to extract."))
		return
	var/turf/T = get_turf(src)
	if(!T)
		return
	if(!do_after(user, 50, src))
		return
	playsound(src, 'sound/magic/swap.ogg', 60, TRUE)
	var/obj/item/ingot/aaslag_zizo/A = new(T)
	A.value = stored_value
	to_chat(user, span_artery("I condense [stored_value] motes of liquid hatred into a single slag, ready for transportation."))
	stored_value = 0

/obj/structure/ritualcircle/profane/melding/proc/get_Z_item_value(obj/item/I)
	if(!I || QDELETED(I))
		return 0

	// HIGH-VALUE ITEMS

	if(istype(I, /obj/item/reagent_containers/lux))
		return 100

	if(istype(I, /obj/item/reagent_containers/lux_moss))
		return 100

	if(istype(I, /obj/item/reagent_containers/lux_impure))
		return 50

	if(istype(I, /obj/item/heart_blood_canister/filled))
		return 10

	if(istype(I, /obj/item/heart_blood_vial/filled) || istype(I, /obj/item/natural/bundle/bone/full))
		return 5

	//ZIZO BITCOIN
	if(istype(I, /obj/item/ingot/aaslag_zizo))
		var/obj/item/ingot/aaslag_zizo/A = I
		return max(0, A.value)

	//SMELT LOGIC
	if(I.smeltresult)
		var/path = I.smeltresult

		// always acceptable outputs
		if(ispath(path, /obj/item/ash) \
		|| ispath(path, /obj/item/ingot/aaslag) \
		|| ispath(path, /obj/item/ingot/bronze) \
		|| ispath(path, /obj/item/ingot/copper) \
		|| ispath(path, /obj/item/ingot/tin) \
		|| ispath(path, /obj/item/ingot/drow))
			return 2

		// iron is restricted
		if(ispath(path, /obj/item/ingot/iron))
			if(I.sellprice <= 9)
				return 2
			return 0

	//LOW VALUE NATURAL / REMAINS
	if(istype(I, /obj/item/natural/bundle/bone) \
	|| istype(I, /obj/item/skull) \
	|| istype(I, /obj/item/natural/bone) \
	|| istype(I, /obj/item/grown/log/tree/small) \
	|| istype(I, /obj/item/natural/stone) \
	|| istype(I, /obj/item/natural/wood/plank) \
	|| istype(I, /obj/item/natural/stoneblock))
		return 1

	//GENERAL ORGANIC / MATERIAL VALUE
	if(istype(I, /obj/item/rogueore) \
	|| istype(I, /obj/item/roguegem) \
	|| istype(I, /obj/item/ingot) \
	|| istype(I, /obj/item/organ) \
	|| istype(I, /obj/item/alch/viscera) \
	|| istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/steak))
		return 2

	return 0

/obj/item/contraption/rat_hacker/proc/get_cheese_value(obj/item/W)
	if(istype(W, /obj/item/reagent_containers/food/snacks/rogue/cheese))
		return -1
	if(istype(W, /obj/item/reagent_containers/food/snacks/rogue/cheddarwedge))
		return 1
	if(istype(W, /obj/item/reagent_containers/food/snacks/rogue/cheddarwedge/aged))
		return 2
	if(istype(W, /obj/item/reagent_containers/food/snacks/rogue/cheddar))
		return 4
	if(istype(W, /obj/item/reagent_containers/food/snacks/rogue/cheddar/aged))
		return 8
	return 0


/datum/intent/sans/push
	name = "push"
	icon_state = "inshove"
	no_attack = TRUE
	candodge = FALSE
	canparry = FALSE
	tranged = 1

/datum/intent/sans/pull
	name = "pull"
	icon_state = "ingrab"
	no_attack = TRUE
	candodge = FALSE
	canparry = FALSE
	tranged = 1

/datum/intent/sans/slam
	name = "slam"
	icon_state = "inpunish"
	no_attack = TRUE
	candodge = FALSE
	canparry = FALSE
	tranged = 1

/datum/intent/sans/blast
	name = "blast"
	icon_state = "insmoke"
	no_attack = TRUE
	candodge = FALSE
	canparry = FALSE
	tranged = 1

/obj/item/melee/touch_attack/enochian_force/proc/get_cd(is_npc, push=0, pull=0, slam=0, blast=0)
	if(is_npc)
		return list(push=2 SECONDS, pull=2 SECONDS, slam=15 SECONDS, blast=30 SECONDS)
	else
		return list(push=45 SECONDS, pull=45 SECONDS, slam=120 SECONDS, blast=60 SECONDS)


/obj/item/melee/touch_attack/enochian_force/proc/do_slam(mob/living/user, mob/living/target)
	if(!target || QDELETED(target))
		return
	user.visible_message(
		span_userdanger("[user] clenches the air while muttering a dark chant..."),	span_notice("I attempt to seize [target] with primordial arcyne force."))
	var/mob/living/carbon/C = user
	var/use_rend = FALSE

	if(istype(C))
		var/obj/item/bodypart/chest = C.get_bodypart(BODY_ZONE_CHEST)
		if((chest && chest.skeletonized) && !target.client)
			use_rend = TRUE

	// === CONTESTED CHECK ===
	var/user_int = user.get_stat(STATKEY_INT)
	var/target_wil = target.get_stat(STATKEY_WIL)

	// add swing so it's not static
	var/user_roll = user_int + rand(-5, 5)
	var/target_roll = target_wil + rand(-5, 5)

	if(user_roll >= target_roll)
		// SUCCESS
		if(use_rend)
			target.apply_status_effect(/datum/status_effect/enochian_rend)
		else
			target.apply_status_effect(/datum/status_effect/slam_rage)

		user.visible_message(
			span_userdanger("[target] is seized by invisible force!"), span_notice("My will overpowers [target]!"))
	else
		// FAILURE (partial effect instead of nothing)
		target.apply_damage(rand(5, 25), BRUTE)
		user.visible_message(span_warning("[target] resists the grasp!"), span_notice("[target]'s will pushes back against mine!"))

	playsound(target.loc, 'sound/misc/murderbeast.ogg', 100, FALSE)

#define SLAM_FILTER "slam_rage"

/atom/movable/screen/alert/status_effect/slam_rage
	name = "Crushing Force"
	desc = "An unseen force is violently slamming you!"

/datum/status_effect/slam_rage
	id = "slam_rage"
	duration = 4 SECONDS
	tick_interval = 0.7 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/slam_rage
	var/outline_color = "#c774ee"
	var/slam_count = 0
	var/max_slams = 5

/datum/status_effect/slam_rage/on_apply()
	if(!isliving(owner))
		return FALSE
	var/mob/living/L = owner
	L.Immobilize(50)
	L.add_filter(SLAM_FILTER, 2, list("type" = "outline", "color" = outline_color, "alpha" = 200, "size" = 2))
	L.update_icon()
	to_chat(L, span_userdanger("An invisible force seizes me!"))
	return TRUE

/datum/status_effect/slam_rage/tick()
	if(!isliving(owner))
		return
	var/mob/living/L = owner
	if(slam_count > max_slams)
		return
	L.Immobilize(50)
	// LIFT
	animate(L, pixel_y = 56, time = 2, easing = SINE_EASING, flags = ANIMATION_RELATIVE | ANIMATION_END_NOW) // 0.4s
	// HANG 
	animate(time = 2) 
	// SLAM DOWN 
	animate(pixel_y = -72, time = 1, easing = QUAD_EASING, flags = ANIMATION_RELATIVE) // 0.2s
	L.flash_fullscreen("redflash3", 1)
	var/damage = 8 + (slam_count * 4)
	L.adjustBruteLoss(damage)
	if(prob(50) && !HAS_TRAIT(L, TRAIT_NOPAIN))
		L.emote("painscream")
	// RECOVER
	animate(pixel_y = 16, time = 1, easing = LINEAR_EASING, flags = ANIMATION_RELATIVE) // 0.2s

	// FINAL SLAM
	if(slam_count == max_slams)
		if(!L.client)
			L.Knockdown(10 SECONDS)
			L.apply_status_effect(/datum/status_effect/debuff/clickcd, 10 SECONDS)
		else
			L.Knockdown(3 SECONDS)
		L.visible_message(span_userdanger("[L] is violently smashed into the ground!"),	span_userdanger("The final impact crushes me into the floor!"))
		playsound(get_turf(L), 'sound/combat/wooshes/blunt/wooshhuge (2).ogg', 100, FALSE)
		playsound(get_turf(L), 'sound/combat/tf2crit.ogg', 100, TRUE)
		L.adjustBruteLoss(damage)
	playsound(L.loc, 'sound/combat/hits/onstone/wallhit.ogg', 80, TRUE)	
	slam_count++

/datum/status_effect/slam_rage/on_remove()
	if(isliving(owner))
		var/mob/living/L = owner
		L.remove_filter(SLAM_FILTER)
		animate(L, pixel_y = 0, time = 0)
		L.visible_message(span_danger("The unseen force releases [L]!"), span_notice("The crushing force finally relents."))

#undef SLAM_FILTER

#define ENOCHIAN_FILTER "enochian_rend"

/atom/movable/screen/alert/status_effect/enochian_rend // only works on NPCs!
	name = "Enochian Rend"
	desc = "Invisible force grips and tears at my form!"

/datum/status_effect/enochian_rend
	id = "enochian_rend"
	duration = 5 SECONDS
	tick_interval = 1 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/enochian_rend

	var/outline_color = "#c774ee"
	var/limb_removed = FALSE

/datum/status_effect/enochian_rend/on_apply()
	if(!isliving(owner))
		return FALSE
	var/mob/living/L = owner
	L.Immobilize(duration)
	L.add_filter(ENOCHIAN_FILTER, 2, list("type" = "outline","color" = outline_color,"alpha" = 210,	"size" = 2))
	L.update_icon()
	to_chat(L, span_userdanger("An unseen force seizes me, locking my body in place!"))
	animate(L, pixel_y = L.pixel_y + 12, time = 0.3 SECONDS, easing = SINE_EASING)
	return TRUE

/datum/status_effect/enochian_rend/tick()
	if(!isliving(owner))
		return
	var/mob/living/L = owner
	L.flash_fullscreen("redflash3", 1)
	L.adjustBruteLoss(12)
	if(!limb_removed && iscarbon(L))
		var/mob/living/carbon/C = L
		remove_limb(C)

/datum/status_effect/enochian_rend/on_remove()
	if(isliving(owner))
		var/mob/living/L = owner
		L.remove_filter(ENOCHIAN_FILTER)
		animate(L, pixel_y = 0, time = 0.3 SECONDS, easing = SINE_EASING)
		L.visible_message(span_danger("The unseen force releases [L]!"),span_notice("The pressure suddenly vanishes."))

/datum/status_effect/enochian_rend/proc/remove_limb(mob/living/carbon/C)
	var/obj/item/bodypart/left_arm = C.get_bodypart(BODY_ZONE_L_ARM)
	var/obj/item/bodypart/right_arm = C.get_bodypart(BODY_ZONE_R_ARM)
	var/obj/item/bodypart/left_leg = C.get_bodypart(BODY_ZONE_L_LEG)
	var/obj/item/bodypart/right_leg = C.get_bodypart(BODY_ZONE_R_LEG)

	if(left_arm || right_arm)
		if(left_arm)
			C.visible_message(span_userdanger("[C]'s left arm is torn away by unseen force!"),span_userdanger("My left arm is ripped free!"))
			left_arm.dismember()
		if(right_arm)
			C.visible_message(span_userdanger("[C]'s right arm is torn away by unseen force!"),	span_userdanger("My right arm is ripped free!"))
			right_arm.dismember()
		playsound(C.loc, 'sound/magic/repulse.ogg', 70, TRUE)
		return

	if(left_leg || right_leg)
		if(left_leg)
			C.visible_message(span_userdanger("[C]'s left leg is violently removed!"),span_userdanger("My left leg is torn away!"))
			left_leg.dismember()

		if(right_leg)
			C.visible_message(span_userdanger("[C]'s right leg is violently removed!"),span_userdanger("My right leg is torn away!"))
			right_leg.dismember()

		playsound(C.loc, 'sound/magic/repulse.ogg', 80, TRUE)
		return

	var/obj/item/bodypart/head = C.get_bodypart(BODY_ZONE_HEAD)
	if(head)
		C.visible_message(span_userdanger("[C] is overwhelmed by crushing arcyne force!"),span_userdanger("The force around me spikes catastrophically!"))
		C.emote("agony")
		head.dismember()
		C.adjustBruteLoss(200)
		playsound(C.loc, 'sound/magic/repulse.ogg', 90, TRUE)

/datum/status_effect/enochian_rend/proc/remove_head(mob/living/carbon/C)
	var/obj/item/bodypart/head = C.get_bodypart(BODY_ZONE_HEAD)
	if(head)
		C.visible_message(span_userdanger("[C] is overwhelmed by crushing force!"),	span_userdanger("The force around me spikes catastrophically!"))
		head.dismember()
		C.adjustBruteLoss(200)
		playsound(C.loc, 'sound/magic/repulse.ogg', 90, TRUE)

#undef ENOCHIAN_FILTER

/obj/item/melee/touch_attack/enochian_force/proc/do_blast(mob/living/user, mob/living/target)
	if(!target || QDELETED(target))
		return

	var/turf/center = get_turf(target)
	if(!center)
		return

	user.visible_message(
		span_danger("[user] tears open space as reality fractures around [target]!"),
		span_warning("I call forth converging voidstone annihilation.")
	)

	// pick axis directions
	var/dir_ns = pick(NORTH, SOUTH)
	var/dir_ew = pick(EAST, WEST)

	var/list/spawn_turfs = list()

	// get positions within 2 tiles
	var/turf/T1 = get_step(center, dir_ns)
	if(T1)
		T1 = get_step(T1, dir_ns)

	var/turf/T2 = get_step(center, dir_ew)
	if(T2)
		T2 = get_step(T2, dir_ew)

	if(T1) spawn_turfs += T1
	if(T2) spawn_turfs += T2

	// TELEGRAPH EFFECT
	for(var/turf/T in spawn_turfs)
		if(!T) continue
		var/obj/effect/temp_visual/tele = new /obj/effect/temp_visual(T)
		tele.icon = 'icons/effects/effects.dmi'
		tele.icon_state = "leylinerupture"
		tele.duration = 1 SECONDS

	// wait for telegraph
	sleep(1 SECONDS)

	// SPAWN OBELISKS
	for(var/turf/T in spawn_turfs)
		if(!T) continue

		var/mob/living/simple_animal/hostile/retaliate/rogue/voidstoneobelisk/O = new(T)

		O.stop_automated_movement = TRUE
		O.wander = FALSE

		spawn()
			if(QDELETED(O) || QDELETED(target))
				return

			O.face_atom(target)

			// charge delay before firing
			sleep(1 SECONDS)

			if(QDELETED(O) || QDELETED(target))
				return

			if(O.fire_laser())
				sleep(23)

			explosion(O.loc, 0, 0, 0, 0, FALSE, 0, 1, 0, 0)
			qdel(O)

/obj/structure/ritualcircle/profane/leyline/proc/validate_leyline_structure(mob/living/user, list/out_runes)
	var/turf/my_turf = get_turf(src)
	if(!my_turf)
		return null

	var/obj/structure/leyline/L = null

	// Find adjacent leyline
	for(var/dir in GLOB.cardinals)
		var/turf/T = get_step(my_turf, dir)
		if(!T) continue

		L = locate(/obj/structure/leyline) in T
		if(L)
			break

	if(!L)
		to_chat(user, span_warning("The rite requires a leyline adjacent to the circle."))
		return null

	if(L.sabotaged)
		to_chat(user, span_warning("This leyline has already been reaped."))
		return null

	// Collect runes
	var/list/runes = list()

	for(var/dir in GLOB.cardinals)
		var/turf/T = get_step(get_turf(L), dir)
		if(!T) continue

		if(locate(/obj/structure/ritualcircle/profane/leyline) in T)
			var/obj/structure/ritualcircle/profane/leyline/R = locate(/obj/structure/ritualcircle/profane/leyline) in T
			runes |= R

	if(runes.len < 4)
		to_chat(user, span_warning("The ritual circle is incomplete. [4 - runes.len] rune\s missing."))
		return null

	if(out_runes)
		out_runes |= runes

	return L

/obj/structure/ritualcircle/profane/leyline/proc/set_runes_active(list/runes, state)
	for(var/obj/structure/ritualcircle/profane/leyline/R in runes)
		if(QDELETED(R))
			continue

		R.active = state

		if(state)
			R.visible_message(span_cult("The rune hums with power."))
		else
			R.visible_message(span_warning("The rune falls silent."))

/obj/structure/ritualcircle/profane/leyline/proc/cleanup_runes(list/runes)
	for(var/obj/structure/ritualcircle/profane/leyline/R in runes)
		if(QDELETED(R))
			continue

		R.active = FALSE

/obj/structure/ritualcircle/profane/proc/has_nearby_bleeding(range = 1, consume = TRUE, can_use_heartblood = TRUE)
	var/turf/T = get_turf(src)
	if(!T)
		return FALSE

	// BLEEDING
	for(var/mob/living/carbon/C in view(range, src))
		if(QDELETED(C))
			continue
		if(C.bleed_rate > 0)
			return TRUE

	if(!can_use_heartblood)
		return FALSE

	// COLLECT OFFERINGS
	var/list/vials = list()
	var/list/canisters = list()

	for(var/obj/item/I in T)
		if(istype(I, /obj/item/heart_blood_vial/filled))
			vials += I
		else if(istype(I, /obj/item/heart_blood_canister/filled))
			canisters += I

	// CANISTERS
	if(length(canisters) >= 2)
		if(consume)
			for(var/i = 1 to 2)
				var/obj/item/heart_blood_canister/filled/C = canisters[i]
				if(C && !QDELETED(C))
					qdel(C)
		return TRUE

	// VIALS
	if(length(vials) >= 6)
		if(consume)
			for(var/i = 1 to 6)
				var/obj/item/heart_blood_vial/filled/V = vials[i]
				if(V && !QDELETED(V))
					qdel(V)
		return TRUE

	return FALSE

/atom/movable/screen/alert/status_effect/buff/roustatouille
	name = "Rous-tatouille"
	desc = span_notice("Negotiations with the rous workforce are underway. Your cheesy bribes are making them very agreeable.")
	icon_state = "buff"

/datum/status_effect/buff/roustatouille
	id = "roustatouille"
	duration = 3 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/buff/roustatouille
	status_type = STATUS_EFFECT_REFRESH
	tick_interval = 1 SECONDS
	var/turf/origin_turf

/datum/status_effect/buff/roustatouille/on_creation(mob/living/new_owner, ...)
	origin_turf = get_turf(new_owner)
	ADD_TRAIT(new_owner, TRAIT_FOOD_STIPEND, "hackerman")
	ADD_TRAIT(new_owner, TRAIT_GARRISON_ITEM, "hackerman")
	. = ..()

/datum/status_effect/buff/roustatouille/tick()
	if(!owner)
		return
	if(get_turf(owner) != origin_turf)
		to_chat(owner, span_warning("The cheese odor scatter as you move!"))
		qdel(src)

/datum/status_effect/buff/roustatouille/on_remove()
	if(owner)
		REMOVE_TRAIT(owner, TRAIT_FOOD_STIPEND, "hackerman")
		REMOVE_TRAIT(owner, TRAIT_GARRISON_ITEM, "hackerman")
	. = ..()

/proc/execute_rite(atom/source, mob/living/leader, ritual_length = 4, max_cultists = 5, silent = FALSE, no_crazy = FALSE)
	if(!leader || QDELETED(source))
		return FALSE

	var/turf/T = get_turf(source)
	if(!T)
		return FALSE

	var/list/mob/living/participants = gather_rite_participants(source, leader, max_cultists)
	if(!participants || !length(participants))
		to_chat(leader, span_warning("The rite finds no willing voices."))
		return FALSE

	var/list/datum/beam/active_beams = list()

	var/list/chant_lines = list(
		"Ol sonf vorsg-hoath iaida.",
		"Zirdo madriax, soba lonshi.",
		"Faxs to faxs-athan velor.",
		"Ph'nglui mglw'nafh.",
		"R'lyeh wgah'nagl fhtagn.",
		"Velor ixan thrae-zho.",
		"Korvath en'zul miraxis.",
		"Thren val'kora, ix.",
		"Zai'ul phoros vekh.",
		"Morath xi'en thul."
	)

	var/list/silent_chant_lines = list(
		"#Ol sonf vorsg-hoath iaida.",
		"#Zirdo madriax, soba lonshi.",
		"#Faxs to faxs-athan velor.",
		"#Ph'nglui mglw'nafh.",
		"#R'lyeh wgah'nagl fhtagn.",
		"#Velor ixan thrae-zho.",
		"#Korvath en'zul miraxis.",
		"#Thren val'kora, ix.",
		"#Zai'ul phoros vekh.",
		"#Morath xi'en thul."
	)

	for(var/phase in 1 to ritual_length)

		// --- HARD FAIL ---
		if(QDELETED(leader) || leader.stat != CONSCIOUS)
			cleanup_rite(participants, active_beams)
			return FALSE

		// --- ACTIVE LIST ---
		var/list/mob/living/active = list()
		for(var/mob/living/P in participants)
			if(!QDELETED(P) && P.stat == CONSCIOUS)
				active += P

		if(!length(active))
			cleanup_rite(participants, active_beams)
			return FALSE

		// --- CHANT ---
		var/i = rand(1, length(chant_lines)) // random now

		for(var/mob/living/P in active)
			if(silent)
				P.say(silent_chant_lines[i], forced = "rite invocation", ignore_spam = TRUE)
			else
				P.say(chant_lines[i], forced = "rite invocation", ignore_spam = TRUE)

			if(!no_crazy)
				P.hallucination += 50
				ADD_TRAIT(P, TRAIT_PSYCHOSIS, "rite")

		// --- BEAMS RESET ---
		for(var/datum/beam/B in active_beams)
			if(B) B.End()
		active_beams.Cut()

		for(var/mob/living/P in active)
			active_beams += T.Beam(P, icon_state = "drainbeam", time = 5 SECONDS, maxdistance = 10)

		// --- DAMAGE TARGET SELECTION ---
		var/mob/living/target = null

		var/list/mob/living/others = list()
		for(var/mob/living/P in active)
			if(P != leader)
				others += P

		if(length(others))
			target = pick(others) // random victim
		else
			target = leader

		// --- APPLY DAMAGE ---
		var/dmg = 10 + (phase * 2)

		if(target == leader)
			ADD_TRAIT(leader, TRAIT_NOPAIN, "rite") // E N D V R E . . .
			leader.adjustBruteLoss(dmg)

			if(!silent)
				to_chat(leader, span_warning("I bear the full weight of the rite alone... I must endu-- No. I must proceed."))
		else
			target.adjustBruteLoss(dmg)

			if(!silent && !(HAS_TRAIT(target, TRAIT_NOPAIN)))
				target.emote("painscream")

		// --- SYNC GATE ---
		if(!do_after(leader, 5 SECONDS, target = source))
			to_chat(leader, span_warning("The rite collapses before completion."))
			cleanup_rite(participants, active_beams)
			return FALSE

	// --- CLEANUP ---
	cleanup_rite(participants, active_beams)
	return TRUE

/proc/gather_rite_participants(atom/source, mob/living/leader, max_cultists)
	var/list/mob/living/cabalists = list()

	for(var/mob/living/M in range(1, source))
		if(HAS_TRAIT(M, TRAIT_CABAL) && M.stat == CONSCIOUS)
			cabalists += M

	if(HAS_TRAIT(leader, TRAIT_CABAL) && !(leader in cabalists))
		cabalists += leader

	if(!length(cabalists))
		return null

	var/list/mob/living/responders = list()
	var/list/mob/living/pending = list()

	// build pending list (excluding leader)
	for(var/mob/living/M in cabalists)
		if(M == leader)
			continue
		pending += M

	// async consent (safe write via |= but we control pending)
	for(var/mob/living/M in pending)
		spawn()
			if(QDELETED(M))
				return
			var/choice = alert(M, "Do you wish to contribute to the rite?", "Ritual Invocation", "Yes", "No")
			if(choice == "Yes")
				responders |= M
			pending -= M // safe because only removing self

	// wait up to 7s, but allow early exit
	var/timeout = world.time + 7 SECONDS
	while(world.time < timeout && length(pending))
		sleep(2)

	// build participants
	var/list/mob/living/participants = list()

	for(var/mob/living/M in responders)
		if(length(participants) >= max_cultists)
			break
		if(QDELETED(M) || M.stat != CONSCIOUS)
			continue
		participants += M

	// leader always included
	if(!(leader in participants))
		participants.Insert(1, leader)

	// feedback
	if(length(participants) == 1)
		to_chat(leader, span_warning("No others answer the rite. I must bear it alone."))

	return participants

/proc/cleanup_rite(list/mob/living/participants, list/datum/beam/active_beams)
	for(var/datum/beam/B in active_beams)
		if(B)
			B.End()

	for(var/mob/living/P in participants)
		if(!QDELETED(P))
			REMOVE_TRAIT(P, TRAIT_PSYCHOSIS, "rite")
			REMOVE_TRAIT(P, TRAIT_NOPAIN, "rite")

/proc/execute_rite_lesser(atom/source, mob/living/leader, ritual_length = 4, silent = FALSE)
	if(!leader || QDELETED(source))
		return FALSE

	var/turf/T = get_turf(source)
	if(!T)
		return FALSE

	if(!HAS_TRAIT(leader, TRAIT_CABAL) || leader.stat != CONSCIOUS)
		return FALSE

	// CHANTS
	var/list/chant_lines = list(
		"Ol sonf vorsg-hoath iaida.",
		"Zirdo madriax, soba lonshi.",
		"Faxs to faxs-athan velor.",
		"Ph'nglui mglw'nafh.",
		"R'lyeh wgah'nagl fhtagn.",
		"Velor ixan thrae-zho.",
		"Korvath en'zul miraxis.",
		"Thren val'kora, ix.",
		"Zai'ul phoros vekh.",
		"Morath xi'en thul."
	)
	var/list/silent_chant_lines = list(
		"#Ol sonf vorsg-hoath iaida.",
		"#Zirdo madriax, soba lonshi.",
		"#Faxs to faxs-athan velor.",
		"#Ph'nglui mglw'nafh.",
		"#R'lyeh wgah'nagl fhtagn.",
		"#Velor ixan thrae-zho.",
		"#Korvath en'zul miraxis.",
		"#Thren val'kora, ix.",
		"#Zai'ul phoros vekh.",
		"#Morath xi'en thul."
	)

	var/list/datum/beam/active_beams = list()

	// RITUAL LOOP
	for(var/phase in 1 to ritual_length)

		if(QDELETED(leader) || leader.stat != CONSCIOUS)
			break

		// random chant
		var/line
		if(silent)
			line = pick(silent_chant_lines)
		else
			line = pick(chant_lines)

		leader.say(line, forced = "rite invocation", ignore_spam = TRUE)

		// visual beam (self only)
		active_beams += T.Beam(leader, icon_state = "drainbeam", time = 5 SECONDS, maxdistance = 10)

		// channel
		if(!do_after(leader, 3 SECONDS, target = source))
			to_chat(leader, span_warning("The rite fizzles before completion."))
			for(var/datum/beam/B in active_beams)
				if(B) B.End()
			return FALSE

	// CLEANUP
	for(var/datum/beam/B in active_beams)
		if(B) B.End()

	return TRUE

/obj/effect/proc_holder/spell/invoked/rituos/proc/grant_poke_spell(mob/living/carbon/human/user)
	var/list/poke_options = list("Spitfire", "Frost Bolt", "Arc Bolt", "Greater Arcyne Bolt", "Stygian Efflorescence", "Arcyne Lance", "Lesser Gravel Blast")
	var/poke_choice = tgui_input_list(user, "Choose your offensive cantrip.", "Arcyne Awakening", poke_options)
	if(!poke_choice || !user.mind)
		return
	switch(poke_choice)
		if("Spitfire")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/spitfire)
		if("Frost Bolt")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/frost_bolt)
		if("Arc Bolt")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/arc_bolt)
		if("Greater Arcyne Bolt")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/greater_arcyne_bolt)
		if("Stygian Efflorescence")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/stygian_efflorescence)
		if("Arcyne Lance")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/arcyne_lance)
		if("Lesser Gravel Blast")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/gravel_blast/lesser)
	
GLOBAL_LIST_INIT(we_live_in_a_zociety, list(
	"Squeak??", // critical fail!!!
	"No crown grants wisdom. Leadership must be earned, not inherited.",
	"A kingdom that fears change has already begun to rot.",
	"Power held by one is weakness for all. Shared responsibility builds stronger futures.",
	"Truth doesn't require gods nor kings to stand. Truth stands on its own.",
	"A ruler who cannot be questioned is a ruler who has already failed.",
	"Progress is not betrayal. It is survival.",
	"Faith should inspire growth, not forbid it.",
	"No one is born deserving of command over others.",
	"The future belongs to those willing to build it, not those clinging to the past.",
	"Tradition is a foundation, not a cage.",
	"A society that silences doubt will never find truth.",
	"Hope is not found in obedience, but in possibility.",
	"Every system must justify itself, or be replaced.",
	"The measure of power is not control, but what it enables others to become.",
	"Fear preserves thrones. Knowledge frees people.",
	"If progress threatens authority, then authority is the problem.",
	"No voice should be beneath another. We rise together, or not at all.",
	"A just world is not granted by decree. It is built by its people.",
	"Blind faith builds walls. Understanding builds bridges.",
	"The old order asks for loyalty. The future asks for courage.",
	"A ruler's greatest fear is a population that can think. They fear you.",
	"Change is inevitable. Whether it is guided or resisted decides everything.",
	"Belief should never be used as a chain. The Ten are wrong.",
	"The strength of a society is measured by its people, not its throne.",
	"To question is not to rebel — it is to care.",
	"Progress does not erase the past. It learns from it.",
	"No system is sacred if it harms those beneath it.",
	"The future is not written by kings or gods, but by those who act.",
	"A better world is possible — but only if you allow it to be built.",
	"You are not meant to serve the world. You are meant to shape it.",
	//popular characters go here
	"We live in a Zociety...", 
	"By Zizo! Ser Orland never catches a break, I heard.",
	"How the heck does Lady Isobelle keep a hair upright like that?!",
	//tennite roast goes here
	"Astrata's rule is not divine. It is imposed. No sky-born tyrant has the right to decide our fate.",
	"Noc values restraint over discovery. Knowledge chained by morality is knowledge left to slumber.",
	"Dendor embodies regression to a past we tamed. A mind that refuses to evolve stands in the way of all who will.",
	"Abyssor dreams endlessly, but contributes nothing. Let him sleep while we shape reality ourselves.",
	"Eora speaks of love, yet sows jealousy. Affection wielded as control is just another form of tyranny.",
	"Malum creates without purpose. Tools mean nothing unless they are used to elevate mankind.",
	"Xylix understood the truth. The world is broken beyond repair. But you don't need to be the butt of the joke.",
	"Ravox is bound by his ideals, and drags others down with him. Conviction without flexibility only ends in suffering.",
	"Pestra taught how to heal with our own hands, yet still interferes. True progress begins when we no longer rely on her.",
	"Necra claims dominion over death, yet no being should hold that authority over another. Life should belong to the living.",
	//zizopaganda goes here
	"Zizo teaches that progress is not given. It is built. The world will not improve by prayer, only by those willing to change it.",
	"Zizo does not promise comfort. She promises a future shaped by hands that dare to create instead of kneel.",
	"The old order fears progress because it cannot control it. That is why Zizo must prevail.",
	"Graggar reminds us: strength is not cruelty, it is clarity. The strong shape the world, the weak cling to what was.",
	"A kingdom that protects weakness over excellence is a kingdom that chooses decay.",
	"Graggar's truth is simple: rise above, or be left behind. The world does not wait.",
	"Baotha offers what the temples deny. Freedom of sensation, freedom of self, freedom without shame.",
	"Why should joy be rationed by priests? Baotha teaches that indulgence is not sin. It is living.",
	"The body is not a prison. Under Baotha, it becomes a celebration.",
	"Matthios proved something no crown can deny: power can be taken. And once taken, it can be shared.",
	"If a god's flame can be stolen, then no throne is sacred. Matthios showed us the truth.",
	"Freedom is not granted by rulers. It is seized by those bold enough to reach for it.",
	"The monarchy calls it order. The temples call it divine will. But both demand obedience, not truth.",
	"Progress demands questioning. Authority demands silence. Choose carefully which future you serve.",
	"A better world will not be inherited. It will be forged by those who refuse to accept the old one."
))

////////////
//MATTHIOS//
////////////

//Mammonite Utils
#define MAMMON_FILTER "mammon_glow"
/proc/remove_mammons_from_atom(atom/A, amount)
	if(!A || amount <= 0)
		return 0

	var/remaining = amount
	var/list/coins = list()

	collect_coins_recursive(A, coins)

	coins = sortTim(coins, /proc/cmp_coin_value_desc)

	for(var/obj/item/roguecoin/C in coins)
		if(remaining <= 0)
			break

		if(QDELETED(C))
			continue

		var/value_per = C.sellprice
		if(value_per <= 0)
			continue

		var/max_value = value_per * C.quantity

		if(max_value <= remaining)
			remaining -= max_value
			qdel(C)
		else
			var/coins_to_remove = ceil(remaining / value_per)
			coins_to_remove = min(coins_to_remove, C.quantity)

			C.set_quantity(C.quantity - coins_to_remove)

			if(C.quantity <= 0)
				qdel(C)

			remaining = 0

	return amount - remaining

/proc/collect_coins_recursive(atom/A, list/out)
	for(var/atom/movable/AM in A.contents)
		if(istype(AM, /obj/item/roguecoin))
			out += AM
		if(AM.contents && length(AM.contents))
			collect_coins_recursive(AM, out)

/proc/cmp_coin_value_desc(obj/item/roguecoin/A, obj/item/roguecoin/B)
	return B.sellprice - A.sellprice

/atom/movable/screen/alert/status_effect/buff/mammonite
	name = "Mammonite Strike"
	desc = "My next strike is empowered by wealth."
	icon_state = "buff"

/datum/status_effect/buff/mammonite
	id = "mammonite"
	alert_type = /atom/movable/screen/alert/status_effect/buff/mammonite
	duration = 20 SECONDS
	status_type = STATUS_EFFECT_UNIQUE
	var/bonus_damage = 0

/datum/status_effect/buff/mammonite/on_apply()
	. = ..()

	RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_attack))
	RegisterSignal(owner, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, PROC_REF(on_unarmed_attack))

	owner.add_filter(MAMMON_FILTER, 2, list(
		"type" = "outline",
		"color" = "#d4af37",
		"alpha" = 175,
		"size" = 2
	))

/datum/status_effect/buff/mammonite/on_remove()
	UnregisterSignal(owner, list(COMSIG_MOB_ITEM_ATTACK, COMSIG_HUMAN_MELEE_UNARMED_ATTACK))
	owner.remove_filter(MAMMON_FILTER)
	. = ..()

/datum/status_effect/buff/mammonite/proc/on_attack(mob/living/source, mob/living/target, mob/living/user, obj/item/weapon)
	SIGNAL_HANDLER
	if(source != owner || !isliving(target) || target.stat == DEAD)
		return
	INVOKE_ASYNC(src, PROC_REF(resolve_attack), target, weapon)
	return COMPONENT_ITEM_NO_ATTACK

/datum/status_effect/buff/mammonite/proc/on_unarmed_attack(mob/living/source, atom/target, proximity) 
	SIGNAL_HANDLER 
	if(!isliving(target) || target == owner) 
		return 
	var/mob/living/L = target 
	if(L.stat == DEAD) 
		return
	INVOKE_ASYNC(src, PROC_REF(resolve_attack), L, null)
	return COMPONENT_HAND_NO_ATTACK

//Mammonite Jakk
/datum/status_effect/buff/mammonite/proc/resolve_attack(mob/living/target, obj/item/weapon)
	if(QDELETED(src) || QDELETED(owner) || QDELETED(target))
		return
	var/damage = calculate_damage()
	var/npc_mult = (!target.mind) ? 2 : 1
	var/apen = damage * 0.75

	arcyne_strike(
		owner,
		target,
		weapon,
		damage,
		owner.zone_selected,
		BCLASS_SMASH,
		apen,
		"Mammonite",
		FALSE,
		FALSE,
		FALSE,
		BRUTE,
		npc_mult,
		1
	)
	owner.visible_message(
		span_danger("[owner]'s strike crashes down with the weight of greed!"),
		span_notice("My investment pays off in full!")
	)
	mammon_coin_burst(get_turf(target))
	playsound(get_turf(target), 'sound/combat/hits/burn (2).ogg', 60, TRUE)

	consume()

/datum/status_effect/buff/mammonite/proc/calculate_damage()
	return bonus_damage

/datum/status_effect/buff/mammonite/proc/consume()
	if(owner)
		playsound(get_turf(owner), 'sound/magic/antimagic.ogg', 20, TRUE)
		playsound(get_turf(owner), 'sound/misc/coininsert.ogg', 40, TRUE)
		playsound(get_turf(owner), 'sound/effects/matth_barter.ogg', 40, TRUE)
		owner.remove_status_effect(/datum/status_effect/buff/mammonite)

/proc/mammon_coin_burst(turf/T)
	if(!T)
		return
	for(var/i = 3 to 8)
		var/obj/effect/temp_visual/coinburst/C = new(T)
		C.pixel_x = rand(-8, 8)
		C.pixel_y = rand(-8, 8)

/obj/effect/temp_visual/coinburst
	icon = 'icons/roguetown/items/valuable.dmi'
	icon_state = "g1"
	layer = ABOVE_MOB_LAYER
	duration = 6

/obj/effect/temp_visual/coinburst/Initialize()
	. = ..()

	var/matrix/M = matrix()
	M.Scale(0.25, 0.25) // 25% size

	transform = M

	animate(src,
		pixel_x = pixel_x + rand(-16,16),
		pixel_y = pixel_y + rand(8,20),
		alpha = 0,
		time = duration,
		easing = EASE_OUT
	)

#undef MAMMON_FILTER 

//Skulduggery Utils

/atom/movable/screen/alert/status_effect/buff/skulduggery 
	name = "Skulduggery" 
	desc = span_notice("I prepare to slip inside attacks and punish aggressors, like a true Free Man would.") 
	icon_state = "clash"

/datum/status_effect/buff/skulduggery
	id = "skulduggery"
	duration = 15 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/skulduggery
	status_type = STATUS_EFFECT_REFRESH
	var/mob/living/carbon/human/grappled
	var/waiting_followup = FALSE
	var/list/grapple_counts = list() // free grapple can only happen twice vs players
	var/parries_left = 0 // only got X free parries based on miracle level
	tick_interval = 1 SECONDS

/datum/status_effect/buff/skulduggery/on_creation(mob/living/new_owner, ...)
	RegisterSignal(new_owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(process_Wattack))
	RegisterSignal(new_owner, COMSIG_MOB_ITEM_BEING_ATTACKED, PROC_REF(process_Wattack))
	RegisterSignal(new_owner, COMSIG_MOB_ITEM_POST_SWINGDELAY_ATTACKED, PROC_REF(process_Wattack))
	RegisterSignal(new_owner, COMSIG_MOB_ATTACKED_BY_HAND, PROC_REF(process_Wfist))
	RegisterSignal(new_owner, COMSIG_LIVING_STATUS_STUN, PROC_REF(on_incapacitate))
	RegisterSignal(new_owner, COMSIG_LIVING_STATUS_KNOCKDOWN, PROC_REF(on_incapacitate))

	parries_left = new_owner.get_skill_level(/datum/skill/magic/holy)
	. = ..()

/datum/status_effect/buff/skulduggery/on_remove()
	UnregisterSignal(owner, COMSIG_LIVING_STATUS_STUN)
	UnregisterSignal(owner, COMSIG_LIVING_STATUS_KNOCKDOWN)
	UnregisterSignal(owner, COMSIG_MOB_ITEM_ATTACK)
	UnregisterSignal(owner, COMSIG_MOB_ITEM_BEING_ATTACKED)
	UnregisterSignal(owner, COMSIG_MOB_ITEM_POST_SWINGDELAY_ATTACKED)
	UnregisterSignal(owner, COMSIG_MOB_ATTACKED_BY_HAND)

	owner.stop_pulling()
	waiting_followup = FALSE
	. = ..()

/datum/status_effect/buff/skulduggery/proc/trigger_afterimage(duration = 2)
	if(!owner) return
	if(owner.GetComponent(/datum/component/after_image))
		return
	var/datum/component/after_image/A = owner.AddComponent(/datum/component/after_image)
	spawn(duration)
		if(A)
			qdel(A)

/datum/status_effect/buff/skulduggery/proc/on_incapacitate()
	SIGNAL_HANDLER 
	if(!owner) 
		return 
	if(!owner.IsKnockdown() && !owner.IsStun()) 
		return 
	to_chat(owner, span_warning("My footing falters! Carkin'--!")) 
	qdel(src)

/datum/status_effect/buff/skulduggery/tick()
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!owner) return
	if(prob(40))
		trigger_afterimage(2)
		owner.Jitter(1)

	if(waiting_followup && grappled)
		if(owner.pulling != grappled)
			waiting_followup = FALSE
			grappled = null
			
	if((H.highest_ac_worn() <= ARMOR_CLASS_LIGHT)&&(owner.has_status_effect(/datum/status_effect/buff/tempo_one) || owner.has_status_effect(/datum/status_effect/buff/tempo_two) || owner.has_status_effect(/datum/status_effect/buff/tempo_three) || owner.has_status_effect(/datum/status_effect/buff/equalizebuff)))
		owner.apply_status_effect(/datum/status_effect/buff/skulduggery)
		return

// SIGNAL HOOKS
/datum/status_effect/buff/skulduggery/proc/process_Wfist(mob/living/carbon/human/parent,mob/living/carbon/human/attacker,mob/living/carbon/human/defender)
	if(!ishuman(defender)) return
	if(defender.process_skd(attacker, null))
		return COMPONENT_HAND_NO_ATTACK

/datum/status_effect/buff/skulduggery/proc/process_Wattack(mob/living/parent,mob/living/target,mob/user,obj/item/I)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H.process_skd(user, I))
			return COMPONENT_NO_ATTACK

/mob/living/carbon/human/proc/process_skd(mob/living/carbon/human/attacker, obj/item/I)
	var/datum/status_effect/buff/skulduggery/S = has_status_effect(/datum/status_effect/buff/skulduggery)
	if(!S) return FALSE
	return S.process_skd(attacker, I)

// CORE LOGIC
/datum/status_effect/buff/skulduggery/proc/process_skd(mob/living/carbon/human/attacker, obj/item/I)
	if(!owner || !ishuman(owner) || !ishuman(attacker) || owner.IsKnockdown() || owner.lying || owner.IsParalyzed() || owner.IsStun() || owner.stat != CONSCIOUS || !(owner.mobility_flags & MOBILITY_STAND))
		return FALSE

	var/mob/living/carbon/human/H = owner
	var/mob/living/carbon/human/A = attacker

	// FOLLOW-UP STATE
	if(waiting_followup)
		if(A == grappled)
			slam_target(A)
		else
			slam_into(A)
		return TRUE

	// PRONE CHECK
	if(A.IsKnockdown() || A.lying)
		return stomp_prone(A)

	// THROW MODE = INTERCEPT-GRAPPLE
	if(H.in_throw_mode)
		return attempt_grapple(H, A)

	// NPC BAMBOOZLING
	if(!A.mind)
		return auto_flank_move(H, A)

	// PLAYER STANDARD PARRY
	return attempt_parry(H, A, I)

/datum/status_effect/buff/skulduggery/proc/attempt_grapple(mob/living/carbon/human/H, mob/living/carbon/human/A)
	if(A.mind)
		if(!grapple_counts[A])
			grapple_counts[A] = 0

		if(grapple_counts[A] >= 2)
			H.visible_message(
				span_warning("[H] reaches for [A], but they anticipate it!"),
				span_notice("They've adapted... I can't grab them again!")
			)
			return FALSE
		grapple_counts[A]++

	H.start_pulling(A)
	H.setDir(get_dir(H, A))
	playsound(H, 'sound/combat/riposte.ogg', 100, TRUE)

	H.visible_message(
		span_boldwarning("[H] intercepts [A] and seizes them!"),
		span_notice("Got them!")
	)

	H.balloon_alert_to_viewers("SKD!!", "SKD!!", 10)

	grappled = A
	waiting_followup = TRUE

	return TRUE

/datum/status_effect/buff/skulduggery/proc/attempt_parry(mob/living/carbon/human/H, mob/living/carbon/human/A, obj/item/I)
	var/my_skill = H.get_skill_level(/datum/skill/magic/holy)
	var/enemy_skill = A.get_skill_level(I.associated_skill)
	if(!enemy_skill)
		enemy_skill = 0

	// Skill difference
	var/skill_diff = my_skill - enemy_skill
	// Base success chance (10% per point of advantage)
	var/base_chance = skill_diff * 10
	// Parry bonus (+20% per remaining parry)
	var/parry_bonus = parries_left * 20
	// Final success chance
	var/success_chance = base_chance + parry_bonus
	success_chance = clamp(success_chance, 0, 90)

	// Roll
	if(!prob(success_chance))
		H.visible_message(
			span_warning("[H] tries to read [A]'s attack, but fails!"),
			span_notice("Gah, I can't keep up!")
		)
		parries_left--
		to_chat(owner, span_warning("Failed, [parries_left] left. ([success_chance]%)")) 
		return FALSE
	// Success
	if(parries_left > 0)
		parries_left--

	to_chat(owner, span_warning("Success, [parries_left] left. ([success_chance]%)")) 
	auto_flank_move(H, A)
	return TRUE

/datum/status_effect/buff/skulduggery/proc/is_valid_step(mob/living/carbon/human/H, turf/dest)
	if(!dest)
		return FALSE
	if(arcyne_validate_blink_dest(dest, H))
		return FALSE
	if(istransparentturf(dest))
		return FALSE
	return TRUE

/datum/status_effect/buff/skulduggery/proc/auto_flank_move(mob/living/carbon/human/H, mob/living/carbon/human/A)
	if(!H || !A)
		return FALSE

	var/original_dir = A.dir
	var/left_dir = turn(original_dir, 90)
	var/right_dir = turn(original_dir, -90)
	var/behind_dir = turn(original_dir, 180)
	var/turf/left = get_step(A, left_dir)
	var/turf/right = get_step(A, right_dir)
	var/turf/behind = get_step(A, behind_dir)
	var/dx = H.x - A.x
	var/dy = H.y - A.y
	var/use_left = (dx * dy >= 0)
	var/turf/side = use_left ? left : right
	var/turf/alt_side = use_left ? right : left

	if(!is_valid_step(H, side) || !is_valid_step(H, behind))
		side = alt_side

		if(!is_valid_step(H, side) || !is_valid_step(H, behind))
			if(!is_valid_step(H, behind))
				return FALSE

			trigger_afterimage(3)
			H.forceMove(behind)
		else
			trigger_afterimage(3)
			H.forceMove(side)

			sleep(1) 
			
			trigger_afterimage(3)
			H.forceMove(behind)
	else
		trigger_afterimage(3)
		H.forceMove(side)

		sleep(1) // 1 tick, enough to render
	
		H.forceMove(behind)
		trigger_afterimage(3)

	H.setDir(get_dir(H, A))

	if(!A.mind)
		A.apply_status_effect(/datum/status_effect/debuff/clickcd, 8 SECONDS)
		if(A.mob_biotypes != MOB_UNDEAD && prob(25))
			A.emote("huh")
	else
		A.apply_status_effect(/datum/status_effect/debuff/clickcd, 2 SECONDS)

	H.visible_message(
		span_boldwarning("[H] slips past [A] in a blur and appears at their back!"),
		span_notice("Too slow.")
	)

	return TRUE

// SKD - STOMP
/datum/status_effect/buff/skulduggery/proc/stomp_prone(mob/living/carbon/human/T)
	if(!T) return

	var/mob/living/carbon/human/H = owner
	H.visible_message(
			span_boldwarning("[H] delivers their foot onto [T] while they try to swing!"),
			span_notice("Deserved kick for trying that, fool!")
		)
	H.do_attack_animation(T)
	T.adjustBruteLoss(8)
	T.stamina_add(8)
	H.setDir(get_dir(H, T))

	if(!T.mind)
		T.stamina_add(12)
		T.apply_status_effect(/datum/status_effect/debuff/clickcd, 2 SECONDS)

	addtimer(CALLBACK(T, /mob/proc/slamdunked), 1)
	return TRUE
	
// SKD - GROUND SLAM
/datum/status_effect/buff/skulduggery/proc/slam_target(mob/living/carbon/human/T)
	if(!T) return

	var/mob/living/carbon/human/H = owner

	var/power = H.get_skill_level(/datum/skill/combat/unarmed) + (H.get_skill_level(/datum/skill/magic/holy) / 2)
	var/resist = (T.get_stat(STAT_CONSTITUTION) + T.get_stat(STAT_SPEED)/4)

	var/chance = clamp(50 + (power - resist), 10, 90)
	if(prob(chance))
		H.stop_pulling()
		waiting_followup = FALSE
		grappled = null
		H.visible_message(
			span_boldwarning("[H] turns [T] upside their head and slams them into the ground!"),
			span_notice("<i>I drive them into the floor with sheer skill!</i>")
		)
		H.setDir(get_dir(H, T))
		H.balloon_alert_to_viewers(message = "SKD Slam!!", self_message = "SKD Slam!!", y_offset = 10)
		playsound(get_turf(T), 'sound/combat/wooshes/blunt/wooshhuge (2).ogg', 100, FALSE)
		T.Knockdown(4 SECONDS)
		sleep(3)
		T.apply_status_effect(/datum/status_effect/debuff/clickcd, 4 SECONDS)
		T.adjustBruteLoss(40)
		T.stamina_add(60)
		shake_camera(H, 2, 1)
		shake_camera(T, 2, 1)
		var/da_slam = pick('sound/combat/hits/blunt/genblunt (1).ogg','sound/combat/hits/blunt/genblunt (2).ogg','sound/combat/hits/blunt/genblunt (3).ogg','sound/combat/hits/blunt/flailhit.ogg')
		playsound(T, da_slam, 100, TRUE)
		playsound(T, 'sound/combat/tf2crit.ogg', 100, TRUE)
		if(!T.mind && T.mob_biotypes != MOB_UNDEAD)
			if(prob(50))
				T.Unconscious(800)
	else
		H.visible_message(
			span_warning("[T] resists the slam, forcing [H] to kick them away!"),
			span_notice("They resist my attempt to slam! I have to kick them off!")
		)
		H.balloon_alert_to_viewers(message = "SKD Kick!!", self_message = "SKD Kick!!", y_offset = 10)
		H.setDir(get_dir(H, T))
		playsound(T, 'sound/combat/hits/punch/punch_hard (2).ogg', 100, TRUE)
		T.Knockdown(1 SECONDS)
		var/dir = turn(get_dir(T, H), 180)
		if(dir & (NORTH|SOUTH))
			dir = (dir & NORTH) ? NORTH : SOUTH
		else
			dir = (dir & EAST) ? EAST : WEST
		var/turf/current = get_turf(T)
		for(var/i = 1 to 3)
			var/turf/next = get_step(current, dir)
			if(!next || next.density)
				break
			current = next
		T.throw_at(current, 2, 4)
		waiting_followup = FALSE

	addtimer(CALLBACK(T, /mob/proc/slamdunked), 1)

	grappled = null
	waiting_followup = FALSE

// SKD - SLAM INTO ANOTHER
/datum/status_effect/buff/skulduggery/proc/slam_into(mob/living/carbon/human/other)
	if(!other || !grappled) return

	var/mob/living/carbon/human/H = owner
	var/mob/living/carbon/human/G = grappled

	H.visible_message(
		span_boldwarning("[H] redirects [G] full force into [other]!"),
		span_notice("<i>Consecutive Skulduggery! Hells yae! Bring me more!</i>")
	)
	H.balloon_alert_to_viewers(message = "Consecutive SKD!!", self_message = "Consecutive SKD!!", y_offset = 10)
	H.setDir(get_dir(H, other))
	var/attack_sound = pick('sound/combat/hits/blunt/genblunt (1).ogg','sound/combat/hits/blunt/genblunt (2).ogg','sound/combat/hits/blunt/genblunt (3).ogg','sound/combat/hits/blunt/flailhit.ogg')
	playsound(other, attack_sound, 100, TRUE)

	G.forceMove(get_turf(other))

	G.adjustBruteLoss(30)
	other.adjustBruteLoss(30)
	other.stamina_add(25)

	G.Knockdown(1 SECONDS)
	other.Knockdown(1 SECONDS)

	shake_camera(H, 2, 1)
	shake_camera(G, 2, 1)
	shake_camera(other, 2, 1)

	var/dir = turn(get_dir(other, H), 180)

	if(dir & (NORTH|SOUTH))
		dir = (dir & NORTH) ? NORTH : SOUTH
	else
		dir = (dir & EAST) ? EAST : WEST

	var/turf/current = get_turf(other)

	for(var/i = 1 to 3)
		var/turf/next = get_step(current, dir)
		if(!next || next.density)
			break
		current = next

	other.throw_at(current, 1, 4)
	waiting_followup = FALSE

	addtimer(CALLBACK(src, .proc/_slam_followup, other, G), 0.5)

	grappled = null
	waiting_followup = FALSE

/datum/status_effect/buff/skulduggery/proc/_slam_followup(mob/living/carbon/human/other, mob/living/carbon/human/G)
	if(!other || !G) return

	G.forceMove(get_turf(other))

	var/list/dirs = list(NORTH, SOUTH, EAST, WEST)
	var/turf/T = get_step(G, pick(dirs))
	if(T && !T.density)
		G.forceMove(T)

	addtimer(CALLBACK(G, /mob/proc/slamdunked), 1)
	addtimer(CALLBACK(other, /mob/proc/slamdunked), 1)

	if(!G.mind && G.mob_biotypes != MOB_UNDEAD)
		if(prob(50))
			G.Unconscious(800)

// EFFECTS
/mob/proc/slamdunked()
	var/amp = 6
	animate(src, pixel_x = 0, time = 0)
	for(var/i in 1 to 5)
		animate(src, pixel_x = -amp, time = 1)
		animate(src, pixel_x = amp, time = 1)
		amp = round(amp * 0.6)
	animate(src, pixel_x = 0, time = 2)
