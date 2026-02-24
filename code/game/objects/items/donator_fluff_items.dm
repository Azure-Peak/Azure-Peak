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

//Strudles donator item - mage vest (same as robes) and xylix tabard
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
	if(istype(W, /obj/item/natural/feather) && !detail_tag)
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


//Zydras donator items - iconoclast pyromaniac - who up icono they clast
/obj/item/clothing/suit/roguetown/armor/brigandine/light/zydrasiconopauldrons
	name = "gilded pauldrons"
	desc = "A ritual-acquired set of pauldrons and gorget. Seemingly protects the gut, too."
	icon_state = "zydras_iconopauldrons"
	item_state = "zydras_iconopauldrons"
	sleevetype = "zydras_iconopauldrons"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi' //No sleeves

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/zydrasiconosash //who up icono they clast
	name = "gilded cloth sash"
	desc = "A ritual-acquired sash of purple cloth, lined with gold. Seemingly protects the gut, too."
	icon_state = "zydras_iconosash"
	item_state = "zydras_iconosash"
	sleevetype = "zydras_iconosash"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi' //No sleeves

/obj/item/clothing/head/roguetown/helmet/heavy/sheriff/zydrasiconocrown
	name = "toper-iron crown"
	desc = "A iron crown with a toper studded into it. Any blow landing upon the wearer's head seems to divert to the gem."
	flags_inv = null //It's a crown, it ain't hiding anything
	flags_cover = null 
	icon_state = "zydras_iconocrown"
	item_state = "zydras_iconocrown"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'


//Eiren's donator items - zweihander and sabres
/obj/item/rogueweapon/greatsword/zwei/eiren
	name = "Regret"
	desc = "People bring the small flames of their wishes together... to keep them from burning out, we cast our own flames into the biggest fire we can find. But you know... I didn't bring a flame with me. As for me, maybe I just wandered up to the campfire to warm myself a little..."
	icon_state = "eiren"
	icon = 'icons/obj/items/donor_weapons_64.dmi'

/obj/item/rogueweapon/greatsword/eiren
	name = "Regret"
	desc = "People bring the small flames of their wishes together... to keep them from burning out, we cast our own flames into the biggest fire we can find. But you know... I didn't bring a flame with me. As for me, maybe I just wandered up to the campfire to warm myself a little..."
	icon_state = "eiren"
	icon = 'icons/obj/items/donor_weapons_64.dmi'

/obj/item/rogueweapon/greatsword/grenz/flamberge/eiren
	name = "Regret"
	desc = "People bring the small flames of their wishes together... to keep them from burning out, we cast our own flames into the biggest fire we can find. But you know... I didn't bring a flame with me. As for me, maybe I just wandered up to the campfire to warm myself a little..."
	icon_state = "eiren"
	icon = 'icons/obj/items/donor_weapons_64.dmi'


/obj/item/rogueweapon/sword/sabre/eiren
	name = "Lunae"
	desc = "Two blades, one forged in Noc's light, a soothing breath of clarity. Here, and here alone, were moon and fire ever together."
	icon_state = "eiren2"
	icon = 'icons/obj/items/donor_weapons.dmi'
	sheathe_icon = "eiren2"

/obj/item/rogueweapon/sword/sabre/eiren/small
	name = "Cinis"
	desc = "Two blades, the other born of Astrata's ire, a raging flame of passion. Here, and here alone, were fates severed and torn."
	icon_state = "eiren3"
	icon = 'icons/obj/items/donor_weapons.dmi'
	sheathe_icon = "eiren3"

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

//pretzel's special things
/obj/item/rogueweapon/greatsword/weeperslathe
	name = "Weeper's Lathe"
	desc = "A recreation of a gilbronze greatsword, wrought in steel. Inscribed on the blade is a declaration: \"I HAVE ONLY A SHORT TYME TO LYVE, BUT I AM NOT AFRAID TO DIE.\""
	icon_state = "weeperslathe"
	icon = 'icons/obj/items/donor_weapons_64.dmi'

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

//inverserun's claymore
/obj/item/rogueweapon/greatsword/zwei/inverserun
	name = "Votive Thorns"
	desc = "Promises hurt, but so does plucking rosa. Hoping hurts, but so does looking at the beauty of Astrata's light. Pick yourself back up. Remember your promise, despite the thorns."
	icon_state = "inverse"
	icon = 'icons/obj/items/donor_weapons_64.dmi'

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

//DAKKEN12
/obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull/dakken
	name = "armoured avantyne barbute"
	desc = "A heavy-metal barbute that seems to be more avantyne than steel. It carries a tormented lustre about it, glinting under the sun as threads of the dark metal wind through its visor."
	icon_state = "dakken_zizbarb"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'

//STINKETHSTONKETH
/obj/item/rogueweapon/sword/sabre/steppesman/stinketh
	name = "fencer's shashka"
	desc = "A heirloom shashka with guardless hilt plated in silver and adorned  with a Mamuk hide grip. A sabre's blade has been added in place of the old one, affording it lethality and reach whilst dismounted."
	icon_state = "stinketh_shashka"
	icon = 'icons/obj/items/donor_weapons_64.dmi'

/obj/item/rogueweapon/sword/sabre/freifechter/stinketh
	name = "fencer's shashka"
	desc = "A heirloom shashka with guardless hilt plated in silver and adorned  with a Mamuk hide grip. A sabre's blade has been added in place of the old one, affording it lethality and reach whilst dismounted."
	icon_state = "stinketh_shashka"
	icon = 'icons/obj/items/donor_weapons_64.dmi'

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
