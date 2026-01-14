#define GNOLL_SCALING_RANDOM  0 // Mode 0: Default behavior, pick a random mode.
#define GNOLL_SCALING_DYNAMIC 1 // Mode 1: Guaranteed increase until 3 slots, diminishing chances until 10 slots
#define GNOLL_SCALING_FLAT    2 // Mode 2: 15% chance, capped at 2 slots
#define GNOLL_SCALING_SINGLE  3 // Mode 3: Single gnoll. We do nothing in code because this is the default.

GLOBAL_VAR_INIT(gnoll_scaling_mode, 0)

/proc/get_gnoll_scaling()
	if(GLOB.gnoll_scaling_mode != 0)
		return GLOB.gnoll_scaling_mode

	var/datum/storyteller/ST =  SSgamemode.selected_storyteller
	// Roll a coinflip to decide the round's behavior when default value is supplied.
	if(ST.preferred_gnoll_mode == GNOLL_SCALING_RANDOM)
		GLOB.gnoll_scaling_mode = pick(GNOLL_SCALING_DYNAMIC, GNOLL_SCALING_FLAT, GNOLL_SCALING_SINGLE)
	else
		GLOB.gnoll_scaling_mode = ST.preferred_gnoll_mode
	return GLOB.gnoll_scaling_mode

/proc/get_gnoll_slot_increase(total_positions)
	var/mode = get_gnoll_scaling()

	switch(mode)
		if(GNOLL_SCALING_DYNAMIC)
			// up to two gnolls guaranteed if there's hunted.
			if(total_positions <= 1)
				return 1
			// up to three gnolls with a 50% chance per hunted if there's more hunted.
			if(total_positions <= 2 && prob(50))
				return 1
			// Up to four gnolls with a 25% chance per hunted if there's more hunted.
			if(total_positions <= 3 && prob(25))
				return 1

		if(GNOLL_SCALING_FLAT)
			if(total_positions < 2 && prob(15))
				return 1
				
	return 0
