#define CURRENCY_MAMMON "mammon"
#define CURRENCY_BURGHER_PLEDGE "burgher_pledge"

#define BURGHER_PLEDGE_BASE_REFILL 500
#define BURGHER_PLEDGE_PER_PLAYER 4
#define BURGHER_PLEDGE_CLAWBACK_MULTIPLIER 2
#define BURGHER_PLEDGE_ROUNDSTART_MULTIPLIER 2
#define BURGHER_PLEDGE_COST_TRIVIAL 38
#define BURGHER_PLEDGE_COST_STANDARD 75
#define BURGHER_PLEDGE_COST_MAJOR 150
#define BURGHER_PLEDGE_COST_INCURSION 250
#define COMMISSION_REQUESTS_PER_DAY 5

#define TAX_CATEGORY_CONTRACT_LEVY "contract levy"
#define TAX_CATEGORY_HEADEATER_LEVY "headeater levy"
#define TAX_CATEGORY_IMPORT_TARIFF "import tariff"
#define TAX_CATEGORY_EXPORT_DUTY "export duty"
#define TAX_CATEGORY_RECOVERED_SPOILS "recovered spoils"
#define TAX_CATEGORY_FINE "fine"
#define TAX_CATEGORY_POLL_LEVY "poll levy"

#define GENERIC_RATE_CAP 0.75
#define STOCKPILE_CROWN_PURCHASE_FLOOR_DEFAULT 1000
#define CROWN_PURSE_SEED_PER_PLAYER 35

#define ROYAL_CUSTOM_VOLUME_BASE 2500
#define ROYAL_CUSTOM_VOLUME_PER_POP 50 // Only count roundstart
#define ROYAL_CUSTOM_DEFAULT_MARGIN 50

#define ESTATE_STARTER_BONUS 30


#define TREASURY_NORMAL 0
#define TREASURY_IN_ARREARS 1
#define TREASURY_BANKRUPTCY 2
#define TREASURY_ARREARS_LOAN 1000

#define BANKRUPTCY_OPERATING_FLOOR 2500
#define BANKRUPTCY_DEBT_FLAT 5000
#define BANKRUPTCY_AUTOEXPORT_PERCENTAGE 0.25
#define AUTOEXPORT_DEFAULT_PERCENTAGE 0.6
#define BANKRUPTCY_CONCESSION_PICKS 3
#define BANKRUPTCY_RECOVERY_RESET 1500

#define BANKRUPTCY_SUSPENDED_DECREES list( \
	DECREE_NOC_PESTRA_COVENANT, \
	DECREE_GREAT_WRIT, \
	DECREE_GUILD_CHARTER_OF_ARMS, \
	DECREE_INDENTURE_OF_WAR, \
	DECREE_MAGNA_CARTA, \
	DECREE_OTAVAN_ACCORDS, \
	DECREE_ZENITSTADT_CONCORDAT, \
)

#define ATC_LOAN_MIN_AMOUNT 500
#define ATC_LOAN_MAX_AMOUNT 1500
#define ATC_LOAN_CLOSED_DAY 5
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

#define POLL_LEVY_CAT_NOBLE "poll_noble"
#define POLL_LEVY_CAT_CLERGY "poll_clergy"
#define POLL_LEVY_CAT_INQUISITION "poll_inquisition"
#define POLL_LEVY_CAT_COURTIER "poll_courtier"
#define POLL_LEVY_CAT_GARRISON "poll_garrison"
#define POLL_LEVY_CAT_GUILDS "poll_guilds"
#define POLL_LEVY_CAT_MERCHANT "poll_merchant"
#define POLL_LEVY_CAT_BURGHER "poll_burgher"
#define POLL_LEVY_CAT_SCHOLAR "poll_scholar"
#define POLL_LEVY_CAT_ADVENTURER "poll_adventurer"
#define POLL_LEVY_CAT_MERCENARY "poll_mercenary"
#define POLL_LEVY_CAT_PEASANT "poll_peasant"

#define POLL_LEVY_CLASS_ORDER list( \
	POLL_LEVY_CAT_NOBLE, \
	POLL_LEVY_CAT_CLERGY, \
	POLL_LEVY_CAT_INQUISITION, \
	POLL_LEVY_CAT_COURTIER, \
	POLL_LEVY_CAT_GARRISON, \
	POLL_LEVY_CAT_GUILDS, \
	POLL_LEVY_CAT_MERCHANT, \
	POLL_LEVY_CAT_BURGHER, \
	POLL_LEVY_CAT_SCHOLAR, \
	POLL_LEVY_CAT_ADVENTURER, \
	POLL_LEVY_CAT_MERCENARY, \
	POLL_LEVY_CAT_PEASANT, \
)

#define POLL_LEVY_SCHOLAR_JOBS list("Court Magician", "Archivist", "Magicians Associate", "Head Physician", "Apothecary")

// Minus principal in circulation (They are meant to issue loans at roundstart)
#define CHURCH_RESERVE_FLOOR 1000

#define ALL_FUND_IDS list("crown", "church", "merchant", "bathhouse", "innkeeper")
#define PATRONAGE_FUND_IDS list("merchant", "bathhouse", "church")

#define CONCORDAT_TITHE_RATE 0.05
#define BATHHOUSE_VAULT_TITHE_RATE 0.20
#define BATHHOUSE_BRASSFACE_TITHE_RATE 0.10
#define BATHHOUSE_ORDINANCE_TOGGLE_COOLDOWN (30 MINUTES)

// Roundstart seeds for non-Crown faction funds.
#define CHURCH_FUND_SEED 1000
#define MERCHANT_FUND_SEED 500
#define BATHHOUSE_FUND_SEED 500
#define INNKEEPER_FUND_SEED 0

#define INNKEEPER_BASH_FLOOR 300
#define INNKEEPER_LUMP_PAYOUT 50

#define PATRON_CAP_MERCHANT 5
#define PATRON_CAP_BATHHOUSE 5
#define PATRON_CAP_CHURCH 20

#define PATRONAGE_WRIT_COOLDOWN (30 SECONDS)

#define CHARGE_CAP_FLAT 100
#define CHARGE_CAP_CHARTER 50

#define POLL_LEVY_FIRST_DAY 2
#define POLL_LEVY_MAX_PER_ROUND 2
#define POLL_LEVY_MIN_GAP_DAYS 1
#define POLL_LEVY_REASON_MIN 50
#define POLL_LEVY_REASON_MAX 300
#define POLL_LEVY_PROTECTED_BALANCE 30
#define POLL_LEVY_LATEJOIN_GRACE (30 MINUTES)

#define GUILD_CHARTER_OF_ARMS_PLEDGE_BONUS 100
#define RESIDENCY_PRINT_COOLDOWN (1 MINUTES)

/// Default daily withdrawal cap for Bathhouse agents drawing from the bathhouse fund.
#define BATHHOUSE_AGENT_DAILY_WITHDRAW_DEFAULT 50
/// Default daily withdrawal cap for Bathhouse workers drawing from the bathhouse fund.
#define BATHHOUSE_WORKER_DAILY_WITHDRAW_DEFAULT 50
