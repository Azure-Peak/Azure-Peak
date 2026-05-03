//////ASPECTS / MODIFIERS
/datum/warbands/aspects
	var/asclass					// aspects of the same class can't be selected simultaneously (i.e: two map aspects)

/datum/warbands/subtypes
	var/quote					// small flavortext for the creation menu
	var/quote_followup			// as above

/datum/warbands/aspects/blockade
	title = "BLOCKADE"
	points = -1
	summary = "Close allies - or perhaps the Warlord's very own ships - stand ready to enclose the city's port. \
	The blockade will be coordinated through the Campaign Planner."
	warning = "...of warships sailing the Duchy's waters. At any moment, they could move to blockade the city."

/datum/warbands/aspects/fort
	title = "FORTRESS"
	asclass = "Map"	
	points = -1
	warcamp = /datum/map_template/warcamp_standard_fort
	summary = "Rather than establishing a camp close to the capital, the Warband opted to capture a small castle in the countryside."
	warning = "...of a pillaged castle in the Duchy's northern reaches."

/datum/warbands/aspects/surprise
	title = "SURPRISE"
	summary = "No one will be forewarned of the Warband's arrival."
	warning = "...?"
	points = -1

/datum/warbands/aspects/extraspawns
	title = "GRAND HOST"
	summary = "Many have flocked to the Warlord's banner."
	warning = "...of a notably large size."
	points = -1

////////////////////////////////////////////////////
/////////////////////////////////// NEGATIVE ASPECTS

/datum/warbands/aspects/envy
	title = "THRONE OF ENVY"
	summary = "All Lieutenants are guaranteed to be Aspirants."
	warning = "...of an inner retinue of backstabbing scum."
	points = 1

/datum/warbands/aspects/badexit
	title = "BAD TRIP"
	summary = "Fate denied an easy path into the Duchy. The Warcamp's initial exit will be someplace awful."
	warning = "...taking an obscure route into the Duchy."
	points = 1

/datum/warbands/aspects/figurehead
	title = "FIGUREHEAD"
	summary = "The Warlord's selfless devotion to his Warband has shaped it into a force to be reckoned with. \
	In comparison - and as a single combatant - the Warlord himself is rather weak."
	warning = "...of a driven, beloved leader."
	points = 1	

/datum/warbands/subtypes
	points = 0

////////////
//////////////////////// MERCENARIES
////////////
// for mercenaries, something in gruntclasses is ALSO available as a "multiclass" for the lieutenants & the warlord
// if their own class list is filled, however, anything provided from gruntclasses will be overridden & unselectable 

// also: if you're adding a merc subtype here, don't forget to add it to the WARBAND_MERCENARIES define list

/datum/warbands/subtypes/northmen
	title = "NORTHMEN"
	warlordclasses = list(/datum/advclass/mercenary/gronn_heavy, /datum/advclass/mercenary/atgervi_shaman)
	lieutenantclasses = list(/datum/advclass/mercenary/atgervi)
	gruntclasses = list(/datum/advclass/mercenary/gronn)
	combatmusic = list('sound/music/combat_shaman2.ogg')
	faithlock = list(ALL_INHUMEN_PATRONS)

/datum/warbands/subtypes/routier
	title = "OTAVAN ROUTIERS"
	treaty_name = "Exemplars of Otava"
	quote = "''I ask only that you stand as a witness. Come dae, my men and I shall make this little field here, famous.''" 
	quote_followup = " - A Routier conscripting an archivist."
	gruntclasses = list(/datum/advclass/mercenary/routier)
	combatmusic = list('sound/music/combat_routier.ogg')

/datum/warbands/subtypes/blackoak
	title = "BLACK OAK"
	treaty_name = "Azuria-in-Exile"
	racelock = list(/datum/species/human/halfelf, /datum/species/elf/wood, /datum/species/elf/dark)
	warlordclasses = list(/datum/advclass/wretch/pariah, /datum/advclass/mercenary/blackoak, /datum/advclass/mercenary/blackoak_ranger)
	lieutenantclasses = list(/datum/advclass/wretch/pariah, /datum/advclass/mercenary/blackoak, /datum/advclass/mercenary/blackoak_ranger)
	gruntclasses = list(/datum/advclass/mercenary/blackoak, /datum/advclass/mercenary/blackoak_ranger)
	combatmusic = list('sound/music/combat_blackoak.ogg')

/datum/warbands/subtypes/condottiero
	title = "CONDOTTIERO"
	warlordclasses = list(/datum/advclass/mercenary/etrusca_condottiero)
	lieutenantclasses = list(/datum/advclass/mercenary/etrusca_condottiero)
	gruntclasses = list(/datum/advclass/mercenary/etrusca_balestrieri)
	combatmusic = list('sound/music/combat_condottiero.ogg')

/datum/warbands/subtypes/raneshen
	title = "DESERT RIDERS"
	warlordclasses = list(/datum/advclass/mercenary/desert_rider)
	lieutenantclasses = list(/datum/advclass/mercenary/desert_rider)
	gruntclasses = list(/datum/advclass/mercenary/desert_rider_sahir, /datum/advclass/mercenary/desert_rider_almah, /datum/advclass/mercenary/desert_rider_zeybek)
	combatmusic = list('sound/music/combat_desertrider.ogg')

/datum/warbands/subtypes/ruma
	title = "RUMA CLAN"
	warlordclasses = list(/datum/advclass/mercenary/seonjang)
	gruntclasses = list(/datum/advclass/mercenary/rumaclan, /datum/advclass/mercenary/rumaclan_sasu)
	combatmusic = list('sound/music/combat_kazengite.ogg')

/datum/warbands/subtypes/forlorn
	title = "THE FORLORN HOPE"
	gruntclasses = list(/datum/advclass/mercenary/forlorn)
	combatmusic = list('sound/music/combat_blackstar.ogg')

/datum/warbands/subtypes/grudgebearer
	title = "DWARVEN GRUDGEBEARERS"
	racelock = list(/datum/species/dwarf/mountain)
	gruntclasses = list(/datum/advclass/mercenary/grudgebearer_soldier, /datum/advclass/mercenary/grudgebearer)
	combatmusic = list('sound/music/combat_dwarf.ogg')

/datum/warbands/subtypes/steppesman
	title = "STEPPESMEN"
	gruntclasses = list(/datum/advclass/mercenary/steppesman)
	combatmusic = list('sound/music/combat_steppe.ogg')

/datum/warbands/subtypes/grenzel
	title = "GRENZELHOFTIAN"
	quote = "''Fought with him for fifteen yils, and I honest to Gods couldn't tell you a damn thing about him. When you hire his kind you're paying for the sword, not the man.''"
	quote_followup = "- The Count of Morngrove, recalling his long-time guardian and companion."
	gruntclasses = list(/datum/advclass/mercenary/grenzelhoft, /datum/advclass/mercenary/grenzelhoft_halberdier, /datum/advclass/mercenary/grenzelhoft_crossbowman, /datum/advclass/mercenary/grenzelhoft_mage)
	combatmusic = list('sound/music/combat_grenzelhoft.ogg')

/datum/warbands/subtypes/warscholar
	title = "WARSCHOLARS"
	quote = "''For if Endurance - if lyfe itself - is prayer, so must we prepare for death. We should hope to unravel His mysteries with what little time we're spared, 'fore we join Him.''"
	quote_followup = "- A dramatic Warscholar, upon chipping his mask."
	gruntclasses = list(/datum/advclass/mercenary/warscholar, /datum/advclass/mercenary/warscholar_pontifex, /datum/advclass/mercenary/warscholar_vizier)
	faithlock = list(/datum/patron/old_god)
	combatmusic = list('sound/music/warscholar.ogg')

/datum/warbands/subtypes/underdweller
	title = "UNDERDWELLERS"
	racelock =	list(/datum/species/dwarf/mountain, /datum/species/elf/dark, /datum/species/kobold, /datum/species/goblinp,	/datum/species/anthromorphsmall)
	gruntclasses = list(/datum/advclass/mercenary/underdweller)
	combatmusic = list('sound/music/combat_delf.ogg')

/datum/warbands/subtypes/anthrax
	title = "ANTHRAXI"
	racelock =	list(/datum/species/elf/dark)
	gruntclasses = list(/datum/advclass/mercenary/anthrax, /datum/advclass/mercenary/anthrax_assassin)
	combatmusic = list('sound/music/combat_delf.ogg')

// vaquero feel like solo mercenaries, but the idea of a cowboy army is too good to pass up. Get In There, Partner
/datum/warbands/subtypes/vaquero
	title = "VAQUERO"
	treaty_name = "The Posse"
	gruntclasses = list(/datum/advclass/mercenary/vaquero)
	combatmusic = list('sound/music/combat_vaquero.ogg')

/datum/warbands/subtypes/freifechter
	title = "FREIFECTHERS"
	treaty_name = "The Freifechters of Aavnar"
	gruntclasses = list(/datum/advclass/mercenary/freelancer, /datum/advclass/mercenary/freelancer_lancer, /datum/advclass/mercenary/freelancer_sabrist)
	combatmusic = list('sound/music/frei_fencer.ogg')

/datum/warbands/subtypes/hangyaku
	title = "HANGYAKU"
	gruntclasses = list(/datum/advclass/mercenary/hangyaku, /datum/advclass/mercenary/chonin)
	combatmusic = list('sound/music/combat_kazengite.ogg')

/datum/warbands/subtypes/tithebound
	title = "TITHEBOUND"
	racelock = list(/datum/species/dracon, /datum/species/lizardfolk, /datum/species/kobold)
	faithlock = list(/datum/patron/divine/astrata, /datum/patron/inhumen/matthios)
	gruntclasses = list(/datum/advclass/mercenary/lirvanmerc)
	combatmusic = list('sound/music/combat_matthios.ogg')

////////////
//////////////////////// SECTS
////////////
/datum/warbands/subtypes/ten
	title = "TEN"
	quote = "''TEN ANGELS descended from on-high, slaughtering heretic and undeath alike. For us, TEN ANGELS sacrificed their holiest of creations.''"
	quote_followup = "DAWN: UNDIVIDED - 2:4"
	warcamp = /datum/map_template/warcamp_standard
	warning = "...of devotion to the Ten."
	faithlock = list(ALL_DIVINE_PATRONS)
	combatmusic = list('sound/music/combat_holy.ogg')

// side note while we're here: antagonists that can't be negotiated with are generally off-theme for Warbands
// if you absolutely need to add one, please leave them at a high rarity
/datum/warbands/subtypes/ascendant
	// rarity = 2	// an ascendant sect treads on narrative ground covered by a ton of other antagonists, so we'll make them uncommon
	// storytellerlimit = /datum/storyteller/graggar // by well-tread narrative ground i'm referring to a massacre
	title = "ASCENDANT"
	treaty_name = "The Holy Ecclesial"
	quote = "''Shine thy fury upon me, oh Dark Star! I sing thy slaughter's psalm, and thy word is sweet!''"
	quote_followup = "- A posthumous translation of a serial butcher's words - which were otherwise unintelligible."
	warning = "...of devotion to the Four."
	warcamp = /datum/map_template/warcamp_standard
	faithlock = list(ALL_INHUMEN_PATRONS)
	combatmusic = list('sound/music/combat2.ogg')
	outskirts_wave = /datum/outskirts_wave/ascendant

/datum/warbands/subtypes/psydon
	title = "OLD GOD"
	treaty_name = "We of the True Faith"
	quote = "''I miss you, Dead God. Psydon, I miss you. You, who cast down thy heart in our name. \
	We who sin in our pursuit of virtue. We who reject you with every breath and step. We who have created edifice and altar to devils in thy stead.''"
	quote_followup = "- Excerpt from The Apostate, Unknown Author"
	warning = "...of devotion to the Old God."
	warcamp = /datum/map_template/warcamp_standard
	faithlock = list(/datum/patron/old_god)
	combatmusic = list('sound/music/combat_inqordinator.ogg')

/datum/warbands/subtypes/psydon/New()
	..()
	if(prob(50)) // jazz roll
		combatmusic = list('sound/music/inquisitorcombat.ogg')
