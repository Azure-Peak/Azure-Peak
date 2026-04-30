// Auto-import: Crown's Purse tops up selected goods each daily tick, reducing Steward
// micromanagement for tedious basics. Essentials below are opt-out by default; every
// other importable good is opt-in through the Steward's Auto-Import tab.

/// Essentials that auto-import by default. Steward can disable individually via the
/// Auto-Import tab. Pure consumables with stable prices and heavy ongoing demand.
#define AUTO_IMPORT_ESSENTIALS list(\
	TRADE_GOOD_COAL,\
	TRADE_GOOD_WOOD,\
	TRADE_GOOD_GRAIN,\
	TRADE_GOOD_IRON_ORE,\
	TRADE_GOOD_HIDE,\
	TRADE_GOOD_FAT\
)

/// Stockpile floor. If stockpile holds fewer than this many units of an auto-imported
/// good, the next daily tick tops it up by AUTO_IMPORT_BATCH.
#define AUTO_IMPORT_FLOOR 10

/// Units imported per daily tick per eligible good.
#define AUTO_IMPORT_BATCH 5

/// Per-unit price ceiling expressed as a multiple of the trade good's base_price.
/// If the last unit in the batch would cost more than base_price * this, the import
/// is skipped. Keeps shortage protection scaled to each good's intrinsic value instead
/// of a flat mammon cap that punishes high-value goods and wastes low-value ones.
#define AUTO_IMPORT_MAX_PRICE_MULT 2

/// Purse floor specifically for auto-import. Separate from stockpile_purchase_floor
/// so auto-import can be more conservative: auto-import will not spend if it would
/// drop the Purse below this value.
#define AUTO_IMPORT_PURSE_FLOOR_DEFAULT 1000

/// Days of auto-import history retained for the Recent Activity readout.
#define AUTO_IMPORT_HISTORY_DAYS 7
