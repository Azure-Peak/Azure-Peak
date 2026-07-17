// Zizo items
#define HERESYDESC_ZIZO_WEAPON "A grim weapon of Zizo's champions"
#define HERESYDESC_ZIZO_ARMOR "An accursed armor piece of Zizo's champions"
#define HERESYDESC_ZIZO_RELIC "A relic of Zizo's grim design"
#define HERESYDESC_ZIZO_ICON "It bears the grim zcross of Zizo"
#define HERESYDESC_ZIZO_MISC "A known design of Zizo"
#define HERESYDESC_ZIZO_AVANTYNE "It is forged out of Zizo's foul Avantyne"
#define HERESYDESC_ZIZO_ARTIFICE "Zizo's artificed design, recreated uncomfortably accurately"
#define HERESYDESC_ZIZO_ARTIFICE_RECLAIMED "The old artificed designs of Zizo... Reclaimed?"

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

// Abyssor dream items
#define HERESYDESC_DREAM_ITEM "A weapon from Abyssor's dream. It is dangerous, and shouldn't be seen outside of capable, sanctified hands"
// Dreamwalker items
#define HERESYDESC_DREAMWALKER_WEAPON "An enchanced weapon from Abyssor's dream, wielded by Abyssor's cursed - the enigmatic and violent Dreamwalkers"
#define HERESYDESC_DREAMWALKER_ARMOR "An armor piece from Abyssor's dream, worn by Abyssor's cursed - the enigmatic and violent Dreamwalkers"

// Misc items
#define HERESYDESC_GRONN "A symbol of the North's archaic beliefs"
#define HERESYDESC_WEEPING_CROSS "It is ensnared in a perpetual state of half-coagulation, the alloy cracked and bleeding"

// Vampire Lord Items - General theme is mysterious but a bad omen
#define HERESYDESC_VAMPIRE "An unnatural enchanted armor piece of solid gilbranze that crackles with strange energies"
#define HERESYDESC_VAMPIRE_CROWN "An unnatural enchanted crown that crackles with strange energies" 
#define HERESYDESC_VAMPIRE_SWORD "An unnatural sword of some unknown alloy that crackles with strange energies"

// Inquisitional gear
#define HERESYDESC_INQUIS_WHISPERER "A blatently unusual design of ring...? that seems to whisper" //Only shows while not equipped on ring slot
#define HERESYDESC_INQUIS_CHURNER "I CAN HEAR SCREAMS COMING FROM WITHIN, WHAT THE HELL IS THAT THING?!!" //Only shows while active

#define VIBEDESC_FRIEND "A loyal ally of Azure Peak."
#define VIBEDESC_FOE "A disloyal enemy of Azure Peak."
#define VIBEDESC_CROWN "A relic anointed by Astrata."
#define VIBEDESC_GOLGATHA "A relic of Psydon's creation."

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
#define EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING 1
/** For items that are heretical and will get you in trouble if you're caught with them,
* but not enough for people to jump straight to violence on sight without probable cause.
* 
* i.e. Ascendant amulets
*/
#define EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS 2
/** For items that are unusual displays of faith that are either not commonly known expressions
* of heretical beliefs, or are simply inoffensive enough that the common Tennite / Psydonite probably won't
* get in someone's hair about it, but will likely give the wielders funny looks and odd squints.
*
* i.e. Gronn/Fjall carving amulets
*/
#define EXAMINEHIGHLIGHT_HERESYSEVERITY_ODD 3

#define EXAMINEHIGHLIGHT_VIBE_FRIEND 4
#define EXAMINEHIGHLIGHT_VIBE_FOE 5
#define EXAMINEHIGHLIGHT_VIBE_CROWN 6
#define EXAMINEHIGHLIGHT_VIBE_GOLGATHA 7

/** For items that are unnautral or clearly cursed, I.E ancient ceremonial armor, the vlord sword
* not defined enough that the average Tennite / Psydonite would always attack on sight but definitely it will
* get you probably taken captive/questioned by the Inqusition or pulled over by the Clergy/Garrison if you were just openly showing it.
*
* i.e. The Ichor Fang, Weeping Psycross, Blacksite Items like Listeners in their Obvious Form
*/
#define EXAMINEHIGHLIGHT_HERESYSEVERITY_VERYODD 8

// Heresy severity colors
#define COLOR_HERESYSEVERITY_ALARMING "#c43535"
#define COLOR_HERESYSEVERITY_SUSPICIOUS "#c49337"
#define COLOR_HERESYSEVERITY_ODD "#c564c5"
#define COLOR_HERESYSEVERITY_VERYODD "#c564c5"

//Other Colors
#define COLOR_VIBE_FRIEND "#6476c5"
#define COLOR_VIBE_FOE "#c43535"
#define COLOR_VIBE_CROWN "#ffdc7c"
#define COLOR_VIBE_GOLGATHA "#94f8ff"

// Heresy severity descriptions
#define EXAMINEHIGHLIGHT_TOOLTIP_HERESYSEVERITY_ALARMING "<font color=[COLOR_HERESYSEVERITY_ALARMING]><b>This is a blatantly dangerous heretical item!</b></font><br>Carrying this out in the open is tantamount to declaring myself an enemy to Tennite and Psydonite faith. Those who serve the Ten and the One are likely to respond in kind."
#define EXAMINEHIGHLIGHT_TOOLTIP_HERESYSEVERITY_SUSPICIOUS "<font color=[COLOR_HERESYSEVERITY_SUSPICIOUS]><b>This is a suspicious heretical item!</b></font><br>It is considered heretical by Tennite and Psydonite faith. Those who serve the Ten and the One are likely to view me with suspicion and distrust <b>at best</b> if I am caught with it."
#define EXAMINEHIGHLIGHT_TOOLTIP_HERESYSEVERITY_ODD "<font color=[COLOR_HERESYSEVERITY_ODD]><b>An odd expression of faith...</b></font><br>It is not openly deemed heretical by Tennite and Psydonite faith. However, that does not stop it from being seen as unusual. I am likely to be given odd looks if I am seen with it and not much more, but more guarded (or paranoid) Tennites and Psydonites may not be so charitable."
#define EXAMINEHIGHLIGHT_TOOLTIP_HERESYSEVERITY_VERYODD "<font color=[COLOR_HERESYSEVERITY_ALARMING]><b>This is a blatantly weird item!</b></font><br>Carrying this out in the open is highly suspicious to Tennite and/or Psydonite faith. Those who serve the Ten and/or the One are likely to respond with suspicion and distrust <b>at best</b> if I am caught with it."

#define EXAMINEHIGHLIGHT_TOOLTIP_VIBE_FRIEND "<font color=[COLOR_VIBE_FRIEND]><b>A loyal bearing.</b></font><br>This carries the look of one who stands with the Crown and its laws. Many subjects may view its bearer as a friend, servant, or ally of the realm."
#define EXAMINEHIGHLIGHT_TOOLTIP_VIBE_FOE "<font color=[COLOR_VIBE_FOE]><b>A disloyal bearing.</b></font><br>This carries the look of one who stands apart from the Crown and its laws. Many subjects may view its bearer with suspicion, seeing a potential rebel, outlaw, or enemy of the realm."
#define EXAMINEHIGHLIGHT_TOOLTIP_VIBE_CROWN "<font color=[COLOR_VIBE_CROWN]><b>Heavy the Crown is, and ever shall it be.</b></font><br>Such symbols are not lightly bestowed, for they signify authority exercised beneath Astrata's eternal light. This is a recognized mark of divine sovereignty, symbolizing the sacred right to rule granted by the Sun-Tyrant to a chosen bloodline. Most subjects should regard its bearer with reverence, recognizing a station and authority very few can claim."
#define EXAMINEHIGHLIGHT_TOOLTIP_VIBE_GOLGATHA "<font color=[COLOR_VIBE_GOLGATHA]><b>`Oh, how graceful His power was! And His sacrifice, ever so noble!`</b></font><br>It is said to contain a volatile fragment of the <font color=[COLOR_VIBE_GOLGATHA]><b>Comet Syon</b></font>, a sacred artifact to those of Psydonite Faith, such a relic is only entrusted within the capable hands of the Otavian Orthodoxy, Those who serve the Orthodoxy or others of Psydonite Faith are <b>very likely respond with violence</b> if I am not supposed to have it."

// Heresy severity symbols
#define EXAMINEHIGHLIGHT_SYMBOL_HERESYSEVERITY_SUSPICIOUS "!"
#define EXAMINEHIGHLIGHT_SYMBOL_HERESYSEVERITY_VERYODD "!"
/// Zcross unicode in HTML form
#define EXAMINEHIGHLIGHT_SYMBOL_HERESYSEVERITY_ALARMING "&#x16E3;"
#define EXAMINEHIGHLIGHT_SYMBOL_HERESYSEVERITY_ODD "?"

#define SYMBOL_VIBE_FRIEND "&#x26E8;"
#define SYMBOL_VIBE_FOE "&#x2694;"
#define SYMBOL_VIBE_CROWN "&#x2654;"
#define SYMBOL_VIBE_GOLGATHA "&#5833;"
