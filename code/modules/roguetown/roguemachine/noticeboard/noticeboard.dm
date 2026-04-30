/obj/structure/roguemachine/noticeboard
	name = "Notice Board"
	desc = "A large wooden notice board, carrying postings from all across Azuria. A ZAD perch sits atop it."
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "noticeboard0"
	density = TRUE
	anchored = TRUE
	max_integrity = 0
	blade_dulling = DULLING_BASH
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	var/current_category = "Postings"
	var/list/categories = list("Postings", "Premium Postings", "Scout Report", "Mercenary Roster", "Charters", "Trade Orders", "Economic Events", "Blockades", "City Assembly")

/obj/structure/roguemachine/noticeboard/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-click the noticeboard to take a better look at it.")
	. += span_info("'Postings' and 'Premium Postings' can host messages of any kind. The zads will audibly notify everyone that a new message has been added to the noticeboard, whenever one is posted.")
	. += span_info("'Scout Reports' detail how dangerous the ambushes in Azuria's many regions might be. The more dangerous a region is, the more numerous and lethal its ambushers will be.")
	. += span_info("'Mercenary Rosters' list the names and detailings of all Mercenaries currently registered to Azuria's Mercenary Guild.")
	. += span_info("'Charters' display the current state of Azuria's four foundational Charters.")
	. += span_info("'Trade Orders' list standing trade demands from every region. Speak with the Steward if you wish to help fulfill one.")
	. += span_info("'Economic Events' warn of active shortages and gluts affecting trade prices across the realm.")
	. += span_info("'Blockades' list regions where trade roads are cut by raiders. Pin a Steward's blockade writ here to open it to a Fellowship of three.")

/obj/structure/roguemachine/noticeboard/Initialize()
	. = ..()
	SSroguemachine.noticeboards += src

/obj/structure/roguemachine/noticeboard/attackby(obj/item/P, mob/living/carbon/human/user, params)
	if(istype(P, /obj/item/quest_writ/blockade))
		var/obj/item/quest_writ/blockade/B = P
		if(B.assigned_quest?.is_directive)
			to_chat(user, span_warning("A Steward's request is not for public posting - it must be handed directly to the bearer."))
			return
		if(B.assigned_quest?.required_fellowship_size >= BLOCKADE_FELLOWSHIP_REQUIREMENT)
			to_chat(user, span_warning("This writ is already posted publicly."))
			return
		B.promote_to_board_gated()
		to_chat(user, span_notice("You pin the [B.name] to the board. Any who take it must have a fellowship of [BLOCKADE_FELLOWSHIP_REQUIREMENT]."))
		playsound(src, 'sound/items/inqslip_sealed.ogg', 50, TRUE, -1)
		return
	return ..()

/datum/noticeboardpost
	var/title
	var/truepostername
	var/posterstitle
	var/poster
	var/message
	var/banner

/obj/structure/roguemachine/noticeboard/examine(mob/living/carbon/human/user)
	. = ..()
	if(!ishuman(user))
		return
	if(user in GLOB.board_viewers)
		return
	else
		GLOB.board_viewers += user
		to_chat(user, span_smallred("A new posting has been made since I last checked!"))

/obj/structure/roguemachine/noticeboard/update_icon()
	. = ..()
	var/total_length = length(GLOB.noticeboard_posts) + length(GLOB.premium_noticeboardposts)
	switch(total_length)
		if(0)
			icon_state = "noticeboard0"
		if(1 to 3)
			icon_state = "noticeboard1"
		if(4 to 6)
			icon_state = "noticeboard2"
		else
			icon_state = "noticeboard3"

/obj/structure/roguemachine/noticeboard/Topic(href, href_list)
	. = ..()
	if(!usr.canUseTopic(src, BE_CLOSE))
		return
	if(href_list["changecategory"])
		current_category = href_list["changecategory"]
	if(href_list["makepost"])
		make_post(usr)
		return attack_hand(usr)
	if(href_list["premiumpost"])
		premium_post(usr)
		return attack_hand(usr)
	if(href_list["removepost"])
		remove_post(usr)
		return attack_hand(usr)
	if(href_list["authorityremovepost"])
		authority_removepost(usr)
		return attack_hand(usr)
	if(href_list["open_assembly"])
		open_assembly_tgui(usr)
		return

	return attack_hand(usr)

/obj/structure/roguemachine/noticeboard/attack_hand(mob/living/carbon/human/user)
	if(!ishuman(user))
		return
	var/can_remove = FALSE
	var/can_premium = FALSE
	if(user.job in list("Man at Arms","Inquisitor", "Knight", "Sergeant", "Orthodoxist", "Absolver", "Marshal", "Hand", "Grand Duke")) //why was KC here but not marshal ?
		can_remove = TRUE
	if(user.job in list("Bathmaster","Merchant", "Innkeeper", "Steward", "Court Magician", "Town Crier", "Keeper", "Grand Duke"))
		can_premium = TRUE
	var/contents
	contents += "<center>NOTICEBOARD<BR>"
	contents += "--------------<BR>"
	var/selection = "Categories: "
	for(var/i = 1, i <= length(categories), i++)
		var/category = categories[i]
		if(category == current_category)
			selection += "<b>[current_category]</b> | "
		else if(i != length(categories))
			selection += "<a href='?src=[REF(src)];changecategory=[category]'>[category]</a> | "
		else
			selection += "<a href='?src=[REF(src)];changecategory=[category]'>[category]</a> "
	contents += selection + "<BR>"
	if(current_category in list("Postings", "Premium Postings"))
		contents += "<a href='?src=[REF(src)];makepost=1'>Make a Posting</a>"
		if(can_premium)
			contents += " | <a href='?src=[REF(src)];premiumpost=1'>Make a Premium Posting</a><br>"
		else
			contents += "<br>"
		contents += "<a href='?src=[REF(src)];removepost=1'>Remove my Posting</a><br>"
		if(can_remove)
			contents += "<a href='?src=[REF(src)];authorityremovepost=1'>Authority: Remove a Posting</a>"
		var/board_empty = TRUE
		switch(current_category)
			if("Postings")
				for(var/datum/noticeboardpost/saved_post in GLOB.noticeboard_posts)
					contents += saved_post.banner
					board_empty = FALSE
			if("Premium Postings")
				for(var/datum/noticeboardpost/saved_post in GLOB.premium_noticeboardposts)
					contents += saved_post.banner
					board_empty = FALSE
		if(board_empty)
			contents += "<br><span class='notice'>No postings have been made yet!</span>"
	else if(current_category == "Scout Report")
		var/list/regional_threats = SSregionthreat.get_threat_regions_for_display()
		contents += "<h2>Scout Report</h2>"
		contents += "<hr></center>"
		for(var/T in regional_threats)
			var/datum/threat_region_display/TRS = T
			var/entry = "<div>[TRS?.region_name]: <font color=[TRS?.danger_color]>[TRS?.danger_level]</font>"
			if(length(TRS?.ic_description))
				entry += " &mdash; [jointext(TRS.ic_description, "; ")]"
			entry += "</div>"
			contents += entry
		contents += "<hr>"
		contents += "Scouts rate how dangerous a region is from Safe -> Low -> Moderate -> Dangerous -> Bleak <br>"
		contents += "A safe region is safe and travelers are unlikely to be ambushed by common creechurs and brigands. <br>"
		contents += "A low threat region is unlikely to manifest any great threat and brigands and creechurs are often found alone. <br>"
		contents += "Only Azure Basin, Azure Grove and the Terrorbog can be rendered safe entirely. <br>"
		contents += "Regions not listed are beyond the charge of the wardens. Danger will be constant in these regions. <br>"
		contents += "Danger is reduced by luring villains and creechurs and killing them when they ambush you. Traveling in groups draws larger ambushes, but each additional companion contributes less to taming the region than a lone traveler would. <br>"
		contents += "The signal horns wardens have been issued can provoke a sizeable fight proportional to the region's dangers, and is the surest way to tame a region. Bandits and wild creechurs trickle back in over time, generally overnight. Take care with the horn, and bring friends."
	else if(current_category == "Mercenary Roster")
		if(SSroguemachine.mercenary_statue)
			contents += SSroguemachine.mercenary_statue.get_readonly_roster_html()
		else
			contents += "<br><span class='notice'>The mercenary statue network is not available.</span>"
	else if(current_category == "Charters")
		contents += "<h2>Charters of the Realm</h2>"
		contents += "<hr></center>"
		for(var/id in SStreasury.decrees)
			var/datum/decree/D = SStreasury.decrees[id]
			// Dormant charters (never activated this round) are hidden from the public Charters
			// listing. A charter the Lord has never pressed doesn't exist as far as the town is
			// concerned - the Notice Board only reflects what's in actual force or was recently.
			if(!D.has_ever_been_active)
				continue
			var/state_color = D.active ? "#2a8a2a" : "#8a2a2a"
			var/state_label = D.active ? "IN FORCE" : "SUSPENDED"
			contents += "<div style='margin-bottom:10px'>"
			contents += "<b>[D.name]</b> <i>of [D.year]</i> &mdash; <font color='[state_color]'>[state_label]</font><br>"
			contents += "<div style='white-space:pre-wrap;margin-top:4px'>[D.get_display_flavor_text()]</div>"
			contents += "</div><hr>"
	else if(current_category == "Trade Orders")
		contents += "<h2>Standing Trade Orders</h2>"
		contents += "<hr></center>"
		var/orders_shown = 0
		for(var/datum/standing_order/O as anything in GLOB.standing_order_pool)
			if(O.is_fulfilled)
				continue
			orders_shown++
			var/datum/economic_region/region = GLOB.economic_regions[O.region_id]
			var/region_name = region ? region.name : O.region_id
			var/days_left = max(0, O.day_expires - GLOB.dayspassed)
			var/is_urgent = istype(O, /datum/standing_order/urgent)
			contents += "<div style='margin-bottom:10px'>"
			if(is_urgent)
				contents += "<font color='#c44'><b>URGENT</b></font> "
			if(region?.is_region_blockaded)
				contents += "<font color='#c44'><b>BLOCKADED</b></font> "
			if(SSeconomy.order_is_equipment(O))
				contents += "<font color='#88c'><b>WAREHOUSE</b></font> "
			if(O.petitioned)
				contents += "<font color='#a872c4'><b>STEWARD'S PETITION</b></font> "
			contents += "<b>[O.name]</b> &mdash; [region_name] &mdash; [days_left]d remaining<br>"
			if(O.description)
				contents += "<i>[O.description]</i><br>"
			contents += "Requires: "
			var/first = TRUE
			for(var/good_id in O.required_items)
				var/datum/trade_good/tg = GLOB.trade_goods[good_id]
				var/label = tg ? tg.name : good_id
				if(!first)
					contents += ", "
				first = FALSE
				contents += "[O.required_items[good_id]] [label]"
			contents += "<br>"
			contents += "Payout: <b>[O.total_payout]m</b><br>"
			contents += "</div><hr>"
		if(!orders_shown)
			contents += "<br><span class='notice'>No standing orders currently posted. Check back later.</span>"
		else
			contents += "<div style='margin-top:8px'><i>Speak with the Steward or Clerk at the Nerve Master to fulfill a stockpile order. WAREHOUSE-tagged orders require finished goods to be left at the dock manifest for Crown collection.</i></div>"
	else if(current_category == "Blockades")
		contents += "<h2>Regional Blockades</h2>"
		contents += "<hr></center>"
		if(!length(GLOB.active_blockades))
			contents += "<br><span class='notice'>No blockades are active. The trade roads run clear.</span>"
		else
			for(var/datum/blockade/B as anything in GLOB.active_blockades)
				var/datum/economic_region/ER = B.get_region()
				var/datum/quest_faction/F = B.get_faction()
				var/region_label = ER ? ER.name : B.region_id
				var/faction_label = F ? "[F.group_word] of [F.name_plural]" : B.faction_id
				var/days_active = GLOB.dayspassed - B.day_started
				contents += "<div style='margin-bottom:10px'>"
				contents += "<font color='#c44'><b>BLOCKADED</b></font> <b>[region_label]</b> &mdash; [days_active]d active<br>"
				contents += "Raiders: <i>[faction_label]</i><br>"
				if(B.has_active_scroll())
					contents += "<font color='#5cb85c'>A defense writ is in circulation - seek the bearer.</font><br>"
				else
					contents += "<i>Awaiting a Steward's defense writ.</i><br>"
				contents += "</div><hr>"
			contents += "<div style='margin-top:8px'><i>Defense writs are drafted by the Steward from the Contract Ledger. Pinning a writ here binds it to a Fellowship of [BLOCKADE_FELLOWSHIP_REQUIREMENT].</i></div>"
	else if(current_category == "Economic Events")
		contents += "<h2>Economic Events</h2>"
		contents += "<hr></center>"
		if(!length(GLOB.active_economic_events))
			contents += "<br><span class='notice'>The realm's trade is calm. No events are currently disturbing the market.</span>"
		else
			for(var/datum/economic_event/E as anything in GLOB.active_economic_events)
				var/days_left = max(0, E.day_expires - GLOB.dayspassed)
				var/color = (E.event_type == ECON_EVENT_SHORTAGE) ? "#c44" : "#5cb85c"
				var/type_label = (E.event_type == ECON_EVENT_SHORTAGE) ? "SHORTAGE" : "GLUT"
				contents += "<div style='margin-bottom:10px'>"
				contents += "<font color='[color]'><b>[type_label]</b></font> &mdash; <b>[E.name]</b> &mdash; forecast to return to normal within [days_left]d<br>"
				if(E.description)
					contents += "<i>[E.description]</i><br>"
				if(length(E.affected_goods))
					contents += "Affected goods: "
					var/first = TRUE
					for(var/good_id in E.affected_goods)
						var/datum/trade_good/tg = GLOB.trade_goods[good_id]
						var/label = tg ? tg.name : good_id
						if(!first)
							contents += ", "
						first = FALSE
						contents += label
					contents += "<br>"
				contents += "</div><hr>"
	else if(current_category == "City Assembly")
		contents += build_assembly_summary_html()
	var/datum/browser/popup = new(user, "NOTICEBOARD", "", 800, 650)
	popup.set_content(contents)
	popup.open()

/obj/structure/roguemachine/noticeboard/proc/premium_post(mob/living/carbon/human/guy)
	if(guy.has_status_effect(/datum/status_effect/debuff/postcooldown))
		to_chat(guy, span_warning("I must wait a time until my next posting..."))
		return
	var/inputtitle = input(guy, "What shall the title of my posting be?", "NOTICEBOARD", null)
	if(!inputtitle)
		return
	var/inputmessage = stripped_multiline_input(guy, "What shall I write for this posting?", "NOTICEBOARD", no_trim=TRUE)
	if(inputmessage)
		if(length(inputmessage) > 2000)
			to_chat(guy, span_warning("Too long! You shall surely overburden the with this novel!"))
			return
	else
		return
	var/inputname = input(guy, "What name shall I use on the posting?", "NOTICEBOARD", null)
	if(!inputname)
		return
	var/inputrole = input(guy, "What personal title shall I use on the posting?", "NOTICEBOARD", null)
	add_post(inputmessage, inputtitle, inputname, inputrole, guy.real_name, TRUE)
	guy.apply_status_effect(/datum/status_effect/debuff/postcooldown)
	message_admins("[ADMIN_LOOKUPFLW(guy)] has made a notice board post. The message was: [inputmessage]")
	for(var/obj/structure/roguemachine/noticeboard/board in SSroguemachine.noticeboards)
		if(board != src)
			playsound(board, 'sound/ambience/noises/birds (7).ogg', 50, FALSE, -1)
			board.visible_message(span_smallred("A ZAD lands, delivering a new posting!"))
			board.update_icon()

/obj/structure/roguemachine/noticeboard/proc/make_post(mob/living/carbon/human/guy)
	if(guy.has_status_effect(/datum/status_effect/debuff/postcooldown))
		to_chat(guy, span_warning("I must wait a time until my next posting..."))
		return
	var/inputtitle = stripped_input(guy, "What shall the title of my posting be?", "NOTICEBOARD", null)
	if(!inputtitle)
		return
	if(length(inputtitle) > 50)
		to_chat(guy, span_warning("Too long! You shall surely overburden the zad with this novel!"))
		return
	var/inputmessage = stripped_multiline_input(guy, "What shall I write for this posting?", "NOTICEBOARD", no_trim=TRUE)
	if(inputmessage)
		if(length(inputmessage) > 2000)
			to_chat(guy, span_warning("Too long! You shall surely overburden the zad with this novel!"))
			return
	else
		return
	var/inputname = stripped_input(guy, "What name shall I use on the posting?", "NOTICEBOARD", null)
	if(!inputname)
		return
	if(length(inputname) > 50)
		to_chat(guy, span_warning("Too long! You shall surely overburden the zad with this novel!"))
		return
	var/inputrole = stripped_input(guy, "What personal title shall I use on the posting?", "NOTICEBOARD", null)
	if(length(inputrole) > 50)
		to_chat(guy, span_warning("Too long! You shall surely overburden the zad with this novel!"))
		return
	add_post(inputmessage, inputtitle, inputname, inputrole, guy.real_name, FALSE)
	guy.apply_status_effect(/datum/status_effect/debuff/postcooldown)
	message_admins("[ADMIN_LOOKUPFLW(guy)] has made a notice board post. The message was: [inputmessage]")
	for(var/obj/structure/roguemachine/noticeboard/board in SSroguemachine.noticeboards)
		board.update_icon()
		if(board != src)
			playsound(board, 'sound/ambience/noises/birds (7).ogg', 50, FALSE, -1)
			board.visible_message(span_smallred("A ZAD lands, delivering a new posting!"))

/obj/structure/roguemachine/noticeboard/proc/remove_post(mob/living/carbon/human/guy)
	var/list/myposts_list = list()
	for(var/datum/noticeboardpost/removable_posts in GLOB.noticeboard_posts)
		if(removable_posts.truepostername == guy.real_name)
			myposts_list += removable_posts.title
	for(var/datum/noticeboardpost/removable_postspremium in GLOB.premium_noticeboardposts)
		if(removable_postspremium.truepostername == guy.real_name)
			myposts_list += removable_postspremium.title
	if(!myposts_list.len)
		to_chat(guy, span_warning("There are no posts I can take down."))
		return
	var/post2remove = input(guy, "Which post shall I take down?", src) as null|anything in myposts_list
	if(!post2remove)
		return
	playsound(loc, 'sound/foley/dropsound/paper_drop.ogg', 50, FALSE, -1)
	loc.visible_message(span_smallred("[guy] tears down a posting!"))
	for(var/datum/noticeboardpost/removing_post in GLOB.noticeboard_posts)
		if(post2remove == removing_post.title && removing_post.truepostername == guy.real_name)
			GLOB.noticeboard_posts -= removing_post
			message_admins("[ADMIN_LOOKUPFLW(guy)] has removed their post, the message was [removing_post.message]")
	for(var/datum/noticeboardpost/removing_post in GLOB.premium_noticeboardposts)
		if(post2remove == removing_post.title && removing_post.truepostername == guy.real_name)
			GLOB.premium_noticeboardposts -= removing_post
			message_admins("[ADMIN_LOOKUPFLW(guy)] has removed their post, the message was [removing_post.message]")
	for(var/obj/structure/roguemachine/noticeboard/board in SSroguemachine.noticeboards)
		board.update_icon()
		if(board != src)
			playsound(board, 'sound/ambience/noises/birds (7).ogg', 50, FALSE, -1)
			board.visible_message(span_smallred("A ZAD lands, removing an old posting!"))

/obj/structure/roguemachine/noticeboard/proc/authority_removepost(mob/living/carbon/human/guy)
	var/list/posts_list = list()
	for(var/datum/noticeboardpost/removable_posts in GLOB.noticeboard_posts)
		posts_list += removable_posts.title
	if(!posts_list.len)
		to_chat(guy, span_warning("There are no posts I can take down."))
		return
	var/post2remove = input(guy, "Which post shall I take down?", src) as null|anything in posts_list
	if(!post2remove)
		return
	playsound(loc, 'sound/foley/dropsound/paper_drop.ogg', 50, FALSE, -1)
	loc.visible_message(span_smallred("[guy] tears down a posting!"))
	for(var/datum/noticeboardpost/removing_post in GLOB.noticeboard_posts)
		if(post2remove == removing_post.title)
			GLOB.noticeboard_posts -= removing_post
			message_admins("[ADMIN_LOOKUPFLW(guy)] has authoritavely removed a post, the message was [removing_post.message]")



/proc/add_post(message, chosentitle, chosenname, chosenrole, truename, premium)
	var/datum/noticeboardpost/new_post = new /datum/noticeboardpost
	new_post.poster = chosenname
	new_post.title = chosentitle
	new_post.message = message
	new_post.posterstitle = chosenrole
	new_post.truepostername = truename
	compose_post(new_post)
	GLOB.board_viewers = list()
	if(!premium)
		GLOB.noticeboard_posts += new_post
	else
		GLOB.premium_noticeboardposts += new_post



/proc/compose_post(datum/noticeboardpost/new_post)
	new_post.banner += "<center><b>[new_post.title]</b><BR>"
	new_post.banner += "[new_post.message]<BR>"
	new_post.banner += "- [new_post.poster]"
	if(new_post.posterstitle)
		new_post.banner += ", [new_post.posterstitle]"
	new_post.banner += "<BR>"
	new_post.banner += "--------------<BR>"

/datum/status_effect/debuff/postcooldown
	id = "postcooldown"
	duration = 5 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/debuff/postcooldown

/atom/movable/screen/alert/status_effect/debuff/postcooldown
	name = "Recent messenger"
	desc = "I'll have to wait a bit before making another posting!"
