// Magic defines - ported from Vanderlin for /datum/action/cooldown/spell system
// Deviation points:
// Schools are datum / defined list, not defined on the spell level and can overlap
// AP Design: No Mana or Attunement system. Uses green/blue bar instead.

// Spell cost types - what resource does the spell consume?
// Special prerequisites (momentum, etc.) are handled via can_cast_spell() overrides, not cost types.

/// No resource cost (free spell, or cost handled entirely by overrides)
#define SPELL_COST_NONE 0
/// Primary balance lever. Uses stamina (green bar). Default for most spells.
#define SPELL_COST_STAMINA 1
/// Pulls from energy bar (blue). For spells that trade blue for green, or drain 70-100+ that would logically stamcrit.
#define SPELL_COST_ENERGY 2
/// Miracle: uses devotion. Will be evaluated for unification later.
#define SPELL_COST_DEVOTION 3
/// Literal blood volume — NOT IMPLEMENTED yet
#define SPELL_COST_BLOOD 4
/// Vampire vitae — NOT IMPLEMENTED yet, to be converted later
#define SPELL_COST_VITAE 5

// Invocation types - what does the caster need to do to invoke (cast) the spell?
/// Allows being able to cast the spell without saying or doing anything.
#define INVOCATION_NONE "none"
/// Forces the caster to shout the invocation to cast the spell.
#define INVOCATION_SHOUT "shout"
/// Forces the caster to whisper the invocation to cast the spell.
#define INVOCATION_WHISPER "whisper"
/// Forces the caster to emote to cast the spell.
#define INVOCATION_EMOTE "emote"

// Generic bitflags for spells
/// Ignore the trait TRAIT_SPELLBLOCK
#define SPELL_IGNORE_SPELLBLOCK (1 << 0)
/// Is learnable via Rituos
#define SPELL_RITUOS (1 << 1)
/// Is a Psydon spell
#define SPELL_PSYDON (1 << 2)

// Bitflags for spell requirements
/// Whether the spell requires wizard clothes to cast.
#define SPELL_REQUIRES_WIZARD_GARB (1 << 0)
/// Whether the spell can only be cast by humans (mob type, not species).
#define SPELL_REQUIRES_HUMAN (1 << 1)
/// Whether the spell can be cast while phased (blood crawling, ethereal jaunting, rod form).
#define SPELL_CASTABLE_WHILE_PHASED (1 << 2)
/// Whether the spell can be cast while the user has antimagic that corresponds to the spell's antimagic flags.
#define SPELL_REQUIRES_NO_ANTIMAGIC (1 << 3)
/// Whether the spell requires being on the station z-level to be cast.
#define SPELL_REQUIRES_STATION (1 << 4)
/// Whether the spell must be cast by someone with a mind datum.
#define SPELL_REQUIRES_MIND (1 << 5)
/// Whether the spell can be cast even if the caster can't speak the invocation (making it flavor).
#define SPELL_CASTABLE_WITHOUT_INVOCATION (1 << 6)
/// If the spell requires the user to not move during casting.
#define SPELL_REQUIRES_NO_MOVE (1 << 7)
/// Whether the spell requires the target to be on the same Z-level as the caster.
#define SPELL_REQUIRES_SAME_Z (1 << 8)

/// Default magic resistance that blocks normal magic
#define MAGIC_RESISTANCE (1 << 0)
/// Tinfoil hat magic resistance that blocks mental magic
#define MAGIC_RESISTANCE_MIND (1 << 1)
/// Holy magic resistance that blocks miracles
#define MAGIC_RESISTANCE_HOLY (1 << 2)
/// Holy magic resistance that blocks unholy magic
#define MAGIC_RESISTANCE_UNHOLY (1 << 3)

// MAGIC TRAITS
#define TRAIT_SPELLBLOCK "spellblock"
#define TRAIT_NOC_CURSE "noc_curse"
#define TRAIT_NOSTAMINA "nostamina"
#define TRAIT_ATHEISM_CURSE "atheism_curse"
