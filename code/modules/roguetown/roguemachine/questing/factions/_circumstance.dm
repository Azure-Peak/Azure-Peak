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
		"A trade caravan was scattered by storm upon the road, and its load lies strewn between the trees.",
		"Foul weather overturned a wagon at the bend of the river; goods of the realm now sit unclaimed in the mud.",
	)

/datum/writ_circumstance/recovery/peddler_lost
	phrasings = list(
		"A peddler was claimed by the mire, their pack abandoned where they fell.",
		"A wandering merchant met an ill end upon the road; their goods lie about them still, untouched.",
	)

/datum/writ_circumstance/recovery/tax_wagon_broken
	phrasings = list(
		"A tax-wagon's axle broke upon the back-road, and its cargo was hastily cached for retrieval.",
		"A tithe-bearer's cart cracked beneath its load and the goods were left under hasty cover.",
	)

/datum/writ_circumstance/recovery/pilgrim_fallen
	phrasings = list(
		"A pilgrim fell sick upon the holy road and shed their pack to the verge.",
		"The offerings of a pilgrim, taken ill, lie strewn at the wayside shrine.",
	)

/datum/writ_circumstance/recovery/courier_dead
	phrasings = list(
		"A courier of the Crown died of a fever in some forgotten hollow, and the parcel they bore lies with their bones.",
		"A messenger of the realm fell to mishap upon the road; their satchel and goods remain where they dropped.",
	)

/datum/writ_circumstance/recovery/cliff_drop
	phrasings = list(
		"Goods of the realm tumbled from a wagon upon the high cliffside path and lie scattered at the foot of the rocks.",
		"A cart dropped its load upon a steep grade, and the parcels lie tangled in the brambles below.",
	)

/datum/writ_circumstance/recovery/thief_cache
	phrasings = list(
		"A thief cached stolen goods in the wilds and was later put to the rope; the cache remains unrecovered.",
		"Stolen wares were hidden by a felon now hanged, and rumour places the hoard somewhere in the country.",
	)

/datum/writ_circumstance/recovery/noble_lost_kit
	phrasings = list(
		"A retainer of a noble house lost their charge's hunting kit upon a hunt that ended ill.",
		"A nobleman's gear was scattered when their hunting party was set upon by beasts; what remains lies upon the trail.",
	)

/datum/writ_circumstance/recovery/seal_case_dropped
	phrasings = list(
		"A Steward's seal-case fell from a courier's saddle upon the road and has not been recovered.",
		"Official parcels were lost when a messenger's bag burst upon the gallop home.",
	)

/datum/writ_circumstance/recovery/flood_swept
	phrasings = list(
		"The spring flood swept goods from a riverside dock and stranded them along the banks downstream.",
		"High water carried a load of goods from the wharf; what was not lost lies cast up upon the shoals.",
	)


/datum/writ_circumstance/carriage/physician_urgent
	phrasings = list(
		"The matter is pressing - the physician hath need of these goods within the day.",
		"The bearer is enjoined to make haste; the recipient hath particular need.",
	)

/datum/writ_circumstance/carriage/regular_runner_indisposed
	phrasings = list(
		"The regular runner of this route is indisposed by injury and cannot bear the parcel.",
		"The usual courier hath been laid low by fever; another hand is needed for this carriage.",
	)

/datum/writ_circumstance/carriage/courier_robbed
	phrasings = list(
		"A previous attempt at this carriage was undone by brigandage; the parcel has been re-prepared and waits upon a new bearer.",
		"The first courier was set upon by highwaymen and the parcel returned to issuer; a hardier bearer is sought for the second attempt.",
	)

/datum/writ_circumstance/carriage/contracted_shipment
	phrasings = list(
		"A standing contract demands this carriage be honoured; the recipient hath paid in advance.",
		"The recipient hath bought this carriage by writ of agreement and waits upon delivery.",
	)

/datum/writ_circumstance/carriage/private_gift
	phrasings = list(
		"The parcel is a private gift between parties; its contents are no concern of the bearer.",
		"This carriage is the favour of one party unto another; let the seal pass unbroken.",
	)

/datum/writ_circumstance/carriage/sealed_confidential
	phrasings = list(
		"The seal is set fast - the bearer is not to know the contents, on pain of the writ's forfeit.",
		"What lies within the parcel is a matter of the recipient alone; let the bearer not pry.",
	)

/datum/writ_circumstance/carriage/replacement_for_spoilage
	phrasings = list(
		"The first parcel was lost to spoilage upon the road; this second one bears the same goods, freshly prepared.",
		"A prior carriage was undone by mishap; the goods herein replace what was lost.",
	)

/datum/writ_circumstance/carriage/festival_provisioning
	phrasings = list(
		"The recipient prepares for a festival of the Tens, and the goods herein are wanted before the appointed day.",
		"A feast-day approaches and these goods are needed at the recipient's hearth before it falls.",
	)

/datum/writ_circumstance/carriage/payment_in_kind
	phrasings = list(
		"This carriage settles a debt rendered in kind, and the recipient awaits the goods to mark it paid.",
		"The parcel is part-payment by goods rather than coin, and the recipient holds the matter open until it arrives.",
	)


/datum/writ_circumstance/recovery_bandits/scattered_caravan
	phrasings = list(
		"The caravan was set upon and broken apart; the bandits made off with what they could carry, but a sealed parcel remains under their guard.",
		"Brigands took what they wished and left the rest cached in their lair; recover what is owed to the realm.",
	)

/datum/writ_circumstance/recovery_bandits/raided_tithe
	phrasings = list(
		"A tithe-wagon was waylaid and its goods carried into the bandit camp; the parcel must be wrested back.",
		"The Crown's tithe-bearer was robbed, and the goods sit now in the keeping of the very wolves who took them.",
	)

/datum/writ_circumstance/recovery_bandits/captured_courier
	phrasings = list(
		"A courier of the realm was taken alongside their parcel; the parcel remains with the band that captured them.",
		"A messenger's pack was claimed by raiders, who keep it for ransom or for spite.",
	)

/datum/writ_circumstance/recovery_bandits/looted_shipment
	phrasings = list(
		"A shipment was stripped from its bearer upon the road and is presently held by the band responsible.",
		"The goods herein were taken by force from a lawful carrier and are presently in the keeping of those who took them.",
	)

/datum/writ_circumstance/recovery_bandits/cached_loot
	phrasings = list(
		"The bandits cache their plunder near their lair; among it sits a parcel that belongs to the realm.",
		"Stolen goods of the Crown have been seen among the band's hoard, and must be returned.",
	)

/datum/writ_circumstance/recovery_bandits/ambush_dropped
	phrasings = list(
		"In the chaos of the ambush the parcel was dropped, and the bandits keep watch over the spot in case of return.",
		"The carrier escaped with their life but not the parcel, which the band now guards.",
	)
