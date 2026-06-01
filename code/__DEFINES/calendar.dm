#define CALENDAR_EPOCH_YEAR 1513
// Per player feedback, I am fixing the year to 1513 to avoid people dealing with implications of aging etc. Cycle instead track how many years passed OOC.
#define YEAR_PER_CYCLE 1 // How many years until the calendar repeats itself from epoch year
#define CALENDAR_MONTHS_PER_YEAR 12
#define CALENDAR_DAYS_IN_MONTH 28 // 28 days ensures each year has exactly 48 weeks, so every year/cycle starts on Monday
#define CALENDAR_DAYS_IN_YEAR (CALENDAR_MONTHS_PER_YEAR * CALENDAR_DAYS_IN_MONTH) // 336
#define CALENDAR_DAYS_IN_WEEK 7
#define CALENDAR_WEEKS_IN_YEAR (CALENDAR_DAYS_IN_YEAR / CALENDAR_DAYS_IN_WEEK) // 48 weeks exactly

#define CALENDAR_SYSTEM_AZURIAN "azurian"

#define CALENDAR_CATEGORY_HOLY_DAY "holy_day"
#define CALENDAR_CATEGORY_FESTIVAL "festival"
#define CALENDAR_CATEGORY_VIGIL "vigil"
#define CALENDAR_CATEGORY_SEASONAL "seasonal"
#define CALENDAR_CATEGORY_CIVIC "civic"

#define CALENDAR_EVENTS_JSON_PATH "strings/calendar_events.json"
