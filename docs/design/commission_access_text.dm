// Contract Ledger examine - code/modules/roguetown/roguemachine/questing/contract_ledger/contract_ledger.dm (get_mechanics_examine)

var/ledger_mechanics_full = "The <b>[Steward and Grand Duke]</b> can issue defense scrolls here. Scrolls are paid from the Burgher Pledge or the Treasury. A scroll can also go out as an unpaid Request. If the Pledge runs short, the Treasury can make up the difference. A Regent ruling in the Grand Duke's absence can issue scrolls while they rule."
var/ledger_mechanics_key = "Anyone carrying the <b>Steward's key</b> can also issue defense scrolls, paid from the Burgher Pledge only."

// Steward's key examine - code/game/objects/items/rogueitems/keys.dm (/obj/item/roguekey/steward, get_mechanics_examine)

var/key_mechanics_commission = "Carry it to issue defense scrolls at the Contract Ledger, paid from the Burgher Pledge only."

// Commission refused - code/modules/roguetown/roguemachine/questing/contract_ledger/steward.dm (commission_defense_from_tgui, to the key holder)

var/key_funding_refused = "With the Steward's key, you can't use the Treasury or issue Requests."

// Commissions panel hovers - tgui/packages/tgui/interfaces/ContractLedgerSteward.tsx (the Alderman gets the same lines with "As Alderman")

var/key_hover_levy = "With the Steward's key, you can't waive the levy."
var/key_hover_treasury = "With the Steward's key, you can't pay from the Treasury."
var/key_hover_request = "With the Steward's key, you can't issue Requests."
