// BASE
/obj/item/clothing/suit/roguetown/armor/plate
	slot_flags = ITEM_SLOT_ARMOR
	name = "steel half-plate"
	desc = "\'Adventurer-fit\' plate armor with pauldrons. The poor fitting leaves many small gaps for daggers and bolts to pierce something vital, so a gambeson is recommended."
	body_parts_covered = COVERAGE_TORSO
	icon_state = "halfplate"
	item_state = "halfplate"
	armor = ARMOR_PLATE
	nodismemsleeves = TRUE
	max_integrity = ARMOR_INT_CHEST_PLATE_STEEL
	allowed_sex = list(MALE, FEMALE)
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	equip_delay_self = 4 SECONDS
	unequip_delay_self = 4 SECONDS
	armor_class = ARMOR_CLASS_MEDIUM
	smelt_bar_num = 3
	chunkcolor = "#a9c1ca"

/obj/item/clothing/suit/roguetown/armor/plate/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_PLATE_STEP, 5)
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_FENCERDEXTERITY)

/obj/item/clothing/suit/roguetown/armor/plate/iron
	name = "iron half-plate"
	desc = "A basic half-plate of iron, protective and moderately durable."
	body_parts_covered = CHEST | VITALS | LEGS // Reflects the sprite, which lacks pauldrons.
	icon_state = "ihalfplate"
	item_state = "ihalfplate"
	boobed = FALSE	//the armor just looks better with this, makes sense and is 8 sprites less
	max_integrity = ARMOR_INT_CHEST_PLATE_IRON
	armor_class = ARMOR_CLASS_MEDIUM
	smeltresult = /obj/item/ingot/iron

/obj/item/clothing/suit/roguetown/armor/plate/aalloy
	name = "decrepit half-plate"
	desc = "Frayed bronze layers, bolted into plate armor. Once, the hauberk of a rising champion; now, nothing more than a fool's tomb."
	icon_state = "ancientplate"
	item_state = "ancientplate"
	max_integrity = ARMOR_INT_CHEST_PLATE_DECREPIT
	color = "#bb9696"
	chunkcolor = "#532e25"
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null
	prevent_crits = PREVENT_CRITS_NONE

/obj/item/clothing/suit/roguetown/armor/plate/paalloy
	name = "ancient half-plate"
	desc = "Polished gilbronze layers, magewelded into plate armor. Let none impede the march of progress, and let Her champions bring the unenlightened masses to kneel."
	icon_state = "ancientplate"
	item_state = "ancientplate"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/clothing/suit/roguetown/armor/plate/paalloy/artificer
	name = "artificed half-plate"
	desc = "Polished gilbronze layers, magewelded into lightweight plate armor. It holds a slot for an arcyne meld to power it."
	smeltresult = /obj/item/ingot/aaslag
	icon_state = "artificerplate"
	item_state = "artificerplate"
	armor_class = ARMOR_CLASS_LIGHT // Artificer made gilbronze.
	var/powered = FALSE
	var/mode = 1
	var/active_item = FALSE //Prevents issues like dragon ring giving negative str instead
	var/legendaryarcane = FALSE
	var/legendaryathletics = FALSE
/obj/item/clothing/suit/roguetown/armor/plate/paalloy/artificer/Initialize()
	.=..()
	update_description()

/obj/item/clothing/suit/roguetown/armor/plate/paalloy/artificer/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/rogueweapon/hammer))
		if(user.get_skill_level(/datum/skill/craft/engineering) >= 3)
			toggle_mode(user)
			return
	if(istype(I, /obj/item/magic/melded/t1) && !powered)
		user.visible_message(span_notice("[user] starts carefully setting [I] into place as a power source."))
		if(do_after(user, 5 SECONDS, target = src))
			qdel(I)
			powered = TRUE
			icon_state ="artificerplate_powered"
			item_state = "artificerplate_powered"
	.=..()

/obj/item/clothing/suit/roguetown/armor/plate/paalloy/artificer/proc/toggle_mode(mob/user)
	if(!src.ontable())
		to_chat(user, span_notice("I need to put this on a table first")) //prevents stats staying on a person if tinkered on self
	else
		mode = (mode == 1) ? 2 : 1
		user.visible_message(span_notice("[user] tinkers with [src], adjusting its enhancements."))
		update_description()

/obj/item/clothing/suit/roguetown/armor/plate/paalloy/artificer/equipped(mob/living/user, slot)
	. = ..()
	if(!powered || active_item || slot != SLOT_ARMOR)
		return
	if(mode == 1) // Arcane mode
		var/current_arcane = user.get_skill_level(/datum/skill/magic/arcane)
		if(current_arcane)
			if(current_arcane < 6) // Only add if not already capped
				active_item = TRUE
				legendaryarcane = FALSE
				user.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
				user.change_stat("intelligence", 3)
				to_chat(user, span_notice("Magicks flow throughout your body."))
				icon_state ="artificerplate_powered"
				item_state = "artificerplate_powered"
			else
				user.change_stat("intelligence", 3)
				legendaryarcane = TRUE
				active_item = TRUE
				to_chat(user, span_warning("[src] hums, but you are already a master of the arcane."))
				icon_state ="artificerplate_powered"
				item_state = "artificerplate_powered"
		else
			to_chat(user, span_warning("[src] feels cold and dead to the non-arcane."))
	if(mode == 2)
		if(slot != SLOT_ARMOR)
			return
		var/current_athletics = user.get_skill_level(/datum/skill/misc/athletics)
		if(current_athletics)
			if(current_athletics < 6)// Only add if not already capped
				user.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
				legendaryathletics = FALSE
				icon_state ="artificerplate_powered"
				item_state = "artificerplate_powered"
			else
				legendaryathletics = TRUE
			active_item = TRUE
			to_chat(user, span_notice("Strength flow throughout your body."))
			user.change_stat("strength", 2)
			user.change_stat("endurance", 2)
			icon_state ="artificerplate_powered"
			item_state = "artificerplate_powered"
			return
		else
			to_chat(user, span_warning("The curiass feels cold and dead."))

/obj/item/clothing/suit/roguetown/armor/plate/paalloy/artificer/dropped(mob/living/user)
	.=..()
	if(active_item)
		if(mode == 1)
			if(user.get_skill_level(/datum/skill/magic/arcane))
				var/mob/living/carbon/human/H = user
				if(!legendaryarcane)
					H.adjust_skillrank(/datum/skill/magic/arcane, -1, TRUE)
				if(H.get_item_by_slot(SLOT_ARMOR) == src)
					to_chat(H, span_notice("Gone is the arcane magicks enhancing thine abilities..."))
					H.change_stat("intelligence", -3)
					active_item = FALSE
					return
			else
				return
		if(mode == 2)
			if(user.get_skill_level(/datum/skill/misc/athletics))
				var/mob/living/carbon/human/H = user
				if(!legendaryathletics)
					H.adjust_skillrank(/datum/skill/misc/athletics, -1, TRUE)
				if(H.get_item_by_slot(SLOT_ARMOR) == src)
					to_chat(H, span_notice("Gone is the strength enhancing thine abilities..."))
					user.change_stat("strength", -2)
					user.change_stat("endurance", -2)
					active_item = FALSE
					return
			else
				return

/obj/item/clothing/suit/roguetown/armor/plate/paalloy/artificer/proc/update_description()
	if(mode == 1)
		desc = "Polished gilbronze layers, magewelded into lightweight plate armor. It hums with arcyne power, enhancing magical prowess."
	else
		desc = "Polished gilbronze layers, magewelded into lightweight plate armor. It radiates raw strength, reinforcing the wearer's physical might."
		
/obj/item/clothing/suit/roguetown/armor/plate/fluted
	name = "fluted half-plate"
	desc = "An ornate steel cuirass, fitted with tassets and pauldrons for additional coverage. This lightweight deviation of 'plate armor' is favored by cuirassiers all across Psydonia, alongside fledging barons who've - up until now - waged their fiercest battles upon a chamberpot." 
	icon_state = "ornatehalfplate"

	equip_delay_self = 6 SECONDS
	unequip_delay_self = 6 SECONDS

	max_integrity = ARMOR_INT_CHEST_PLATE_STEEL
	body_parts_covered = COVERAGE_FULL // Less durability than proper plate, more expensive to manufacture, and accurate to the sprite.
	armor_class = ARMOR_CLASS_HEAVY

/obj/item/clothing/suit/roguetown/armor/plate/fluted/graggar
	name = "vicious half-plate"
	desc = "A fluted half-plate armour-set which stirs with the same violence driving our world. This inner motive makes it far less restrictive."
	armor_class = ARMOR_CLASS_MEDIUM
	max_integrity = ARMOR_INT_CHEST_PLATE_STEEL // We are probably one of the best medium armor sets. At higher integ than most(heavy armor levels, pretty much. But worse resistances, we get the bonus over the other sets of being medium and being unequippable.)
	icon_state = "graggarplate"
	armor = ARMOR_CUIRASS

/obj/item/clothing/suit/roguetown/armor/plate/fluted/graggar/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_HORDE, "ARMOR", "RENDERED ASUNDER")

/obj/item/clothing/suit/roguetown/armor/plate/fluted/ornate
	name = "psydonic half-plate"
	desc = "A beautiful steel cuirass, fitted with tassets and pauldrons for additional coverage. Lesser clerics of Psydon oft-decorate these sets with dyed cloths, so that those who're wounded can still find salvation in the madness of battle. </br>'..the thrumbing of madness, to think that your suffering was all-for-naught to Adonai's sacrifical lamb..' </br>... </br>With some blessed silver and a blacksmith's assistance, I can turn this half-plate into a set of full-plate armor."
	icon_state = "ornatehalfplate"
	smeltresult = /obj/item/ingot/silverblessed
	body_parts_covered = COVERAGE_FULL // Less durability than proper plate, more expensive to manufacture, and accurate to the sprite.

	max_integrity = ARMOR_INT_CHEST_PLATE_PSYDON

/obj/item/clothing/suit/roguetown/armor/plate/fluted/ornate/ComponentInitialize()
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_PSYDONIAN_GRIT)

// Full plate armor

/obj/item/clothing/suit/roguetown/armor/plate/full
	name = "plate armor"
	desc = "Full steel plate armor. Slow to don and doff without the aid of a good squire."
	icon_state = "plate"
	body_parts_covered = COVERAGE_FULL
	equip_delay_self = 12 SECONDS
	unequip_delay_self = 12 SECONDS
	equip_delay_other = 3 SECONDS
	strip_delay = 6 SECONDS
	armor_class = ARMOR_CLASS_HEAVY
	smelt_bar_num = 4

/obj/item/clothing/suit/roguetown/armor/plate/full/iron
	name = "iron plate armor"
	icon_state = "ironplate"
	desc = "Full iron plate armor. Slow to don and doff without the aid of a good squire."
	smeltresult = /obj/item/ingot/iron
	max_integrity = ARMOR_INT_CHEST_PLATE_IRON

/obj/item/clothing/suit/roguetown/armor/plate/full/samsibsa
	name = "samsibsa scaleplate"
	desc = "A heavy set of armour worn by the kouken of distant Kazengun. As opposed to the plate armour utilized by most of Psydonia and the West, samsiba-cheolpan is made of thirty-four rows of composite scales, each an ultra-thin sheet of blacksteel gilded over steel. </br> It is an extremely common practice to engrave characters onto individual plates - such as LUCK, HONOR, or HEAVEN."
	icon_state = "kazengunheavy"
	item_state = "kazengunheavy"
	detail_tag = "_detail"
	boobed_detail = FALSE
	color = null
	detail_color = CLOTHING_WHITE
	body_parts_covered = COVERAGE_ALL_BUT_LEGS
	max_integrity = ARMOR_INT_CHEST_PLATE_STEEL - 50 //slightly worse
	var/picked = FALSE

/obj/item/clothing/suit/roguetown/armor/plate/full/samsibsa/attack_right(mob/user)
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

/obj/item/clothing/suit/roguetown/armor/plate/full/samsibsa/Initialize()
	. = ..()		
	update_icon()

/obj/item/clothing/suit/roguetown/armor/plate/full/samsibsa/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/armor/plate/full/fluted
	name = "fluted plate"
	desc = "A suit of ornate plate armor, noble in both presentation and protection. Such resplendent maille is traditionally reserved for the higher echelons of nobility; seasoned knights, venerated kings, and pot-bellied councilmen that wish to flaunt their opulence towards the unwashed masses."
	icon_state = "ornateplate"

	max_integrity = ARMOR_INT_CHEST_PLATE_STEEL

/obj/item/clothing/suit/roguetown/armor/plate/full/fluted/ornate
	name = "psydonic plate"
	desc = "A suit of beautiful plate armor, meticulously fluted with blessed silver. This design's origins lay in the hands of a legendary armorsmith, who sought to mimic the heavenly maille that Psydon's angels once wore. </br>'..the refusal of despair, and the resolve to defend Psydonia in its darkest hour..'"
	icon_state = "ornateplate"
	smeltresult = /obj/item/ingot/silverblessed

	max_integrity = ARMOR_INT_CHEST_PLATE_PSYDON

	/// Whether the user has the Heavy Armour Trait prior to donning.
	var/traited = FALSE
	smelt_bar_num = 3

/obj/item/clothing/suit/roguetown/armor/plate/full/fluted/ornate/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_PSYDONIAN_GRIT)

/obj/item/clothing/suit/roguetown/armor/plate/fluted/shadowplate
	name = "scourge breastplate"
	desc = "More form over function, this armor is fit for demonstration of might rather than open combat. The aged gilding slowly tarnishes away."
	icon_state = "shadowplate"
	item_state = "shadowplate"
	armor_class = ARMOR_CLASS_MEDIUM
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/suit/roguetown/armor/plate/full/fluted/ornate/ordinator
	name = "inquisitorial ordinator's plate"
	desc = "A relic that is said to have survived the Grenzelhoft-Otavan war, refurbished and repurposed to slay the arch-enemy in the name of Psydon. <br> A fluted cuirass that has been reinforced with thick padding and an additional shoulder piece. You will endure."
	icon_state = "ordinatorplate"	

/obj/item/clothing/suit/roguetown/armor/plate/full/matthios
	name = "gilded fullplate"
	desc = "Often, you have heard that told,"
	icon_state = "matthiosarmor"
	max_integrity = ARMOR_INT_CHEST_PLATE_ANTAG
	peel_threshold = 5	//-Any- weapon will require 5 peel hits to peel coverage off of this armor.

/obj/item/clothing/suit/roguetown/armor/plate/full/matthios/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/suit/roguetown/armor/plate/full/matthios/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/clothing/suit/roguetown/armor/plate/full/zizo
	name = "avantyne fullplate"
	desc = "Full plate. Called forth from the edge of what should be known. In Her name."
	icon_state = "zizoplate"
	max_integrity = ARMOR_INT_CHEST_PLATE_ANTAG
	peel_threshold = 5	//-Any- weapon will require 5 peel hits to peel coverage off of this armor.
	chunkcolor = "#363030"

/obj/item/clothing/suit/roguetown/armor/plate/full/zizo/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/suit/roguetown/armor/plate/full/zizo/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)


/obj/item/clothing/suit/roguetown/armor/plate/full/bikini
	name = "full-plate corset"
	desc = "Breastplate, pauldrons, couters, cuisses... did you forget something?"
	icon_state = "platekini"
	allowed_sex = list(MALE, FEMALE)
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	equip_delay_self = 8 SECONDS
	unequip_delay_self = 8 SECONDS
	equip_delay_other = 3 SECONDS
	strip_delay = 6 SECONDS
	smelt_bar_num = 3

/obj/item/clothing/suit/roguetown/armor/heartfelt/lord
	slot_flags = ITEM_SLOT_ARMOR
	name = "coat of armor"
	desc = "A lordly coat of armor."
	body_parts_covered = CHEST|GROIN|VITALS|LEGS|ARMS
	icon_state = "heartfelt"
	item_state = "heartfelt"
	armor = ARMOR_PLATE
	allowed_sex = list(MALE, FEMALE)
	nodismemsleeves = TRUE
	blocking_behavior = null
	max_integrity = ARMOR_INT_CHEST_PLATE_STEEL
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	armor_class = ARMOR_CLASS_HEAVY
	smelt_bar_num = 4

/obj/item/clothing/suit/roguetown/armor/heartfelt/hand
	slot_flags = ITEM_SLOT_ARMOR
	name = "coat of armor"
	desc = "A lordly coat of armor."
	body_parts_covered = COVERAGE_FULL
	icon_state = "heartfelt_hand"
	item_state = "heartfelt_hand"
	armor = ARMOR_PLATE
	allowed_sex = list(MALE, FEMALE)
	nodismemsleeves = TRUE
	blocking_behavior = null
	max_integrity = ARMOR_INT_CHEST_PLATE_STEEL
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	armor_class = ARMOR_CLASS_HEAVY
	smelt_bar_num = 4

/obj/item/clothing/suit/roguetown/armor/plate/otavan
	name = "otavan half-plate"
	desc = "Half-plate armor with pauldrons. Recommended to layer with the otavan gambeson."
	armor = ARMOR_PLATE
	body_parts_covered = COVERAGE_TORSO
	icon_state = "corsethalfplate"
	item_state = "corsethalfplate"
	adjustable = CAN_CADJUST
	allowed_race = NON_DWARVEN_RACE_TYPES
	detail_tag = "_detail"
	color = "#FFFFFF"
	detail_color = "#5058c1"
	armor_class = ARMOR_CLASS_HEAVY
	var/swapped_color // holder for corset colour when the corset is toggled off.

/obj/item/clothing/suit/roguetown/armor/plate/otavan/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/armor/plate/otavan/AdjustClothes(mob/user)
	if(loc == user)
		playsound(user, "sound/foley/dropsound/cloth_drop.ogg", 100, TRUE, -1)
		if(adjustable == CAN_CADJUST)
			adjustable = CADJUSTED
			icon_state = "fancyhalfplate"
			body_parts_covered = CHEST|GROIN|VITALS
			flags_cover = null
			emote_environment = 0
			swapped_color = detail_color
			detail_color = "#ffffff"
			update_icon()
			if(ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_armor()
			block2add = null
		else if(adjustable == CADJUSTED)
			ResetAdjust(user)
			detail_color = swapped_color
			emote_environment = 3
			update_icon()
			if(user)
				if(ishuman(user))
					var/mob/living/carbon/H = user
					H.update_inv_armor()


// MEDIUM
/obj/item/clothing/suit/roguetown/armor/plate/bikini
	name = "half-plate corslet"
	desc = "A high breastplate and hip armor allowing flexibility and great protection, save for the stomach."
	body_parts_covered = CHEST|GROIN
	icon_state = "halfplatekini"
	item_state = "halfplatekini"
	armor = ARMOR_CUIRASS // Identical to steel cuirass, but covering the groin instead of the vitals.
	max_integrity = ARMOR_INT_CHEST_MEDIUM_STEEL	// Identical to steel cuirasss. Same steel price.
	allowed_sex = list(MALE, FEMALE)
	armor_class = ARMOR_CLASS_MEDIUM
	smelt_bar_num = 2

/obj/item/clothing/suit/roguetown/armor/plate/cuirass
	slot_flags = ITEM_SLOT_ARMOR
	name = "steel cuirass"
	desc = "A basic cuirass of steel. Lightweight and durable. A crossbow bolt will probably go right through this, but not an arrow."
	body_parts_covered = COVERAGE_VEST
	icon_state = "cuirass"
	item_state = "cuirass"
	armor = ARMOR_CUIRASS
	allowed_race = CLOTHED_RACES_TYPES
	nodismemsleeves = TRUE
	blocking_behavior = null
	max_integrity = ARMOR_INT_CHEST_MEDIUM_STEEL
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	armor_class = ARMOR_CLASS_MEDIUM
	smelt_bar_num = 2

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer
	name = "fencer's cuirass"
	desc = "An expertly smithed form-fitting steel cuirass that is much lighter and agile, but breaks with much more ease. It's thinner, but backed with silk and leather."
	armor = ARMOR_CUIRASS		// Experimental.
	armor_class = ARMOR_CLASS_LIGHT
	max_integrity = ARMOR_INT_CHEST_LIGHT_STEEL
	smelt_bar_num = 1
	icon_state = "fencercuirass"
	item_state = "fencercuirass"

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer/ComponentInitialize()
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_FENCERDEXTERITY)

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer/psydon
	name = "psydonic chestplate"
	desc = "An expertly smithed form-fitting steel cuirass that is much lighter and agile, but breaks with much more ease. It's thinner, but backed with silk and leather."
	smelt_bar_num = 1
	smeltresult = /obj/item/ingot/silverblessed
	icon_state = "ornatechestplate"
	item_state = "ornatechestplate"

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/aalloy
	name = "decrepit cuirass"
	desc = "Frayed bronze, pounded into a breastplate. It feels more like a corset than a cuirass; there's barely enough width to let those aching lungs breathe."
	icon_state = "ancientcuirass"
	max_integrity = ARMOR_INT_CHEST_MEDIUM_DECREPIT
	color = "#bb9696"
	chunkcolor = "#532e25"
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null
	prevent_crits = PREVENT_CRITS_NONE

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/paalloy
	name = "ancient cuirass"
	desc = "Polished gilbranze, curved into a breastplate. It is not for the heart that beats no more, but for the spirit that flows through luxless marrow; one of Her many gifts."
	icon_state = "ancientcuirass"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted
	name = "fluted cuirass"
	icon_state = "ornatecuirass"
	desc = "An ornate steel cuirass, fitted with tassets for additional coverage. The intricate fluting not only attracts the maidens, but also strengthens the steel's resistance against repeated impacts."

	body_parts_covered = CHEST | VITALS | LEGS 
	max_integrity = ARMOR_INT_CHEST_MEDIUM_STEEL

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/ornate
	name = "psydonic cuirass"
	icon_state = "ornatecuirass"
	desc = "A beautiful steel cuirass, fitted with tassets for additional coverage. Strips of blessed silver have been meticulously incorporated into the fluting; a laborous decoration that denotes it as originating from the Order of the Silver Psycross. </br>'..the feeling of Aeon's grasp upon your shoulders, imparting the world's burden unto flesh and bone..' </br>... </br>With some blessed silver and a blacksmith's assistance, I can turn this cuirass into a set of half-plate armor."
	smeltresult = /obj/item/ingot/silverblessed
	smelt_bar_num = 1

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron
	name = "iron breastplate"
	desc = "A basic cuirass of iron, protective and moderately durable."
	icon_state = "ibreastplate"
	boobed = FALSE	//the armor just looks better with this, makes sense and is 8 sprites less
	max_integrity = ARMOR_INT_CHEST_MEDIUM_IRON
	smeltresult = /obj/item/ingot/iron
	smelt_bar_num = 2

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/copper
	name = "heart protector"
	desc = "Very simple and crude protection for the chest. Ancient fighters once used similar gear, with better quality..."
	icon_state = "copperchest"
	max_integrity = ARMOR_INT_CHEST_MEDIUM_DECREPIT
	armor = list("blunt" = 75, "slash" = 75, "stab" = 75, "piercing" = 40, "fire" = 0, "acid" = 0)	//idk what this armor is but I ain't making a define for it
	smeltresult = /obj/item/ingot/copper
	body_parts_covered = CHEST
	armor_class = ARMOR_CLASS_LIGHT
	smelt_bar_num = 1

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/elven
	name = "elven guardian cuirass"
	desc = "A cuirass made of steel with a thin decorative gold plating. Lightweight and durable."
	color = COLOR_ASSEMBLY_GOLD

/obj/item/clothing/suit/roguetown/armor/plate/scale
	slot_flags = ITEM_SLOT_ARMOR
	name = "scalemail"
	desc = "Metal scales interwoven intricately to form flexible protection!"
	body_parts_covered = COVERAGE_ALL_BUT_ARMS
	allowed_sex = list(MALE, FEMALE)
	icon_state = "lamellar"
	max_integrity = ARMOR_INT_CHEST_MEDIUM_STEEL
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	equip_delay_self = 4 SECONDS
	armor_class = ARMOR_CLASS_MEDIUM
	smelt_bar_num = 2

/obj/item/clothing/suit/roguetown/armor/plate/scale/steppe
	name = "steel heavy lamellar"
	desc = "A chestpiece of Aavnic make composed of easily-replaced small rectangular plates of layered steel laced together in rows with wire. Malleable and protective, perfect for cavalrymen."
	icon_state = "hudesutu"
	max_integrity = ARMOR_INT_CHEST_MEDIUM_STEEL + 50

/obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat
	slot_flags = ITEM_SLOT_ARMOR
	slot_flags = ITEM_SLOT_ARMOR
	name = "inquisitorial duster"
	desc = "A heavy longcoat with layers of maille hidden beneath the leather, donned by the Holy Otavan Inquisition's finest. </br>A Psydonic Cuirass can be fitted with this longcoat, in order to ward off deadlier blows without compromising one's fashion sense."
	body_parts_covered = COVERAGE_FULL
	allowed_sex = list(MALE, FEMALE)
	allowed_sex = list(MALE, FEMALE)
	icon_state = "inqcoat"
	item_state = "inqcoat"
	sleevetype = "shirt"
	max_integrity = 300
	anvilrepair = /datum/skill/craft/armorsmithing
	equip_delay_self = 4 SECONDS
	armor_class = ARMOR_CLASS_LIGHT
	armor = ARMOR_LEATHER_STUDDED
	smeltresult = /obj/item/ingot/iron
	smelt_bar_num = 2
	blocksound = SOFTHIT

/obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat/ComponentInitialize()	//No movement rustle component.
	return

/obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/ornate))
		user.visible_message(span_warning("[user] starts to fit [W] inside the [src]."))
		if(do_after(user, 12 SECONDS))
			var/obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat/armored/P = new /obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat/armored(get_turf(src.loc))
			if(user.is_holding(src))
				user.dropItemToGround(src)
			user.put_in_hands(P)
			P.obj_integrity = src.obj_integrity
			qdel(src)
			qdel(W)
		else
			user.visible_message(span_warning("[user] stops fitting [W] inside the [src]."))
		return


/obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat/armored
	slot_flags = ITEM_SLOT_ARMOR
	name = "armored inquisitorial duster"
	desc = "A heavy longcoat with layers of maille hidden beneath the leather, donned by the Holy Otavan Inquisition's finest. Where the longcoat parts, a surprise awaits; an ornate steel cuirass, worn beneath the leathers to ward off crippling blows."
	smeltresult = /obj/item/ingot/steel 
	icon_state = "inqcoata"
	item_state = "inqcoata"
	equip_delay_self = 4 SECONDS
	max_integrity = 300
	armor_class = ARMOR_CLASS_MEDIUM
	armor = ARMOR_CUIRASS
	smelt_bar_num = 2
	smeltresult = /obj/item/ingot/steel
	blocksound = PLATEHIT	

/obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat/armored/ComponentInitialize()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_PLATE_STEP, 5)
	return

/obj/item/clothing/suit/roguetown/armor/plate/silver
	slot_flags = ITEM_SLOT_ARMOR
	name = "templar's half-plate"
	desc = "Noc's holy silver, one fifth. Steel, three fifths. Chosen Material, one fifth. The armor of the Templar, protector and warrior of the Ten's Faithful."
	body_parts_covered = COVERAGE_TORSO
	icon_state = "silverhalfplate"
	item_state = "silverhalfplate"
	armor = ARMOR_PLATE
	max_integrity = ARMOR_INT_CHEST_PLATE_STEEL
	allowed_sex = list(MALE, FEMALE)
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	armor_class = ARMOR_CLASS_MEDIUM
	smelt_bar_num = 3
