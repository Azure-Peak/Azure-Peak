/datum/action/cooldown/spell/projectile/basic_offensive
	button_icon = 'icons/mob/actions/mage_shared.dmi'
	name = "Basic Offensive Magic"
	desc = "Fundamental attack magyck. Used for centuries. Toggle firing mode (Shift+G) while the spell is active: \
	Arcyne Bolt strikes a single target, Arced Bolt lobs over obstacles, and Soulshot fires a piercing beam through several foes. \
	Deals 50% increased damage to simple-minded creechurs."
	button_icon_state = "greater_arcyne_bolt"
	sound = 'sound/magic/vlightning.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM

	projectile_type = /obj/projectile/magic/greater_arcyne_bolt
	projectile_type_arc = /obj/projectile/magic/greater_arcyne_bolt/arc
	cast_range = SPELL_RANGE_PROJECTILE
	point_cost = 3

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocations = list("Magicae Sagitta!")
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
	var/list/modes = list(
		list("name" = "Arcyne Bolt", "tag" = "BOLT", "proj" = /obj/projectile/magic/greater_arcyne_bolt, "arc" = FALSE, "icon" = "greater_arcyne_bolt", "cost" = SPELLCOST_MINOR_PROJECTILE, "cooldown" = 5.5 SECONDS, "charge" = CHARGETIME_POKE, "slowdown" = CHARGING_SLOWDOWN_SMALL, "sound" = 'sound/magic/vlightning.ogg', "invocation" = "Magicae Sagitta!"),
		list("name" = "Arced Bolt", "tag" = "ARC", "proj" = /obj/projectile/magic/greater_arcyne_bolt, "arc" = TRUE, "icon" = "greater_arcyne_bolt", "cost" = SPELLCOST_MINOR_PROJECTILE, "cooldown" = 5.5 SECONDS, "charge" = CHARGETIME_POKE, "slowdown" = CHARGING_SLOWDOWN_SMALL, "sound" = 'sound/magic/vlightning.ogg', "invocation" = "Magicae Sagitta!"),
		list("name" = "Soulshot", "tag" = "BEAM", "proj" = /obj/projectile/magic/soulshot, "arc" = FALSE, "icon" = "soulshot", "cost" = SPELLCOST_MAJOR_PROJECTILE, "cooldown" = 12 SECONDS, "charge" = CHARGETIME_MAJOR, "slowdown" = CHARGING_SLOWDOWN_SMALL, "sound" = 'sound/magic/soulshot.ogg', "invocation" = "Animus Ictus!"),
	)

/datum/action/cooldown/spell/projectile/basic_offensive/Grant(mob/grant_to)
	. = ..()
	apply_mode(current_mode)

/datum/action/cooldown/spell/projectile/basic_offensive/proc/apply_mode(index)
	var/list/mode = modes[index]
	projectile_type = mode["proj"]
	arc_mode = mode["arc"]
	button_icon_state = mode["icon"]
	primary_resource_cost = mode["cost"]
	cooldown_time = mode["cooldown"]
	charge_time = mode["charge"]
	charge_slowdown = mode["slowdown"]
	sound = mode["sound"]
	invocations = list(mode["invocation"])
	build_all_button_icons()
	update_mode_maptext(mode["tag"])

/datum/action/cooldown/spell/projectile/basic_offensive/toggle_arc_mode(mob/user)
	current_mode = (current_mode % length(modes)) + 1
	apply_mode(current_mode)
	var/list/mode = modes[current_mode]
	to_chat(user, span_notice("[name]: [mode["name"]] mode."))

/datum/action/cooldown/spell/projectile/basic_offensive/proc/update_mode_maptext(tag)
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

/datum/action/cooldown/spell/projectile/basic_offensive/get_spell_statistics(mob/living/user)
	var/list/stats = ..()
	for(var/i in stats)
		if(findtext(i, "Arc Mode"))
			stats -= i
			break
	stats += span_info("Firing mode (toggle with Shift+G): Arcyne Bolt (direct) / Arced Bolt (lobbed over cover) / Soulshot (piercing beam).")
	return stats
