
/obj/item/clothing/suit/roguetown/armor/brigandine
	slot_flags = ITEM_SLOT_ARMOR
	name = "brigandine"
	desc = "Composite armour made according to an Etruscan tradition. It's a high-quality arched plate cuirass sewn with dyed leather and fitted with a wide skirt at the bottom to cover the groin."
	icon_state = "brigandine"
	blocksound = SOFTHIT
	body_parts_covered = COVERAGE_ALL_BUT_LEGS
	armor = ARMOR_PLATE
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_TWIST)
	allowed_sex = list(MALE, FEMALE)
	nodismemsleeves = TRUE
	max_integrity = ARMOR_INT_CHEST_PLATE_BRIGANDINE
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	equip_delay_self = 4 SECONDS
	armor_class = ARMOR_CLASS_MEDIUM //good idea suggested by lamaster
	sleeved_detail = FALSE
	boobed_detail = FALSE

/obj/item/clothing/suit/roguetown/armor/brigandine/Initialize()
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_PLATE_COAT_STEP, 6)

/obj/item/clothing/suit/roguetown/armor/brigandine/attack_right(mob/user)
	if(detail_tag)
		return
	var/the_time = world.time
	var/pickedcolor = input(user, "Select a color.","Brigandine Color") as null|anything in CLOTHING_COLOR_NAMES
	if(!pickedcolor)
		return
	if(world.time > (the_time + 30 SECONDS))
		return
	detail_tag = "_det"
	detail_color = clothing_color2hex(pickedcolor)
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_armor()

/obj/item/clothing/suit/roguetown/armor/brigandine/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/armor/brigandine/retinue/Initialize()
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/suit/roguetown/armor/brigandine/retinue/lordcolor(primary,secondary)
	detail_tag = "_det"
	detail_color = primary
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_armor()

/obj/item/clothing/suit/roguetown/armor/brigandine/retinue/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/suit/roguetown/armor/brigandine/coatplates
	name = "coat of plates"
	desc = "A leather coat with plates attached to increase protection while retaining mobility. The leather below might stop a dagger."
	icon_state = "coat_of_plates"
	blocksound = PLATEHIT
	smelt_bar_num = 2
	armor_class = ARMOR_CLASS_HEAVY
	max_integrity = ARMOR_INT_CHEST_PLATE_BRIGANDINE + 50

/obj/item/clothing/suit/roguetown/armor/brigandine/retinue/coat
	name = "coat of the commander"
	desc = "A thick boiled leather surcoat with enough plates concealed within the folds to offer superior protection. It weighs a ton and takes a great man to wear."
	icon_state = "leathercoat"
	item_state = "leathercoat"
	var/picked = FALSE
	sleeved_detail = TRUE
	boobed_detail = TRUE

/obj/item/clothing/suit/roguetown/armor/brigandine/retinue/coat/attack_right(mob/user)
	if(picked)
		return
	var/the_time = world.time
	var/pickedvalue = input(user, "Select a color", "KINGSLAYER'S GARB") as null|anything in list("Khaki", "Black")
	if(!pickedvalue)
		return
	if(world.time > (the_time + 30 SECONDS))
		return
	if(pickedvalue == "Khaki")
		picked = TRUE
	else if(pickedvalue == "Black")
		picked = TRUE
		icon_state = "bleathercoat"
		item_state = "bleathercoat"
		update_icon()
		if(ismob(loc))
			var/mob/L = loc
			L.update_inv_armor()


/obj/item/clothing/suit/roguetown/armor/brigandine/light
	slot_flags = ITEM_SLOT_ARMOR
	name = "lightweight brigandine"
	desc = "A light riveted coat with plates concealed inside an exterior fabric. Susceptible to daggers being shoved into your ribs."
	icon_state = "light_brigandine"
	blocksound = SOFTHIT
	body_parts_covered = COVERAGE_TORSO
	armor = ARMOR_LEATHER_STUDDED
	max_integrity = ARMOR_INT_CHEST_PLATE_BRIGANDINE
	smeltresult = /obj/item/ingot/iron
	equip_delay_self = 40
	armor_class = ARMOR_CLASS_LIGHT//steel version of the studded leather armor now
	w_class = WEIGHT_CLASS_BULKY

/obj/item/clothing/suit/roguetown/armor/brigandine/light/attack_right(mob/user)
	if(detail_tag)
		return
	var/the_time = world.time
	var/pickedcolor = input(user, "Select a color.","Brigandine Color") as null|anything in CLOTHING_COLOR_NAMES
	if(!pickedcolor)
		return
	if(world.time > (the_time + 30 SECONDS))
		return
	detail_tag = "_detail"
	detail_color = clothing_color2hex(pickedcolor)
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_armor()

/obj/item/clothing/suit/roguetown/armor/brigandine/light/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/armor/brigandine/light/retinue/Initialize()
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/suit/roguetown/armor/brigandine/light/retinue/lordcolor(primary,secondary)
	detail_tag = "_detail"
	detail_color = primary
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_armor()

/obj/item/clothing/suit/roguetown/armor/brigandine/light/retinue/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/suit/roguetown/armor/brigandine/captain
	name = "captain's brigandine"
	desc = "A coat with plates specifically tailored and forged for the captain of Azure."
	icon_state = "capplate"
	icon = 'icons/roguetown/clothing/special/captain.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/captain.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/captain.dmi'
	detail_tag = "_detail"
	detail_color = "#39404d"
	blocksound = SOFTHIT
	equip_delay_self = 4 SECONDS
	unequip_delay_self = 4 SECONDS
	max_integrity = ARMOR_INT_CHEST_PLATE_BRIGANDINE + 50
	sellprice = 363 // On par w/ judgement and ichor fang cuz why not
	smelt_bar_num = 2
	armor_class = ARMOR_CLASS_HEAVY

/obj/item/clothing/suit/roguetown/armor/brigandine/haraate
	name = "hansimhae cuirass"
	desc = "A more common form of Kazengunite armor, consisting of several interlocking plates of blacksteel-coated steel. Much cheaper than a full set of armor, these are commonly seen on militia forces and standing armies alike."
	icon_state = "kazengunmedium"
	boobed = FALSE
	item_state = "kazengunmedium"
	detail_tag = "_detail"
	color = "#FFFFFF"
	detail_color = "#FFFFFF"
	var/picked = FALSE

/obj/item/clothing/suit/roguetown/armor/brigandine/haraate/attack_right(mob/user)
	..()
	if(!picked)
		var/choice = input(user, "Choose a color.", "Uniform colors") as anything in colorlist
		var/playerchoice = colorlist[choice]
		picked = TRUE
		detail_color = playerchoice
		detail_tag = "_detail"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_armor()
			H.update_icon()

/obj/item/clothing/suit/roguetown/armor/brigandine/haraate/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)
