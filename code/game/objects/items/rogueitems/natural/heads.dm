/obj/item/natural/head
	name = "generic animal head"
	desc = "You shouldn't be seeing this."
	icon = 'icons/roguetown/items/bounty_heads.dmi'
	w_class = WEIGHT_CLASS_TINY
	grid_width = 64
	grid_height = 64
	gripped_intents = list(/datum/intent/use)

/obj/item/natural/head/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Heads can be sold to a Merchant for coinage, or to their Headeating machine; note that the latter is automatic, but comes at the cost of halving the head's potential payout.")
	. += span_info("The chance to obtain a head from butchering scales with your Butchering skill. This also applies to the head's quality, which can affect how much - or how little - coinage it can sell for.")
	. += span_info("Certain heads, such as those belonging to ambushing bandits and goblins, can only be acquired through decapitation.")

/// Quality from butchering. 0 is bad, 1 is decent, 2 is normal, 3 is good, -1 means its rotten and useless.
/obj/item/natural/head/proc/scale_butchering_quality(butchering_quality)
	var/initial_name = name
	switch(butchering_quality)
		if(0) // Skill 0-1: was ~30% drop chance, so 0.30x
			sellprice = floor(sellprice * 0.30)
			name = "poor quality [initial_name]" // Apply quality text so you can discern
			// between the different qualities of heads. Also inform the player that it is bad.
		if(1) // Skill 2: was ~70% drop chance, so 0.70x
			sellprice = floor(sellprice * 0.70)
			name = "decent quality [initial_name]"
		if(2) // Skill 3: was guaranteed, so 1.0x
			return
		if(3) // Skill 4+: Towner or dedicated roles, 1.15x
			sellprice = floor(sellprice * 1.15)
			name = "fine quality [initial_name]"
		if(-1) // Rotten
			sellprice = floor(sellprice * 0.1)
			name = "rotten [initial_name]"

/obj/item/natural/head/volf
	name = "volf head"
	desc = "The head of a fearsome volf."
	icon_state = "volfhead"
	layer = 3.1
	grid_height = 32
	sellprice = 10

/obj/item/natural/head/volf/undead
	name = "deadite volf head"
	desc = "At last, the barking and snarling has ceased."
	icon_state = "deadwolfhead"
	sellprice = 30

/obj/item/natural/head/goat
	name = "goat head"
	desc = "The head of a simple goat."
	icon_state = "goathead"
	layer = 3.1
	grid_height = 32
	sellprice = 5

/obj/item/natural/head/fox
	name = "venard head"
	desc = "The head of a majestic venard."
	icon_state = "foxhead"
	layer = 3.1
	grid_height = 32
	sellprice = 6

/obj/item/natural/head/fox/undead
	name = "deadite venard head"
	desc = "Punished for desiring the taste of flesh a little too eagerly."
	icon_state = "deadfoxhead"
	sellprice = 20

/obj/item/natural/head/cabbit/undead
	name = "deadite cabbit head"
	desc = "Despite the small size, undead cabbits are considered one of the more dangerous types of cabbit."
	icon_state = "deadcabbit"
	sellprice = 40

/obj/item/natural/head/saiga
	name = "saiga head"
	desc = "The head of a proud saiga."
	icon_state = "saigahead"
	layer = 3.1
	grid_height = 32
	sellprice = 12

/obj/item/natural/head/saiga/undead
	name = "deadite saiga head"
	desc = "It wasn't easy to put down, now it finally rests motionless in your hands."
	icon_state = "deadsaigahead"
	sellprice = 40

/obj/item/natural/head/direbear
	name = "direbear head"
	desc = "The head of a terrifying direbear."
	icon_state = "direbearhead"
	layer = 3.1
	sellprice = 20

/obj/item/natural/head/mole
	name = "mole head"
	desc = "The head of a lesser mole."
	icon_state = "molehead"
	layer = 3.1
	sellprice = 20

/obj/item/natural/head/boar
	name = "bramblesnout head"
	desc = "The head of a terrifying bramblesnout."
	icon_state = "boarhead"
	layer = 3.1
	// More than other animals that drop a significant amount. Boars are harder to kill and more dangerous.
	sellprice = 45

/obj/item/natural/head/boar/undead
	name = "deadite bramblesnout head"
	desc = "The head of a terrifying bramblesnout claimed by undeath."
	icon_state = "boarhead_undead"
	layer = 3.1
	sellprice = 110

/obj/item/natural/head/terrorhog
	name = "terrorhog head"
	desc = "An abomination, simply put. Thankfully, it is dead."
	icon_state = "boarhead_terror"
	layer = 3.1
	sellprice = 225

/obj/item/natural/head/troll
	name = "troll head"
	desc = "The head of a giant troll."
	icon_state = "trollhead"
	layer = 3.1
	w_class = WEIGHT_CLASS_NORMAL // We want them to be placeable in headhook
	grid_height = 96
	grid_width = 96
	// More than bears because they drop less useful loot.
	sellprice = 30

/obj/item/natural/head/troll/axe
	name = "troll head"
	desc = "The head of a once mighty warrior troll."
	icon_state = "trollhead_axe"
	sellprice = 50

/obj/item/natural/head/troll/cave
	name = "cave troll head"
	icon_state = "cavetrollhead"
	sellprice = 70

/obj/item/natural/head/troll/undead
	name = "deadite troll head"
	desc = "Mightier in undeath, now just a smelly memento."
	icon_state = "deadtrollhead"
	sellprice = 80

/obj/item/natural/head/minotaur
	name = "minotaur head"
	desc = "The head of a dangerous beast of Dendor's madness."
	icon_state = "minotaurhead"
	layer = 3.1
	w_class = WEIGHT_CLASS_NORMAL // We want them to be placeable in headhook
	grid_height = 96
	grid_width = 96
	sellprice = 50

/obj/item/natural/head/dragon/
	name = "dragon head"
	desc = "The head of a dragon."
	w_class = WEIGHT_CLASS_NORMAL // We want them to be placeable in headhook
	grid_height = 96
	grid_width = 96
	icon_state = "dragonhead"
	sellprice = 150

/obj/item/natural/head/dragon/broodmother
	name = "aspirant head"
	desc = "The head of a drakkyn aspirant."
	icon_state = "dragonhead"
	sellprice = 225

/obj/item/natural/head/rous
	name = "rous head"
	desc = "The head of an unusually large rat."
	icon_state = "roushead"
	layer = 3.1
	grid_height = 32
	grid_width = 32
	sellprice = 10

/obj/item/natural/head/honeyspider
	name = "honeyspider head"
	desc = "The head of a venomous honeyspider."
	icon_state = "spiderhead"
	layer = 3.1
	grid_height = 32
	grid_width = 32
	sellprice = 10

/obj/item/natural/head/mirespider
	name = "mire spider head"
	desc = "The head of a disgusting 'little' mire spider."
	icon_state = "mirespiderhead"
	layer = 3.1
	grid_height = 32
	grid_width = 32
	sellprice = 10

/obj/item/natural/head/mirelurker
	name = "mire lurker head"
	desc = "The head of a terrifyingly large mire lurker."
	icon_state = "mirelurkerhead"
	layer = 3.1
	grid_height = 32
	sellprice = 20

/obj/item/natural/head/mirespider_paralytic
	name = "aragn head"
	desc = "The head of the wretched aragn."
	icon_state = "mirespider_paralytichead"
	layer = 3.1
	grid_height = 32
	grid_width = 32
	sellprice = 10
