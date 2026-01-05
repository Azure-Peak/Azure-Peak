/datum/stressevent
	var/timer
	var/stressadd = 0
	var/desc
	var/time_added
	var/stacks = 0
	var/max_stacks = 1
	var/stressadd_per_extra_stack = 0
	///this is how much we affect quality in the end
	var/quality_modifier = 0

/datum/stressevent/proc/can_apply(mob/living/user)
	return TRUE

/datum/stressevent/proc/on_apply(mob/living/user)
	return TRUE

/datum/stressevent/proc/get_stress(mob/living/user)
	if(user && HAS_TRAIT(user, TRAIT_NOMOOD))
		return 0
	var/base_stress = stressadd + ((stacks - 1) * stressadd_per_extra_stack)
	if (user && base_stress > 0)
		if (HAS_TRAIT(user, TRAIT_BAD_MOOD))
			base_stress *= 2
		if (HAS_TRAIT(user, TRAIT_EORAN_SERENE))
			base_stress = (base_stress * -1)
	return base_stress

/datum/stressevent/test
	timer = 5 SECONDS
	stressadd = 3
	desc = span_red("This is a negative test event.")

/datum/stressevent/testr
	timer = 5 SECONDS
	stressadd = -3
	desc = span_green("This is a positive test event.")
