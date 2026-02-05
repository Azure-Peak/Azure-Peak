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
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_HONORBOUND)

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

/obj/item/clothing/head/roguetown/helmet/leather/chapeau
	name = "Chapeau a Naled"
	desc = "A leather cap, armored with layers of especially crafted armored coins each baring wards against supernatural forces. The heavy closeable, face-obscuring flaps are both practical, to protect from sand and dust and frigid nights--and to ensure the Otavan aids were not violating Naledi customs with their uncovered faces.</br>They are heavily associated with the Poet-Historian Aalis Petit and her writings and songs about the campaign into Naledi and through her, adventurous bards of Otava. "
	icon_state = "chapnaled"
	var/open_wear = TRUE
	flags_inv = HIDEHAIR
	body_parts_covered = HEAD|HAIR|EARS

/obj/item/clothing/head/roguetown/helmet/leather/chapeau/attack_right(mob/user)
	switch(open_wear)
		if(FALSE)
			icon_state = "chapnaledalt"
			item_state = "chapnaledalt"
			open_wear = TRUE
			flags_inv = HIDESNOUT|HIDEHAIR
			body_parts_covered_dynamic = HEAD|HAIR|FACE
		if(TRUE)
			icon_state = "chapnaled"
			item_state = "chapnaled"
			open_wear = FALSE
			flags_inv = HIDEHAIR
			body_parts_covered_dynamic = HEAD|HAIR|EARS
	update_icon()
	if(user)
		if(ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/leather/chapeau/AltRightClick(mob/user)
	if(!istype(loc, /mob/living/carbon))
		return
	var/mob/living/carbon/H = user
	if(icon_state == "[initial(icon_state)]_snout")
		icon_state = initial(icon_state)
		H.update_inv_head()
		update_icon()
		return

	var/icon/J = new('icons/roguetown/clothing/onmob/head.dmi')
	var/list/istates = J.IconStates()
	for(var/icon_s in istates)
		if(findtext(icon_s, "[icon_state]_snout"))
			icon_state += "_snout"
			H.update_inv_head()
			update_icon()
			return

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
	desc = "Whether it's monsters or fair maidens, a true Grenzelhoftian slays both. This hat contains a hidden metallic cap underneath to protect the head from blows. </br>I can fit this onto a sallet, Etruscan bascinet, or Blacksteel armet for added protection."
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

/obj/item/clothing/head/roguetown/grenzelhofthat/triumph
	name = "grenzelhoft tellerbarret"
	desc = "The latest in sixteenth-century fashionwear, stitched by the finest tailors in Grenzelhoft. </br>I can fit this onto a sallet, Etruscan bascinet, or Blacksteel armet for added protection."
	max_integrity = ARMOR_INT_HELMET_CLOTH
	prevent_crits = PREVENT_CRITS_NONE
	icon_state = "grenzelhat"
	item_state = "grenzelhat"
	icon = 'icons/roguetown/clothing/head.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/stonekeep_merc.dmi'
	detail_tag = "_detail"
	altdetail_tag = "_detailalt"
	dynamic_hair_suffix = ""
	armor = ARMOR_CLOTHING_GOOD //One-to-one replication of the original Plume Hat's protections.
	resistance_flags = FLAMMABLE
	color = "#262927"
	detail_color = "#FFFFFF"
	altdetail_color = "#007fff"

/obj/item/clothing/head/roguetown/grenzelhofthat/triumph/attack_right(mob/user)
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

/obj/item/clothing/head/roguetown/grenzelhofthat/triumph/update_icon()
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
/obj/item/clothing/head/roguetown/briarthorns
	name = "briar thorns"
	desc = "A circlet of thorns often worn by devout followers of Dendor. Designed to dig \
	into the flesh just enough to ground the wearer's sanity."
	icon_state = "briarthorns"
	max_integrity = 150
	body_parts_covered = HEAD|HAIR|EARS
	armor = ARMOR_CLOTHING
	salvage_result = /obj/item/natural/fibers
	salvage_amount = 1

/obj/item/clothing/head/roguetown/briarthorns/pickup(mob/living/user)
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

/obj/item/clothing/head/roguetown/mentorhat/ComponentInitialize()
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_HONORBOUND)
