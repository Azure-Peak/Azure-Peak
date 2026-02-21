// GAMBESON ARMOUR

/obj/item/clothing/suit/roguetown/armor/gambeson
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "gambeson"
	desc = "A thick jacket of cloth, and the finest compatriot to alloyed chestpieces. In tymes of peace, the humble gambeson wards off a blizzard's chill - and in tymes of peril, it rebukes the crippling blows of bludgeons-and-bows alike."
	icon_state = "gambeson"
	body_parts_covered = COVERAGE_ALL_BUT_HANDFEET
	armor = ARMOR_PADDED
	prevent_crits = PREVENT_CRITS_NONE
	blocksound = SOFTUNDERHIT
	blade_dulling = DULLING_BASHCHOP
	max_integrity = ARMOR_INT_CHEST_LIGHT_MEDIUM
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sewrepair = TRUE
	color = "#ad977d"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	armor_class = ARMOR_CLASS_LIGHT
	chunkcolor = "#978151"
	material_category = ARMOR_MAT_LEATHER
	cold_protection = 10

/obj/item/clothing/suit/roguetown/armor/gambeson/ComponentInitialize()
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_FENCERDEXTERITY)
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_HONORBOUND)

/obj/item/clothing/suit/roguetown/armor/gambeson/dark
	color = "#646464"

/obj/item/clothing/suit/roguetown/armor/gambeson/lord
	name = "arming jacket"
	desc = "A collared jacket, purpose-woven for warfare. The flared collar and sleeves keep the wearer's dexterity from being mitigated, while its tighter presentation helps to ward off killing blows from afar."
	icon_state = "dgamb"
	body_parts_covered = COVERAGE_ALL_BUT_LEGS
	prevent_crits = PREVENT_CRITS_MOST
	color = null
	chunkcolor = null
	allowed_sex = list(MALE, FEMALE)

/obj/item/clothing/suit/roguetown/armor/gambeson/shadowrobe
	name = "stalker robe"
	desc = "A thick robe in royal purple, befitting the hand, while remaining easy for them to slip about in.."
	allowed_race = NON_DWARVEN_RACE_TYPES
	prevent_crits = PREVENT_CRITS_MOST
	icon_state = "shadowrobe"

/obj/item/clothing/suit/roguetown/armor/gambeson/light
	name = "light gambeson"
	desc = "A light and insulative jacket, hewn from cloth. Peasants tend to wear these in the colder months, though they've also been repurposed - by more desperate hands - as armor-padding."
	armor = ARMOR_PADDED_BAD
	max_integrity = ARMOR_INT_CHEST_LIGHT_BASE
	prevent_crits = PREVENT_CRITS_NONE
	sellprice = 10

/obj/item/clothing/suit/roguetown/armor/gambeson/lord/heavy
	name = "padded arming jacket"
	desc = "A collared jacket, intended to be worn underneath plate armor. The thicker padding ensures that any gaps left within its alloyed shell are thoroughly protected - lest an unforseen bowstrike, landing true, ruptures the vulnerable flesh beneath."
	icon_state = "dgamb"
	body_parts_covered = COVERAGE_ALL_BUT_LEGS
	armor = ARMOR_PADDED_GOOD
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER
	prevent_crits = PREVENT_CRITS_MOST

/obj/item/clothing/suit/roguetown/armor/gambeson/lord/heavy/silkjacket
	name = "besilked jacket"
	desc = "A lightweight jacket, who's besilked stitchwork allows it to catch thrusts-and-arrows alike without compromise. For reasons that needn't be spoken, such traits make it coveted among lesser nobility."
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	icon_state = "puritan_shirt"

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	name = "padded gambeson"
	desc = "A heavyweight jacket, further tightened with dorpel-styled stitchwork. On its own, it is a masterwork that can reduce a crushing blow into a slight tickle; beneath an alloyed chestplate, it can ward off anything short of a greater fireball."
	icon_state = "gambesonp"
	armor = ARMOR_PADDED_GOOD
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER
	prevent_crits = PREVENT_CRITS_MOST
	sellprice = 25
	color = "#976E6B"
	var/shiftable = TRUE
	var/shifted = FALSE

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/attack_right(mob/user)
	if(!shiftable)
		return
	if(shifted)
		if(alert("Would you like to wear your gambeson normally? -Restores greyscaling, new style.",, "Yes", "No") != "No")
			icon_state = "gambesonp"
			color = "#976E6B"
			update_icon()
			shifted = FALSE
			if(user)
				if(ishuman(user))
					var/mob/living/carbon/H = user
					H.update_inv_shirt()
					H.update_inv_armor()
			return
	else
		if(alert("Would you like to wear your gambeson traditionally? -Removes Greyscaling, old style.",, "Yes", "No") != "No")
			icon_state = "gambesonpold"
			color = null
			update_icon()
			shifted = TRUE
			if(user)
				if(ishuman(user))
					var/mob/living/carbon/H = user
					H.update_inv_shirt()
					H.update_inv_armor()
			return


/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan
	name = "fencing gambeson"
	desc = "A large shirt with heavy padding meant to be used below armor. Will probably stop an arrow, unlikely to stop a bolt."
	icon_state = "fancygamb"
	allowed_race = NON_DWARVEN_RACE_TYPES
	color = "#5058c1"
	detail_color = "#e98738"
	detail_tag = "_detail"
	shiftable = FALSE
	sellprice = 30
	var/picked = FALSE

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan/attack_right(mob/user)
	..()
	if(!picked)
		var/choice = input(user, "Choose a color.", "Otavan colors") as anything in COLOR_MAP
		var/playerchoice = COLOR_MAP[choice]
		picked = TRUE
		detail_color = playerchoice
		detail_tag = "_detail"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_shirt()
			H.update_icon()

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan/Initialize()
	. = ..()
	update_icon()

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/shirt/freifechter
	name = "padded fencing shirt"
	desc = "A strong loosely worn quilted shirt that places little weight on the arms, usually worn underneath a flexible leather vest. It won't cover your legs."
	icon = 'icons/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/armor.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	body_parts_covered = COVERAGE_ALL_BUT_LEGS
	icon_state = "fencingshirt"
	color = "#FFFFFF"
	var/shiftable = FALSE
	armor = ARMOR_PADDED_GOOD
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER + 35
	prevent_crits = PREVENT_CRITS_MOST
	sellprice = 25
	blocksound = SOFTUNDERHIT
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sewrepair = TRUE
	cold_protection = 10

/obj/item/clothing/suit/roguetown/shirt/freifechter/ComponentInitialize()
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_FENCERDEXTERITY)
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_HONORBOUND)

/obj/item/clothing/suit/roguetown/shirt/freifechter/shepherd
	name = "shepherd's shirt"
	desc = "A strong loosely worn quilted shirt that places little weight on the arms."
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER - 35

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah
	name = "padded caftan"
	desc = "A long overcoat commonly worn in Naledi, Kazengun, and Aavnr - but mostly associated with steppesmen. This specific kind rivals a padded gambeson in protection."
	icon_state = "chargah"
	color = "#ffffff"
	boobed = TRUE
	shiftable = FALSE

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "grenzelhoftian hip-shirt"
	desc = "Padded shirt for extra comfort and protection, adorned in vibrant colors."
	body_parts_covered = COVERAGE_ALL_BUT_LEGS
	icon_state = "grenzelshirt"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/stonekeep_merc.dmi'
	boobed = FALSE // Temporary fix, set to FALSE because for some reason boobed and details don't want to work together, removing the ability to dye it or it's details for the onmob
	detail_tag = "_detail"
	detail_color = CLOTHING_WHITE
	max_integrity = ARMOR_INT_CHEST_LIGHT_MEDIUM
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	color = "#1d1d22"
	detail_color = "#FFFFFF"
	sellprice = 40
	var/picked = FALSE
	shiftable = FALSE

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft/attack_right(mob/user)
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
			H.update_inv_shirt()

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/raneshen
	name = "padded desert coat"
	desc = "A slim-fitting sherwani, a Ranesheni-styled coat meant to endure in the desert's climate. This one is heavily padded, meant for a warrior to wear."
	icon_state = "sherwani"
	color = "#eec39a"
	shiftable = FALSE

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant
	name = "hierophant's shawl"
	icon_state = "desertrobe"
	item_state = "desertrobe"
	desc = "A thick robe intervowen with spell-laced fabrics. Thick and protective while remaining light and breezy; the perfect gear for protecting one from the threats of the sun, the desert and the daemons, yet still allowing one to cast spells aptly."
	naledicolor = TRUE
	shiftable = FALSE

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/pontifex
	name = "pontifex's kaftan"
	icon_state = "monkleather"
	item_state = "monkleather"
	desc = "Tight boiled leathers that stretch and fit to one's frame perfectly."
	shiftable = FALSE

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq
	name = "inquisitorial leather tunic"
	desc = "The finest leather tunic; made to ENDURE, made to INQUIRE, come heretic or hellfire."
	icon_state = "leathertunic"
	color = null
	armor = ARMOR_PADDED
	shiftable = FALSE
	body_parts_covered = COVERAGE_ALL_BUT_HANDFEET

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/shadowrobe
	name = "stalker robe"
	desc = "A robe-like gambeson of moth-eaten cloth and cheap purple dye. No self-respecting elf would be seen wearing this."
	allowed_race = NON_DWARVEN_RACE_TYPES
	icon_state = "shadowrobe"
	armor = ARMOR_PADDED_GOOD
	max_integrity = ARMOR_INT_CHEST_LIGHT_MEDIUM + 30 //280

//Special Hand armor. More defense, low integrity, similar logic to Ruma Clan tattoos. Can't be worn in shirt slot.
/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hand
	name = "hand's gambeson"
	desc = "Sturdy leather, fine silks and ornaments of gold, opulent and imperial, for any one who must say <i>\"I am in charge.\"</i> holds no power at all."
	icon = 'icons/roguetown/clothing/special/hand.dmi'
	icon_state = "handgambeson"
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/hand.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/hand.dmi'
	detail_tag = "_detail"
	detail_color = "#6e423a"
	armor = ARMOR_HANDGAMB
	slot_flags = ITEM_SLOT_ARMOR
	max_integrity = ARMOR_INT_CHEST_LIGHT_STEEL
	prevent_crits = PREVENT_CRITS_MOST
	sellprice = 250
	shiftable = FALSE
	unenchantable = TRUE

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hand/advisor
	detail_color = "#6678c9"

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hand/spymaster
	detail_color = "#742277"
