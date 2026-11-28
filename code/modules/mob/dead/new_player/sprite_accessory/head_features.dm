/datum/sprite_accessory/head_feature
	abstract_type = /datum/sprite_accessory/head_feature

/datum/sprite_accessory/head_feature/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_FACE, OFFSET_FACE_F)

/datum/sprite_accessory/head_feature/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return is_human_part_visible(owner, HIDEHAIR)

/datum/sprite_accessory/head_feature/skrell_hair
	abstract_type = /datum/sprite_accessory/head_feature/skrell_hair
	icon = 'icons/mob/sprite_accessory/head_features/skrell_hair.dmi'
	color_key_name = "Tentacles"
	relevant_layers = list(BODY_ADJ_LAYER, BODY_FRONT_LAYER)

/datum/sprite_accessory/head_feature/skrell_hair/long
	name = "Female"
	icon_state = "long"

/datum/sprite_accessory/head_feature/skrell_hair/short
	name = "Male"
	icon_state = "short"

/datum/sprite_accessory/head_feature/xeno_head
	abstract_type = /datum/sprite_accessory/head_feature/xeno_head
	icon = 'icons/mob/sprite_accessory/head_features/xeno_head.dmi'
	color_key_name = "Head"
	relevant_layers = list(BODY_ADJ_LAYER)

/datum/sprite_accessory/head_feature/xeno_head/standard
	name = "Standard"
	icon_state = "standard"

/datum/sprite_accessory/head_feature/xeno_head/royal
	name = "Royal"
	icon_state = "royal"

/datum/sprite_accessory/head_feature/xeno_head/hollywood
	name = "Hollywood"
	icon_state = "hollywood"

/datum/sprite_accessory/head_feature/xeno_head/warrior
	name = "Warrior"
	icon_state = "warrior"

/datum/sprite_accessory/head_feature/ipc_screen
	abstract_type = /datum/sprite_accessory/head_feature/ipc_screen
	icon = 'icons/mob/sprite_accessory/head_features/ipc_screens.dmi'
	color_key_name = "Screen"
	relevant_layers = list(BODY_ADJ_LAYER)
	default_colors = list("#FFFFFF")

/datum/sprite_accessory/head_feature/ipc_screen/blank
	name = "Blank"
	icon_state = "blank"

/datum/sprite_accessory/head_feature/ipc_screen/pink
	name = "Pink"
	icon_state = "pink"

/datum/sprite_accessory/head_feature/ipc_screen/green
	name = "Green"
	icon_state = "green"

/datum/sprite_accessory/head_feature/ipc_screen/red
	name = "Red"
	icon_state = "red"

/datum/sprite_accessory/head_feature/ipc_screen/blue
	name = "Blue"
	icon_state = "blue"

/datum/sprite_accessory/head_feature/ipc_screen/yellow
	name = "Yellow"
	icon_state = "yellow"

/datum/sprite_accessory/head_feature/ipc_screen/shower
	name = "Shower"
	icon_state = "shower"

/datum/sprite_accessory/head_feature/ipc_screen/nature
	name = "Nature"
	icon_state = "nature"

/datum/sprite_accessory/head_feature/ipc_screen/eight
	name = "Eight"
	icon_state = "eight"

/datum/sprite_accessory/head_feature/ipc_screen/goggles
	name = "Goggles"
	icon_state = "goggles"

/datum/sprite_accessory/head_feature/ipc_screen/heart
	name = "Heart"
	icon_state = "heart"

/datum/sprite_accessory/head_feature/ipc_screen/monoeye
	name = "Mono Eye"
	icon_state = "monoeye"

/datum/sprite_accessory/head_feature/ipc_screen/breakout
	name = "Breakout"
	icon_state = "breakout"

/datum/sprite_accessory/head_feature/ipc_screen/purple
	name = "Purple"
	icon_state = "purple"

/datum/sprite_accessory/head_feature/ipc_screen/scroll
	name = "Scroll"
	icon_state = "scroll"

/datum/sprite_accessory/head_feature/ipc_screen/console
	name = "Console"
	icon_state = "console"

/datum/sprite_accessory/head_feature/ipc_screen/rgb
	name = "RGB"
	icon_state = "rgb"

/datum/sprite_accessory/head_feature/ipc_screen/golglider
	name = "Gol Glider"
	icon_state = "golglider"

/datum/sprite_accessory/head_feature/ipc_screen/rainbow
	name = "Rainbow"
	icon_state = "rainbow"

/datum/sprite_accessory/head_feature/ipc_screen/sunburst
	name = "Sunburst"
	icon_state = "sunburst"

/datum/sprite_accessory/head_feature/ipc_screen/static
	name = "Static"
	icon_state = "static"

/datum/sprite_accessory/head_feature/ipc_screen/bsod
	name = "BSOD"
	icon_state = "bsod"

/datum/sprite_accessory/head_feature/ipc_screen/redtext
	name = "Red Text"
	icon_state = "redtext"

/datum/sprite_accessory/head_feature/ipc_screen/sinewave
	name = "Sine Wave"
	icon_state = "sinewave"

/datum/sprite_accessory/head_feature/ipc_screen/squarewave
	name = "Square Wave"
	icon_state = "squarewave"

/datum/sprite_accessory/head_feature/ipc_screen/ecgwave
	name = "ECG Wave"
	icon_state = "ecgwave"

/datum/sprite_accessory/head_feature/ipc_screen/eyes
	name = "Eyes"
	icon_state = "eyes"

/datum/sprite_accessory/head_feature/ipc_screen/textdrop
	name = "Text Drop"
	icon_state = "textdrop"

/datum/sprite_accessory/head_feature/ipc_screen/stars
	name = "Stars"
	icon_state = "stars"

/datum/sprite_accessory/head_feature/teshari_feathers
	abstract_type = /datum/sprite_accessory/head_feature/teshari_feathers
	icon = 'icons/mob/sprite_accessory/head_features/teshari_feathers.dmi'
	color_key_name = "Feathers"
	relevant_layers = list(BODY_ADJ_LAYER, BODY_FRONT_LAYER)

/datum/sprite_accessory/head_feature/teshari_feathers/regular
	name = "Regular"
	icon_state = "regular"
	color_keys = 2
	color_key_names = list("Feathers", "Details")

/datum/sprite_accessory/head_feature/teshari_feathers/bushy
	name = "Bushy"
	icon_state = "bushy"
	color_keys = 2
	color_key_names = list("Feathers", "Details")

/datum/sprite_accessory/head_feature/teshari_feathers/mohawk
	name = "Mohawk"
	icon_state = "mohawk"
	color_keys = 2
	color_key_names = list("Feathers", "Details")

/datum/sprite_accessory/head_feature/teshari_feathers/spiky
	name = "Spiky"
	icon_state = "spiky"
	color_keys = 2
	color_key_names = list("Feathers", "Details")

/datum/sprite_accessory/head_feature/teshari_feathers/pointy
	name = "Pointy"
	icon_state = "pointy"
	color_keys = 2
	color_key_names = list("Feathers", "Details")

/datum/sprite_accessory/head_feature/teshari_feathers/upright
	name = "Upright"
	icon_state = "upright"
	color_keys = 2
	color_key_names = list("Feathers", "Details")

/datum/sprite_accessory/head_feature/teshari_feathers/mane
	name = "Mane"
	icon_state = "mane"
	color_keys = 2
	color_key_names = list("Feathers", "Details")

/datum/sprite_accessory/head_feature/teshari_feathers/droopy
	name = "Droopy"
	icon_state = "droopy"
	color_keys = 2
	color_key_names = list("Feathers", "Details")

/datum/sprite_accessory/head_feature/teshari_feathers/longway
	name = "Longway"
	icon_state = "longway"
	color_keys = 2
	color_key_names = list("Feathers", "Details")

/datum/sprite_accessory/head_feature/teshari_feathers/tree
	name = "Tree"
	icon_state = "tree"
	color_keys = 2
	color_key_names = list("Feathers", "Details")

/datum/sprite_accessory/head_feature/teshari_feathers/mushroom
	name = "Mushroom"
	icon_state = "mushroom"

/datum/sprite_accessory/head_feature/teshari_feathers/backstrafe
	name = "Backstrafe"
	icon_state = "backstrafe"

/datum/sprite_accessory/head_feature/teshari_feathers/thinmohawk
	name = "Thin Mohawk"
	icon_state = "thinmohawk"

/datum/sprite_accessory/head_feature/teshari_feathers/thinmane
	name = "Thin Mane"
	icon_state = "thinmane"
