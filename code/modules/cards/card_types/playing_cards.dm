/obj/item/deck/cards
	name = "deck of playing cards"
	desc = "To the Xylixians; sacred. To the rest of the church of the Ten; a source of moral decay."

/obj/item/deck/cards/get_new_deck()
	. = ..()
	for(var/suit in list("spades","clubs","diamonds","hearts"))
		for(var/number in list("ace","two","three","four","five","six","seven","eight","nine","ten","jack","queen","king"))
			var/datum/playingcard/pcard = new()
			pcard.set_name("[capitalize(number)] of [capitalize(suit)]")
			pcard.set_front_icon_state("[number]-[suit]")
			pcard.set_back_icon_state(back_icon_state)
			pcard.set_icon(icon)
			. += pcard // Make it so. // side note: I've been driving myself insane reworking cards LET ME HAVE MY FUN!!!! - Ryumi

/obj/item/deck/cards/triple
	name = "triple-sized deck of playing cards"
	deck_size = 3
