
/datum/component/sunlight_vulnerability
	/// How much damage per tick in sunlight
	var/burn_damage = 5
	/// How much bloodpool drain per tick
	var/bloodpool_drain = 2.5
	/// Whether this mob is currently in sunlight
	var/in_sunlight = FALSE

/datum/component/sunlight_vulnerability/Initialize(damage = 5, drain = 10)
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
			if(HAS_TRAIT(H, TRAIT_WEATHER_PROTECTED))
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


// a variant of Sunlight Vulnerability that applies to people exiled via a treaty
/datum/component/sunlight_vulnerability/exile
	var/town_only = TRUE // only triggers if they're both within city limits & outside

/datum/component/sunlight_vulnerability/exile/check_sunlight(mob/living/source)
	var/mob/living/carbon/human/H = source
	if(!H || H.stat == DEAD || H.advsetup)
		return
	if(GLOB.tod != "day")
		in_sunlight = FALSE
		return
	if(isturf(H.loc))
		var/turf/T = H.loc
		if(town_only) // check if they're in town
			var/area/A = get_area(T)
			if(!istype(A, /area/rogue/outdoors/town))
				if(in_sunlight)
					to_chat(H, span_notice("I am beyond the city limits. The divine punishment ceases."))
				in_sunlight = FALSE
				return
		if(T.can_see_sky())
			if(!in_sunlight)
				in_sunlight = TRUE
				to_chat(H, span_userdanger("The Sun's wrath descends upon me! Her flames seek to enforce my exile!"))

			simple_sunlight_damage(H)
		else
			if(in_sunlight)
				to_chat(H, span_notice("The scorching gaze of the Sun-Tyrant burns me no more."))
			in_sunlight = FALSE
	else
		in_sunlight = FALSE

// simple sunlight damage proc for exiles
/datum/component/sunlight_vulnerability/exile/proc/simple_sunlight_damage(mob/living/carbon/human/H)
	H.fire_act(1, burn_damage)

