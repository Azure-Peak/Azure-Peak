/obj/item/clothing/gloves/roguetown/plate
	name = "plate gauntlets"
	desc = "A pair of alloyed gauntlets. Each finger is afforded a trinity of segments; with it, one can use a quill as precisely as an arming sword."
	icon_state = "gauntlets"
	armor = ARMOR_PLATE
	resistance_flags = FIRE_PROOF
	blocksound = PLATEHIT
	max_integrity = ARMOR_INT_SIDE_STEEL
	blade_dulling = DULLING_BASH
	break_sound = 'sound/foley/breaksound.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel

	grid_width = 64
	grid_height = 32
	unarmed_bonus = 1.2

/obj/item/clothing/gloves/roguetown/plate/ComponentInitialize()
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_FENCERDEXTERITY)

/obj/item/clothing/gloves/roguetown/plate/iron
	name = "iron plate gauntlets"
	desc = "A pair of armored gauntlets. The joints, though simplistic, nevertheless allow for the strumming of both a bowstring and lute."
	icon_state = "igauntlets"
	smeltresult = /obj/item/ingot/iron
	max_integrity = ARMOR_INT_SIDE_IRON

/obj/item/clothing/gloves/roguetown/plate/aalloy
	name = "decrepit plate gauntlets"
	desc = "Frayed bronze mechanisms, connected to form the shells of hands. Too clumsy to properly knock a bow, too rigid to comfortably grip a sword; clench those fists any tighter, and the segments'll cut into flesh."
	icon_state = "agauntlets"
	max_integrity = ARMOR_INT_SIDE_DECREPIT
	color = "#bb9696"
	chunkcolor = "#532e25"
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null
	prevent_crits = PREVENT_CRITS_NONE

/obj/item/clothing/gloves/roguetown/plate/paalloy
	name = "ancient plate gauntlets"
	desc = "Polished gilbranze mechanisms, meticulously interconnected to shroud splayed hands. 'Mercy' and 'innocence' are concepts paraded by the unenlightened; spill their blood without guilt, so that the world may yet be remade in Her image." 
	icon_state = "agauntlets"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/clothing/gloves/roguetown/plate/graggar
	name = "vicious gauntlets"
	desc = "Fluted gauntlets, razor-tipped and fluidic in motion. Most are led to believe that 'might makes right', yet Graggar's truth is far more succinct - 'might makes'. Murder is the ultimate force; the only difference between you and them is that they're too afraid to admit it."
	max_integrity = ARMOR_INT_SIDE_ANTAG
	icon_state = "graggarplategloves"

/obj/item/clothing/gloves/roguetown/plate/graggar/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_HORDE, "ARMOR", "RENDERED ASUNDER")

/obj/item/clothing/gloves/roguetown/plate/matthios
	name = "gilded gauntlets"
	desc = "Many a man his life hath sold,"
	icon_state = "matthiosgloves"
	max_integrity = ARMOR_INT_SIDE_ANTAG

/obj/item/clothing/gloves/roguetown/plate/matthios/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/gloves/roguetown/plate/matthios/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)


/obj/item/clothing/gloves/roguetown/plate/zizo
	name = "avantyne gauntlets"
	desc = "Unknowing truths, veiling the hands that prayed. Called forth from the edge of what should be known, in Her name."
	icon_state = "zizogauntlets"
	max_integrity = ARMOR_INT_SIDE_ANTAG
	chunkcolor = "#363030"

/obj/item/clothing/gloves/roguetown/plate/zizo/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/gloves/roguetown/plate/zizo/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/clothing/gloves/roguetown/plate/shadowgauntlets
	name = "darkplate gauntlets"
	desc = "Gauntlets with gilded fingers fashioned into talons. The tips are all too dull to be of harm."
	icon_state = "shadowgauntlets"
	allowed_race = NON_DWARVEN_RACE_TYPES
	body_parts_covered = HANDS|ARMS //For "heavy" drow merc
	smeltresult = /obj/item/ingot/drow
	smelt_bar_num = 1

/obj/item/clothing/gloves/roguetown/plate/kote
	name = "jjajeungna gauntlets"
	desc = "A set of reinforced Kazengunite gauntlets. Difficult to do much other than fight in, but not entirely arresting."
	icon_state = "kazengungauntlets"
	item_state = "kazengungauntlets"
	body_parts_covered = HANDS|ARMS
	detail_tag = "_detail"
	color = "#FFFFFF"
	detail_color = "#FFFFFF"
	var/picked = FALSE

/obj/item/clothing/gloves/roguetown/plate/kote/attack_right(mob/user)
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

/obj/item/clothing/gloves/roguetown/plate/kote/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)
