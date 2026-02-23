# Spellblade 2 - Design Notes

## Philosophy
Highly mobile pseudo-melee, caster-flavored melee where melee is necessary to access the most powerful toolkit. Utility spell access keeps a Magey feel.

Spellblade abilities get around 90% dodge and parry — if all could be parried/dodged it would feel horrid. However, they still cannot be cast casually into a Defend stance. Pseudo-melee spells respect the melee combat system: Defending targets can block, and blocked spells Expose the caster.

## Chant System
Three chants (Blade / Phalangite / Macebearer) shared across all faction classes. Selected at character creation via HTML UI. Each chant gives 4 unique spells + shared spells (Bind Weapon, Recall Weapon, Mending, Enchant Weapon) + utility spell points from pool.

## Momentum System
- +1 per bound weapon hit, 4s decay, max 10 stacks
- Overcharge at 7+: chest damage per tick, electricity overlay, impaired vision
- Stun/Knockdown: drop to 0. Off-balanced: lose 3.

## Faction Classes
| Class | Faction | Defense | Special |
|-------|---------|---------|---------|
| **Spellblade** | Adventurer | Light armor | Core version |
| **Black Oak Pariah** | Wretch (Elf) | Dodge Expert | Elvish weapons, outdoorsman traits, bounty |
| **Zizite Spellblade** | Wretch (Zizo) | Medium Armor | T1 caster (healing/profane), Discretion vs Progress armor choice |
| **Unbound** | Antagonist | TBD | Skeleton/lich risen ancient practitioner |

## Lore
One unified Azurean school split after the fall of the Celestial Empire. Conventional school survived as Adventurer/University tradition. Black Oak school carried on by elves. Zizites follow Zizo's original teaching of progress — they abhor undeath and fight for advancement. The Unbound are ancient practitioners risen from the dead, fragments of the original school.
