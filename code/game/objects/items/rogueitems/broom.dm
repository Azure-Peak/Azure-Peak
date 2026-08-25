/obj/item/broom
	name = "broom"
	desc = "A robust-looking broom, made from a bundle of twigs. Sweep a wide swathe of floor clear of debris, glass, blood, dirt, and time without a care in the world."
	icon = 'icons/roguetown/weapons/tools.dmi'
	icon_state = "broom"
	experimental_inhand = TRUE
	possible_item_intents = list(/datum/intent/use, /datum/intent/mace/strike/wood)
	gripped_intents = list(/datum/intent/use, /datum/intent/mace/strike/wood, /datum/intent/spear/thrust/quarterstaff)
	wlength = WLENGTH_LONG
	sharpness = IS_BLUNT
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
	can_parry = TRUE
	associated_skill = /datum/skill/craft/cooking
	force = 10
	force_wielded = 15
	throwforce = 9
	firefuel = 30 MINUTES
	wdefense = 4
	walking_stick = TRUE
	anvilrepair = /datum/skill/craft/carpentry
	smeltresult = /obj/item/ash
	resistance_flags = FLAMMABLE
	var/sweeping = FALSE
	COOLDOWN_DECLARE(twirl_cooldown) // Prevents the twirl from spamming chat.

/obj/item/broom/getonmobprop(tag)
	. = ..()
	if(!tag)
		return
	switch(tag)
		if("gen")
			return list("shrink" = 0.8, "sx" = -6, "sy" = -1, "nx" = 8, "ny" = 0, "wx" = -4, "wy" = 0, "ex" = 2, "ey" = 1, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0, "nturn" = -38, "sturn" = 37, "wturn" = 32, "eturn" = -23, "nflip" = 0, "sflip" = 8, "wflip" = 8, "eflip" = 0)
		if("wielded")
			return list("shrink" = 0.8, "sx" = 4, "sy" = -2, "nx" = -3, "ny" = -2, "wx" = -5, "wy" = -1, "ex" = 3, "ey" = -2, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0, "nturn" = 7, "sturn" = -7, "wturn" = 16, "eturn" = -22, "nflip" = 8, "sflip" = 0, "wflip" = 8, "eflip" = 0)
		if("onback")
			return list("shrink" = 0.8, "sx" = -1, "sy" = 2, "nx" = 0, "ny" = 2, "wx" = 2, "wy" = 1, "ex" = 0, "ey" = 1, "nturn" = 0, "sturn" = 0, "wturn" = 70, "eturn" = 15, "nflip" = 1, "sflip" = 1, "wflip" = 1, "eflip" = 1, "northabove" = 1, "southabove" = 0, "eastabove" = 0, "westabove" = 0)
		if("onbelt")
			return list("shrink" = 0.8, "sx" = -2, "sy" = -5, "nx" = 4, "ny" = -5, "wx" = 0, "wy" = -5, "ex" = 2, "ey" = -5, "nturn" = 0, "sturn" = 0, "wturn" = 0, "eturn" = 0, "nflip" = 0, "sflip" = 0, "wflip" = 0, "eflip" = 0, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0)

/obj/item/broom/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Sweeping time decreases with higher Cooking skill.")
	. += span_info("STRONG intent will make you do a power-sweeping, targeting a 3x3 area!")
	. += span_info("You can twirl [src] by right-clicking it in your hand while in combat mode. Doing so safely requires Expert skill; anything less risks harming yourself.")

/obj/item/broom/rmb_self(mob/user)
	. = ..()
	SpinAnimation(4, 2)
	if(!COOLDOWN_FINISHED(src, twirl_cooldown))
		return
	COOLDOWN_START(src, twirl_cooldown, 3 SECONDS)
	// smack thineself loser nerd
	if(user.get_skill_level(associated_skill) < SKILL_LEVEL_EXPERT && prob(40))
		var/crit = prob(60)
		var/critmsg = " <span class='crit'><b>Critical hit!</b> [user] is knocked out!</span>"
		user.visible_message(span_danger("While trying to twirl [src] [user] flings it instead, hitting [user.p_themselves()] in the head![crit ? critmsg : ""]"), span_userdanger("While trying to twirl [src] you fling it instead, hitting yourself in the head![crit ? critmsg : ""]"))
		var/mob/living/carbon/human/unfortunate_idiot = user
		unfortunate_idiot.apply_damage(src.force, BRUTE, BODY_ZONE_PRECISE_SKULL)
		if(crit)
			unfortunate_idiot.flash_fullscreen("whiteflash3")
			unfortunate_idiot.Unconscious(5 SECONDS)
			playsound(get_turf(unfortunate_idiot), 'sound/combat/tf2crit.ogg', 100, FALSE)
		playsound(get_turf(unfortunate_idiot), 'sound/misc/bonk.ogg', 100, FALSE)
		user.dropItemToGround(src, TRUE)
		return
	user.visible_message(span_notice("[user] twirls [src] in a dramatic flourish!"), span_notice("You twirl [src] dramatically."))
	playsound(src, 'sound/combat/sidesweep_hit.ogg', 20, FALSE)

/obj/item/broom/proc/sweep_time(mob/living/user)
	return max(40 - (user.get_skill_level(associated_skill) * 15), 5)
/obj/item/broom/proc/sweep_move_time(mob/living/user)
	return max(40 - (user.get_skill_level(associated_skill) * 15), 5)

/obj/item/broom/proc/sweep_alive(mob/living/user)
	return !QDELETED(user) && user.stat != DEAD

/obj/item/broom/proc/sweep_message(atom/A, mob/living/user)
	user.visible_message(span_notice("[user] dutifully sweeps \the [A]."), span_notice("I dutifully sweep \the [A]."))

/obj/item/broom/proc/is_sweep_trash(obj/O)
	return istype(O, /obj/effect/decal/cleanable/dirt) \
		|| istype(O, /obj/item/paper/crumpled) \
		|| istype(O, /obj/item/ash) \
		|| istype(O, /obj/item/natural/glass_shard) \
		|| istype(O, /obj/effect/decal/cleanable/debris) \
		|| istype(O, /obj/effect/decal/remains/human)

/obj/item/broom/proc/is_clutter(atom/movable/A)
	return istype(A, /obj/item/natural/stone) \
		|| istype(A, /obj/item/scrap) \
		|| istype(A, /obj/item/paper/crumpled) \
		|| istype(A, /obj/item/grown/log/tree/stick) \
		|| istype(A, /obj/item/ash) \
		|| istype(A, /obj/item/organ) \
		|| istype(A, /obj/item/bodypart) \
		|| istype(A, /obj/item/natural/glass_shard) \
		|| istype(A, /obj/item/natural/cloth) \
		|| istype(A, /obj/item/natural/fibers) \
		|| istype(A, /obj/item/natural/silk) \
		|| istype(A, /obj/item/natural/bone) \
		|| istype(A, /obj/item/natural/bundle) \
		|| istype(A, /obj/item/ammo_casing) \
		|| istype(A, /obj/item/rogueweapon/huntingknife/throwingknife)

/obj/item/broom/attack_obj(obj/O, mob/living/user)
	if(!istype(user.used_intent, /datum/intent/use))
		return ..()
	if(istype(O, /obj/structure/spider/stickyweb))
		O.take_damage(200, BRUTE, "blunt", FALSE)
		playsound(loc, "smashlimb", 50, FALSE)
		return
	if(!do_after(user, sweep_time(user), target = O))
		return
	sweep_message(O, user)
	playsound(user, "clothwipe", 100, TRUE)
	broom_fu(O)

/obj/item/broom/attack_turf(turf/T, mob/living/user)
	if(!istype(user.used_intent, /datum/intent/use))
		return ..()
	if(istype(user.rmb_intent, /datum/rmb_intent/strong))
		sweep_strong(T, user)
		return
	if(istype(T, /turf/open/lava) || istype(T, /turf/open/water))
		return
	if(!do_after(user, sweep_time(user), target = T))
		return
	perform_sweep(T, user, T)

/obj/item/broom/proc/sweep_strong(turf/center, mob/living/user)
	if(!center || !sweep_alive(user) || sweeping)
		return
	sweeping = TRUE
	var/list/tiles = list()
	for(var/turf/T in range(1, center))
		if(T == center || istype(T, /turf/open/lava) || istype(T, /turf/open/water))
			continue
		tiles += T
	// Sweep each surrounding tile in a random order.
	while(length(tiles))
		if(!sweep_alive(user))
			sweeping = FALSE
			return
		var/turf/T = pick_n_take(tiles)
		if(!move_to_sweep(T, user))
			sweeping = FALSE
			return
		if(!do_after(user, sweep_move_time(user), target = T))
			sweeping = FALSE
			return
		if(!sweep_alive(user))
			sweeping = FALSE
			return
		perform_sweep(T, user, center)

	// Return to the original tile before finishing the sweep.
	if(!move_to_sweep(center, user))
		sweeping = FALSE
		return
	if(!do_after(user, sweep_move_time(user), target = center))
		sweeping = FALSE
		return
	if(!sweep_alive(user))
		sweeping = FALSE
		return
	perform_sweep(center, user, center)
	sweeping = FALSE

/obj/item/broom/proc/move_to_sweep(turf/target, mob/living/user)
	var/stuck = 0
	while(user.loc != target)
		if(!sweep_alive(user))
			return FALSE
		var/turf/old_turf = get_turf(user)
		step_to(user, target)
		sleep(1)
		if(get_turf(user) != old_turf)
			playsound(user, "clothwipe", 100, TRUE)
			stuck = 0
			continue
		if(++stuck >= 2)
			return FALSE
	return TRUE

/obj/item/broom/proc/perform_sweep(turf/T, mob/living/user, turf/center)
	sweep_message(T, user)
	sweep_smoke(T)
	playsound(user, 'sound/items/broom_sweep.ogg', 150, TRUE)
	gather_clutter(T, user, center)
	broom_fu(T)
	clean_sweep_turf(T)

/obj/item/broom/proc/clean_sweep_turf(turf/T)
	if(!T)
		return
	wash_atom(T, CLEAN_MEDIUM)
	for(var/atom/A in T)
		if(istype(A, /obj/effect/decal/cleanable) || ismob(A) || (isobj(A) && !istype(A, /obj/effect)))
			wash_atom(A, CLEAN_MEDIUM)

/obj/item/broom/proc/sweep_area(turf/center)
	var/washed = 0
	var/max_washes = 75
	for(var/turf/T in range(1, center))
		if(washed >= max_washes)
			return
		broom_fu(T)
		wash_atom(T, CLEAN_MEDIUM)
		washed++
		for(var/atom/A in T)
			if(washed >= max_washes)
				return
			if(istype(A, /obj/effect/decal/cleanable) || ismob(A) || (isobj(A) && !istype(A, /obj/effect)))
				wash_atom(A, CLEAN_MEDIUM)
				washed++

/obj/item/broom/proc/broom_fu(atom/A)
	var/turf/T = get_turf(A)
	if(!T)
		return
	for(var/obj/O in T.contents)
		if(O.loc == T && is_sweep_trash(O))
			qdel(O)

/obj/item/broom/proc/gather_clutter(turf/T, mob/living/user, turf/center)
	if(!T || !center)
		return
	var/moved = 0
	for(var/atom/movable/A in range(1, T))
		if(moved >= 10)
			break
		if(A.loc == center || QDELETED(A) || !is_clutter(A))
			continue
		A.forceMove(center)
		moved++
	if(moved)
		user.visible_message(span_notice("[user] gathers the clutter into \the [center]."), span_notice("I gather the clutter into \the [center]."))

/obj/item/broom/proc/sweep_smoke(turf/T) // anime is real
	if(!T)
		return
	new /obj/effect/temp_visual/dir_setting/firing_effect/cleanshebling(T)
	var/matrix/small = matrix()
	small.Scale(0.3, 0.3)
	var/obj/effect/particle_effect/thick_steam/left = new(T)
	var/obj/effect/particle_effect/thick_steam/right = new(T)
	left.transform = small
	right.transform = small
	animate(left, pixel_x = -12, pixel_y = 6, transform = matrix(), time = 4, easing = EASE_OUT)
	animate(pixel_x = -24, pixel_y = 0, alpha = 0, transform = matrix() * 1.15, time = 4, easing = SINE_EASING)
	animate(right, pixel_x = 12, pixel_y = 6, transform = matrix(), time = 4, easing = EASE_OUT)
	animate(pixel_x = 24, pixel_y = 0, alpha = 0, transform = matrix() * 1.15, time = 4, easing = SINE_EASING)
	QDEL_IN(left, 7)
	QDEL_IN(right, 7)

/obj/effect/temp_visual/dir_setting/firing_effect/cleanshebling
	icon_state = "shieldsparkles"
	duration = 20
/obj/effect/temp_visual/dir_setting/firing_effect/cleanshebling/Initialize(mapload, set_dir)
	. = ..()
	animate(src, alpha = 0, time = 20)
