/datum/action/cooldown/spell/fire_strike
	button_icon = 'icons/mob/actions/mage_pyromancy.dmi'
	name = "Fire Strike"
	desc = "Call down a fireball on a location after a short delay. It damages structures across a 5x5 area and leaves a cloud of smoke and a curtain of flame in its wake. You are not immune to your own fire.\n\
	Fire spells apply scorched effects - at 4 scorched, an armor piercing wound is applied to the head or chest: whichever you are aiming at, and randomly if aiming elsewhere."
	button_icon_state = "grenzel_meteor"
	sound = 'sound/magic/fireball.ogg'
	spell_color = GLOW_COLOR_FIRE
	glow_intensity = GLOW_INTENSITY_HIGH
	attunement_school = ASPECT_NAME_PYROMANCY

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_AOE

	invocations = list("Cadat Globus Igneus!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_MAJOR
	charge_swingdelay_type = SWINGDELAY_CANCEL
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging_fire.ogg'
	cooldown_time = 75 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_impact_intensity = SPELL_IMPACT_HIGH

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/blast_radius = 2
	var/impact_delay = 2 SECONDS
	var/structural_damage = 600
	var/mob_damage = 110
	displayed_damage = 110
	var/curtain_life = 10 SECONDS

/datum/action/cooldown/spell/fire_strike/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	var/turf/center = get_turf(cast_on)
	if(!center)
		return FALSE
	if(!(center in get_hear(cast_range, get_turf(H))))
		to_chat(H, span_warning("I can't cast where I can't see!"))
		return FALSE

	for(var/turf/T in range(blast_radius, center))
		new /obj/effect/temp_visual/trap_wall/fire(T)
	center.visible_message(span_boldwarning("The air above ignites - something is coming down!"))
	addtimer(CALLBACK(src, PROC_REF(drop_fireball), center), impact_delay)
	return TRUE

/datum/action/cooldown/spell/fire_strike/proc/drop_fireball(turf/center)
	if(QDELETED(src) || QDELETED(owner))
		return
	new /obj/effect/temp_visual/falling_boulder/fireball(center, CALLBACK(src, PROC_REF(fire_impact), center))

/datum/action/cooldown/spell/fire_strike/proc/fire_impact(turf/center)
	if(QDELETED(src) || QDELETED(owner))
		return
	var/mob/living/carbon/human/caster = owner
	playsound(center, 'sound/magic/fireball.ogg', 100, TRUE, 6)
	new /obj/effect/temp_visual/spell_impact(center, spell_color, spell_impact_intensity)

	for(var/turf/T in range(blast_radius, center))
		for(var/obj/structure/S in T.contents)
			S.take_damage(structural_damage, BRUTE, "blunt", object_damage_multiplier = 2)
		T.take_damage(structural_damage, BRUTE, "blunt", object_damage_multiplier = 2)
		for(var/mob/living/L in T.contents)
			if(L == owner)
				continue
			if(L.anti_magic_check())
				continue
			if(spell_guard_check(L, TRUE))
				continue
			if(istype(caster) && ishuman(L))
				arcyne_strike(caster, L, null, mob_damage, BODY_ZONE_CHEST, BCLASS_BURN, spell_name = "Fire Strike", damage_type = BURN, skip_animation = TRUE)
			else
				L.adjustFireLoss(mob_damage)
			apply_scorch_stack(L, 2)
			L.Knockdown(3)

	for(var/turf/T in range(blast_radius, center))
		new /obj/effect/curtain_fire(T, curtain_life, owner)

	var/datum/effect_system/smoke_spread/smoke = new
	smoke.set_up(4, center)
	smoke.start()

/obj/effect/temp_visual/falling_boulder/fireball
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "meteor"
	name = "falling fireball"
	color = "#ff7722"
