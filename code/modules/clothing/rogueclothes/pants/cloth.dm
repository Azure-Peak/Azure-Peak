/obj/item/clothing/under/roguetown/tights
	name = "tights"
	desc = "A pair of form-fitting tights."
	gender = PLURAL
	icon_state = "tights"
	item_state = "tights"
//	adjustable = CAN_CADJUST

/obj/item/clothing/under/roguetown/tights/random/Initialize()
	color = pick("#544236", "#435436", "#543836", "#79763f")
	..()

/obj/item/clothing/under/roguetown/tights/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Shift-right click while targeting either leg to tear a sleeve off, which can be used to bandage wounds in an emergency.")
	. += span_info("The chance to successfully tear a sleeve off scales with your character's Strength.")

/obj/item/clothing/under/roguetown/tights/black
	color = CLOTHING_BLACK

/obj/item/clothing/under/roguetown/tights/red
	color = CLOTHING_RED

/obj/item/clothing/under/roguetown/tights/green
	color = CLOTHING_GREEN

/obj/item/clothing/under/roguetown/tights/purple
	color = CLOTHING_PURPLE

/obj/item/clothing/under/roguetown/tights/jester
	desc = "Funny tights!"
	color = "#1E3B20"

/obj/item/clothing/under/roguetown/tights/lord
	color = "#865c9c"

/obj/item/clothing/under/roguetown/tights/vagrant
	r_sleeve_status = SLEEVE_TORN
	body_parts_covered = GROIN|LEG_LEFT

/obj/item/clothing/under/roguetown/tights/vagrant/l
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_TORN
	body_parts_covered = GROIN|LEG_RIGHT

/obj/item/clothing/under/roguetown/tights/vagrant/Initialize()
	color = pick("#6b5445", "#435436", "#704542", "#79763f")
	..()

/obj/item/clothing/under/roguetown/tights/sailor
	name = "sailor's pants"
	icon_state = "sailorpants"
	salvage_amount = 1

/obj/item/clothing/under/roguetown/tights/explorerpants
	name = "explorer's pants"
	desc = "Practical and modest, you hope that it will survive the next cavedive."
	icon_state = "explorerpants"
	item_state = "explorerpants"

/obj/item/clothing/under/roguetown/tights/puritan
	name = "formal breeches"
	icon_state = "monkpants"
	item_state = "monkpants"
	color = CLOTHING_BLACK

/obj/item/clothing/under/roguetown/tights/formalfancy
	name = "formal trousers"
	desc = "A formal pair of formal trousers."
	icon_state = "butlerpants"
	item_state = "butlerpants"
	detail_tag = "_detail"
	sleeved = 'icons/roguetown/clothing/special/onmob/sleeves_maids.dmi'
	salvage_result = /obj/item/natural/cloth
	detail_color = CLOTHING_DARK_GREY

/obj/item/clothing/under/roguetown/tights/shorts
	name = "trouser shorts"
	desc = "A pair of formal trouser shorts, fit for any strapping young lad."
	icon_state = "butlershorts"
	item_state = "butlershorts"
	detail_color = CLOTHING_DARK_GREY

/obj/item/clothing/under/roguetown/webs
	name = "webbing"
	desc = "A fine webbing made from spidersilk, popular fashion within the Underdark."
	gender = PLURAL
	icon_state = "webs"
	item_state = "webs"
	r_sleeve_status = SLEEVE_NOMOD
	l_sleeve_status = SLEEVE_NOMOD
	salvage_result = /obj/item/natural/silk
	salvage_amount = 1

/obj/item/clothing/under/roguetown/loincloth
	name = "loincloth"
	desc = ""
	icon_state = "loincloth"
	item_state = "loincloth"
	r_sleeve_status = SLEEVE_NOMOD
	l_sleeve_status = SLEEVE_NOMOD
	salvage_amount = 1

/obj/item/clothing/under/roguetown/loincloth/brown
	color = CLOTHING_BROWN

/obj/item/clothing/under/roguetown/loincloth/pink
	color = "#b98ae3"

/obj/item/clothing/under/roguetown/loincloth/deprived
	color = "#464040"

/obj/item/clothing/under/roguetown/tights/hose
	name = "cloth hosen"
	icon_state = "hose" //Crafting-combining datum for maille hoses can be found in chain.dm.
	item_state = "hose"
	desc = "A pair of cloth leggings, traditionally worn in conjunction with one's shortclothes. These can be combined with maille hosen for \
	the perfect blend of function-and-fashion; just pray no one has the mind to aim below the belt."
	body_parts_covered = LEGS|FEET
	detail_tag = "_detail"
	altdetail_tag = "_detailalt"
	flags_inv = null
	color = null
	detail_color = CLOTHING_WHITE
	altdetail_color = CLOTHING_WHITE

/obj/item/clothing/under/roguetown/tights/hose/Initialize()
	. = ..()
	update_icon()

/obj/item/clothing/under/roguetown/tights/hose/update_icon()
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

/obj/item/clothing/under/roguetown/tights/clothlegs
	name = "padded chausses"
	icon_state = "paddedchausses"
	desc = "A pair of cloth-armored trousers, comprised of padded hoses worn atop thickly-quilted shortclothes. Originating as an answer to \
	labors and pilgrimages through harsher terrain, it's also been mobilized as a cost-effective means of protecting militia-legs aplenty."
	detail_tag = "_detail"
	altdetail_tag = "_detailalt"
	armor = ARMOR_PADDED
	max_integrity = ARMOR_INT_LEG_LEATHER
	blocksound = SOFTUNDERHIT
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sewrepair = TRUE
	body_parts_covered = GROIN|LEGS
	cold_protection = 10
	detail_color = CLOTHING_WHITE

/obj/item/clothing/under/roguetown/tights/clothlegs/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)
