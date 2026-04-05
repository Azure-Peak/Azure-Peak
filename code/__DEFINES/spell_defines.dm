// Constants for glow color used in spells
#define GLOW_COLOR_FIRE "#FF4500" // Red
#define GLOW_COLOR_ICE "#87CEEB" // Cyan
#define GLOW_COLOR_LIGHTNING "#FFD700" // Warm gold-yellow
#define GLOW_COLOR_BUFF "#A0E65C" // Green
#define GLOW_COLOR_VAMPIRIC "#8B0000" // Dark Red
#define GLOW_COLOR_METAL "#B0B8C8" // Silver-steel
#define GLOW_COLOR_EARTHEN "#8B6914" // Brown, for earthen / stone spells
#define GLOW_COLOR_DISPLACEMENT "#9400D3" // Purple, for generic displacement / CC spells
#define GLOW_COLOR_ARCANE "#7878F0" // Blue-purple, for generic arcane spells
#define GLOW_COLOR_KINESIS "#7B68EE" // Purple, pure arcana
#define GLOW_COLOR_HEX "#b884f8" // Hex purple
#define GLOW_COLOR_ILLUSION "#CE93D8" // Illusory pink-purple
#define GLOW_COLOR_HEARTH "#FF8A65" // Warm hearthfire salmon
#define GLOW_COLOR_LIGHT "#FFFDE7" // Pale warm white, for light spells
#define GLOW_COLOR_WARD "#D4A844" // Warm amber-gold, for battlewardry / protective ward spells

// Constants for spell glow intensity. These are literally 1 2 3 4 but it is for documenting design purposes
#define GLOW_INTENSITY_LOW 1 // For spam projectiles or generic buffs
#define GLOW_INTENSITY_MEDIUM 2 // Anything that would hurt quite a bit
#define GLOW_INTENSITY_HIGH 3 // Large AOE
#define GLOW_INTENSITY_VERY_HIGH 4 // Greater Fireball or Massive AOE / T4 spells

// Constants for enchantment effects (used by fit_clothing, gems, etc.)
#define FORCE_BLADE_ENCHANT 2
#define DURABILITY_ENCHANT 3
#define DURABILITY_INCREASE 100
#define FORCE_FILTER "force_blade"
#define DURABILITY_FILTER "durability_enchant"

// Spell CD / Chargetime Scaling
#define SPELL_SCALING_THRESHOLD 10 // The threshold at which the spell scaling starts to kick in
#define SPELL_POSITIVE_SCALING_THRESHOLD 15 // The threshold at which spell scaling stop
#define COOLDOWN_REDUCTION_PER_INT 0.05 // The amount of cooldown reduction per point of intelligence above / below threshold
#define FATIGUE_REDUCTION_PER_INT 0.05 // Stamina cost reduction per INT above threshold. 5 points above = 25% max reduction

// Armor Penalty - We applies to cooldown because we want static stamina cost
#define MEDIUM_ARMOR_CD_PENALTY 0.15 // Cooldown multiplier for wearing medium armor
#define HEAVY_ARMOR_CD_PENALTY 0.3 // Cooldown multiplier for wearing heavy armor
#define UNTRAINED_ARMOR_CD_PENALTY 0.8 // Cooldown multiplier for wearing armor you're not trained in

// Standardized spell stamina costs
#define SPELLCOST_CANTRIP            5
#define SPELLCOST_MINOR_PROJECTILE   10 // Should feels good to spam and not stamcrit you
#define SPELLCOST_MAJOR_PROJECTILE   20 // 20 seems decent
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
// Buff duration tiers
#define STAT_BUFF_SELF_DURATION      1 MINUTES
#define STAT_BUFF_ALLY_DURATION      2.5 MINUTES
#define UTILITY_AOE_BUFF_DURATION    15 MINUTES

#define SPELLCOST_MIRACLE            30
#define SPELLCOST_MIRACLE_MAJOR      60
#define SPELLCOST_MINOR_SKILL        30
#define SPELLCOST_MAJOR_SKILL        50

// Spellblade specific cost
#define SPELLCOST_SB_POKE 12 // Roughly 3 attacks worth
#define SPELLCOST_SB_MOBILITY 12 // Dashes / Teleports / Anchor
#define SPELLCOST_SB_ULT 50 // Their ult

// Standardized charge times — keeps poke/major/heavy spells consistent for balance passes
#define CHARGETIME_POKE          0.5 SECONDS  // Staple poke spells
#define CHARGETIME_MINOR         1 SECONDS    // Minor utility / support spells
#define CHARGETIME_MAJOR         1.5 SECONDS  // Major projectiles
#define CHARGETIME_HEAVY         2 SECONDS    // Heavy AOE / ultimates

// Standardized mage projectile speeds — lower = faster
#define MAGE_PROJ_FAST        1.25  // Quick bolts (arcyne bolt, frost bolt)
#define MAGE_PROJ_MEDIUM      1.75  // Mid-range projectiles (spitfire, lance)
#define MAGE_PROJ_SLOW        2     // Heavier projectiles (gravel blast)
#define MAGE_PROJ_VERY_SLOW   2.5   // Looming doom (fireball)

// Standardized spell ranges
#define SPELL_RANGE_PROJECTILE 10  // Standard projectile travel distance and projectile spell cast range
#define SPELL_RANGE_GROUND     7   // Standard ground-targeted / AOE spell cast range

// Charging slowdown tiers — how much the caster is slowed while charging
#define CHARGING_SLOWDOWN_NONE 0       // Spellblade abilities, no movement penalty
#define CHARGING_SLOWDOWN_SMALL 1      // Small projectiles, minor spells
#define CHARGING_SLOWDOWN_MEDIUM 2     // Big projectiles, significant spells
#define CHARGING_SLOWDOWN_HEAVY 3      // Area denial, channeled spells

// Spell impact visual intensity tiers
#define SPELL_IMPACT_NONE   0  // No impact visual
#define SPELL_IMPACT_LOW    1  // 2 wisps — minor pokes, utility
#define SPELL_IMPACT_MEDIUM 2  // 4 wisps — staple projectiles, soulshot
#define SPELL_IMPACT_HIGH   3  // 6 wisps — big hits, fireball, boulder

// Rune Ward types and icon states
#define RUNE_WARD_STUN "stun"
#define RUNE_WARD_FIRE "fire"
#define RUNE_WARD_CHILL "chill"
#define RUNE_WARD_DAMAGE "damage"
#define RUNE_WARD_ALARM "alarm"
#define RUNE_WARD_ICON_STUN "rune_stun"
#define RUNE_WARD_ICON_FIRE "rune_fire"
#define RUNE_WARD_ICON_CHILL "rune_chill"
#define RUNE_WARD_ICON_DAMAGE "rune_damage"
#define RUNE_WARD_ICON_ALARM "rune_alarm"

// Magic Aspect system - default slot counts (overridden by mage_aspect_config per class)
#define MAX_MAJOR_ASPECTS 1
#define MAX_MINOR_ASPECTS 2
#define ASPECT_MAJOR "major"
#define ASPECT_MINOR "minor"

// Telegraph delay tiers (in ticks)
#define TELEGRAPH_SKILLSHOT 4   // Fast - requires prediction to dodge
#define TELEGRAPH_DODGEABLE 8   // Reactable - can dodge on reaction
#define TELEGRAPH_HIGH_IMPACT 12 // Slow - highly telegraphed, big payoff
#define TELEGRAPH_AREA_DENIAL 16 // Very Slow - AOE or ground targeted, requires setup to avoid
#define TELEGRAPH_ULTIMATE 20 // Supremely slow. Getting hit is your own fault

// Aspect attuned names — shared between magic_aspect datums and implement-scaled spells
#define ASPECT_NAME_PYROMANCY   "Fire"
#define ASPECT_NAME_CRYOMANCY   "Frost"
#define ASPECT_NAME_FULGURMANCY "Storms"
#define ASPECT_NAME_GEOMANCY    "Stone"
#define ASPECT_NAME_KINESIS     "Force"
#define ASPECT_NAME_FERRAMANCY  "Metal"
#define ASPECT_NAME_AUGMENTATION "Enhancement"
#define ASPECT_NAME_BATTLEWARDRY "Wards"

// Arcyne ward tier hierarchy - higher tier wards override lower, equal or lower cannot override
#define ARCYNE_WARD_TIER_OTHER   1 // Other Ward (cast on allies)
#define ARCYNE_WARD_TIER_BASE    4 // Standard arcyne ward (self-cast)
#define ARCYNE_WARD_TIER_GREATER 5 // Dragonhide / Crystalhide upgrades

// Variant additive sentinel - used instead of null because DM skips null keys in for-in loops
#define VARIANT_ADDITIVE "__additive__"

// Weapon-in-hand casting penalty — applied when casting a penalized spell while holding a non-implement rogueweapon
#define WEAPON_CAST_PENALTY 0.3

// Spell implement tiers and multipliers
#define IMPLEMENT_TIER_LESSER  1
#define IMPLEMENT_TIER_GREATER 2
#define IMPLEMENT_TIER_GRAND   3

#define IMPLEMENT_MULT_LESSER  1.2   // 20% poke damage bonus
#define IMPLEMENT_MULT_GREATER 1.225 // 22.5% poke damage bonus
#define IMPLEMENT_MULT_GRAND   1.25  // 25% poke damage bonus

// Lightning Specific constants
#define LIGHTNING_ADAPTATION_COOLDOWN 15 SECONDS
#define MT_LIGHTNING_ADAPTATION "lightning_adaptation"

// Gravity Specific constants
#define GRAVITY_ADAPTATION_COOLDOWN 15 SECONDS
#define MT_GRAVITY_ADAPTATION "gravity_adaptation"

// Temporary — move back to components.dm once PR #6301 merges
#define COMSIG_MOB_KICKED_SUCCESSFUL "mob_kicked_successful" //from /mob/living/proc/try_kick(). Sent to target after a kick lands (past dodge/parry).

// Aspect
#define ASPECT_RESET_BUDGET 4
#define ASPECT_RESET_COST_MAJOR 4
#define ASPECT_RESET_COST_MINOR 2
#define ASPECT_RESET_COST_UTILITY 1
