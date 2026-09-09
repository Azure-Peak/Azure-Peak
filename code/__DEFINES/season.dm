// Calendar season names, as returned by get_season_from_month()/get_current_season().
#define SEASON_SPRING "Spring"
#define SEASON_SUMMER "Summer"
#define SEASON_AUTUMN "Autumn"
#define SEASON_WINTER "Winter"

// Winter sub-phase names, as returned by get_season_phase()/get_current_season_phase().
#define SEASON_PHASE_EARLY "Early"
#define SEASON_PHASE_MID "Mid"
#define SEASON_PHASE_LATE "Late"

// Lowercase season names used for flora sprite suffixes (e.g. "leaf-[FLORA_SEASON_SPRING]-1").
// Distinct from the SEASON_* defines above because Autumn's flora sprites are named "fall".
#define FLORA_SEASON_SPRING "spring"
#define FLORA_SEASON_SUMMER "summer"
#define FLORA_SEASON_FALL "fall"
#define FLORA_SEASON_WINTER "winter"

// In-game days a mid-round season change is spread across, rather than converting the whole
// map in one sweep while players are standing on it. Roundstart conversions ignore this and
// happen all at once; so do admin-forced date changes, so testing a season doesn't mean
// waiting out four dawns. See SSseason.
#define SEASON_TRANSITION_DAYS 4

// Edge length, in tiles, of the square blocks season_chunk_shuffle() scatters conversions in.
// Bigger blocks mean less repeated icon smoothing but chunkier-looking transitions.
#define SEASON_SHUFFLE_CHUNK 8
