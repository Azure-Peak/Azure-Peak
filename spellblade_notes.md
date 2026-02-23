# Spellblade 2 - Development Notes

## Philosophy
Highly mobile (depending on the subclass) pseudo-melee, caster-flavored melee where melee is necessary for them to access their most powerful toolkit. Gain utility spell access to keep a Magey feel.

Spellblade abilities get around 90% dodge and parry — if all of them could be parried/dodged it would feel horrid. However, they still cannot be cast casually into a Defend stance.

Pseudo-melee spells respect the melee combat system. If a target is Defending and the spell is blocked/parried, the caster gets Exposed — same punishment as swinging a real weapon into a guard. You fight a Spellblade the same way you fight any melee threat.

---

## Blade Subclass - Mobility themed, multi-purpose

| Ability | Role | Momentum | CD | Notes |
|---------|------|----------|----|-------|
| **Caedo** | Dash-Strike | Consumes ALL | 15s | 5 tile range (blink range). Afterimage trail. Multi-purpose: engage, escape, escape grapple (replaces fetch/repel/repulse role for mage), combine with bait. |
| **Air Slash** (was Crescent Slash) | Arc Attack | 0 or 3 | 6s | Invocation: "Aeris (TBD)". Bread-and-butter. Adapts to stance. At 3+ momentum: empowered arc + pull. |
| **Greater Forcewall** | Utility/Zone Control | None | — | Blade-exclusive. Stronger forcewall variant. |
| **Blade Storm** | AoE Nuke | 7+ required | 45s | 3x3 hollow square — center tile is NOT hit. Hard to score in a real fight (center safe zone = counterplay). Mulches mobs. Anti-dorpel (drop on ally being surrounded). Forces enemies out of chokepoints. Looks cool. |

---

## Phalangite Subclass - Hold the Line

| Ability | Role | Momentum | CD | Notes |
|---------|------|----------|----|-------|
| **Azurean Phalanx** | Line poke + push | Builds momentum | 8s | Bread-and-butter. |
| **Azurean Javelin** | Ranged AP poke + slow | Consumes stacks | 20s | Scale damage/effect with momentum consumed. |
| **Advance!** | Charge + thrust | None | 8s | 3 paces forward and thrust. Repositioning tool. |
| **Gate of Reckoning** | Portal spear + teleport | — | 30s | Conjure portal above target, spear drops on head, then blink to position and strike again. |

---

## Momentum System (Stable)
- +1 per weapon hit, 4s decay, max 10 stacks
- Overcharge at 7+: chest damage per tick, electricity overlay, impaired vision
- Stun/Knockdown: drop to 0. Off-balanced: lose 3.
- Balloon alerts "M: X/10"

---

## The Chant (Class Selection UI)
- Extracted to `spellblade_chant.dm` as global procs
- 4 faction variants (conventional, blackoak, zizite, undead) x 3 chants (blade/phalanx/macebearer)
- Undead gets "MEMORIES" title, "WAKE UP" buttons, interrupted chant

### All Planned Faction Classes
| Class | Faction | Notes |
|-------|---------|-------|
| **Spellblade** | Adventurer | Core adventurer version |
| **Spellguard** | University | University faction variant |
| **Orthodoxist** | Black Oak | Traditional school |
| **Pariah** | Black Oak | Stronger than the merc version |
| **Zizite Spellblade** | Zizo | Access to Healing, Medium Armor |
| **Unbound / Lich Spellblade** | Antagonist | Skeleton/lich risen ancient practitioner |

---

## Lore
Once there was one unified Azurean Spellbladery school, one tradition.

One survived as Adventurer / University after the fall of the Celestial Empire. A little document would document the orthodox school. It neglects to mention Zizo's school, except to not touch it.

The other, under Black Oak, thinks the conventional school a bit awkward and less traditional. But do mention it. Also tells others to not touch the Zizites.

The Zizites abhor undeath (oddly enough, for Zizo followers). They genuinely believe in progress and will fight for it. Undeath at best is a tool, at worst an abhorrence.

---

## The Blade Verse — Chant Lore (4 Faction Variants)

**Shared preamble:**

> O! Blade of Tarichea!
>
> There was once a great city. On the foot of this very mountain, over the Azure Sea.
>
> It prospered, and in its midst, our warriors practiced their art, combining the arcyne with blades. We were master! Our skills, unmatched! Our techniques, unparalleled! Envy of the world! No Ranesheni bladedancers, or Kazengunese bladesman, or Grenzelhoftian mercenary, could match our prowess! Mages! Knights! Demons! All fell before our blade.
>
> THEN - SHE ASCENDED, ALL WAS LOST.
>
> OR WAS IT?
>
> O! Blade of Azurea!

**Conventional / Adventurer:**
> Hone the tradition of five centuries! Let not the art die with the fall of the old city! Wield your blade for justice, for profit, or for mastery! There is no wrong path, except to stray into heresy!

**Black Oak / Snow Elf:**
> Hone the tradition of your people! Though the snow elves are gone, your heritage is not! As the most excellent, most long-lyved of all races, it is up to you to carry on the legacy of a spellblade! Five hundred yils of martial and arcyne excellence, five hundred yils more!

**Zizite:**
> Hone the knowledge of your patron! With her ascension. The ignorant clings onto the old way, your goddess lays imprisoned. Her teachings are all that remains. Her followers - corrupted, seeking undeath and bones, forgetting that she too, is the mistress of progress. With your very blade, you shall cut open the wound of the world, cauterize it, and let her light shine through! You are her herald.

**Undead / Tarichean:**
> Hone the blade of Tarichea! You awaken to...what? There is no demons, no Celestial Empire. What do you fight for? Why do you wield the blade? Every moves, every cuts, every thrust. Engrained into those old bones of yours. Fleshy hand that once wielded weapons, now naught but a pair of bone. Why? Do you fight? Have you been awakened by an ancient evyl, or did you just wake up, lost, dead, yet, somehow, retaining your will? Why do you fight? Why do you fight? Why do you fight?

## Refactoring TODO
- Shared `arcyne_strike` helper proc (weapon-aware strike with armor, crit rolls, animations) — currently 73 lines in shukuchi.dm, duplicated in other abilities
- Shared weapon-in-hand check (copy-pasted in most abilities)
- Shared destination validation (shukuchi + gate of reckoning share teleport checks)
- Stat allocation TBD: leaning +2 INT, +1 STR, +1 CON. Force Virtuous statpack.
