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

/datum/taxsetter/ui_static_data(mob/user)
	var/list/category_rates = list()
	for(var/category in SStreasury.tax_rates)
		if(category == TAX_CATEGORY_FINE)
			continue
		category_rates += list(list(
			"category" = category,
			"rate" = round(SStreasury.tax_rates[category] * 100),
		))
	return list("categoryRates" = category_rates)

/datum/taxsetter/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE
	switch(action)
		if("set_rates")
			SStreasury.apply_rate_adjustments(params["categoryRates"], good_announcement_text, bad_announcement_text)
			return TRUE

/datum/taxsetter/ui_state(mob/user)
	return GLOB.conscious_state
