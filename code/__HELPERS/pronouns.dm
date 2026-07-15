//pronoun procs, for getting pronouns without using the text macros that only work in certain positions
//datums don't have gender, but most of their subtypes do!

/datum/proc/p_they(capitalized, temp_gender)
	. = "it"
	if(capitalized)
		. = capitalize(.)

/datum/proc/p_their(capitalized, temp_gender)
	. = "its"
	if(capitalized)
		. = capitalize(.)

/datum/proc/p_them(capitalized, temp_gender)
	. = "it"
	if(capitalized)
		. = capitalize(.)

/datum/proc/p_themselves(capitalized, temp_gender)
	. = "itself"
	if(capitalized)
		. = capitalize(.)

/datum/proc/p_have(temp_gender)
	. = "has"

/datum/proc/p_are(temp_gender)
	. = "is"

/datum/proc/p_were(temp_gender)
	. = "was"

/datum/proc/p_do(temp_gender)
	. = "does"

/datum/proc/p_theyve(capitalized, temp_gender)
	. = p_they(capitalized, temp_gender) + "'" + copytext(p_have(temp_gender), 3)

/datum/proc/p_theyre(capitalized, temp_gender)
	. = p_they(capitalized, temp_gender) + "'" + copytext(p_are(temp_gender), 2)

/datum/proc/p_s(temp_gender) //is this a descriptive proc name, or what?
	. = "s"

/datum/proc/p_es(temp_gender)
	. = "es"


// pronouns datums: each is its own pronounset. mobs can have multiple of these, and they'll be used alternately!
/datum/pronouns
	var/name = "base pronoun definition"
	var/c_they
	var/c_their
	var/c_them
	var/c_themselves
	var/c_have
	var/c_are
	var/c_were
	var/c_do // the only reason these have the c_ prefix is that 'do' is a keyword
	var/c_theyve
	var/c_theyre
	var/c_s
	var/c_es
	var/c_noun // for... mob descriptors?
	var/assoc_gender // used for simplemob stuff mostly

/datum/pronouns/it_its
	name = "it/its"
	c_they = "it"
	c_their = "its"
	c_them = "it"
	c_themselves = "itself"
	c_have = "has"
	c_are = "is"
	c_were = "was"
	c_do = "does"
	c_theyve = "it's"
	c_theyre = "it's"
	c_s = "s"
	c_es = "es"
	c_noun = "creacher"
	assoc_gender = NEUTER

/datum/pronouns/she_her
	name = "she/her"
	c_they = "she"
	c_their = "her"
	c_them = "her"
	c_themselves = "herself"
	c_have = "has"
	c_are = "is"
	c_were = "was"
	c_do = "does"
	c_theyve = "she's"
	c_theyre = "she's"
	c_s = "s"
	c_es = "es"
	c_noun = "woman"
	assoc_gender = FEMALE

/datum/pronouns/they_them
	name = "they/them"
	c_they = "they"
	c_their = "their"
	c_them = "them"
	c_themselves = "themselves"
	c_have = "have"
	c_are = "are"
	c_were = "were"
	c_do = "do"
	c_theyve = "they've"
	c_theyre = "they're"
	c_s = ""
	c_es = ""
	c_noun = "person"
	assoc_gender = PLURAL

/datum/pronouns/he_him
	name = "he/him"
	c_they = "he"
	c_their = "his"
	c_them = "him"
	c_themselves = "himself"
	c_have = "has"
	c_are = "is"
	c_were = "was"
	c_do = "does"
	c_theyve = "he's"
	c_theyre = "he's"
	c_s = "s"
	c_es = "es"
	c_noun = "man"
	assoc_gender = MALE

/datum/pronouns/p_they(capitalized, temp_gender)
	. = c_they
	if(capitalized)
		. = capitalize(.)

/datum/pronouns/p_their(capitalized, temp_gender)
	. = c_their
	if(capitalized)
		. = capitalize(.)

/datum/pronouns/p_them(capitalized, temp_gender)
	. = c_them
	if(capitalized)
		. = capitalize(.)

/datum/pronouns/p_themselves(capitalized, temp_gender)
	. = c_themselves
	if(capitalized)
		. = capitalize(.)

/datum/pronouns/p_have(temp_gender)
	. = c_have

/datum/pronouns/p_are(temp_gender)
	. = c_are

/datum/pronouns/p_were(temp_gender)
	. = c_were

/datum/pronouns/p_do(temp_gender)
	. = c_do

/datum/pronouns/p_theyve(capitalized, temp_gender)
	. = c_theyve

/datum/pronouns/p_theyre(capitalized, temp_gender)
	. = c_theyre

/datum/pronouns/p_s(temp_gender) //is this a descriptive pronouns name, or what?
	. = c_s

/datum/pronouns/p_es(temp_gender)
	. = c_es

/datum/pronouns/proc/m1(self_examine) // used in examine procs
	return (self_examine ? "I am" : "[p_they(TRUE)] [p_are()]")

/datum/pronouns/proc/m2(self_examine)
	return (self_examine ? "my" : "[p_their()]")

/datum/pronouns/proc/m3(self_examine)
	return (self_examine ? "I have" : "[p_they(TRUE)] [p_have()]")

//like clients, which do have gender.
/client/p_they(capitalized, temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "they"
	switch(temp_gender)
		if(FEMALE)
			. = "she"
		if(MALE)
			. = "he"
	if(capitalized)
		. = capitalize(.)

/client/p_their(capitalized, temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "their"
	switch(temp_gender)
		if(FEMALE)
			. = "her"
		if(MALE)
			. = "his"
	if(capitalized)
		. = capitalize(.)

/client/p_them(capitalized, temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "them"
	switch(temp_gender)
		if(FEMALE)
			. = "her"
		if(MALE)
			. = "him"
	if(capitalized)
		. = capitalize(.)

/client/p_have(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "has"
	if(temp_gender == PLURAL || temp_gender == NEUTER)
		. = "have"

/client/p_are(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "is"
	if(temp_gender == PLURAL || temp_gender == NEUTER)
		. = "are"

/client/p_were(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "was"
	if(temp_gender == PLURAL || temp_gender == NEUTER)
		. = "were"

/client/p_do(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "does"
	if(temp_gender == PLURAL || temp_gender == NEUTER)
		. = "do"

/client/p_s(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	if(temp_gender != PLURAL && temp_gender != NEUTER)
		. = "s"

/client/p_es(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	if(temp_gender != PLURAL && temp_gender != NEUTER)
		. = "es"

// LETHALSTONE NOTE: hello! we always return early on PLURAL check here because it's always correct (human mob overrides set it for disguises) and respects disguises. causes some code duplication though

//mobs(and atoms but atoms don't really matter write your own proc overrides) also have gender!
/mob/p_they(capitalized, temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "it"
	switch(temp_gender)
		if(FEMALE)
			. = "she"
		if(MALE)
			. = "he"
		if(PLURAL)
			. = "they"
			if (capitalized)
				. = capitalize(.)
			return

	// mobs can have multiple pronouns now, because of woke. for calls using the old method
	// (usually because we don't know the object in question is a mob), we use the first pronoun selected as a fallback
	// as it's usually the one the player feels most strongly about
	if (pronouns && length(pronouns))
		var/datum/pronouns/used_pronoun = pronouns[1]
		. = used_pronoun.c_they

	if(capitalized)
		. = capitalize(.)

/mob/p_their(capitalized, temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "its"
	switch(temp_gender)
		if(FEMALE)
			. = "her"
		if(MALE)
			. = "his"
		if(PLURAL)
			. = "their"
			if (capitalized)
				. = capitalize(.)
			return

	if (pronouns && length(pronouns))
		var/datum/pronouns/used_pronoun = pronouns[1]
		. = used_pronoun.c_their

	if(capitalized)
		. = capitalize(.)

/mob/p_them(capitalized, temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "it"
	switch(temp_gender)
		if(FEMALE)
			. = "her"
		if(MALE)
			. = "him"
		if(PLURAL)
			. = "them"
			if (capitalized)
				. = capitalize(.)
			return
	
	if (pronouns && length(pronouns))
		var/datum/pronouns/used_pronoun = pronouns[1]
		. = used_pronoun.c_them

	if(capitalized)
		. = capitalize(.)

/mob/p_themselves(capitalized, temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "itself"
	switch(temp_gender)
		if(FEMALE)
			. = "herself"
		if(MALE)
			. = "himself"
		if(PLURAL)
			. = "themselves"
			if (capitalized)
				. = capitalize(.)
			return
	
	if (pronouns && length(pronouns))
		var/datum/pronouns/used_pronoun = pronouns[1]
		. = used_pronoun.c_themselves
	
	if(capitalized)
		. = capitalize(.)

/mob/p_have(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "has"
	if(temp_gender == PLURAL)
		. = "have"
		return

	if (pronouns && length(pronouns))
		var/datum/pronouns/used_pronoun = pronouns[1]
		. = used_pronoun.c_have

/mob/p_are(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "is"
	if(temp_gender == PLURAL)
		. = "are"
		return
	
	if (pronouns && length(pronouns))
		var/datum/pronouns/used_pronoun = pronouns[1]
		. = used_pronoun.c_are

/mob/p_were(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "was"
	if(temp_gender == PLURAL)
		. = "were"
		return
	
	if (pronouns && length(pronouns))
		var/datum/pronouns/used_pronoun = pronouns[1]
		. = used_pronoun.c_were

/mob/p_do(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "does"
	if(temp_gender == PLURAL)
		. = "do"
		return
	
	if (pronouns && length(pronouns))
		var/datum/pronouns/used_pronoun = pronouns[1]
		. = used_pronoun.c_do

/mob/p_s(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	if(temp_gender != PLURAL)
		if(!pronouns || !length(pronouns))
			. = "s"
		else
			var/datum/pronouns/used_pronoun = pronouns[1]
			. = used_pronoun.c_s

/mob/p_es(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	if(temp_gender != PLURAL)
		. = "es"
		if (pronouns && length(pronouns))
			var/datum/pronouns/used_pronoun = pronouns[1]
			. = used_pronoun.c_es

//humans need special handling, because they can have their gender hidden
/mob/living/carbon/human/p_they(capitalized, temp_gender)
	var/list/obscured = check_obscured_slots()
	var/skipface = (wear_mask && (wear_mask.flags_inv & HIDEFACE)) || (head && (head.flags_inv & HIDEFACE))
	if((SLOT_PANTS in obscured) && skipface)
		temp_gender = PLURAL
	return ..()

/mob/living/carbon/human/p_their(capitalized, temp_gender)
	var/list/obscured = check_obscured_slots()
	var/skipface = (wear_mask && (wear_mask.flags_inv & HIDEFACE)) || (head && (head.flags_inv & HIDEFACE))
	if((SLOT_PANTS in obscured) && skipface)
		temp_gender = PLURAL
	return ..()

/mob/living/carbon/human/p_them(capitalized, temp_gender)
	var/list/obscured = check_obscured_slots()
	var/skipface = (wear_mask && (wear_mask.flags_inv & HIDEFACE)) || (head && (head.flags_inv & HIDEFACE))
	if((SLOT_PANTS in obscured) && skipface)
		temp_gender = PLURAL
	return ..()

/mob/living/carbon/human/p_have(temp_gender)
	var/list/obscured = check_obscured_slots()
	var/skipface = (wear_mask && (wear_mask.flags_inv & HIDEFACE)) || (head && (head.flags_inv & HIDEFACE))
	if((SLOT_PANTS in obscured) && skipface)
		temp_gender = PLURAL
	return ..()

/mob/living/carbon/human/p_are(temp_gender)
	var/list/obscured = check_obscured_slots()
	var/skipface = (wear_mask && (wear_mask.flags_inv & HIDEFACE)) || (head && (head.flags_inv & HIDEFACE))
	if((SLOT_PANTS in obscured) && skipface)
		temp_gender = PLURAL
	return ..()

/mob/living/carbon/human/p_were(temp_gender)
	var/list/obscured = check_obscured_slots()
	var/skipface = (wear_mask && (wear_mask.flags_inv & HIDEFACE)) || (head && (head.flags_inv & HIDEFACE))
	if((SLOT_PANTS in obscured) && skipface)
		temp_gender = PLURAL
	return ..()

/mob/living/carbon/human/p_do(temp_gender)
	var/list/obscured = check_obscured_slots()
	var/skipface = (wear_mask && (wear_mask.flags_inv & HIDEFACE)) || (head && (head.flags_inv & HIDEFACE))
	if((SLOT_PANTS in obscured) && skipface)
		temp_gender = PLURAL
	return ..()

/mob/living/carbon/human/p_s(temp_gender)
	var/list/obscured = check_obscured_slots()
	var/skipface = (wear_mask && (wear_mask.flags_inv & HIDEFACE)) || (head && (head.flags_inv & HIDEFACE))
	if((SLOT_PANTS in obscured) && skipface)
		temp_gender = PLURAL
	return ..()

/mob/living/carbon/human/p_es(temp_gender)
	var/list/obscured = check_obscured_slots()
	var/skipface = (wear_mask && (wear_mask.flags_inv & HIDEFACE)) || (head && (head.flags_inv & HIDEFACE))
	if((SLOT_PANTS in obscured) && skipface)
		temp_gender = PLURAL
	return ..()

// used often to get the 'canonical' pronoun for a mob e.g. as a fallback for job outfit detection. this returns a path!
/mob/proc/get_first_pronoun()
	if(!pronouns || !length(pronouns))
		return
	return pronouns[1]

// used to refer to mobs 'properly', in place of the old p_(something) procs. call this once per 'message' to allow pronouns to alternate properly
// this returns a datum instance!
/mob/proc/get_pronoun()
	if(!pronouns || !length(pronouns))
		return
	return GLOB.pronouns[pick(pronouns)]

/mob/living/carbon/human/get_pronoun()
	var/list/obscured = check_obscured_slots()
	var/skipface = (wear_mask && (wear_mask.flags_inv & HIDEFACE)) || (head && (head.flags_inv & HIDEFACE))
	if((SLOT_PANTS in obscured) && skipface)
		return GLOB.pronouns[THEY_THEM] // always use they/them for hidden folks
	return ..()
