// Caravans tab - tgui/packages/tgui/interfaces/StewardTrade/CaravansView.tsx

var/tab_label = "Caravans"
var/fleet_line = "[home] of [fleet] home · [out] en route, return in [minutes] minute(s)"
var/road_line = "[route]: [request] · [units] [good] · [region] tribute"
var/column_region = "Region"
var/column_request = "Request"
var/column_offer = "Offer"
var/column_tribute = "Tribute"
var/route_blockaded = "[count] blockaded"
var/route_loading = "Loading"
var/region_hover_blockaded = "Blockaded"
var/badge_shortage = "SHORTAGE"
var/badge_warehouse = "WAREHOUSE"
var/badge_petitioned = "PETITIONED"
var/row_request_line = "[count] [good] ([royal stock]) · [payout]m · [days]d left"
var/row_offer_line = "[units] [good] at [unit price]m · [total]m"
var/row_tribute_blockaded = "Blockaded"
var/row_tribute_sent = "Sent today"

// Caravan dock - bottom of the Caravans tab

var/dock_request_empty = "None"
var/dock_offer_empty = "None"
var/dock_request_title = "[region] · up to [count] [good]"
var/dock_request_title_many = "[region] · [count] goods"
var/dock_stock_line_many = "[count] [good]: Royal stock [royal stock] · Market [count] left at [first price]m to [last price]m each"
var/dock_request_terms = "[unit pay]m each · [days]d left"
var/dock_stock_line = "Royal stock [royal stock] · Market [count] left at [first price]m to [last price]m each"
var/dock_stock_market_closed = "Royal stock [royal stock] · Market closed"
var/dock_stock_market_sold_out = "Royal stock [royal stock] · Market sold out"
var/dock_stock_warehouse = "On the warehouse dock: [count]"
var/dock_fill_toggle = "Fill partial from Market"
var/dock_fill_hover_sequestered = "Locked under sequestration."
var/dock_fill_hover_covered = "Enough in royal stock."
var/dock_fill_hover_closed = "The market is closed."
var/dock_fill_hover_sold_out = "The Market is sold out."
var/dock_outcome = "[loaded] of [needed] loaded"
var/dock_outcome_partial = "[loaded] of [needed] loaded · [left] remaining"
var/dock_outcome_none = "You have none of the goods for this order."
var/dock_projection_request = "Payout ([count]) +[amount]m · Market ([count]) -[amount]m · Net [amount]m"
var/dock_zad_button = "Extend request - [cost]p"
var/dock_zad_hover = "Send a zad to extend the request by one dae."
var/dock_zad_hover_not_official = "Only Crown officials can send a zad."
var/dock_offer_title = "[region] · [units] [good]"
var/dock_offer_terms = "at [unit price]m · [total]m at send"
var/dock_offer_resale = "Market pays about [average price]m each"
var/dock_offer_resale_hover = "Market bid [first price]m falling to [last price]m as the stock fills"
var/dock_offer_closed = "The market is closed."
var/dock_projection_offer = "Sale ([units]) +[amount]m · Cost -[amount]m · Net [amount]m"
var/dock_tribute_label = "Tribute"
var/dock_tribute_empty = "None"
var/dock_tribute_resale = "Resale +[amount]m"
var/dock_projected_net = "Projected net [amount]m"
var/clear_button = "Clear"
var/send_button = "Send caravan"
var/send_note_route = "on [route]"
var/send_note_home = "[home] of [fleet] home"
var/send_note_none_home = "No caravans are ready."
var/send_note_nothing = "Nothing to deliver"

// Dispatches tab - tgui/packages/tgui/interfaces/StewardTrade/DispatchesView.tsx

var/dispatches_tab_label = "Dispatches"
var/dispatches_empty = "No dispatches."
var/events_header = "Active Economic Events"
var/events_empty = "None."
var/event_kind_shortage = "Shortage"
var/event_kind_glut = "Glut"
var/event_days_left = "[days]d left"
var/event_relief = "Relief: [progress] / [target] units delivered ([pct]%). Accepts: [goods]"
var/blockades_header = "Blockaded Regions"
var/brigands_header = "Projected Losses to Brigands"
var/brigands_total = "-[total]m next dawn"
var/brigands_debt = "Brigand Debt: [debt]m, skimmed from all inflow"
var/brigands_row = "[region] ([danger]) -[cost]m"
var/brigands_row_hover = "[base]m base, plus [per]m per active person for [pop] active people"
var/brigands_hoard = "Brigands are sitting on [hoard]m. When a hoard is recovered, the Crown taxes a share of it."

// Header - tgui/packages/tgui/interfaces/StewardTrade/SequestrationBanner.tsx

var/sequestration_label_hover = "Sealed under the ATC's mark"

// Caravans - code/modules/roguetown/roguemachine/steward/steward_trade_tgui.dm (send action)

var/send_order_gone = "That order is gone."
var/send_offer_gone = "That offer is gone."

// Caravans - code/controllers/subsystem/rogue/economy/caravans.dm (Steward chat on send)

var/caravan_sent = "A caravan sets out on [route]. It returns at dawn."
var/caravan_none_home = "No caravans are home."
var/caravan_empty = "The caravan has nothing to carry."
var/caravan_order_gone = "That order is gone."
var/caravan_order_off_route = "That order is not on this route."
var/caravan_order_blockaded = "[region] is blockaded. You can't deliver this order until the road is cleared or escorted."
var/caravan_no_goods = "You have none of the goods for this order."
var/caravan_offer_gone = "That offer is gone."
var/caravan_offer_off_route = "That offer is not on this route."
var/caravan_offer_blockaded = "[region] is blockaded. You can't take this offer until the road is cleared or escorted."
var/caravan_offer_poor = "The Treasury can't afford this. It has [balance]m and needs [cost]m."
var/caravan_fill_poor = "The Treasury can't afford this. It has [balance]m and needs [market cost plus offer cost]m."
var/caravan_fill_sequestered = "Trade controls are locked under sequestration. Petitions, taxes and fines still work."
var/caravan_fill_bought = "Bought [count] [good] from the market for [cost]m."
var/caravan_tribute_off_route = "[region] is not on this route."

// Tribute - code/modules/economy/regions/economic_region.dm (shown when a tribute can't be picked up)

var/tribute_none = "[region] sends no tribute."
var/tribute_blockaded = "[region] is blockaded. No tribute will come through until it is cleared."
var/tribute_already_sent = "[region] has already sent its tribute today."

// Guide - code/modules/crafting/recipe_books/book_entries/treasury/realm_chapters.dm (Of Standing Orders, Fulfillment)

var/guide_fulfillment = "Orders are delivered by caravan from the Nerve Master. A caravan carries one order, one offer and one region's tribute along a route, and returns at dawn. Stockpile goods leave the royal stockpile, and finished goods leave the warehouse dock. The payout goes into the Treasury."

// Avisa - tgui/packages/tgui/interfaces/Noticeboard/AvisaSections/TradeOrdersSection.tsx (help panel)

var/avisa_orders_help = "Standing orders are demands posted by the realm's regions. The Steward fills them by caravan from the Nerve Master."

// Escorts - tgui/packages/tgui/interfaces/StewardTrade/CaravansView.tsx (route header)

var/escort_button = "Escort [subroute] - [fee]m"
var/escort_active = "[subroute] escorted until dawn"
var/badge_half = "HALF"

// Escorts - code/controllers/subsystem/rogue/economy/caravans.dm (Steward chat, and the escort button hover)

var/escort_hired = "An escort is hired for [subroute] until dawn."
var/escort_not_blockaded = "That road is not blockaded."
var/escort_already = "That road already has an escort until dawn."
var/escort_poor = "The Treasury can't afford this. It has [balance]m and needs [fee]m."

// Guide - code/modules/crafting/recipe_books/book_entries/treasury/realm_chapters.dm (blockades)

var/guide_escort = "The Steward can hire an escort to get caravans through a blockaded road until dawn. The escort costs more the longer the blockade stands. Deals in a blockaded region are halved, and no tribute comes through."
