/datum/virtue/utility/noble
	name = "Nobility"
	desc = "By birth, blade or brain, I am noble known to the royalty of these lands, and have all the benefits associated with it. I've cleverly stashed away a healthy amount of coinage, alongside a familial heirloom."
	added_traits = list(TRAIT_NOBLE)
	added_skills = list(list(/datum/skill/misc/reading, 1, 6))
	added_stashed_items = list("Heirloom Amulet" = /obj/item/clothing/neck/roguetown/ornateamulet/noble,
                                "Hefty Coinpurse" = /obj/item/storage/belt/rogue/pouch/coins/virtuepouch)

/datum/virtue/utility/noble/apply_to_human(mob/living/carbon/human/recipient)
	SStreasury.noble_incomes[recipient] += 15

/datum/virtue/utility/beautiful
	name = "Beautiful"
	desc = "Wherever I go, I turn heads, such is my natural beauty. I am also rather good in bed, though they always say that."
	custom_text = "Incompatible with Ugly virtue. Has a special interaction with Revenants."
	added_traits = list(TRAIT_BEAUTIFUL,TRAIT_GOODLOVER)
	added_stashed_items = list(
		"Hand Mirror" = /obj/item/handmirror)

/datum/virtue/utility/beautiful/handle_traits(mob/living/carbon/human/recipient)
	..()
	if(isdullahan(recipient))
		REMOVE_TRAIT(recipient, TRAIT_BEAUTIFUL, TRAIT_VIRTUE)
		ADD_TRAIT(recipient, TRAIT_BEAUTIFUL_UNCANNY, TRAIT_VIRTUE)
	if(HAS_TRAIT(recipient, TRAIT_UNSEEMLY))
		to_chat(recipient, "Your attractiveness is cancelled out! You become normal.")
		if(HAS_TRAIT(recipient, TRAIT_BEAUTIFUL))
			REMOVE_TRAIT(recipient, TRAIT_BEAUTIFUL, TRAIT_VIRTUE)
		REMOVE_TRAIT(recipient, TRAIT_UNSEEMLY, TRAIT_VIRTUE)

/datum/virtue/utility/deadened
	name = "Deadened"
	desc = "Some terrible incident colours my past, and now, I feel nothing."
	added_traits = list(TRAIT_NOMOOD)

/datum/virtue/utility/light_steps
	name = "Light Steps"
	desc = "Years of skulking about have left my steps quiet, and my hunched gait quicker."
	added_traits = list(TRAIT_LIGHT_STEP)
	added_skills = list(list(/datum/skill/misc/sneaking, 3, 6))

/datum/virtue/utility/resident
	name = "Resident"
	desc = "I'm a resident of Azure Peak. I have an account in the city's treasury and a home in the city."
	added_traits = list(TRAIT_RESIDENT)

/datum/virtue/utility/resident/apply_to_human(mob/living/carbon/human/recipient)
	var/mapswitch = 0
	if(SSmapping.config.map_name == "Dun World")
		mapswitch = 1

	if(mapswitch == 0)
		return
	if(recipient.mind?.assigned_role == "Adventurer" || recipient.mind?.assigned_role == "Mercenary" || recipient.mind?.assigned_role == "Court Agent")
		// Find tavern area for spawning
		var/area/spawn_area
		for(var/area/A in world)
			if(istype(A, /area/rogue/indoors/town/tavern))
				spawn_area = A
				break

		if(spawn_area)
			var/target_z = 3 //ground floor of tavern for dun manor / world
			var/target_y = 234 //dun world huge
			var/list/possible_chairs = list()

			for(var/obj/structure/chair/C in spawn_area)
				//z-level 3, wooden chair, and Y > north of tavern backrooms
				var/turf/T = get_turf(C)
				if(T && T.z == target_z && T.y > target_y && istype(C, /obj/structure/chair/wood/rogue) && !T.density && !T.is_blocked_turf(FALSE))
					possible_chairs += C

			if(length(possible_chairs))
				var/obj/structure/chair/chosen_chair = pick(possible_chairs)
				recipient.forceMove(get_turf(chosen_chair))
				chosen_chair.buckle_mob(recipient)
				to_chat(recipient, span_notice("As a resident of Azure Peak, you find yourself seated at a chair in the local tavern."))
			else
				var/list/possible_spawns = list()
				for(var/turf/T in spawn_area)
					if(T.z == target_z && T.y > (target_y + 4) && !T.density && !T.is_blocked_turf(FALSE))
						possible_spawns += T

				if(length(possible_spawns))
					var/turf/spawn_loc = pick(possible_spawns)
					recipient.forceMove(spawn_loc)
					to_chat(recipient, span_notice("As a resident of Azure Peak, you find yourself in the local tavern."))

/datum/virtue/utility/failed_squire
	name = "Failed Squire"
	desc = "I was once a squire in training, but failed to achieve knighthood. Though my dreams of glory were dashed, I retained my knowledge of equipment maintenance and repair, including how to polish arms and armor."
	added_traits = list(TRAIT_SQUIRE_REPAIR)
	added_stashed_items = list(
		"Hammer" = /obj/item/rogueweapon/hammer/iron,
		"Polishing Cream" = /obj/item/polishing_cream,
		"Fine Brush" = /obj/item/armor_brush,
		"Armor Plates" = /obj/item/repair_kit/metal,
		"Sewing Kit" = /obj/item/repair_kit,
	)

/datum/virtue/utility/failed_squire/apply_to_human(mob/living/carbon/human/recipient)
	to_chat(recipient, span_notice("Though you failed to become a knight, your training in equipment maintenance and repair remains useful."))
	to_chat(recipient, span_notice("You can retrieve your hammer and polishing tools from a tree, statue, or clock."))

/datum/virtue/utility/linguist
	name = "Intellectual"
	desc = "I've spent my life surrounded by various books or sophisticated foreigners, be it through travel or other fortunes beset on my life. I've picked up several tongues and wits, and keep a journal closeby. I can tell people's exact prowess."
	custom_text = "Maximizes Assess benefits with a bonus of the target's Stats. Allows the choice of 3 languages to learn upon joining. +1 INT."
	added_traits = list(TRAIT_INTELLECTUAL)
	added_skills = list(list(/datum/skill/misc/reading, 3, 6))
	added_stashed_items = list(
		"Quill" = /obj/item/natural/feather,
		"Scroll #1" = /obj/item/paper/scroll,
		"Scroll #2" = /obj/item/paper/scroll,
		"Book Crafting Kit" = /obj/item/book_crafting_kit,
		"Unfinished Skillbook" = /obj/item/skillbook/unfinished
	)

/datum/virtue/utility/linguist/apply_to_human(mob/living/carbon/human/recipient)
	recipient.change_stat(STATKEY_INT, 1)
	addtimer(CALLBACK(src, .proc/linguist_apply, recipient), 50)

/datum/virtue/utility/linguist/proc/linguist_apply(mob/living/carbon/human/recipient)
	var/static/list/selectable_languages = list(
		/datum/language/elvish,
		/datum/language/dwarvish,
		/datum/language/orcish,
		/datum/language/hellspeak,
		/datum/language/draconic,
		/datum/language/celestial,
		/datum/language/grenzelhoftian,
		/datum/language/kazengunese,
		/datum/language/otavan,
		/datum/language/etruscan,
		/datum/language/gronnic,
		/datum/language/aavnic
	)

	var/list/choices = list()
	for(var/language_type in selectable_languages)
		if(recipient.has_language(language_type))
			continue
		var/datum/language/a_language = new language_type()
		choices[a_language.name] = language_type

	if(length(choices))	//If this isn't true then we have no new languages learn -- we probably picked archivist
		var/lang_count = 3
		var/count = lang_count
		for(var/i in 1 to lang_count)
			var/chosen_language = input(recipient, "Choose your extra spoken language.", "VIRTUE: [count] LEFT") as null|anything in choices
			if(chosen_language)
				var/language_type = choices[chosen_language]
				recipient.grant_language(language_type)
				choices -= chosen_language
				to_chat(recipient, span_info("I recall my knowledge of [chosen_language]..."))
				count--

/datum/virtue/utility/deathless
	name = "Deathless"
	desc = "Some fell magick has rendered me inwardly unliving - I do not hunger, and I do not breathe."
	added_traits = list(TRAIT_NOHUNGER, TRAIT_NOBREATH)

/datum/virtue/utility/feral_appetite
	name = "Feral Appetite"
	desc = "Raw, toxic or spoiled food doesn't bother my superior digestive system."
	added_traits = list(TRAIT_NASTY_EATER)

/datum/virtue/utility/night_vision
	name = "Night-eyed"
	desc = "I have eyes able to see through cloying darkness. Incompatible with the vice Colorblind."
	added_traits = list(TRAIT_DARKVISION)
	custom_text = "Adds a button to toggle colorblindness to aid seeing in the dark. Taking this with the Colorblind vice will permanently colorblind you."

/datum/virtue/utility/night_vision/apply_to_human(mob/living/carbon/human/recipient)
	if(recipient.charflaw)
		if(recipient.charflaw.type == /datum/charflaw/colorblind)
			to_chat(recipient, "Your eyes have become permanently colorblind.")
		else
			recipient.verbs += /mob/living/carbon/human/proc/toggleblindness

/datum/virtue/utility/performer
	name = "Performer"
	desc = "Music, artistry and the act of showmanship carried me through life. I've hidden a favorite instrument of mine, know how to please anyone I touch, and how to crack the eggs of hecklers."
	custom_text = "Comes with a stashed instrument of your choice. You choose the instrument after spawning in."
	added_traits = list(TRAIT_NUTCRACKER, TRAIT_GOODLOVER)
	added_skills = list(list(/datum/skill/misc/music, 4, 4))

/datum/virtue/utility/performer/apply_to_human(mob/living/carbon/human/recipient)
    addtimer(CALLBACK(src, .proc/performer_apply, recipient), 50)

/datum/virtue/utility/performer/proc/performer_apply(mob/living/carbon/human/recipient)
	var/list/instruments = list()
	for(var/instrument_type in subtypesof(/obj/item/rogue/instrument))
		if(instrument_type == /obj/item/rogue/instrument/harp/handcarved)
			continue //Skip the donator personal item harp.
		var/obj/item/rogue/instrument/instr = new instrument_type()
		instruments[instr.name] = instrument_type
		qdel(instr)  // Clean up the temporary instance

	var/chosen_name = input(recipient, "What instrument did I stash?", "STASH") as null|anything in instruments
	if(chosen_name)
		var/instrument_type = instruments[chosen_name]
		recipient.mind?.special_items[chosen_name] = instrument_type

/datum/virtue/utility/larcenous
	name = "Larcenous"
	desc = "Whether it was asked of you, or by a calling for the rush deep within your hollow heart, you seek things that don't belong you. You know how to work a lock, and have stashed a ring of them, for just the occasion."
	added_stashed_items = list("Lockpick Ring" = /obj/item/lockpickring/mundane)
	added_skills = list(list(/datum/skill/misc/lockpicking, 3, 6))

/datum/virtue/utility/granary
	name = "Cunning Provisioner"
	added_traits = list(TRAIT_HOMESTEAD_EXPERT)
	desc = "You've worked in or around the docks enough to steal away a sack of supplies that no one would surely miss, just in case. You've picked up on some cooking and fishing tips in your spare time, as well."
	added_stashed_items = list("Bag of Food" = /obj/item/storage/roguebag/food)
	added_skills = list(list(/datum/skill/craft/cooking, 3, 6),
						list(/datum/skill/labor/fishing, 2, 6))

/datum/virtue/utility/forester
	name = "Forester"
	added_traits = list(TRAIT_HOMESTEAD_EXPERT)
	desc = "The forest is your home, or at least, it used to be. You always long to return and roam free once again, and you have not forgotten your knowledge on how to be self sufficient."
	added_stashed_items = list("Trusty hoe" = /obj/item/rogueweapon/hoe)
	added_skills = list(list(/datum/skill/craft/cooking, 2, 2),
						list(/datum/skill/misc/athletics, 2, 2),
						list(/datum/skill/labor/farming, 2, 2),
						list(/datum/skill/labor/fishing, 2, 2),
						list(/datum/skill/labor/lumberjacking, 2, 2)
	)

/datum/virtue/utility/homesteader
	name = "Pilgrim (-3 TRI)"
	added_traits = list(TRAIT_HOMESTEAD_EXPERT)
	desc= "As they say, 'hearth is where the heart is'. You are intimately familiar with the labors of lyfe, and have stowed away everything necessary to start anew: a hunting dagger, your trusty hoe, and a sack of assorted supplies."
	triumph_cost = 3
	added_stashed_items = list(
		"Hoe" = /obj/item/rogueweapon/hoe,
		"Bag of Food" = /obj/item/storage/roguebag/food,
		"Hunting Knife" = /obj/item/rogueweapon/huntingknife
	)
	added_skills = list(list(/datum/skill/craft/cooking, 3, 3),
						list(/datum/skill/misc/athletics, 2, 2),
						list(/datum/skill/labor/farming, 3, 3),
						list(/datum/skill/labor/fishing, 3, 3),
						list(/datum/skill/labor/lumberjacking, 2, 2),
						list(/datum/skill/combat/knives, 2, 2)
	)

/datum/virtue/utility/ugly
	name = "Ugly"
	desc = "Be it your family's habits in and out of womb, your own choices or Xylix's cruel roll of fate, you have been left unbearable to look at. Stuck to the unseen pits and crevices of the town, you've grown used to the foul odours of lyfe that often follow you. Corpses do not stink for you, and that is all the company you might find."
	custom_text = "Incompatible with Beautiful virtue."
	added_traits = list(TRAIT_UNSEEMLY, TRAIT_NOSTINK)

/datum/virtue/utility/ugly/handle_traits(mob/living/carbon/human/recipient)
	..()
	if(HAS_TRAIT(recipient, TRAIT_BEAUTIFUL))
		to_chat(recipient, "Your repulsiveness is cancelled out! You become normal.")
		REMOVE_TRAIT(recipient, TRAIT_BEAUTIFUL, TRAIT_VIRTUE)
		REMOVE_TRAIT(recipient, TRAIT_UNSEEMLY, TRAIT_VIRTUE)

/datum/virtue/utility/secondvoice
	name = "Second Voice"
	desc = "From performance, deception, or by a need to change yourself in uncanny ways, you've acquired a second, perfect voice. You may switch between them at any point."
	custom_text = "Grants access to a new 'Virtue' tab. It will have the options for setting and changing your voice."

/datum/virtue/utility/secondvoice/apply_to_human(mob/living/carbon/human/recipient)
	recipient.verbs += /mob/living/carbon/human/proc/changevoice
	recipient.verbs += /mob/living/carbon/human/proc/swapvoice

/datum/virtue/utility/keenears
	name = "Keen Ears"
	desc = "Cowering from authorities, loved ones or by a generous gift of the gods, you've adapted a keen sense of hearing, and can identify the speakers even when they are out of sight, their whispers ringing louder."
	added_traits = list(TRAIT_KEENEARS)
	custom_text = "You can identify known people who speak even when they are out of sight. You can hear people speaking normally above and below you, regardless of obstacles in the way. You can hear whispers from one tile further."

/datum/virtue/utility/tracker
	name = "Sleuth"
	desc = "You realised long ago that the ability to find a man is as helpful to aid the law as it is to evade it."
	added_skills = list(list(/datum/skill/misc/tracking, 3, 6))
	added_traits = list(TRAIT_SLEUTH)
	custom_text = "- Upon right clicking a track, you will Mark the person who made them <i>(Expert skill required, not exclusive to this Virtue)</i>.\n- Further tracks found will be automatically highlighted as theirs, along with the person themselves, if they are not sneaking or invisible at the time.\n- Reduces the cooldown for tracking, allows track examining right away, and movement no longer cancels tracking."

/datum/virtue/utility/bronzearm_r
	name = "Bronze Arm (R)"
	desc = "Through connections or wealth, my arm had been replaced by one of bronze and gears, that can grip and hold onto things. I've learned just a bit of Engineering as a result."
	custom_text = "Replaces your Right arm with a prosthetic Bronze one. Incompatible with Wood Arm (R) vice"
	added_skills = list(list(/datum/skill/craft/engineering, 1, 6))

/datum/virtue/utility/bronzearm_r/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	var/obj/item/bodypart/O = recipient.get_bodypart(BODY_ZONE_R_ARM)
	if(O)
		O.drop_limb()
		qdel(O)
	if(recipient.charflaw)
		if(recipient.charflaw.type == /datum/charflaw/limbloss/arm_r)
			to_chat(recipient, span_info("In my foolishness I believed a sharlatan who wished to trade in my wooden arm for one of bronze. It fell apart. Now I've no arm at all."))
		else
			var/obj/item/bodypart/r_arm/prosthetic/bronzeright/L = new()
			L.attach_limb(recipient)

/datum/virtue/utility/bronzearm_l
	name = "Bronze Arm (L)"
	desc = "Through connections or wealth, my arm had been replaced by one of bronze and gears, that can grip and hold onto things. I've learned just a bit of Engineering as a result."
	custom_text = "Replaces your Left arm with a prosthetic Bronze one. Incompatible with Wood Arm (L) vice"
	added_skills = list(list(/datum/skill/craft/engineering, 1, 6))

/datum/virtue/utility/bronzearm_l/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	var/obj/item/bodypart/O = recipient.get_bodypart(BODY_ZONE_L_ARM)
	if(O)
		O.drop_limb()
		qdel(O)
	if(recipient.charflaw)
		if(recipient.charflaw.type == /datum/charflaw/limbloss/arm_l)
			to_chat(recipient, span_info("In my foolishness I believed a sharlatan who wished to trade in my wooden arm for one of bronze. It fell apart. Now I've no arm at all."))
		else
			var/obj/item/bodypart/l_arm/prosthetic/bronzeleft/L = new()
			L.attach_limb(recipient)

/datum/virtue/utility/woodwalker
	name = "Woodwalker"
	desc = "After years of training in the wilds, I've learned to traverse the woods confidently, without breaking any twigs. I can even step lightly on leaves without falling, and I can gather twice as many things from bushes."
	added_traits = list(TRAIT_WOODWALKER, TRAIT_OUTDOORSMAN)

/datum/virtue/heretic/zchurch_keyholder
	name = "Defiled Keyholder"
	desc = "The 'Holy' See has their blood-stained grounds, and so do we. Underneath their noses, we pray to the true gods - I know the location of the local heretic conclave. Secrecy is paramount. If found out, I will surely be killed."
	added_traits = list(TRAIT_ZURCH)

/datum/virtue/utility/mountable
	name = "Mountable"
	desc = "You have trained and become fit enough to function as a suitable mount. People may ride you as they would a saiga."
	added_traits = list(TRAIT_MOUNTABLE)
