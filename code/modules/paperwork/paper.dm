/*
 * Paper
 * also scraps of paper
 *
 * lipstick wiping is in code/game/objects/items/weapons/cosmetics.dm!
 */

#ifdef TESTSERVER

/client/verb/textperp()
	set category = "PAPER"
	set name = "textper+"
	set desc = ""

	var/obj/item/I
	I = mob.get_active_held_item()
	if(I)
		if(istype(I,/obj/item/paper))
			var/obj/item/paper/P = I
			P.textper++
			P.read(mob)
		if(istype(I,/obj/item/book))
			var/obj/item/book/P = I
			P.textper++
			P.read(mob)

/client/verb/textperm()
	set category = "PAPER"
	set name = "textper-"
	set desc = ""

	var/obj/item/I
	I = mob.get_active_held_item()
	if(I)
		if(istype(I,/obj/item/paper))
			var/obj/item/paper/P = I
			P.textper--
			P.read(mob)
		if(istype(I,/obj/item/book))
			var/obj/item/book/P = I
			P.textper--
			P.read(mob)

#endif

/obj/item/paper
	name = "parchment"
	gender = NEUTER
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "paper"
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_range = 1
	throw_speed = 1
	slot_flags = ITEM_SLOT_HEAD
	body_parts_covered = HEAD
	resistance_flags = FLAMMABLE
	max_integrity = 30
	dog_fashion = /datum/dog_fashion/head
	drop_sound = 'sound/foley/dropsound/paper_drop.ogg'
	pickup_sound =  'sound/blank.ogg'
	grind_results = list(/datum/reagent/cellulose = 3)


	var/extra_headers //For additional styling or other js features.

	var/info		//What's actually written on the paper.
	var/info_links	//A different version of the paper which includes html links at fields and EOF
	var/stamps		//The (text for the) stamps on the paper.
	var/fields = 0	//Amount of user created fields
	var/list/stamped
	var/rigged = 0
	var/spam_flag = 0
	var/contact_poison // Reagent ID to transfer on contact
	var/contact_poison_volume = 0
	dropshrink = 0.5
	var/textper = 100
	var/maxlen = 2000

	var/cached_mailer
	var/cached_mailedto
	var/trapped

/obj/item/paper/examine()
	. = ..()
	. += span_info("Use a feather to write on it. You can create a two-page manuscript that can be turned into a book by writing on it and applying it to another piece of paper that also have something written on it.")

/obj/item/paper/get_real_price()
	if(info)
		return 0
	else
		return sellprice

/obj/item/paper/spark_act()
	fire_act()

/obj/item/paper/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.3,"sx" = 0,"sy" = -1,"nx" = 13,"ny" = -1,"wx" = 4,"wy" = 0,"ex" = 7,"ey" = -1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 2,"sflip" = 0,"wflip" = 0,"eflip" = 8)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/paper/pickup(user)
	if(contact_poison && ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/clothing/gloves/G = H.gloves
		if(!istype(G) || G.transfer_prints)
			H.reagents.add_reagent(contact_poison,contact_poison_volume)
			contact_poison = null
	..()

/obj/item/paper/update_icon()
	. = ..()
	update_icon_state()

/obj/item/paper/Initialize()
	. = ..()
	pixel_y = rand(-8, 8)
	pixel_x = rand(-9, 9)
	update_icon_state()
	updateinfolinks()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/survival/sigsweet,
		/datum/crafting_recipe/roguetown/survival/sigdry,
		/datum/crafting_recipe/roguetown/survival/rocknutdry,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/item/paper/update_icon_state()
	if(mailer)
		icon_state = "paper_prep"
		name = "letter"
		throw_range = 7
		return
	name = initial(name)
	throw_range = initial(throw_range)
	if(info)
		icon_state = "paperwrite"
		return
	icon_state = "paper"

/obj/item/paper/examine(mob/user)
	. = ..()
	if(!mailer)
		. += "<a href='?src=[REF(src)];read=1'>Read</a> (<a href='?src=[REF(src)];Help=1'>Help</a>)"
	else
		. += "It's from [mailer], addressed to [mailedto].</a>"

/obj/item/paper/proc/read(mob/user)
//	var/datum/asset/assets = get_asset_datum(/datum/asset/spritesheet/simple/paper)
//	assets.send(user)
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		if(info)
			user.adjust_experience(/datum/skill/misc/reading, 2, FALSE)
		return
	if(mailer)
		return
	if(in_range(user, src) || isobserver(user))
//		var/obj/screen/read/R = user.hud_used.reads
		var/dat = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
			<html><head><style type=\"text/css\">
			body { background-image:url('book.png');background-repeat: repeat; }</style></head><body scroll=yes>"}
		dat += info
		dat += "<br>"
		dat += "<a href='?src=[REF(src)];close=1' style='position:absolute;right:50px'>Close</a>"
		dat += "</body></html>"
		user << browse(dat, "window=reading;size=500x400;can_close=1;can_minimize=0;can_maximize=0;can_resize=1;titlebar=0;border=0")
		onclose(user, "reading", src)
	else
		return span_warning("I'm too far away to read it.")

/*
	if(in_range(user, src) || isobserver(user))
		if(user.is_literate())
			user << browse("<HTML><HEAD><TITLE>[name]</TITLE>[extra_headers]</HEAD><BODY>[info]<HR></BODY></HTML>", "window=paper[md5(name)]")
			onclose(user, "paper[md5(name)]")
		else
			user << browse("<HTML><HEAD><TITLE>[name]</TITLE>[extra_headers]</HEAD><BODY>[stars(info)]<HR></BODY></HTML>", "window=paper[md5(name)]")
			onclose(user, "paper[md5(name)]")
	else
		return "<span class='warning'>You're too far away to read it.</span>"
*/

/obj/item/paper/proc/format_browse(t, mob/user)
	user << browse_rsc('html/book.png')
	var/dat = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
			<html><head><style type=\"text/css\">
			body { background-image:url('book.png');background-repeat: repeat; }</style></head><body scroll=yes>"}
	dat += "[t]<br>"
	dat += "<a href='?src=[REF(src)];close=1' style='position:absolute;right:50px'>Close</a>"
	dat += "</body></html>"
	user << browse(dat, "window=reading;size=500x400;can_close=1;can_minimize=0;can_maximize=0;can_resize=1;titlebar=0;border=0")

/obj/item/paper/verb/rename()
	set name = "Rename paper"
	set hidden = 1
	set src in usr

	if(usr.incapacitated() || !usr.is_literate())
		return
	var/n_name = stripped_input(usr, "What would you like to label the paper?", "Paper Labelling", null, MAX_NAME_LEN)
	if((loc == usr && usr.stat == CONSCIOUS))
		name = "paper[(n_name ? text("- '[n_name]'") : null)]"
	add_fingerprint(usr)


/obj/item/paper/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] scratches a grid on [user.p_their()] wrist with the paper! It looks like [user.p_theyre()] trying to commit sudoku...</span>")
	return (BRUTELOSS)

/obj/item/paper/proc/reset_spamflag()
	spam_flag = FALSE

/obj/item/paper/attack_self(mob/user)
	if(mailer)
		user.visible_message("<span class='notice'>[user] opens the letter from [mailer].</span>")
		cached_mailer = mailer
		cached_mailedto = mailedto
		mailer = null
		mailedto = null
		update_icon()
		return
	if(trapped)
		var/mob/living/victim = user
		victim.visible_message(span_notice("[user] opens the [src]."))
		to_chat(user, span_warning("This parchment is full of strange symbols that start to glow. How odd. Wait-"))
		sleep(5)
		victim.adjust_fire_stacks(15)
		victim.ignite_mob()
		victim.visible_message(span_danger("[user] bursts into flames upon reading [src]!"))
	read(user)
	if(rigged && (SSevents.holidays && SSevents.holidays[APRIL_FOOLS]))
		if(!spam_flag)
			spam_flag = TRUE
			playsound(loc, 'sound/blank.ogg', 50, TRUE)
			addtimer(CALLBACK(src, PROC_REF(reset_spamflag)), 20)

/obj/item/paper/proc/addtofield(id, text, links = 0)
	var/locid = 0
	var/laststart = 1
	var/textindex = 1
	while(locid < 15)	//hey whoever decided a while(1) was a good idea here, i hate you
		var/istart = 0
		if(links)
			istart = findtext(info_links, "<span class=\"paper_field\">", laststart)
		else
			istart = findtext(info, "<span class=\"paper_field\">", laststart)

		if(istart == 0)
			return	//No field found with matching id

		laststart = istart+1
		locid++
		if(locid == id)
			var/iend = 1
			if(links)
				iend = findtext(info_links, "</span>", istart)
			else
				iend = findtext(info, "</span>", istart)

			//textindex = istart+26
			textindex = iend
			break

	if(links)
		var/before = copytext(info_links, 1, textindex)
		var/after = copytext(info_links, textindex)
		info_links = before + text + after
	else
		var/before = copytext(info, 1, textindex)
		var/after = copytext(info, textindex)
		info = before + text + after
		updateinfolinks()


/obj/item/paper/proc/updateinfolinks()
	info_links = info
	for(var/i in 1 to min(fields, 15))
		addtofield(i, "<A href='?src=[REF(src)];write=[i]'>write</A> (<A href='?src=[REF(src)];help=1'>\[?\]</A>)", 1)
	info_links = info_links + "<A href='?src=[REF(src)];write=end'>write</A> <A href='?src=[REF(src)];help=1'>\[?\]</A>"


/obj/item/paper/proc/clearpaper()
	info = null
	stamps = null
	LAZYCLEARLIST(stamped)
	cut_overlays()
	updateinfolinks()
	update_icon_state()


/obj/item/paper/proc/parsepencode(t, obj/item/P, mob/user, iscrayon = 0)
	if(length(t) < 1)		//No input means nothing needs to be parsed
		return

	t = parsemarkdown(t, user, iscrayon)

	if(istype(P, /obj/item/natural/thorn))
		t = "<font face=\"[FOUNTAIN_PEN_FONT]\" color=#862f20>[t]</font>"
	else if(istype(P, /obj/item/natural/feather))
		t = "<font face=\"[FOUNTAIN_PEN_FONT]\" color=#14103f>[t]</font>"

	// Count the fields
	var/laststart = 1
	while(fields < 15)
		var/i = findtext(t, "<span class=\"paper_field\">", laststart)
		if(i == 0)
			break
		laststart = i+1
		fields++

	return t

/obj/item/paper/proc/reload_fields() // Useful if you made the paper programicly and want to include fields. Also runs updateinfolinks() for you.
	fields = 0
	var/laststart = 1
	while(fields < 15)
		var/i = findtext(info, "<span class=\"paper_field\">", laststart)
		if(i == 0)
			break
		laststart = i+1
		fields++
	updateinfolinks()


/obj/item/paper/proc/openhelp(mob/user)
	user << browse({"<HTML><HEAD><TITLE>Paper Help</TITLE></HEAD>
	<BODY>
		You can use backslash (\\) to escape special characters.<br>
		<br>
		# text : Defines a header.<br>
		|text| : Centers the text.<br>
		**text** : Makes the text <b>bold</b>.<br>
		*text* : Makes the text <i>italic</i>.<br>
		^text^ : Increases the <font size = \"4\">size</font> of the text.<br>
		%s : Inserts a signature of your name in a foolproof way.<br>
		%f : Inserts an invisible field which lets you start type from there. Useful for forms.<br>
		((text)) : Decreases the <font size = \"1\">size</font> of the text.<br>
		* item : An unordered list item.<br>
		&nbsp;&nbsp;* item: An unordered list child item.<br>
		--- : Adds a horizontal rule.<br>
		-=FFFFFFtext=- : Adds a specific <font color = '#FFFFFF'>colour</font> to text.
	</BODY></HTML>"}, "window=paper_help")


/obj/item/paper/Topic(href, href_list)
	..()

	if(!usr)
		return

	if(href_list["close"])
		var/mob/user = usr
		if(user?.client && user.hud_used)
			if(user.hud_used.reads)
				user.hud_used.reads.destroy_read()
			user << browse(null, "window=reading")

	var/literate = usr.is_literate()
	if(!usr.canUseTopic(src, BE_CLOSE, literate))
		return

	if(href_list["read"])
		if(trapped)
			var/mob/living/victim = usr
			victim.visible_message(span_notice("[usr] opens the [src]."))
			to_chat(usr, span_warning("This parchment is full of strange symbols that start to glow. How odd. Wait-"))
			sleep(5)
			victim.adjust_fire_stacks(15)
			victim.ignite_mob()
			victim.visible_message(span_danger("[usr] bursts into flames upon reading [src]!"))
		read(usr)

	if(href_list["help"])
		openhelp(usr)
		return

	if(href_list["write"])
		var/id = href_list["write"]
		var/t =  stripped_multiline_input("Enter what you want to write:", "Write", no_trim=TRUE)
		if(!t || !usr.canUseTopic(src, BE_CLOSE, literate))
			return
		var/obj/item/i = usr.get_active_held_item()	//Check to see if he still got that darn pen, also check if he's using a crayon or pen.
		if(!istype(i, /obj/item/natural/thorn))
			if(!istype(i, /obj/item/natural/feather))
				return

		if(!in_range(src, usr) && loc != usr && loc.loc != usr && usr.get_active_held_item() != i)	//Some check to see if he's allowed to write
			return

		log_paper("[key_name(usr)] writing to paper [t]")
		t = parsepencode(t, i, usr, FALSE) // Encode everything from pencode to html

		if(t != null)	//No input from the user means nothing needs to be added
			if((length(info) + length(t)) > maxlen)
				to_chat(usr, "<span class='warning'>Too long. Try again.</span>")
				return
			if(id!="end")
				addtofield(text2num(id), t) // He wants to edit a field, let him.
			else
				info += t // Oh, he wants to edit to the end of the file, let him.
				testing("[length(info)]")
				testing("[findtext(info, "\n")]")
				updateinfolinks()
			playsound(src, 'sound/items/write.ogg', 100, FALSE)
			format_browse(info_links, usr)
			update_icon_state()

/obj/item/paper/attackby(obj/item/P, mob/living/carbon/human/user, params)
	if(resistance_flags & ON_FIRE)
		return ..()

	if(mailer)
		return ..()

	if(is_blind(user))
		return ..()
	
	if(!istype(src, /obj/item/paper/inqslip))
		if(istype(P, /obj/item/clothing/ring/signet))
			var/obj/item/clothing/ring/signet/ring = P
			if(ring.tallowed)
				return create_import_writ(user)
		if(istype(P, /obj/item/scomstone/garrison))
			return create_import_writ(user)

	if(istype(P, /obj/item/grant))
		var/obj/item/grant/grant = P
		if(!grant.sealed)
			to_chat(user, span_warning("This grant must be sealed first."))
			return
		return create_import_writ(user, grant)

	if(istype(P, /obj/item/natural/feather/infernal))
		if(trapped)
			to_chat(user, span_warning("[src] is already trapped."))
		else
			to_chat(user, span_warning("I draw infernal symbols on this [src], rigging it to explode."))
			trapped = TRUE

	if(istype(P, /obj/item/natural/thorn)|| istype(P, /obj/item/natural/feather))
		if(length(info) > maxlen)
			to_chat(user, "<span class='warning'>[src] is full of verba.</span>")
			return
		if(user.can_read(src))
			format_browse(info_links, user)
			update_icon_state()
			return
		else
			to_chat(user, "<span class='warning'>I can't write.</span>")
			return
	
	if(istype(P, /obj/item/paper))
		var/obj/item/paper/p = P
		if(info && p.info)
			var/obj/item/manuscript/M = new /obj/item/manuscript(get_turf(P.loc))
			M.page_texts = list(src.info, p.info)
			M.compiled_pages = "<p>[src.info]</p><p>[p.info]</p>"
			qdel(p)
			if(user.Adjacent(M))
				M.add_fingerprint(user)
				user.update_inv_hands()
				user.put_in_active_hand(src)
				user.put_in_inactive_hand(M)
			. = ..()
			return qdel(src)
	if(!P.can_be_package_wrapped())
		return ..()

	if(istype(P, /obj/item/roguecoin))
		if(mailer || trapped)
			return ..()
		
		var/obj/item/roguecoin/C = P
		var/grant_amount = C.get_real_price()
		
		if(grant_amount <= 0)
			to_chat(user, span_warning("These coins have no value."))
			return
		
		to_chat(user, span_info("I start preparing a grant with [grant_amount] mammon..."))
		if(do_after(user, 90, target = src))
			var/obj/item/grant/new_grant = new /obj/item/grant(src.loc)
			new_grant.grant_amount = grant_amount
			if(!user.transferItemToLoc(C, new_grant)) // this shouldn't fail
				to_chat(user, span_warning("I couldn't get the coins inside the grant!"))
				qdel(new_grant)
				return
			new_grant.update_name()
			qdel(src)
			user.put_in_hands(new_grant)
			to_chat(user, span_notice("I've prepared a grant of [grant_amount] mammon."))
		return


	if(!istype(src, /obj/item/paper/inqslip))
		to_chat(user, span_info("I start to wrap [P] in [src]..."))
		if(do_after(user, 30, 0, target = src))
			if(user.is_holding(P))
				if(!user.dropItemToGround(P))
					return
			else if(!isturf(P.loc))
				return
			var/obj/item/smallDelivery/D = new /obj/item/smallDelivery(get_turf(P.loc))
			if(user.Adjacent(D))
				D.add_fingerprint(user)
				P.add_fingerprint(user)
				user.put_in_hands(D)
			P.forceMove(D)
			var/size = round(P.w_class)
			D.name = "[weightclass2text(size)] package"
			D.w_class = size
			size = min(size, 5)
			D.grid_height = P.grid_height
			D.grid_width = P.grid_width
			D.icon_state = "deliverypackage[size]"
			D.note = src
			forceMove(D)

		add_fingerprint(user)
		return ..()
	else
		return ..()	

/obj/item/paper/fire_act(added, maxstacks)
	..()
	if(!(resistance_flags & FIRE_PROOF))
		add_overlay("paper_onfire_overlay")
		info = "[stars(info)]"


/obj/item/paper/extinguish()
	..()
	cut_overlay("paper_onfire_overlay")

// turns a sheet of paper into an import writ for a faction's vault
/obj/item/paper/proc/create_import_writ(mob/user, obj/item/grant/grant = null)
	if(!user.mind)
		return

	var/list/available_territories = list()
	var/list/territory_to_faction = list()
	var/import_amount = 0

	if(grant)
		if(!grant.target_faction)
			to_chat(user, span_warning("This grant has no designated authority."))
			return
		// var/datum/territory_faction/source_faction
		// source_faction = grant.target_faction
		import_amount = grant.grant_amount
		
		for(var/datum/territory/estate in grant.target_faction.territories)
			available_territories[estate.name] = estate
			territory_to_faction[estate.name] = grant.target_faction
	else
		for(var/datum/territory_faction/faction in user.mind.associated_factions)
			if(faction.owner == user.real_name || faction.job_owner == user.job)
				for(var/datum/territory/estate in faction.territories)
					if(!(estate.name in available_territories))
						available_territories[estate.name] = estate
						territory_to_faction[estate.name] = faction

	if(!available_territories.len)
		var/error_msg = grant ? "[grant.target_faction.name] has no territories to import from." : "I have no territories to import from."
		to_chat(user, span_warning(error_msg))
		return

	var/chosen_territory = input(user, "Select a territory to import from:", "Import Writ") as null|anything in available_territories
	if(!chosen_territory)
		return
	
	var/datum/territory/selected_estate = available_territories[chosen_territory]
	var/datum/territory_faction/controlling_faction = territory_to_faction[chosen_territory]
	if(!selected_estate)
		return

	if(!grant) // if there's no grant, we'll be dealing with the faction's vault
		// vault balance (treasury for Grand Duchy, faction vault for others)
		var/available_funds = 0
		if(controlling_faction)
			if(controlling_faction.name == "The Grand Duchy of Azuria")
				available_funds = SStreasury.treasury_value
				to_chat(user, span_notice("The treasury has [available_funds] mammon."))
			else
				available_funds = controlling_faction.vault
				to_chat(user, span_notice("[controlling_faction.name] has [available_funds] mammon in its vault."))
		
		import_amount = input(user, "How much mammon should be spent? (Available: [available_funds])", "Import Writ") as null|num
		if(!import_amount || import_amount <= 0)
			return
		import_amount = round(import_amount)
		if(import_amount > available_funds)
			to_chat(user, span_warning("Insufficient funds."))
			return
	else
		to_chat(user, span_notice("Using grant value of [import_amount] mammon."))

	var/delivery_location = alert(user, "Select delivery location:", "Import Writ", "City Docks (High Toll)", "Groveside (No Toll)", "Cancel")
	if(!delivery_location || delivery_location == "Cancel")
		return
	
	var/obj/item/import_writ/writ = new /obj/item/import_writ(grant ? get_turf(src) : src)
	writ.territory_name = chosen_territory
	writ.import_amount = import_amount
	writ.import_location = delivery_location
	writ.issuing_faction = controlling_faction
	writ.sealed = TRUE

	if(grant)
		if(!user.transferItemToLoc(grant, writ))
			to_chat(user, span_warning("I couldn't attach the grant!"))
			qdel(writ)
			return
		writ.attached_grant = grant
		writ.update_icon_state()
		to_chat(user, span_notice("I have drafted an import writ for [import_amount] mammon from [chosen_territory], with the grant attached."))
	else
		to_chat(user, span_notice("I have drafted an import writ for [import_amount] mammon worth of goods from [chosen_territory]."))
	
	user.put_in_hands(writ)
	qdel(src)
/*
 * Construction paper
 */

/obj/item/paper/construction

/obj/item/paper/construction/Initialize()
	. = ..()
	color = pick("FF0000", "#33cc33", "#ffb366", "#551A8B", "#ff80d5", "#4d94ff")

/*
 * Natural paper
 */

/obj/item/paper/natural/Initialize()
	. = ..()
	color = "#FFF5ED"

/obj/item/paper/crumpled
	name = "paper scrap"
	icon_state = "scrap"
	slot_flags = null

/obj/item/paper/crumpled/update_icon_state()
	return

/obj/item/paper/crumpled/bloody
	icon_state = "scrap_bloodied"

/obj/item/paper/crumpled/muddy
	icon_state = "scrap_mud"

/obj/item/smallDelivery
	name = "package"
	desc = ""
	icon = 'icons/roguetown/clothing/storage.dmi'
	icon_state = "deliverypackage3"
	item_state = "deliverypackage"
	var/giftwrapped = 0
	var/sortTag = 0
	var/obj/item/paper/note

/obj/item/smallDelivery/contents_explosion(severity, target)
	for(var/atom/movable/AM in contents)
		AM.ex_act()

/obj/item/smallDelivery/attack_self(mob/user)
	user.temporarilyRemoveItemFromInventory(src, TRUE)
	for(var/X in contents)
		var/atom/movable/AM = X
		user.put_in_hands(AM)
	playsound(src.loc, 'sound/blank.ogg', 50, TRUE)
	user.visible_message(span_warning("[user] opens [src]."))
	if(note)
		note.forceMove(user.loc)
	qdel(src)

/obj/item/smallDelivery/attack_self_tk(mob/user)
	if(ismob(loc))
		var/mob/M = loc
		M.temporarilyRemoveItemFromInventory(src, TRUE)
		for(var/X in contents)
			var/atom/movable/AM = X
			M.put_in_hands(AM)
	else
		for(var/X in contents)
			var/atom/movable/AM = X
			AM.forceMove(src.loc)
	if(note)
		note.forceMove(user.loc)
	playsound(src.loc, 'sound/blank.ogg', 50, TRUE)
	qdel(src)

/obj/item/smallDelivery/examine(mob/user)
	. = ..()
	if(note && length(note.info))
		if(!in_range(user, src))
			. += "There's a [note.name] attached to it. You can't read it from here."
		else
			. += "There's a [note.name] attached to it..."
			. += note.examine(user)
	if(mailer)
		. += "It's from [mailer], addressed to [mailedto].</a>"

/obj/item/smallDelivery/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/natural/feather))
		if(!user.is_literate())
			to_chat(user, span_notice("I scribble illegibly on the side of [src]!"))
			return
		var/str = copytext(sanitize(input(user,"Label text?","Set label","")),1,MAX_NAME_LEN)
		if(!user.canUseTopic(src, BE_CLOSE))
			return
		if(!str || !length(str))
			to_chat(user, span_warning("Invalid text!"))
			return
		user.visible_message(span_notice("[user] labels [src] as [str]."))
		name = "[name] ([str])"

/obj/item/proc/can_be_package_wrapped() //can the item be wrapped with package wrapper into a delivery package
	return 1

/obj/item/storage/can_be_package_wrapped()
	return 0

/obj/item/storage/box/can_be_package_wrapped()
	return 1

/obj/item/storage/belt/rogue/pouch/can_be_package_wrapped()
	return 1

/obj/item/smallDelivery/can_be_package_wrapped()
	return 0

/obj/item/inqarticles/indexer/can_be_package_wrapped()
	return 0
