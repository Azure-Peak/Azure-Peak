/obj/effect/proc_holder/spell/invoked/projectile/arcynebolt
	name = "Arcyne Bolt"
	desc = "Shoot out a rapid bolt of arcyne magic. Inflicts blunt damage, and applies one stack of <b>Arcane Mark</b> on the target. At three marks, it instead does piercing damage and consumes all <b>marks</b> \n\
	Damage is increased by 50% versus simple-minded creechurs.\n\
	Toggle arc mode (Ctrl+G) while the spell is active to fire it over intervening mobs. Arced attacks deal 25% less damage."
	clothes_req = FALSE
	range = 12
	projectile_type = /obj/projectile/energy/arcynebolt
	projectile_type_arc = /obj/projectile/energy/arcynebolt/arc
	overlay_state = "force_dart"
	sound = list('sound/magic/vlightning.ogg')
	active = FALSE
	releasedrain = 20
	chargedrain = 1
	chargetime = 0
	recharge_time = 4 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	spell_tier = 2
	invocations = list("Magicae Sagitta!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	cost = 3

/obj/effect/proc_holder/spell/invoked/projectile/arcynebolt/cast(list/targets, mob/user = user)
	projectile_type = arc_mode ? projectile_type_arc : initial(projectile_type)
	. = ..()

/obj/projectile/energy/arcynebolt
	name = "Arcyne Bolt"
	icon_state = "arcane_barrage"
	guard_deflectable = TRUE
	damage = 40
	woundclass = BCLASS_BLUNT
	nodamage = FALSE
	npc_simple_damage_mult = 1.5 // Makes it more effective against NPCs.
	hitsound = 'sound/combat/hits/blunt/shovel_hit2.ogg'
	speed = 1
	var/apply_mark = TRUE

/obj/projectile/energy/arcynebolt/arc
	name = "Arced Arcyne Bolt"
	damage = 30 // You cannot modify charge and releasedrain dynamically so lower damage it is.
	arcshot = TRUE

/obj/projectile/energy/arcynebolt/on_hit(target)

	var/mob/living/carbon/M = target
	if(ismob(target))
		var/datum/status_effect/debuff/arcanemark/mark = M.has_status_effect(/datum/status_effect/debuff/arcanemark)
		if(mark && mark.stacks == mark.max_stacks)
			damage = 60
			armor_penetration = 50
			woundclass = BCLASS_STAB
			apply_mark = FALSE
			consume_arcane_mark_stacks(M)

	. = ..()

	if(ismob(target))
		if(M.anti_magic_check())
			visible_message(span_warning("[src] fizzles on contact with [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		playsound(get_turf(target), 'sound/combat/hits/blunt/shovel_hit2.ogg', 100) //CLANG
		if(istype(M, /mob/living/carbon) && (src.apply_mark == TRUE))
			apply_arcane_mark(M)
	else
		return
