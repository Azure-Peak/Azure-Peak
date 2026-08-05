#define CURRENCY_MAMMON "mammon"
#define CURRENCY_BURGHER_PLEDGE "burgher_pledge"

#define BURGHER_PLEDGE_BASE_REFILL 500
#define BURGHER_PLEDGE_PER_PLAYER 4
#define BURGHER_PLEDGE_CLAWBACK_MULTIPLIER 2
#define BURGHER_PLEDGE_ROUNDSTART_MULTIPLIER 2
#define BURGHER_PLEDGE_COST_TRIVIAL 38
#define BURGHER_PLEDGE_COST_STANDARD 75
#define BURGHER_PLEDGE_COST_MAJOR 150
#define COMMISSION_REQUESTS_PER_DAY 5

#define TAX_CATEGORY_CONTRACT_LEVY "contract levy"
#define TAX_CATEGORY_HEADEATER_LEVY "headeater levy"
#define TAX_CATEGORY_IMPORT_TARIFF "import tariff"
#define TAX_CATEGORY_EXPORT_DUTY "export duty"
#define TAX_CATEGORY_FINE "fine"

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

#define POLL_TAX_MAX_RATE 40
#define POLL_TAX_MAX_SUBSIDY 60
#define POLL_TAX_DEBT_DAYS_TO_DEBTOR 2

#define GOLDEN_BULL_POLL_CAP 20
#define NOC_PESTRA_POLL_CAP 10
#define GUILD_CHARTER_OF_ARMS_POLL_CAP 15
#define GUILD_CHARTER_OF_ARMS_PLEDGE_BONUS 100
#define POLL_TAX_ADVANCE_LOCKOUT (10 MINUTES)
#define POLL_TAX_MAX_ADVANCE_DAYS 7
#define POLL_TAX_ADVANCE_FALLBACK_RATE 10
