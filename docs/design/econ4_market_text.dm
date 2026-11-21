// Stockpile and vomitorium - tgui/packages/tgui/interfaces/Stockpile.tsx (Buy button hover)

var/buy_hover_next = "Next [count] at [price]m. After that, [next]m."
var/buy_hover_sells_out = "Last [count] at [price]m."
var/buy_hover_sold_out = "The market is out of stock."
var/buy_hover_subsidy = "Next [count] at [price]m. Paid from royal subsidy."

// Stockpile - tgui/packages/tgui/interfaces/Stockpile.tsx (Sell price hover)

var/sell_hover_next = "Next [count] at [price]m. After that, [next]m."

// Stockpile and vomitorium - tgui/packages/tgui/interfaces/Stockpile.tsx (buttons and labels)

var/buy_button = "Buy [price]m"
var/buy_button_sold_out = "Out of stock"
var/buy_button_closed = "Closed"
var/shortage_badge_hover = "Ends once enough is sold to the market."
var/bar_segment_hover = "[band]: [from] to [to] in stock, buy [price]m"
var/empty_category = "No stock in this category."
var/conditions_tab = "Conditions ([count])"
var/conditions_header = "Market Conditions ([count])"

// Stockpile and vomitorium - tgui/packages/tgui/interfaces/Stockpile.tsx (header)

var/stockpile_title = "Town Stockpile"
var/stockpile_subtitle = "Drop goods at the machine to sell them. Put coins in to buy."
var/coinpouch_label = "Coinpouch"
var/subsidy_label = "Royal Subsidy [amount]m"
var/subsidy_hover = "Roles with royal subsidy will pull from the royal stockpile, and then buy from the market using treasury money if the royal stock is empty, so long as there's enough fund above the treasury floor ([floor]m) to cover the cost. Selling goods will go directly into the royal stockpile instead of the market"
var/subsidy_treasury_low = "The Crown is broke"
var/market_dae_label = "Next market dae in [minutes] minute(s)"
var/market_dae_hover = "Every dae traders will arrive and adjust the stocks and price toward the norm, according to regional supply and demand. This will only apply on non-blockaded region"
var/refund_button = "Refund"
var/detailed_button = "Detailed"
var/compact_button = "Compact"

// Vomitorium - code/modules/roguetown/roguemachine/withdraw.dm

var/vomitorium_title = "Vomitorium"
var/vomitorium_subtitle = "Put in mammon, then withdraw goods from the local stockpile."
var/vomitorium_examine_1 = "Left-click with an open hand to open the vomitorium. Put in mammon to fund purchases, then buy goods from the local stockpile."
var/vomitorium_examine_2 = "The vomitorium does not buy goods. Take deposits to a stockpile instead."

// Stockpile - code/modules/roguetown/roguemachine/stockpile/stockpile.dm

var/stockpile_desc = "A magickal device connected to the city's trade network. Buy and sell goods with the market here."
var/stockpile_examine_1 = "Left-click with an open hand to see the stockpile. Put in mammon to buy goods from it."
var/stockpile_examine_2 = "Left-click the machine with an item to sell it into the stockpile. You're paid into your MEISTER account. The machine won't take your goods unless you have an account."
var/stockpile_examine_3 = "Right-clicking the machine will automatically load all adjacent items into the stockpile at once."
var/stockpile_examine_4 = "Goods sold here go into the market. Roles with royal subsidy sell into the royal stockpile instead."
var/stockpile_examine_5 = "Right-click to sell everything in front of the stockpile."
var/stockpile_no_account = "No account found for [name]. Submit your fingers to a Meister for inspection."
var/stockpile_not_accepted = "[item] isn't accepted here."
var/stockpile_bulk_selling = "Bulk selling in progress..."
var/stockpile_announce_bundle = "[count] units of [good] have been stockpiled."
var/stockpile_announce_single = "[good] has been stockpiled."

// Stockpile and vomitorium buying - code/modules/roguetown/roguemachine/stockpile/withdraw_tab.dm

var/withdraw_closed = "Not available."
var/withdraw_sold_out = "Out of stock."
var/withdraw_no_money = "You haven't put in enough mammon."
var/withdraw_royal_stock = "[machine] chitters and squeaks."
var/withdraw_subsidy_treasury = "[machine] chitters and squeaks. Paid from royal subsidy."

// Steward desk - tgui/packages/tgui/interfaces/StewardTrade/SequestrationBanner.tsx

var/sequestration_banner = "The Crown defaulted, so the ATC now collects the realm's revenues until the [debt]m debt is repaid. You can't trade with the market until then. Petitions, taxes and fines still work."

// Steward desk - tgui/packages/tgui/interfaces/StewardTrade.tsx (rural subsidy hover, predates this PR, not changed yet)

var/rural_subsidy_hover = "A modest stipend from the countryside manors, sent while the Steward's own hand is thin on the ground. It dwindles as the guilds and artisans fill their benches - once enough hands are at the forge, the loom, and the apothecary's counter to sustain trade themselves, the lands keep what they raise."

// Steward Market tab - tgui/packages/tgui/interfaces/StewardTrade/MarketView.tsx

var/steward_sell_prompt = "Sell how many [good] to the market? Royal stock: [count]."
var/steward_buy_prompt = "Buy how many [good] from the market? [left] left before it is out of stock. This is paid from the treasury."
var/steward_sell_button = "Sell to Market"
var/steward_sell_hover = "Sell royal stock to the market. The first sells for [price]m."
var/steward_sell_hover_closed = "The market is closed."
var/steward_buy_button = "Buy from Market"
var/steward_buy_hover = "Buy from the market into royal stock, paid by the Treasury. The first costs [price]m."
var/steward_buy_hover_closed = "The market is closed."
var/steward_buy_hover_sold_out = "The market is out of stock."

// Steward Market chat - code/controllers/subsystem/rogue/economy/economy.dm

var/market_sell_closed = "The market is closed."
var/market_sell_none = "There is no [good] in the royal stockpile."
var/market_sold = "Sold [count] [good] to the market for [amount]m."
var/market_buy_closed = "The market is closed."
var/market_buy_sold_out = "[good] is out of stock."
var/market_buy_no_money = "The Treasury can't afford this. It has [balance]m and needs [cost]m."
var/market_bought = "Bought [count] [good] from the market for [cost]m."

// Guide - code/modules/crafting/recipe_books/book_entries/treasury/general_chapters.dm (supply chapter)

var/guide_shortage_relief = "A shortage ends early once enough of the affected goods are sold to the market, counted by value. Every sale to the market counts, and the shortage badge shows how much is still needed. When it ends, prices return to normal and SCOM announces the end of the shortage."
var/guide_market_scroll = "The Market Scroll at the Nerve Master shows live market prices."

// Shortage relief - tgui/packages/tgui/interfaces/Stockpile.tsx (shortage badge) and StewardTrade/DispatchesView.tsx

var/stockpile_shortage_badge = "SHORTAGE ([sold]m / [needed]m)"
var/dispatch_relief_line = "Relief: [sold]m / [needed]m sold ([pct]%). Accepts: [goods]"
