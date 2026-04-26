//Lazily shoving all donator fluff items in here for now. Feel free to make this a sub-folder or something, I think it's just easier to keep a list here and just modify as needed.

//Plexiant's donator item - rapier
/obj/item/rogueweapon/sword/rapier/aliseo
	name = "Rapier di Aliseo"
	desc = "A rapier of sporting a steel blade and decrotive silver-plating. Elaborately designed in classic intricate yet functional Etrucian style, the pummel appears to be embedded with a cut emerald with a family crest engraved in the fine leather grip of the handle."
	icon_state = "plex"
	icon = 'icons/obj/items/donor_weapons_64.dmi'

//Ryebread's donator item - estoc
/obj/item/rogueweapon/estoc/worttrager
	name = "Wortträger"
	desc = "An imported Grenzelhoftian panzerstecher, a superbly crafted implement devoid of armory marks- merely bearing a maker's mark and the Zenitstadt seal. This one has a grip of walnut wood, and a pale saffira set within the crossguard. The ricasso is engraved with Ravoxian scripture."
	icon_state = "mansa"
	icon = 'icons/obj/items/donor_weapons_64.dmi'

//Srusu's donator item - dress
/obj/item/clothing/suit/roguetown/shirt/dress/emerald
	name = "emerald dress"
	desc = "A silky smooth emerald-green dress, only for the finest of ladies."
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR	//Goes either slot, no armor on it after all.
	icon_state = "laciedress"
	sleevetype = "laciedress"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'

/obj/item/clothing/head/roguetown/circlet/saffiratiara
	name = "saffira encrusted tiara"
	desc = "An ornate gold tiara, inset with a Saffira in its peak."
	icon_state = "eekasqueak"
	item_state = "eekasqueak"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'

//Funkymonke's donator item - dress
/obj/item/clothing/suit/roguetown/shirt/dress/funkydress
	name = "padded dress"
	desc = "A trimmed down version of a would be protective dress."
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	icon_state = "funkydress"
	sleevetype = "funkydress"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'

//Strudles donator item - mage vest, xylix tabard, etruscan cloak, and formfitted gambeson
/obj/item/clothing/suit/roguetown/shirt/robe/sofiavest
	name = "grenzelhoftian mages vest"
	desc = "A vest often worn by those of the Grenzelhoftian mages college."
	icon_state = "sofiavest"
	item_state = "sofiavest"
	sleevetype = "sofiavest"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'
	flags_inv = HIDEBOOB
	color = null
	nodismemsleeves = TRUE // prevents sleeves from being torn

/obj/item/clothing/cloak/templar/xylixian/faux
	name = "xylixian fasching leotard"
	desc = "Look at you! Swing and Jingle your hips, maybe even crack some whips. Today is going to be a fun day!"
	icon_state = "fauxoutfit"
	item_state = "fauxoutfit"
	alternate_worn_layer = TABARD_LAYER
	boobed = FALSE
	flags_inv = HIDECROTCH|HIDEBOOB
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_CLOAK|ITEM_SLOT_ARMOR
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = null
	nodismemsleeves = TRUE
	color = CLOTHING_DARK_GREY
	detail_tag = "_detail"
	detail_color = CLOTHING_WHITE

/obj/item/clothing/cloak/poncho/dittocloak
	name = "etruscan design cloak"
	desc = "A overly fancy and nicely designed Cloak with what appears to be Etruscan silks. Looks expensive."
	detail_tag = "_detail"
	altdetail_tag = "_detailalt"
	adjustable = CAN_CADJUST
	alternate_worn_layer = 9.9 // okay look this is weird but its to cover hair :)
	color = CLOTHING_WHITE
	detail_color = CLOTHING_WHITE
	altdetail_color = CLOTHING_WHITE
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'
	icon_state = "dittocloak"
	item_state = "dittocloak"
	sleevetype = "dittocloak"
	nodismemsleeves = TRUE

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/strudels
	name = "form-fitting padded gambeson"
	desc = "A normal looking padded gambeson that seems to have been custom fitted to a specific body for more comfort."
	icon_state = "formfit"
	item_state = "formfit"
	color = "#ffffff"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'

//Bat's donator item - custom harp sprite
/obj/item/rogue/instrument/harp/handcarved
	name = "handcrafted harp"
	desc = "A handcrafted harp."
	icon_state = "batharp"
	icon = 'icons/obj/items/donor_objects.dmi'

//Rebel0's donator item - visored sallet with a hood on under it. (Same as normal sallet)
/obj/item/clothing/head/roguetown/helmet/sallet/visored/gilded
	name = "gilded visored sallet"
	desc = "A steel helmet with gilded trim which protects the ears, nose, and eyes."
	icon_state = "gildedsallet_visor"
	item_state = "gildedsallet_visor"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'

//Bigfoot's donator item - knight helmet with gilded pattern
/obj/item/clothing/head/roguetown/helmet/heavy/knight/gilded
	name = "gilded knight's helmet"
	desc = "A noble knight's helm made of steel and completed with a gilded trim."
	icon_state = "gildedknight"
	item_state = "gildedknight"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'

/obj/item/clothing/head/roguetown/helmet/heavy/knight/gilded/attackby(obj/item/W, mob/living/user, params)
	..()
	if(!(istype(W, /obj/item/natural/feather) && !detail_tag))
		return
	user.visible_message(span_warning("[user] adds [W] to [src]."))
	user.transferItemToLoc(W, src, FALSE, FALSE)
	detail_tag = "_detail"
	update_icon()
	if(loc == user && ishuman(user))
		var/mob/living/carbon/H = user
		H.update_inv_head()
		
//Bigfoot's donator item - steel great axe with gilded pattern
/obj/item/rogueweapon/greataxe/steel/gilded
	name = "gilded greataxe"
	desc = "A gilded steel great axe, a long-handled axe with a single blade made for ruining someone's day beyond any measure.."
	icon_state = "orin"
	icon = 'icons/obj/items/donor_weapons_64.dmi'


//Zydras donator items - ironclad baddie
/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy/zycuirass
	name = "iron gardbrace and fauld"
	desc = "An aged piece of damaged mailled hauberk, with only its skirt and a spiked shoulder remaining. It glimmers with a reddish hue."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	icon_state = "zy_cuirass"
	item_state = "zy_cuirass"
	sleevetype = "zy_cuirass"
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'

/obj/item/rogueweapon/greataxe/zygreataxe
	name = "Bourreau"
	desc = "This Greataxe has seen better days. It will see even worse ones, by the looks of its wielder."
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	icon_state = "zy_greataxe"


/obj/item/clothing/suit/roguetown/armor/longcoat/eiren //Longcoat has no armor, ignore the /armor/ path.
	name = "Darkwood's Embrace"
	desc = "A tough leather coat, taken from one of the few remaining arcyne studies of Lord Darkwood. Ancient, but in remarkably good condition as the weight of memory and sin tries to drag you down."
	sleeved = TRUE
	icon = 'icons/clothing/donor_clothes.dmi'
	icon_state = "eirencoat"
	item_state = "eirencoat"
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'
	sleevetype = "eirencoat"
	detail_tag = "_detail"
	detail_color = CLOTHING_RED
	color = CLOTHING_WHITE
	boobed = FALSE

/obj/item/clothing/suit/roguetown/armor/longcoat/eiren/Initialize()
	. = ..()
	update_icon()

/obj/item/clothing/suit/roguetown/armor/longcoat/eiren/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/rogueweapon/eirenxiv/eiren_m
	name = "glintstone longsword"
	desc = "A glimmering blade, forged from a blue-white ore found rarely within the duchy of Azuria. Identical to steel in its properties, the tempering process to preserve the blue sheen is extensive and time consuming."
	icon_state = "eiren_m"
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	sheathe_icon = "eiren_m"
	bigboy = TRUE

/obj/item/rogueweapon/eirenxiv/eirensword
	name = "stygian longsword"
	desc = "A finely crafted steel longsword, its design perfectly combining elegance and practicality. Quenched in white oil, refined by the dwarves of Hammerhold, the blade holds a darker hue than usual."
	icon_state = "eirensword"
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	sheathe_icon = "eirensword"
	bigboy = TRUE

/obj/item/clothing/head/roguetown/duelhat/pretzel
	name = "rethrifted gravedigger's hat"
	desc = "A gravetender's dark leather slouch, refitted with a golden dragon-sigil. Who needs a steel skullcap when you have dumb luck? <br> \
	\"You ever feel like nothin' good was ever gonna happen to you?\" <br> \
	\"Yeah, and nothin' did. So what?\""
	color = null
	icon_state = "pretzel_stolenhat"
	item_state = "pretzel_stolenhat"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'


// ZoeTheOrc
/obj/item/clothing/cloak/raincloak/feather_cloak
	name = "Shroud of the Undermaiden"
	desc = "A fine cloak made from the feathers of Necra's servants, each gifted to a favoured child of the Lady of Veils. While it offers no physical protection, perhaps it ensures that the Undermaiden's gaze is never far from its wearer..."
	icon_state = "feather_cloak"
	item_state = "feather_cloak"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	boobed = FALSE
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'
	sleevetype = "feather_cloak"
	hoodtype = /obj/item/clothing/head/hooded/rainhood/feather_hood

/obj/item/clothing/head/hooded/rainhood/feather_hood
	name = "feather hood"
	desc = "This one will shelter me from the weather and my identity too."
	icon_state = "feather_hood"
	item_state = "feather_hood"
	slot_flags = ITEM_SLOT_HEAD
	dynamic_hair_suffix = ""
	edelay_type = 1
	body_parts_covered = HEAD
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDETAIL
	block2add = FOV_BEHIND
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'

/obj/item/clothing/suit/roguetown/armor/longcoat/wyrd_cloak
	name = "Cloak of the Wyrd"
	desc = "Sewn by ways unknown to the land, what may have been garbs fitting for royalty once now lays aged beyond measure. However, it would surely provide much needed warmth for the cold and uncaring bog..."
	icon_state = "wyrd_cloak"
	item_state = "wyrd_cloak"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	armor = ARMOR_CLOTHING
	boobed = FALSE
	toggle_icon_state = FALSE
	flags_inv = HIDEBOOB|HIDECROTCH
	color = null
	hoodtype = /obj/item/clothing/head/hooded/rainhood/wyrd_hood

/obj/item/clothing/head/hooded/rainhood/wyrd_hood
	name = "Hood of the Wyrd"
	desc = "Heavy is the head that hides beneath this shadowy hood, for what knowledge lays inside ought to never come into the light..."
	icon_state = "wyrd_hood"
	item_state = "wyrd_hood"
	slot_flags = ITEM_SLOT_HEAD
	dynamic_hair_suffix = ""
	edelay_type = 1
	body_parts_covered = HEAD
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDETAIL
	block2add = FOV_BEHIND
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'

// DASFOX
/obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/dasfox
	name = "archaic ceremonial valkyrhelm"
	desc = "A winged and angular helm of archaic design, tracing its lineage back to the Celestial Empire's fall. \
		House Timbermere makes sole use of its design within Azuria, claiming it as their heritage right. \
		This one has been gilded by Astrata's own colors, with a hand-woven plume atop to bear heraldic colors."
	icon_state = "valkyrhelm"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'

/obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/dasfox/attackby(obj/item/W, mob/living/user, params)
	..()
	if(!(istype(W, /obj/item/natural/feather) && !detail_tag))
		return
	var/choice = input(user, "Choose a color.", "Plume") as anything in COLOR_MAP
	user.visible_message(span_warning("[user] adds [W] to [src]."))
	user.transferItemToLoc(W, src, FALSE, FALSE)
	detail_color = COLOR_MAP[choice]
	detail_tag = "_detail"
	update_icon()
	if(loc == user && ishuman(user))
		var/mob/living/carbon/H = user
		H.update_inv_head()

/obj/item/clothing/neck/roguetown/psicross/astrata/dasfox
	name = "defiled Astratan periapt"
	desc = "This golden-lashed eye atop a blade was once a periapt of Astrata, \
	used in prayer and reverence of Her Tyrannical Light. This one has been damaged heavily, \
	and near-shattered- and is bound together by cloth and silver wires. \
	In lieu of its former nature, it now serves as amulet or attachment to armor due to the braided wire to be \
	utilized as a chain."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	icon_state = "astrata_periapt"

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/dasfox
	name = "archaic ceremonial cuirass"
	desc = "A cuirass and tasset set of archaic design, tracing its lineage back to the Celestial Empire's fall. \
		House Timbermere makes sole use of its design within Azuria, claiming it as their heritage right. \
		This one has been gilded by Astrata's own colors atop a sleeved surcoat to bear heraldic colors."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	icon_state = "archaiccuirass"
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'
	detail_tag = "_det"
	detail_color = CLOTHING_WHITE
	boobed = FALSE
	boobed_detail = FALSE

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/dasfox/update_icon()
	cut_overlays()
	if(!get_detail_tag())
		return
	var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
	message_admins("[pic.icon_state]")
	pic.appearance_flags = RESET_COLOR
	if(get_detail_color())
		pic.color = get_detail_color()
	add_overlay(pic)

/obj/item/rogueweapon/spear/lance/dasfox
	name = "La Rosa de la Chevalerie"
	desc = "A jousting lance, designed to look much like the flower- a softness backed by steel. \
		Handwoven silk is draped down the length and kept in place by steel vines, while heart-shaped ties keep silk on the grip from moving much even during proper jousts. \
		The cup guard has been forged, in lieu of its natural shape, into a blooming rosa - genteel and pleasant in view for a weapon of war."
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	icon_state = "dasfox_lance"

//IamCrystalClear
/obj/item/clothing/mask/rogue/iamcrystalclear
	name = "porcelain mask"
	desc = "A porcelain mask with black eyes and no mouth."
	icon = 'icons/clothing/donor_clothes.dmi'
	icon_state = "porc_mask"
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	adjustable = CAN_CADJUST
	var/list/toggles = list(
		"porc_mask",
		"porc_mask_red",
		"porc_mask_blue"
		)

/obj/item/clothing/mask/rogue/iamcrystalclear/AdjustClothes(mob/user)
	for(var/i in 1 to length(toggles))
		if(toggles[i] == icon_state)
			if(i == length(toggles))
				icon_state = toggles[1]
			else
				icon_state = toggles[i+1]
			break
	to_chat(user, span_info("My mask shifts its contours."))
	update_icon()
	user.update_inv_head()
	user.update_inv_wear_mask()
	


//RYAN180602
/obj/item/caparison/ryan
	name = "western estates caparison"
	desc = "To the west, Grenzelhoft. The scrawny coastlines make it hard to lay anchor. The waters flow, regardless."
	icon = 'icons/clothing/donor_clothes.dmi'
	icon_state = "ryan_caparison"
	caparison_icon = 'icons/clothing/onmob/donor_caparisons.dmi'
	caparison_state = "ryan_caparison"
	female_caparison_state = "ryan_caparison-f"

/obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm/ryan
	name = "maimed psydonic helm"
	desc = "Disavowed lamb, suicidal hero, cursed idiot - Psydon is dead. Will you follow Him to the grave, as a beacon of dying hope, or surrender to temptation?"
	icon_state = "ryan_maimedhelm"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes64.dmi'

//KORUU
/obj/item/clothing/head/roguetown/mentorhat/koruu
	name = "well-worn bamboo hat"
	desc = "A bamboo hat, made from shaven rice straw and woven into place alongside a coating of lacquer. This particular hat seems worn with age, yet well maintained. The phrase, '葉隠' can be seen stitched in gold in the inner lining of the hat."
	armor = ARMOR_CLOTHING

/obj/item/rogueweapon/spear/naginata/koruu
	name = "Sixty Five Yils"
	desc = "A beautiful guandao forged out of steel and interlocked with blacksteel, much like few blades before. The inscription, 'At fifteen, I went to join the army; only at eighty was I finally able to return home.' is inscribed in gold into the haft of the guandao."
	icon_state = "koruu_naginata"
	icon = 'icons/obj/items/donor_weapons_64.dmi'

/obj/item/rogueweapon/spear/naginata/koruu/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/rogueweapon/halberd/glaive/koruu
	name = "Sixty Five Yils"
	desc = "A beautiful guandao forged out of steel and interlocked with blacksteel, much like few blades before. The inscription, 'At fifteen, I went to join the army; only at eighty was I finally able to return home.' is inscribed in gold into the haft of the guandao."
	icon_state = "koruu_glaive"
	icon = 'icons/obj/items/donor_weapons_64.dmi'

/obj/item/rogueweapon/koruu/kukri
	name = "leachwhacker"
	desc = "A curved blade proudly made of Azurean Origin. Forged for wading through the hellish Terrorbog, it is a symbol of Azurean Tenacity. \
	It is said that the name is derived from old rituals of severing the leaves of a westleach bush while the iron is still hot to bless it. \
	The bane of Maneaters, Brigands, and Invaders."
	icon_state = "koruu_kukri"
	icon = 'icons/obj/items/donor_weapons.dmi'
	sheathe_icon = "koruu_kukri"

/obj/item/rogueweapon/koruu/kukri/warden
	name = "warden's leachwhacker"
	desc = "A curved blade proudly made of Azurean Origin. Forged for wading through the hellish Terrorbog, it is a symbol of Azurean Tenacity. \
	It is said that the name is derived from old rituals of severing the leaves of a westleach bush while the iron is still hot to bless it. \
	The bane of Maneaters, Brigands, and Invaders. An azure cloth could be seen wrapped around the handle."
	icon_state = "koruu_kukri_warden"
	icon = 'icons/obj/items/donor_weapons.dmi'
	sheathe_icon = "koruu_kukri_warden"

//DAKKEN12
/obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull/dakken
	name = "armoured avantyne barbute"
	desc = "A heavy-metal barbute that seems to be more avantyne than steel. It carries a tormented lustre about it, glinting under the sun as threads of the dark metal wind through its visor."
	icon_state = "dakken_zizbarb"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'

/obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/dakken
	name = "armoured avantyne barbute"
	desc = "A heavy-metal barbute that seems to be more avantyne than steel. It carries a tormented lustre about it, glinting under the sun as threads of the dark metal wind through its visor."
	icon_state = "dakken_zizbarb"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'

/obj/item/clothing/head/roguetown/helmet/heavy/barbute/visor/dakken
	name = "armoured avantyne barbute"
	desc = "A heavy-metal barbute that seems to be more avantyne than steel. It carries a tormented lustre about it, glinting under the sun as threads of the dark metal wind through its visor."
	icon_state = "dakken_zizbarb"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes64.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64
	bloody_icon = 'icons/effects/blood64.dmi'

/obj/item/rogueweapon/sword/dakken_sword
	name = "avantyne threaded sword"
	desc = "'Threads of dark metal wind through what was formerly a simple steel blade. Cracks and chips are filled in as the weapon of war is reshaped into a symbol of faith.'"
	icon = 'icons/obj/items/donor_weapons.dmi'
	icon_state = "alloybsword_32"
	sheathe_icon = "alloybsword"

/obj/item/rogueweapon/sword/long/dakken_longsword
	name = "avantyne threaded longsword"
	desc = "'Threads of dark metal wind through what was formerly a simple steel blade. Cracks and chips are filled in as the weapon of war is reshaped into a symbol of faith.'"
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	icon_state = "alloyblongsword"
	sheathe_icon = "alloybsword"

/obj/item/rogueweapon/spear/boar/frei/pike/stinketh
	name = "Kindness of Ravens Standard"
	desc = "A Freifechter's steel pike with a reinforced spruce shaft sporting a black banner with a strange blend of religious symbols."
	icon_state = "stinkethbanner"
	icon = 'icons/obj/items/donor_weapons_64.dmi'

//DRD21
/obj/item/rogueweapon/sword/long/drd
	name = "ornate basket-hilted longsword"
	desc = "A longsword, fitten with a basket-hilt. The grip is made out of a fine green-stained leather, with a piece of spiral-cared walnut connecting it to a lion-shaped pommel. A purple glowing rune sits atop the blade."
	icon_state = "drd_lsword"
	icon = 'icons/obj/items/donor_weapons_64.dmi'

/obj/item/caparison/drd
	name = "\improper House Woerden caparison"
	desc = "The livery of House Woerden: Pale blue, and white. A deer's head marks the flanks of the caparison."
	icon = 'icons/clothing/donor_clothes.dmi'
	icon_state = "drd_caparison"
	caparison_icon = 'icons/clothing/onmob/donor_caparisons.dmi'
	caparison_state = "drd_caparison"
	female_caparison_state = "drd_caparison-f"

/obj/item/rogueweapon/drd/shield
	name = "kite shield"
	desc = "The heraldry of the near-fallen House Woerden: Argent and celestial-azure, per bend, in fess point a deer head erased affronty gray."
	icon_state = "drd_shield"
	icon = 'icons/obj/items/donor_weapons.dmi'

//LMWEVIL
/obj/item/clothing/mask/rogue/courtphysician/brassbeak
	name = "\improper Society of the Brass Beak mask"
	desc = "A plague mask fitted with a brass-embossed beak, indicating membership in an erudite society of like-minded physickers. \
	This one is utterly filled with a pungent array of dried herbs to ward off ill humours, shielding from the outside world one breath at a time."
	icon_state = "brassbeak"
	item_state = "brassbeak"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'

//SHUDDERFLY
/obj/item/rogueweapon/huntingknife/idagger/steel/shudderfly
	name = "\improper Eoran Spike"
	desc = "An ornately decorated steel dagger with the initials M.D. engraved on one side and the word Amor on the other. \
	Around its crossguard is bound a rosa that never seems to wilt, the weapon is obviously cared for, but has seen many fights. \
	You can’t help but shake the feeling that the weapon itself resists being used."
	icon_state = "eoranspike"
	icon = 'icons/obj/items/donor_weapons.dmi'

//MAESUNE
/obj/item/clothing/suit/roguetown/shirt/maesune
	name = "mercantile union's garb"
	desc = "Baubles, Trinkets, Merchandise galore! Come seek your finest wares, store them in your many pockets! Made for the finery of the naturalistic entrepreneurs! Mercantilism, ho!"
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	icon_state = "merchantgarb"
	sleevetype = "merchantgarb"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'

/obj/item/rogueweapon/maesune/sabre
	name = "\improper Y Ceirw"
	desc = "A masterfully forged sword, trimmed in gold, embedded with a gem in the guard. Built as a weapon against injustice. So we may carve out a better world. \
	Borne upon the blade, a faded inscription reads, \"A Light Shineth In the Darkness\"."
	icon_state = "maesune_sabre"
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	bigboy = TRUE

/obj/item/rogueweapon/maesune/shield
	name = "\improper Fy Annwyl"
	desc = "A balanced shield, trimmed in silver, and bearing the crest of a golden deer's head with gleaming gemstone eyes. A bulwark against the howling abyss. Endvring, so we may all live in a better world. \
	Borne upon it, a freshly carved inscription reads, \"But The Darkness Comprehended It Not\"."
	icon_state = "maesune_shield"
	icon = 'icons/obj/items/donor_weapons.dmi'

//NEROCAVALIER
/obj/item/rogueweapon/nerocavalier/flsword
	name = "blacksteel longsword"
	desc = "A sleek blade of a dark, and burnished hue. A handle carved from a rosawood branch. A pairing that should sing a melody sweeter than any harp as it parts the air.. and yet, beautiful it may be, it is not worthy of song."
	icon_state = "flsword"
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	bigboy = TRUE

//WALKTHEWASTE
/obj/item/clothing/head/roguetown/mentorhat/walkthewaste
	armor = ARMOR_CLOTHING

//SCIDRAGON
/obj/item/rogueweapon/sword/sabre/shamshir/dono_scidragon_flame
	name = "flametongue"
	desc = "An eternal flame dances and flickers across the blade of this shamshir, fueled by the passion of its wielder, promising to bring the heat of the long-away desert to its victims."
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	icon_state = "sci_firetongue"

/obj/item/rogueweapon/sword/sabre/shamshir/dono_scidragon_flame/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/ignitable/fluff/sci_flame)

/obj/item/rogueweapon/sword/sabre/shamshir/dono_scidragon_sand
	name = "sandlash"
	desc = "Fury of an untamable desert sandstorm, conjured along the steel of this shamshir, destined to bite and lash at the target of its owner's ire. Or perhaps just business."
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	icon_state = "sci_sandlash"

/obj/item/rogueweapon/sword/sabre/shamshir/dono_scidragon_sand/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/ignitable/fluff/sci_sand)

/obj/item/rogueweapon/wand/aisu
	base_implement_name = "crystalline wand"
	name = "crystalline wand"
	desc = "A crystalline wand, born from a single tear and weeks of prayers and enchantments, Oh my guiding Moonlight!"
	icon_state = "aisuwand"
	icon = 'icons/obj/items/donor_weapons.dmi'

/obj/item/rogueweapon/wand/aisu/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onbelt")
				return list("shrink" = 0.5,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

//NAUTICALL
/obj/item/rogueweapon/example/regnum
	name = "Regnum"
	desc = "<i>'In war, the moral is to the physical as three is to one.'</i> <br> \
	An armor-piercing longsword. The finest steel, wrapped in the finest leather. Its rear-biased weight distribution makes it more of a scalpel than a slasher, while its sharp taper implies its purpose of skewering enemies with graceful precision. \
	The immaculate craftsmanship, the red leather, and the sparse but tasteful gold ornaments tell anyone who may pick this blade up that 'tis truly fit for a sovereign."
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	icon_state = "regnum" 
	sheathe_icon = "regnum"
	bigboy = TRUE

/obj/item/rogueweapon/example/aeternum
	name = "Aeternum"
	desc = "<i>'Lay by your pleading, law lies a-bleeding / Burn all your studies down, and throw away your reading; small power the word has, and can afford us / Not half so many privileges as the sword has.'</i> <br> \
	A bespoke polished montante. Austere yet ornate, formal yet functional. Like its smaller sibling, it comes with hardware of real gold and a handgrip of supple red leather. Where most monarchs' blades are meant for ceremony, this one tells a \
	different story altogether, for it is made for only one purpose: war."
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	icon_state = "aeternum"
	bigboy = TRUE

//KETRAI

/obj/item/clothing/head/roguetown/octopus
	name = "octopus hat"
	desc = "A deep red, slimy cephalopod that clings to your scalp. Its tentacles can be adjusted."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	icon_state = "octopus"
	adjustable = CAN_CADJUST
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR
	body_parts_covered = HEAD|EARS|HAIR
	armor = null 
	resistance_flags = FIRE_PROOF
	sellprice = 30

/obj/item/clothing/head/roguetown/octopus/ComponentInitialize()
	..()
	AddComponent(/datum/component/adjustable_clothing, \
		(HEAD|EARS|HAIR), \
		(HIDEEARS|HIDEFACE|HIDEHAIR),\
		null, \
		'sound/magic/slimesquish.ogg', \
		null, \
		UPD_HEAD)

/obj/item/clothing/head/roguetown/octopus/MiddleClick(mob/user)
	if(!ishuman(user))
		return
	if(flags_inv & HIDEHAIR)
		flags_inv &= ~HIDEHAIR
		to_chat(user, span_info("You pull your hair out from under the [src]."))
	else
		flags_inv |= HIDEHAIR
		to_chat(user, span_info("You tuck your hair under the [src]."))
	user.update_inv_head()

// CASTORTROY23

/obj/item/rogueweapon/example/darling 
	name = "Darling"
	desc = "<i>'... since this is the basic tenet of swordsmanship: that a man is always in motion and never at rest.'</i> <br> \
	Elaborately forged at the edge, reinforced at the tip, and restrained at the handle with fine leathers and coiling of taut sylveren wire, \
	this sleek longsword is a most modern marvel of metallurgy blended with one of the oldest symbols of majesty, its blade boasting a diamond cross section \
	and a thin fuller to boot. The color and insignia on the fine silken cloth wrapped around its ricasso does not quite seem to fit with the wielder's own."
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	icon_state = "darling" 
	sheathe_icon = "darling"
	bigboy = TRUE

//RIVERCADAVER

/obj/item/rogueweapon/example/sumquoderis
	name = "Sum Quod Eris"
	desc = "<b>'I AM AS YOU WERE. YOU WILL BE AS I AM NOW.'</b> <br> \
	A staggeringly large executioner's sword seemingly formed from one great slab of metal. A horrific implement for a singular task. \
	The handle of the blade is wreathed in blood-red vines sprouting from hollows within the crossguard. Crimson ichor drips from the thorns. \
	A surprisingly heavy pommel allows for deceptively quick strikes, but the grotesque weight of the blade is capable of cleaving bodies in twain. \
	The weapon is entirely without adornment, bare metal facing the world. <i>When you fall, leave behind a beautiful corpse. Do not die of decay.</i>"
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	icon_state = "sumquoderis"
	bigboy = TRUE

/obj/item/rogueweapon/example/euthanasia
	name = "Euthanasia"
	desc = "A curved, flowing dagger of dappled steel, formed in one piece as if born, not made. <br> \
	Strings of rough, red hemp-rope tie in tight coils around the haft and crossguard, forming a surprisingly makeshift grip. \
	No adornments or inscription lies on the blade. Its purpose is fulfilled intrinsically, a sarkic weapon, fit for one sole purpose. \
	<i>Take the instrument into your hands, O murderer mine. The garden is on fire, and soon the stars must go out.</i>"
	icon = 'icons/obj/items/donor_weapons.dmi'
	icon_state = "euthanasia"
