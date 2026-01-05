GLOBAL_LIST_INIT(sex_actions, build_sex_actions())

GLOBAL_LIST_EMPTY(sex_sessions)
GLOBAL_LIST_EMPTY(sex_collectives)
GLOBAL_VAR_INIT(collective_counter, 1)
GLOBAL_LIST_EMPTY(locked_sex_objects)

#define SEX_ACTION(sex_action_type) GLOB.sex_actions[sex_action_type]

#define COMSIG_SEX_ADJUST_AROUSAL "sex_adjust_arousal"                  // (amount) - Adjust arousal level
#define COMSIG_SEX_SET_AROUSAL "sex_set_arousal"                        // (amount) - Set arousal to specific value
#define COMSIG_SEX_AROUSAL_CHANGED "sex_arosual_change"					// fires to the parent about a change
#define COMSIG_SEX_FREEZE_AROUSAL "sex_freeze_arousal"                  // (freeze_state) - Toggle arousal freeze
#define COMSIG_SEX_GET_AROUSAL "sex_get_arousal"                        // () - Get current arousal info
#define COMSIG_SEX_CLIMAX "sex_climax"                                  // (type, target) - Handle climax event
#define COMSIG_SEX_RECEIVE_ACTION "sex_receive_action"                  // (arousal_amt, pain_amt, giving, force, speed) - Receive action effects

// Knotting Component Signals
/// Attempts to knot a target. Args: (target, force_level)
#define COMSIG_SEX_TRY_KNOT "sex_try_knot"
/// Removes an existing knot. Args: (forceful_removal, notify, keep_top_status, keep_btm_status)
#define COMSIG_SEX_REMOVE_KNOT "sex_remove_knot"

// General Sex Signals
/// Checks if user can use their penis. Return: TRUE/FALSE
#define COMSIG_SEX_CAN_USE_PENIS "sex_can_use_penis"
/// Checks if user is considered limp. Return: TRUE/FALSE
#define COMSIG_SEX_CONSIDERED_LIMP "sex_considered_limp"

#define SEX_SPEED_LOW 1
#define SEX_SPEED_MID 2
#define SEX_SPEED_HIGH 3
#define SEX_SPEED_EXTREME 4

#define SEX_SPEEDS list(SEX_SPEED_LOW, SEX_SPEED_MID, SEX_SPEED_HIGH, SEX_SPEED_EXTREME)

#define SEX_SPEED_MIN 1
#define SEX_SPEED_MAX 4

#define SEX_FORCE_LOW 1
#define SEX_FORCE_MID 2
#define SEX_FORCE_HIGH 3
#define SEX_FORCE_EXTREME 4

#define SEX_FORCES list(SEX_FORCE_LOW, SEX_FORCE_MID, SEX_FORCE_HIGH, SEX_FORCE_EXTREME)

#define SEX_FORCE_MIN 1
#define SEX_FORCE_MAX 4

#define SEX_MANUAL_AROUSAL_DEFAULT 1
#define SEX_MANUAL_AROUSAL_UNAROUSED 2
#define SEX_MANUAL_AROUSAL_PARTIAL 3
#define SEX_MANUAL_AROUSAL_FULL 4

#define SEX_MANUAL_AROUSALS LIST(SEX_MANUAL_AROUSAL_DEFAULT, SEX_MANUAL_AROUSAL_UNAROUSED, SEX_MANUAL_AROUSAL_PARTIAL, SEX_MANUAL_AROUSAL_FULL)

#define SEX_MANUAL_AROUSAL_MIN 1
#define SEX_MANUAL_AROUSAL_MAX 4

#define BLUEBALLS_GAIN_THRESHOLD 40
#define BLUEBALLS_LOOSE_THRESHOLD 35

#define PAIN_MILD_EFFECT 10
#define PAIN_MED_EFFECT 20
#define PAIN_HIGH_EFFECT 30
#define PAIN_MINIMUM_FOR_DAMAGE PAIN_MED_EFFECT
#define PAIN_DAMAGE_DIVISOR 50

#define MAX_AROUSAL 150
#define PASSIVE_EJAC_THRESHOLD 108
#define ACTIVE_EJAC_THRESHOLD 100
#define SEX_MAX_CHARGE 300
#define CHARGE_FOR_CLIMAX 100
#define AROUSAL_HARD_ON_THRESHOLD 20
#define CHARGE_RECHARGE_RATE (CHARGE_FOR_CLIMAX / (2 MINUTES))
#define AROUSAL_TIME_TO_UNHORNY (5 SECONDS)
#define SPENT_AROUSAL_RATE (3 / (1 SECONDS))
#define IMPOTENT_AROUSAL_LOSS_RATE (3 / (1 SECONDS))

#define MOAN_COOLDOWN 3 SECONDS
#define PAIN_COOLDOWN 6 SECONDS

#define MIN_PENIS_SIZE 1
#define DEFAULT_PENIS_SIZE 2
#define MAX_PENIS_SIZE 3

#define PENIS_SIZES list(\
	MIN_PENIS_SIZE,\
	DEFAULT_PENIS_SIZE,\
	MAX_PENIS_SIZE,\
	)

#define PENIS_SIZES_BY_NAME list(\
	"Small" = MIN_PENIS_SIZE,\
	"Average" = DEFAULT_PENIS_SIZE,\
	"Large" = MAX_PENIS_SIZE,\
	)

#define PENIS_TYPE_PLAIN 1
#define PENIS_TYPE_KNOTTED 2
#define PENIS_TYPE_EQUINE 3
#define PENIS_TYPE_TAPERED 4
#define PENIS_TYPE_TAPERED_DOUBLE 5
#define PENIS_TYPE_TAPERED_DOUBLE_KNOTTED 6
#define PENIS_TYPE_BARBED 7
#define PENIS_TYPE_BARBED_KNOTTED 8
#define PENIS_TYPE_TENTACLE 9

#define SHEATH_TYPE_NONE 0
#define SHEATH_TYPE_NORMAL 1
#define SHEATH_TYPE_SLIT 2

#define ERECT_STATE_NONE 0
#define ERECT_STATE_PARTIAL 1
#define ERECT_STATE_HARD 2

#define MIN_TESTICLES_SIZE 1
#define DEFAULT_TESTICLES_SIZE 2
#define MAX_TESTICLES_SIZE 3

#define TESTICLE_SIZES list(\
	MIN_TESTICLES_SIZE,\
	DEFAULT_TESTICLES_SIZE,\
	MAX_TESTICLES_SIZE,\
	)

#define TESTICLE_SIZES_BY_NAME list(\
	"Small" = MIN_TESTICLES_SIZE,\
	"Average" = DEFAULT_TESTICLES_SIZE,\
	"Large" = MAX_TESTICLES_SIZE,\
	)

#define ORGAN_SLOT_PENIS "penis"
#define ORGAN_SLOT_TESTICLES "testicles"
#define ORGAN_SLOT_BREASTS "breasts"
#define ORGAN_SLOT_VAGINA "vagina"
#define ORGAN_SLOT_ANUS "anus"///this is a fake organ used for sex_lock

#define BREAST_SIZE_FLAT 0
#define BREAST_SIZE_VERY_SMALL 1
#define BREAST_SIZE_SMALL 2
#define BREAST_SIZE_NORMAL 3
#define BREAST_SIZE_LARGE 4
#define BREAST_SIZE_ENORMOUS 5

#define MIN_BREASTS_SIZE BREAST_SIZE_FLAT
#define DEFAULT_BREASTS_SIZE BREAST_SIZE_NORMAL
#define MAX_BREASTS_SIZE BREAST_SIZE_ENORMOUS

#define BREAST_SIZES list(\
	BREAST_SIZE_FLAT,\
	BREAST_SIZE_VERY_SMALL,\
	BREAST_SIZE_SMALL,\
	BREAST_SIZE_NORMAL,\
	BREAST_SIZE_LARGE,\
	BREAST_SIZE_ENORMOUS,\
	)

#define BREAST_SIZES_BY_NAME list(\
	"Flat" = BREAST_SIZE_FLAT,\
	"Very Small" = BREAST_SIZE_VERY_SMALL,\
	"Small" = BREAST_SIZE_SMALL,\
	"Normal" = BREAST_SIZE_NORMAL,\
	"Large" = BREAST_SIZE_LARGE,\
	"Enormous" = BREAST_SIZE_ENORMOUS,\
	)

#define KINK_PROCESS (1 << 0)
#define KINK_SEX_ACT (1 << 1)
#define KINK_ATTACKED (1 << 2)

#define KINK_BONDAGE "Bondage"
#define KINK_DOMINATION "Domination"
#define KINK_GENTLE "Gentle"
#define KINK_ONOMATOPOEIA "Onomatopoeia"
#define KINK_PRAISE "Praise"
#define KINK_PUBLIC_RISK "Public Risk"
#define KINK_ROLEPLAY "Roleplay"
#define KINK_ROUGH "Rough"
#define KINK_SENSUAL_PLAY "Sensual Play"
#define KINK_SUBMISSIVE "Submissive"
#define KINK_TEASING "Teasing"
#define KINK_VISUAL_EFFECTS "Visual Effects"

/proc/build_sex_actions()
	. = list()
	for(var/path in typesof(/datum/sex_action))
		if(is_abstract(path))
			continue
		.[path] = new path()
	return .


#define SUBTLE_TAG (1 << 0)
#define SUBTLE_ALL (1 << 1)
#define SUBTLE_NOGHOST (1 << 2)
#define SUBTLE_SHORT (1 << 3)

#define SEX_SOUNDS_SLOW list(\
	"sound/misc/mat/sex_clap/slow/SexSlap14.ogg",\
	"sound/misc/mat/sex_clap/slow/SexSlap20.ogg",\
	"sound/misc/mat/sex_clap/slow/SexSlap21.ogg",\
	"sound/misc/mat/sex_clap/slow/SexSlap23.ogg",\
	"sound/misc/mat/sex_clap/slow/SexSlap34.ogg",\
	)

#define SEX_SOUNDS_HARD list(\
	"sound/misc/mat/sex_clap/hard/SexSmack17.ogg",\
	"sound/misc/mat/sex_clap/hard/SexSmack18.ogg",\
	"sound/misc/mat/sex_clap/hard/SexSmack20.ogg",\
	"sound/misc/mat/sex_clap/hard/SexSmack21.ogg",\
	"sound/misc/mat/sex_clap/hard/SexSmack24.ogg",\
	"sound/misc/mat/sex_clap/hard/SexSmack26.ogg",\
	)

#define KNOTTED_NULL 0
#define KNOTTED_AS_TOP 1
#define KNOTTED_AS_BTM 2
