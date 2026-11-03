// alchemical bathbombs: apply a small flavor effect and increased potence to bathing. applied to all nearby tiles of the type, wears off after some time
/datum/component/bath_infusion
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/smell = "herbal"		// will be displayed to bathers, as in "The water's [herbal] infusion soothes my body and mind."
	var/boost = 1				// bonus to the strength of the bathing buff. bathing is so anti-gamer that this is probably unimpactful but it is flavor, so.
	var/duration = 15 MINUTES	// how long the infusion lasts. remember that a full bath takes 2 minutes, so don't set this much shorter!

/datum/component/bath_infusion/Initialize(smell_description, duration_mod, boost_strength)
	if(!istype(parent, /obj/structure/hotspring) && !istype(parent, /turf/open/water/bath))
		return COMPONENT_INCOMPATIBLE
	. = ..()
	if(smell_description)
		smell = smell_description
	if(duration_mod)
		duration = duration_mod
	if(boost_strength)
		boost = boost_strength
	addtimer(CALLBACK(src, PROC_REF(Destroy)), duration)
