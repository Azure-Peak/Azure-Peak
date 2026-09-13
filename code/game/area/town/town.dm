// Any areas that are part of the town
//////
/////
////		TOWN AREAS
////
///
//

/area/rogue/indoors/town
	name = "indoors"
	icon_state = "town"
	droning_sound = 'sound/music/area/towngen.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	converted_type = /area/rogue/outdoors/exposed/town
	town_area = TRUE
	deathsight_message = "the city of Azure Peak and all its bustling souls"
	detail_text = DETAIL_TEXT_AZURE_PEAK

/area/rogue/outdoors/exposed/town
	icon_state = "town"
	droning_sound = 'sound/music/area/towngen.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	fog_protected = TRUE

/area/rogue/outdoors/exposed/town/keep
	name = "Keep"
	icon_state = "manor"
	droning_sound = 'sound/music/area/manorgarri.ogg'
	keep_area = TRUE
	town_area = TRUE
	detail_text = DETAIL_TEXT_KEEP

/area/rogue/outdoors/exposed/town/keep/unbuildable
	name = "Keep unbuildable"

/area/rogue/outdoors/exposed/town/keep/unbuildable/can_craft_here()
	return FALSE

/area/rogue/indoors/town/manor
	name = "Manor"
	icon_state = "manor"
	droning_sound = list('sound/music/area/manor.ogg', 'sound/music/area/manor2.ogg')
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/exposed/manorgarri
	first_time_text = "THE KEEP OF AZURE PEAK"
	keep_area = TRUE
	detail_text = DETAIL_TEXT_MANOR

//PILGRIM
/area/rogue/indoors/town/grim
	name = "indoors"
	icon_state = "town"
	droning_sound = list('sound/music/area/towngen.ogg', 'sound/music/area/townchill.ogg', 'sound/music/area/townstroll.ogg', 'sound/music/area/townwander.ogg')
	droning_sound_dusk = 'sound/music/area/townalright.ogg'
	droning_sound_night = list( 'sound/music/area/townambient.ogg', 'sound/music/area/grimnight.ogg')
	droning_sound_dawn = 'sound/music/area/grimtowndawn.ogg'
	converted_type = /area/rogue/outdoors/exposed/town/grim
	town_area = TRUE
	deathsight_message = "the city of Pilgrim and all its bustling souls"
	detail_text = DETAIL_TEXT_AZURE_PEAK

/area/rogue/indoors/town/manor/grim
	name = "Manor"
	icon_state = "manor"
	droning_sound = list('sound/music/area/manor.ogg', 'sound/music/area/manor2.ogg', 'sound/music/area/grimmanor.ogg', 'sound/music/area/grimcastle.ogg', 'sound/music/area/grimabode.ogg')
	droning_sound_dusk = 'sound/music/area/townalright.ogg'
	droning_sound_night = 'sound/music/area/grimnight.ogg'
	droning_sound_dawn = 'sound/music/area/grimtowndawn.ogg'
	converted_type = /area/rogue/outdoors/exposed/town/keep/grim
	first_time_text = "PILGRIM KEEP"
	keep_area = TRUE
	detail_text = DETAIL_TEXT_MANOR

/area/rogue/outdoors/exposed/town/keep/grim
	name = "Keep"
	icon_state = "manor"
	droning_sound = 'sound/music/area/grimgarri.ogg'
	droning_sound_dusk = 'sound/music/area/townalright.ogg'
	droning_sound_night = list('sound/music/area/townambient.ogg', 'sound/music/area/grimnight.ogg')
	droning_sound_dawn = 'sound/music/area/grimtowndawn.ogg'
	keep_area = TRUE
	town_area = TRUE
	detail_text = DETAIL_TEXT_KEEP

/area/rogue/outdoors/exposed/town/keep/grim/training
	name = "Training Yard"
	icon_state = "manor"
	droning_sound = 'sound/music/area/grimgarri.ogg'
	droning_sound_dusk = 'sound/music/area/townalright.ogg'
	droning_sound_night = list('sound/music/area/townambient.ogg', 'sound/music/area/grimnight.ogg')
	droning_sound_dawn = 'sound/music/area/grimtowndawn.ogg'
	keep_area = TRUE
	town_area = TRUE
	detail_text = DETAIL_TEXT_KEEP

/area/rogue/indoors/town/garrison/grim
	icon_state = "garrison"
	droning_sound = 'sound/music/area/grimgarri.ogg'
	droning_sound_dusk = 'sound/music/area/townalright.ogg'
	droning_sound_night = list('sound/music/area/townambient.ogg', 'sound/music/area/grimnight.ogg')
	droning_sound_dawn = 'sound/music/area/grimtowndawn.ogg'
	keep_area = TRUE
	town_area = TRUE

/area/rogue/outdoors/exposed/town/grim
	icon_state = "town"
	droning_sound = list('sound/music/area/towngen.ogg', 'sound/music/area/townchill.ogg', 'sound/music/area/townstroll.ogg', 'sound/music/area/townwander.ogg')
	droning_sound_dusk = 'sound/music/area/townalright.ogg'
	droning_sound_night = list('sound/music/area/townambient.ogg', 'sound/music/area/grimnight.ogg')
	droning_sound_dawn = 'sound/music/area/grimtowndawn.ogg'
	fog_protected = TRUE

/area/rogue/indoors/town/bath/grim
	name = "Calmer Baths"
	icon_state = "bath"
	droning_sound = list('sound/music/area/bathchill.ogg', 'sound/music/area/grimpeace.ogg', 'sound/music/area/bathcalm.ogg')
	droning_sound_dusk = 'sound/music/area/townalright.ogg'
	droning_sound_night = list('sound/music/area/bathchill.ogg', 'sound/music/area/grimpeace.ogg', 'sound/music/area/bathcalm.ogg')
	converted_type = /area/rogue/outdoors/exposed/bath

/area/rogue/indoors/town/church/grim
	name = "The House of the Ten"
	icon_state = "church"
	droning_sound = 'sound/music/area/grimchurch.ogg'
	droning_sound_dusk = 'sound/music/area/townalright.ogg'
	droning_sound_night = null
	droning_sound_dawn = 'sound/music/area/grimtowndawn.ogg'
	holy_area = TRUE
	converted_type = /area/rogue/outdoors/exposed/church/grim
	deathsight_message = "a hallowed place, sworn to the Ten"

/area/rogue/indoors/town/church/grim/infirmary
	name = "The Infirmary of the Ten"
	icon_state = "church"
	droning_sound = 'sound/music/area/grimchurch.ogg'
	droning_sound_dusk = 'sound/music/area/townalright.ogg'
	droning_sound_night = null
	droning_sound_dawn = 'sound/music/area/grimtowndawn.ogg'
	holy_area = TRUE
	converted_type = /area/rogue/outdoors/exposed/church/grim
	deathsight_message = "a hallowed place, sworn to the Ten"

/area/rogue/outdoors/exposed/church/grim
	icon_state = "church"
	droning_sound = 'sound/music/area/grimchurch.ogg'
	droning_sound_dusk = 'sound/music/area/townalright.ogg'
	droning_sound_night = null
	droning_sound_dawn = 'sound/music/area/grimtowndawn.ogg'
	deathsight_message = "a hallowed place, sworn to the Ten"

/area/rogue/indoors/town/church/chapel/grim
	icon_state = "chapel"
	first_time_text = "THE CATHEDRAL OF THE TEN"
	droning_sound = 'sound/music/area/grimchurch.ogg'
	droning_sound_dusk = 'sound/music/area/townalright.ogg'
	droning_sound_night = null
	droning_sound_dawn = 'sound/music/area/grimtowndawn.ogg'
	holy_area = TRUE
	detail_text = DETAIL_TEXT_CHAPEL

/area/rogue/indoors/town/church/chapel/grim/almonry
	icon_state = "chapel"
	first_time_text = "EORAN ALMONRY"
	droning_sound = list( 'sound/music/area/townchill.ogg', 'sound/music/area/townstroll.ogg', 'sound/music/area/townwander.ogg')
	droning_sound_dusk = 'sound/music/area/townalright.ogg'
	droning_sound_night = list('sound/music/area/townambient.ogg', 'sound/music/area/grimnight.ogg')
	droning_sound_dawn = 'sound/music/area/grimtowndawn.ogg'
	holy_area = TRUE
	detail_text = DETAIL_TEXT_CHAPEL

/area/rogue/indoors/town/pestra_sanctum/grim
	name = "Pestran Crypts"
	icon_state = "pestrasanctum"
	droning_sound = 'sound/music/area/grimsanctum.ogg'
	droning_sound_dusk = 'sound/music/area/grimdusk.ogg'
	droning_sound_night = 'sound/music/area/grimnight.ogg'
	droning_sound_dawn = 'sound/music/area/grimtowndawn.ogg'
	spookysounds = SPOOKY_MYSTICAL
	spookynight = SPOOKY_MYSTICAL
	first_time_text = "THE PESTRAN CRYPTS"
	keep_area = TRUE

/area/rogue/indoors/town/church/basement/grim
	icon_state = "church"
	droning_sound = 'sound/music/area/grimchurch.ogg'
	droning_sound_dusk = 'sound/music/area/townalright.ogg'
	droning_sound_night = null
	droning_sound_dawn = 'sound/music/area/grimtowndawn.ogg'
	first_time_text = "CATHEDRAL CRYPTS"

/area/rogue/indoors/town/tavern/grim
	first_time_text = "THE BLUSHING BOGMAN"
	name = "Blushing Bogman"
	icon_state = "tavern"
	ambientsounds = AMB_INGEN
	ambientnight = AMB_INGEN
	droning_sound = list('sound/music/area/genericrevelry.ogg', 'sound/music/area/genericcalm.ogg', 'sound/music/area/genericchill.ogg', 'sound/music/area/genericflutey.ogg')
	droning_sound_dusk = list('sound/music/area/townalright.ogg', 'sound/music/area/grimpeace.ogg', 'sound/music/area/genericjaunty.ogg')
	droning_sound_night = 'sound/music/area/grimnight.ogg'
	droning_sound_dawn = 'sound/music/area/grimtowndawn.ogg'
	converted_type = /area/rogue/outdoors/exposed/tavern
	tavern_area = TRUE
	deathsight_message = "the local tavern, shadowed patrons either scattering or standing to watch this unfortunate soul"

/area/rogue/indoors/town/magician/grim
	name = "Arcyne College"
	icon_state = "magician"
	spookysounds = SPOOKY_MYSTICAL
	spookynight = SPOOKY_MYSTICAL
	droning_sound = 'sound/music/area/magiciantower.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "THE ARCYNE UNIVERSITY"
	converted_type = /area/rogue/outdoors/exposed/magiciantower
	keep_area = TRUE
	detail_text = DETAIL_TEXT_UNIVERSITY_OF_AZURIA
	deathsight_message = "A location wreathed in arcyne energies- swirling mists of purples and blues clouding the edges of your vision"

//PILGRIM END

/area/rogue/outdoors/exposed/manorgarri
	icon_state = "manorgarri"
	droning_sound = 'sound/music/area/manorgarri.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	keep_area = TRUE

/area/rogue/indoors/town/magician
	name = "University of Azuria"
	icon_state = "magician"
	spookysounds = SPOOKY_MYSTICAL
	spookynight = SPOOKY_MYSTICAL
	droning_sound = 'sound/music/area/magiciantower.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "THE UNIVERSITY OF AZURIA"
	converted_type = /area/rogue/outdoors/exposed/magiciantower
	keep_area = TRUE
	detail_text = DETAIL_TEXT_UNIVERSITY_OF_AZURIA

/area/rogue/indoors/town/pestra_sanctum
	name = "Sanctum of Pestra"
	icon_state = "pestrasanctum"
	droning_sound = 'sound/music/area/catacombs.ogg'
	spookysounds = SPOOKY_MYSTICAL
	spookynight = SPOOKY_MYSTICAL
	first_time_text = "THE SANCTUM OF PESTRA"
	droning_sound_dusk = null
	droning_sound_night = null
	keep_area = TRUE

/area/rogue/outdoors/exposed/magiciantower
	icon_state = "magiciantower"
	droning_sound = 'sound/music/area/magiciantower.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	keep_area = TRUE
	town_area = TRUE
	detail_text = DETAIL_TEXT_UNIVERSITY_OF_AZURIA

/area/rogue/indoors/town/shop
	name = "Merchant"
	icon_state = "shop"
	droning_sound = 'sound/music/area/shop.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/exposed/shop

/area/rogue/outdoors/exposed/shop
	icon_state = "shop"
	droning_sound = 'sound/music/area/shop.ogg'

/area/rogue/indoors/town/steward
	name = "Steward"
	icon_state = "steward"
	droning_sound = 'sound/music/area/shop.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/indoors/town/physician
	name = "Physician"
	icon_state = "physician"
	droning_sound = 'sound/music/area/magiciantower.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/indoors/town/bath
	name = "Baths"
	icon_state = "bath"
	droning_sound = 'sound/music/area/bath.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/exposed/bath

/area/rogue/outdoors/exposed/bath
	icon_state = "bath"
	droning_sound = 'sound/music/area/bath.ogg'

/area/rogue/outdoors/exposed/bath/vault
	name = "Bathmaster vault"
	icon_state = "bathvault"
	ceiling_protected = TRUE

/area/rogue/indoors/town/garrison
	name = "Garrison"
	icon_state = "garrison"
	droning_sound = 'sound/music/area/manorgarri.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/exposed/manorgarri
	keep_area = TRUE

/area/rogue/indoors/town/cell
	name = "dungeon cell"
	icon_state = "cell"
	spookysounds = SPOOKY_DUNGEON
	spookynight = SPOOKY_DUNGEON
	droning_sound = 'sound/music/area/manorgarri.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/exposed/manorgarri
	keep_area = TRUE
	cell_area = TRUE

/area/rogue/indoors/town/tavern
	name = "Azurian Pint"
	icon_state = "tavern"
	ambientsounds = AMB_INGEN
	ambientnight = AMB_INGEN
	droning_sound = 'sound/silence.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/exposed/tavern
	tavern_area = TRUE

/area/rogue/outdoors/exposed/tavern
	icon_state = "tavern"
	droning_sound = 'sound/silence.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	tavern_area = TRUE

/area/rogue/indoors/town/church
	name = "The House of the Ten"
	icon_state = "church"
	droning_sound = 'sound/music/area/church.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	holy_area = TRUE
	droning_sound_dawn = 'sound/music/area/churchdawn.ogg'
	converted_type = /area/rogue/outdoors/exposed/church
	deathsight_message = "a hallowed place, sworn to the Ten"

/area/rogue/outdoors/exposed/church
	icon_state = "church"
	droning_sound = 'sound/music/area/church.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	droning_sound_dawn = 'sound/music/area/churchdawn.ogg'
	deathsight_message = "a hallowed place, sworn to the Ten"

/area/rogue/indoors/town/church/chapel
	icon_state = "chapel"
	first_time_text = "THE HOUSE OF THE TEN"
	detail_text = DETAIL_TEXT_CHAPEL

/area/rogue/indoors/town/church/basement
	icon_state = "church"
	droning_sound = 'sound/music/area/catacombs.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "CATHEDRAL CELLARAGE"

/area/rogue/indoors/town/fire_chamber
	name = "incinerator"
	icon_state = "fire_chamber"

/area/rogue/indoors/town/warehouse
	name = "dock warehouse import"
	icon_state = "warehouse"

/area/rogue/indoors/inq
	name = "The Inquisition"
	icon_state = "chapel"
	first_time_text = "THE OTAVAN INQUISITION"
	detail_text = DETAIL_TEXT_INQUISITION_HQ

/area/rogue/indoors/inq/embassy
	name = "The Otavan Embassy"
	icon_state = "chapel"
	first_time_text = "THE OTAVAN EMBASSY"

/area/rogue/indoors/inq/office
	name = "The Inquisitor's Office"
	icon_state = "chapel"

/area/rogue/indoors/inq/basement
	name = "The Inquisition's Basement"
	icon_state = "chapel"

/area/rogue/indoors/inq/chapel
	name = "The Psydonic Chapel"
	icon_state = "chapel"
	first_time_text = "THE PSYDONIC CHAPEL"

/area/rogue/indoors/town/warehouse/can_craft_here()
	return FALSE

/area/rogue/indoors/inq/import
	name = "foreign imports"
	icon_state = "warehouse"

/area/rogue/indoors/inq/import/can_craft_here()
	return FALSE

/area/rogue/indoors/town/vault
	name = "vault"
	icon_state = "vault"
	keep_area = TRUE
/area/rogue/indoors/town/entrance
	first_time_text = "Roguetown"
	icon_state = "entrance"

/area/rogue/indoors/town/dwarfin
	name = "The Guild of Craft"
	icon_state = "dwarfin"
	droning_sound = 'sound/music/area/dwarf.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "AZUREAN GUILD OF CRAFT"
	converted_type = /area/rogue/outdoors/exposed/dwarf
	detail_text = DETAIL_TEXT_AZUREAN_GUILD_OF_CRAFT

/area/rogue/outdoors/exposed/dwarf
	icon_state = "dwarf"
	droning_sound = 'sound/music/area/dwarf.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/indoors/town/zhurch
	name = "Chapel of the Ecclesial"
	droning_sound = 'sound/music/area/zhurch.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
