#define CURRENCY_MAMMON "mammon"
#define CURRENCY_BURGHER_PLEDGE "burgher_pledge"

/// Floor amount of Burgher Pledge authority refilled per day regardless of population (lowpop safety).
#define BURGHER_PLEDGE_BASE_REFILL 500
/// Additional Burgher Pledge authority granted per active player per day.
#define BURGHER_PLEDGE_PER_PLAYER 4
/// Clawback ceiling — any Burgher Pledge balance above this multiple of the daily refill is skimmed at each daily tick.
#define BURGHER_PLEDGE_CLAWBACK_MULTIPLIER 2
/// Roundstart balance is this multiple of the daily refill, giving the Steward a buffer at the start.
#define BURGHER_PLEDGE_ROUNDSTART_MULTIPLIER 2
/// Pledge cost of issuing a Trivial-tier defense quest (kill-easy / clear-out).
#define BURGHER_PLEDGE_COST_TRIVIAL 38  // 1 band
/// Pledge cost of issuing a Standard-tier defense quest (bounty / clear-out).
#define BURGHER_PLEDGE_COST_STANDARD 75 // 2 bands
/// Pledge cost of issuing a Major-tier defense quest (raid).
#define BURGHER_PLEDGE_COST_MAJOR 150    // 3 bands

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

/// Default Crown's Purse floor below which the stockpile refuses purchases. Steward-settable.
#define STOCKPILE_CROWN_PURCHASE_FLOOR_DEFAULT 1000
/// Per-active-player mammon added to the Crown's Purse roundstart seed. Scales initial
/// treasury against expected payroll (highpop full Crown-salary roster = ~600m/day).
#define CROWN_PURSE_SEED_PER_PLAYER 35

/// Flat bonus minted on top of the recipient's noble_income on their first estate payment
/// (round-start / character-creation). Recurring daily ticks pay the base amount with no bonus.
#define ESTATE_STARTER_BONUS 30

// ============================================================================
// Treasury insolvency / bankruptcy / receivership
// ============================================================================
/// Treasury solvency states. Drive distribute_daily_payments, the debt skim, and
/// charter / auto-trade behavior. State transitions in
/// SStreasury.advance_treasury_state, never assigned directly elsewhere.
#define TREASURY_NORMAL 0
#define TREASURY_IN_ARREARS 1
#define TREASURY_BANKRUPTCY 2

/// Interest-free advance when the Crown first misses payroll. Sized as max(this, shortfall)
/// so a small overdraft uses the floor and a large one borrows enough to actually cover wages.
#define TREASURY_ARREARS_LOAN 1000

/// Crown's Purse balance injected at bankruptcy entry to keep auto-import/export functional
/// during receivership. Also the operating-floor cap: any inflow that would push the purse
/// above this is skimmed against bankruptcy debt instead.
#define BANKRUPTCY_OPERATING_FLOOR 2500

/// Bankruptcy debt registered on entry. Flat by design: the operating-floor advance is
/// flat too, and scaling one without the other reads as arbitrary.
#define BANKRUPTCY_DEBT_FLAT 5000

/// Auto-export percentage forced while in bankruptcy ("everything must move"). The
/// Steward-settable percentage is stashed and restored on recovery.
#define BANKRUPTCY_AUTOEXPORT_PERCENTAGE 0.25

/// Concession picks granted on recovery: how many bankruptcy-suspended charters the
/// Lord/Hand can restore without cooldown. Remaining suspended charters follow normal
/// DECREE_COOLDOWN rules.
#define BANKRUPTCY_CONCESSION_PICKS 3

/// Crown's Purse balance reset to this on recovery, replacing whatever sub-floor amount
/// was held during receivership.
#define BANKRUPTCY_RECOVERY_RESET 1500

/// Decrees suspended on bankruptcy entry. Golden Bull is intentionally absent - burgher
/// protection holds, and the Crown cannot revoke it during receivership.
#define BANKRUPTCY_SUSPENDED_DECREES list( \
	DECREE_NOC_PESTRA_COVENANT, \
	DECREE_GREAT_WRIT, \
	DECREE_GUILD_CHARTER_OF_ARMS, \
	DECREE_INDENTURE_OF_WAR, \
	DECREE_MAGNA_CARTA, \
	DECREE_OTAVAN_ACCORDS, \
	DECREE_ZENITSTADT_CONCORDAT, \
)

// ============================================================================
// ATC Emergency Loan - the early-round "just one more day" tool
// ============================================================================
/// Minimum size of an Azurian Trading Company emergency loan.
#define ATC_LOAN_MIN_AMOUNT 500
/// Maximum size of an Azurian Trading Company emergency loan.
#define ATC_LOAN_MAX_AMOUNT 1500
/// On this day and onward the Guilds clerk is "out of office" and the loan is unavailable.
/// Prevents the loan from being used as a free emergency cash injection late round when the
/// debt would not realistically be collectible.
#define ATC_LOAN_CLOSED_DAY 5

/// Interest the Company charges on every emergency loan. Crown receives the principal but owes
/// principal * (1 + this) back. Sized to keep the loan a deliberate "last resort" choice rather
/// than a default-on-cooldown buffer; period-realistic for merchant-house emergency lending.
#define ATC_LOAN_INTEREST_RATE 0.25

// ============================================================================
// Far-travel anti-grief: Keep insiders only. Gates the bank-reclaim clawback so we don't
// punish innocent bailers (burgher/peasant/adventurer FT'ing Day 1 because they hated
// their slot) but do catch Crown-adjacent power roles who could meaningfully grief by
// hoarding Crown coin and leaving the round.
// ============================================================================
#define KEEP_INSIDER_JOBS list( \
	"Lord", \
	"Prince", \
	"Consort", \
	"Hand", \
	"Steward", \
	"Clerk", \
	"Seneschal", \
	"Councillor", \
	"Suitor", \
	"Marshal", \
	"Knight", \
)

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
#define POLL_TAX_MAX_SUBSIDY 60
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
