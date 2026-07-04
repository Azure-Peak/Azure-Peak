/* File for raw pie and pie making recipes
This account for the "BIG PIE", please do not creep this file or the .dmi for small pie.
*/

/*	........   Pie making   ................ */
/obj/item/reagent_containers/food/snacks/rogue/foodbase/piebottom
	name = "pie bottom"
	desc = "The foundation of the fantastical.."
	icon = 'modular/Neu_Food/icons/raw/raw_pies.dmi'
	icon_state = "piebottom"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = /datum/status_effect/debuff/uncookedfood
	cooked_smell = /datum/pollutant/food/pie_base
