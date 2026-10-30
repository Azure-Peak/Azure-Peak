/datum/taxsetter
	var/good_announcement_text = "The Generous Grand Duke Decrees"
	var/bad_announcement_text = "The Tyrannical Grand Duke Dictates"

/datum/taxsetter/New(good_announcement_text = null, bad_announcement_text = null)
	. = ..()
	if(good_announcement_text)
		src.good_announcement_text = good_announcement_text
	if(bad_announcement_text)
		src.bad_announcement_text = bad_announcement_text

/datum/taxsetter/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TaxSetter", "Set Crown Levies")
		ui.open()

/datum/taxsetter/ui_data(mob/user)
	return list(
		"levyCooldown" = (GLOB.dayspassed <= SStreasury.levy_rates_changed_day),
		"pollLevy" = SStreasury.get_poll_levy_ui_data(user),
	)

/datum/taxsetter/ui_static_data(mob/user)
	var/list/category_rates = list()
	for(var/category in SStreasury.tax_rates)
		if(category == TAX_CATEGORY_FINE)
			continue
		category_rates += list(list(
			"category" = category,
			"rate" = round(SStreasury.tax_rates[category] * 100),
		))
	return list(
		"categoryRates" = category_rates,
		"concordatFloor" = round(CONCORDAT_TITHE_RATE * 100),
		"pollLevyMax" = CHARGE_CAP_FLAT,
		"pollLevyReasonMin" = POLL_LEVY_REASON_MIN,
		"pollLevyReasonMax" = POLL_LEVY_REASON_MAX,
	)

/datum/taxsetter/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE
	switch(action)
		if("set_rates")
			SStreasury.apply_rate_adjustments(params["categoryRates"], good_announcement_text, bad_announcement_text)
			return TRUE
		if("enact_poll_levy")
			SStreasury.enact_poll_levy(usr, params["amounts"], params["reason"])
			return TRUE

/datum/taxsetter/ui_state(mob/user)
	return GLOB.conscious_state
