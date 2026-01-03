/obj/item/clothing/suit/roguetown/shirt
	slot_flags = ITEM_SLOT_SHIRT
	body_parts_covered = CHEST|VITALS
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	equip_sound = 'sound/blank.ogg'
	drop_sound = 'sound/blank.ogg'
	pickup_sound =  'sound/blank.ogg'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	sleevetype = "shirt"
	edelay_type = 1
	equip_delay_self = 25
	bloody_icon_state = "bodyblood"
	boobed = TRUE
	sewrepair = TRUE
	flags_inv = HIDEBOOB
	experimental_inhand = FALSE
	salvage_amount = 2

	grid_width = 64
	grid_height = 64

/obj/item/clothing/suit/roguetown/shirt/MiddleClick(mob/user, params)
	var/mob/living/carbon/H = user
	if(!ishuman(H))
		return
	if(flags_inv & HIDEWINGS)
		flags_inv &= ~HIDEWINGS
	else
		flags_inv |= HIDEWINGS
	H.update_inv_armor()

/obj/item/clothing/suit/roguetown/shirt/undershirt
	name = "shirt"
	desc = "Modest and humble. It lets you walk around in public with your dignity intact."
	icon_state = "undershirt"
	item_state = "undershirt"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	body_parts_covered = CHEST|ARMS|VITALS

/obj/item/clothing/suit/roguetown/shirt/undershirt/priest
	name = "undervestments"
	desc = "A soft garment designed to prevent chafing from wearing heavy robes all dae and night."
	icon_state = "priestunder"
	item_state = "priestunder"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	allowed_sex = list(MALE, FEMALE)
	allowed_race = NON_DWARVEN_RACE_TYPES
	boobed = TRUE
	flags_inv= HIDEBOOB|HIDECROTCH
	body_parts_covered = CHEST|GROIN|ARMS|VITALS

/obj/item/clothing/suit/roguetown/shirt/undershirt/black
	color = CLOTHING_BLACK

/obj/item/clothing/suit/roguetown/shirt/undershirt/purple
	color = CLOTHING_PURPLE

/obj/item/clothing/suit/roguetown/shirt/undershirt/brown
	color = "#6b5445"

/obj/item/clothing/suit/roguetown/shirt/undershirt/lord
	desc = ""
	color = "#616898"

/obj/item/clothing/suit/roguetown/shirt/undershirt/red
	color = "#851a16"

/obj/item/clothing/suit/roguetown/shirt/undershirt/guard
	color = CLOTHING_AZURE

/obj/item/clothing/suit/roguetown/shirt/undershirt/guard/Initialize()
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/suit/roguetown/shirt/undershirt/guard/Destroy()
	GLOB.lordcolor -= src
	return ..()


/obj/item/clothing/suit/roguetown/shirt/undershirt/guardsecond
	color = CLOTHING_PURPLE

/obj/item/clothing/suit/roguetown/shirt/undershirt/guardsecond/Initialize()
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/suit/roguetown/shirt/undershirt/guardsecond/lordcolor(primary,secondary)
	if(secondary)
		color = secondary

/obj/item/clothing/suit/roguetown/shirt/undershirt/guardsecond/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/suit/roguetown/shirt/undershirt/random/Initialize()
	color = pick("#6b5445", "#435436", "#704542", "#79763f")
	..()

/obj/item/clothing/suit/roguetown/shirt/undershirt/puritan
	name = "formal silks"
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	icon_state = "puritan_shirt"
	allowed_race = CLOTHED_RACES_TYPES
	sleeved = 'icons/roguetown/clothing/onmob/shirts.dmi'
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	salvage_result = /obj/item/natural/silk
	salvage_amount = 1

/obj/item/clothing/suit/roguetown/shirt/undershirt/artificer
	name = "tinker suit"
	desc = "Typical fashion of the best engineers."
	icon_state = "artishirt"

/obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut
	name = "low cut tunic"
	desc = "A tunic exposing much of the neck and... shoulders?! How scandalous..."
	icon_state = "lowcut"

/obj/item/clothing/suit/roguetown/shirt/shadowshirt
	name = "silk shirt"
	desc = "A sleeveless shirt woven from glossy material."
	icon_state = "shadowshirt"
	item_state = "shadowshirt"
	r_sleeve_status = SLEEVE_TORN
	l_sleeve_status = SLEEVE_TORN
	body_parts_covered = CHEST|VITALS

/obj/item/clothing/suit/roguetown/shirt/shadowshirt/elflock
	allowed_race = NON_DWARVEN_RACE_TYPES
	body_parts_covered = COVERAGE_ALL_BUT_ARMS
	max_integrity = ARMOR_INT_CHEST_LIGHT_BASE
	armor = ARMOR_PADDED

/obj/item/clothing/suit/roguetown/shirt/apothshirt
	name = "apothecary shirt"
	desc = "When trudging through late-autumn forests, one needs to keep warm."
	icon_state = "apothshirt"
	item_state = "apothshirt"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	body_parts_covered = CHEST|VITALS

/obj/item/clothing/suit/roguetown/shirt/tunic/noblecoat
	name = "fancy coat"
	desc = "A fancy tunic and coat combo. How elegant."
	alternate_worn_layer = TABARD_LAYER
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	icon_state = "noblecoat"
	sleevetype = "noblecoat"
	detail_tag = "_detail"
	detail_color = CLOTHING_AZURE
	color = CLOTHING_WHITE
	boobed = TRUE

/obj/item/clothing/suit/roguetown/shirt/undershirt/artificer
	name = "tinker suit"
	desc = "Typical fashion of the best engineers."
	icon_state = "artishirt"

//Royal clothing:
//................ Royal Dress (Ball Gown)............... //
/obj/item/clothing/suit/roguetown/shirt/dress/royal
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	icon = 'icons/roguetown/clothing/shirts_royalty.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts_royalty.dmi'
	name = "royal gown"
	desc = "An elaborate ball gown, a favoured fashion of queens and elevated nobility in Enigma."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	icon_state = "royaldress"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts_royalty.dmi'
	boobed = TRUE
	detail_tag = "_detail"
	detail_color = CLOTHING_BLACK
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL

/obj/item/clothing/suit/roguetown/shirt/dress/royal/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/shirt/dress/royal/lordcolor(primary, secondary)
	detail_color = primary
	color = secondary
	update_icon()

	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.update_inv_armor()

/obj/item/clothing/suit/roguetown/shirt/dress/royal/Initialize()
	. = ..()
	GLOB.lordcolor += src
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary, GLOB.lordsecondary)

/obj/item/clothing/suit/roguetown/shirt/dress/royal/Destroy()
	GLOB.lordcolor -= src
	return ..()

//................ Princess Dress ............... //
/obj/item/clothing/suit/roguetown/shirt/dress/royal/princess
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "pristine dress"
	desc = "A flowy, intricate dress made by the finest tailors in the land for the monarch's children."
	icon_state = "princess"
	boobed = TRUE
	detail_color = CLOTHING_BLUE

//................ Prince Shirt   ............... //
/obj/item/clothing/suit/roguetown/shirt/dress/royal/prince
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "gilded dress shirt"
	desc = "A gold-embroidered dress shirt specially tailored for the monarch's children."
	icon_state = "prince"
	boobed = TRUE
	detail_color = CLOTHING_MAGENTA

// End royal clothes


//Is this terrible, yes, but at this point ehhhhhhhh.
/obj/item/clothing/suit/roguetown/shirt/dress/royal/hand_m
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "gilded dress shirt"
	desc = "A gold-embroidered dress shirt tailored for the right hand man."
	icon_state = "prince"
	boobed = TRUE
	detail_color = CLOTHING_AZURE

/obj/item/clothing/suit/roguetown/shirt/dress/royal/hand_f
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "pristine dress"
	desc = "A flowy, intricate dress made by the finest tailors in the land for the right hand man."
	icon_state = "princess"
	boobed = TRUE
	detail_color = CLOTHING_AZURE

/obj/item/clothing/suit/roguetown/shirt/dress/silkydress
	name = "silky dress"
	desc = "Despite not actually being made of silk, the legendary expertise needed to sew this puts the quality on par."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	icon_state = "silkydress"
	item_state = "silkydress"
	sleevetype = null
	sleeved = null
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/suit/roguetown/shirt/dress/silkydress/random/Initialize()
	color = pick("#e6e5e5", "#249589", "#a32121", "#428138", "#8747b1", "#007fff")
	..()

/obj/item/clothing/suit/roguetown/shirt/dress/gown
	icon = 'icons/roguetown/clothing/shirts_gown.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts_gown.dmi'
	name = "spring gown"
	desc = "A delicate gown that captures the essence of the season of renewal."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	icon_state = "springgown"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts_gown.dmi'
	boobed = TRUE
	detail_tag = "_detail"
	detail_color = CLOTHING_DARK_GREEN
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	var/picked = FALSE

/obj/item/clothing/suit/roguetown/shirt/dress/gown/summergown
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "summer gown"
	desc = "A breezy flowing gown fit for warm weathers."
	icon_state = "summergown"
	boobed = TRUE
	detail_color = "#e395bb"
	salvage_result = /obj/item/natural/silk
	salvage_amount = 2

/obj/item/clothing/suit/roguetown/shirt/dress/gown/fallgown
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "fall gown"
	desc = "A solemn long-sleeved gown that signifies the season of year's end."
	icon_state = "fallgown"
	boobed = TRUE
	detail_color = "#8b3f00"

/obj/item/clothing/suit/roguetown/shirt/dress/gown/wintergown
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "winter gown"
	desc = "A warm elegant gown adorned with soft fur for the cold winter."
	icon_state = "wintergown"
	boobed = TRUE
	detail_color = "#45749d"
	salvage_result = /obj/item/natural/silk
	salvage_amount = 2

/obj/item/clothing/suit/roguetown/shirt/undershirt/sailor
	icon_state = "sailorblues"

/obj/item/clothing/suit/roguetown/shirt/undershirt/sailor/red
	icon_state = "sailorreds"

/obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
	r_sleeve_status = SLEEVE_TORN
	body_parts_covered = CHEST|ARM_LEFT|VITALS

/obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/l
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_TORN
	body_parts_covered = CHEST|ARM_RIGHT|VITALS

/obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/Initialize()
	color = pick("#6b5445", "#435436", "#704542", "#79763f")
	..()

/obj/item/clothing/suit/roguetown/shirt/shortshirt
	name = "shirt"
	desc = ""
	icon_state = "shortshirt"
	item_state = "shortshirt"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL

/obj/item/clothing/suit/roguetown/shirt/shortshirt/random/Initialize()
	color = pick("#6b5445", "#435436", "#704542", "#79763f")
	..()

/obj/item/clothing/suit/roguetown/shirt/shortshirt/merc
	name = "shirt"
	desc = ""
	icon_state = "shortshirt"
	item_state = "shortshirt"
	r_sleeve_status = SLEEVE_TORN
	l_sleeve_status = SLEEVE_TORN
	body_parts_covered = CHEST|VITALS

/obj/item/clothing/suit/roguetown/shirt/shortshirt/bog
	color = "#9ac878"

/obj/item/clothing/suit/roguetown/shirt/rags
	slot_flags = ITEM_SLOT_ARMOR
	name = "rags"
	desc = "From rags to... nope, still rags."
	body_parts_covered = CHEST|GROIN|VITALS
	color = "#b0b0b0"
	icon_state = "rags"
	item_state = "rags"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/suit/roguetown/shirt/tribalrag
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "tribalrag"
	desc = ""
	body_parts_covered = CHEST|VITALS
	boobed = TRUE
	icon_state = "tribalrag"
	item_state = "tribalrag"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	flags_inv = HIDECROTCH|HIDEBOOB
	salvage_result = /obj/item/natural/hide
	salvage_amount = 1

/obj/item/clothing/suit/roguetown/shirt/robe/archivist
	name = "archivist's robe"
	desc = "Robes belonging to seekers of knowledge."
	icon_state = "archivist"
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	boobed = FALSE
	flags_inv = HIDECROTCH|HIDEBOOB
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	allowed_sex = list(MALE, FEMALE)

/obj/item/clothing/suit/roguetown/shirt/fancyjacket
	name = "fancy jacket"
	desc = "My, so modern -- so elegant. Which fine hands sewed this?"
	icon_state = "fancyjacket"
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	boobed = FALSE
	flags_inv = HIDECROTCH|HIDEBOOB
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	allowed_sex = list(MALE, FEMALE)


/obj/item/clothing/suit/roguetown/shirt/explorer
	name = "explorer's vest"
	desc = "Vest belonging to those who seek knowledge!"
	icon_state = "explorervest"
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	boobed = TRUE
	flags_inv = HIDECROTCH|HIDEBOOB
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	allowed_sex = list(MALE, FEMALE)
	color = null

/obj/item/clothing/suit/roguetown/shirt/tunic
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	name = "tunic"
	desc = "Modest and fashionable, with the right colors."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	icon_state = "tunic"
	boobed = TRUE
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/suit/roguetown/shirt/tunic/green
	color = CLOTHING_GREEN

/obj/item/clothing/suit/roguetown/shirt/tunic/blue
	color = CLOTHING_BLUE

/obj/item/clothing/suit/roguetown/shirt/tunic/red
	color = CLOTHING_RED

/obj/item/clothing/suit/roguetown/shirt/tunic/purple
	color = CLOTHING_PURPLE

/obj/item/clothing/suit/roguetown/shirt/tunic/white
	color = CLOTHING_WHITE

/obj/item/clothing/suit/roguetown/shirt/tunic/black
	color = CLOTHING_BLACK

/obj/item/clothing/suit/roguetown/shirt/tunic/ucolored
	color = COLOR_GRAY

/obj/item/clothing/suit/roguetown/shirt/tunic/random/Initialize()
	color = pick(CLOTHING_PURPLE, CLOTHING_RED, CLOTHING_BLUE, CLOTHING_GREEN, CLOTHING_BLACK, CLOTHING_WHITE, COLOR_GRAY)
	..()
/obj/item/clothing/suit/roguetown/shirt/dress
	slot_flags = ITEM_SLOT_ARMOR
	name = "dress"
	desc = "A simple dress worn by women and the bold."
	body_parts_covered = CHEST|GROIN|LEGS|VITALS
	icon_state = "dress"
	item_state = "dress"
	allowed_sex = list(MALE, FEMALE)
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/suit/roguetown/shirt/dress/gen
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "dress"
	desc = "A simple dress worn by women and the bold."
	body_parts_covered = CHEST|GROIN|LEGS|VITALS
	icon_state = "dressgen"
	item_state = "dressgen"
	color = "#6b5445"

/obj/item/clothing/suit/roguetown/shirt/dress/gen/black
	color = CLOTHING_BLACK

/obj/item/clothing/suit/roguetown/shirt/dress/gen/blue
	color = CLOTHING_BLUE

/obj/item/clothing/suit/roguetown/shirt/dress/gen/purple
	color = CLOTHING_PURPLE

/obj/item/clothing/suit/roguetown/shirt/dress/gen/random/Initialize()
	color = pick("#6b5445", "#435436", "#704542", "#79763f", CLOTHING_BLUE)
	..()

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "chemise"
	desc = "Comfortable yet elegant, it offers both style and comfort for everyday wear."
	body_parts_covered = CHEST|GROIN|LEGS|VITALS
	icon_state = "silkdress"
	item_state = "silkdress"
	color = "#e6e5e5"
	salvage_result = /obj/item/natural/silk
	salvage_amount = 2

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/princess
	color = CLOTHING_WHITE

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/princess/Initialize()
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/princess/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/black
	color = CLOTHING_BLACK

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/green
	color = CLOTHING_DARK_GREEN

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/random/Initialize()
	. = ..()
	color = pick("#e6e5e5", "#52BE80", "#C39BD3", "#EC7063","#5DADE2")

/obj/item/clothing/suit/roguetown/shirt/dress/gen/sexy
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "sheer dress"
	desc = "A scandalously short dress made of extra fine fibers for a semi-sheer look."
	body_parts_covered = null
	icon_state = "sexydress"
	sleevetype = null
	sleeved = null
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/suit/roguetown/shirt/dress/gen/sexy/random/Initialize()
	. = ..()
	color = pick(CLOTHING_WHITE, CLOTHING_RED, CLOTHING_PURPLE, CLOTHING_MAGENTA, CLOTHING_TEAL, CLOTHING_BLACK)

/obj/item/clothing/suit/roguetown/shirt/dress/gen/sexy/black/Initialize()
	. = ..()
	color = CLOTHING_BLACK

/obj/item/clothing/suit/roguetown/shirt/undershirt/webs
	name = "webbed shirt"
	desc = "Exotic silk finely woven into... this? Might as well be wearing a spiderweb."
	icon_state = "webs"
	item_state = "webs"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	body_parts_covered = CHEST|ARMS|VITALS
	color = null
	salvage_result = /obj/item/natural/silk
	salvage_amount = 1

/obj/item/clothing/suit/roguetown/shirt/jester
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "jester's tunick"
	desc = "Whether it's standup, slapstick, or wrestling nobles to the floor, this tunick can take it all."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	icon_state = "jestershirt"
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/shirts.dmi'
	boobed = FALSE // for some reason when boobed, the game likes to get rid of the detail and altdetail. I went ahead and just merged it into the main icon.
	detail_tag = "_detail"
	altdetail_tag = "_detailalt"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	flags_inv = HIDECROTCH|HIDEBOOB
	detail_color = CLOTHING_WHITE
	color = CLOTHING_AZURE
	altdetail_color = CLOTHING_WHITE


/obj/item/clothing/suit/roguetown/shirt/jester/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/shirt/jester/lordcolor(primary,secondary)
	detail_color = secondary
	color = primary
	update_icon()

/obj/item/clothing/suit/roguetown/shirt/jester/Initialize()
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	else
		GLOB.lordcolor += src

/obj/item/clothing/suit/roguetown/shirt/jester/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/steward
	color = null
	name = "ornate silk dress"
	desc = "A dress woven of only the finest, softest silks. Golden thread is inlaid with a deep royal crimson, expressing the owner's exquisitve wealth."
	icon_state = "stewarddress"
	item_state = "stewarddress"

/obj/item/clothing/suit/roguetown/shirt/tunic/silktunic
	name = "ornate silk tunic"
	desc = "A billowing tunic made of the finest silks and softest fabrics. Inlaid with golden thread, this is the height of fashion for the wealthiest of wearers."
	icon_state = "stewardtunic"
	item_state = "stewardtunic"

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/loudmouth
	color = null
	name = "crier's garb"
	desc = "A robe that speaks volumes!"
	icon_state = "loudmouthrobe"
	item_state = "loudmouthrobe"

//WEDDING CLOTHES
/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/weddingdress
	name = "wedding silk dress"
	desc = "A dress woven from fine silks, with golden threads inlaid in it. Made for that special day."
	icon_state = "weddingdress"
	item_state = "weddingdress"

/obj/item/clothing/suit/roguetown/shirt/exoticsilkbra
	name = "exotic silk bra"
	desc = "An exquisite bra crafted from the finest silk and adorned with gold rings. It leaves little to the imagination."
	icon_state = "exoticsilkbra"
	item_state = "exoticsilkbra"
	body_parts_covered = CHEST
	boobed = TRUE
	sewrepair = TRUE
	flags_inv = null
	slot_flags = ITEM_SLOT_SHIRT
	salvage_result = /obj/item/natural/silk
	salvage_amount = 2

/obj/item/clothing/suit/roguetown/shirt/desertbra
	name = "desert bra"
	desc = "An exquisite bra crafted from durable cloth. It leaves little to the imagination. Why is it a desert bra and not just a bra?"
	icon_state = "desertbra"
	item_state = "desertbra"
	body_parts_covered = CHEST
	boobed = FALSE
	sewrepair = TRUE
	flags_inv = null
	slot_flags = ITEM_SLOT_SHIRT
	salvage_result = /obj/item/natural/fibers
	salvage_amount = 3

//kazengite content
/obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt1
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "black foreign shirt"
	desc = "A shirt typically used by thugs."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	icon_state = "eastshirt1"
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/shirts.dmi'
	boobed = TRUE
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	flags_inv = HIDECROTCH|HIDEBOOB
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt2
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "white foreign shirt"
	desc = "A shirt typically used by foreign gangs."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	icon_state = "eastshirt2"
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	boobed = TRUE
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	flags_inv = HIDECROTCH|HIDEBOOB
	allowed_race = NON_DWARVEN_RACE_TYPES

//tattoo code
/obj/item/clothing/suit/roguetown/armor/regenerating/easttats
	name = "bouhoi bujeog tattoos"
	desc = "A mystic style of tattoos adopted by the Ruma Clan, emulating a practice performed by warrior monks of the Xinyi Dynasty. They are your way of identifying fellow clan members, an sign of companionship and secretive brotherhood. These are styled into the shape of clouds, created by a mystical ink which shifts and moves in ripples like a pond to harden where your skin is struck. It's movement causes you to shudder."
	resistance_flags = FIRE_PROOF
	icon_state = "easttats"
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	prevent_crits = PREVENT_CRITS_NONE
	armor = ARMOR_RUMACLAN
	body_parts_covered = COVERAGE_FULL
	body_parts_inherent = COVERAGE_FULL
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	allowed_race = NON_DWARVEN_RACE_TYPES
	max_integrity = 195
	flags_inv = null //free the breast
	surgery_cover = FALSE // cauterize and surgery through it.

	repairmsg_begin = "The tattoos begin to slowly mend its abuse.."
	repairmsg_continue = "The tattoos mend some of its abuse.."
	repairmsg_stop = "The tattoos stops mending from the onslaught!"
	repairmsg_end = "The tattoos flow more calmly, as they finish resting and regain their strength."

	interrupt_damount = 25
	repair_time = 35 SECONDS

/obj/item/clothing/suit/roguetown/armor/regenerating/easttats/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/suit/roguetown/armor/regenerating/easttats/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/clothing/suit/roguetown/shirt/dress/maid
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "maid dress"
	desc = "A distinctive black dress that should be kept clean and tidy - unless you want to be disciplined."
	body_parts_covered = CHEST|GROIN|ARMS|LEGS|VITALS
	boobed = TRUE
	item_state = "maiddress"
	icon_state = "maiddress"
	icon = 'icons/roguetown/clothing/special/maids.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/maids.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/maids.dmi'
	var/open_wear = FALSE

/obj/item/clothing/suit/roguetown/shirt/dress/maid/attack_right(mob/user)
	switch(open_wear)
		if(FALSE)
			name = "open maid dress"
			body_parts_covered = null
			open_wear = TRUE
			flags_inv = HIDEBOOB
			to_chat(usr, span_warning("Now wearing radically!"))
		if(TRUE)
			name = "maid dress"
			body_parts_covered = CHEST|GROIN|ARMS|LEGS|VITALS
			open_wear = FALSE
			flags_inv = HIDEBOOB|HIDECROTCH
			to_chat(usr, span_warning("Now wearing normally!"))
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_armor()
