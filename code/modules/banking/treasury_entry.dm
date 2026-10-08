/datum/treasury_entry
	var/world_time
	var/kind
	var/from_name
	var/to_name
	var/amount
	var/currency
	var/reason
	var/count = 1
	var/time_created = 0
	/// In-game day the entry was recorded on.
	var/day = 0
	/// Journal number. Only postings (entries with legs) are numbered; memo lines are not.
	var/entry_no = 0
	/// Balanced double-entry legs: list(list(account_id, debit, credit), ...). Null for memo lines.
	var/list/legs

/datum/treasury_entry/New(entry_kind, datum/fund/from_fund, datum/fund/to_fund, entry_amount, entry_reason, from_label)
	. = ..()
	world_time = world.time
	kind = entry_kind
	amount = entry_amount
	reason = entry_reason
	from_name = from_fund ? from_fund.name : (from_label || "void")
	to_name = to_fund ? to_fund.name : "void"
	var/datum/fund/source = from_fund || to_fund
	currency = source?.currency
	time_created = world.time
	day = GLOB.dayspassed
	count = 1

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

/// Identifies the shape of a posting (accounts, order and side of every leg) so that repeated
/// identical postings can be merged without changing what they mean.
/datum/treasury_entry/proc/leg_signature()
	if(!length(legs))
		return ""
	var/list/parts = list()
	for(var/list/leg as anything in legs)
		parts += "[leg[1]]:[leg[2] > 0 ? "D" : "C"]"
	return jointext(parts, "|")

/// Folds another posting of identical shape into this one.
/datum/treasury_entry/proc/absorb_legs(datum/treasury_entry/other)
	if(!length(legs) || !length(other.legs))
		return
	for(var/i in 1 to length(legs))
		var/list/mine = legs[i]
		var/list/theirs = other.legs[i]
		mine[2] += theirs[2]
		mine[3] += theirs[3]

/// True if any leg touches an account in the given book.
/datum/treasury_entry/proc/touches_book(book)
	for(var/list/leg as anything in legs)
		if(findtext(leg[1], "[book]_") == 1)
			return TRUE
	return FALSE
