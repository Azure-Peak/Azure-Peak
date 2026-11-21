// Special Commission - tgui/packages/tgui/interfaces/StewardTrade/TabBar.tsx and CommissionsView.tsx

var/tab_label = "Commission"
var/header = "Special Commission"
var/lead_line = "Orders are delivered from the Royal Armoury [lead] minutes after a commission."
var/kit_left = "[stock] of [daily] left today"
var/commission_button = "Commission"
var/kit_content_line = "[Item] ×[count]"
var/local_header = "Local Commission"
var/local_lead_line = "Delivered to the warehouse at once."
var/orders_header = "On Order"
var/order_line = "[kit] arrives in [minutes] minutes"
var/orders_none = "Nothing on order."

// Special Commission - code/controllers/subsystem/rogue/economy/commissions.dm (Steward chat)

var/commission_sold_out = "The Royal Armoury takes no more [kit] commissions today."
var/commission_poor = "The Treasury can't afford this. It has [balance]m and needs [price]m."
var/commission_placed = "The Royal Armoury takes the commission. The [kit] arrives at the warehouse in [time]."

// Local Commission - code/controllers/subsystem/rogue/economy/commissions.dm (Steward chat)

var/local_sold_out = "None left today."
var/local_poor = "The Treasury can't afford this. It has [balance]m and needs [price]m."
var/local_placed = "The [item] is delivered to the warehouse."

// Special Commission - code/modules/banking/ledger.dm (ledger account)

var/ledger_account = "Royal Commissions"

// Special Commission - code/modules/roguetown/roguestock/royal_commissions.dm (kits)

var/crossbow_name = "Crossbow Crate"
var/crossbow_desc = "Three crossbows and three full quivers."
var/warden_name = "Warden Equipment Crate"
var/warden_desc = "Equipment kit for a warden."
var/manatarms_name = "Man-at-Arms Equipment Crate"
var/manatarms_desc = "Equipment kit for an armsman."
var/knight_name = "Knight Equipment Crate"
var/knight_desc = "Equipment kit for a dismounted knight."
var/caparison_name = "Royal Caparison"
var/caparison_desc = "A saiga caparison in ducal colours."
