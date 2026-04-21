#define TRAIT_RESIDENCY_LETTER "residency_letter"

/obj/item/residency_letter
	name = "Letter of Residency"
	desc = "A sealed letter from the Nerve Master, bearing the Steward's signature."
	icon = 'icons/roguetown/items/paper.dmi'
	icon_state = "paper_altprep"
	w_class = WEIGHT_CLASS_TINY
	force = 0
	throwforce = 0
	var/issuer_name
	var/issuer_year

/obj/item/residency_letter/examine(mob/user)
	. = ..()
	var/signature = issuer_name || "the Nerve Master"
	var/year = issuer_year || CALENDAR_EPOCH_YEAR
	. += span_info("The letter reads: <i>\"Be it known to all who read this writ, that the bearer, upon claiming this letter, is received into the body of Azuria as a Resident and Burgher, and shall enjoy the protections and obligations attending that station under the Golden Bull of Kingsfield.\"</i>")
	. += span_info("<i>Signed in the year [year], [signature].</i>")
	. += span_notice("Left-click in hand to claim its rights.")

/obj/item/residency_letter/attack_self(mob/living/carbon/human/user)
	if(!istype(user))
		return ..()
	if(HAS_TRAIT(user, TRAIT_RESIDENT))
		to_chat(user, span_warning("I am already a Resident of Azuria."))
		return
	if(user.job == "Steward" || user.job == "Grand Duke")
		to_chat(user, span_warning("This letter is meant for another. I must hand it over."))
		return
	user.visible_message(span_notice("[user] unfolds the letter and accepts its seal."), \
		span_notice("I claim the rights of Residency and Burghership granted by this letter."))
	ADD_TRAIT(user, TRAIT_RESIDENT, TRAIT_RESIDENCY_LETTER)
	playsound(get_turf(user), 'sound/misc/gold_license.ogg', 60, FALSE, -1)
	qdel(src)
