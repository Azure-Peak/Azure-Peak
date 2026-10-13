#define TAROT_DECK_DESCRIPTION "The Mouthpiece of Xylix, given to mortals long ago. See fate. Never bend a corner."

/datum/playingcard/tarot
	var/reversed = FALSE

/datum/playingcard/tarot/on_shuffle(mob/user = null, silent = FALSE)
	. = ..()
	if(prob(50))
		reversed = !reversed

/datum/playingcard/tarot/get_name()
	. = ..()
	if(reversed)
		. += " (Reversed)"

/datum/playingcard/tarot/get_card_image(image_loc, is_concealed)
	. = ..()
	var/image/I = .
	if(reversed)
		var/matrix/M = matrix()
		M.Turn(180)
		I.transform = M

/obj/item/deck/tarot
	name = "tarot deck (major arcana)"
	desc = TAROT_DECK_DESCRIPTION + " This deck uses only the major arcana."
	icon = 'icons/roguetown/items/cards/tarot.dmi'
	var/has_minor_arcana = FALSE

/obj/item/deck/tarot/includes_minor_arcana
	name = "tarot deck (major and minor arcana)"
	has_minor_arcana = TRUE
	desc = TAROT_DECK_DESCRIPTION + " This deck uses both the major and minor arcana."

/obj/item/deck/tarot/get_new_deck()
	. = ..()
	var/list/major_arcana = alist(
		"The Magician" = "magician",
		"The High Priestess" = "high-priestess",
		"The Empress" = "empress",
		"The Emperor" = "emperor",
		"The Hierophant" = "hierophant",
		"The Lovers" = "lovers",
		"The Chariot" = "chariot",
		"The Hermit" = "hermit",
		"The Wheel of Fortune" = "wheel-of-fortune",
		"The Hanged Man" = "hanged-man",
		"The Devil" = "devil",
		"The Tower" = "tower",
		"The Star" = "star",
		"The Moon" = "moon",
		"The Sun" = "sun",
		"The World" = "world",
		"The Fool" = "fool",
		"Justice" = "justice",
		"Strength" = "strength",
		"Death" = "death",
		"Temperance" = "temperance",
		"Judgement" = "judgement",
	)
	for(var/key, value in major_arcana)
		var/datum/playingcard/tarot/pcard = new()
		pcard.set_name(key)
		pcard.set_front_icon_state(value)
		pcard.set_back_icon_state(back_icon_state)
		pcard.set_icon(icon)
		. += pcard
	// If we want the minor arcana too, include that!
	if(has_minor_arcana)
		for(var/suit in list("swords","wands","cups","pentacles"))
			for(var/number in list("ace","two","three","four","five","six","seven","eight","nine","ten","page","knight","queen","king"))
				var/datum/playingcard/tarot/pcard = new()
				pcard.set_name("[capitalize(number)] of [capitalize(suit)]")
				pcard.set_front_icon_state("[number]-[suit]")
				pcard.set_back_icon_state(back_icon_state)
				pcard.set_icon(icon)
				. += pcard

#undef TAROT_DECK_DESCRIPTION
