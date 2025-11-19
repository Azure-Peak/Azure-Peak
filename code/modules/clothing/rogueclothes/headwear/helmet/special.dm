// File for special multi-category helmets that should all be seen together.


/////////////////////////////////// GRENZELHOFT PLUME HATS W/HELMETS ///////////////////////////////////

/obj/item/clothing/head/roguetown/helmet/sallet/grenzelhoft
	name = "sallet w/plume hat"
	desc = "A Grenzelhoftian plume hat placed atop a regular steel sallet, staying fashionable while protecting the wearer's head to a better degree."
	icon_state = "grenzelmid"
	item_state = "grenzelmid"
	icon = 'icons/roguetown/clothing/special/grenzelhats.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/grenzelhats.dmi'
	detail_tag = "_detail"
	altdetail_tag = "_detailalt"
	resistance_flags = FIRE_PROOF
	var/picked = FALSE
	color = "#FFFFFF"
	detail_color = "#262927"
	altdetail_color = "#FFFFFF"
	max_integrity = ARMOR_INT_HELMET_STEEL + 15

/obj/item/clothing/head/roguetown/helmet/sallet/grenzelhoft/update_icon()
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

/obj/item/clothing/head/roguetown/helmet/bascinet/etruscan/grenzelhoft
	name = "etruscan bascinet w/plume hat"
	desc = "A Grenzelhoftian plume hat placed atop an Etruscan bascinet, staying fashionable while protecting the wearer's head to a better degree."
	icon_state = "grenzelheavy"
	item_state = "grenzelheavy"
	icon = 'icons/roguetown/clothing/special/grenzelhats.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/grenzelhats.dmi'
	detail_tag = "_detail"
	altdetail_tag = "_detailalt"
	resistance_flags = FIRE_PROOF
	var/picked = FALSE
	color = "#FFFFFF"
	detail_color = "#262927"
	altdetail_color = "#FFFFFF"
	max_integrity = ARMOR_INT_HELMET_STEEL + 10

/obj/item/clothing/head/roguetown/helmet/bascinet/etruscan/grenzelhoft/update_icon()
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

/obj/item/clothing/head/roguetown/helmet/blacksteel/modern/armet/grenzelhoft
	name = "blacksteel armet w/plume hat"
	desc = "A Grenzelhoftian plume hat placed atop a blacksteel armet, staying fashionable while protecting the wearer's head for a better degree. Aren't you the affluent mercenary."
	icon_state = "grenzelblack"
	item_state = "grenzelblack"
	icon = 'icons/roguetown/clothing/special/grenzelhats.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/grenzelhats.dmi'
	detail_tag = "_detail"
	altdetail_tag = "_detailalt"
	resistance_flags = FIRE_PROOF
	var/picked = FALSE
	color = "#FFFFFF"
	detail_color = "#262927"
	altdetail_color = "#FFFFFF"

/obj/item/clothing/head/roguetown/helmet/blacksteel/modern/armet/grenzelhoft/update_icon()
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

///////// CRAFTING DATUMS FOR PLUME HATS /////////

/datum/crafting_recipe/roguetown/sewing/grenzelhelm
	name = "grenzelhoftian hat with steel sallet"
	result = list(/obj/item/clothing/head/roguetown/helmet/sallet/grenzelhoft)
	reqs = list(/obj/item/clothing/head/roguetown/grenzelhofthat = 1,
	            /obj/item/clothing/head/roguetown/helmet/sallet = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/grenzelhelm/off
	name = "take hat off steel sallet"
	result = list(/obj/item/clothing/head/roguetown/grenzelhofthat = 1, /obj/item/clothing/head/roguetown/helmet/sallet = 1)
	reqs = list(/obj/item/clothing/head/roguetown/helmet/sallet/grenzelhoft = 1)
	bypass_dupe_test = TRUE
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/grenzelklapper
	name = "grenzelhoftian hat with klappvisier"
	result = list(/obj/item/clothing/head/roguetown/helmet/bascinet/etruscan/grenzelhoft)
	reqs = list(/obj/item/clothing/head/roguetown/grenzelhofthat = 1,
	            /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan = 1)
	bypass_dupe_test = TRUE
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/grenzelklapper/off
	name = "take hat off etruscan bascinet"
	result = list(/obj/item/clothing/head/roguetown/grenzelhofthat = 1, /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan = 1)
	reqs = list(/obj/item/clothing/head/roguetown/helmet/bascinet/etruscan/grenzelhoft = 1)
	bypass_dupe_test = TRUE
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/grenzelblack
	name = "grenzelhoftian hat with blacksteel armet"
	result = list(/obj/item/clothing/head/roguetown/helmet/blacksteel/modern/armet/grenzelhoft)
	reqs = list(/obj/item/clothing/head/roguetown/grenzelhofthat = 1,
	            /obj/item/clothing/head/roguetown/helmet/blacksteel/modern/armet = 1)
	bypass_dupe_test = TRUE
	craftdiff = 0
