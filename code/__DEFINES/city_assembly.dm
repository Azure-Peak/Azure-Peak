// First Assembly session fires N minutes after GAME_STATE_PLAYING (not after Initialize).
// This guarantees an early election even on rounds where the first dawn is >20min away.
// Subsequent sessions resolve on the in-game day-tick (dawn).
#define ASSEMBLY_FIRST_SESSION_MINUTES 10

// Weights are stored internally as (display * 2) so fractional 1.5 becomes integer 3.
// Display in UI divides by 2. All thresholds and tallies operate on the doubled values.
#define ASSEMBLY_WEIGHT_NONE 0
#define ASSEMBLY_WEIGHT_1 2
#define ASSEMBLY_WEIGHT_1_5 3
#define ASSEMBLY_WEIGHT_2 4
#define ASSEMBLY_WEIGHT_4 8

// Removal motion floors (doubled weight + mob count).
#define ASSEMBLY_REMOVAL_WEIGHT_FLOOR 8   // i.e. 4 in displayed terms
#define ASSEMBLY_REMOVAL_MOB_FLOOR 2

// Session-wide quorum: minimum distinct voters across all motions. Below this, status quo.
#define ASSEMBLY_QUORUM_VOTERS 3

// Passing thresholds (percent of cast weight, integer percent).
#define ASSEMBLY_RECALL_THRESHOLD_PCT 50
#define ASSEMBLY_CENSURE_THRESHOLD_PCT 66

// Bracket vote NAE veto: if NAE weight / total cast weight >= this, authorization is vetoed.
#define ASSEMBLY_NAE_VETO_PCT 50
// Bracket vote win threshold (max-acceptable cumulative support).
#define ASSEMBLY_BRACKET_PASS_PCT 50

// Bracket option strings (stored as-is on ballots).
#define ASSEMBLY_BRACKET_NAE "NAE"
#define ASSEMBLY_BRACKET_ABSTAIN "ABSTAIN"

// Trade authority brackets, in mammon/day.
#define ASSEMBLY_TRADE_BRACKETS list(0, 150, 300, 450, 600, 750, 900)
// Defense authority brackets, in burgher pledge equivalent/day.
#define ASSEMBLY_DEFENSE_BRACKETS list(0, 250, 500, 750, 1000)
// Poll tax brackets, in mammon/payer (per levy).
#define ASSEMBLY_POLL_BRACKETS list(0, 5, 10, 15, 20)

// Poll-tax -> pledge fund magic multiplier. Intentional mint-knob.
#define ASSEMBLY_POLL_PLEDGE_MULTIPLIER 2

// Motion ids.
#define ASSEMBLY_MOTION_ELECTION "election"
#define ASSEMBLY_MOTION_TRADE_AUTH "trade_auth"
#define ASSEMBLY_MOTION_DEFENSE_AUTH "defense_auth"
#define ASSEMBLY_MOTION_POLL_TAX "poll_tax"
#define ASSEMBLY_MOTION_RECALL "recall"
#define ASSEMBLY_MOTION_CENSURE "censure"

// Ballot choice sentinels for single-option motions (recall, censure).
#define ASSEMBLY_YAE "YAE"
#define ASSEMBLY_NAY "NAY"
#define ASSEMBLY_ABS "ABSTAIN"

// Announcement titles.
#define ASSEMBLY_ANNOUNCE_TITLE "THE CITY ASSEMBLY"

// Session state.
#define ASSEMBLY_SESSION_PENDING "pending"
#define ASSEMBLY_SESSION_OPEN "open"
#define ASSEMBLY_SESSION_RESOLVED "resolved"

// Poll tax debt behavior on failure: if payer cannot afford, skip quietly (no trait/debt).
#define ASSEMBLY_POLL_SKIP_INSOLVENT TRUE
