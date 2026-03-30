/datum/patron/mossmother
	name = "The Mossmother"
	domain = "Hags, primordial evyl, poisoned boons and eternal life."
	desc = "The mother of all hags. Murmured by hags to have been defeated in times long past, but her spirit carries on in the soil. Old grievances will be settled."
	worshippers = "Hags"
	associated_faith = /datum/faith/mossmother
	preference_accessible = FALSE
	undead_hater = FALSE
	confess_lines = list(
		"THE MOSSMOTHER SEES YOU!",
		"YOU WILL PAY THE PRICE DEARIE!",
		"You're so far up Psydon's cake you can't see straight. Pathetic.",
		"REVENGE IS DUE.",
		"I AM THE LAND. YOU SHOULD BE THANKING ME FOR THREADING IT.",
	)

/datum/patron/godless/can_pray(mob/living/follower)
	. = ..()
	to_chat(follower, span_danger("I do not need to pray to the Mossmother, she is with me always."))
	return FALSE	//heathen

/datum/patron/godless/on_lesser_heal(
    mob/living/user,
    mob/living/target,
    message_out,
    message_self,
    conditional_buff,
    situational_bonus
)
	*message_out = span_info("Without any particular cause or reason, [target] is healed!")
	*message_self = span_notice("My wounds close without cause.")
