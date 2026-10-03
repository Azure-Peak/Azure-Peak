GLOBAL_LIST_EMPTY(quest_circumstances_recovery)
GLOBAL_LIST_EMPTY(quest_circumstances_carriage)
GLOBAL_LIST_EMPTY(quest_circumstances_recovery_bandits)

/datum/writ_circumstance
	var/list/phrasings

/datum/writ_circumstance/proc/render()
	if(!length(phrasings))
		return null
	return pick(phrasings)

/proc/init_writ_circumstances()
	GLOB.quest_circumstances_recovery = list()
	for(var/path in subtypesof(/datum/writ_circumstance/recovery))
		GLOB.quest_circumstances_recovery += new path()
	GLOB.quest_circumstances_carriage = list()
	for(var/path in subtypesof(/datum/writ_circumstance/carriage))
		GLOB.quest_circumstances_carriage += new path()
	GLOB.quest_circumstances_recovery_bandits = list()
	for(var/path in subtypesof(/datum/writ_circumstance/recovery_bandits))
		GLOB.quest_circumstances_recovery_bandits += new path()

/proc/pick_circumstance_from(list/pool)
	if(!length(pool))
		return ""
	var/datum/writ_circumstance/C = pick(pool)
	return C.render()

/proc/pick_recovery_circumstance()
	return pick_circumstance_from(GLOB.quest_circumstances_recovery)

/proc/pick_carriage_circumstance()
	return pick_circumstance_from(GLOB.quest_circumstances_carriage)

/proc/pick_recovery_bandits_circumstance()
	return pick_circumstance_from(GLOB.quest_circumstances_recovery_bandits)


/datum/writ_circumstance/recovery/caravan_storm
	phrasings = list(
		"Three nights past, a storm scattered a trade caravan along the forest road.",
		"Carters say a wagon overturned by the river.",
	)

/datum/writ_circumstance/recovery/peddler_lost
	phrasings = list(
		"A peddler went into the mire and did not come out.",
		"A shepherd found a merchant dead beside the road, their purse still full.",
	)

/datum/writ_circumstance/recovery/tax_wagon_broken
	phrasings = list(
		"When the tax wagon's axle broke on the back road, the carters hid the cargo and went for help.",
		"A cart carrying the Church's tithe broke down on the road. Its load was left under cover.",
	)

/datum/writ_circumstance/recovery/courier_dead
	phrasings = list(
		"Reported to the Steward: a Crown courier dead of fever off the road. The parcel must be recovered.",
		"A messenger of the realm left on this road and never reached the next town. Their satchel must be found.",
	)

/datum/writ_circumstance/recovery/cliff_drop
	phrasings = list(
		"On the high cliff path, a wagon lost its load over the edge.",
		"A woodcutter found parcels in the brambles below a steep hill. A cart had lost them on the way up.",
	)

/datum/writ_circumstance/recovery/thief_cache
	phrasings = list(
		"A thief who hid their takings in the wilds was hanged before they could fetch them.",
		"Tavern talk says a hanged thief buried their takings nearby.",
	)

/datum/writ_circumstance/recovery/noble_lost_kit
	phrasings = list(
		"Reported to the Steward: a retainer lost their lord's hunting kit when a hunt went wrong. The kit must be recovered.",
		"When beasts fell on a noble's hunting party, the party fled and left its gear on the trail.",
	)

/datum/writ_circumstance/recovery/seal_case_dropped
	phrasings = list(
		"A Steward's sealed case fell from a courier's saddle upon the road. It must be recovered.",
		"On the last market day, a messenger's bag burst at the gallop and scattered official parcels along the road.",
	)

/datum/writ_circumstance/recovery/flood_swept
	phrasings = list(
		"The spring flood carried a load of goods off the dock and down the river.",
		"Fishers have seen crates cast up on the shoals since the high water.",
	)


/datum/writ_circumstance/carriage/physician_urgent
	phrasings = list(
		"The matter is pressing. The physician hath need of these goods within the day.",
		"The recipient hath urgent need of this parcel. Make haste.",
	)

/datum/writ_circumstance/carriage/regular_runner_indisposed
	phrasings = list(
		"With the usual runner laid up by a broken leg, this parcel needs another carrier.",
		"Posted by the sender: the usual courier is down with fever. Another carrier is wanted.",
	)

/datum/writ_circumstance/carriage/courier_robbed
	phrasings = list(
		"Since brigands broke the last attempt at this carriage, the parcel has been packed again for a new holder.",
		"Highwaymen turned back the first courier. A hardier holder is sought for the second attempt.",
	)

/datum/writ_circumstance/carriage/contracted_shipment
	phrasings = list(
		"The recipient paid for this carriage in advance.",
		"The recipient paid for this carriage a week ago and is still waiting.",
	)

/datum/writ_circumstance/carriage/private_gift
	phrasings = list(
		"The parcel is a private gift. Its contents are no concern of the holder.",
		"The sender says it is a gift and asks that the seal stay unbroken.",
	)

/datum/writ_circumstance/carriage/sealed_confidential
	phrasings = list(
		"The seal is set fast, and the holder is not to know the contents.",
		"Let the holder not pry. What lies within is for the recipient alone.",
	)

/datum/writ_circumstance/carriage/replacement_for_spoilage
	phrasings = list(
		"When the first parcel spoiled on the road, the goods were prepared again. Deliver this one before it turns.",
		"The last parcel never arrived, and no one knows why. These goods replace it.",
	)

/datum/writ_circumstance/carriage/festival_provisioning
	phrasings = list(
		"The festival of the Tens is days away. The recipient needs these goods before it.",
		"A feast day approaches and these goods are needed at the recipient's hearth before it falls.",
	)

/datum/writ_circumstance/carriage/payment_in_kind
	phrasings = list(
		"Having no coin, the sender pays their debt in goods. The recipient will call it settled when this parcel arrives.",
		"The parcel is part payment by goods rather than coin, and the recipient holds the matter open until it arrives.",
	)


/datum/writ_circumstance/recovery_bandits/scattered_caravan
	phrasings = list(
		"The caravan was set upon and broken apart. The brigands made off with what they could carry. A sealed parcel remains under their guard.",
		"A carter who hid in the ditch saw the brigands carry the rest of the load to their camp. It must be taken back.",
	)

/datum/writ_circumstance/recovery_bandits/raided_tithe
	phrasings = list(
		"Brigands waylaid a tithe wagon and carried its goods to their camp. The parcel must be taken back.",
		"The Crown's tithe bearer was robbed, and the goods sit now in the keeping of the very volves who took them.",
	)

/datum/writ_circumstance/recovery_bandits/captured_courier
	phrasings = list(
		"Four daes ago, the band took a courier and their parcel. The parcel must be recovered.",
		"Raiders took a messenger's pack. No ransom has been asked. The pack must be taken back.",
	)

/datum/writ_circumstance/recovery_bandits/looted_shipment
	phrasings = list(
		"Reported to the Steward: a shipment seized on the road. The carrier is unhurt, and the band holds the goods.",
		"The carrier says the band took the goods at knifepoint and kept them.",
	)

/datum/writ_circumstance/recovery_bandits/cached_loot
	phrasings = list(
		"Among the plunder the brigands keep near their lair is a parcel that belongs to the realm. It must be recovered.",
		"Stolen goods of the Crown have been seen among the band's hoard and must be returned.",
	)

/datum/writ_circumstance/recovery_bandits/ambush_dropped
	phrasings = list(
		"In the chaos of the ambush the parcel was dropped, and the brigands keep watch over the spot in case of return.",
		"The carrier escaped with their life. The brigands now guard the parcel.",
	)
