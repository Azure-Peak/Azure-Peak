// Constants for tuning simple mobs
/*
*/
// Fraction of melee_damage_lower/upper a cripple wound strips from the mob.
#define CRIPPLE_DAMAGE_PENALTY_MINOR 0.2
#define CRIPPLE_DAMAGE_PENALTY_MAJOR 0.4

// Multiplier on the mob's next_move_modifier while crippled. Higher is slower.
#define CRIPPLE_ATTACK_DELAY_MINOR 1.05
#define CRIPPLE_ATTACK_DELAY_MAJOR 1.2

// Movespeed modifier applied per crippled limb. Stacks per leg.
#define CRIPPLE_MOVE_PENALTY_MINOR (0.15 SECONDS)
#define CRIPPLE_MOVE_PENALTY_MAJOR (0.4 SECONDS)

// Share of a ranged hit's damage contributed toward breaking a part
#define RANGED_PART_CONTRIBUTION 0.66

// Damage multiplier vs Earth Elemental for using blunt weapons
#define CONSTRUCT_BLUNT_PART_MULT 1.6

// Penetration damage multiplier vs PART, not total HP. So that there's rewards for using stab weapons instead of just DPS race.
// Largely meant to give a slight leg up to spears and such which also make sense. See: Boar Spears in history.
#define PEN_PART_MULT_LIGHT		1.05
#define PEN_PART_MULT_MEDIUM	1.1
#define PEN_PART_MULT_HEAVY		1.3
#define PEN_PART_MULT_BSTEEL	1.6

// Only allow thrust / piercing family to get this multiplier to avoid axes in particular from becoming too good
#define PEN_PART_BCLASSES list(BCLASS_STAB, BCLASS_PICK, BCLASS_PIERCE)

// Throttle on the "I can't reach that" message, per mob.
#define REACH_WARNING_COOLDOWN (4 SECONDS)

// Mobs below this maxHealth never show the staged damage popup.
#define DAMAGE_STAGE_MIN_HEALTH 200

// Health ratios at which the popup escalates.
#define DAMAGE_STAGE_BLOODIED 0.75
#define DAMAGE_STAGE_MANGLED 0.5
#define DAMAGE_STAGE_SAVAGED 0.25
