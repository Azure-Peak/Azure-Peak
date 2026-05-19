/datum/action/cooldown/spell/projectile/arcyne_salvo
	button_icon = 'icons/mob/actions/mage_telomancy.dmi'
	name = "Arcyne Salvo"
	desc = "Loose three heavy arcyne bolts in a wide spread toward a single target. Each bolt strikes hard on its own, and if all three converge on the same foe the payoff is devastating. \
	The spread is wide enough that only a Telomancer willing to close the distance will land the full salvo. \
	Toggle arc mode (Ctrl+G) to lob the bolts over obstacles at reduced damage."
	button_icon_state = "arcyne_salvo"
	sound = 'sound/magic/vlightning.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM

	projectile_type = /obj/projectile/magic/arcyne_salvo
	projectile_type_arc = /obj/projectile/magic/arcyne_salvo/arc
	cast_range = SPELL_RANGE_PROJECTILE
	projectiles_per_fire = 3

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_PROJECTILE

	invocations = list("Tela Convergunt!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_POKE
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 12 SECONDS
	attunement_school = ASPECT_NAME_TELOMANCY
	var/spread_step = 15

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 3
	spell_impact_intensity = SPELL_IMPACT_MEDIUM

/datum/action/cooldown/spell/projectile/arcyne_salvo/ready_projectile(obj/projectile/to_fire, atom/target, mob/user, iteration)
	. = ..()
	var/base_angle = to_fire.Angle
	if(isnull(base_angle))
		base_angle = Get_Angle(user, target)
	var/center_index = (projectiles_per_fire + 1) / 2
	to_fire.Angle = base_angle + ((iteration - center_index) * spread_step)
	// Only the center bolt can roll for blunt crit/knockout
	if(iteration != center_index)
		to_fire.woundclass = null

/obj/projectile/magic/arcyne_salvo
	name = "arcyne bolt"
	icon = 'icons/obj/magic_projectiles.dmi'
	icon_state = "arcyne_bolt"
	damage = 30
	nodamage = FALSE
	damage_type = BRUTE
	woundclass = BCLASS_BLUNT
	flag = "blunt"
	range = SPELL_RANGE_PROJECTILE
	speed = MAGE_PROJ_FAST
	accuracy = 60
	guard_deflectable = TRUE
	npc_simple_damage_mult = 1.5
	intdamfactor = BLUNT_DEFAULT_INT_DAMAGEFACTOR
	hitsound = 'sound/combat/hits/blunt/shovel_hit2.ogg'
	ricochets_max = 2
	ricochet_chance = 100
	ricochet_auto_aim_angle = 40
	ricochet_auto_aim_range = 5
	ricochet_incidence_leeway = 40
	ricochet_decay_chance = 1
	ricochet_decay_damage = 1

/obj/projectile/magic/arcyne_salvo/arc
	name = "arced arcyne bolt"
	damage = 23
	arcshot = TRUE

/obj/projectile/magic/arcyne_salvo/on_hit(target)
	hitsound = pick('sound/combat/hits/blunt/shovel_hit.ogg', 'sound/combat/hits/blunt/shovel_hit2.ogg', 'sound/combat/hits/blunt/shovel_hit3.ogg')
	if(ismob(target))
		var/mob/living/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] dissipates harmlessly against [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
	. = ..()
