/*
	Helper for the CALENDAR System. This will be where I document the design decisions.
	Azure Peak's canonical calendar system, known as the Azurian Calendar ICly, is a solar calendar. It is based on the "Grenzelhoftian Calendar", a tennite calendar system. 
	But actually, because we're in a fictional video game, it is a perfect calendar with no leap years or irregularities.
	It consists of 12 months, each with exactly 28 days dividing into 4 weeks. And it starts from Monday and ends on Sunday with a 7 days week.
	Each week = 1 round IC (regardless of how much time actually passed in game)
	The first month of a year begins in Spring - Gregorian March, like most sane agricultural calendars that begins in February / March.
*/


/* Returns the IC date as a string in the format
 [Weekday], [Day] [Month] [Year], [HH:MM] ([Time Of Day]), ([Cycle Number])
*/
/proc/get_current_ic_date_as_string()
	var/month_number
	var/day_of_month
	var/current_cycle
	var/year_number = CALENDAR_EPOCH_YEAR

	var/round_id = text2num(GLOB.round_id) || 0
	current_cycle = FLOOR(round_id / (YEAR_PER_CYCLE * CALENDAR_WEEKS_IN_YEAR), 1) + 1

	var/days_since_epoch = (round_id) * CALENDAR_DAYS_IN_WEEK + (GLOB.dayspassed - 1)

	if(GLOB.date_override_enabled)
		days_since_epoch += GLOB.date_override_offset

	var/day_of_year = MODULUS(days_since_epoch, CALENDAR_DAYS_IN_YEAR) + 1
	month_number = FLOOR((day_of_year - 1) / CALENDAR_DAYS_IN_MONTH, 1) + 1
	day_of_month = MODULUS((day_of_year - 1), CALENDAR_DAYS_IN_MONTH) + 1

	var/month_name = get_month_number_to_text(month_number)
	var/season = get_season_from_month(month_number)
	var/season_phase = get_season_phase(month_number)

	return "[day_of_month] [month_name] [year_number] (Month [month_number] [season_phase] [season]), Cycle [current_cycle]"

// Returns the current IC time as a string in the format [DAYS] ᛉ HH:MM ([Time Of Day])
/proc/get_current_ic_time_as_string()
	// Credit to Zydras for Syon's Dae for Saturday
	// These are the day names that can be referred to sensically ICly
	// By using secular names rather than IRL deity like Thule, Saturn, Tiw (Tyr), it avoids us having to explain a non-existent
	// Norse deity while remaining phonetically close to the original English name
	var/weekday = get_current_day_of_week_name()
	return  "[weekday] ᛉ [capitalize(GLOB.tod)] ᛉ [station_time_timestamp("hh:mm")]"

// Given a number between 1 to 12, returns the month name as text
/proc/get_month_number_to_text(month_number)
	switch(month_number)
		if(1)
			return "Psyrise" // March - The first month of a year is dedicated to the original god that created the world
		if(2)
			return "Eora" // April
		if(3)
			return "Dendor" // May
		if(4)
		// June, the hottest month is the month of the god of the SUN, because this is when they come into prominence
		// Historically, the winter solstice was celebrated as the rebirth of the sun / sun god, so it makes sense for the hottest month to be dedicated to the night god
			return "Astrata" // June  
		if(5)
			return "Xylix" // July
		if(6)
			return "Malum" // August
		if(7)
			// This neatly split the year into two half of rise and fall of Psydon.
			// It also happens to be the start of "Fall" / Autumn.
			// And it matches the "Psydonia is a minecraft world" joke quite well with Psydon going back to school
			return "Syonfall"
		if(8)
			// Middle / End of harvesting seasons for some crops. It make sense that the goddess of rot / decay follows
			// And after Syonfall comes the gradual move to winter
			return "Pestra" // October
		if(9)
			// A month dedicated to the goddess of death, before the sun's rebirth and after the goddess of rot
			return "Necra" // November
		if(10)
			// And on winter solstice and the longest night of the year, we have the month dedicated to the god of night 
			return "Noc" // December
		if(11)
			return "Abyssor" // January
		if(12)
			return "Ravox" // February
		else
			return "Unknown Month ([month_number])"

/* Returns the season based on month number (1-12)
 Months 1 - 3: Spring, 4 - 6: Summer, 7 - 9: Autumn, 10 - 12: Winter
 */
/proc/get_season_from_month(month_number)
	switch(CEILING(month_number, 3) / 3)
		if(1)
			return "Spring"
		if(2)
			return "Summer"
		if(3)
			return "Autumn"
		if(4)
			return "Winter"
	return "Unknown"

/* Returns Early/Mid/Late based on position within the season
 1st month of season: Early, 2nd: Mid, 3rd: Late
*/
/proc/get_season_phase(month_number)
	switch(MODULUS(month_number - 1, 3) + 1)
		if(1)
			return "Early"
		if(2)
			return "Mid"
		if(3)
			return "Late"
	return ""

/proc/get_current_day_of_week()
	return GLOB.dayspassed

/proc/get_current_day_of_week_name()
	var/round_id = text2num(GLOB.round_id) || 0
	var/days_since_epoch = (round_id) * CALENDAR_DAYS_IN_WEEK + (GLOB.dayspassed - 1)

	if(GLOB.date_override_enabled)
		days_since_epoch += GLOB.date_override_offset

	var/day_of_year = MODULUS(days_since_epoch, CALENDAR_DAYS_IN_YEAR) + 1
	var/day_of_month = MODULUS((day_of_year - 1), CALENDAR_DAYS_IN_MONTH) + 1
	var/day_of_week = MODULUS((day_of_month - 1), CALENDAR_DAYS_IN_WEEK) + 1

	switch(day_of_week)
		if(1)
			return "Moon's Dae"
		if(2)
			return "Truce's Dae"
		if(3)
			return "Wedding's Dae"
		if(4)
			return "Thunder's Dae"
		if(5)
			return "Feast's Dae"
		if(6)
			return "Psydon's Dae"
		if(7)
			return "Sun's Dae"
	return "Unknown Dae"
