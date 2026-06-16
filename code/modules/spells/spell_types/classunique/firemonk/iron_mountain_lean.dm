/datum/action/cooldown/spell/iron_mountain
	name = "Iron Mountain Lean"
	desc = "An expensive attack that deals considerable damage to the target, \
		along with inflicting a significant amount of Burn based on a dice roll (20-35). \
		Empowering (7+ momentum) improves your dice roll (25-40). \
		If your target defends against the strike, you will be left exposed and slowed."
	button_icon = 'icons/mob/actions/classuniquespells/firemonk.dmi'
	button_icon_state = "iron_mountain"
	sound = 'sound/magic/firemonk/dash.ogg'
	spell_color = GLOW_COLOR_FIREMONK
	glow_intensity = GLOW_INTENSITY_MEDIUM

	cast_range = 7

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_SB_ULT

	invocations = list("TIĒSHĀNKÀO!!!") //tl: lit. iron mountain lean. 
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = FALSE
	charge_time = CHARGETIME_MAJOR
	charge_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/charging_fire.ogg'
	cooldown_time = 60 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 5
	spell_impact_intensity = SPELL_IMPACT_HIGH
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/max_range = 5
	var/damage = 40
	var/burn_stacks = 6
	var/momentum_cost = 5
	var/empower_cost = 7

// dead simple proc helper - uses forcemove but i thiiiink it should be fine?
/datum/action/cooldown/spell/iron_mountain/proc/dash_to(mob/living/carbon/human/owner, turf/destination, mob/living/target)
	var/turf/origin = get_turf(owner)
	new /obj/effect/temp_visual/decoy/fading/halfsecond(origin, owner)
	owner.forceMove(destination)
	owner.dir = get_dir(owner, target)

/datum/action/cooldown/spell/iron_mountain/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/H = owner
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M || M.stacks < momentum_cost)
		return FALSE
	return TRUE

/datum/action/cooldown/spell/iron_mountain/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/user = owner
	var/mob/living/carbon/victim = cast_on
	if(!istype(user))
		return

	if(!isliving(victim))
		return FALSE

	if(user.z != victim.z)
		return FALSE
	if(victim == user)
		return FALSE

	if(!istype(user))
		return

	var/datum/status_effect/buff/arcyne_momentum/M = user.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M || M.stacks < momentum_cost)
		to_chat(user, span_warning("Not enough momentum! I need at least [momentum_cost] stacks!"))
		return

	var/turf/owner_turf = get_turf(owner)
	if(owner_turf)
		var/dragon_dir = get_dir(user, victim)
		var/obj/effect/temp_visual/dragon_face/D = new(owner_turf)
		D.dir = dragon_dir
	user.visible_message(span_danger("[user] raises a flaming dragon with their fists!"))
	
	playsound(user, 'sound/magic/firemonk/hit1.ogg', 80, TRUE)
	
	sleep(20)

	// Check and consume momentum for empowerment
	var/empowered = FALSE
	M = user.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(M && M.stacks >= momentum_cost)
		M.consume_stacks(momentum_cost)
		empowered = TRUE
		burn_stacks = rand(25,40)
		to_chat(user, span_notice("[momentum_cost] momentum released — dice roll improved!"))

	if(empowered)
		burn_stacks = rand(25,40)
	else
		burn_stacks = rand(20,35)

	if(!victim || !user) //one last check to prevent runtimes
		return
	var/turf/dest = get_ranged_target_turf_direct(user, victim, get_dist(user, victim) + 2)
	if(!dest)
		dest = get_turf(victim)
	dash_to(user, dest, victim)
	arcyne_strike(user, victim, null, damage, BCLASS_BLUNT, spell_name = "Iron Mountain Lean", skip_animation = TRUE, skip_message = TRUE)
	victim.apply_burn(burn_stacks)
	user.visible_message(span_danger("[user] smothers [victim] in flames!"))
	playsound(user, 'sound/magic/firemonk/mountainlean.ogg', 80, FALSE)
	var/deflected = FALSE
	if(spell_guard_check(victim, FALSE, deflected ? null : user))
		if(!deflected)
			deflected = TRUE
			user.Slowdown(10)
	sleep(0.3 SECONDS)

/obj/effect/temp_visual/dragon_face
	icon = 'icons/effects/96x96.dmi'
	icon_state = "dragon"
	light_outer_range = 1
	duration = 20
	layer = ABOVE_ALL_MOB_LAYER
	pixel_x = -32
	pixel_y = -32
