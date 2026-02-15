// BASE
/obj/item/clothing/suit/roguetown/armor/plate
	slot_flags = ITEM_SLOT_ARMOR
	name = "steel half-plate"
	desc = "A padded steel cuirass, adorned with segmented pauldrons. Its prevalence amongst the pious is indisputable - deceptively light, sturdy, and accomadating to a Cleric's miracle-casting gestures."
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
	material_category = ARMOR_MAT_PLATE

/obj/item/clothing/suit/roguetown/armor/plate/ComponentInitialize()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_PLATE_STEP, 12)
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_FENCERDEXTERITY)
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_HONORBOUND)

//

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/legacy
    name = "valorian cuirass"
    desc = "A steel cuirass. Do you still remember the first time you tasted blood; that sanguine succor, dribbling from a busted lip?"
    icon_state = "legacycuirass"
    item_state = "legacycuirass"

/obj/item/clothing/suit/roguetown/armor/plate/legacy
    name = "valorian half-plate"
    desc = "A padded steel cuirass, 'adventurer-fitted' with a pair of pauldrons. Before you is your weapon; when was the last time you had ever thought without its presence?"
    icon_state = "legacyhalfplate"
    item_state = "legacyhalfplate"

/obj/item/clothing/suit/roguetown/armor/plate/full/legacy
    name = "valorian plate armor"
    desc = "A complete set of steel plate armor, fitted with tassets and bracers for additional coverage. When the kingdom comes crashing down, will you deliver its people from evil; or will you be the one to string up 'pon the pyre?"
    icon_state = "legacyplate"
    item_state = "legacyplate"

/obj/item/clothing/suit/roguetown/armor/plate/full/fluted/legacy
    name = "valorian fluted plate armor"
    desc = "A resplendant set of steel plate armor, decorated with silver flutings. Blessed dreamer, accursed heathen, lowly fool; the curtain call is a mere heartbeat away. Are you ready for one last dance, before midnight calls?"
    icon_state = "legacyornateplate"
    item_state = "legacyornateplate"
//

/obj/item/clothing/suit/roguetown/armor/plate/iron
	name = "iron half-plate"
	desc = "A padded iron cuirass, bottomed with segmented tassets. It is inexpensive yet robust; a desirable combination, which has long-since led to its proliferation amongst most of Psydonia's standing garrisons."
	body_parts_covered = CHEST | VITALS | LEGS //Reflects the sprite, which lacks pauldrons.
	icon_state = "ihalfplate"
	item_state = "ihalfplate"
	boobed = FALSE	//the armor just looks better with this, makes sense and is 8 sprites less
	max_integrity = ARMOR_INT_CHEST_PLATE_IRON
	armor_class = ARMOR_CLASS_MEDIUM
	smeltresult = /obj/item/ingot/iron

/obj/item/clothing/suit/roguetown/armor/plate/bronze
	name = "bronze cuirass"
	desc = "A chiseled breastplate of bronze, further padded with hide to comfort its championing bod. The plates have been carefully forged to mimic the statuesque physiques of Psydonia's ancient heroes. Wearing it bolsters you with determination."
	body_parts_covered = CHEST | VITALS | LEGS 
	icon_state = "bronzecuirass"
	armor = ARMOR_PLATE_BRONZE
	smeltresult = /obj/item/ingot/bronze
	max_integrity = ARMOR_INT_CHEST_MEDIUM_BRONZE
	armor_class = ARMOR_CLASS_MEDIUM
	prevent_crits = PREVENT_CRITS_ALL
	boobed = FALSE
	smelt_bar_num = 2

/obj/item/clothing/suit/roguetown/armor/plate/aalloy
	name = "decrepit half-plate"
	desc = "Frayed bronze layers, wrought into plate armor. Once, the hauberk of a rising champion; now, nothing more than a fool's tomb."
	icon_state = "ancientplate"
	item_state = "ancientplate"
	max_integrity = ARMOR_INT_CHEST_PLATE_DECREPIT
	color = "#bb9696"
	chunkcolor = "#532e25"
	material_category = ARMOR_MAT_PLATE
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null
	prevent_crits = PREVENT_CRITS_NONE

/obj/item/clothing/suit/roguetown/armor/plate/paalloy
	name = "ancient half-plate"
	desc = "Polished gilbronze layers, artificed into plate armor. Let none impede the march of progress, and let Her champions bring the unenlightened masses to kneel."
	icon_state = "ancientplate"
	item_state = "ancientplate"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/clothing/suit/roguetown/armor/plate/paalloy/artificer
	name = "artificed half-plate"
	desc = "Forbidden knowledge, resurrected into a weightless vessel of gilbranze-and-magicka. It holds a slot for an arcyne meld to power it."
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
		to_chat(user, span_notice("I need to put this on a table first!")) //prevents stats staying on a person if tinkered on self
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
				to_chat(user, span_notice("Arcyne lightning crackles across the cuirass, enchanting your mind with forbidden knowledge!"))
				icon_state ="artificerplate_powered"
				item_state = "artificerplate_powered"
			else
				user.change_stat("intelligence", 3)
				legendaryarcane = TRUE
				active_item = TRUE
				to_chat(user, span_warning("Arcyne lightning crackles across the cuirass, enshrining your mastery over magicka!"))
				icon_state ="artificerplate_powered"
				item_state = "artificerplate_powered"
		else
			to_chat(user, span_warning("The cuirass feels unnervingly cold to the touch."))
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
			to_chat(user, span_notice("Arcyne lightning crackles across the cuirass, enchanting your body with adrenalized power!"))
			user.change_stat("strength", 2)
			user.change_stat("endurance", 2)
			icon_state ="artificerplate_powered"
			item_state = "artificerplate_powered"
			return
		else
			to_chat(user, span_warning("The cuirass feels unnervingly warm to the touch."))

/obj/item/clothing/suit/roguetown/armor/plate/paalloy/artificer/dropped(mob/living/user)
	.=..()
	if(active_item)
		if(mode == 1)
			if(user.get_skill_level(/datum/skill/magic/arcane))
				var/mob/living/carbon/human/H = user
				if(!legendaryarcane)
					H.adjust_skillrank(/datum/skill/magic/arcane, -1, TRUE)
				if(H.get_item_by_slot(SLOT_ARMOR) == src)
					to_chat(H, span_notice("Gone is the intelligence, which bolstered thine arcyna.."))
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
					to_chat(H, span_notice("Gone is the strength, which bolstered thine arms.."))
					user.change_stat("strength", -2)
					user.change_stat("endurance", -2)
					active_item = FALSE
					return
			else
				return

/obj/item/clothing/suit/roguetown/armor/plate/paalloy/artificer/proc/update_description()
	if(mode == 1)
		desc = "Forbidden knowledge, resurrected into a weightless vessel of gilbranze-and-magicka. It crackles with raw magicka; the mind, empowered."
	else
		desc = "Forbidden knowledge, resurrected into a weightless vessel of gilbranze-and-magicka. It crackles with arcyne vigor; the body, emboldened."
		
/obj/item/clothing/suit/roguetown/armor/plate/fluted
	name = "fluted half-plate"
	desc = "An ornate steel cuirass, fitted with tassets and pauldrons for additional coverage. This lightweight deviation of 'plate armor' is favored by cuirassiers all across Psydonia, alongside fledging barons who've - up until now - waged their fiercest battles upon a chamberpot." 
	icon_state = "ornatehalfplate"

	equip_delay_self = 6 SECONDS
	unequip_delay_self = 6 SECONDS

	max_integrity = ARMOR_INT_CHEST_PLATE_STEEL
	body_parts_covered = COVERAGE_ALL_BUT_HANDFEET // Less durability than proper plate, more expensive to manufacture, and accurate to the sprite.
	armor_class = ARMOR_CLASS_HEAVY

/obj/item/clothing/suit/roguetown/armor/plate/fluted/graggar
	name = "vicious half-plate"
	desc = "A fluted vessel of Graggar's hatred, stirring with the same violence that drives our world. Such an inner motive leaves the steel unchained from flesh - enslaved, no more!"
	armor_class = ARMOR_CLASS_MEDIUM
	max_integrity = ARMOR_INT_CHEST_PLATE_STEEL // We are probably one of the best medium armor sets. At higher integ than most(heavy armor levels, pretty much. But worse resistances, we get the bonus over the other sets of being medium and being unequippable.)
	icon_state = "graggarplate"
	armor = ARMOR_CUIRASS

/obj/item/clothing/suit/roguetown/armor/plate/fluted/graggar/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_HORDE, "ARMOR", "RENDERED ASUNDER")

/obj/item/clothing/suit/roguetown/armor/plate/fluted/ornate
	name = "psydonic half-plate"
	desc = "A beautiful steel cuirass, fitted with tassets and pauldrons for additional coverage. Lesser clerics of Psydon oft-decorate these sets with dyed cloths, so that those who're wounded can still find salvation in the madness of battle. </br>‎  </br>'..the thrumbing of madness, to think that your suffering was all-for-naught to Adonai's sacrifical lamb..'"
	icon_state = "ornatehalfplate"
	smeltresult = /obj/item/ingot/silverblessed
	body_parts_covered = COVERAGE_ALL_BUT_HANDFEET // Less durability than proper plate, more expensive to manufacture, and accurate to the sprite.

	max_integrity = ARMOR_INT_CHEST_PLATE_PSYDON

/obj/item/clothing/suit/roguetown/armor/plate/fluted/ornate/ComponentInitialize()
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_PSYDONIAN_GRIT, "ornate_plate")

// HEAVY
/obj/item/clothing/suit/roguetown/armor/plate/full
	name = "plate armor"
	desc = "A pristine set of steel plate armor, fitted with tassets and bracers for additional coverage. To the Knights of Psydonia, these sets are a symbolic manifestation of their oath; to serve thine kingdom without hesitation, and to rebuke all the villains who'd dare to defile it. </br>‎  </br>'Slow to don-and-doff, without a trusted Squire's aid..'"
	icon_state = "plate"
	body_parts_covered = COVERAGE_ALL_BUT_HANDFEET
	equip_delay_self = 12 SECONDS
	unequip_delay_self = 12 SECONDS
	equip_delay_other = 3 SECONDS
	strip_delay = 6 SECONDS
	armor_class = ARMOR_CLASS_HEAVY
	smelt_bar_num = 4

/obj/item/clothing/suit/roguetown/armor/plate/full/iron
	name = "iron plate armor"
	icon_state = "ironplate"
	desc = "A 'munition'-grade set of iron plate armor, fitted with pauldrons and tassets for additional coverage. Most of these sets, produced within the last century, can trace their origins to an edict from Hammerhold's former King: one which demanded a munitions run, but forgot to specify its tailoring towards the dwarven physique. </br>‎  </br>'Slow to don-and-doff, without a trusted Levyman's aid..'"
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
	desc = "A suit of beautiful plate armor, meticulously fluted with blessed silver. This design's origins lay in the hands of a legendary armorsmith, who sought to mimic the heavenly maille that Psydon's angels once wore. </br>‎  </br>'..the refusal of despair, and the resolve to defend Psydonia in its darkest hour..'"
	icon_state = "ornateplate"
	smeltresult = /obj/item/ingot/silverblessed

	max_integrity = ARMOR_INT_CHEST_PLATE_PSYDON

	/// Whether the user has the Heavy Armour Trait prior to donning.
	var/traited = FALSE
	smelt_bar_num = 3

/obj/item/clothing/suit/roguetown/armor/plate/full/fluted/ornate/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_PSYDONIAN_GRIT, "ornate_plate")

/obj/item/clothing/suit/roguetown/armor/plate/fluted/shadowplate
	name = "scourge breastplate"
	desc = "More form over function, this armor is fit for demonstration of might rather than open combat. The aged gilding slowly tarnishes away."
	icon_state = "shadowplate"
	item_state = "shadowplate"
	armor_class = ARMOR_CLASS_MEDIUM
	allowed_race = NON_DWARVEN_RACE_TYPES
	smeltresult = /obj/item/ingot/drow
	smelt_bar_num = 2

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
	desc = "Impossible angularities, molded into a form more comprehensible to the layman's eyes. It has been called forth from the edge of what should be known, in Her name."
	icon_state = "zizoplate"
	max_integrity = ARMOR_INT_CHEST_PLATE_ANTAG
	peel_threshold = 5	//-Any- weapon will require 5 peel hits to peel coverage off of this armor.
	chunkcolor = "#363030"
	material_category = ARMOR_MAT_PLATE

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
	desc = "Breastplate, pauldrons, couters, cuisses.. did you forget something?"
	icon_state = "platekini"
	allowed_sex = list(MALE, FEMALE)
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	equip_delay_self = 8 SECONDS
	unequip_delay_self = 8 SECONDS
	equip_delay_other = 3 SECONDS
	strip_delay = 6 SECONDS
	smelt_bar_num = 3

/obj/item/clothing/suit/roguetown/armor/heartfelt
	slot_flags = ITEM_SLOT_ARMOR
	name = "coat of armor"
	desc = "A lordly coat of armor."
	body_parts_covered = COVERAGE_ALL_BUT_HANDFEET
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
	body_parts_covered = COVERAGE_ALL_BUT_HANDFEET
	icon_state = "heartfelt_hand"
	item_state = "heartfelt_hand"


/obj/item/clothing/suit/roguetown/armor/plate/otavan
	name = "otavan half-plate"
	desc = "A gilded steel cuirass, flanked with curved pauldrons and veiled in expensive silks. Like most articles of Otavan armorsmithery, it is both remarkably opulent and protective."
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
	desc = "A steel cuirass. It bares all the hallmarks of sixteenth-century nobility: angularity, polishedness, and - above all else - class."
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
	smelt_bar_num = 1

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
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_PLATE_STEP, 12)
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_FENCERDEXTERITY)
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_HONORBOUND)

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer/psydon
	name = "psydonic chestplate"
	desc = "An expertly smithed form-fitting steel cuirass that is much lighter and agile, but breaks with much more ease. It's thinner, but backed with silk and leather."
	smelt_bar_num = 1
	max_integrity = ARMOR_INT_CHEST_LIGHT_BASE
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
	material_category = ARMOR_MAT_PLATE
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

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/gold
	name = "golden cuirass"
	icon_state = "goldcuirass"
	desc = "A resplendant cuirass of pure gold, fitted with tassets for additional coverage. It is dressed atop a besilked arming jacket to ensure the absolute comfort of its wearer, and the holy sigil has been meticulously formed from its slanted plates."
	armor = ARMOR_GOLD //Renders its wearer completely invulnerable to damage. The caveat is, however..
	max_integrity = ARMOR_INT_SIDE_GOLD // ..is that it's extraordinarily fragile, especially against blunt damage.
	armor_class = ARMOR_CLASS_HEAVY
	anvilrepair = null
	smeltresult = /obj/item/ingot/gold
	smelt_bar_num = 1
	grid_height = 96
	grid_width = 96
	sellprice = 300
	unenchantable = TRUE

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/gold/heroic
	name = "golden heroic cuirass"
	icon_state = "heroiccuirass"
	desc = "A resplendant cuirass of pure gold, fitted with tassets for additional coverage. It has been meticulously waxed-and-assembled from dozens of smaller golden plates, in order to replicate the statuesque physique of Psydonia's legendary heroes."
	unenchantable = TRUE

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/gold/king
	name = "golden heroic cuirass"
	max_integrity = ARMOR_INT_SIDE_GOLDPLUS // Doubled integrity.
	sellprice = 400
	unenchantable = TRUE

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/ornate
	name = "psydonic cuirass"
	icon_state = "ornatecuirass"
	desc = "A beautiful steel cuirass, fitted with tassets for additional coverage. Strips of blessed silver have been meticulously incorporated into the fluting; a laborous decoration that denotes it as originating from the Order of the Silver Psycross. </br>‎  </br>'..the feeling of Aeon's grasp upon your shoulders, imparting the world's burden unto flesh and bone..'"
	smeltresult = /obj/item/ingot/silverblessed
	smelt_bar_num = 1

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron
	name = "iron breastplate"
	desc = "An iron cuirass. While most would sneer at the idea of wearing 'lesser alloys', many-a-levyman can attest to its robustness."
	icon_state = "ibreastplate"
	boobed = FALSE	//the armor just looks better with this, makes sense and is 8 sprites less
	max_integrity = ARMOR_INT_CHEST_MEDIUM_IRON
	smeltresult = /obj/item/ingot/iron
	smelt_bar_num = 2

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/copper
	name = "heart protector"
	desc = "Shingled copper disks, strapped together to ward the heart from harm. As discovered by its antiquital wearers, it is deceptively protective; yet, its straps can only sustain so much stress before snapping.."
	icon_state = "copperchest"
	max_integrity = ARMOR_INT_CHEST_MEDIUM_DECREPIT
	armor = list("blunt" = 75, "slash" = 75, "stab" = 75, "piercing" = 40, "fire" = 0, "acid" = 0)	//idk what this armor is but I ain't making a define for it
	smeltresult = /obj/item/ingot/copper
	body_parts_covered = CHEST
	armor_class = ARMOR_CLASS_LIGHT
	smelt_bar_num = 1

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer/elven
	name = "elven cuirass"
	desc = "A cuirass made of steel with a thin decorative gold plating. Lightweight and durable."
	color = COLOR_ASSEMBLY_GOLD

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

//Coats of Plates
/obj/item/clothing/suit/roguetown/armor/plate/scale
	slot_flags = ITEM_SLOT_ARMOR
	name = "scalemail"
	desc = "Metal scales interwoven intricately to form flexible protection!"
	body_parts_covered = COVERAGE_ALL_BUT_ARMFEET
	allowed_sex = list(MALE, FEMALE)
	icon_state = "lamellar"
	max_integrity = ARMOR_INT_CHEST_MEDIUM_STEEL
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	equip_delay_self = 4 SECONDS
	armor_class = ARMOR_CLASS_MEDIUM
	smelt_bar_num = 2

/obj/item/clothing/suit/roguetown/armor/plate/scale/knight
	name = "coat of plates"
	desc = "A heavyweight coat-of-plates, adorned with a pair of steel vambraces and faulds."
	icon_state = "coat_of_plates"
	blocksound = PLATEHIT
	smelt_bar_num = 2
	armor_class = ARMOR_CLASS_HEAVY
	max_integrity = ARMOR_INT_CHEST_PLATE_BRIGANDINE + 50

/obj/item/clothing/suit/roguetown/armor/plate/scale/marshal
	name = "coat of the commander"
	desc = "A coat of plates concealed beneath a heavy leather surcoat. Only the most battle-hardened of Azuria's commanders can hope to bear its burden, both metaphorically and quite literally."
	icon_state = "leathercoat"
	item_state = "leathercoat"

/obj/item/clothing/suit/roguetown/armor/plate/scale/marshal/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/armor/plate/scale/marshal/Initialize()
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/suit/roguetown/armor/plate/scale/marshal/lordcolor(primary,secondary)
	detail_tag = "_det"
	detail_color = primary
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_armor()

/obj/item/clothing/suit/roguetown/armor/plate/scale/marshal/Destroy()
	GLOB.lordcolor -= src
	return ..()

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
	body_parts_covered = COVERAGE_ALL_BUT_HANDFEET
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
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_PLATE_STEP, 12)
	return
