#define CURRENCY_MAMMON "mammon"
#define CURRENCY_BURGHER_AUTHORITY "burgher_authority"

/// Floor amount of Burgher Bond authority refilled per day regardless of population (lowpop safety).
#define BURGHER_BOND_BASE_REFILL 400
/// Additional Burgher Bond authority granted per active player per day.
#define BURGHER_BOND_PER_PLAYER 10
/// Clawback ceiling — any Burgher Bond balance above this multiple of the daily refill is skimmed at each daily tick.
#define BURGHER_BOND_CLAWBACK_MULTIPLIER 2

#define TAX_CATEGORY_CONTRACT_LEVY "contract levy"
#define TAX_CATEGORY_HEADEATER_LEVY "headeater levy"
#define TAX_CATEGORY_IMPORT_TARIFF "import tariff"
#define TAX_CATEGORY_EXPORT_DUTY "export duty"
#define TAX_CATEGORY_FINE "fine"

/// Maximum fraction of a target's balance a single levy/fine can take. Decrees may narrow this further.
#define GENERIC_RATE_CAP 0.75

/// Mammon balance at round-end required to earn the Savings Goal triumph.
#define SAVINGS_GOAL_THRESHOLD 200

// Poll Tax categories - flat per-head daily levy by civic class.
#define POLL_TAX_CAT_NOBLE "poll_noble"
#define POLL_TAX_CAT_CLERGY "poll_clergy"
#define POLL_TAX_CAT_INQUISITION "poll_inquisition"
#define POLL_TAX_CAT_COURTIER "poll_courtier"
#define POLL_TAX_CAT_GARRISON "poll_garrison"
#define POLL_TAX_CAT_GUILDS "poll_guilds"
#define POLL_TAX_CAT_MERCHANT "poll_merchant"
#define POLL_TAX_CAT_BURGHER "poll_burgher"
#define POLL_TAX_CAT_ADVENTURER "poll_adventurer"
#define POLL_TAX_CAT_MERCENARY "poll_mercenary"
#define POLL_TAX_CAT_PEASANT "poll_peasant"

/// Max poll tax per category, per day, in mammon.
#define POLL_TAX_MAX_RATE 50
/// Days consecutively owing before TRAIT_DEBTOR is applied.
#define POLL_TAX_DEBT_DAYS_TO_DEBTOR 2
/// Golden Bull of Kingsfield caps burgher poll tax at this flat amount when in force.
#define GOLDEN_BULL_POLL_CAP 25
/// Minimum world-time since round start before Poll Tax advance is allowed.
#define POLL_TAX_ADVANCE_LOCKOUT (10 MINUTES)
/// Maximum days of advance a mob can hold at once. Caps advance + accumulation.
#define POLL_TAX_MAX_ADVANCE_DAYS 7
/// Presumed per-day rate used for Poll Tax advance when the Steward has not set a rate for the class.
/// Lets a proactive payer settle the full advance cap even when the Crown is lazy; it is NOT charged
/// at tick time — if the Steward never sets a rate, the tick continues to skip the class.
#define POLL_TAX_ADVANCE_FALLBACK_RATE 10
