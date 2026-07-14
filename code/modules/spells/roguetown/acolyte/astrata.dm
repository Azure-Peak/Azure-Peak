/datum/action/cooldown/spell/astrata
	background_icon = 'icons/mob/actions/astratamiracles.dmi'
	button_icon = 'icons/mob/actions/astratamiracles.dmi'
	spell_color = GLOW_COLOR_ASTRATA

	attunement_school = null

	primary_resource_type = SPELL_COST_DEVOTION

	secondary_resource_type = SPELL_COST_STAMINA

	ignore_armor_penalty = TRUE

	has_visual_effects = FALSE
	spell_impact_intensity = SPELL_IMPACT_NONE
	associated_stat = null
	associated_skill = /datum/skill/magic/holy
	spell_tier = 0

	point_cost = 0

	required_items = list(/obj/item/clothing/neck/roguetown/psicross/astrata, /obj/item/clothing/neck/roguetown/psicross/silver/astrata, /obj/item/clothing/neck/roguetown/psicross/undivided, /obj/item/clothing/neck/roguetown/psicross/silver/undivided)

///////////////////////////////////////////////////
// T0 - Ignition - Ignite a target or an object. //
///////////////////////////////////////////////////

/datum/action/cooldown/spell/miracle/ignition/astrata
	background_icon = 'icons/mob/actions/astratamiracles.dmi'
	button_icon = 'icons/mob/actions/astratamiracles.dmi'
	spell_color = GLOW_COLOR_ASTRATA
	glow_intensity = GLOW_INTENSITY_LOW

	required_items = list(/obj/item/clothing/neck/roguetown/psicross/astrata, /obj/item/clothing/neck/roguetown/psicross/silver/astrata, /obj/item/clothing/neck/roguetown/psicross/undivided, /obj/item/clothing/neck/roguetown/psicross/silver/undivided)

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// T1 - Astratan Gaze - Removes cone vision for a dynamic duration. Adds PERCEPTION based on holy skill and time of day. //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/action/cooldown/spell/astrata/astrata_gaze
	name = "Astratan Gaze"
	desc = "Removes the limit on your vision, letting you see behind you for a time, lasts longer during the dae and gives a perception bonus to those skilled and holy arts."
	fluff_desc = "The second gift to men, Her ability to discern evyl hiding in plain sight. Astrata's tireless gaze - a true boon in hands of mortals as well Her misbegotten children."
	button_icon_state = "gaze"
	sound = 'sound/magic/astrata_choir.ogg'
	glow_intensity = 0

	click_to_activate = FALSE

	primary_resource_cost = SPELLCOST_MIRACLE

	secondary_resource_cost = SPELLCOST_UTILITY_BUFF

	invocations = list("Astrata show me true.")
	invocation_type = INVOCATION_WHISPER

	charge_required = FALSE
	cooldown_time = 3 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/astrata/astrata_gaze/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	var/skill_level = H.get_skill_level(associated_skill)
	H.apply_status_effect(/datum/status_effect/buff/astrata_gaze, skill_level)
	return TRUE

/atom/movable/screen/alert/status_effect/buff/astrata_gaze
	name = "Astratan's Gaze"
	desc = "She shines through me, illuminating all injustice."
	icon_state = "astrata_gaze"

/datum/status_effect/buff/astrata_gaze
	id = "astratagaze"
	alert_type = /atom/movable/screen/alert/status_effect/buff/astrata_gaze
	duration = 40 SECONDS
	var/skill_level = 0
	status_type = STATUS_EFFECT_REPLACE

/datum/status_effect/buff/astrata_gaze/on_creation(mob/living/new_owner, slevel)
	// Only store skill level here
	skill_level = slevel
	.=..()

/datum/status_effect/buff/astrata_gaze/on_apply()
	// Reset base values because the miracle can
	// now actually be recast at high enough skill and during day time
	// This is a safeguard because buff code makes my head hurt
	var/per_bonus = 0
	duration = 20 SECONDS

	if(skill_level > SKILL_LEVEL_NOVICE)
		per_bonus++

	if(GLOB.tod == "dawn" || GLOB.tod == "day" || GLOB.tod == "dusk")
		per_bonus++
		duration *= 2

	duration *= skill_level

	if(per_bonus)
		effectedstats = list(STATKEY_PER = per_bonus)

	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.viewcone_override = TRUE
		H.hide_cone()
		H.update_cone_show()

	to_chat(owner, span_info("She shines through me! I can perceive all clear as dae!"))

	return ..()

/datum/status_effect/buff/astrata_gaze/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.viewcone_override = FALSE
		H.hide_cone()
		H.update_cone_show()

//////////////////////////////////////////////////////////
// T2 - Sacred Flame - Deals damage and ignites target. //
//////////////////////////////////////////////////////////

/datum/action/cooldown/spell/projectile/sacred_flame
	name = "Sacred Flame"
	desc = "Emit a bolt of holy fire that sunders a target, setting them on fire and slowing them down for 6 seconds. \
	Damage is increased by 100% versus simple-minded creechurs. \
	The CC effects cannot be reapplied to the same target within 15 seconds."
	fluff_desc = "The fourth gift to men, sliver of Astrata's fury against the horrors of Psydonia, bringing evyl to its knees at hands of Her devoted."
	background_icon = 'icons/mob/actions/astratamiracles.dmi'
	button_icon = 'icons/mob/actions/astratamiracles.dmi'
	button_icon_state = "bolt"
	sound = 'sound/magic/lightning.ogg'
	spell_color = GLOW_COLOR_ASTRATA
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = null

	projectile_type = /obj/projectile/magic/sacred_flame
	cast_range = SPELL_RANGE_PROJECTILE

	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = SPELLCOST_MIRACLE

	secondary_resource_type = SPELL_COST_STAMINA
	secondary_resource_cost = SPELLCOST_MAJOR_PROJECTILE

	invocations = list("Judgement of the Sun!")
	invocation_type = INVOCATION_SHOUT

	ignore_armor_penalty = TRUE
	charge_required = TRUE
	charge_time = CHARGETIME_MAJOR
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/holycharging.ogg'
	cooldown_time = 45 SECONDS

	associated_stat = null
	associated_skill = /datum/skill/magic/holy
	spell_tier = 0

	point_cost = 0

	spell_impact_intensity = SPELL_IMPACT_MEDIUM

	spell_flags = SPELL_PSYDON
	required_items = list(/obj/item/clothing/neck/roguetown/psicross/astrata, /obj/item/clothing/neck/roguetown/psicross/silver/astrata, /obj/item/clothing/neck/roguetown/psicross/undivided, /obj/item/clothing/neck/roguetown/psicross/silver/undivided)

/obj/projectile/magic/sacred_flame
	name = "bolt of holy fire"
	tracer_type = /obj/effect/projectile/tracer/stun
	muzzle_type = null
	impact_type = null
	hitscan = TRUE
	movement_type = UNSTOPPABLE
	guard_deflectable = TRUE
	light_color = "#a98107"
	damage = 50
	npc_simple_damage_mult = 2
	damage_type = BURN
	accuracy = 50 //Astrata show me true or something?
	nodamage = FALSE
	speed = 0.3
	flag = "fire"
	light_outer_range = 7

/obj/projectile/magic/sacred_flame/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] fizzles on contact with [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		if(isliving(target))
			var/mob/living/L = target
			if(out_of_effective_range())
				return
			L.electrocute_act(1, src, 1, SHOCK_NOSTUN)
			if(HAS_TRAIT(L, TRAIT_SILVER_WEAK))
				L.adjust_fire_stacks(4, /datum/status_effect/fire_handler/fire_stacks/sunder)
				L.Immobilize(0.5 SECONDS)
				L.ignite_mob()
			else
				L.adjust_fire_stacks(4)
				L.Immobilize(0.5 SECONDS)
				L.ignite_mob()
	else if(isatom(target))
		var/atom/A = target
		A.fire_act()
	qdel(src)

///////////////////////////
// T2 - Astratan Fortify //
///////////////////////////

/datum/action/cooldown/spell/miracle/fortify/astrata
	background_icon = 'icons/mob/actions/astratamiracles.dmi'
	button_icon = 'icons/mob/actions/astratamiracles.dmi'

////////////////////////////////////////////////////////////////
// T3 - Solar Eruption - Finisher for the rest of the spells. //
////////////////////////////////////////////////////////////////

/datum/action/cooldown/spell/astrata/miracle_pyre
	name = "Solar Pyre"
	desc = "Creates a pyre dedicated to Astrata, lasts 30 minutes."
	button_icon_state = "pyre"
	sound = 'sound/magic/astrata_choir.ogg'
	spell_color = GLOW_COLOR_ASTRATA
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	self_cast_possible = FALSE
	cast_range = 3

	primary_resource_cost = SPELLCOST_MIRACLE_MAJOR
	secondary_resource_cost = SPELLCOST_MIRACLE_MAJOR

	invocations = list("Let Her radiance guide us forward.")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = 3 SECONDS
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/holycharging.ogg'
	cooldown_time = 10 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_NO_MOVE | SPELL_REQUIRES_SAME_Z

	var/fire_type = /obj/machinery/light/rogue/campfire/miracle_pyre
	var/static/list/turf_blacklist = list(
		/turf/open/water,
		/turf/open/transparent,
		/turf/closed/transparent,
		)

/datum/action/cooldown/spell/astrata/miracle_pyre/cast(atom/cast_on)
	. = ..()
	var/turf/target = get_turf(cast_on)

	if(!target || !target.Enter(owner) || is_type_in_list(target, turf_blacklist))
		to_chat(owner, span_warning("This turf can't be on fiyaaaah! (It's blocked sire.)"))
		return FALSE

	new /obj/machinery/light/rogue/campfire/miracle_pyre(target)

	return TRUE

/obj/machinery/light/rogue/campfire/miracle_pyre
	name = "astrata's pyre"
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "pyre_astrata1"
	base_state = "pyre_astrata"
	density = FALSE
	layer = 2.8
	brightness = 10
	fueluse = 15 MINUTES
	color = GLOW_COLOR_ASTRATA
	bulb_colour = GLOW_COLOR_ASTRATA
	max_integrity = 150
	healing_range = 2
	var/lifespan = 15 MINUTES

/obj/machinery/light/rogue/campfire/miracle_pyre/process()
	..()
	if(isopenturf(loc))
		var/turf/open/O = loc
		if(IS_WET_OPEN_TURF(O))
			extinguish()

	if(on)
		var/list/hearers_in_range = get_hearers_in_LOS(healing_range, src, RECURSIVE_CONTENTS_CLIENT_MOBS)
		for(var/mob/living/carbon/human/human in hearers_in_range)
			var/distance = get_dist(src, human)
			if(distance > healing_range || HAS_TRAIT(human, TRAIT_IRONMAN))
				continue
			if(istype(human.patron, /datum/patron/divine))
				if(!human.has_status_effect(/datum/status_effect/buff/pyre))
					to_chat(human, span_info("Her warmth sutures my mangled body."))
				human.apply_status_effect(/datum/status_effect/buff/pyre)
				human.add_stress(/datum/stressevent/astrata_pyre)

/obj/machinery/light/rogue/campfire/miracle_pyre/Initialize()
	. = ..()
	if(lifespan)
		QDEL_IN(src, lifespan) //delete after it runs out

/obj/machinery/light/rogue/campfire/miracle_pyre/onkick(mob/user)
	var/mob/living/L = user
	L.visible_message(span_info("[L] kicks \the [src], the divine fire dissipating."))
	burn_out()
	qdel(src)

/atom/movable/screen/alert/status_effect/buff/healing/pyre
	name = "Radiant Pyre"
	desc = "I can rest under Her watchful gaze."
	icon_state = "astrata_pyre"

/datum/status_effect/buff/pyre
	id = "astratan_pyre"
	alert_type = /atom/movable/screen/alert/status_effect/buff/healing/pyre
	examine_text = "SUBJECTPRONOUN is basking in Her light."
	var/healing_on_tick_pyre = 3
	duration = 10 SECONDS

/datum/status_effect/buff/pyre/tick()
	if(!owner.cmode)
		healing_on_tick_pyre *= 2
		return
	if(HAS_TRAIT(owner, TRAIT_IRONMAN))
		return
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_rogue/campfire(get_turf(owner))
	H.color = GLOW_COLOR_ASTRATA
	if(owner.blood_volume < BLOOD_VOLUME_OKAY)
		owner.blood_volume = min(owner.blood_volume+healing_on_tick_pyre, BLOOD_VOLUME_OKAY)
	var/list/wCount = owner.get_wounds()
	if(length(wCount))
		owner.heal_wounds(healing_on_tick_pyre, list(/datum/wound/slash, /datum/wound/puncture, /datum/wound/bite, /datum/wound/bruise, /datum/wound/dynamic, /datum/wound/dislocation))
		owner.update_damage_overlays()
	owner.adjustBruteLoss(-healing_on_tick_pyre, 0)
	owner.adjustFireLoss(-healing_on_tick_pyre, 0)
	owner.adjustOxyLoss(-healing_on_tick_pyre, 0)
	owner.adjustToxLoss(-healing_on_tick_pyre, 0)
	owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -healing_on_tick_pyre)
	owner.adjustCloneLoss(-healing_on_tick_pyre, 0)
	owner.adjust_bodytemperature(8)

///////////////////////////////////////////////////////////////////////////
// T3 - Asbestine Cloak - Grant fire resistance to people around caster. //
///////////////////////////////////////////////////////////////////////////

/datum/action/cooldown/spell/astrata/firecloak
	name = "Asbestine Cloak"
	desc = "Cover yourself and adjacent targets in fire-resistant cloak."
	fluff_desc = "The third gift to men, for the devout are granted the right to witness Her glorious radiance with their own eyes without burning up into pile of ash."
	button_icon_state = "cloak"
	sound = 'sound/magic/haste.ogg'
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_STAT_BUFF

	invocations = list("Bask in Her radiance.")
	invocation_type = INVOCATION_WHISPER

	charge_required = TRUE
	charge_time = 1 SECONDS
	hold_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/holycharging.ogg'
	cooldown_time = 1.5 MINUTES

	associated_skill = null
	spell_tier = 0

	point_cost = 0

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/astrata/firecloak/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	H.visible_message("[H] mutters an incantation and a dim pulse of light radiates out from them.")
	for(var/mob/living/L in range(1, H))
		L.apply_status_effect(/datum/status_effect/buff/dragonhide/astrata)

	return TRUE

//////////////////////////////
// T3 - Anastasis - Revive. //
//////////////////////////////

/obj/effect/proc_holder/spell/invoked/revive
	name = "Anastasis"
	desc = "Focus Astratas energy through a stationary psycross, reviving the target from death."
	action_icon = 'icons/mob/actions/astratamiracles.dmi'
	overlay_icon = 'icons/mob/actions/astratamiracles.dmi'
	overlay_state = "revive"
	releasedrain = 90
	chargedrain = 0
	chargetime = 50
	range = 1
	warnie = "sydwarning"
	no_early_release = TRUE
	movement_interrupt = TRUE
	chargedloop = /datum/looping_sound/invokeholy
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/revive.ogg'
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 2 MINUTES
	miracle = TRUE
	devotion_cost = 80
	/// Amount of PQ gained for reviving people
	var/revive_pq = PQ_GAIN_REVIVE

/obj/effect/proc_holder/spell/invoked/revive/start_recharge()
	var/old_recharge = recharge_time
	// Because the cooldown for anastasis is so incredibly low, not having tech impacts them more heavily than other faiths
	var/tech_resurrection_modifier = SSchimeric_tech.get_resurrection_multiplier()
	if(tech_resurrection_modifier > 1)
		recharge_time = initial(recharge_time) * (tech_resurrection_modifier * 1.25)
	else
		recharge_time = initial(recharge_time)
	if(charge_counter >= old_recharge && old_recharge > 0)
		charge_counter = recharge_time
	. = ..()

/obj/effect/proc_holder/spell/invoked/revive/cast(list/targets, mob/living/user)
	..()

	if(!isliving(targets[1]))
		revert_cast()
		return FALSE

	var/mob/living/target = targets[1]
	if(!target.check_revive(user))
		revert_cast()
		return FALSE
	if(GLOB.tod == "night")
		to_chat(user, span_warning("Let there be light."))
	for(var/obj/structure/fluff/psycross/S in oview(5, user))
		S.AOE_flash(user, range = 8)
	if(target.mob_biotypes & MOB_UNDEAD) //positive energy harms the undead
		if(alert(user, "[target]'s body rattles and seizes under the divine force. This will likely unmake them permanently. Continue?", "Divine Revival", "PURGE THE UNCLEAN!", "Stop") != "PURGE THE UNCLEAN!")
			to_chat(user, span_notice("You halt the rite before the divine force can fully take hold."))
			revert_cast()
			return FALSE
		target.visible_message(span_danger("[target] is unmade by divine magic!"), span_userdanger("Holy power tears my undead form apart!"))
		playsound(target.loc, 'sound/magic/churn.ogg', 100, TRUE)
		target.dust()
		return TRUE
	if(alert(target, "They are calling for you. Are you ready?", "Revival", "I need to wake up", "Don't let me go") != "I need to wake up")
		target.visible_message(span_astrata("Nothing happens. They are not being let go."))
		return FALSE
	target.adjustOxyLoss(-target.getOxyLoss()) //Ye Olde CPR
	if(!target.revive(full_heal = FALSE))
		to_chat(user, span_warning("Nothing happens."))
		revert_cast()
		return FALSE

	var/mob/living/carbon/spirit/underworld_spirit = target.get_spirit()
	//GET OVER HERE!
	if(underworld_spirit)
		var/mob/dead/observer/ghost = underworld_spirit.ghostize()
		qdel(underworld_spirit)
		ghost.mind.transfer_to(target, TRUE)
	target.grab_ghost(force = TRUE) // even suicides
	target.emote("breathgasp")
	target.Jitter(100)
	record_round_statistic(STATS_ASTRATA_REVIVALS)
	target.update_body()
	target.visible_message(span_astrata("[target] is revived by holy light!"), span_green("I awake from the void."))
	if(revive_pq && !HAS_TRAIT(target, TRAIT_IWASREVIVED) && user?.ckey)
		adjust_playerquality(revive_pq, user.ckey)
		ADD_TRAIT(target, TRAIT_IWASREVIVED, "[type]")
	target.mind.remove_antag_datum(/datum/antagonist/zombie)
	target.remove_status_effect(/datum/status_effect/debuff/rotted_zombie)	//Removes the rotted-zombie debuff if they have it - Failsafe for it.
	target.apply_status_effect(/datum/status_effect/debuff/revived)	//Temp debuff on revive, your stats get hit temporarily. Doubly so if having rotted.
	return TRUE

/obj/effect/proc_holder/spell/invoked/revive/cast_check(skipcharge, mob/user = usr)
	if(!..())
		return FALSE
	var/found = null
	for(var/obj/structure/fluff/psycross/S in oview(5, user))
		found = S
	if(!found)
		to_chat(user, span_warning("I need a holy cross."))
		return FALSE
	return TRUE




// =====================
// Immolation Component
// =====================
/datum/component/immolation
	var/mob/living/carbon/caster
	var/mob/living/carbon/partner
	var/duration = 360 SECONDS
	var/max_distance = 7
	var/self_damage
	var/base_damage
	var/damage_amplifier
	var/target_bonus = 0.75
	var/simple_mob_bonus = 2.5
	var/ispartner = FALSE
	var/immolate = FALSE
	can_transfer = TRUE
	var/damage_cooldown = 1 SECONDS // Damage applied every second
	var/next_damage = 0
	var/message_cooldown = 8 SECONDS
	var/next_message = 0

/datum/component/immolation/partner
	ispartner = TRUE
	immolate = TRUE

/datum/component/immolation/Initialize(mob/living/partner_mob, mob/living/carbon/caster_mob, var/holy_skill, var/is_astrata)
	if(!isliving(parent) || !iscarbon(partner_mob))
		return COMPONENT_INCOMPATIBLE

	// Prevent duplicate immolation
	if(parent.GetComponent(/datum/component/immolation))
		return COMPONENT_INCOMPATIBLE

	caster = caster_mob
	partner = partner_mob

	// Configure damage based on patron and skill
	base_damage = 8
	self_damage = 0.95
	damage_amplifier = 0.95

	if(holy_skill >= 3)
		self_damage -= 0.1 // 85%
		damage_amplifier += 0.15 // 110%
	if(is_astrata)
		self_damage -= 0.1 // 75%
		damage_amplifier += 0.15 // 125%

	// Set up processing and expiration
	START_PROCESSING(SSprocessing, src)
	RegisterSignal(parent, COMSIG_LIVING_MIRACLE_HEAL_APPLY, PROC_REF(on_heal))
	RegisterSignal(parent, COMSIG_PARENT_QDELETING, PROC_REF(on_deletion))
	addtimer(CALLBACK(src, .proc/remove_immolation), duration)

	// Apply visual effect
	var/mob/living/L = parent
	if(parent == caster)
		L.apply_status_effect(/datum/status_effect/immolation, FALSE)
	else
		L.apply_status_effect(/datum/status_effect/immolation, TRUE)
	return ..()

/datum/component/immolation/proc/on_deletion()
	remove_immolation()

/datum/component/immolation/proc/on_heal()
	// Healing is removed.
	partner.remove_status_effect(/datum/status_effect/buff/healing)

/datum/component/immolation/process()
	if(!istype(partner) || !istype(caster) || partner.stat == DEAD || caster.stat != CONSCIOUS || get_dist(partner, caster) > max_distance)
		remove_immolation()
		return FALSE
	return TRUE

/datum/component/immolation/partner/process()
	if(!..()) // Parent handles removal checks
		return

	if(world.time < next_damage)
		return
	next_damage = world.time + damage_cooldown

	// Get all living mobs in 2 tiles range
	var/list/targets = list()
	for(var/mob/living/L in view(2, partner))
		if(L == partner || L == caster || L.stat == DEAD)
			continue
		targets += L

	var/num_targets = targets.len
	var/damage_modifier = damage_amplifier + (target_bonus * (num_targets - 1))
	var/total_damage = base_damage * damage_modifier
	var/damage_per_target = num_targets > 0 ? total_damage / num_targets : 0

	// Apply damage to targets
	for(var/mob/living/target in targets)
		// Apply to random limb for carbons
		if(iscarbon(target))
			var/mob/living/carbon/C = target
			var/static/list/valid_limbs = list(
				BODY_ZONE_CHEST,
				BODY_ZONE_L_ARM,
				BODY_ZONE_R_ARM,
				BODY_ZONE_L_LEG,
				BODY_ZONE_R_LEG
			)

			// Get all existing limbs that are valid
			var/list/obj/item/bodypart/possible_limbs = list()
			for(var/zone in valid_limbs)
				var/obj/item/bodypart/BP = C.get_bodypart(zone)
				if(BP)
					possible_limbs += BP

			if(possible_limbs.len)
				// Select random limb
				var/obj/item/bodypart/BP = pick(possible_limbs)
				BP.receive_damage(damage_per_target)

				if(world.time > next_message)
					C.visible_message(span_danger("[C]'s [BP.name] is cut by holy flames!"))
					next_message = world.time + message_cooldown
				target.update_damage_overlays()

				// Dismember limb if damage exceeds max
				if(BP.brute_dam >= BP.max_damage)
					BP.dismember()
					C.visible_message(span_danger("[C]'s [BP.name] is dismembered violently by cutting flames!"))
		else
			// Simple brute damage for non-carbons
			target.adjustBruteLoss(damage_per_target * simple_mob_bonus)
			if(world.time > next_message)
				target.visible_message(span_danger("[target] is cut by holy flames!"))
				next_message = world.time + message_cooldown

	// Apply self-damage to caster
	if(num_targets > 0)
		partner.adjustBruteLoss(base_damage * self_damage)
	else
		partner.adjustBruteLoss(1) // Minimal damage when no targets

/datum/component/immolation/proc/remove_immolation()
	var/mob/living/L = parent
	if(L)
		L.remove_status_effect(/datum/status_effect/immolation)
		UnregisterSignal(L, list(
			COMSIG_LIVING_MIRACLE_HEAL_APPLY,
			COMSIG_PARENT_QDELETING
		))

	if(partner)
		partner.remove_status_effect(/datum/status_effect/immolation)
		var/datum/component/immolation/other = partner.GetComponent(/datum/component/immolation)
		if(other)
			other.partner = null
			qdel(other)

	partner = null
	STOP_PROCESSING(SSprocessing, src)
	qdel(src)

// =====================
// Immolation Spell
// =====================
/obj/effect/proc_holder/spell/invoked/immolation
	name = "Immolation"
	desc = "Ignite a target in holy flames, burning those that surround them. The fire burns brighter within devout Astratans."
	action_icon = 'icons/mob/actions/astratamiracles.dmi'
	overlay_icon = 'icons/mob/actions/astratamiracles.dmi'
	overlay_state = "immolation"
	range = 2
	chargetime = 0.5 SECONDS
	invocations = list("The Sun cleanses!")
	sound = 'sound/magic/fireball.ogg'
	recharge_time = 600 SECONDS
	miracle = TRUE
	devotion_cost = 60
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/immolation/cast(list/targets, mob/living/user)
	var/mob/living/carbon/target = targets[1]

	var/datum/component/immolation/existing = user.GetComponent(/datum/component/immolation)
	if(existing)
		to_chat(user, span_warning("You are already channeling someone"))
		revert_cast()
		return FALSE

	if(!istype(target, /mob/living/carbon) || target == user)
		revert_cast()
		return FALSE

	if(spell_guard_check(target, TRUE))
		target.visible_message(span_warning("[target] resists the immolation!"))
		return TRUE

	// Channeling requirement
	user.visible_message(span_danger("[user] begins lighting [target] ablaze with strange, divine fire!"))
	if(!do_after(user, 1 SECONDS, target = target))
		to_chat(user, span_warning("Astratan might requires unwavering focus to channel!"))
		revert_cast()
		return FALSE

	// Get caster properties
	var/holy_skill = target.get_skill_level(associated_skill)
	var/is_astrata = (istype(target.patron, /datum/patron/divine/astrata))

	// Apply component
	user.AddComponent(/datum/component/immolation, target, user, holy_skill, is_astrata)
	target.AddComponent(/datum/component/immolation/partner, target, user, holy_skill, is_astrata)

	// Visual feedback
	user.visible_message(span_astrata("Holy flames erupt from [user]'s hands and engulf [target]!"))
	if(!is_astrata)
		target.visible_message(span_danger("[target] lights ablaze with sacred fire. Fire cutting like a blade in a small area around them."))
	else
		target.visible_message(span_danger("[target] lights ablaze with a grand, roaring pyre of divinity. Fire slashing violently like a blade in a small area around them."))
	return TRUE

// =====================
// Immolation Status Effect
// =====================
#define IMMOLATION_FILTER "immolation_glow"

/datum/status_effect/immolation
	id = "immolation"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/immolation
	var/outline_colour = "#FF4500"
	var/flaming_hot = FALSE

/atom/movable/screen/alert/status_effect/immolation
	name = "Immolated"
	desc = "Holy flames consume you! Anyone will be cut down for stepping near."
	icon_state = "immolation"

/datum/status_effect/immolation/on_creation(mob/living/new_owner, light_ablaze)
	flaming_hot = light_ablaze
	. = ..()
	if(!flaming_hot)
		linked_alert.desc = "I'm channeling Immolation onto someone to burn all those that step near, I must remain close to them."

/datum/status_effect/immolation/on_apply()
	if(!owner.get_filter(IMMOLATION_FILTER))
		owner.add_filter(IMMOLATION_FILTER, 2, list(
			"type" = "outline",
			"color" = outline_colour,
			"alpha" = 60,
			"size" = 2,
		))
	if(flaming_hot)
		new/obj/effect/dummy/lighting_obj/moblight/fire(owner)
		var/fire_icon = "Generic_mob_burning"
		var/mutable_appearance/new_fire_overlay = mutable_appearance('icons/mob/OnFire.dmi', fire_icon, -FIRE_LAYER)
		new_fire_overlay.color = list(0,0,0, 0,0,0, 0,0,0, 1,1,1)
		new_fire_overlay.appearance_flags = RESET_COLOR
		owner.overlays_standing[FIRE_LAYER] = new_fire_overlay
		owner.apply_overlay(FIRE_LAYER)
	return TRUE

/datum/status_effect/immolation/on_remove()
	owner.remove_filter(IMMOLATION_FILTER)
	if(flaming_hot)
		for(var/obj/effect/dummy/lighting_obj/moblight/fire/F in owner)
			qdel(F)
			owner.remove_overlay(FIRE_LAYER)

#undef IMMOLATION_FILTER
