/obj/effect/visuals/black_ice
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "blackice"
	layer = TURF_LAYER + 1
	density = FALSE
	anchored = TRUE

/obj/item/rogueweapon/spear/dreamscape_trident/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	var/turf/impact_turf = get_turf(hit_atom)
	if(!impact_turf)
		return
	if(world.time < shockwave_cooldown)
		return
	// Calculate distance traveled
	var/distance = throwingdatum ? throwingdatum.dist_travelled : 0
	// Create the shockwave effect
	if(distance >= 3)
		create_shockwave(impact_turf, distance)
		shockwave_cooldown = world.time + shockwave_cooldown_interval

/obj/item/rogueweapon/spear/dreamscape_trident/proc/create_shockwave(turf/epicenter, distance)
	// Alledgedly makes this proc asyncronous, required for this to execute properly
	set waitfor = FALSE
	var/max_radius = min(7, round(distance / shockwave_divisor))
	var/knockup_threshold = 5
	playsound(epicenter, 'sound/magic/lightning.ogg', 60, TRUE)
	var/list/visual_effects = list()

	sleep(5)
	for(var/radius in 1 to max_radius)
		var/list/ring_turfs = get_ring_turfs(epicenter, radius)
		for(var/turf/T in ring_turfs)
			if(T.density)
				continue
			var/obj/effect/visuals/black_ice/V = new(T)
			visual_effects[T] = V

			for(var/mob/living/L in T)
				affect_mob(L, distance, radius, knockup_threshold)
		sleep(5)
	revert_shockwave(epicenter, visual_effects, max_radius)

/obj/item/rogueweapon/spear/dreamscape_trident/proc/revert_shockwave(turf/epicenter, list/visual_effects, max_radius)
	set waitfor = FALSE
	for(var/radius in max_radius to 1 step -1)
		var/list/ring_turfs = get_ring_turfs(epicenter, radius)
		for(var/turf/T in ring_turfs)
			if(visual_effects[T])
				qdel(visual_effects[T])
		sleep(5)
	visual_effects.Cut()

/obj/item/rogueweapon/spear/dreamscape_trident/proc/get_ring_turfs(turf/center, radius)
	var/list/ring_turfs = list()

	if(radius <= 0)
		return list(center)

	// Last time wasn't really a circle so I'm trying something else, more math
	// Long story short, this looks for 1/8th of a circle, then finds the other points of the circle based on that.
	var/x0 = center.x
	var/y0 = center.y
	var/x = radius
	var/y = 0
	var/decision = 1 - x

	while(y <= x)
		// Add all 8 octants
		ring_turfs |= locate(x0 + x, y0 + y, center.z)
		ring_turfs |= locate(x0 - x, y0 + y, center.z)
		ring_turfs |= locate(x0 + x, y0 - y, center.z)
		ring_turfs |= locate(x0 - x, y0 - y, center.z)
		ring_turfs |= locate(x0 + y, y0 + x, center.z)
		ring_turfs |= locate(x0 - y, y0 + x, center.z)
		ring_turfs |= locate(x0 + y, y0 - x, center.z)
		ring_turfs |= locate(x0 - y, y0 - x, center.z)
		y++
		if(decision <= 0)
			decision += 2 * y + 1
		else
			x--
			decision += 2 * (y - x) + 1

	for(var/turf/T in ring_turfs)
		if(!isturf(T))
			ring_turfs -= T
	return ring_turfs

/obj/item/rogueweapon/spear/dreamscape_trident/proc/affect_mob(mob/living/L, distance, radius, threshold)
	if(L.stat == DEAD)
		return

	// Apply effects based on distance and radius from epicenter
	var/effect_strength = 1
	if(distance >= threshold)
		effect_strength = 2
		if(radius <= 2) // Stronger effect closer to center
			effect_strength = 3

	if(shockwave_damage)
		var/damage = round(distance)
		damage += max(0,(18 - (radius*6)))
		// Apply a small ammount of damage considering this is armor piercing damage
		L.adjustBruteLoss(damage)

	// Special knockup effect for strong throws
	if(effect_strength >= 2 && radius <= 3)
		L.Knockdown(1 * effect_strength)
		L.drop_all_held_items()
		knockup_effect(L)
	else
		L.set_resting(TRUE, TRUE)
		L.visible_message(span_warning("[L] looses their footing as the ground shakes!"))

/obj/item/rogueweapon/spear/dreamscape_trident/proc/knockup_effect(mob/living/L)
	// Animation
	animate(L, pixel_y = L.pixel_y + 16, time = 3, easing = SINE_EASING)
	spawn(3)
		animate(L, pixel_y = L.pixel_y - 16, time = 3, easing = SINE_EASING)
		L.visible_message(span_warning("[L] is thrown off their feet by the shockwave!"))
