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
