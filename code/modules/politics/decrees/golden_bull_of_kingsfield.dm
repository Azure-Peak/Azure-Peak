/datum/decree/golden_bull
	id = DECREE_GOLDEN_BULL
	name = "The Golden Bull of Kingsfield"
	category = DECREE_CATEGORY_ANCIENT
	mechanical_text = "Burghers and residents are capped at 25% balance-rate on taxes/fines, with daily fine ceiling 50m and a poll-tax cap."
	flavor_text = {"This Golden Bull of Kingsfield, sealed under Astrata's Sun and with Ravox as witness, witnesseth the ancient compact between the Crown of Azuria and the makers of her wealth.

It is attested, by name of the Grand Duke of Azuria, and by the Councils of the Notables and Burghers of Azure Peak duly assembled to set this seal, that the said Councils do hereby assent, in this yil and in perpetuity, that the Crown shall levy upon the Burghers no greater portion than one quarter part of their meister account, and shall exact in fine no more than fifty mammon by the day, nor poll-tax beyond twenty mammon by the day; such being the limits deemed meet in time of peace, of war, and of necessite alike. Beyond these bounds no Burgher shall be taxed, nor deprived of their wealth, save by the law of the land.

In return, the Burghers of Azuria shall undertake to furnish, for the common defense of the Realm against pirates, brigands, and such other malefactors as do threaten the peace, a yearly Budget - the sum collected from amongst their members according to their wealth, and apportioned by their own assembly.

And should the Crown exceed these ratified bounds, or otherwise violate this Charter, the Burghers are absolved of their obligation, that the Realm may know the cost of breaking faith with its makers of wealth.

Yeven under the seal of the Crown."}
	revoke_text = "The %RULER% has suspended the Golden Bull of Kingsfield. The burghers stand exposed to the Crown's full levy, and the outraged merchants shall contribute no more to the common defense of the Realm."
	restore_text = "The %RULER% has restored the Golden Bull of Kingsfield. The compact stands renewed, and the burghers resume their tribute to the common defense."

/datum/decree/golden_bull/roll_initial_year()
	return CALENDAR_EPOCH_YEAR - rand(40, 100)

/datum/decree/golden_bull/apply_rate_cap(mob/living/payer, tax_category, current_cap)
	if(!is_protected_by_bull(payer))
		return current_cap
	return min(current_cap, GOLDEN_BULL_BURGHER_CAP)

/// Per-stroke mammon ceiling for Bull-protected subjects. Combined with the realm's
/// one-fine-per-day rule this becomes an effective daily cap.
/datum/decree/golden_bull/apply_daily_fine_cap(mob/living/payer, current_remaining)
	if(!is_protected_by_bull(payer))
		return current_remaining
	return min(current_remaining, GOLDEN_BULL_DAILY_FINE_CAP)

/// Cap the Burgher poll-tax daily charge at GOLDEN_BULL_POLL_CAP.
/datum/decree/golden_bull/apply_poll_tax_cap(mob/living/payer, poll_category, current_rate)
	if(poll_category != POLL_TAX_CAT_BURGHER)
		return current_rate
	return min(current_rate, GOLDEN_BULL_POLL_CAP)

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

