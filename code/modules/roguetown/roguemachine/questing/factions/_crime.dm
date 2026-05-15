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
		"the drinking of wine kept for the temple-cup",
		"the draining of altar-vintage, sealed for the rites",
	)

/datum/quest_crime/petty_alms_theft
	id = CRIME_PETTY_ALMS_THEFT
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"the theft of food set aside for pilgrims and the poor",
		"the eating of bread laid out for the alms-bowl",
	)

/datum/quest_crime/petty_relieving
	id = CRIME_PETTY_RELIEVING
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"the fouling of a wayside shrine in plain sight",
		"the fouling of a roadside cairn dedicated to the Tens",
	)

/datum/quest_crime/petty_chicken
	id = CRIME_PETTY_CHICKEN
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"the carrying-off of a cottar's hen",
		"the seizing of poultry from a bereaved holder's coop",
	)

/datum/quest_crime/petty_orchard
	id = CRIME_PETTY_ORCHARD
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"the stripping of an orchard not their own",
		"the picking of fruit from another man's tree, by daylight and with witness",
	)

/datum/quest_crime/petty_offering_eating
	id = CRIME_PETTY_OFFERING_EATING
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"the eating of votive cake left at the shrine",
		"the consumption of holy offerings, while drunk",
	)

/datum/quest_crime/petty_priest_mocking
	id = CRIME_PETTY_PRIEST_MOCKING
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"the open mocking of a priest in the market-square",
		"the singing of unseemly verses about a Censor of the Tens",
	)

/datum/quest_crime/petty_drinking_temple
	id = CRIME_PETTY_DRINKING_TEMPLE
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"the staggering, drunken, into the temple at midnight",
		"the loud quarrel raised within the temple-precinct, for sport",
	)

/datum/quest_crime/petty_brawl
	id = CRIME_PETTY_BRAWL
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"the brawling in tavern, in defiance of the Guards",
		"the smiting of a lawful man over a spilled cup",
	)

/datum/quest_crime/petty_dueling
	id = CRIME_PETTY_DUELING
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"the drawing of steel over a wager unpaid",
		"the offering of a duel for trifling cause, against the Duke's peace",
	)

/datum/quest_crime/petty_dog_kicking
	id = CRIME_PETTY_DOG_KICKING
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"the kicking of a herald's dog",
		"the maltreatment of beasts in the Duke's keeping",
	)

/datum/quest_crime/petty_signpost
	id = CRIME_PETTY_SIGNPOST
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"the casting-down of a Duke's signpost upon the road",
		"the defacing of milestones along the Duke's Road, with rude words",
	)

/datum/quest_crime/petty_proposal_scorn
	id = CRIME_PETTY_PROPOSAL_SCORN
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"the spurning, with undue insult, of one who proposed in good faith, a violation of Eora's love",
		"the public mockery of a suitor who came in earnest, against Eora's binding",
	)

/datum/quest_crime/petty_barren_mock
	id = CRIME_PETTY_BARREN_MOCK
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"the mocking of a barren matron in the marketplace, against Eora's blessing",
		"the public taunting of one who has lost a child, scorn unto Eora's gift",
	)

/datum/quest_crime/petty_guest_wine
	id = CRIME_PETTY_GUEST_WINE
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"the spitting in wine ere it was poured for a guest, against Eora's hospitality",
		"the souring of bread set out for a guest, an insult unto Eora's table",
	)

/datum/quest_crime/petty_tombstone_insult
	id = CRIME_PETTY_TOMBSTONE_INSULT
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"the carving of unkind verse upon a tombstone, an insult to Necra's keeping",
		"the daubing of mock and rhyme upon a graveplate, that the dead lie ill at peace",
	)


/datum/quest_crime/brigandage
	id = CRIME_BRIGANDAGE
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"brigandage upon the Duke's Road",
		"the laying of ambush upon the open road, with intent of plunder",
	)

/datum/quest_crime/road_robbery
	id = CRIME_ROAD_ROBBERY
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"the robbery of merchants under the peace of Azuria",
		"the despoiling of caravans bound lawfully for market",
	)

/datum/quest_crime/pilgrim_robbery
	id = CRIME_PILGRIM_ROBBERY
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"the robbery of pilgrims bearing offerings to the shrines",
		"the seizing of alms-pouches from those upon the holy road",
	)

/datum/quest_crime/murder_stealth
	id = CRIME_MURDER_STEALTH
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"murder by stealth and ambush",
		"the slaying of free folk by hidden hand",
		"slaughter wrought in the dark, that no man might cry hue",
		"the slaying of free folk by hidden hand, a slaughter that Ravox's law abhors",
	)

/datum/quest_crime/murder_watch
	id = CRIME_MURDER_WATCH
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"the murder of a sworn man of the Guard",
		"the slaying of an officer set in the Duke's keeping",
	)

/datum/quest_crime/herald_slaying
	id = CRIME_HERALD_SLAYING
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"the slaying of a herald bearing a sealed writ",
		"the breaking of safe conduct, and bloodshed upon a messenger of the Duke",
		"the breaking of safe conduct sworn under Ravox's hilt, and bloodshed upon a messenger of the Duke",
	)

/datum/quest_crime/arson_night
	id = CRIME_ARSON_NIGHT
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"arson of a steading by night",
		"the kindling of fire upon a sleeping household's roof",
		"the kindling of fire upon a sleeping household, that the day peace of Astrata be torn into Noc's hours",
	)

/datum/quest_crime/granary_burning
	id = CRIME_GRANARY_BURNING
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"the burning of a granary in time of want",
		"setting torch to common stores, that hunger fall upon the folk",
		"the burning of a granary in time of want, that Dendor's grain rot into ash before hungry mouths",
	)

/datum/quest_crime/burglary
	id = CRIME_BURGLARY
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"burglary of a household at night",
		"breaking of doors by darkness, and the plunder of hearth and hall",
	)

/datum/quest_crime/cattle_lifting
	id = CRIME_CATTLE_LIFTING
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"cattle lifting, and the driving off of beasts from common pasture",
		"the reiving of kine from honest holders",
		"the reiving of kine from honest holders, a robbery of Dendor's bounty unto a thieving keeping",
	)

/datum/quest_crime/horse_theft
	id = CRIME_HORSE_THEFT
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"the theft of horses from a stable",
		"the running-off of mounts kept in lawful keeping",
	)

/datum/quest_crime/coin_clipping
	id = CRIME_COIN_CLIPPING
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"the coining of false mammon and the clipping of true coin",
		"forgery of the Duke's mint, and the passing of light coin in market",
	)

/datum/quest_crime/seal_forgery
	id = CRIME_SEAL_FORGERY
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"the forging of seals and the counterfeit of writs",
		"setting false sigil to parchment, that lies wear the colour of law",
	)

/datum/quest_crime/prison_breaking
	id = CRIME_PRISON_BREAKING
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"breaking of prison, and the freeing of those held for trial",
		"the loosing of felons from the Duke's keep",
	)

/datum/quest_crime/harbouring_outlaws
	id = CRIME_HARBOURING_OUTLAWS
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"the harbouring of declared outlaws, knowing them so",
		"giving roof and bread to wolf's-head folk",
	)

/datum/quest_crime/receiving_stolen
	id = CRIME_RECEIVING_STOLEN
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"receiving of stolen goods, knowing them stolen",
		"the trafficking of plunder taken from honest folk",
	)

/datum/quest_crime/poaching_land
	id = CRIME_POACHING_LAND
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"the slaying of beasts in excess of need, leaving carcasses to rot, a crime against Dendor's bounty",
		"the hunting of wood and field beyond reasonable want, that good meat was left for crows",
	)

/datum/quest_crime/poaching_fish
	id = CRIME_POACHING_FISH
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"the netting of fish in excess of need, leaving the catch to spoil upon the strand, a crime against Abyssor's bounty",
		"the casting of nets beyond what mouths could fill, that Abyssor's tide was robbed for waste",
	)

/datum/quest_crime/false_relics
	id = CRIME_FALSE_RELICS
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"the selling of false relics, peddling Astrata's name for mammon",
		"the hawking of forged bones and chains, that the holy were named upon trinkets",
	)


/datum/quest_crime/treason_lord
	id = CRIME_TREASON_LORD
	tier = CRIME_TIER_OATH
	phrasings = list(
		"treason against the lord to whom they had sworn faith",
		"the betrayal of those whose bread they had eaten",
		"treason against the lord to whom they had sworn faith before Ravox's altar",
	)

/datum/quest_crime/oath_breaking
	id = CRIME_OATH_BREAKING
	tier = CRIME_TIER_OATH
	phrasings = list(
		"the breaking of the oath sworn before Ravox upon hilt and altar",
		"forswearing of vow taken in the hearing of Ravox",
	)

/datum/quest_crime/desertion
	id = CRIME_DESERTION
	tier = CRIME_TIER_OATH
	phrasings = list(
		"desertion from the Duke's levy in time of war",
		"the casting down of arms while the foe yet stood",
		"desertion from the Duke's levy, casting down arms in the hour Ravox would have them stand",
	)

/datum/quest_crime/foreign_pay
	id = CRIME_FOREIGN_PAY
	tier = CRIME_TIER_OATH
	phrasings = list(
		"the taking of pay from a foreign captain while bound to Azuria",
		"selling of their arm to strange banners, their oath yet warm",
	)

/datum/quest_crime/sedition
	id = CRIME_SEDITION
	tier = CRIME_TIER_OATH
	phrasings = list(
		"the stirring of common folk to riot and the breaking of peace",
		"sowing of discord in market and tavern, against the Duke's keeping",
	)

/datum/quest_crime/compass_death
	id = CRIME_COMPASS_DEATH
	tier = CRIME_TIER_OATH
	phrasings = list(
		"compassing the death of a sworn officer of the Duke",
		"the imagining and counsel of murder against the Duke's own men",
		"compassing the death of a sworn officer of the Duke, an evil Ravox knows by its scent",
	)

/datum/quest_crime/adhering_enemies
	id = CRIME_ADHERING_ENEMIES
	tier = CRIME_TIER_OATH
	phrasings = list(
		"adhering to the Duke's enemies, and giving them aid and counsel",
		"the bearing of word and bread to those who war upon Azuria",
	)

/datum/quest_crime/oath_betrayal
	id = CRIME_OATH_BETRAYAL
	tier = CRIME_TIER_OATH
	phrasings = list(
		"the betrayal of an oathed companion in the hour of need, that Ravox's sworn faith was made coin",
		"the abandonment of one whose hand had been clasped in oath, against Ravox's measure",
	)

/datum/quest_crime/marriage_vow_broken
	id = CRIME_MARRIAGE_VOW_BROKEN
	tier = CRIME_TIER_OATH
	phrasings = list(
		"the breaking of marriage vow sworn before Eora, that the bond fell into Necra's hands ere its time",
		"the forsaking of a wedded spouse against the binding made under Eora's eye",
	)

/datum/quest_crime/sacrilege_temple
	id = CRIME_SACRILEGE_TEMPLE
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"sacrilege wrought upon a temple of the Tens",
		"the laying of unclean hand upon altar and consecrated stone",
	)

/datum/quest_crime/priest_slaying
	id = CRIME_PRIEST_SLAYING
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"the slaying of a priest before their own altar",
		"shedding of holy blood within the precinct of the Tens",
		"the slaying of a priest before their own altar, the blood of Astrata's servant cried out from the stones",
	)

/datum/quest_crime/shrine_robbery
	id = CRIME_SHRINE_ROBBERY
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"the robbery of a shrine and the bearing-away of holy gear",
		"the plundering of votive plate, and the despoiling of the Tens' own house",
	)

/datum/quest_crime/defiling_ground
	id = CRIME_DEFILING_GROUND
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"the defiling of consecrated ground",
		"the working of unclean act upon earth blessed unto the Tens",
		"the defiling of consecrated ground, an unclean act upon earth Dendor blessed",
	)

/datum/quest_crime/sanctuary_breaking
	id = CRIME_SANCTUARY_BREAKING
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"the breaking of sanctuary, and the dragging-forth of those who had sought it",
		"the violation of holy refuge, that no soul may flee unto the Tens for keeping",
	)

/datum/quest_crime/cleric_robbery
	id = CRIME_CLERIC_ROBBERY
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"the robbery of a cleric upon the road, they in vestment",
		"setting upon a priest as they travelled the Duke's Road in holy raiment",
	)

/datum/quest_crime/tomb_desecration
	id = CRIME_TOMB_DESECRATION
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"the desecration of a tomb of the honoured dead",
		"the breaking of barrow and crypt, that the dead lie ill at rest",
		"the desecration of a tomb of the honoured dead, defiance against Necra's veil",
	)

/datum/quest_crime/relic_theft
	id = CRIME_RELIC_THEFT
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"the theft of relics from their reliquary",
		"the bearing-away of holy bones, that the priests cry shame",
	)

/datum/quest_crime/simony
	id = CRIME_SIMONY
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"the simony of holy office, that a priest's place was bought with coin",
		"the trafficking of blessing and rite for mammon",
	)

/datum/quest_crime/altar_casting_down
	id = CRIME_ALTAR_CASTING_DOWN
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"the casting-down of an altar of the Tens",
		"the breaking of holy stone, that the Tens be dishonoured before their own",
	)

/datum/quest_crime/pilgrim_slaughter
	id = CRIME_PILGRIM_SLAUGHTER
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"the slaughter of pilgrims in their column",
		"a wholesale shedding of blood among the holy-bound",
	)

/datum/quest_crime/temple_peace_breaking
	id = CRIME_TEMPLE_PEACE_BREAKING
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"the breaking of the temple-peace, that bared steel was borne within the precinct",
		"the drawing of blade upon holy ground, where no edge ought to gleam",
	)

/datum/quest_crime/well_poisoning
	id = CRIME_WELL_POISONING
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"the poisoning of a holy well",
		"the fouling of waters held sacred unto the Tens",
		"the poisoning of a holy well, fouling at once Pestra's healing arts and Abyssor's gift of water",
	)

/datum/quest_crime/eoran_tree_felled
	id = CRIME_EORAN_TREE_FELLED
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"the felling of an Eoran shrine tree, that lovers' troths bound unto its branches were undone",
		"the cutting of a sacred tree of Eora, that the bonds tied upon it were severed at root",
	)

/datum/quest_crime/necran_procession_broken
	id = CRIME_NECRAN_PROCESSION_BROKEN
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"the disturbance of a Necran funeral procession, that the dead's last journey was broken",
		"the violent halting of mourners bearing the dead unto Necra's keeping",
	)


/datum/quest_crime/apostasy
	id = CRIME_APOSTASY
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"apostasy from the Tens, and the open mocking of their rites",
		"the casting-off of holy bond, and laughter at the altar",
	)

/datum/quest_crime/forbidden_doctrine
	id = CRIME_FORBIDDEN_DOCTRINE
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"the teaching of doctrines forbidden by the Holy See",
		"preaching of foul wisdom in barn and hedge, against the Tens",
	)

/datum/quest_crime/forbidden_books
	id = CRIME_FORBIDDEN_BOOKS
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"the keeping of forbidden books, that the priests had ordered burnt",
		"the hoarding of black tomes, sealed and condemned",
	)

/datum/quest_crime/ascendant_consorting
	id = CRIME_ASCENDANT_CONSORTING
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"the consorting with the false gods Ascendant, raised against the Tens",
		"the offering of prayer and incense unto Ascendant powers, in defiance of the See",
	)

/datum/quest_crime/demonic_pact
	id = CRIME_DEMONIC_PACT
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"the binding of pact with demoni beings, that the soul be pledged for power",
		"the cutting of compact with the things below, by blood and by ink",
	)

/datum/quest_crime/maleficium
	id = CRIME_MALEFICIUM
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"the working of curses upon the unborn, the sick, and the cattle in their byres",
		"the laying of black art upon honest folk, that fields fail and children sicken",
	)

/datum/quest_crime/summoning
	id = CRIME_SUMMONING
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"the summoning of that which the Tens had cast down",
		"the calling-up of shapes from beneath, by name and by sigil",
	)

/datum/quest_crime/necromancy
	id = CRIME_NECROMANCY
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"necromancy, and the rousing of the unquiet dead",
		"the binding of corpse and bone to walk again, against the Necra' own peace",
	)

/datum/quest_crime/blasphemy
	id = CRIME_BLASPHEMY
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"blasphemy openly spoken in market and at the temple-door",
		"the speaking of foul names against the Tens, before witness",
	)

/datum/quest_crime/host_desecration
	id = CRIME_HOST_DESECRATION
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"the breaking of consecrated bread, and casting of it to dogs",
		"the despoiling of holy offering, that the Tens be made mock",
		"the breaking of consecrated bread, casting of Eora's gift to dogs",
	)

/datum/quest_crime/priestly_blood
	id = CRIME_PRIESTLY_BLOOD
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"the shedding of priestly blood with malice aforethought",
		"the murder of a priest, by purpose laid and counsel kept",
	)

/datum/quest_crime/dreamer_sacrifice
	id = CRIME_DREAMER_SACRIFICE
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"the casting of captives, bound and gagged, into the deep, seeking to rouse the Dreamer from his blissful sleep",
		"the offering of bound flesh unto the deep, that Abyssor's slumber be broken by mortal hand",
	)

/datum/quest_crime/inhumen_invocation
	id = CRIME_INHUMEN_INVOCATION
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"the calling upon the false names of the Inhumen, of Graggar's eight, of Zizo's six, of the Devourer below",
		"the speaking aloud of the unholy names that the Holy See hath bound to silence",
	)


/datum/quest_crime/piracy
	id = CRIME_PIRACY
	tier = CRIME_TIER_PIRACY
	phrasings = list(
		"piracy upon the Duke's Sea, and the boarding of ships under truce",
		"the taking of vessels at oar and sail, against the peace of the strand",
	)

/datum/quest_crime/bondage_taking
	id = CRIME_BONDAGE_TAKING
	tier = CRIME_TIER_PIRACY
	phrasings = list(
		"the taking of crews into bondage, and the selling of free folk",
		"the dragging of mariners to chain and block",
	)

/datum/quest_crime/shore_slaving
	id = CRIME_SHORE_SLAVING
	tier = CRIME_TIER_PIRACY
	phrasings = list(
		"the slaving of folk upon the strand, in towns made desolate",
		"the harvest of bondsmen from villages put to torch",
	)

/datum/quest_crime/coastal_burning
	id = CRIME_COASTAL_BURNING
	tier = CRIME_TIER_PIRACY
	phrasings = list(
		"the burning of fishing-villages at the dawn-tide",
		"setting of fire to thatch upon the coast, while the folk yet slept",
	)

/datum/quest_crime/coastal_rapine
	id = CRIME_COASTAL_RAPINE
	tier = CRIME_TIER_PIRACY
	phrasings = list(
		"rapine upon the coast, that no fisher dare cast net",
		"the harrying of the strand, that the sea folk flee inland",
	)

/datum/quest_crime/temple_ship_burned
	id = CRIME_TEMPLE_SHIP_BURNED
	tier = CRIME_TIER_PIRACY
	phrasings = list(
		"the burning of a temple ship at sea, that the holy bones aboard sank without rite",
		"the firing of a sacred vessel upon Abyssor's tide, that pilgrims and priests were drowned in their hour of rest",
	)


/datum/quest_crime/beast_sheep
	id = CRIME_BEAST_SHEEP
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"taken sheep of the eastern fold",
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
		"set upon travellers on the lonely road",
		"made the forest road unsafe to lone passage",
	)

/datum/quest_crime/beast_cattle
	id = CRIME_BEAST_CATTLE
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"hamstrung kine in the byre",
		"slaughtered cattle in their pens",
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
		"come down from the high places, with hunger upon it",
		"emboldened by want, drawn near to the hearth-smoke",
	)

/datum/quest_crime/beast_corpse
	id = CRIME_BEAST_CORPSE
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"left bones in the ditch, picked clean",
		"scattered the dead about the wayside",
	)
