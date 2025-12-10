/datum/alch_grind_recipe/sinew
	valid_input = /obj/item/alch/sinew
	valid_outputs = list(/obj/item/alch/viscera = 1)
	bonus_chance_outputs = list(/obj/item/alch/viscera = 75)

//Runes -> dust
// Unused for now not clogging up the grind recipes
// /datum/alch_grind_recipe/fire_rune
// 	valid_input = /obj/item/rune/spell/fire_rune
// 	valid_outputs = list(/obj/item/alch/firedust = 2)
// 	bonus_chance_outputs = list(/obj/item/alch/firedust = 33)

// /datum/alch_grind_recipe/water_rune
// 	valid_input = /obj/item/rune/spell/water_rune
// 	valid_outputs = list(/obj/item/alch/waterdust = 2)
// 	bonus_chance_outputs = list(/obj/item/alch/waterdust = 33)

// /datum/alch_grind_recipe/air_rune
// 	valid_input = /obj/item/rune/spell/air_rune
// 	valid_outputs = list(/obj/item/alch/airdust = 2)
// 	bonus_chance_outputs = list(/obj/item/alch/airdust = 33)

// /datum/alch_grind_recipe/earth_rune
// 	valid_input = /obj/item/rune/spell/earth_rune
// 	valid_outputs = list(/obj/item/alch/earthdust = 2)
// 	bonus_chance_outputs = list(/obj/item/alch/earthdust = 33)

// /datum/alch_grind_recipe/blank_rune
// 	valid_input = /obj/item/rune/spell/blank_rune
// 	valid_outputs = list(/obj/item/alch/runedust = 2)
// 	bonus_chance_outputs = list(/obj/item/alch/runedust = 33)

//Objects -> dusts
/datum/alch_grind_recipe/crow
	name = "Crow"
	valid_input = /obj/item/reagent_containers/food/snacks/crow
	valid_outputs = list(/obj/item/alch/airdust = 1)
	bonus_chance_outputs = list(/obj/item/alch/airdust = 33)

/datum/alch_grind_recipe/bone
	name = "Bone"
	valid_input = /obj/item/alch/bone
	valid_outputs = list( /obj/item/alch/bonemeal = 2)
	bonus_chance_outputs = list(/obj/item/alch/bonemeal = 50)

/datum/alch_grind_recipe/horn

	valid_input = /obj/item/alch/horn
	valid_outputs = list(/obj/item/alch/earthdust = 1,/obj/item/alch/bonemeal = 2)
	bonus_chance_outputs = list(/obj/item/alch/earthdust = 66)

/datum/alch_grind_recipe/fish
	name = "Fish"
	picky = FALSE
	valid_input = /obj/item/reagent_containers/food/snacks/fish
	valid_outputs = list(/obj/item/alch/waterdust = 1)
	bonus_chance_outputs = list(/obj/item/alch/bonemeal = 50)

/datum/alch_grind_recipe/swampweed
	name = "Swampweed"
	valid_input = /obj/item/reagent_containers/food/snacks/grown/rogue/swampweed
	valid_outputs = list(/obj/item/alch/swampdust = 1)
	bonus_chance_outputs = list(/obj/item/alch/earthdust = 33)

/datum/alch_grind_recipe/swampweed_dried
	name = "Dried Swampweed"
	valid_input = /obj/item/reagent_containers/food/snacks/grown/rogue/swampweeddry
	valid_outputs = list(/obj/item/alch/swampdust = 1)
	bonus_chance_outputs = list(/obj/item/alch/earthdust = 50,/obj/item/alch/swampdust = 50)

/datum/alch_grind_recipe/westleach
	name = "Westleach"
	valid_input = /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed
	valid_outputs = list(/obj/item/alch/tobaccodust = 1)
	bonus_chance_outputs = list(/obj/item/alch/airdust = 33)

/datum/alch_grind_recipe/dry_westleach
	name = "Dried Westleach"
	valid_input = /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry
	valid_outputs = list(/obj/item/alch/tobaccodust = 1)
	bonus_chance_outputs = list(/obj/item/alch/airdust = 50,/obj/item/alch/tobaccodust = 50)

/datum/alch_grind_recipe/fyritius
	name = "Fyritius"
	valid_input = /obj/item/reagent_containers/food/snacks/grown/rogue/fyritius
	valid_outputs = list(/obj/item/alch/firedust = 1)
	bonus_chance_outputs = list(/obj/item/alch/solardust = 50)

/datum/alch_grind_recipe/poppy
	name = "Poppy"
	valid_input = /obj/item/reagent_containers/food/snacks/grown/rogue/poppy
	valid_outputs = list(/obj/item/reagent_containers/powder/ozium = 1)
	bonus_chance_outputs = list(/obj/item/alch/airdust =33,/obj/item/alch/earthdust = 33)

/datum/alch_grind_recipe/seeds
	name = "Seeds"
	picky = FALSE
	valid_input = /obj/item/seeds
	valid_outputs = list(/obj/item/alch/seeddust = 1)
	bonus_chance_outputs = list(/obj/item/alch/airdust =25,/obj/item/alch/earthdust = 25)

/datum/alch_grind_recipe/seedsherb
	name = "Herb Seeds"
	picky = FALSE
	valid_input = /obj/item/herbseed
	valid_outputs = list(/obj/item/alch/seeddust = 1)
	bonus_chance_outputs = list(/obj/item/alch/airdust =25,/obj/item/alch/earthdust = 25)

/datum/alch_grind_recipe/ozium
	name = "Ozium"
	valid_input = /obj/item/reagent_containers/powder/ozium
	valid_outputs = list(/obj/item/alch/ozium = 1)
	bonus_chance_outputs = list(/obj/item/alch/airdust =25,/obj/item/alch/ozium = 25)

/datum/alch_grind_recipe/sunflower
	name = "Sunflower"
	valid_input = /obj/item/reagent_containers/food/snacks/grown/sunflower
	valid_outputs = list(/obj/item/alch/solardust = 1)
	bonus_chance_outputs = list(/obj/item/alch/firedust = 25)

/datum/alch_grind_recipe/scrap
	name = "Scrap"
	valid_input = /obj/item/scrap
	valid_outputs = list(/obj/item/alch/irondust = 1)
	bonus_chance_outputs = list(/obj/item/alch/runedust = 10)

//Ores -> dust
/datum/alch_grind_recipe/gold_ore
	name = "Gold Ore"
	valid_input = /obj/item/rogueore/gold
	valid_outputs = list(/obj/item/alch/golddust = 1)
	bonus_chance_outputs = list(/obj/item/alch/golddust = 33)

/datum/alch_grind_recipe/silver_ore
	name = "Silver Ore"
	valid_input = /obj/item/rogueore/silver
	valid_outputs = list(/obj/item/alch/silverdust = 1)
	bonus_chance_outputs = list(/obj/item/alch/silverdust = 33)

/datum/alch_grind_recipe/iron_ore
	name = "Iron Ore"
	valid_input = /obj/item/rogueore/iron
	valid_outputs = list(/obj/item/alch/irondust = 1)
	bonus_chance_outputs = list(/obj/item/alch/irondust = 33, /obj/item/alch/runedust = 25)

/datum/alch_grind_recipe/coal_ore
	name = "Coal Ore"
	valid_input = /obj/item/rogueore/coal
	valid_outputs = list(/obj/item/alch/coaldust = 1)
	bonus_chance_outputs = list(/obj/item/alch/coaldust = 33, /obj/item/alch/firedust = 25)

/datum/alch_grind_recipe/gold_bar
	name = "Gold Bar"
	valid_input = /obj/item/ingot/gold
	valid_outputs = list(/obj/item/alch/golddust = 1)
	bonus_chance_outputs = list(/obj/item/alch/golddust = 33, /obj/item/alch/firedust = 25)

/datum/alch_grind_recipe/silver_bar
	name = "Silver Bar"
	valid_input = /obj/item/ingot/silver
	valid_outputs = list(/obj/item/alch/silverdust = 1)
	bonus_chance_outputs = list(/obj/item/alch/silverdust = 33, /obj/item/alch/firedust = 25)

/datum/alch_grind_recipe/blessed_silver_bar
	name = "Blessed Silver Bar"
	valid_input = /obj/item/ingot/silverblessed
	valid_outputs = list(/obj/item/alch/silverdust = 1)
	bonus_chance_outputs = list(/obj/item/alch/silverdust = 33, /obj/item/alch/firedust = 25)

/datum/alch_grind_recipe/iron_bar
	name = "Iron Bar"
	valid_input = /obj/item/ingot/iron
	valid_outputs = list(/obj/item/alch/irondust = 1)
	bonus_chance_outputs = list(/obj/item/alch/irondust = 33, /obj/item/alch/runedust = 25, /obj/item/alch/firedust = 25)

/datum/alch_grind_recipe/puresalt
	name = "Pure Salt"
	valid_input = /obj/item/reagent_containers/powder/salt
	valid_outputs = list(/obj/item/alch/puresalt = 1)

/datum/alch_grind_recipe/berrypowder
	name = "Berry Powder"
	valid_input = /obj/item/reagent_containers/food/snacks/grown/berries/rogue
	valid_outputs = list(/obj/item/alch/berrypowder = 1)
	bonus_chance_outputs = list(/obj/item/alch/waterdust = 25)

/datum/alch_grind_recipe/manabloompowder
	name = "Manabloom Powder"
	valid_input = /obj/item/reagent_containers/food/snacks/grown/manabloom
	valid_outputs = list(/obj/item/alch/manabloompowder = 1)
	bonus_chance_outputs = list(/obj/item/alch/manabloompowder = 25)

/datum/alch_grind_recipe/infernaldust
	name = "Infernal Dust"
	valid_input = /obj/item/magic/infernal/fang
	valid_outputs = list(/obj/item/alch/infernaldust = 1)
	bonus_chance_outputs = list(/obj/item/alch/firedust = 25)

// Start of gem dust section - I've included gold dust as an additional product because of lesser alchemy, grinding up a gem should give you a bit extra (I mean come on it's a gem)

/datum/alch_grind_recipe/mineraldustyellow  // costs two gold to make
	name = "Mineral Dust (Toper)"
	valid_input = /obj/item/roguegem/yellow
	valid_outputs = list(/obj/item/alch/mineraldust = 1, /obj/item/alch/golddust = 1)
	bonus_chance_outputs = list(/obj/item/alch/golddust = 66)

/datum/alch_grind_recipe/mineraldustgreen  // costs 4 gold to make
	name = "Mineral Dust (Gemerald)"
	valid_input = /obj/item/roguegem/green
	valid_outputs = list(/obj/item/alch/mineraldust = 1, /obj/item/alch/earthdust = 1, /obj/item/alch/golddust = 2)
	bonus_chance_outputs = list(/obj/item/alch/earthdust = 66)

/datum/alch_grind_recipe/mineraldustviolet // costs 6 gold to make
	name = "Mineral Dust (Saffira)"
	valid_input = /obj/item/roguegem/violet
	valid_outputs = list(/obj/item/alch/mineraldust = 1, /obj/item/alch/magicdust = 1, /obj/item/alch/golddust = 3)
	bonus_chance_outputs = list(/obj/item/alch/magicdust = 66)

/datum/alch_grind_recipe/mineraldustblue // costs 8 gold to make
	name = "Mineral Dust (Blortz)"
	valid_input = /obj/item/roguegem/blue
	valid_outputs = list(/obj/item/alch/mineraldust = 1, /obj/item/alch/waterdust = 2, /obj/item/alch/golddust = 4)
	bonus_chance_outputs = list(/obj/item/alch/waterdust = 66)

/datum/alch_grind_recipe/mineraldustdiamond // costs a whopping 18 gold to make, why are you doing this
	name = "Mineral Dust (Diamond)"
	valid_input = /obj/item/roguegem/diamond
	valid_outputs = list(/obj/item/alch/mineraldust = 1, /obj/item/alch/golddust = 6)
	bonus_chance_outputs = list(/obj/item/alch/golddust = 66)

/datum/alch_grind_recipe/mineraldustriddle //why are you doing this...
	name = "Mineral Dust (Riddle of Steel)"
	valid_input = /obj/item/riddleofsteel
	valid_outputs = list(/obj/item/alch/mineraldust = 2, /obj/item/alch/airdust = 1, /obj/item/alch/irondust = 1, /obj/item/alch/firedust = 1, /obj/item/alch/magicdust = 1, /obj/item/alch/silverdust = 1, /obj/item/alch/coaldust = 1, /obj/item/alch/runedust = 1, /obj/item/alch/waterdust = 1)  // if you're crazy enough to grind a riddle you should get at LEAST one of every dust.
	bonus_chance_outputs = list(/obj/item/alch/mineraldust = 25, /obj/item/alch/airdust = 25, /obj/item/alch/irondust = 25, /obj/item/alch/firedust = 25, /obj/item/alch/magicdust = 25, /obj/item/alch/silverdust = 25, /obj/item/alch/coaldust = 25, /obj/item/alch/runedust = 25, /obj/item/alch/waterdust = 25)

// End of gem dust section


//Herb -> Herbseed
/datum/alch_grind_recipe/atropa_seed
	name = "Herb Seed (Atropa)"
	valid_input = /obj/item/alch/atropa
	valid_outputs = list(/obj/item/herbseed/atropa = 1)

/datum/alch_grind_recipe/matricaria_seed
	name = "Herb Seed (Matricaria)"
	valid_input = /obj/item/alch/matricaria
	valid_outputs = list(/obj/item/herbseed/matricaria = 1)

/datum/alch_grind_recipe/symphitum_seed
	name = "Herb Seed (Symphitum)"
	valid_input = /obj/item/alch/symphitum
	valid_outputs = list(/obj/item/herbseed/symphitum = 1)

/datum/alch_grind_recipe/taraxacum_seed
	name = "Herb Seed (Taraxacum)"
	valid_input = /obj/item/alch/taraxacum
	valid_outputs = list(/obj/item/herbseed/taraxacum = 1)

/datum/alch_grind_recipe/euphrasia_seed
	name = "Herb Seed (Euphrasia)"
	valid_input = /obj/item/alch/euphrasia
	valid_outputs = list(/obj/item/herbseed/euphrasia = 1)

/datum/alch_grind_recipe/paris_seed
	name = "Herb Seed (Paris)"
	valid_input = /obj/item/alch/paris
	valid_outputs = list(/obj/item/herbseed/paris = 1)

/datum/alch_grind_recipe/calendula_seed
	name = "Herb Seed (Calendula)"
	valid_input = /obj/item/alch/calendula
	valid_outputs = list(/obj/item/herbseed/calendula = 1)

/datum/alch_grind_recipe/mentha_seed
	name = "Herb Seed (Mentha)"
	valid_input = /obj/item/alch/mentha
	valid_outputs = list(/obj/item/herbseed/mentha = 1)

/datum/alch_grind_recipe/urtica_seed
	name = "Herb Seed (Urtica)"
	valid_input = /obj/item/alch/urtica
	valid_outputs = list(/obj/item/herbseed/urtica = 1)

/datum/alch_grind_recipe/salvia_seed
	name = "Herb Seed (Salvia)"
	valid_input = /obj/item/alch/salvia
	valid_outputs = list(/obj/item/herbseed/salvia = 1)

/datum/alch_grind_recipe/hypericum_seed
	name = "Herb Seed (Hypericum)"
	valid_input = /obj/item/alch/hypericum
	valid_outputs = list(/obj/item/herbseed/hypericum = 1)

/datum/alch_grind_recipe/benedictus_seed
	name = "Herb Seed (Benedictus)"
	valid_input = /obj/item/alch/benedictus
	valid_outputs = list(/obj/item/herbseed/benedictus = 1)

/datum/alch_grind_recipe/valeriana_seed
	name = "Herb Seed (Valeriana)"
	valid_input = /obj/item/alch/valeriana
	valid_outputs = list(/obj/item/herbseed/valeriana = 1)

/datum/alch_grind_recipe/artemisia_seed
	name = "Herb Seed (Artemisia)"
	valid_input = /obj/item/alch/artemisia
	valid_outputs = list(/obj/item/herbseed/artemisia = 1)

/datum/alch_grind_recipe/rosa_seed
	name = "Herb Seed (Rosa)"
	valid_input = /obj/item/alch/rosa
	valid_outputs = list(/obj/item/herbseed/rosa = 1)
