/datum/quest/kill/towner_miner_orevein
	quest_type = QUEST_TOWNER_MINER_OREVEIN
	quest_difficulty = QUEST_DIFFICULTY_HARD
	required_fellowship_size = TOWNER_QUEST_FELLOWSHIP_SIZE
	levy_exempt = TRUE
	guild_cut_exempt = TRUE
	tp_budget = QUEST_TP_BUDGET_RECOVERY
	threat_bands_cleared = QUEST_BANDS_RECOVERY
	var/posting_tier = TOWNER_POSTING_TIER_HARD

/datum/quest/kill/towner_miner_orevein/calculate_deposit()
	return 0

/datum/quest/kill/towner_miner_orevein/can_claim(mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	return towner_can_claim_check(src, user)

/datum/quest/kill/towner_miner_orevein/claim_failure_reason(mob/living/user)
	var/towner_reason = towner_claim_failure_reason(src, user)
	if(towner_reason)
		return towner_reason
	return ..()

/datum/quest/kill/towner_miner_orevein/get_title()
	if(title)
		return title
	return "A Miner's Lead"

/datum/quest/kill/towner_miner_orevein/get_objective_text()
	return "Escort the miner, slay the guardian elementals, and let them work the vein."

/datum/quest/kill/towner_miner_orevein/proc/on_turn_in_pay_giver(mob/bearer, turf/ledger_turf)
	return
