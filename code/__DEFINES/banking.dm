#define CURRENCY_MAMMON "mammon"
#define CURRENCY_BURGHER_PLEDGE "burgher_pledge"

/// Floor amount of Burgher Pledge authority refilled per day regardless of population (lowpop safety).
#define BURGHER_PLEDGE_BASE_REFILL 250
/// Additional Burgher Pledge authority granted per active player per day.
#define BURGHER_PLEDGE_PER_PLAYER 2
/// Clawback ceiling — any Burgher Pledge balance above this multiple of the daily refill is skimmed at each daily tick.
#define BURGHER_PLEDGE_CLAWBACK_MULTIPLIER 2
/// Roundstart balance is this multiple of the daily refill, giving the Steward a buffer at the start.
#define BURGHER_PLEDGE_ROUNDSTART_MULTIPLIER 2
/// Pledge cost of issuing a Trivial-tier defense quest (kill-easy / clear-out).
#define BURGHER_PLEDGE_COST_TRIVIAL 50  // 1 band
/// Pledge cost of issuing a Standard-tier defense quest (recovery / bounty).
#define BURGHER_PLEDGE_COST_STANDARD 100 // 2 bands
/// Pledge cost of issuing a Major-tier defense quest (raid).
#define BURGHER_PLEDGE_COST_MAJOR 200    // 3 bands

/// Directive fallback: unfunded, zero-reward commission. The Steward is commanding the
/// retinue/garrison they already pay wages to. Capped per day so it can't be spammed to
/// saturate the quest pool with free work.
#define COMMISSION_REQUESTS_PER_DAY 5

#define TAX_CATEGORY_CONTRACT_LEVY "contract levy"
#define TAX_CATEGORY_HEADEATER_LEVY "headeater levy"
#define TAX_CATEGORY_IMPORT_TARIFF "import tariff"
#define TAX_CATEGORY_EXPORT_DUTY "export duty"
#define TAX_CATEGORY_FINE "fine"

/// Maximum fraction of a target's balance a single levy/fine can take. Decrees may narrow this further.
#define GENERIC_RATE_CAP 0.75

/// Savings Goal tiers. Round-end balance (on-person + bank) awards triumphs at each step;
/// the top tier awards its full triumph count (tiers don't stack - reaching tier 3 earns 3, not 6).
#define SAVINGS_GOAL_TIER1 100
#define SAVINGS_GOAL_TIER2 150
#define SAVINGS_GOAL_TIER3 200
/// Kept as an alias for callsites that still read the "main" goal threshold (announcements, etc.).
#define SAVINGS_GOAL_THRESHOLD SAVINGS_GOAL_TIER3
/// Default Crown's Purse floor below which the stockpile refuses purchases. Steward-settable.
#define STOCKPILE_CROWN_PURCHASE_FLOOR_DEFAULT 1000
/// Per-active-player mammon added to the Crown's Purse roundstart seed. Scales initial
/// treasury against expected payroll (highpop full Crown-salary roster = ~600m/day).
#define CROWN_PURSE_SEED_PER_PLAYER 35
/// Extra savings required of a noble - aristocratic duty to be comfortable. Shifts every tier.
#define SAVINGS_GOAL_NOBLE_BUMP 100
/// Extra savings required of the Greedy - a self-declared flaw. Shifts every tier.
#define SAVINGS_GOAL_GREEDY_BUMP 100

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
#define POLL_TAX_MAX_RATE 40
/// Days consecutively owing before TRAIT_ARREARS is stamped on the subject. TRAIT_DEBTOR is
/// reserved for loan defaulters; TRAIT_ARREARS is the softer mark for poll-tax-behind subjects.
#define POLL_TAX_DEBT_DAYS_TO_DEBTOR 2
/// Golden Bull of Kingsfield caps burgher poll tax at this flat amount when in force.
#define GOLDEN_BULL_POLL_CAP 20
/// Covenant of Noc & Pestra caps the poll tax of University (Court Magician, Archivist,
/// Magicians Associate) and Apothecary roster (Apothecary, Head Physician) at this flat amount.
#define NOC_PESTRA_POLL_CAP 10
/// Guild Charter of Arms caps Mercenary poll tax at this flat amount when in force.
#define GUILD_CHARTER_OF_ARMS_POLL_CAP 15
/// The Guild of Arms' reciprocal contribution to the common defense budget: the Burgher Pledge
/// daily refill gains this flat bonus while the charter is in force. Paralleled with the Golden
/// Bull's Burgher Pledge - both charters feed the same "common defense" pool.
#define GUILD_CHARTER_OF_ARMS_PLEDGE_BONUS 100
#define POLL_TAX_ADVANCE_LOCKOUT (10 MINUTES)
#define POLL_TAX_MAX_ADVANCE_DAYS 7
#define POLL_TAX_ADVANCE_FALLBACK_RATE 10
