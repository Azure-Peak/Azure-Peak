/datum/preferences/proc/ui_act_popup_statbuy(action, list/params, datum/tgui/ui, datum/ui_state/state)
	var/mob/user = ui.user

	switch(action)
		if("statbuy_adjust")
			var/stat = params["stat"]
			if(!(stat in GLOB.statbuy_stats))
				return CHARACTER_ACT_DATA_UPDATE

			var/amount = params["amount"]
			if(istext(amount))
				amount = text2num(amount)
			if(!isnum(amount))
				return CHARACTER_ACT_DATA_UPDATE

			var/old_value = statbuy[stat]
			var/new_value = clamp(old_value + round(amount), STATBUY_STAT_MIN, STATBUY_STAT_MAX)
			if(new_value == old_value)
				return CHARACTER_ACT_DATA_UPDATE
			if(get_statbuy_points_spent(statbuy) - old_value + new_value > STATBUY_POINTS)
				return CHARACTER_ACT_DATA_UPDATE

			var/old_statbuy = generate_statbuy_string(statbuy)
			statbuy[stat] = new_value
			verbose_pref_log_change(user, "notice", "Statbuy", old_statbuy, generate_statbuy_string(statbuy))
			return CHARACTER_ACT_DATA_UPDATE

		if("statbuy_reset")
			if(is_statbuy_unassigned(statbuy))
				return CHARACTER_ACT_DATA_UPDATE

			var/old_statbuy = generate_statbuy_string(statbuy)
			statbuy = get_default_statbuy()
			verbose_pref_log_change(user, "notice", "Statbuy", old_statbuy, generate_statbuy_string(statbuy))
			return CHARACTER_ACT_DATA_UPDATE
