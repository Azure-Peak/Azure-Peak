#define CURRENCY_MAMMON "mammon"
#define CURRENCY_WAR_AUTHORITY "war_authority"

/// Floor amount of War Chest authority refilled per day regardless of population (lowpop safety).
#define WAR_CHEST_BASE_REFILL 400
/// Additional War Chest authority granted per active player per day.
#define WAR_CHEST_PER_PLAYER 10
/// Clawback ceiling — any War Chest balance above this multiple of the daily refill is skimmed at each daily tick.
#define WAR_CHEST_CLAWBACK_MULTIPLIER 2

#define TAX_CATEGORY_CONTRACT_LEVY "contract levy"
#define TAX_CATEGORY_HEADEATER_LEVY "headeater levy"
#define TAX_CATEGORY_IMPORT_TARIFF "import tariff"
#define TAX_CATEGORY_EXPORT_DUTY "export duty"
#define TAX_CATEGORY_FINE "fine"

/// Maximum fraction of a target's balance a single levy/fine can take. Decrees may narrow this further.
#define GENERIC_RATE_CAP 0.75
