#define FETCH_YEET_RANGE 7
/datum/action/cooldown/spell/projectile/fetch
	button_icon = 'icons/mob/actions/mage_kinesis.dmi'
	name = "Fetch"
	desc = "Shoot out a magical bolt that draws in the target struck towards the caster."
	button_icon_state = "fetch"
	sound = 'sound/magic/magnet.ogg'
	spell_color = GLOW_COLOR_KINESIS
	glow_intensity = GLOW_INTENSITY_LOW

	projectile_type = /obj/projectile/magic/fetch
	cast_range = 15
	point_cost = 2

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocations = list("Recollige!")
	invocation_type = INVOCATION_WHISPER

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_MINOR
	charge_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 15 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_LOW

/obj/projectile/magic/fetch
	name = "bolt of fetching"
	icon_state = "cursehand0"
	flag = "blunt"
	speed = MAGE_PROJ_FAST
	range = 15
	cannot_cross_z = TRUE

/obj/projectile/magic/fetch/on_hit(target)
	. = ..()
	var/atom/throw_target = get_step(firer, get_dir(firer, target))
	if(isliving(target))
		var/mob/living/L = target
		if(L.anti_magic_check() || !firer)
			L.visible_message(span_warning("[src] vanishes on contact with [target]!"))
			return BULLET_ACT_BLOCK
		L.throw_at(throw_target, FETCH_YEET_RANGE, 4)
	else
		if(isitem(target))
			var/obj/item/I = target
			var/mob/living/carbon/human/carbon_firer
			if (ishuman(firer))
				carbon_firer = firer
				if (carbon_firer?.can_catch_item())
					throw_target = get_turf(firer)
			I.throw_at(throw_target, FETCH_YEET_RANGE, 3)

#undef FETCH_YEET_RANGE
