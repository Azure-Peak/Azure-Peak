/datum/config_entry/number_list/fog_event_days
	 // Default: Tues (2) and Sat (6)
	config_entry_value = list(2, 6)

/datum/config_entry/number/fog_event_hour
	// 6PM by default
	config_entry_value = 18
	min_val = 0
	max_val = 23
	resident_file = "events.txt"
