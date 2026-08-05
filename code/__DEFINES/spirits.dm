//Spirit defines, placed here so they can be read by other things!
// These used to be for monkeys.

//Mode defines
#define SPIRIT_IDLE 			0	// idle
#define SPIRIT_HUNT 			1	// found target, hunting
#define SPIRIT_FLEE 			2	// free from enemies
#define SPIRIT_DISPOSE 			3	// dump body in disposals

#define SPIRIT_FLEE_HEALTH 					50	// below this health value the spirit starts to flee from enemies
#define SPIRIT_ENEMY_VISION 				9	// how close an enemy must be to trigger aggression
#define SPIRIT_FLEE_VISION					4	// how close an enemy must be before it triggers flee
#define SPIRIT_ITEM_SNATCH_DELAY 			25	// How long does it take the item to be taken from a mobs hand
#define SPIRIT_CUFF_RETALIATION_PROB		20  // Probability spirit will aggro when cuffed
#define SPIRIT_SYRINGE_RETALIATION_PROB		20  // Probability spirit will aggro when syringed

// Probability per Life tick that the spirit will:
#define SPIRIT_RESIST_PROB 					50	// resist out of restraints
												// when the spirit is idle
#define SPIRIT_PULL_AGGRO_PROB 				5		// aggro against the mob pulling it
#define SPIRIT_SHENANIGAN_PROB 				5		// chance of getting into mischief, i.e. finding/stealing items
												// when the spirit is hunting
#define SPIRIT_ATTACK_DISARM_PROB 			50		// disarm an armed attacker
#define SPIRIT_WEAPON_PROB 					20		// if not currently getting an item, search for a weapon around it
#define SPIRIT_RECRUIT_PROB 				25		// recruit a spirit near it
#define SPIRIT_SWITCH_TARGET_PROB 			25		// switch targets if it sees another enemy

#define SPIRIT_RETALIATE_HARM_PROB 			95	// probability for the spirit to aggro when attacked with harm intent
#define SPIRIT_RETALIATE_DISARM_PROB 		20 	// probability for the spirit to aggro when attacked with disarm intent

#define SPIRIT_HATRED_AMOUNT 				4	// amount of aggro to add to an enemy when they attack user
#define SPIRIT_HATRED_REDUCTION_PROB 		25	// probability of reducing aggro by one when the spirit attacks

// how many Life ticks the spirit will fail to:
#define SPIRIT_HUNT_FRUSTRATION_LIMIT 		8	// Chase after an enemy before giving up
#define SPIRIT_DISPOSE_FRUSTRATION_LIMIT 	16 	// Dispose of a body before giving up

#define SPIRIT_AGGRESSIVE_INFIGHT_PROB			0	// If you mass edit monkies to be aggressive. there is a small chance of in-fighting
