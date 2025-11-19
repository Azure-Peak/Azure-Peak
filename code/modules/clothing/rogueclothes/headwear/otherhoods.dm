/obj/item/clothing/head/roguetown/antlerhood
	name = "antlerhood"
	desc = "A hood suited for druids and shamans."
	color = null
	flags_inv = HIDEEARS|HIDEHAIR
	icon_state = "antlerhood"
	item_state = "antlerhood"
	icon = 'icons/roguetown/clothing/head.dmi'
	body_parts_covered = HEAD|HAIR|EARS|NECK
	slot_flags = ITEM_SLOT_HEAD
	dynamic_hair_suffix = ""
	max_integrity = 80
	armor = ARMOR_CLOTHING
	prevent_crits = list(BCLASS_TWIST)
	anvilrepair = null
	sewrepair = TRUE
	blocksound = SOFTHIT
	salvage_result = /obj/item/natural/hide
	salvage_amount = 1

/obj/item/clothing/head/roguetown/beekeeper
	name = "beekeeper's hood"
	desc = ""
	flags_inv = HIDEEARS|HIDEHAIR
	icon_state = "beekeeper"
	item_state = "beekeeper"
	icon = 'icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head.dmi'
	alternate_worn_layer  = 8.9 //On top of helmet
	body_parts_covered = HEAD|HAIR|EARS|NECK
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	sleevetype = null
	sleeved = null
	dynamic_hair_suffix = ""
	edelay_type = 1
	adjustable = CANT_CADJUST
	toggle_icon_state = FALSE
	max_integrity = 100
	sewrepair = TRUE

/obj/item/clothing/head/roguetown/nochood
	name = "moon hood"
	desc = "A hood worn by those who favor Noc with a mask in the shape of a crescent."
	color = null
	icon_state = "nochood"
	item_state = "nochood"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	dynamic_hair_suffix = ""
	sewrepair = TRUE

/obj/item/clothing/head/roguetown/necrahood
	name = "death shroud"
	desc = "Wisps of dark fabric that cover your entire head and flutter gently in the breeze. Often worn by those who usher the dead to the afterlife."
	color = null
	icon_state = "necrahood"
	item_state = "necrahood"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	dynamic_hair_suffix = ""
	sewrepair = TRUE
/obj/item/clothing/head/roguetown/necramask
	name = "death mask"
	desc = "A hood with a decorated jaw bone at the chin, normally worn by some followers of Necra as a form of devotion"
	color = null
	icon_state = "deathface"
	item_state = "deathface"
	icon = 'icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head.dmi' //Overrides slot icon behavior
	body_parts_covered = NECK|MOUTH //Jaw bone
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	flags_inv = HIDEEARS|HIDESNOUT|HIDEHAIR|HIDEFACIALHAIR
	dynamic_hair_suffix = ""
	sewrepair = TRUE
	mask_override = TRUE

/obj/item/clothing/head/roguetown/dendormask
	name = "briarmask"
	desc = "A mask of wood and thorns worn by druids in service to Dendor."
	color = null
	icon_state = "dendormask"
	item_state = "dendormask"
	icon = 'icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head.dmi' 
	body_parts_covered = MOUTH
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	dynamic_hair_suffix = ""
	sewrepair = TRUE
	mask_override = TRUE

/obj/item/clothing/head/roguetown/necromhood
	name = "necromancers hood"
	color = null
	icon_state = "necromhood"
	item_state = "necromhood"
	body_parts_covered = NECK
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	dynamic_hair_suffix = ""
	sewrepair = TRUE

/obj/item/clothing/head/roguetown/menacing
	name = "sack hood"
	desc = "A hood commonly worn by executioners to hide their face; The stigma of such a role, and all the grisly work it entails, makes many executioners outcasts in their own right."
	icon_state = "menacing"
	item_state = "menacing"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	dynamic_hair_suffix = ""
	sewrepair = TRUE
	color = "#999999"
	//dropshrink = 0.75

/obj/item/clothing/head/roguetown/menacing/bandit
	icon_state = "bandithood"

/obj/item/clothing/head/roguetown/jester
	name = "jester's hat"
	desc = "A funny-looking hat with jingly bells attached to it."
	icon_state = "jester"
	item_state = "jester"
	detail_tag = "_detail"
	altdetail_tag = "_detailalt"
	dynamic_hair_suffix = "+generic"
	sewrepair = TRUE
	flags_inv = HIDEEARS
	detail_color = CLOTHING_WHITE
	color = CLOTHING_AZURE
	altdetail_color = CLOTHING_WHITE

/obj/item/clothing/head/roguetown/jester/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/head/roguetown/jester/lordcolor(primary,secondary)
	detail_color = secondary
	color = primary
	update_icon()

/obj/item/clothing/head/roguetown/jester/Initialize()
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_JINGLE_BELLS, 2)
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	else
		GLOB.lordcolor += src

/obj/item/clothing/head/roguetown/jester/jester/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/head/roguetown/jester/MiddleClick(mob/user)
	if(!ishuman(user))
		return
	if(flags_inv & HIDE_HEADTOP)
		flags_inv &= ~HIDE_HEADTOP
	else
		flags_inv |= HIDE_HEADTOP
	user.update_inv_head()
