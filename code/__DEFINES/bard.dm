#define BARD_T1 1 // Lesser Bard (Cantor, Spellsinger, etc.)
#define BARD_T2 2 // Full Bard (Minstrel, Jester, Psyalmist, Rogue Bard)

// Bardic song costs
#define SONG_ACTIVATION_COST 30 // Upfront stamina cost to start or swap a song
#define SONG_SUSTAIN_COST -10 // Blue drained per sustain tick (every 20 seconds)
#define SONG_SUSTAIN_TICKS 10 // Number of tick() calls between sustain drains (10 ticks x 2s = 20s)

// Bardic tier scaling - song effect multiplier
#define BARD_SCALING_LESSER 0.6 // Cantor / Spellsinger (T1)
#define BARD_SCALING_FULL 1.0 // Bard (T2)

// Bardic tier scaling - flat stat bonuses (CON from Resolute Refrain, SPD from Akathist, etc.)
#define BARD_STAT_FULL 3 // Bard (T2)
#define BARD_STAT_LESSER 2 // Cantor / Spellsinger (T1)

// Cadence system
#define CADENCE_COOLDOWN 8 SECONDS // Cooldown between cadence procs
#define GREATER_CADENCE_STACKS 3 // Lesser cadence procs needed to unlock Greater Cadence
#define GREATER_CADENCE_DECAY 20 SECONDS // Time before Greater Cadence stacks decay

