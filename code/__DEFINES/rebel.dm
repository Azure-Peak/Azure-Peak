/// How many rebellion leaders the roundstart event tries to seat
#define REBELLION_ROUNDSTART_LEADERS 2
/// How many roundstart converts spawn alongside the leaders
#define REBELLION_ROUNDSTART_CONVERTS 4
/// Total roundstart rebellion slots
#define REBELLION_ROUNDSTART_TOTAL (REBELLION_ROUNDSTART_LEADERS + REBELLION_ROUNDSTART_CONVERTS)
/// Delay between a leader declaring open rebellion and every convert being forced into the open
#define REBELLION_AUTO_UPRISE_TIME 1 MINUTES
/// Mammon minted when the ruler themselves is discarded
#define REBELLION_PAYOUT_RULER 1000
/// Mammon range minted when a noble is discarded
#define REBELLION_PAYOUT_NOBLE_LOW 200
#define REBELLION_PAYOUT_NOBLE_HIGH 400
/// Mammon range minted when a courtier is discarded
#define REBELLION_PAYOUT_COURTIER_LOW 100
#define REBELLION_PAYOUT_COURTIER_HIGH 200
/// Mammon minted for usurping a rebel leader
#define REBELLION_PAYOUT_USURP 1000
/// Mammon needed to become the new leader from a dead leader
#define REBELLION_CLAIM_COST 200
/// Pick weight. Burghers have a higher chance to be leaders.
#define REBELLION_CLASS_BIAS 3
/// Triumphs paid at roundend when the rebellion wins
#define REBELLION_TRIUMPH_CONVERT 3
#define REBELLION_TRIUMPH_LEADER 6
/// Mammon (in carried coin) a leader pays to spread word to every rebel in the realm
#define REBELLION_WORD_COST 300
/// Mammon given to rebel leaders
#define REBELLION_LEADER_FUNDS 150
