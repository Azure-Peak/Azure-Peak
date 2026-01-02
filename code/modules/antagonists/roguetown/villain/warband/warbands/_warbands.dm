/*
////////////////////////																			////////////////////////
//////////////////////////////////////////////// NOTES ON WARBAND CREATION ////////////////////////////////////////////////
////////////////////////																			////////////////////////
	MAP SIZES
		warcamp: 45x45
		outskirts: 30x45
		intermission: 13x13

	in each WARCAMP map
		required objects:
			'/obj/effect/landmark/start/warlordlate'					| a spawn point
			'/obj/structure/fluff/warband/warband_recruit'				| a recruitment point
			'/obj/structure/fluff/warband/campaign_planner'				| this thing
			'/obj/structure/fluff/traveltile/warband/camp_to_outskirts' | an entrance
			'/obj/structure/fluff/warband/shortcut' 					| an emergency entrance

		!VERY IMPORTANT!
			each area in a warcamp or outskirts template requires a baseturf helper
			otherwise, destroyed walls will cause errors
			it must be placed once in EACH AREA!!
			EACH!
			AREA!!

	in each OUTSKIRTS map
		'/obj/structure/fluff/traveltile/warband/outskirts_to_intermission' | an entrance
		'/obj/structure/fluff/traveltile/warband/outskirts_to_camp' | an exit
		in strongdmm they'll appear teal & purple


	in each INTERMISSION map
		'/obj/structure/fluff/traveltile/warband/intermission_to_azure' | an entrance
		'/obj/structure/fluff/traveltile/warband/intermission_to_outskirts' | an exit
		in strongdmm they'll appear red & orange

	add any warbands & aspects you make to the #define lists, otherwise they'll never pop up in the warband creation menu

////////////////////////																			////////////////////////
//////////////////////////////////////////////// NOTES ON WARBAND CREATION ////////////////////////////////////////////////
////////////////////////																			////////////////////////
*/

#define WARBANDS 	list(/datum/warbands/standard,  /datum/warbands/mercenary, /datum/warbands/sect, \
					/datum/warbands/storyteller/peasant, /datum/warbands/storyteller/wizard)

#define WARBAND_BASE_RESPAWNS 400
#define RESPAWNS_MINIMAL 25
#define RESPAWNS_LOW 50
#define RESPAWNS_MEDIUM 100
#define RESPAWNS_HIGH 200
#define RESPAWNS_HORDE 500

/datum/warbands
	var/title						// name used in the creation menu
	var/name = "Warband"			// name used outside the creation menu and during desertions

	// appears in treaties
	var/treaty_name = "Warband"		
	var/treaty_desc = "Azuria bears no shortage of enemies."
	var/icon = 'icons/roguetown/weapons/shields32.dmi'
	var/icon_state = "ironsh"
	var/territory_name = "Unknown Territory"	// for the warband faction's initial territory
	var/territory_desc 

	var/desc						// used for extra details
	var/summary						// first description in a warband's info tab | followed up by var/desc
	var/warning						// when a warband spawns, someone in the city is sent a warning letter w/details (its warband, aspects, etc)
	var/datum/map_template/warcamp	// a 45x45 map template
	var/datum/storytellerlimit		// certain warbands are only available with certain storytellers | when storytellers are accounted, the manager will use the current storyteller, the storyteller chosen at roundstart, and each prince's patron
	var/rarity						// how many times the storytellerlimit needs to be met before a locked warband is unlocked
	var/subtyperequired = FALSE		// forces a warband to take a subtype
	
	var/list/faithlock = list()		// E.G: Atgervi & Warscholars
	var/list/racelock = list()		// E.G: Grudgebearers & Black Oak

	var/list/subtypes = list()
	var/list/aspects = list()

	var/points = 1					// selection cost in the creation menu | if this is NEGATIVE, it incurs a cost
	var/list/warlordclasses = list()
	var/list/lieutenantclasses = list()
	var/list/gruntclasses = list()
	var/spawns						// lost when an NPC is spawned | combined with the warband manager's baseline spawns, which is 400
	var/list/combatmusic = list()

////////////////////////
//////////////////////////////////////////////// WARBANDS
////////////////////////

/datum/warbands/standard
	title = "FEUD"
	name = "Rival Lord"
	summary = "No feud can go unresolved. Settlements between men of low standing are simple - an apology here, or an exchange of cattle and mammon there. \
	But Great Men cannot settle. Honor demands apologies to be signed in blood and thousands of cattle to fall before spear-point."
	warning = "...a foreign Banner on the march towards the capital."
	combatmusic = list('sound/music/cmode/antag/combat_thewall.ogg')
	aspects = list(ASPECT_FORT, ASPECT_BLOCKADE, ASPECT_SURPRISE, ASPECT_HOST, ASPECT_FIGUREHEAD, ASPECT_ENVY, ASPECT_BADSPAWN)
	warcamp = /datum/map_template/warcamp_standard
	warlordclasses = list(/datum/advclass/warband/standard/warlord/lord)
	lieutenantclasses = list(/datum/advclass/warband/standard/lieutenant/knight, /datum/advclass/warband/standard/lieutenant/preacher, /datum/advclass/warband/standard/lieutenant/spymaster, /datum/advclass/warband/standard/lieutenant/magician)
	gruntclasses = list(/datum/advclass/warband/standard/grunt/veteran, /datum/advclass/warband/standard/grunt/scout, /datum/advclass/warband/standard/grunt/rider, /datum/advclass/warband/standard/grunt/sapper)
	spawns = RESPAWNS_MEDIUM

/datum/warbands/mercenary
	title = "MERCENARY COMPANY"
	name = "Mercenary Company"
	treaty_name = "The Company"
	summary = "So numerous are the potential motives for a band of mercenaries, that the idea \
	they might be getting paid in mammon becomes a mere afterthought."
	subtyperequired = TRUE
	subtypes = list(WARBAND_MERCENARIES)
	aspects = list(ASPECT_BLOCKADE, ASPECT_SURPRISE, ASPECT_FORT, ASPECT_HOST, ASPECT_ENVY, ASPECT_BADSPAWN)
	warlordclasses = list(/datum/advclass/warband/mercenary/warlord/captain)
	lieutenantclasses = list(/datum/advclass/warband/mercenary/lieutenant/vanguard, /datum/advclass/warband/mercenary/lieutenant/tactician, /datum/advclass/warband/mercenary/lieutenant/skirmisher)
	gruntclasses = list(/datum/advclass/warband/mercenary/grunt/merc)
	warcamp = /datum/map_template/warcamp_standard
	spawns = RESPAWNS_LOW
	combatmusic = list('sound/music/combat_veteran.ogg')

/datum/warbands/sect
	title = "SECT"
	name = "Sect"
	summary = "A band of fanatics driven to arms; if not by delusion, by a divine obligation."
	warning = "...of single-minded fanaticism and ritual."
	warlordclasses = list(/datum/advclass/warband/sect/warlord/prophet)
	lieutenantclasses = list(/datum/advclass/warband/sect/lieutenant/justiciar, /datum/advclass/warband/sect/lieutenant/versekeeper, /datum/advclass/warband/sect/lieutenant/sentinel)
	gruntclasses = list(/datum/advclass/warband/sect/grunt/crusader, /datum/advclass/warband/sect/grunt/cultist, /datum/advclass/warband/sect/grunt/zealot)
	subtyperequired = TRUE
	subtypes = list(WARBAND_SECTS)
	aspects = list(ASPECT_BLOCKADE, ASPECT_SURPRISE, ASPECT_FORT, ASPECT_HOST, ASPECT_FIGUREHEAD, ASPECT_ENVY, ASPECT_BADSPAWN)
	spawns = RESPAWNS_MEDIUM
	combatmusic = list('sound/music/cmode/antag/combat_thewall.ogg')

/datum/warbands/storyteller/peasant
	// storytellerlimit = /datum/storyteller/matthios FIXNOTE: don't leave this uncommented
	// rarity = 1
	title = "PEASANT REBELLION"
	name = "Peasant Rebellion"
	treaty_name = "The People"
	summary = "Turmoil in the Duchy's countryside has boiled into a full-blown rebellion."
	warning = "...turmoil in Azuria's distant countryside, and roving bands of unruly peasants."	
	warcamp = /datum/map_template/warcamp_peasant
	warlordclasses = list(/datum/advclass/warband/rebellion/warlord/ringleader)
	lieutenantclasses = list(/datum/advclass/warband/rebellion/lieutenant/folkhero, /datum/advclass/warband/rebellion/lieutenant/firebrand, /datum/advclass/warband/rebellion/lieutenant/turncoat, /datum/advclass/warband/rebellion/lieutenant/wildcard)
	gruntclasses = list(/datum/advclass/warband/rebellion/grunt/militiaman, /datum/advclass/warband/rebellion/grunt/conspirator)
	aspects = list(ASPECT_SURPRISE, ASPECT_HOST, ASPECT_FIGUREHEAD, ASPECT_ENVY, ASPECT_BADSPAWN)
	combatmusic = list('sound/music/combat_routier.ogg') // despite this being a mercenary track it's Inherently Peasantcore
	spawns = RESPAWNS_HORDE

/datum/warbands/storyteller/wizard
	// storytellerlimit = /datum/storyteller/noc FIXNOTE: don't leave this uncommented
	// rarity = 3
	title = "SORCERER-KING"
	name = "Sorcerer-King"
	treaty_name = "The Court of the Sorcerer-King"
	summary = "Atop a great tower of stone is a perversion of the Divine Right. Within lies a man without history, without blood, yet as wrathful as any true king."
	warning = "...of a terrible, twisted citadel carried upon stormclouds. They say it fell as lightning, and stuck itself within the earth."
	warcamp = /datum/map_template/warcamp_wizard
	warlordclasses = list(/datum/advclass/warband/wizard/warlord/sorcerer)
	lieutenantclasses =  list(/datum/advclass/warband/wizard/lieutenant/pyromancer, /datum/advclass/warband/wizard/lieutenant/stormcaller, /datum/advclass/warband/wizard/lieutenant/conjurer)
	gruntclasses = list(/datum/advclass/warband/wizard/grunt/stalker, /datum/advclass/warband/wizard/grunt/layman, /datum/advclass/warband/wizard/grunt/warlock)
	aspects = list(ASPECT_SURPRISE, ASPECT_HOST, ASPECT_ENVY, ASPECT_FIGUREHEAD, ASPECT_BADSPAWN)
	spawns = RESPAWNS_LOW
	combatmusic = list('sound/music/cmode/nobility/combat_courtmage.ogg')


/////////////////////////////////////////////


/datum/outskirts_wave
	var/list/wave_alert_phrase = list() // flavortext popup when a wave spawns
	var/list/npc_pool = list()			// npc pool that the outskirts wave draws from

/datum/outskirts_encounter
	var/atom/movable/screen/warband/manager/linked_warband
	var/list/current_wave = list()
	var/wave_number = 0
	var/obj/structure/outskirts_objective/objective
	var/prep_time = 3 MINUTES
	var/prep_started = FALSE
	var/encounter_active = FALSE
	var/min_wave_size = 10
	var/obj/structure/fluff/traveltile/warband/outskirts_to_intermission/attacker_entry
	var/obj/structure/fluff/traveltile/warband/outskirts_to_camp/defender_entry

/obj/structure/outskirts_objective
	var/attacker_goal
	var/defender_goal
	var/linked_encounter

/obj/structure/outskirts_objective/threshold
	name = "threshold"
	icon_state = "travel"
	icon = 'icons/turf/roguefloor.dmi'
	density = FALSE
	anchored = TRUE
	layer = ABOVE_OPEN_TURF_LAYER
	max_integrity = 0


// finds the middle point between both of the outskirts entry points and spawn the objective
// this probably won't work very well if the map's entry points are in unique positions
// but atm every encounter map is just a basic Straight Shot across from one another, so this should be fine
/datum/outskirts_encounter/proc/spawn_objective()
	if(!attacker_entry || !defender_entry)
		return

	var/turf/attacker_turf = get_turf(attacker_entry)
	var/turf/defender_turf = get_turf(defender_entry)
	
	if(!attacker_turf || !defender_turf)
		return
	
	var/mid_x = round((attacker_turf.x + defender_turf.x) / 2)
	var/mid_y = round((attacker_turf.y + defender_turf.y) / 2)
	var/turf/spawn_turf = locate(mid_x, mid_y, attacker_turf.z)

	for(var/turf/open/candidate in range(3, spawn_turf))
		if(!candidate.density)
			objective = new /obj/structure/outskirts_objective/threshold(candidate)
			objective.linked_encounter = src
			objective.attacker_goal = attacker_turf
			objective.defender_goal = defender_turf
			return


/atom/movable/screen/introtext
	name = "intro text"
	icon = 'icons/roguetown/hud/warband/placeholder_intro.dmi'
	icon_state = "warlordintro_placeholder"
	screen_loc = "4.3,9"
	alpha = 0

/atom/movable/screen/introtext/lieutenant
	icon_state = "lieutenantintro_placeholder"
	screen_loc = "4.5,9"

/atom/movable/screen/introtext/veteran
	icon_state = "veteranintro_placeholder"

/atom/movable/screen/introtext/aspirant
	icon_state = "aspirantintro_placeholder"
