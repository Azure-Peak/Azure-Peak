/* Greater Fireball — just fireball tuned up to 11, court-mage exclusive. Wider AOE radius,
more raw damage. */

/obj/effect/proc_holder/spell/invoked/projectile/fireball/greater
	name = "Greater Fireball"
	desc = "Shoot out an immense ball of fire that explodes on impact, scorching all nearby targets in a wide radius. \n\ Damage is increased by 100% versus simple-minded creechurs.\n\
	Toggle arc mode (Ctrl+G) while the spell is active to fire it over intervening mobs. Arced attacks deal 25% less damage."
	clothes_req = FALSE
	range = 8
	projectile_type = /obj/projectile/magic/aoe/fireball/rogue/great
	projectile_type_arc = /obj/projectile/magic/aoe/fireball/rogue/great/arc
	overlay_state = "fireball_wide"
	sound = list('sound/magic/fireball.ogg')
	active = FALSE
	releasedrain = 50
	chargedrain = 1
	chargetime = 15
	recharge_time = 30 SECONDS // Cuz you can stack it with normal fireball atm
	warnie = "spellwarning"
	spell_tier = 4
	invocations = list("Maior Sphaera Ignis!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_FIRE
	glow_intensity = GLOW_INTENSITY_VERY_HIGH
	no_early_release = TRUE
	movement_interrupt = TRUE
	chargedloop = /datum/looping_sound/invokefire
	cost = 9
	xp_gain = TRUE

/obj/projectile/magic/aoe/fireball/rogue/great
	name = "greater fireball"
	exp_heavy = -1
	exp_light = -1
	exp_flash = 0
	exp_fire = 0
	damage = 90
	npc_simple_damage_mult = 2
	flag = "magic"
	arcyne_aoe_radius = 2
	structural_damage = 150

/obj/projectile/magic/aoe/fireball/rogue/great/arc
	name = "Arced Greater Fireball"
	damage = 70 // ~25% damage penalty
	arcshot = TRUE
