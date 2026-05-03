/datum/quest/towner
	quest_difficulty = QUEST_DIFFICULTY_HARD
	required_fellowship_size = TOWNER_QUEST_FELLOWSHIP_SIZE
	levy_exempt = TRUE
	guild_cut_exempt = TRUE
	var/posting_tier = TOWNER_POSTING_TIER_HARD

/datum/quest/towner/calculate_deposit()
	return 0

/datum/quest/towner/preview(obj/effect/landmark/quest_spawner/landmark)
	. = ..()
	if(!.)
		return FALSE
	finalize_preview_title()
	return TRUE

/datum/quest/towner/can_claim(mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	var/mob/poster = quest_giver_reference?.resolve()
	if(!poster)
		return FALSE
	var/datum/fellowship/F = user?.current_fellowship
	if(!F || !F.has_member(poster))
		return FALSE
	return TRUE

/datum/quest/towner/claim_failure_reason(mob/living/user)
	var/mob/poster = quest_giver_reference?.resolve()
	if(!poster)
		return "The contract-poster is no longer with us."
	var/datum/fellowship/F = user?.current_fellowship
	if(!F)
		return "You must form a Fellowship that includes [quest_giver_name] before signing."
	if(!F.has_member(poster))
		return "[quest_giver_name] must be in your Fellowship before you can sign."
	return ..()

/datum/quest/towner/proc/on_turn_in_pay_giver(mob/bearer, turf/ledger_turf)
	return
