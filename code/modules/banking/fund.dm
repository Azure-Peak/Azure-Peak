/datum/fund
	var/name
	var/balance = 0
	var/currency = CURRENCY_MAMMON
	var/datum/weakref/owner_ref
	var/created_at
	var/tax_debt = 0

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
