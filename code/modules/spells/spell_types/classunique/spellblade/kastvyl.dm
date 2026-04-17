/datum/action/cooldown/spell/projectile/kastvyl
	name = "Kastvyl"
	desc = "In old Azurian - 'To throw a blade'. Tosses out a bouncing phantom hurlbat that ricochets against solid wall. The damage type changes based on the blade class of your current active intent. Striking the same target twice will deal no damage."
	button_icon = 'icons/mob/actions/classuniquespells/spellblade.dmi'
	button_icon_state = "kastvyl"
	sound = 'sound/combat/wooshes/bladed/wooshlarge (1).ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

	projectile_type = /obj/projectile/energy/kastvyl
	projectile_type_arc = /obj/projectile/energy/kastvyl/arc
	cast_range = 12

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocations = list("Kastvyl!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = FALSE
	charge_time = CHARGETIME_POKE
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 9 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_MEDIUM
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

	var/base_damage = 35
	var/empowered_damage = 60
	var/momentum_cost = 3
	var/cached_damage = 0
	var/cached_woundclass = BCLASS_CUT
	var/cached_empowered = FALSE

/datum/action/cooldown/spell/projectile/kastvyl/cast(atom/cast_on)
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!arcyne_get_weapon(H))
		to_chat(H, span_warning("I need my bound weapon in hand!"))
		return FALSE

	cached_empowered = FALSE
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(M && M.stacks >= momentum_cost)
		M.consume_stacks(momentum_cost)
		cached_empowered = TRUE
		to_chat(H, span_notice("[momentum_cost] momentum released - empowered kastvyl!"))

	cached_damage = cached_empowered ? empowered_damage : base_damage

	cached_woundclass = BCLASS_BLUNT
	if(H.used_intent?.blade_class)
		cached_woundclass = H.used_intent.blade_class

	if(cached_empowered)
		projectile_type = /obj/projectile/energy/kastvyl/empowered
		projectile_type_arc = /obj/projectile/energy/kastvyl/empowered/arc
	else
		projectile_type = /obj/projectile/energy/kastvyl
		projectile_type_arc = /obj/projectile/energy/kastvyl/arc

	. = ..()

/datum/action/cooldown/spell/projectile/kastvyl/ready_projectile(obj/projectile/to_fire, atom/target, mob/user, iteration)
	..()
	to_fire.damage = cached_damage
	var/obj/projectile/energy/kastvyl/K = to_fire
	if(istype(K))
		K.woundclass = cached_woundclass
		switch(cached_woundclass)
			if(BCLASS_CUT, BCLASS_CHOP)
				K.flag = "piercing"
				K.hitsound = 'sound/combat/hits/bladed/genslash (1).ogg'
			if(BCLASS_STAB)
				K.flag = "piercing"
				K.hitsound = 'sound/combat/hits/bladed/genthrust (1).ogg'
			else
				K.flag = "blunt"
				K.hitsound = 'sound/combat/hits/blunt/genblunt (1).ogg'

/obj/projectile/energy/kastvyl
	name = "phantom hurlbat"
	icon = 'icons/obj/magic_projectiles.dmi'
	icon_state = "kastvyl"
	damage = 40
	damage_type = BRUTE
	woundclass = BCLASS_BLUNT
	nodamage = FALSE
	speed = MAGE_PROJ_SLOW
	npc_simple_damage_mult = 1.5
	guard_deflectable = TRUE
	flag = "blunt"
	hitsound = 'sound/combat/hits/blunt/genblunt (1).ogg'
	range = 10
	ricochets_max = 3
	ricochet_chance = 100
	ricochet_auto_aim_angle = 60
	ricochet_auto_aim_range = 6
	ricochet_decay_chance = 1
	ricochet_decay_damage = 1
	// Pierce through mobs like Arcyne Lance - the projectile keeps flying onward after each strike.
	movement_type = UNSTOPPABLE
	var/list/hit_targets

/obj/projectile/energy/kastvyl/on_hit(target)
	if(isliving(target))
		var/mob/living/L = target
		if(L.anti_magic_check())
			visible_message(span_warning("[src] disperses on contact with [L]!"))
			playsound(get_turf(L), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		LAZYINITLIST(hit_targets)
		if(hit_targets[REF(L)])
			return BULLET_ACT_FORCE_PIERCE
		hit_targets[REF(L)] = TRUE
		if(firer)
			log_combat(firer, L, "kastvyl-struck")
		. = ..()
		return . || BULLET_ACT_FORCE_PIERCE
	. = ..()

/obj/projectile/energy/kastvyl/empowered
	name = "empowered phantom hurlbat"
	damage = 60

/obj/projectile/energy/kastvyl/arc
	name = "arced phantom hurlbat"
	damage = 30
	arcshot = TRUE

/obj/projectile/energy/kastvyl/empowered/arc
	name = "empowered arced phantom hurlbat"
	damage = 45
	arcshot = TRUE
