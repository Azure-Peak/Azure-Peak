// Danger levels. Each danger level is defined as an ambush that can happen. Every time this fire, this number iterates.
#define DANGER_LEVEL_SAFE "Safe"
#define DANGER_LEVEL_LOW "Low"
#define DANGER_LEVEL_MODERATE "Moderate"
#define DANGER_LEVEL_DANGEROUS "Dangerous"
#define DANGER_LEVEL_BLEAK "Bleak"

#define THREAT_REGION_AZURE_BASIN "Azure Basin"
#define THREAT_REGION_AZURE_GROVE "Azure Grove"
#define THREAT_REGION_AZUREAN_COAST "Azurean Coast"
#define THREAT_REGION_MOUNT_DECAP "Mount Decapitation"
#define THREAT_REGION_TERRORBOG "Terrorbog"
#define THREAT_REGION_UNDERDARK "Underdark"

#define LOWPOP_THRESHOLD 30 // When do we give highpop tick?

/// Threat Point tiers for ambush mobs. Base unit: 10 = one wolf.
#define THREAT_TRASH 8       // Fox, raccoon, bigrat, mire crawler, all goblins — trivial critters
#define THREAT_LOW 10        // Wolf, bobcat, badger, honeyspider, supereasy skeleton, medium skeleton
#define THREAT_MODERATE 14   // Mossback, mole, easy/pirate/bogguard skeleton, hobgoblin, militia deserter
#define THREAT_HIGH 20       // Highwayman + archer/crossbowman, orc footsoldier/archer, deepone, mutated spider
#define THREAT_TOUGH 25      // Searaider + archer, mount reaver, hard skeleton, drow raider, deepone spit/wiz
#define THREAT_DANGEROUS 30  // Bog deserter, orc berserker/marauder, troll, bog troll, drider
#define THREAT_DEADLY 40     // Searaider huscarl, road knight, sharpshooter, orc warlord, direbear — champion-tier
#define THREAT_ELITE 50      // Minotaur, mirespider lurker/paralytic, dwarf skeleton — boss-tier mobs

/// Conversion: one "band" in the Noticeboard IC description equals this many threat points.
#define THREAT_POINTS_PER_BAND 50
