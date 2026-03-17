SUBSYSTEM_DEF(rogueinfo)
	name = "RogueInfo Controller"
	flags = SS_NO_FIRE

	var/list/role_visibility = list(
		"blacksmith" = FALSE,
		"artificer"  = FALSE,
		"steward"    = FALSE,
		"duke"       = FALSE,
		"apothecary" = FALSE,
		"church"     = FALSE,
		"fisher"     = FALSE,
		"university" = FALSE,
		"innkeeper"  = FALSE,
		"tailor"     = FALSE,
		"bathhouse"  = FALSE,
		"merchant"   = FALSE,
		"freeform1"  = FALSE,
		"freeform2"  = FALSE
	)

	var/list/role_data = list(
		"blacksmith" = list(
			"desc" = "The guild blacksmith, adept at forging armor, weaponry, tools and other metal objects. They can also repair goods.",
			"note" = "No custom notes."
		),
		"artificer" = list(
			"desc" = "The guild artificer, expert in magicraft and mechanics. crossbows, cogs and such.",
			"note" = "No custom notes."
		),
		"steward" = list(
			"desc" = "The town steward, responsible for the stockpile, handing out adventurer contracts and hiring new personnel for the keep. May buy valuables.",
			"note" = "No custom notes."
		),
		"duke" = list(
			"desc" = "The duke of our glorious duchy is currently taking petitions.",
			"note" = "No custom notes."
		),
		"apothecary" = list(
			"desc" = "A practitioner of herbalism and alchemy, capable of creating medicines, balms, and curative tinctures. Get your wounds cured and the dead revived here.",
			"note" = "No custom notes."
		),
		"church" = list(
			"desc" = "The spiritual center of the town, providing guidance, funeral rites, healing and reviving the dead. Don't miss mass, you heretic.",
			"note" = "No custom notes."
		),
		"fisher" = list(
			"desc" = "The primary provider of aquatic resources, working the docks to the east to supply the town with fresh fish.",
			"note" = "No custom notes."
		),
		"university" = list(
			"desc" = "The academic hub of the town, dedicated to the study of history, science, and arcane theory. Often offers enchanting services or combat-capable mages.",
			"note" = "No custom notes."
		),
		"innkeeper" = list(
			"desc" = "Proprietor of the local tavern, keeping the peace (through alcohol) while offering lodging, supper and spirits to travellers.",
			"note" = "No custom notes."
		),
		"tailor" = list(
			"desc" = "A master of textiles, clothing, and fabrics, capable of repairing garments and crafting new finery.",
			"note" = "No custom notes."
		),
		"bathhouse" = list(
			"desc" = "The sanctuary of Eoran cleanliness, offering public sanitation and relaxation for the weary townsfolk. Unwind as our skilled attendants see to your every need.",
			"note" = "No custom notes."
		),
		"merchant" = list(
			"desc" = "A tradesperson specializing in the import and distribution of rare goods, artifacts, and general stock. Will, at times, buy rare goods as well. May buy valuables.",
			"note" = "No custom notes."
		),
		"freeform1" = list(
			"desc" = "A secondary role or faction operating within the town limits.",
			"note" = "No custom notes."
		),
		"freeform2" = list(
			"desc" = "A secondary role or faction operating within the town limits.",
			"note" = "No custom notes."
		),
	)

	var/list/all_flags = list()

/datum/controller/subsystem/rogueinfo/Initialize()
	. = ..()

/datum/controller/subsystem/rogueinfo/proc/set_role_visibility(role_name, new_status)
	if(!(role_name in role_visibility))
		return FALSE

	if(role_visibility[role_name] == new_status)
		return FALSE

	role_visibility[role_name] = new_status

	for(var/obj/structure/flagpole/F in all_flags)
		F.update_single_role(role_name, new_status)

	return TRUE
