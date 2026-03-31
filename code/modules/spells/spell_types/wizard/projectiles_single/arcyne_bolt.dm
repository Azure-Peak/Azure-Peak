// New spell system
/datum/action/cooldown/spell/projectile/arcynebolt
	name = "Arcyne Bolt"
	desc = "Shoot out a rapid bolt of arcyne magic. Inflicts blunt damage, and applies one stack of <b>Arcane Mark</b> on the target. At three marks, it instead does piercing damage and consumes all <b>marks</b>. \
	Damage is increased by 50% versus simple-minded creechurs. \
	Toggle arc mode (Ctrl+G) while the spell is active to fire it over intervening mobs. Arced attacks deal 25% less damage."
	button_icon_state = "force_dart"
	sound = 'sound/magic/vlightning.ogg'
	spell_color = GLOW_COLOR_ARCANE

	projectile_type = /obj/projectile/energy/arcynebolt
	projectile_type_arc = /obj/projectile/energy/arcynebolt/arc
	cast_range = 12
	point_cost = 3

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocations = list("Magicae Sagitta!")
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	cooldown_time = 4 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2

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
			armor_penetration = PEN_HEAVY
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
