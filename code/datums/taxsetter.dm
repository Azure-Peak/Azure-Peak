/datum/taxsetter
	var/good_announcement_text = "The Generous Lord Decrees"
	var/bad_announcement_text = "The Tyrannical Lord Dictates"

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
	var/list/projection = SStreasury.get_poll_tax_projection()
	return list(
		"levyCooldown" = (GLOB.dayspassed <= SStreasury.levy_rates_changed_day),
		"pollCooldown" = (GLOB.dayspassed <= SStreasury.poll_rates_changed_day),
		"pollProjection" = projection,
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
	// Poll tax - flat mammon per head per day. Fixed order matches the civic-priority
	// stack used by get_poll_tax_category().
	var/list/poll_order = list(
		POLL_TAX_CAT_NOBLE,
		POLL_TAX_CAT_CLERGY,
		POLL_TAX_CAT_INQUISITION,
		POLL_TAX_CAT_COURTIER,
		POLL_TAX_CAT_GARRISON,
		POLL_TAX_CAT_GUILDS,
		POLL_TAX_CAT_MERCHANT,
		POLL_TAX_CAT_BURGHER,
		POLL_TAX_CAT_ADVENTURER,
		POLL_TAX_CAT_MERCENARY,
		POLL_TAX_CAT_PEASANT,
	)
	var/list/poll_tax_rates_out = list()
	for(var/category in poll_order)
		poll_tax_rates_out += list(list(
			"category" = category,
			"label" = SStreasury.get_poll_tax_category_pretty_name(category),
			"rate" = SStreasury.poll_tax_rates[category] || 0,
		))
	return list(
		"categoryRates" = category_rates,
		"pollTaxRates" = poll_tax_rates_out,
		"pollTaxMax" = POLL_TAX_MAX_RATE,
		"pollTaxMin" = -POLL_TAX_MAX_SUBSIDY,
	)

/datum/taxsetter/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE
	switch(action)
		if("set_rates")
			SStreasury.apply_rate_adjustments(params["categoryRates"], good_announcement_text, bad_announcement_text)
			return TRUE
		if("set_poll_rates")
			SStreasury.apply_poll_rate_adjustments(params["pollTaxRates"], good_announcement_text, bad_announcement_text)
			return TRUE

/datum/taxsetter/ui_state(mob/user)
	return GLOB.conscious_state
