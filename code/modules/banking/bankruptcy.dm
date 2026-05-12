// Treasury solvency state machine: NORMAL -> IN_ARREARS -> BANKRUPTCY (and back).
// All transitions go through these helpers. distribute_daily_payments and the debt-skim
// path read treasury_state but never mutate it.

/datum/controller/subsystem/treasury/proc/is_in_receivership()
	return treasury_state == TREASURY_BANKRUPTCY

/datum/controller/subsystem/treasury/proc/is_in_arrears_or_worse()
	return treasury_state != TREASURY_NORMAL

/datum/controller/subsystem/treasury/proc/enter_arrears(projected_total)
	if(treasury_state != TREASURY_NORMAL)
		return FALSE
	var/shortfall = max(0, projected_total - discretionary_fund.balance)
	var/loan_amount = max(TREASURY_ARREARS_LOAN, shortfall)
	treasury_state = TREASURY_IN_ARREARS
	treasury_debt += loan_amount
	GLOB.azure_round_stats[STATS_TREASURY_DEBT_OUTSTANDING] = treasury_debt
	record_round_statistic(STATS_ARREARS_DECLARED, 1)
	// Direct credit so the loan itself isn't immediately skimmed against the debt we just registered.
	discretionary_fund.balance += loan_amount
	log_fund_entry(new /datum/treasury_entry("mint", null, discretionary_fund, loan_amount, "Arrears advance from the Azurian Trading Company"))
	priority_announce(
		"The Crown's coffers ran dry at payroll. The Burghers of Azuria, by their standing pledge, advance [loan_amount]m at no interest to cover the day's wages. Should the Crown fail again on the morrow, the realm enters sequestration.",
		"THE BURGHERS LEND",
		'sound/misc/royal_decree2.ogg',
		"Captain",
	)
	return TRUE

/datum/controller/subsystem/treasury/proc/enter_bankruptcy()
	if(treasury_state == TREASURY_BANKRUPTCY)
		return FALSE
	bankruptcy_count += 1
	record_round_statistic(STATS_BANKRUPTCY_DECLARED, 1)

	// Reset purse to the operating floor. Adjust by difference and log so the ledger reflects
	// the residual being burned (or topped up) rather than a silent assignment.
	if(discretionary_fund.balance > BANKRUPTCY_OPERATING_FLOOR)
		var/excess = discretionary_fund.balance - BANKRUPTCY_OPERATING_FLOOR
		discretionary_fund.balance = BANKRUPTCY_OPERATING_FLOOR
		log_fund_entry(new /datum/treasury_entry("burn", discretionary_fund, null, excess, "Sequestration: residual purse forfeit"))
	else if(discretionary_fund.balance < BANKRUPTCY_OPERATING_FLOOR)
		var/topup = BANKRUPTCY_OPERATING_FLOOR - discretionary_fund.balance
		discretionary_fund.balance = BANKRUPTCY_OPERATING_FLOOR
		log_fund_entry(new /datum/treasury_entry("mint", null, discretionary_fund, topup, "Sequestration: operating reserve from the Azurian Trading Company"))

	// Existing arrears debt is rolled into the new sequestration debt rather than dropped,
	// so the Crown doesn't escape the smaller obligation by failing harder.
	var/new_debt = BANKRUPTCY_DEBT_FLAT
	treasury_debt += new_debt
	GLOB.azure_round_stats[STATS_TREASURY_DEBT_OUTSTANDING] = treasury_debt
	treasury_state = TREASURY_BANKRUPTCY

	suspend_all_salaries_for_bankruptcy()
	suspend_charters_for_bankruptcy()
	override_trade_for_bankruptcy()

	priority_announce(
		"Following seizure of [atc_seizure_blurb()] against the Crown's outstanding obligations, the Azurian Trading Company - most blessed, most devout servant of Malum the Worker and Abyssor the Dreamer - has graciously advanced an interest-free reserve of [BANKRUPTCY_OPERATING_FLOOR]m in exchange for a debt of [new_debt]m to the Company. Until the debt is repaid in full, the Company holds the sequestered revenues of the realm and farms the customs and salt tolls in perpetuity; the stockpile and trade-engine pass to its hand, that the orderly operation of commerce may be assured for the common weal. Salaries stand suspended; all Charters but the Golden Bull are dissolved.",
		"SEQUESTRATION DECLARED",
		'sound/misc/royal_decree.ogg',
		"Captain",
	)
	return TRUE

/// Called by skim_for_treasury_debt the moment treasury_debt reaches zero.
/// In NORMAL state the only thing to do is reset the loan flag - an ATC emergency loan
/// has been repaid in full and the arrears safety net is restored.
/datum/controller/subsystem/treasury/proc/clear_treasury_debt_state()
	switch(treasury_state)
		if(TREASURY_NORMAL)
			if(atc_loan_arrears_consumed)
				atc_loan_arrears_consumed = FALSE
				priority_announce(
					"The Crown's debt to the Azurian Trading Company is settled. The Burghers' grace stands restored.",
					"ATC LOAN SETTLED",
					'sound/misc/royal_decree2.ogg',
					"Captain",
				)
		if(TREASURY_IN_ARREARS)
			exit_arrears()
		if(TREASURY_BANKRUPTCY)
			exit_bankruptcy()

/datum/controller/subsystem/treasury/proc/exit_arrears()
	if(treasury_state != TREASURY_IN_ARREARS)
		return
	treasury_state = TREASURY_NORMAL
	atc_loan_arrears_consumed = FALSE
	priority_announce(
		"The Crown has settled its arrears with the Burghers. The realm is solvent once more.",
		"THE BURGHERS PAID",
		'sound/misc/royal_decree2.ogg',
		"Captain",
	)

/datum/controller/subsystem/treasury/proc/exit_bankruptcy()
	if(treasury_state != TREASURY_BANKRUPTCY)
		return
	treasury_state = TREASURY_NORMAL

	// The skim leaves the purse at exactly the operating floor; top up to the recovery target
	// so the Crown has working capital to resume.
	if(discretionary_fund.balance < BANKRUPTCY_RECOVERY_RESET)
		var/topup = BANKRUPTCY_RECOVERY_RESET - discretionary_fund.balance
		discretionary_fund.balance = BANKRUPTCY_RECOVERY_RESET
		log_fund_entry(new /datum/treasury_entry("mint", null, discretionary_fund, topup, "Sequestration lifted: working capital"))

	resume_all_salaries_after_bankruptcy()
	// Trade configuration intentionally NOT restored - re-tuning it is part of the cost of failure.
	bankruptcy_concession_picks = BANKRUPTCY_CONCESSION_PICKS
	atc_loan_arrears_consumed = FALSE
	GLOB.azure_round_stats[STATS_TREASURY_DEBT_OUTSTANDING] = 0

	priority_announce(
		"The Azurian Trading Company releases the Crown's commerce. Wages resume on the morrow. The Lord may, by ancient prerogative, restore up to [BANKRUPTCY_CONCESSION_PICKS] of the suspended Charters at once; all others must wait the customary span between proclamations.",
		"SEQUESTRATION LIFTED",
		'sound/misc/royal_decree.ogg',
		"Captain",
	)

/// Blanket-apply TRAIT_WAGES_SUSPENDED via "bankruptcy" source so we only lift it on recovery,
/// leaving any prior Steward-applied (TRAIT_GENERIC) suspensions in place.
/datum/controller/subsystem/treasury/proc/suspend_all_salaries_for_bankruptcy()
	if(!steward_machine || !steward_machine.daily_payments)
		return
	var/list/job_names = steward_machine.daily_payments
	for(var/mob/living/carbon/human/H as anything in GLOB.human_list)
		if(!H.job || !(H.job in job_names))
			continue
		if(HAS_TRAIT(H, TRAIT_WAGES_SUSPENDED))
			continue
		ADD_TRAIT(H, TRAIT_WAGES_SUSPENDED, "bankruptcy")

/datum/controller/subsystem/treasury/proc/resume_all_salaries_after_bankruptcy()
	for(var/mob/living/carbon/human/H as anything in GLOB.human_list)
		REMOVE_TRAIT(H, TRAIT_WAGES_SUSPENDED, "bankruptcy")

/// Force-suspend bankruptcy-listed Charters, bypassing cooldown and the daily revoke gate -
/// these aren't policy decisions, they're mechanical consequences of default.
/datum/controller/subsystem/treasury/proc/suspend_charters_for_bankruptcy()
	bankruptcy_suspended_decree_ids.Cut()
	for(var/decree_id in BANKRUPTCY_SUSPENDED_DECREES)
		var/datum/decree/D = decrees[decree_id]
		if(!D)
			continue
		if(D.active)
			D.active = FALSE
			D.cooldown_expires = 0
			D.on_revoke()
		D.bankruptcy_suspended = TRUE
		bankruptcy_suspended_decree_ids += decree_id
	steward_machine?.enforce_wage_floors()

/// Force every importable good onto standing import and pin auto-export at the sequestration
/// ratio. Not snapshotted - the Steward must re-tune by hand on recovery.
/datum/controller/subsystem/treasury/proc/override_trade_for_bankruptcy()
	autoexport_percentage = BANKRUPTCY_AUTOEXPORT_PERCENTAGE
	auto_import_disabled.Cut()
	for(var/good_id in GLOB.trade_goods)
		var/datum/trade_good/tg = GLOB.trade_goods[good_id]
		if(tg && tg.importable)
			auto_import_standing[good_id] = TRUE

/// Cooldown-free restore of a bankruptcy-suspended charter. Returns TRUE on success.
/datum/controller/subsystem/treasury/proc/restore_charter_via_concession(decree_id)
	if(bankruptcy_concession_picks <= 0)
		return FALSE
	var/datum/decree/D = decrees[decree_id]
	if(!D || !D.bankruptcy_suspended || D.active)
		return FALSE
	D.bankruptcy_suspended = FALSE
	D.active = TRUE
	D.year = CALENDAR_EPOCH_YEAR
	D.cooldown_expires = 0
	D.has_ever_been_active = TRUE
	D.on_restore()
	D.broadcast_state_change()
	bankruptcy_concession_picks -= 1
	bankruptcy_suspended_decree_ids -= decree_id
	steward_machine?.enforce_wage_floors()
	return TRUE

/// Called from set_decree_active before any state change. Golden Bull cannot be revoked
/// during sequestration; bankruptcy-suspended charters are immutable until concession-restored.
/datum/controller/subsystem/treasury/proc/can_mutate_decree(decree_id, new_active)
	if(treasury_state == TREASURY_BANKRUPTCY && decree_id == DECREE_GOLDEN_BULL && !new_active)
		return FALSE
	if(treasury_state != TREASURY_BANKRUPTCY)
		return TRUE
	var/datum/decree/D = decrees[decree_id]
	if(!D)
		return FALSE
	if(D.bankruptcy_suspended)
		return FALSE
	return TRUE

/proc/bankruptcy_state_label(state_value)
	switch(state_value)
		if(TREASURY_NORMAL)
			return "Solvent"
		if(TREASURY_IN_ARREARS)
			return "In Arrears"
		if(TREASURY_BANKRUPTCY)
			return "Sequestered"
	return "Unknown"

/// Properties the Azurian Trading Company "seizes" against the Crown's debts on bankruptcy entry.
/// Two or three are picked at random for the sequestration announcement. 
GLOBAL_LIST_INIT(atc_seizure_inventory, list(
	"the Lord's gilded bathing-tub",
	"a brace of falcons from the royal mews",
	"an illuminated psyalter bound in shagreen",
	"the great Otavan tapestry depicting the Hunt of the Boar",
	"two gilded saltcellars in the Etruscan fashion",
	"three sealed coffers of the Crown's pearls",
	"the household reliquary (less the relic)",
	"a Naledian astrolabe with three missing pins",
	"the Steward's reserve of saffron and cinnamon",
	"an ivory chess-set, six pieces short",
	"a brocaded canopy bed, taken down with great difficulty",
	"the chapel's spare gilt candelabrum",
	"the last Marshal's silver-mounted hunting-horn",
	"a portrait of a long-forgotten ancestor, slashed by a disgruntled debtor",
	"the Court Cupbearer's pewter inventory and the keys to it",
	"a Lirvanic jewel-encrusted bathtub of indecent proportion",
	"twelve casks of Bleakcoast firewine, marked for the Midwinter feast",
	"a Kazengun lacquered wardrobe of indeterminate vintage",
	"an Etruscan illuminated bestiary, water-damaged",
	"a clutch of Heartfelt clockwork toys, ticking faintly",
	"the menagerie's pet civet, of doubtful temperament",
	"the great clock of the Crown, dismantled in three carts",
	"twelve hundred yards of Naledian silk, the Crown's spare livery",
	"the Crown's reserve of Saltwick anchovies, packed in oil",
	"the Crown's emergency Kingsfield cheese reserve",
	"two white stag heads, taxidermied from the last royal hunt",
	"a crate of unknown white liquid of uncertain provenance, labeled 'CROWN ONLY - Not for Consumption'",
	"a sealed crate marked PROPERTY OF THE LATE STEWARD",
))

/// Returns a semicolon-separated string of 2-3 randomly chosen seizures for the announcement.
/// Semicolons (rather than commas) keep the items distinguishable when each contains internal
/// commas of its own ("...water-damaged", "...packed in oil"). The final item is preceded by
/// "and" in the period-formal manner.
/proc/atc_seizure_blurb()
	var/list/picks = list()
	var/count = rand(2, 3)
	var/list/pool = GLOB.atc_seizure_inventory.Copy()
	for(var/i in 1 to count)
		if(!length(pool))
			break
		var/choice = pick(pool)
		picks += choice
		pool -= choice
	if(length(picks) == 1)
		return picks[1]
	if(length(picks) == 2)
		return "[picks[1]]; and [picks[2]]"
	var/last = picks[length(picks)]
	picks.Cut(length(picks), length(picks) + 1)
	return "[jointext(picks, "; ")]; and [last]"

// ============================================================================
// ATC Emergency Loan - early-round "just one more day" tool. Adds debt that future inflow
// repays, plus consumes the arrears safety net (next failed payroll skips to sequestration).
// Disabled from ATC_LOAN_CLOSED_DAY onward so it can't be used to free-ride a round-end wipe.
// ============================================================================
/datum/controller/subsystem/treasury/proc/atc_loan_available()
	if(treasury_state == TREASURY_BANKRUPTCY)
		return FALSE
	if(GLOB.dayspassed >= ATC_LOAN_CLOSED_DAY)
		return FALSE
	return TRUE

/datum/controller/subsystem/treasury/proc/atc_loan_blocker_reason()
	if(treasury_state == TREASURY_BANKRUPTCY)
		return "The Company administers commerce. No further loans until sequestration lifts."
	if(GLOB.dayspassed >= ATC_LOAN_CLOSED_DAY)
		return "The Guilds clerk is out of office. The loan window has closed for the week."
	if(atc_loan_arrears_consumed)
		return "A prior advance stands unpaid. The Company refuses a second loan until the first is settled."
	return null

/datum/controller/subsystem/treasury/proc/take_atc_loan(amount, mob/applicant)
	var/blocker = atc_loan_blocker_reason()
	if(blocker)
		if(applicant)
			to_chat(applicant, span_warning("Loan refused: [blocker]."))
		return FALSE
	amount = clamp(round(amount), ATC_LOAN_MIN_AMOUNT, ATC_LOAN_MAX_AMOUNT)
	var/debt_owed = round(amount * (1 + ATC_LOAN_INTEREST_RATE))
	treasury_debt += debt_owed
	GLOB.azure_round_stats[STATS_TREASURY_DEBT_OUTSTANDING] = treasury_debt
	atc_loans_drawn_this_round += 1
	atc_loan_arrears_consumed = TRUE
	// Direct credit so the principal isn't immediately skimmed against the debt we just registered.
	discretionary_fund.balance += amount
	log_fund_entry(new /datum/treasury_entry("mint", null, discretionary_fund, amount, "ATC emergency loan (principal)"))
	priority_announce(
		"The Crown takes an advance of [amount]m from the Azurian Trading Company at the customary one-quarter interest, registering a debt of [debt_owed]m. The arrears grace stands forfeit; should the Crown miss its next payroll, the realm enters sequestration without warning.",
		"THE CROWN BORROWS",
		'sound/misc/royal_decree.ogg',
		"Captain",
	)
	log_game("ATC LOAN: [applicant ? key_name(applicant) : "system"] drew [amount]m principal from the Azurian Trading Company; debt of [debt_owed]m registered")
	return TRUE
