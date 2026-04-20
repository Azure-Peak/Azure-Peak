/datum/action/cooldown/mob_cooldown/fire_breath
	name = "Fire Breath"
	button_icon = 'icons/obj/magic.dmi'
	button_icon_state = "fireball"
	desc = "Breathe a line of flames towards the target."
	cooldown_time = 30 SECONDS
	/// The range of the fire
	var/fire_range = 15
	/// The sound played when you use this ability
	var/fire_sound = 'sound/magic/fireball.ogg'
	/// Time to wait between spawning each fire turf
	var/fire_delay = 0.25 SECONDS
	var/cast_time = 2 SECONDS
	var/explode_sound = list('sound/misc/explode/incendiary (1).ogg','sound/misc/explode/incendiary (2).ogg')

/datum/action/cooldown/mob_cooldown/fire_breath/Activate(atom/target_atom)
	owner.visible_message(span_alert("[owner] inhales deeply, warmth emanating from their form."))
	addtimer(CALLBACK(src, PROC_REF(attack_sequence), target_atom), cast_time)
	StartCooldown()
	return TRUE

/// Apply our specific fire breathing shape, in proc form so we can override it in subtypes
/datum/action/cooldown/mob_cooldown/fire_breath/proc/attack_sequence(atom/target)
	playsound(owner.loc, fire_sound, 200, TRUE)
	fire_line(target)

/// Breathe fire in a line towards the target, optionally rotated at an offset from the target
/datum/action/cooldown/mob_cooldown/fire_breath/proc/fire_line(atom/target, offset)
	if (isnull(target))
		return
	
	
	var/turf/target_turf = get_ranged_target_turf_direct(owner, target, fire_range, offset)
	var/list/turfs = getline(owner, target_turf) - get_turf(owner)
	INVOKE_ASYNC(src, PROC_REF(progressive_fire_line), turfs)

/// Creates fire with a delay on the list of targeted turfs
/datum/action/cooldown/mob_cooldown/fire_breath/proc/progressive_fire_line(list/burn_turfs)
	if (QDELETED(owner) || owner.stat == DEAD)
		return
	// Guys we have already hit, no double dipping
	var/list/hit_list = list(owner) // also don't burn ourselves
	for(var/turf/target_turf in burn_turfs)
		if (target_turf.is_blocked_turf(exclude_mobs = TRUE))
			var/exp_heavy = 0
			var/exp_light = 4
			var/exp_flash = 0
			var/exp_fire = 1
			explosion(target_turf, -1, exp_heavy, exp_light, exp_flash, 0, flame_range = exp_fire, soundin = explode_sound)
			return
		burn_turf(target_turf, hit_list, owner)
		sleep(fire_delay)

/// Finally spawn the actual fire, spawns the fire hotspot in case you want to recolour it or something
/datum/action/cooldown/mob_cooldown/fire_breath/proc/burn_turf(turf/fire_turf, list/hit_list, mob/living/source)
	var/obj/effect/hotspot/fire_hotspot = new /obj/effect/hotspot(fire_turf)
	
	for(var/mob/living/barbecued in fire_turf.contents)
		if(barbecued in hit_list)
			continue
		hit_list |= barbecued

	return fire_hotspot

/// Do something unpleasant to someone we set on fire
/datum/action/cooldown/mob_cooldown/fire_breath/proc/on_burn_mob(mob/living/barbecued, mob/living/source)
	to_chat(barbecued, span_userdanger("You are burned by [source]'s fire breath!"))

/// Shoot three lines of fire in a sort of fork pattern approximating a cone
/datum/action/cooldown/mob_cooldown/fire_breath/cone
	name = "Fire Cone"
	desc = "Breathe several lines of fire directed at a target."
	cooldown_time = 45 SECONDS
	/// The angles relative to the target that shoot lines of fire
	var/list/angles = list(-20, 0, 20)

/datum/action/cooldown/mob_cooldown/fire_breath/cone/attack_sequence(atom/target)
	playsound(owner.loc, fire_sound, 200, TRUE)
	for(var/offset in angles)
		fire_line(target, offset)

/// Shoot fire in a whole bunch of directions
/datum/action/cooldown/mob_cooldown/fire_breath/mass_fire
	name = "Mass Fire"
	button_icon = 'icons/effects/fire.dmi'
	button_icon_state = "light"
	desc = "Breathe flames in all directions."
	cooldown_time = 60.5 SECONDS
	//click_to_activate = FALSE
	/// How many fire lines do we produce to turn a full circle?
	var/sectors = 12
	/// How long do we wait between each spin?
	var/breath_delay = 2.5 SECONDS
	/// How many full circles do we perform?
	var/total_spins = 3

/datum/action/cooldown/mob_cooldown/fire_breath/mass_fire/Activate(atom/target_atom)
	target_atom = get_step(owner, owner.dir) // Just shoot it forwards, we don't need to click on someone for this one
	return ..()

/datum/action/cooldown/mob_cooldown/fire_breath/mass_fire/attack_sequence(atom/target)
	var/queued_spins = 0
	for (var/i in 1 to total_spins)
		var/delay = queued_spins * breath_delay
		queued_spins++
		addtimer(CALLBACK(src, PROC_REF(fire_spin), target, queued_spins), delay)

/// Breathe fire in a circle, with a slight angle offset based on which of our several circles it is
/datum/action/cooldown/mob_cooldown/fire_breath/mass_fire/proc/fire_spin(target, spin_count)
	if (QDELETED(owner) || owner.stat == DEAD)
		return // Too dead to spin
	playsound(owner.loc, fire_sound, 200, TRUE)
	var/angle_increment = 360 / sectors
	var/additional_offset = spin_count * angle_increment / 2
	for (var/i in 1 to sectors)
		fire_line(target, (angle_increment * i) + (additional_offset))
