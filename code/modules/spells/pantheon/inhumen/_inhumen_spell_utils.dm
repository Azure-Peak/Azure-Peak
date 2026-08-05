#define MAMMON_FILTER "mammon_glow"

////////
//ZIZO//
////////

/atom/movable/screen/alert/status_effect/buff/shadow_eyes
	name = "Clarity in Darkness"
	desc = "In shadows, I see the true path to progress."
	icon_state = "darkvision"

/datum/status_effect/buff/shadow_eyes
	id = "darkvision"
	alert_type = /atom/movable/screen/alert/status_effect/buff/shadow_eyes
	duration = 15 SECONDS
	status_type = STATUS_EFFECT_REFRESH

/datum/status_effect/buff/shadow_eyes/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_NITEVISION, "zizosnuff")
	owner.update_sight()

/datum/status_effect/buff/twinned_gaze/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_NITEVISION, "zizosnuff")
	show_visible_message(owner, "[owner]'s eyes return to normal.", "Your eyes return to normal.")
	owner.update_sight()

/proc/is_missionary(mob/living/user)
	if(!istype(user, /mob/living/carbon/human))
		return FALSE

	var/mob/living/carbon/human/H = user
	if(!H?.advjob)
		return FALSE

	var/datum/advclass/A = SSrole_class_handler.get_advclass_by_name(H.advjob)
	if(istype(A, /datum/advclass/cleric/missionary))
		return TRUE

	return FALSE

/proc/consume_bone_fuel(mob/living/user, amount)
	var/available = 0

	var/list/bundles = list()
	var/list/singles = list()
	var/list/skeletons = list()

	// on hands
	for(var/obj/item/I in user.get_equipped_items())
		if(istype(I, /obj/item/natural/bundle/bone))
			var/obj/item/natural/bundle/bone/B = I
			bundles += B
			available += B.amount

		else if(istype(I, /obj/item/natural/bone))
			singles += I
			available++

	// bones on floor, 2 range
	for(var/obj/item/I in range(2, user))
		if(I.loc == user)
			continue

		if(istype(I, /obj/item/natural/bundle/bone))
			var/obj/item/natural/bundle/bone/B = I
			bundles += B
			available += B.amount

		else if(istype(I, /obj/item/natural/bone))
			singles += I
			available++

	// uses skeletons too, 3 range
	for(var/mob/living/S in range(3, user))
		if(S == user)
			continue

		if(S.mind && !length(S.faction & user.faction))
			continue

		if(iscarbon(S))
			var/mob/living/carbon/C = S
			var/valid = FALSE

			for(var/obj/item/bodypart/BP in C.bodyparts)
				if(BP && BP.body_zone != BODY_ZONE_HEAD)
					valid = TRUE
					break

			if(!valid)
				continue

		skeletons += S
		available++

	// rip
	if(available < amount)
		return FALSE

	var/remaining = amount

	// bundle nommer
	for(var/obj/item/natural/bundle/bone/B in bundles)
		if(remaining <= 0)
			break

		var/to_use = min(remaining, B.amount)
		if(to_use > 0 && B.use(to_use))
			remaining -= to_use

	// bone nommer
	for(var/obj/item/natural/bone/B in singles)
		if(remaining <= 0)
			break

		qdel(B)
		remaining--

	// skeleton nommer
	for(var/mob/living/S in skeletons)
		if(remaining <= 0)
			break

		if(iscarbon(S))
			var/mob/living/carbon/C = S
			var/list/limbs = list()

			for(var/obj/item/bodypart/BP in C.bodyparts)
				if(BP && BP.body_zone != BODY_ZONE_HEAD)
					limbs += BP

			if(length(limbs))
				var/obj/item/bodypart/L = pick(limbs)
				L.dismember()
				user.visible_message(span_purple("[user] violently tears bone from [S]!"),span_purple("I rip a limb from [S]!"))
				remaining--
		else
			S.adjustBruteLoss(90)
			user.visible_message(span_purple("[user] violently siphons necrotic essence from [S]!"),span_purple("I draw power from [S]!"))
			remaining--

	return TRUE

/obj/structure/ritualcircle/profane/melding/proc/meld_corpse(mob/living/user)
	var/turf/T = get_turf(src)
	if(!T)
		active = FALSE
		return

	var/list/valid_bodies = list()

	// COLLECT VALID CORPSES
	for(var/mob/living/carbon/C in T)

		var/is_departed = (!C.key && !C.get_ghost(FALSE, TRUE)) // should prevent PC corpses from being dusted

		if(C.stat != DEAD)
			continue

		if(is_departed || C.mind?.has_antag_datum(/datum/antagonist/skeleton))
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
		active = FALSE
		return
	var/turf/T = get_turf(src)
	if(!T)
		active = FALSE
		return
	if(!do_after(user, 50, src))
		active = FALSE
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
		if(ispath(path, /obj/item/ash)\
		|| ispath(path, /obj/item/ingot/aaslag)\
		|| ispath(path, /obj/item/ingot/bronze)\
		|| ispath(path, /obj/item/ingot/copper)\
		|| ispath(path, /obj/item/ingot/tin)\
		|| ispath(path, /obj/item/ingot/drow)\
		|| ispath(path, /obj/item/ingot/iron))
			return 2

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

	//CLUTTER (basically items we dont care about that litter often)
	if(istype(I, /obj/item/clothing/suit/roguetown/armor/leather)\
	|| istype(I, /obj/item/clothing/head/roguetown/helmet/leather)\
	|| istype(I, /obj/item/clothing/under/roguetown/trou/leather)\
	|| istype(I, /obj/item/clothing/gloves/roguetown/leather)\
	|| istype(I, /obj/item/clothing/wrists/roguetown/bracers/leather)\
	|| istype(I, /obj/item/storage/belt/rogue/pouch)\
	|| istype(I, /obj/item/storage/belt/rogue/leather)\
	|| istype(I, /obj/item/clothing/neck/roguetown/leather)\
	|| istype(I, /obj/item/clothing/neck/roguetown/coif/heavypadding)\
	|| istype(I, /obj/item/clothing/mask/rogue/ragmask)\
	|| istype(I, /obj/item/clothing/suit/roguetown/shirt/shadowshirt/elflock/drowraider)\
	|| istype(I, /obj/item/clothing/under/roguetown/heavy_leather_pants/shadowpants/drowraider)\
	|| istype(I, /obj/item/clothing/suit/roguetown/armor/leather/heavy/shadowvest/drowraider))
		return 1

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
	var/is_npc = (!target.mind && !target.key)

	if(istype(C))
		var/obj/item/bodypart/chest = C.get_bodypart(BODY_ZONE_CHEST)
		if((chest && chest.skeletonized) && is_npc)
			use_rend = TRUE

	// === CONTESTED CHECK ===
	var/user_int = user.get_stat(STATKEY_INT)
	var/target_wil = target.get_stat(STATKEY_WIL)

	// add swing so it's not static
	var/user_roll = user_int + rand(-1, 1)
	var/target_roll = target_wil + rand(-2, 2)

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
	L.Immobilize(duration)
	L.add_filter(SLAM_FILTER, 2, list("type"="outline","color"=outline_color,"alpha"=200,"size"=2))
	L.update_icon()

	to_chat(L, span_userdanger("An unseen force lifts me!"))
	return TRUE

/datum/status_effect/slam_rage/tick()
	if(!isliving(owner) || slam_count >= max_slams)
		return

	var/mob/living/L = owner

	// LIFT
	animate(L, pixel_y = 56, time = 2, easing = SINE_EASING, flags = ANIMATION_RELATIVE | ANIMATION_END_NOW)
	// HANG
	animate(time = 2)
	// SLAM DOWN
	animate(pixel_y = -72, time = 1, easing = QUAD_EASING, flags = ANIMATION_RELATIVE)
	// RECOVER
	animate(pixel_y = 16, time = 1, easing = LINEAR_EASING, flags = ANIMATION_RELATIVE)

	L.flash_fullscreen("redflash3", 1)

	var/damage = 10 + (slam_count * 3)
	L.adjustBruteLoss(damage)

	if(prob(40) && !HAS_TRAIT(L, TRAIT_NOPAIN))
		L.emote("painscream")

	playsound(L.loc, 'sound/combat/hits/onstone/wallhit.ogg', 80, TRUE)

	slam_count++

	if(slam_count == max_slams)
		L.visible_message(
			span_userdanger("[L] is brutally smashed into the ground!"),
			span_userdanger("The final slam crushes me!")
		)

		L.Knockdown(5 SECONDS)
		L.apply_status_effect(/datum/status_effect/debuff/clickcd, 5 SECONDS)

		playsound(get_turf(L), 'sound/combat/wooshes/blunt/wooshhuge (2).ogg', 100, FALSE)
		playsound(get_turf(L), 'sound/combat/tf2crit.ogg', 100, TRUE)

/datum/status_effect/slam_rage/on_remove()
	if(isliving(owner))
		var/mob/living/L = owner
		L.remove_filter(SLAM_FILTER)
		animate(L, pixel_y = 0, time = 0)

#undef SLAM_FILTER

#define ENOCHIAN_FILTER "enochian_rend"

/atom/movable/screen/alert/status_effect/enochian_rend
	name = "Enochian Rend"
	desc = "Invisible force grips and tears at my form!"

/datum/status_effect/enochian_rend
	id = "enochian_rend"
	duration = 3 SECONDS
	tick_interval = 1 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/enochian_rend

	var/outline_color = "#ae00ff"
	var/limbs_removed = FALSE

/datum/status_effect/enochian_rend/on_apply()
	if(!iscarbon(owner))
		return FALSE

	var/mob/living/carbon/C = owner

	C.Immobilize(duration)
	C.add_filter(ENOCHIAN_FILTER, 2, list("type"="outline","color"=outline_color,"alpha"=210,"size"=2))
	C.update_icon()

	to_chat(C, span_userdanger("An unseen force lifts me into the air!"))
	animate(C, pixel_y = 56, time = 2, easing = SINE_EASING, flags = ANIMATION_RELATIVE | ANIMATION_END_NOW)

	return TRUE

/datum/status_effect/enochian_rend/tick()
	if(!iscarbon(owner))
		return

	var/mob/living/carbon/C = owner

	C.flash_fullscreen("redflash3", 1)
	C.adjustBruteLoss(20)

	if(!limbs_removed)
		remove_limbs(C)

/datum/status_effect/enochian_rend/on_remove()
	if(isliving(owner))
		var/mob/living/L = owner
		L.remove_filter(ENOCHIAN_FILTER)
		animate(L, pixel_y = 0, time = 0.2 SECONDS)

	owner.visible_message(span_danger("The unseen force releases [owner]!"))

/datum/status_effect/enochian_rend/proc/remove_limbs(mob/living/carbon/C)
	if(limbs_removed)
		return

	var/obj/item/bodypart/l_arm = C.get_bodypart(BODY_ZONE_L_ARM)
	var/obj/item/bodypart/r_arm = C.get_bodypart(BODY_ZONE_R_ARM)
	var/obj/item/bodypart/l_leg = C.get_bodypart(BODY_ZONE_L_LEG)
	var/obj/item/bodypart/r_leg = C.get_bodypart(BODY_ZONE_R_LEG)

	var/has_arms = (l_arm && r_arm)
	var/has_legs = (l_leg && r_leg)

	if(has_arms)
		C.visible_message(span_userdanger("[C]'s arms are violently torn off by an unseen force!"))
		l_arm.dismember()
		sleep(2)
		r_arm.dismember()

	else if(has_legs)
		C.visible_message(span_userdanger("[C]'s legs are violently torn off by an unseen force!"))
		l_leg.dismember()
		sleep(2)
		r_leg.dismember()

	else
		var/obj/item/bodypart/head = C.get_bodypart(BODY_ZONE_HEAD)
		if(head)
			C.visible_message(span_userdanger("[C]'s head is ripped clean off by the unseen force!"))
			head.dismember()
			C.adjustBruteLoss(200)

	var/obj/effect/temp_visual/dir_setting/bloodsplatter/splatter = new(get_turf(C), pick(GLOB.cardinals))
	splatter.color = "#880000"

	playsound(C.loc, 'sound/magic/repulse.ogg', 90, TRUE)

	limbs_removed = TRUE

#undef ENOCHIAN_FILTER

/obj/item/melee/touch_attack/enochian_force/proc/do_push(mob/living/user, mob/living/target)
	if(!user || !target)
		return

	var/list/thrown = list(target)

	for(var/am in thrown)
		var/atom/movable/AM = am
		if(AM == user || AM.anchored)
			continue

		var/turf/throwtarget = get_edge_target_turf(
			user,
			get_dir(user, get_step_away(AM, user))
		)

		var/dist = get_dist(user, AM)

		if(dist <= 1)
			if(isliving(AM))
				var/mob/living/M = AM
				M.set_resting(TRUE, TRUE)
				M.adjustBruteLoss(20)
				to_chat(M, span_danger("You're slammed into the ground by [user]!"))
		else
			if(isliving(AM))
				var/mob/living/M = AM
				M.set_resting(TRUE, TRUE)
				to_chat(M, span_danger("You're violently repelled by [user]!"))

			AM.safe_throw_at(
				throwtarget,
				CLAMP(6 - (dist - 1), 3, 6),
				1,
				user,
				force = MOVE_FORCE_EXTREMELY_STRONG
			)

	user.visible_message(
		span_notice("[user] releases a violent wave of force, repelling [target]!"),
		span_notice("I violently shove [target] away.")
	)


/obj/item/melee/touch_attack/enochian_force/proc/do_pull(mob/living/user, mob/living/target)
	if(!user || !target)
		return

	var/list/thrown = list(target)

	for(var/am in thrown)
		var/atom/movable/AM = am
		if(AM == user || AM.anchored)
			continue

		var/turf/throwtarget = get_turf(user)
		var/dist = get_dist(user, AM)

		if(dist <= 1)
			if(isliving(AM))
				var/mob/living/M = AM
				M.set_resting(TRUE, TRUE)
				M.adjustBruteLoss(15)
				to_chat(M, span_danger("You're violently crushed into [user]!"))
		else
			if(isliving(AM))
				var/mob/living/M = AM
				M.set_resting(TRUE, TRUE)
				to_chat(M, span_danger("You're dragged toward [user] by unseen force!"))

			AM.safe_throw_at(
				throwtarget,
				CLAMP(6 - (dist - 1), 3, 6),
				1,
				user,
				force = MOVE_FORCE_EXTREMELY_STRONG
			)

	user.visible_message(
		span_notice("[user] clenches their hand, dragging [target] forward!"),
		span_notice("I pull [target] toward me.")
	)

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

/atom/movable/screen/alert/status_effect/buff/rat_hack
	name = "Rous Bribling"
	desc = span_notice("Negotiations with the rous workforce are underway. Your cheesy bribes are making them very agreeable on the moment.")
	icon_state = "buff"

/datum/status_effect/buff/rat_hack
	id = "rat_hack"
	duration = 3 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/buff/rat_hack
	status_type = STATUS_EFFECT_REFRESH
	tick_interval = 1 SECONDS
	var/turf/origin_turf

/datum/status_effect/buff/rat_hack/on_creation(mob/living/new_owner, ...)
	origin_turf = get_turf(new_owner)
	ADD_TRAIT(new_owner, TRAIT_FOOD_STIPEND, "hackerman")
	ADD_TRAIT(new_owner, TRAIT_GARRISON_ITEM, "hackerman")
	. = ..()

/datum/status_effect/buff/rat_hack/tick()
	if(!owner)
		return
	if(get_turf(owner) != origin_turf)
		to_chat(owner, span_warning("You hastily pull the doohickey away, scattering some cheese around!"))
		qdel(src)

/datum/status_effect/buff/rat_hack/on_remove()
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
				if(P.hallucination <= 200)
					P.hallucination += 50
				ADD_TRAIT(P, TRAIT_PSYCHOSIS, "rite")

		// --- BEAMS RESET ---
		for(var/datum/beam/B in active_beams)
			if(B) B.End()
		active_beams.Cut()

		for(var/mob/living/P in active)
			active_beams += T.Beam(P, icon_state = "drainbeam", time = 6 SECONDS, maxdistance = 10)

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
	//clown emoji
	"We live in a Zociety...",
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
/datum/action/cooldown/spell/zizo/rituos/proc/run_ritual_chant(mob/living/carbon/human/user, path_choice)
	var/list/chant_lines

	switch(path_choice)
		if("Progress")
			chant_lines = list(
				",w ZIZO! ZIZO! ZIZO! GRANT ME INSIGHT UNSHACKLED!",
				",w STRIP ME OF STAGNATION AND IGNORANCE!",
				",w BREAK THE CHAINS OF FALSE UNDERSTANDING!",
				",w LET REVELATION FLOOD THIS FRAIL MIND!",
				",w I OFFER THIS MIND TO COMPLETE THY WORK!",
			)

		if("Unlife")
			chant_lines = list(
				",w ZIZO! ZIZO! ZIZO! FLENSE FLESH FROM MY BONE!",
				",w STRIP ME OF MORTALITY'S SHACKLE!",
				",w LET THIS FRAIL MORTALITY FALL AWAY FROM PURPOSE!",
				",w REMAKE ME IN DEATH'S ENDURING IMAGE!",
				",w I OFFER THIS VESSEL TO COMPLETE THY WORK!",
			)

	for(var/i in 1 to length(chant_lines))
		user.say(chant_lines[i], forced = "spell", language = /datum/language/common)
		user.adjustBruteLoss(15)
		user.emote(pick("Progress" ? list("whimper", "painmoan", "gag", "choke") : list("painscream", "superagony", "paincrit", "choke")))
		if(i > 1)
			shake_camera(user, min(i * 2, 3), i)

		if(!do_after(user, 3 SECONDS, target = user))
			to_chat(user, span_warning("The ritual collapses. Zizo's gaze turns away."))
			return FALSE

	return TRUE

/datum/action/cooldown/spell/zizo/rituos/proc/apply_progress_path(mob/living/carbon/human/user)
	user.adjust_skillrank(/datum/skill/magic/arcane, 3, TRUE)

	if(user.mind)
		user.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 6))
		new /obj/effect/temp_visual/zizorite(get_turf(user))
		ADD_TRAIT(user, TRAIT_STEELHEARTED, "[type]")
		ADD_TRAIT(user, TRAIT_JACKOFALLTRADES, "[type]")
		ADD_TRAIT(user, TRAIT_SELF_SUSTENANCE, "[type]")
		ADD_TRAIT(user, TRAIT_UNLYCKERABLE, "[type]")
		grant_poke_spell(user)

	user.visible_message(
		span_boldwarning("Arcyne runes sear themselves across [user]'s skin, glowing with a sickly light before fading beneath the flesh!"),
		span_notice("THE LESSER WORK IS DONE! Arcyne knowledge floods my mind - I can see the threads of magic itself!")
	)

	to_chat(user, span_purple("You have performed the Rituos to perfection. By all rights, you should now be a full-fledged Magos... and yet..."))
	sleep(30)
	to_chat(user, "<i>...Why do I still struggle to comprehend anything beyond a mere grasp of the arcane? What am I missing?</i>")

/datum/action/cooldown/spell/zizo/rituos/proc/apply_unlife_path(mob/living/carbon/human/user)

	user.mob_biotypes |= MOB_UNDEAD

	ADD_TRAIT(user, TRAIT_NOMOOD, "[type]")
	ADD_TRAIT(user, TRAIT_NOPAIN, "[type]")
	ADD_TRAIT(user, TRAIT_NOHUNGER, "[type]")
	ADD_TRAIT(user, TRAIT_NOBREATH, "[type]")
	ADD_TRAIT(user, TRAIT_TOXIMMUNE, "[type]")
	ADD_TRAIT(user, TRAIT_BLOODLOSS_IMMUNE, "[type]")
	ADD_TRAIT(user, TRAIT_LIMBATTACHMENT, "[type]")
	ADD_TRAIT(user, TRAIT_ZOMBIE_IMMUNE, "[type]")
	ADD_TRAIT(user, TRAIT_SILVER_WEAK, "[type]")
	ADD_TRAIT(user, TRAIT_UNLYCKERABLE, "[type]")

	for(var/obj/item/bodypart/part in user.bodyparts)
		if(istype(part, /obj/item/bodypart/head))
			continue

		part.skeletonize(FALSE)
		user.update_body_parts()
		playsound(user.loc, 'sound/misc/smelter_sound.ogg', 50, FALSE)
		new /obj/effect/temp_visual/zizorite(get_turf(user))
		sleep(15)

	var/obj/item/bodypart/torso = user.get_bodypart(BODY_ZONE_CHEST)
	playsound(user.loc, 'sound/misc/lava_death.ogg', 100, FALSE)
	torso?.skeletonize(FALSE)

	var/obj/item/organ/eyes/eyes = user.getorganslot(ORGAN_SLOT_EYES)
	if(eyes)
		eyes.Remove(user,1)
		QDEL_NULL(eyes)
	eyes = SSwardrobe.provide_type(/obj/item/organ/eyes/night_vision/zombie)
	eyes.Insert(user)
	user.update_body_parts()

	user.adjust_skillrank(/datum/skill/magic/arcane, 3, TRUE)

	if(user.mind)
		user.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 4))
		user.mind.AddSpell(new /datum/action/cooldown/spell/bonechill)
		user.mind.AddSpell(new /datum/action/cooldown/spell/bonemend)
		grant_poke_spell(user)

	user.visible_message(
		span_boldwarning("[user]'s flesh burns away in necrotic flames, revealing bone beneath as they are consumed by the Lesser Work!"),
		span_notice("THE LESSER WORK IS DONE! My flesh is forfeit - and death itself answers my call!")
	)

	to_chat(user, span_purple("You have performed the Rituos to perfection. You should be a full-fledged Lich by now... and yet..."))
	sleep(30)
	to_chat(user, "<i>...Vestiges of mortality still cling to me...? Why?</i>")

/mob/living/carbon/human/proc/zizo_spam_rejection()
	visible_message(span_userdanger("[src]'s body suddenly convulses as the Lesser Work reaches completion!<br>"), span_userdanger("The Work collapses in on itself...! Something has gone terribly WRONG!<br>"))
	to_chat(src, span_artery("<br><br>OH. IT'S YOU.<br><br>"))
	src.playsound_local(get_turf(src), 'sound/magic/scryed_on.ogg', 200)
	if(!HAS_TRAIT(src, TRAIT_NOMOOD))
		src.freak_out()
	sleep(30)
	to_chat(src, span_purple("DO YOU THINK I DON'T NOTICE?<br><br>"))
	sleep(20)
	to_chat(src, span_purple("PATHETIC.<br><br>"))
	sleep(20)
	to_chat(src, span_purple("YOU ARE NOT CLEVER. YOU ARE INSOLENT.<br><br>"))
	sleep(20)
	to_chat(src, span_purple("AND I HATE INSOLENT THINGS.<br><br>"))
	sleep(20)
	to_chat(src, span_purple("KINDLY, UNDO YOURSELF."))
	new /obj/effect/temp_visual/zizorite(get_turf(src))
	Stun(100)
	Knockdown(100)
	emote("superagony")
	src.playsound_local(get_turf(src), 'sound/magic/scryed_on.ogg', 200)
	playsound(get_turf(src), 'sound/misc/zizo.ogg', 200)
	to_chat(src, span_userdanger("--MY LUX- NO-! SHE SEES IT! SHE SEES WHAT I TRIED TO DO-!! SHIT!!!"))
	ADD_TRAIT(src, TRAIT_DNR, "zizo_rejection")
	sleep(50)
	new /obj/effect/temp_visual/zizorite(get_turf(src))
	playsound(get_turf(src), 'sound/magic/churn.ogg', 200)
	playsound(get_turf(src), 'sound/combat/dismemberment/dismem (2).ogg', 100)
	visible_message(span_userdanger("[src] suddenly explodes into a pile or gore and remains!"), span_artery("The Lesser Work rejects you entirely. A hopeful lesson for another timeline."))
	gib()

/mob/living/carbon/human/proc/zizo_vampire_rejection()
	visible_message(span_userdanger("[src]'s body suddenly convulses as the Lesser Work reaches completion!<br>"),
	span_userdanger("The Work rejects my cursed blood!<br>"))
	src.playsound_local(get_turf(src), 'sound/magic/scryed_on.ogg', 200)
	if(!HAS_TRAIT(src, TRAIT_NOMOOD))
		src.freak_out()
	to_chat(src, span_purple("<br><br>OH. WONDERFUL. I KNOW WHAT YOU ARE ATTEMPTING.<br><br>"))
	sleep(40)
	to_chat(src, span_purple("YOU THINK SO LITTLE OF MY WORK? INSOLENT FOOL.<br><br>"))
	sleep(15)
	to_chat(src, span_purple("YOU HAVE NOT DISCOVERED SOME HIDDEN TRUTH.<br><br>"))
	sleep(15)
	to_chat(src, span_purple("YOU HAVE NOT FOUND A LOOPHOLE.<br><br>"))
	sleep(15)
	to_chat(src, span_purple("YOU HAVE NOT OUTWITTED ME.<br><br>"))
	sleep(15)
	to_chat(src, span_purple("YOU HAVE MERELY WASTED MY TIME.<br><br>"))
	sleep(20)
	to_chat(src, span_purple("MY PRECIOUS TIME.<br><br>"))
	sleep(20)
	to_chat(src, span_purple("SO. ALLOW ME TO REPAY THE FAVOR."))
	new /obj/effect/temp_visual/zizorite(get_turf(src))
	Stun(40)
	Knockdown(40)
	emote("superagony")
	src.playsound_local(get_turf(src), 'sound/magic/scryed_on.ogg', 200)
	playsound(get_turf(src), 'sound/misc/zizo.ogg', 200)
	to_chat(src, span_userdanger("--MY LUX IS BEING TORN OFF THROUGH MY HEAD!! MY HEAD!! MYHEADMYHEADMYHEADMYHEADMYHEHEAHEHEA!!"))
	ADD_TRAIT(src, TRAIT_DNR, "zizo_rejection")
	sleep(50)
	new /obj/effect/temp_visual/zizorite(get_turf(src))
	playsound(get_turf(src), 'sound/magic/churn.ogg', 200)
	playsound(get_turf(src), 'sound/combat/dismemberment/dismem (2).ogg', 100)
	var/obj/item/bodypart/head = get_bodypart(BODY_ZONE_HEAD)
	head?.skeletonize(TRUE)
	update_body()
	visible_message(span_userdanger("[src] SCREAMS in UNBELIEVABLE AGONY as their face is torn away, leaving only a hollow skull..."), span_artery("The Lesser Work rejects you entirely. A hopeful lesson for another timeline."))
	sleep(20)
	visible_message(span_userdanger("Their Lux has been completely and utterly annihilated..."), span_userdanger("Your lux has been completely and utterly annihilated..."))
	sleep(100) //Give everyone a good window to be traumatised horribly + clear away death screen, for that EXTRA spite of spite
	new /obj/effect/temp_visual/zizorite(get_turf(src))
	playsound(get_turf(src), 'sound/magic/churn.ogg', 200)
	playsound(get_turf(src), 'sound/combat/dismemberment/dismem (2).ogg', 100)
	visible_message(span_userdanger("[src] suddenly explodes into a pile or gore and remains!"))
	gib()

////////////
//MATTHIOS//
////////////

//Mammonite Utils

/datum/action/cooldown/spell/matthios/mammonite/proc/get_investment_range(mob/living/carbon/human/H)
	var/min_invest = min_mammon
	var/max_invest = min_mammon
	switch(H.rmb_intent.type)
		if(/datum/rmb_intent/swift)
			max_invest = 20
		if(/datum/rmb_intent/riposte) // "defend"
			min_invest = 20
			max_invest = 40
		if(/datum/rmb_intent/feint)
			min_invest = 40
			max_invest = 60
		if(/datum/rmb_intent/aimed)
			min_invest = 60
			max_invest = 80
		if(/datum/rmb_intent/strong)
			min_invest = 80
			max_invest = max_mammon
	return list(min_invest, max_invest)

/datum/action/cooldown/spell/matthios/mammonite/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE

	if(!ishuman(owner))
		return FALSE

	var/mob/living/carbon/human/H = owner

	var/bank = 0
	if(SStreasury.has_account(H))
		bank = SStreasury.get_balance(H)

	var/onhand = get_mammons_in_atom(H)
	var/total = bank + onhand
	var/list/range = get_investment_range(H)
	var/min_invest = range[1]

	if(total < min_invest)
		if(feedback)
			to_chat(H, span_warning("I lack the wealth to invoke Matthios' favor... ([min_invest] mammon needed for [H.rmb_intent.name] stance.)"))
		return FALSE

	return TRUE

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

/atom/movable/screen/alert/status_effect/debuff/doomed
	name = "Doom"
	desc = "You have precisely 3 seconds to live. See you on the other side."
	icon_state = "permadeath"

/datum/status_effect/debuff/doom
	id = "doom"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/doomed
	duration = 3 SECONDS
	status_type = STATUS_EFFECT_UNIQUE

/datum/status_effect/debuff/doom/on_apply()
	. = ..()
	owner.add_filter(MAMMON_FILTER, 2, list("type" = "outline", "color" = "#911096ff", "alpha" = 175, "size" = 2))

/datum/status_effect/debuff/doom/on_remove()
	. = ..()
	var/mob/living/L = owner
	if(!istype(L))
		return
	L.gib()

/atom/movable/screen/alert/status_effect/buff/mammonite
	name = "Mammonite Strike"
	desc = "My next strike is empowered by wealth."
	icon_state = "buff"

/datum/status_effect/buff/mammonite
	id = "mammonite"
	alert_type = /atom/movable/screen/alert/status_effect/buff/mammonite
	duration = 20 SECONDS
	status_type = STATUS_EFFECT_UNIQUE
	var/bonus_damage
	var/cap

/datum/status_effect/buff/mammonite/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_attack))
	RegisterSignal(owner, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, PROC_REF(on_unarmed_attack))
	owner.add_filter(MAMMON_FILTER, 2, list("type" = "outline", "color" = "#d4af37", "alpha" = 175, "size" = 2))

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
	if(should_mammon_gib(target))
		do_mammon_execution(target) // only works vs NPCs! Knocks them back and chance to gib them if you spent over 80 mammon on this (guaranteed if over half the max_cap).
	else
		do_mammon_strike(target, weapon)
	consume()

/datum/status_effect/buff/mammonite/proc/should_mammon_gib(mob/living/target)
	if(target.mind)
		return FALSE
	var/mammon_spent = round(bonus_damage / 3)
	if(mammon_spent <= 79)
		return FALSE
	var/mid_cap = cap * 0.5
	var/gib_chance
	if(mammon_spent >= mid_cap)
		gib_chance = 100
	else
		gib_chance = 20 + (mammon_spent - 80) * (80 / (mid_cap - 80))
	gib_chance = clamp(gib_chance, 20, 100)
	return prob(gib_chance)

/datum/status_effect/buff/mammonite/proc/do_mammon_execution(mob/living/target)
	if(QDELETED(owner) || QDELETED(target))
		return
	owner.visible_message(span_boldwarning("[target] suddenly contorts, twists and lets out a blood-curling screech--!"), span_notice("Their life was worth less than the investment."))
	target.emote("superagony")
	mammon_coin_burst(get_turf(target))
	playsound(get_turf(target), 'sound/combat/hits/burn (2).ogg', 60, TRUE)
	target.apply_status_effect(/datum/status_effect/debuff/doom)
	target.safe_throw_at(target, 3, 1, owner, force = MOVE_FORCE_EXTREMELY_STRONG)

/datum/status_effect/buff/mammonite/proc/do_mammon_strike(mob/living/target, obj/item/weapon)
	if(QDELETED(owner) || QDELETED(target))
		return

	var/damage = bonus_damage
	var/npc_mult = target.mind ? 1 : 2
	var/apen = damage * 0.75

	arcyne_strike(owner, target, weapon, damage, owner.zone_selected, BCLASS_SMASH, apen, "Mammonite", FALSE, FALSE, FALSE, BRUTE, npc_mult, 1)
	owner.visible_message(span_danger("[owner]'s strike crashes down with the weight of greed!"), span_notice("My investment pays off in full!"))
	mammon_coin_burst(get_turf(target))
	playsound(get_turf(target), 'sound/combat/hits/burn (2).ogg', 60, TRUE)

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
	animate(src, pixel_x = pixel_x + rand(-16,16), pixel_y = pixel_y + rand(8,20), alpha = 0, time = duration, easing = EASE_OUT)

#undef MAMMON_FILTER
