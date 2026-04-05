/*------------------------\
| ARMOR PENETRATION DEFINES |
\------------------------*/
// Penetration tier system
// Weapon penfactor (on intents) vs armor blocking tier (on clothing).
// If penfactor > armor tier: 100% of damage penetrates armor.
// If penfactor == armor tier: 20% of damage penetrates armor.
// If penfactor < armor tier: fully blocked (0 through).
// Blunt uses DR Absorb — damage multiplied by 1 / (1 + 0.2 * DR tier), all absorbed by armor (none to HP).
// Fire/Acid use DR Pierce — same DR formula, but reduced damage still hits HP.

// Penetration tiers (0-4). Weapon attacks.
#define PEN_NONE			0	// No penetration. Training weapons, base cuts/chops.
#define PEN_LIGHT			1	// Falx cut, axe chop. Penetrates trash armor (NPC cloth/bad leather).
#define PEN_MEDIUM			2	// Sword thrusts, longsword chop. Penetrates player light armor (gambeson, hardened leather).
#define PEN_HEAVY			3	// Spear, estoc. Penetrates mail/brigandine/plate at same-tier 20%.
#define PEN_BSTEEL			4	// Halfsword, dagger pick. Penetrates plate fully, blacksteel at 20%.

// Damage Blocking tiers (0-4). Armor clothing.
#define DBLOCK_NONE			0	// No blocking. Unarmored skin.
#define DBLOCK_LIGHT		1	// Cloth, bad leather, NPC trash armor.
#define DBLOCK_MEDIUM		2	// Gambeson, padded, hardened leather, studded — player light armor.
#define DBLOCK_HEAVY		3	// Brigandine, mail, cuirass, plate.
#define DBLOCK_BSTEEL		4	// Blacksteel, antagonist.

// Damage reduction tiers (0-5). Used by blunt (absorb), fire, acid (pierce).
// Note that blunt by default have 1.6x Integrity Multiplier.
// Damage multiplier = 1 / (1 + 0.2 * tier)
// Blunt: all damage absorbed by armor. Fire/Acid: reduced damage still hits HP.
#define DR_NONE				0	// Nothing. 100% damage. EDPS: 160%
#define DR_LIGHT			1	// Plate / Metal. 20% EHP increase. EDPS: 133%
#define DR_MEDIUM			2	// Mail. 40% EHP increase. EDPS: 114%
#define DR_HEAVY			3	// Bad Light Armor. 60% EHP increase. EDPS: 100%
#define DR_SUPER			4	// Medium Light Armor. 80% EHP increase. EDPS: 89%
#define DR_ULTRA			5	// Best quality light armor. 100% EHP increase. EDPS: 80%

// Armor damage type categories
// DR Absorb: damage reduced by tier, ALL damage goes to armor integrity (none to HP). Blunt.
// DR Pierce: damage reduced by tier, reduced damage STILL hits HP. Armor also takes integrity damage. Fire, acid.
// DBLOCK: tier pass/fail penetration system. Slash, stab, piercing.
#define ARMOR_DR_ABSORB_TYPES list("blunt")
#define ARMOR_DR_PIERCE_TYPES list("fire", "acid")
#define ARMOR_DR_TYPES list("blunt", "fire", "acid")
#define ARMOR_DBLOCK_TYPES list("slash", "stab", "piercing")

// Penetration passthrough fractions
#define PEN_PASSTHROUGH_OVER	1.0		// pen > armor tier: full damage through
#define PEN_PASSTHROUGH_SAME	0.2		// pen == armor tier: 20% damage through
// pen < armor tier: fully blocked (0 through)
// 0.2 is calculated from 55 AP + 30 damage spear = 5 damage through on 80 plate (stab), 5 / 30 = 0.166, rounded up to 0.2. This somewhat matches old system behavior.

/*------------------------\
| ARMOR INTEGRITY DEFINES | // Use these when possible on armor to keep value consistent.
\------------------------*/
// Side = Non-chest armor integrity
// For now. Steel vs Iron will be a difference of 75% integrity without rating differences.
// So Iron will actually be pretty decent and there shouldn't be a compulsive need to upgrade.

#define ARMOR_INTEG_FAILURE 0.1	//Percentage of damage the armor breaks at. 0.1 = 10%

// Helmet
#define ARMOR_INT_HELMET_ANTAG 600
#define ARMOR_INT_HELMET_BLACKSTEEL 500
#define ARMOR_INT_HELMET_HEAVY_BRONZE 450
#define ARMOR_INT_HELMET_HEAVY_STEEL 400
#define ARMOR_INT_HELMET_HEAVY_IRON 300
#define ARMOR_INT_HELMET_HEAVY_DECREPIT 200
#define ARMOR_INT_HELMET_HEAVY_ADJUSTABLE_PENALTY 50 // Integrity reduction, if a helmet is adjustable
#define ARMOR_INT_HELMET_BRONZE 350 //More integrity, less protection.
#define ARMOR_INT_HELMET_STEEL 300
#define ARMOR_INT_HELMET_IRON 225
#define ARMOR_INT_HELMET_HARDLEATHER 250
#define ARMOR_INT_HELMET_LEATHER 200
#define ARMOR_INT_HELMET_CLOTH 100

// Chest / Armor Pieces

// HEAVY
#define ARMOR_INT_CHEST_PLATE_ANTAG 700
#define ARMOR_INT_CHEST_PLATE_BLACKSTEEL 600
#define ARMOR_INT_CHEST_PLATE_BRONZE 300
#define ARMOR_INT_CHEST_PLATE_STEEL 500
#define ARMOR_INT_CHEST_PLATE_STEELLIGHT 450
#define ARMOR_INT_CHEST_PLATE_PSYDON 400 // You get free training, less int
#define ARMOR_INT_CHEST_PLATE_IRON 375
#define ARMOR_INT_CHEST_PLATE_BRIGANDINE 350
#define ARMOR_INT_CHEST_PLATE_BRIGANDINE_WEIGHT_MODIFIER 50 //Light AC brigandine parts get -50, Heavy AC brigandine parts get +50.
#define ARMOR_INT_CHEST_PLATE_IRONLIGHT 325
#define ARMOR_INT_CHEST_PLATE_DECREPIT 250
#define ARMOR_INT_CHEST_PLATE_DECREPITLIGHT 200

// MEDIUM
#define ARMOR_INT_CHEST_MEDIUM_BRONZE 250
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
#define ARMOR_INT_LEG_BRONZE 250
#define ARMOR_INT_LEG_DECREPIT_PLATE 200
#define ARMOR_INT_LEG_STEEL_CHAIN 300
#define ARMOR_INT_LEG_BRIGANDINE 250
#define ARMOR_INT_LEG_IRON_CHAIN 225
#define ARMOR_INT_LEG_DECREPIT_CHAIN 150
#define ARMOR_INT_LEG_HARDLEATHER 250
#define ARMOR_INT_LEG_LEATHER 200
#define ARMOR_INT_LEG_CLOTH 10

// SIDE PIECES - Non-Chest armor
#define ARMOR_INT_SIDE_ANTAG 500 // Integrity for antag pieces
#define ARMOR_INT_SIDE_BLACKSTEEL 400 // Integrity for blacksteel pieces
#define ARMOR_INT_SIDE_BRONZE 250 // Integrity for bronze pieces
#define ARMOR_INT_SIDE_STEEL 300 // Integrity for steel pieces
#define ARMOR_INT_SIDE_IRON 225 // Integrity for iron pieces
#define ARMOR_INT_SIDE_HARDLEATHER 250 // Integrity for hardened leather pieces
#define ARMOR_INT_SIDE_LEATHER 200 // Integrity for leather / copper pieces
#define ARMOR_INT_SIDE_DECREPIT 150 // Integrity for decrepit pieces
#define ARMOR_INT_SIDE_CLOTH 100 // Integrity for cloth / aesthetic oriented pieces
#define ARMOR_INT_SIDE_GOLDPLUS 10 // Integrity for royal variants of golden / cermemonial pieces
#define ARMOR_INT_SIDE_GOLD 5 // Integrity for golden / ceremonial pieces
#define ARMOR_INT_SIDE_COVERAGE_BONUS 50 //bonus integrity for side pieces lacking coverage, eg. gorgets

/*--------------------\
| ARMOR VALUE DEFINES |
\--------------------*/
// Misc defines. These are here just in case. Inherited by their relevant subtypes.
#define ARMOR_MACHINERY list("blunt" = DR_LIGHT, "slash" = DBLOCK_LIGHT, "stab" = DBLOCK_LIGHT, "piercing" = DBLOCK_LIGHT, "fire" = DR_MEDIUM, "acid" = DR_HEAVY)
#define ARMOR_STRUCTURE list("blunt" = DR_NONE, "slash" = DBLOCK_NONE, "stab" = DBLOCK_NONE, "piercing" = DBLOCK_NONE, "fire" = DR_MEDIUM, "acid" = DR_MEDIUM)
#define ARMOR_DISPLAYCASE list("blunt" = DR_LIGHT, "slash" = DBLOCK_LIGHT, "stab" = DBLOCK_LIGHT, "piercing" = DBLOCK_NONE, "fire" = DR_HEAVY, "acid" = DR_ULTRA)
#define ARMOR_CLOSET list("blunt" = DR_LIGHT, "slash" = DBLOCK_LIGHT, "stab" = DBLOCK_LIGHT, "piercing" = DBLOCK_LIGHT, "fire" = DR_HEAVY, "acid" = DR_HEAVY)
#define ARMOR_BLACKBAG list("blunt" = DR_ULTRA, "slash" = DBLOCK_BSTEEL, "stab" = DBLOCK_BSTEEL, "piercing" = DBLOCK_BSTEEL, "fire" = DR_SUPER, "acid" = DR_ULTRA)

// TRASH — Cloth, bad leather, NPC trash.
#define ARMOR_CLOTHING list("blunt" = DR_NONE, "slash" = DBLOCK_NONE, "stab" = DBLOCK_NONE, "piercing" = DBLOCK_NONE, "fire" = DR_NONE, "acid" = DR_NONE)
#define ARMOR_PADDED_BAD list("blunt" = DR_MEDIUM, "slash" = DBLOCK_LIGHT, "stab" = DBLOCK_LIGHT, "piercing" = DBLOCK_LIGHT, "fire" = DR_NONE, "acid" = DR_NONE)

// LIGHT ARMOR - Split into two sidegrades: PADDED VS LEATHER
// PADDED: Best Blunt protection, Bodkin immune. But Axe CHOP (MEDIUM) and most thrusts (LIGHT) get through. 
// LEATHER: Decent Blunt DR. Axe CHOP (MEDIUM), sword thrust (MEDIUM) and bodkin (HEAVY) get through. Better vs stab than padded, worse vs piercing.
#define ARMOR_PADDED list("blunt" = DR_SUPER, "slash" = DBLOCK_MEDIUM, "stab" = DBLOCK_LIGHT, "piercing" = DBLOCK_BSTEEL, "fire" = DR_MEDIUM, "acid" = DR_NONE)
#define ARMOR_LEATHER list("blunt" = DR_ULTRA, "slash" = DBLOCK_MEDIUM, "stab" = DBLOCK_MEDIUM, "piercing" = DBLOCK_HEAVY, "fire" = DR_MEDIUM, "acid" = DR_NONE)

// LIGHT ARMOR - SNOWFLAKE. Not comfortable with them, but not touching it atm.
#define ARMOR_DRAGONSKIN list("blunt" = DR_SUPER, "slash" = DBLOCK_MEDIUM, "stab" = DBLOCK_MEDIUM, "piercing" = DBLOCK_MEDIUM, "fire" = DR_HEAVY, "acid" = DR_NONE) // Iconoclast dragon skin. Fire resistant.
#define ARMOR_DRAGONHIDE list("blunt" = DR_SUPER, "slash" = DBLOCK_MEDIUM, "stab" = DBLOCK_LIGHT, "piercing" = DBLOCK_LIGHT, "fire" = DR_HEAVY, "acid" = DR_NONE) // snowflake armor for dragonhide - a bit worse than hard leather but w/ decent fire resist

// BRIGANDINE — All brigandine parts. Better blunt and arrow padding than plate, but sword stabs and above will pen. Best light armor gets for melee. Medium/heavy classes should still wear maille under it!
#define ARMOR_BRIGANDINE list("blunt" = DR_HEAVY, "slash" = DBLOCK_HEAVY, "stab" = DBLOCK_MEDIUM, "piercing" = DBLOCK_HEAVY, "fire" = DR_NONE, "acid" = DR_NONE)

// BRONZE - All bronze armor. Not particularly good against any specialized AP intent, but uniquely resistant to fire damage from mage spells and the like. THIS SHOULD BE USING IRON INTEGRITY.
#define ARMOR_BRONZE list("blunt" = DR_MEDIUM, "slash" = DBLOCK_MEDIUM, "stab" = DBLOCK_MEDIUM, "piercing" = DBLOCK_MEDIUM, "fire" = DR_LIGHT, "acid" = DR_LIGHT)

// MAILLE — Chainmail. Medium: Plate level protection but weak vs Bodkin (100% through)
#define ARMOR_MAILLE list("blunt" = DR_MEDIUM, "slash" = DBLOCK_HEAVY, "stab" = DBLOCK_HEAVY, "piercing" = DBLOCK_LIGHT, "fire" = DR_NONE, "acid" = DR_NONE)

// PLATE — Cuirass, plate. All plate-tier items; differentiated by integrity, not rating. Spear (PEN_HEAVY) gets 20% through stab. Bodkin goes through 100% - MEDIUM rating. Weak vs Blunt. 
#define ARMOR_PLATE list("blunt" = DR_LIGHT, "slash" = DBLOCK_HEAVY, "stab" = DBLOCK_HEAVY, "piercing" = DBLOCK_MEDIUM, "fire" = DR_NONE, "acid" = DR_NONE)

// BSTEEL — Blacksteel, antagonist. DBLOCK_BSTEEL (4).
// Halfsword (PEN_BSTEEL) gets 20% through. Blunt still works decently (DR_MEDIUM only).
#define ARMOR_PLATE_BSTEEL list("blunt" = DR_MEDIUM, "slash" = DBLOCK_BSTEEL, "stab" = DBLOCK_BSTEEL, "piercing" = DBLOCK_BSTEEL, "fire" = DR_MEDIUM, "acid" = DR_MEDIUM)

//Antag / Special / Unique armor defines
// If you DO NOT have a VERY VERY good design reasons for why your armor should varies 
// Please do not add it and use an existing one, so to prevent armor bloat and keep armor
// reasonable and intuitive.
#define ARMOR_REGENERATING_BROKEN list("blunt" = DR_LIGHT, "slash" = DBLOCK_LIGHT, "stab" = DBLOCK_LIGHT, "piercing" = DBLOCK_LIGHT, "fire" = DR_NONE, "acid" = DR_NONE)
#define ARMOR_VAMP list("blunt" = DR_ULTRA, "slash" = DBLOCK_BSTEEL, "stab" = DBLOCK_HEAVY, "piercing" = DBLOCK_HEAVY, "fire" = DR_NONE, "acid" = DR_NONE)
#define ARMOR_WWOLF list("blunt" = DR_SUPER, "slash" = DBLOCK_HEAVY, "stab" = DBLOCK_HEAVY, "piercing" = DBLOCK_MEDIUM, "fire" = DR_MEDIUM, "acid" = DR_NONE)
#define ARMOR_GNOLL_WEAK list("blunt" = DR_ULTRA, "slash" = DBLOCK_HEAVY, "stab" = DBLOCK_HEAVY, "piercing" = DBLOCK_MEDIUM, "fire" = DR_MEDIUM, "acid" = DR_NONE)
#define ARMOR_GNOLL_STANDARD list("blunt" = DR_SUPER, "slash" = DBLOCK_HEAVY, "stab" = DBLOCK_HEAVY, "piercing" = DBLOCK_HEAVY, "fire" = DR_MEDIUM, "acid" = DR_NONE)
#define ARMOR_GNOLL_STRONG list("blunt" = DR_MEDIUM, "slash" = DBLOCK_BSTEEL, "stab" = DBLOCK_BSTEEL, "piercing" = DBLOCK_HEAVY, "fire" = DR_MEDIUM, "acid" = DR_NONE)
#define ARMOR_BLACKOAK list("blunt" = DR_ULTRA, "slash" = DBLOCK_LIGHT, "stab" = DBLOCK_BSTEEL, "piercing" = DBLOCK_MEDIUM, "fire" = DR_NONE, "acid" = DR_NONE) // Wood: great vs blunt/stab, bad vs slash

// Indestructible / Meme
#define ARMOR_INDESTRUCTIBLE list("blunt" = DR_ULTRA, "slash" = DBLOCK_BSTEEL, "stab" = DBLOCK_BSTEEL, "piercing" = DBLOCK_BSTEEL, "fire" = DR_ULTRA, "acid" = DR_ULTRA) // Magical / indestructible items
#define ARMOR_BUCKET list("blunt" = DR_LIGHT, "slash" = DBLOCK_LIGHT, "stab" = DBLOCK_LIGHT, "piercing" = DBLOCK_NONE, "fire" = DR_HEAVY, "acid" = DR_SUPER) // It's a bucket. On your head.
