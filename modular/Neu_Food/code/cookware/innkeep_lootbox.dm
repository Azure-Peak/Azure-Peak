/obj/item/ration_lootbox
	name = "mysterious ration package"
	desc = "An unassuming paper bundle. It feels surprisingly heavy, like it contains a bounty of assorted goodies. Perhaps a RIGHT hand can reveal the bounty?"
	icon = 'modular/Neu_food/icons/cookware/ration.dmi'
	icon_state = "ration_large"
	w_class = WEIGHT_CLASS_HUGE
	grid_height = 32
	grid_width = 32
	color = "#b58fe6"

/obj/item/ration_lootbox/attack_right(mob/user)
	..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(do_after(H, 20, target = src))
		to_chat(H, span_notice("You unwrap the mysterious package..."))
		var/list/loot_table = list(
			/obj/item/reagent_containers/food/snacks/chocolate,
			/obj/item/reagent_containers/food/snacks/dragee,
			/obj/item/reagent_containers/food/snacks/caramel,
			/obj/item/reagent_containers/food/snacks/rogue/raisins,
			/obj/item/reagent_containers/food/snacks/rogue/raisins/raspberry,
			/obj/item/reagent_containers/food/snacks/rogue/raisins/strawberry,
			/obj/item/reagent_containers/food/snacks/rogue/raisins/blackberry,
			/obj/item/reagent_containers/food/snacks/rogue/raisins/plum,
			/obj/item/reagent_containers/food/snacks/rogue/raisins/pear,
			/obj/item/reagent_containers/food/snacks/rogue/raisins/tangerine,
			/obj/item/reagent_containers/food/snacks/rogue/raisins/lemon,
			/obj/item/reagent_containers/food/snacks/rogue/raisins/lime,
			/obj/item/reagent_containers/food/snacks/rogue/pesto,
			/obj/item/reagent_containers/food/snacks/rogue/truffles,
			/obj/item/reagent_containers/food/snacks/rogue/mushroom,
			/obj/item/reagent_containers/food/snacks/rogue/fruit/pumpkin_sliced,
			/obj/item/reagent_containers/food/snacks/rogue/preserved/pumpkin_mashed,
			/obj/item/reagent_containers/food/snacks/grown/rice,
			/obj/item/reagent_containers/food/snacks/fish/sole,
			/obj/item/reagent_containers/food/snacks/fish/cod,
			/obj/item/reagent_containers/food/snacks/fish/lobster,
			/obj/item/reagent_containers/food/snacks/fish/salmon,
			/obj/item/reagent_containers/food/snacks/fish/plaice,
			/obj/item/reagent_containers/food/snacks/fish/bass,
			/obj/item/reagent_containers/food/snacks/fish/clam,
			/obj/item/reagent_containers/food/snacks/fish/shrimp,
			/obj/item/reagent_containers/food/snacks/grown/tea,
			/obj/item/reagent_containers/food/snacks/grown/coffeebeansroasted,
			/obj/item/reagent_containers/food/snacks/pumpkinspice,
			/obj/item/reagent_containers/powder/rocknut,
			/obj/item/reagent_containers/food/snacks/grown/fruit/lemon,
			/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry,
			/obj/item/reagent_containers/food/snacks/grown/fruit/lime,
			/obj/item/reagent_containers/food/snacks/grown/fruit/pear,
			/obj/item/reagent_containers/food/snacks/grown/fruit/plum,
			/obj/item/reagent_containers/food/snacks/grown/fruit/raspberry,
			/obj/item/reagent_containers/food/snacks/grown/fruit/strawberry,
			/obj/item/reagent_containers/food/snacks/grown/fruit/tangerine,
			/obj/item/reagent_containers/food/snacks/grown/fruit/tomato,
			/obj/item/reagent_containers/food/snacks/grown/maize,
			/obj/item/reagent_containers/food/snacks/rogue/meat/bacon,
			/obj/item/reagent_containers/food/snacks/rogue/meat/ham,
			/obj/item/reagent_containers/food/snacks/rogue/meat/bear,
			/obj/item/reagent_containers/food/snacks/rogue/meat/saiga,
			/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs,
			/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_z,
			/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs_z
		)

		var/num_items = rand(9, 15)
		var/loot_turf = get_turf(src)
		for(var/i in 1 to num_items)
			var/item_type = pick(loot_table)
			new item_type(loot_turf)

		qdel(src)
