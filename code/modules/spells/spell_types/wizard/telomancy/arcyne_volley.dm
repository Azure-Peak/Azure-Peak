/datum/action/cooldown/spell/projectile/arcyne_volley
	button_icon = 'icons/mob/actions/mage_telomancy.dmi'
	name = "Magister's Dart"
	desc = "Advanced Offensive Magyck, refined over millenium and turned into a true Telomancer's ultimate thesis! Toggle firing mode (Shift+G) while the spell is active: \
	Cascade looses a rapid stream of bolts at a single foe, Seeker sends homing orbs that pass harmlessly through all but their mark, and Soulshot fires a piercing beam through several foes. \
	Deals 50% increased damage to simple-minded creechurs."
	button_icon_state = "arcyne_bolt"
	sound = 'sound/magic/vlightning.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_TELOMANCY

	projectile_type = /obj/projectile/magic/greater_arcyne_bolt/flurry
	cast_range = SPELL_RANGE_PROJECTILE
	point_cost = 3

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocations = list("Telum Magistri!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_POKE
	charge_swingdelay_type = SWINGDELAY_PENALTY
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 5.5 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_MEDIUM

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

	var/current_mode = 1
	var/flurry_shots = 4
	var/flurry_shot_delay = 2
	var/flurry_spread = 10
	var/list/modes = list(
		list("name" = "Cascade", "tag" = "CASC", "fire" = "stream", "proj" = /obj/projectile/magic/greater_arcyne_bolt/flurry, "per_fire" = 1, "cost" = SPELLCOST_MINOR_PROJECTILE, "cooldown" = 5.5 SECONDS, "charge" = CHARGETIME_POKE, "slowdown" = CHARGING_SLOWDOWN_SMALL, "sound" = 'sound/magic/vlightning.ogg', "invocation" = "Telum Magistri!", "icon" = "arcyne_bolt"),
		list("name" = "Seeker", "tag" = "SEEK", "fire" = "homing", "proj" = /obj/projectile/magic/seeker_orb/greater, "per_fire" = 5, "cost" = SPELLCOST_MINOR_PROJECTILE, "cooldown" = 5.5 SECONDS, "charge" = CHARGETIME_POKE, "slowdown" = CHARGING_SLOWDOWN_SMALL, "sound" = 'sound/magic/vlightning.ogg', "invocation" = "Sequere, Telum!", "icon" = "seeker"),
		list("name" = "Soulshot", "tag" = "SOUL", "fire" = "single", "proj" = /obj/projectile/magic/soulshot, "per_fire" = 1, "cost" = SPELLCOST_MAJOR_PROJECTILE, "cooldown" = 10 SECONDS, "charge" = CHARGETIME_MAJOR, "slowdown" = CHARGING_SLOWDOWN_SMALL, "sound" = 'sound/magic/soulshot.ogg', "invocation" = "Animus Ictus!", "icon" = "soulshot"), // Soulshot mode is a bit cheaper than basic offensive magyck for their budget
	)

/datum/action/cooldown/spell/projectile/arcyne_volley/Grant(mob/grant_to)
	. = ..()
	update_mode_maptext(modes[current_mode]["tag"])

/datum/action/cooldown/spell/projectile/arcyne_volley/proc/apply_mode(index)
	var/list/mode = modes[index]
	projectile_type = mode["proj"]
	projectiles_per_fire = mode["per_fire"]
	primary_resource_cost = mode["cost"]
	cooldown_time = mode["cooldown"]
	charge_time = mode["charge"]
	charge_slowdown = mode["slowdown"]
	sound = mode["sound"]
	invocations = list(mode["invocation"])
	button_icon_state = mode["icon"]
	build_all_button_icons()
	update_mode_maptext(mode["tag"])

/datum/action/cooldown/spell/projectile/arcyne_volley/toggle_arc_mode(mob/user)
	current_mode = (current_mode % length(modes)) + 1
	apply_mode(current_mode)
	var/list/mode = modes[current_mode]
	to_chat(user, span_notice("[name]: [mode["name"]] mode."))

/datum/action/cooldown/spell/projectile/arcyne_volley/proc/update_mode_maptext(tag)
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

/datum/action/cooldown/spell/projectile/arcyne_volley/fire_projectile(atom/target)
	switch(modes[current_mode]["fire"])
		if("stream")
			INVOKE_ASYNC(src, PROC_REF(fire_stream), target)
			return TRUE
		if("homing")
			return fire_seeker_volley(target)
	return ..()

/datum/action/cooldown/spell/projectile/arcyne_volley/proc/fire_seeker_volley(atom/target)
	var/list/volley = list()
	for(var/i in 1 to projectiles_per_fire)
		var/obj/projectile/to_fire = new projectile_type(owner.loc)
		ready_projectile(to_fire, target, owner, i)
		if(istype(to_fire, /obj/projectile/magic/seeker_orb/greater))
			var/obj/projectile/magic/seeker_orb/greater/orb = to_fire
			orb.volley = volley
			volley += orb
		to_fire.fire()
	return TRUE

/datum/action/cooldown/spell/projectile/arcyne_volley/proc/fire_stream(atom/target)
	for(var/i in 1 to flurry_shots)
		if(QDELETED(src) || QDELETED(owner) || !isturf(owner.loc))
			return
		var/obj/projectile/to_fire = new projectile_type(owner.loc)
		ready_projectile(to_fire, target, owner, i)
		if(flurry_spread)
			var/base_angle = to_fire.Angle
			if(isnull(base_angle))
				base_angle = Get_Angle(owner, target)
			to_fire.setAngle(base_angle + rand(-flurry_spread, flurry_spread))
		to_fire.fire()
		if(i < flurry_shots)
			sleep(flurry_shot_delay)

/datum/action/cooldown/spell/projectile/arcyne_volley/ready_projectile(obj/projectile/to_fire, atom/target, mob/user, iteration)
	. = ..()
	if(istype(to_fire, /obj/projectile/magic/seeker_orb))
		var/obj/projectile/magic/seeker_orb/orb = to_fire
		var/mob/living/mark = isliving(target) ? target : pick_seeker_target(user)
		if(mark)
			orb.set_homing_target(mark)
			orb.original = mark
		orb.Angle += ((iteration - (projectiles_per_fire + 1) / 2) * 60)
		if(iteration != (projectiles_per_fire + 1) / 2)
			orb.woundclass = null

/datum/action/cooldown/spell/projectile/arcyne_volley/proc/pick_seeker_target(mob/user)
	var/list/mob/living/pool = list()
	for(var/mob/living/M in view(cast_range, user))
		if(M.stat == DEAD)
			continue
		pool += M
	return length(pool) ? pick(pool) : null

/datum/action/cooldown/spell/projectile/arcyne_volley/get_spell_statistics(mob/living/user)
	var/list/stats = ..()
	for(var/i in stats.Copy())
		if(findtext(i, "Damage:") || findtext(i, "Arc Mode"))
			stats -= i
	stats += span_info("Firing mode (Shift+G): Cascade (4x20 stream) / Seeker (3x20 homing, marks) / Soulshot (80 piercing beam).")
	return stats

/obj/projectile/magic/greater_arcyne_bolt/flurry
	name = "arcyne bolt"
	damage = 20
	flag = "piercing"
	woundclass = BCLASS_PIERCE
	speed = MAGE_PROJ_MEDIUM
	hitsound = 'sound/combat/hits/bladed/genthrust (1).ogg'
	impact_sounds = list('sound/combat/hits/bladed/genthrust (1).ogg', 'sound/combat/hits/bladed/genthrust (2).ogg')

/obj/projectile/magic/seeker_orb/greater
	damage = 15
	flag = "piercing"
	woundclass = BCLASS_PIERCE
	speed = 5
	hitsound = 'sound/combat/hits/bladed/genthrust (1).ogg'
	impact_sounds = list('sound/combat/hits/bladed/genthrust (1).ogg', 'sound/combat/hits/bladed/genthrust (2).ogg')
	var/list/volley

/obj/projectile/magic/seeker_orb/greater/on_guard_deflect(mob/living/defender, silent = FALSE)
	var/mob/living/caster = firer
	var/list/flight = volley
	. = ..()
	if(!isliving(caster) || QDELETED(caster) || !flight)
		return
	for(var/obj/projectile/magic/seeker_orb/greater/orb in flight)
		if(QDELETED(orb))
			continue
		orb.firer = defender
		orb.original = caster
		orb.set_homing_target(caster)
