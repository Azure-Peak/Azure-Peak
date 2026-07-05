/obj/item/clothing/mask/muzzle
	name = "muzzle"
	desc = ""
	icon_state = "muzzle"
	item_state = "blindfold"
	flags_cover = MASKCOVERSMOUTH
	w_class = WEIGHT_CLASS_SMALL
	gas_transfer_coefficient = 0.9
	equip_delay_other = 20

/obj/item/clothing/mask/pig
	name = "pig mask"
	desc = ""
	icon_state = "pig"
	item_state = "pig"
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	clothing_flags = VOICEBOX_TOGGLABLE
	w_class = WEIGHT_CLASS_SMALL
	modifies_speech = TRUE

/obj/item/clothing/mask/pig/handle_speech(datum/source, list/speech_args)
	if(!CHECK_BITFIELD(clothing_flags, VOICEBOX_DISABLED))
		speech_args[SPEECH_MESSAGE] = pick("Oink!","Squeeeeeeee!","Oink Oink!")

/obj/item/clothing/mask/pig/cursed
	name = "pig face"
	desc = ""
	flags_inv = HIDEFACIALHAIR|HIDESNOUT
	clothing_flags = NONE

/obj/item/clothing/mask/rat
	name = "rat mask"
	desc = ""
	icon_state = "rat"
	item_state = "rat"
	flags_inv = HIDEFACE|HIDESNOUT
	flags_cover = MASKCOVERSMOUTH

/obj/item/clothing/mask/rat/fox
	name = "fox mask"
	desc = ""
	icon_state = "fox"
	item_state = "fox"

/obj/item/clothing/mask/rat/bee
	name = "bee mask"
	desc = ""
	icon_state = "bee"
	item_state = "bee"

/obj/item/clothing/mask/rat/bear
	name = "bear mask"
	desc = ""
	icon_state = "bear"
	item_state = "bear"

/obj/item/clothing/mask/rat/bat
	name = "bat mask"
	desc = ""
	icon_state = "bat"
	item_state = "bat"

/obj/item/clothing/mask/rat/raven
	name = "raven mask"
	desc = ""
	icon_state = "raven"
	item_state = "raven"

/obj/item/clothing/mask/rat/jackal
	name = "jackal mask"
	desc = ""
	icon_state = "jackal"
	item_state = "jackal"

/obj/item/clothing/mask/rat/tribal
	name = "tribal mask"
	desc = ""
	icon_state = "bumba"
	item_state = "bumba"

/obj/item/clothing/mask/bandana
	name = "botany bandana"
	desc = ""
	w_class = WEIGHT_CLASS_TINY
	flags_cover = MASKCOVERSMOUTH
	flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	visor_flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	visor_flags_cover = MASKCOVERSMOUTH | PEPPERPROOF
	slot_flags = ITEM_SLOT_MASK
	adjusted_flags = ITEM_SLOT_HEAD
	icon_state = "bandbotany"

/obj/item/clothing/mask/bandana/attack_self(mob/user)
	adjustmask(user)


/obj/item/clothing/mask/bandana/black
	name = "black bandana"
	desc = ""
	icon_state = "bandblack"
