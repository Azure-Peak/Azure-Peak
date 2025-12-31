/obj/item/clothing/shoes/roguetown
	name = "shoes"
	icon = 'icons/roguetown/clothing/feet.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/feet.dmi'
	desc = ""
	gender = PLURAL
	slot_flags = ITEM_SLOT_SHOES
	body_parts_covered = FEET
	body_parts_inherent = FEET
	bloody_icon_state = "shoeblood"
	equip_delay_self = 30
	resistance_flags = FIRE_PROOF
	experimental_inhand = FALSE
	salvage_amount = 0
	salvage_result = null

/obj/item/clothing/shoes/roguetown/boots
	name = "dark boots"
	//dropshrink = 0.75
	color = "#d5c2aa"
	desc = ""
	gender = PLURAL
	icon_state = "blackboots"
	item_state = "blackboots"
	max_integrity = 80
	sewrepair = TRUE
	var/atom/movable/holdingknife = null
	salvage_amount = 1
	armor = ARMOR_CLOTHING

/obj/item/clothing/shoes/roguetown/boots/attackby(obj/item/W, mob/living/carbon/user, params)
	if(istype(W, /obj/item/rogueweapon/huntingknife/throwingknife))
		if(holdingknife == null)
			for(var/obj/item/clothing/shoes/roguetown/boots/B in user.get_equipped_items(TRUE))
				to_chat(loc, span_warning("I quickly slot [W] into [B]!"))
				user.transferItemToLoc(W, holdingknife)
				holdingknife = W
				playsound(loc, 'sound/foley/equip/swordsmall1.ogg')
		else
			to_chat(loc, span_warning("My boot already holds a throwing knife."))
		return
	. = ..()

/obj/item/clothing/shoes/roguetown/boots/attack_right(mob/user)
	if(holdingknife != null)
		if(!user.get_active_held_item())
			user.put_in_active_hand(holdingknife, user.active_hand_index)
			holdingknife = null
			playsound(loc, 'sound/foley/equip/swordsmall1.ogg')
			return TRUE

/obj/item/clothing/shoes/roguetown/boots/aalloy
	name = "decrepit boots"
	desc = "Frayed bronze greaves, shingled atop boots of rotted leather. The toebones of its former legionnaire remain within, rattling about with every step taken."
	max_integrity = 40
	prevent_crits = PREVENT_CRITS_NONE
	icon_state = "ancientboots"
	color = "#bb9696"

/obj/item/clothing/shoes/roguetown/boots/psydonboots
	name = "psydonic leather boots"
	desc = "Blacksteel-heeled boots. The leather refuses to be worn down, no matter how far you march through these lands."
	icon_state = "psydonboots"
	item_state = "psydonboots"
	sewrepair = TRUE
	armor = ARMOR_LEATHER_GOOD
	salvage_amount = 1
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/shoes/roguetown/boots/psydonboots/ComponentInitialize()
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_FENCERDEXTERITY)

/obj/item/clothing/shoes/roguetown/boots/nobleboot
	name = "noble boots"
	//dropshrink = 0.75
	color = "#d5c2aa"
	desc = "Fine dark leather boots."
	gender = PLURAL
	icon_state = "nobleboots"
	item_state = "nobleboots"
	sewrepair = TRUE
	armor = ARMOR_CLOTHING
	salvage_amount = 2
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/shoes/roguetown/boots/nobleboot/ComponentInitialize()
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_FENCERDEXTERITY)

/obj/item/clothing/shoes/roguetown/boots/nobleboot/steppesman
	name = "aavnic riding boots"
	desc = "A pair of sturdy riding boots with an iron heel and brass spurs."
	armor = ARMOR_LEATHER_GOOD
	max_integrity = ARMOR_INT_SIDE_HARDLEATHER

/obj/item/clothing/shoes/roguetown/shortboots
	name = "shortboots"
	color = "#d5c2aa"
	desc = ""
	gender = PLURAL
	icon_state = "shortboots"
	item_state = "shortboots"
	sewrepair = TRUE
	salvage_amount = 1
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/shoes/roguetown/ridingboots
	name = "riding boots"
	color = "#d5c2aa"
	desc = ""
	gender = PLURAL
	icon_state = "ridingboots"
	item_state = "ridingboots"
	sewrepair = TRUE
	salvage_amount = 1
	salvage_result = /obj/item/natural/hide/cured

///obj/item/clothing/shoes/roguetown/ridingboots/Initialize()
//	. = ..()
//	AddComponent(/datum/component/squeak, list('sound/foley/spurs (1).ogg'sound/blank.ogg'=1), 50)

/obj/item/clothing/shoes/roguetown/simpleshoes
	name = "shoes"
	desc = ""
	gender = PLURAL
	icon_state = "simpleshoe"
	item_state = "simpleshoe"
	sewrepair = TRUE
	resistance_flags = null
	color = "#473a30"
	salvage_amount = 1
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/shoes/roguetown/simpleshoes/white
	color = null


/obj/item/clothing/shoes/roguetown/simpleshoes/buckle
	name = "buckled shoes"
	icon_state = "buckleshoes"
	color = null

/obj/item/clothing/shoes/roguetown/simpleshoes/lord
	name = "shoes"
	desc = "Common shoes for everyday wear by the peasantry."
	gender = PLURAL
	icon_state = "simpleshoe"
	item_state = "simpleshoe"
	resistance_flags = null
	color = "#cbcac9"

/obj/item/clothing/shoes/roguetown/gladiator
	name = "leather sandals"
	desc = ""
	gender = PLURAL
	icon_state = "gladiator"
	item_state = "gladiator"
	sewrepair = TRUE

/obj/item/clothing/shoes/roguetown/sandals
	name = "sandals"
	desc = "A humble pair of sandals with adjustable straps that allow a snug fit for almost anyone."
	gender = PLURAL
	icon_state = "sandals"
	item_state = "sandals"
	sewrepair = TRUE

/obj/item/clothing/shoes/roguetown/sandals/aalloy
	name = "decrepit sandals"
	desc = "Frayed bronze platforms, curled about to cradle the feet. The beaches that these sandals once treaded are no more; pearly sands, long since turnt to glass from the Comet Syon's impact."
	icon_state = "ancientsandals"
	color = "#bb9696"
	prevent_crits = PREVENT_CRITS_NONE

/obj/item/clothing/shoes/roguetown/shalal
	name = "babouche"
	desc = ""
	gender = PLURAL
	icon_state = "shalal"
	item_state = "shalal"
	sewrepair = TRUE

/obj/item/clothing/shoes/roguetown/boots/leather
	name = "leather boots"
	//dropshrink = 0.75
	desc = "Sturdy boots stitched together from tanned leather. They leak a little."
	gender = PLURAL
	icon_state = "leatherboots"
	item_state = "leatherboots"
	sewrepair = TRUE
	armor = ARMOR_CLOTHING
	salvage_amount = 1
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/shoes/roguetown/boots/leather/ComponentInitialize()
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_FENCERDEXTERITY)

/obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	name = "heavy leather boots"
	desc = "Sturdy boots stitched together from cured leather. Stylish, firm, and sport a satisfying 'squeek' with each step."
	icon_state = "alboots"
	item_state = "alboots"
	max_integrity = 100			//Half that of iron boots
	armor = ARMOR_LEATHER_GOOD			//Better than regular leather.
	color = null

/obj/item/clothing/shoes/roguetown/boots/leather/reinforced/short
	name = "dress boots"
	desc = "A pair of sturdy boots stitched together from cured leather. These are shorter than usual, made for casual wear and dueling."
	icon_state = "albootsb"
	item_state = "albootsb"

/obj/item/clothing/shoes/roguetown/boots/otavan
	name = "otavan leather boots"
	desc = "Boots of outstanding craft, your fragile feet have never felt so protected and comfortable before."
	body_parts_covered = FEET
	icon_state = "fencerboots"
	item_state = "fencerboots"
	blocksound = SOFTHIT
	max_integrity = ARMOR_INT_SIDE_HARDLEATHER
	armor = ARMOR_LEATHER_GOOD
	allowed_race = NON_DWARVEN_RACE_TYPES
	salvage_amount = 1
	salvage_result = /obj/item/natural/hide/cured
	sewrepair = TRUE

/obj/item/clothing/shoes/roguetown/boots/otavan/ComponentInitialize()
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_FENCERDEXTERITY)

/obj/item/clothing/shoes/roguetown/grenzelhoft
	name = "grenzelhoft boots"
	icon_state = "grenzelboots"
	item_state = "grenzelboots"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/stonekeep_merc.dmi'
	armor = ARMOR_LEATHER_GOOD
	allowed_race = NON_DWARVEN_RACE_TYPES
	salvage_amount = 1
	salvage_result = /obj/item/natural/hide/cured
	sewrepair = TRUE

/obj/item/clothing/shoes/roguetown/boots/leather/elven_boots
	name = "woad elven boots"
	desc = "The living trunks still blossom in the spring. They let water through, but it is never cold."
	armor = list("blunt" = 100, "slash" = 10, "stab" = 100, "piercing" = 20, "fire" = 0, "acid" = 0) //Resistant to blunt and stab, but very weak to slash.
	prevent_crits = PREVENT_CRITS_ALL
	icon = 'icons/roguetown/clothing/special/race_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/race_armor.dmi'
	icon_state = "welfshoes"
	item_state = "welfshoes"
	anvilrepair = /datum/skill/craft/carpentry

/obj/item/clothing/shoes/roguetown/boots/armor
	name = "plated boots"
	desc = "Boots forged of a set of steel plates to protect your fragile toes."
	body_parts_covered = FEET
	icon_state = "armorboots"
	item_state = "armorboots"
	color = null
	blocksound = PLATEHIT
	resistance_flags = FIRE_PROOF
	max_integrity = ARMOR_INT_SIDE_STEEL
	armor = ARMOR_PLATE
	pickup_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel

/obj/item/clothing/shoes/roguetown/boots/armor/ComponentInitialize()
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_FENCERDEXTERITY)

/obj/item/clothing/shoes/roguetown/boots/armor/graggar
	name = "vicious boots"
	desc = "Plated boots which stir with the same violence driving our world. They have treaded a thousand skulls."
	max_integrity = ARMOR_INT_SIDE_ANTAG
	armor = ARMOR_ASCENDANT
	icon_state = "graggarplateboots"

/obj/item/clothing/shoes/roguetown/boots/armor/graggar/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_HORDE, "ARMOR", "RENDERED ASUNDER")


/obj/item/clothing/shoes/roguetown/boots/armor/matthios
	max_integrity = ARMOR_INT_SIDE_ANTAG
	name = "gilded boots"
	desc = "Gilded tombs do worm enfold."
	icon_state = "matthiosboots"
	armor = ARMOR_ASCENDANT

/obj/item/clothing/shoes/roguetown/boots/armor/matthios/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/shoes/roguetown/boots/armor/matthios/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/clothing/shoes/roguetown/boots/armor/zizo
	max_integrity = ARMOR_INT_SIDE_ANTAG
	name = "avantyne boots"
	desc = "Plate boots. Called forth from the edge of what should be known. In Her name."
	icon_state = "zizoboots"
	chunkcolor = "#363030"
	armor = ARMOR_ASCENDANT

/obj/item/clothing/shoes/roguetown/boots/armor/zizo/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/shoes/roguetown/boots/armor/zizo/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/clothing/shoes/roguetown/boots/armor/iron
	name = "light plated boots"
	desc = "Boots with iron for added protection."
	body_parts_covered = FEET
	icon_state = "soldierboots"
	item_state = "soldierboots"
	color = null
	blocksound = PLATEHIT
	max_integrity = ARMOR_INT_SIDE_IRON
	armor = ARMOR_PLATE
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/iron

/obj/item/clothing/shoes/roguetown/boots/leather/reinforced/kazengun
	name = "armored sandals"
	desc = "Leather sandals, with steel ankle-protectors and socks of sturdy cloth."
	icon_state = "kazengunboots"
	item_state = "kazengunboots"
	detail_tag = "_detail"
	color = "#FFFFFF"
	detail_color = "#FFFFFF"
	var/picked = FALSE

/obj/item/clothing/shoes/roguetown/boots/leather/reinforced/kazengun/attack_right(mob/user)
	..()
	if(!picked)
		var/choice = input(user, "Choose a color.", "Uniform colors") as anything in COLOR_MAP
		var/playerchoice = COLOR_MAP[choice]
		picked = TRUE
		detail_color = playerchoice
		detail_tag = "_detail"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_armor()
			H.update_icon()

/obj/item/clothing/shoes/roguetown/boots/leather/reinforced/kazengun/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/shoes/roguetown/jester
	name = "funny shoes"
	desc = "The bells add a jostling jingle jangle to each step."
	icon_state = "jestershoes"
	detail_tag = "_detail"
	resistance_flags = null
	sewrepair = TRUE
	detail_color = CLOTHING_WHITE
	color = CLOTHING_AZURE

/obj/item/clothing/shoes/roguetown/jester/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/shoes/roguetown/jester/lordcolor(primary,secondary)
	detail_color = secondary
	color = primary
	update_icon()

/obj/item/clothing/shoes/roguetown/jester/Initialize()
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_JINGLE_BELLS, 2)
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	else
		GLOB.lordcolor += src

/obj/item/clothing/shoes/roguetown/jester/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/shoes/roguetown/boots/furlinedboots
	name = "fur lined boots"
	desc = "Leather boots lined with fur."
	gender = PLURAL
	icon_state = "furlinedboots"
	item_state = "furlinedboots"
	sewrepair = TRUE
	max_integrity = 160
	armor = ARMOR_CLOTHING
	salvage_amount = 1
	salvage_result = /obj/item/natural/fur

/obj/item/clothing/shoes/roguetown/boots/furlinedanklets
	name = "fur lined anklets"
	desc = "Leather anklets lined with fur for a little extra protection while leaving the feet bare."
	gender = PLURAL
	icon_state = "furlinedanklets"
	item_state = "furlinedanklets"
	sewrepair = TRUE
	is_barefoot = TRUE
	armor = ARMOR_CLOTHING
	is_barefoot = TRUE
	salvage_amount = 1
	salvage_result = /obj/item/natural/fur

/obj/item/clothing/shoes/roguetown/boots/clothlinedanklets
	name = "cloth lined anklets"
	desc = "Cloth anklets lined with fibers for warmth while leaving the feet bare."
	gender = PLURAL
	icon_state = "furlinedanklets"
	item_state = "furlinedanklets"
	is_barefoot = TRUE
	sewrepair = TRUE
	armor = ARMOR_CLOTHING

/obj/item/clothing/shoes/roguetown/boots/otavan/inqboots
	name = "inquisitorial boots"
	desc = "Finely crafted boots, made to stomp out darkness."
	icon_state = "inqboots"
	item_state = "inqboots"
	allowed_race = ALL_RACES_TYPES


// ----------------- BLACKSTEEL -----------------------

/obj/item/clothing/shoes/roguetown/boots/blacksteel/modern/plateboots
	name = "blacksteel plate boots"
	desc = "Boots forged of durable blacksteel, using a modern design."
	body_parts_covered = FEET
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	icon_state = "bplateboots"
	item_state = "bplateboots"
	color = null
	blocksound = PLATEHIT
	max_integrity = ARMOR_INT_SIDE_BLACKSTEEL
	armor = ARMOR_PLATE_BSTEEL
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/blacksteel
	resistance_flags = FIRE_PROOF
	chunkcolor = "#303036"

/obj/item/clothing/shoes/roguetown/boots/blacksteel/plateboots
	name = "ancient blacksteel plate boots"
	desc = "Boots forged of durable blacksteel."
	body_parts_covered = FEET
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	icon_state = "bkboots"
	item_state = "bkboots"
	color = null
	blocksound = PLATEHIT
	max_integrity = ARMOR_INT_SIDE_BLACKSTEEL
	armor = ARMOR_PLATE_BSTEEL
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/blacksteel
	resistance_flags = FIRE_PROOF
	chunkcolor = "#303036"

// ----------------- BLACKSTEEL END -----------------------

/obj/item/clothing/shoes/roguetown/anklets
	name = "golden anklets"
	desc = "Luxurious anklets made of the finest gold. They leave the feet bare while adding an exotic flair."
	gender = PLURAL
	icon_state = "anklets"
	item_state = "anklets"
	is_barefoot = TRUE
	sewrepair = TRUE
	armor = ARMOR_CLOTHING

//kazen update
/obj/item/clothing/shoes/roguetown/armor/rumaclan
	name = "raised sandals"
	desc = "A pair of strange sandals that push you off the ground."
	icon_state = "eastsandals"
	item_state = "eastsandals"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/stonekeep_merc.dmi'
	armor = ARMOR_LEATHER_GOOD

// horseshoes!
/obj/item/clothing/shoes/roguetown/horseshoes
	name = "iron horseshoes"
	desc = "A pair of sturdy iron horseshoes nailed onto thick leather soles. These are ready to be attached to some hooves."
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x32/saiga.dmi'
	icon_state = "iron_horseshoes"
	item_state = "iron_horseshoes"
	clothing_flags = TAUR_COMPATIBLE
	max_integrity = ARMOR_INT_LEG_IRON_PLATE
	sewrepair = FALSE
	armor = ARMOR_PLATE
	smeltresult = /obj/item/ingot/iron

/obj/item/clothing/shoes/roguetown/horseshoes/build_worn_icon(default_layer, default_icon_file, isinhands, femaleuniform, override_state, female, customi, sleeveindex, boobed_overlay, icon/clip_mask)
	var/mutable_appearance/image = ..()
	image.pixel_x = -16
	image.pixel_y = -1
	return image

/obj/item/clothing/shoes/roguetown/horseshoes/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning)
	var/mob/living/equipped_to_mob = equipper || M
	var/obj/item/bodypart/taur/taur = equipped_to_mob.get_taur_tail()
	if(!istype(taur, /obj/item/bodypart/taur/horse))
		if(!disable_warning)
			to_chat(M, span_warning("These horseshoes can only be equipped by beings with hooves."))
		return FALSE
	return ..()

/obj/item/clothing/shoes/roguetown/horseshoes/steel
	name = "steel horseshoes"
	desc = "A pair of robust steel horseshoes nailed onto thick leather soles. These are ready to be attached to some hooves."
	icon_state = "steel_horseshoes"
	item_state = "steel_horseshoes"
	max_integrity = ARMOR_INT_LEG_STEEL_CHAIN
	sewrepair = FALSE
	armor = ARMOR_PLATE
	smeltresult = /obj/item/ingot/steel

/obj/item/clothing/shoes/roguetown/horseshoes/silver
	name = "silver horseshoes"
	desc = "A pair of shining silver horseshoes nailed onto thick leather soles. These are ready to be attached to some hooves."
	icon_state = "silver_horseshoes"
	item_state = "silver_horseshoes"
	max_integrity = ARMOR_INT_LEG_HARDLEATHER
	sewrepair = FALSE
	armor = ARMOR_PLATE
	smeltresult = /obj/item/ingot/silver

/obj/item/clothing/shoes/roguetown/horseshoes/gold
	name = "gold horseshoes"
	desc = "A pair of opulent golden horseshoes nailed onto thick leather soles. These are ready to be attached to some hooves."
	icon_state = "gold_horseshoes"
	item_state = "gold_horseshoes"
	max_integrity = ARMOR_INT_LEG_LEATHER
	sewrepair = FALSE
	armor = ARMOR_PLATE_BAD // these are awful!
	smeltresult = /obj/item/ingot/gold
