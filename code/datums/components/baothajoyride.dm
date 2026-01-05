/datum/component/baotha_joyride
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/mob/living/carbon/partner
	var/mob/living/carbon/caster
	var/duration = 8 MINUTES
	var/max_distance = 10
	var/ispartner = FALSE
	can_transfer = TRUE

/datum/component/baotha_joyride/partner
	ispartner = TRUE

/datum/component/baotha_joyride/Initialize(mob/living/partner_mob, mob/living/caster_mob, var/holy_skill)
	if(!isliving(parent) || !isliving(partner_mob))
		return COMPONENT_INCOMPATIBLE

	partner = partner_mob
	caster = caster_mob

	RegisterSignal(parent, COMSIG_PARENT_QDELETING, PROC_REF(on_deletion))

	START_PROCESSING(SSprocessing, src)
	addtimer(CALLBACK(src, .proc/remove_bond), duration)

	var/mob/living/L = parent
	L.apply_status_effect(/datum/status_effect/baotha_joyride)
	return ..()

/datum/component/baotha_joyride/proc/on_deletion()
	remove_bond()

/datum/component/baotha_joyride/process()
	var/mob/living/M = parent
	if(!istype(M) || !istype(partner) || M.stat == DEAD || partner.stat == DEAD || get_dist(M, partner) > max_distance)
		remove_bond()

/datum/component/baotha_joyride/proc/remove_bond()
	var/mob/living/L = parent
	if(L)
		L.remove_status_effect(/datum/status_effect/baotha_joyride)
		UnregisterSignal(L, list(
			COMSIG_PARENT_QDELETING
		))

	if(partner)
		partner.remove_status_effect(/datum/status_effect/baotha_joyride)
		var/datum/component/baotha_joyride/other = partner.GetComponent(/datum/component/baotha_joyride)
		if(other)
			other.partner = null
			qdel(other)

	partner = null
	STOP_PROCESSING(SSprocessing, src)
	qdel(src)

#define JOYRIDE_FILTER "joyride"

/datum/status_effect/baotha_joyride
	id = "baotha_joyride"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/baotha_joyride
	effectedstats = list(STATKEY_SPD = 5, STATKEY_WIL = 3)
	var/outline_colour = "#c6307b"

/datum/status_effect/baotha_joyride/on_apply()
	. = ..()

	var/filter = owner.get_filter(JOYRIDE_FILTER)
	if (!filter)
		owner.add_filter(JOYRIDE_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 2))
		
	ADD_TRAIT(owner, TRAIT_NOPAIN, src)
	ADD_TRAIT(owner, TRAIT_CRACKHEAD, src)

/datum/status_effect/baotha_joyride/on_remove()
	. = ..()

	owner.remove_filter(JOYRIDE_FILTER)
	REMOVE_TRAIT(owner, TRAIT_NOPAIN, src)
	REMOVE_TRAIT(owner, TRAIT_CRACKHEAD, src)

/atom/movable/screen/alert/status_effect/baotha_joyride
	name = "Joyride"
	desc = "At the tip of the tongue, Baotha's blessing in purest form."

#undef JOYRIDE_FILTER
