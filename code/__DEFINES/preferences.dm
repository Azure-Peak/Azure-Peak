#ifdef LOCALTEST
	#define MINIMUM_FLAVOR_TEXT 0
	#define MINIMUM_OOC_NOTES 0
#endif
#ifndef LOCALTEST
	#define MINIMUM_FLAVOR_TEXT		200
	#define MINIMUM_OOC_NOTES 		5 //Just put something in there
#endif

//Preference toggles
#define SOUND_ADMINHELP			(1<<0)
#define SOUND_MIDI				(1<<1)
#define SOUND_AMBIENCE			(1<<2)
#define SOUND_LOBBY				(1<<3)
#define MEMBER_PUBLIC			(1<<4)
#define INTENT_STYLE			(1<<5)
#define MIDROUND_ANTAG			(1<<6)
#define SOUND_INSTRUMENTS		(1<<7)
#define SOUND_SHIP_AMBIENCE		(1<<8)
#define SOUND_PRAYERS			(1<<9)
#define ANNOUNCE_LOGIN			(1<<10)
#define SOUND_ANNOUNCEMENTS		(1<<11)
#define DISABLE_DEATHRATTLE		(1<<12)
#define DISABLE_ARRIVALRATTLE	(1<<13)
#define COMBOHUD_LIGHTING		(1<<14)

#define DEADMIN_ALWAYS			(1<<15)
#define DEADMIN_ANTAGONIST		(1<<16)
#define DEADMIN_POSITION_HEAD	(1<<17)

#define TOGGLE_FULLSCREEN		(1<<20)
#define SCHIZO_VOICE			(1<<21)
#define ROLEPLAY_ADS			(1<<22)
#define CMODE_STRIPPING			(1<<23)

#define FLOATING_TEXT			(1<<0)
#define XP_TEXT					(1<<1)
#define HITZONE_TEXT			(1<<2)
#define TOGGLES_TEXT_DEFAULT (FLOATING_TEXT|XP_TEXT|HITZONE_TEXT)

#define TOGGLES_DEFAULT (SOUND_ADMINHELP|SOUND_MIDI|SOUND_AMBIENCE|SOUND_LOBBY|MEMBER_PUBLIC|INTENT_STYLE|MIDROUND_ANTAG|SOUND_INSTRUMENTS|SOUND_SHIP_AMBIENCE|SOUND_PRAYERS|SOUND_ANNOUNCEMENTS|TOGGLE_FULLSCREEN)

//Chat toggles
#define CHAT_OOC			(1<<0)
#define CHAT_DEAD			(1<<1)
#define CHAT_GHOSTEARS		(1<<2)
#define CHAT_GHOSTSIGHT		(1<<3)
#define CHAT_PRAYER			(1<<4)
#define CHAT_RADIO			(1<<5)
#define CHAT_PULLR			(1<<6)
#define CHAT_GHOSTWHISPER	(1<<7)
#define CHAT_GHOSTPDA		(1<<8)
#define CHAT_GHOSTRADIO 	(1<<9)
#define CHAT_BANKCARD		(1<<10)
#define CHAT_ADMINLOOC		(1<<11)
#define CHAT_ADMINSPAWN		(1<<12)
#define CHAT_DSAY			(1<<13)

#define TOGGLES_DEFAULT_CHAT (CHAT_OOC|CHAT_DSAY|CHAT_PRAYER|CHAT_RADIO|CHAT_PULLR|CHAT_GHOSTPDA|CHAT_BANKCARD)
#define TOGGLES_DEFAULT_CHAT_ADMIN (CHAT_ADMINSPAWN|CHAT_ADMINLOOC)

#define PARALLAX_INSANE -1 //for show offs
#define PARALLAX_HIGH    0 //default.
#define PARALLAX_MED     1
#define PARALLAX_LOW     2
#define PARALLAX_DISABLE 3 //this option must be the highest number

#define PARALLAX_DELAY_DEFAULT world.tick_lag
#define PARALLAX_DELAY_MED     1
#define PARALLAX_DELAY_LOW     2

#define SEC_DEPT_NONE "None"
#define SEC_DEPT_RANDOM "Random"
#define SEC_DEPT_ENGINEERING "Engineering"
#define SEC_DEPT_MEDICAL "Medical"
#define SEC_DEPT_SCIENCE "Science"
#define SEC_DEPT_SUPPLY "Supply"

// Playtime tracking system, see jobs_exp.dm
#define EXP_TYPE_LIVING			"Living"
#define EXP_TYPE_CREW			"Crew"
#define EXP_TYPE_COMMAND		"Command"
#define EXP_TYPE_ENGINEERING	"Engineering"
#define EXP_TYPE_MEDICAL		"Medical"
#define EXP_TYPE_SCIENCE		"Science"
#define EXP_TYPE_SUPPLY			"Supply"
#define EXP_TYPE_SECURITY		"Security"
#define EXP_TYPE_SILICON		"Silicon"
#define EXP_TYPE_SERVICE		"Service"
#define EXP_TYPE_ANTAG			"Antag"
#define EXP_TYPE_SPECIAL		"Special"
#define EXP_TYPE_GHOST			"Ghost"
#define EXP_TYPE_ADMIN			"Admin"

//Flags in the players table in the db
#define DB_FLAG_EXEMPT 1

#define DEFAULT_CYBORG_NAME "Default Cyborg Name"


//Job preferences levels
#define JP_LOW 1
#define JP_MEDIUM 2
#define JP_HIGH 3

//randomised elements
#define RANDOM_NAME "random_name"
#define RANDOM_NAME_ANTAG "random_name_antag"
#define RANDOM_BODY "random_body"
#define RANDOM_BODY_ANTAG "random_body_antag"
#define RANDOM_SPECIES "random_species"
#define RANDOM_GENDER "random_gender"
#define RANDOM_GENDER_ANTAG "random_gender_antag"
#define RANDOM_AGE "random_age"
#define RANDOM_AGE_ANTAG "random_age_antag"
#define RANDOM_UNDERWEAR "random_underwear"
#define RANDOM_UNDERWEAR_COLOR "random_underwear_color"
#define RANDOM_UNDERSHIRT "random_undershirt"
#define RANDOM_SOCKS "random_socks"
#define RANDOM_BACKPACK "random_backpack"
#define RANDOM_JUMPSUIT_STYLE "random_jumpsuit_style"
#define RANDOM_SKIN_TONE "random_skin_tone"
#define RANDOM_EYE_COLOR "random_eye_color"

//Age ranges
#define AGE_ADULT			"Adult"
#define AGE_MIDDLEAGED		"Middle-Aged"
#define AGE_OLD				"Old"

#define ALL_AGES_LIST list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)

//Voice ranges
#define MIN_VOICE_PITCH		0.8
#define MAX_VOICE_PITCH		1.35

// Pronouns (LETHALSTONE)
#define HE_HIM			"he/him"
#define SHE_HER			"she/her"
#define THEY_THEM		"they/them (Masc Clothes)"
#define THEY_THEM_F		"they/them (Femme Clothes)"
#define IT_ITS			"it/its"
#define HE_HIM_F		"he/him (Femme Clothes)"
#define SHE_HER_M		"she/her (Masc Clothes)"

GLOBAL_LIST_INIT(pronouns_list, list(HE_HIM, SHE_HER, THEY_THEM, THEY_THEM_F, IT_ITS, HE_HIM_F, SHE_HER_M))

// Voice types (LETHALSTONE)

#define VOICE_TYPE_MASC	"Masculine"
#define VOICE_TYPE_FEM	"Feminine"
#define VOICE_TYPE_ANDR	"Androgynous"

GLOBAL_LIST_INIT(voice_types_list, list(VOICE_TYPE_MASC, VOICE_TYPE_FEM, VOICE_TYPE_ANDR))
