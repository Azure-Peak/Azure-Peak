
/obj/item/clothing/head/roguetown/helmet/blacksteel/modern/armet
	name = "blacksteel armet"
	desc = "A magnificent greathelm of blacksteel, bearing the handiwork of Psydonia's finest blacksmiths. Beneath the visor most-assuredly lays a legendary guise; be it a commander's glare, a conquerer's sneer, or a champion's observance."
	body_parts_covered = FULL_HEAD
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	icon_state = "bplatehelm"
	item_state = "bplatehelm"
	flags_inv = HIDEEARS|HIDEFACE|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	armor = ARMOR_PLATE_BSTEEL
	prevent_crits = PREVENT_CRITS_ALL
	block2add = FOV_BEHIND
	adjustable = CAN_CADJUST
	max_integrity = ARMOR_INT_HELMET_BLACKSTEEL
	smeltresult = /obj/item/ingot/blacksteel
	smelt_bar_num = 2
	chunkcolor = "#303036"
	material_category = ARMOR_MAT_PLATE

/obj/item/clothing/head/roguetown/helmet/blacksteel/modern/armet/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS|HIDEHAIR), null, 'sound/items/visor.ogg', null, UPD_HEAD)	//Standard helmet

/obj/item/clothing/head/roguetown/helmet/blacksteel/modern/armet/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/feather) && !detail_tag)
		var/choice = input(user, "Choose a color.", "Plume") as anything in COLOR_MAP
		user.visible_message(span_warning("[user] adds [W] to [src]."))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		detail_color = COLOR_MAP[choice]
		detail_tag = "_detail"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()
	if(istype(W, /obj/item/natural/cloth) && !altdetail_tag)
		var/choicealt = input(user, "Choose a color.", "Orle") as anything in COLOR_MAP + pridelist
		user.visible_message(span_warning("[user] adds [W] to [src]."))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		altdetail_color = COLOR_MAP[choicealt]
		altdetail_tag = "_detailalt"
		if(choicealt in pridelist)
			detail_tag = "_detailp"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/blacksteel/modern/armet/armet/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)
	if(get_altdetail_tag())
		var/mutable_appearance/pic2 = mutable_appearance(icon(icon, "[icon_state][altdetail_tag]"))
		pic2.appearance_flags = RESET_COLOR
		if(get_altdetail_color())
			pic2.color = get_altdetail_color()
		add_overlay(pic2)

/obj/item/clothing/head/roguetown/helmet/blacksteel/bucket
	name = "blacksteel bucket helm"
	desc = "An antiquated greathelm of blacksteel, crested with a thick and luscious plume. How much will it take for your faith to sway - and how little will it be? Will you clasp to the atrocities of the past and believe yourself unredeemable, or will you mantle the burden of doing what is right? </br>‎  </br>It is never too late to change; for the better, and for the worse."
	body_parts_covered = FULL_HEAD
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	icon_state = "bkhelm"
	item_state = "bkhelm"
	flags_inv = HIDEEARS|HIDEFACE|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	armor = ARMOR_PLATE_BSTEEL
	prevent_crits = PREVENT_CRITS_ALL
	block2add = FOV_BEHIND
	max_integrity = ARMOR_INT_HELMET_BLACKSTEEL
	smeltresult = /obj/item/ingot/blacksteel
	smelt_bar_num = 2
	chunkcolor = "#303036"
	material_category = ARMOR_MAT_PLATE

/obj/item/clothing/head/roguetown/helmet/blacksteel/psythorns
	name = "crown of psydonian thorns"
	desc = "Thorns fashioned from pliable yet durable blacksteel - woven and interlinked, fashioned to be worn upon the head."
	body_parts_covered = HAIR | HEAD
	icon_state = "psybarbs"
	item_state = "psybarbs"
	armor = ARMOR_PLATE_BSTEEL
	prevent_crits = PREVENT_CRITS_ALL
	blocksound = PLATEHIT
	resistance_flags = FIRE_PROOF
	max_integrity = ARMOR_INT_SIDE_BLACKSTEEL
	anvilrepair = /datum/skill/craft/armorsmithing
	sewrepair = FALSE
	icon = 'icons/roguetown/clothing/wrists.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head.dmi'
	alternate_worn_layer  = 8.9 //On top of helmet
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK

/obj/item/clothing/head/roguetown/helmet/blacksteel/psythorns/attack_self(mob/living/user)
	. = ..()
	user.visible_message(span_warning("[user] starts to reshape the [src]."))
	if(do_after(user, 4 SECONDS))
		var/obj/item/clothing/wrists/roguetown/bracers/psythorns/P = new /obj/item/clothing/wrists/roguetown/bracers/psythorns(get_turf(src.loc))
		if(user.is_holding(src))
			user.dropItemToGround(src)
			user.put_in_hands(P)
		P.obj_integrity = src.obj_integrity
		user.adjustBruteLoss(25)
		qdel(src)
	else
		user.visible_message(span_warning("[user] stops reshaping [src]."))
		return

// What is this, fake Blacksteel? As of 12/15/2025 it isn't used anywhere in-game.
/obj/item/clothing/head/roguetown/helmet/heavy/blkknight
	name = "black knight helmet" // "blacksteel helmet"
	icon_state = "bkhelm"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'

/obj/item/clothing/head/roguetown/helmet/heavy/blkknight/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS|HIDEHAIR), null, 'sound/items/visor.ogg', null, UPD_HEAD)

/obj/item/clothing/head/roguetown/helmet/heavy/blkknight/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/feather) && !detail_tag)
		var/choice = input(user, "Choose a color.", "Plume") as anything in COLOR_MAP
		user.visible_message(span_warning("[user] adds [W] to [src]."))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		detail_color = COLOR_MAP[choice]
		detail_tag = "_detail"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()
	if(istype(W, /obj/item/natural/cloth) && !altdetail_tag)
		var/choicealt = input(user, "Choose a color.", "Orle") as anything in COLOR_MAP
		user.visible_message(span_warning("[user] adds [W] to [src]."))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		altdetail_color = COLOR_MAP[choicealt]
		altdetail_tag = "_detailalt"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/heavy/blkknight/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)
	if(get_altdetail_tag())
		var/mutable_appearance/pic2 = mutable_appearance(icon(icon, "[icon_state][altdetail_tag]"))
		pic2.appearance_flags = RESET_COLOR
		if(get_altdetail_color())
			pic2.color = get_altdetail_color()
		add_overlay(pic2)
