/* Artillery Fireball - Worse DPS, much better structural damage. Smoke
*/

/obj/effect/proc_holder/spell/invoked/projectile/fireball/artillery
	name = "Artillery Fireball"
	desc = "An artillery fireball that destroys structures with ease and creates a large impact of smoke and flame. \n\
	Damage is increased by 140% versus simple-minded creechurs.\n\
	Toggle arc mode (Ctrl+G) while the spell is active to fire it over intervening mobs. Arced attacks deal 25% less damage."
	clothes_req = FALSE
	cost = 6
	range = 8
	projectile_type = /obj/projectile/magic/aoe/fireball/rogue/artillery
	projectile_type_arc = /obj/projectile/magic/aoe/fireball/rogue/artillery/arc
	overlay_state = "fireball_artillery"
	sound = list('sound/magic/fireball.ogg')
	releasedrain = 30
	chargedrain = 1
	chargetime = 25
	recharge_time = 22 SECONDS // 10% penalty but otherwise the same as fireball, to keep it from being strictly better in every way
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 3
	spell_tier = 4 // Court mage can have this as a treat
	invocations = list("Ignis Sphaera Bombardae!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_FIRE
	glow_intensity = GLOW_INTENSITY_HIGH
	chargedloop = /datum/looping_sound/invokefire
	associated_skill = /datum/skill/magic/arcane
	xp_gain = TRUE

/obj/projectile/magic/aoe/fireball/rogue/artillery
	name = "Artillery Fireball"
	exp_heavy = -1
	exp_light = -1
	exp_flash = 0
	exp_fire = 1
	damage = 60
	damage_type = BURN
	npc_simple_damage_mult = 2.4
	accuracy = 40 // Base accuracy is lower for burn projectiles because they bypass armor
	nodamage = FALSE
	flag = "magic"
	hitsound = 'sound/blank.ogg'
	aoe_range = 0
	arcyne_aoe_radius = 1
	structural_damage = 300 // On average a door is 1100 integrity, and a window is 200
	structural_damage_radius = 1

/obj/projectile/magic/aoe/fireball/rogue/artillery/arc
	name = "Arced Artillery Fireball"
	damage = 40 // 25% damage penalty, matching fireball
	arcshot = TRUE

/obj/projectile/magic/aoe/fireball/rogue/artillery/on_hit(target)
	var/cached_radius = structural_damage_radius
	. = ..()
	if(. == BULLET_ACT_BLOCK)
		return
	// Artillery-specific: lava visuals and smoke on impact
	var/turf/fallzone = get_turf(target)
	if(!fallzone)
		return
	for(var/turf/open/visual in view(cached_radius, fallzone))
		var/obj/effect/temp_visual/lavastaff/Lava = new /obj/effect/temp_visual/lavastaff(visual)
		animate(Lava, alpha = 255, time = 5)
	var/datum/effect_system/smoke_spread/S = new /datum/effect_system/smoke_spread/fast
	S.set_up(cached_radius, fallzone)
	S.start()
