/obj/structure/roguemachine/noticeboard
	name = "Notice Board"
	desc = "A large wooden notice board, carrying postings from all across Azurea. A ZAD perch sits atop it."
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "noticeboard0"
	density = TRUE
	anchored = TRUE
	max_integrity = 0
	blade_dulling = DULLING_BASH
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	var/current_category = "Postings"
	var/list/categories = list("Postings", "Premium Postings", "Scout Report")

/obj/structure/roguemachine/noticeboard/Initialize()
	. = ..()
	SSroguemachine.noticeboards += src

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
 
	return attack_hand(usr)

/obj/structure/roguemachine/noticeboard/attack_hand(mob/living/carbon/human/user)
	if(!ishuman(user)) 
		return
	var/can_remove = FALSE
	var/can_premium = FALSE
	if(user.job in list("Man at Arms","Inquisitor", "Knight", "Sergeant", "Knight Captain", "Orthodoxist", "Absolver", "Marshal", "Hand")) //why was KC here but not marshal ?
		can_remove = TRUE
	if(user.job in list("Bathmaster","Merchant", "Innkeeper", "Steward", "Court Magician", "Town Crier", "Keeper"))
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
			contents += ("<div>[TRS?.region_name]: <font color=[TRS?.danger_color]>[TRS?.danger_level]</font></div>")
		contents += "<hr>"
		contents += "Scouts rate how dangerous a region is from Safe -> Low -> Moderate -> Dangerous -> Bleak <br>"
		contents += "A safe region is safe and travelers are unlikely to be ambushed by common creechurs and brigands <br>"
		contents += "A low threat region is unlikely to manifest any great threat and brigands and creechurs are often found alone.<br>"
		contents += "Only Azure Basin, Azure Grove and the Terrorbog can be rendered safe entirely. <br>" 
		contents += "Regions not listed are beyond the charge of the wardens. Danger will be constant in these regions.<br>"
		contents += "Danger is reduced by luring villains and creechurs and killing them when they ambush you. The signal horns wardens have been issued can help with this. Take care with using it."
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
