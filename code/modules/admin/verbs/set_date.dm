/client/proc/cmd_admin_set_ic_date()
	set category = "-Special Verbs-"
	set name = "Set IC Date"

	if(!check_rights(R_ADMIN))
		return

	var/choice = alert(src, "What would you like to do?", "IC Date Override", "Set Custom Date", "Clear Override")

	if(!choice || choice == "Clear Override")
		if(GLOB.date_override_enabled)
			GLOB.date_override_enabled = FALSE
			GLOB.date_override_offset = 0
			log_admin("[key_name(usr)] cleared the IC date override")
			message_admins(span_adminnotice("[key_name_admin(usr)] cleared the IC date override. Date is now: [get_current_ic_date_as_string()]"))
			SSblackbox.record_feedback("tally", "admin_verb", 1, "Set IC Date - Clear")
		return

	if(choice == "Set Custom Date")
		var/month_names = list(
			"1 - Psyrise (March)",
			"2 - Eora (April)",
			"3 - Dendor (May)",
			"4 - Astrata (June)",
			"5 - Xylix (July)",
			"6 - Malum (August)",
			"7 - Syonfall (September)",
			"8 - Pestra (October)",
			"9 - Necra (November)",
			"10 - Noc (December)",
			"11 - Abyssor (January)",
			"12 - Ravox (February)"
		)

		var/month_choice = input(src, "Select the month:", "Set IC Date - Month") as null|anything in month_names
		if(!month_choice)
			return

		var/target_month = text2num(copytext(month_choice, 1, 3))

		var/target_day = input(src, "Enter the day of the month (1-28):", "Set IC Date - Day", 1) as num|null
		if(isnull(target_day))
			return

		target_day = clamp(round(target_day), 1, 28)

		var/round_id = text2num(GLOB.round_id) || 0
		var/current_days_since_epoch = (round_id) * CALENDAR_DAYS_IN_WEEK + (GLOB.dayspassed - 1)
		var/current_day_of_year = MODULUS(current_days_since_epoch, CALENDAR_DAYS_IN_YEAR) + 1

		var/target_day_of_year = (target_month - 1) * CALENDAR_DAYS_IN_MONTH + target_day
		var/offset = target_day_of_year - current_day_of_year

		GLOB.date_override_enabled = TRUE
		GLOB.date_override_day = target_day
		GLOB.date_override_month = target_month
		GLOB.date_override_offset = offset

		log_admin("[key_name(usr)] set IC date override to [target_day]/[target_month] (offset: [offset] days)")
		message_admins(span_adminnotice("[key_name_admin(usr)] set IC date override. New date: [get_current_ic_date_as_string()], time: [get_current_ic_time_as_string()]"))
		to_chat(src, span_notice("IC Date set to: [get_current_ic_date_as_string()]"))
		to_chat(src, span_notice("This date will advance naturally as days pass."))
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Set IC Date")
