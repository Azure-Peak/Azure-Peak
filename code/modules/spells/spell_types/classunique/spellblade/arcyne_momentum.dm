#define MOMENTUM_FILTER "momentum_glow"
#define MOMENTUM_DECAY_DELAY (8 SECONDS)
#define SECOND_PER_MOMENTUM (6 SECONDS) // Time between each stack lost during decay.

/atom/movable/screen/alert/status_effect/buff/arcyne_momentum
	name = "Arcyne Momentum (0)"
	desc = "Strikes with my bound weapon fuel arcyne power. Build momentum to unleash your power. Melee strikes grant 1 stack every 2 seconds. Certain abilities capable of striking multiple targets grant bonus momentum. Take care not to lose control."
	icon_state = "buff"

/datum/status_effect/buff/arcyne_momentum
	id = "arcyne_momentum"
	alert_type = /atom/movable/screen/alert/status_effect/buff/arcyne_momentum
	duration = -1
	tick_interval = 20
	status_type = STATUS_EFFECT_UNIQUE
	var/stacks = 0
	var/max_stacks = 10
	var/glow_colour = "#4a90d9"
	var/crackle_colour = "#7b5ea7"
	var/overcharge_threshold = 7
	var/overcharge_damage = 4
	var/is_overcharged = FALSE
	var/last_stack_time = 0
	var/last_decay_time = 0
	var/static/mutable_appearance/electricity_overlay
	var/obj/item/bound_weapon
	var/chant

/datum/status_effect/buff/arcyne_momentum/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_LIVING_STATUS_STUN, PROC_REF(on_stunned))
	RegisterSignal(owner, COMSIG_LIVING_STATUS_KNOCKDOWN, PROC_REF(on_knockdown))
	update_alert()

/datum/status_effect/buff/arcyne_momentum/on_remove()
	UnregisterSignal(owner, list(COMSIG_LIVING_STATUS_STUN, COMSIG_LIVING_STATUS_KNOCKDOWN))
	if(is_overcharged)
		owner.cut_overlay(electricity_overlay)
	owner.clear_fullscreen("momentum_strain")
	owner.remove_filter(MOMENTUM_FILTER)
	. = ..()

/datum/status_effect/buff/arcyne_momentum/proc/on_stunned()
	SIGNAL_HANDLER
	if(stacks <= 0)
		return
	stacks = 0
	owner.balloon_alert(owner, "M: 0/[max_stacks]")
	update_visuals()
	update_alert()
	update_spell_buttons()
	to_chat(owner, span_warning("The shock breaks my concentration — all momentum lost!"))

/datum/status_effect/buff/arcyne_momentum/proc/on_knockdown()
	SIGNAL_HANDLER
	if(stacks <= 0)
		return
	stacks = 0
	owner.balloon_alert(owner, "M: 0/[max_stacks]")
	update_visuals()
	update_alert()
	update_spell_buttons()
	to_chat(owner, span_warning("I hit the ground — all momentum lost!"))

/datum/status_effect/buff/arcyne_momentum/proc/add_stacks(amount)
	var/old_stacks = stacks
	stacks = min(stacks + amount, max_stacks)
	last_stack_time = world.time
	if(stacks == old_stacks)
		return
	owner.balloon_alert(owner, "M: [stacks]/[max_stacks]")
	update_visuals()
	update_alert()
	update_spell_buttons()
	if(old_stacks < 3 && stacks >= 3)
		to_chat(owner, span_notice("Arcyne force gathers within me!"))
		playsound(get_turf(owner), 'sound/magic/charging.ogg', 30, TRUE)
	if(old_stacks < 6 && stacks >= 6)
		to_chat(owner, span_warning("Release! I must ACT NOW!"))
		playsound(get_turf(owner), 'sound/magic/charged.ogg', 50, TRUE)
	if(old_stacks < overcharge_threshold && stacks >= overcharge_threshold)
		to_chat(owner, span_boldwarning("POWER! POWER! POWER! UNLEASH! UNLEASH! UNLEASH!"))
		playsound(get_turf(owner), 'sound/magic/charged.ogg', 70, TRUE)

/datum/status_effect/buff/arcyne_momentum/proc/consume_stacks(amount)
	var/consumed = min(stacks, amount)
	stacks = max(stacks - amount, 0)
	owner.balloon_alert(owner, "M: [stacks]/[max_stacks]")
	update_visuals()
	update_alert()
	update_spell_buttons()
	return consumed

/datum/status_effect/buff/arcyne_momentum/proc/consume_all_stacks()
	var/consumed = stacks
	stacks = 0
	owner.balloon_alert(owner, "M: 0/[max_stacks]")
	update_visuals()
	update_alert()
	update_spell_buttons()
	return consumed

/datum/status_effect/buff/arcyne_momentum/proc/update_visuals()
	owner.remove_filter(MOMENTUM_FILTER)
	if(stacks >= overcharge_threshold)
		owner.add_filter(MOMENTUM_FILTER, 2, list("type" = "outline", "color" = crackle_colour, "alpha" = 200, "size" = 2))
	else if(stacks >= 6)
		owner.add_filter(MOMENTUM_FILTER, 2, list("type" = "outline", "color" = crackle_colour, "alpha" = 150, "size" = 2))
	else if(stacks >= 3)
		owner.add_filter(MOMENTUM_FILTER, 2, list("type" = "outline", "color" = glow_colour, "alpha" = 100, "size" = 1))
	if(stacks >= overcharge_threshold)
		if(!is_overcharged)
			enter_overcharge()
	else if(is_overcharged)
		exit_overcharge()
	if(stacks >= overcharge_threshold)
		owner.overlay_fullscreen("momentum_strain", /atom/movable/screen/fullscreen/impaired, 1)
	else if(stacks >= 6)
		owner.overlay_fullscreen("momentum_strain", /atom/movable/screen/fullscreen/impaired, 1)
	else
		owner.clear_fullscreen("momentum_strain")

/datum/status_effect/buff/arcyne_momentum/proc/update_alert()
	if(!linked_alert)
		return
	linked_alert.name = "Arcyne Momentum ([stacks]/[max_stacks])"

/datum/status_effect/buff/arcyne_momentum/proc/update_spell_buttons()
	if(!owner?.mind)
		return
	for(var/obj/effect/proc_holder/spell/S in owner.mind.spell_list)
		if(S.action)
			S.action.UpdateButtonIcon(status_only = TRUE)

/datum/status_effect/buff/arcyne_momentum/tick()
	if(stacks > 0 && world.time - last_stack_time >= MOMENTUM_DECAY_DELAY)
		if(world.time - last_decay_time >= SECOND_PER_MOMENTUM)
			last_decay_time = world.time
			stacks = max(stacks - 1, 0)
			owner.balloon_alert(owner, "M: [stacks]/[max_stacks]")
			update_visuals()
			update_alert()
			update_spell_buttons()
	if(stacks >= overcharge_threshold)
		owner.apply_damage(overcharge_damage, BRUTE, BODY_ZONE_CHEST)
		owner.emote(pick("twitch", "strain"), forced = TRUE)

/datum/status_effect/buff/arcyne_momentum/proc/enter_overcharge()
	is_overcharged = TRUE
	if(!electricity_overlay)
		electricity_overlay = mutable_appearance('icons/effects/effects.dmi', "electricity", EFFECTS_LAYER)
		electricity_overlay.appearance_flags = RESET_COLOR
	owner.add_overlay(electricity_overlay)
	to_chat(owner, span_boldwarning("Electricity crackles across my body as arcyne energy overloads!"))

/datum/status_effect/buff/arcyne_momentum/proc/exit_overcharge()
	is_overcharged = FALSE
	owner.cut_overlay(electricity_overlay)

/proc/get_arcyne_momentum(mob/living/target)
	if(!istype(target))
		return 0
	var/datum/status_effect/buff/arcyne_momentum/M = target.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M)
		return 0
	return M.stacks

#undef MOMENTUM_FILTER
#undef MOMENTUM_DECAY_DELAY
#undef SECOND_PER_MOMENTUM
