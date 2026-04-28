/// Civic classification helpers. Maps a job title to a civic-class department used by the
/// Assembly for vote weighting and by other systems that care about class groupings. Kept as a
/// plain proc with no subsystem dependency so callers can use it without pulling the Assembly
/// or other modules into scope.

/proc/civic_department(job)
	if(!job)
		return "NONE"
	switch(job)
		if("Grand Duke", "Consort", "Prince", "Princess", "Regent", "Lord", "Lady", "Duke", "Duchess", "Count", "Countess", "Noble")
			return "KEEP"
		if("Hand", "Clerk", "Councillor", "Seneschal", "Steward", "Suitor", "Servant")
			return "KEEP"
		if("Knight", "Marshal", "Squire")
			return "KEEP"
		if("Sergeant", "Man at Arms", "Warden", "Watchman", "Veteran")
			return "KEEP"
		if("Inquisitor", "Absolutionist", "Orthodoxist")
			return "INQUISITION"
		if("Wretch", "Bandit", "Assassin", "Lunatic")
			return "EXCLUDED"
		if("Adventurer", "Mercenary", "Hangyaku", "Lirvan", "Routier", "Seonjang", "Slayer", "Trader", "Pilgrim", "Villager", "Sellsword")
			return "TOWN_TRANSIENT"
		if("Peasant", "Towner", "Sidefolk", "Serf", "Vagabond")
			return "TOWN_PEASANT"
		if("Innkeeper", "Guildsman", "Archivist", "Apothecary", "Tailor", "Crier", "Physician", "Tradesmith", "Magicians Associate", "Jester", "Burgher", "Resident", "Keeper")
			return "TOWN_BURGHER"
		if("Priest", "Acolyte", "Druid", "Sexton", "Templar", "Martyr", "Clergy")
			return "TOWN_CLERGY"
		if("Court Magician", "Merchant", "Guildmaster", "Bishop", "Bathmaster", "Head Physician", "Town Elder")
			return "TOWN_NOTABLE"
	return "NONE"
