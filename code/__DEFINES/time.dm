///number of deciseconds in a day
#define MIDNIGHT_ROLLOVER 864000

///displays the current time into the round, with a lot of extra code just there for ensuring it looks okay after an entire day passes
#define ROUND_TIME(...) ( "[world.time - SSticker.round_start_time > MIDNIGHT_ROLLOVER ? "[round((world.time - SSticker.round_start_time)/MIDNIGHT_ROLLOVER)]:[worldtime2text()]" : worldtime2text()]" )

///Returns the time that has passed since the game started
#define STATION_TIME_PASSED(...) (world.time - SSticker.round_start_time)

#define JANUARY		1
#define FEBRUARY	2
#define MARCH		3
#define APRIL		4
#define MAY			5
#define JUNE		6
#define JULY		7
#define AUGUST		8
#define SEPTEMBER	9
#define OCTOBER		10
#define NOVEMBER	11
#define DECEMBER	12

//Select holiday names -- If you test for a holiday in the code, make the holiday's name a define and test for that instead
#define NEW_YEAR				"New Year"
#define VALENTINES				"Valentine's Day"
#define APRIL_FOOLS				"April Fool's Day"
#define EASTER					"Easter"
#define HALLOWEEN				"Halloween"
#define CHRISTMAS				"Christmas"
#define FESTIVE_SEASON			"Festive Season"

/*

Days of the week to make it easier to reference them.

When using time2text(), please use "DDD" to find the weekday. Refrain from using "Day"

*/

#define MONDAY		"Mon"
#define TUESDAY	"Tue"
#define WEDNESDAY	"Wed"
#define THURSDAY	"Thu"
#define FRIDAY		"Fri"
#define SATURDAY	"Sat"
#define SUNDAY		"Sun"

#define DECISECONDS *1

#define SECONDS *10

#define MINUTES SECONDS*60

#define HOURS MINUTES*60

#define TICKS *world.tick_lag

#define DS2TICKS(DS) ((DS)/world.tick_lag)

#define TICKS2DS(T) ((T) TICKS)
