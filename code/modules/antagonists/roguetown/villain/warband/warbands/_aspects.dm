//////ASPECTS / MODIFIERS
/datum/warbands/aspects
	var/asclass					// aspects of the same class can't be selected simultaneously (i.e: two map aspects)

/datum/warbands/subtypes
	var/quote					// small flavortext for the creation menu
	var/quote_followup			// as above

#define ASPECT_BLOCKADE 		/datum/warbands/aspects/blockade
#define ASPECT_SURPRISE			/datum/warbands/aspects/surprise
#define ASPECT_FORT				/datum/warbands/aspects/fort
#define ASPECT_CULT				/datum/warbands/aspects/monofaith
#define ASPECT_HOST				/datum/warbands/aspects/extraspawns
#define ASPECT_FIGUREHEAD		/datum/warbands/aspects/figurehead
#define ASPECT_ENVY				/datum/warbands/aspects/envy
#define ASPECT_BADSPAWN			/datum/warbands/aspects/badexit

#define ASPECTS					list(ASPECT_FORT, ASPECT_BLOCKADE, ASPECT_SURPRISE, ASPECT_CULT, ASPECT_HOST, ASPECT_FIGUREHEAD, ASPECT_ENVY, ASPECT_BADSPAWN)

// FIXNOTE
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

// ideally, sect's monofaith aspect should be replaced with a unique aspect/class set for each god, but it'd be a massive timesink
// the current broad class groups are fine
/datum/warbands/aspects/monofaith
	title = "MONOFAITH"
	summary = "Everyone in the Warband prays to a single, shared patron determined by the Warlord's faith."
	desc = ""
	warning = "...of single-minded fanaticism and ritual."
	points = -1

/datum/warbands/aspects/extraspawns
	title = "GRAND HOST"
	summary = "Many have flocked to the Warlord's banner. \
	His Lieutenants will be able to recruit additional veterans, and more chaff fill his rank-and-file."
	warning = "...of a notably large size."
	points = -1


/datum/warbands/aspects/badexit
	title = "BAD TRIP"
	summary = "Fate denied an easy path into the Duchy. The Warcamp's initial exit will be someplace awful."
	warning = "...taking an obscure route into the Duchy."
	points = 1

//////////////////////////////////////////////
/////////////////////////////////// FIGUREHEAD
/*
	removes the warlord's Sweep ability
	physical scores get tanked to a preset number, unless they're already lower
	10 SPD
	10 CON
	8 STR
*/
/datum/warbands/aspects/figurehead
	title = "FIGUREHEAD"
	summary = "The Warlord's selfless devotion to his Warband has shaped it into a force to be reckoned with. \
	In comparison - and as a single combatant - the Warlord himself is rather weak."
	warning = "...of a driven, beloved leader."
	points = 1

/datum/warbands/aspects/envy
	title = "THRONE OF ENVY"
	summary = "All Lieutenants are guaranteed to be Aspirants."
	warning = "...of an inner retinue of backstabbing scum."
	points = 1


////////////////////////
//////////////////////////////////////////////// SUBTYPES
////////////////////////
#define WARBAND_MERC_ATGERVI		/datum/warbands/subtypes/atgervi
#define WARBAND_MERC_GRENZEL		/datum/warbands/subtypes/grenzel
#define WARBAND_MERC_BLACKOAK		/datum/warbands/subtypes/blackoak
#define WARBAND_MERC_CONDO			/datum/warbands/subtypes/condottiero
#define WARBAND_MERC_DESERTRIDER	/datum/warbands/subtypes/raneshen
#define WARBAND_MERC_FORLORN		/datum/warbands/subtypes/forlorn
#define WARBAND_MERC_FREI			/datum/warbands/subtypes/freifechter
#define WARBAND_MERC_GRUDGE			/datum/warbands/subtypes/grudgebearer
#define WARBAND_MERC_ROUTIER		/datum/warbands/subtypes/routier
#define WARBAND_MERC_RUMA			/datum/warbands/subtypes/ruma
#define WARBAND_MERC_STEPPE			/datum/warbands/subtypes/steppesman
#define WARBAND_MERC_UNDERDWELLER	/datum/warbands/subtypes/underdweller
#define WARBAND_MERC_VAQUERO		/datum/warbands/subtypes/vaquero
#define WARBAND_MERC_WARSCHOLAR		/datum/warbands/subtypes/warscholar
#define WARBAND_MERC_DROW			/datum/warbands/subtypes/anthrax
#define WARBAND_MERC_HANGYAKU		/datum/warbands/subtypes/hangyaku

#define WARBAND_MERCENARIES list(WARBAND_MERC_ATGERVI, WARBAND_MERC_GRENZEL, WARBAND_MERC_BLACKOAK, WARBAND_MERC_CONDO, \
                            WARBAND_MERC_DESERTRIDER, WARBAND_MERC_FORLORN, WARBAND_MERC_FREI, WARBAND_MERC_GRUDGE, \
                            WARBAND_MERC_ROUTIER, WARBAND_MERC_RUMA, WARBAND_MERC_STEPPE, WARBAND_MERC_WARSCHOLAR, \
                            WARBAND_MERC_VAQUERO, WARBAND_MERC_UNDERDWELLER, WARBAND_MERC_DROW, WARBAND_MERC_HANGYAKU)


#define WARBAND_SECT_TEN 		/datum/warbands/subtypes/ten 
#define WARBAND_SECT_FOUR		/datum/warbands/subtypes/ascendant
#define WARBAND_SECT_PSYDON		/datum/warbands/subtypes/psydon


#define WARBAND_SECTS	list(WARBAND_SECT_TEN, WARBAND_SECT_FOUR, WARBAND_SECT_PSYDON)


#define WARBAND_UNTAGGED_SUBTYPES	list()


/datum/warbands/subtypes
	points = 0

////////////
//////////////////////// MERCENARIES
////////////

/datum/warbands/subtypes/atgervi
	title = "ATGERVI"
	desc = "REQUIRED FAITH: THE FOUR"
	gruntclasses = list(/datum/advclass/mercenary/atgervi, /datum/advclass/mercenary/atgervi/shaman)
	combatmusic = list('sound/music/combat_shaman2.ogg')

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
	desc = "REQUIRED SPECIES: ELF"
	racelock = list(/datum/species/human/halfelf, /datum/species/elf/wood, /datum/species/elf/dark)
	gruntclasses = list(/datum/advclass/mercenary/blackoak, /datum/advclass/mercenary/blackoak/ranger, /datum/advclass/wretch/blackoakwyrm)
	combatmusic = list('sound/music/combat_blackoak.ogg')

/datum/warbands/subtypes/condottiero
	title = "CONDOTTIERO"
	gruntclasses = list(/datum/advclass/mercenary/condottiero)
	combatmusic = list('sound/music/combat_condottiero.ogg')

/datum/warbands/subtypes/raneshen
	title = "DESERT RIDERS"
	gruntclasses = list(/datum/advclass/mercenary/desert_rider, /datum/advclass/mercenary/desert_rider/zeybek, /datum/advclass/mercenary/desert_rider/almah)
	combatmusic = list('sound/music/combat_desertrider.ogg')

/datum/warbands/subtypes/ruma
	title = "RUMA CLAN"
	gruntclasses = list(/datum/advclass/mercenary/rumaclan, /datum/advclass/mercenary/rumaclan/sasu)
	combatmusic = list('sound/music/combat_kazengite.ogg')

/datum/warbands/subtypes/forlorn
	title = "THE FORLORN HOPE"
	gruntclasses = list(/datum/advclass/mercenary/forlorn)
	combatmusic = list('sound/music/combat_blackstar.ogg')

/datum/warbands/subtypes/grudgebearer
	title = "DWARVEN GRUDGEBEARERS"
	desc = "REQUIRED SPECIES: DWARF"
	racelock = list(/datum/species/dwarf/mountain)
	gruntclasses = list(/datum/advclass/mercenary/grudgebearer/soldier, /datum/advclass/mercenary/grudgebearer)
	combatmusic = list('sound/music/combat_dwarf.ogg')

/datum/warbands/subtypes/steppesman
	title = "STEPPESMEN"
	gruntclasses = list(/datum/advclass/mercenary/steppesman)
	combatmusic = list('sound/music/combat_steppe.ogg')

/datum/warbands/subtypes/grenzel
	title = "GRENZELHOFTIAN"
	quote = "''Fought with him for fifteen yils, and I honest to Gods couldn't tell you a damn thing about him. When you hire his kind you're paying for the sword, not the man.''"
	quote_followup = "- The Count of Morngrove, recalling his long-time guardian and companion."
	gruntclasses = list(/datum/advclass/mercenary/grenzelhoft, /datum/advclass/mercenary/grenzelhoft/halberdier, /datum/advclass/mercenary/grenzelhoft/crossbowman, /datum/advclass/mercenary/grenzelhoft/mage)
	combatmusic = list('sound/music/combat_grenzelhoft.ogg')

/datum/warbands/subtypes/warscholar
	title = "WARSCHOLARS"
	quote = "''For if Endurance - if lyfe itself - is prayer, so must we prepare for death. We should hope to unravel His mysteries with what little time we're spared, 'fore we join Him.''"
	quote_followup = "- A dramatic Warscholar, upon chipping his mask."
	desc = "REQUIRED FAITH: PSYDON"
	gruntclasses = list(/datum/advclass/mercenary/warscholar, /datum/advclass/mercenary/warscholar/pontifex, /datum/advclass/mercenary/warscholar/vizier)
	faithlock = list(/datum/patron/old_god)
	combatmusic = list('sound/music/warscholar.ogg')

/datum/warbands/subtypes/underdweller
	title = "UNDERDWELLERS"
	desc = "REQUIRED SPECIES: DWARF, DARK ELF, GOBLIN, KOBOLD or CREECHER"
	racelock =	list(/datum/species/dwarf/mountain, /datum/species/elf/dark, /datum/species/kobold, /datum/species/goblinp,	/datum/species/anthromorphsmall)
	gruntclasses = list(/datum/advclass/mercenary/underdweller)
	combatmusic = list('sound/music/combat_delf.ogg')

/datum/warbands/subtypes/anthrax
	title = "VENOM"
	desc = "REQUIRED SPECIES: DARK ELF"
	racelock =	list(/datum/species/elf/dark)
	gruntclasses = list(/datum/advclass/mercenary/anthrax, /datum/advclass/mercenary/anthrax/assasin)
	combatmusic = list('sound/music/combat_delf.ogg')

/datum/warbands/subtypes/vaquero
	title = "VAQUERO"
	treaty_name = "The Posse"
	gruntclasses = list(/datum/advclass/mercenary/vaquero)
	combatmusic = list('sound/music/combat_vaquero.ogg')

/datum/warbands/subtypes/freifechter
	title = "FREIFECTHERS"
	treaty_name = "The Freifechters of Aavnar"
	gruntclasses = list(/datum/advclass/mercenary/freelancer, /datum/advclass/mercenary/freelancer/lancer)
	combatmusic = list('sound/music/combat_noble.ogg')

/datum/warbands/subtypes/hangyaku
	title = "HANGYAKU"
	gruntclasses = list(/datum/advclass/mercenary/hangyaku, /datum/advclass/mercenary/chonin)
	combatmusic = list('sound/music/combat_kazengite.ogg')


////////////
//////////////////////// SECTS
////////////
/datum/warbands/subtypes/ten
	title = "TEN"
	quote = "''TEN ANGELS descended from on-high, slaughtering heretic and undeath alike. For us, TEN ANGELS sacrificed their holiest of creations.''"
	quote_followup = "DAWN: UNDIVIDED - 2:4"
	desc = "REQUIRED FAITH: THE TEN"
	warcamp = /datum/map_template/warcamp_standard
	warning = "...of devotion to the Ten."
	aspects = list(ASPECT_CULT)
	faithlock = list(ALL_DIVINE_PATRONS)
	combatmusic = list('sound/music/combat_holy.ogg')

/datum/warbands/subtypes/ascendant
	rarity = 2	// an ascendant sect treads on narrative ground covered by a ton of other antagonists, so we'll make them uncommon
	storytellerlimit = /datum/storyteller/graggar // by well-tread narrative ground i'm referring to a massacre
	title = "ASCENDANT"
	treaty_name = "The Holy Ecclesial"
	quote = "''Shine thy fury upon me, oh Dark Star! I sing thy slaughter's psalm, and thy word is sweet!''"
	quote_followup = "- A posthumous translation of a serial butcher's words - which were otherwise unintelligible."
	warning = "...of devotion to the Four."
	desc = "REQUIRED FAITH: THE FOUR"
	warcamp = /datum/map_template/warcamp_standard
	aspects = list(ASPECT_CULT)
	faithlock = list(ALL_INHUMEN_PATRONS)
	combatmusic = list('sound/music/combat2.ogg')

/datum/warbands/subtypes/psydon
	title = "OLD GOD"
	treaty_name = "We of the True Faith"
	quote = "''I miss you, Dead God. Psydon, I miss you. You, who cast down thy heart in our name. \
	We who sin in our pursuit of virtue. We who reject you with every breath and step. We who have created edifice and altar to devils in thy stead.''"
	quote_followup = "- Excerpt from The Apostate, Unknown Author"
	warning = "...of devotion to the Old God."
	desc = "REQUIRED FAITH: PSYDON"
	warcamp = /datum/map_template/warcamp_standard
	aspects = list(ASPECT_SURPRISE)
	faithlock = list(/datum/patron/old_god)
	combatmusic = list('sound/music/combat_inqordinator.ogg')
