/datum/action/cooldown/spell/projectile/fireball/greater
	name = "Greater Fireball"
	desc = "Shoot out an immense ball of fire that explodes on impact, scorching and slowing all nearby targets in a wide radius. \
	Damage is increased by 100% versus simple-minded creechurs.\n\
	Toggle arc mode (Ctrl+G) while the spell is active to fire it over intervening mobs. Arced attacks deal 25% less damage."
	button_icon_state = "fireball_greater"
	glow_intensity = GLOW_INTENSITY_VERY_HIGH

	projectile_type = /obj/projectile/magic/aoe/fireball/rogue/great
	projectile_type_arc = /obj/projectile/magic/aoe/fireball/rogue/great/arc

	primary_resource_cost = SPELLCOST_SUPER_PROJECTILE

	invocations = list("Maior Sphaera Ignis!")

	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	cooldown_time = 22 SECONDS

	spell_tier = 4
	point_cost = 9
	spell_impact_intensity = SPELL_IMPACT_HIGH

/obj/projectile/magic/aoe/fireball/rogue/great
	name = "greater fireball"
	exp_heavy = -1
	exp_light = -1
	exp_flash = 0
	exp_fire = 0
	damage = 90
	npc_simple_damage_mult = 2
	flag = "fire"
	arcyne_aoe_radius = 2
	structural_damage = 150

/obj/projectile/magic/aoe/fireball/rogue/great/arc
	name = "arced greater fireball"
	damage = 70
	arcshot = TRUE
