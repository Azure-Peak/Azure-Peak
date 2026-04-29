/// Assembly vote weight by civic department. Commons-only: Keep and Inquisition get no vote
/// (civic-dead for Assembly purposes). Wretches and the un-jobbed are also excluded.
/proc/assembly_job_weight(job)
	var/dept = civic_department(job)
	switch(dept)
		if("KEEP", "INQUISITION", "EXCLUDED", "NONE")
			return ASSEMBLY_WEIGHT_NONE
		if("TOWN_TRANSIENT")
			return ASSEMBLY_WEIGHT_1
		if("TOWN_PEASANT")
			return ASSEMBLY_WEIGHT_1_5
		if("TOWN_BURGHER", "TOWN_CLERGY")
			return ASSEMBLY_WEIGHT_2
		if("TOWN_NOTABLE")
			return ASSEMBLY_WEIGHT_4
	return ASSEMBLY_WEIGHT_NONE

/datum/controller/subsystem/city_assembly/proc/resolve_election(datum/assembly_session/S)
	var/list/tally = list()
	var/total_weight = 0
	for(var/datum/weakref/wr in S.ballots[ASSEMBLY_MOTION_ELECTION])
		var/list/entry = S.ballots[ASSEMBLY_MOTION_ELECTION][wr]
		var/choice = entry["choice"]
		var/w = entry["weight"]
		if(w <= 0)
			continue
		total_weight += w
		tally[choice] = (tally[choice] || 0) + w

	var/list/out = list(
		"tally" = tally,
		"total_weight" = total_weight,
		"winner_key" = null,
		"winner_name" = null,
		"winner_job" = null,
		"changed" = FALSE,
		"skipped_names" = list(),
	)

	if(!length(tally))
		return out

	// Sort choices by descending tally. Walk the list; the first eligible candidate takes the
	// seat. Dead, outlawed, or censured front-runners fall through to whoever the Assembly
	// ranked next. NO_ALDERMAN terminates the walk: if it out-ranks every eligible candidate,
	// the Commons has chosen nobody.
	var/list/sorted_keys = sortTim(tally.Copy(), /proc/cmp_numeric_dsc, associative = TRUE)

	for(var/key in sorted_keys)
		if(key == "NO_ALDERMAN")
			// Walking top-down, if NO_ALDERMAN is reached before any eligible candidate, it beats
			// the rest. Vacate the seat and stop.
			out["winner_key"] = key
			if(resolve_get_alderman())
				demote_alderman("vacated by Assembly vote")
				out["changed"] = TRUE
				out["winner_name"] = "(vacant)"
			return out

		var/datum/weakref/winner_wr
		var/list/candidate_info
		for(var/datum/weakref/wr in S.candidates)
			if("[wr]" == key)
				winner_wr = wr
				candidate_info = S.candidates[wr]
				break
		if(!winner_wr)
			continue

		var/candidate_name = candidate_info?["name"] || "(unknown)"
		var/mob/winner = winner_wr.resolve()
		if(!winner || !can_hold_office(winner))
			// Top-voted candidate can't take the seat (dead, outlawed, censured, gone). Log it
			// and fall through to the next-ranked choice.
			out["skipped_names"] += candidate_name
			continue

		out["winner_key"] = key
		out["winner_name"] = candidate_name
		out["winner_job"] = candidate_info?["job"] || "no station"
		var/mob/current = resolve_get_alderman()
		if(current != winner)
			promote_to_alderman(winner)
			out["changed"] = TRUE
		return out

	// Walked every candidate, none eligible. The seat remains as it was; note the skipped
	// names for the summary.
	return out

/datum/controller/subsystem/city_assembly/proc/resolve_bracket_motion(datum/assembly_session/S, motion_id, list/brackets)
	var/list/tally_by_choice = list()
	var/nae_weight = 0
	var/total_weight = 0
	for(var/datum/weakref/wr in S.ballots[motion_id])
		var/list/entry = S.ballots[motion_id][wr]
		var/choice = entry["choice"]
		var/w = entry["weight"]
		if(w <= 0)
			continue
		total_weight += w
		if(choice == ASSEMBLY_BRACKET_NAE)
			nae_weight += w
		else
			tally_by_choice[choice] = (tally_by_choice[choice] || 0) + w

	var/list/out = list(
		"tally_by_choice" = tally_by_choice,
		"nae_weight" = nae_weight,
		"total_weight" = total_weight,
		"brackets" = brackets.Copy(),
		"winning_bracket" = null,
		"vetoed" = FALSE,
	)

	if(total_weight == 0)
		return out

	if((nae_weight * 100) >= (total_weight * ASSEMBLY_NAE_VETO_PCT))
		out["vetoed"] = TRUE
		return out

	// Max-acceptable: a vote for X supports all brackets <= X. Walk brackets from highest
	// to lowest; for each, cumulative support = sum of weight whose chosen bracket >= this.
	// The highest bracket with cumulative support >= pass% of total_weight wins.
	var/list/sorted = sortTim(brackets.Copy(), cmp = /proc/cmp_numeric_dsc)
	for(var/candidate in sorted)
		var/cumulative = 0
		for(var/choice in tally_by_choice)
			var/as_num = text2num(choice)
			if(isnull(as_num))
				continue
			if(as_num >= candidate)
				cumulative += tally_by_choice[choice]
		if((cumulative * 100) >= (total_weight * ASSEMBLY_BRACKET_PASS_PCT))
			out["winning_bracket"] = candidate
			return out
	return out

/datum/controller/subsystem/city_assembly/proc/resolve_yae_motion(datum/assembly_session/S, motion_id, threshold_pct)
	var/yae_weight = 0
	var/nay_weight = 0
	var/cast_weight = 0
	var/cast_count = 0
	for(var/datum/weakref/wr in S.ballots[motion_id])
		var/list/entry = S.ballots[motion_id][wr]
		var/choice = entry["choice"]
		var/w = entry["weight"]
		if(w <= 0)
			continue
		if(choice == ASSEMBLY_YAE)
			yae_weight += w
			cast_weight += w
			cast_count++
		else if(choice == ASSEMBLY_NAY)
			nay_weight += w
			cast_weight += w
			cast_count++

	var/list/out = list(
		"yae_weight" = yae_weight,
		"nay_weight" = nay_weight,
		"cast_weight" = cast_weight,
		"cast_count" = cast_count,
		"passed" = FALSE,
		"reason" = "",
	)

	if(cast_weight < ASSEMBLY_REMOVAL_WEIGHT_FLOOR)
		out["reason"] = "insufficient weight floor"
		return out
	if(cast_count < ASSEMBLY_REMOVAL_MOB_FLOOR)
		out["reason"] = "insufficient distinct voters"
		return out
	if((yae_weight * 100) >= (cast_weight * threshold_pct))
		out["passed"] = TRUE
	return out

/datum/controller/subsystem/city_assembly/proc/apply_trade_authorization(list/result)
	if(!current_warrant)
		return
	// No participation preserves the existing cap - silence is not withdrawal.
	if(result["total_weight"] <= 0)
		return
	// Active veto zeroes the cap - that IS a decision, not indecision.
	if(result["vetoed"])
		current_warrant.set_trade_cap(0)
		return
	// Votes cast but no bracket carried a majority - keep status quo. Scattered votes across
	// brackets shouldn't strip a cap the Commons previously authorized.
	if(isnull(result["winning_bracket"]))
		return
	current_warrant.set_trade_cap(result["winning_bracket"])

/datum/controller/subsystem/city_assembly/proc/apply_defense_authorization(list/result)
	if(!current_warrant)
		return
	if(result["total_weight"] <= 0)
		return
	if(result["vetoed"])
		current_warrant.set_defense_cap(0)
		return
	if(isnull(result["winning_bracket"]))
		return
	current_warrant.set_defense_cap(result["winning_bracket"])

// Assembly poll tax is disabled from the resolution slate pending anti-dodge design - the
// assess-against-bank-only check invited a trivial exploit (pull cash to on-person before
// the vote resolves, appear broke, skip the levy, redeposit after). levy_poll_tax remains
// callable from the admin verb for direct testing. See design doc for the replacement proposal.
//
// /datum/controller/subsystem/city_assembly/proc/apply_poll_tax(list/result)
//     ... (formerly wired into resolve_session)

/datum/controller/subsystem/city_assembly/proc/levy_poll_tax(amount)
	var/total_collected = 0
	var/payers = 0
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.stat == DEAD)
			continue
		if(HAS_TRAIT(H, TRAIT_OUTLAW))
			continue
		var/datum/fund/account = SStreasury.get_account(H)
		if(!account)
			continue
		if(account.balance < amount)
			continue
		if(SStreasury.burn(account, amount, "City Assembly poll levy for common defense"))
			total_collected += amount
			payers++
	if(total_collected <= 0)
		return
	var/pledge_gain = total_collected * ASSEMBLY_POLL_PLEDGE_MULTIPLIER
	if(SStreasury.burgher_pledge_fund)
		SStreasury.mint(SStreasury.burgher_pledge_fund, pledge_gain, "City Assembly poll-levy bonus (2x magic multiplier)")
	log_game("CITY ASSEMBLY: poll tax levied - [amount]m from [payers] payer(s); [total_collected]m collected, [pledge_gain]p minted into Pledge.")

/datum/controller/subsystem/city_assembly/proc/build_summary_text(list/summary)
	var/list/lines = list()
	if(summary["flavor_prefix"])
		lines += "<i>[summary["flavor_prefix"]]</i>"
	lines += "<b>The City Assembly convenes (Session [summary["session"]]).</b>"
	if(!isnull(summary["quorate"]) && !summary["quorate"])
		lines += "<b>Quorum not met</b> &mdash; only [summary["voter_count"]] voice[summary["voter_count"] == 1 ? "" : "s"] took part. Status quo retained; no motions carry."
		return lines.Join("<br>")

	var/list/election = summary["results"]?["election"]
	if(election)
		var/list/skipped = election["skipped_names"]
		var/skip_note = ""
		if(islist(skipped) && length(skipped))
			skip_note = " (skipped: [jointext(skipped, ", ")] - outlawed or censured)"
		var/winner_label = election["winner_name"]
		var/winner_job = election["winner_job"]
		if(winner_label && winner_job)
			winner_label = "[winner_label], the [winner_job]"
		if(election["changed"])
			lines += "<b>Alderman:</b> [winner_label || "(vacant)"] takes the seat[skip_note]."
		else if(election["winner_name"])
			lines += "<b>Alderman:</b> [winner_label] retains the seat[skip_note]."
		else
			lines += "<b>Alderman:</b> no candidate carried; the seat remains as it was[skip_note]."

	var/list/trade = summary["results"]?["trade_auth"]
	if(trade)
		if(trade["vetoed"])
			lines += "<b>Trade warrant:</b> DENIED by the Commons (NAE >= 50%)."
		else if(!isnull(trade["winning_bracket"]))
			lines += "<b>Trade warrant:</b> [trade["winning_bracket"]]m/day authorized."
		else
			lines += "<b>Trade warrant:</b> no bracket carried a majority."

	var/list/defense = summary["results"]?["defense_auth"]
	if(defense)
		if(defense["vetoed"])
			lines += "<b>Defense warrant:</b> DENIED by the Commons (NAE >= 50%)."
		else if(!isnull(defense["winning_bracket"]))
			lines += "<b>Defense warrant:</b> [defense["winning_bracket"]]p/day authorized."
		else
			lines += "<b>Defense warrant:</b> no bracket carried a majority."

	var/list/recall = summary["results"]?["recall"]
	if(recall && recall["cast_count"] > 0)
		lines += "<b>Recall motion:</b> [recall["passed"] ? "PASSED - Alderman removed." : "failed."]"

	var/list/censure = summary["results"]?["censure"]
	if(censure && censure["cast_count"] > 0)
		lines += "<b>Censure motion:</b> [censure["passed"] ? "PASSED - name stricken from the ledger, barred for the week." : "failed."]"

	return lines.Join("<br>")

/// Pure dry-run of the current session's tallies for display in the TGUI. Never mutates state.
/// Cached on the subsystem; writes call invalidate_tallies() to clear. Individual ballots stay
/// private - only aggregates returned.
/datum/controller/subsystem/city_assembly/proc/preview_tallies()
	if(!isnull(cached_tallies))
		return cached_tallies
	var/list/out = list()
	if(!current_session)
		cached_tallies = out
		return out
	var/datum/assembly_session/S = current_session

	var/list/election_t = list()
	var/election_total = 0
	for(var/datum/weakref/wr in S.ballots[ASSEMBLY_MOTION_ELECTION])
		var/list/entry = S.ballots[ASSEMBLY_MOTION_ELECTION][wr]
		var/choice = entry["choice"]
		var/w = entry["weight"]
		if(w <= 0)
			continue
		election_t[choice] = (election_t[choice] || 0) + w
		election_total += w
	var/election_leader
	var/election_leader_weight = 0
	for(var/k in election_t)
		if(election_t[k] > election_leader_weight)
			election_leader_weight = election_t[k]
			election_leader = k
	out["election"] = list(
		"tally" = election_t,
		"total" = election_total,
		"leader_key" = election_leader,
	)

	var/list/brackets_by_motion = list(
		ASSEMBLY_MOTION_TRADE_AUTH = ASSEMBLY_TRADE_BRACKETS,
		ASSEMBLY_MOTION_DEFENSE_AUTH = ASSEMBLY_DEFENSE_BRACKETS,
		// ASSEMBLY_MOTION_POLL_TAX disabled pending anti-dodge design.
	)
	for(var/motion_id in brackets_by_motion)
		var/list/result = resolve_bracket_motion(S, motion_id, brackets_by_motion[motion_id])
		out[motion_id] = list(
			"tally" = result["tally_by_choice"],
			"nae" = result["nae_weight"],
			"total" = result["total_weight"],
			"winning_bracket" = result["winning_bracket"],
			"vetoed" = result["vetoed"],
		)

	var/list/recall_result = resolve_yae_motion(S, ASSEMBLY_MOTION_RECALL, ASSEMBLY_RECALL_THRESHOLD_PCT)
	out[ASSEMBLY_MOTION_RECALL] = list(
		"yae" = recall_result["yae_weight"],
		"nay" = recall_result["nay_weight"],
		"total" = recall_result["cast_weight"],
		"count" = recall_result["cast_count"],
		"would_pass" = recall_result["passed"],
	)

	var/list/censure_result = resolve_yae_motion(S, ASSEMBLY_MOTION_CENSURE, ASSEMBLY_CENSURE_THRESHOLD_PCT)
	out[ASSEMBLY_MOTION_CENSURE] = list(
		"yae" = censure_result["yae_weight"],
		"nay" = censure_result["nay_weight"],
		"total" = censure_result["cast_weight"],
		"count" = censure_result["cast_count"],
		"would_pass" = censure_result["passed"],
	)

	cached_tallies = out
	return out
