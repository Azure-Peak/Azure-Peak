/proc/quality_delta_flavor(quality)
	if(quality < ITEM_QUALITY_STANDARD)
		return pick(
			"Your goods are shoddier than that ancient Naledi Merchant.",
			"My liege, it'll take three smiths and a dozen forges to fix this.",
			"My liege, please take a look at this complaint tablet.",
			"Bold of you to think this machine does not have a touchstone in it.",
			"The quality of your goods could fell kingdoms, starting with Azuria.",
			"Are you familiar with the shock of the masters' rod? No? You're about to be.",

		)
	if(quality > ITEM_QUALITY_STANDARD)
		return pick(
			"Fine work, my liege!",
			"Tis the finest goods I have seen in this land!",
			"Ah! Fineries suitable for a King!",
			"We scratched the goods! Of the FINEST quality, my liege!",
			"MORE!",
			"EXCELSIOR!",
			"ARISTOCRATIC!",
		)
	return null

/proc/navigator_quality_jab(quality)
	if(quality < ITEM_QUALITY_STANDARD)
		return pick(
			"THIS WASN'T WORTH LIFTING THE BALLOON FOR!",
			"THIS BESMIRCHES THE HONOR OF THE COMPANY!",
			"May Malum prevent who-ever made this from crafting again.",
			"...not even worth it's WEIGHT IN GOLD.",
			"FACTOR! WHAT IS THIS?!",
			"DID YOU PULL THIS FROM A GOBLIN'S RIBCAGE?",
			"Another bucket of PISS splashed in the company's face.",
			"If I had my way, we would lock you in a cell and have it BRICKED. UP!",
			"May your daes be cold and your mugs wooden.",
			"AT LEAST WASH THE BLOOD OFF THIS SCAVENGED CARK! NITESOIL! THE LOT OF IT!",
			"The next BASTERD to send me poor quality goods is getting paed with my CHAMBERPOT.",
					)
	if(quality > ITEM_QUALITY_STANDARD)
		return pick(
			"Mermaids are leaping out of the water for this cargo!",
			"These items might just make Psydon return!",
			"The Captain is most pleased.",
			"Tis was worth the trip to Azuria.",
			"The Company appreciates your efforts.",
			"FACTOR! MORE OF THIS!",
			"FACTOR! DOUBLE THIS ONE'S PAY!",
			"GROWTH AND PROFIT!",
			"LIVE AND DRINK, FRIEND!",
					)
	return null
