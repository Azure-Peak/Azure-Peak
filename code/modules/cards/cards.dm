#define MAX_HAND_SIZE 10
#define SHOW_ERROR_HAND_FULL(user) to_chat(user, span_warning("It can't hold any more cards."))
#define SHOW_ERROR_CARDS_FROM_DIFFERENT_DECK(user) to_chat(user, span_warning("These cards come from a different deck. I can't mix them."))
#define SHOW_ERROR_WHERES_YOUR_FUCKING_ARMS(user) to_chat(user, span_danger("WITH WHAT ARMS?"))
#define VISIBLE_MESSAGE_CARD_DRAWN_DECK(user) user.visible_message(span_notice("\The [user] draws a card from \the [src]."), span_notice("I draw a card from \the [src]."))
#define VISIBLE_MESSAGE_CARD_DRAWN_HAND(user) user.visible_message(span_notice("\The [user] draws a card from another hand."), span_notice("I draw a card from another hand."))
#define BALLOON_ALERT_CARD_DRAWN(user) balloon_alert_to_viewers("1 card drawn...")

/datum/playingcard
	/** Protected variable.

	If getting/setting publicly, use `get_name()` / `set_name()`
	*/
	VAR_PROTECTED/name = "playing card"
	/** Protected variable.

	If getting publicly, use `get_card_image()` and use the icon_state that is returned.

	If setting, use `set_front_icon_state()`
	*/
	VAR_PROTECTED/front_icon_state = "hand1"
	/** Protected variable.

	If getting publicly, use `get_card_image()` and use the icon_state that is returned.

	If setting, use `set_back_icon_state()`
	*/
	VAR_PROTECTED/back_icon_state = "singlecard_down"
	/** Protected variable.

	If getting publicly, use `get_card_image()` and use the icon that is returned.

	If setting, use `set_icon()`
	*/
	VAR_PROTECTED/icon = 'icons/roguetown/items/cards/playingcards.dmi'
	var/obj/item/deck/our_deck

/**
	Gets an image of the card.
	#### Arguments:
	* `image_loc`: Location of the image to be rendered.
	* `is_concealed`: Is the card supposed to be concealed (aka face down)?
	#### Returns:
	(`/image`) An image of the card.
*/
/datum/playingcard/proc/get_card_image(image_loc, is_concealed)
	RETURN_TYPE(/image)
	return image(src.icon, image_loc, is_concealed ? back_icon_state : front_icon_state)

/datum/playingcard/proc/get_name()
	SHOULD_CALL_PARENT(TRUE)
	return name

/datum/playingcard/proc/set_name(card_name)
	name = card_name

/datum/playingcard/proc/set_front_icon_state(front_icon_state)
	src.front_icon_state = front_icon_state

/datum/playingcard/proc/set_back_icon_state(back_icon_state)
	src.back_icon_state = back_icon_state

/datum/playingcard/proc/set_icon(icon)
	src.icon = icon

/// Called when the card is shuffled.
/datum/playingcard/proc/on_shuffle()
	return

/** Helper proc for card game stuff that prompts the user to choose from a list of cards which selection of cards they wish to draw.
* Returns which cards they wish to draw as `list`.
*/
/obj/item/proc/get_cards_in_selection(list/datum/playingcard/card_list, mob/living/carbon/human/user, max_cards_selectable)
	RETURN_TYPE(/list/datum/playingcard)

	if(user.stat || !Adjacent(user)) return

	if(!ishuman(user))
		return

	if(!card_list.len)
		to_chat(user, span_warning("There are no cards in the deck."))
		return

	. = list()

	// Emote before doing anything so you can't cheat!
	user.visible_message(span_notice("\The [user] looks into \the [src] and searches within it..."))
	balloon_alert_to_viewers("searching...")

	// We store the card names as an associated list with the card name as the key, and the value as the list of all unique instances of that card.
	// We'll need to take each of these instances and list them with unique key strings when we present them all to the player.
	// Why, you may ask?
	// Because TGUI list selection UIs do NOT like items with duplicate key strings. We must give each item a unique key string!
	// This is in other words a workaround to TGUI jank.
	var/list/card_names = list()
	for(var/datum/playingcard/P in card_list)
		var/name = P.get_name()
		// If we haven't yet found any cards with this name...
		if(!card_names[name])
			// ... Add them to a new list, where we'll store any duplicates!
			card_names[name] = list()
		card_names[name] += name

	var/list/cards_to_choose = list()
	for(var/key, value in card_names)
		var/list/L = value
		for(var/i = 0, i < L.len, i++)
			cards_to_choose += "[key] ([i+1])"

	var/list/cards_to_draw = tgui_input_checkboxes(user, "Which cards do you want to retrieve?", "Choose your cards", cards_to_choose, 1, max_cards_selectable)

	if(!LAZYLEN(cards_to_draw))
		user.visible_message(span_notice("\The [user] searches for specific cards in \the [src], but draws none."))
		return

	// Search through our cards for every card the user chose, and remove them from the deck if the name matches!
	for(var/to_draw in cards_to_draw)
		for(var/i = length(card_list), i > 0, i--)
			// Ignore the duplicate number at the end, we just want the card name itself!
			var/TDN = copytext(to_draw, 1, length(to_draw) - 3)
			var/datum/playingcard/P = card_list[i]
			if(TDN == P.get_name())
				card_list.Cut(i, i+1)
				. += P
				break

	// I mean... it can happen!
	if(!src)
		return null

	if(isturf(loc))
		balloon_alert_to_viewers("[cards_to_draw.len] card[cards_to_draw.len > 1 ? "s" : ""] drawn...")
	user.visible_message(span_notice("\The [user] searches for specific cards in \the [src], and draws [cards_to_draw.len]."))
	return .

// Hand of cards. Holds one or more cards

/obj/item/card_hand
	name = "hand of cards"
	icon = 'icons/roguetown/items/cards/playingcards.dmi'
	icon_state = null
	dropshrink = 0.5
	var/list/datum/playingcard/cards = list()
	/// The original deck we come from. Our cards can ONLY be taken from / put into this deck, and no other.
	var/obj/item/deck/our_deck = null
	var/concealed = TRUE
	w_class = WEIGHT_CLASS_SMALL
	grid_width = 32
	grid_height = 32
	var/fake_direction = 0

/obj/item/card_hand/proc/get_drawn_cards(mob/living/carbon/human/H, atom/drawing_to, max_amt_to_draw = null)
	var/last_loc = drawing_to.loc
	var/list/cards_to_draw = get_cards_in_selection(cards.Copy(), H, max_amt_to_draw || min(cards.len, MAX_HAND_SIZE))
	if(!src || !drawing_to || drawing_to.loc != last_loc)
		return null
	if(cards_to_draw?.len && Adjacent(H))
		var/list/removed = list()
		for(var/datum/playingcard/card_draw in cards_to_draw)
			for(var/datum/playingcard/PC in cards)
				if(card_draw == PC)
					removed.Add(PC)
					cards.Remove(PC)
					break
		return removed
	else
		return null

/obj/item/card_hand/get_mechanics_examine(mob/user)
	. = ..()
	. += span_smallnotice("<b>Activate in-hand</b> to flip all cards in the hand face-up or face-down.")
	. += span_smallnotice("<b>RIGHT CLICK</b> to draw a single card to your active hand. If your active hand is empty, a new hand of cards is made. If your active hand has a hand of cards already, the drawn card is added to it.")
	. += span_smallnotice("<b>SHIFT + RIGHT CLICK</b> to search the hand for one or more cards and draw whichever ones were chosen. If your active hand is empty, a new hand of cards is made. If your active hand has a hand of cards already, the drawn card(s) is/are added to it.")

/obj/item/card_hand/attackby(obj/item/I, mob/user, params)
	if(!user || !ishuman(user) || user.stat)
		return
	if(istype(I, /obj/item/card_hand))
		var/obj/item/card_hand/CH = I
		if(MAX_HAND_SIZE < (CH.cards.len + cards.len))
			SHOW_ERROR_HAND_FULL(user)
			return
		var/mob/living/carbon/human/H = user
		cards.Add(CH.cards)
		H.visible_message(span_notice("\The [H] joins \the [CH] with [H.p_their()] hand."))
		qdel(CH)
		update_icon()

/obj/item/card_hand/attack_self(mob/user)
	. = ..()
	concealed = !concealed
	update_icon()
	user.visible_message(span_notice("\The [user] [concealed ? "conceals" : "reveals"] [user.p_their()] hand."), span_notice("I [concealed ? "conceal" : "reveal"] my hand."), span_notice("I hear the flipping of card stock."))

/obj/item/card_hand/examine(mob/user)
	. = ..()
	if((!concealed) && cards.len)
		. += "<details><summary>[span_notice("Cards in Hand:")]</summary>"
		for(var/datum/playingcard/C in cards)
			var/image/I = C.get_card_image(user, FALSE)
			. += span_notice("[icon2html(I, user)] [C.get_name()]")
		. += "</details>"

/obj/item/card_hand/dropped(mob/user, silent)
	. = ..()
	fake_direction = user.dir
	update_icon()

/obj/item/card_hand/attack_right(mob/user)
	. = ..()
	if(!user || !ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.get_num_arms() <= 0)
		SHOW_ERROR_WHERES_YOUR_FUCKING_ARMS(user)
		return

	// If we're right clicking with an empty hand, make a new hand!
	var/thing_in_hand = H.get_active_held_item()
	if(!thing_in_hand && cards.len > 1)
		// Take the first card in our hand and give it to the new one
		var/datum/playingcard/PC = cards[cards.len]
		cards.Cut(cards.len, cards.len + 1)
		var/obj/item/card_hand/CH = new(user.loc, our_deck, list(PC), concealed)
		H.put_in_active_hand(CH)
		if(isturf(loc))
			BALLOON_ALERT_CARD_DRAWN(user)
		VISIBLE_MESSAGE_CARD_DRAWN_HAND(user)
		update_icon()
	// If we're right clicking with another hand of cards, do the same thing but we just transfer that hand
	else if(istype(thing_in_hand, /obj/item/card_hand))
		var/obj/item/card_hand/CH = thing_in_hand
		if(CH.our_deck != our_deck)
			SHOW_ERROR_CARDS_FROM_DIFFERENT_DECK(user)
			return
		if(CH.cards.len >= MAX_HAND_SIZE)
			SHOW_ERROR_HAND_FULL(user)
			return
		var/datum/playingcard/PC = cards[cards.len]
		cards.Cut(cards.len, cards.len + 1)
		CH.cards.Add(PC)
		CH.update_icon()
		VISIBLE_MESSAGE_CARD_DRAWN_HAND(user)
		if(!try_delete_self_if_no_cards())
			if(isturf(loc))
				BALLOON_ALERT_CARD_DRAWN(user)
			update_icon()

/obj/item/card_hand/ShiftRightClick(mob/user)
	if(!ishuman(user) || user.stat)
		return
	var/mob/living/carbon/human/H = user
	if(H.get_num_arms() <= 0)
		SHOW_ERROR_WHERES_YOUR_FUCKING_ARMS(user)
		return
	var/thing_in_hand = H.get_active_held_item()
	// If we're right clicking with an empty hand, make a new hand!
	if(!thing_in_hand && cards.len > 1)
		// Let the user choose which cards to remove
		var/list/drawn_cards = get_drawn_cards(H, H)
		if(!drawn_cards)
			return TRUE
		if(src && drawn_cards.len )
			var/obj/item/card_hand/CH = new(user.loc, our_deck, drawn_cards, concealed)
			H.put_in_active_hand(CH)
			if(!try_delete_self_if_no_cards())
				update_icon()
		return TRUE
	// If we're right clicking with another hand of cards, do the same thing but we just transfer that hand
	else if(istype(thing_in_hand, /obj/item/card_hand))
		var/obj/item/card_hand/CH = thing_in_hand
		if(CH.our_deck != our_deck)
			SHOW_ERROR_CARDS_FROM_DIFFERENT_DECK(user)
			return TRUE
		if(cards.len >= MAX_HAND_SIZE)
			SHOW_ERROR_HAND_FULL(user)
			return TRUE
		var/their_max = MAX_HAND_SIZE - CH.cards.len
		// Sanity check
		if(their_max <= 0)
			return TRUE
		var/drawn_max = clamp(their_max, 1, MAX_HAND_SIZE)
		var/list/drawn_cards = get_drawn_cards(H, CH, min(drawn_max, MAX_HAND_SIZE))
		if(!drawn_cards)
			return TRUE
		if(drawn_cards.len)
			CH.cards.Add(drawn_cards)
			CH.update_icon()
			if(!try_delete_self_if_no_cards())
				update_icon()
		return TRUE

/obj/item/card_hand/proc/try_delete_self_if_no_cards()
	if(!cards.len)
		qdel(src)
		return TRUE
	return FALSE

/obj/item/card_hand/Destroy()
	QDEL_LIST(cards)
	return ..()

/obj/item/card_hand/update_icon()
	cut_overlays()

	var/card_count = cards.len
	// Sanity check
	if(!card_count)
		return
	if(card_count > 1)
		name = "hand of cards ([card_count])"
		desc = "The inked illustrations, still as ice, await their wielder's moment of glory and fortune."
	else
		name = "playing card"
		desc = "One would be forgiven for the bizarre impulse to flick the card stock in one's hand." // Stimming...

	// If we just have a single card, no need for handling the transform
	if(card_count == 1)
		var/datum/playingcard/P = cards[1]
		var/image/I = P.get_card_image(src, concealed)
		add_overlay(I)
		return

	// If there are multiple cards, determine the min / max distance cards can be from one another
	var/offset = FLOOR(20/card_count, 1)

	var/matrix/M = matrix()
	if(fake_direction)
		// Make the cards visually face direction the player (if any) was facing when we were placed
		switch(fake_direction)
			if(NORTH)
				M.Translate( 0,  0)
			if(SOUTH)
				M.Translate( 0,  4)
			if(WEST)
				M.Turn(90)
				M.Translate( 3,  0)
			if(EAST)
				M.Turn(90)
				M.Translate(-2,  0)

	var/i = 0
	for(var/datum/playingcard/P in cards)
		var/image/I = P.get_card_image(src, concealed)
		// Pixel offsets to keep us visually where a player would expect us to go when placing us on a table
		switch(fake_direction)
			if(SOUTH)
				I.pixel_x = 8-(offset*i)
			if(WEST)
				I.pixel_y = -6+(offset*i)
			if(EAST)
				I.pixel_y = 8-(offset*i)
			else
				I.pixel_x = -7+(offset*i)
		I.transform = M
		add_overlay(I)
		i++

/obj/item/card_hand/pickup(mob/user)
	. = ..()
	fake_direction = 0
	update_icon()

/obj/item/card_hand/Initialize(mapload, obj/item/deck/source_deck, list/_cards, concealed = TRUE)
	. = ..()
	if(!source_deck || !_cards?.len)
		qdel(src)
		return
	src.concealed = concealed
	src.our_deck = source_deck
	src.cards.Insert(1, _cards)
	update_icon()

// Card decks

// Abstract card deck. Do not directly spawn this ingame - use one of the subtyes!!
/obj/item/deck
	name = "THE DECK OF IMPOSSIBLE AND BROKEN CARDS"
	desc = "You should not be seeing this. If you see this, report it to a developer!!"
	icon = 'icons/roguetown/items/cards/playingcards.dmi'
	icon_state = "deck_full"
	w_class = WEIGHT_CLASS_SMALL
	var/cooldown = 0
	var/last_touched = 0
	var/list/datum/playingcard/cards = list()
	/// Number of times we will duplicate our deck's contents when created. 2 makes a double sized deck, 3 makes triple sized, etc.
	var/deck_size = 1
	/// How many cards are dealt at a time when our holder deals a hand
	var/hand_size = 5
	/// Icon state used for the backs of the cards this deck provides.
	var/back_icon_state = "singlecard_down"
	grid_width = 32
	grid_height = 32

/obj/item/deck/proc/get_drawn_cards(mob/living/carbon/human/H, atom/drawing_to, max_amt_to_draw = null)
	var/last_loc = drawing_to.loc
	var/list/cards_to_draw = get_cards_in_selection(cards.Copy(), H, max_amt_to_draw || min(cards.len, MAX_HAND_SIZE))
	if(!src || !drawing_to || drawing_to.loc != last_loc)
		return null
	if(cards_to_draw?.len && Adjacent(H))
		var/list/removed = list()
		for(var/datum/playingcard/card_draw in cards_to_draw)
			for(var/datum/playingcard/PC in cards)
				if(card_draw == PC)
					removed.Add(PC)
					cards.Remove(PC)
					break
		return removed
	else
		return null

/obj/item/deck/proc/get_new_deck()
	PROTECTED_PROC(TRUE)
	SHOULD_CALL_PARENT(TRUE)
	RETURN_TYPE(/list/datum/playingcard)
	return list()

/obj/item/deck/proc/shuffle_deck(mob/user = null, silent = FALSE)
	if(cooldown < world.time - 25)
		cards = shuffle(cards)
		for(var/datum/playingcard/P in cards)
			P.on_shuffle()
		cooldown = world.time
		if(!silent && user != null)
			playsound(src, 'sound/items/cardshuffle.ogg', 100, TRUE)
			user.visible_message(span_notice("[user] shuffles the deck."), span_notice("I shuffle the deck."), span_notice("I hear the shuffling of cards."))

/obj/item/deck/Destroy()
	QDEL_LIST(cards)
	return ..()

/obj/item/deck/attack_self(mob/user)
	. = ..()
	shuffle_deck(user)
	user.changeNext_move(CLICK_CD_MELEE)

/obj/item/deck/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(istype(I, /obj/item/card_hand))
		var/obj/item/card_hand/CH = I
		if(CH.our_deck != src)
			to_chat(user, span_warning("[CH.cards.len > 1 ? "These cards" : "This card"] didn't come from this deck!"))
			return
		cards.Add(CH.cards)
		user.visible_message(span_notice("\The [user] returns \the [CH] to the bottom of \the [src]."), span_notice("I return \the [CH] to the bottom of \the [src]."))
		qdel(CH)
		user.changeNext_move(CLICK_CD_FAST)
		return

/obj/item/deck/ShiftRightClick(mob/user)
	if(!ishuman(user) || user.stat)
		return
	var/mob/living/carbon/human/H = user
	if(H.get_num_arms() <= 0)
		SHOW_ERROR_WHERES_YOUR_FUCKING_ARMS(user)
		return TRUE
	var/thing_in_hand = H.get_active_held_item()
	// If we're right clicking with an empty hand, make a new hand!
	if(!thing_in_hand && cards.len > 1)
		// Let the user choose which cards to remove
		var/list/drawn_cards = get_drawn_cards(H, H, min(cards.len, MAX_HAND_SIZE))
		if(!drawn_cards)
			return TRUE
		if(drawn_cards.len)
			var/obj/item/card_hand/CH = new(user.loc, src, drawn_cards, TRUE)
			H.put_in_active_hand(CH)
		return TRUE
	// If we're right clicking with another hand of cards, do the same thing but we just transfer that hand
	else if(istype(thing_in_hand, /obj/item/card_hand))
		var/obj/item/card_hand/CH = thing_in_hand
		if(CH.our_deck != src)
			SHOW_ERROR_CARDS_FROM_DIFFERENT_DECK(user)
			return TRUE
		if(CH.cards.len >= MAX_HAND_SIZE)
			SHOW_ERROR_HAND_FULL(user)
		var/their_max = MAX_HAND_SIZE - CH.cards.len
		// Sanity check
		if(their_max <= 0)
			return TRUE
		var/drawn_max = clamp(their_max, 1, MAX_HAND_SIZE)
		var/list/drawn_cards = get_drawn_cards(H, CH, min(drawn_max, MAX_HAND_SIZE))
		if(!drawn_cards)
			return TRUE
		if(drawn_cards.len)
			CH.cards.Add(drawn_cards)
			CH.update_icon()
		return TRUE

/obj/item/deck/attack_right(mob/user)
	. = ..()
	if(!user || !ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.get_num_arms() <= 0)
		SHOW_ERROR_WHERES_YOUR_FUCKING_ARMS(user)
		return
	// If we're right clicking with an empty hand, make a new hand!
	var/thing_in_hand = H.get_active_held_item()
	if(!thing_in_hand && cards.len > 1)
		// Take the first card in our hand and give it to the new one
		var/datum/playingcard/PC = cards[cards.len]
		cards.Cut(cards.len, cards.len + 1)
		var/obj/item/card_hand/CH = new(user.loc, src, list(PC), TRUE)
		H.put_in_active_hand(CH)
		VISIBLE_MESSAGE_CARD_DRAWN_DECK(user)
		if(isturf(loc))
			BALLOON_ALERT_CARD_DRAWN(user)
	// If we're right clicking with another hand of cards, do the same thing but we just transfer that hand
	else if(istype(thing_in_hand, /obj/item/card_hand))
		var/obj/item/card_hand/CH = thing_in_hand
		if(CH.our_deck != src)
			SHOW_ERROR_CARDS_FROM_DIFFERENT_DECK(user)
			return
		if(CH.cards.len >= MAX_HAND_SIZE)
			SHOW_ERROR_HAND_FULL(user)
			return
		var/datum/playingcard/PC = cards[cards.len]
		cards.Cut(cards.len, cards.len + 1)
		CH.cards.Add(PC)
		CH.update_icon()
		if(isturf(loc))
			BALLOON_ALERT_CARD_DRAWN(user)
		VISIBLE_MESSAGE_CARD_DRAWN_DECK(user)

/obj/item/deck/MiddleClick(mob/user, params)
	. = ..()
	if(!ishuman(user) || user.stat || !user.canUseTopic(src, BE_CLOSE))
		return
	shuffle_deck(user)
	user.changeNext_move(CLICK_CD_MELEE)

/obj/item/deck/Initialize(mapload)
	. = ..()
	for(var/i = 0, i < deck_size, i++)
		var/list/datum/playingcard/new_deck = get_new_deck()
		cards.Insert(1, new_deck)
	shuffle_deck(null, TRUE)

/obj/item/deck/examine()
	. = ..()
	. += span_notice("It has [cards.len] cards left.")

/obj/item/deck/get_mechanics_examine(mob/user)
	. = ..()
	. += span_smallnotice("<b>MIDDLE CLICK</b> to shuffle the deck.")
	. += span_smallnotice("<b>RIGHT CLICK</b> to draw a single card to your active hand. If your active hand is empty, a new hand of cards is made. If your active hand has a hand of cards already, the drawn card is added to it.")
	. += span_smallnotice("<b>SHIFT + RIGHT CLICK</b> to search the hand for one or more cards and draw whichever ones were chosen. If your active hand is empty, a new hand of cards is made. If your active hand has a hand of cards already, the drawn card(s) is/are added to it.")


#undef SHOW_ERROR_HAND_FULL
#undef SHOW_ERROR_WHERES_YOUR_FUCKING_ARMS
#undef SHOW_ERROR_CARDS_FROM_DIFFERENT_DECK
#undef VISIBLE_MESSAGE_CARD_DRAWN_DECK
#undef VISIBLE_MESSAGE_CARD_DRAWN_HAND
#undef BALLOON_ALERT_CARD_DRAWN
#undef MAX_HAND_SIZE
