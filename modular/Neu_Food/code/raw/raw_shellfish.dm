
// Raw Shellfish. Separate folder due to sprites
/obj/item/reagent_containers/food/snacks/fish/crab
	name = "crab"
	desc = "A shellfish with large claws and a tough shell. It is a hassle to crack open, but tastes great when cooked whole with spices and butter, or made into cakes. In Rosawood, they are eaten with elaborate tools, said to be brought from the far east, so that the crab can be eaten without dirtying your hands and reassembled afterwards. In Kingsfield, people make it into a cake or just crack it open and eat it with their hands. It is said that crabs can be lured out of the water by playing a special tune on a flute, and that they can be caught once they are out of the water."
	// Reference to the "two ways" of eating crabs in China + Aelian's passage on luring crab. Not actually mechanical
	icon_state = "crab"
	fish_id = "crab"
	average_size = 2
	average_weight = 1
	required_fluid_type = FISH_FLUID_SALTWATER
	fish_movement_type = /datum/fish_movement/choppy
	fish_traits = list(/datum/fish_trait/heavy)
	favorite_bait = list(
		list(
			FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
			FISH_BAIT_VALUE = DISH_MEAT,
		),
		/obj/item/fishing/bait/shell,
	)
	faretype = FARE_NEUTRAL
	sellprice = FISH_PRICE_GOOD
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/crab
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/crab
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/crab
	cooked_smell = /datum/pollutant/food/fried_crab

/obj/item/reagent_containers/food/snacks/fish/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Chopping fish on a table with a knife, cleaver, or dagger turns it into mince. Mince can be used for advanced recipes, or used to make 'more out of less' in a stew's broth.")

/obj/item/reagent_containers/food/snacks/fish/clam
	name = "clam"
	desc = "A shelled beast that Abyssorites say was built in the image of a knight. Hard shell, squishy interior. Though clams have not much meat, they are found and hauled in abundance from the sea bed, and have sweet and tender flesh."
	icon_state = "clam"
	fish_id = "clam"
	average_size = 0.8
	average_weight = 0.2
	required_fluid_type = FISH_FLUID_SALTWATER
	fishing_difficulty_modifier = -10
	fish_movement_type = /datum/fish_movement/slow
	fish_traits = list(/datum/fish_trait/vegan, /datum/fish_trait/heavy)
	faretype = FARE_FINE
	no_rarity_sprite = TRUE
	sellprice = FISH_PRICE_FINE
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/clam
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/clam
	cooked_smell = /datum/pollutant/food/fried_shellfish

/obj/item/reagent_containers/food/snacks/fish/lobster
	name = "lobster"
	desc = "The lobster is a bloodless creechur, protected by a fragile rind. They stay in the water for five months every yil without rest, and battle each other with their claws for territory. They are quite a delicacy, and are often boiled alive to ensure they are fresh. However, this practice has fallen out of use in Azuria due to the cruelty of it after advocacy by Abyssorite and Dendorite clerics, and now they are often killed by a quick blow to the head with a special knife. They are often served with butter and spices."
	icon_state = "lobster"
	fish_id = "lobster"
	average_size = 4
	average_weight = 3
	required_fluid_type = FISH_FLUID_SALTWATER
	fishing_difficulty_modifier = 5
	fish_movement_type = /datum/fish_movement/slow
	favorite_bait = list(
		list(
			FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
			FISH_BAIT_VALUE = DISH_MEAT,
		),
		/obj/item/fishing/bait/shell,
	)
	fish_traits = list(/datum/fish_trait/heavy)
	faretype = FARE_FINE
	no_rarity_sprite = TRUE
	sellprice = FISH_PRICE_FINE
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/lobster
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/lobster
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/shellfish
	cooked_smell = /datum/pollutant/food/fried_shellfish

/obj/item/reagent_containers/food/snacks/fish/shrimp
	name = "shrimp"
	desc = "A tiny fish, little bigger than a thumb. They are found in utter abundance in the northern coast of Azuria. The shell is soft and troublesome, but the meat is sweet and tender, and it might be the best meat a commoner can afford every week or two."
	icon_state = "shrimp"
	fish_id = "shrimp"
	average_size = 0.5
	average_weight = 0.01
	required_fluid_type = FISH_FLUID_SALTWATER
	fishing_difficulty_modifier = -5
	fish_movement_type = /datum/fish_movement/slow
	favorite_bait = list(
		list(
			FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
			FISH_BAIT_VALUE = DISH_VEGETABLE,
		),
		/obj/item/fishing/bait/dough,
		/obj/item/fishing/bait/gray,
		/obj/item/fishing/bait/shell,
	)
	sellprice = FISH_PRICE_FAIR
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/shrimp
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/shrimp
	cooked_smell = /datum/pollutant/food/fried_shellfish

/obj/item/reagent_containers/food/snacks/fish/oyster
	name = "oyster"
	desc = "A stubborn, shelled fish that has no sense and acts more like a plant, akin to the sea-cucumber. It can be opened with a knife to reveal the flesh within. It is said that women on the Isle of Glass dive down to retrieve the most precious of pearls and oysters, alongside Azurian glasses."
	icon_state = "oyster"
	fish_id = "oyster"
	average_size = 0.8
	average_weight = 0.2
	required_fluid_type = FISH_FLUID_SALTWATER
	fishing_difficulty_modifier = -10
	fish_movement_type = /datum/fish_movement/slow
	fish_traits = list(/datum/fish_trait/vegan, /datum/fish_trait/heavy)
	faretype = FARE_POOR
	sellprice = FISH_PRICE_COMMON
	var/closed
	var/obj/item/pearl
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/shellfish
	trash = /obj/item/oystershell
	cooked_smell = /datum/pollutant/food/fried_shellfish

/obj/item/reagent_containers/food/snacks/fish/oyster/Initialize(mapload)
	. = ..()
	closed = TRUE

// Pearl distribution is based on rarity. This helper make it roll when it is opened after its rarity is settled after fishing minigame
/obj/item/reagent_containers/food/snacks/fish/oyster/proc/roll_pearl()
	var/pearl_weight
	switch(rarity_rank)
		if(FISH_RARITY_LEGENDARY)
			pearl_weight = pickweight(list("bpearl" = 200, "pearl" =15, "nopearl"=15))
		if(FISH_RARITY_ULTRA)
			pearl_weight = pickweight(list("bpearl" = 60, "pearl" =120, "nopearl"=35))
		if(FISH_RARITY_RARE)
			pearl_weight = pickweight(list("bpearl" = 40, "pearl" =80, "nopearl"=150))
		else
			pearl_weight = pickweight(list("bpearl" = 10, "pearl" =40, "nopearl"=200))
	switch(pearl_weight)
		if("pearl")
			pearl = new /obj/item/pearl(src)
		if("bpearl")
			pearl = new /obj/item/pearl/blue(src)

/obj/item/reagent_containers/food/snacks/fish/oyster/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/rogueweapon/huntingknife))
		if(closed)
			user.visible_message("<span class='notice'>[user] opens the oyster with the knife.</span>")
			closed = FALSE
			roll_pearl()
			icon_state = "[icon_state]_open"
			update_icon()
		else
			if(slice(src, user))
				new /obj/item/oystershell(user.loc)
				new /obj/item/oystershell(user.loc)
	else
		. = ..()

/obj/item/reagent_containers/food/snacks/fish/oyster/attack_right(mob/user)
	if(user.get_active_held_item())
		return
	else
		if(pearl)
			user.put_in_hands(pearl)
			pearl = null
			update_icon()
	. = ..()

/obj/item/reagent_containers/food/snacks/fish/oyster/update_icon()
	cut_overlays()
	if(!closed && pearl)
		var/mutable_appearance/pearl = mutable_appearance(icon, "pearl")
		add_overlay(pearl)

/obj/item/oystershell
	name = "oyster shell"
	icon = 'modular/Neu_food/icons/raw/raw_fish.dmi'
	icon_state = "oyster_shell"
	desc = ""
	dropshrink = 0.5
	w_class = WEIGHT_CLASS_TINY
	sellprice = 3
	grid_height = 32
	grid_width = 32

// Close enough crab cake is raw shellfish
/obj/item/reagent_containers/food/snacks/rogue/foodbase/crabcakeraw
	cuisine = CUISINE_SOUTH_IMPERIAL
	dish_type = DISH_SEAFOOD|DISH_DAIRY
	name = "raw crab cake"
	desc = "A variant of the handpie filled with buttery, savory shellfish meat and made with a buttered slice of dough."
	icon = 'modular/Neu_Food/icons/raw/raw_fish.dmi' // I guess it is a raw fish meal
	icon_state = "crab_cake_raw"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/crabcake
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/crabcake
	cooked_smell = /datum/pollutant/food/fried_crab_cake
	w_class = WEIGHT_CLASS_NORMAL
	dropshrink = 0.8
