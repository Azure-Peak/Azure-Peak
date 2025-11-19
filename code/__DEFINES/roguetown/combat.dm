/* COMBAT DEFINES for NON ARMOR VALUES */

#define BASE_PARRY_STAMINA_DRAIN 5 // Unmodified stamina drain for parry, now a var instead of setting on simplemobs
#define BAD_GUARD_FATIGUE_DRAIN 20 //Percentage of your green bar lost on letting a guard expire.
#define GUARD_PEEL_REDUCTION 2	//How many Peel stacks to lose if a Guard is hit.
#define BAIT_PEEL_REDUCTION 1	//How many Peel stacks to lose if we perfectly bait.

/*
Medical defines
*/
#define ARTERY_LIMB_BLEEDRATE 20	//This is used as a reference point for dynamic wounds, so it's better off as a define.
#define CONSTITUTION_BLEEDRATE_MOD 0.1	//How much slower we'll be bleeding for every CON point. 0.1 = 10% slower.
#define CONSTITUTION_BLEEDRATE_CAP 15	//The CON value up to which we get a bleedrate reduction.

/*
 Misc. Category. Spin it out if needed
*/
#define CRIT_DISMEMBER_DAMAGE_THRESHOLD 0.75 // 75% damage threshold for dismemberment / crit
#define STANDING_DECAP_GRACE_PERIOD 2 SECONDS // Time after falling prone where you still count as standing for decap purpose

/*
	Critical Resistance Defines 
*/
// Normal classes are guaranteed 4 resists, NPC 1, noblood / revenant 1
#define CRIT_RESISTANCE_STACKS_PLAYER 4
#define CRIT_RESISTANCE_STACKS_NPC 1
#define CRIT_RESISTANCE_STACKS_OP 1 // Noblood / Revenant etc.
#define CRIT_RESISTANCE_EFFECTIVE_BLEEDRATE 0.5 // How much CR reduce bleedrate by
#define CRIT_RESISTANCE_TIMER_CD 30 SECONDS // Cooldown between guaranteed CR procs. DOES NOT APPLY TO DISMEMBERMENT.
