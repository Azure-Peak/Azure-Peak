/datum/withdraw_tab
	var/stockpile_index = -1
	var/budget = 0
	var/compact = TRUE
	var/current_category = "Raw Materials"
	var/list/categories = list("Raw Materials", "Fruit", "Vegetable", "Animal","Seafood")
	var/obj/structure/roguemachine/parent_structure = null

/datum/withdraw_tab/New(stockpile_param, obj/structure/roguemachine/structure_param)
	. = ..()
	stockpile_index = stockpile_param
	parent_structure = structure_param

/datum/withdraw_tab/proc/get_contents(title, show_back)
	var/contents = "<center>[title]<BR>"
	if(show_back)
		contents += "<a href='?src=[REF(parent_structure)];navigate=directory'>(back)</a><BR>"

	contents += "--------------<BR>"
	contents += "<a href='?src=[REF(parent_structure)];change=1'>Stored Mammon: [budget]</a><BR>"
	contents += "<a href='?src=[REF(parent_structure)];compact=1'>Compact Mode: [compact ? "ENABLED" : "DISABLED"]</a></center><BR>"
	var/selection = "Categories: "
	for(var/category in categories)
		if(category == current_category)
			selection += "<b>[current_category]</b> "
		else
			selection += "<a href='?src=[REF(parent_structure)];changecat=[category]'>[category]</a> "
	contents += selection + "<BR>"
	contents += "--------------<BR>"

	if(compact)
		for(var/datum/roguestock/stockpile/A in SStreasury.stockpile_datums)
			if(A.category != current_category)
				continue
			var/remote_stockpile = stockpile_index == 1 ? 2 : 1
			if(!A.withdraw_disabled)
				contents += "<b>[A.name] (Max: [A.stockpile_limit]):</b> <a href='?src=[REF(parent_structure)];withdraw=[REF(A)]'>LCL: [A.held_items[stockpile_index]] at [A.withdraw_price]m</a> /"
				contents += "<a href='?src=[REF(parent_structure)];withdraw=[REF(A)];remote=1'>RMT: [A.held_items[remote_stockpile]] at [A.withdraw_price+A.transport_fee]m</a><BR>"

			else
				contents += "<b>[A.name]:</b> Withdrawing Disabled..."

	else
		for(var/datum/roguestock/stockpile/A in SStreasury.stockpile_datums)
			if(A.category != current_category)
				continue
			contents += "[A.name]<BR>"
			contents += "[A.desc]<BR>"
			contents += "Stockpiled Amount (Local): [A.held_items[stockpile_index]]<BR>"
			var/remote_stockpile = stockpile_index == 1 ? 2 : 1
			contents += "Stockpiled Amount (Remote): [A.held_items[remote_stockpile]]<BR>"
			if(!A.withdraw_disabled)
				contents += "<a href='?src=[REF(parent_structure)];withdraw=[REF(A)]'>\[Withdraw Local ([A.withdraw_price])\] </a>"
				contents += "<a href='?src=[REF(parent_structure)];withdraw=[REF(A)];remote=1'>\[Withdraw Remote ([A.withdraw_price+A.transport_fee])\]</a><BR><BR>"
			else
				contents += "Withdrawing Disabled...<BR><BR>"

	return contents

/datum/withdraw_tab/proc/perform_action(href, href_list)
	if(href_list["withdraw"])
		var/datum/roguestock/D = locate(href_list["withdraw"]) in SStreasury.stockpile_datums

		var/remote = href_list["remote"]
		var/source_stockpile = stockpile_index
		var/total_price = D.withdraw_price
		if (remote)
			total_price += D.transport_fee
			source_stockpile = stockpile_index == 1 ? 2 : 1

		if(!D)
			return FALSE
		if(D.withdraw_disabled)
			return FALSE
		if(D.held_items[source_stockpile] <= 0)
			parent_structure.say("Insufficient stock.")
		else if(total_price > budget)
			parent_structure.say("Insufficient mammon.")
		else
			D.held_items[source_stockpile]--
			budget -= total_price
			SStreasury.economic_output -= D.export_price // Prevent GDP double counting
			SStreasury.give_money_treasury(D.withdraw_price, "stockpile withdraw")
			record_round_statistic(STATS_STOCKPILE_REVENUE, D.withdraw_price)
			var/obj/item/I = new D.item_type(parent_structure.loc)
			var/mob/user = usr
			if(!user.put_in_hands(I))
				I.forceMove(get_turf(user))
			playsound(parent_structure.loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
		return TRUE
	if(href_list["compact"])
		if(!usr.canUseTopic(parent_structure, BE_CLOSE))
			return FALSE
		if(ishuman(usr))
			compact = !compact
		return TRUE
	if(href_list["change"])
		if(!usr.canUseTopic(parent_structure, BE_CLOSE))
			return FALSE
		if(ishuman(usr))
			if(budget > 0)
				parent_structure.budget2change(budget, usr)
				budget = 0
	if(href_list["changecat"])
		if(!usr.canUseTopic(parent_structure, BE_CLOSE))
			return FALSE
		current_category = href_list["changecat"]
		return TRUE

/datum/withdraw_tab/proc/insert_coins(obj/item/roguecoin/C)
	budget += C.get_real_price()
	qdel(C)
	parent_structure.update_icon()
	playsound(parent_structure.loc, 'sound/misc/coininsert.ogg', 100, TRUE, -1)

/proc/stock_announce(message)
	for(var/obj/structure/roguemachine/stockpile/S in SSroguemachine.stock_machines)
		S.say(message, spans = list("info"))
