/datum/virtue/utility/noble
	name = "Nobility"
	desc = "By birth, blade or brain, I am noble known to the royalty of these lands, and have all the benefits associated with it. I've cleverly stashed away a healthy amount of coinage, alongside a familial heirloom."
	restricted = TRUE
	races = list(/datum/species/construct, /datum/species/dullahan)
	added_traits = list(TRAIT_NOBLE, TRAIT_EXPERT_HUNTER)
	added_skills = list(list(/datum/skill/misc/reading, 1, 6))
	added_stashed_items = list("Heirloom Amulet" = /obj/item/clothing/neck/roguetown/ornateamulet/noble,
								"Hefty Coinpurse" = /obj/item/storage/belt/rogue/pouch/coins/virtuepouch)

/datum/virtue/utility/noble/apply_to_human(mob/living/carbon/human/recipient)
	SStreasury.noble_incomes[recipient] += 15

#define NOTABLE_BEAUTY "Beauty"
#define NOTABLE_STASH "Stashed Riches"
#define NOTABLE_RESIDENCY "Residency"
#define NOTABLE_SHREWD "Shrewd Appraisal"

/datum/virtue/utility/notable
	name = "Well Off"
	desc = "Fate or effort had blessed my lyfe with spoils, natural or earned."
	max_choices = 2	//Tentative. 2 is more interesting than getting all 4 easily.
	choice_costs = list(0, 0)
	stackable = TRUE
	extra_choices = list(	//These are so individually bespoke it's not even worth assoc listing them, all are snowflaked in the application proc instead.
		NOTABLE_BEAUTY,
		NOTABLE_STASH,
		NOTABLE_RESIDENCY,
		NOTABLE_SHREWD
	)
	choice_tooltips = list(
		NOTABLE_BEAUTY = "Just looking at me relieves some of the hardships of the world, and I'm quite good in bed.",
		NOTABLE_STASH = "I've a hidden coinpurse for a particularly dark dae.",
		NOTABLE_RESIDENCY = "I am a Resident of Azure Peak, with access to one of its buildings all to myself.",
		NOTABLE_SHREWD = "Grants Secular Appraise -- a spell that allows you to tell how much wealth someone has on them, and in their Meister."
	)

/datum/virtue/utility/notable/apply_to_human(mob/living/carbon/human/recipient)
	if(!triumph_check(recipient))
		return
	for(var/choice in picked_choices)
		switch(choice)
			if(NOTABLE_BEAUTY)
				ADD_TRAIT(recipient, TRAIT_BEAUTIFUL, TRAIT_VIRTUE)
				ADD_TRAIT(recipient, TRAIT_GOODLOVER, TRAIT_VIRTUE)
				recipient.mind?.special_items["Hand Mirror"] = /obj/item/handmirror
			if(NOTABLE_STASH)
				recipient.mind?.special_items["Weighty Coinpurse"] = /obj/item/storage/belt/rogue/pouch/coins/virtuepouch
			if(NOTABLE_SHREWD)
				ADD_TRAIT(recipient, TRAIT_SEEPRICES, TRAIT_VIRTUE)
				recipient.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/appraise/secular)
			if(NOTABLE_RESIDENCY)
				ADD_TRAIT(recipient, TRAIT_RESIDENT, TRAIT_VIRTUE)
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

#undef NOTABLE_BEAUTY
#undef NOTABLE_STASH
#undef NOTABLE_RESIDENCY
#undef NOTABLE_SHREWD

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

/datum/virtue/utility/intellectual
	name = "Intellectual"
	desc = "I've spent my life surrounded by various books or sophisticated foreigners, be it through travel or other fortunes beset on my life. I've picked up several tongues and wits, and keep a journal closeby. I can tell people's exact prowess."
	custom_text = "Maximizes Assess benefits with a bonus of the target's Stats. Allows the choice of up to 6 languages to learn."
	added_traits = list(TRAIT_INTELLECTUAL)
	added_skills = list(list(/datum/skill/misc/reading, 3, 6))
	added_stashed_items = list(
		"Quill" = /obj/item/natural/feather,
		"Scroll #1" = /obj/item/paper/scroll,
		"Scroll #2" = /obj/item/paper/scroll,
		"Book Crafting Kit" = /obj/item/book_crafting_kit,
		"Unfinished Skillbook" = /obj/item/skillbook/unfinished
	)
	max_choices = 6
	choice_costs = list(0, 0, 0, 2, 3, 4)
	extra_choices = list(
		"Elvish" = /datum/language/elvish,
		"Dwarvish" = /datum/language/dwarvish,
		"Orcish" = /datum/language/orcish,
		"Infernal" = /datum/language/hellspeak,
		"Draconic" = /datum/language/draconic,
		"Celestial" = /datum/language/celestial,
		"Ranesheni" = /datum/language/raneshi,
		"Grenzelhoftian" = /datum/language/grenzelhoftian,
		"Kazengunese" = /datum/language/kazengunese,
		"Lingyuese" = /datum/language/lingyuese,
		"Undercommon" = /datum/language/undercommon,
		"Otavan" = /datum/language/otavan,
		"Etruscan" = /datum/language/etruscan,
		"Gronnic" = /datum/language/gronnic,
		"Aavnic" = /datum/language/aavnic
	)

/datum/virtue/utility/intellectual/apply_to_human(mob/living/carbon/human/recipient)
	addtimer(CALLBACK(src, .proc/linguist_apply, recipient), 50)

/datum/virtue/utility/intellectual/proc/linguist_apply(mob/living/carbon/human/recipient)
	if(check_triumphs(recipient))
		for(var/lang in picked_choices)
			recipient.grant_language(extra_choices[lang])

/datum/virtue/utility/hollow
	name = "Hollow"
	desc = "Some fell magick has rendered me inwardly unliving - I do not hunger, and I do not breathe."
	added_traits = list(TRAIT_NOHUNGER, TRAIT_NOBREATH)

/datum/virtue/utility/deadened
	name = "Deadened"
	desc = "Some terrible incident colours my past, and now, I feel nothing."
	added_traits = list(TRAIT_NOMOOD)

/datum/virtue/utility/feral_appetite
	name = "Feral Appetite"
	desc = "Raw, toxic or spoiled food doesn't bother my superior digestive system."
	added_traits = list(TRAIT_NASTY_EATER)

/datum/virtue/utility/prowler
	name = "Prowler"
	desc = "I've learned to stalk the shadows, in step and in sight. My hands had also been honed to be deft."
	max_choices = 3	//Tentative, feels more fun to limit yourself to a set out of these rather than all of them. (Used to be 6)
	choice_costs = list(0, 0, 0)
	stackable = TRUE	//It's OK to take Virtuous and get everything here.
	choice_tooltips = list(
		"Light Steps" = "My steps are light and swift. I make less noise while sneaking and wearing armor, and can sneak much quicker.",
		"Second Voice" = "I am able to change my voice at will (Grants a button in 'Virtue' tab to change voice color)."
	)
	extra_choices = list(
		"Darksight" = TRAIT_DARKVISION,
		"Light Steps" = TRAIT_LIGHT_STEP,
		"Stashed Lockpick Ring" = /obj/item/lockpickring/mundane,
		"Sneak Skill (+2, Up to Legendary)" = /datum/skill/misc/sneaking,
		"Lockpick Skill (+3, Up to Legendary)" = /datum/skill/misc/lockpicking,
		"Second Voice"
		)

/datum/virtue/utility/prowler/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	if(triumph_check(recipient))
		for(var/choice in picked_choices)
			if(extra_choices[choice] in GLOB.roguetraits)
				ADD_TRAIT(recipient, extra_choices[choice], TRAIT_VIRTUE)
				if(choice == TRAIT_DARKVISION)
					if(recipient.has_flaw(/datum/charflaw/colorblind))
						to_chat(recipient, "Your eyes have become permanently colorblind.")
					else if(recipient.charflaws.len)
						recipient.verbs += /mob/living/carbon/human/proc/toggleblindness
			else if(ispath(extra_choices[choice], /datum/skill))
				if(extra_choices[choice] == /datum/skill/misc/sneaking)
					recipient.adjust_skillrank(extra_choices[choice], SKILL_LEVEL_APPRENTICE, silent = TRUE)
				else if(extra_choices[choice] == /datum/skill/misc/lockpicking)
					recipient.adjust_skillrank(extra_choices[choice], SKILL_LEVEL_JOURNEYMAN, silent = TRUE)
			else if(ispath(extra_choices[choice], /obj/item))
				var/obj/item/I = extra_choices[choice]
				recipient.mind?.special_items[capitalize(I::name)] = extra_choices[choice]
			else if(choice == "Second Voice")
				recipient.verbs += /mob/living/carbon/human/proc/changevoice
				recipient.verbs += /mob/living/carbon/human/proc/swapvoice
				recipient.AddComponent(/datum/component/voice_handler)

/datum/virtue/utility/performer
	name = "Performer"
	desc = "Music, artistry and the act of showmanship carried me through life. I've hidden a favorite instrument of mine, know how to please anyone I touch, and how to crack the eggs of hecklers."
	custom_text = "Comes with a stashed instrument of your choice. You choose the instrument after spawning in."
	added_traits = list(TRAIT_NUTCRACKER, TRAIT_GOODLOVER)
	added_skills = list(list(/datum/skill/misc/music, 4, 4))
	max_choices = 3
	choice_costs = list(0, 2, 2)
	extra_choices = list(
		"Guitar" = /obj/item/rogue/instrument/guitar,
		"Lute" = /obj/item/rogue/instrument/lute,
		"Hurdy Gurdy" = /obj/item/rogue/instrument/hurdygurdy,
		"Harp" = /obj/item/rogue/instrument/harp,
		"Flute" = /obj/item/rogue/instrument/flute,
		"Accordion" = /obj/item/rogue/instrument/accord,
		"Shamisen" = /obj/item/rogue/instrument/shamisen,
		"Drum" = /obj/item/rogue/instrument/drum,
		"Viola" = /obj/item/rogue/instrument/viola,
		"Vocal Talisman" = /obj/item/rogue/instrument/vocals,
		"Psyaltery" = /obj/item/rogue/instrument/psyaltery
	)

/datum/virtue/utility/performer/apply_to_human(mob/living/carbon/human/recipient)
	if(triumph_check(recipient))
		for(var/choice in picked_choices)
			if(ispath(extra_choices[choice], /obj/item))
				recipient.mind?.special_items[choice] = extra_choices[choice]

/datum/virtue/utility/granary
	name = "Cunning Provisioner"
	added_traits = list(TRAIT_HOMESTEAD_EXPERT)
	desc = "You've worked in or around the docks enough to steal away a sack of supplies that no one would surely miss, just in case. You've picked up on some cooking and fishing tips in your spare time, as well."
	added_stashed_items = list("Bag of Food" = /obj/item/storage/roguebag/food)
	added_skills = list(list(/datum/skill/craft/cooking, 3, 6),
						list(/datum/skill/labor/fishing, 2, 6))

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

/datum/virtue/utility/bronzelimbs
	name = "Bronze Limbs"
	desc = "Through connections or wealth, my limb had been replaced by one of bronze and gears, that can grip and hold onto things. I've learned just a bit of Engineering as a result."
	custom_text = "Replaces your chosen limbs with a prosthetic Bronze ones."
	added_skills = list(list(/datum/skill/craft/engineering, 1, 6))
	max_choices = 4
	stackable = TRUE //We're OK with this, it's fairly innocuous
	choice_costs = list(0, 0, 1, 2)
	extra_choices = list(
		"Right Arm",
		"Left Arm",
		"Right Leg",
		"Left Leg"
	)

/datum/virtue/utility/bronzelimbs/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	if(triumph_check(recipient))
		var/obj/item/bodypart/to_attach
		var/zone
		for(var/choice in picked_choices)
			switch(choice)
				if("Right Arm")
					to_attach = /obj/item/bodypart/r_arm/prosthetic/bronzeright
					zone = BODY_ZONE_R_ARM
				if("Left Arm")
					to_attach = /obj/item/bodypart/l_arm/prosthetic/bronzeleft
					zone = BODY_ZONE_L_ARM
				if("Right Leg")
					to_attach = /obj/item/bodypart/r_leg/prosthetic/bronzeright
					zone = BODY_ZONE_R_LEG
				if("Left Leg")
					to_attach = /obj/item/bodypart/l_leg/prosthetic/bronzeleft
					zone = BODY_ZONE_L_LEG
			var/obj/item/bodypart/O = recipient.get_bodypart(zone)
			if(O)
				O.drop_limb()
				qdel(O)
			if(recipient.charflaws.len)
				var/obj/item/bodypart/BP = new to_attach()
				BP.attach_limb(recipient)

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

// AUTHOR NOTE - Probably remove this from court, leader and inquisition roles later since the barrier to roleplaying this correctly as those roles is extremely high.
// Mostly meant as a virtue for strange fey creatures, or people roleplaying as if they have been influenced by hags positively in the past, following an active pact to avoid vengeance.
// Hags don't get a boon on this person, that's perhaps a choice to add later.
/datum/virtue/utility/feytouched
	name = "Feytouched"
	desc = "A vessel or creation of the Mossmother, or perhaps a puppet of the past. You are sympathetic to the hag's cause. Your connection to the fey allows you to offer lux or bloated leechticks and traverse the roots, though your mortal form is frail (-1 INT, -2 STR). The hag is aware of you; your lux is corrupted. You may know of old events, but as the decades lengthen, so does your recollection of them fade. Hag-boons cannot take hold."
	added_stats = list(STATKEY_INT = -1, STATKEY_STR = -2)
	added_traits = list(TRAIT_FEYTOUCHED)
	added_skills = list(list(/datum/skill/misc/medicine, 1, 4),
						list(/datum/skill/craft/alchemy, 1, 4)
	)
	added_stashed_items = list("Bag of Leechbait" = /obj/item/storage/roguebag/leechbait)

/datum/virtue/utility/feytouched/apply_to_human(mob/living/carbon/human/recipient)
	..() // Apply traits, stats, and languages first
	if(!recipient.mind)
		return
	for(var/mob/living/hag_mob in GLOB.active_hags)
		var/datum/mind/hag_mind = hag_mob.mind
		if(!hag_mind)
			continue
		hag_mind.i_know_person(recipient)
		recipient.mind.i_know_person(hag_mind)
		if(hag_mind.current)
			to_chat(hag_mind.current, span_boldnotice("A familiar rhythm pulse in the roots... [recipient.real_name] is walking the lands this week."))
	to_chat(recipient, span_boldnotice("The Mossmother's gaze lingers upon you. You are recognized by her daughters."))
