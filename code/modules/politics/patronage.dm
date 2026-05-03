/// Global roll of current Ecclesiastical Benefactors. Iterated for revocation, inspection, and decree-revoke cleanup.
GLOBAL_LIST_EMPTY(declared_benefactors)

/datum/controller/subsystem/treasury
	/// ckey -> list of WEAKREFs of currently-granted recipients
	var/list/patronage_grants = list()
	/// ckey -> world.time of last grant action
	var/list/patronage_last_grant = list()

/datum/controller/subsystem/treasury/proc/can_issue_patronage(mob/living/granter)
	if(!granter?.ckey)
		return FALSE
	var/last = patronage_last_grant[granter.ckey]
	if(last && world.time < last + PATRONAGE_GRANT_COOLDOWN)
		return FALSE
	var/list/held = patronage_grants[granter.ckey]
	if(held && length(held) >= PATRONAGE_CAP_PER_ROUND)
		return FALSE
	return TRUE

/datum/controller/subsystem/treasury/proc/patronage_cooldown_remaining(mob/living/granter)
	if(!granter?.ckey)
		return 0
	var/last = patronage_last_grant[granter.ckey]
	if(!last)
		return 0
	return max(0, (last + PATRONAGE_GRANT_COOLDOWN) - world.time)

/datum/controller/subsystem/treasury/proc/record_patronage_grant(mob/living/granter, mob/living/recipient)
	if(!granter?.ckey || !recipient)
		return
	var/list/held = patronage_grants[granter.ckey]
	if(!held)
		held = list()
		patronage_grants[granter.ckey] = held
	held += WEAKREF(recipient)
	patronage_last_grant[granter.ckey] = world.time

/datum/controller/subsystem/treasury/proc/record_patronage_revoke(mob/living/granter, mob/living/recipient)
	if(!granter?.ckey || !recipient)
		return
	var/list/held = patronage_grants[granter.ckey]
	if(!held)
		return
	for(var/datum/weakref/ref in held)
		if(ref.resolve() == recipient)
			held -= ref
			break
	patronage_last_grant[granter.ckey] = world.time

/datum/controller/subsystem/treasury/proc/get_patronage_count(mob/living/granter)
	if(!granter?.ckey)
		return 0
	var/list/held = patronage_grants[granter.ckey]
	if(!held)
		return 0
	// Prune expired weakrefs
	for(var/datum/weakref/ref in held)
		if(!ref.resolve())
			held -= ref
	return length(held)

/// Shared helper: target an adjacent mob, toggle the given trait. Returns TRUE on success.
/// `grant_label` - name shown to target in the accept dialog (e.g. "a Benefactor of the Church").
/// `grant_proclamation` - uppercase IC line the granter says on acceptance
///                       (e.g. "a benefactor of the Church of Azuria").
/// `revoke_proclamation` - uppercase IC line the granter says on revocation
///                        (e.g. "no longer a benefactor of the Church of Azuria").
/proc/perform_patronage_grant(mob/living/carbon/human/granter, trait_id, grant_label, grant_proclamation, revoke_proclamation)
	if(!granter.mind || granter.stat)
		return FALSE
	var/list/candidates = list()
	for(var/mob/living/carbon/human/H in orange(1, granter))
		if(H == granter)
			continue
		if(H.stat)
			continue
		candidates += H
	if(!length(candidates))
		to_chat(granter, span_warning("There is no one nearby to receive my blessing."))
		return FALSE
	var/mob/living/carbon/human/target = input(granter, "Choose a recipient", "Patronage Grant") as null|anything in candidates
	if(!target || !granter.Adjacent(target))
		return FALSE
	// Revocation path: if they already hold the trait from this granter, pull it back
	if(HAS_TRAIT_FROM(target, trait_id, "[TRAIT_PATRONAGE_GRANT]_[granter.ckey]"))
		revoke_patronage(granter, target, trait_id, revoke_proclamation)
		return TRUE
	// Grant path
	if(!SStreasury.can_issue_patronage(granter))
		var/count = SStreasury.get_patronage_count(granter)
		if(count >= PATRONAGE_CAP_PER_ROUND)
			to_chat(granter, span_warning("I have already extended patronage to as many as I may this week."))
		else
			var/remaining = SStreasury.patronage_cooldown_remaining(granter)
			to_chat(granter, span_warning("I must wait [round(remaining / 10)]s before extending further patronage."))
		return FALSE
	if(HAS_TRAIT(target, trait_id))
		to_chat(granter, span_warning("[target] already holds that status."))
		return FALSE
	var/confirm = alert(target, "[granter.real_name] offers to declare you [grant_label]. Do you accept?", "Patronage Offered", "Accept", "Decline")
	if(confirm != "Accept")
		to_chat(granter, span_warning("[target] has declined."))
		return FALSE
	ADD_TRAIT(target, trait_id, "[TRAIT_PATRONAGE_GRANT]_[granter.ckey]")
	SStreasury.record_patronage_grant(granter, target)
	var/list/global_list = get_patronage_global_list(trait_id)
	if(global_list)
		global_list |= target
	granter.say("I HEREBY DECLARE YOU, [uppertext(target.name)], [uppertext(grant_proclamation)]!")
	log_game("PATRONAGE GRANT: [key_name(granter)] declared [key_name(target)] as [grant_label]")
	return TRUE

/// Returns the global list matching the given patronage trait, for iteration / revocation.
/proc/get_patronage_global_list(trait_id)
	switch(trait_id)
		if(TRAIT_DECLARED_BENEFACTOR)
			return GLOB.declared_benefactors
	return null

/// Revoke a patronage grant from a specific target. No adjacency check - the granter may
/// strike names from the faction's rolls remotely.
/proc/revoke_patronage(mob/living/carbon/human/granter, mob/living/carbon/human/target, trait_id, revoke_proclamation)
	if(!granter || !target)
		return FALSE
	REMOVE_TRAIT(target, trait_id, "[TRAIT_PATRONAGE_GRANT]_[granter.ckey]")
	SStreasury.record_patronage_revoke(granter, target)
	var/list/global_list = get_patronage_global_list(trait_id)
	if(global_list)
		global_list -= target
	granter.say("I HEREBY DECLARE YOU, [uppertext(target.name)], [uppertext(revoke_proclamation)]!")
	log_game("PATRONAGE REVOKE: [key_name(granter)] revoked patronage from [key_name(target)]")
	return TRUE

/// Prune stale / dead entries from a patronage global list before display.
/proc/prune_patronage_list(list/the_list)
	if(!the_list)
		return
	for(var/mob/living/M in the_list)
		if(QDELETED(M) || M.stat == DEAD)
			the_list -= M

/// Shared helper: pick one of the granter's existing patronage recipients from a list and revoke.
/// Returns TRUE on success.
/proc/perform_patronage_revoke_from_list(mob/living/carbon/human/granter, trait_id, revoke_proclamation)
	if(!granter.mind || granter.stat)
		return FALSE
	var/list/global_list = get_patronage_global_list(trait_id)
	if(!global_list)
		return FALSE
	prune_patronage_list(global_list)
	// Filter to entries this specific granter issued
	var/list/owned_by_granter = list()
	var/granter_source = "[TRAIT_PATRONAGE_GRANT]_[granter.ckey]"
	for(var/mob/living/carbon/human/H in global_list)
		if(HAS_TRAIT_FROM(H, trait_id, granter_source))
			owned_by_granter[H.real_name] = H
	if(!length(owned_by_granter))
		to_chat(granter, span_warning("I have extended no such patronage to revoke."))
		return FALSE
	var/chosen_name = input(granter, "Whose patronage shall be struck from the rolls?", "Revoke Patronage") as null|anything in owned_by_granter
	if(!chosen_name)
		return FALSE
	var/mob/living/carbon/human/target = owned_by_granter[chosen_name]
	if(!target || QDELETED(target))
		return FALSE
	revoke_patronage(granter, target, trait_id, revoke_proclamation)
	return TRUE

