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

/proc/barter_quality_jab(quality)
	switch(quality)
		if(ITEM_QUALITY_LOOTED, ITEM_QUALITY_RUINED, ITEM_QUALITY_AWFUL)
			return pick(
				"<i>You interrupt My matters... for this?</i>",
				"<i>Cast such refuse before Me again, and I shall remember your name.</i>",
				"<i>You mistake My greed for need. I require nothing you possess.</i>",
				"<i>I have seen kings executed for insults of lesser measure.</i>",
				"<i>You offer Me filth, then expect My favor?</i>",
			)

		if(ITEM_QUALITY_CRUDE)
			return pick(
				"<i>Crude... yet not beyond redemption.</i>",
				"<i>I shall melt it down. Its present form offends Me.</i>",
				"<i>There is profit hidden within. Barely.</i>",
				"<i>Your judgment falters, but not enough to deny Our bargain.</i>",
				"<i>See that your next tribute is worthy of My attention.</i>",
			)

		if(ITEM_QUALITY_ROUGH)
			return pick(
				"<i>A sensible offering.</i>",
				"<i>This possesses honest value.</i>",
				"<i>Our bargain proceeds.</i>",
				"<i>Acceptable. Continue.</i>",
				"<i>At least you understand what wealth resembles.</i>",
			)

		if(ITEM_QUALITY_FINE)
			return pick(
				"<i>Now you bargain with wisdom.</i>",
				"<i>A worthy addition to My vaults.</i>",
				"<i>You understand that value exists to be acquired.</i>",
				"<i>Such craftsmanship deserves preservation.</i>",
				"<i>You have pleased Me.</i>",
			)

		if(ITEM_QUALITY_FLAWLESS)
			return pick(
				"<i>Excellent. Few mortals relinquish treasures so freely.</i>",
				"<i>This shall not be forgotten.</i>",
				"<i>Beauty and value are seldom found together. You have both.</i>",
				"<i>A fitting tribute.</i>",
				"<i>I accept this with satisfaction.</i>",
			)

		if(ITEM_QUALITY_MASTERWORK)
			return pick(
				"<i>Magnificent. This shall endure beyond empires.</i>",
				"<i>You surrender perfection in pursuit of greater fortune. Admirable.</i>",
				"<i>This belongs among My greatest treasures.</i>",
				"<i>At last... an offering worthy of My notice.</i>",
				"<i>You have honored Our covenant.</i>",
			)

	return null
