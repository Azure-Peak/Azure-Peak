#define GEYSER_SPREAD_RADIUS 3

/obj/structure/dream_pylon
	name = "painted pylon"
	desc = "A strange pulsing pylon that seems to be made out of thick, solidified swirls of abyssal paints."
	icon = 'icons/obj/structures/abyssor_pylon.dmi'
	icon_state = "pylon"
	anchored = TRUE
	density = TRUE
	resistance_flags = FIRE_PROOF | ACID_PROOF
	max_integrity = 500

	/// Tracks the active overlay object currently attached to the pylon
	var/obj/effect/pylon_overlay/active_overlay
	/// The typepath of the status effect infusion currently hosted inside this pylon
	var/datum/status_effect/infusion/infusion_payload = /datum/status_effect/infusion/intelligence
	/// Current amount of abyssal energy stored
	var/charge = 100
	/// Max capability reservoir
	var/max_charge = 100
	/// Cost per extraction
	var/charge_cost_per_use = 25
	/// Color hex applied to the central core overlay and player outlines
	var/pylon_color
	/// Whether this pylon can currently be topped up by a replenishment miracle. Resets when infusion changes.
	var/can_recharge = TRUE

/obj/structure/dream_pylon/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Dream pylons with a floating ball of dream energies can be interacted with to receive a buff.")
	. += span_info("Buffs from pylons rapidly decay when out of their range, the pylon will glow red when out of range.")
	. += span_info("You can only benefit from one pylon at a time.")
	. += span_info("You can interact with a pylon to return a buff prematurely.")
	. += span_info("Pylons can be infused by skilled painter abyssorites to restore some charge, once per seed.")
	. += span_info("Inserting a new dream seed will fully recharge a pylon, and allow it to be recharged via infusion again.")
	. += span_info("Pylons with the same infusion type can support said infusion if you step out of range of one, and into another.")

/obj/structure/dream_pylon/Initialize(mapload)
	. = ..()
	update_pylon_appearance()

/obj/structure/dream_pylon/Destroy()
	if(active_overlay)
		qdel(active_overlay)
		active_overlay = null
	return ..()

/obj/structure/dream_pylon/proc/update_pylon_appearance()
	if(charge < charge_cost_per_use)
		set_pylon_overlay(null, null)
	else
		var/chosen_state = pylon_color ? "ball_grey" : "ball"
		set_pylon_overlay('icons/obj/structures/abyssor_pylon.dmi', chosen_state)

/obj/structure/dream_pylon/examine(mob/user)
	. = ..()
	if(charge <= 0 || !infusion_payload)
		. += "\n<span class='warning'>Its central core looks completely hollowed out, awaiting an infusion.</span>"
	else
		var/amount_of_charges = floor(charge / charge_cost_per_use)
		var/infusion_name = initial(infusion_payload.id)
		var/message = (amount_of_charges > 0) ? amount_of_charges : "No"
		. += "\n<span class='notice'>It is imbued with the essence of <b>[infusion_name]</b>. It appears to have <b>[message]</b> uses left.</span>"

/obj/structure/dream_pylon/proc/set_pylon_overlay(new_icon, new_icon_state)
	if(active_overlay)
		cut_overlay(active_overlay)
		qdel(active_overlay)
		active_overlay = null

	if(!new_icon || !new_icon_state)
		return

	var/obj/effect/pylon_overlay/O = new(src)
	O.icon = new_icon
	O.icon_state = new_icon_state
	if(pylon_color)
		O.color = pylon_color
	active_overlay = O
	add_overlay(active_overlay)

/obj/effect/pylon_overlay
	name = "ball"
	desc = "oOOoOOooOOo I'm a spooky abyssal ball OooOoOooooo pondering my orb."
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_OBJ_LAYER

/obj/structure/dream_pylon/interact(mob/living/user)
	if(!istype(user) || user.stat != CONSCIOUS)
		return

	var/datum/status_effect/infusion/existing_effect
	for(var/datum/status_effect/infusion/I in user.status_effects)
		existing_effect = I
		break

	if(existing_effect)
		var/obj/structure/dream_pylon/target_pylon = existing_effect.pylon_ref?.resolve()
		if(target_pylon == src && existing_effect.type == infusion_payload)
			src.visible_message(span_notice("[user] touches [src], rendering their active infusion back into the structure."))
			existing_effect.refund_charge()
			return
		else
			to_chat(user, span_warning("You are already attuned to a pylon's infusion! Clear your mind first."))
			return

	if(charge < charge_cost_per_use)
		to_chat(user, span_warning("The pylon doesn't have enough residual charge left to manifest an infusion."))
		return

	charge = max(0, charge - charge_cost_per_use)
	user.apply_status_effect(infusion_payload, src)
	src.visible_message(span_purple("[user] absorbs a pulsing splash of paint from [src]!"))
	update_pylon_appearance()

/obj/structure/dream_pylon/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/dream_material/dream_seed))
		if(!do_after(user, 1 SECONDS))
			to_chat(user, span_warning("I was interrupted!"))
			return
		var/obj/item/dream_material/dream_seed/seed = I
		seed.apply_to_pylon(src, user)
		return TRUE

	return ..()

/obj/structure/dream_pylon/proc/set_infusion(datum/status_effect/infusion/new_infusion, new_max_charge, new_charge, new_color)
	infusion_payload = new_infusion
	max_charge = new_max_charge
	charge = new_charge
	pylon_color = new_color
	can_recharge = TRUE
	update_pylon_appearance()

/obj/structure/dream_pylon/geyser
	name = "geyser pylon"
	desc = "A strange pylon built to burst forth and saturate its surrounding area with abyssal paint."
	pylon_color = "#333749"
	/// The trail type path created when a projectile lands.
	var/obj/effect/ink_trail/trail_type = /obj/effect/ink_trail
	/// Amount of projectiles launched upon activation.
	var/geyser_projectile_count = 6
	/// Timestamp tracking when the pylon can next be triggered.
	var/next_geyser_use = 0
	/// Cooldown in seconds when a geyser pylon can be next triggered.
	var/geyser_use_cooldown_time = 8 SECONDS

/obj/structure/dream_pylon/geyser/get_mechanics_examine(mob/user)
	. = ..()
	. += span_greentext("Geyser pylons store abyssal energy and erupt into a shower of paint puddles when activated.")
	. += span_greentext("Projectiles phase through living creatures but drop puddles early upon hitting dense structures.")

/obj/structure/dream_pylon/geyser/interact(mob/living/user)
	if(!istype(user) || user.stat != CONSCIOUS)
		return

	if(world.time < next_geyser_use)
		to_chat(user, span_warning("The pylon is still recovering from its last discharge!"))
		return

	if(charge < charge_cost_per_use)
		to_chat(user, span_warning("The pylon doesn't have enough residual charge left to erupt."))
		return

	next_geyser_use = world.time + geyser_use_cooldown_time
	charge = max(0, charge - charge_cost_per_use)
	src.visible_message(span_purple("[user] triggers [src], causing paint to spray everywhere!"))
	erupt_paint()
	update_pylon_appearance()

/obj/structure/dream_pylon/geyser/proc/erupt_paint()
	var/turf/epicenter = get_turf(src)
	if(!epicenter)
		return

	var/list/turf/target_turfs = list()
	for(var/turf/T in range(GEYSER_SPREAD_RADIUS, epicenter))
		if(T != epicenter && !T.density)
			target_turfs += T

	if(!target_turfs.len)
		return

	for(var/i in 1 to geyser_projectile_count)
		var/delay = (i - 1) * 0.1 SECONDS
		addtimer(CALLBACK(src, PROC_REF(fire_geyser_projectile), epicenter, target_turfs), delay)

/obj/structure/dream_pylon/geyser/proc/fire_geyser_projectile(turf/epicenter, list/turf/target_turfs)
	if(QDELETED(src) || !epicenter || !target_turfs.len)
		return

	var/turf/target = pick(target_turfs)
	var/obj/projectile/ink_geyser/P = new(epicenter)
	P.spawn_trail_type = trail_type
	P.color = pylon_color
	P.range = rand(1, 4)
	P.preparePixelProjectile(target, src)
	P.fire()

/obj/structure/dream_pylon/geyser/proc/set_geyser_type(new_trail_type, new_max_charge, new_charge, new_pylon_color, ink_puddle_spawn_amount)
	trail_type = new_trail_type
	max_charge = new_max_charge
	charge = new_charge
	pylon_color = new_pylon_color
	can_recharge = TRUE
	if(ink_puddle_spawn_amount)
		geyser_projectile_count = ink_puddle_spawn_amount
	update_pylon_appearance()

/obj/projectile/ink_geyser
	name = "paint globs"
	icon = 'icons/mob/actions/abyssormiracles.dmi'
	icon_state = "paint_gray"
	pass_flags = PASSMOB // Phases through players to reach its intended target
	speed = 10
	damage = 0
	nodamage = TRUE
	range = 3
	var/obj/effect/ink_trail/spawn_trail_type = /obj/effect/ink_trail

/obj/projectile/ink_geyser/on_hit(atom/target, blocked = 0)
	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		return ..()

	if(target_turf.density || (isobj(target) && target.density))
		var/turf/proj_turf = get_turf(src)
		var/turf/landing_turf
		if(proj_turf == target_turf)
			landing_turf = get_step_towards(target_turf, starting) || get_step(target_turf, turn(dir, 180))
		else
			landing_turf = proj_turf

		if(landing_turf && !landing_turf.density)
			spawn_puddle(landing_turf)
	else
		spawn_puddle(target_turf)

	return ..()

/obj/projectile/ink_geyser/on_range()
	var/turf/T = get_turf(src)
	if(T)
		spawn_puddle(T)
	qdel(src)

/obj/projectile/ink_geyser/proc/spawn_puddle(turf/T)
	if(!T || T.density)
		return

	var/obj/effect/ink_trail/existing = locate(spawn_trail_type) in T
	if(existing)
		existing.refresh_lifetime()
	else
		new spawn_trail_type(T)

/obj/structure/dream_pylon/geyser/healing
	pylon_color = "#b6e6b6"
	trail_type = /obj/effect/ink_trail/healing
	geyser_projectile_count = 12

/obj/structure/dream_pylon/geyser/invigorating
	pylon_color = "#3a86ff"
	trail_type = /obj/effect/ink_trail/invigorating

/obj/structure/dream_pylon/geyser/spiked
	pylon_color = "#580000"
	trail_type = /obj/effect/ink_trail/evil
	geyser_projectile_count = 15

#undef GEYSER_SPREAD_RADIUS
