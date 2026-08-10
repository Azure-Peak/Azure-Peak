#define TREASURY_FLOW_SALARY "Salary"
#define TREASURY_FLOW_WITHDRAWAL "Direct Withdrawal"
#define TREASURY_FLOW_UNAUTHORIZED "Unauthorized Withdrawal"
#define TREASURY_FLOW_TRANSFER "Treasury Transfer"
#define TREASURY_FLOW_SUBSIDY "Poll Subsidy"
#define TREASURY_FLOW_IMPORT "Crown Import"
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
	TREASURY_FLOW_BANDITRY,
	TREASURY_FLOW_LOAN_OUT,
	TREASURY_FLOW_MISC,
))

GLOBAL_LIST_EMPTY(treasury_expense_ledger)

/proc/treasury_role_of(mob/M)
	if(!M)
		return "Unknown"
	var/role = M.job
	return role ? role : "Unknown"

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
