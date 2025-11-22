/datum/triumph_buy/communal
	name = "Communal Fund"
	desc = "Contribute to a shared pool of triumphs for communal benefits."
	category = TRIUMPH_CAT_COMMUNAL
	visible_on_active_menu = TRUE
	manual_activation = TRUE
	/// Maximum number of triumphs this pool can hold (0 for unlimited)
	var/maximum_pool = 0
	/// Current progress towards goal (0-100)
	var/progress = 0

/datum/triumph_buy/communal/New()
	. = ..()
	SStriumphs.communal_pools[type] = 0
	SStriumphs.communal_contributions[type] = list()
