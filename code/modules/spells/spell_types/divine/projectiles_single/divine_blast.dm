/datum/action/cooldown/spell/projectile/divine_blast
	background_icon = 'icons/mob/actions/genericmiracles.dmi'
	button_icon = 'icons/mob/actions/genericmiracles.dmi'
	button_icon_state = "dblast"
	name = "Divine Blast"
	desc = "Release a blast of sheer divine energy at your enemies. Deals more damage to apostates, undead, and simple-minded creatures. Toggle firing mode (Shift+G): Focus or Arc."
	fluff_desc = "Among the first miracles bestowed upon the faithful is the ability to channel their patron's essence into a focused blast of divine power. Though simple in execution, it is a versatile expression of a deity's will, carrying forth a fragment of the patron's true nature."
	sound = 'sound/magic/vlightning.ogg'
	spell_color = GLOW_COLOR_LIGHTNING
	glow_intensity = GLOW_INTENSITY_LOW
	projectile_type = /obj/projectile/energy/divineblast
	cast_range = SPELL_RANGE_PROJECTILE

	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = 25
	invocation_type = INVOCATION_SHOUT
	charge_required = TRUE
	charge_time = CHARGETIME_MAJOR
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_swingdelay_type = SWINGDELAY_PENALTY
	charge_sound = 'sound/magic/charging.ogg'

	cooldown_time = 10 SECONDS
	associated_skill = /datum/skill/magic/holy
	spell_impact_intensity = SPELL_IMPACT_LOW
	spell_requirements = SPELL_REQUIRES_HUMAN
	var/next_bonus_time = 0
	var/current_mode = 1
	var/list/modes = list(
		list("name" = "Focus", "tag" = "FOCUS", "proj" = /obj/projectile/energy/divineblast, "invocation" = "Sakral Strahl!"),
		list("name" = "Arc", "tag" = "ARC", "proj" = /obj/projectile/energy/divineblast/arc, "invocation" = "Sakral Strahl!"),
	)

/obj/projectile/energy/divineblast
	name = "divine blast"
	tracer_type = /obj/effect/projectile/tracer/wormhole
	muzzle_type = null
	impact_type = null
	hitscan = TRUE
	movement_type = UNSTOPPABLE
	light_color = LIGHT_COLOR_WHITE
	damage = 52
	max_range = MAGE_LONG_PROJ_RANGE
	damage_type = BURN
	guard_deflectable = TRUE
	expose_caster_on_deflect = TRUE
	speed = 0.3
	flag = "fire"
	light_outer_range = 4
	color = "#00a3d4"

/obj/projectile/energy/divineblast/arc
	name = "arced divine blast"
	damage = 32
	arcshot = TRUE

/obj/projectile/energy/divineblast/on_hit(target, blocked = FALSE)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] dissipates harmlessly against [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		if(isliving(M))
			var/mob/living/L = M
			if(out_of_effective_range())
				qdel(src)
				return
			if(blocked < 100)
				if(HAS_TRAIT(L, TRAIT_SILVER_WEAK) && !L.has_status_effect(STATUS_EFFECT_ANTIMAGIC))
					L.visible_message("<font color='white'>Divine power rebukes [L]!</font>")
					L.adjust_fire_stacks(2, /datum/status_effect/fire_handler/fire_stacks/divine)
					L.ignite_mob()
				apply_divine_damage(L)
				var/datum/action/cooldown/spell/projectile/divine_blast/S = source_spell
				if(S && S.can_apply_god_bonus())
					apply_god_bonus(L)
					S.consume_god_bonus()
	qdel(src)

/datum/action/cooldown/spell/projectile/divine_blast/proc/can_apply_god_bonus()
	return world.time >= next_bonus_time

/datum/action/cooldown/spell/projectile/divine_blast/proc/consume_god_bonus()
	next_bonus_time = world.time + 30 SECONDS

/obj/projectile/energy/divineblast/proc/apply_divine_damage(mob/living/L)
	var/damage_to_do = damage
	if(L.patron?.type in ALL_INHUMEN_PATRONS)
		damage_to_do += 30
	if(L.patron?.type in OLD_GOD_PATRON)
		damage_to_do += 25
	if(L.mob_biotypes & MOB_UNDEAD)
		damage_to_do += 50
	if(!L.mind)
		damage_to_do += 50
	var/mob/living/carbon/human/caster = firer
	if(L.guard_deflect_spell("Divine Blast", TRUE, caster))
		return
	if(istype(caster) && ishuman(L))
		arcyne_strike(caster, L, null, damage_to_do, def_zone, BCLASS_BURN, PEN_MEDIUM, spell_name = "Divine Blast", damage_type = BURN, npc_simple_damage_mult = 1, skip_animation = TRUE)
	else
		L.apply_damage(damage_to_do, BURN)

/obj/projectile/energy/divineblast/proc/apply_god_bonus(mob/living/L)
	var/mob/living/carbon/human/caster = firer
	if(!istype(caster))
		return

	switch(caster.patron?.type)
		if(/datum/patron/divine/undivided)
			L.adjust_fire_stacks(4, /datum/status_effect/fire_handler/fire_stacks/divine)
			L.ignite_mob()
			L.apply_status_effect(/datum/status_effect/debuff/exposed, 3 SECONDS)
		if(/datum/patron/divine/astrata)
			L.adjust_fire_stacks(4, /datum/status_effect/fire_handler/fire_stacks/divine)
			L.ignite_mob()
			L.apply_status_effect(/datum/status_effect/debuff/exposed, 3 SECONDS)
		if(/datum/patron/divine/noc)
			L.adjust_fire_stacks(4, /datum/status_effect/fire_handler/fire_stacks/divine)
			L.ignite_mob()
			L.apply_status_effect(/datum/status_effect/debuff/exposed, 3 SECONDS)
		if(/datum/patron/divine/dendor)
			L.adjust_fire_stacks(4, /datum/status_effect/fire_handler/fire_stacks/divine)
			L.ignite_mob()
			L.apply_status_effect(/datum/status_effect/debuff/exposed, 3 SECONDS)
		if(/datum/patron/divine/abyssor)
			L.adjust_fire_stacks(4, /datum/status_effect/fire_handler/fire_stacks/divine)
			L.ignite_mob()
			L.apply_status_effect(/datum/status_effect/debuff/exposed, 3 SECONDS)
		if(/datum/patron/divine/ravox)
			L.adjust_fire_stacks(4, /datum/status_effect/fire_handler/fire_stacks/divine)
			L.ignite_mob()
			L.apply_status_effect(/datum/status_effect/debuff/exposed, 3 SECONDS)
		if(/datum/patron/divine/necra)
			L.adjust_fire_stacks(4, /datum/status_effect/fire_handler/fire_stacks/divine)
			L.ignite_mob()
			L.apply_status_effect(/datum/status_effect/debuff/exposed, 3 SECONDS)
		if(/datum/patron/divine/xylix)
			L.adjust_fire_stacks(4, /datum/status_effect/fire_handler/fire_stacks/divine)
			L.ignite_mob()
			L.apply_status_effect(/datum/status_effect/debuff/exposed, 3 SECONDS)
		if(/datum/patron/divine/pestra)
			L.adjust_fire_stacks(4, /datum/status_effect/fire_handler/fire_stacks/divine)
			L.ignite_mob()
			L.apply_status_effect(/datum/status_effect/debuff/exposed, 3 SECONDS)
		if(/datum/patron/divine/malum)
			L.adjust_fire_stacks(4, /datum/status_effect/fire_handler/fire_stacks/divine)
			L.ignite_mob()
			L.apply_status_effect(/datum/status_effect/debuff/exposed, 3 SECONDS)
		if(/datum/patron/divine/eora)
			L.adjust_fire_stacks(4, /datum/status_effect/fire_handler/fire_stacks/divine)
			L.ignite_mob()
			L.apply_status_effect(/datum/status_effect/debuff/exposed, 3 SECONDS)

/datum/action/cooldown/spell/projectile/divine_blast/Grant(mob/grant_to)
	. = ..()
	apply_mode(current_mode)

/datum/action/cooldown/spell/projectile/divine_blast/proc/apply_mode(index)
	var/list/mode = modes[index]
	projectile_type = mode["proj"]
	invocations = list(mode["invocation"])
	update_mode_maptext(mode["tag"])

/datum/action/cooldown/spell/projectile/divine_blast/toggle_arc_mode(mob/user)
	current_mode = (current_mode % length(modes)) + 1
	apply_mode(current_mode)
	to_chat(user, span_notice("[name]: [modes[current_mode]["name"]] mode."))

/datum/action/cooldown/spell/projectile/divine_blast/proc/update_mode_maptext(tag)
	for(var/datum/hud/hud as anything in viewers)
		var/atom/movable/screen/movable/action_button/B = viewers[hud]
		var/atom/movable/screen/arc_maptext_holder/holder
		for(var/atom/movable/screen/arc_maptext_holder/existing in B.vis_contents)
			holder = existing
			break
		if(!holder)
			holder = new(B)
			B.vis_contents.Add(holder)
		holder.maptext = MAPTEXT(tag)
		holder.color = "#00ccff"

/datum/action/cooldown/spell/projectile/divine_blast/get_spell_statistics(mob/living/user)
	var/list/stats = ..()
	stats += span_info("Firing mode (Shift+G): Focus (standard blast) / Arc (lobs over obstacles with reduced damage).")
	return stats
