
/datum/component/sunlight_vulnerability
	/// How much damage per tick in sunlight
	var/burn_damage = 0
	/// How much bloodpool drain per tick
	var/bloodpool_drain = 0
	/// Whether this mob is currently in sunlight
	var/in_sunlight = FALSE

/// we set these defaults on the init, it goes below the codenote
/*
So future coder, you want to give a clan, a custom amount of sunlight weakness, here's how
	H.AddComponent(/datum/component/sunlight_vulnerability, damage = 5, drain = 5) //set damage/vitae drain, both'll alter what the vamps take

	if they lack this component, in their clan it won't be applied and they'll be immune to sunlight
	please don't do this unless you're doing an inaccessable clan for aurafarming purposes, testing or events.
*/
/datum/component/sunlight_vulnerability/Initialize(damage = 5, drain = 5)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	burn_damage = damage
	bloodpool_drain = drain

	RegisterSignal(parent, COMSIG_HUMAN_LIFE, PROC_REF(check_sunlight))

/datum/component/sunlight_vulnerability/proc/check_sunlight(mob/living/source)
	var/mob/living/carbon/human/H = source
	if(!H || H.stat == DEAD || H.advsetup)
		return

	// Only check during day
	if(GLOB.tod != "day")
		in_sunlight = FALSE
		return

	// Check if outside and in light
	if(isturf(H.loc))
		var/turf/T = H.loc
		if(T.can_see_sky())
			if(HAS_TRAIT(H, TRAIT_WEATHER_PROTECTED) || HAS_TRAIT(H, TRAIT_VAMPIRE_SPAWN_PROTECTION))
				if(!in_sunlight)
					in_sunlight = TRUE
					to_chat(H, span_danger("I am shielded from the Sun-Tyrant's scorn."))
				return

			if(!in_sunlight)
				in_sunlight = TRUE
				to_chat(H, span_danger("The sunlight burns my flesh!"))

			apply_sunlight_damage(H)
		else
			if(in_sunlight)
				to_chat(H, span_notice("The scorching gaze of the Sun-Tyrant burns me no more."))
			in_sunlight = FALSE
	else
		in_sunlight = FALSE

/datum/component/sunlight_vulnerability/proc/apply_sunlight_damage(mob/living/carbon/human/H)
	H.adjust_bloodpool(-bloodpool_drain)
	var/datum/component/vampire_disguise/disguise_comp = H.GetComponent(/datum/component/vampire_disguise)
	if(disguise_comp && disguise_comp.disguised)
		if(H.bloodpool > disguise_comp.min_bloodpool * 2)
			return
		disguise_comp.force_undisguise(H)
		to_chat(H, span_warning("The sunlight breaks my disguise!"))

	// Apply fire damage
	H.fire_act(1, burn_damage)

	// Freak out if on fire
	if(H.on_fire)
		H.freak_out()
