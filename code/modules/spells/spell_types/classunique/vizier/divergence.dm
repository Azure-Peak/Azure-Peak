/datum/action/cooldown/spell/vizier/divergence
	name = "Divergence"
	desc = "Shatters a target across several competing timelines, briefly immobilizing them and spawning 4 to 8 Time Echoes around them. Recovering an echo restores the target's vitality, while destroying one forces reality to violently reconcile the contradiction, inflicting damage."
	fluff_desc = "The Naledi teach that every living thing exists atop an endless lattice of unrealized possibilities. Divergence tears open that lattice and scatters fragments of a victim's fate across nearby histories. To reclaim an echo is to remember a life that almost was. To destroy one is to deny that possibility ever existed, and reality rarely forgives the contradiction."
	button_icon_state = "divergence"
	sound = list('sound/magic/regression1.ogg', 'sound/magic/regression2.ogg', 'sound/magic/regression3.ogg')
	cast_range = 5
	self_cast_possible = TRUE
	charge_required = FALSE
	cooldown_time = 60 SECONDS
	invocations = list("Naf'ir! Diverge, timeline!")
	invocation_type = INVOCATION_SHOUT

/datum/action/cooldown/spell/vizier/divergence/cast(atom/cast_on)
	. = ..()
	var/mob/living/target = cast_on
	if(!istype(target))
		return FALSE
	target.visible_message(span_blue("Origin Magick shatters [target] across diverging timelines!"), span_blue("I feel myself pulled apart into countless possibilities! I'm not here-- I'm there-- Huh?? Where??"))
	target.apply_status_effect(/datum/status_effect/debuff/divergence, owner)
	return TRUE


/datum/status_effect/debuff/divergence
	id = "divergence"
	duration = 20 SECONDS

	var/list/fragments = list()

	var/heal_per_fragment = 14
	var/damage_per_fragment = 22

	var/mob/living/caster

/datum/status_effect/debuff/divergence/on_creation(mob/living/new_owner, mob/living/new_caster)
	. = ..()

	caster = new_caster

/datum/status_effect/debuff/divergence/on_apply()
	. = ..()

	if(!owner)
		return

	var/turf/center = get_turf(owner)

	owner.Immobilize(3 SECONDS)

	owner.visible_message(
		span_warning("[owner]'s timeline fractures apart!"),
		span_notice("I can feel pieces of myself scattered around me!")
	)

	spawn_fragments(center)

/datum/status_effect/debuff/divergence/on_remove()
	. = ..()

	for(var/obj/effect/divergence_fragment/F in fragments)
		if(!QDELETED(F))
			qdel(F)

	fragments.Cut()

/datum/status_effect/debuff/divergence/proc/spawn_fragments(turf/center)
	if(!center || !owner)
		return

	var/list/candidates = list()

	for(var/turf/T in range(3, center))
		if(T == center)
			continue

		if(get_dist(center, T) < 1)
			continue

		if(arcyne_validate_blink_dest(T, owner))
			continue

		candidates += T

	if(!length(candidates))
		return

	var/list/chosen = list()
	var/count = rand(4, 8)
	var/attempts = 0

	while(length(chosen) < count && attempts < 100)
		attempts++

		var/turf/T = pick(candidates)

		var/valid = TRUE

		for(var/turf/other in chosen)
			if(get_dist(T, other) <= 1)
				valid = FALSE
				break

		if(!valid)
			continue

		chosen += T
		candidates -= T

	for(var/turf/T in chosen)
		var/obj/effect/divergence_afterimage/A = new(center)

		A.appearance = new /mutable_appearance(owner)
		A.color = "#A8C8FF"
		A.alpha = 180

		var/dx = (T.x - center.x) * 32
		var/dy = (T.y - center.y) * 32

		A.pixel_x = rand(-8, 8)
		A.pixel_y = rand(-8, 8)

		animate(A, pixel_x = dx + rand(-12, 12), pixel_y = dy + rand(-12, 12), alpha = 0, transform = matrix() * rand(80, 120) / 100, time = rand(3, 6))
		addtimer(CALLBACK(src, PROC_REF(spawn_fragment), T), rand(3, 6))

/obj/effect/divergence_fragment
	name = "temporal simulacrum"
	desc = "A discarded possibility struggling to remain real."
	density = TRUE
	anchored = TRUE
	alpha = 140
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_OPAQUE

	var/datum/status_effect/debuff/divergence/master
	var/collapsing = FALSE

/obj/effect/divergence_fragment/Initialize()
	. = ..()

	addtimer(CALLBACK(src, PROC_REF(start_jitter)), 4)
	addtimer(CALLBACK(src, PROC_REF(range_check)), 10, TIMER_LOOP)

	return INITIALIZE_HINT_NORMAL

/obj/effect/divergence_fragment/proc/start_jitter()
	if(QDELETED(src))
		return

	addtimer(CALLBACK(src, PROC_REF(jitter)), 1, TIMER_LOOP)

/obj/effect/divergence_fragment/proc/enable_collision()
	if(QDELETED(src))
		return

	density = TRUE

	addtimer(CALLBACK(src, PROC_REF(jitter)), 1, TIMER_LOOP)

/obj/effect/divergence_fragment/proc/range_check()
	if(QDELETED(src))
		return

	if(!master || !master.owner)
		qdel(src)
		return

	var/mob/living/M = master.owner
	if(!istype(M))
		qdel(src)
		return

	var/turf/T = get_turf(M)
	var/turf/self_turf = get_turf(src)

	if(!T || !self_turf)
		qdel(src)
		return

	// distance threshold (tweak freely)
	if(get_dist(self_turf, T) > 6)
		M.visible_message(span_warning("A fractured timeline collapses as its origin drifts too far away."), span_notice("One of your temporal echoes fades from existence."))
		qdel(src)

/obj/effect/divergence_fragment/proc/jitter()
	if(QDELETED(src))
		return

	pixel_x = rand(-1, 1)
	pixel_y = rand(-1, 1)

/obj/effect/divergence_fragment/proc/copy_target(mob/living/L)
	if(!L)
		return
	appearance = new /mutable_appearance(L)
	alpha = 140
	color = "#A8C8FF"

/obj/effect/divergence_fragment/Crossed(atom/movable/AM)
	. = ..()
	var/mob/living/L = AM
	if(L.cmode)
		to_chat(L, span_warning("I need a calm mind to properly match the simulacrum's frequency. Turn Combat Mode off!"))
		return
	converge()

/obj/effect/divergence_fragment/Bumped(atom/movable/AM)
	. = ..()
	var/mob/living/L = AM
	if(L.cmode)
		to_chat(L, span_warning("I need a calm mind to properly match the simulacrum's frequency. Turn Combat Mode off!"))
		return
	converge()

/obj/effect/divergence_fragment/proc/converge()
	if(collapsing)
		return

	collapsing = TRUE
	if(!master)
		return
	var/mob/living/M = master.owner

	if(M)
		M.adjustBruteLoss(-master.damage_per_fragment)
		M.adjustFireLoss(-master.damage_per_fragment)
		M.adjustOxyLoss(-master.damage_per_fragment)
		M.visible_message(span_blue("[src] rejoins [M]'s timeline."), span_blue("A lost possibility settles back into place, restoring you."))
	master.fragments -= src

	qdel(src)

/obj/effect/divergence_fragment/attackby(obj/item/W, mob/user, params)
	. = ..()
	collapse()

/obj/effect/divergence_fragment/attack_hand(mob/user, list/modifiers)
	. = ..()
	collapse()

/obj/effect/divergence_fragment/proc/collapse()
	if(collapsing)
		return

	collapsing = TRUE
	if(master)
		master.fragments -= src

	var/mob/living/M = master?.owner

	if(M)
		M.adjustBruteLoss(master.damage_per_fragment/2)
		M.adjustFireLoss(master.damage_per_fragment/2)
		M.adjustOxyLoss(master.damage_per_fragment/2)
		M.visible_message(span_danger("Time violently distorts around [M] as a discarded timeline is forced back into reality!"), span_userdanger("One of my fractured timelines violently collapses!"))
		shake_camera(M, 2, 2)
		if(!M.mind && iscarbon(M) && prob(30)) // 30% crit chance on NPCs, baybee
			var/list/limb_zones = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
			shuffle(limb_zones)
			for(var/zone in limb_zones)
				var/obj/item/bodypart/L = M.get_bodypart(zone)
				if(L)
					if(L.dismember(damage = 999))
						M.visible_message(span_userdanger("[M]'s timeline rejects one of its possibilities, tearing away a limb!"), span_userdanger("Reality violently disagrees on the existence of one of my limbs!"))
					break


	new /obj/effect/temp_visual/origin_restoration_burst(get_turf(M), NORTHEAST)
	new /obj/effect/temp_visual/origin_restoration_burst(get_turf(M), NORTHWEST)
	new /obj/effect/temp_visual/origin_restoration_burst(get_turf(M), SOUTHEAST)
	new /obj/effect/temp_visual/origin_restoration_burst(get_turf(M), SOUTHWEST)
	playsound(get_turf(M), "glassbreak", 90, TRUE)
	playsound(get_turf(M), 'sound/magic/regression2.ogg', 80)

	qdel(src)

/obj/effect/divergence_afterimage
	name = ""
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = TRUE
	density = FALSE
	layer = ABOVE_MOB_LAYER
	alpha = 180

/obj/effect/divergence_afterimage/Initialize()
	. = ..()
	QDEL_IN(src, 5)

/datum/status_effect/debuff/divergence/proc/spawn_fragment(turf/T)
	if(QDELETED(src))
		return

	var/obj/effect/divergence_fragment/F = new(T)

	F.master = src
	F.copy_target(owner)

	F.dir = pick(NORTH, SOUTH, EAST, WEST)

	F.alpha = 0
	F.transform = matrix() * 0.25

	animate(
		F,
		alpha = 140,
		transform = matrix(),
		time = 2
	)

	fragments += F
