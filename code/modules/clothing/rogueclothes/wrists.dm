/obj/item/clothing/wrists/roguetown
	slot_flags = ITEM_SLOT_WRISTS
	sleeved = 'icons/roguetown/clothing/onmob/wrists.dmi'
	icon = 'icons/roguetown/clothing/wrists.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/wrists.dmi'
	sleevetype = "shirt"
	resistance_flags = FLAMMABLE
	sewrepair = TRUE
	anvilrepair = null
	experimental_inhand = FALSE
	grid_width = 32
	grid_height = 64
	var/overarmor

/obj/item/clothing/wrists/roguetown/MiddleClick(mob/user, params)
	. = ..()
	overarmor = !overarmor
	to_chat(user, span_info("I [overarmor ? "wear \the [src] over my armor" : "wear \the [src] under my armor"]."))
	if(overarmor)
		alternate_worn_layer = WRISTS_LAYER
	else
		alternate_worn_layer = UNDER_ARMOR_LAYER
	user.update_inv_wrists()
	user.update_inv_gloves()
	user.update_inv_armor()
	user.update_inv_shirt()

/obj/item/clothing/wrists/roguetown/bracers
	name = "bracers"
	desc = "Steel bracers that protect the arms."
	body_parts_covered = ARMS
	icon_state = "bracers"
	item_state = "bracers"
	armor = ARMOR_PLATE
	blocksound = PLATEHIT
	resistance_flags = FIRE_PROOF
	max_integrity = ARMOR_INT_SIDE_STEEL
	pickup_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	sewrepair = FALSE
	smeltresult = /obj/item/ingot/steel

/obj/item/clothing/wrists/roguetown/bracers/leather/ComponentInitialize()
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_FENCERDEXTERITY)

/obj/item/clothing/wrists/roguetown/bracers/psythorns
	name = "psydonic thorns"
	desc = "Thorns fashioned from pliable yet durable blacksteel - woven and interlinked, fashioned to be wrapped around the wrists."
	body_parts_covered = ARMS
	icon_state = "psybarbs"
	item_state = "psybarbs"
	armor = ARMOR_PLATE_BSTEEL
	blocksound = PLATEHIT
	resistance_flags = FIRE_PROOF
	max_integrity = ARMOR_INT_SIDE_BLACKSTEEL
	anvilrepair = /datum/skill/craft/armorsmithing
	sewrepair = FALSE
	alternate_worn_layer = WRISTS_LAYER

/obj/item/clothing/wrists/roguetown/bracers/psythorns/equipped(mob/user, slot)
	. = ..()
	user.update_inv_wrists()
	user.update_inv_gloves()
	user.update_inv_armor()
	user.update_inv_shirt()

/obj/item/clothing/wrists/roguetown/bracers/psythorns/attack_self(mob/living/user)
	. = ..()
	user.visible_message(span_warning("[user] starts to reshape the [src]."))
	if(do_after(user, 4 SECONDS))
		var/obj/item/clothing/head/roguetown/helmet/blacksteel/psythorns/P = new /obj/item/clothing/head/roguetown/helmet/blacksteel/psythorns(get_turf(src.loc))
		if(user.is_holding(src))
			user.dropItemToGround(src)
			user.put_in_hands(P)
		P.obj_integrity = src.obj_integrity
		user.adjustBruteLoss(25)	
		qdel(src)
	else
		user.visible_message(span_warning("[user] stops reshaping [src]."))
		return

/obj/item/clothing/wrists/roguetown/bracers/aalloy
	name = "decrepit bracers"
	desc = "Frayed bronze cuffings, bound across the wrists. Don't bother counting the tallies left behind by their former legionnaires; none of them ever returned from the battlefields."
	max_integrity = ARMOR_INT_SIDE_DECREPIT
	icon_state = "ancientbracers"
	color = "#bb9696"
	chunkcolor = "#532e25"
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null
	prevent_crits = PREVENT_CRITS_NONE

/obj/item/clothing/wrists/roguetown/bracers/paalloy
	name = "ancient bracers"
	desc = "Polished gilbranze cuffings, clasped around the wrists. Through ascension, the chains of mortality are broken; and only through death will the spirit be ready to embrace divinity."
	icon_state = "ancientbracers"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/clothing/wrists/roguetown/bracers/leather
	name = "leather bracers"
	desc = "Standard leather bracers that offer some meager protection for the arms."
	icon_state = "lbracers"
	item_state = "lbracers"
	armor = ARMOR_PADDED_GOOD
	max_integrity = ARMOR_INT_SIDE_HARDLEATHER
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	anvilrepair = null
	smeltresult = null
	sewrepair = TRUE
	smeltresult = null
	salvage_amount = 0 // sry
	salvage_result = /obj/item/natural/hide/cured
	color = "#684338"

/obj/item/clothing/wrists/roguetown/bracers/leather/ComponentInitialize()
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_FENCERDEXTERITY)

/obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	name = "hardened leather bracers"
	desc = "Hardened leather braces that will keep your wrists safe from bludgeoning."
	icon_state = "albracers"
	armor = ARMOR_LEATHER_GOOD
	max_integrity = ARMOR_INT_SIDE_STEEL
	sellprice = 10
	salvage_amount = 1
	salvage_result = /obj/item/natural/hide/cured
	color = "#4d4d4d"

/obj/item/clothing/wrists/roguetown/bracers/copper
	name = "copper bracers"
	desc = "Copper forearm guards that offer some protection while looking rather stylish"
	icon_state = "copperarm"
	item_state = "copperarm"
	smeltresult = /obj/item/ingot/copper
	armor = ARMOR_PLATE_BAD

/obj/item/clothing/wrists/roguetown/wrappings
	name = "solar wrappings"
	slot_flags = ITEM_SLOT_WRISTS
	icon_state = "wrappings"
	item_state = "wrappings"
	sewrepair = TRUE

/obj/item/clothing/wrists/roguetown/nocwrappings
	name = "moon wrappings"
	slot_flags = ITEM_SLOT_WRISTS
	icon_state = "nocwrappings"
	item_state = "nocwrappings"
	sewrepair = TRUE

/obj/item/clothing/wrists/roguetown/allwrappings
	name = "wrappings"
	desc = "Strips of cloth, snuggly winding around your arms."
	slot_flags = ITEM_SLOT_WRISTS
	icon_state = "nocwrappings" //Greyscale. Accessable in the loadout.
	item_state = "nocwrappings"
	sewrepair = TRUE

/obj/item/clothing/wrists/roguetown/bracers/cloth
	name = "cloth bracers"
	desc = "This shouldn't be used in code."
	smeltresult = null
	armor = ARMOR_PADDED_GOOD
	blade_dulling = DULLING_BASHCHOP
	icon_state = "nocwrappings"
	item_state = "nocwrappings"
	max_integrity = ARMOR_INT_SIDE_STEEL //Heavy leather-tier protection and critical resistances, steel-tier integrity. Integrity boost encourages hand-to-hand parrying. Weaker than the Psydonic Thorns. Uncraftable.
	blocksound = SOFTHIT
	anvilrepair = null
	sewrepair = TRUE

/obj/item/clothing/wrists/roguetown/bracers/cloth/monk
	name = "monk's wrappings"
	desc = "Sheared burlap and cloth, meticulously fashioned around the forearms. Taut fibers turn weeping gashes into mere tears along the cloth, allowing for Monks to more confidently parry blades with their bare hands."
	color = "#BFB8A9"

/obj/item/clothing/wrists/roguetown/bracers/cloth/naledi
	name = "sojourner's wrappings"
	desc = "Sheared burlap and cloth, meticulously fashioned around the forearms. Naledian-trained monks rarely share the same fatalistic mindset as their Otavan cousins, and - consequency - tend to be averse with binding their wrists in jagged thorns. Unbloodied fingers tend to work far better with the arcyne, too. </br>'..And so, the great tears that they wept when it took it's last breath, the rain of the Weeper, is what marked this era of silence. Fools would tell you that Psydon has died, that they splintered into ‘ten smaller fragments', but that does not make sense. They are everything within and without, they are beyond size and shape. How can everything become something? No, they have merely turned their ear from us. They mourn, for their greatest child and their worst..'"
	color = "#48443B"

//Queensleeves
/obj/item/clothing/wrists/roguetown/royalsleeves
	name = "royal sleeves"
	desc = "Sleeves befitting an elaborate gown."
	slot_flags = ITEM_SLOT_WRISTS
	icon_state = "royalsleeves"
	item_state = "royalsleeves"
	detail_tag = "_detail"
	detail_color = CLOTHING_BLACK

/obj/item/clothing/wrists/roguetown/royalsleeves/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/wrists/roguetown/royalsleeves/lordcolor(primary,secondary)
	detail_color = primary
	color = secondary
	update_icon()

	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.update_inv_wrists()

/obj/item/clothing/wrists/roguetown/royalsleeves/Initialize()
	. = ..()
	GLOB.lordcolor += src
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary, GLOB.lordsecondary)

/obj/item/clothing/wrists/roguetown/royalsleeves/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/wrists/roguetown/splintarms
	name = "brigandine rerebraces"
	desc = "Brigandine bracers, pauldrons and a set of metal couters, designed to protect the arms while still providing almost complete free range of movement."
	body_parts_covered = ARMS
	icon_state = "splintarms"
	item_state = "splintarms"
	armor = ARMOR_PLATE
	blocksound = SOFTHIT
	max_integrity = ARMOR_INT_SIDE_IRON
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FIRE_PROOF
	sewrepair = FALSE

/obj/item/clothing/wrists/roguetown/splintarms/ComponentInitialize()
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_FENCERDEXTERITY)

/obj/item/clothing/wrists/roguetown/splintarms/iron
	name = "splint bracers"
	desc = "A pair of leather sleeves backed with iron splints, couters, and shoulderpieces that protect your arms and remain decently light."
	body_parts_covered = ARMS
	icon_state = "ironsplintarms"
	item_state = "ironsplintarms"
	armor = ARMOR_LEATHER_STUDDED //not plate armor, is leather + iron bits
	blocksound = SOFTHIT
	max_integrity = ARMOR_INT_SIDE_LEATHER
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/iron
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FIRE_PROOF
	sewrepair = FALSE

/obj/item/clothing/wrists/roguetown/bracers/iron
	name = "iron bracers"
	desc = "Iron bracers that protect the arms."
	body_parts_covered = ARMS
	icon_state = "ibracers"
	item_state = "ibracers"
	max_integrity = ARMOR_INT_SIDE_IRON
	smeltresult = /obj/item/ingot/iron

/obj/item/clothing/wrists/roguetown/bracers/jackchain
	name = "jack chains"
	desc = "Thin strips of steel attached to small shoulder and elbow plates, worn on the outside of the arms to protect against slashes."
	icon_state = "jackchain"
	item_state = "jackchain"
	armor = ARMOR_LEATHER_STUDDED // Please help me make this make sense this has the same stab protection vro.
	max_integrity = ARMOR_INT_SIDE_LEATHER // Make it slightly worse
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	smeltresult = null

/obj/item/clothing/wrists/roguetown/bracers/jackchain/ComponentInitialize()
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_FENCERDEXTERITY)

//

/obj/item/clothing/wrists/roguetown/bracers/matthios
	name = "gilded bracers"
	desc = "Away with you, vile beggar!"
	color = "#ffc960"

/obj/item/clothing/wrists/roguetown/bracers/matthios/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_COMMIE, "ARMOR")

//

/obj/item/clothing/wrists/roguetown/bracers/zizo
	name = "avantyne bracers"
	desc = "Clasped, yet unburdening. The pursuit of knowledge has led you to this very moment; there is no going back."
	color = "#c1b18d"
	chunkcolor = "#363030"

/obj/item/clothing/wrists/roguetown/bracers/zizo/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_CABAL, "ARMOR")
//

/obj/item/clothing/wrists/roguetown/bracers/graggar
	name = "vicious bracers"
	desc = "Oh, to plunge hands into cold water; to play a melody upon an ivory-keyed piano; to watch steam rise from boiling, twisting entrails.."
	color = "#ddc0a7"

/obj/item/clothing/wrists/roguetown/bracers/graggar/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_HORDE, "ARMOR", "RENDERED ASUNDER")

