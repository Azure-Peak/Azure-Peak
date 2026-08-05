/datum/mob_descriptor/height
	abstract_type = /datum/mob_descriptor/height
	slot = MOB_DESCRIPTOR_SLOT_HEIGHT

/datum/mob_descriptor/height/moderate
	name = "Moderate"
	prefix = "a"

/datum/mob_descriptor/height/middling
	name = "Middling"
	prefix = "a"

/datum/mob_descriptor/height/tall
	name = "Tall"
	prefix = "a"

/datum/mob_descriptor/height/short
	name = "Short"
	prefix = "a"

/datum/mob_descriptor/height/towering
	name = "Towering"
	prefix = "a"

/datum/mob_descriptor/height/giant
	name = "Giant"
	prefix = "a"

/datum/mob_descriptor/height/tiny
	name = "Tiny"
	prefix = "a"

/datum/mob_descriptor/height/custom
	var/custom_index

/datum/mob_descriptor/height/custom/can_describe(mob/living/described)
	return length(described.custom_descriptors) >= custom_index

/datum/mob_descriptor/height/custom/get_description(mob/living/described)
	var/datum/custom_descriptor_entry/entry = described.custom_descriptors[custom_index]
	return entry.content_text

/datum/mob_descriptor/height/custom/get_pre_string(mob/living/described)
	var/datum/custom_descriptor_entry/entry = described.custom_descriptors[custom_index]
	switch(entry.prefix_type)
		if(CUSTOM_PREFIX_HAS_A)
			return "a "
		if(CUSTOM_PREFIX_HAS_AN)
			return "an "
	return null

/datum/mob_descriptor/height/custom/eleven
	name = "Custom Height"
	custom_index = 11
