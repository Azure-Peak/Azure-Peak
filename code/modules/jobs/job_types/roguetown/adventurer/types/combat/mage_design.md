Mage Design doc - Ansari / WeNeedMorePhoron

# Introduction
This is a design document for mages and spellblades in particular. 

When I first joined Azure Peak around March, the balance of mage were all over the place. Very few viable projectiles, Arcyne Bolt that was completely doodoo, Fireball that didn't work until it suddenly hit the over 10 firestacks threshold and nuke you with 200 damage per stack (I remember getting downvoted for removing it), LBolt that if you score win the fight with hardstun and if you misses might as well kill yourself. Repulse that wins. Buff spells with inconsistent duration that was slapped on yourself.

The talk back then, of balance, was to make Antimagic - a hard counter, much more common, with a PR for Inquisition getting a Mage Hunter. I thought the problem was different - spells were not balanced to be useful on their own, certain spells were far too dominant, there were multiple "gotcha" with spells, and Mage were built on a "feast or famine" mentality of either you mouthgrab them through mask and end them rightly or they end you with LBolt. No one got to have fun. 

Now, after the mage overhauls I made around April 2025 to September (The major one in April, and follow up of nerfing and changing Spitfire's blind, LBolt's hardstun and Repulse's hardstun in several succeeding PR, not all of which were popular), I felt like Mage was in a healthier place.

With the porting of new spells, QOLs I've added to mages (spell switching and all), addition of new spells I felt like mage balance and content is once again, in decline, leaning toward the cheesier side of mage with a lot of way for them to prep their way out of a competitive fight. 

I believe Point Buy free mage is a design deadend. There's no way one can improve the diversity of Mage theme without someone inevitably combining it in the least fun possible combination to nodiff someone. 

Going forward, mage like the Grenzelhoftian Mage, where nearly all of the COMBAT adjacent spells are in a handpicked package without any possibility for unwanted combinations. I think Mage can retain quite a bit of whimsy - and I will be expanding the arsenal of non combat adjacent (or combat niche) spells that I deem safe for mage to "free pick", moving away from a free point buy system in which every mage sticks to their thematic in a tightly controlled package.

# Spellblade 2
Spellblade 2 is my first attempt to move Azure away from the current Mage paradigm, of free point buy into an undefeatable combination. Instead, it is a tightly controlled thematic pairing of combat spells, while retaining the trapping of a freeform mage by access to what I call utilities or whimsy spells, alchemy, and mage gameplay loop through skills. 

Compared to a pure / skirmisher mage, Spellblade is supposed to play pretense at being a melee class, but more versatile yet with less clutch like armor or certain defensive options. A pure mage is a pure ranged hate machine and thus harder to design in a way that is more fun to fight and fight against. Spellblade does have the advantage of being a pseudo melee class (Already arguaably the heaviest in skill expression and the most conventional in design), so I feel like it made sense as the first class to prototype. 

The design of Spellblade 2 revolves around that you are not a ranged skirmisher with peel ala current spellblade, but that you are a melee caster who melee in a very magey way with abilities that give you mobility, and is "magey" in the sense that they are often multiple purposes and can reposition and get yourself out of situations others will find themselves cornered in. In exchange, you of course, have less clutch than those melee classes like armor or miracle to fallback on.


# Pure Mage / Skirmisher Mage
Currently, as of Feb 22 2026, I feel that Mage is largely dominated by two or three strategem. The burn strategem based on LBolt, Spitfire and Fireball, where once stack as much damage as possible on the head / chest to hardcrit someone (and fuck over light classes by burning them). Then, there's the spellblade strategem of playing as a skirmisher, stacking Arcyne Bolt - Air Blade and Stygian as a finisher to end the enemy, optionally combined with  LBolt to make your opponent not play the game, Repulse to knock them down, and or Arcyne Mark to quickly stack up the triple stack of Knockdown and Autowin. 

Then there's also self-haste fortitude (Fortitude first) where you attempt to nuke down someone with sheer stats differences with melee before they can do anything and disappear. 

All of which I am not really entirely comfortable with. 

I had idea of making some sort of fun, happy Rock Mages, but the idea of it being combined in a rotation of Arcyne Bolt Air Blade or any other spells to suddenly make Mage outdo actual archer in blunt damage was anathema to me. Without restricting spell choices, this idea is no bueno. 

As of this writing this plan has not been executed yet, but I aim for a new system that would allow for freedom in choosing spells while restraining them from a cancerous combination.

# Spell List / Learning Architecture 

## The Problem
The current spell learning system is a single flat pool, with casters only filtered by tier and whether they are a Zizite. There's no concept of "this class can only learn these spells." Short of utterly fixed spelllist (Grenzmage before getting 3 - 6 points), there's no good solution to this. 

The moment an interesting new spell is added, say, a group of rock projectiles for a hypothetical rock mage, every other mage can take it and slot it into their existing LBolt + Repulse Rotation. The new content don't create a new playstyle but instead, give an existing dominant strategy another tool or slight variation. 

There's no class awareness anywhere in the pipeline. 

## Design Rationale 
The goal is not to remove player choice but to make the choices meaningful. A Spellblade picking 4 points betwene Mending or Mindlink is making a real choice. A Sorcerer picking between LBolt + Repulse or Message or Mending is not making a choice, it is shooting yourself in the foot or shooting the enemy in their head. 

## The Solution
The fix is simple - instead of a universal spell pool, there's a bunch of sub list akin to magical schools. As I intend, there'd be a shared, whimsy focused (Or you could say, utilities) spells that all mages, no matter what will always have access to. Then, the offensive package that they gain access to is pre-determined on spawn or based on a combination of choice. 

For now, it is used only for Spellblade whose offensive package is entirely pre-determined, but in the future I will conceptualize a system that would balance freedom to mix spells in combat with utilities.

For example, I believe that Forcewall and the Buff Spells can belong on a free-er to pick list for pure mage whereas spell like Repulse, Stygian and Lightning Bolt are so degenerate that they must not be freely picked in a future skirmisher mage.

The architecture itself is simple enough to build incrementally—add sub-lists as needed, tag classes with which lists they can access, and the door stays open for future systems (spell schools, patron-specific packages, hybrid builds) without requiring a rewrite.
