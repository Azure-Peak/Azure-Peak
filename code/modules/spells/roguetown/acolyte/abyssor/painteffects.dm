#define COLOR_LUMINOUS_ABYSSAL_INK   "#006600"

#define INK_MAX_HEAL_STACKS          6
#define INK_STACK_LIFETIME           5 SECONDS
// 1.5 at one stack - 4 at max stacks
// 1.5/2/2.5/3/3.5/4
#define INK_HEAL_BASE                1
#define INK_HEAL_PER_STACK           0.5

/obj/effect/ink_trail
	name = "paint trail"
	desc = "A strange, shimmering paint staining the ground."
	icon = 'icons/mob/actions/abyssormiracles.dmi'
	icon_state = "paint"
	alpha = 255
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_MOB_LAYER

	var/datum/weakref/caster_ref
	var/duration = 8 SECONDS
	var/expiration_timer_id

	/// What buff is given if those attuned to trails walk over this one.
	var/buff_payload = /datum/status_effect/buff/ink_surge
	/// What debuff is given if those NOT attuned to trails walk over this one.
	var/debuff_payload = /datum/status_effect/debuff/ink_clog
	/// Whether trails are consumed when a positive effect is applied.
	var/consume_buff = FALSE
	/// Whether trails are consumed when someone unattuned walks over them.
	var/deny_buff = FALSE

/obj/effect/ink_trail/ex_act()
	return

/obj/effect/ink_trail/Initialize(mapload, mob/living/caster)
	. = ..()
	if(caster)
		caster_ref = WEAKREF(caster)

	src.pixel_x = rand(-4, 4)
	src.pixel_y = rand(-4, 4)
	src.transform = turn(src.transform, pick(0, 90, 180, 270))
	src.alpha = 255

	// We use a filter to make it cheaper for del() to clean these up!
	start_filter_fade()

/obj/effect/ink_trail/proc/start_filter_fade(var/new_duration = duration)
	if(src.filters && src.filters.len)
		src.remove_filter("ink_trail_fade")

	var/list/filter_params = list(
		"type" = "color",
		"color" = list(
			1, 0, 0, 0,
			0, 1, 0, 0,
			0, 0, 1, 0,
			0, 0, 0, 1
		)
	)

	src.add_filter("ink_trail_fade", 1, filter_params)
	if(!src.filters || !src.filters.len)
		return
	var/raw_filter = src.filters[src.filters.len]

	animate(raw_filter, color = list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1), time = new_duration - 3 SECONDS, flags = ANIMATION_RELATIVE)
	animate(color = list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,0.1), time = 3 SECONDS, easing = LINEAR_EASING)
	expiration_timer_id = addtimer(CALLBACK(src, .proc/timed_out), new_duration, TIMER_STOPPABLE)

/obj/effect/ink_trail/proc/timed_out()
	expiration_timer_id = null
	qdel(src)

/obj/effect/ink_trail/proc/refresh_lifetime(var/new_duration = duration)
	if(expiration_timer_id)
		deltimer(expiration_timer_id)
	start_filter_fade(new_duration)

/obj/effect/ink_trail/proc/consume()
	if(expiration_timer_id)
		deltimer(expiration_timer_id)
	expiration_timer_id = null
	qdel(src)

/obj/effect/ink_trail/Crossed(atom/movable/AM)
	. = ..()
	if(!AM.throwing)
		if(isliving(AM))
			trigger_ink_effect(AM)

/obj/effect/ink_trail/proc/trigger_ink_effect(mob/living/L)
	if(!L || L.stat != CONSCIOUS)
		return

	// For efficiency sake, let's only check this if it's actually needed.
	var/mob/living/caster = null
	if(!HAS_TRAIT(L, TRAIT_INK_AFFINITY))
		caster = caster_ref?.resolve()

	if(HAS_TRAIT(L, TRAIT_INK_AFFINITY) || (caster && L == caster))
		if(buff_payload)
			L.apply_status_effect(buff_payload)
			if(consume_buff)
				consume()
	else
		if(debuff_payload)
			L.apply_status_effect(debuff_payload)
		if(deny_buff)
			consume()

// ==========================================
// STATUS EFFECT DEFINITIONS
// ==========================================

/datum/status_effect/buff/ink_surge
	id = "ink_surge"
	duration = 1.5 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/ink_surge

/datum/status_effect/buff/ink_surge/on_apply()
	effectedstats = list(STATKEY_SPD = 1)
	// Makes it ever so slightly easier to sprint around the map with this.
	owner.adjust_nutrition(1)
	owner.energy_add(1)
	return ..()

/datum/status_effect/buff/ink_surge/refresh()
	owner.adjust_nutrition(1)
	owner.energy_add(1)
	return ..()

/datum/status_effect/debuff/ink_clog
	id = "ink_clog"
	duration = 2.5 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/debuff/ink_clog

/datum/status_effect/debuff/ink_clog/on_apply()
	effectedstats = list(STATKEY_SPD = -1)
	owner.blur_eyes(2)
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		// Slight loss of stamina to make chasing down a corridor harder
		C.stamina_add(2)
	return ..()

/atom/movable/screen/alert/status_effect/buff/ink_surge
	name = "Abyssal Sprint"
	desc = "The depths speed my step!"
	icon_state = "buff"

/atom/movable/screen/alert/status_effect/debuff/ink_clog
	name = "Paint Fatigue"
	desc = "Abyssal paints cling to my legs."
	icon_state = "debuff"

/datum/status_effect/debuff/ink_leak
	id = "ink_leak"
	duration = 8 SECONDS
	var/datum/weakref/caster_ref

/datum/status_effect/debuff/ink_leak/on_creation(mob/living/new_owner, mob/living/caster)
	// We always want the caster on the offchance someone is given miracles like this one, but doesn't have paint affinity.
	// We'll see how expensive this is. In the future, maybe it's better to just give them paint affinity when they don't have it, and use a miracle that needs it.
	if(caster)
		caster_ref = WEAKREF(caster)
	. = ..()

/datum/status_effect/debuff/ink_leak/on_apply()
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, .proc/spill_trail)
	to_chat(owner, span_userdanger("Paint oozes from your flesh!"))
	return ..()

/datum/status_effect/debuff/ink_leak/proc/spill_trail(mob/living/victim, turf/old_turf, dir)
	SIGNAL_HANDLER
	if(!old_turf || !isopenturf(old_turf))
		return

	var/mob/living/caster = caster_ref?.resolve()

	var/obj/effect/ink_trail/existing_trail = locate(/obj/effect/ink_trail) in old_turf
	if(existing_trail)
		existing_trail.refresh_lifetime()
	else
		// Note, we do not apply the debuff here to make it less punishing. Otherwise people would lose stamina for every move.
		new /obj/effect/ink_trail(old_turf, caster)

/datum/status_effect/debuff/ink_leak/on_remove()
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
	caster_ref = null
	return ..()

/datum/status_effect/buff/umbral_recovery
	id = "umbral_recovery"
	duration = -1
	tick_interval = 1 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/umbral_recovery
	
	var/stacks = 1
	var/next_decay_time = 0
	var/image/ink_overlay_mesh

/datum/status_effect/buff/umbral_recovery/on_apply()
	. = ..()
	if(ishuman(owner))
		update_ink_visuals()
	
	RegisterSignal(owner, COMSIG_MOB_APPLY_DAMGE, .proc/on_wearer_damaged)
	next_decay_time = world.time + INK_STACK_LIFETIME

/datum/status_effect/buff/umbral_recovery/refresh()
	. = ..()
	if(stacks < INK_MAX_HEAL_STACKS)
		stacks++
		update_ink_visuals()
	next_decay_time = world.time + INK_STACK_LIFETIME

/datum/status_effect/buff/umbral_recovery/proc/on_wearer_damaged(datum/source, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	if(damage <= 0 || stacks <= 0)
		return

	if(prob(30))
		to_chat(owner, span_danger("The impact disrupts your unholy recovery, breaking a layer of ink away!"))
	next_decay_time = 0
	check_decay()

/datum/status_effect/buff/umbral_recovery/tick()
	if(check_decay())
		return

	if(!ishuman(owner) || stacks <= 0)
		return

	var/mob/living/carbon/human/H = owner
	var/healing_amount = INK_HEAL_BASE + (stacks * INK_HEAL_PER_STACK)
	var/obj/effect/temp_visual/heal_rogue/H_heal = new /obj/effect/temp_visual/heal_rogue(get_turf(H))
	H_heal.color = COLOR_LUMINOUS_ABYSSAL_INK
	H.adjustBruteLoss(-healing_amount, 0)
	H.adjustFireLoss(-healing_amount, 0)
	H.adjustOxyLoss(-healing_amount, 0)
	H.adjustToxLoss(-healing_amount, 0)
	H.adjustOrganLoss(ORGAN_SLOT_BRAIN, -healing_amount)
	H.adjustCloneLoss(-healing_amount, 0)
	if(H.blood_volume < BLOOD_VOLUME_NORMAL)
		H.blood_volume = min(H.blood_volume + healing_amount, BLOOD_VOLUME_NORMAL)
	var/list/wCount = H.get_wounds()
	if(wCount.len > 0)
		H.heal_wounds(healing_amount, list(/datum/wound/slash, /datum/wound/puncture, /datum/wound/bite, /datum/wound/bruise, /datum/wound/dynamic))
		H.update_damage_overlays()

/datum/status_effect/buff/umbral_recovery/proc/check_decay()
	if(world.time < next_decay_time)
		return FALSE

	stacks--
	if(stacks <= 0)
		qdel(src)
		return TRUE

	update_ink_visuals()
	next_decay_time = world.time + INK_STACK_LIFETIME
	return FALSE

/datum/status_effect/buff/umbral_recovery/proc/update_ink_visuals()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return

	H.cut_overlay(ink_overlay_mesh)
	if(stacks > 0)
		ink_overlay_mesh = image('icons/mob/moboverlays/paintoverlay.dmi', "paint[stacks]")
		//ink_overlay_mesh.appearance_flags = RESET_COLOR
		H.add_overlay(ink_overlay_mesh)

/datum/status_effect/buff/umbral_recovery/on_remove()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.cut_overlay(ink_overlay_mesh)
	UnregisterSignal(owner, COMSIG_MOB_APPLY_DAMGE)
	return ..()

/atom/movable/screen/alert/status_effect/buff/umbral_recovery
	name = "Umbral Knitting"
	desc = "Pure abyssal ink is surging through my wounds. Taking damage will break down the concentration faster."
	icon_state = "buff"

#undef COLOR_LUMINOUS_ABYSSAL_INK

#undef INK_MAX_HEAL_STACKS
#undef INK_STACK_LIFETIME
#undef INK_HEAL_BASE
#undef INK_HEAL_PER_STACK
