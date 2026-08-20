/datum/wound/artery
	name = "severed artery"
	check_name = span_artery("<B>ARTERY</B>")
	severity = WOUND_SEVERITY_CRITICAL
	crit_message = "Blood sprays from %VICTIM's %BODYPART!"
	sound_effect = 'sound/combat/crit.ogg'
	whp = 50
	sewn_whp = 20
	bleed_rate = ARTERY_LIMB_BLEEDRATE
	sewn_bleed_rate = 0.2
	clotting_threshold = null
	sewn_clotting_threshold = null
	woundpain = 50
	sewn_woundpain = 20
	mob_overlay = "s1"
	sewn_overlay = "cut"
	can_sew = TRUE
	can_cauterize = TRUE
	critical = TRUE
	sleep_healing = 0.5
	embed_chance = 75

	werewolf_infection_probability = 100

/datum/wound/artery/can_stack_with(datum/wound/other)
	if(istype(other, /datum/wound/artery) && (type == other.type))
		return FALSE
	return TRUE

/datum/wound/artery/on_mob_gain(mob/living/affected)
	. = ..()
	affected.emote("paincrit", TRUE)
	affected.Slowdown(20)
	shake_camera(affected, 2, 2)

/datum/wound/artery/on_bodypart_gain(obj/item/bodypart/affected)
	. = ..()
	affected.temporary_crit_paralysis(10 SECONDS)

/datum/wound/artery/neck
	name = "torn carotid"
	check_name = span_artery("<B>CAROTID</B>")
	severity = WOUND_SEVERITY_FATAL
	crit_message = "Blood sprays from %VICTIM's throat!"
	whp = 100
	sewn_whp = 25
	bleed_rate = 50
	sewn_bleed_rate = 0.5
	woundpain = 60
	sewn_woundpain = 30
	mob_overlay = "s1_throat"
	mortal = TRUE

/datum/wound/artery/neck/on_mob_gain(mob/living/affected)
	. = ..()
	ADD_TRAIT(affected, TRAIT_GARGLE_SPEECH, "[type]")

/datum/wound/artery/neck/on_mob_loss(mob/living/affected)
	. = ..()
	REMOVE_TRAIT(affected, TRAIT_GARGLE_SPEECH, "[type]")

/datum/wound/artery/chest
	name = "aortic dissection"
	check_name = span_artery("<B>AORTA</B>")
	severity = WOUND_SEVERITY_FATAL
	whp = 100
	sewn_whp = 35
	bleed_rate = 50
	sewn_bleed_rate = 0.8
	woundpain = 100
	sewn_woundpain = 50
	mortal = TRUE

/datum/wound/artery/chest/on_mob_gain(mob/living/affected)
	. = ..()
	if(iscarbon(affected))
		var/mob/living/carbon/carbon_affected = affected
		carbon_affected.vomit(blood = TRUE)
	var/static/list/heartaches = list(
		"OOHHHH MY HEART!",
		"MY HEART! IT HURTS!",
		"I AM DYING!",
		"MY HEART IS TORN!",
		"MY HEART IS BLEEDING!",
	)
	to_chat(affected, span_userdanger("[pick(heartaches)]"))

/datum/wound/artery/chest/on_life()
	. = ..()
	if(!iscarbon(owner))
		return
	var/mob/living/carbon/carbon_owner = owner
	if(!carbon_owner.stat && prob(5))
		carbon_owner.vomit(1, blood = TRUE, stun = TRUE)

/datum/wound/artery/reattachment
	name = "replantation"
	check_name = span_artery("<B>UNSEWN</B>")
	severity = WOUND_SEVERITY_FATAL
	whp = 100
	sewn_whp = 25
	bleed_rate = 50
	sewn_bleed_rate = 0.5
	woundpain = 60
	sewn_woundpain = 30
	disabling = TRUE

/////////////////////////////////////////////////////////
// Construct reflavored stuff
////////////////////////////////////////////////////////

/datum/wound/integrity
	name = "severed etheric conduit"
	check_name = span_artery("<B>ETHERIC CONDUIT</B>")
	severity = WOUND_SEVERITY_CRITICAL
	crit_message = "Arcane energy violently bursts out from %VICTIM's %BODYPART!"
	sound_effect = 'sound/combat/crit.ogg'
	whp = 200
	sewn_whp = 20
	clotting_threshold = null
	sewn_clotting_threshold = null
	woundpain = 50
	sewn_woundpain = 20
	mob_overlay = "s1"
	sewn_overlay = "cut"
	can_sew = TRUE
	can_cauterize = TRUE
	critical = TRUE
	sleep_healing = 0.5
	embed_chance = 75
	werewolf_infection_probability = 0
	var/weakzappy = 0

/datum/wound/integrity/can_stack_with(datum/wound/other)
	if(istype(other, /datum/wound/integrity) && (type == other.type))
		return FALSE
	return TRUE

/datum/wound/integrity/on_mob_gain(mob/living/carbon/affected)
	. = ..()
	affected.emote("superagony", TRUE)
	affected.Slowdown(20)
	affected.electrocute_act(10, affected)
	shake_camera(affected, 2, 2)

/datum/wound/integrity/on_life()
	. = ..()
	if(!iscarbon(owner))
		return
	var/mob/living/carbon/carbon_owner = owner
	if(!carbon_owner.has_status_effect(/datum/status_effect/debuff/integrity_rig))
		if(world.time >= weakzappy)
			weakzappy = world.time + rand(20 SECONDS, 40 SECONDS)
			carbon_owner.electrocute_act(20, carbon_owner)
			if(carbon_owner.getFireLoss() > 450 || carbon_owner.getBruteLoss() > 500)
				core_meltdown(carbon_owner)
				carbon_owner.death()

/datum/wound/integrity/on_bodypart_gain(obj/item/bodypart/affected)
	. = ..()
	affected.temporary_crit_paralysis(10 SECONDS)

/datum/wound/integrity/neck
	name = "ruptured throat conduit"
	check_name = span_artery("<B>VOCAL SIGIL</B>")
	severity = WOUND_SEVERITY_FATAL
	crit_message = "Arcane energy bursts from %VICTIM's throat conduit!"
	whp = 150
	sewn_whp = 25
	woundpain = 60
	sewn_woundpain = 30
	mob_overlay = "s1_throat"
	mortal = TRUE
	var/zoppy = 0

/datum/wound/integrity/neck/on_mob_gain(mob/living/affected)
	. = ..()
	ADD_TRAIT(affected, TRAIT_GARGLE_SPEECH, "[type]")

/datum/wound/integrity/neck/on_mob_loss(mob/living/affected)
	. = ..()
	REMOVE_TRAIT(affected, TRAIT_GARGLE_SPEECH, "[type]")

/datum/wound/integrity/neck/on_life()
	. = ..()
	if(!iscarbon(owner))
		return
	var/mob/living/carbon/carbon_owner = owner
	if(!carbon_owner.has_status_effect(/datum/status_effect/debuff/integrity_rig))
		if(world.time >= zoppy)
			zoppy = world.time + rand(10 SECONDS, 20 SECONDS)
			carbon_owner.electrocute_act(15, carbon_owner)
			if(carbon_owner.getFireLoss() > 450 || carbon_owner.getBruteLoss() > 500)
				core_meltdown(carbon_owner)
				carbon_owner.death()

/datum/wound/integrity/chest
	name = "core lattice rupture"
	check_name = span_artery("<B>CORE LATTICE</B>")
	severity = WOUND_SEVERITY_FATAL
	whp = 300
	sewn_whp = 35
	woundpain = 100
	sewn_woundpain = 50
	mortal = TRUE
	var/zappy = 0

/datum/wound/integrity/chest/on_mob_gain(mob/living/affected)
	. = ..()
	if(iscarbon(affected))
		var/mob/living/carbon/carbon_affected = affected
		carbon_affected.emote("agony")
	var/static/list/corefails = list(
		"MY CORE IS FRACTURING!",
		"THE LATTICE IS BREAKING!",
		"I AM UNRAVELING!",
		"MY FORM IS FAILING!",
		"THE CONDUITS ARE SHATTERING!"
	)
	to_chat(affected, span_userdanger("[pick(corefails)]"))

/datum/wound/integrity/chest/on_life()
	. = ..()
	if(!iscarbon(owner))
		return
	var/mob/living/carbon/carbon_owner = owner
	if(!carbon_owner.has_status_effect(/datum/status_effect/debuff/integrity_rig))
		if(world.time >= zappy)
			zappy = world.time + rand(5 SECONDS, 15 SECONDS)
			carbon_owner.electrocute_act(20, carbon_owner)
			if(carbon_owner.getFireLoss() > 450 || carbon_owner.getBruteLoss() > 500)
				core_meltdown(carbon_owner)
				carbon_owner.death()

/datum/wound/integrity/reattachment
	name = "replantation"
	check_name = span_artery("<B>UNSEALED</B>")
	severity = WOUND_SEVERITY_FATAL
	whp = 50
	sewn_whp = 25
	woundpain = 60
	sewn_woundpain = 30
	disabling = TRUE

/datum/wound/integrity/proc/core_meltdown(mob/living/source)
	if(!source)
		return
	// look what you FUCKING did!!! D:
	explosion(source, devastation_range = 0, heavy_impact_range = 0, light_impact_range = 0, flash_range = 3, adminlog = FALSE, ignorecap = TRUE)

	var/list/thrownatoms = list()
	for(var/turf/T in get_hear(2, source))
		for(var/atom/movable/AM in T)
			thrownatoms += AM

	for(var/atom/movable/AM as anything in thrownatoms)
		if(AM == source || AM.anchored)
			continue
		if(ismob(AM))
			var/mob/M = AM
			if(M.anti_magic_check())
				continue
		var/turf/throwtarget = get_edge_target_turf(source, get_dir(source, get_step_away(AM, source)))
		var/dist = get_dist(source, AM)
		if(dist == 0)
			if(isliving(AM))
				var/mob/living/L = AM
				L.set_resting(TRUE, TRUE)
				L.Knockdown(3 SECONDS)
				L.adjustBruteLoss(35)
				L.electrocute_act(40, source)
			AM.safe_throw_at(throwtarget, 2, 1, source, force = MOVE_FORCE_EXTREMELY_STRONG)
		else
			new /obj/effect/temp_visual/gravpush(get_turf(AM), get_dir(source, AM))
			if(isliving(AM))
				var/mob/living/L = AM
				L.set_resting(TRUE, TRUE)
				L.Knockdown(2 SECONDS)
				L.electrocute_act(20, source)
			AM.safe_throw_at(throwtarget, 5, 1, source, force = MOVE_FORCE_EXTREMELY_STRONG)
