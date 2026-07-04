#define BATTLE_WARD_RUNE_DURATION (1 MINUTES)
#define BATTLE_WARD_TELEGRAPH_TIME (3 SECONDS)

/datum/action/cooldown/spell/battle_ward
	button_icon = 'icons/mob/actions/mage_battlewardry.dmi'
	name = "Battle Ward"
	desc = "Channel arcyne energy to inscribe a pattern of five rune wards in an X formation on a targeted area. The runes are fragile and last for one minute before fading. In addition, Battle Wards are indiscriminate unlike permanent Rune Wards, and will hit the caster and their allies. They can be circumvented by jumping or flying over them, or destroyed with a few solid hits. The type of rune placed depends on your current ward mode.\n\
	Use the Alt Mode keybind to cycle between Stun, Fire, Chill, and Damage."
	button_icon_state = "battle_ward"
	sound = 'sound/magic/charging.ogg'
	spell_color = GLOW_COLOR_WARD
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_BATTLEWARDRY

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = FALSE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_AOE

	invocations = list("Bellitutela Inscriptum!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = CHARGETIME_HEAVY
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 20 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/ward_mode = RUNE_WARD_STUN
	var/list/ward_modes = list(RUNE_WARD_STUN, RUNE_WARD_FIRE, RUNE_WARD_CHILL, RUNE_WARD_DAMAGE)
	var/static/list/ward_mode_labels = list(RUNE_WARD_STUN = "STUN", RUNE_WARD_FIRE = "FIRE", RUNE_WARD_CHILL = "CHILL", RUNE_WARD_DAMAGE = "DMG")

/datum/action/cooldown/spell/battle_ward/Grant(mob/grant_to)
	. = ..()
	update_ward_maptext()

/datum/action/cooldown/spell/battle_ward/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/center = get_turf(cast_on)
	if(!center)
		return FALSE

	var/rune_path = get_rune_path()
	if(!rune_path)
		return FALSE

	// X pattern: center + 4 corners
	var/list/target_turfs = list()
	target_turfs += center
	target_turfs += get_step(center, NORTHWEST)
	target_turfs += get_step(center, NORTHEAST)
	target_turfs += get_step(center, SOUTHWEST)
	target_turfs += get_step(center, SOUTHEAST)

	// Show telegraph visuals before runes appear
	for(var/turf/T in target_turfs)
		new /obj/effect/temp_visual/trap_wall/battle_ward(T)

	playsound(center, 'sound/magic/whiteflame.ogg', 60, TRUE)
	H.visible_message(span_warning("[H] completes a complex inscription - runes begin to materialize!"), span_notice("I finish inscribing the [ward_mode] ward pattern."))

	addtimer(CALLBACK(src, PROC_REF(spawn_runes), target_turfs, rune_path, H.real_name, H.ckey || "no ckey"), BATTLE_WARD_TELEGRAPH_TIME)
	return TRUE

/datum/action/cooldown/spell/battle_ward/proc/spawn_runes(list/turfs, rune_path, caster_name, caster_ckey)
	for(var/turf/T in turfs)
		var/obj/structure/rune_ward/rune = new rune_path(T)
		rune.owner_name = caster_name
		rune.owner_ckey = caster_ckey
		rune.max_integrity = 50
		rune.obj_integrity = 50
		QDEL_IN(rune, BATTLE_WARD_RUNE_DURATION)

/datum/action/cooldown/spell/battle_ward/proc/get_rune_path()
	switch(ward_mode)
		if(RUNE_WARD_STUN)
			return /obj/structure/rune_ward/stun
		if(RUNE_WARD_FIRE)
			return /obj/structure/rune_ward/fire
		if(RUNE_WARD_CHILL)
			return /obj/structure/rune_ward/chill
		if(RUNE_WARD_DAMAGE)
			return /obj/structure/rune_ward/damage
	return null

/datum/action/cooldown/spell/battle_ward/toggle_alt_mode(mob/user)
	var/current_index = ward_modes.Find(ward_mode)
	current_index = (current_index % length(ward_modes)) + 1
	ward_mode = ward_modes[current_index]
	var/label = ward_mode_labels[ward_mode] || uppertext(ward_mode)
	to_chat(user, span_notice("Ward mode set to: [label]."))
	update_ward_maptext()
	return TRUE

/datum/action/cooldown/spell/battle_ward/proc/update_ward_maptext()
	var/label = ward_mode_labels[ward_mode]
	for(var/datum/hud/hud as anything in viewers)
		var/atom/movable/screen/movable/action_button/B = viewers[hud]
		var/atom/movable/screen/arc_maptext_holder/holder
		for(var/atom/movable/screen/arc_maptext_holder/existing in B.vis_contents)
			holder = existing
			break
		if(!holder)
			holder = new(B)
			B.vis_contents.Add(holder)
		holder.maptext = MAPTEXT(label)
		holder.maptext_x = 5
		holder.color = GLOW_COLOR_WARD

/obj/effect/temp_visual/trap_wall/battle_ward
	color = GLOW_COLOR_WARD
	light_color = GLOW_COLOR_WARD
	duration = BATTLE_WARD_TELEGRAPH_TIME

#undef BATTLE_WARD_RUNE_DURATION
#undef BATTLE_WARD_TELEGRAPH_TIME
