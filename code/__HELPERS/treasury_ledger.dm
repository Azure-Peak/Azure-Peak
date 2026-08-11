#define TREASURY_FLOW_SALARY "Salary"
#define TREASURY_FLOW_WITHDRAWAL "Direct Withdrawal"
#define TREASURY_FLOW_UNAUTHORIZED "Unauthorized Withdrawal"
#define TREASURY_FLOW_TRANSFER "Treasury Transfer"
#define TREASURY_FLOW_SUBSIDY "Poll Subsidy"
#define TREASURY_FLOW_IMPORT "Crown Import"
#define TREASURY_FLOW_CONTRACT "Contract Commissions"
#define TREASURY_FLOW_TITHE "Church Tithe"
#define TREASURY_FLOW_BANDITRY "Banditry Losses"
#define TREASURY_FLOW_LOAN_OUT "Loan Issued"
#define TREASURY_FLOW_LOAN_IN "Loan Repaid"
#define TREASURY_FLOW_MISC "Miscellaneous"

GLOBAL_LIST_INIT(treasury_flow_order, list(
	TREASURY_FLOW_SALARY,
	TREASURY_FLOW_WITHDRAWAL,
	TREASURY_FLOW_UNAUTHORIZED,
	TREASURY_FLOW_TRANSFER,
	TREASURY_FLOW_SUBSIDY,
	TREASURY_FLOW_IMPORT,
	TREASURY_FLOW_CONTRACT,
	TREASURY_FLOW_TITHE,
	TREASURY_FLOW_BANDITRY,
	TREASURY_FLOW_LOAN_OUT,
	TREASURY_FLOW_MISC,
))

GLOBAL_LIST_EMPTY(treasury_expense_ledger)
GLOBAL_VAR_INIT(treasury_inflow_total, 0)
GLOBAL_VAR_INIT(treasury_outflow_total, 0)

/proc/record_purse_inflow(amount)
	if(amount > 0)
		GLOB.treasury_inflow_total += amount

/proc/record_purse_outflow(amount)
	if(amount > 0)
		GLOB.treasury_outflow_total += amount

/proc/treasury_role_of(mob/M)
	if(!M)
		return "Unknown"
	var/role = M.job
	return role ? role : "Unknown"

/proc/total_treasury_expenses()
	var/total = 0
	for(var/mechanism in GLOB.treasury_expense_ledger)
		var/list/by_role = GLOB.treasury_expense_ledger[mechanism]
		for(var/role in by_role)
			total += by_role[role]
	return total

/proc/cmp_treasury_role_desc(list/a, list/b)
	return b["amount"] - a["amount"]

/proc/record_treasury_expense(mechanism, role, amount)
	if(!mechanism || amount <= 0)
		return
	if(!role)
		role = "Unknown"
	var/list/bucket = GLOB.treasury_expense_ledger[mechanism]
	if(!bucket)
		bucket = list()
		GLOB.treasury_expense_ledger[mechanism] = bucket
	bucket[role] = (bucket[role] || 0) + amount

/proc/record_treasury_payout(mob/actor, mob/recipient, amount, is_salary = FALSE)
	if(amount <= 0)
		return
	var/role = treasury_role_of(recipient)
	if(is_salary)
		record_treasury_expense(TREASURY_FLOW_SALARY, role, amount)
		return
	if(actor && actor == recipient)
		record_treasury_expense(has_fiscal_authority(actor) ? TREASURY_FLOW_WITHDRAWAL : TREASURY_FLOW_UNAUTHORIZED, role, amount)
		return
	if(actor && !has_fiscal_authority(actor))
		record_treasury_expense(TREASURY_FLOW_UNAUTHORIZED, treasury_role_of(actor), amount)
		return
	record_treasury_expense(TREASURY_FLOW_TRANSFER, role, amount)
