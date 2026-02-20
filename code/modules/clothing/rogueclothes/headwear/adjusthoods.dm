
// REAL hoods

/obj/item/clothing/head/roguetown/roguehood
	name = "hood"
	desc = ""
	color = CLOTHING_BROWN
	icon_state = "basichood"
	item_state = "basichood"
	icon = 'icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head.dmi' //Overrides slot icon behavior
	alternate_worn_layer  = 8.9 //On top of helmet
	body_parts_covered = NECK|HAIR|EARS|HEAD
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	sleevetype = null
	sleeved = null
	dynamic_hair_suffix = ""
	edelay_type = 1
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	max_integrity = 100
	sewrepair = TRUE
	block2add = FOV_BEHIND
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1

/obj/item/clothing/head/roguetown/roguehood/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/adjustable_clothing, NECK, null, null, 'sound/foley/equip/cloak (3).ogg', null, (UPD_HEAD|UPD_MASK))	//Standard hood

/obj/item/clothing/head/roguetown/roguehood/MiddleClick(mob/user)
	if(!ishuman(user))
		return
	if(flags_inv & HIDEHAIR)
		flags_inv &= ~HIDEHAIR
	else
		flags_inv |= HIDEHAIR
	user.update_inv_wear_mask()
	user.update_inv_head()

/obj/item/clothing/head/roguetown/roguehood/AltRightClick(mob/user)
	overarmor = !overarmor
	to_chat(user, span_info("I wear \the [src] [overarmor ? "under" : "over"] my hair."))
	if(overarmor)
		alternate_worn_layer = HOOD_LAYER //Below Hair Layer
	else
		alternate_worn_layer = BACK_LAYER //Above Hair Layer
	user.update_inv_wear_mask()
	user.update_inv_head()

/obj/item/clothing/head/roguetown/roguehood/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Right click to adjust the hood's coverage. Most fully-drawn hoods will hide the wearer's identity.")
	. += span_info("Middle click to toggle hair.")
	. += span_info("Alt Right click to move hood layer under or above hair.")

/obj/item/clothing/head/roguetown/roguehood/red
	color = CLOTHING_RED

/obj/item/clothing/head/roguetown/roguehood/black
	color = CLOTHING_BLACK

/obj/item/clothing/head/roguetown/roguehood/darkgreen
	color = "#264d26"

/obj/item/clothing/head/roguetown/roguehood/random/Initialize()
	color = pick("#544236", "#435436", "#543836", "#79763f")
	..()

/obj/item/clothing/head/roguetown/roguehood/mage/Initialize()
	color = pick("#4756d8", "#759259", "#bf6f39", "#c1b144", "#b8252c")
	..()

/obj/item/clothing/head/roguetown/roguehood/shalal
	name = "keffiyeh"
	desc = "A protective covering worn by those native to the desert."
	color = "#b8252c"
	icon_state = "shalal"
	item_state = "shalal"
	flags_inv = HIDEHAIR|HIDEFACIALHAIR|HIDEFACE|HIDEEARS
	sleevetype = null
	sleeved = null
	icon = 'icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head.dmi' //Overrides slot icon behavior
	alternate_worn_layer  = 8.9 //On top of helmet
	body_parts_covered = HEAD|HAIR|EARS|NECK
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	dynamic_hair_suffix = ""
	edelay_type = 1
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	hidesnoutADJ = TRUE
	blocksound = SOFTHIT
	max_integrity = 100
	sewrepair = TRUE
	mask_override = TRUE
	overarmor = FALSE
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1

/obj/item/clothing/head/roguetown/roguehood/shalal/black
	color = CLOTHING_BLACK

/obj/item/clothing/head/roguetown/roguehood/shalal/purple
	color = CLOTHING_PURPLE

/obj/item/clothing/head/roguetown/roguehood/shalal/hijab
	name = "hijab"
	desc = "Flowing like blood from a wound, this tithe of cloth-and-silk spills out to the shoulders. It carries the telltale mark of Naledian stitcheries."
	item_state = "hijab"
	icon_state = "hijab"
	hidesnoutADJ = FALSE
	flags_inv = HIDEEARS|HIDEHAIR|HIDEFACIALHAIR	//Does not hide face.
	block2add = null

/obj/item/clothing/head/roguetown/roguehood/shalal/hijab/raneshen
	name = "padded headscarf"
	desc = "A common sight amongst those travelling the long desert routes, it offers protection from the heat and a modicum of it against the beasts that prowl its more comfortable nites."
	slot_flags = ITEM_SLOT_HEAD
	max_integrity = 200
	armor = ARMOR_SPELLSINGER //basically the same as a warscholar hood
	item_state = "hijab"
	icon_state = "hijab"
	naledicolor = TRUE

/obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood
	name = "heavy hood"
	desc = "This thick lump of burlap completely shrouds your head, protecting it from harsh weather and nosey protagonists alike."
	color = CLOTHING_BROWN
	item_state = "heavyhood"
	icon_state = "heavyhood"
	hidesnoutADJ = FALSE

/obj/item/clothing/head/roguetown/roguehood/shalal/hijab/yoruku
	name = "shadowed hood"
	desc = "It sits just so, obscuring the face just enough to spoil recognition."
	color = CLOTHING_BLACK

// Holy Hoods

/obj/item/clothing/head/roguetown/roguehood/astrata
	name = "sun hood"
	desc = "A hood worn by those who favor Astrata. Praise the firstborn sun!"
	color = null
	icon_state = "astratahood"
	item_state = "astratahood"
	icon = 'icons/roguetown/clothing/head.dmi'
	body_parts_covered = NECK
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	dynamic_hair_suffix = ""
	edelay_type = 1
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	max_integrity = 180
	resistance_flags = FIRE_PROOF
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1

/obj/item/clothing/head/roguetown/roguehood/nochood
	name = "moon hood"
	desc = "A hood worn by those who favor Noc with a mask in the shape of a crescent."
	color = null
	icon_state = "nochood"
	item_state = "nochood"
	icon = 'icons/roguetown/clothing/head.dmi'
	body_parts_covered = NECK
	dynamic_hair_suffix = ""
	sewrepair = TRUE
	edelay_type = 1
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	max_integrity = 180
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1

/obj/item/clothing/head/roguetown/roguehood/abyssor
	name = "depths hood"
	desc = "A hood worn by the followers of Abyssor, with a unique, coral-shaped mask. How do they even see out of this?"
	color = null
	icon_state = "abyssorhood"
	item_state = "abyssorhood"
	icon = 'icons/roguetown/clothing/head.dmi'
	body_parts_covered = NECK
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	dynamic_hair_suffix = ""
	edelay_type = 1
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	max_integrity = 180
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1

/obj/item/clothing/head/roguetown/roguehood/eorahood
	name = "opera hood"
	desc = "An opera mask worn by the faithful of Eora, usually during their rituals. Comes with a hood that can be pulled up for warmth."
	color = null
	icon = 'icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	icon_state = "eorahood"
	bloody_icon = 'icons/effects/blood64.dmi'
	bloody_icon_state = "helmetblood"
	worn_x_dimension = 64
	worn_y_dimension = 64
	resistance_flags = FIRE_PROOF
	dynamic_hair_suffix = ""
	edelay_type = 1
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	max_integrity = 180
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1

/obj/item/clothing/head/roguetown/roguehood/ravoxgorget
	name = "ravox's tabard gorget"
	color = null
	icon_state = "ravoxgorget"
	item_state = "ravoxgorget"
	body_parts_covered = NECK
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	flags_inv = HIDENECK
	dynamic_hair_suffix = ""
	sewrepair = TRUE
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1
	block2add = null

// UN-Holy Hoods!
/obj/item/clothing/head/roguetown/roguehood/unholy
	name = "foreboding hood"
	desc = "A veil to the cultic and capricious. The runic sigils stitched along the hems teem with unimaginable knowledge, in the most literal sense of the word."
	max_integrity = ARMOR_INT_HELMET_CLOTH
	armor = ARMOR_PADDED
	color = null
	item_state = "warlockhood"
	icon_state = "warlockhood"

/obj/item/clothing/head/roguetown/roguehood/unholy/lich
	name = "ominous hood"
	desc = "An otherworldly veil, whispering the constant ponderances of a runic enigma. She watches over you; and Her grin is crooked into one of eternal malice."
	max_integrity = ARMOR_INT_HELMET_ANTAG

/obj/item/clothing/head/roguetown/roguehood/unholy/enchanted
	name = "ominously enchanted hood"
	desc = "An otherworldly veil, amythortz-woven and crackling with the unignorable truths of a runic enigma. She watches over you; and Her grin is crooked into one of eternal malice."
	max_integrity = ARMOR_INT_HELMET_ANTAG
	armor = ARMOR_SPELLSINGER
	item_state = "ewarlockhood"
	icon_state = "ewarlockhood"

//............... Feldshers Hood ............... //
/obj/item/clothing/head/roguetown/roguehood/feld
	name = "feldsher's hood"
	desc = "My cure is most effective."
	icon_state = "feldhood"
	item_state = "feldhood"
	body_parts_covered = HEAD|EARS|NOSE
	color = null
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1

//............... Physicians Hood ............... //
/obj/item/clothing/head/roguetown/roguehood/phys
	name = "physicker's hood"
	desc = "My cure is mostly effective."
	icon_state = "surghood"
	item_state = "surghood"
	body_parts_covered = HEAD|EARS|NOSE
	color = null
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1

//Agnostic variants for use in the loadout.

/obj/item/clothing/head/roguetown/roguehood/shroudscarlet
	name = "scarlet shroud"
	desc = "A billowing hood, carrying the aroma of granulated rosas."
	icon_state = "feldhood"
	item_state = "feldhood"
	body_parts_covered = HEAD|EARS|NOSE
	color = null
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1

/obj/item/clothing/head/roguetown/roguehood/shroudblack
	name = "black shroud"
	desc = "A billowing hood, carrying the aroma of smoldering charcoal."
	icon_state = "surghood"
	item_state = "surghood"
	body_parts_covered = HEAD|EARS|NOSE
	color = null
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1

/obj/item/clothing/head/roguetown/roguehood/shroudwhite
	name = "robed shroud"
	desc = "A billowing hood, carrying the aroma of a distant memory."
	icon_state = "whitehood"
	item_state = "whitehood"
	body_parts_covered = HEAD|EARS|NOSE
	color = null
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1

//

/obj/item/clothing/head/roguetown/roguehood/psydon
	name = "psydonian hood"
	desc = "A hood worn by Psydon's disciples, oft-worn in conjunction with its matching tabard. Made with spell-laced fabric to provide some protection."
	icon_state = "psydonhood"
	item_state = "psydonhood"
	color = null
	blocksound = SOFTHIT
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	body_parts_covered = NECK | HEAD | HAIR
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	prevent_crits = PREVENT_CRITS_NONE
	armor = ARMOR_SPELLSINGER
	dynamic_hair_suffix = ""
	edelay_type = 1
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	max_integrity = 200
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1

/obj/item/clothing/head/roguetown/roguehood/psydon/confessor
	name = "confessional hood"
	desc = "A loose-fitting piece of leatherwear that can be tightened on the move. Keeps rain, blood, and the tears of the sullied away."
	icon_state = "confessorhood"
	item_state = "confessorhood"
	color = null
	body_parts_covered = NECK | HEAD | HAIR
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	prevent_crits = PREVENT_CRITS_MOST
	armor = ARMOR_SPELLSINGER
	dynamic_hair_suffix = ""
	edelay_type = 1
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	max_integrity = 200
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1

/obj/item/clothing/head/roguetown/roguehood/hierophant
	name = "hierophant's pashmina"
	desc = "A thick hood that covers one's entire head, should they desire, or merely acts as a scarf otherwise. Made with spell-laced fabric to provide some protection against daemons and mortals alike."
	max_integrity = 100
	prevent_crits = PREVENT_CRITS_NONE
	armor = ARMOR_SPELLSINGER
	icon_state = "hijab"
	item_state = "hijab"
	naledicolor = TRUE
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1

/obj/item/clothing/head/roguetown/roguehood/pontifex
	name = "pontifex's pashmina"
	desc = "A slim hood with thin, yet dense fabric. Stretchy and malleable, allowing for full flexibility and mobility. Made with spell-laced fabric to provide some protection against daemons and mortals alike."
	max_integrity = 100
	prevent_crits = PREVENT_CRITS_NONE
	armor = ARMOR_SPELLSINGER
	icon_state = "monkhood"
	item_state = "monkhood"
	naledicolor = TRUE
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1

/obj/item/clothing/head/roguetown/roguehood/studded
	name = "studded hood"
	desc = "A padded hood splinted across creating a cocooon for whoever wears it - won't protect your face however."
	icon_state = "studhood"
	item_state = "studhood"
	body_parts_covered = NECK | HEAD | HAIR
	slot_flags = ITEM_SLOT_HEAD
	flags_inv = HIDEEARS|HIDEHAIR
	blocksound = SOFTHIT
	armor = ARMOR_LEATHER_STUDDED
	prevent_crits = PREVENT_CRITS_MOST
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER
	dynamic_hair_suffix = ""
	edelay_type = 1
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	block2add = null
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1

	color = CLOTHING_BROWN

/obj/item/clothing/head/roguetown/roguehood/studded/retinue //For skirmisher
	name = "guard studded hood"
	desc = "A padded hood splinted across creating a cocooon for whoever wears it - won't protect your face however. This one bears the heraldry of the local lord."
	detail_tag = "_detail"
	color = CLOTHING_AZURE
	detail_color = CLOTHING_WHITE

/obj/item/clothing/head/roguetown/roguehood/studded/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/adjustable_clothing, NECK, null, null, 'sound/foley/equip/cloak (3).ogg', null, (UPD_HEAD))
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_FENCERDEXTERITY)
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_HONORBOUND)

/obj/item/clothing/head/roguetown/roguehood/studded/retinue/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/head/roguetown/roguehood/studded/retinue/Initialize()
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/head/roguetown/roguehood/studded/retinue/lordcolor(primary,secondary)
	color = primary
	detail_color = secondary
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_armor()

/obj/item/clothing/head/roguetown/roguehood/studded/retinue/Destroy()
	GLOB.lordcolor -= src
	return ..()
