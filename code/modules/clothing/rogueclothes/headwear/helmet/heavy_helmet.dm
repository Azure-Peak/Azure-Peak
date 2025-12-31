/obj/item/clothing/head/roguetown/helmet/heavy
	name = "barbute"
	desc = "A simple helmet with a visor in the shape of a Y."
	body_parts_covered = FULL_HEAD
	icon_state = "barbute"
	item_state = "barbute"
	flags_inv = HIDEEARS|HIDEFACE|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	armor = ARMOR_PLATE
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	max_integrity = ARMOR_INT_HELMET_HEAVY_STEEL
	armor_class = ARMOR_CLASS_MEDIUM	//Heavy helmets require at least medium armor training. Stops no-armor training plate-headgear users.
	smelt_bar_num = 1
	stack_fovs = TRUE

/obj/item/clothing/head/roguetown/helmet/heavy/aalloy
	name = "decrepit barbute"
	desc = "Frayed bronze plates, pounded into a visored helmet. Scrapes and dents line the curved plating, weathered from centuries of neglect. The remains of a plume's stub hang atop its rim."
	body_parts_covered = COVERAGE_HEAD
	max_integrity = ARMOR_INT_HELMET_HEAVY_DECREPIT
	icon_state = "ancientbarbute"
	color = "#bb9696"
	chunkcolor = "#532e25"
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null
	prevent_crits = PREVENT_CRITS_NONE

/obj/item/clothing/head/roguetown/helmet/heavy/aalloy/attackby(obj/item/W, mob/living/user, params)
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

/obj/item/clothing/head/roguetown/helmet/heavy/aalloy/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/head/roguetown/helmet/heavy/kabuto
	name = "kabuto"
	desc = "A Kazengunite helmet of steel plates, gilded in blacksteel and gold trim alike to evoke feelings of nobility and strength. Commonly worn with a mask or mouthguard."
	flags_inv = HIDEEARS
	flags_cover = null
	icon_state = "kazengunheavyhelm"

/obj/item/clothing/head/roguetown/helmet/heavy/paalloy
	name = "ancient barbute"
	desc = "Polished gilbranze plates, pounded to form a visored helmet. Zizo commands progress, and progress commands sacrifice; let these sundered legionnaires rise again, to spill the blood of unenlightened fools. A coiled pocket is perched atop the rim, awaiting to be plumed."
	icon_state = "ancientbarbute"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/clothing/head/roguetown/helmet/heavy/paalloy/attackby(obj/item/W, mob/living/user, params)
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


/obj/item/clothing/head/roguetown/helmet/heavy/guard
	name = "steel savoyard"
	desc = "A helmet with a menacing visage."
	icon_state = "steelsavoyard"
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2

/obj/item/clothing/head/roguetown/helmet/heavy/guard/bogman
	name = "steel bogman's helmet"
	desc = "A helmet featuring the face of a snarling goblin. Once worn by the Bogmen, now a relic of old Azuria."
	icon_state = "guardhelm"

/obj/item/clothing/head/roguetown/helmet/heavy/guard/aalloy
	name = "decrepit savoyard"
	desc = "Frayed bronze plates, molded into a ventilated casket. It reeks of fetid shit, and each breath - labored and strained - is laced with flaked metal."
	max_integrity = ARMOR_INT_HELMET_HEAVY_DECREPIT
	icon_state = "ancientsavoyard"
	color = "#bb9696"
	chunkcolor = "#532e25"
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null
	prevent_crits = PREVENT_CRITS_NONE

/obj/item/clothing/head/roguetown/helmet/heavy/guard/paalloy
	name = "ancient savoyard"
	desc = "Polished gilbranze plates, molded into a bulwark's greathelm. The Comet Syon's glare has been forever burnt into the alloy; a decayed glimpse into the world that was, before Psydon's slumber and Zizo's awakening."
	icon_state = "ancientsavoyard"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/clothing/head/roguetown/helmet/heavy/sheriff
	name = "barred helmet"
	desc = "A helmet which offers good protection to the face at the expense of vision."
	icon_state = "gatehelm"
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2

/obj/item/clothing/head/roguetown/helmet/heavy/knight
	name = "knight's armet"
	desc = "A noble knight's helm in the current style popular with nobility. Add a feather to show the colors of your family or allegiance."
	icon_state = "knight"
	item_state = "knight"
	adjustable = CAN_CADJUST
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	block2add = FOV_BEHIND
	max_integrity = ARMOR_INT_HELMET_HEAVY_STEEL - ARMOR_INT_HELMET_HEAVY_ADJUSTABLE_PENALTY
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2

/obj/item/clothing/head/roguetown/helmet/heavy/knight/black
	color = CLOTHING_GREY

/obj/item/clothing/head/roguetown/helmet/heavy/knight/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS|HIDEHAIR), null, 'sound/items/visor.ogg', null, UPD_HEAD)	//Standard helmet

/obj/item/clothing/head/roguetown/helmet/heavy/knight/attackby(obj/item/W, mob/living/user, params)
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

/obj/item/clothing/head/roguetown/helmet/heavy/knight/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/head/roguetown/helmet/heavy/knight/fluted
	name = "fluted armet"
	desc = "An ornate steel greathelm with a visor, which protects the entire head. While bulky, the fluted design excels at prolonging chivalrous bouts with fellow knights. Add a feather to show the colors of your family or allegiance."

/obj/item/clothing/head/roguetown/helmet/heavy/knight/iron
	name = "iron knight's armet"
	icon_state = "iknight"
	desc = "A noble knight's helm made of iron."
	smeltresult = /obj/item/ingot/iron
	max_integrity = ARMOR_INT_HELMET_HEAVY_IRON

/obj/item/clothing/head/roguetown/helmet/heavy/knight/old
	name = "knight's helmet"
	icon_state = "knightclassic"

/obj/item/clothing/head/roguetown/helmet/heavy/knight/old/iron
	name = "iron knight's helmet"
	icon_state = "iknightclassic"
	smeltresult = /obj/item/ingot/iron
	max_integrity = ARMOR_INT_HELMET_HEAVY_IRON

/obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle
	name = "slitted kettle helm"
	desc = "A reinforced Eisenhut that's been extended downwards to cover the face, fully protecting the wearer but limiting his field of view. Pairs well with a bevor."
	icon_state = "skettle"
	item_state = "skettle"
	max_integrity = ARMOR_INT_HELMET_HEAVY_STEEL
	adjustable = CANT_CADJUST

/obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle/attackby(obj/item/W, mob/living/user, params)
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

/obj/item/clothing/head/roguetown/helmet/heavy/knight/armet
	name = "armet"
	desc = "Holy lamb, sacrificial hero, blessed idiot - Psydon endures. Will you endure alongside Him, as a knight of humenity, or crumble before temptation?"
	icon_state = "armet"

/obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS|HIDEHAIR), null, 'sound/items/visor.ogg', null, UPD_HEAD)	//Standard helmet

/obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/attackby(obj/item/W, mob/living/user, params)
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


/obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/update_icon()
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


/obj/item/clothing/head/roguetown/helmet/heavy/bucket/gold
	name = "golden helmet"
	icon_state = "topfhelm_gold"
	item_state = "topfhelm_gold"
	desc = "A full-head covering helm with the engravings of Ravox. Bravery. Justice. Ever Unyielding."

/obj/item/clothing/head/roguetown/helmet/heavy/bucket/ravox/attackby(obj/item/W, mob/living/user, params)
	return

/obj/item/clothing/head/roguetown/helmet/heavy/bucket
	name = "bucket helmet"
	desc = "A helmet which covers the whole of the head. Offers excellent protection."
	icon_state = "topfhelm"
	item_state = "topfhelm"
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2

/obj/item/clothing/head/roguetown/helmet/heavy/bucket/attackby(obj/item/W, mob/living/user, params)
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

/obj/item/clothing/head/roguetown/helmet/heavy/bucket/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/head/roguetown/helmet/heavy/xylixhelm
	name = "xylixian helmet"
	desc = "I dance, I sing! I'll be your fool!"
	icon_state = "xylixhelmet"
	item_state = "xylixhelmet"
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2

/obj/item/clothing/head/roguetown/helmet/heavy/xylixhelm/Initialize()
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_JINGLE_BELLS, 2)

/obj/item/clothing/head/roguetown/helmet/heavy/astratahelm
	name = "astrata helmet"
	desc = "Headwear commonly worn by Templars in service to Astrata. The firstborn child's light will forever shine on within its crest."
	icon_state = "astratahelm"
	item_state = "astratahelm"
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2

/obj/item/clothing/head/roguetown/helmet/heavy/psydonbarbute
	name = "psydonic barbute"
	desc = "A ceremonial barbute, masterfully forged to represent Psydon's divine authority. The Order of Saint Malum's artisans have chiseled this pronged visage into more statues than you could possibly imagine."
	icon_state = "psydonbarbute"
	item_state = "psydonbarbute"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT

/obj/item/clothing/head/roguetown/helmet/heavy/psydonbarbute/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -5,"sy" = -3,"nx" = 0,"ny" = 0,"wx" = 0,"wy" = -3,"ex" = 2,"ey" = -3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 8)
			if("onbelt")
				return list("shrink" = 0.32,"sx" = -3,"sy" = -8,"nx" = 6,"ny" = -8,"wx" = -1,"wy" = -8,"ex" = 3,"ey" = -8,"nturn" = 180,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 1,"sflip" = 0,"wflip" = 0,"eflip" = 8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm
	name = "psydonic armet"
	desc = "An ornate helmet, whose visor has been bound shut with blacksteel chains. The Order of Saint Eora often decorates these armets with flowers - not only as a lucky charm gifted to them by fair maidens and family, but also as a vibrant reminder that 'happiness has to be fought for.'"
	icon_state = "psydonarmet"
	item_state = "psydonarmet"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	adjustable = CAN_CADJUST
	max_integrity = ARMOR_INT_HELMET_HEAVY_STEEL - ARMOR_INT_HELMET_HEAVY_ADJUSTABLE_PENALTY
	smeltresult = /obj/item/ingot/silver

/obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -5,"sy" = -3,"nx" = 0,"ny" = 0,"wx" = 0,"wy" = -3,"ex" = 2,"ey" = -3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 8)
			if("onbelt")
				return list("shrink" = 0.32,"sx" = -3,"sy" = -8,"nx" = 6,"ny" = -8,"wx" = -1,"wy" = -8,"ex" = 3,"ey" = -8,"nturn" = 180,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 1,"sflip" = 0,"wflip" = 0,"eflip" = 8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS|HIDEHAIR), null, 'sound/items/visor.ogg', null, UPD_HEAD)	//Standard helmet

/obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm/attackby(obj/item/W, mob/living/user, params)
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
	if(istype(W, /obj/item/natural/feather) && !altdetail_tag)
		var/choicealt = input(user, "Choose a color.", "Plume") as anything in COLOR_MAP
		user.visible_message(span_warning("[user] adds [W] to [src]."))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		altdetail_color = COLOR_MAP[choicealt]
		altdetail_tag = "_detailalt"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm/update_icon()
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

/obj/item/clothing/head/roguetown/helmet/heavy/ordinatorhelm
	name = "inquisitorial ordinator's helmet"
	desc = "A design suggested by a Grenzelhoftian smith, an avid follower of Saint Abyssor - implying to base it on the templar's greathelm design, and it was proved worthy of usage: A steel casket with thin slits that allow for deceptively clear vision. The tainted will drown on the blood you will bring their way."
	icon_state = "ordinatorhelm"
	item_state = "ordinatorhelm"
	worn_x_dimension = 64
	worn_y_dimension = 64
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	bloody_icon = 'icons/effects/blood64.dmi'
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	adjustable = CAN_CADJUST
	max_integrity = ARMOR_INT_HELMET_HEAVY_STEEL - ARMOR_INT_HELMET_HEAVY_ADJUSTABLE_PENALTY
	var/plumed = FALSE

/obj/item/clothing/head/roguetown/helmet/heavy/ordinatorhelm/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS|HIDEHAIR), null, 'sound/items/visor.ogg', null, UPD_HEAD)	//Standard helmet

/obj/item/clothing/head/roguetown/helmet/heavy/ordinatorhelm/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/feather))
		user.visible_message(span_warning("[user] starts to fashion plumage using [W] for [src]."))
		if(do_after(user, 4 SECONDS))
			var/obj/item/clothing/head/roguetown/helmet/heavy/ordinatorhelm/plume/P = new /obj/item/clothing/head/roguetown/helmet/heavy/ordinatorhelm/plume(get_turf(src.loc))
			if(user.is_holding(src))
				user.dropItemToGround(src)
				user.put_in_hands(P)
			P.obj_integrity = src.obj_integrity
			qdel(src)
			qdel(W)
		else
			user.visible_message(span_warning("[user] stops fashioning plumage for [src]."))
		return

/obj/item/clothing/head/roguetown/helmet/heavy/ordinatorhelm/plume
	icon_state = "ordinatorhelmplume"
	item_state = "ordinatorhelmplume"

/obj/item/clothing/head/roguetown/helmet/heavy/ordinatorhelm/plume/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/natural/feather))
		return
	..()

/obj/item/clothing/head/roguetown/helmet/heavy/absolver
	name = "psydonic conical helm"
	desc = "Based on the visage worn by Saint Pestra's order, this cryptic helmet provides its wearer with the satisfaction of reminding heretics that fear is not an emotion easily lost. Even the dead may learn to taste terror again."
	icon_state = "absolutionisthelm"
	item_state = "absolutionisthelm"
	emote_environment = 3
	body_parts_covered = FULL_HEAD|NECK
	block2add = FOV_RIGHT|FOV_LEFT
	max_integrity = ARMOR_INT_HELMET_HEAVY_STEEL + ARMOR_INT_HELMET_HEAVY_ADJUSTABLE_PENALTY // Worst vision. Yes.
	worn_x_dimension = 64
	worn_y_dimension = 64
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	bloody_icon = 'icons/effects/blood64.dmi'
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	smeltresult = /obj/item/ingot/silver

/obj/item/clothing/head/roguetown/helmet/heavy/psybucket
	name = "psydonic bucket helmet"
	desc = "Worn by the blade-carrying arms of Saint Astrata and Saint Ravox, it is a true-and-tested design. Steel encapsulates your head, and His cross when facing enemies reminds them that you will endure until they meet oblivion. Only then may you rest."
	icon_state = "psybucket"
	item_state = "psybucket"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	adjustable = CAN_CADJUST
	max_integrity = ARMOR_INT_HELMET_HEAVY_STEEL
	smeltresult = /obj/item/ingot/silver

/obj/item/clothing/head/roguetown/helmet/heavy/psysallet
	name = "psydonic sallet"
	desc = "A boiled leather cap, crowned with steel and veiled with His cross. Fear not - He will show you the way, and He will see your blows well-struck."
	icon_state = "psysallet"
	item_state = "psysallet"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	adjustable = CAN_CADJUST
	max_integrity = ARMOR_INT_HELMET_HEAVY_STEEL
	smeltresult = /obj/item/ingot/silver

/obj/item/clothing/head/roguetown/helmet/heavy/nochelm
	name = "noc helmet"
	desc = "Headwear commonly worn by Templars in service to Noc. Without the night there can be no day; without Noc there can be no light in the dark hours."
	icon_state = "nochelm"
	item_state = "nochelm"
	emote_environment = 3
	body_parts_covered = HEAD|HAIR|EARS
	flags_inv = HIDEEARS|HIDEHAIR
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2

/obj/item/clothing/head/roguetown/helmet/heavy/necrahelm
	name = "necra helmet"
	desc = "Headwear commonly worn by Templars in service to Necra. Let its skeletal features remind you of the only thing which is guaranteed in life: You will die."
	icon_state = "necrahelm"
	item_state = "necrahelm"
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2

/obj/item/clothing/head/roguetown/helmet/heavy/dendorhelm
	name = "dendor helmet"
	desc = "Headwear commonly worn by Templars in service to Dendor. Its protrusions almost resemble branches. Take root in the earth, and you will never be moved."
	icon_state = "dendorhelm"
	item_state = "dendorhelm"
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2

/obj/item/clothing/head/roguetown/helmet/heavy/abyssorgreathelm
	name = "abyssorite helmet"
	desc = "A helmet commonly worn by Templars in service to Abyssor. It evokes imagery of the sea with a menacing crustacean visage."
	icon_state = "abyssorgreathelm"
	item_state = "abyssorgreathelm"
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2

/obj/item/clothing/head/roguetown/helmet/heavy/ravoxhelm
	name = "justice eagle"
	desc = "Forged in reverence to Ravox, this helm bears the stylized visage of an eagle, symbol of unyielding judgment and divine vigilance. Its hollow eyes see not just foes, but the truth behind every deed."
	icon_state = "ravoxhelmet"
	item_state = "ravoxhelmet"
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2

/obj/item/clothing/head/roguetown/helmet/heavy/ravoxhelm/attackby(obj/item/W, mob/living/user, params)
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

/obj/item/clothing/head/roguetown/helmet/heavy/volfplate
	name = "volf-face helm"
	desc = "A steel bascinet helmet with a volfish visor protecting the head, ears, eyes, nose and mouth."
	icon_state = "volfplate"
	item_state = "volfplate"
	adjustable = CAN_CADJUST
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	max_integrity = ARMOR_INT_HELMET_HEAVY_STEEL - ARMOR_INT_HELMET_HEAVY_ADJUSTABLE_PENALTY
	armor_class = null	//Needs no armor class, snowflake merc gear.

/obj/item/clothing/head/roguetown/helmet/heavy/volfplate/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS|HIDEHAIR), null, 'sound/items/visor.ogg', null, UPD_HEAD)	//Standard helmet

/obj/item/clothing/head/roguetown/helmet/heavy/volfplate/puritan
	name = "volfskulle bascinet"
	desc = "A steel bascinet helmet with a snarling visor that protects the entire head and face. It mimics the guise of a terrible nitebeast; intimidating to the levyman, inspiring to the hunter."

/obj/item/clothing/head/roguetown/helmet/heavy/volfplate/berserker
	name = "volfskulle bascinet"
	desc = "A steel bascinet helmet with a snarling visor that protects the entire head and face. Just like the nitebeasts it mimics, so too does the helmet's teeth glisten with flesh-sundering sharpness."
	armor_class = ARMOR_CLASS_LIGHT //Pseudoantagonist-exclusive. Gives them an edge over traditional pugilists and barbarians.
	var/active_item = FALSE

/obj/item/clothing/head/roguetown/helmet/heavy/volfplate/berserker/equipped(mob/living/user, slot)
	. = ..()
	if(slot == SLOT_HEAD)
		active_item = TRUE
		ADD_TRAIT(user, TRAIT_BITERHELM, TRAIT_GENERIC)
		to_chat(user, span_red("The bascinet's visor chitters, and your jaw tightens with symbiotic intent.."))
	return

/obj/item/clothing/head/roguetown/helmet/heavy/volfplate/berserker/dropped(mob/living/user)
	..()
	if(!active_item)
		return
	active_item = FALSE
	REMOVE_TRAIT(user, TRAIT_BITERHELM, TRAIT_GENERIC)
	to_chat(user, span_red("..and like that, the bascinet's visor goes dormant once more - a strange pressure, relieved from your jaw."))

/obj/item/clothing/head/roguetown/helmet/heavy/elven_helm
	name = "woad elven helm"
	desc = "An assembly of woven trunk, kept alive by ancient song, now twisted and warped for battle and scorn."
	body_parts_covered = FULL_HEAD | NECK
	armor = list("blunt" = 100, "slash" = 20, "stab" = 110, "piercing" = 40, "fire" = 0, "acid" = 0)//Resistant to blunt & stab, but very weak to slash.
	prevent_crits = PREVENT_CRITS_ALL
	icon = 'icons/roguetown/clothing/special/race_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/race_armor.dmi'
	icon_state = "welfhead"
	item_state = "welfhead"
	block2add = FOV_BEHIND
	bloody_icon = 'icons/effects/blood64.dmi'
	drop_sound = 'sound/foley/dropsound/wooden_drop.ogg'
	smeltresult = /obj/item/rogueore/coal
	anvilrepair = /datum/skill/craft/carpentry
	max_integrity = ARMOR_INT_HELMET_HEAVY_IRON // Weaker than usual because it is good vs blunt and stab
	blocksound = SOFTHIT
	experimental_inhand = FALSE
	experimental_onhip = FALSE

/obj/item/clothing/head/roguetown/helmet/heavy/frogmouth
	name = "froggemund helmet"
	desc = "A tall and imposing frogmouth-style helm popular in the highest plateaus of the Azure Peak. It covers not only the entire head and face, but the neck as well. Add a cloth to show the colors of your family or allegiance."
	icon_state = "frogmouth"
	item_state = "frogmouth"
	emote_environment = 3
	prevent_crits = PREVENT_CRITS_ALL
	body_parts_covered = FULL_HEAD|NECK
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR
	block2add = FOV_RIGHT|FOV_LEFT
	max_integrity = ARMOR_INT_HELMET_HEAVY_STEEL + ARMOR_INT_HELMET_HEAVY_ADJUSTABLE_PENALTY // Worst vision. Yes.
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2

/obj/item/clothing/head/roguetown/helmet/heavy/frogmouth/attackby(obj/item/W, mob/living/user, params)
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

/obj/item/clothing/head/roguetown/helmet/heavy/frogmouth/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)


/obj/item/clothing/head/roguetown/helmet/heavy/matthios
	name = "gilded visage"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	bloody_icon = 'icons/effects/blood64.dmi'
	desc = "All that glitters is not gold,"
	flags_inv = HIDEEARS|HIDEFACE|HIDESNOUT|HIDEHAIR|HIDEFACIALHAIR
	icon_state = "matthioshelm"
	max_integrity = ARMOR_INT_HELMET_ANTAG
	prevent_crits = PREVENT_CRITS_ALL
	worn_x_dimension = 64
	worn_y_dimension = 64
	bloody_icon = 'icons/effects/blood64.dmi'
	experimental_inhand = FALSE
	experimental_onhip = FALSE

/obj/item/clothing/head/roguetown/helmet/heavy/matthios/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_COMMIE, "ARMOR")

/obj/item/clothing/head/roguetown/helmet/heavy/graggar
	name = "vicious helmet"
	desc = "A rugged helmet which stirs with the same violence which drives our world."
	icon_state = "graggarplatehelm"
	max_integrity = ARMOR_INT_HELMET_ANTAG
	flags_inv = HIDEEARS|HIDEFACE|HIDESNOUT|HIDEHAIR|HIDEFACIALHAIR
	prevent_crits = PREVENT_CRITS_ALL
	var/active_item = FALSE

/obj/item/clothing/head/roguetown/helmet/heavy/graggar/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_HORDE, "HELM", "RENDERED ASUNDER")

/obj/item/clothing/head/roguetown/helmet/heavy/graggar/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	if(slot == SLOT_HEAD)
		active_item = TRUE
		ADD_TRAIT(user, TRAIT_BITERHELM, TRAIT_GENERIC)

/obj/item/clothing/head/roguetown/helmet/heavy/graggar/dropped(mob/living/user)
	..()
	if(!active_item)
		return
	active_item = FALSE
	REMOVE_TRAIT(user, TRAIT_BITERHELM, TRAIT_GENERIC)

/obj/item/clothing/head/roguetown/helmet/heavy/matthios/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_COMMIE, "VISAGE")

/obj/item/clothing/head/roguetown/helmet/heavy/zizo
	name = "avantyne barbute"
	desc = "A avantyne barbute. This one has an adjustable visor. Called forth from the edge of what should be known. In Her name."
	adjustable = CAN_CADJUST
	icon_state = "zizobarbute"
	max_integrity = ARMOR_INT_HELMET_ANTAG
	prevent_crits = PREVENT_CRITS_ALL
	peel_threshold = 4
	chunkcolor = "#363030"
	var/frogstyle = FALSE

/obj/item/clothing/head/roguetown/helmet/heavy/zizo/MiddleClick(mob/user)
	frogstyle = !frogstyle
	to_chat(user, span_info("My darksteel helmet shifts into the style of [frogstyle ? "a froggemund" : "a barbute"]."))
	if(frogstyle)
		icon_state = "zizofrogmouth"
		name = "darksteel froggemund"
		desc = "A darksteel froggemund. Called forth from the edge of what should be known. In Her name."
		flags_inv = HIDEFACE|HIDESNOUT|HIDEEARS
		body_parts_covered = HEAD|EARS|HAIR
		adjustable = CANT_CADJUST
	else
		icon_state = "zizobarbute"
		name = "darksteel barbute"
		desc = "A darksteel barbute. This one has an adjustable visor. Called forth from the edge of what should be known. In Her name."
		adjustable = CAN_CADJUST
	update_icon()
	user.update_inv_head()


/obj/item/clothing/head/roguetown/helmet/heavy/zizo/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_CABAL, "HELMET")

/obj/item/clothing/head/roguetown/helmet/heavy/zizo/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS|HIDEHAIR), null, 'sound/items/visor.ogg', null, UPD_HEAD)	//Standard helmet

/obj/item/clothing/head/roguetown/helmet/heavy/bucket/iron
	name = "iron bucket helm"
	desc = "A helmet that covers your entire head, offering good protection while making breathing a difficult ordeal."
	icon_state = "ironplate"
	item_state = "ironplate"
	emote_environment = 3
	max_integrity = ARMOR_INT_HELMET_HEAVY_IRON
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/iron
	smelt_bar_num = 2

/obj/item/clothing/head/roguetown/helmet/heavy/captain
	name = "captain's helmet"
	desc = "An elegant barbute, fitted with the gold trim and polished metal of nobility."
	icon = 'icons/roguetown/clothing/special/captain.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/captain.dmi'
	icon_state = "capbarbute"
	adjustable = CAN_CADJUST
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	max_integrity = ARMOR_INT_HELMET_HEAVY_STEEL - ARMOR_INT_HELMET_HEAVY_ADJUSTABLE_PENALTY
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2

/obj/item/clothing/head/roguetown/helmet/heavy/captain/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS|HIDEHAIR), null, 'sound/items/visor.ogg', null, UPD_HEAD)	//Standard helmet
