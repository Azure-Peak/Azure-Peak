
/obj/item/storage/belt/rogue
	name = ""
	desc = ""
	icon = 'icons/roguetown/clothing/belts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/belts.dmi'
	icon_state = ""
	item_state = ""
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb = list("whips", "lashes")
	max_integrity = 300
	equip_sound = 'sound/blank.ogg'
	content_overlays = FALSE
	bloody_icon_state = "bodyblood"
	experimental_inhand = FALSE
	component_type = /datum/component/storage/concrete/roguetown/belt
	grid_width = 64
	grid_height = 64

/obj/item/storage/belt/rogue/attack_right(mob/user)
	var/datum/component/storage/CP = GetComponent(/datum/component/storage)
	if(CP)
		CP.rmb_show(user)
		return TRUE
	..()

/obj/item/storage/belt/rogue/leather
	name = "belt"
	desc = "A fine leather strap notched with holes for a buckle to secure itself."
	icon_state = "leather"
	item_state = "leather"
	equip_sound = 'sound/blank.ogg'
	sewrepair = TRUE
	sellprice = 10
	resistance_flags = FIRE_PROOF

/obj/item/storage/belt/rogue/leather/plaquegold
	name = "plaque belt"
	desc = "An exquisite belt, decorated with studdings of gold."
	icon_state = "goldplaque"
	sellprice = 50
	sewrepair = FALSE
	anvilrepair = /datum/skill/craft/armorsmithing

/obj/item/storage/belt/rogue/leather/shalal
	name = "shalal belt"
	icon_state = "shalal"
	sellprice = 5

/obj/item/storage/belt/rogue/leather/black
	name = "black belt"
	icon_state = "blackbelt"
	item_state = "blackbelt"
	sellprice = 10

/obj/item/storage/belt/rogue/leather/plaquesilver
	name = "plaque belt"
	desc = "An exquisite belt, decorated with studdings of silver."
	icon_state = "silverplaque"
	sellprice = 30
	sewrepair = FALSE
	anvilrepair = /datum/skill/craft/armorsmithing

/obj/item/storage/belt/rogue/leather/battleskirt
	name = "cloth military skirt"
	desc = "A fine leather strap notched with holes for a buckle to secure itself, notched above a flared military skirt."
	icon_state = "battleskirt"
	sewrepair = FALSE
	detail_tag = "_belt"

/obj/item/storage/belt/rogue/leather/battleskirt/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/storage/belt/rogue/leather/battleskirt/black
	color = CLOTHING_BLACK

/obj/item/storage/belt/rogue/leather/battleskirt/barbarian
	color = "#48443b"

/obj/item/storage/belt/rogue/leather/battleskirt/faulds
	name = "belt with faulds"
	desc = "A fine leather strap notched with holes for a buckle to secure itself, notched above a halved military skirt."
	icon_state = "faulds"
	sewrepair = FALSE
	detail_tag = "_belt"

/obj/item/storage/belt/rogue/leather/battleskirt/breechcloth
	name = "belt with breechcloth"
	desc = "A fine leather strap notched with holes for a buckle to secure itself, and nestled above a halved tabard's coverings."
	icon_state = "breechcloth"
	flags_inv = HIDECROTCH
	sewrepair = FALSE
	detail_tag = "_belt"

/obj/item/storage/belt/rogue/leather/battleskirt/breechcloth/blackbelt
	name = "black belt with breechcloth"
	desc = "A fine black-leather strap notched with holes for a buckle to secure itself, and nestled above a halved tabard's coverings."
	icon_state = "breechclothalt"
	flags_inv = HIDECROTCH
	sewrepair = FALSE
	detail_tag = "_belt"

/obj/item/storage/belt/rogue/leather/steel
	name = "steel belt"
	desc = "A fine leather belt that's been sleeved within many segments of steel, protecting its delicate innards from prying hands-and-blades."
	icon_state = "steelplaque"
	sellprice = 30
	sewrepair = FALSE
	anvilrepair = /datum/skill/craft/armorsmithing

/obj/item/storage/belt/rogue/leather/steel/tasset
	name = "tasseted belt"
	desc = "A fine leather belt that's been sleeved within many segments of steel, and further reinforced with the tassets of a fluted cuirass."
	icon_state = "steeltasset"
	sellprice = 35
	sewrepair = FALSE
	anvilrepair = /datum/skill/craft/armorsmithing

/obj/item/storage/belt/rogue/leather/rope
	name = "rope belt"
	desc = "A length of strong rope repurposed into a belt. Better than nothing."
	icon_state = "rope"
	item_state = "rope"
	color = "#b9a286"
	component_type = /datum/component/storage/concrete/roguetown/belt/cloth

/obj/item/storage/belt/rogue/leather/cloth
	name = "cloth sash"
	desc = "A strip of cloth tied together at the ends into a makeshift belt. It's better than nothing."
	icon_state = "cloth"
	component_type = /datum/component/storage/concrete/roguetown/belt/cloth

/obj/item/storage/belt/rogue/leather/cloth/lady
	color = "#575160"

/obj/item/storage/belt/rogue/leather/cloth/bandit
	color = "#ff0000"
	component_type = /datum/component/storage/concrete/roguetown/belt

/obj/item/storage/belt/rogue/leather/sash
	name = "fine sash"		//Like the cloth sash but with better storage. More expensive.
	desc = "A pliable sash made of wool meant to wrap tightly around the waist, especially popular with travellers who wear loose shirts."
	icon_state = "clothsash"
	item_state = "clothsash"

/obj/item/storage/backpack/rogue/satchel
	name = "satchel"
	desc = "Modest, easy on the shoulders, and holds a respectable amount."
	icon_state = "satchel"
	item_state = "satchel"
	icon = 'icons/roguetown/clothing/storage.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	resistance_flags = FIRE_PROOF
	max_integrity = 300
	sellprice = 10
	equip_sound = 'sound/blank.ogg'
	bloody_icon_state = "bodyblood"
	alternate_worn_layer = UNDER_CLOAK_LAYER
	sewrepair = TRUE
	component_type = /datum/component/storage/concrete/roguetown/satchel


/obj/item/storage/backpack/rogue/satchel/cloth
	name = "cloth knapsack"
	desc = "A rudimentary cloth sack strapped to the back for storing small amounts of items."
	icon_state = "clothbackpack"
	item_state = "clothbackpack"
	component_type = /datum/component/storage/concrete/roguetown/satchel/cloth

/obj/item/storage/backpack/rogue/satchel/heartfelt
	populate_contents = list(
		/obj/item/natural/feather,
		/obj/item/paper,
	)

/obj/item/storage/backpack/rogue/satchel/otavan
	name = "otavan leather satchel"
	desc = "A sleek, stylish, and surprisingly sturdy satchel that hails straight from the Sovereignty of Otava. It is made to endure, first and foremost."
	icon_state = "osatchel"
	item_state = "osatchel"

/obj/item/storage/backpack/rogue/satchel/mule/PopulateContents()
	for(var/i in 1 to 3)
		switch(rand(1,4))
			if(1)
				new /obj/item/reagent_containers/powder/moondust_purest(src)
			if(2)
				new /obj/item/reagent_containers/powder/moondust_purest(src)
			if(3)
				new /obj/item/reagent_containers/powder/ozium(src)
			if(4)
				new /obj/item/reagent_containers/powder/spice(src)

/obj/item/storage/backpack/rogue/satchel/black
	color = CLOTHING_BLACK

/obj/item/storage/backpack/rogue/attack_right(mob/user)
	var/datum/component/storage/CP = GetComponent(/datum/component/storage)
	if(CP)
		CP.rmb_show(user)
		return TRUE

/obj/item/storage/backpack/rogue/satchel/short
	name = "short satchel"
	desc = "A leather satchel that's meant to clip to a belt or to a pair of pants, freeing the shoulders from any weight."
	icon_state = "satchelshort"
	item_state = "satchelshort"
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_HIP //Implement a check in the future that prevents more than one being worn at once.

/obj/item/storage/backpack/rogue/satchel/beltpack
	name = "beltpack" //Satchel that fits on the cloak or belt slot. Should be exceptionally rare for on-spawn loadouts, unless a flag's added to make it incompatable with regular satchels.
	desc = "A lighter satchel that rests against the rump, freeing the shoulders from any weight. It's traditionally worn in place of a belt or cloak."
	icon_state = "buttpack" //Later down the line, take the unused belt-satchel onmob and rename it to 'gamesatchel'.
	item_state = "buttpack"
	icon = 'icons/roguetown/clothing/storage.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/belts.dmi'
	slot_flags = ITEM_SLOT_CLOAK|ITEM_SLOT_BELT //Implement a check that prevents one from being worn on both slots at once. Another coder's duty, I think.
	edelay_type = 1
	equip_delay_self = 10
	max_integrity = 300
	component_type = /datum/component/storage/concrete/roguetown/satchel

/obj/item/storage/belt/rogue/leather/sash/maid
	name = "cloth sash"
	desc = "A pliable sash made of wool meant to wrap tightly around the waist."
	item_state = "maidsash"
	icon_state = "maidsash"
	icon = 'icons/roguetown/clothing/special/maids.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/maids.dmi'

/obj/item/storage/backpack/rogue/backpack
	name = "backpack"
	desc = "One of the best ways to carry many things while keeping your hands free."
	icon_state = "backpack"
	item_state = "backpack"
	icon = 'icons/roguetown/clothing/storage.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK_L
	resistance_flags = FIRE_PROOF
	max_integrity = 300
	sellprice = 15
	equip_sound = 'sound/blank.ogg'
	bloody_icon_state = "bodyblood"
	sewrepair = TRUE
	component_type = /datum/component/storage/concrete/roguetown/backpack

/obj/item/storage/backpack/rogue/artibackpack
	name = "Cooling backpack"
	desc = "A leather backpack with complex pipework coursing through it. It hums and vibrates constantly."
	icon_state = "artibackpack"
	item_state = "artibackpack"
	icon = 'icons/roguetown/clothing/storage.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK_L
	resistance_flags = FIRE_PROOF
	max_integrity = 300
	equip_sound = 'sound/blank.ogg'
	bloody_icon_state = "bodyblood"
	sewrepair = FALSE
	component_type = /datum/component/storage/concrete/roguetown/backpack

/obj/item/storage/backpack/rogue/backpack/bagpack
	name = "rucksack"
	desc = "A sack tied with some rope. Can be flung over your shoulders, if it's tied shut."
	icon_state = "rucksack_untied"
	item_state = "rucksack"
	component_type = /datum/component/storage/concrete/roguetown/sack/bag
	max_integrity = 100
	sewrepair = TRUE
	var/tied = FALSE

/obj/item/storage/backpack/rogue/backpack/bagpack/attack_right(mob/user)
	tied = !tied
	to_chat(user, span_info("I [tied ? "tighten" : "loosen"] the rucksack."))
	playsound(src, 'sound/foley/equip/rummaging-01.ogg', 100)
	update_icon()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	if(tied)
		STR.click_gather = FALSE
		STR.allow_quick_gather = FALSE
		STR.allow_quick_empty = FALSE
	else
		STR.click_gather = TRUE
		STR.allow_quick_gather = TRUE
		STR.allow_quick_empty = TRUE

/obj/item/storage/backpack/rogue/backpack/bagpack/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(!tied && (slot == SLOT_BACK_L || slot == SLOT_BACK_R))
		var/datum/component/storage/STR = GetComponent(/datum/component/storage)
		var/list/things = STR.contents()
		if(length(things))
			visible_message(span_warning("The loose bag empties as it is swung around [user]'s shoulder!"))
			STR.quick_empty(user)

/obj/item/storage/backpack/rogue/backpack/bagpack/update_icon()
	. = ..()
	if(tied)
		icon_state = "rucksack_tied_sling"
	else
		icon_state = "rucksack_untied"

/obj/item/storage/belt/rogue/leather/plaquegold/steward
	name = "fancy gold belt"
	desc = "A dark belt with real gold making up the buckle and highlights. How bougie."
	icon_state = "stewardbelt"
	item_state = "stewardbelt"

//Knifeblade belts, act as quivers mixed with belts. Lower storage size of a belt, but holds knives without taking space.
/obj/item/storage/belt/rogue/leather/knifebelt
	name = "tossblade belt"
	desc = "A five-slotted belt meant for tossblades. Little room left over."
	icon_state = "knife"
	item_state = "knife"
	strip_delay = 20
	var/max_storage = 5			//Javelin bag is 4 and they can't hold items. So, more fair having it like this since these are pretty decent weapons.
	var/list/knives = list()
	sewrepair = TRUE
	component_type = /datum/component/storage/concrete/roguetown/belt/knife_belt

/obj/item/storage/belt/rogue/leather/knifebelt/attack_turf(turf/T, mob/living/user)
	if(knives.len >= max_storage)
		to_chat(user, span_warning("Your [src.name] is full!"))
		return
	to_chat(user, span_notice("You begin to gather the ammunition..."))
	for(var/obj/item/rogueweapon/huntingknife/throwingknife/K in T.contents)
		if(do_after(user, 5))
			if(!eatknife(K))
				break

/obj/item/storage/belt/rogue/leather/knifebelt/proc/eatknife(obj/A)
	if(A.type in typesof(/obj/item/rogueweapon/huntingknife/throwingknife))
		if(knives.len < max_storage)
			A.forceMove(src)
			knives += A
			update_icon()
			return TRUE
		else
			return FALSE

/obj/item/storage/belt/rogue/leather/knifebelt/attackby(obj/A, loc, params)
	if(A.type in typesof(/obj/item/rogueweapon/huntingknife/throwingknife))
		if(knives.len < max_storage)
			if(ismob(loc))
				var/mob/M = loc
				M.doUnEquip(A, TRUE, src, TRUE, silent = TRUE)
			else
				A.forceMove(src)
			knives += A
			update_icon()
			to_chat(usr, span_notice("I discreetly slip [A] into [src]."))
		else
			to_chat(loc, span_warning("Full!"))
		return
	..()

/obj/item/storage/belt/rogue/leather/knifebelt/attack_right(mob/user)
	if(knives.len)
		var/obj/O = knives[knives.len]
		knives -= O
		O.forceMove(user.loc)
		user.put_in_hands(O)
		update_icon()
		return TRUE

/obj/item/storage/belt/rogue/leather/knifebelt/examine(mob/user)
	. = ..()
	if(knives.len)
		. += span_notice("[knives.len] inside.")

/obj/item/storage/belt/rogue/leather/knifebelt/iron/Initialize()
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/rogueweapon/huntingknife/throwingknife/K = new()
		knives += K
	update_icon()

/obj/item/storage/belt/rogue/leather/knifebelt/black
	icon_state = "blackknife"
	item_state = "blackknife"

/obj/item/storage/belt/rogue/leather/knifebelt/black/iron/Initialize()
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/rogueweapon/huntingknife/throwingknife/K = new()
		knives += K
	update_icon()

/obj/item/storage/belt/rogue/leather/knifebelt/black/steel/Initialize()
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/rogueweapon/huntingknife/throwingknife/steel/K = new()
		knives += K
	update_icon()

/obj/item/storage/belt/rogue/leather/knifebelt/black/silver/Initialize()
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/rogueweapon/huntingknife/throwingknife/silver/K = new()
		knives += K
	update_icon()

/obj/item/storage/belt/rogue/leather/knifebelt/black/psydon/Initialize()
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/rogueweapon/huntingknife/throwingknife/psydon/K = new()
		knives += K
	update_icon()

/obj/item/storage/belt/rogue/leather/knifebelt/black/kazengun/Initialize()
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/rogueweapon/huntingknife/throwingknife/kazengun/K = new()
		knives += K
	update_icon()

/obj/item/storage/belt/rogue/leather/exoticsilkbelt
	name = "exotic silk belt"
	desc = "A gold adorned belt with the softest of silks barely concealing one's bits."
	icon_state = "exoticsilkbelt"
	var/max_storage = 5
	sewrepair = TRUE

///////////////////////////////////////////////

/obj/item/storage/hip/headhook
	name = "head hook"
	desc = "an iron hook for storing 6 heads"
	icon = 'icons/roguetown/clothing/belts.dmi'
	//mob_overlay_icon = 'icons/roguetown/clothing/onmob/belts.dmi' //N/A uncomment when a mob_overlay icon is made and added
	icon_state = "ironheadhook"
	item_state = "ironheadhook"
	slot_flags = ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 300
	equip_sound = 'sound/blank.ogg'
	//content_overlays = FALSE
	bloody_icon_state = "bodyblood"
	anvilrepair = /datum/skill/craft/blacksmithing
	smeltresult = /obj/item/ingot/iron
	component_type = /datum/component/storage/concrete/grid/headhook

/obj/item/storage/hip/headhook/bronze
	name = "bronze head hook"
	desc = "a bronze hook for storing 12 heads"
	icon = 'icons/roguetown/clothing/belts.dmi'
	//mob_overlay_icon = 'icons/roguetown/clothing/onmob/belts.dmi'
	icon_state = "bronzeheadhook"
	item_state = "bronzeheadhook"
	slot_flags = ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 400
	equip_sound = 'sound/blank.ogg'
	//content_overlays = FALSE
	bloody_icon_state = "bodyblood"
	anvilrepair = /datum/skill/craft/blacksmithing
	smeltresult = /obj/item/ingot/bronze
	component_type = /datum/component/storage/concrete/grid/headhook/bronze

/obj/item/clothing/climbing_gear
	name = "climbing gear"
	desc = "Lets you do the impossible."
	color = null
	icon = 'icons/roguetown/clothing/storage.dmi'
	item_state = "climbing_gear" // sprites from lfwb kitbashed with grappler for inventory sprite
	icon_state = "climbing_gear" // sprites from lfwb kitbashed among each other for onmob sprite
	alternate_worn_layer = UNDER_CLOAK_LAYER
	inhand_mod = FALSE
	slot_flags = ITEM_SLOT_BACK

/obj/item/clothing/climbing_gear/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	playsound(loc, 'sound/items/garrotegrab.ogg', 100, TRUE)

/obj/item/clothing/wall_grab
	name = "wall"
	item_state = "grabbing"
	icon_state = "grabbing"
	icon = 'icons/mob/roguehudgrabs.dmi'
	max_integrity = 10
	w_class = WEIGHT_CLASS_HUGE
	item_flags = ABSTRACT
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	no_effect = TRUE

/obj/item/clothing/wall_grab/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)
	var/turf/openspace = user.loc
	openspace.zFall(user) // slop?

/obj/item/clothing/wall_grab/intercept_zImpact(atom/movable/AM, levels = 1) // with this shit it doesn't generate "X falls through open space". thank u guppyluxx
    . = ..()
    . |= FALL_NO_MESSAGE

/obj/item/storage/hip/orestore/bronze
	name = "mechanized ore bag"
	desc = "A becogged bag for sorting and compressing ore, ingots, and gemeralds. It idly ticks to the rhythm of unseen mechanisms, yearning for earthly treats."
	icon = 'icons/roguetown/items/misc.dmi'
	//mob_overlay_icon = 'icons/roguetown/clothing/onmob/belts.dmi'
	icon_state = "rucksack"
	item_state = "rucksack"
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_BACK 
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 400
	equip_sound = 'sound/blank.ogg'
	//content_overlays = FALSE
	anvilrepair = /datum/skill/craft/blacksmithing
	smeltresult = /obj/item/ingot/bronze
	component_type = /datum/component/storage/concrete/grid/orestore/bronze

/obj/item/storage/belt/rogue/leather/zig_bandolier
	name = "zig bandolier"
	desc = "For when your addiction gets a hold on you."
	icon_state = "twstrap0"
	item_state = "twstrap"
	icon = 'icons/obj/items/twstrap.dmi'
	lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_ARMOR
	resistance_flags = FIRE_PROOF
	equip_delay_self = 5 SECONDS
	unequip_delay_self = 5 SECONDS
	max_integrity = 0
	sellprice = 15
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	pixel_y = -16
	pixel_x = -16
	bigboy = TRUE
	equip_sound = 'sound/blank.ogg'
	bloody_icon_state = "bodyblood"
	alternate_worn_layer = UNDER_CLOAK_LAYER
	strip_delay = 20
	component_type = /datum/component/storage/concrete/roguetown/zig_bandolier
