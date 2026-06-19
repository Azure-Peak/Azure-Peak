/obj/item/kitchen/spoon
	name = "wooden spoon"
	desc = "Traditional utensil for shoveling soup into your mouth, or to churn butter with."
	icon = 'modular/Neu_Food/icons/cookware/spoon.dmi'
	icon_state = "spoon"
	force = 0
	w_class = WEIGHT_CLASS_TINY

/obj/item/kitchen/spoon/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-click a bowl with the spoon to drink from its contents.")
	. += span_info("Nobler appetites prefer utensils over simply eating and drinking with one's bare hands.")

/obj/item/kitchen/spoon/aalloy
	name = "decrepit spoon"
	icon_state = "aspoon"
	color = "#bb9696"

/obj/item/kitchen/spoon/iron
	name = "iron spoon"
	icon_state = "spoon_iron"

/obj/item/kitchen/spoon/bronze
	name = "bronze spoon"
	icon_state = "spoon_bronze"

/obj/item/kitchen/spoon/tin
	name = "pewter spoon"
	icon_state = "spoon_iron"

/obj/item/kitchen/spoon/gold
	name = "gold spoon"
	icon_state = "spoon_gold"

/obj/item/kitchen/spoon/silver
	name = "silver spoon"
	icon_state = "spoon_silver"
	is_silver = TRUE
	is_lesser_silver = TRUE

/obj/item/kitchen/spoon/carved
	name = "carved spoon"
	icon_state = "aspoon"
	has_item_quality = TRUE

/obj/item/kitchen/spoon/carved/shell
	name = "shell spoon"
	icon_state = "spoon_shell"

/obj/item/kitchen/spoon/carved/rose
	name = "rosestone spoon"
	icon_state = "spoon_rose"

/obj/item/kitchen/spoon/carved/jade
	name = "jade spoon"
	icon_state = "spoon_jade"

/obj/item/kitchen/spoon/carved/onyxa
	name = "onyxa spoon"
	icon_state = "spoon_onyxa"

/obj/item/kitchen/spoon/carved/turq
	name = "cerulite spoon"
	icon_state = "spoon_turq"

/obj/item/kitchen/spoon/carved/coral
	name = "heartstone spoon"
	icon_state = "spoon_coral"

/obj/item/kitchen/spoon/carved/amber
	name = "amber spoon"
	icon_state= "spoon_amber"

/obj/item/kitchen/spoon/carved/opal
	name = "opal spoon"
	icon_state = "spoon_opal"

// NUKE THIS FUCKING TYPEPATH WHEN WE HAVE TIME
/obj/item/kitchen/spoon/plastic
	name = "wooden spoon"
	desc = "Good for soup."
	icon_state = "spoon"
