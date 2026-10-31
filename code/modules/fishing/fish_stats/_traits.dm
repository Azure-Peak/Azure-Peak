///A global list of singleton fish traits by their paths
GLOBAL_LIST_INIT(fish_traits, init_subtypes_w_path_keys(/datum/fish_trait, list()))

/datum/fish_trait
	var/name = "Unnamed Trait"
	/// Description of the trait in the fishing catalog and scanner
	var/catalog_description = "Uh uh, someone has forgotten to set description to this trait. Yikes!"
	///A list of traits fish cannot have in conjunction with this trait.
	var/list/incompatible_traits
	/// Depending on the value, fish with trait will be reported as more or less difficult in the catalog.
	var/added_difficulty = 0

/// Difficulty modifier from this mod, needs to return a list with two values
/datum/fish_trait/proc/difficulty_mod(obj/item/fishingrod/rod, mob/fisherman)
	SHOULD_CALL_PARENT(TRUE) //Technically it doesn't but this makes it saner without custom unit test
	return list(ADDITIVE_FISHING_MOD = 0, MULTIPLICATIVE_FISHING_MOD = 1)

/// Catch weight table modifier from this mod, needs to return a list with two values
// When initially ported, fishes had nocturnal and day dwelling traits, but since we have our day WAY shorter than night, it is not really worth it to implement these traits, especially because the rare fishes are overwhelmingly night fishes.
/datum/fish_trait/proc/catch_weight_mod(obj/item/fishingrod/rod, mob/fisherman, atom/location, obj/item/reagent_containers/food/snacks/fish/fish_type)
	SHOULD_CALL_PARENT(TRUE)
	return list(ADDITIVE_FISHING_MOD = 0, MULTIPLICATIVE_FISHING_MOD = 1)

/// Returns special minigame rules and effects applied by this trait
/datum/fish_trait/proc/minigame_mod(obj/item/fishingrod/rod, mob/fisherman, datum/fishing_challenge/minigame)
	return

/// Applies some special qualities to the fish that has been spawned
/datum/fish_trait/proc/apply_to_fish(obj/item/reagent_containers/food/snacks/fish/fish)
	SHOULD_CALL_PARENT(TRUE)
	return

/datum/fish_trait/wary
	name = "Wary"
	catalog_description = "This fish will avoid visible fishing lines. A thin line is recommended."

/datum/fish_trait/wary/difficulty_mod(obj/item/fishingrod/rod, mob/fisherman)
	. = ..()
	var/obj/item/fishing/reel/reel = rod.reel
	if(!reel || !(reel.fishing_reel_traits & FISHING_REEL_THIN))
		.[ADDITIVE_FISHING_MOD] += FISH_TRAIT_MINOR_DIFFICULTY_BOOST

/datum/fish_trait/picky_eater
	name = "Picky Eater"
	catalog_description = "This fish is very picky and will ignore low quality bait (unless it's amongst its favorites)."

/datum/fish_trait/picky_eater/catch_weight_mod(obj/item/fishingrod/rod, mob/fisherman, atom/location, obj/item/reagent_containers/food/snacks/fish/fish_type)
	. = ..()
	var/list/fav_baits = SSfishing.fish_properties[fish_type][FISH_PROPERTIES_FAV_BAIT]
	for(var/list/identifier in fav_baits)
		if(identifier[FISH_BAIT_TYPE] != FISH_BAIT_FOODTYPE)
			continue
		if(is_matching_bait(rod, identifier)) //Bait or no bait, it's a yummy rod.
			return
	if(!rod.baited)
		.[MULTIPLICATIVE_FISHING_MOD] = 0
		return
	if(HAS_TRAIT(rod.baited, TRAIT_OMNI_BAIT))
		return

	for(var/identifier in fav_baits)
		if(is_matching_bait(rod.baited, identifier)) //we like this bait anyway
			return

	var/list/bad_baits = SSfishing.fish_properties[fish_type][FISH_PROPERTIES_BAD_BAIT]
	for(var/identifier in bad_baits)
		if(is_matching_bait(rod.baited, identifier)) //we hate this bait.
			.[MULTIPLICATIVE_FISHING_MOD] = 0
			return

	if(!HAS_TRAIT(rod.baited, TRAIT_GOOD_QUALITY_BAIT) && !HAS_TRAIT(rod.baited, TRAIT_GREAT_QUALITY_BAIT))
		.[MULTIPLICATIVE_FISHING_MOD] = 0

/datum/fish_trait/heavy
	name = "Demersal"
	catalog_description = "This fish tends to stay near the waterbed."

/datum/fish_trait/heavy/proc/has_sinker(obj/item/fishingrod/rod)
	if(rod.line && (rod.line.fishing_line_traits & FISHING_LINE_SINKER))
		return TRUE
	var/obj/item/fishing/bait/rolled = rod.baited
	return istype(rolled) && rolled.weighted

/datum/fish_trait/heavy/catch_weight_mod(obj/item/fishingrod/rod, mob/fisherman, atom/location, obj/item/reagent_containers/food/snacks/fish/fish_type)
	. = ..()
	if(has_sinker(rod))
		.[MULTIPLICATIVE_FISHING_MOD] *= FISHING_SINKER_DEMERSAL_MULT

/datum/fish_trait/heavy/minigame_mod(obj/item/fishingrod/rod, mob/fisherman, datum/fishing_challenge/minigame)
	if(has_sinker(rod))
		return
	minigame.mover.fish_idle_velocity -= 10

/datum/fish_trait/carnivore
	name = "Carnivore"
	catalog_description = "This fish can only be baited with meat."
	incompatible_traits = list(/datum/fish_trait/vegan)

/datum/fish_trait/carnivore/catch_weight_mod(obj/item/fishingrod/rod, mob/fisherman, atom/location, obj/item/reagent_containers/food/snacks/fish/fish_type)
	. = ..()
	if(!rod.baited)
		.[MULTIPLICATIVE_FISHING_MOD] = 0
		return
	if(HAS_TRAIT(rod.baited, TRAIT_OMNI_BAIT))
		return
	var/list/bait_identifier = list(
		FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
		FISH_BAIT_VALUE = DISH_MEAT,
	)
	if(!is_matching_bait(rod.baited, bait_identifier))
		.[MULTIPLICATIVE_FISHING_MOD] = 0

/datum/fish_trait/vegan
	name = "Herbivore"
	catalog_description = "This fish can only be baited with fresh produce."
	incompatible_traits = list(/datum/fish_trait/carnivore)

/datum/fish_trait/vegan/catch_weight_mod(obj/item/fishingrod/rod, mob/fisherman, atom/location, obj/item/reagent_containers/food/snacks/fish/fish_type)
	. = ..()
	if(!rod.baited)
		.[MULTIPLICATIVE_FISHING_MOD] = 0
		return
	if(HAS_TRAIT(rod.baited, TRAIT_OMNI_BAIT))
		return
	if(istype(rod.baited, /obj/item/reagent_containers/food/snacks/grown))
		return
	var/list/bait_liked_identifier = list(
		FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
		FISH_BAIT_VALUE = DISH_VEGETABLE|DISH_FRUIT,
	)
	var/list/bait_hated_identifier = list(
		FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
		FISH_BAIT_VALUE = DISH_MEAT|DISH_DAIRY,
	)
	if(!is_matching_bait(rod.baited, bait_liked_identifier) || is_matching_bait(rod.baited, bait_hated_identifier))
		.[MULTIPLICATIVE_FISHING_MOD] = 0

/datum/fish_trait/antigrav
	name = "Anti-Gravity"
	catalog_description = "This fish will invert the gravity of the bait at random. May fall upward outside after being caught."
	added_difficulty = 20

/datum/fish_trait/antigrav/minigame_mod(obj/item/fishingrod/rod, mob/fisherman, datum/fishing_challenge/minigame)
	minigame.special_effects |= FISHING_MINIGAME_RULE_ANTIGRAV

/datum/fish_trait/camouflage
	name = "Camouflage"
	catalog_description = "This fish possess the ability to blend with its surroundings."
	added_difficulty = 5

/datum/fish_trait/camouflage/minigame_mod(obj/item/fishingrod/rod, mob/fisherman, datum/fishing_challenge/minigame)
	minigame.special_effects |= FISHING_MINIGAME_RULE_CAMO

/datum/fish_trait/prehistoric
	name = "Royal Fish"
	catalog_description = "An extremely rare fish extirpated from most of Azuria's range. Extremely valuable, and succulent."
	added_difficulty = 25

/datum/fish_trait/prehistoric/apply_to_fish(obj/item/reagent_containers/food/snacks/fish/fish)
	. = ..()
	fish.price_mult *= FISH_ROYAL_PRICE_MULT

/datum/fish_trait/venomous
	name = "Venomous"
	catalog_description = "This fish secretes toxins. Can poison other fish and handlers."
	added_difficulty = 10

/datum/fish_trait/treasure_hunter
	name = "Treasure Hunter"
	catalog_description = "This fish collects shiny objects. May have valuables in its stomach when caught."
	incompatible_traits = list(/datum/fish_trait/vegan)

/datum/fish_trait/treasure_hunter/apply_to_fish(obj/item/reagent_containers/food/snacks/fish/fish)
	. = ..()
	// When the fish is butchered/killed, small chance to drop coins or gems
	RegisterSignal(fish, COMSIG_FISH_STATUS_CHANGED, PROC_REF(drop_treasure))

/datum/fish_trait/treasure_hunter/proc/drop_treasure(obj/item/reagent_containers/food/snacks/fish/source)
	SIGNAL_HANDLER
	if(!source.dead || !prob(15))
		return
	var/treasure_type = pick(/obj/item/roguecoin/copper, /obj/item/roguecoin/silver, /obj/item/roguecoin/gold)
	new treasure_type(get_turf(source))
	source.visible_message(span_notice("Something shiny falls out of [source]!"))
