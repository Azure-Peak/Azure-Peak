/datum/action/cooldown/spell/fulmination
	button_icon = 'icons/mob/actions/mage_fulgurmancy.dmi'
	name = "Fulmination"
	desc = "Cast down storm on your enemy. Toggle firing mode (Shift+G):\n\
	Heaven's Strike: Call down a single devastating bolt on a target tile, striking the aimed body part for massive damage - doubled against simple-minded creechurs.\n\
	Thunderstrike: Blanket a wide 5x5 area, striking all of it at once for flat damage after a brief warning."
	button_icon_state = "heavens_strike"
	sound = 'sound/magic/lightning.ogg'
	spell_color = GLOW_COLOR_LIGHTNING
	glow_intensity = GLOW_INTENSITY_HIGH
	attunement_school = ASPECT_NAME_FULGURMANCY

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_AOE

	invocations = list("Caelum Feri!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_swingdelay_type = SWINGDELAY_PENALTY
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_MINOR
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 12 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 3
	spell_impact_intensity = SPELL_IMPACT_HIGH

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

	var/hs_damage = 80
	var/hs_npc_simple_damage_mult = 2
	var/hs_telegraph = TELEGRAPH_SKILLSHOT

	var/ts_damage = 60
	var/ts_radius = 2
	var/ts_telegraph = TELEGRAPH_AREA_DENIAL

	var/current_mode = 1
	var/list/modes = list(
		list("name" = "Heaven's Strike", "tag" = "SMITE", "icon" = "heavens_strike", "cost" = SPELLCOST_MAJOR_AOE, "cooldown" = 12 SECONDS, "charge" = CHARGETIME_MAJOR, "invocation" = "Caelum Feri!"),
		list("name" = "Thunderstrike", "tag" = "STORM", "icon" = "thunderstrike", "cost" = SPELLCOST_MAJOR_AOE, "cooldown" = 20 SECONDS, "charge" = CHARGETIME_HEAVY, "invocation" = "Feri Fulmine Hostem!"),
	)

/datum/action/cooldown/spell/fulmination/Grant(mob/grant_to)
	. = ..()
	apply_mode(current_mode)

/datum/action/cooldown/spell/fulmination/proc/apply_mode(index)
	var/list/mode = modes[index]
	button_icon_state = mode["icon"]
	primary_resource_cost = mode["cost"]
	cooldown_time = mode["cooldown"]
	charge_time = mode["charge"]
	invocations = list(mode["invocation"])
	build_all_button_icons()
	update_mode_maptext(mode["tag"])

/datum/action/cooldown/spell/fulmination/toggle_alt_mode(mob/user)
	current_mode = (current_mode % length(modes)) + 1
	apply_mode(current_mode)
	to_chat(user, span_notice("[name]: [modes[current_mode]["name"]] mode."))
	return TRUE

/datum/action/cooldown/spell/fulmination/proc/update_mode_maptext(tag)
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
		holder.maptext_x = 5
		holder.color = GLOW_COLOR_LIGHTNING

/datum/action/cooldown/spell/fulmination/get_spell_statistics(mob/living/user)
	var/list/stats = ..()
	stats += span_info("Damage: [hs_damage] (Heaven's Strike) / [ts_damage] (Thunderstrike, 5x5)")
	stats += span_info("Firing mode (toggle with Shift+G): Heaven's Strike (single devastating bolt, +100% vs simple creechurs) / Thunderstrike (telegraphed 5x5 blast, flat [ts_damage] damage all at once).")
	return stats

/datum/action/cooldown/spell/fulmination/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/centerpoint = get_turf(cast_on)
	if(!centerpoint)
		return FALSE

	var/turf/source_turf = get_turf(H)
	if(centerpoint.z > H.z)
		source_turf = get_step_multiz(source_turf, UP)
	if(centerpoint.z < H.z)
		source_turf = get_step_multiz(source_turf, DOWN)
	if(!(centerpoint in get_hear(cast_range, source_turf)))
		to_chat(H, span_warning("I can't cast where I can't see!"))
		return FALSE

	if(current_mode == 1)
		cast_heavens_strike(centerpoint)
	else
		cast_thunderstrike(centerpoint)
	return TRUE

/datum/action/cooldown/spell/fulmination/proc/cast_heavens_strike(turf/T)
	new /obj/effect/temp_visual/trap/thunderstrike(T, hs_telegraph)
	addtimer(CALLBACK(src, PROC_REF(heavens_strike_damage), T), hs_telegraph)

/datum/action/cooldown/spell/fulmination/proc/heavens_strike_damage(turf/T)
	new /obj/effect/temp_visual/thunderstrike_actual(T)
	playsound(T, 'sound/magic/lightning.ogg', 80)
	T.fire_act()
	for(var/atom/A in T.contents)
		if(!ismob(A))
			A.fire_act()
	var/mob/living/carbon/human/caster = owner
	var/target_zone = caster?.zone_selected || pick(BODY_ZONE_HEAD, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
	for(var/mob/living/L in T.contents)
		if(L.anti_magic_check())
			L.visible_message(span_warning("The lightning fades away around [L]!"))
			playsound(T, 'sound/magic/magic_nulled.ogg', 100)
			continue
		if(spell_guard_check(L, TRUE))
			L.visible_message(span_warning("[L] weathers the lightning strike!"))
			continue
		var/actual_damage = hs_damage
		if(!L.mind && !ishuman(L))
			actual_damage *= hs_npc_simple_damage_mult
		if(istype(caster) && ishuman(L))
			arcyne_strike(caster, L, null, actual_damage, target_zone, \
				BCLASS_BURN, spell_name = "Heaven's Strike", \
				damage_type = BURN, npc_simple_damage_mult = 1, \
				skip_animation = TRUE)
		else
			L.electrocute_act(actual_damage, src, 1, SHOCK_NOSTUN)
		L.electrocute_act(0, src, 1, SHOCK_NOSTUN|SHOCK_VISUAL_ONLY)
		new /obj/effect/temp_visual/spell_impact(get_turf(L), spell_color, spell_impact_intensity)

/datum/action/cooldown/spell/fulmination/proc/cast_thunderstrike(turf/centerpoint)
	for(var/turf/T in range(ts_radius, centerpoint))
		if(!(T in get_hear(ts_radius, centerpoint)))
			continue
		new /obj/effect/temp_visual/pillar_warning/fadein(T, ts_telegraph)
	playsound(centerpoint, 'sound/magic/charging.ogg', 80, TRUE)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(thunderstrike_erupt), centerpoint, owner, ts_radius, ts_damage, src), ts_telegraph)

/proc/thunderstrike_erupt(turf/centerpoint, mob/living/carbon/human/caster, radius = 2, damage = 50, datum/action/cooldown/spell/guard_source, spell_name = "Thunderstrike", mob/living/exclude)
	if(!centerpoint)
		return
	playsound(centerpoint, 'sound/magic/lightning.ogg', 100, TRUE, 8)
	var/static/list/random_zones = list(BODY_ZONE_HEAD, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
	for(var/turf/T in range(radius, centerpoint))
		if(!(T in get_hear(radius, centerpoint)))
			continue
		new /obj/effect/temp_visual/thunderstrike_actual(T)
		T.fire_act()
		for(var/atom/A in T.contents)
			if(!ismob(A))
				A.fire_act()
		for(var/mob/living/L in T.contents)
			if(L == exclude)
				continue
			if(L.anti_magic_check())
				L.visible_message(span_warning("The lightning fades away around [L]!"))
				playsound(T, 'sound/magic/magic_nulled.ogg', 100)
				continue
			if(guard_source && !QDELETED(guard_source) && guard_source.spell_guard_check(L, TRUE))
				L.visible_message(span_warning("[L] weathers the lightning strike!"))
				continue
			if(istype(caster) && !QDELETED(caster) && ishuman(L))
				arcyne_strike(caster, L, null, damage, pick(random_zones), \
					BCLASS_BURN, spell_name = spell_name, \
					damage_type = BURN, npc_simple_damage_mult = 1, \
					skip_animation = TRUE)
			else
				L.electrocute_act(damage, caster, 1, SHOCK_NOSTUN)
			L.electrocute_act(0, caster, 1, SHOCK_NOSTUN|SHOCK_VISUAL_ONLY)
			new /obj/effect/temp_visual/spell_impact(get_turf(L), GLOW_COLOR_LIGHTNING, SPELL_IMPACT_HIGH)
