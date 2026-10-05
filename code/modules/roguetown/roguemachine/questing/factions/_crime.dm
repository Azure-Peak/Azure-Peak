GLOBAL_LIST_EMPTY(quest_crimes)

/datum/quest_crime
	var/id
	var/tier = CRIME_TIER_COMMON
	var/list/phrasings

/datum/quest_crime/proc/render()
	if(!length(phrasings))
		return null
	return pick(phrasings)

/proc/init_quest_crimes()
	GLOB.quest_crimes = list()
	for(var/path in subtypesof(/datum/quest_crime))
		var/datum/quest_crime/C = new path()
		if(!C.id)
			continue
		if(GLOB.quest_crimes[C.id])
			CRASH("Duplicate quest_crime id: [C.id]")
		GLOB.quest_crimes[C.id] = C

/proc/get_quest_crime(id)
	return GLOB.quest_crimes[id]


/datum/quest_crime/petty_temple_wine
	id = CRIME_PETTY_TEMPLE_WINE
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"the drinking of wine set by for the temple's rites, against the peace of the Tens",
		"drinking the altar wine before the rites",
	)

/datum/quest_crime/petty_alms_theft
	id = CRIME_PETTY_ALMS_THEFT
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"the theft of six zennies' worth of bread set aside for the poor",
		"eating the bread laid out for the alms bowl",
	)

/datum/quest_crime/petty_relieving
	id = CRIME_PETTY_RELIEVING
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"fouling a wayside shrine",
		"the fouling of a cairn raised to the Tens",
		"the fouling of a signpost raised at the Duke's expense, by way of their own bowels"
	)

/datum/quest_crime/petty_chicken
	id = CRIME_PETTY_CHICKEN
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"the taking of a hen worth two zennies from a cottar's yard",
		"stealing a goose that bit the watchman",
	)

/datum/quest_crime/petty_orchard
	id = CRIME_PETTY_ORCHARD
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"the stripping of an orchard not their own",
		"picking a neighbour's apples while the neighbour watched",
	)

/datum/quest_crime/petty_offering_eating
	id = CRIME_PETTY_OFFERING_EATING
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"the eating of votive cake left at the shrine",
		"mistaking a shrine for a tavern and eating the offerings",
	)

/datum/quest_crime/petty_priest_mocking
	id = CRIME_PETTY_PRIEST_MOCKING
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"mocking a priest in the market square",
		"the singing of unseemly verses about a priest of the Tens",
	)

/datum/quest_crime/petty_drinking_temple
	id = CRIME_PETTY_DRINKING_TEMPLE
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"entering the temple drunk at midnight",
		"the raising of a loud quarrel within the temple during prayers",
	)

/datum/quest_crime/petty_brawl
	id = CRIME_PETTY_BRAWL
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"brawling in a tavern, against the peace of the Duke",
		"the smiting of a lawful man over a spilled cup",
	)

/datum/quest_crime/petty_dueling
	id = CRIME_PETTY_DUELING
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"the drawing of steel over an unpaid wager of two zennies",
		"brawling with drawn steel over a trifle",
	)

/datum/quest_crime/petty_dog_kicking
	id = CRIME_PETTY_DOG_KICKING
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"the kicking of a herald's dog",
		"beating the Duke's mule",
	)

/datum/quest_crime/petty_signpost
	id = CRIME_PETTY_SIGNPOST
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"pulling down the Duke's signpost",
		"writing rude words on a milestone of the Duke's Road and spelling them wrong",
	)

/datum/quest_crime/petty_proposal_scorn
	id = CRIME_PETTY_PROPOSAL_SCORN
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"the spurning with insult of a suitor who proposed in good faith, against the peace of Eora",
		"reading a suitor's love letter aloud in the tavern",
	)

/datum/quest_crime/petty_barren_mock
	id = CRIME_PETTY_BARREN_MOCK
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"mocking a childless woman in the market",
		"the taunting of a parent at their child's grave",
	)

/datum/quest_crime/petty_guest_wine
	id = CRIME_PETTY_GUEST_WINE
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"spitting in a guest's wine before pouring it",
		"the souring of bread set out for a guest",
	)

/datum/quest_crime/petty_tombstone_insult
	id = CRIME_PETTY_TOMBSTONE_INSULT
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"the carving of unkind verse upon a tombstone",
		"the daubing of a rude rhyme upon a tombstone that cost its family forty zennies",
	)


/datum/quest_crime/brigandage
	id = CRIME_BRIGANDAGE
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"brigandage upon the Duke's Road",
		"the laying of ambush upon the road with intent to rob",
	)

/datum/quest_crime/road_robbery
	id = CRIME_ROAD_ROBBERY
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"the robbery of merchants on the road, against the peace of the Duke",
		"the taking of a wool cart worth ninety zennies from a merchant on the road",
	)

/datum/quest_crime/pilgrim_robbery
	id = CRIME_PILGRIM_ROBBERY
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"the robbery of pilgrims bearing offerings to the shrines",
		"cutting the purses of pilgrims",
	)

/datum/quest_crime/murder_stealth
	id = CRIME_MURDER_STEALTH
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"murder by stealth and ambush",
		"the murder of a sleeping carter",
		"murder done by night, that none might raise the hue and cry",
		"the slaying of free folk by hidden hand, against Ravox's law",
	)

/datum/quest_crime/murder_watch
	id = CRIME_MURDER_WATCH
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"the slaying of a man of the Retinue, knowing him to be such",
		"the murder of an officer of the Duke",
	)

/datum/quest_crime/herald_slaying
	id = CRIME_HERALD_SLAYING
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"the murder of a herald carrying sealed letters",
		"wounding a messenger of the Duke under safe conduct",
		"the wounding of a messenger of the Duke under safe conduct sworn upon Ravox's hilt",
	)

/datum/quest_crime/arson_night
	id = CRIME_ARSON_NIGHT
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"arson of a steading by night",
		"the setting of fire to a neighbour's thatch over a quarrel about a fence",
		"the setting of fire by night to a house, its household asleep within, against the peace of Astrata",
	)

/datum/quest_crime/granary_burning
	id = CRIME_GRANARY_BURNING
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"the burning of a granary in time of want",
		"the burning of three hundred bushels of the village's rye",
		"the burning of a granary in time of want, that Astrata's grain burned to ash before hungry mouths",
	)

/datum/quest_crime/burglary
	id = CRIME_BURGLARY
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"burglary of a household at night",
		"the taking of thirty zennies from under a tanner's floorboards by night",
	)

/datum/quest_crime/cattle_lifting
	id = CRIME_CATTLE_LIFTING
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"driving off cattle from the common pasture",
		"the driving off of four cows worth eighty zennies from a farmer's byre",
		"the reiving of kine from honest holders, a theft of Dendor's bounty",
	)

/datum/quest_crime/horse_theft
	id = CRIME_HORSE_THEFT
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"stealing a horse and selling it back to its owner",
		"the running off of mounts kept in lawful keeping",
	)

/datum/quest_crime/coin_clipping
	id = CRIME_COIN_CLIPPING
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"the passing of clipped zennies, knowing them to be such",
		"counterfeiting the Duke's coin",
	)

/datum/quest_crime/seal_forgery
	id = CRIME_SEAL_FORGERY
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"forging the Steward's seal",
		"setting false sigil to parchment, that lies bore the seal of law",
	)

/datum/quest_crime/prison_breaking
	id = CRIME_PRISON_BREAKING
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"breach of prison",
		"the freeing of felons from the Duke's dungeon",
	)

/datum/quest_crime/harbouring_outlaws
	id = CRIME_HARBOURING_OUTLAWS
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"the harbouring of outlaws, knowing them to be such",
		"harbouring outlaws, knowing them to be such",
	)

/datum/quest_crime/receiving_stolen
	id = CRIME_RECEIVING_STOLEN
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"receiving stolen goods, knowing them to be stolen",
		"the buying of a stolen saddle for a quarter of its worth",
	)

/datum/quest_crime/poaching_land
	id = CRIME_POACHING_LAND
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"the slaying of deer beyond need and leaving them to rot, against the strictures of Dendor",
		"the killing of eleven deer in one day and the eating of none",
	)

/datum/quest_crime/poaching_fish
	id = CRIME_POACHING_FISH
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"the netting of forty baskets of fish left to spoil on the shore",
		"the casting of nets beyond need, against the peace of Abyssor",
	)

/datum/quest_crime/false_relics
	id = CRIME_FALSE_RELICS
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"the selling of a relic of Astrata that was a pig's knuckle",
		"the selling of false relics, knowing them to be such",
	)


/datum/quest_crime/treason_lord
	id = CRIME_TREASON_LORD
	tier = CRIME_TIER_OATH
	phrasings = list(
		"treason against their sworn lord",
		"the betrayal of those whose bread they had eaten",
		"treason against the lord to whom they had sworn faith before Ravox's altar",
	)

/datum/quest_crime/oath_breaking
	id = CRIME_OATH_BREAKING
	tier = CRIME_TIER_OATH
	phrasings = list(
		"the breaking of the oath sworn before Ravox upon hilt and altar",
		"forswearing an oath taken before Ravox",
	)

/datum/quest_crime/desertion
	id = CRIME_DESERTION
	tier = CRIME_TIER_OATH
	phrasings = list(
		"desertion from the Duke's levy in time of war",
		"the casting down of arms and the outrunning of the enemy's horse",
		"desertion from the Duke's levy on the eve of battle, against the oath sworn before Ravox",
	)

/datum/quest_crime/foreign_pay
	id = CRIME_FOREIGN_PAY
	tier = CRIME_TIER_OATH
	phrasings = list(
		"taking a foreign captain's pay",
		"selling their sword to a foreign banner while still sworn to the Duke",
	)

/datum/quest_crime/sedition
	id = CRIME_SEDITION
	tier = CRIME_TIER_OATH
	phrasings = list(
		"the stirring of common folk to riot, against the peace of the Duke",
		"calling the Duke a fool in three taverns in one night",
	)

/datum/quest_crime/compass_death
	id = CRIME_COMPASS_DEATH
	tier = CRIME_TIER_OATH
	phrasings = list(
		"compassing the death of a sworn officer of the Duke",
		"plotting the murder of the Duke's officers",
		"compassing the death of a sworn officer of the Duke, against Ravox's law",
	)

/datum/quest_crime/adhering_enemies
	id = CRIME_ADHERING_ENEMIES
	tier = CRIME_TIER_OATH
	phrasings = list(
		"adhering to the Duke's enemies, and giving them aid and counsel",
		"the carrying of bread to the Duke's enemies, knowing them to be such",
	)

/datum/quest_crime/oath_betrayal
	id = CRIME_OATH_BETRAYAL
	tier = CRIME_TIER_OATH
	phrasings = list(
		"the betrayal of an oathed companion in the hour of need, against the faith sworn before Ravox",
		"the abandonment of a sworn companion to their death",
	)

/datum/quest_crime/marriage_vow_broken
	id = CRIME_MARRIAGE_VOW_BROKEN
	tier = CRIME_TIER_OATH
	phrasings = list(
		"the breaking of marriage vow sworn before Eora",
		"abandoning a spouse on the wedding night and taking the dowry",
	)

/datum/quest_crime/sacrilege_temple
	id = CRIME_SACRILEGE_TEMPLE
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"sacrilege in a temple of the Tens",
		"the fouling of an altar, against the peace of the Tens",
	)

/datum/quest_crime/priest_slaying
	id = CRIME_PRIEST_SLAYING
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"the slaying of a priest before their own altar",
		"shedding a priest's blood inside the temple",
		"the slaying of a priest before their own altar, that the blood of Astrata's servant cried out from the stones",
	)

/datum/quest_crime/shrine_robbery
	id = CRIME_SHRINE_ROBBERY
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"the robbery of a shrine and the bearing away of holy gear",
		"the taking of a silver offering bowl worth fifty zennies from a shrine",
	)

/datum/quest_crime/defiling_ground
	id = CRIME_DEFILING_GROUND
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"the defiling of consecrated ground",
		"the digging of a privy in consecrated ground",
		"the defiling of ground blessed by Dendor, against the peace of the Tens",
	)

/datum/quest_crime/sanctuary_breaking
	id = CRIME_SANCTUARY_BREAKING
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"the breaking of sanctuary, and the dragging forth of those who had sought it",
		"the seizing of a fugitive at the altar, knowing them to be in sanctuary",
	)

/datum/quest_crime/cleric_robbery
	id = CRIME_CLERIC_ROBBERY
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"the robbery of a cleric upon the road, in their vestments",
		"the taking of eight zennies and a prayer book from a priest on the Duke's Road",
	)

/datum/quest_crime/tomb_desecration
	id = CRIME_TOMB_DESECRATION
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"breaking open a tomb",
		"the breaking of a family crypt and the taking of the rings from the dead",
		"the desecration of a tomb, against the peace of Necra",
	)

/datum/quest_crime/relic_theft
	id = CRIME_RELIC_THEFT
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"the theft of a holy bone and the leaving of a chicken bone in its place",
		"the bearing away of holy bones, that the priests cry shame",
	)

/datum/quest_crime/simony
	id = CRIME_SIMONY
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"the buying of a priest's office for two hundred zennies",
		"selling blessings for mammon",
	)

/datum/quest_crime/altar_casting_down
	id = CRIME_ALTAR_CASTING_DOWN
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"the casting down of an altar of the Tens",
		"the breaking of an altar stone to mend a wall",
	)

/datum/quest_crime/pilgrim_slaughter
	id = CRIME_PILGRIM_SLAUGHTER
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"the murder of pilgrims on the road",
		"a wholesale shedding of blood among those bound for the shrines",
	)

/datum/quest_crime/temple_peace_breaking
	id = CRIME_TEMPLE_PEACE_BREAKING
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"the breaking of the temple's peace, that bared steel was borne within the precinct",
		"the drawing of blade upon holy ground",
	)

/datum/quest_crime/well_poisoning
	id = CRIME_WELL_POISONING
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"the poisoning of a holy well",
		"the fouling of a holy well with a dead goat",
		"the poisoning of a healing spring, against the peace of Pestra and Abyssor",
	)

/datum/quest_crime/eoran_tree_felled
	id = CRIME_EORAN_TREE_FELLED
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"the felling of an Eoran shrine tree hung with lovers' ribbons, against the peace of Eora",
		"the cutting down of a tree sacred to Eora for eight zennies' worth of firewood",
	)

/datum/quest_crime/necran_procession_broken
	id = CRIME_NECRAN_PROCESSION_BROKEN
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"the disturbance of a funeral procession, against the peace of Necra",
		"overturning a bier on its way to the grave",
	)


/datum/quest_crime/apostasy
	id = CRIME_APOSTASY
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"apostasy from the Tens",
		"the casting off of holy bond, and laughter at the altar",
	)

/datum/quest_crime/forbidden_doctrine
	id = CRIME_FORBIDDEN_DOCTRINE
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"the teaching of doctrines forbidden by the Holy See",
		"preaching heresy to cows when no one else would listen",
	)

/datum/quest_crime/forbidden_books
	id = CRIME_FORBIDDEN_BOOKS
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"the keeping of forbidden books, knowing them to be such",
		"copying condemned books for sale",
	)

/datum/quest_crime/ascendant_consorting
	id = CRIME_ASCENDANT_CONSORTING
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"consorting with the false gods Ascendant",
		"the burning of incense to Ascendant powers, against the peace of the Tens",
	)

/datum/quest_crime/demonic_pact
	id = CRIME_DEMONIC_PACT
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"the making of a pact with demons",
		"signing a pact in blood for a better harvest",
	)

/datum/quest_crime/maleficium
	id = CRIME_MALEFICIUM
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"the working of a curse that killed a neighbour's eleven cows",
		"working curses on their neighbours",
	)

/datum/quest_crime/summoning
	id = CRIME_SUMMONING
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"the summoning of that which the Tens had cast down",
		"the calling up of creatures from the infernal realms, without proper bound and consultation",
	)

/datum/quest_crime/necromancy
	id = CRIME_NECROMANCY
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"the raising of a dead ox to pull their plough",
		"the binding of corpse and bone to walk again, against Necra's own peace",
	)

/datum/quest_crime/blasphemy
	id = CRIME_BLASPHEMY
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"blasphemy openly spoken in market and at the temple door",
		"the cursing of the Tens before witnesses",
	)

/datum/quest_crime/host_desecration
	id = CRIME_HOST_DESECRATION
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"feeding consecrated bread to dogs",
		"the eating of consecrated bread at table, knowing it to be such",
		"the breaking of consecrated bread, and the casting of Eora's gift to dogs",
	)

/datum/quest_crime/priestly_blood
	id = CRIME_PRIESTLY_BLOOD
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"the shedding of priestly blood with malice aforethought",
		"the paying of thirty zennies for the murder of a priest",
	)

/datum/quest_crime/dreamer_sacrifice
	id = CRIME_DREAMER_SACRIFICE
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"the drowning of bound captives to wake the Dreamer",
		"the offering of captives to the sea, against the peace of Abyssor",
	)

/datum/quest_crime/inhumen_invocation
	id = CRIME_INHUMEN_INVOCATION
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"speaking the names the Holy See forbids",
	)


/datum/quest_crime/piracy
	id = CRIME_PIRACY
	tier = CRIME_TIER_PIRACY
	phrasings = list(
		"piracy upon the Duke's Sea, and the boarding of ships under a flag of truce",
		"the taking of a fishing boat and its catch worth fifteen zennies",
	)

/datum/quest_crime/bondage_taking
	id = CRIME_BONDAGE_TAKING
	tier = CRIME_TIER_PIRACY
	phrasings = list(
		"the selling of free sailors into bondage",
		"the buying of captives, knowing them to be free folk",
	)

/datum/quest_crime/shore_slaving
	id = CRIME_SHORE_SLAVING
	tier = CRIME_TIER_PIRACY
	phrasings = list(
		"slaving on the coast",
		"the carrying off of villagers in chains, against the peace of the Duke",
	)

/datum/quest_crime/coastal_burning
	id = CRIME_COASTAL_BURNING
	tier = CRIME_TIER_PIRACY
	phrasings = list(
		"the burning of fishing villages and wanton slaughter of fishermen",
		"the burning of twelve fishing boats drawn up on the shore",
	)

/datum/quest_crime/coastal_rapine
	id = CRIME_COASTAL_RAPINE
	tier = CRIME_TIER_PIRACY
	phrasings = list(
		"rapine upon the coast",
		"the harrying of the shore until the fishers took up farming",
	)

/datum/quest_crime/temple_ship_burned
	id = CRIME_TEMPLE_SHIP_BURNED
	tier = CRIME_TIER_PIRACY
	phrasings = list(
		"the burning of a temple ship with its relics aboard",
		"the drowning of priests and pilgrims at sea, against the peace of Abyssor",
	)


/datum/quest_crime/beast_sheep
	id = CRIME_BEAST_SHEEP
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"taken nine ewes from the eastern fold",
		"savaged the flocks at pasture",
		"dragged off lambs by the throat",
	)

/datum/quest_crime/beast_child
	id = CRIME_BEAST_CHILD
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"taken a child of the woodward",
		"carried off the goatherd's youngling at dusk",
	)

/datum/quest_crime/beast_traveller
	id = CRIME_BEAST_TRAVELLER
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"set upon three travellers on the road",
		"made the carters go the long way round",
	)

/datum/quest_crime/beast_cattle
	id = CRIME_BEAST_CATTLE
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"hamstrung kine in the byre",
		"slain four cows of the common herd",
	)

/datum/quest_crime/beast_dogs
	id = CRIME_BEAST_DOGS
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"slain the hounds set against it",
		"torn open the shepherd's mastiff",
	)

/datum/quest_crime/beast_winter
	id = CRIME_BEAST_WINTER
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"come down from the hills for want of food",
		"grown bold with want, and drawn near to the hearth smoke",
	)

/datum/quest_crime/beast_corpse
	id = CRIME_BEAST_CORPSE
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"left bones picked clean in the ditch",
		"dug up the newly buried",
	)
