/obj/structure/bed/rogue/sanctuary
	name = "sanctuary bed"
	desc = "A bed of magical flora."
	sleepy = 4
	debris = null
	max_integrity = 50
	hidingspot = FALSE

	/// Ref status effect to apply to occupants
	var/status_effect_type = /datum/status_effect/buff/healing/bed_rest
	var/list/occupants = list()
	var/next_heal_time = 0
	var/heal_cooldown = 10 SECONDS

/obj/structure/bed/rogue/sanctuary/Initialize(mapload)
	. = ..()
	var/random_rotation = pick(0, 180)
	if(random_rotation != 0)
		var/matrix/M = matrix()
		M.Turn(random_rotation)
		transform = M

/obj/structure/bed/rogue/sanctuary/Crossed(atom/movable/AM)
	. = ..()
	if(isliving(AM))
		check_and_register_occupant(AM)

/obj/structure/bed/rogue/sanctuary/post_buckle_mob(mob/living/M)
	. = ..()
	check_and_register_occupant(M)

/obj/structure/bed/rogue/sanctuary/proc/check_and_register_occupant(mob/living/L)
	if(!istype(L) || L.loc != src.loc)
		return

	for(var/datum/weakref/W in occupants)
		if(W.resolve() == L)
			return

	occupants += WEAKREF(L)
	START_PROCESSING(SSobj, src)

/obj/structure/bed/rogue/sanctuary/process(seconds_per_tick)
	if(!occupants.len)
		STOP_PROCESSING(SSobj, src)
		return

	var/mob/living/priority_target = null
	var/max_priority_score = -1

	for(var/datum/weakref/W in occupants)
		var/mob/living/L = W.resolve()

		if(!L || L.loc != src.loc)
			occupants -= W
			continue

		if(L.has_status_effect(status_effect_type))
			continue

		if(L.mobility_flags & MOBILITY_STAND)
			continue

		var/score = calculate_priority(L)
		if(score > max_priority_score)
			max_priority_score = score
			priority_target = L

	if(priority_target && world.time >= next_heal_time)
		priority_target.apply_status_effect(status_effect_type)
		next_heal_time = world.time + heal_cooldown

/// Hook for subtypes to define who gets healed first
/obj/structure/bed/rogue/sanctuary/proc/calculate_priority(mob/living/L)
	return L.getOxyLoss() + L.getBruteLoss()

/datum/status_effect/buff/healing/bed_rest
	id = "eora_bed"
	alert_type = /atom/movable/screen/alert/status_effect/buff/healing/eora_bed
	// Smoother than 10 seconds with the bed CD
	duration = 11 SECONDS
	healing_on_tick = 0.5
	outline_colour = "#d04ae2"

/atom/movable/screen/alert/status_effect/buff/healing/eora_bed
	name = "Eora's reprieve"
	desc = "The warmth of the petals soothes my breathing and heals my ails."
	icon_state = "eorabed"

/datum/status_effect/buff/healing/bed_rest/tick()
	if(!owner || owner.stat == DEAD)
		return

	spawn_visual()
	var/bleeding = owner.bleed_rate > 1

	owner.heal_wounds(healing_on_tick)
	owner.adjustBruteLoss(-healing_on_tick, 0)
	owner.adjustFireLoss(-healing_on_tick, 0)
	owner.adjustToxLoss(-healing_on_tick, 0)
	owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -0.5)

	if(owner.blood_volume < BLOOD_VOLUME_OKAY && !bleeding)
		owner.blood_volume = min(owner.blood_volume + healing_on_tick, BLOOD_VOLUME_OKAY)
	if(!bleeding)
		owner.adjustOxyLoss(-healing_on_tick, 0)

/datum/status_effect/buff/healing/bed_rest/proc/spawn_visual()
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
	H.color = outline_colour

/obj/structure/bed/rogue/sanctuary/eora
	name = "flower bed"
	desc = "A bed of flower petals that looks soft enough to sleep on! Said to spare the dying from Necra's domain."
	icon_state = "eora"
	status_effect_type = /datum/status_effect/buff/healing/bed_rest

/datum/action/cooldown/spell/summon_bed
	name = "Summon Sanctuary Bed"
	desc = "Summon a sacred bed."
	background_icon = 'icons/mob/actions/eoramiracles.dmi'
	button_icon = 'icons/mob/actions/eoramiracles.dmi'
	sound = 'sound/magic/holyshield.ogg'

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_STAT_BUFF

	invocation_type = INVOCATION_SHOUT
	charge_required = TRUE
	charge_time = 1 SECONDS
	cooldown_time = 30 SECONDS
	devotion_cost = 40

	associated_skill = /datum/skill/magic/holy

	/// Type of bed spawned by this spell
	var/bed_type = /obj/structure/bed/rogue/sanctuary/eora
	/// Base maximum beds allowed regardless of skill
	var/base_max_beds = 1
	/// Whether skill scaling applies to max beds
	var/scale_with_skill = TRUE
	/// Active bed references
	var/list/bed_refs = list()

/datum/action/cooldown/spell/summon_bed/proc/get_max_beds(mob/living/user)
	if(!scale_with_skill)
		return base_max_beds

	var/holy_skill = user.get_skill_level(associated_skill)
	if(holy_skill >= 5)
		return 3
	if(holy_skill >= 4)
		return 2
	return base_max_beds

/datum/action/cooldown/spell/summon_bed/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!user)
		return FALSE

	var/turf/T = get_turf(cast_on) || get_turf(user)

	if(!isopenturf(T) || T.density)
		to_chat(user, span_warning("The ground here is unsuitable for a sanctuary."))
		return FALSE

	if(locate(/obj/structure/bed) in T)
		to_chat(user, span_warning("There is already a bed here!"))
		return FALSE

	var/max_beds = get_max_beds(user)

	for(var/datum/weakref/W in bed_refs)
		if(!W.resolve())
			bed_refs -= W

	while(bed_refs.len >= max_beds)
		var/datum/weakref/oldest_W = bed_refs[1]
		var/obj/structure/bed/rogue/sanctuary/old_bed = oldest_W.resolve()
		if(old_bed && !QDELETED(old_bed))
			old_bed.visible_message(span_notice("\The [old_bed] fades away as a new one is summoned."))
			qdel(old_bed)
		bed_refs.Cut(1, 2)

	var/obj/structure/bed/rogue/sanctuary/new_bed = new bed_type(T)
	bed_refs += WEAKREF(new_bed)
	user.visible_message(
		span_notice("[user] conjures \a [new_bed]!"),
		span_notice("You summon a sanctuary for the weary.")
	)
	return TRUE

/datum/action/cooldown/spell/summon_bed/Destroy()
	for(var/datum/weakref/W in bed_refs)
		var/obj/structure/bed/rogue/sanctuary/B = W.resolve()
		if(B)
			qdel(B)
	bed_refs.Cut()
	return ..()

/datum/action/cooldown/spell/summon_bed/eora
	name = "Eora's Rest"
	desc = "Summon a sacred Eoran bed to provide sanctuary and soothe the wounded. \
	You may only maintain a limited amount of beds at a time depending on miracle skill."
	button_icon_state = "eorabed"
	spell_color = "#b74ae2"
	invocations = list("Eora, grant us respite!")
	bed_type = /obj/structure/bed/rogue/sanctuary/eora
