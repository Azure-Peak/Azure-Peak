/obj/item/clothing/head/roguetown/armingcap
	name = "arming cap"
	desc = "A modest arming cap. It will stop a light blow."
	icon_state = "armingcap"
	item_state = "armingcap"
	sleevetype = null
	sleeved = null
	body_parts_covered = HEAD|HAIR|EARS
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HEAD //Meant to be worn under helmets pmuch
	armor = ARMOR_PADDED_BAD
	prevent_crits = PREVENT_CRITS_NONE
	blocksound = SOFTHIT
	max_integrity = ARMOR_INT_HELMET_CLOTH
	color = "#463C2B"
	sewrepair = TRUE
	salvage_result = /obj/item/natural/fibers
	salvage_amount = 2 // Major materials loss

/obj/item/clothing/head/roguetown/armingcap/padded/ComponentInitialize()
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_FENCERDEXTERITY)

/obj/item/clothing/head/roguetown/armingcap/padded
	name = "padded arming cap"
	desc = "A padded up arming cap. It might even stop a mace!"
	icon_state = "paddedarmingcap"
	item_state = "paddedarmingcap"
	armor = ARMOR_PADDED
	prevent_crits = list(BCLASS_BLUNT, BCLASS_SMASH)
	max_integrity = ARMOR_INT_HELMET_CLOTH + 60

/obj/item/clothing/head/roguetown/helmet/leather
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_HIP
	name = "leather helmet"
	desc = "A helmet made of leather."
	body_parts_covered = HEAD|HAIR|EARS|NOSE
	icon_state = "leatherhelm"
	armor = ARMOR_LEATHER
	sellprice = 10
	prevent_crits = PREVENT_CRITS_NONE
	anvilrepair = null
	smeltresult = null
	sewrepair = TRUE
	blocksound = SOFTHIT
	max_integrity = ARMOR_INT_HELMET_LEATHER
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/head/roguetown/helmet/leather/volfhelm
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_HIP
	name = "volf helmet"
	desc = "A leather helmet fashioned from a volf's head."
	body_parts_covered = HEAD|HAIR|EARS
	icon_state = "volfhead"
	item_state = "volfhead"

/obj/item/clothing/head/roguetown/helmet/leather/saiga
	name = "saiga skull"
	desc = "The skull of a fearsome saiga. Looks like it could withstand some damage."
	icon_state = "saigahead"
	item_state = "saigahead"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64
	bloody_icon = 'icons/effects/blood64.dmi'
	flags_inv = HIDEEARS|HIDEFACE|HIDESNOUT
	flags_cover = HEADCOVERSEYES
	body_parts_covered = HEAD|EARS|HAIR|NOSE|EYES
	experimental_inhand = FALSE
	experimental_onhip = FALSE

/obj/item/clothing/head/roguetown/helmet/leather/advanced
	name = "hardened leather helmet"
	desc = "Sturdy, durable, flexible. A comfortable and reliable hood made of hardened leather."
	icon_state = "leatherhelm"
	max_integrity = ARMOR_INT_HELMET_HARDLEATHER
	sellprice = 15
	body_parts_covered = HEAD|EARS|HAIR|NOSE
	prevent_crits = PREVENT_CRITS_NONE
	armor = ARMOR_LEATHER_GOOD
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_HIP
	anvilrepair = null
	smeltresult = null
	sewrepair = TRUE
	blocksound = SOFTHIT
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/head/roguetown/spellcasterhat
	name = "spellsinger hat"
	desc = "An oddly shaped hat made of tightly-sewn leather, commonly worn by spellswords."
	icon_state = "spellcasterhat"
	item_state = "spellcasterhat"
	prevent_crits = PREVENT_CRITS_NONE
	armor = ARMOR_SPELLSINGER
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	bloody_icon = 'icons/effects/blood64.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64
	sewrepair = TRUE
	resistance_flags = FIRE_PROOF

// Grenzel unique drip head. Pretend it is a secrete (A type of hat with a hidden helmet underneath). Same stats as kettle
/obj/item/clothing/head/roguetown/grenzelhofthat
	name = "grenzelhoft plume hat"
	desc = "Whether it's monsters or fair maidens, a true Grenzelhoftian slays both. This hat contains a hidden metallic cap underneath to protect the head from blows."
	icon_state = "grenzelhat"
	item_state = "grenzelhat"
	icon = 'icons/roguetown/clothing/head.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/stonekeep_merc.dmi'
	slot_flags = ITEM_SLOT_HEAD
	detail_tag = "_detail"
	altdetail_tag = "_detailalt"
	dynamic_hair_suffix = ""
	max_integrity = ARMOR_INT_HELMET_LEATHER
	body_parts_covered = HEAD|HAIR|EARS
	prevent_crits = PREVENT_CRITS_NONE
	armor = ARMOR_SPELLSINGER // spellsinger hat stats
	sewrepair = TRUE
	resistance_flags = FIRE_PROOF
	var/picked = FALSE
	color = "#262927"
	detail_color = "#FFFFFF"
	altdetail_color = "#9c2525"

/obj/item/clothing/head/roguetown/grenzelhofthat/attack_right(mob/user)
	..()
	if(!picked)
		var/choice = input(user, "Choose a color.", "Grenzelhoft colors") as anything in COLOR_MAP
		var/playerchoice = COLOR_MAP[choice]
		picked = TRUE
		detail_color = playerchoice
		detail_tag = "_detail"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

/obj/item/clothing/head/roguetown/grenzelhofthat/update_icon()
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

//................ Briar Thorns ............... //	- Dendor Briar
/obj/item/clothing/head/roguetown/padded/briarthorns
	name = "briar thorns"
	desc = "The pain of wearing it might distract you from the whispers of a mad God overpowering your sanity..."
	icon_state = "briarthorns"

/obj/item/clothing/head/roguetown/padded/briarthorns/pickup(mob/living/user)
	. = ..()
	to_chat(user, span_warning ("The thorns prick me."))
	user.adjustBruteLoss(4)

//kazengite update
/obj/item/clothing/head/roguetown/mentorhat
	name = "worn bamboo hat"
	desc = "A reinforced bamboo hat."
	icon_state = "easthat"
	item_state = "easthat"
	armor = ARMOR_SPELLSINGER
	max_integrity = ARMOR_INT_HELMET_LEATHER
	blocksound = SOFTHIT
	sewrepair = TRUE
	flags_inv = HIDEEARS
	body_parts_covered = HEAD|HAIR|EARS|NOSE|EYES
	resistance_flags = FIRE_PROOF
