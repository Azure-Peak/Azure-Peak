/obj/item/reagent_containers/food/snacks/fish
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
	sellprice = 10
	dropshrink = 0.6
	slices_num = 2
	slice_bclass = BCLASS_CHOP
	chopping_sound = TRUE
	var/rarity_rank = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = 3)
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/fish
	eat_effect = /datum/status_effect/debuff/uncookedfood
	cooked_smell = /datum/pollutant/food/cooked_fish

/obj/item/reagent_containers/food/snacks/fish/dead
	dead = TRUE

/obj/item/reagent_containers/food/snacks/fish/Initialize()
	. = ..()
	var/rarity = pickweight(list("gold" = 1, "ultra" = 40, "rare"= 50, "com"= 900))
	if(!no_rarity_sprite)
		icon_state = "[initial(icon_state)][rarity]"
	switch(rarity)
		if("gold")
			sellprice = sellprice * 10
			name = "legendary [initial(name)]"
			rarity_rank = 3
		if("ultra")
			sellprice = sellprice * 4
			name = "ultra-rare [initial(name)]"
			rarity_rank = 2
		if("rare")
			sellprice = sellprice * 2
			name = "rare [initial(name)]"
			rarity_rank = 1
		if("com")
			name = "common [initial(name)]"
	if(!dead)
		START_PROCESSING(SSobj, src)

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
	desc = "A lonesome, horrific creacher of the freshwaters, searching for a mate. It makes for good eating."
	icon_state = "salmon"
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	sellprice = 15
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/salmon
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/salmon

/obj/item/reagent_containers/food/snacks/fish/plaice
	name = "plaice"
	desc = "A popular flatfish for eating. Found on tables of noblefolk and peasantry alike."
	icon_state = "plaice"
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	sellprice = 15
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/plaice
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/plaice

/obj/item/reagent_containers/food/snacks/fish/mudskipper
	name = "mudskipper"
	desc = "A furtive creacher, it hides in murky waters to keep its grotesque visage secreted away."
	icon_state = "mudskipper"
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	sellprice = 5
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/mudskipper
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/mudskipper

/obj/item/reagent_containers/food/snacks/fish/bass
	name = "seabass"
	desc = "I didn't see a bass."
	icon_state = "seabass"
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	sellprice = 10
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/bass
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/bass

/obj/item/reagent_containers/food/snacks/fish/sunny
	name = "sunny"
	desc = "A pitiful beast, clinging to Astrata's light as if it would make it stronger. Little does it know that it needs faith for such miracles."
	icon_state = "sunny"
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	sellprice = 3
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/sunny
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/sunny

/obj/item/reagent_containers/food/snacks/fish/carp
	name = "carp"
	desc = "A mudraking creacher of the river-depths, barely fit for food."
	faretype = FARE_IMPOVERISHED
	icon_state = "carp"
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/carp
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/carp

/obj/item/reagent_containers/food/snacks/fish/clownfish
	name = "clownfish"
	desc = "This fish brings vibrant hues to the dark world of Azure Peak."
	icon_state = "clownfish"
	faretype = FARE_NEUTRAL
	sellprice = 40
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/clownfish
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/clownfish

/obj/item/reagent_containers/food/snacks/fish/angler
	name = "anglerfish"
	desc = "A menacing abyssal predator."
	faretype = FARE_NEUTRAL
	icon_state = "angler"
	sellprice = 15
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/angler
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/angler

/obj/item/reagent_containers/food/snacks/fish/eel
	name = "eel"
	desc = "A sinuous eel that slithers through the dark waters."
	icon_state = "eel"
	faretype = FARE_NEUTRAL
	sellprice = 5
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/eel
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/eel

/obj/item/reagent_containers/food/snacks/fish/sole
	name = "sole"
	desc = "An ugly flatfish, slimy and with both eyes on one side of its head. Nothing to do with feet."
	icon_state = "sole"
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	sellprice = 5
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/sole
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/sole

/obj/item/reagent_containers/food/snacks/fish/cod
	name = "cod"
	desc = "A cod, wow! Cod you hand me another piece of bait?"
	icon_state = "cod"
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/cod
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/cod

/obj/item/reagent_containers/food/snacks/fish/creepy_eel
	name = "abyssal eel"
	desc = "Pick me up pick me up pick me up pick me up pick me up pick me up!"
	icon_state = "creepy_eel"
	faretype = FARE_IMPOVERISHED
	no_rarity_sprite = TRUE
	var/was_i_picked_up = FALSE
	dropshrink = 0

/obj/item/reagent_containers/food/snacks/fish/creepy_eel/pickup(mob/living/user)
	if(!was_i_picked_up && ishuman(user))
		teleport_to_dream(user, 1, 1)
		was_i_picked_up = TRUE
		desc = "A slimy eel, you feel a strange mundanity looking at it... You're assured there's nothing weird about it whatsoever. It might as well be the most average thing in the realm."
	..()

/obj/item/reagent_containers/food/snacks/fish/creepy_squid
	name = "brain squid"
	desc = "It makes me feel strange..."
	icon_state = "creepy_squid"
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
	desc = "It's scales refract light in a strange, unsettling manner."
	icon_state = "creepy_shark"
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
	desc = "Black-Headed Salmon is an ocean fish found in open salt waters, recognizable by its dark head and lighter body. It is fully edible and prized for its firm, tasty meat, and the dark coloration likely helps it blend in when hunting near the surface."
	icon_state = "salmon_black"
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/salmon/black_headed
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/salmon/black_headed
	sellprice = 17

/obj/item/reagent_containers/food/snacks/fish/flounder
	name = "flounder"
	desc = "Flounder is a flat ocean fish living in open salt waters, well adapted to life along the seabed. It is fully edible and known for its mild, tender meat, and an interesting fact is that both of its eyes are located on one side of the body, helping it stay hidden while lying flat on the ocean floor."
	icon_state = "flounder"
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/flounder
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/flounder
	sellprice = 5

/obj/item/reagent_containers/food/snacks/fish/swamp_shrimp
	name = "swamp shrimp"
	icon_state = "swamp_shrimp"
	desc = "Swamp \"Shrimp\" is a small crustacean found in murky swamp waters, adapted to survive in dirty, low-oxygen water."
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/swamp_shrimp
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/swamp_shrimp
	sellprice = 5

/obj/item/reagent_containers/food/snacks/fish/swamp_mother
	name = "swamp mother"
	icon_state = "swamp_mother"
	desc = "Swamp Mother is a large swamp-dwelling creature found in murky waters."
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/swamp_mother
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/swamp_mother
	sellprice = 15

/obj/item/reagent_containers/food/snacks/fish/black_bass
	name = "black bass"
	icon_state = "black_bass"
	desc = "Black Bass is a freshwater fish found in clean rivers and lakes, known for its strength and aggressive behavior. It is fully edible and popular for its firm meat, and a fun fact is that black bass are notorious for fighting hard even when caught on light tackle."
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/black_bass
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/black_bass
	sellprice = 7

/obj/item/reagent_containers/food/snacks/fish/zizo_abberation
	name = "zizo abberation"
	icon_state = "zizo_abberation"
	desc = "Zizo Aberration is a cave-dwelling creature found in murky underground waters. It is edible, but widely nicknamed the “Zizo creature” due to its disgusting behavior, it viciously bites any hand that comes into contact with it, whether in water or out."
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/zizo_abberation
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/zizo_abberation
	sellprice = 20

/obj/item/reagent_containers/food/snacks/fish/sturgeon
	name = "sturgeon"
	icon_state = "sturgeon"
	desc = "Sturgeon is a large freshwater fish found in clean rivers and waterfalls, known for its ancient appearance and heavy armor-like scales. It is fully edible and highly valued, and an interesting fact is that sturgeons have existed for over 200 million years, making them true living fossils."
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/sturgeon
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/sturgeon
	sellprice = 5

/obj/item/reagent_containers/food/snacks/fish/mackerel
	name = "mackerel"
	icon_state = "mackerel"
	desc = "Mackerel is a fast-moving ocean fish found in open salt waters. It is fully edible, rich in oils and flavor, and known for its speed, mackerel can swim so fast it must keep moving to breathe properly."
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/mackerel
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/mackerel
	sellprice = 5

/obj/item/reagent_containers/food/snacks/fish/beaksnapper
	name = "beaksnapper"
	icon_state = "beaksnapper"
	desc = "Beaksnapper is a colorful ocean fish found in salt waters, named for its strong, beak-like mouth. It is edible and prized for its firm meat, and fun fact: its snapping bite is strong enough to crush small shells, making it a clever little predator."
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/beaksnapper
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/beaksnapper
	sellprice = 15
