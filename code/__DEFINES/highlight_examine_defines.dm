// Zizo items
#define HERESYDESC_ZIZO_WEAPON "A grim weapon of Zizo's champions"
#define HERESYDESC_ZIZO_ARMOR "An accursed armor piece of Zizo's champions"
#define HERESYDESC_ZIZO_RELIC "A relic of Zizo's grim design"
#define HERESYDESC_ZIZO_ICON "It bears the grim zcross of Zizo"
#define HERESYDESC_ZIZO_MISC "A known design of Zizo"
#define HERESYDESC_ZIZO_AVANTYNE "It is forged out of Zizo's foul Avantyne"

// Matthios items
#define HERESYDESC_MATTHIOS_WEAPON "A weapon of Matthios's greedy champions"
#define HERESYDESC_MATTHIOS_ARMOR "An avaricious armor piece of Matthios's champions"
#define HERESYDESC_MATTHIOS_RELIC "A relic of Matthios's covetous design"
#define HERESYDESC_MATTHIOS_ICON "It bears the covetous icon of Matthios"
#define HERESYDESC_MATTHIOS_MISC "A known design of Matthios"

// Graggar items
#define HERESYDESC_GRAGGAR_WEAPON "A weapon of Graggar's bloodthirsty champions"
#define HERESYDESC_GRAGGAR_ARMOR "A brutal armor piece of Graggar's champions"
#define HERESYDESC_GRAGGAR_RELIC "A relic of Graggar's cruel design"
#define HERESYDESC_GRAGGAR_ICON "It bears the icon of cruel Graggar"
#define HERESYDESC_GRAGGAR_MISC "A known design of Graggar"

// Baotha items
#define HERESYDESC_BAOTHA_WEAPON "A weapon of Baotha's depraved champions"
#define HERESYDESC_BAOTHA_ARMOR "A depraved armor piece of Baotha's champions"
#define HERESYDESC_BAOTHA_RELIC "A relic of Baotha's debauched design"
#define HERESYDESC_BAOTHA_ICON "It bears the icon of debauched Baotha"
#define HERESYDESC_BAOTHA_MISC "A known design of Baotha"

// Misc items
#define HERESYDESC_GRONN "A symbol of the North's archaic beliefs"


/**
* -========= HERESY ITEM SEVERITY LEVELS =========-
*
* The more "Severely" heretical an item is, the more
* alarmingly the item will be presented on examine.
*
* -===============================================-*/
/** For items that are both blatantly heretical AND actively dangerous.
* Items should be marked with this if the expected response to seeing someone
* carrying them is to quickly escalate to violence.
* 
* i.e. heretic armor, avantyne weapons
*/
#define EXAMINEHIGHLIGHT_HERESY_SEVERITY_ALARMING 1
// Heresy item severity levels. The more "Severely" heretical an item is, the more alarmingly the item will be presented on examine.
/** For items that are heretical and will get you in trouble if you're caught with them,
* but not enough for people to jump straight to violence on sight without probable cause.
* 
* i.e. Ascendant amulets
*/
#define EXAMINEHIGHLIGHT_HERESY_SEVERITY_SUSPICIOUS 2

// Heresy severity colors
#define COLOR_HERESY_SEVERITY_SUSPICIOUS "#c49337"
#define COLOR_HERESY_SEVERITY_ALARMING "#c43535"

// Heresy severity descriptions
#define DESCRIPTION_HERESY_SEVERITY_SUSPICIOUS "<font color=[COLOR_HERESY_SEVERITY_SUSPICIOUS]><b>This is a suspicious heretical item!</b></font><br>It is considered heretical by Tennite and Psydonite faith. Those who serve the Ten and the One are likely to view me with suspicion and distrust <b>at best</b> if I am caught with it."
#define DESCRIPTION_HERESY_SEVERITY_ALARMING "<font color=[COLOR_HERESY_SEVERITY_ALARMING]><b>This is a blatantly dangerous heretical item!</b></font><br>Carrying this out in the open is tantamount to declaring myself an enemy to Tennite and Psydonite faith. Those who serve the Ten and the One are likely to respond in kind."

// Heresy severity symbols
#define SYMBOL_HERESY_SEVERITY_SUSPICIOUS "?"
/// Zcross unicode in HTML form
#define SYMBOL_HERESY_SEVERITY_ALARMING "&#x16E3;"
