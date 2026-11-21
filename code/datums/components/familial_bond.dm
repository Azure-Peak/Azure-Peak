/datum/component/familial_bond
	var/mob/living/carbon/human/bonded_with
	var/bond_duration
	var/bond_strength = 100 // Bond strength affects range and clarity of sensing
	var/crit_check = FALSE // TRUE if our partner is in crit and we've already been notified
	var/max_sensing_range = 200 // Maximum range for sensing - lowered based on bond strength
	var/datum/coven_power/eora/familial_bond/origin // power that created us

/datum/component/familial_bond/Initialize(mob/living/carbon/human/target, duration, datum/coven_power/eora/familial_bond/source)
	if(!istype(target) || !istype(parent))
		return COMPONENT_INCOMPATIBLE

	bonded_with = target
	bond_duration = duration
	origin = source

	// Notify both parties of the bond formation
	var/mob/living/carbon/human/parent_mob = parent
	to_chat(parent_mob, span_purple("I feel a warm spiritual connection forming with [bonded_with]."))
	to_chat(bonded_with, span_purple("I feel a warm spiritual connection forming with [parent_mob]."))

	// Set up termination timer
	addtimer(CALLBACK(src, PROC_REF(end_bond)), duration)
	START_PROCESSING(SSprocessing, src)

	// Let them check the status of their partner
	add_verb(parent_mob, /mob/living/carbon/human/proc/sense_partner)

	// Register signal handlers for enhanced interaction
	RegisterSignal(bonded_with, COMSIG_MOB_STATCHANGE, PROC_REF(on_bonded_statchange))
	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(on_parent_death))
	RegisterSignal(bonded_with, COMSIG_LIVING_DEATH, PROC_REF(on_bonded_death))

/datum/component/familial_bond/Destroy()
	UnregisterSignal(parent, COMSIG_LIVING_DEATH)
	if(bonded_with)
		UnregisterSignal(bonded_with, list(COMSIG_LIVING_DEATH, COMSIG_MOB_STATCHANGE))
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/mob/living/carbon/human/proc/sense_partner()
	set name = "Sense Partner"
	set category = "RoleUnique.Eoran Bond"
	var/datum/component/familial_bond/bond = GetComponent(/datum/component/familial_bond)
	if(!bond)
		remove_verb(src, /mob/living/carbon/human/proc/sense_partner)
	bond.provide_location_sense()

/datum/component/familial_bond/process()
	if(!bonded_with || QDELETED(bonded_with) || !parent || QDELETED(parent))
		end_bond()
		return

	var/mob/living/carbon/human/parent_mob = parent

	// Check if we're still on the same server/existence plane
	if(bonded_with.z == 0 || parent_mob.z == 0)
		return

	// Bond strength naturally degrades over time (adds realism)
	if(prob(5))
		bond_strength = max(bond_strength - 1, 20)

/datum/component/familial_bond/proc/provide_location_sense()
	var/mob/living/carbon/human/parent_mob = parent
	if(!parent_mob || !bonded_with)
		return

	// Different z-levels
	if(!(parent_mob.z in  get_multiz_accessible_levels(bonded_with.z)))
		to_chat(parent_mob, span_info("I sense [bonded_with] is outside the bounds of this world."))
		return

	// Health check - using the same thresholds as examine code
	var/health_desc = ""
	var/temp = 0
	for(var/obj/item/bodypart/part as anything in bonded_with.bodyparts)
		if(part.max_damage)
			temp = max(temp, part.get_damage() / part.max_damage)
	if(!HAS_TRAIT(bonded_with, TRAIT_NOPAIN))
		temp = max(temp, bonded_with.get_complex_pain() / max(bonded_with.pain_threshold, 1))
	if(temp < 0.25)
		health_desc = " I sense [bonded_with] is in good health. "
	else if(temp > 0.5)
		health_desc = span_warning(" I sense [bonded_with] is hurt. ")

	var/distance = get_dist(parent_mob, bonded_with)
	var/direction = get_dir(parent_mob, bonded_with)

	// Range check based on bond strength
	var/effective_range = max_sensing_range * (bond_strength / 100)
	if(distance > effective_range)
		to_chat(parent_mob, span_info("My bond with [bonded_with] is too weak to sense [bonded_with.p_them()] clearly at this range."))
		return

	// Provide detailed location information based on distance
	var/distance_desc
	var/direction_text = dir2text(direction)
	var/zdiff = parent_mob.z - bonded_with.z
	var/zdiff_text
	switch(zdiff)
		if(0 to 1)
			zdiff_text = "just"
		if(2)
			zdiff_text = "far"
		if(3)
			zdiff_text = "very far"
	if(zdiff > 0)
		direction_text += ", [zdiff_text] below me"
	else if(zdiff < 0)
		direction_text += ", [zdiff_text] above me"

	switch(distance)
		if(0 to 7)
			distance_desc = "within sight"
		if(8 to 30)
			distance_desc = "some distance away"
		if(31 to 50)
			distance_desc = "far"
		if(51 to INFINITY)
			distance_desc = "[distance] paces"

	// Add emotional context based on bond strength
	var/bond_feeling = ""
	if(bond_strength >= 80)
		bond_feeling = " Our connection feels strong and warm."
	else if(bond_strength >= 50)
		bond_feeling = " The bond feels stable."
	else if(bond_strength >= 30)
		bond_feeling = " The connection feels somewhat faint."
	else
		bond_feeling = " The bond is weakening."

	to_chat(parent_mob, span_info("I sense [bonded_with] is [distance_desc] to the [direction_text].[health_desc][bond_feeling]"))

// note: this is stat as in status (conscious/unconscious/softcrit/etc), not the 1-20 stats
/datum/component/familial_bond/proc/on_bonded_statchange()
	SIGNAL_HANDLER
	var/mob/living/carbon/human/parent_mob = parent
	if(!bonded_with)
		return
	if(crit_check && !bonded_with.stat)
		crit_check = FALSE
		to_chat(parent_mob, span_green("A wave of relief rushes through me as I feel [bonded_with] stir to waking!"))
	if(bonded_with.stat && !bonded_with.IsSleeping() && !bonded_with.IsUnconscious()) // gods i wish we had a better way to check for softcrit specifically
		crit_check = TRUE
		to_chat(parent_mob, span_danger("I feel a sharp pain in my chest - [bonded_with] is in serious danger!"))
		// Add a subtle screen effect
		parent_mob.overlay_fullscreen("familial_pain", /atom/movable/screen/fullscreen/painflash, 1)
		addtimer(CALLBACK(parent_mob, TYPE_PROC_REF(/mob, clear_fullscreen), "familial_pain"), 3 SECONDS)

/datum/component/familial_bond/proc/on_parent_death(mob/living/source)
	SIGNAL_HANDLER

	if(bonded_with)
		to_chat(bonded_with, span_danger("I feel a terrible emptiness as my bond with [source] is severed by death."))
		bonded_with.add_stress(/datum/stressevent/bond_death)
	end_bond()

/datum/component/familial_bond/proc/on_bonded_death(mob/living/source)
	SIGNAL_HANDLER

	var/mob/living/carbon/human/parent_mob = parent
	if(parent_mob)
		to_chat(parent_mob, span_danger("I feel a terrible emptiness as my bond with [source] is severed by death."))
		parent_mob.add_stress(/datum/stressevent/bond_death)
	end_bond()

/datum/component/familial_bond/proc/strengthen_bond(amount = 10)
	bond_strength = min(bond_strength + amount, 100)
	var/mob/living/carbon/human/parent_mob = parent
	to_chat(parent_mob, span_purple("Our familial bond grows stronger."))
	if(bonded_with)
		to_chat(bonded_with, span_purple("Our familial bond grows stronger."))

/datum/component/familial_bond/proc/weaken_bond(amount = 15)
	bond_strength = max(bond_strength - amount, 10)
	var/mob/living/carbon/human/parent_mob = parent
	to_chat(parent_mob, span_warning("Our familial bond weakens."))
	if(bonded_with)
		to_chat(bonded_with, span_warning("Our familial bond weakens."))

	if(bond_strength <= 10)
		to_chat(parent_mob, span_danger("Our familial bond is nearly broken!"))
		// Chance for early termination if bond is too weak
		if(prob(25))
			end_bond()

/datum/component/familial_bond/proc/end_bond()
	var/mob/living/carbon/human/parent_mob = parent

	if(parent_mob)
		to_chat(parent_mob, span_info("Our familial bond fades away, but the memory of connection remains."))
		parent_mob.add_stress(/datum/stressevent/bond_ended)
		remove_verb(parent_mob, /mob/living/carbon/human/proc/sense_partner)

	if(bonded_with)
		to_chat(bonded_with, span_info("Our familial bond fades away, but the memory of connection remains."))
		bonded_with.add_stress(/datum/stressevent/bond_ended)
		remove_verb(bonded_with, /mob/living/carbon/human/proc/sense_partner)

	if(origin && origin.active)
		origin.try_deactivate(parent_mob)
		origin.try_deactivate(bonded_with)
	STOP_PROCESSING(SSprocessing, src)
	qdel(src)

/datum/stressevent/bond_death
	desc = "Someone I was bonded with has died. I feel empty inside."
	stressadd = 6
	timer = 30 MINUTES

/datum/stressevent/bond_ended
	desc = "A familial bond has ended, but I feel grateful for the connection we shared."
	stressadd = -1
	timer = 10 MINUTES
