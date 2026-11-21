// Requests - code/modules/roguetown/roguestock/standing_order.dm (single good request title, no description)

var/request_name = "[REGION] - [GOOD]"

// Requests - tgui/packages/tgui/interfaces/StewardTrade/CaravansView.tsx

var/order_item_line = "[count] [good] ([royal stock]) at [unit pay]m"

// Requests - code/modules/roguetown/roguestock/caravan.dm (announced at dawn when a caravan returns)

var/announce_part = "Standing Order part delivered: [name] (+[payout]m)[quality]."
var/announce_full = "Standing Order fulfilled: [name] (+[payout]m)[quality]."

// Extensions - tgui/packages/tgui/interfaces/StewardTrade/CaravansView.tsx

var/zad_button = "Send a zad - [cost]p"
var/zad_hover = "Send a zad to extend the request by one dae."
var/zad_hover_not_official = "Only Crown officials can send a zad."

// Extensions - code/modules/roguetown/roguestock/steward_petition.dm (blockers show as the button hover and in chat)

var/zad_sent = "A zad flies off. [order] holds another dae."
var/zad_refused = "No zad sent: [reason]."
var/zad_reason_gone = "the order is gone"
var/zad_reason_no_pledge = "the Burghers have not made their pledge yet"
var/zad_reason_poor = "not enough Burgher Pledge (need [cost]p)"
var/zad_reason_burn_failed = "the Burgher Pledge could not cover the cost"

// Extensions - code/modules/roguetown/roguemachine/steward/steward_trade_tgui.dm

var/zad_not_official_chat = "Only Crown officials can send a zad."

// Petitions - code/modules/roguetown/roguestock/steward_petition.dm

var/petition_region_full = "[region] already has an order"
var/petition_materials_desc = "Artificery."
var/petition_arms_desc = "Finished weapons and armor."
var/petition_luxuries_desc = "Court finery and jewelry."
var/petition_alchemy_desc = "Finished potions and prosthetics."
var/petition_masterwork_desc = "Showpiece commissions - artificed panoply, hunt trophies."

// Request kinds - code/modules/roguetown/roguestock/standing_order.dm (petition choices)

var/kind_arms = "Arms"
var/kind_heavy_armor = "Heavy Armor"
var/kind_light_armor = "Light Armor"
var/kind_potions = "Potions"
var/kind_prosthetics = "Prosthetics"
var/kind_artificery = "Artificery"
var/kind_panoply = "Artificed Panoply"
var/kind_finery = "Finery"
var/kind_jewelry = "Jewelry"
var/kind_scrolls = "Enchantment Scrolls"
var/kind_trophies = "Hunt Trophies"

// Avisa - tgui/packages/tgui/interfaces/Noticeboard/AvisaSections/TradeOrdersSection.tsx (help panel)

var/avisa_partial_help = "Orders can be delivered in parts. Each unit is paid in full, and the rest stays open until the order expires."

// Guide - code/modules/crafting/recipe_books/book_entries/treasury/realm_chapters.dm (Of Standing Orders)

var/guide_regular = "Regular - rolled each dawn, more the more players are active ."
var/guide_partial = "Partial delivery: an order can be delivered in parts. Each unit is paid in full is paid in full and an order stay open until it expires."
var/guide_extension = "Extension: Crown officials can spend Burgher Pledge at the Nerve Master to send a zad and keep an order open another dae."
var/guide_limits ="Each region will have one order at a time. Blockaded regions can have orders but cannot be delivered to."
