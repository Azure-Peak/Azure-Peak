// Food that is primarily made out of a cooked fruit component.
/*	.............   Cooked pumpkin   ................ */
/obj/item/reagent_containers/food/snacks/rogue/preserved/pumpkin_mashed
	name = "cooked pumpkin mash"
	icon = 'modular/Neu_Food/icons/cooked/cooked_fruits.dmi'
	icon_state = "pumpkinmash"
	desc = "Once bland, now a surprisingly rich and fibrous mash."
	faretype = FARE_POOR
	portable = FALSE
	bitesize = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	rotprocess = SHELFLIFE_LONG