/*------------------------\
| ARMOR INTEGRITY DEFINES | // Use these when possible on armor to keep value consistent.	
\------------------------*/
// Side = Non-chest armor integrity 
// For now. Steel vs Iron will be a difference of 75% integrity without rating differences.
// So Iron will actually be pretty decent and there shouldn't be a compulsive need to upgrade.

// Helmet
#define ARMOR_INT_HELMET_ANTAG 600
#define ARMOR_INT_HELMET_BLACKSTEEL 500
#define ARMOR_INT_HELMET_HEAVY_STEEL 400
#define ARMOR_INT_HELMET_HEAVY_IRON 300
#define ARMOR_INT_HELMET_HEAVY_DECREPIT 200
#define ARMOR_INT_HELMET_HEAVY_ADJUSTABLE_PENALTY 50 // Integrity reduction, if a helmet is adjustable
#define ARMOR_INT_HELMET_STEEL 300 
#define ARMOR_INT_HELMET_IRON 225
#define ARMOR_INT_HELMET_HARDLEATHER 250
#define ARMOR_INT_HELMET_LEATHER 200
#define ARMOR_INT_HELMET_CLOTH 100

// Chest / Armor Pieces 

// HEAVY
#define ARMOR_INT_CHEST_PLATE_ANTAG 700
#define ARMOR_INT_CHEST_PLATE_BLACKSTEEL 600
#define ARMOR_INT_CHEST_PLATE_STEEL 500
#define ARMOR_INT_CHEST_PLATE_BRIGANDINE 350
#define ARMOR_INT_CHEST_PLATE_PSYDON 400 // You get free training, less int
#define ARMOR_INT_CHEST_PLATE_IRON 375
#define ARMOR_INT_CHEST_PLATE_DECREPIT 250

// MEDIUM
#define ARMOR_INT_CHEST_MEDIUM_STEEL 300
#define ARMOR_INT_CHEST_MEDIUM_IRON 225
#define ARMOR_INT_CHEST_MEDIUM_SCALE 200 // More coverage, less integrity
#define ARMOR_INT_CHEST_MEDIUM_DECREPIT 150

// LIGHT
#define ARMOR_INT_CHEST_LIGHT_MASTER 300 // High tier cloth / leather armor
#define ARMOR_INT_CHEST_LIGHT_MEDIUM 250 // Medium tier cloth / leather armor
#define ARMOR_INT_CHEST_LIGHT_BASE 200
#define ARMOR_INT_CHEST_LIGHT_STEEL 180
#define ARMOR_INT_CHEST_CIVILIAN 100

// LEG PIECES - Leg Armor
#define ARMOR_INT_LEG_ANTAG 600
#define ARMOR_INT_LEG_BLACKSTEEL 500 
#define ARMOR_INT_LEG_STEEL_PLATE 400
#define ARMOR_INT_LEG_IRON_PLATE 300
#define ARMOR_INT_LEG_DECREPIT_PLATE 200
#define ARMOR_INT_LEG_STEEL_CHAIN 300
#define ARMOR_INT_LEG_BRIGANDINE 250 // Iron grade but whatever.
#define ARMOR_INT_LEG_IRON_CHAIN 225
#define ARMOR_INT_LEG_DECREPIT_CHAIN 150
#define ARMOR_INT_LEG_HARDLEATHER 250
#define ARMOR_INT_LEG_LEATHER 200
#define ARMOR_INT_LEG_CLOTH 10

// SIDE PIECES - Non-Chest armor
#define ARMOR_INT_SIDE_ANTAG 500 // Integrity for antag pieces
#define ARMOR_INT_SIDE_BLACKSTEEL 400 // Integrity for blacksteel pieces
#define ARMOR_INT_SIDE_STEEL 300 // Integrity for steel pieces
#define ARMOR_INT_SIDE_IRON 225 // Integrity for iron pieces
#define ARMOR_INT_SIDE_HARDLEATHER 250 // Integrity for hardened leather pieces
#define ARMOR_INT_SIDE_LEATHER 200 // Integrity for leather / copper pieces
#define ARMOR_INT_SIDE_DECREPIT 150 // Integrity for decrepit pieces
#define ARMOR_INT_SIDE_CLOTH 100 // Integrity for cloth / aesthetic oriented pieces


/*--------------------\
| ARMOR VALUE DEFINES |	
\--------------------*/
// Misc defines. These are here just in case. Inherited by their relevant subtypes.
#define ARMOR_MACHINERY list("blunt" = 25, "slash" = 25, "stab" = 25,  "piercing" = 10, "fire" = 50, "acid" = 70)
#define ARMOR_STRUCTURE list("blunt" = 0, "slash" = 0, "stab" = 0, "piercing" = 0, "fire" = 50, "acid" = 50)
#define ARMOR_DISPLAYCASE list("blunt" = 30, "slash" = 30, "stab" = 30,  "piercing" = 0, "fire" = 70, "acid" = 100)
#define ARMOR_CLOSET list("blunt" = 20, "slash" = 10, "stab" = 15, "piercing" = 10, "fire" = 70, "acid" = 60)
#define ARMOR_BLACKBAG list("blunt" = 100, "slash" = 100, "stab" = 100, "piercing" = 100, "fire" = 75, "acid" = 100)	

// Light AC
// In general, light armor should always be vulnerable to stab, somewhat weak vs high pen slash (for now).
// Also good protection vs arrows.
// Minimal blunt rating should be 50, because normal blunt multiplier is 1.4, thus making sure it trade poorly
// Capped to 90 blunt rating. This means light armor will take approx. 75% damage from blunt-weapon blunt attacks.
// So blunt weapon can still be used against light armor but just not as effective.  
#define ARMOR_CLOTHING list("blunt" = 0, "slash" = 10, "stab" = 20, "piercing" = 0, "fire" = 0, "acid" = 0)
#define ARMOR_PADDED_BAD list("blunt" = 50, "slash" = 30, "stab" = 20, "piercing" = 40, "fire" = 0, "acid" = 0)
#define ARMOR_PADDED list("blunt" = 70, "slash" = 40, "stab" = 30, "piercing" = 50, "fire" = 0, "acid" = 0)
#define ARMOR_PADDED_GOOD list("blunt" = 90, "slash" = 50, "stab" = 50, "piercing" = 80, "fire" = 0, "acid" = 0)

// Leather should always be 10 less than their padded counterparts for piercing but is good vs arrows still.
#define ARMOR_LEATHER list("blunt" = 60, "slash" = 50, "stab" = 40, "piercing" = 30, "fire" = 0, "acid" = 0)
#define ARMOR_SPELLSINGER list("blunt" = 70, "slash" = 70, "stab" = 50, "piercing" = 40, "fire" = 0, "acid" = 0)
#define ARMOR_LEATHER_GOOD list("blunt" = 90, "slash" = 70, "stab" = 50, "piercing" = 50, "fire" = 0, "acid" = 0)
#define ARMOR_LEATHER_STUDDED list("blunt" = 80, "slash" = 80, "stab" = 60, "piercing" = 40, "fire" = 0, "acid" = 0) // Pseudo metallic armor therefore worse vs blunt and piercing

// Medium AC
#define ARMOR_CUIRASS list("blunt" = 40, "slash" = 100, "stab" = 80, "piercing" = 40, "fire" = 0, "acid" = 0)	
#define ARMOR_MAILLE list("blunt" = 40, "slash" = 100, "stab" = 80, "piercing" = 10, "fire" = 0, "acid" = 0)

// Heavy AC
// Also applicable to fully metallic armor (i.e. helmet)
#define ARMOR_PLATE_BAD list("blunt" = 10, "slash" = 50, "stab" = 50, "piercing" = 20, "fire" = 0, "acid" = 0) // For really bad / copper plate
#define ARMOR_PLATE list("blunt" = 10, "slash" = 100, "stab" = 80, "piercing" = 40, "fire" = 0, "acid" = 0)
#define ARMOR_PLATE_BSTEEL list("blunt" = 80, "slash" = 100, "stab" = 90, "piercing" = 80, "fire" = 0, "acid" = 0) // It's EVIL. OH GOD.

//Antag / Special / Unique armor defines
#define ARMOR_VAMP list("blunt" = 100, "slash" = 100, "stab" = 90, "piercing" = 80, "fire" = 0, "acid" = 0)
#define ARMOR_WWOLF list("blunt" = 70, "slash" = 90, "stab" = 80, "piercing" = 70, "fire" = 40, "acid" = 0)
#define ARMOR_DRAGONSCALE list("blunt" = 100, "slash" = 100, "stab" = 100, "fire" = 50, "acid" = 0)
#define ARMOR_ASCENDANT list("blunt" = 50, "slash" = 100, "stab" = 80, "piercing" = 80, "fire" = 0, "acid" = 0)
#define ARMOR_GRUDGEBEARER list("blunt" = 40, "slash" = 200, "stab" = 200, "piercing" = 100, "fire" = 0, "acid" = 0)
#define ARMOR_ZIZOCONCSTRUCT list("blunt" = 60, "slash" = 70, "stab" = 70, "piercing" = 60, "fire" = 40, "acid" = 10)
#define ARMOR_DRAGONHIDE list("blunt" = 30, "slash" = 30, "stab" = 30, "piercing" = 30, "fire" = 40, "acid" = 0) // snowflake armor for dragonhide, fire resist but lower other values from the ring since more integ
#define ARMOR_FATEWEAVER list("blunt" = 10, "slash" = 100, "stab" = 100, "piercing" = 100, "fire" = 0, "acid" = 0)
#define ARMOR_RUMACLAN	list("blunt" = 5,"slash" = 90, "stab" = 90, "piercing" = 50, "fire" = 0, "acid" = 0)
// Blocks every hit, at least once
#define ARMOR_GRONN_LIGHT list("blunt" = 80, "slash" = 80, "stab" = 30, "piercing" = 30, "fire" = 0, "acid" = 0)
