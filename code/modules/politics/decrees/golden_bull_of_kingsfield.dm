#define GOLDEN_BULL_BURGHER_CAP 0.25

/datum/decree/golden_bull
	id = DECREE_GOLDEN_BULL
	name = "The Golden Bull of Kingsfield"
	flavor_text = {"Under Astrata's Sun, with Ravox as witness, be it known that the Crown shall impose no tax or levy upon the Burghers of Azuria save by consent of a Council of Notables and Burghers assembled; nor shall any Burgher be deprived of his wealth but by the law of the land.

In return, the Burghers of Azuria undertake to furnish, for the common defense of the Realm against pirates, brigands, and such other malefactors as do threaten the peace, a yearly Budget, the sum collected from amongst their members according to wealth and apportioned by their own assembly.

Should the Crown violate this Charter, the Burghers are absolved of their obligation, that the Realm may know the cost of breaking faith with its makers of wealth."}
	revoke_text = "The %RULER% has suspended the Golden Bull of Kingsfield. The burghers stand exposed to the Crown's full levy, and the outraged merchants shall contribute no more to the common defense of the realm."
	restore_text = "The %RULER% has restored the Golden Bull of Kingsfield. The compact stands renewed, and the burghers resume their tribute to the common defense."

/datum/decree/golden_bull/roll_initial_year()
	return CALENDAR_EPOCH_YEAR - rand(40, 100)

/datum/decree/golden_bull/apply_rate_cap(mob/living/payer, tax_category, current_cap)
	if(!active)
		return current_cap
	if(HAS_TRAIT(payer, TRAIT_RESIDENT))
		return min(current_cap, GOLDEN_BULL_BURGHER_CAP)
	if(payer.job in GLOB.wanderer_positions)
		return current_cap
	if(payer.job == "Mercenary")
		return current_cap
	return min(current_cap, GOLDEN_BULL_BURGHER_CAP)

#undef GOLDEN_BULL_BURGHER_CAP
