#define BALLOON_TEXT_WIDTH 200
#define BALLOON_TEXT_SPAWN_TIME (0.2 SECONDS)
#define BALLOON_TEXT_FADE_TIME (0.1 SECONDS)
#define BALLOON_TEXT_FULLY_VISIBLE_TIME (0.7 SECONDS)
#define BALLOON_TEXT_TOTAL_LIFETIME(mult) (BALLOON_TEXT_SPAWN_TIME + BALLOON_TEXT_FULLY_VISIBLE_TIME*mult + BALLOON_TEXT_FADE_TIME)
/// The increase in duration per character in seconds
#define BALLOON_TEXT_CHAR_LIFETIME_INCREASE_MULT (0.05)
/// The amount of characters needed before this increase takes into effect
#define BALLOON_TEXT_CHAR_LIFETIME_INCREASE_MIN 10
//These are "standard" separations for 3 tiers. Should work fine with single words.
#define BALLOON_Y_OFFSET_TIER1 5
#define BALLOON_Y_OFFSET_TIER2 15
#define BALLOON_Y_OFFSET_TIER3 25

#define WXH_TO_HEIGHT(measurement, return_var) \
	do { \
		var/_measurement = measurement; \
		return_var = text2num(copytext(_measurement, findtextEx(_measurement, "x") + 1)); \
	} while(FALSE);
