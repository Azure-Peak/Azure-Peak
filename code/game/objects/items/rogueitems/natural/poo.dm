/obj/item/natural/poo
	name = "nightsoil"
	desc = "It smells awful."
	icon_state = "humpoo"
	dropshrink = 0.75
	throwforce = 0
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_TINY

/obj/item/natural/poo/cow
	name = "cow pie"
	desc = "It smells awful, but I know it's just digested grass... right?"
	icon_state = "cowpoo"

/obj/item/natural/poo/horse
	name = "droppings"
	desc = "It smells awful, but I know it's just digested grass."
	icon_state = "horsepoo"

/obj/item/natural/poo/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Nightsoil can be used as fertilizer, in order to improve a crop's health. To do so, left-click the crop or its soil while holding the nightsoil.")
