// Deleted the flavorful desc from Vanderlin until I can think of a better desc. 
/obj/item/recipe_book/leatherworking
	name = "The Tanned Hide Tome: Mastery of Leather and Craft"
	wiki_name = "Leatherworking"
	icon_state = "book8_0"
	base_icon_state = "book8"

	types = list(
	/datum/crafting_recipe/roguetown/tallow,
	/datum/crafting_recipe/roguetown/leather, 		
	)

/obj/item/recipe_book/sewing
	name = "Threads of Destiny: A Tailor's Codex"
	wiki_name = "Sewing"
	icon_state = "book7_0"
	base_icon_state = "book7"

	types = list(
		/datum/crafting_recipe/roguetown/survival/cloth, // Screw it just in case
		/datum/crafting_recipe/roguetown/sewing,
		)

/obj/item/recipe_book/blacksmithing
	name = "The Smith’s Legacy"
	wiki_name = "Blacksmithing"
	icon_state = "book3_0"
	base_icon_state = "book3"

	types = list(/datum/anvil_recipe)

/obj/item/recipe_book/engineering
	name = "The Artificer's Handbook"
	wiki_name = "Engineering"
	icon_state = "book4_0"
	base_icon_state = "book4"

	types = list(/datum/crafting_recipe/roguetown/engineering)

// I gave up I will make better names later lol
// Was gonna do a carpenter + masonry handbook but 
// Both are under structures so I will just make them one and add categories
// Later 
/obj/item/recipe_book/builder
	name = "The Builder's Handbook - For Carpenters and Masons"
	wiki_name = "Building"
	icon_state = "book5_0"
	base_icon_state = "book5"

	types = list(
		/datum/crafting_recipe/roguetown/structure,
		/datum/crafting_recipe/roguetown/turfs,

		/datum/crafting_recipe/roguetown/turfs/brick,
		/datum/crafting_recipe/roguetown/turfs/brick/floor,
		/datum/crafting_recipe/roguetown/turfs/brick/wall,
		/datum/crafting_recipe/roguetown/turfs/brick/window,

		/datum/crafting_recipe/roguetown/turfs/fancywindow,		
		/datum/crafting_recipe/roguetown/turfs/fancywindow/openclose,

		/datum/crafting_recipe/roguetown/turfs/hay,

		/datum/crafting_recipe/roguetown/turfs/reinforcedwindow,
		/datum/crafting_recipe/roguetown/turfs/reinforcedwindow/openclose,
		/datum/crafting_recipe/roguetown/turfs/roguewindow,
		/datum/crafting_recipe/roguetown/turfs/roguewindow/dynamic,
		/datum/crafting_recipe/roguetown/turfs/roguewindow/stone,

		/datum/crafting_recipe/roguetown/turfs/stone,
		/datum/crafting_recipe/roguetown/turfs/stone/cobblerock,
		/datum/crafting_recipe/roguetown/turfs/stone/cobble,
		/datum/crafting_recipe/roguetown/turfs/stone/block,
		/datum/crafting_recipe/roguetown/turfs/stone/newstone,
		/datum/crafting_recipe/roguetown/turfs/stone/herringbone,
		/datum/crafting_recipe/roguetown/turfs/stone/hexstone,
		/datum/crafting_recipe/roguetown/turfs/stone/platform,
		/datum/crafting_recipe/roguetown/turfs/stone/wall,
		/datum/crafting_recipe/roguetown/turfs/stone/brick,
		/datum/crafting_recipe/roguetown/turfs/stone/decorated,
		/datum/crafting_recipe/roguetown/turfs/stone/craft,
		/datum/crafting_recipe/roguetown/turfs/stone/window,

		/datum/crafting_recipe/roguetown/turfs/tentwall,
		/datum/crafting_recipe/roguetown/turfs/tentdoor,
		/datum/crafting_recipe/roguetown/turfs/twigplatform,
		/datum/crafting_recipe/roguetown/turfs/twig,

		/datum/crafting_recipe/roguetown/turfs/wood,
		/datum/crafting_recipe/roguetown/turfs/wood/floor,
		/datum/crafting_recipe/roguetown/turfs/wood/platform,
		/datum/crafting_recipe/roguetown/turfs/wood/wall,
		/datum/crafting_recipe/roguetown/turfs/wood/wall/alt,
		/datum/crafting_recipe/roguetown/turfs/wood/fancy,
		/datum/crafting_recipe/roguetown/turfs/wood/murderhole,
		/datum/crafting_recipe/roguetown/turfs/wood/murderhole/alt
		)

/obj/item/recipe_book/ceramics
	name = "The Potter's Handbook"
	wiki_name = "Ceramics"
	icon_state = "book5_0"
	base_icon_state = "book5"

	types = list(
		/datum/crafting_recipe/roguetown/structure/ceramicswheel,
		/datum/crafting_recipe/roguetown/ceramics
		)

// This book should be widely given to everyone
/obj/item/recipe_book/survival
	name = "Tips, Tricks, & Triumphs: The Novice's Handbook To Azuria"
	wiki_name = "Survival"
	desc = "A heftsome tome, filled to the brim with all the information you'd need to survive within Azuria. The golden bookmark seems to always lead you \
	to the page you needed the most, no matter how you flip it. </br>‎  </br>Check out Azure Peak's official wikipedia - https://azurepeak.miraheze.org/wiki/Main_Page - for \
	whatever comes to mind. </br>‎  </br>This particular tome can be recycled into the Stockpile for a small amount of free \
	mammons. </br>‎  </br>Activate the tome in your hand to open a searchable glossary, filled with most basic crafting recipes.  </br>‎  </br>Click the 'Mechanics' \
	tab to reveal a wide variety of tips and tricks, for getting started. Be warned, it's quite a lot; be prepared to scroll around, or hold shift while scrolling down \
	to compact more information into your chatbox's frame."
	icon_state = "starterguide_0"
	base_icon_state = "starterguide"
	sellprice = 5

	types = list(
		/datum/crafting_recipe/roguetown/survival,
		/datum/crafting_recipe/roguetown/tallow,
		)

/obj/item/recipe_book/survival/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Examining things will display a small blurb in the chatbox. If present, clicking the blurb's 'Mechanics' tab or '(?)' button will reveal more detailed information about the thing-in-question.")
	. += span_info("In particular, many things will have detailed tutorials about core mechanics inside of their 'Mechanics' tab. A bed can explain how sleeping works, a tree can explain how climbing works, and so-on. Examine the world around you to decipher its secrets.")
	. += span_info("Adventurers, Pilgrims, and other newcomers usually spawn to the south of Town. Following the cobblestone road - and any signs of civilization - will eventually lead you there.")
	. += span_info("Your character's skills are generally inherited by their chosen role, and greatly affects their ability to do many tasks. Click on the 'SKILLS' button in your HUD to see-and-learn-more about what you have.")
	. += span_info("The same principle applies to your character's core stats; Strength, Constitution, Perception, Willpower, Intelligence, Speed, and Fortune. A value of 'X' is considered the baseline.")
	. += span_info("Clicking the 'FEINT' button on your HUD allows you to toggle between a variety of intents, which changes your stance in COMBAT MODE. Shift-click each intent to learn more about their unique mechanics.")
	. += span_info("Below that are the four subintents; 'BITE', 'KICK', 'JUMP', and 'SPECIAL'. These are triggerable by middle-clicking. Toggling 'JUMP' and 'RUN' at the same time lets you LEAP across larger gaps.")
	. += span_info("Pressing 'C', by default, toggles COMBAT MODE. This allows your character to PARRY and DODGE incoming attacks, while greatly improving their capacity to fight back.")
	. += span_info("Pressing 'X', by default, allows you to RESIST. This is used for many circumstances; putting out fires on yourself, getting out of beds and chairs, escaping MANEATERS, and so on.")
	. += span_info("Pressing 'V', by default, lets you GET UP and LAY DOWN. This can be used to recover energy and stamina, represented by the blue and green bars on your HUD. Pace yourself, lest you be caught off-guard.")
	. += span_info("This tome can be turned into the Stockpile, traditionally located in a small alcove between the Innhouse and Smithy, for some coinage.")
	. += span_info("If you're ever stumped, try asking a question through the 'Mentorhelp' verb in the 'Admin' tab, located in your screen's top-right corner. Alternatively, try asking in the Discord's #mentor-talk channel.")
	. += span_info("Likewise, try checking out Azure Peak's official wikipedia - https://azurepeak.miraheze.org/wiki/Main_Page - for anything else you might wish to learn about.")
	. += span_info("And most importantly.. have fun!")

// TBD - Cauldron Recipes
/obj/item/recipe_book/alchemy
	name = "Secrets of Alchemy"
	wiki_name = "Alchemy"
	icon_state = "book3_0"
	base_icon_state = "book3"

	types = list(
		/datum/crafting_recipe/roguetown/structure/alch,
		/datum/crafting_recipe/roguetown/structure/cauldronalchemy,
		/datum/crafting_recipe/roguetown/alchemy,
		/datum/alch_grind_recipe,
		/datum/alch_cauldron_recipe
		)
 
/obj/item/recipe_book/cooking
	name = "The Culinary Codex"
	wiki_name = "Cooking"
	desc = "A book full of recipes and tips for cooking. This version looks very incomplete, and only contain brewing recipes. Perhaps it will be filled in later?"
	icon_state = "book2_0"
	base_icon_state = "book2"

	types = list(
		/datum/brewing_recipe,
		/datum/book_entry/brewing
	)

/obj/item/recipe_book/magic
	name = "The Magister's Grimoire"
	wiki_name = "Magic"
	icon_state = "book4_0"
	base_icon_state = "book4"

	types = list(
		/datum/book_entry/magic1,
		/datum/book_entry/magic2,
		/datum/crafting_recipe/roguetown/arcana,
		/datum/runeritual/summoning,
		/datum/runeritual/enchanting,
		/datum/runeritual/binding,
		/datum/runeritual/other,
		)


/obj/item/recipe_book/miracle_compendium
	name = "The Divine Accord: Miracles of the Gods"
	wiki_name = "Miracles"
	wiki_section = "Guides"
	can_spawn = FALSE
	wiki_only = TRUE
	icon_state = "book4_0"
	base_icon_state = "book4"

/obj/item/recipe_book/miracle_compendium/New()
	. = ..()
	build_miracle_registry()
	var/list/unique_spells = list()
	for(var/path_key in GLOB.miracle_registry)
		var/spell_path = text2path(path_key)
		if(spell_path && !(spell_path in unique_spells))
			unique_spells += spell_path
	types = unique_spells

/obj/item/recipe_book/spell_list
	name = "Spell List"
	wiki_name = "Spell List"
	wiki_section = "Guides"
	can_spawn = FALSE
	wiki_only = TRUE
	icon_state = "book4_0"
	base_icon_state = "book4"

/obj/item/recipe_book/spell_list/open_wiki_entry(mob/user)
	var/datum/aspect_viewer/viewer = new(user)
	viewer.ephemeral = TRUE
	viewer.ui_interact(user)
	return TRUE
