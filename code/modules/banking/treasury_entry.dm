/datum/treasury_entry
	var/world_time
	var/kind
	var/from_name
	var/to_name
	var/amount
	var/currency
	var/reason

/datum/treasury_entry/New(entry_kind, datum/fund/from_fund, datum/fund/to_fund, entry_amount, entry_reason)
	. = ..()
	world_time = world.time
	kind = entry_kind
	amount = entry_amount
	reason = entry_reason
	from_name = from_fund ? from_fund.name : "void"
	to_name = to_fund ? to_fund.name : "void"
	var/datum/fund/source = from_fund || to_fund
	currency = source?.currency

/datum/treasury_entry/proc/format()
	var/suffix = reason ? " ([reason])" : ""
	switch(kind)
		if("mint")
			return "+[amount] to [to_name][suffix]"
		if("burn")
			return "-[amount] from [from_name][suffix]"
		if("transfer")
			return "[amount] from [from_name] to [to_name][suffix]"
	return "[kind] [amount][suffix]"
