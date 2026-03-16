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
#define ARCANE_MARK_COOLDOWN 7 SECONDS

// Spell CD / Chargetime Scaling
#define SPELL_SCALING_THRESHOLD 10 // The threshold at which the spell scaling starts to kick in
#define SPELL_POSITIVE_SCALING_THRESHOLD 15 // The threshold at which spell scaling stop
#define COOLDOWN_REDUCTION_PER_INT 0.05 // The amount of cooldown reduction per point of intelligence above / below threshold
#define CHARGE_REDUCTION_PER_SKILL 0.05 // The amount of charge reduction per skill level.
#define FATIGUE_REDUCTION_PER_INT 0.05 // Stamina cost reduction per INT above threshold. 5 points above = 25% max reduction

// Armor Penalty - We applies to cooldown because we want static stamina cost
#define MEDIUM_ARMOR_CD_PENALTY 0.15 // Cooldown multiplier for wearing medium armor
#define HEAVY_ARMOR_CD_PENALTY 0.3 // Cooldown multiplier for wearing heavy armor
#define UNTRAINED_ARMOR_CD_PENALTY 0.8 // Cooldown multiplier for wearing armor you're not trained in

// Standardized spell stamina costs
#define SPELLCOST_CANTRIP            5
#define SPELLCOST_MINOR_PROJECTILE   10 // Should feels good to spam and not stamcrit you
#define SPELLCOST_MAJOR_PROJECTILE   20 // 25 seems decent
#define SPELLCOST_SUPER_PROJECTILE   45 // Only used for GFB for now as an intermediary
#define SPELLCOST_ULTIMATE           70
#define SPELLCOST_MINOR_AOE          15
#define SPELLCOST_MAJOR_AOE          30
#define SPELLCOST_SINGLE_CC          30
#define SPELLCOST_UTILITY_BUFF       20
#define SPELLCOST_STAT_BUFF          40
#define SPELLCOST_CONJURE            20
#define SPELLCOST_TELEPORT           15
#define SPELLCOST_MINOR_SUMMON       30
#define SPELLCOST_MAJOR_SUMMON       50
#define SPELLCOST_MIRACLE            30
#define SPELLCOST_MIRACLE_MAJOR      60
#define SPELLCOST_MINOR_SKILL        30
#define SPELLCOST_MAJOR_SKILL        50

// Spellblade specific cost
#define SPELLCOST_SB_POKE 15 // Roughly 3 attacks worth
#define SPELLCOST_SB_MOBILITY 15 // Dashes / Teleports / Anchor
#define SPELLCOST_SB_ULT 50 // Their ult

// Telegraph delay tiers (in ticks)
#define TELEGRAPH_SKILLSHOT 4   // Fast — requires prediction to dodge
#define TELEGRAPH_DODGEABLE 8   // Reactable — can dodge on reaction
#define TELEGRAPH_HIGH_IMPACT 12 // Slow — highly telegraphed, big payoff
