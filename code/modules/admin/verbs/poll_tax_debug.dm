/client/proc/cmd_admin_poll_tax_tick()
	set category = "Debug"
	set name = "Poll Tax Tick"
	set desc = "Run SStreasury.tick_poll_tax() once for manual testing."

	if(!check_rights(R_DEBUG))
		return
	GLOB.dayspassed++
	SStreasury.tick_poll_tax()
	message_admins(span_adminnotice("[key_name_admin(usr)] ran a Poll Tax tick. Day is now [GLOB.dayspassed]."))

/client/proc/cmd_admin_poll_tax_status()
	set category = "Debug"
	set name = "Poll Tax Status"
	set desc = "Dump Poll Tax state for every account holder."

	if(!check_rights(R_DEBUG))
		return
	var/list/lines = list("<b>Poll Tax status (day [GLOB.dayspassed])</b>")
	lines += "Rates: [json_encode(SStreasury.poll_tax_rates)]"
	for(var/key in SStreasury.bank_accounts)
		var/datum/fund/account = SStreasury.bank_accounts[key]
		if(!account)
			continue
		var/mob/living/owner = account.get_owner()
		if(!owner)
			continue
		var/category = SStreasury.get_poll_tax_category(owner)
		var/rate = SStreasury.get_poll_tax_rate_for(owner, category)
		var/exempt = SStreasury.is_poll_tax_charter_exempt(owner, category)
		var/grace = SStreasury.poll_tax_days_paid[owner] || 0
		var/owed = SStreasury.poll_tax_owed[owner] || 0
		var/overdue = SStreasury.poll_tax_debt_days[owner] || 0
		lines += "[owner.real_name] ([owner.job]) cat=[category] rate=[rate] exempt=[exempt] grace=[grace] owed=[owed] overdue=[overdue] balance=[account.balance]"
	to_chat(usr, jointext(lines, "<br>"))
