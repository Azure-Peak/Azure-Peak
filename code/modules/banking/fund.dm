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

/datum/fund/church
	ledger_book = LEDGER_BOOK_CHURCH

/datum/fund/merchant
	ledger_book = LEDGER_BOOK_MERCHANT

/datum/fund/bathhouse
	ledger_book = LEDGER_BOOK_BATHHOUSE

/datum/fund/innkeeper
	ledger_book = LEDGER_BOOK_TAVERN
