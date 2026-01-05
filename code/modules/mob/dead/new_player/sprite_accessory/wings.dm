/datum/sprite_accessory/wings
	abstract_type = /datum/sprite_accessory/wings
	icon = 'icons/mob/sprite_accessory/wings/wings.dmi'
	color_key_name = "Wings"
	relevant_layers = list(BODY_BEHIND_LAYER, BODY_FRONT_LAYER)
	/// Whether the sprite accessory has states for open wings (With an "_open" suffix).
	var/can_open = FALSE
	var/can_hide = FALSE

/datum/sprite_accessory/wings/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_BACK, OFFSET_BACK_F)

/datum/sprite_accessory/wings/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(!owner || !can_open)
		return ..()
	var/obj/item/organ/wings/wings_organ = owner.getorganslot(ORGAN_SLOT_WINGS)
	if(!wings_organ || !wings_organ.is_open)
		return ..()
	return "[icon_state]_open"

/datum/sprite_accessory/wings/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(can_hide)
		return is_human_part_visible(owner, HIDEWINGS)
	else
		return TRUE

#ifdef UNIT_TESTS

/datum/sprite_accessory/wings/unit_testing_icon_states(list/states)
	states += icon_state
	if(can_open)
		states += "[icon_state]_open"

#endif

/datum/sprite_accessory/wings/bee
	name = "Bee"
	icon_state = "bee"

/datum/sprite_accessory/wings/fairy
	name = "Fairy"
	icon_state = "fairy"

/datum/sprite_accessory/wings/feathery
	name = "Feathery"
	icon_state = "feathery"

/datum/sprite_accessory/wings/bat
	name = "Bat"
	icon_state = "bat"

/datum/sprite_accessory/wings/featheryv2
	name = "Feathery v2"
	icon_state = "featheryv2"

/datum/sprite_accessory/wings/dragon/clipped
	name = "Clipped Dragon"
	icon_state = "clipped"

/datum/sprite_accessory/wings/moth
	abstract_type = /datum/sprite_accessory/wings/moth
	icon = 'icons/mob/sprite_accessory/wings/moth_wings.dmi'
	default_colors = list("#FFFFFF")

/datum/sprite_accessory/wings/moth/plain
	name = "Plain"
	icon_state = "plain"

/datum/sprite_accessory/wings/moth/monarch
	name = "Monarch"
	icon_state = "monarch"

/datum/sprite_accessory/wings/moth/luna
	name = "Luna"
	icon_state = "luna"

/datum/sprite_accessory/wings/moth/atlas
	name = "Atlas"
	icon_state = "atlas"

/datum/sprite_accessory/wings/moth/reddish
	name = "Reddish"
	icon_state = "redish"

/datum/sprite_accessory/wings/moth/royal
	name = "Royal"
	icon_state = "royal"

/datum/sprite_accessory/wings/moth/gothic
	name = "Gothic"
	icon_state = "gothic"

/datum/sprite_accessory/wings/moth/lovers
	name = "Lovers"
	icon_state = "lovers"

/datum/sprite_accessory/wings/moth/whitefly
	name = "White Fly"
	icon_state = "whitefly"

/datum/sprite_accessory/wings/moth/punished
	name = "Burnt Off"
	icon_state = "burnt_off"

/datum/sprite_accessory/wings/moth/firewatch
	name = "Firewatch"
	icon_state = "firewatch"

/datum/sprite_accessory/wings/moth/deathhead
	name = "Deathshead"
	icon_state = "deathhead"

/datum/sprite_accessory/wings/moth/poison
	name = "Poison"
	icon_state = "poison"

/datum/sprite_accessory/wings/moth/ragged
	name = "Ragged"
	icon_state = "ragged"

/datum/sprite_accessory/wings/moth/moonfly
	name = "Moon Fly"
	icon_state = "moonfly"

/datum/sprite_accessory/wings/moth/snow
	name = "Snow"
	icon_state = "snow"

/datum/sprite_accessory/wings/moth/oakworm
	name = "Oak Worm"
	icon_state = "oakworm"

/datum/sprite_accessory/wings/moth/jungle
	name = "Jungle"
	icon_state = "jungle"

/datum/sprite_accessory/wings/moth/witchwing
	name = "Witch Wing"
	icon_state = "witchwing"

/datum/sprite_accessory/wings/moth/rosy
	name = "Rosy"
	icon_state = "rosy"

/datum/sprite_accessory/wings/moth/featherful
	name = "Featherful"
	icon_state = "featherful"

/datum/sprite_accessory/wings/moth/brown
	name = "Brown"
	icon_state = "brown"

/datum/sprite_accessory/wings/moth/plasmafire
	name = "Plasmafire"
	icon_state = "plasmafire"

/datum/sprite_accessory/wings/wide
	abstract_type = /datum/sprite_accessory/wings/wide
	icon = 'icons/mob/sprite_accessory/wings/wings_wide.dmi'
	pixel_x = -7

/datum/sprite_accessory/wings/wide/succubus
	name = "Succubus"
	icon_state = "succubus"
	extra_state = TRUE

/datum/sprite_accessory/wings/wide/dragon_synth
	name = "Dragon (synthetic alt)"
	icon_state = "dragonsynth"

/datum/sprite_accessory/wings/wide/dragon_alt1
	name = "Dragon (alt 1)"
	icon_state = "dragonalt1"

/datum/sprite_accessory/wings/wide/dragon_alt2
	name = "Dragon (alt 2)"
	icon_state = "dragonalt2"

/datum/sprite_accessory/wings/wide/harpywings
	name = "Harpy"
	icon_state = "harpy"
	can_hide = TRUE

/datum/sprite_accessory/wings/wide/harpywingsalt1
	name = "Harpy (alt 1)"
	icon_state = "harpyalt"
	can_hide = TRUE

/datum/sprite_accessory/wings/wide/harpywingsalt2
	name = "Harpy (Bat)"
	icon_state = "harpybat"
	can_hide = TRUE

/datum/sprite_accessory/wings/wide/harpywings_top
	name = "Harpy (Top)"
	icon_state = "harpy_top"
	relevant_layers = list(BODY_FRONT_LAYER)
	can_hide = TRUE

/datum/sprite_accessory/wings/wide/harpywingsalt1_top
	name = "Harpy (alt 1) (Top)"
	icon_state = "harpyalt_top"
	relevant_layers = list(BODY_FRONT_LAYER)
	can_hide = TRUE

/datum/sprite_accessory/wings/wide/harpywingsalt2_top
	name = "Harpy (Bat) (Top)"
	icon_state = "harpybat_top"
	relevant_layers = list(BODY_FRONT_LAYER)
	can_hide = TRUE

/datum/sprite_accessory/wings/wide/low_wings
	name = "Low wings"
	icon_state = "low"

/datum/sprite_accessory/wings/wide/low_wings_top
	name = "Low wings (Top)"
	icon_state = "low_top"

/datum/sprite_accessory/wings/wide/spider
	name = "Spider legs"
	icon_state = "spider_legs"

/datum/sprite_accessory/wings/wide/robowing
	name = "mechanical dragon wings"
	icon_state = "robowing"

/datum/sprite_accessory/wings/huge
	abstract_type = /datum/sprite_accessory/wings/huge
	icon = 'icons/mob/sprite_accessory/wings/wings_huge.dmi'
	relevant_layers = list(BODY_BEHIND_LAYER, BODY_ADJ_LAYER, BODY_FRONT_LAYER)
	pixel_x = -32
	can_open = TRUE

/datum/sprite_accessory/wings/huge/angel
	name = "Angel"
	icon_state = "angel"

/datum/sprite_accessory/wings/huge/dragon
	name = "Dragon"
	icon_state = "dragon"

/datum/sprite_accessory/wings/huge/megamoth
	name = "Megamoth"
	icon_state = "megamoth"

/datum/sprite_accessory/wings/huge/mothra
	name = "Mothra"
	icon_state = "mothra"

/datum/sprite_accessory/wings/huge/skeleton
	name = "Skeleton"
	icon_state = "skele"

/datum/sprite_accessory/wings/huge/robotic
	name = "Robotic"
	icon_state = "robotic"

/datum/sprite_accessory/wings/large
	abstract_type = /datum/sprite_accessory/wings/large
	icon = 'icons/mob/sprite_accessory/wings/wings_64x32.dmi'
	relevant_layers = list(BODY_BEHIND_LAYER, BODY_FRONT_LAYER)
	pixel_x = -16

/datum/sprite_accessory/wings/large/harpyswept
	name = "Harpy (Swept)"
	icon_state = "harpys"
	can_hide = TRUE

/datum/sprite_accessory/wings/large/harpyswept_alt
	name = "Harpy (Swept Alt)"
	icon_state = "harpys_alt"
	can_hide = TRUE

/datum/sprite_accessory/wings/large/harpyfluff
	name = "Harpy Fluff"
	icon_state = "harpyfluff"
	can_hide = TRUE

/datum/sprite_accessory/wings/large/harpyfolded
	name = "Harpy Folded"
	icon_state = "harpyfolded"
	can_hide = TRUE

/datum/sprite_accessory/wings/large/harpyowl
	name = "Harpy Owl"
	icon_state = "harpyowl"
	can_hide = TRUE

/datum/sprite_accessory/wings/large/harpybat_alt
	name = "Harpy Bat Alt"
	icon_state = "harpybat_alt"
	can_hide = TRUE

/datum/sprite_accessory/wings/large/gargoyle
	name = "Gargoyle"
	icon_state = "gargoyle"
