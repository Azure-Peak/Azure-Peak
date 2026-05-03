//////////////////
#define WARBANDS 	list(/datum/warbands/standard,  /datum/warbands/mercenary, /datum/warbands/sect, \
					/datum/warbands/storyteller/peasant, /datum/warbands/storyteller/wizard)

#define WARBAND_BASE_RESPAWNS 400
#define RESPAWNS_MINIMAL 25
#define RESPAWNS_LOW 50
#define RESPAWNS_MEDIUM 100
#define RESPAWNS_HIGH 200
#define RESPAWNS_HORDE 500

// subtypes
#define WARBAND_MERC_NORTHMEN		/datum/warbands/subtypes/northmen
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
#define WARBAND_MERC_TITHEBOUND 	/datum/warbands/subtypes/tithebound

#define WARBAND_MERCENARIES list(WARBAND_MERC_NORTHMEN, WARBAND_MERC_GRENZEL, WARBAND_MERC_BLACKOAK, WARBAND_MERC_CONDO, \
                            WARBAND_MERC_DESERTRIDER, WARBAND_MERC_FORLORN, WARBAND_MERC_FREI, WARBAND_MERC_GRUDGE, \
                            WARBAND_MERC_ROUTIER, WARBAND_MERC_RUMA, WARBAND_MERC_STEPPE, WARBAND_MERC_WARSCHOLAR, \
                            WARBAND_MERC_VAQUERO, WARBAND_MERC_UNDERDWELLER, WARBAND_MERC_DROW, WARBAND_MERC_HANGYAKU, WARBAND_MERC_TITHEBOUND)

#define WARBAND_SECT_TEN 		/datum/warbands/subtypes/ten 
#define WARBAND_SECT_FOUR		/datum/warbands/subtypes/ascendant
#define WARBAND_SECT_PSYDON		/datum/warbands/subtypes/psydon

#define WARBAND_SECTS	list(WARBAND_SECT_TEN, WARBAND_SECT_FOUR, WARBAND_SECT_PSYDON)

#define WARBAND_UNTAGGED_SUBTYPES	list()

// aspects
#define ASPECT_BLOCKADE 		/datum/warbands/aspects/blockade
#define ASPECT_SURPRISE			/datum/warbands/aspects/surprise
#define ASPECT_FORT				/datum/warbands/aspects/fort
#define ASPECT_HOST				/datum/warbands/aspects/extraspawns
#define ASPECT_FIGUREHEAD		/datum/warbands/aspects/figurehead
#define ASPECT_ENVY				/datum/warbands/aspects/envy
#define ASPECT_BADSPAWN			/datum/warbands/aspects/badexit

#define ASPECTS					list(ASPECT_FORT, ASPECT_BLOCKADE, ASPECT_SURPRISE, ASPECT_HOST, ASPECT_FIGUREHEAD, ASPECT_ENVY, ASPECT_BADSPAWN)

// terms
#define WARBAND_TERMS list(/datum/treaty/terms/codify_law, /datum/treaty/terms/remove_law, /datum/treaty/terms/freeze_laws, /datum/treaty/terms/set_tax/noble, \
							/datum/treaty/terms/set_tax/yeoman, /datum/treaty/terms/set_tax/peasant, /datum/treaty/terms/set_tax/church, /datum/treaty/terms/territory_loss, \
							/datum/treaty/terms/cointribute, /datum/treaty/terms/exile, /datum/treaty/terms/freeform)

#define TEMPLATE_OUTSKIRTS 1
#define TEMPLATE_INTERMISSION 2
#define TEMPLATE_WARCAMP 3
