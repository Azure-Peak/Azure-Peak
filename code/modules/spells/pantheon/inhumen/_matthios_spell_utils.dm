
/datum/action/cooldown/spell/telegraphed_strike/dragons_breath/matthios
	button_icon = 'icons/mob/actions/astratamiracles.dmi'
	name = "Gilded Dragon's Breath"
	desc = "Unleash a wide cone of gilded flame, burning everything in its path and slowing those caught within."
	desc = "Take upon yourself the aspect of Matthios's greatest creation. The dragon was the image he shaped of himself for mankind: proud, free, and terrifying when bothered. Those truly devoted may borrow that aspect and breathe fyre down upon their unenlightened foes."
	button_icon_state = "bolt"
	sound = 'sound/magic/fireball.ogg'
	spell_color = GLOW_COLOR_FIRE
	glow_intensity = GLOW_INTENSITY_HIGH
	attunement_school = null

	invocation_type = INVOCATION_SHOUT
	invocations = list("Roar, flames of mine!")

	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = SPELLCOST_MAJOR_AOE

	cooldown_time = 5 SECONDS
	associated_skill = /datum/skill/magic/holy
	spell_impact_intensity = SPELL_IMPACT_HIGH
	spell_requirements = SPELL_REQUIRES_HUMAN

	damage = 25 // half the damage from the normal one
	strike_damage_type = BURN
	blade_class = BCLASS_BURN
	npc_simple_damage_mult = 2
	committed_strike = TRUE
	interruptible = FALSE
	charging_slowdown = CHARGING_SLOWDOWN_SMALL
	windup_time = TELEGRAPH_AREA_DENIAL
	sweep_step = 0
	strike_sound = 'sound/magic/fireball.ogg'
	detonate_sound = 'sound/misc/explode/incendiary (1).ogg'
	cone_range = 4
	var/slowdown_duration = 3 SECONDS

/datum/action/cooldown/spell/telegraphed_strike/dragons_breath/matthios/cone_rings()
	var/list/rings = list()
	for(var/d in 1 to cone_range)
		var/list/ring = list()
		var/half = max(1, round(d / 2))
		for(var/lat in -half to half)
			ring += list(list(lat, d))
		rings += list(ring)
	return rings

/datum/action/cooldown/spell/telegraphed_strike/dragons_breath/matthios/get_sweep_bands()
	return list(get_pattern_offsets())

/datum/action/cooldown/spell/telegraphed_strike/dragons_breath/matthios/get_pattern_offsets()
	var/list/flat = list()
	for(var/list/ring in cone_rings())
		flat += ring
	return flat

/datum/action/cooldown/spell/telegraphed_strike/dragons_breath/matthios/on_hit_target(mob/living/carbon/human/H, mob/living/L, facing)
	if(HAS_TRAIT(L, TRAIT_FREEMAN) || L.has_status_effect(/datum/status_effect/buff/dragonhide/astrata))
		return // THROUGH THE FIRES AND FLAMES WE CARRY ON!!!

	if(!L.mind || HAS_TRAIT(L, TRAIT_NOBLE))
		if(!L.mind)
			L.Knockdown(3)
		L.Slowdown(slowdown_duration * 3)
		L.adjust_fire_stacks(6)
	else
		L.Slowdown(slowdown_duration)
		L.adjust_fire_stacks(3)
	L.ignite_mob()

/datum/action/cooldown/spell/telegraphed_strike/dragons_breath/matthios/on_impact(mob/living/carbon/human/H, facing, atom/movable/visual)
	var/turf/origin = get_turf(H)
	if(!origin)
		return
	for(var/list/off in get_pattern_offsets())
		var/list/r = rotate_offset(off[1], off[2], facing)
		var/turf/T = locate(origin.x + r[1], origin.y + r[2], origin.z)
		if(!T || T.density)
			continue
		if(stop_at_dense && path_blocked(origin, T))
			continue
		new /obj/effect/temp_visual/gilded_flames(T)
		for(var/atom/movable/A in T)
			if(ismob(A))
				continue
			A.fire_act()

/obj/effect/temp_visual/gilded_flames
	icon = 'icons/effects/fire.dmi'
	icon_state = "3"
	layer = GASFIRE_LAYER
	light_outer_range = LIGHT_RANGE_FIRE
	light_color = LIGHT_COLOR_FIRE
	blend_mode = BLEND_ADD
	duration = 8

///////////////////////////////////////////////////////////////

/datum/action/cooldown/spell/projectile/sacred_flame/matthios
	name = "Gilded Sacred Flame"
	desc = "Emit a bolt of holy fire that sunders a target, setting them on fire and slowing them down for 6 seconds. \
	Damage is increased by 100% versus simple-minded creechurs. \
	The CC effects cannot be reapplied to the same target within 15 seconds."
	fluff_desc = "Astrata's fire, stolen from the Sun-Tyrant by Matthios and given to mankind. Where she commands the flame in service of the divine, Matthios teaches men to wield it for their own mandate. The heavens may claim the fire as theirs, but a free man need only steal what he desires."
	background_icon = 'icons/mob/actions/astratamiracles.dmi'
	button_icon = 'icons/mob/actions/astratamiracles.dmi'
	button_icon_state = "bolt"
	sound = 'sound/magic/lightning.ogg'
	spell_color = GLOW_COLOR_ASTRATA
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = null
	projectile_type = /obj/projectile/magic/sacred_flame
	cast_range = SPELL_RANGE_PROJECTILE
	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = SPELLCOST_MIRACLE
	secondary_resource_type = SPELL_COST_STAMINA
	secondary_resource_cost = SPELLCOST_MAJOR_PROJECTILE
	invocations = list("Judge, heavenly flames!")
	invocation_type = INVOCATION_SHOUT
	ignore_armor_penalty = TRUE
	charge_required = TRUE
	charge_time = CHARGETIME_MAJOR
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/holycharging.ogg'
	cooldown_time = 5 SECONDS
	associated_stat = null
	associated_skill = /datum/skill/magic/holy
	spell_tier = 0
	point_cost = 0
	spell_impact_intensity = SPELL_IMPACT_MEDIUM
	spell_flags = SPELL_PSYDON
	required_items = list(/obj/item/clothing/neck/roguetown/psicross/astrata, /obj/item/clothing/neck/roguetown/psicross/silver/astrata, /obj/item/clothing/neck/roguetown/psicross/undivided, /obj/item/clothing/neck/roguetown/psicross/silver/undivided)

/obj/projectile/magic/sacred_flame/matthios
	name = "bolt of holy fire"
	tracer_type = /obj/effect/projectile/tracer/solar_beam
	muzzle_type = null
	impact_type = null
	hitscan = TRUE
	movement_type = UNSTOPPABLE
	guard_deflectable = TRUE
	expose_caster_on_deflect = TRUE
	damage = 45 // less damage than astrata's own, but better fire stacks
	npc_simple_damage_mult = 2
	damage_type = BURN
	nodamage = FALSE
	speed = 0.3
	flag = "fire"
	light_outer_range = 7

/obj/projectile/magic/sacred_flame/on_hit(target, blocked = FALSE)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] fizzles on contact with [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		if(isliving(target))
			var/mob/living/L = target
			if(out_of_effective_range())
				return
			if(L.has_status_effect(/datum/status_effect/buff/dragonhide/astrata)) // blocked by astrata's shield passively, darn!
				visible_message(span_warning("[src] fizzles on contact with [target]!"))
				playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
				qdel(src)
				return
			if(blocked < 100)
				L.electrocute_act(1, src, 1, SHOCK_NOSTUN)
				if(HAS_TRAIT(L, TRAIT_SILVER_WEAK) || HAS_TRAIT(L, TRAIT_NOBLE))
					L.adjust_fire_stacks(4, /datum/status_effect/fire_handler/fire_stacks/sunder)
					L.Immobilize(0.5 SECONDS)
					L.ignite_mob()
				else
					L.adjust_fire_stacks(4)
					L.Immobilize(0.5 SECONDS)
					L.ignite_mob()
	else if(isatom(target))
		var/atom/A = target
		A.fire_act()
	qdel(src)

///////////////////////////////////////////////////////////////

/datum/action/cooldown/spell/gilded_ward
	button_icon = 'icons/mob/actions/genericmiracles.dmi'
	name = "Gilded Warding Flames"
	desc = "Surrounds an ally with gilded flames. Each flame lashes out when they are struck, burning their attacker before being extinguished."
	fluff_desc = "Why kneel and beg the gods for protection when a man's own will may command the flame? Matthios stole fire from the heavens to prove that what the gods hoard, men may seize. Let the heavens witness: mankind needs no god to shield it."
	button_icon_state = "dblast"
	sound = 'sound/magic/fireball.ogg'
	spell_color = GLOW_COLOR_MATTHIOS
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = null
	click_to_activate = TRUE
	self_cast_possible = TRUE
	cast_range = 7
	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE
	invocations = list("Ward, heavenly flames!")
	invocation_type = INVOCATION_SHOUT
	charge_required = TRUE
	charge_time = 0.5 SECONDS
	cooldown_time = 45 SECONDS
	associated_skill = /datum/skill/magic/holy
	spell_tier = 0
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN
	supports_fellowship_snap = TRUE
	var/orb_count = 5

/datum/action/cooldown/spell/gilded_ward/cast(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	if(!ishuman(cast_on))
		to_chat(owner, span_warning("I can only wreath people in flame!"))
		return FALSE

	var/mob/living/carbon/human/target = cast_on
	target.apply_status_effect(/datum/status_effect/buff/gilded_ward, orb_count)

	return TRUE

/datum/action/cooldown/spell/gilded_ward/get_spell_statistics(mob/living/user)
	var/list/stats = ..()
	stats += span_info("Fellowship Mode (toggle with Shift+G): An off-target cast snaps the flames to your nearest fellowship member in range.")
	return stats

// GILDED WARD STATUS EFFECT

/atom/movable/screen/alert/status_effect/buff/gilded_ward
	name = "Gilded Flames"
	desc = "Gilded flames circle me, lashing out at those who strike me."
	icon_state = "buff"

/datum/status_effect/buff/gilded_ward
	id = "gilded_ward"
	duration = 45 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/gilded_ward
	var/orbs = 5
	var/list/orb_visuals
	var/last_struck_time = 0

/datum/status_effect/buff/gilded_ward/on_creation(mob/living/new_owner, count = 5)
	orbs = count
	return ..()

/datum/status_effect/buff/gilded_ward/on_apply()
	. = ..()
	if(!.)
		return FALSE
	orb_visuals = list()
	RegisterSignals(owner, list(COMSIG_MOB_ITEM_BEING_ATTACKED, COMSIG_MOB_ATTACKED_BY_HAND, COMSIG_ATOM_BULLET_ACT, COMSIG_ATOM_HITBY, COMSIG_ATOM_WAS_ATTACKED), PROC_REF(on_struck))
	for(var/i in 1 to orbs)
		var/obj/effect/gilded_ward_orb/orb = new()
		orb_visuals += orb
		owner.vis_contents += orb
		spin_orb(orb, (i - 1) * (360 / orbs))
	owner.balloon_alert_to_viewers("wreathed in sacred flame!")
	return TRUE

/datum/status_effect/buff/gilded_ward/proc/spin_orb(obj/effect/gilded_ward_orb/orb, phase)
	var/radius = 16
	var/segments = 12
	var/seg_time = 2.2
	orb.pixel_x = round(radius * cos(phase))
	orb.pixel_y = round(radius * sin(phase))
	for(var/s in 1 to segments)
		var/a = phase + (s * (360 / segments))
		if(s == 1)
			animate(orb, pixel_x = round(radius * cos(a)), pixel_y = round(radius * sin(a)), time = seg_time, loop = -1, flags = ANIMATION_PARALLEL)
		else
			animate(pixel_x = round(radius * cos(a)), pixel_y = round(radius * sin(a)), time = seg_time)

/datum/status_effect/buff/gilded_ward/proc/on_struck(datum/source, mob/living/struck, mob/living/attacker, obj/item/weapon)
	SIGNAL_HANDLER
	if(world.time == last_struck_time)
		return
	if(!attacker || attacker == owner)
		return
	if(attacker.has_status_effect(/datum/status_effect/buff/gilded_ward) || attacker.has_status_effect(/datum/status_effect/buff/dragonhide/astrata))
		return // this was a hillarious infinite loop, oops!
	last_struck_time = world.time
	retaliate(attacker)

/datum/status_effect/buff/gilded_ward/proc/retaliate(mob/living/attacker)
	if(orbs <= 0)
		return
	attacker.adjust_fire_stacks(2)
	attacker.ignite_mob()
	attacker.visible_message(span_danger("[attacker] is scorched by the gilded flames surrounding [owner]!"))
	deplete_orb()

/datum/status_effect/buff/gilded_ward/proc/deplete_orb()
	orbs = max(0, orbs - 1)
	if(length(orb_visuals))
		var/obj/effect/spent = orb_visuals[length(orb_visuals)]
		orb_visuals -= spent
		if(owner)
			owner.vis_contents -= spent
		if(!QDELETED(spent))
			qdel(spent)
	if(orbs <= 0)
		owner.remove_status_effect(/datum/status_effect/buff/gilded_ward)

/datum/status_effect/buff/gilded_ward/on_remove()
	UnregisterSignal(owner, list(COMSIG_MOB_ITEM_BEING_ATTACKED, COMSIG_MOB_ATTACKED_BY_HAND, COMSIG_ATOM_BULLET_ACT, COMSIG_ATOM_HITBY, COMSIG_ATOM_WAS_ATTACKED))
	for(var/obj/effect/orb in orb_visuals)
		if(owner)
			owner.vis_contents -= orb
		if(!QDELETED(orb))
			qdel(orb)
	orb_visuals = null
	return ..()

/obj/effect/gilded_ward_orb
	name = "gilded flame"
	icon = 'icons/obj/magic_projectiles.dmi'
	icon_state = "seeker_orb_f"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_MOB_LAYER
	vis_flags = VIS_INHERIT_PLANE

////////////////////////////////////////////////////////////////////////////////////////////////

/atom/movable/screen/alert/status_effect/buff/matthios_loan
	name = "Gilded Loan"
	desc = "Matthios has taken notice of my deeds, allowing me to invest 200 drams of my Devotion to release a free max-powered Mammonite!"
	icon_state = "pom_god"

/datum/status_effect/buff/matthios_loan
	id = "matthios_loan"
	duration = 30 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/matthios_loan

/datum/status_effect/buff/matthios_loan/on_apply()
	. = ..()
	if(!.)
		return FALSE
	to_chat(owner, span_yellow("<i>A comforting weight settles upon your soul as you feel His gaze upon you, evaluating your greed with interest...</i>"))
	return TRUE
