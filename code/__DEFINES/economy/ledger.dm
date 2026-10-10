// Double-entry bookkeeping for the Meister / Stewardry.
//
// Every posting is a balanced list of Dr/Cr legs against a chart of accounts. Accounts live in
// "books" (one per institution that holds funds). A book's own postings always balance within
// that book, so each institution can produce its own trial balance and statements.
//
// Account ids are "[book]_[key]". The standard keys exist in every book; the extras below
// are defined only where they mean something.

#define LEDGER_BOOK_CROWN "crown"
#define LEDGER_BOOK_PLEDGE "pledge"
#define LEDGER_BOOK_CHURCH "church"
#define LEDGER_BOOK_MERCHANT "merchant"
#define LEDGER_BOOK_BATHHOUSE "bathhouse"
#define LEDGER_BOOK_TAVERN "tavern"
#define LEDGER_BOOK_CITIZENS "citizens"

#define LEDGER_CLASS_ASSET "asset"
#define LEDGER_CLASS_LIABILITY "liability"
#define LEDGER_CLASS_EQUITY "equity"
#define LEDGER_CLASS_REVENUE "revenue"
#define LEDGER_CLASS_EXPENSE "expense"
#define LEDGER_CLASS_SUSPENSE "suspense"

// Standard keys, present in every book.
#define LEDGER_KEY_CASH "cash"
#define LEDGER_KEY_CAPITAL "capital"
#define LEDGER_KEY_INCOME "income"
#define LEDGER_KEY_EXPENSE "expense"
#define LEDGER_KEY_SUSP_IN "susp_in"
#define LEDGER_KEY_SUSP_OUT "susp_out"
#define LEDGER_KEY_LOANS_REC "loans_rec"
#define LEDGER_KEY_LOANS_PAY "loans_pay"
#define LEDGER_KEY_INTEREST_INC "interest_inc"
#define LEDGER_KEY_INTEREST_EXP "interest_exp"
#define LEDGER_KEY_GRANTS "grants"

#define LEDGER_DEFAULT_MAX_LEGS 12

// Counterparty shown when money enters or leaves with no fund on that side and no better name to give it.
#define LEDGER_REALM_LABEL "The Realm"

// --- Crown book: assets ---
#define LEDGER_CROWN_CASH "crown_cash"
#define LEDGER_CROWN_LOANS_REC "crown_loans_rec"
#define LEDGER_CROWN_INVENTORY "crown_inventory"
#define LEDGER_CROWN_POLL_RECEIVABLE "crown_poll_receivable"
#define LEDGER_CROWN_INTEREST_RECEIVABLE "crown_interest_receivable"
// --- Crown book: liabilities ---
#define LEDGER_CROWN_POLL_DEFERRED "crown_poll_deferred"
#define LEDGER_CROWN_ARREARS_ADVANCE "crown_arrears_advance"
#define LEDGER_CROWN_ATC_LOAN "crown_atc_loan"
#define LEDGER_CROWN_SEQUESTRATION_DEBT "crown_sequestration_debt"
#define LEDGER_CROWN_BANDITRY_DEBT "crown_banditry_debt"
// --- Crown book: equity ---
#define LEDGER_CROWN_CAPITAL "crown_capital"
#define LEDGER_CROWN_GRANTS "crown_grants"
// --- Crown book: revenue ---
#define LEDGER_CROWN_REV_CONTRACT_LEVY "crown_rev_contract_levy"
#define LEDGER_CROWN_REV_HEADEATER_LEVY "crown_rev_headeater_levy"
#define LEDGER_CROWN_REV_IMPORT_TARIFF "crown_rev_import_tariff"
#define LEDGER_CROWN_REV_EXPORT_DUTY "crown_rev_export_duty"
#define LEDGER_CROWN_REV_SPOILS "crown_rev_spoils"
#define LEDGER_CROWN_REV_FINES "crown_rev_fines"
#define LEDGER_CROWN_REV_POLL_TAX "crown_rev_poll_tax"
#define LEDGER_CROWN_REV_EXPORT_SALES "crown_rev_export_sales"
#define LEDGER_CROWN_REV_STANDING_ORDERS "crown_rev_standing_orders"
#define LEDGER_CROWN_REV_STOCKPILE_SALES "crown_rev_stockpile_sales"
#define LEDGER_CROWN_REV_QUALITY "crown_rev_quality"
#define LEDGER_CROWN_REV_RURAL "crown_rev_rural"
#define LEDGER_CROWN_REV_BLOCKADE "crown_rev_blockade"
#define LEDGER_CROWN_REV_MAIL "crown_rev_mail"
#define LEDGER_CROWN_REV_REFUNDS "crown_rev_refunds"
#define LEDGER_CROWN_INTEREST_INC "crown_interest_inc"
#define LEDGER_CROWN_REV_OTHER "crown_income"
// --- Crown book: expenses ---
#define LEDGER_CROWN_EXP_WAGES "crown_exp_wages"
#define LEDGER_CROWN_EXP_IMPORTS "crown_exp_imports"
#define LEDGER_CROWN_EXP_POLL_SUBSIDY "crown_exp_poll_subsidy"
#define LEDGER_CROWN_EXP_BANDITRY "crown_exp_banditry"
#define LEDGER_CROWN_EXP_CONTRACTS "crown_exp_contracts"
#define LEDGER_CROWN_EXP_TITHE "crown_exp_tithe"
#define LEDGER_CROWN_EXP_WITHDRAWALS "crown_exp_withdrawals"
#define LEDGER_CROWN_EXP_GRANTS "crown_exp_grants"
#define LEDGER_CROWN_EXP_QUALITY "crown_exp_quality"
#define LEDGER_CROWN_EXP_SEQUESTRATION "crown_exp_sequestration"
#define LEDGER_CROWN_EXP_LOAN_LOSS "crown_exp_loan_loss"
#define LEDGER_CROWN_EXP_STOCKPILE "crown_exp_stockpile"
#define LEDGER_CROWN_EXP_INVENTORY_ADJ "crown_exp_inventory_adj"
#define LEDGER_CROWN_EXP_POLL_WRITEOFF "crown_exp_poll_writeoff"
#define LEDGER_CROWN_INTEREST_EXP "crown_interest_exp"
#define LEDGER_CROWN_EXP_OTHER "crown_expense"

// --- Citizens book (control account over every personal Meister account) ---
#define LEDGER_CITIZEN_CASH "citizens_cash"
#define LEDGER_CITIZEN_COIN_IN "citizens_coin_in"
#define LEDGER_CITIZEN_COIN_OUT "citizens_coin_out"
#define LEDGER_CITIZEN_WAGES "citizens_wages"
#define LEDGER_CITIZEN_TAXES "citizens_taxes"
#define LEDGER_CITIZEN_CONTRACTS "citizens_contracts"
#define LEDGER_CITIZEN_CONTRACT_PAID "citizens_contract_paid"
#define LEDGER_CITIZEN_SALES "citizens_sales"
#define LEDGER_CITIZEN_ESTATE "citizens_estate"
// Escrow holds only move money between two deposits; both sides post here so they net to nothing
// instead of inflating citizen receipts and payments.
#define LEDGER_CITIZEN_ESCROW "citizens_escrow"

// Money committed to commissions, present in every book except the Crown (which has its own
// Contract Outlay) and the citizens.
#define LEDGER_KEY_CONTRACTS "contracts"

// --- Other institutions ---
#define LEDGER_CHURCH_TITHE_IN "church_tithe_in"
#define LEDGER_MERCHANT_LEVY_IN "merchant_levy_in"
#define LEDGER_MERCHANT_MARGIN_IN "merchant_margin_in"
#define LEDGER_BATHHOUSE_MARGIN_IN "bathhouse_margin_in"
#define LEDGER_TAVERN_REFERRAL_IN "tavern_referral_in"
