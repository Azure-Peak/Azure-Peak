#define GNOLL_SCALING_RANDOM  0 // Mode 0: Default behavior, pick a random mode.
#define GNOLL_SCALING_DYNAMIC 1 // Mode 1: Guaranteed increase until 3 slots, diminishing chances until 10 slots
#define GNOLL_SCALING_FLAT    2 // Mode 2: 15% chance, capped at 2 slots
#define GNOLL_SCALING_SINGLE  3 // Mode 3: Single gnoll. We do nothing in code because this is the default.
