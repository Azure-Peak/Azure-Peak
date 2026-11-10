/// Called before beam is redrawn
#define COMSIG_BEAM_BEFORE_DRAW "beam_before_draw"
	#define BEAM_CANCEL_DRAW (1 << 0)

/// From /obj/effect/ebeam/reacting/beam_entered() : (atom/movable/entered)
#define COMSIG_BEAM_ENTERED "beam_entered"
/// From /obj/effect/ebeam/reacting/beam_exited() : (atom/movable/exited)
#define COMSIG_BEAM_EXITED "beam_exited"
/// From /obj/effect/ebeam/reacting/beam_turfs_changed() : (list/datum/callback/post_change_callbacks)
#define COMSIG_BEAM_TURFS_CHANGED "beam_turfs_changed"
