/datum/roguestock/stockpile/apple
	name = "Apple"
	desc = "Harvested produce."
	item_type = /obj/item/reagent_containers/food/snacks/grown/apple
	held_items = list(0, 0)
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	passive_generation = 3 // Apple here remain a clutch for wandering nobles because of sliced??? So higher amount
	stockpile_limit = 50
	category = "Fruit"

/datum/roguestock/stockpile/pear
	name = "Pear"
	desc = "Too sweet for many, a favored treat for little ones. Dwarves do love them."
	item_type = /obj/item/reagent_containers/food/snacks/grown/fruit/pear
	held_items = list(0, 4)
	payout_price = 2
	withdraw_price = 2
	export_price = 3
	importexport_amt = 5
	passive_generation = 2
	stockpile_limit = 25
	category = "Fruit"

/datum/roguestock/stockpile/jacksberry
	name = "Jacksberries"
	desc = "Sweet berries, prime for winemaking."
	item_type = /obj/item/reagent_containers/food/snacks/grown/berries/rogue
	held_items = list(0, 0)
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50 // Jackberries are used to mass produce raisins so higher limit
	passive_generation = 2
	category = "Fruit"

/datum/roguestock/stockpile/blackberry
	name = "Blackberry"
	desc = "A small, dark fruit with a sweet and slightly tart taste. It is often used in desserts."
	item_type = /obj/item/reagent_containers/food/snacks/grown/fruit/blackberry

	held_items = list(0, 0)
	held_random_upper = 3
	held_random_lower = 1
	nothing_chance = 40
	export_only = TRUE

	payout_price = 2
	withdraw_price = 6
	transport_fee = 5
	export_price = 3
	importexport_amt = 5
	passive_generation = 0
	stockpile_limit = 25
	category = "Fruit"

/datum/roguestock/stockpile/raspberry
	name = "Raspberry"
	desc = "A small, red fruit with a sweet and slightly tart taste. It is often used in desserts."
	item_type = /obj/item/reagent_containers/food/snacks/grown/fruit/raspberry

	held_items = list(0, 0)
	held_random_upper = 3
	held_random_lower = 1
	nothing_chance = 40
	export_only = TRUE

	payout_price = 2
	withdraw_price = 6
	transport_fee = 5
	export_price = 3
	importexport_amt = 5
	passive_generation = 0
	stockpile_limit = 25
	category = "Fruit"

/datum/roguestock/stockpile/strawberry
	name = "Strawberry"
	desc = "A small, red fruit with a sweet taste. It is often used in desserts."
	item_type = /obj/item/reagent_containers/food/snacks/grown/fruit/strawberry

	held_items = list(0, 0)
	held_random_upper = 3
	held_random_lower = 1
	nothing_chance = 40
	export_only = TRUE

	payout_price = 2
	withdraw_price = 6
	transport_fee = 5
	export_price = 3
	importexport_amt = 5
	passive_generation = 0
	stockpile_limit = 25
	category = "Fruit"

/datum/roguestock/stockpile/lemon
	name = "Lemon"
	desc = "Too sweet for many, a favored treat for little ones. Dwarves do love them."
	item_type = /obj/item/reagent_containers/food/snacks/grown/fruit/lemon

	held_items = list(0, 0)
	held_random_upper = 3
	held_random_lower = 1
	nothing_chance = 40
	export_only = TRUE

	payout_price = 2
	withdraw_price = 6
	transport_fee = 5
	export_price = 3
	importexport_amt = 5
	passive_generation = 0
	stockpile_limit = 25
	category = "Fruit"

/datum/roguestock/stockpile/lime
	name = "Lime"
	desc = "Too sweet for many, a favored treat for little ones. Dwarves do love them."
	item_type = /obj/item/reagent_containers/food/snacks/grown/fruit/lime

	held_items = list(0, 0)
	held_random_upper = 3
	held_random_lower = 1
	nothing_chance = 40
	export_only = TRUE

	payout_price = 2
	withdraw_price = 6
	transport_fee = 5
	export_price = 3
	importexport_amt = 5
	passive_generation = 0
	stockpile_limit = 25
	category = "Fruit"

/datum/roguestock/stockpile/tangerine
	name = "Tangerine"
	desc = "Too sweet for many, a favored treat for little ones. Dwarves do love them."
	item_type = /obj/item/reagent_containers/food/snacks/grown/fruit/tangerine

	held_items = list(0, 0)
	held_random_upper = 3
	held_random_lower = 1
	nothing_chance = 40
	export_only = TRUE

	payout_price = 2
	withdraw_price = 6
	transport_fee = 5
	export_price = 3
	importexport_amt = 5
	passive_generation = 0
	stockpile_limit = 25
	category = "Fruit"

/datum/roguestock/stockpile/plum
	name = "Plum"
	desc = "Too sweet for many, a favored treat for little ones. Dwarves do love them."
	item_type = /obj/item/reagent_containers/food/snacks/grown/fruit/plum

	held_items = list(0, 0)
	held_random_upper = 3
	held_random_lower = 1
	nothing_chance = 40
	export_only = TRUE

	payout_price = 2
	withdraw_price = 6
	transport_fee = 5
	export_price = 3
	importexport_amt = 5
	passive_generation = 0
	stockpile_limit = 25
	category = "Fruit"

/datum/roguestock/stockpile/tomato
	name = "Tomato"
	desc = "A red fruit that is often mistaken for a vegetable. It is commonly used in salads and sauces."
	item_type = /obj/item/reagent_containers/food/snacks/grown/fruit/tomato
	held_items = list(0, 4)
	payout_price = 2
	withdraw_price = 2
	export_price = 3
	importexport_amt = 5
	passive_generation = 2
	stockpile_limit = 25
	category = "Fruit"

/datum/roguestock/stockpile/pumpkin
	name = "Pumpkin"
	desc = "The thick pumpkin rind shields a surprisingly dense fleshy interior."
	item_type = /obj/item/natural/shellplant/pumpkin
	held_items = list(0, 4)
	payout_price = 2
	withdraw_price = 3
	export_price = 4
	importexport_amt = 5
	passive_generation = 2
	stockpile_limit = 25
	category = "Fruit"
