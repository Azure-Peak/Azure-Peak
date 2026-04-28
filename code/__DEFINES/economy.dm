#define TRADE_CATEGORY_BASIC_MINERAL "basic_mineral"
#define TRADE_CATEGORY_RARE_METAL "rare_metal"
#define TRADE_CATEGORY_PRECIOUS_METAL "precious_metal"
#define TRADE_CATEGORY_INTERMEDIARY "intermediary"
#define TRADE_CATEGORY_GRAIN "grain"
#define TRADE_CATEGORY_FRUIT "fruit"
#define TRADE_CATEGORY_VEGETABLE "vegetable"
#define TRADE_CATEGORY_ANIMAL "animal"
#define TRADE_CATEGORY_SEAFOOD "seafood"
#define TRADE_CATEGORY_CLOTH "cloth"
#define TRADE_CATEGORY_ARTISAN "artisan"
#define TRADE_CATEGORY_GEM_COMMON "gem_common"
#define TRADE_CATEGORY_GEM_RARE "gem_rare"
#define TRADE_CATEGORY_GEM_LEGENDARY "gem_legendary"
#define TRADE_CATEGORY_POTION "potion"

#define TRADE_BEHAVIOR_RAW "raw"
#define TRADE_BEHAVIOR_INTERMEDIARY "intermediary"
#define TRADE_BEHAVIOR_GEM "gem"
// Finished equipment. Fulfilled via warehouse tiles, not stockpile deposits.
#define TRADE_BEHAVIOR_EQUIPMENT "equipment"
// Finished potions. Fulfilled via warehouse tiles by reagent + volume, any container.
#define TRADE_BEHAVIOR_POTION "potion"

#define TRADE_REGION_KINGSFIELD "kingsfield"
#define TRADE_REGION_ROSAWOOD "rosawood"
#define TRADE_REGION_ROCKHILL "rockhill"
#define TRADE_REGION_DAFTSMARCH "daftsmarch"
#define TRADE_REGION_BLACKHOLT "blackholt"
#define TRADE_REGION_SALTWICK "saltwick"
#define TRADE_REGION_BLEAKCOAST "bleakcoast"
#define TRADE_REGION_NORTHFORT "northfort"
#define TRADE_REGION_HEARTFELT "heartfelt"
#define TRADE_REGION_HAGENWALD "hagenwald"

#define STANDING_ORDER_DURATION 2
// Urgent orders (spawned by shortage events) pay a premium but expire the very next dawn,
// so "urgent" actually bites — the Crown is not patient when a shortage is on.
#define URGENT_ORDER_DURATION 1

// Order count is NOT pop-scaled. Each order's size scales with pop instead via
// STANDING_ORDER_POP_SCALE_PER_PLAYER - this avoids drowning a single Steward in
// order-count triage while still proportioning Crown throughput to the player economy.
#define STANDING_ORDERS_BASE_PER_DAY 4
#define STANDING_ORDERS_PER_ACTIVE_PLAYER 0.05
#define STANDING_ORDERS_MAX_PER_DAY 13
#define STANDING_ORDERS_POOL_CAP 13
#define STANDING_ORDERS_MAX_PER_REGION 3
// Cap on simultaneous urgent (shortage-spawned) orders in the pool. Shortage events
// past this cap still apply their price_mod but don't spawn an urgent quest, leaving
// pool slots for regular standing orders that drive towner/secondary-role play.
#define STANDING_ORDERS_MAX_URGENT 2

// Additive payout bonuses over base_price. Regular standing orders pay base * (1 + BASE_BONUS)
// per unit; urgent orders pay base * (1 + BASE_BONUS + URGENT_EXTRA) per unit. No multiplier
// stacking. Event price_mod applies on top as a separate multiplicand.
#define STANDING_ORDER_BASE_BONUS 0.75
#define URGENT_ORDER_EXTRA_BONUS 0.75

// Standing order size scales with active player count so the Crown's throughput matches
// the player economy. Size scales (not count) - a single Steward can only triage so many
// orders per day, but each one getting bigger keeps the scope per action manageable.
// Pop scaling for standing-order size is disabled. Order quantities stay at the template's
// rolled face value regardless of player count - a full round was scaling to 100+ stone /
// 50+ wood orders that Stewards couldn't reasonably coordinate and outsiders wouldn't engage
// with. The COUNT scalar (STANDING_ORDERS_PER_ACTIVE_PLAYER) still applies; more players
// still get more distinct orders, just not each one inflated.
#define STANDING_ORDER_POP_SCALE_PER_PLAYER 0
#define STANDING_ORDER_POP_SCALE_MAX 3.0

// Per-unit price behavior past a region's daily production/demand.
// Import escalates: import_unit = base_price * (1 + overshoot * slope) * global_price_mod * blockade_mult.
//   Overshoot = how far past the region's daily PRODUCTION the Crown is buying. Scarcity pressure.
// Export decays:  export_unit = base_price * global_price_mod * (1 / (1 + overshoot * slope))
//                                * (1 - IMPORT_EXPORT_SPREAD) * blockade_mult, floored at low_price.
//   Overshoot = how far past the region's daily DEMAND the Crown is selling. Oversupply pressure.
// The spread + oversupply decay together guarantee buy-then-sell is always a loss. Crown profits
// only from held stockpile accumulated through player deposits, shortage-held inventory, or
// standing order bonuses.
#define TRADE_ESCALATION_SLOPE 1.0
#define IMPORT_EXPORT_SPREAD 0.25

#define TRADE_MAX_BULK_UNITS 50

// Blockaded regions remain tradeable but at punitive rates.
// Import costs double, export revenue halves. Blockade-running is a desperate-times option.
#define BLOCKADE_IMPORT_MULT 2.0
#define BLOCKADE_EXPORT_MULT 0.5

#define TRADE_STOCKPILE_BUY_DISCOUNT 0.75

#define STOCKPILE_AUTO_LIMIT_DAYS 2
#define STOCKPILE_LIMIT_MIN 5

// Each subsequent import of the same crown_import in one day adds this much to the price.
// Resets when SSeconomy daily tick fires.
#define CROWN_IMPORT_ELASTICITY 0.1

#define REGION_POP_SCALE_PER_PLAYER 0.025
#define REGION_POP_SCALE_MAX 3.0

// Economic events: shortage/oversupply surges that bend trade_good.global_price_mod
// for a fixed window. Shortages also spawn a single bonus-pay urgent standing order.
#define ECON_EVENT_DURATION 2
#define ECON_EVENT_SHORTAGE "shortage"
#define ECON_EVENT_OVERSUPPLY "oversupply"
#define ECON_EVENT_NARRATIVE "narrative"
#define ECON_EVENT_TARGET_COUNT 5
#define ECON_EVENT_ROUNDSTART_COUNT 3

// Banditry drain — TEMPORARY consequence for neglected threat regions, per region per
// daily tick. Drain = base + per_player * active_pop. Drain stops cutting the purse
// below BANDITRY_DEBT_FLOOR; remainder accrues as debt that skims all future treasury
// inflow until paid. Personal accounts and stockpile balances are never touched directly
// — only inflow into the discretionary fund is skimmed.
// Why flat+pop over percentage: percentage created a perverse incentive to drain the
// keep into personal accounts before the tick fired. Flat+pop makes hoarding strictly
// worse (debt accrues regardless and eats anything you try to mint back in later).
// TODO: Stand-in for proper raid/siege mechanics. Delete this system when raids ship.
#define BANDITRY_DRAIN_DANGEROUS_FLAT 40
#define BANDITRY_DRAIN_BLEAK_FLAT 80
#define BANDITRY_DRAIN_DANGEROUS_PER_PLAYER 1
#define BANDITRY_DRAIN_BLEAK_PER_PLAYER 2
// Floor sits 500m above the autoimport purse-floor (AUTO_IMPORT_PURSE_FLOOR_DEFAULT,
// 1000m) so the stockpile can keep auto-trading even when banditry has pushed the
// treasury down to its floor.
#define BANDITRY_DEBT_FLOOR 1500

// Blockades
#define BLOCKADE_ROUNDSTART_COUNT_MIN 2
#define BLOCKADE_ROUNDSTART_COUNT_MAX 3
#define BLOCKADE_RECLEAR_COOLDOWN 1
#define BLOCKADE_SCROLL_PLEDGE_COST 500
#define BLOCKADE_SCROLL_REWARD 500
/// Steward-selectable "Bonus Pay" sweetener on defense commissions and blockade writs.
/// Tri-state: NONE (1.0x), LIGHT (1.25x), FULL (1.5x). The Steward picks a level per
/// commission; LIGHT lets a budget-constrained Steward nudge a contract without a full
/// 50% draft increase. Multiplies both the draft cost and the quest's reward by the
/// selected multiplier. Not available on Requests, which have no reward to sweeten.
#define COMMISSION_BONUS_PAY_NONE 0
#define COMMISSION_BONUS_PAY_LIGHT 1
#define COMMISSION_BONUS_PAY_FULL 2
#define COMMISSION_BONUS_PAY_LIGHT_MULT 1.25
#define COMMISSION_BONUS_PAY_MULT 1.5
#define BLOCKADE_FELLOWSHIP_REQUIREMENT 3
#define BLOCKADE_WAVE_TIMER_DS (10 MINUTES)
// Recall policy: the bearer gets BLOCKADE_RECALL_WINDOW_DS to reach the blockade.
// Only AFTER that elapsed time (and while still armed) may the Steward recall the writ.
// If nobody acts, BLOCKADE_ARM_TIMEOUT_DS is a backstop that auto-fails the writ.
#define BLOCKADE_ARM_TIMEOUT_DS (30 MINUTES)
#define BLOCKADE_RECALL_WINDOW_DS (15 MINUTES)
// Wave composition arrays in quest_blockade_defense.dm assume exactly 3 waves.
#define BLOCKADE_TOTAL_WAVES 3
#define BLOCKADE_WAVE_1_TP 72
#define BLOCKADE_WAVE_2_TP 72
#define BLOCKADE_WAVE_3_TP 104

// Steward petition for a standing order. Burns Burgher Pledge to roll a category-bound
// order in a chosen non-blockaded region. Petitioned orders pay PETITION_TAX_MULT of the
// natural payout - the trade hall shaves margin when it knows you needed it.
#define PETITIONS_PER_DAY 3
#define PETITION_TAX_MULT 0.80
#define PETITION_BLOCKADE_RECOVERY_DAYS 2

#define PETITION_CATEGORY_PROVISIONS "provisions"
#define PETITION_CATEGORY_MATERIALS "materials"
#define PETITION_CATEGORY_ARMS "arms"
#define PETITION_CATEGORY_LUXURIES "luxuries"
#define PETITION_CATEGORY_ALCHEMY "alchemy"
#define PETITION_CATEGORY_MASTERWORK "masterwork"

#define PETITION_COST_PROVISIONS 200
#define PETITION_COST_MATERIALS 250
#define PETITION_COST_ARMS 300
#define PETITION_COST_LUXURIES 350
#define PETITION_COST_ALCHEMY 350
#define PETITION_COST_MASTERWORK 400

