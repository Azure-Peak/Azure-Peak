/obj/item/clothing/cloak
	name = "cloak"
	icon = 'icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	slot_flags = ITEM_SLOT_CLOAK
	desc = "Protects you from the weather and your identity from everyone else."
	edelay_type = 1
	equip_delay_self = 10
	bloody_icon_state = "bodyblood"
	sewrepair = TRUE //Vrell - AFAIK, all cloaks are cloth ATM. Technically semi-less future-proof, but it removes a line of code from every subtype, which is worth it IMO.
	experimental_inhand = FALSE
	var/overarmor = TRUE
	var/storage = TRUE

	grid_width = 64
	grid_height = 64

/obj/item/clothing/cloak/ComponentInitialize()
	. = ..()
	if(storage)
		AddComponent(/datum/component/storage/concrete/roguetown/cloak)

/obj/item/clothing/cloak/dropped(mob/living/carbon/human/user)
	..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	if(STR)
		var/list/things = STR.contents()
		for(var/obj/item/I in things)
			STR.remove_from_storage(I, get_turf(src))

/obj/item/clothing/cloak/MiddleClick(mob/user)
	overarmor = !overarmor
	to_chat(user, span_info("I [overarmor ? "wear [src] over my armor" : "wear [src] under my armor"]."))

	alternate_worn_layer = overarmor ? TABARD_LAYER : UNDER_ARMOR_LAYER

	user.update_inv_cloak()
	user.update_inv_armor()

//////////////////////////
/// TABARD
////////////////////////

/obj/item/clothing/cloak/tabard
	name = "tabard"
	desc = "A long vest meant for knights."
	color = null
	icon_state = "tabard"
	item_state = "tabard"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB
	var/custom_design = FALSE

/obj/item/clothing/cloak/tabard/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/cloak/tabard/attack_right(mob/user)
	if(custom_design)
		return
	var/the_time = world.time
	var/design = input(user, "Select a design.","Tabard Design") as null|anything in list("None", "Symbol", "Split", "Quadrants", "Boxes", "Diamonds")
	if(!design)
		return
	if(world.time > (the_time + 30 SECONDS))
		return
	var/symbol_chosen = FALSE
	if(design == "Symbol")
		design = null
		design = input(user, "Select a symbol.","Tabard Design") as null|anything in list("chalice","psy","peace","z","imp","skull","widow","arrow")
		if(!design)
			return
		design = "_[design]"
		symbol_chosen = TRUE
	var/colorone = input(user, "Select a primary color.","Tabard Design") as null|anything in COLOR_MAP
	if(!colorone)
		return
	var/colortwo
	if(design != "None")
		colortwo = input(user, "Select a secondary color.","Tabard Design") as null|anything in COLOR_MAP
		if(!colortwo)
			return
	if(world.time > (the_time + 30 SECONDS))
		return
	if(design != "None")
		detail_tag = design
	switch(design)
		if("Split")
			detail_tag = "_spl"
		if("Quadrants")
			detail_tag = "_quad"
		if("Boxes")
			detail_tag = "_box"
		if("Diamonds")
			detail_tag = "_dim"
	boobed_detail = !symbol_chosen
	color = COLOR_MAP[colorone]
	if(colortwo)
		detail_color = COLOR_MAP[colortwo]
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()
	if(alert("Are you pleased with your heraldry?", "Heraldry", "Yes", "No") != "Yes")
		detail_color = initial(detail_color)
		color = initial(color)
		boobed_detail = initial(boobed_detail)
		detail_tag = initial(detail_tag)
		update_icon()
		if(ismob(loc))
			var/mob/L = loc
			L.update_inv_cloak()
		return
	custom_design = TRUE

/obj/item/clothing/cloak/tabard/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)


/obj/item/clothing/cloak/tabard/abyssortabard
	name = "abyssorite tabard"
	desc = "A tabard worn by Abyssorite devouts."
	color = null
	icon_state = "abyssortabard"
	item_state = "abyssortabard"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	custom_design = TRUE

/obj/item/clothing/cloak/tabard/psydontabard
	name = "psydonian tabard"
	desc = "A tabard worn by Psydon's disciples. Delicate stitchwork professes the psycross with pride."
	color = null
	icon_state = "psydontabard"
	item_state = "psydontabard"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	custom_design = TRUE
	var/open_wear = FALSE

/obj/item/clothing/cloak/tabard/psydontabard/alt
	name = "opened psydonian tabard"
	desc = "A tabard worn by Psydon's disciples, peeled back to reveal its enduring innards."
	body_parts_covered = GROIN
	icon_state = "psydontabardalt"
	item_state = "psydontabardalt"
	flags_inv = HIDECROTCH
	open_wear = TRUE

/obj/item/clothing/cloak/tabard/psydontabard/MiddleClick(mob/user)
	..()
	user.update_inv_shirt()

/obj/item/clothing/cloak/tabard/psydontabard/attack_right(mob/user)
	switch(open_wear)
		if(FALSE)
			name = "opened psydonian tabard"
			desc = "A tabard worn by Psydon's disciples, peeled back to reveal its enduring innards."
			body_parts_covered = GROIN
			icon_state = "psydontabardalt"
			item_state = "psydontabardalt"
			open_wear = TRUE
			flags_inv = HIDECROTCH // BARE YOUR CHEST, NOT YOUR WEEN!
			to_chat(usr, span_warning("ENDURING, like the MARTYRS who'll guide the faithful-and-pious to PARADISE."))
		if(TRUE)
			name = "psydonian tabard"
			desc = "A tabard worn by Psydon's disciples. Delicate stitchwork professes the psycross with pride."
			body_parts_covered = CHEST|GROIN
			icon_state = "psydontabard"
			item_state = "psydontabard"
			flags_inv = HIDECROTCH|HIDEBOOB
			open_wear = FALSE
			to_chat(usr, span_warning("VEILED, like the CORPSES who've been shepherded by your steel to the AFTERLYFE."))
	update_icon()
	if(user)
		if(ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_cloak()
			H.update_inv_armor()

/obj/item/clothing/cloak/templar/astratan
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	alternate_worn_layer = TABARD_LAYER
	boobed = FALSE
	name = "astratan tabard"
	desc = "The washed out golds of an asratan crusader adorn these fine robes."
	icon_state = "astratatabard"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/cloak/templar/malumite
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	alternate_worn_layer = TABARD_LAYER
	boobed = FALSE
	name = "tabard of malum"
	desc = "Light blacks and greys, with a tinge of red, the everlasting fire of Malum's iron hammer as it strikes."
	icon_state = "malumtabard"

/obj/item/clothing/cloak/templar/necran
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	alternate_worn_layer = TABARD_LAYER
	boobed = FALSE
	name = "necran tabard"
	desc = "Deep dark blacks, swallowing all light as if the night itself."
	icon_state = "necratabard"

/obj/item/clothing/cloak/templar/pestran
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	alternate_worn_layer = TABARD_LAYER
	boobed = TRUE
	name = "pestran tabard"
	desc = "A simple covering of green cloth, meant to keep rot and blood alike off it's wearer."
	icon_state = "pestratabard"

/obj/item/clothing/cloak/templar/eoran
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	alternate_worn_layer = TABARD_LAYER
	boobed = TRUE
	name = "eoran tabard"
	desc = "A complex covering of translucent pink and beige clothes. They carry the scent of flowers in them."
	icon_state = "eoratabard"

/obj/item/clothing/cloak/templar/xylixian
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	alternate_worn_layer = TABARD_LAYER
	boobed = TRUE
	name = "xylixian cloak"
	desc = "Swirling cloth, jingling bells! Oh, how I love the path to hell!"
	icon_state = "xylixcloak"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_cloaks.dmi'
	sleevetype = "shirt"

/obj/item/clothing/cloak/templar/undivided
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	alternate_worn_layer = TABARD_LAYER
	boobed = TRUE
	name = "undivided tabard"
	desc = "The refuge of the TEN upon my back. A Undivided House, standing eternal against the encroaching darkness."
	icon_state = "seetabard"

/obj/item/clothing/cloak/tabard/devotee
	nodismemsleeves = TRUE
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB
	custom_design = TRUE

/obj/item/clothing/cloak/tabard/devotee/psydon
	name = "psydon tabard"
	desc = "An outer garment commonly worn by soldiers. This one has the symbol of Psydon on it."
	icon_state = "tabard_weeping"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"

/obj/item/clothing/cloak/tabard/devotee/astrata
	name = "astratan tabard"
	desc = "An outer garment commonly worn by soldiers. This one has the symbol of Astrata on it."
	icon_state = "tabard_astrata_alt"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"

/obj/item/clothing/cloak/tabard/devotee/noc
	name = "noc tabard"
	desc = "An outer garment commonly worn by soldiers. This one has the symbol of Noc on it."
	icon_state = "tabard_noc"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"

/obj/item/clothing/cloak/tabard/devotee/dendor
	name = "dendor tabard"
	desc = "An outer garment commonly worn by soldiers. This one has the symbol of Dendor on it."
	icon_state = "tabard_dendor"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"

/obj/item/clothing/cloak/tabard/devotee/necra
	name = "necra tabard"
	desc = "An outer garment commonly worn by soldiers. This one has the symbol of Necra on it."
	icon_state = "tabard_necra"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"

/obj/item/clothing/cloak/tabard/devotee/abyssor
	name = "abyssor tabard"
	desc = "An outer garment commonly worn by soldiers. This one has the symbol of Abyssor on it."
	icon_state = "tabard_abyssor"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"

/obj/item/clothing/cloak/tabard/devotee/malum
	name = "malum tabard"
	desc = "An outer garment commonly worn by soldiers. This one has the symbol of Malum on it."
	icon_state = "tabard_malum"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"


/obj/item/clothing/cloak/tabard/knight
	color = CLOTHING_PURPLE
	custom_design = TRUE

/obj/item/clothing/cloak/tabard/knight/Initialize()
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/cloak/tabard/knight/Destroy()
	GLOB.lordcolor -= src
	return ..()


/obj/item/clothing/cloak/tabard/retinue
	desc = "A tabard with the lord's heraldic colors."
	color = CLOTHING_AZURE
	detail_tag = "_quad"
	detail_color = CLOTHING_WHITE

/obj/item/clothing/cloak/tabard/retinue/Initialize()
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/cloak/tabard/retinue/lordcolor(primary,secondary)
	color = primary
	detail_color = secondary
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()

/obj/item/clothing/cloak/tabard/retinue/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/cloak/tabard/retinue/captain //Because of his other snowflake cloak we can't actually use the naming normally.
	name = "captain's tabard"


/obj/item/clothing/cloak/tabard/crusader
	detail_tag = "_psy"
	detail_color = CLOTHING_RED
	boobed_detail = FALSE

/obj/item/clothing/cloak/tabard/crusader/Initialize()
	. = ..()
	update_icon()

/obj/item/clothing/cloak/tabard/crusader/attack_right(mob/user)
	if(custom_design)
		return
	var/the_time = world.time
	var/design = input(user, "Select a design.","Tabard Design") as null|anything in list("Default", "Gold Cross", "Jeruah", "BlackGold", "BlackWhite")
	if(!design)
		return
	if(world.time > (the_time + 30 SECONDS))
		return
	if(design == "Gold Cross")
		detail_color = "#b5b004"
	if(design == "Jeruah")
		detail_color = "#b5b004"
		color = "#249589"
	if(design == "BlackGold")
		detail_color = CLOTHING_YELLOW
		color = CLOTHING_BLACK
	if(design == "BlackWhite")
		detail_color = CLOTHING_WHITE
		color = CLOTHING_BLACK
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()
	if(alert("Are you pleased with your heraldry?", "Heraldry", "Yes", "No") != "Yes")
		detail_color = initial(detail_color)
		color = initial(color)
		update_icon()
		if(ismob(loc))
			var/mob/L = loc
			L.update_inv_cloak()
		return
	custom_design = TRUE

/obj/item/clothing/cloak/tabard/crusader/tief
	color = CLOTHING_RED
	detail_color = CLOTHING_WHITE

/obj/item/clothing/cloak/tabard/crusader/tief/attack_right(mob/user)
	if(custom_design)
		return
	var/the_time = world.time
	var/design = input(user, "Select a design.","Tabard Design") as null|anything in list("Default", "RedBlack", "BlackRed")
	if(!design)
		return
	if(world.time > (the_time + 30 SECONDS))
		return
	if(design == "RedBlack")
		detail_color = CLOTHING_BLACK
		color = CLOTHING_RED
	if(design == "BlackRed")
		detail_color = CLOTHING_RED
		color = CLOTHING_BLACK
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()
	if(alert("Are you pleased with your heraldry?", "Heraldry", "Yes", "No") != "Yes")
		detail_color = initial(detail_color)
		color = initial(color)
		update_icon()
		if(ismob(loc))
			var/mob/L = loc
			L.update_inv_cloak()
		return
	custom_design = TRUE

/obj/item/clothing/cloak/tabard/crusader/astrata
	color = "#9B7538"
	detail_color = CLOTHING_WHITE

/obj/item/clothing/cloak/tabard/crusader/ravox
	color = CLOTHING_RED
	detail_color = CLOTHING_BLACK

/obj/item/clothing/cloak/tabard/crusader/malum
	color = CLOTHING_RED
	detail_color = CLOTHING_YELLOW

/obj/item/clothing/cloak/tabard/crusader/abyssor
	color = "#373f69"
	detail_color = "#974305"

/obj/item/clothing/cloak/tabard/crusader/dendor
	color = "#4B5637"
	detail_color = "#3D1D1C"

/obj/item/clothing/cloak/tabard/crusader/necra
	color = "#222223"
	detail_color = "#CACBC5"

/obj/item/clothing/cloak/tabard/crusader/pestra
	color = CLOTHING_WHITE
	detail_color = CLOTHING_GREEN

/obj/item/clothing/cloak/tabard/crusader/noc
	color = "#2C2231"
	detail_color = "#9AB0B0"

/obj/item/clothing/cloak/tabard/crusader/psydon
	color = CLOTHING_BLACK
	detail_color = CLOTHING_WHITE

/obj/item/clothing/cloak/tabard/crusader/eora
	color = "#4D1E49"
	detail_color = "#A95650"


//////////////////////////
/// SOLDIER TABARD
////////////////////////


/obj/item/clothing/cloak/tabard/stabard
	name = "surcoat"
	desc = "An outer garment commonly worn by soldiers."
	icon_state = "stabard"
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE

/obj/item/clothing/cloak/tabard/stabard/guard
	name = "guard tabard"
	desc = "A tabard with the lord's heraldic colors."
	color = CLOTHING_AZURE
	detail_tag = "_spl"
	detail_color = CLOTHING_WHITE

/obj/item/clothing/cloak/tabard/stabard/guard/Initialize()
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/cloak/tabard/stabard/guard/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/cloak/tabard/stabard/guard/lordcolor(primary,secondary)
	color = primary
	detail_color = secondary
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()

/obj/item/clothing/cloak/tabard/stabard/guard/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/cloak/tabard/stabard/bog
	name = "bogman tabard"
	desc = "A tabard colored in a glorius green of the mighty protectors of the BOG." // THE BOG DESERVES A BETTER DESCRIPTION!
	color = CLOTHING_GREEN
	detail_color = CLOTHING_DARK_GREEN

/obj/item/clothing/cloak/tabard/stabard/grenzelhoft
	name = "grenzelhoft mercenary tabard"
	desc = "A tabard bearing the colors of the Grenzelhoft emperiate mercenary guild."
	color = CLOTHING_YELLOW
	detail_color = CLOTHING_RED
	detail_tag = "_box"

/obj/item/clothing/cloak/tabard/stabard/dungeon
	color = CLOTHING_BLACK

/obj/item/clothing/cloak/tabard/stabard/dungeon/attack_right(mob/user)
	return

/obj/item/clothing/cloak/tabard/stabard/mercenary
	detail_tag = "_quad"

/obj/item/clothing/cloak/tabard/stabard/mercenary/Initialize()
	. = ..()
	detail_tag = pick("_quad", "_spl", "_box", "_dim")
	color = pick(CLOTHING_COLOR_MAP)
	detail_color = pick(CLOTHING_COLOR_MAP)
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()


//////////////////////////
/// SURCOATS
////////////////////////


/obj/item/clothing/cloak/tabard/stabard/surcoat
	name = "jupon"
	icon_state = "surcoat"

/obj/item/clothing/cloak/tabard/stabard/surcoat/bailiff
	color = "#641E16"

/obj/item/clothing/cloak/tabard/stabard/surcoat/councillor
	color = "#2d2d2d"

/obj/item/clothing/cloak/tabard/stabard/surcoat/short
	name = "short jupon"
	icon_state = "surcoat_short"
	body_parts_covered = CHEST

/obj/item/clothing/cloak/tabard/stabard/surcoat/guard
	desc = "A surcoat with the lord's heraldic colors."
	color = CLOTHING_AZURE
	detail_tag = "_quad"
	detail_color = CLOTHING_WHITE

/obj/item/clothing/cloak/tabard/stabard/surcoat/guard/Initialize()
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/cloak/tabard/stabard/surcoat/guard/lordcolor(primary,secondary)
	color = primary
	detail_color = secondary
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()

/obj/item/clothing/cloak/tabard/stabard/surcoat/guard/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/cloak/tabard/stabard/black
	color = CLOTHING_BLACK


/obj/item/clothing/cloak/lordcloak
	name = "lordly cloak"
	desc = "Ermine trimmed, handed down."
	color = null
	icon_state = "lord_cloak"
	item_state = "lord_cloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	boobed = TRUE
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = TRUE
	allowed_race = NON_DWARVEN_RACE_TYPES
	detail_tag = "_det"
	detail_color = CLOTHING_AZURE

/obj/item/clothing/cloak/lordcloak/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/cloak/lordcloak/lordcolor(primary,secondary)
	detail_color = primary
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()

/obj/item/clothing/cloak/lordcloak/Initialize()
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/cloak/lordcloak/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/cloak/darkcloak
	name = "dark cloak"
	desc = "It'll warm up your flesh, but not your cold, dead heart."
	color = null
	icon_state = "dark_cloak"
	item_state = "dark_cloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	boobed = TRUE
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = TRUE
	allowed_race = NON_DWARVEN_RACE_TYPES
	salvage_result = /obj/item/natural/fur

/obj/item/clothing/cloak/darkcloak/bear
	name = "direbear cloak"
	desc = "Made from the finest, warmest bear pelt. It might be worth more than your life."
	icon_state = "bear_cloak"
	item_state = "bear_cloak"
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 3

/obj/item/clothing/cloak/darkcloak/bear/light
	name = "light direbear cloak"
	icon_state = "bbear_cloak"
	item_state = "bbear_cloak"
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 3

/obj/item/clothing/cloak/apron
	name = "apron"
	desc = "An apron used by many workshop workers."
	color = null
	icon_state = "apron"
	item_state = "apron"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	allowed_race = CLOTHED_RACES_TYPES
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/cloak/apron/blacksmith
	name = "leather apron"
	desc = "A leather apron used by those who temper metals and work forges."
	color = null
	icon_state = "leather_apron"
	item_state = "leather_apron"
	body_parts_covered = CHEST|GROIN
	armor = ARMOR_CLOTHING
	boobed = TRUE
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/cloak/apron/brown
	color = CLOTHING_BROWN

/obj/item/clothing/cloak/apron/waist
	name = "apron"
	desc = "An apron used by many workshop workers."
	color = null
	icon_state = "waistpron"
	item_state = "waistpron"
	body_parts_covered = GROIN
	boobed = FALSE
	flags_inv = HIDECROTCH

/obj/item/clothing/cloak/apron/waist/brown
	color = CLOTHING_BROWN

/obj/item/clothing/cloak/apron/waist/bar
	color = "#251f1d"


/obj/item/clothing/cloak/apron/cook
	name = "cook apron"
	desc = "An apron meant to show how clean the cook is."
	color = null
	icon_state = "aproncook"
	item_state = "aproncook"
	body_parts_covered = GROIN
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	boobed = FALSE

/obj/item/clothing/cloak/raincloak
	name = "rain cloak"
	desc = "This one will help against the rainy weather."
	color = null
	icon_state = "rain_cloak"
	item_state = "rain_cloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	boobed = TRUE
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = TRUE
	hoodtype = /obj/item/clothing/head/hooded/rainhood
	toggle_icon_state = FALSE
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/cloak/raincloak/red
	color = CLOTHING_RED

/obj/item/clothing/cloak/raincloak/mortus
	desc = "You're always shrouded by death."
	color = CLOTHING_BLACK

/obj/item/clothing/cloak/raincloak/brown
	color = CLOTHING_BROWN
	sellprice = 25

/obj/item/clothing/cloak/raincloak/green
	color = CLOTHING_GREEN

/obj/item/clothing/cloak/raincloak/blue
	color = CLOTHING_BLUE

/obj/item/clothing/cloak/raincloak/purple
	color = CLOTHING_PURPLE

/obj/item/clothing/head/hooded/rainhood
	name = "hood"
	desc = "This one will shelter me from the weather and my identity too."
	icon_state = "rain_hood"
	item_state = "rain_hood"
	slot_flags = ITEM_SLOT_HEAD
	dynamic_hair_suffix = ""
	edelay_type = 1
	body_parts_covered = HEAD
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDETAIL
	block2add = FOV_BEHIND

/obj/item/clothing/cloak/raincloak/furcloak
	name = "fur cloak"
	desc = "This glorious cloak is made of animal fur. Very soft and warm."
	icon_state = "furgrey"
	inhand_mod = FALSE
	hoodtype = /obj/item/clothing/head/hooded/rainhood/furhood
	salvage_result = /obj/item/natural/fur

/obj/item/clothing/cloak/raincloak/furcloak/crafted/Initialize()
	. = ..()
	if(prob(50))
		color = pick("#685542","#66564d")

/obj/item/clothing/cloak/raincloak/furcloak/brown
	color = "#685542"

/obj/item/clothing/cloak/raincloak/furcloak/black
	color = "#2b292e"

/obj/item/clothing/cloak/raincloak/furcloak/darkgreen
	color = "#264d26"

/obj/item/clothing/cloak/raincloak/furcloak/woad
	name = "Warden's fur cloak"
	desc = "Usually sewn by the very wardens that wear them, this hue of blue is made to alart denizens of the forest to their presence."
	color = "#597fb9"

/obj/item/clothing/head/hooded/rainhood/furhood
	icon_state = "fur_hood"
	block2add = FOV_BEHIND

/obj/item/clothing/cloak/cape
	name = "cape"
	desc = "A beautiful, flowing cape. Too bad it tangles too much on the vegetation."
	color = null
	icon_state = "cape"
	item_state = "cape"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	boobed = TRUE
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = FALSE
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK

/obj/item/clothing/cloak/cape/purple
	color = CLOTHING_PURPLE

/obj/item/clothing/cloak/cape/knight
	color = CLOTHING_WHITE

/obj/item/clothing/cloak/cape/guard
	color = CLOTHING_AZURE

/obj/item/clothing/cloak/cape/guard/Initialize()
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/cloak/cape/guard/lordcolor(primary,secondary)
	color = secondary
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()

/obj/item/clothing/cloak/cape/guard/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/cloak/cape/puritan
	icon_state = "puritan_cape"
	allowed_race = CLOTHED_RACES_TYPES
	salvage_result = /obj/item/natural/silk
	salvage_amount = 1

/obj/item/clothing/cloak/cape/archivist
	icon_state = "puritan_cape"
	color = CLOTHING_BLACK
	allowed_race = CLOTHED_RACES_TYPES

/obj/item/clothing/cloak/cape/inquisitor
	name = "Inquisitors Cloak"
	desc = "A time honored cloak Valorian design, used by founding clans of the Valorian Lodge"
	icon_state = "inquisitor_cloak"
	icon = 'icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'

/obj/item/clothing/cloak/cape/rogue
	name = "cape"
	icon_state = "roguecape"
	item_state = "roguecape"

/obj/item/clothing/cloak/cape/hood
	name = "hooded cape"
	icon_state = "hoodcape"
	item_state = "hoodcape"

/obj/item/clothing/cloak/cape/fur
	name = "fur cape"
	icon_state = "furcape"
	item_state = "furcape"
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	inhand_mod = TRUE
	salvage_result = /obj/item/natural/fur

/obj/item/clothing/cloak/chasuble
	name = "chasuble"
	desc = ""
	icon_state = "chasuble"
	body_parts_covered = CHEST|GROIN|ARMS
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_CLOAK
	allowed_sex = list(MALE, FEMALE)
	allowed_race = NON_DWARVEN_RACE_TYPES
	nodismemsleeves = TRUE

/obj/item/clothing/cloak/stole
	name = "stole"
	desc = ""
	icon_state = "stole_gold"
	item_state = "stole_gold"
	sleeved = null
	sleevetype = null
	body_parts_covered = null
	flags_inv = null

/obj/item/clothing/cloak/stole/red
	icon_state = "stole_red"
	item_state = "stole_red"

/obj/item/clothing/cloak/stole/purple
	icon_state = "stole_purple"

/obj/item/clothing/cloak/black_cloak
	name = "fur overcoat"
	desc = "A very thick, baggy set of robes trimmed with fur, meant to be worn over one's clothing."
	icon_state = "black_cloak"
	body_parts_covered = CHEST|GROIN|VITALS|ARMS
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_CLOAK
	allowed_sex = list(MALE, FEMALE)
	allowed_race = NON_DWARVEN_RACE_TYPES
	sellprice = 50
	nodismemsleeves = TRUE
	salvage_result = /obj/item/natural/fur

/obj/item/clothing/cloak/heartfelt
	name = "red cloak"
	desc = ""
	icon_state = "heartfelt_cloak"
	body_parts_covered = CHEST|GROIN|VITALS|ARMS
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_CLOAK
	allowed_sex = list(MALE, FEMALE)
	allowed_race = NON_DWARVEN_RACE_TYPES
	sellprice = 50
	nodismemsleeves = TRUE

/obj/item/clothing/cloak/undivided
	name = "undivided cloak"
	desc = "The refuge of the TEN upon my back. A Undivided House, standing eternal against the encroaching darkness."
	icon_state = "seecloak"
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK

/obj/item/clothing/cloak/half
	name = "halfcloak"
	desc = ""
	color = null
	icon_state = "halfcloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	boobed = TRUE
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = TRUE
	hoodtype = null
	toggle_icon_state = FALSE
	color = CLOTHING_BLACK
	allowed_sex = list(MALE, FEMALE)
	flags_inv = null
	var/flipped = FALSE

/obj/item/clothing/cloak/half/attack_right(mob/user)
	if(!flipped)
		icon_state += "_rev"
		flipped = TRUE
	else
		icon_state = initial(icon_state)
		flipped = FALSE
	user.regenerate_icons()

/obj/item/clothing/cloak/half/brown
	color = CLOTHING_BROWN

/obj/item/clothing/cloak/half/red
	color = CLOTHING_RED

/obj/item/clothing/cloak/half/orange
	color = CLOTHING_ORANGE

/obj/item/clothing/cloak/half/rider
	name = "rider cloak"
	icon_state = "guardcloak"
	color = CLOTHING_AZURE
	allowed_sex = list(MALE, FEMALE)
	allowed_race = NON_DWARVEN_RACE_TYPES
	inhand_mod = FALSE

/obj/item/clothing/cloak/half/rider/red
	color = CLOTHING_RED

/obj/item/clothing/cloak/half/vet
	name = "town watch cloak"
	icon_state = "guardcloak"
	color = CLOTHING_AZURE
	allowed_sex = list(MALE, FEMALE)
	allowed_race = NON_DWARVEN_RACE_TYPES
	inhand_mod = FALSE

/obj/item/clothing/cloak/half/vet/Initialize()
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/cloak/half/vet/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/cloak/half/shadowcloak
	name = "stalker cloak"
	desc = "A heavy leather cloak held together by a gilded pin, depicting the Grand Duke's house. The sign of a faithful servant."
	icon_state = "shadowcloak"
	color = null
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/cloak/thief_cloak
	name = "rapscallion's shawl"
	desc = "A simple shawl clapsed with an ersatz fastener. Practical and functional, though the fabric is rough and wearing bare."
	icon_state = "thiefcloak"
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	color = CLOTHING_ORANGE

/obj/item/clothing/cloak/thief_cloak/yoruku
	color = CLOTHING_BLACK

/obj/item/clothing/cloak/volfmantle
	name = "volf mantle"
	desc = "A warm cloak made using the hide and head of a slain volf. A status symbol if ever there was one."
	color = null
	icon_state = "volfpelt"
	item_state = "volfpelt"
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = FALSE
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 1

/obj/item/clothing/cloak/wickercloak
	name = "wicker cloak"
	desc = "A makeshift cloak constructed with mud, sticks and fibers."
	icon_state = "wicker_cloak"
	item_state = "wicker_cloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	allowed_sex = list(MALE, FEMALE)
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = TRUE
	salvage_result = /obj/item/natural/fibers
	salvage_amount = 2

/obj/item/clothing/cloak/tribal
	name = "tribal pelt"
	desc = "A haphazardly cured pelt of a creecher, thrown on top of one's body or armor, to serve as additional protection against the cold. Itchy."
	icon_state = "tribal"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	body_parts_covered = CHEST|GROIN|VITALS
	allowed_sex = list(MALE, FEMALE)
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	nodismemsleeves = TRUE
	boobed = FALSE
	sellprice = 10

/obj/item/clothing/cloak/lordcloak/ladycloak
	name = "ladylike shortcloak"
	desc = "Ermine trimmed, handed down."
	color = null
	icon_state = "shortcloak"
	item_state = "shortcloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	boobed = TRUE
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	detail_tag = "_detail"
	detail_color = CLOTHING_BLACK

/obj/item/clothing/cloak/matron
	name = "matron cloak"
	desc = "A cloak that only the meanest of old crones bother to wear."
	icon_state = "matroncloak"
	icon = 'icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon ='icons/roguetown/clothing/onmob/cloaks.dmi'
	body_parts_covered = CHEST|GROIN|VITALS|ARMS
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_CLOAK
	nodismemsleeves = TRUE
	sleevetype = "shirt"
	slot_flags = ITEM_SLOT_CLOAK

/obj/item/clothing/cloak/battlenun
	name = "nun vestments"
	desc = "Chaste, righteous, merciless to the wicked."
	color = null
	icon_state = "battlenun"
	allowed_sex = list(FEMALE)
	item_state = "battlenun"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK

/obj/item/clothing/cloak/templar/MiddleClick(mob/user)
	overarmor = !overarmor
	to_chat(user, span_info("I [overarmor ? "wear the tabard over my armor" : "wear the tabard under my armor"]."))
	if(overarmor)
		alternate_worn_layer = TABARD_LAYER
	else
		alternate_worn_layer = UNDER_ARMOR_LAYER
	user.update_inv_cloak()
	user.update_inv_armor()

/obj/item/clothing/cloak/templar/eora
	name = "eora tabard"
	desc = "An outer garment commonly worn by soldiers. This one has the symbol of Eora on it."
	icon_state = "tabard_eora"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/cloak/templar/pestra
	name = "pestra tabard"
	desc = "An outer garment commonly worn by soldiers. This one has the symbol of Pestra on it."
	icon_state = "tabard_pestra"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/cloak/cleric/ravox
	name = "ravox tabard"
	desc = "An outer garment commonly worn by soldiers. This one has the symbol of Ravox on it."
	icon_state = "tabard_ravox"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/cloak/templar/ravox
	name = "justice tabard"
	desc = "An underarmor vestments with a neck cover, worn by templars of Ravox."
	icon_state = "justicetabard"
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK|ITEM_SLOT_MASK
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/cloak/templar/xylix
	name = "xylix tabard"
	desc = "An outer garment commonly worn by soldiers. This one has the symbol of Xylix on it."
	icon_state = "tabard_xylix"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/cloak/cape/blkknight
	name = "blood cape"
	icon_state = "bkcape"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'

/obj/item/clothing/cloak/tabard/blkknight
	name = "blood sash"
	icon_state = "bksash"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'

/obj/item/clothing/under/roguetown/platelegs/blk
	name = "blacksteel legs"
	icon_state = "bklegs"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'

/obj/item/clothing/gloves/roguetown/plate/blk
	name = "blacksteel gaunties"
	icon_state = "bkgloves"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'

/obj/item/clothing/neck/roguetown/blkknight
	name = "dragonscale necklace" //Who the hell put a NECKLACE in the CLOAKS file?
	desc = "A blacksteel chain, laced through a dozen of the Hoardmaster's golden teeth. Atuned to the beating heart of Psydonia's financial systems, its true strength can only be harnessed by those who covet wealth above all else."
	icon_state = "bktrinket"
	max_integrity = 666 //Exceptionally strong, can be purchased multiple times, and provides a flat +2 to the entire statblock. If it gets destroyed in a fight, that's fair game. Reduced from the original value of 100,000.
	armor = ARMOR_DRAGONSCALE
	prevent_crits = PREVENT_CRITS_NONE
	blocksound = PLATEHIT
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	//dropshrink = 0.75
	resistance_flags = FIRE_PROOF
	sellprice = 666
	static_price = TRUE
	smeltresult = /obj/item/riddleofsteel
	anvilrepair = /datum/skill/craft/armorsmithing
	var/active_item = FALSE

/obj/item/clothing/neck/roguetown/blkknight/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	if(slot == SLOT_NECK)
		active_item = TRUE
		if(user.mind.special_role == "Bandit")
			to_chat(user, span_monkeyhive("Matthios empowers me! My body glistens with spiritual wealth!"))
			user.change_stat(STATKEY_STR, 2)
			user.change_stat(STATKEY_PER, 2)
			user.change_stat(STATKEY_INT, 2)
			user.change_stat(STATKEY_CON, 2)
			user.change_stat(STATKEY_WIL, 2)
			user.change_stat(STATKEY_SPD, 2)
			user.change_stat(STATKEY_LCK, 2)
			armor = getArmor("blunt" = 100, "slash" = 100, "stab" = 100, "piercing" = 100, "fire" = 50, "acid" = 0)
		else
			to_chat(user, span_suicide("As I don the necklace, I feel my very worth draining away.."))
			armor = getArmor("blunt" = 0, "slash" = 0, "stab" = 0, "piercing" = 0, "fire" = 0, "acid" = 0)

/obj/item/clothing/neck/roguetown/blkknight/dropped(mob/living/user)
	..()
	if(!active_item)
		return
	active_item = FALSE
	if(user.mind.special_role == "Bandit")
		to_chat(user, span_monkeyhive("Golden sparks flutter from the teeth, before they fade away - and with it, the blessing of Matthios.."))
		user.change_stat(STATKEY_STR, -2)
		user.change_stat(STATKEY_PER, -2)
		user.change_stat(STATKEY_INT, -2)
		user.change_stat(STATKEY_CON, -2)
		user.change_stat(STATKEY_WIL, -2)
		user.change_stat(STATKEY_SPD, -2)
		user.change_stat(STATKEY_LCK, -2)
	else
		to_chat(user, span_suicide("..dripping down from the heavens, I feel my worth returning once more.."))
		armor = getArmor("blunt" = 100, "slash" = 100, "stab" = 100, "piercing" = 100, "fire" = 50, "acid" = 0)

/obj/item/clothing/suit/roguetown/armor/plate/blkknight
	slot_flags = ITEM_SLOT_ARMOR
	name = "darkened steel plate"
	desc = "A darkened half-plate piece with added arm coverage."
	body_parts_covered = CHEST|GROIN|VITALS|ARMS
	r_sleeve_status = SLEEVE_NOMOD
	l_sleeve_status = SLEEVE_NOMOD
	icon_state = "bkarmor"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'

/obj/item/clothing/shoes/roguetown/boots/armor/blkknight
	name = "darkened steel boots"
	icon_state = "bkboots"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'

//Short hoods for guards

/obj/item/clothing/cloak/tabard/stabard/guardhood
	name = "guard hood"
	desc = "A hood with the lord's heraldic colors."
	color = CLOTHING_AZURE
	detail_tag = "_spl"
	detail_color = CLOTHING_WHITE
	icon_state = "guard_hood"
	item_state = "guard_hood"
	body_parts_covered = CHEST

/obj/item/clothing/cloak/tabard/stabard/guardhood/attack_right(mob/user)
	if(custom_design)
		return
	var/the_time = world.time
	var/chosen = input(user, "Select a design.","Tabard Design") as null|anything in list("Split")
	if(world.time > (the_time + 10 SECONDS))
		return
	if(!chosen)
		return
	switch(chosen)
		if("Split")
			detail_tag = "_spl"
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()
	if(alert("Are you pleased with your heraldry?", "Heraldry", "Yes", "No") != "Yes")
		detail_tag = initial(detail_tag)
		update_icon()
		if(ismob(loc))
			var/mob/L = loc
			L.update_inv_cloak()
		return
	custom_design = TRUE

/obj/item/clothing/cloak/tabard/stabard/guardhood/Initialize()
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/cloak/tabard/stabard/guardhood/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/cloak/tabard/stabard/guardhood/lordcolor(primary,secondary)
	color = primary
	detail_color = secondary
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()

/obj/item/clothing/cloak/tabard/stabard/guardhood/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/cloak/tabard/stabard/guardhood/elder
	name = "elder's hood"

/obj/item/clothing/cloak/hierophant
	name = "hierophant's sash"
	icon_state = "naledisash"
	item_state = "naledisash"
	desc = "A limp piece of fabric traditionally used to fasten bags that are too baggy, but in modern days has become more of a fashion statement than anything."

/obj/item/clothing/cloak/tabard/stabard/grenzelmage
	name = "grenzelhoftian magos mantle"
	desc = "A fashionable Mantle often worn by Celestial Academy Magos."
	color = CLOTHING_WHITE
	detail_color = CLOTHING_WHITE
	detail_tag = "_spl"
	icon_state = "guard_hood" // The same as the guard hood however to break it from using the lords colors it has been given its own item path
	item_state = "guard_hood"
	body_parts_covered = CHEST

/obj/item/clothing/cloak/wardencloak
	name = "warden cloak"
	desc = "A cloak worn by the Wardens of Azuria's Forests"
	icon_state = "wardencloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = TRUE

/obj/item/clothing/cloak/graggar
	name = "vicious cloak"
	desc = "The only motive force in this rotten world is violence. Be its wielder, not its victim."
	icon_state = "graggarcloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = TRUE

/obj/item/clothing/cloak/graggar/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_HORDE, "CLOAK", "RENDERED ASUNDER")

/obj/item/clothing/cloak/forrestercloak
	name = "forrester cloak"
	desc = "A cloak worn by the Black Oaks of Azuria."
	icon_state = "forestcloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = TRUE

/obj/item/clothing/cloak/forrestercloak/snow
	name = "snow cloak"
	desc = "A cloak meant to keep one's body warm in the cold of the mountains as well as the dampness of Azuria."
	icon_state = "snowcloak"

/obj/item/clothing/cloak/poncho
	name = "cloth poncho"
	desc = "A loose garment that is usually draped across ones upper body. No one's quite sure of its cultural origin."
	icon_state = "poncho"
	item_state = "poncho"
	alternate_worn_layer = TABARD_LAYER
	boobed = FALSE
	flags_inv = HIDECROTCH|HIDEBOOB
	slot_flags = ITEM_SLOT_CLOAK|ITEM_SLOT_ARMOR
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	nodismemsleeves = TRUE
	color = CLOTHING_WHITE
	detail_tag = "_detail"
	detail_color = CLOTHING_WHITE

/obj/item/clothing/cloak/poncho/fancycoat
	name = "fancy coat"
	desc = "A loose garment that is usually draped across ones upper body. No one's quite sure of its cultural origin but it does look fancy."
	icon_state = "fancycoat"
	item_state = "fancycoat"
	alternate_worn_layer = TABARD_LAYER
	boobed = FALSE
	flags_inv = HIDECROTCH|HIDEBOOB
	slot_flags = ITEM_SLOT_CLOAK|ITEM_SLOT_ARMOR
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	nodismemsleeves = TRUE
	color = CLOTHING_WHITE
	detail_tag = "_detail"
	detail_color = CLOTHING_WHITE

/obj/item/clothing/cloak/eastcloak1
	name = "cloud-cutter's cloak"
	desc = "A brown cloak with white swirls. Some Kazengites may recognize it as an old militaristic symbol."
	color = null
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	icon_state = "eastcloak1"
	item_state = "eastcloak1"
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = FALSE
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/cloak/eastcloak2
	name = "leather cloak"
	desc = "A brown cloak. There's nothing special on it."
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	color = null
	icon_state = "eastcloak2"
	item_state = "eastcloak2"
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = FALSE
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/cloak/psyaltrist
	name = "psyalter's stole"
	desc = "A silk stole embroidered with silver fillagree and with concealed pockets in its back worn over a hymnal-scroll. It is worn as the traditional garb of a graduate of the choir leaders of the cathedrals of Otava and is a symbol of their station."
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	icon_state = "psaltertabard"
	item_state = "psaltertabard"
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = TRUE

/obj/item/clothing/cloak/ordinatorcape
	name = "ordinator cape"
	desc = "A flowing red cape complete with an ornately patterned steel shoulderguard. Made to last. Made to ENDURE. Made to LYVE."
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	icon_state = "ordinatorcape"
	item_state = "ordinatorcape"
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = TRUE

/obj/item/clothing/cloak/absolutionistrobe
	name = "absolver's robe"
	desc = "Absolve them of their pain. Absolve them of their longing. Lyve, as PSYDON lyves."
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	icon_state = "absolutionistrobe"
	item_state = "absolutionistrobe"
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = TRUE

/obj/item/clothing/cloak/cotehardie
	name = "fitted coat"
	desc = "Also known as a cotehardie: a long-sleeved tunic worn by peasants and nobles alike. It's used by men and women, in both summer and winter. It won't drop any items inside when unequipped."
	color = "#586849"
	icon_state = "cotehardie"
	item_state = "cotehardie"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN|ARMS
	boobed = TRUE
	slot_flags = ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB
	detail_tag = "_detail"
	detail_color = "#36241f"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_cloaks.dmi'
	sleevetype = "cotehardie"

/obj/item/clothing/cloak/cotehardie/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/cloak/cotehardie/Initialize()
	..()
	update_icon()

/obj/item/clothing/cloak/cotehardie/MiddleClick(mob/user)
	overarmor = !overarmor
	to_chat(user, span_info("I [overarmor ? "wear the coat over my armor" : "wear the coat under my armor"]."))
	if(overarmor)
		alternate_worn_layer = TABARD_LAYER
	else
		alternate_worn_layer = UNDER_ARMOR_LAYER
	user.update_inv_cloak()
	user.update_inv_armor()

/obj/item/clothing/cloak/captain
	name = "captain's cape"
	desc = "A cape with a gold embroided heraldry of Azure."
	icon = 'icons/roguetown/clothing/special/captain.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/captain.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/captain.dmi'
	sleevetype = "shirt"
	icon_state = "capcloak"
	detail_tag = "_detail"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	detail_color = "#39404d"

/obj/item/clothing/cloak/captain/Initialize()
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary, GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/cloak/tabard/knight/guard/lordcolor(primary,secondary)
	detail_color = primary
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()

/obj/item/clothing/cloak/captain/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/cloak/apron/waist/maid
	name = "maid apron"
	desc = "A fancy, somewhat short apron usually worn by servants."
	body_parts_covered = null
	icon_state = "maidapron"
	item_state = "maidapron"
	icon = 'icons/roguetown/clothing/special/maids.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/maids.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/maids.dmi'

/obj/item/clothing/cloak/kazengun
	name = "jinbaori"
	desc = "A simple kind of Kazengunite surcoat, worn here in the distant battlefields of Azuria to differentiate friend from foe."
	icon_state = "kazenguncoat"
	item_state = "kazenguncoat"
	detail_tag = "_detail"
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	color = "#FFFFFF"
	detail_color = "#FFFFFF"
