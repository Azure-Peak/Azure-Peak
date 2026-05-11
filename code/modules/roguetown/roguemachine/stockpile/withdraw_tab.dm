/datum/withdraw_tab
	var/budget = 0
	var/compact = TRUE
	var/current_category = "Raw Materials"
	var/list/categories = list("Raw Materials", "Refined", "Alchemy", "Fruit", "Vegetable", "Animal", "Seafood", "Precious")
	var/obj/structure/roguemachine/parent_structure = null

/datum/withdraw_tab/New(obj/structure/roguemachine/structure_param)
	. = ..()
	parent_structure = structure_param

/datum/withdraw_tab/proc/get_contents(title, show_back)
	var/contents = "<center>[title]<BR>"
	if(show_back)
		contents += "<a href='?src=[REF(parent_structure)];navigate=directory'>(back)</a><BR>"

	contents += "--------------<BR>"
	contents += "<a href='?src=[REF(parent_structure)];change=1'>Stored Mammon: [budget]</a><BR>"
	contents += "<a href='?src=[REF(parent_structure)];compact=1'>Compact Mode: [compact ? "ENABLED" : "DISABLED"]</a></center><BR>"
	var/mob/living/user = usr
	if (user && HAS_TRAIT(user, TRAIT_FOOD_STIPEND))
		contents += "<center><b>TREASURY-LINE ACTIVE.</b></center><BR>"
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
			A.refresh_auto_price()
			if(!A.withdraw_disabled)
				contents += "<b>[A.name][A.get_event_tag()] (Max: [A.stockpile_limit]):</b> <a href='?src=[REF(parent_structure)];withdraw=[REF(A)]'>[A.stockpile_amount] at [A.withdraw_price]m</a>[A.get_market_delta_tag_for("withdraw")]"
				if(!A.accept_toggle_enabled)
					contents += " <font color='#888'>(NOT ACCEPTING DEPOSITS)</font>"
				contents += "<BR>"
			else
				contents += "<b>[A.name]:</b> Withdrawing Disabled...<BR>"

	else
		for(var/datum/roguestock/stockpile/A in SStreasury.stockpile_datums)
			if(A.category != current_category)
				continue
			A.refresh_auto_price()
			contents += "[A.name][A.get_event_tag()]<BR>"
			contents += "[A.desc]<BR>"
			contents += "Stockpiled Amount: [A.stockpile_amount]<BR>"
			if(!A.accept_toggle_enabled)
				contents += "<font color='#888'>NOT ACCEPTING DEPOSITS</font><BR>"
			if(!A.withdraw_disabled)
				contents += "<a href='?src=[REF(parent_structure)];withdraw=[REF(A)]'>\[Withdraw ([A.withdraw_price])\]</a>[A.get_market_delta_tag_for("withdraw")]<BR><BR>"
			else
				contents += "Withdrawing Disabled...<BR><BR>"

	return contents

/datum/withdraw_tab/proc/perform_action(href, href_list)
	if(href_list["withdraw"])
		var/datum/roguestock/D = locate(href_list["withdraw"]) in SStreasury.stockpile_datums
		if(!D)
			return FALSE
		D.refresh_auto_price()
		var/total_price = D.withdraw_price

		if(D.withdraw_disabled)
			return FALSE
		if(D.stockpile_amount <= 0)
			parent_structure.say("Insufficient stock.")
		else if(total_price > budget)
			var/mob/living/user = usr
			if (user && HAS_TRAIT(user, TRAIT_FOOD_STIPEND))
				if (SStreasury.burn(SStreasury.discretionary_fund, total_price, "food stipend - vomitorium"))
					D.stockpile_amount--
					var/obj/item/I = new D.item_type(parent_structure.loc)
					to_chat(user, span_info("[parent_structure] chitters and squeaks into the treasury ratlines."))
					if(!user.put_in_hands(I))
						I.forceMove(get_turf(user))
					playsound(parent_structure.loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
				else
					parent_structure.say("The treasury is barren. Please insert coinage.")
			else
				parent_structure.say("Insufficient mammon.")
		else
			D.stockpile_amount--
			budget -= total_price
			SStreasury.mint(SStreasury.discretionary_fund, total_price, "stockpile withdraw")
			record_round_statistic(STATS_STOCKPILE_REVENUE, total_price)
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
				budget2change(budget, usr)
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
