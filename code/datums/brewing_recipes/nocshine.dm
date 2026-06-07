/datum/brewing_recipe/nocmash
	name = "Noc Mash"
	category = "Grain"
	bottle_name = "noc mash"
	bottle_desc = "A bottle of harsh, grain-fortified distillate. An unfinished step toward Noc's Shine."
	reagent_to_brew = /datum/reagent/consumable/ethanol/nocmash
	output_bottle_type = /obj/item/reagent_containers/glass/bottle/brewing_bottle/nocmash
	pre_reqs = /datum/reagent/consumable/ethanol/voddena
	needed_items = list(/obj/item/reagent_containers/food/snacks/grown/wheat = 6)
	brewed_amount = 4
	brew_time = 5 MINUTES
	sell_value = 20
	heat_required = 370
	helpful_hints = "Distill Voddena with wheat. The first of two distillations on the way to Noc's Shine"

/datum/brewing_recipe/nocshine
	name = "Noc's Shine"
	category = "Liquor"
	bottle_name = "noc's shine"
	bottle_desc = "An unmarked bottle with a distinctively blue-greenish liquor inside. Extremely potent, usable for cleaning wounds. Said to strengthen the body, and destroy the mind."
	reagent_to_brew = /datum/reagent/consumable/ethanol/nocshine
	output_bottle_type = /obj/item/reagent_containers/glass/bottle/brewing_bottle/nocshine
	pre_reqs = /datum/reagent/consumable/ethanol/nocmash
	needed_items = list(/obj/item/reagent_containers/food/snacks/grown/rogue/swampweed = 6)
	brewed_amount = 4
	brew_time = 6 MINUTES
	sell_value = 160
	heat_required = 370
	helpful_hints = "Distill Noc Mash with swampweed."
