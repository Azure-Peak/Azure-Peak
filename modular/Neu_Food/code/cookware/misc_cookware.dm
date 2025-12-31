// Please only put REALLY, REALLY MISCELLANEOUS stuff in here. Like rolling pins
/obj/item/kitchen/rollingpin
	name = "rolling pin"
	desc = "A wooden implement designed to flatten dough."
	icon = 'modular/Neu_Food/icons/cookware/misc.dmi'
	icon_state = "rolling_pin"
	force = 8
	throwforce = 5
	throw_speed = 1
	throw_range = 7
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb = list("bashed", "battered", "bludgeoned", "thrashed", "whacked")
	custom_price = 20
	grid_width = 32
	grid_height = 64

/obj/item/kitchen/rollingpin/suicide_act(mob/living/carbon/user)
	user.visible_message("<span class='suicide'>[user] begins flattening [user.p_their()] head with \the [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return BRUTELOSS

/obj/item/tablecloth/silk
	name = "silk tablecloth"
	desc = "A fancy silk tablecloth, laid out for diplomatic feasts and other important events."
	icon = 'modular/Neu_Food/icons/cookware/misc.dmi'
	icon_state = "tablecloth_silk"
	sellprice = 40
	w_class = WEIGHT_CLASS_NORMAL
