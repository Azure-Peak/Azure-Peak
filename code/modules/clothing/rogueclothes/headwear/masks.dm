/obj/item/clothing/head/roguetown/priestmask
	name = "solar visage"
	desc = "The sanctified helm of the most devoted. Thieves beware."
	color = null
	icon_state = "priesthead"
	item_state = "priesthead"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	dynamic_hair_suffix = ""
	sewrepair = TRUE

/obj/item/clothing/head/roguetown/priestmask/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_CHOSEN, "VISAGE")

//Eora content from Stonekeep

/obj/item/clothing/head/roguetown/eoramask
	name = "eoran mask"
	desc = "A silver mask in the likeness of a rabbit. Usually worn by the faithful of Eora during their rituals, but it's not like anyone's going to stop you. Right?"
	color = null
	icon_state = "eoramask"
	item_state = "eoramask"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	bloody_icon = 'icons/effects/blood64.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64
	flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDEHAIR
	dynamic_hair_suffix = ""
	resistance_flags = FIRE_PROOF // Made of metal
	salvage_result = /obj/item/natural/silk
	salvage_amount = 2

/obj/item/clothing/head/roguetown/eoramask/equipped(mob/living/carbon/human/user, slot) //Copying Eora bud pacifism
	. = ..()
	if(slot == SLOT_HEAD)
		ADD_TRAIT(user, TRAIT_PACIFISM, "eoramask_[REF(src)]")

/obj/item/clothing/head/roguetown/eoramask/dropped(mob/living/carbon/human/user)
	..()
	REMOVE_TRAIT(user, TRAIT_PACIFISM, "eoramask_[REF(src)]")

/obj/item/clothing/head/roguetown/eoramask/attack_hand(mob/user)
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(src == C.head)
			to_chat(user, "<span class='warning'>I need some time to remove the mask peacefully.</span>")
			if(do_after(user, 50))
				return ..()
			return
	return ..()

