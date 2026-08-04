/datum/action/cooldown/spell/projectile/gravel_blast
	button_icon = 'icons/mob/actions/mage_geomancy.dmi'
	name = "Gravel Blast"
	desc = "Spray a volley of stones at a target. Stones ricochet off walls. Subsequent hits on the same target deal reduced damage. \
	Stones are particularly effective at degrading armor. Deals 2x damage to structures. \
	Toggle arc mode (Shift+G) to lob over obstacles at reduced damage."
	button_icon_state = "gravel_blast"
	sound = 'sound/combat/hits/onstone/wallhit.ogg'
	spell_color = GLOW_COLOR_EARTHEN
	glow_intensity = GLOW_INTENSITY_LOW

	projectile_type = /obj/projectile/magic/gravel_blast
	projectile_type_arc = /obj/projectile/magic/gravel_blast/arc
	cast_range = SPELL_RANGE_PROJECTILE
	projectiles_per_fire = 5

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocations = list("Saxum Iaci!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_POKE
	charge_swingdelay_type = SWINGDELAY_PENALTY
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging_fire.ogg'
	cooldown_time = 6 SECONDS
	attunement_school = ASPECT_NAME_GEOMANCY
	var/spread_step = 8

	associated_skill = /datum/skill/magic/arcane
	spell_impact_intensity = SPELL_IMPACT_LOW

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

/datum/action/cooldown/spell/projectile/gravel_blast/ready_projectile(obj/projectile/to_fire, atom/target, mob/user, iteration)
	. = ..()
	var/base_angle = to_fire.Angle
	if(isnull(base_angle))
		base_angle = Get_Angle(user, target)
	var/center_index = (projectiles_per_fire + 1) / 2
	to_fire.Angle = base_angle + ((iteration - center_index) * spread_step)
	// Only the center stone can roll for blunt crit/knockout
	if(iteration != center_index)
		to_fire.woundclass = null

// --- Lesser Gravel Blast: 3-projectile variant for poke option picks ---

/datum/action/cooldown/spell/projectile/gravel_blast/lesser
	name = "Lesser Gravel Blast"
	desc = "Spray a trio of stones at a target. Stones ricochet off walls. Subsequent hits on the same target deal reduced damage. \
	Stones are particularly effective at degrading armor. Deals 2x damage to structures. \
	Toggle arc mode (Shift+G) to lob over obstacles at reduced damage."
	button_icon_state = "gravel_blast"
	projectiles_per_fire = 3
	attunement_school = null
	spell_tier = 0
	point_cost = 0
