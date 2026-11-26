GLOBAL_LIST_INIT(petition_categories, build_petition_categories())

/proc/build_petition_categories()
	var/list/cats = list()
	cats[PETITION_CATEGORY_MATERIALS] = list(
		"label" = "Materials",
		"description" = "Artificery.",
		"cost" = PETITION_COST_MATERIALS,
		"kinds" = list(
			/datum/request_kind/artificery,
		),
	)
	cats[PETITION_CATEGORY_ARMS] = list(
		"label" = "Arms & Harness",
		"description" = "Finished weapons and armor.",
		"cost" = PETITION_COST_ARMS,
		"kinds" = list(
			/datum/request_kind/arms,
			/datum/request_kind/heavy_armor,
			/datum/request_kind/light_armor,
		),
	)
	cats[PETITION_CATEGORY_LUXURIES] = list(
		"label" = "Luxuries",
		"description" = "Court finery and jewelry.",
		"cost" = PETITION_COST_LUXURIES,
		"kinds" = list(
			/datum/request_kind/finery,
			/datum/request_kind/jewelry,
		),
	)
	cats[PETITION_CATEGORY_ALCHEMY] = list(
		"label" = "Alchemy & Care",
		"description" = "Finished potions and prosthetics.",
		"cost" = PETITION_COST_ALCHEMY,
		"kinds" = list(
			/datum/request_kind/potions,
			/datum/request_kind/prosthetics,
		),
	)
	cats[PETITION_CATEGORY_MASTERWORK] = list(
		"label" = "Masterwork",
		"description" = "Showpiece commissions - artificed panoply, hunt trophies.",
		"cost" = PETITION_COST_MASTERWORK,
		"kinds" = list(
			/datum/request_kind/artificed_panoply,
			/datum/request_kind/hunt_trophies,
		),
	)
	return cats
