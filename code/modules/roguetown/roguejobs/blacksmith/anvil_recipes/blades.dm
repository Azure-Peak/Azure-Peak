/obj/item/blade
	name = "blade"
	desc = "A cast blade waiting to be finished."
	icon = 'icons/roguetown/items/anvil_casting.dmi'
	var/quality = SMELTERY_LEVEL_POOR
	var/datum/anvil_recipe/currecipe
	var/overlay_color

/obj/item/blade/Initialize()
    . = ..()
    if(overlay_color)
        color = overlay_color

/obj/item/blade/iron_axe
	name = "iron axe blade"
	icon_state = "blade_axe"
	overlay_color = "#808080"

/obj/item/blade/iron_mace
	name = "iron mace head"
	icon_state = "blade_mace"
	overlay_color = "#808080"

/obj/item/blade/iron_sword
	name = "iron sword blade"
	icon_state = "blade_sword"
	overlay_color = "#808080"

/obj/item/blade/iron_knife
	name = "iron knife blade"
	icon_state = "blade_knife"
	overlay_color = "#808080"

/obj/item/blade/iron_polearm
	name = "iron polearm blade"
	icon_state = "blade_polearm"
	overlay_color = "#808080"

/obj/item/blade/iron_plate
	name = "iron plate"
	icon_state = "blade_plate"
	overlay_color = "#808080"
	desc = "A cast plate waiting to be finished."

//

/obj/item/blade/bronze_axe
	name = "bronze axe blade"
	icon_state = "blade_axe"
	overlay_color = "#f9d690"

/obj/item/blade/bronze_mace
	name = "bronze mace head"
	icon_state = "blade_mace"
	overlay_color = "#f9d690"

/obj/item/blade/bronze_sword
	name = "bronze sword blade"
	icon_state = "blade_sword"
	overlay_color = "#f9d690"

/obj/item/blade/bronze_knife
	name = "bronze knife blade"
	icon_state = "blade_knife"
	overlay_color = "#f9d690"

/obj/item/blade/bronze_polearm
	name = "bronze polearm blade"
	icon_state = "blade_polearm"
	overlay_color = "#f9d690"

/obj/item/blade/bronze_plate
	name = "bronze plate"
	icon_state = "blade_plate"
	overlay_color = "#f9d690"
	desc = "A cast plate waiting to be finished."

//

/obj/item/blade/steel_axe
	name = "steel axe blade"
	icon_state = "blade_axe"

/obj/item/blade/steel_mace
	name = "steel mace head"
	icon_state = "blade_mace"

/obj/item/blade/steel_sword
	name = "steel sword blade"
	icon_state = "blade_sword"

/obj/item/blade/steel_knife
	name = "steel knife blade"
	icon_state = "blade_knife"

/obj/item/blade/steel_polearm
	name = "steel polearm blade"
	icon_state = "blade_polearm"

/obj/item/blade/steel_plate
	name = "steel plate"
	icon_state = "blade_plate"
	desc = "A cast plate waiting to be finished."
