/obj/item/reagent_containers/food/snacks/fish
	cuisine = CUISINE_SOUTH_IMPERIAL
	dish_type = DISH_SEAFOOD
	name = "fish"
	desc = "Fresh blood stains its silvery skin. Silver-coloured scales shimmering softly.."
	icon_state = "carp"
	icon = 'modular/Neu_food/icons/raw/raw_fish.dmi'
	verb_say = "glubs"
	verb_yell = "glubs"
	obj_flags = CAN_BE_HIT
	var/dead = TRUE
	var/no_rarity_sprite = FALSE // Whether this fish has rarity based sprites. If not, don't change icon states
	var/sinkable = TRUE
	max_integrity = 50
	sellprice = FISH_PRICE_GOOD
	dropshrink = 0.6
	slices_num = FISH_FILLETS_SMALL
	slice_bclass = BCLASS_CHOP
	chopping_sound = TRUE
	var/rarity_rank = FISH_RARITY_COMMON
	list_reagents = list(/datum/reagent/consumable/nutriment = 3)
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/fish
	eat_effect = /datum/status_effect/debuff/uncookedfood
	cooked_smell = /datum/pollutant/food/cooked_fish
	possible_item_intents = list(/datum/intent/food, /datum/intent/mace/slap)
	force = 8
	materia = list(/datum/materia_aspect/water)

/datum/intent/mace/slap
	name = "slap"
	blade_class = BCLASS_PUNCH
	attack_verb = list("slaps", "smacks", "wallops", "chastises")
	hitsound = list('sound/foley/slap.ogg', 'modular/Neu_Food/sound/meatslap.ogg', 'sound/misc/mat/sex_clap/hard/SexSmack21.ogg', 'sound/misc/mat/sex_clap/hard/SexSmack24.ogg')
	chargetime = 1
	penfactor = PEN_NONE
	swingdelay = 0
	icon_state = "fish"
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

/datum/intent/mace/slap/pig
	name = "ham-shank"
	icon_state = "inshank"
	blade_class = BCLASS_BLUNT
	attack_verb = list("schmacked", "wallops", "pork-chops", "thwacks")
	hitsound = list('modular/Neu_Food/sound/meatslap.ogg', 'sound/misc/mat/sex_clap/slow/SexSlap34.ogg', 'sound/misc/bonk.ogg')

/obj/item/reagent_containers/food/snacks/fish/Initialize(mapload)
	. = ..()
	if(!dead)
		START_PROCESSING(SSobj, src)
	apply_traits()
	update_size_and_weight()

/obj/item/reagent_containers/food/snacks/fish/initialize_slice(obj/item/reagent_containers/food/snacks/slice, reagents_per_slice)
	. = ..()
	slice.name = "[initial(name)] filet"
	slice.faretype = faretype

/obj/item/reagent_containers/food/snacks/fish/initialize_cooked_food(obj/item/reagent_containers/food/snacks/S, cooking_efficiency = 1)
	. = ..()
	if(S.type != cooked_type && S.type != fried_type)
		return
	S.slices_num = slices_num
	S.slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried
	S.slice_bclass = slice_bclass
	S.slice_name = "fried [initial(name)] filet"
	var/target = FISH_COOKED_NUTRIMENT_PER_FILLET * slices_num
	var/current = S.reagents.get_reagent_amount(/datum/reagent/consumable/nutriment)
	if(target > current)
		S.reagents.add_reagent(/datum/reagent/consumable/nutriment, target - current, S.tastes)
	else if(target < current)
		S.reagents.remove_reagent(/datum/reagent/consumable/nutriment, current - target)

/obj/item/reagent_containers/food/snacks/fish/proc/update_rarity()
	var/ratio = size / average_size
	var/label = "common"
	var/suffix = "com"
	var/mult = 1
	rarity_rank = FISH_RARITY_COMMON
	if(ratio >= FISH_RARITY_LEGENDARY_RATIO)
		label = "legendary"
		suffix = "gold"
		mult = FISH_RARITY_LEGENDARY_PRICE_MULT
		rarity_rank = FISH_RARITY_LEGENDARY
	else if(ratio >= FISH_RARITY_ULTRA_RATIO)
		label = "ultra-rare"
		suffix = "ultra"
		mult = FISH_RARITY_ULTRA_PRICE_MULT
		rarity_rank = FISH_RARITY_ULTRA
	else if(ratio >= FISH_RARITY_RARE_RATIO)
		label = "rare"
		suffix = "rare"
		mult = FISH_RARITY_RARE_PRICE_MULT
		rarity_rank = FISH_RARITY_RARE
	name = "[label] [initial(name)]"
	sellprice = initial(sellprice) * mult * price_mult
	if(!no_rarity_sprite)
		icon_state = "[initial(icon_state)][suffix]"

/obj/item/reagent_containers/food/snacks/fish/get_stockpile_quality_mult()
	if(!initial(sellprice))
		return 1
	return sellprice / initial(sellprice)

/obj/item/reagent_containers/food/snacks/fish/attack_hand(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(!(L.mobility_flags & MOBILITY_PICKUP))
			return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	if(dead)
		..()
	else
		if(isturf(user.loc))
			src.forceMove(user.loc)
		to_chat(user, span_warning("Too slippery!"))
		return

/obj/item/reagent_containers/food/snacks/fish/process()
	if(!isturf(loc)) //no floating out of bags
		return
	if(prob(50) && !dead)
		dir = pick(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
		step(src, dir)

/obj/item/reagent_containers/food/snacks/fish/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/reagent_containers/food/snacks/fish/deconstruct()
	if(!dead)
		dead = TRUE
//		icon_state = "[icon_state]"
		STOP_PROCESSING(SSobj, src)
		return 1

/obj/item/reagent_containers/food/snacks/fish/after_throw(datum/callback/callback)
	. = ..()
	sinkable = TRUE

/obj/item/reagent_containers/food/snacks/fish/salmon
	name = "salmon"
	desc = "The king of freshwater fish. They swim up rivers, pass weirs and traps and all kinds of obstacles, so they may lay their spawn, which is said to occur in the month of Xylix, and then swim out to the sea before winter. Any who are left behind are barely fit for eating, but those who make it to the sea are delicious and in abundance. A popular delicacy in Daftsmarch and Hagenstead, where many of their rivers are home to them. Up north in Rockhill and Rosawood, trout which are similar to them are more common."
	icon_state = "salmon"
	fish_id = "salmon"
	average_size = 7
	average_weight = 8
	required_fluid_type = FISH_FLUID_FRESHWATER
	fishing_difficulty_modifier = 10
	fish_movement_type = /datum/fish_movement/accelerando
	favorite_bait = list(
		list(
			FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
			FISH_BAIT_VALUE = DISH_MEAT,
		),
	)
	faretype = FARE_FINE
	slices_num = FISH_FILLETS_LARGE
	no_rarity_sprite = TRUE
	sellprice = FISH_PRICE_FINE
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/fish/salmon
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/salmon
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/salmon
	smoked_type = /obj/item/reagent_containers/food/snacks/rogue/smokefish

/obj/item/reagent_containers/food/snacks/fish/plaice
	name = "plaice"
	desc = "A popular flatfish, they come from the seas of Bleakisles, where they are found in utter abundance, though they are scarcer in Azurian waters. It is delicious, with a subtle and sweet taste, and is a common dish for commoners and nobles alike. Plaice caught here are sold as far as Heartfelt in the west of Azuria."
	icon_state = "plaice"
	fish_id = "plaice"
	average_size = 4
	average_weight = 2
	required_fluid_type = FISH_FLUID_SALTWATER
	fish_movement_type = /datum/fish_movement/slow
	favorite_bait = list(
		list(
			FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
			FISH_BAIT_VALUE = DISH_MEAT,
		),
	)
	fish_traits = list(/datum/fish_trait/camouflage, /datum/fish_trait/heavy)
	faretype = FARE_FINE
	slices_num = FISH_FILLETS_MEDIUM
	no_rarity_sprite = TRUE
	sellprice = FISH_PRICE_FINE
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/plaice
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/plaice
	smoked_type = /obj/item/reagent_containers/food/snacks/rogue/smokefish

/obj/item/reagent_containers/food/snacks/fish/mudskipper
	name = "mudskipper"
	desc = "A furtive creechur, born of the mud. It hides in murky waters to keep its grotesque visage secreted away, and emerges when the spiders have left to pounce on insects and others floating on the water. They are not popular due to their appearance and occasionally fishy taste, but are surprisingly delicious for a fish accessible to the poor."
	icon_state = "mudskipper"
	fish_id = "mudskipper"
	average_size = 1.5
	average_weight = 0.1
	required_fluid_type = FISH_FLUID_FRESHWATER
	fishing_difficulty_modifier = -5
	fish_movement_type = /datum/fish_movement/choppy
	favorite_bait = list(
		list(
			FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
			FISH_BAIT_VALUE = DISH_MEAT,
		),
	)
	fish_traits = list(/datum/fish_trait/camouflage)
	faretype = FARE_POOR
	slices_num = FISH_FILLETS_TINY
	no_rarity_sprite = TRUE
	sellprice = FISH_PRICE_COMMON
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/mudskipper
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/mudskipper
	smoked_type = /obj/item/reagent_containers/food/snacks/rogue/smokefish

/obj/item/reagent_containers/food/snacks/fish/bass
	name = "seabass"
	desc = "A sea bass. Dense, with rich and flaky meat, often found on a burgher's table. It is a popular fish, but a commoner who is not a fisherman may not get to taste it more than a few times in their life. They have white, soft and buttery meat, and are best cooked by frying, preferably done by a properly trained cook in a noble's household. Bass caught in the river are the most prized, but there's barely any of them to be found, so they settle for sea bass instead."
	icon_state = "seabass"
	fish_id = "bass"
	average_size = 6
	average_weight = 6
	required_fluid_type = FISH_FLUID_SALTWATER
	fishing_difficulty_modifier = 5
	fish_movement_type = /datum/fish_movement/zippy
	favorite_bait = list(
		list(
			FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
			FISH_BAIT_VALUE = DISH_MEAT,
		),
	)
	faretype = FARE_NEUTRAL
	slices_num = FISH_FILLETS_MEDIUM
	no_rarity_sprite = TRUE
	sellprice = FISH_PRICE_GOOD
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/bass
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/bass
	smoked_type = /obj/item/reagent_containers/food/snacks/rogue/smokefish

/obj/item/reagent_containers/food/snacks/fish/sunny
	name = "sunny"
	desc = "A pitiful beast, clinging to Astrata's light as if it would make it stronger. Little does it know that it needs faith for such miracles. A tiny fish that loves to live in ponds, and with a pleasant and sweet taste. Suitable for usage as a bait."
	icon_state = "sunny"
	fish_id = "sunny"
	average_size = 1.5
	average_weight = 0.3
	required_fluid_type = FISH_FLUID_FRESHWATER
	fishing_difficulty_modifier = -5
	fish_movement_type = /datum/fish_movement/zippy
	favorite_bait = list(
		list(
			FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
			FISH_BAIT_VALUE = DISH_BREAD,
		),
	)
	faretype = FARE_POOR
	slices_num = FISH_FILLETS_TINY
	no_rarity_sprite = TRUE
	sellprice = FISH_PRICE_BAIT
	isbait = TRUE
	bait_quality = TRAIT_BASIC_QUALITY_BAIT
	bait_flag = DISH_MEAT
	baitresilience = 1
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/sunny
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/sunny
	smoked_type = /obj/item/reagent_containers/food/snacks/rogue/smokefish

/obj/item/reagent_containers/food/snacks/fish/carp
	name = "carp"
	desc = "A mudraking creacher of the river depths. It is kept in ponds and lakes for its meat, and is a very common fish for commoners to eat. It is said to be the Queen of Rivers, and has a subtle, but muddy taste."
	faretype = FARE_POOR
	slices_num = FISH_FILLETS_SMALL
	sellprice = FISH_PRICE_COMMON
	icon_state = "carp"
	fish_id = "carp"
	average_size = 6
	average_weight = 8
	required_fluid_type = FISH_FLUID_FRESHWATER
	fishing_difficulty_modifier = 5
	fish_movement_type = /datum/fish_movement/choppy
	favorite_bait = list(
		list(
			FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
			FISH_BAIT_VALUE = DISH_BREAD,
		),
		/obj/item/fishing/bait/dough,
		/obj/item/fishing/bait/gray,
	)
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/carp
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/carp
	smoked_type = /obj/item/reagent_containers/food/snacks/rogue/smokefish

/obj/item/reagent_containers/food/snacks/fish/clownfish
	name = "clownfish"
	desc = "A fish of vibrant hue and distinctive markings, said to brighten up one's dae just by looking at it. It is a popular pet, kept in bowls and ponds, and hard to find. The meat is frankly mediocre, but eating it is said to bring good luck."
	icon_state = "clownfish"
	fish_id = "clownfish"
	average_size = 1
	average_weight = 0.06
	required_fluid_type = FISH_FLUID_SALTWATER
	fishing_difficulty_modifier = 5
	fish_movement_type = /datum/fish_movement/zippy
	favorite_bait = list(
		list(
			FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
			FISH_BAIT_VALUE = DISH_MEAT,
		),
		/obj/item/fishing/bait/speckled,
	)
	fish_traits = list(/datum/fish_trait/camouflage, /datum/fish_trait/picky_eater)
	faretype = FARE_FINE
	slices_num = FISH_FILLETS_TINY
	sellprice = FISH_PRICE_PRIZED
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/clownfish
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/clownfish
	smoked_type = /obj/item/reagent_containers/food/snacks/rogue/smokefish

/obj/item/reagent_containers/food/snacks/fish/angler
	name = "anglerfish"
	desc = "A menacing abyssal creature with a massive head. They are said to be a relative of the frog, and have grown a great lure to draw lesser fishes to their doom. They yield a lot of meat, which is succulent and dense around the tail."
	faretype = FARE_FINE
	slices_num = FISH_FILLETS_LARGE
	icon_state = "angler"
	fish_id = "angler"
	average_size = 8
	average_weight = 20
	required_fluid_type = FISH_FLUID_SALTWATER
	fishing_difficulty_modifier = 15
	fish_movement_type = /datum/fish_movement/plunger
	favorite_bait = list(
		list(
			FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
			FISH_BAIT_VALUE = DISH_MEAT,
		),
		/obj/item/fishing/bait/speckled,
	)
	fish_traits = list(/datum/fish_trait/heavy, /datum/fish_trait/carnivore)
	sellprice = FISH_PRICE_FINE
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/angler
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/angler
	smoked_type = /obj/item/reagent_containers/food/snacks/rogue/smokefish

/obj/item/reagent_containers/food/snacks/fish/eel
	name = "eel"
	desc = "Eel for breakfast, eel for lunch, eel for dinner. So says the Kingsfielder. Much of south Azuria was once swampland drained to make way for farmland, and eels can be found everywhere and anywhere. It is the most common type of meat on a peasant's plate, and quite delicious too, with a rich and oily taste. It is also said to be an aphrodisiac. No wonder then, that the humen of Azuria outnumber the elves of the north, who partake in more wholesome fishes, fried in lard and served with potatoes."
	icon_state = "eel"
	fish_id = "eel"
	average_size = 8
	average_weight = 2
	required_fluid_type = FISH_FLUID_FRESHWATER
	fishing_difficulty_modifier = 10
	fish_movement_type = /datum/fish_movement/zippy
	favorite_bait = list(
		list(
			FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
			FISH_BAIT_VALUE = DISH_MEAT,
		),
		/obj/item/fishing/bait/meat,
		/obj/item/fishing/bait/gray,
	)
	faretype = FARE_POOR
	slices_num = FISH_FILLETS_SMALL
	sellprice = FISH_PRICE_COMMON
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/eel
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/eel
	smoked_type = /obj/item/reagent_containers/food/snacks/rogue/smokefish

/obj/item/reagent_containers/food/snacks/fish/sole
	name = "sole"
	desc = "An ugly flatfish, slimy and with both eyes on one side of its head. Yet just like the plaice, its flesh is sweet and tender and it can be caught in abundance. Best served fried with a light butter, a slice of Etruscan lemon, and a bit of herbs."
	icon_state = "sole"
	fish_id = "sole"
	average_size = 3
	average_weight = 1
	required_fluid_type = FISH_FLUID_SALTWATER
	fish_movement_type = /datum/fish_movement/slow
	favorite_bait = list(
		list(
			FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
			FISH_BAIT_VALUE = DISH_MEAT,
		),
	)
	fish_traits = list(/datum/fish_trait/camouflage, /datum/fish_trait/heavy)
	faretype = FARE_POOR
	slices_num = FISH_FILLETS_SMALL
	no_rarity_sprite = TRUE
	sellprice = FISH_PRICE_COMMON
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/sole
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/sole
	smoked_type = /obj/item/reagent_containers/food/snacks/rogue/smokefish

/obj/item/reagent_containers/food/snacks/fish/cod
	name = "cod"
	desc = "A fish found in abundance in the northern shore of Azuria, and by fishermen who venture north of the Bleakisles to the colder water of the northern sea. It is very popular amongst the Rossan, and harder to find in the south, where they are fried and served with pesto as 'Elf Fish'."
	icon_state = "cod"
	fish_id = "cod"
	average_size = 8
	average_weight = 12
	required_fluid_type = FISH_FLUID_SALTWATER
	fishing_difficulty_modifier = 5
	fish_movement_type = /datum/fish_movement/choppy
	favorite_bait = list(
		list(
			FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
			FISH_BAIT_VALUE = DISH_MEAT,
		),
	)
	fish_traits = list(/datum/fish_trait/heavy)
	faretype = FARE_NEUTRAL
	slices_num = FISH_FILLETS_LARGE
	sellprice = FISH_PRICE_GOOD
	no_rarity_sprite = TRUE
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/cod
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/cod
	smoked_type = /obj/item/reagent_containers/food/snacks/rogue/smokefish

/obj/item/reagent_containers/food/snacks/fish/creepy_eel
	name = "abyssal eel"
	fish_flags = NONE // Abyssor fishs are hidden
	desc = "Pick me up pick me up pick me up pick me up pick me up pick me up!"
	icon_state = "creepy_eel"
	fish_id = "creepy_eel"
	average_size = 10
	average_weight = 5
	required_fluid_type = FISH_FLUID_SALTWATER
	fishing_difficulty_modifier = 15
	fish_movement_type = /datum/fish_movement/zippy
	favorite_bait = list(
		list(
			FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
			FISH_BAIT_VALUE = DISH_MEAT,
		),
	)
	faretype = FARE_IMPOVERISHED
	no_rarity_sprite = TRUE
	var/was_i_picked_up = FALSE
	dropshrink = 0

/obj/item/reagent_containers/food/snacks/fish/creepy_eel/pickup(mob/living/user)
	if(!was_i_picked_up && ishuman(user))
		teleport_to_dream(user, force = TRUE)
		was_i_picked_up = TRUE
		desc = "A slimy eel, you feel a strange mundanity looking at it... You're assured there's nothing weird about it whatsoever. It might as well be the most average thing in the realm."
	..()

/obj/item/reagent_containers/food/snacks/fish/creepy_squid
	name = "brain squid"
	fish_flags = NONE // Abyssor fishs are hidden
	desc = "It makes me feel strange..."
	icon_state = "creepy_squid"
	fish_id = "creepy_squid"
	average_size = 5
	average_weight = 4
	required_fluid_type = FISH_FLUID_SALTWATER
	fishing_difficulty_modifier = 15
	fish_movement_type = /datum/fish_movement/plunger
	favorite_bait = list(
		list(
			FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
			FISH_BAIT_VALUE = DISH_MEAT,
		),
	)
	faretype = FARE_IMPOVERISHED
	no_rarity_sprite = TRUE
	dropshrink = 0

/obj/item/reagent_containers/food/snacks/fish/creepy_squid/examine(mob/user)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(ishuman(H) && !HAS_TRAIT(H, TRAIT_NOMOOD) && H.patron.type != /datum/patron/divine/abyssor)
		. += span_danger("As I behold the squid closely, I can see its body extend into the spectral shape of a vicious, horrific creature. Countless tentacles lead into innumerable spiny limbs with vicious looking spikes. A singular, gigantic eye stares back at me. The image fades...")
		H.add_stress(/datum/stressevent/creepy_squid)
		H.emote("scream")
		H.Knockdown(1)
	else if(H.patron.type == /datum/patron/divine/abyssor)
		. += span_notice("It's the most beautiful creature I have ever laid my eyes upon.")
		user.add_stress(/datum/stressevent/creepy_squid_happy)

/datum/stressevent/creepy_squid
	timer = 5 MINUTES
	stressadd = 2
	desc = span_danger("I don't know what I saw, but I can still see parts of that horrific form in the corners of my vision.")

/datum/stressevent/creepy_squid_happy
	timer = 25 MINUTES
	stressadd = -1
	desc = span_notice("Seeing that beautiful squid made me really happy!")

/obj/item/reagent_containers/food/snacks/fish/creepy_shark
	name = "iridescent reaver"
	fish_flags = NONE // Abyssor fishs are hidden
	desc = "Its scales refract light in a strange, unsettling manner."
	icon_state = "creepy_shark"
	fish_id = "creepy_shark"
	average_size = 15
	average_weight = 40
	required_fluid_type = FISH_FLUID_SALTWATER
	fishing_difficulty_modifier = 25
	fish_movement_type = /datum/fish_movement/accelerando
	favorite_bait = list(
		list(
			FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
			FISH_BAIT_VALUE = DISH_MEAT,
		),
	)
	fish_traits = list(/datum/fish_trait/heavy, /datum/fish_trait/carnivore)
	faretype = FARE_IMPOVERISHED
	no_rarity_sprite = TRUE
	dropshrink = 0
	var/loot_spawn_cooldown

// I'll probably give this a cooler effect later, but scope creep ahhh.
/obj/item/reagent_containers/food/snacks/fish/creepy_shark/attack_self(mob/user)
	if(world.time < loot_spawn_cooldown)
		var/time_left = (loot_spawn_cooldown - world.time) / (1 MINUTES)
		var/minutes_left = round(time_left, 0.1)
		to_chat(user, span_warning("The [src] feels inert. It will take about [minutes_left] more minutes before it can produce again."))
		return TRUE

	var/obj/effect/spawner/lootdrop/roguetown/abyssor/table = new /obj/effect/spawner/lootdrop/roguetown/abyssor
	var/list/loot_table = table.loot
	if(!loot_table || !loot_table.len)
		to_chat(user, span_warning("The [src] shimmers faintly, but nothing happens."))
		return TRUE

	var/lootspawn = pickweight(loot_table)

	if(!lootspawn)
		to_chat(user, span_warning("The [src] shimmers faintly, but nothing happens."))
		return TRUE

	var/obj/item/I = new lootspawn()

	if(user.put_in_hands(I))
		to_chat(user, span_notice("The [src] shimmers, and you feel the weight of [I] materialize in your hand!"))
	else
		I.forceMove(user.drop_location())
		to_chat(user, span_notice("The [src] shimmers, and [I] appears at your feet!"))

	loot_spawn_cooldown = world.time + 30 MINUTES
	return TRUE

/obj/item/reagent_containers/food/snacks/fish/creepy_shark/examine(mob/user)
	. = ..()
	if(loot_spawn_cooldown && world.time < loot_spawn_cooldown)
		var/time_left = (loot_spawn_cooldown - world.time) / (1 MINUTES)
		var/minutes_left = round(time_left, 0.1)
		. += span_notice("It feels inert and cannot be squeezed yet. About [minutes_left] more minutes required.")
	else
		. += span_notice("You swear you can hear it demand you squeeze it in your hand.")

/obj/item/reagent_containers/food/snacks/fish/salmon/black_headed
	name = "black-headed salmon"
	desc = "The black-headed salmon is a relative of the common salmonne, and it is said that one out of ten salmon that spawn in the rivers of Azuria will be destined to become a black-headed salmon, should they survive their perilous journey down river and back to their spawning grounds. It is found mostly in open salt waters, and has oilier and more flavorful meat than its common cousin."
	icon_state = "salmon_black"
	fish_id = "salmon_black_headed"
	average_size = 8
	average_weight = 10
	required_fluid_type = FISH_FLUID_SALTWATER
	fishing_difficulty_modifier = 10
	fish_movement_type = /datum/fish_movement/accelerando
	favorite_bait = list(
		list(
			FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
			FISH_BAIT_VALUE = DISH_MEAT,
		),
	)
	faretype = FARE_FINE
	slices_num = FISH_FILLETS_LARGE
	no_rarity_sprite = TRUE
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/fish/salmon
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/salmon/black_headed
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/salmon/black_headed
	smoked_type = /obj/item/reagent_containers/food/snacks/rogue/smokefish
	sellprice = FISH_PRICE_RARE

/obj/item/reagent_containers/food/snacks/fish/flounder
	name = "flounder"
	desc = "The flounder is a flatfish much like the plaice and sole, and has strange eyes that grow on one side of the body. They are said to spend most of their lyfe lazily lounging about on the bottom of the sea, eating any creechurs that crawl up to them."
	icon_state = "flounder"
	fish_id = "flounder"
	average_size = 3
	average_weight = 1
	required_fluid_type = FISH_FLUID_SALTWATER
	fish_movement_type = /datum/fish_movement/slow
	favorite_bait = list(
		list(
			FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
			FISH_BAIT_VALUE = DISH_MEAT,
		),
	)
	fish_traits = list(/datum/fish_trait/camouflage, /datum/fish_trait/heavy)
	faretype = FARE_POOR
	slices_num = FISH_FILLETS_SMALL
	no_rarity_sprite = TRUE
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/flounder
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/flounder
	smoked_type = /obj/item/reagent_containers/food/snacks/rogue/smokefish
	sellprice = FISH_PRICE_COMMON

/obj/item/reagent_containers/food/snacks/fish/swamp_shrimp
	name = "swamp shrimp"
	icon_state = "swamp_shrimp"
	desc = "The swamp shrimp is a relative of the common shrimp, adapted to survive in the dirty and murky water of the Terrorbog. Scholars say that while common shrimps are birthed from Abyssor's breath, giving lyfe and food to every creechur of the sea, swamp shrimps are birthed from the putrid remnants of the swamp and emerge from the mud every spring."
	fish_id = "swamp_shrimp"
	average_size = 0.4
	average_weight = 0.01
	required_fluid_type = FISH_FLUID_FRESHWATER
	fishing_difficulty_modifier = -5
	fish_movement_type = /datum/fish_movement/slow
	favorite_bait = list(
		list(
			FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
			FISH_BAIT_VALUE = DISH_VEGETABLE,
		),
	)
	fish_traits = list(/datum/fish_trait/vegan)
	faretype = FARE_POOR
	slices_num = FISH_FILLETS_TINY
	no_rarity_sprite = TRUE
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/swamp_shrimp
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/swamp_shrimp
	smoked_type = /obj/item/reagent_containers/food/snacks/rogue/smokefish
	sellprice = FISH_PRICE_COMMON

/obj/item/reagent_containers/food/snacks/fish/swamp_mother
	name = "swamp mother"
	fish_flags = NONE
	icon_state = "swamp_mother"
	desc = "The swamp mother is a massive, swamp-dwelling creechur with strange, red eyes. It is not known how such a large fish survives in the deadly swamps of the Terrorbog. Some say it digs deep holes into the mud, and ambushes any spiderlings that venture into its territory. How fortunate it is then, that you have caught one and can eat it yourself!"
	fish_id = "swamp_mother"
	average_size = 12
	average_weight = 30
	required_fluid_type = FISH_FLUID_FRESHWATER
	fishing_difficulty_modifier = 15
	fish_movement_type = /datum/fish_movement/plunger
	favorite_bait = list(
		list(
			FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
			FISH_BAIT_VALUE = DISH_MEAT,
		),
	)
	fish_traits = list(/datum/fish_trait/heavy, /datum/fish_trait/carnivore)
	faretype = FARE_FINE
	slices_num = FISH_FILLETS_HUGE
	no_rarity_sprite = TRUE
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/swamp_mother
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/swamp_mother
	smoked_type = /obj/item/reagent_containers/food/snacks/rogue/smokefish
	sellprice = FISH_PRICE_FINE

/obj/item/reagent_containers/food/snacks/fish/black_bass
	name = "black bass"
	icon_state = "black_bass"
	desc = "The black bass. They call it the lion of the rivers. Unlike its far more common sea bass cousin, it is known for its strength and how aggressive it is. It is said that the Azurians and the Taricheans before them have eaten all of the basses in the rivers, save for the noble and powerful black bass which is said to have dragged many a fisherman to their doom. But the meat of a black bass is firm, as delicious as they are hard to fight."
	fish_id = "black_bass"
	average_size = 5
	average_weight = 4
	required_fluid_type = FISH_FLUID_FRESHWATER
	fishing_difficulty_modifier = 10
	fish_movement_type = /datum/fish_movement/zippy
	favorite_bait = list(
		list(
			FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
			FISH_BAIT_VALUE = DISH_MEAT,
		),
	)
	fish_traits = list(/datum/fish_trait/carnivore)
	faretype = FARE_NEUTRAL
	slices_num = FISH_FILLETS_MEDIUM
	no_rarity_sprite = TRUE
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/black_bass
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/black_bass
	smoked_type = /obj/item/reagent_containers/food/snacks/rogue/smokefish
	sellprice = FISH_PRICE_FAIR

/obj/item/reagent_containers/food/snacks/fish/murkfang
	name = "murkfang"
	fish_flags = NONE
	icon_state = "murkfang"
	desc = "A terrifying fish with bloodied teeth, purple skin and red eyes. It is surprisingly edible. It viciously bites anything that comes into contact with it, in or out of water. Inhabitants of the Terrorbog call it 'Zizo's Creechur' for its behavior. Usually cooked and eaten on the spot, because people will seldom buy it."
	fish_id = "murkfang"
	average_size = 4
	average_weight = 3
	required_fluid_type = FISH_FLUID_FRESHWATER
	fishing_difficulty_modifier = 15
	fish_movement_type = /datum/fish_movement/choppy
	favorite_bait = list(
		list(
			FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
			FISH_BAIT_VALUE = DISH_MEAT,
		),
	)
	fish_traits = list(/datum/fish_trait/carnivore)
	faretype = FARE_NEUTRAL
	slices_num = FISH_FILLETS_MEDIUM
	no_rarity_sprite = TRUE
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/murkfang
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/murkfang
	smoked_type = /obj/item/reagent_containers/food/snacks/rogue/smokefish
	sellprice = FISH_PRICE_RARE

/obj/item/reagent_containers/food/snacks/fish/sturgeon
	name = "sturgeon"
	icon_state = "sturgeon"
	desc = "The sturgeon is a massive freshwater fish, known for its many scales, which alone of all fishes are said to grow turned towards the head. In the older daes, a sturgeon was brought to the Grand Duke's table by servants crowned with Calendula or Azurosa, with a piper walking before it. Nowadays, sturgeon are very hard to find in the rivers of Azuria, for surely our ancestors have eaten all of them. It is the most noble of all fish, with abundant, delicious and clean flesh. In the yil 1414, the sturgeon was declared a royal fish, and it is said that all sturgeon that land in Azuria are the property of the Grand Duke. But enforcement is evidently quite spotty."
	fish_id = "sturgeon"
	average_size = 10
	average_weight = 60
	required_fluid_type = FISH_FLUID_FRESHWATER
	fishing_difficulty_modifier = 15
	fish_movement_type = /datum/fish_movement/plunger
	favorite_bait = list(
		list(
			FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
			FISH_BAIT_VALUE = DISH_MEAT,
		),
	)
	fish_traits = list(/datum/fish_trait/heavy, /datum/fish_trait/prehistoric)
	faretype = FARE_FINE
	slices_num = FISH_FILLETS_GIANT
	no_rarity_sprite = TRUE
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/sturgeon
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/sturgeon
	smoked_type = /obj/item/reagent_containers/food/snacks/rogue/smokefish
	// Sturgeon has Royal Fish multiplier so it get insane.
	sellprice = FISH_PRICE_RARE

/obj/item/reagent_containers/food/snacks/fish/mackerel
	name = "mackerel"
	icon_state = "mackerel"
	desc = "The mackerel is a fish that is coloured like sulphur when in water, and they come in shoals in the ocean. They move fast, and are rich in oil and flavor, but quite bony. The Azurian Cookbook 'Forme of Ranesheni Curry' says that mackerels are best served after being deboned, and cooked in a spiced sauce. Commoners settle for just roasting it with a good amount of salt."
	fish_id = "mackerel"
	average_size = 4
	average_weight = 1.5
	required_fluid_type = FISH_FLUID_SALTWATER
	fishing_difficulty_modifier = 5
	fish_movement_type = /datum/fish_movement/zippy
	favorite_bait = list(
		list(
			FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
			FISH_BAIT_VALUE = DISH_MEAT,
		),
	)
	faretype = FARE_POOR
	slices_num = FISH_FILLETS_SMALL
	no_rarity_sprite = TRUE
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/mackerel
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/mackerel
	smoked_type = /obj/item/reagent_containers/food/snacks/rogue/smokefish
	sellprice = FISH_PRICE_COMMON

/obj/item/reagent_containers/food/snacks/fish/beaksnapper
	name = "beaksnapper"
	icon_state = "beaksnapper"
	desc = "The beaksnapper is a colorful ocean fish, said to do battle with crabs and lobsters of the depths to crush their shells and reach the delicate flesh within. It has snapped many a fisherman's fingers and lines."
	fish_id = "beaksnapper"
	average_size = 4
	average_weight = 3
	required_fluid_type = FISH_FLUID_SALTWATER
	fishing_difficulty_modifier = 5
	fish_movement_type = /datum/fish_movement/choppy
	favorite_bait = list(
		list(
			FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
			FISH_BAIT_VALUE = DISH_MEAT,
		),
	)
	fish_traits = list(/datum/fish_trait/carnivore)
	faretype = FARE_FINE
	slices_num = FISH_FILLETS_MEDIUM
	no_rarity_sprite = TRUE
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/beaksnapper
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/beaksnapper
	smoked_type = /obj/item/reagent_containers/food/snacks/rogue/smokefish
	sellprice = FISH_PRICE_FINE

/obj/item/reagent_containers/food/snacks/fish/swordfish
	name = "swordfish"
	desc = "It is said that Abyssor created the swordfish in Ravox's image, and gave it a very long sword on its nose which it uses to joust and hunt the other fishes of the sea. They are found in small numbers in the open ocean, and a shoal of swordfish is said to be a sign of ill omen and great misfortune, for Abyssor's rage is sure to arrive soon after. Their flesh is sometimes orange-ish and very firm, and they are large enough to be grilled as steaks."
	icon_state = "swordfish"
	fish_id = "swordfish"
	average_size = 30
	average_weight = 200
	required_fluid_type = FISH_FLUID_SALTWATER
	fishing_difficulty_modifier = 25
	fish_movement_type = /datum/fish_movement/accelerando
	force = SWORDFISH_FORCE
	armor_penetration = PEN_LIGHT // By the light of the ten, we should have a little bit of whimsy in our codebase. Just a lil
	thrown_bclass = BCLASS_STAB
	embedding = list("embedded_pain_multiplier" = 2, "embed_chance" = 25)
	thrown_damage_flag = "piercing"
	// By jot do not give this an actual combat skills or I will cry
	throwforce = 20
	dropshrink = 0.8
	possible_item_intents = list(DAGGER_THRUST, /datum/intent/food)
	associated_skill = /datum/skill/combat/knives
	favorite_bait = list(
		list(
			FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
			FISH_BAIT_VALUE = DISH_MEAT,
		),
	)
	disliked_bait = list(
		list(
			FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
			FISH_BAIT_VALUE = DISH_VEGETABLE,
		),
	)
	fish_traits = list(/datum/fish_trait/carnivore)
	faretype = FARE_FINE
	slices_num = FISH_FILLETS_GIANT
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/swordfish
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/swordfish
	smoked_type = /obj/item/reagent_containers/food/snacks/rogue/smokefish
	cooked_smell = /datum/pollutant/food/baked_swordfish
	sellprice = FISH_PRICE_PRIZED
