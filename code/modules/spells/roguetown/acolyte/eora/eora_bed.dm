/obj/structure/bed/rogue/eora
	name = "flower bed"
	desc = "A bed of flower petals that looks soft enough to sleep on! Said to spare the dying from Necra's domain."
	sleepy = 4
	debris = null
	max_integrity = 50
	icon_state = "eora"
	hidingspot = FALSE
	var/list/occupants = list()
	var/next_heal_time = 0
	var/heal_cooldown = 10 SECONDS

/obj/structure/bed/rogue/eora/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_SLEEPING_ON_BED, PROC_REF(on_sleeper))
	var/random_rotation = pick(0, 180)
	if(random_rotation != 0)
		var/matrix/M = matrix()
		M.Turn(random_rotation)
		transform = M

/obj/structure/bed/rogue/eora/proc/on_sleeper(datum/source, mob/living/L)
	SIGNAL_HANDLER

	if(!istype(L))
		return

	for(var/datum/weakref/W in occupants)
		if(W.resolve() == L)
			return

	occupants += WEAKREF(L)
	START_PROCESSING(SSobj, src)

/obj/structure/bed/rogue/eora/process(seconds_per_tick)
	if(!occupants.len)
		STOP_PROCESSING(SSobj, src)
		return

	var/mob/living/priority_target = null
	var/max_oxy = -1 // Start below 0 to catch people even with 0 oxy loss
	var/max_brute = -1 // Brute if oxy is 0.

	for(var/datum/weakref/W in occupants)
		var/mob/living/L = W.resolve()

		if(!L || L.loc != src.loc || (L.mobility_flags & MOBILITY_STAND))
			occupants -= W
			continue

		if(L.has_status_effect(/datum/status_effect/buff/healing/bed_rest))
			continue

		var/current_oxy = L.getOxyLoss()
		var/current_brute = L.getBruteLoss()
		if(current_oxy > max_oxy)
			max_oxy = current_oxy
			priority_target = L
			max_brute = current_brute 

		else if(current_oxy == max_oxy && !priority_target)
			if(current_brute > max_brute)
				max_brute = current_brute
				priority_target = L

	if(priority_target && world.time >= next_heal_time)
		priority_target.apply_status_effect(/datum/status_effect/buff/healing/bed_rest)
		next_heal_time = world.time + heal_cooldown

/obj/structure/bed/rogue/eora/Destroy()
	. = ..()
	UnregisterSignal(src, COMSIG_SLEEPING_ON_BED)

/datum/status_effect/buff/healing/bed_rest
	id = "eora_bed"
	alert_type = /atom/movable/screen/alert/status_effect/buff/healing/eora_bed
	// Smoother than 10 seconds with the bed CD
	duration = 11 SECONDS
	healing_on_tick = 0.5
	var/oxy_healing_on_tick = 5
	outline_colour = "#d04ae2"

/atom/movable/screen/alert/status_effect/buff/healing/eora_bed
	name = "Eora's reprieve"
	desc = "The warmth of the petals soothes my breathing and heals my ails."
	icon_state = "eorabed"

/datum/status_effect/buff/healing/bed_rest/tick()
	if(!owner || owner.stat == DEAD)
		return
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
	H.color = outline_colour

	owner.heal_wounds(healing_on_tick)
	owner.adjustBruteLoss(-healing_on_tick, 0)
	owner.adjustFireLoss(-healing_on_tick, 0)
	owner.adjustToxLoss(-healing_on_tick, 0)

	owner.adjustOxyLoss(-oxy_healing_on_tick, 0)
	owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -0.5)
	if(owner.blood_volume < BLOOD_VOLUME_NORMAL)
		owner.blood_volume = min(owner.blood_volume+healing_on_tick, BLOOD_VOLUME_NORMAL)

/datum/action/cooldown/spell/summon_bed
	name = "Eora's Rest"
	desc = "Summon a sacred Eoran bed to provide sanctuary and stabilize the wounded. \
	You may only maintain a limited amount of beds at a time depending on miracle skill. Summoning a new one will cause the oldest one to vanish."
	button_icon = 'icons/mob/actions/eoramiracles.dmi'
	button_icon_state = "eorabed" // Replace with your icon state
	sound = 'sound/magic/holyshield.ogg'
	spell_color = "#b74ae2"

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_STAT_BUFF

	invocations = list("Eora, provider of beauty-sleeps!")
	invocation_type = INVOCATION_SHOUT
	charge_required = TRUE
	charge_time = 1 SECONDS
	cooldown_time = 30 SECONDS
	devotion_cost = 40

	associated_skill = /datum/skill/magic/holy
	var/list/bed_refs = list()

/datum/action/cooldown/spell/summon_bed/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!user)
		return FALSE

	var/turf/T = get_turf(cast_on) || get_turf(user)

	if(!isopenturf(T) || T.density)
		to_chat(user, span_warning("The ground here is unsuitable for a sanctuary."))
		return FALSE

	var/max_beds = 1
	var/holy_skill = user.get_skill_level(/datum/skill/magic/holy)

	if(holy_skill >= 5)
		max_beds = 3
	else if(holy_skill >= 4)
		max_beds = 2

	for(var/datum/weakref/W in bed_refs)
		if(!W.resolve())
			bed_refs -= W

	if(bed_refs.len >= max_beds)
		var/datum/weakref/oldest_W = bed_refs[1]
		var/obj/structure/bed/rogue/eora/old_bed = oldest_W.resolve()
		if(old_bed && !QDELETED(old_bed))
			old_bed.visible_message(span_nicegreen("The bed fades as a new one is summoned."))
			qdel(old_bed)
		bed_refs.Cut(1, 2)

	var/obj/structure/bed/rogue/eora/new_bed = new(T)
	bed_refs += WEAKREF(new_bed)
	user.visible_message(span_notice("[user] conjures a beautiful bed of Eoran petals!"), \
						 span_notice("You summon a sanctuary for the weary."))

	return TRUE

/datum/action/cooldown/spell/summon_bed/Destroy()
	for(var/datum/weakref/W in bed_refs)
		var/obj/structure/bed/rogue/eora/B = W.resolve()
		if(B)
			qdel(B)
	bed_refs.Cut()
	return ..()
