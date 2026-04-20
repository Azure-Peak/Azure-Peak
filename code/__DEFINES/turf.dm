#define SEE_SKY_YES 1
#define SEE_SKY_NO 2

/// If a turf is an unused reservation turf awaiting assignment
#define UNUSED_RESERVATION_TURF (1 << 0)
/// If a turf is a reserved turf
#define RESERVATION_TURF (1 << 1)
/// Can't be jaunted through
#define NO_JAUNT (1 << 2)
/// Fluid effects can't spawn in this turf
#define TURF_NO_LIQUID_SPREAD (1<<3)
/// Turf is currently in the weathered_turfs list and should not be readded to avoid duplicates
#define TURF_BEING_WEATHERED (1<<4)
/// Turf is currently queued in GLOB.SUNLIGHT_QUEUE_CORNER and should not be re-queued to avoid duplicates
#define TURF_SUNLIGHT_QUEUED (1<<5)
