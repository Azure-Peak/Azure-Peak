#define CALENDAR_EPOCH_YEAR 1513
#define YEAR_PER_CYCLE 1 // How many years until the calendar repeats itself from epoch year
#define CALENDAR_MONTHS_PER_YEAR 12
#define CALENDAR_DAYS_IN_MONTH 28 // 28 days ensures each year has exactly 48 weeks, so every year/cycle starts on Monday
#define CALENDAR_DAYS_IN_YEAR (CALENDAR_MONTHS_PER_YEAR * CALENDAR_DAYS_IN_MONTH) // 336
#define CALENDAR_DAYS_IN_WEEK 7
#define CALENDAR_WEEKS_IN_YEAR (CALENDAR_DAYS_IN_YEAR / CALENDAR_DAYS_IN_WEEK) // 48 weeks exactly
