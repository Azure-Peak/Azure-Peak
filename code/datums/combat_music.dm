/*
	Combat Mode Music Track Datums
	---
	Currently only used for overriding the default combat music that comes with your job or antagonist.
	As of writing they are never directly applied to mobs themselves, only the name and musicpath are.
	Deleting these datums or renaming subtypes will not break preferences; invalid saves get redirected to /default.
	When adding new songs, add a shortname around ~12 characters for the game preferences menu.
	
	IMPORTANT! Be careful about adding songs to this list that aren't used anywhere else, lest you needlessly inflate the RSC.
*/

// Admins: please don't molest my lists. You can't add new types at runtime anyways. Kisses! - Zoktiik
GLOBAL_LIST_EMPTY(cmode_tracks_by_type)
GLOBAL_LIST_EMPTY(cmode_tracks_by_name)

// People make mistakes. This should help catch when that happens.
/proc/cmode_track_to_namelist(var/datum/combat_music/track)
	if(!track)
		return
	if(!track.name)
		LAZYREMOVE(GLOB.cmode_tracks_by_type, track.type)
		CRASH("CMODE MUSIC: type [track.type] has no name!") 
	if(GLOB.cmode_tracks_by_name[track.name])
		LAZYREMOVE(GLOB.cmode_tracks_by_type, track.type)
		CRASH("CMODE MUSIC: type [track.type] has duplicate name \"[track.name]\"!")
	GLOB.cmode_tracks_by_name[track.name] = track
	return

/datum/combat_music
	var/name
	var/desc
	var/shortname
	var/credits
	var/musicpath = list()

// Shit WILL break if you change /default's typepath. Don't do it.
/datum/combat_music/default
	name = "Default"
	desc = "I let my current status sing for itself; its song will change dynamically."
	shortname = "Default"
	musicpath = list()

/datum/combat_music/acolyte
	name = "Acolyte"
	desc = ""
	shortname = "Acolyte"
	credits = "T-87 SULFURHEAD - Hellions (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/church/combat_acolyte.ogg')

/datum/combat_music/adjudicator
	name = "Adjudicator"
	desc = ""
	shortname = "Adjudicator"
	credits = "Chivalry 2 OST: Duty and Honor II (with Ryan Patrick Buckley)"
	musicpath = list('sound/music/templarofpsydonia.ogg')

/datum/combat_music/adventurer_default
	name = "Adventurer Default (Warriors)"
	desc = ""
	shortname = "Adv. Default"
	credits = "T-87 SULFURHEAD - Men at War (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/adventurer/combat_outlander2.ogg')

/datum/combat_music/adventurer_2
	name = "Adventurer 2 (Assassin)"
	desc = ""
	shortname = "Adv. 2"
	credits = "T-87 SULFURHEAD - Ninth Circle (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/adventurer/combat_outlander.ogg')

/datum/combat_music/adventurer_3
	name = "Adventurer 3 (Rogue/Mage Classes)"
	desc = ""
	shortname = "Adv. 3"
	credits = "T-87 SULFURHEAD - MORTEM OBIRE (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/adventurer/combat_outlander3.ogg') 

/datum/combat_music/adventurer_4
	name = "Adventurer 4"
	desc = ""
	shortname = "Adv. 4"
	credits = "T-87 SULFURHEAD - Snicker Snacker (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/adventurer/combat_outlander4.ogg') 

/datum/combat_music/ascended
	name = "Ascended"
	desc = "No mortal could ever comprehend the heights to which I've risen."
	shortname = "Ascended"
	credits = "TO PIERCE THE BLACK SKY /// ENVY INTERLUDE - UNFORTUNATE DEVELOPMENT"
	musicpath = list('sound/music/combat_ascended.ogg')

/datum/combat_music/ascendedsavior
	name = "Ascended ('Savior' Mix)"
	desc = "Blessed idiot, sacrificial hero, lowly fool - will you save your world, or will you watch the birth of a new one?"
	shortname = "Savior"
	credits = "DON'T BLINK /// OUTCOME MEMORIES - LAST MAN STANDING"
	musicpath = list('sound/music/combat_savior.ogg')

/datum/combat_music/astrata
	name = "Astratan Light"
	desc = ""
	shortname = "Astrata"
	credits = "T-87 SULFURHEAD - Heliotrix (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/church/combat_astrata.ogg')

/datum/combat_music/bandit_default
	name = "Bandit Default"
	desc = ""
	shortname = "Bandit Def."
	credits = "T-87 SULFURHEAD - Deadly Shadows (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/antag/combat_deadlyshadows.ogg')

/datum/combat_music/bandit_soldier
	name = "Bandit Soldier (Deserter/Outlaw)"
	desc = ""
	shortname = "Bandit Sold."
	credits = "T-87 SULFURHEAD - The Wall (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/antag/combat_thewall.ogg')

/datum/combat_music/bandit_rogue
	name = "Bandit Rogue (Sellsword/Cutpurse)"
	desc = ""
	shortname = "Bandit Rogue"
	credits = "T-87 SULFURHEAD - Cutpurse (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/antag/combat_cutpurse.ogg')

/datum/combat_music/barbarian
	name = "Barbarian"
	desc = ""
	shortname = "Barbarian"
	musicpath = list('sound/music/combat_gronn.ogg')

/datum/combat_music/blackoak
	name = "Black Oak's Guardian"
	desc = ""
	shortname = "Black Oak"
	musicpath = list('sound/music/combat_blackoak.ogg')

/datum/combat_music/beggar
	name = "Beggar"
	desc = ""
	shortname = "Beggar"
	credits = "Pathologic (Classic) - Most Combat Theme"
	musicpath = list('sound/music/combat_bum.ogg')

/datum/combat_music/conddottiero
	name = "Condottiero Guildsman"
	desc = ""
	shortname = "Condottiero"
	musicpath = list('sound/music/combat_condottiero.ogg')

/datum/combat_music/cultic
	name = "Cultic Witchcraft"
	desc = ""
	shortname = "Cultic"
	credits = "Igor Kornelyuk - Воланд (\"Voland\")"
	musicpath = list('sound/music/combat_cult.ogg')

/datum/combat_music/combat
	name = "Combat Classic (Adventurer)"
	desc = ""
	shortname = "Combt Classic"
	musicpath = list('sound/music/combat.ogg')

/* Unused
/datum/combat_music/combat_old_2
	name = "Combat Old 2"
	desc = ""
	shortname = "Combat Old 2"
	musicpath = list('sound/music/combat2.ogg')
*/

/datum/combat_music/darkstar
	name = "Dark Star (Verewolf/Barbarian/Berserker)"
	desc = ""
	shortname = "Dark Star"
	credits = " T-87 SULFURHEAD - Archetype of the Dark Star (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/antag/combat_darkstar.ogg')

/datum/combat_music/deadite
	name = "Deadite"
	desc = ""
	shortname = "Deadite"
	musicpath = list('sound/music/combat_weird.ogg')

/datum/combat_music/dendor
	name = "Dendorite Clergy (Warden)"
	desc = ""
	shortname = "Dendor"
	credits = "T87-Sulfurhead - Metamorphosis (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/garrison/combat_warden.ogg')

/datum/combat_music/desertrider
	name = "Desert Rider Mercenary"
	desc = ""
	shortname = "Desert Rider"
	credits = "Two Fingers - You Ain't Down"
	musicpath = list('sound/music/combat_desertrider.ogg')

/datum/combat_music/dungeoneer
	name = "Dungeoneer"
	desc = ""
	shortname = "Dungeoneer"
	credits = "T87-Sulfurhead - RATEATER (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/combat_dungeoneer.ogg')

/datum/combat_music/dwarf
	name = "Dwarven Grudgebearer"
	desc = ""
	shortname = "Dwarf"
	musicpath = list('sound/music/combat_dwarf.ogg')

/datum/combat_music/eora
	name = "Eoran Clergy"
	desc = "Do not listen to this one after a breakup." // from the credits.txt lol
	shortname = "Eora"
	credits = "T-87 SULFURHEAD - Family Melts Away (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/church/combat_eora.ogg')

/datum/combat_music/forlorn
	name = "Forlorn Hope Mercenary"
	desc = ""
	shortname = "Forlorn Hope"
	musicpath = list('sound/music/combat_blackstar.ogg')

/datum/combat_music/grenzelhoft
	name = "Grenzelhoft Mercenary"
	desc = ""
	shortname = "Grenzelhoft"
	credits = "Helbrede - Sons of Tyr"
	musicpath = list('sound/music/combat_grenzelhoft.ogg')

/datum/combat_music/heretic_zizo
	name = "Heretic - Zizo (Lich)"
	desc = ""
	shortname = "Zizo"
	credits = "T87-Sulfurhead - DEMESNE (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/combat_heretic.ogg')

/datum/combat_music/heretic_matthios
	name = "Heretic - Matthios"
	desc = ""
	shortname = "Matthios"
	credits = "T87-Sulfurhead - Amontillado (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/combat_matthios.ogg')

/datum/combat_music/heretic_graggar
	name = "Heretic - Graggar"
	desc = ""
	shortname = "Graggar"
	credits = "T87-Sulfurhead - Black Powder (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/combat_graggar.ogg')

/datum/combat_music/heretic_baotha
	name = "Heretic - Baotha"
	desc = ""
	shortname = "Baotha"
	credits = "T87-Sulfurhead - Love Within You (Rough Mix) (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/combat_baotha.ogg')

/datum/combat_music/iconoclast
	name = "Iconoclast"
	desc = ""
	shortname = "Iconoclast"
	credits = "Valley of Judgement- Lateralis"
	musicpath = list('sound/music/Iconoclast.ogg')

/datum/combat_music/inquisitor
	name = "Inquisitor (Monster Hunter/Spellbreaker)"
	desc = ""
	shortname = "Inquisitor"
	credits = "Hellsing OST RAID Track 15: Survival on the Street of Insincerity"
	musicpath = list('sound/music/inquisitorcombat.ogg')

/datum/combat_music/inquis_ordinator
	name = "Inquisitor - Ordinator"
	desc = ""
	shortname = "Ordinator"
	musicpath = list('sound/music/combat_inqordinator.ogg')

/datum/combat_music/jester
	name = "Jester"
	desc = ""
	shortname = "Jester"
	credits = "Alias Conrad Coldwood - Pepper Steak (OFF OST)"
	musicpath = list('sound/music/combat_jester.ogg')

/datum/combat_music/kazengite
	name = "Kazengite"
	desc = ""
	shortname = "Kazengite"
	musicpath = list('sound/music/combat_kazengite.ogg')

/datum/combat_music/knight
	name = "Knight (Noble)"
	desc = ""
	shortname = "Knight"
	credits = "T87-Sulfurhead - Durandal (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/combat_knight.ogg')

/datum/combat_music/man_at_arms
	name = "Man at Arms (Sergeant)"
	desc = ""
	shortname = ""
	credits = "T87-Sulfurhead - Ready or Not (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/combat_ManAtArms.ogg')


// Maniac code has this track uncommented so this is free. And tbh it should remain here. Banger.
/datum/combat_music/maniac
	name = "Maniac"
	desc = ""
	shortname = "Maniac"
	credits = "Thomas Bangalter - Stress"
	musicpath = list('sound/music/combat_maniac2.ogg')

/* Unused
/datum/combat_music/maniac_old
	name = "Maniac (Old)"
	desc = ""
	shortname = "Maniac Old"
	musicpath = list('sound/music/combat_maniac.ogg')
*/

/datum/combat_music/martyr
	name = "Martyr"
	desc = ""
	shortname = "Martyr"
	musicpath = list('sound/music/combat_martyrsafe.ogg')

// The two Martyr Vengeance combat tracks are intentionally left out of this. Look how they're used.

/datum/combat_music/magician
	name = "Magicians, Court"
	desc = ""
	shortname = "Magicians"
	credits = "T-87 SULFURHEAD - MANASURGE (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/nobility/combat_courtmage.ogg')

/datum/combat_music/monastic
	name = "Monastic Zeal"
	desc = ""
	shortname = "Monastic"
	credits = "Jesper Kyd - Light of the Imperium"
	musicpath = list('sound/music/combat_holy.ogg')

/datum/combat_music/necra
	name = "Necran Clergy"
	desc = ""
	shortname = "Necra"
	credits = "T-87 SULFURHEAD - Formerly Known as Toulouse Lautrec (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/church/combat_necra.ogg')

/datum/combat_music/noble
	name = "Noble (Merchant/Freifechter)"
	desc = ""
	shortname = "Noble"
	musicpath = list('sound/music/combat_noble.ogg')

/datum/combat_music/ozium
	name = "Ozium Abuse (loud!)"
	desc = ""
	shortname = "Ozium"
	credits = "Light Club - FAHKEET"
	musicpath = list('sound/music/combat_ozium.ogg')

/datum/combat_music/physician
	name = "Physician (Alchemist)"
	desc = ""
	shortname = "Physician"
	credits = "Pathologic (Classic) - Utroba Aggression"
	musicpath = list('sound/music/combat_physician.ogg')

/datum/combat_music/poacher
	name = "Poacher Wretch"
	desc = ""
	shortname = "Poacher"
	musicpath = list('sound/music/combat_poacher.ogg')

/datum/combat_music/reckoning
	name = "Reckoning (Clergy, Offense)"
	desc = ""
	shortname = "Reckoning"
	credits = "T-87 SULFURHEAD - The Reckoning (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/church/combat_reckoning.ogg')

/datum/combat_music/routier
	name = "Routier, Otavan"
	desc = ""
	shortname = "Rogue"
	musicpath = list('sound/music/combat_routier.ogg')

/datum/combat_music/shaman
	name = "Shaman, Atgervi"
	desc = ""
	shortname = "Shaman"
	credits = "Heilung - Elddansurin"
	musicpath = list('sound/music/combat_shaman2.ogg')

/datum/combat_music/spymaster
	name = "Spymaster"
	desc = ""
	shortname = "Spymaster"
	credits = "T-87 SULFURHEAD - ABedofMoss (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/nobility/combat_spymaster.ogg')

/datum/combat_music/squire
	name = "Squire"
	desc = ""
	shortname = "Squire"
	credits = "Dragon's Dogma OST: Tense Combat"
	musicpath = list('sound/music/combat_squire.ogg')

/datum/combat_music/starsugar
	name = "Starsugar Abuse (loud!)"
	desc = ""
	shortname = "Starsugar"
	credits = "FEMTANYL - DOGMATICA"
	musicpath = list('sound/music/combat_starsugar.ogg')

/datum/combat_music/steppe
	name = "Steppesman"
	desc = ""
	shortname = "Steppe"
	credits = "MusicImaginary - Tatars"
	musicpath = list('sound/music/combat_steppe.ogg')

/datum/combat_music/town_dirt
	name = "Town Dirt (Default)"
	desc = ""
	shortname = "Town Dirt"
	credits = "T-87 SULFURHEAD - Catharsis (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/towner/combat_towner.ogg')

/datum/combat_music/town_heavyweights
	name = "Town Heavyweights"
	desc = ""
	shortname = "Town Heavies"
	credits = "T-87 SULFURHEAD - Burning Hovel (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/towner/combat_towner2.ogg')

/datum/combat_music/town_skilled
	name = "Town Skilled"
	desc = ""
	shortname = "Town Skills"
	credits = "combat_towner3.ogg: T-87 SULFURHEAD - Knowledge & Pain (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/towner/combat_towner3.ogg')

/datum/combat_music/town_leaders
	name = "Town Leaders"
	desc = "Innkeeper, Guildmaster, Village Chief, Normal Veteran."
	shortname = "Town Leads"
	credits = "T-87 SULFURHEAD - How Sausage is Made (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/towner/combat_retired.ogg')

/datum/combat_music/varangian
	name = "Varangian"
	desc = ""
	shortname = "Varangian"
	credits = "Heilung - Svanrand"
	musicpath = list('sound/music/combat_vagarian.ogg')

/datum/combat_music/vampire
	name = "Vampire"
	desc = ""
	shortname = "Vampire"
	credits = "T-87 SULFURHEAD - STOLEN SKY (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/antag/combat_thrall.ogg')

/* Unused
/datum/combat_music/vampire_old
	name = "Vampire (Old)"
	desc = ""
	shortname = "Vampire Old"
	musicpath = list('sound/music/combat_vamp.ogg')
*/

/datum/combat_music/vaquero
	name = "Vaquero"
	desc = ""
	shortname = "Vaquero"
	musicpath = list('sound/music/combat_vaquero.ogg')

/datum/combat_music/veteran
	name = "Veteran"
	desc = ""
	shortname = "Veteran"
	credits = "T87-Sulfurhead - Good Men Die Young (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/combat_veteran.ogg')

/datum/combat_music/warscholar
	name = "Warscholar, Naledi"
	desc = ""
	shortname = "Warscholar"
	credits = "Butcher's Boulevard - Kristjan Thomas Haaristo"
	musicpath = list('sound/music/warscholar.ogg')

/datum/combat_music/freifencer
	name = "Freifechter, Fencer"
	desc = "God is dead, yet I follow his word! No fire made by any man will snuff out the Reformation! Paradise awaits!"
	shortname = "Fencer"
	credits = "MusicImaginary - Old Church"
	musicpath = list('sound/music/frei_fencer.ogg')

/datum/combat_music/freilancer
	name = "Freifechter, Lancer"
	desc = "Etruscan pike companies are some of Psydonia's most sought-after mercenaries - but you're not one of those. You're a master."
	shortname = "Lancer"
	credits = "Lucas Gitano - The Mask of Zorro (Fingerstyle Acoustic Cover)"
	musicpath = list('sound/music/frei_lancer.ogg')

/datum/combat_music/freisabrist
	name = "Freifechter, Sabrist"
	desc = "So long as we still lyve, what the foreign powers have seized from us, we shall recapture with a sabre in hand."
	shortname = "Sabrist"
	credits = "MusicImaginary - Lyra"
	musicpath = list('sound/music/frei_sabre.ogg')

/datum/combat_music/aavshepherd
	name = "Aavnic Shepherd"
	desc = "\"No saber in hand, they crush bones with their fokos!\""
	shortname = "Shepherd"
	credits = "MusicImaginary - Yendrek"
	musicpath = list('sound/music/frei_shepherd.ogg')

/datum/combat_music/thespian
	name = "Thespian-Errant"
	desc = "Witness us! We, who are about to die, salute thee!"
	shortname = "Thespian"
	credits = "Swords And Sandals, Spartacus - Title Theme"
	musicpath = list('sound/music/combat_thespian.ogg')

/datum/combat_music/dying_world
	name = "Chant Against a Dying World (Neu Verevolf)"
	desc = "\"DENDOR! FATHER! SPIRIT GUIDE! LET ME-- VINDICATE MY PRIDE!\""
	shortname = "Dying World (VOCAL)"
	credits = "T-87 SULFURHEAD - CHANT AGAINST A DYING WORLD (https://www.youtube.com/watch?v=uf3Iqn-i6EM)"
	musicpath = list('sound/music/cmode/antag/combat_dying_world.ogg')

/datum/combat_music/dying_world_instrumental
	name = "Chant Against a Dying World (Instrumental)"
	desc = "The more common form of the song, lacks the lyrics. Recommended for long-term use."
	shortname = "Dying World (INSTR)"
	credits = "T-87 SULFURHEAD - CHANT AGAINST A DYING WORLD INSTRUMENTAL (https://www.youtube.com/watch?v=M0gmFhgPaV8)"
	musicpath = list('sound/music/cmode/antag/combat_dying_world_instrumental.ogg')

/datum/combat_music/ready_to_die
	name = "I'M READY TO DIE, ARE YOU?"
	desc = "\"I REMEMBER A TIME NOT THAT LONG AGO, WHEN WE HAD VAMPIRES AND DUNPEALS BOTH AROUND HERE...\"" // yes it's "dunpeals". ask hunter d not me
	shortname = "Ready to Die"
	credits = "T-87 SULFURHEAD - I'M READY TO DIE, ARE YOU? (https://www.youtube.com/watch?v=cJpAxIvd8_g)"
	musicpath = list('sound/music/cmode/combat_ready_to_die.ogg')
