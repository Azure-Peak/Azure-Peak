/datum/fund
	var/name
	var/balance = 0
	var/currency = CURRENCY_MAMMON
	var/datum/weakref/owner_ref
	var/created_at
	var/tax_debt = 0
	var/list/pending_micro = list()
	var/wages_suspended = FALSE
	/// Which double-entry book this fund's cash belongs to. Personal accounts and anything
	/// unclassified fall under the Citizens control account.
	var/ledger_book = LEDGER_BOOK_CITIZENS
	/// Per-day mammon cap for each allowance group drawing from this fund, keyed by ALLOWANCE_GROUP_*.
	var/list/allowance_limits
	/// Allowance groups whose withdrawals the fund's authority has suspended, keyed by ALLOWANCE_GROUP_*.
	var/list/allowance_suspended
	/// Amount each capped drawer has taken today, keyed by real_name.
	var/list/allowance_withdrawals
	var/allowance_withdrawals_day = -1

/datum/fund/New(fund_name, mob/living/fund_owner, starting_balance = 0, fund_currency = CURRENCY_MAMMON)
	. = ..()
	name = fund_name
	if(fund_owner)
		owner_ref = WEAKREF(fund_owner)
	balance = starting_balance
	currency = fund_currency
	created_at = world.time

/datum/fund/proc/get_owner()
	return owner_ref?.resolve()

/datum/fund/proc/get_cash_account()
	return ledger_acct(ledger_book, LEDGER_KEY_CASH)

/datum/fund/proc/get_allowance_withdrawn(drawer_name)
	if(GLOB.dayspassed != allowance_withdrawals_day)
		allowance_withdrawals_day = GLOB.dayspassed
		allowance_withdrawals = null
	return LAZYACCESS(allowance_withdrawals, drawer_name) || 0

/datum/fund/proc/record_allowance_withdrawal(drawer_name, amount)
	if(amount <= 0)
		return
	var/drawn = get_allowance_withdrawn(drawer_name)
	LAZYSET(allowance_withdrawals, drawer_name, drawn + amount)

/datum/fund/church
	ledger_book = LEDGER_BOOK_CHURCH
	allowance_limits = list(
		ALLOWANCE_GROUP_WORKER = CHURCH_WORKER_DAILY_WITHDRAW_DEFAULT,
	)

/datum/fund/merchant
	ledger_book = LEDGER_BOOK_MERCHANT

/datum/fund/bathhouse
	ledger_book = LEDGER_BOOK_BATHHOUSE
	allowance_limits = list(
		ALLOWANCE_GROUP_WORKER = BATHHOUSE_WORKER_DAILY_WITHDRAW_DEFAULT,
		ALLOWANCE_GROUP_AGENT = BATHHOUSE_AGENT_DAILY_WITHDRAW_DEFAULT,
	)

/datum/fund/innkeeper
	ledger_book = LEDGER_BOOK_TAVERN
