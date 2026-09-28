# NPC LOADOUT DESIGN

This is for documentation on standardization of NPC stats and loadouts with the new system for future documentation purpose.

NPC statpacks are sorted by Archetypes and then separated into tiers. 10 is set as the baseline stat for STR / SPD.

Then, based on their faction they get differing loadouts and then a faction modifier is applied on top.

| Tier | Archetype                           | Con / Wil | STR | SPD | PER | INT | TP                        |
| ---- | ----------------------------------- | --------- | --- | --- | --- | --- | ------------------------- |
| 0    | Goblins. Trash Mobs. Novice Skills. | 4         | 8   | 10  | 9   | 7   | TRASH / LOW (8-10)        |
| 1    | Highwayman. Typical Filler.         | 6         | 10  | 10  | 10  | 8   | MODERATE / HIGH (14-20)   |
| 2    | Mount Reaver. Trained Infantry.     | 8         | 12  | 10  | 11  | 9   | TOUGH / DANGEROUS (25-30) |
| 3    | Road Knight. Champion.              | 10        | 14  | 10  | 12  | 10  | DEADLY (40)               |
| 4    | Sackman. God-Tier.                  | 12        | 14  | 10  | 13  | 11  | ELITE and up (50+)        |

SPD does not scale with Tier. STR, PER and INT do.

STR is capped at 14 within the tier and role grid. Faction modifiers may push past it.

## Archetype Modifier

Each roles trade stats for specialization, using the conventional statweight of STR / SPD = 2. And the rest = 1.

| Role     | Trade                               |
| -------- | ----------------------------------- |
| line     | none, baseline                      |
| light    | 2 STR -> 2 SPD, and 2 Con -> 2 INT  |
| marksman | 1 STR -> 2 PER                      |
| heavy    | 2 SPD, 2 PER -> 1 STR, 2 Con, 2 Wil |

Archetype:

- Light trade 2 STR for 2 SPD, and 2 CON for 2 INT, so they are harder to feint but more likely to use Special. One more STR for one more SPD at T3.
- Marksman trade 1 STR for 2 PER, then 2 STR for 3 PER and 1 INT at T3.
- Heavy trades 2 SPD, 2 PER for 1 STR, 2 Con, 2 Wil.

PER is capped at 15. INT 8 is the minimum for NPC specials and tactics, INT 10 or above gives feint resistance only and should be present on Light usually.

## Faction Modifier

Modifiers applied on top of whatever statpacks they have for factional flavor. These may exceed the STR and PER caps.

| Faction  | Modifier                      | Why                                                                                                                                           |
| -------- | ----------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| gronnman | 2 PER -> 1 STR                | GRAGGAR!!!! DO NOT AIM                                                                                                                        |
| orc      | 2 INT -> 1 STR                | ALSO GRAGGAR but dumber                                                                                                                       |
| goblin   | 2 SPD, net loss               | Keeps their action economy from overwhelming players.                                                                                         |
| undead   | 2 CON -> 2 WIL, and 6 INT     | Makes them more fragile to being attacked and delimbed since they are pain and bleed immune. Int Loss is to make sure they do not use special |
| madmen   | 2 STR, 2 SPD, 2 CON, net gain |                                                                                                                                               |

Bosses with bespoke packs will have no archetypes.

## Armor & Weapons

In general, for armor:

- At T2 or beyond, full or near full coverage should be expected but with weaknesses
- Line can be whatever, as appropriate for their faction, but should have competent coverage.
- Bulwark should have full if not nearly full coverage, especially at T2 or above.
- Marksmen should possesses an open faced helmet and or non-armored mask, and never a close faced helmet or mask no matter what.
- With very few exceptions, do not put Steel ARMOR on NPCs.
- Steel weapons are occasionally allowed for appropriate factions, leaning toward Azurian one.
- Desirable player weapons of low cost like Longbow can make occasional appearances, but should not be too common

## Faction Archetypes

### Goblins

- Shit sucks and their weapons and armor are overwhelmingly disastrous.
- Shitty archers and slingers. Should have LOWER speed to prevent action economy from overwhelming players easily. But also low TP
- Hoblins are their "elites"

### Azurian / Native Bandits

Includes Highwaymen / Mount Reavers.

These are the typical trash mobs our adventurers will face. Access to better steel weapons, iron armor.

"Line" or "Medium" should starts with common, late renaissance ish gears i.e. Gambeson and Cuirass and open-faced helmets. Full iron coverage can be seen. Mixture of leather and iron helmets.

T1s should occasionally miss the second layers of their armor in the chest slot.

Crossbowmen belongs to LINE and is tougher than usual, open faced helmet and metallic armor.

Archers should always be in full light armor and a mixture of leather helmets and iron helmets.

Lights should be in full light armor including helmets, and can be wielding one or two dagger and iron version of swift weapons.

Occasional heavy shows in the form of Bulwark. T1 Bulwark will have the wooden tower shield and some sort of blunt weapons and a close faced helmet but lacks full body armor. T3 can be fully ironed up. Bulwarks should favors blunt weapons for thematic purpose.

Non-forest bandit factions like Bleakisle Reavers and Mount Reavers will follow the same rules but trade numbers for higher quality and tier bandits.

### Other Archetypes

- Undead: Decrepit / Ancient gears, with Ancient Gears only for very very rare case as they are steel equivalence
- Bogman: Higher quality gears implying direct desertion from the military, full iron gears for all but their light classes should be expected, with occasional steel and high quality (Brigandine) coverage.
- Sea Raiders: Being of Gronnic origin means steel weapons should be excessively rare and armor should be light. No presence of full face coverage helmet or the combination of Open Face + Mask instead of a full helmet, since that doesn't match their technological level. Mail or Fabric / Leather should be the primary armor, with their thematic banded iron appearing as helmet and gauntlet pieces.
- Orcs: Should overwhelmingly have light armor with iron being rare and full coverage in iron being rare, due to primitiveness, with full iron armor recovered for Warlord. Should trade INT for more STR / CON / WIL
- Mad-touched: They are super boss mob and is allowed to sit above tier
