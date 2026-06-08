/datum/patron/godless
	name = "Godless"
	domain = "Humenity"
	desc = "The gods exists, but either you do not know them or do not worship them. You guide yourself by your instincts or your reasons."
	worshippers = "Beasts whom cannot reason and the truly cynical."
	associated_faith = /datum/faith/godless
	preference_accessible = FALSE
	undead_hater = FALSE
	confess_lines = list(
		"Gods are WORTHLESS!",
		"I DON'T NEED GODS!",
		"NO GODS, NO MASTERS!",
	)

/datum/patron/godless/can_pray(mob/living/follower)
	. = ..()
	to_chat(follower, span_danger("You worship no gods, who are you praying to?"))
	return FALSE

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
