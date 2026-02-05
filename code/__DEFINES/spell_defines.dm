// Constants for glow color used in spells
#define GLOW_COLOR_FIRE "#FF4500" // Red
#define GLOW_COLOR_ICE "#87CEEB" // Cyan
#define GLOW_COLOR_LIGHTNING "#FFFF00" // Yellow
#define GLOW_COLOR_BUFF "#A0E65C" // Green
#define GLOW_COLOR_VAMPIRIC "#8B0000" // Dark Red
#define GLOW_COLOR_METAL "#808080" // Gray
#define GLOW_COLOR_DISPLACEMENT "#9400D3" // Purple, for generic displacement / CC spells
#define GLOW_COLOR_ARCANE "#6495ED" // Light Blue, for generic arcane spells

// Constants for spell glow intensity. These are literally 1 2 3 4 but it is for documenting design purposes
#define GLOW_INTENSITY_LOW 1 // For spam projectiles or generic buffs
#define GLOW_INTENSITY_MEDIUM 2 // Anything that would hurt quite a bit
#define GLOW_INTENSITY_HIGH 3 // Large AOE
#define GLOW_INTENSITY_VERY_HIGH 4 // Greater Fireball or Massive AOE / T4 spells

// Constants for enchanted_weapon
#define FORCE_BLADE_ENCHANT 2
#define DURABILITY_ENCHANT 3
#define ARCANE_MARK_ENCHANT 4
#define FORCE_BLADE_FORCE 5
#define DURABILITY_INCREASE 100
#define FORCE_FILTER "force_blade"
#define DURABILITY_FILTER "durability_enchant"
#define ARCANE_MARK_FILTER_WEAPON "arcane_mark_enchant"
#define ARCANE_MARK_COOLDOWN 12 SECONDS