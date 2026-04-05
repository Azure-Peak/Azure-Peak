/datum/action/cooldown/spell/projectile/fireball/artillery
	name = "Artillery Fireball"
	desc = "An artillery fireball that destroys structures with ease and creates a large impact of smoke and flame. \
	Damage is increased by 140% versus simple-minded creechurs.\n\
	Toggle arc mode (Ctrl+G) while the spell is active to fire it over intervening mobs. Arced attacks deal 25% less damage."
	button_icon_state = "fireball_artillery"

	projectile_type = /obj/projectile/magic/aoe/fireball/rogue/artillery
	projectile_type_arc = /obj/projectile/magic/aoe/fireball/rogue/artillery/arc

	primary_resource_cost = SPELLCOST_MAJOR_PROJECTILE

	invocations = list("Ignis Sphaera Bombardae!")

	charge_time = CHARGETIME_HEAVY
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	cooldown_time = 18 SECONDS

	spell_tier = 4
	point_cost = 9
	spell_impact_intensity = SPELL_IMPACT_HIGH

/obj/projectile/magic/aoe/fireball/rogue/artillery
	name = "artillery fireball"
	exp_heavy = -1
	exp_light = -1
	exp_flash = 0
	exp_fire = 1
	damage = 60
	damage_type = BURN
	npc_simple_damage_mult = 2.4
	accuracy = 40
	nodamage = FALSE
	flag = "fire"
	hitsound = 'sound/blank.ogg'
	aoe_range = 0
	arcyne_aoe_radius = 1
	structural_damage = 300
	structural_damage_radius = 1

/obj/projectile/magic/aoe/fireball/rogue/artillery/arc
	name = "arced artillery fireball"
	damage = 40
	arcshot = TRUE

/obj/projectile/magic/aoe/fireball/rogue/artillery/on_hit(target)
	var/cached_radius = structural_damage_radius
	. = ..()
	if(. == BULLET_ACT_BLOCK)
		return
	var/turf/fallzone = get_turf(target)
	if(!fallzone)
		return
	for(var/turf/open/visual in view(cached_radius, fallzone))
		var/obj/effect/temp_visual/lavastaff/Lava = new /obj/effect/temp_visual/lavastaff(visual)
		animate(Lava, alpha = 255, time = 5)
	var/datum/effect_system/smoke_spread/S = new /datum/effect_system/smoke_spread/fast
	S.set_up(cached_radius, fallzone)
	S.start()
