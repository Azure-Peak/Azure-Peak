#define BCLASS_CHISEL "chisel"

// ==========================================
// HANDSAW DEFINITIONS
// ==========================================

/obj/item/rogueweapon/handsaw
	name = "handsaw"
	desc = "Iron tool for woodworking."
	icon = 'icons/roguetown/items/crafting.dmi'
	icon_state = "handsaw"

	force = 5
	wdefense = 0
	wlength = WLENGTH_LONG
	w_class = WEIGHT_CLASS_NORMAL
	sharpness = IS_SHARP
	max_blade_int = 300

	grid_width = 32
	grid_height = 96
	slot_flags = ITEM_SLOT_HIP
	is_tool = TRUE
	tool_behaviour = TOOL_SAW

	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/chop/cleaver)
	gripped_intents = null
	associated_skill = /datum/skill/combat/axes

	swingsound = list('sound/combat/wooshes/blunt/shovel_swing.ogg', 'sound/combat/wooshes/blunt/shovel_swing2.ogg')
	drop_sound = 'sound/foley/dropsound/shovel_drop.ogg'
	smeltresult = /obj/item/ingot/iron

/obj/item/rogueweapon/handsaw/bronze
	name = "bronze handsaw"
	desc = "The serrated half of a bronzen pair, keen to saw away at its problems."
	icon_state = "bronzehandsaw"
	max_blade_int = 400
	smeltresult = /obj/item/ingot/bronze

/obj/item/rogueweapon/handsaw/blacksteel
	name = "blacksteel handsaw"
	desc = "Embrace the joy of creation, one motion at a time."
	icon_state = "bshandsaw"
	max_blade_int = 400
	max_integrity = 300
	smeltresult = /obj/item/ingot/blacksteel


// ==========================================
// BASE CHISEL DEFINITIONS
// ==========================================

/obj/item/rogueweapon/chisel
	name = "chisel"
	desc = "Add something to strike it with before doing stonework. Like a mallet or a stone."
	icon = 'icons/roguetown/items/crafting.dmi'
	icon_state = "chisel"

	force = 10
	throwforce = 2
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_SMALL
	wdefense = 0
	sharpness = IS_SHARP
	blade_dulling = 0
	max_integrity = 140
	max_blade_int = 300
	dropshrink = 0.9

	grid_width = 32
	grid_height = 64
	slot_flags = ITEM_SLOT_HIP

	possible_item_intents = list(/datum/intent/stab)
	associated_skill = /datum/skill/combat/knives

	swingsound = list('sound/combat/wooshes/blunt/shovel_swing.ogg', 'sound/combat/wooshes/blunt/shovel_swing2.ogg')
	drop_sound = 'sound/foley/dropsound/shovel_drop.ogg'

	var/already_assembled = FALSE
	var/chisel_prefix = ""

/obj/item/rogueweapon/chisel/bronze
	name = "bronze chisel"
	desc = "The blunted half of a bronzen pair, for issues requiring a steady trepanning. Add something to strike it with before doing stonework, like a mallet or a stone."
	icon_state = "bronzechisel"
	max_blade_int = 400
	smeltresult = /obj/item/ingot/bronze
	chisel_prefix = "bronze"

/obj/item/rogueweapon/chisel/blacksteel
	name = "blacksteel chisel"
	desc = "The pen that'll scrawl a masterwork through this parchment-of-stone. Add something to strike it with before doing stonework, like a mallet or a stone."
	icon_state = "bschisel"
	max_blade_int = 500
	max_integrity = 300
	smeltresult = /obj/item/ingot/blacksteel
	chisel_prefix = "bs"

// Single attackby proc handles combining ANY chisel with ANY valid striking tool
// This is where you add more chisels if you've got sprites for them.. Though in the future, auto-generating the icons might be wiser.
/obj/item/rogueweapon/chisel/attackby(obj/item/W, mob/living/user, params)
	if(already_assembled)
		return ..()

	var/static/list/striking_tool_types = list(
		/obj/item/natural/stoneblock          = "b",
		/obj/item/natural/stone               = "s",
		/obj/item/rogueweapon/hammer/steel    = "c",
		/obj/item/rogueweapon/hammer/iron     = "h",
		/obj/item/rogueweapon/hammer/wood     = "m",
		/obj/item/rogueweapon/hammer/blacksteel = "bh",
		/obj/item/rogueweapon/hammer/bronze   = "bronzeh",
		/obj/item/rogueweapon/hammer/paalloy   = "a"
	)

	var/tool_suffix = null
	for(var/typepath in striking_tool_types)
		if(istype(W, typepath))
			tool_suffix = striking_tool_types[typepath]
			break

	if(!tool_suffix)
		return ..()

	playsound(get_turf(user.loc), 'sound/foley/brickdrop.ogg', 100, TRUE)
	user.visible_message(span_info("[user] adds a striking tool to the chisel set."))

	var/obj/item/rogueweapon/chisel/assembly/A = new(src.loc)
	A.chisel_type = src.type
	A.striking_tool_type = W.type
	A.icon_state = "[chisel_prefix]chisel[tool_suffix]"

	qdel(W)
	user.put_in_hands(A)
	qdel(src)


// ==========================================
// UNIFIED CHISEL TOOLSET ASSEMBLY
// ==========================================

/obj/item/rogueweapon/chisel/assembly
	name = "chisel set"
	desc = "Ready to shape stones when held in a steady grip. Can be separated easily."
	grid_width = 64
	grid_height = 64
	already_assembled = TRUE

	possible_item_intents = list(/datum/intent/hit)
	gripped_intents = list(/datum/intent/chisel)

	var/chisel_type = /obj/item/rogueweapon/chisel
	var/striking_tool_type = /obj/item/rogueweapon/hammer/wood

// Single proc handles splitting the assembly back into its component parts
/obj/item/rogueweapon/chisel/assembly/attack_right(mob/user)
	var/obj/item/chisel_item = new chisel_type(user.loc)
	var/obj/item/striking_item = new striking_tool_type(user.loc)

	playsound(get_turf(user.loc), 'sound/foley/brickdrop.ogg', 100, TRUE)
	user.put_in_hands(striking_item)
	user.put_in_hands(chisel_item)
	qdel(src)


// ==========================================
// INTENT DEFINITION
// ==========================================

/datum/intent/chisel
	name = "chisel"
	icon_state = "inchisel"
	attack_verb = list("chisels")
	hitsound = list('sound/combat/hits/pick/genpick (1).ogg', 'sound/combat/hits/pick/genpick (2).ogg')
	animname = "strike"
	item_d_type = "stab"
	blade_class = BCLASS_CHISEL
	chargetime = 0
	swingdelay = 3

#undef BCLASS_CHISEL
