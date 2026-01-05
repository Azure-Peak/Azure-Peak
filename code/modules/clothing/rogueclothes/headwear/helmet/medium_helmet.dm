/obj/item/clothing/head/roguetown/helmet
	icon = 'icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head.dmi'
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_HIP
	name = "helmet"
	desc = "A helmet that doesn't get any more simple in design."
	body_parts_covered = HEAD|HAIR|NOSE
	icon_state = "nasal"
	sleevetype = null
	sleeved = null
	resistance_flags = FIRE_PROOF
	armor = ARMOR_PLATE
	clothing_flags = CANT_SLEEP_IN
	dynamic_hair_suffix = "+generic"
	bloody_icon_state = "helmetblood"
	equip_sound = 'sound/foley/equip/equip_armor.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	blocksound = PLATEHIT
	max_integrity = ARMOR_INT_HELMET_STEEL
	grid_height = 64
	grid_width = 64
	experimental_onhip = TRUE
	experimental_inhand = TRUE
	chunkcolor = "#8c9599"

/obj/item/clothing/head/roguetown/helmet/MiddleClick(mob/user)
	if(!ishuman(user))
		return
	if(flags_inv & HIDE_HEADTOP)
		flags_inv &= ~HIDE_HEADTOP
	else
		flags_inv |= HIDE_HEADTOP
	user.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -5,"sy" = -3,"nx" = 0,"ny" = 0,"wx" = 0,"wy" = -3,"ex" = 2,"ey" = -3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 8)
			if("onbelt")
				return list("shrink" = 0.42,"sx" = -3,"sy" = -8,"nx" = 6,"ny" = -8,"wx" = -1,"wy" = -8,"ex" = 3,"ey" = -8,"nturn" = 180,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 1,"sflip" = 0,"wflip" = 0,"eflip" = 8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/clothing/head/roguetown/helmet/skullcap
	name = "skull cap"
	desc = "An iron helmet which covers the top of the head."
	icon_state = "skullcap"
	body_parts_covered = HEAD|HAIR
	max_integrity = ARMOR_INT_HELMET_IRON
	smeltresult = /obj/item/ingot/iron

// Copper lamellar cap
/obj/item/clothing/head/roguetown/helmet/coppercap
	name = "lamellar cap"
	desc = "A heavy lamellar cap made out of copper. Despite the primitive material, it's an effective design that keeps the head safe."
	icon_state = "lamellar"
	smeltresult = /obj/item/ingot/copper
	armor = ARMOR_LEATHER
	max_integrity = ARMOR_INT_HELMET_LEATHER

/obj/item/clothing/head/roguetown/helmet/horned
	name = "horned cap"
	desc = "An iron helmet with two horns poking out of the sides."
	icon_state = "hornedcap"
	body_parts_covered = HEAD|HAIR
	smeltresult = /obj/item/ingot/iron
	max_integrity = ARMOR_INT_HELMET_IRON

/obj/item/clothing/head/roguetown/helmet/winged
	name = "winged cap"
	desc = "A helmet with two wings on its sides."
	icon_state = "wingedcap"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	bloody_icon = 'icons/effects/blood64.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64
	body_parts_covered = HEAD|HAIR

/obj/item/clothing/head/roguetown/helmet/kettle
	name = "kettle helmet"
	desc = "A steel helmet which protects the top and sides of the head."
	icon_state = "kettle"
	body_parts_covered = HEAD|HAIR|EARS
	armor = ARMOR_PLATE

/obj/item/clothing/head/roguetown/helmet/kettle/iron
	name = "iron kettle helmet"
	desc = "A kettle helmet made of iron. It protects the top and sides of the head."
	icon_state = "ikettle"
	smeltresult = /obj/item/ingot/iron
	max_integrity = ARMOR_INT_HELMET_IRON

/obj/item/clothing/head/roguetown/helmet/kettle/wide
	name = "wide kettle helmet"
	desc = "A steel helmet which protects the top and sides of the head. This one looks wider than others."
	icon_state = "kettlewide"

/obj/item/clothing/head/roguetown/helmet/kettle/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/cloth) && !detail_tag)
		var/choice = input(user, "Choose a color.", "Orle") as anything in COLOR_MAP + pridelist
		user.visible_message(span_warning("[user] adds [W] to [src]."))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		detail_color = COLOR_MAP[choice]
		detail_tag = "_detail"
		if(choice in pridelist)
			detail_tag = "_detailp"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/kettle/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/head/roguetown/helmet/sallet
	name = "sallet"
	icon_state = "sallet"
	desc = "A steel helmet which protects the ears."
	smeltresult = /obj/item/ingot/steel
	body_parts_covered = HEAD|HAIR|EARS

/obj/item/clothing/wrists/roguetown/bracers/jackchain/ComponentInitialize()
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_FENCERDEXTERITY)

/obj/item/clothing/head/roguetown/helmet/sallet/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/cloth) && !detail_tag)
		var/choice = input(user, "Choose a color.", "Orle") as anything in COLOR_MAP + pridelist
		user.visible_message(span_warning("[user] adds [W] to [src]."))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		detail_color = COLOR_MAP[choice]
		detail_tag = "_detail"
		if(choice in pridelist)
			detail_tag = "_detailp"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/sallet/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/head/roguetown/helmet/sallet/iron
	name = "iron sallet"
	icon_state = "isallet"
	desc = "A iron helmet which protects the ears."
	smeltresult = /obj/item/ingot/iron
	max_integrity = ARMOR_INT_HELMET_IRON

/obj/item/clothing/head/roguetown/helmet/sallet/visored
	name = "visored sallet"
	desc = "A steel helmet which protects the ears, nose, and eyes."
	icon_state = "sallet_visor"
	adjustable = CAN_CADJUST
	flags_inv = HIDEEARS|HIDEFACE|HIDESNOUT|HIDEHAIR
	flags_cover = HEADCOVERSEYES
	body_parts_covered = HEAD|EARS|HAIR|NOSE|EYES
	block2add = FOV_BEHIND
	smelt_bar_num = 2
	armor = ARMOR_PLATE
	stack_fovs = TRUE

/obj/item/clothing/head/roguetown/helmet/sallet/shishak
	name = "steel shishak"
	desc = "A flat decorated steel helmet of Aavnic make with a spike at the top end. A hanging layer of chainmail protects the sides of the head and even the neck."
	body_parts_covered = HEAD|EARS|HAIR|NECK
	max_integrity = ARMOR_INT_HELMET_STEEL + 50
	icon_state = "shishak"

/obj/item/clothing/head/roguetown/helmet/sallet/visored/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), HIDEEARS|HIDEHAIR, null, 'sound/items/visor.ogg', null, UPD_HEAD)	//Sallet. Hides ears at the very least since it's a helmet.

/obj/item/clothing/head/roguetown/helmet/sallet/visored/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/cloth) && !detail_tag)
		var/choice = input(user, "Choose a color.", "Orle") as anything in COLOR_MAP + pridelist
		user.visible_message(span_warning("[user] adds [W] to [src]."))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		detail_color = COLOR_MAP[choice]
		detail_tag = "_detail"
		if(choice in pridelist)
			detail_tag = "_detailp"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/sallet/visored/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/head/roguetown/helmet/sallet/visored/iron
	name = "iron visored sallet"
	icon_state = "isallet_visor"
	desc = "A iron helmet which protects the ears, nose, and eyes."
	smeltresult = /obj/item/ingot/iron
	max_integrity = ARMOR_INT_HELMET_IRON

/obj/item/clothing/head/roguetown/helmet/sallet/elven
	desc = "A steel helmet with a thin gold plating designed for Elven woodland guardians."
	icon_state = "bascinet_novisor"
	item_state = "bascinet_novisor"
	color = COLOR_ASSEMBLY_GOLD

/obj/item/clothing/head/roguetown/helmet/sallet/raneshen
	name = "kulah khud"
	desc = "A sturdy, conical helm that has served the Empire well throughout its many campaigns. It's a sight to see, thousands of these bobbing as an army marches. The only greater humiliation than losing it is losing one's medallion."
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	bloody_icon = 'icons/effects/blood64.dmi'
	icon_state = "raneshen"
	worn_x_dimension = 64
	worn_y_dimension = 64
	bloody_icon = 'icons/effects/blood64.dmi'

/obj/item/clothing/head/roguetown/helmet/otavan
	name = "otavan helmet"
	desc = "A helmet of Otavan make, similar in structure to a Psydonian Armet but fitted with an angular klappvisier."
	icon_state = "otavahelm"
	item_state = "otavahelm"
	adjustable = CAN_CADJUST
	emote_environment = 3
	body_parts_covered = FULL_HEAD
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2
	stack_fovs = TRUE

	detail_tag = "_detail"
	color = "#FFFFFF"
	detail_color = "#e08828"

/obj/item/clothing/head/roguetown/helmet/otavan/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/head/roguetown/helmet/otavan/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -5,"sy" = -3,"nx" = 0,"ny" = 0,"wx" = 0,"wy" = -3,"ex" = 2,"ey" = -3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 8)
			if("onbelt")
				return list("shrink" = 0.32,"sx" = -3,"sy" = -8,"nx" = 6,"ny" = -8,"wx" = -1,"wy" = -8,"ex" = 3,"ey" = -8,"nturn" = 180,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 1,"sflip" = 0,"wflip" = 0,"eflip" = 8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/clothing/head/roguetown/helmet/otavan/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), HIDEEARS, null, 'sound/items/visor.ogg', null, UPD_HEAD)	//Otavan. Only hides ears when open.

/obj/item/clothing/head/roguetown/helmet/elvenbarbute
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_HIP
	name = "elven barbute"
	desc = "It fits snugly on one's elven head, with special slots for their pointier ears."
	body_parts_covered = FULL_HEAD
	flags_inv = HIDEEARS|HIDEFACE|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	icon_state = "elven_barbute_full"
	item_state = "elven_barbute_full"
	armor = ARMOR_PLATE
	clothing_flags = 0
	block2add = FOV_BEHIND

/obj/item/clothing/head/roguetown/helmet/elvenbarbute/winged
	name = "winged elven barbute"
	desc = "A winged version of the elven barbute. They have always been known for their vanity."
	icon_state = "elven_barbute_winged"
	item_state = "elven_barbute_winged"

/obj/item/clothing/head/roguetown/helmet/bascinet
	name = "bascinet"
	desc = "A steel bascinet helmet. Though it lacks a visor, it still protects the head and ears."
	icon_state = "bascinet_novisor"
	item_state = "bascinet_novisor"
	emote_environment = 3
	body_parts_covered = HEAD|HAIR|EARS
	flags_inv = HIDEEARS|HIDEHAIR
	smeltresult = /obj/item/ingot/steel //STOP TOUCHING THE FOV IT IS NOT MEANT TO HAVE A FULL HELMET BLOCK ON IT THIS IS THE 3RD TIME SOMEONE DONE THIS.

/obj/item/clothing/head/roguetown/helmet/bascinet/pigface
	name = "pigface bascinet"
	desc = "A steel bascinet helmet with a pigface visor that protects the entire head and face. Add a feather to show the colors of your family or allegiance."
	icon_state = "bascinet"
	item_state = "bascinet"
	adjustable = CAN_CADJUST
	emote_environment = 3
	body_parts_covered = FULL_HEAD
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2
	stack_fovs = TRUE

/obj/item/clothing/head/roguetown/helmet/bascinet/pigface/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS|HIDEHAIR), null, 'sound/items/visor.ogg', null, UPD_HEAD)	//Standard helmet

/obj/item/clothing/head/roguetown/helmet/bascinet/pigface/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/feather) && !detail_tag)
		var/choice = input(user, "Choose a color.", "Plume") as anything in COLOR_MAP + pridelist
		detail_color = COLOR_MAP[choice]
		detail_tag = "_detail"
		user.visible_message(span_warning("[user] adds [W] to [src]."))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/bascinet/pigface/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull
	name = "hounskull bascinet"
	desc = "A bascinet with a conical visor, favored by those with snouts and whiskers. Nestle a feather onto the rim to display your allegiance."
	icon_state = "hounskull"
	item_state = "hounskull"

/obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS|HIDEHAIR), null, 'sound/items/visor.ogg', null, UPD_HEAD)	//Standard helmet


/obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/feather) && !detail_tag)
		var/choice = input(user, "Choose a color.", "Plume") as anything in COLOR_MAP
		detail_color = COLOR_MAP[choice]
		detail_tag = "_detail"
		user.visible_message(span_warning("[user] adds [W] to [src]."))
		user.transferItemToLoc(W, src, FALSE, FALSE)
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


/obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull/update_icon()
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

/obj/item/clothing/head/roguetown/helmet/bascinet/etruscan
	name = "klappvisier bascinet"
	desc = "A steel bascinet helmet with a straight visor, or \"klappvisier\", which can greatly reduce visibility. Though it was first developed in Etrusca, it is also widely used in Grenzelhoft."
	icon_state = "klappvisier"
	item_state = "klappvisier"
	adjustable = CAN_CADJUST
	emote_environment = 3
	body_parts_covered = FULL_HEAD
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2

/obj/item/clothing/head/roguetown/helmet/bascinet/etruscan/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/cloth) && !detail_tag)
		var/choice = input(user, "Choose a color.", "Orle") as anything in COLOR_MAP + pridelist
		user.visible_message(span_warning("[user] adds [W] to [src]."))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		detail_color = COLOR_MAP[choice]
		detail_tag = "_detail"
		if(choice in pridelist)
			detail_tag = "_detailp"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/bascinet/etruscan/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/head/roguetown/helmet/bascinet/etruscan/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS|HIDEHAIR), null, 'sound/items/visor.ogg', null, UPD_HEAD)	//Standard helmet

/obj/item/clothing/head/roguetown/helmet/kettle/jingasa
	name = "jingasa"
	desc = "A steel-reinforced conical hat with a decorative rim of fabric. It protects the head and ears as much as it shields the eyes from the sun."
	icon_state = "kazengunmedhelm"
	item_state = "kazengunmedhelm"
	detail_tag = "_detail"
	detail_color = "#FFFFFF"

/obj/item/clothing/head/roguetown/helmet/kettle/jingasa/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

// Warden Helmets
/obj/item/clothing/head/roguetown/helmet/bascinet/antler
	name = "wardens's helmet"
	desc = "A beastly snouted armet with the large horns of an elder saiga protruding from it. Residents of Azure Peak know not to fear such a sight in the wilds, for they are exclusively associated with the Azurian wardens."
	icon = 'icons/roguetown/clothing/special/warden.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/warden64.dmi'
	bloody_icon = 'icons/effects/blood64.dmi'
	icon_state = "wardenhelm"
	adjustable = CAN_CADJUST
	worn_x_dimension = 64
	worn_y_dimension = 64
	body_parts_covered = FULL_HEAD
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2
	experimental_inhand = FALSE
	experimental_onhip = FALSE

/obj/item/clothing/head/roguetown/helmet/bascinet/antler/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS|HIDEHAIR), null, 'sound/items/visor.ogg', null, UPD_HEAD)	//Standard helmet

//............... Eora Helmet ............... //
/obj/item/clothing/head/roguetown/helmet/sallet/eoran
	name = "eora helmet"
	desc = "A simple yet protective helmet forged in the style typical of Eoran worshippers. Upon it lays several laurels of flowers and other colorful ornaments followed by symbols noting the accomplishments and punishments of the owner's chapter."
	icon_state = "eorahelmsallet"
	item_state = "eorahelmsallet"

/obj/item/clothing/head/roguetown/helmet/sallet/warden
	flags_inv = HIDEFACE|HIDESNOUT
	body_parts_covered = FULL_HEAD
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	block2add = FOV_BEHIND

/obj/item/clothing/head/roguetown/helmet/sallet/warden/wolf
	name = "warden's volfskull helm"
	desc = "The large, intimidating skull of an elusive white volf, plated with steel on its inner side and given padding - paired together with a steel maille mask and worn with a linen shroud. Such trophies are associated with life-long game wardens and their descendants."
	icon = 'icons/roguetown/clothing/special/warden.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/warden.dmi'
	icon_state = "skullmet_volf"

/obj/item/clothing/head/roguetown/helmet/sallet/warden/goat
	name = "warden's ramskull helm"
	desc = "The large, intimidating horned skull of an elusive Azurian great ram, plated with steel on its inner side and given padding - paired together with a steel maille mask and worn with a linen shroud. Such trophies are associated with life-long foresters and their descendants."
	icon = 'icons/roguetown/clothing/special/warden.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/warden.dmi'
	icon_state = "skullmet_goat"

/obj/item/clothing/head/roguetown/helmet/sallet/warden/bear
	name = "warden's bearskull helm"
	desc = "The large, intimidating skull of a common direbear, plated with steel on its inner side and given padding - paired together with a steel maille mask and worn with a linen shroud. Such trophies are associated with life-long hunters and their descendants."
	icon = 'icons/roguetown/clothing/special/warden.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/warden.dmi'
	icon_state = "skullmet_bear"

/obj/item/clothing/head/roguetown/helmet/sallet/warden/rat
	name = "warden's rouskull helm"
	desc = "The large, intimidating skull of the rare giant rous, plated with steel on its inner side and given padding - paired together with a steel maille mask and worn with a linen shroud. Such trophies are associated with life-long sewer dwellers and their descendants."
	icon = 'icons/roguetown/clothing/special/warden.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/warden.dmi'
	icon_state = "skullmet_rat"

/obj/item/clothing/head/roguetown/roguehood/warden
	name = "warden's hood"
	desc = "A hunter's leather hood with two linen layers, sewn larger than usual to accommodate a helmet - or an animal's skull."
	color = null
	icon_state = "wardenhood"
	item_state = "wardenhood"
	icon = 'icons/roguetown/clothing/special/warden.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/warden.dmi'
	body_parts_covered = NECK
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	dynamic_hair_suffix = ""
	edelay_type = 1
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	max_integrity = 200

/obj/item/clothing/head/roguetown/roguehood/warden/antler
	name = "warden's antlered hood"
	desc = "A hunter's leather hood with two linen layers, sewn larger than usual tooo accommodate a helmet, and fitted with the large horns of an elder saiga."
	icon_state = "wardenhoodalt"
	item_state = "wardenhoodalt"
	icon = 'icons/roguetown/clothing/special/warden.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/warden64.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64
	bloody_icon = 'icons/effects/blood64.dmi'

/obj/item/clothing/head/roguetown/roguehood/warden/munitioneer
	name = "forgehound's hood"
	desc = "Beneath his gleaming mask, the fyrmanne smiles. He is a salamander upon the worlde, belching flame, cleaning away history, and leaving a new land for the lyving."
