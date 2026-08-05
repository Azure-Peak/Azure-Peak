/obj/structure/displaycase
	name = "display case"
	icon_state = "glassbox0"
	desc = ""
	density = TRUE
	anchored = TRUE
	resistance_flags = ACID_PROOF
	armor = ARMOR_DISPLAYCASE
	max_integrity = 200
	integrity_failure = 0.25
	var/obj/item/showpiece = null
	var/alert = TRUE
	var/open = FALSE
	var/openable = TRUE
	var/start_showpiece_type = null //add type for items on display
	var/list/start_showpieces = list() //Takes sublists in the form of list("type" = /obj/item/bikehorn, "trophy_message" = "henk")
	var/trophy_message = ""

/obj/structure/displaycase/Initialize()
	. = ..()
	if(start_showpieces.len && !start_showpiece_type)
		var/list/showpiece_entry = pick(start_showpieces)
		if (showpiece_entry && showpiece_entry["type"])
			start_showpiece_type = showpiece_entry["type"]
			if (showpiece_entry["trophy_message"])
				trophy_message = showpiece_entry["trophy_message"]
	if(start_showpiece_type)
		showpiece = new start_showpiece_type (src)
	update_icon()

/obj/structure/displaycase/Destroy()
	if(showpiece)
		QDEL_NULL(showpiece)
	return ..()

/obj/structure/displaycase/examine(mob/user)
	. = ..()
	if(alert)
		. += "<span class='notice'>Hooked up with an anti-theft system.</span>"
	if(showpiece)
		. += "<span class='notice'>There's [showpiece] inside.</span>"
	if(trophy_message)
		. += "The plaque reads:\n [trophy_message]"


/obj/structure/displaycase/proc/dump()
	if (showpiece)
		showpiece.forceMove(loc)
		showpiece = null

/obj/structure/displaycase/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			playsound(src.loc, 'sound/blank.ogg', 75, TRUE)
		if(BURN)
			playsound(src.loc, 'sound/blank.ogg', 100, TRUE)

/obj/structure/displaycase/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		dump()
		if(!disassembled)
			new /obj/item/natural/glass_shard( src.loc )
	qdel(src)

/obj/structure/displaycase/obj_break(damage_flag)
	..()

	if(!obj_broken && !(flags_1 & NODECONSTRUCT_1))
		density = FALSE
		new /obj/item/natural/glass_shard( src.loc )
		playsound(src, "shatter", 70, TRUE)
		update_icon()

/obj/structure/displaycase/update_icon()
	return

/obj/structure/displaycase/attackby(obj/item/W, mob/user, params)
	if(W.GetID() && !obj_broken && openable)
		if(allowed(user))
			to_chat(user,  "<span class='notice'>I [open ? "close":"open"] [src].</span>")
			toggle_lock(user)
		else
			to_chat(user,  "<span class='alert'>Access denied.</span>")
	else if(W.tool_behaviour == TOOL_WELDER && user.used_intent.type == INTENT_HELP && !obj_broken)
		if(obj_integrity < max_integrity)
			if(!W.tool_start_check(user, amount=5))
				return

			to_chat(user, "<span class='notice'>I begin repairing [src]...</span>")
			if(W.use_tool(src, user, 40, amount=5, volume=50))
				obj_integrity = max_integrity
				update_icon()
				to_chat(user, "<span class='notice'>I repair [src].</span>")
		else
			to_chat(user, "<span class='warning'>[src] is already in good condition!</span>")
		return
	else if(!alert && W.tool_behaviour == TOOL_CROWBAR && openable) //Only applies to the lab cage and player made display cases
		if(obj_broken)
			if(showpiece)
				to_chat(user, "<span class='warning'>Remove the displayed object first!</span>")
			else
				to_chat(user, "<span class='notice'>I remove the destroyed case.</span>")
				qdel(src)
		else
			to_chat(user, "<span class='notice'>I start to [open ? "close":"open"] [src]...</span>")
			if(W.use_tool(src, user, 20))
				to_chat(user,  "<span class='notice'>I [open ? "close":"open"] [src].</span>")
				toggle_lock(user)
	else if(open && !showpiece)
		if(user.transferItemToLoc(W, src))
			showpiece = W
			to_chat(user, "<span class='notice'>I put [W] on display.</span>")
			update_icon()
	else
		return ..()

/obj/structure/displaycase/proc/toggle_lock(mob/user)
	open = !open
	update_icon()

/obj/structure/displaycase/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	if (showpiece && (obj_broken || open))
		to_chat(user, "<span class='notice'>I deactivate the hover field built into the case.</span>")
		log_combat(user, src, "deactivates the hover field of")
		dump()
		src.add_fingerprint(user)
		update_icon()
		return
	else
	    //prevents remote "kicks" with TK
		if (!Adjacent(user))
			return
		if (user.used_intent.type == INTENT_HELP)
			user.examinate(src)
			return
		user.visible_message("<span class='danger'>[user] kicks the display case.</span>", null, null, COMBAT_MESSAGE_RANGE)
		log_combat(user, src, "kicks")
		user.do_attack_animation(src, ATTACK_EFFECT_KICK)
		take_damage(2)

/obj/structure/displaycase/trophy
	name = "trophy display case"
	desc = ""
	var/placer_key = ""
	var/added_roundstart = TRUE
	var/is_locked = TRUE

	alert = TRUE
	integrity_failure = 0
	openable = FALSE

/obj/structure/displaycase/trophy/Initialize()
	. = ..()
	GLOB.trophy_cases += src

/obj/structure/displaycase/trophy/Destroy()
	GLOB.trophy_cases -= src
	return ..()

/obj/structure/displaycase/trophy/attackby(obj/item/W, mob/user, params)

	if(!user.Adjacent(src)) //no TK museology
		return
	if(user.used_intent.type == INTENT_HARM)
		return ..()

	if(user.is_holding_item_of_type(/obj/item/key/displaycase))
		if(added_roundstart)
			is_locked = !is_locked
			to_chat(user, "<span class='notice'>I [!is_locked ? "un" : ""]lock the case.</span>")
		else
			to_chat(user, "<span class='warning'>The lock is stuck shut!</span>")
		return

	if(is_locked)
		to_chat(user, "<span class='warning'>The case is shut tight with an old fashioned physical lock. Maybe you should ask the curator for the key?</span>")
		return

	if(!added_roundstart)
		to_chat(user, "<span class='warning'>You've already put something new in this case!</span>")
		return

	if(user.transferItemToLoc(W, src))

		if(showpiece)
			to_chat(user, "<span class='notice'>I press a button, and [showpiece] descends into the floor of the case.</span>")
			QDEL_NULL(showpiece)

		to_chat(user, "<span class='notice'>I insert [W] into the case.</span>")
		showpiece = W
		added_roundstart = FALSE
		update_icon()

		placer_key = user.ckey

		trophy_message = W.desc //default value

		var/chosen_plaque = stripped_input(user, "What would you like the plaque to say? Default value is item's description.", "Trophy Plaque")
		if(chosen_plaque)
			if(user.Adjacent(src))
				trophy_message = chosen_plaque
				to_chat(user, "<span class='notice'>I set the plaque's text.</span>")
			else
				to_chat(user, "<span class='warning'>I are too far to set the plaque's text!</span>")

		SSpersistence.SaveTrophy(src)
		return TRUE

	else
		to_chat(user, "<span class='warning'>\The [W] is stuck to your hand, you can't put it in the [src.name]!</span>")

	return

/obj/structure/displaycase/trophy/dump()
	if (showpiece)
		if(added_roundstart)
			visible_message("<span class='danger'>The [showpiece] crumbles to dust!</span>")
			new /obj/item/ash(loc)
			QDEL_NULL(showpiece)
		else
			..()

/obj/item/key/displaycase
	name = "display case key"
	desc = ""

/obj/item/showpiece_dummy
	name = "Cheap replica"

/obj/item/showpiece_dummy/Initialize(mapload, path)
	. = ..()
	var/obj/item/I = path
	name = initial(I.name)
	icon = initial(I.icon)
	icon_state = initial(I.icon_state)
