#define GOLDEN_BULL_BURGHER_CAP 0.25
#define GOLDEN_BULL_DAILY_FINE_CAP 50

/datum/decree/golden_bull
	id = DECREE_GOLDEN_BULL
	name = "The Golden Bull of Kingsfield"
	/// Tracks fines taken per player per day. Key = ckey, value = list("day", "total").
	var/list/fine_daily_ledger = list()
	flavor_text = {"Under Astrata's Sun, with Ravox as witness, be it known that the Crown shall impose no tax or levy upon the Burghers of Azuria save by consent of a Council of Notables and Burghers assembled; nor shall any Burgher be deprived of his wealth but by the law of the land.

In return, the Burghers of Azuria undertake to furnish, for the common defense of the Realm against pirates, brigands, and such other malefactors as do threaten the peace, a yearly Budget, the sum collected from amongst their members according to wealth and apportioned by their own assembly.

Should the Crown violate this Charter, the Burghers are absolved of their obligation, that the Realm may know the cost of breaking faith with its makers of wealth."}
	revoke_text = "The %RULER% has suspended the Golden Bull of Kingsfield. The burghers stand exposed to the Crown's full levy, and the outraged merchants shall contribute no more to the common defense of the realm."
	restore_text = "The %RULER% has restored the Golden Bull of Kingsfield. The compact stands renewed, and the burghers resume their tribute to the common defense."

/datum/decree/golden_bull/roll_initial_year()
	return CALENDAR_EPOCH_YEAR - rand(40, 100)

/datum/decree/golden_bull/apply_rate_cap(mob/living/payer, tax_category, current_cap)
	if(!is_protected_by_bull(payer))
		return current_cap
	return min(current_cap, GOLDEN_BULL_BURGHER_CAP)

/// Returns TRUE if the payer is currently shielded by the Golden Bull.
/datum/decree/golden_bull/proc/is_protected_by_bull(mob/living/payer)
	if(!active)
		return FALSE
	if(HAS_TRAIT(payer, TRAIT_OUTLAW))
		return FALSE
	if(HAS_TRAIT(payer, TRAIT_RESIDENT))
		return TRUE
	if(payer.job in GLOB.wanderer_positions)
		return FALSE
	if(payer.job == "Mercenary")
		return FALSE
	return TRUE

/datum/decree/golden_bull/apply_daily_fine_cap(mob/living/payer, current_remaining)
	if(!is_protected_by_bull(payer))
		return current_remaining
	if(!payer.key)
		return current_remaining
	var/key = payer.key
	var/list/entry = fine_daily_ledger[key]
	if(!entry || entry["day"] != GLOB.dayspassed)
		fine_daily_ledger[key] = list("day" = GLOB.dayspassed, "total" = 0)
		entry = fine_daily_ledger[key]
	return min(current_remaining, max(0, GOLDEN_BULL_DAILY_FINE_CAP - entry["total"]))

/datum/decree/golden_bull/on_fine_applied(mob/living/payer, amount)
	if(!is_protected_by_bull(payer))
		return
	if(!payer.key)
		return
	var/key = payer.key
	if(!fine_daily_ledger[key] || fine_daily_ledger[key]["day"] != GLOB.dayspassed)
		return
	fine_daily_ledger[key]["total"] += amount

#undef GOLDEN_BULL_BURGHER_CAP
#undef GOLDEN_BULL_DAILY_FINE_CAP
