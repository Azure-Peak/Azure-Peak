#define ARCYNE_BARRAGE_SLOWDOWN_ID "arcyne_barrage_channel"

/datum/action/cooldown/spell/projectile/arcyne_barrage
	button_icon = 'icons/mob/actions/mage_telomancy.dmi'
	name = "Arcyne Barrage"
	desc = "The Ultimate Reason of a Telomancer - barrage a general direction with a barrage of arcyne bolts for ten seconds. \
	The bolts arrive in interleaved pulses. You can walk while channeling but you are greatly slowed down and cannot change your direction. \
	Being stunned, knocked down, or grabbed will break the channeling."
	button_icon_state = "arcyne_barrage"
	sound = 'sound/magic/vlightning.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_VERY_HIGH
	attunement_school = ASPECT_NAME_TELOMANCY

	click_to_activate = TRUE
	cast_range = 21

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_ULTIMATE

	invocations = list()
	invocation_type = INVOCATION_NONE
	var/barrage_invocation = "Ultima Ratio Telum!"

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_HEAVY
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 90 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 4
	spell_impact_intensity = SPELL_IMPACT_HIGH

	var/channel_duration = 10 SECONDS
	var/pulse_interval = 1 SECONDS
	var/arc_width = 120
	var/odd_pulse_step = 10
	var/even_pulse_step = 10
	var/channel_slowdown = 3

/datum/action/cooldown/spell/projectile/arcyne_barrage/before_cast(atom/cast_on)
	. = ..()
	. |= SPELL_NO_IMMEDIATE_COOLDOWN

/datum/action/cooldown/spell/projectile/arcyne_barrage/fire_projectile(atom/target)
	return TRUE

/datum/action/cooldown/spell/projectile/arcyne_barrage/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	H.say(barrage_invocation, forced = "spell", language = /datum/language/common)

	var/locked_angle = dir2angle(H.dir)
	var/end_time = world.time + channel_duration
	var/pulse_index = 0

	H.visible_message(span_danger("<b>[H] plants their feet and unleashes a storm of arcyne bolts!</b>"))
	playsound(get_turf(H), 'sound/magic/vlightning.ogg', 100, TRUE)
	H.add_movespeed_modifier(ARCYNE_BARRAGE_SLOWDOWN_ID, update = TRUE, priority = 100, multiplicative_slowdown = channel_slowdown, movetypes = GROUND)

	while(world.time < end_time)
		if(!channel_valid(H))
			end_channel(H, TRUE)
			return TRUE

		pulse_index++
		fire_pulse(H, locked_angle, pulse_index)

		new /obj/effect/temp_visual/spell_impact(get_turf(H), spell_color, spell_impact_intensity)
		sleep(pulse_interval)

	end_channel(H, FALSE)
	return TRUE

/datum/action/cooldown/spell/projectile/arcyne_barrage/proc/end_channel(mob/living/carbon/human/H, interrupted)
	if(H)
		H.remove_movespeed_modifier(ARCYNE_BARRAGE_SLOWDOWN_ID)
	if(interrupted)
		StartCooldown(get_adjusted_cooldown() / 2)
		if(H)
			to_chat(H, span_warning("My barrage falters!"))
	else
		StartCooldown(get_adjusted_cooldown())

/datum/action/cooldown/spell/projectile/arcyne_barrage/proc/channel_valid(mob/living/carbon/human/H)
	if(QDELETED(H))
		return FALSE
	if(H.stat != CONSCIOUS)
		return FALSE
	if(H.IsParalyzed() || H.IsStun() || H.IsKnockdown() || H.IsUnconscious())
		return FALSE
	if(H.pulledby)
		return FALSE
	return TRUE

/// Fire a single pulse of greater arcyne bolts. Odd pulses hit 0/20/40/60/80/100/120; even pulses hit 10/30/50/70/90/110.
/datum/action/cooldown/spell/projectile/arcyne_barrage/proc/fire_pulse(mob/living/carbon/human/H, locked_angle, pulse_index)
	var/is_odd_pulse = (pulse_index % 2) == 1
	var/start_offset = is_odd_pulse ? 0 : (odd_pulse_step / 2)
	var/step_size = is_odd_pulse ? odd_pulse_step : even_pulse_step
	var/arc_start = locked_angle - (arc_width / 2)
	var/list/angles_to_fire = list()
	var/current_offset = start_offset
	while(current_offset <= arc_width)
		angles_to_fire += (arc_start + current_offset)
		current_offset += step_size
	for(var/angle in angles_to_fire)
		fire_barrage_bolt(H, angle)

/datum/action/cooldown/spell/projectile/arcyne_barrage/proc/fire_barrage_bolt(mob/living/carbon/human/H, angle)
	var/obj/projectile/magic/arcyne_barrage_bolt/bolt = new(get_turf(H))
	bolt.firer = H
	bolt.fired_from = get_turf(H)
	bolt.def_zone = BODY_ZONE_CHEST
	bolt.spell_impact_intensity = SPELL_IMPACT_MEDIUM
	bolt.accuracy += (H.STAINT - 9) * 4
	bolt.bonus_accuracy += (H.STAINT - 8) * 3
	if(H.mind)
		bolt.bonus_accuracy += (H.get_skill_level(associated_skill) * 5)
	bolt.setAngle(angle)
	bolt.fire()

/obj/projectile/magic/arcyne_barrage_bolt
	name = "greater arcyne bolt"
	icon = 'icons/obj/magic_projectiles.dmi'
	icon_state = "arcyne_bolt"
	damage = 45
	nodamage = FALSE
	damage_type = BRUTE
	woundclass = BCLASS_BLUNT
	flag = "blunt"
	range = 30
	speed = 3
	accuracy = 60
	guard_deflectable = TRUE
	npc_simple_damage_mult = 1.5
	intdamfactor = BLUNT_DEFAULT_INT_DAMAGEFACTOR
	ricochets_max = 2
	ricochet_chance = 80
	ricochet_auto_aim_angle = 40
	ricochet_auto_aim_range = 5
	ricochet_incidence_leeway = 40
	ricochet_decay_chance = 1
	ricochet_decay_damage = 0.8
	hitsound = 'sound/combat/hits/blunt/shovel_hit2.ogg'

/obj/projectile/magic/arcyne_barrage_bolt/on_hit(target)
	hitsound = pick('sound/combat/hits/blunt/shovel_hit.ogg', 'sound/combat/hits/blunt/shovel_hit2.ogg', 'sound/combat/hits/blunt/shovel_hit3.ogg')
	if(ismob(target))
		var/mob/living/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] dissipates harmlessly against [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
	. = ..()

#undef ARCYNE_BARRAGE_SLOWDOWN_ID
