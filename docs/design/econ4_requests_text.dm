// Requests - code/modules/roguetown/roguestock/standing_order.dm (single good request title, no description)

var/request_name = "[REGION] - [GOOD]"

// Requests - tgui/packages/tgui/interfaces/StewardTrade/OrdersView.tsx

var/order_item_line = "[count] [good] ([royal stock]) at [unit pay]m"
var/deliver_part_button = "Deliver part - [payout]m"

// Requests - code/controllers/subsystem/rogue/economy/economy.dm (Steward chat)

var/deliver_none = "You have none of the goods for this order."
var/deliver_part = "Part delivered: [payout]m paid to the Treasury."
var/deliver_full = "Order fulfilled: [payout]m paid to the Treasury."

// Requests - code/modules/roguetown/roguemachine/steward/steward_trade_tgui.dm (announcement)

var/announce_part = "Standing Order part delivered: [name] (+[payout]m)[quality]."
var/announce_full = "Standing Order fulfilled: [name] (+[payout]m)[quality]."

// Petitions - code/modules/roguetown/roguestock/steward_petition.dm

var/petition_region_full = "[region] already has an order"
var/petition_materials_desc = "Artificery."
var/petition_luxuries_desc = "Court finery, jewelry and name day tributes."
var/petition_alchemy_desc = "Finished potions and prosthetics."
var/petition_masterwork_desc = "Showpiece commissions - artificed panoply, tournament arms, hunt trophies."

// Avisa - tgui/packages/tgui/interfaces/Noticeboard/AvisaSections/TradeOrdersSection.tsx (help panel)

var/avisa_partial_help = "Orders can be delivered in parts. Each unit is paid in full, and the rest stays open until the order expires."

// Guide - code/modules/crafting/recipe_books/book_entries/treasury/realm_chapters.dm (Of Standing Orders)

var/guide_regular = "Regular - rolled each dawn, more in a busier realm. Most ask for a single good the region needs. They last a couple of days and pay well above the market price."
var/guide_partial = "Partial delivery: an order can be delivered in parts. Each unit is paid in full, and the rest stays open until the order expires."
var/guide_limits = "Each region holds one order at a time, and the realm caps how many stand at once. Blockaded regions can hold orders but cannot be delivered to."
