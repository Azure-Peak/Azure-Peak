/datum/mob_descriptor/face
	abstract_type = /datum/mob_descriptor/face
	prefix = "a"
	slot = MOB_DESCRIPTOR_SLOT_FACE_SHAPE

/datum/mob_descriptor/face/unremarkable
	name = "Unremarkable"
	prefix = "an"

/datum/mob_descriptor/face/smooth
	name = "Smooth"

/datum/mob_descriptor/face/rough
	name = "Rough"

/datum/mob_descriptor/face/chiseled
	name = "Chiseled"

/datum/mob_descriptor/face/scarred
	name = "Scarred"

/datum/mob_descriptor/face/angular
	name = "Angular"
	prefix = "an"

/datum/mob_descriptor/face/gaunt
	name = "Gaunt"

/datum/mob_descriptor/face/round
	name = "Round"

/datum/mob_descriptor/face/delicate
	name = "Delicate"

/datum/mob_descriptor/face/soft
	name = "Soft"

/datum/mob_descriptor/face/sharp
	name = "Sharp"

/datum/mob_descriptor/face/sleek
	name = "Sleek"

/datum/mob_descriptor/face/broad
	name = "Broad"

/datum/mob_descriptor/face/disfigured
	name = "Disfigured"

/datum/mob_descriptor/face/tall
	name = "Tall"

/datum/mob_descriptor/face/chubby
	name = "Chubby"

/datum/mob_descriptor/face/mousy
	name = "Mousy"

/datum/mob_descriptor/face/full
	name = "Full"

/datum/mob_descriptor/face/punchable
	name = "Punchable"

/datum/mob_descriptor/face/custom
	prefix = null
	var/custom_index

/datum/mob_descriptor/face/custom/can_describe(mob/living/described)
	return length(described.custom_descriptors) >= custom_index

/datum/mob_descriptor/face/custom/get_description(mob/living/described)
	var/datum/custom_descriptor_entry/entry = described.custom_descriptors[custom_index]
	return entry.content_text

/datum/mob_descriptor/face/custom/get_pre_string(mob/living/described)
	var/datum/custom_descriptor_entry/entry = described.custom_descriptors[custom_index]
	switch(entry.prefix_type)
		if(CUSTOM_PREFIX_HAS_A)
			return "a "
		if(CUSTOM_PREFIX_HAS_AN)
			return "an "
	return null

/datum/mob_descriptor/face/custom/five
	name = "Custom Face"
	custom_index = 5

/datum/mob_descriptor/face_exp
	abstract_type = /datum/mob_descriptor/face_exp
	suffix = "face"
	slot = MOB_DESCRIPTOR_SLOT_FACE_EXPRESSION

/datum/mob_descriptor/face_exp/refined
	name = "Refined"

/datum/mob_descriptor/face_exp/disinterested
	name = "Disinterested"

/datum/mob_descriptor/face_exp/sour
	name = "Sour"

/datum/mob_descriptor/face_exp/bright
	name = "Bright"

/datum/mob_descriptor/face_exp/starry_eyed
	name = "Starry-eyed"

/datum/mob_descriptor/face_exp/cold
	name = "Cold"

/datum/mob_descriptor/face_exp/haggard
	name = "Haggard"

/datum/mob_descriptor/face_exp/fake
	name = "Fake"

/datum/mob_descriptor/face_exp/bitchy
	name = "Bitchy"

/datum/mob_descriptor/face_exp/spiteful
	name = "Spiteful"

/datum/mob_descriptor/face_exp/warm
	name = "Warm"

/datum/mob_descriptor/face_exp/salacious
	name = "Salacious"

/datum/mob_descriptor/face_exp/contemptous
	name = "Contemptuous"

/datum/mob_descriptor/face_exp/mocking
	name = "Mocking"

/datum/mob_descriptor/face_exp/knowing
	name = "Knowing"

/datum/mob_descriptor/face_exp/cocky
	name = "Cocky"

/datum/mob_descriptor/face_exp/coy
	name = "Coy"

/datum/mob_descriptor/face_exp/frustrated
	name = "Frustrated"

/datum/mob_descriptor/face_exp/stern
	name = "Stern"

/datum/mob_descriptor/face_exp/genuine
	name = "Genuine"

/datum/mob_descriptor/face_exp/jaded
	name = "Jaded"

/datum/mob_descriptor/face_exp/inquisitive
	name = "Inquisitive"

/datum/mob_descriptor/face_exp/suspicious
	name = "Suspicious"

/datum/mob_descriptor/face_exp/tender
	name = "Tender"

/datum/mob_descriptor/face_exp/affectionate
	name = "Affectionate"

/datum/mob_descriptor/face_exp/calm
	name = "Calm"

/datum/mob_descriptor/face_exp/cutthroat
	name = "Cutthroat"

/datum/mob_descriptor/face_exp/suave
	name = "Suave"

/datum/mob_descriptor/face_exp/humble
	name = "Humble"

/datum/mob_descriptor/face_exp/smug
	name = "Smug"

/datum/mob_descriptor/face_exp/custom
	var/custom_index

/datum/mob_descriptor/face_exp/custom/can_describe(mob/living/described)
	return length(described.custom_descriptors) >= custom_index

/datum/mob_descriptor/face_exp/custom/get_description(mob/living/described)
	var/datum/custom_descriptor_entry/entry = described.custom_descriptors[custom_index]
	return entry.content_text

/datum/mob_descriptor/face_exp/custom/six
	name = "Custom Expression"
	custom_index = 6
