/proc/quality_delta_flavor(quality)
	if(quality < ITEM_QUALITY_STANDARD)
		return pick(
			"Your goods are shoddier than that ancient Naledi Merchant.",
			"My liege, I'll have to hire three smiths to remake that.",
			"I'd write a complaint tablet about you.",
			"Bold of you to think this machine does not have a touchstone in it.",
			"The quality of your goods could fell kingdoms, starting with Azuria.",
		)
	if(quality > ITEM_QUALITY_STANDARD)
		return pick(
			"Fine work, my liege!",
			"Tis the finest goods I have seen in this land!",
			"Ah! Fineries suitable for a King!",
			"I have scratched the goods and confirm it is of the highest quality",
			"MORE!",
		)
	return null

/proc/navigator_quality_jab(quality)
	if(quality < ITEM_QUALITY_STANDARD)
		return pick(
			"This is not even worth lifting the balloon for",
			"This besmirches the honor of the Company.",
			"Such goods are beneath the dignity of Malum",
			"This is not even worth its weight",
			"FACTOR! WHAT IS THIS!",
		)
	if(quality > ITEM_QUALITY_STANDARD)
		return pick(
			"Mermaids are leaping out of the water for this cargo!",
			"Surely, Psydon will return to observe the quality of your cargo.",
			"The Captain is most pleased.",
			"Tis was worth the trip to Azuria.",
			"The Company appreciates your efforts.",
		)
	return null
