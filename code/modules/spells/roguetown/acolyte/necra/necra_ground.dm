/obj/effect/proc_holder/spell/invoked/consecrate_ground
	name = "Consecrate Ground"
	desc = "Channel holy energy to bless a Necran cross, allowing it to be activated against undead. devout can maintain one cross, while masters can maintain three. You can unbless a previously blessed cross to reclaim the slot."
	invocations = list("In the name of Her this ground is made SACROSANCT!")
	sound = 'sound/effects/necracon_create.ogg'
	devotion_cost = 100
	recharge_time = 130 SECONDS //2 min duration + 10 second CD inbetween. Unless it gets destroyed before.
	chargetime = 1 SECONDS
	range = 1
	overlay_icon = 'icons/mob/actions/necramiracles.dmi'
	overlay_state = "consecrate_ground"
	action_icon_state = "consecrate_ground"
	action_icon = 'icons/mob/actions/necramiracles.dmi'
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/consecrate_ground/cast(list/targets, mob/user)
	. = ..()
	var/turf/target_turf
	if(!isturf(targets[1]))
		if(!isnull(targets[1]))
			target_turf = get_turf(targets[1])
	else
		target_turf = targets[1]
	if(!target_turf)
		revert_cast()
		return FALSE
	if(target_turf.density)	//On a wall
		revert_cast()
		return FALSE

	var/effect_size = 2
	var/skill_level = user.get_skill_level(associated_skill)
	switch(skill_level)
		if(SKILL_LEVEL_EXPERT)
			effect_size = 3
		if(SKILL_LEVEL_MASTER to SKILL_LEVEL_LEGENDARY)
			effect_size = 4

	new /obj/structure/fluff/psycross/necra/consecrated(target_turf, effect_size)

	return TRUE
	

/obj/structure/fluff/psycross/necra/consecrated
	name = "spirit necran cross"
	desc = "A monument to Her holy sanctity, blessing her worshippers in vicinity. Those who have vowed their souls to her in full receive better boons. Standing in its presence, a sense of idle acceptance prods at your mind. We will all have to let go at some point."
	icon_state = "cross_necra_consecrate"
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	layer = ABOVE_MOB_LAYER	//We want this to be more visible than not, adjust this as needed if it's ever used behind stuff
	plane = GAME_PLANE_UPPER
	max_integrity = 100	//3-5 hits with the average weapon (20-40 damage) to fully destroy.
	var/list/affected_mobs = list()
	var/list/turfgrid = list()
	var/list/effectgrid = list()
	var/range = 2
	var/expires_in = 2 MINUTES
	var/outline_colour ="#929186" // A dull grey.

#define NECRACON_FILTER "necra_consecration"

/obj/structure/fluff/psycross/necra/consecrated/Initialize(mapload, newrange)
	. = ..()
	if(newrange)
		range = newrange
	LAZYCLEARLIST(affected_mobs)	//Just in case, it's kept on the proc holder datum after all.
	get_grid()
	color_grid()
	addtimer(CALLBACK(src, PROC_REF(expire_self)), expires_in)
	START_PROCESSING(SSobj, src)

/obj/structure/fluff/psycross/necra/consecrated/take_damage(damage_amount, damage_type, damage_flag, sound_effect, attack_dir, armor_penetration, object_damage_multiplier)
	if(object_damage_multiplier)	//Mostly used by ranged weapons
		object_damage_multiplier = 1
	if(damage_amount > round(max_integrity / 3))	//We don't want this thing to be one-shottable, especially with our loosy-goosy obj / integ damage mods.
		damage_amount = (round(max_integrity / 3) + 1)	//+ 1 so it's guaranteed to go down in 3 hits, round() isn't consistent with this.
	. = ..()

/obj/structure/fluff/psycross/necra/consecrated/proc/get_grid()
	LAZYCLEARLIST(turfgrid)
	var/turf/source = get_turf(src)

	var/turf/block_lower = locate(source.x - range, source.y - range, source.z)
	var/turf/block_upper = locate(source.x + range, source.y + range, source.z)
	turfgrid = block(block_lower, block_upper)

/obj/structure/fluff/psycross/necra/consecrated/proc/color_grid()
	for(var/turf/T in turfgrid)
		var/obj/effect/temp_visual/necra_consecrate/fx = new(T, expires_in)
		effectgrid.Add(fx)

/obj/structure/fluff/psycross/necra/consecrated/proc/purge_grid()
	for(var/obj/effect/temp_visual/fx in effectgrid)
		fx.timed_out()

/obj/structure/fluff/psycross/necra/consecrated/process()
	var/list/checked_dudes = list()
	for(var/mob/living/carbon/human/H in get_hearers_in_view(range, src, RECURSIVE_CONTENTS_CLIENT_MOBS))
		if(!H.devotion)
			continue
		if(H.devotion && istype(H.patron, /datum/patron/divine/necra))
			if(!(H in affected_mobs))
				var/datum/beam/newbeam = Beam(H, icon_state="necra_beam", time = 9999, maxdistance = range)
				affected_mobs[H] = newbeam
			else
				var/datum/beam/B = affected_mobs[H]
				if(!istype(B) || QDELETED(B))	//our beam got deleted, make a new one
					var/datum/beam/newbeam = Beam(H, icon_state="necra_beam", time = 9999, maxdistance = range)
					affected_mobs[H] = newbeam
			H.apply_status_effect(/datum/status_effect/buff/necran_consecration, range)
			LAZYADD(checked_dudes, H)
	if(length(checked_dudes) != length(affected_mobs))
		for(var/mob/living/carbon/human/H in affected_mobs)	//We left the range, uh oh.
			if(!(H in checked_dudes))
				var/datum/beam/B = affected_mobs[H]
				if(B)
					B.End()
				H.remove_status_effect(/datum/status_effect/buff/necran_consecration)
				LAZYREMOVE(affected_mobs, H)

/obj/structure/fluff/psycross/necra/consecrated/proc/expire_self()
	STOP_PROCESSING(SSobj, src)
	purge_grid()
	if(length(affected_mobs))
		for(var/mob/living/L in affected_mobs)
			L.remove_status_effect(/datum/status_effect/buff/necran_consecration)
			var/datum/beam/B = affected_mobs[L]
			if(istype(B))
				B.End()
	playsound(src, 'sound/effects/necracon_destroy.ogg', 100, TRUE)
	if(!QDELETED(src))
		qdel(src)

#undef NECRACON_FILTER

/obj/structure/fluff/psycross/necra/consecrated/obj_destruction(damage_flag)
	expire_self()
