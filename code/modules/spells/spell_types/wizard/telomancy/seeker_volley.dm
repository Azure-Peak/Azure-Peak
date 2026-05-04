/datum/action/cooldown/spell/projectile/seeker_volley
	button_icon = 'icons/mob/actions/mage_telomancy.dmi'
	name = "Seeker Volley"
	desc = "Lock onto a single target and loose a flight of slow arcyne orbs that pursue them relentlessly. \
	Each orb deals trivial damage but slows the chosen quarry to a crawl. The orbs phase harmlessly through any creature that is not their fated mark, \
	but they can still be deflected by a guard, blocked by a shield, shrugged off by warding - or reflected outright by counterspell."
	button_icon_state = "seeker_volley"
	sound = 'sound/magic/vlightning.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

	projectile_type = /obj/projectile/magic/seeker_orb
	cast_range = SPELL_RANGE_PROJECTILE
	projectiles_per_fire = 3
	click_to_activate = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocations = list("Sequere, Telum!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_POKE
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 12 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	attunement_school = ASPECT_NAME_TELOMANCY
	spell_impact_intensity = SPELL_IMPACT_LOW

/datum/action/cooldown/spell/projectile/seeker_volley/ready_projectile(obj/projectile/to_fire, atom/target, mob/user, iteration)
	. = ..()
	if(istype(to_fire, /obj/projectile/magic/seeker_orb))
		var/obj/projectile/magic/seeker_orb/orb = to_fire
		orb.set_homing_target(target)
		orb.Angle += ((iteration - (projectiles_per_fire + 1) / 2) * 60)
		// Only the center orb can roll for blunt crit/knockout
		if(iteration != (projectiles_per_fire + 1) / 2)
			orb.woundclass = null

/obj/projectile/magic/seeker_orb
	name = "seeker orb"
	icon = 'icons/obj/magic_projectiles.dmi'
	icon_state = "seeker_orb"
	damage = 5
	damage_type = BRUTE
	woundclass = BCLASS_BLUNT
	flag = "blunt"
	range = 16
	speed = MAGE_PROJ_SLOW
	accuracy = 100
	guard_deflectable = TRUE
	npc_simple_damage_mult = 1.5
	intdamfactor = BLUNT_DEFAULT_INT_DAMAGEFACTOR
	hitsound = 'sound/combat/hits/blunt/shovel_hit2.ogg'
	homing_turn_speed = 35
	homing_inaccuracy_max = 12

/obj/projectile/magic/seeker_orb/prehit(atom/target)
	if(isliving(target) && target != original)
		return FALSE
	return ..()

/obj/projectile/magic/seeker_orb/process_homing()
	if(QDELETED(homing_target))
		homing = FALSE
		return FALSE
	var/desired_angle = Get_Angle(src, homing_target)
	var/diff = closer_angle_difference(Angle, desired_angle)
	if(!isnum(diff))
		return FALSE
	setAngle(Angle + CLAMP(diff, -homing_turn_speed, homing_turn_speed))
	return TRUE

/obj/projectile/magic/seeker_orb/on_hit(target)
	hitsound = pick('sound/combat/hits/blunt/shovel_hit.ogg', 'sound/combat/hits/blunt/shovel_hit2.ogg', 'sound/combat/hits/blunt/shovel_hit3.ogg')
	if(ismob(target))
		var/mob/living/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] dissipates harmlessly against [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		M.apply_status_effect(/datum/status_effect/debuff/seeker_marked)
	. = ..()

/datum/status_effect/debuff/seeker_marked
	id = "seeker_marked"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/seeker_marked
	duration = 8 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	effectedstats = list(STATKEY_SPD = -2)

/atom/movable/screen/alert/status_effect/debuff/seeker_marked
	name = "Marked"
	desc = "An arcyne weight clings to my limbs. The Telomancer's mark is upon me."
	icon_state = "debuff"

/datum/status_effect/debuff/seeker_marked/on_apply()
	. = ..()
	var/mob/living/target = owner
	target.balloon_alert_to_viewers("<font color='#b388ff'>marked!</font>")
