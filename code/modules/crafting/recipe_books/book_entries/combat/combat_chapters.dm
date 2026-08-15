/datum/book_entry/combat
	abstract_type = /datum/book_entry/combat
	category = null

/datum/book_entry/combat/basics
	name = "01. Basic Controls & Combat Mode"

/datum/book_entry/combat/basics/inner_book_html(mob/user)
	return {"
		<div>
		<h3>Basic Controls</h3>
		<ul>
			<li><b>Left Click</b> to interact with most objects.</li>
			<li><b>Shift Click</b> to examine an object or person. Clicking a (?) or opening a "Mechanics" link tends to give more explanation.</li>
			<li><b>Right Clicking</b> someone with an object in hand OFFERS it to them. Doing it while sneaking will offer it stealthily. Combat Mode (see below) ensures you do not offer it by accident and use your stance's right click (More in the stances and special section).</li>
			<li><b>Holding Right Click</b> lets you turn around in place to where you are looking at, unless it is done to an object that has a specific right click override.</li>
			<li><b>Click Dragging</b> someone from their sprite onto your own opens their equipment, letting you strip items off them or put items onto them. Dragging your own sprite onto yourself opens the same menu for your own equipment.</li>
			<li>Pressing <b>F</b> turns you into "Locked Eyes" mode, locking your character to face the direction you are facing instead of turning fluidly to face where you are moving. Moving in a direction you are not facing slows you down. This can be tactically toggled on and off by advanced players to ensure they are facing their enemy.</li>
			<li><b>Z</b> drops an item, and can be used to release a Grab too.</li>
			<li><b>Q</b> and <b>E</b> swap between your left and right hand.</li>
		</ul>

		<h3>Combat Mode</h3>
		<p>Turning on Combat Mode signifies your intent to fight. If it is off, you will not be able to parry or dodge effectively. Parry / Dodge is your main source of passive defenses and adds a lot to your actual durability in combat.</p>

		<p>Turn it on by pressing <b>C</b>, or clicking Combat on the left side of your HUD. When combat mode is on, your combat music will play and the icon will change. You will lose a small amount of Energy (the blue bar, your long term energy) while combat mode is on, so only toggle it on when you need it. The green bar is known as Stamina, and will be expanded on later.</p>

		<h3>The Eye, Standing and Laying Down</h3>
		<p>On the left of your HUD, you will see an open eye looking around. Clicking Up and Down allows you to close your eyes. If you do that while laying down, you will start to sleep.</p>

		<p>On the far left, you will see a big arrow pointing up and down. That is your command for STANDING UP / LAYING DOWN respectively. Laying down / Standing Up can be toggled by <b>V</b> by default.</p>

		<h3>Resist</h3>
		<p>You can RESIST by pressing <b>X</b> as the shortcut. Resist is useful when you are grappled or most importantly - grabbed by a maneater in the wilds. Knowing it makes the difference between breaking a piece of armor or being torn piece to piece.</p>

		<p>Resist can also be used to pat out flames on you. Patting while laying down will make you roll, stunning you but putting it down rapidly.</p>

		<h3>Surrender / Yielding</h3>
		<p>By default, mechanical Surrender / Yielding is bound to <b>Shift + X</b>, though many players opt to unbind the key to avoid accidental yield in combat.</p>

		<p>Mechanical surrender / yielding puts a surrender flag animation over your character and forces you to lay down. It gives you resistance against critical wounds and greatly slows down your bleeding. It also renders you unable to do any actions.</p>

		<p>This can be useful for signalling to players during / after fight that you are mechanically surrendering and to spare you. Based on their own IC reasonings, they can choose to capture, kill, heal, or ignore you. All of the options are fine and in general, considered within the rules.</p>

		<p>It is completely useless against NPCs who will slaughter you on the spot if you are in active combat.</p>

		<h3>Run / Sneak</h3>
		<p>You can toggle Run by pressing the "Run" button. It is by default bound to the unset "SPRINT" Keybind in your settings. Sprinting increases your speed of movement at the cost of rapidly depleting your stamina.</p>

		<p>Sprinting also allows you to CHARGE someone. Charging compares your STR + CON vs the enemy's STR + CON, and whether you or the opponent have a shield. Charging point blank results in the charger dropping down, whereas charging at a longer distance gives a slight advantage. Turning too quickly during a charge leads to it automatically failing. A successful Charge will knock down your opponent, giving you a great advantage, but a failed one will in turn greatly imperil you. It is a risky move that should be used carefully and only when you are familiar with the combat system.</p>

		<p>Running into solid objects like a tree will knock you down and running into boulders can trip you.</p>

		<p>You can toggle SNEAK mode by clicking on the SNEAK button. By default, it is not bound. Your ability to sneak depends on your "Sneaking" skills. Higher sneaking skills make you move faster while sneaking. Sneaking renders you completely invisible when you are in the dark. In a lit area it does nothing for you while you are standing, though laying down while sneaking will make you partly transparent. It is broken by being near a light source. It also allows you to avoid maneaters or triggering ambushes in the wild.</p>

		<p>Right clicking on the EYE allows you to look around for hidden objects. By default, this stops your movement, though the Sleuth virtue can allow you to track and move at the same time.</p>
		</div>
	"}


/datum/book_entry/combat/survival
	name = "02. Survival & Upkeep"

/datum/book_entry/combat/survival/inner_book_html(mob/user)
	return {"
		<div>
		<h3>Bleeding and the Sewing Needle</h3>
		<p>Bleeding is one of the primary causes of death whether you are adventuring or PVPing.</p>

		<p>You can craft a sewing needle by clicking "Craft" on the top left, while you have 1 fiber and 1 thorn. Fiber can be found by cutting grass with a sharp weapon or searching a bush (left click), whereas thorn can also be found in the same way.</p>

		<p>To sew a bleeding wound, aim for the bleeding zone on yourself or another and then left click. Higher Medicine skill drastically improves effectiveness. No Medicine Skill makes it very slow.</p>

		<h3>Hunger and Thirst</h3>
		<p>Keep yourself topped up on nutrition. You can search bushes for jacksberries that can make for basic food for non-nobles. Take only one bite at a time, and if you taste they are bitter, refrain from biting any further and remember that color is poisonous for the week. Sometimes, the poisonous and normal jacksberries can have the same color. You can also buy and barter for food from other roles in town. Spending energy and just existing both use up your Energy, which draws from your nutrition. You can eat up ahead of time a little to keep yourself topped up.</p>

		<p>Your character also becomes thirsty with time. You can get water by using a bucket from a well and then drinking from it by clicking on yourself. You can also BITE a CLEAN, FLOWING river tile (not stagnant water!) to drink from it. You technically can drink sewage and swamp water the same way, but it will poison you and kill you without the traits for it. Certain fruit - notably jacksberries, also provide a small amount of water.</p>

		<h3>Sleeping and Dream Points</h3>
		<p>You can sleep by closing your eyes and then laying down on the ground.</p>

		<p>The speed at which you fall asleep depends on the quality of your bed. It also affects the quality of your sleep which determines how fast you heal and recover energy. A bedroll purchased at the tailor or merchant can be useful for sleeping on the move.</p>

		<p>You cannot sleep if you have medium or heavy (usually metallic) armor on your head or chest. Take them off.</p>

		<p>Sleeping every night gives you Dream Points, which can be used to purchase and level up skills in round that will reset at the end of a round. What skills are rolled and available to level up during sleep depends on RNG - with most crafting skills being able to be randomly leveled up to Journeyman this way. Some (mostly crafting) skills are gated entirely beyond virtue and can only be leveled up to Journeyman and none beyond this way.</p>

		<p>Training certain skills in round beyond Apprentice will "bank" those XP up to 2 levels above, requiring you to spend dream points to unlock it. A night's rest gives dream points. Being intelligent, and being in a good mood yields more dream points.</p>

		<p>Dream Points that are not used are banked for the next night, and so is any leftover dust that did not round up into a whole point. Sleeping is not necessary mechanically for most people except for healing or skilling up.</p>
		</div>
	"}


/datum/book_entry/combat/stats
	name = "03. Stats"

/datum/book_entry/combat/stats/inner_book_html(mob/user)
	return {"
		<div>
		<p>Your character has different stats, based on your role, your race, and your chosen Statpack, if any.</p>

		<p>STR and PER have a softcap, at [STRENGTH_SOFTCAP] and [RANGED_STAT_SOFTCAP] respectively, beyond which their effect scales less aggressively. The rest have no softcap and scale flat all the way up.</p>

		<ul>
			<li><b>STR</b>: Improves the damage you deal on your weapon, and the effectiveness of your penetrative attacks on strength scaling weapon. Softcaps at [STRENGTH_SOFTCAP] - every point up to it is worth [round(STRENGTH_MULT * 100)]% damage, every point past it only [round(STRENGTH_CAPPEDMULT * 100)]%.</li>
			<li><b>PER</b>: Improves the damage you deal with scaling ranged weapon like Bow or Slings, improves your ROF with these weapons. And increases your chance of hitting a precise bodypart significantly. Like STR, it pays well up to its softcap at [RANGED_STAT_SOFTCAP] and much less after.</li>
			<li><b>INT</b>: Improves the chance of your FEINTING or not being FEINTED. Also useful for Mages in particular for reducing the cooldown and stamina cost of their spells - [round(COOLDOWN_REDUCTION_PER_INT * 100)]% off each per point above [SPELL_SCALING_THRESHOLD], no longer improving past [SPELL_POSITIVE_SCALING_THRESHOLD]. Below [SPELL_SCALING_THRESHOLD], it scales into the negative.</li>
			<li><b>CON</b>: Increases the effective HP of your limbs and makes them harder to disable or score a critical wound on.</li>
			<li><b>WIL</b>: Increases your Energy and Stamina pool, and also increases your pain tolerance. Every point above or below average widens or narrows those pools appreciably.</li>
			<li><b>SPD</b>: Increases your Movement speed, and also makes SWIFT balance weapon more effective.</li>
			<li><b>FOR</b>: Increases your chance of scoring critical wounds once the limb is sufficiently damaged. Positive effects are small, but it has a devastating effect when in the negative and causes you to miss a large proportion of your attack.</li>
		</ul>
		</div>
	"}


/datum/book_entry/combat/inventory
	name = "04. Inventory & Equipment"

/datum/book_entry/combat/inventory/inner_book_html(mob/user)
	return {"
		<div>
		<p>On the left occupying the bottom half of your screen is your character's equipment slots. These are generally used to equip armor or gear. Hovering over the empty part of the armor UI tells you its name - even if there's armor on top. Starting from top to bottom:</p>

		<ul>
			<li><b>Mask</b>: Used to cover your mouth and often used to put on additional armor for your face.</li>
			<li><b>Helmet</b>: Used to put on a helmet. Most helmets have an Aesthetic Storage accessible by right click that allows you to put on masks and hats with no armor value to customize your look.</li>
			<li><b>Mouth</b>: Used for cigarettes or putting a Rosa in your mouth, to charm the dashing denizens of Azurea. You can also hold a knife or a coin in there.</li>
			<li><b>Back Right and Back Left</b>: On the row below. These are used to hold satchels (Can be accessed with left click while moving), backpacks (Which need to be taken off before being accessible but hold much more), certain weapons, shields, quivers, bows, and greatweapon strap, which can store large polearms at the cost of needing a lot of time to take it on and off.</li>
			<li><b>Cloak</b>: Used for an aesthetic cloak that can also store a small amount of small items. Commonly used for tabard, jupons etc. to signify your allegiance. Cloaks with customization options like the tabard can be customized with right click with a heraldry of your choice.</li>
			<li><b>Neck</b>: Used for neck armor like Bevor, Gorget etc, can also be used to hang on a pouch.</li>
			<li><b>Armor</b>: The outer layer of your chest armor slot. Usually where one part of your most important armor is. Certain items like Gambeson or Hauberk can be layered in either slot - but the same type of item cannot appear twice in both the Shirt and the Armor slot. When you are short on mammons and gears, the armor and shirt slot is often the most cost effective place to layer on armor first.</li>
			<li><b>Wrists</b>: Used for bracers, which exclusively protect your arms. It is also vital for unarmed classes to parry. Can also be used to carry a sling, an amulet, or a knife sheath.</li>
			<li><b>Ring</b>: Used for carrying certain type of valuable rings, communication rings often used by retinue or burghers like scomstone / houndstone. Certain type of loot only rings can also be worn here to improve your character's stats.</li>
			<li><b>Shirt</b>: The inner armor slot, certain type of underarmor such as gambeson, hauberk, haubergeon can be worn underneath here.</li>
			<li><b>Gloves</b>: Used for gloves, which exclusively protect your hands. As a rule of thumb, there generally isn't more than one layer of armor on this slot.</li>
			<li><b>Belt</b>: The belt slot is used for a belt that can hold a small amount of items. Having a belt on is also essential to access your two hip slots - they are unusable otherwise.</li>
			<li><b>Hip Slots</b>: Split into left and right. These are used to hold swords, weapons, quivers, and tools. Swords need to be holstered in a scabbard to be drawn instantly, otherwise drawing them will take more time. As the saying goes, a sword without a scabbard is a troublesome gift.</li>
			<li><b>Trou (Trousers / Pants)</b>: Used for armor which covers the legs and generally also groin.</li>
			<li><b>Boots</b>: Used for boots that protect exclusively your feet. Follow the same rules - there generally isn't more than one layer of armor on this slot.</li>
		</ul>
		</div>
	"}


/datum/book_entry/combat/resources
	name = "05. Stamina & Energy"

/datum/book_entry/combat/resources/inner_book_html(mob/user)
	return {"
		<div>
		<p>On your HUD is a blue and green bar. The blue bar indicates how much Energy you have, whereas the green bar indicates how much Stamina you have.</p>

		<p>Shift Clicking them shows the actual number, but is not recommended in combat.</p>

		<p>Parrying, Dodging and Attacking will spend your stamina. Certain actions such as spells or miracles will also deplete your stamina, and occasionally some attacks will also attack them directly. When you use stamina, it stops your regeneration briefly, requiring you to disengage and not use any actions like attacking or defending that deplete your stamina to regenerate. Sometimes, as an advanced tactic, certain players will turn off their combat mode in order to avoid parrying / dodging to regenerate their stamina in an emergency. This is a risky tactic but viable.</p>

		<p>If your Stamina is completely depleted, you become exhausted, and are stunned briefly. You are rendered immobilized and vulnerable to being kicked down and assaulted by your enemies. Try to prevent it from going to 0 at all costs.</p>

		<p>Spending your Stamina pulls from your Energy pool at a 1 to 1 ratio. As your Energy pool is depleted, your speed at which you regenerate stamina is proportionally lowered - a full Energy bar recovers stamina five times as fast as an empty one. This eventually requires you to disengage, sleep / rest next to a campfire to regenerate, or consume a mana potion in order to restore your combat endurance.</p>

		<p>Having no Energy at all means you cannot run.</p>
		</div>
	"}


/datum/book_entry/combat/defense
	name = "06. Parry, Dodge & Defense"

/datum/book_entry/combat/defense/inner_book_html(mob/user)
	return {"
		<div>
		<h3>Parry / Dodge</h3>
		<p>Above the "Combat" button is the Parry / Dodge button. Parry and Dodge are the primary way you extend your durability in melee combat. When an enemy attacks you with their weapon in melee, you will attempt to Parry or Dodge them.</p>

		<p>Parrying has a minimum cooldown of [CLICK_CD_MELEE / 10] second between each attempt, exactly equal to the normal attack speed of most weapons. DEFEND Stance removes that delay, at the cost of potentially exhausting yourself and depleting your weapon's durability and or your stamina faster. Dodge has no cooldown of its own - it only picks one up from being baited, feinted, or caught outside your vision cone, and DEFEND does not clear it.</p>

		<p>To parry, you must have a weapon held in your hand. Your parry percentage is calculated by a comparison of your weapon's defense, and your opponents skills and yours. In general, a rule of thumb is that your parry chance does not go above 90%, and that it is equal to your Weapon Defense at [PARRY_PER_WDEF_POINT]% a point, +/- [PARRY_PER_SKILL_LEVEL]% per level of difference in skill between you and your opponent.</p>

		<p>Parrying a weapon costs you durability and sharpness, if applicable. A blunt weapon / shield costs you [INTEG_PARRY_DECAY_NOSHARP] flat integrity, whereas parrying with a sharp weapon costs you [INTEG_PARRY_DECAY] integrity and [SHARPNESS_ONHIT_DECAY] sharpness. A weapon held in your off-hand always pays the blunt rate of [INTEG_PARRY_DECAY_NOSHARP], sharp or not. This forces you to sharpen up and repair your weapon or switch it mid combat. Parrying also costs a moderate amount of stamina.</p>

		<p>Parrying generally works better with weapons that are good at parrying and the user is skilled in, or with a shield.</p>

		<p>Characters skilled in unarmed combat parry with their bracers instead if they have one and do not have a competing weapon in their hand with more than 0 WDefense. Knuckles and bandages serve the same purpose. Bare Fists make for extremely poor defense, unless they are an Expert Pugilist with a bracers, in which case they can parry as well as a decent weapon. Bare Your unarmed skill adds on top of both.</p>

		<p>Dodge costs more stamina, and compares your speed versus theirs. A dodge expert begins a fight very hard to touch, but every dodge you make wears that down, and a long exchange will drag it well below where it started. Landing hits of your own builds it back up over time, a little past its opening value at best.</p>

		<p>Taking a wound also refunds some dodge, though never quite back to full. Being Exposed or Vulnerable when it lands won't give you anything.</p>

		<p>If your opponent is faster than you, every point of SPD they have on you costs you extra stamina - unless the weapon in your own hands is HEAVY balanced, which exempts you from it entirely. Being outskilled costs you on top of that, and an opponent in SWIFT stance drains you hardest while your dodge is freshest, tapering to nothing once you have built up some dodge cooldown. So a fast, skilled attacker in SWIFT can wear a dodger down even while missing.</p>

		<p>If either opponents is unarmed, neither of these penalties apply.</p>

		<p>Dodging works much better with classes that are built for it with Dodge Expert trait, and when there's a large difference of speed between you and your opponent. It also works well if you are wielding weapons that have very very poor defenses.</p>

		<h3>Vision Cones and Parrying</h3>
		<p>By default, your character has a vision cone that extends to 270 degrees. This determines what you can see and at what angle you can parry from. Melee Attacks outside of your vision range cannot be parried against. Dodge does not care about this.</p>

		<p>Wearing certain helmets or masks will restrict your vision to the frontal 180 degrees arc. A few rare ones will restrict it to 90 degrees. This will decrease your combat awareness and make it easier for opponents who get around you to bypass your parry.</p>

		<h3>Defense Readiness</h3>
		<p>On top of your stamina / energy bar is a light. If the light is gone, you cannot dodge or parry. If it is red, it means you are in combat and cannot perform certain stealthy actions for [IN_COMBAT_DELAY / 10] seconds. You will also be unable to benefit from energy regeneration from a campfire / fireplace briefly.</p>
		</div>
	"}


/datum/book_entry/combat/aiming
	name = "07. Where to Aim"

/datum/book_entry/combat/aiming/inner_book_html(mob/user)
	return {"
		<div>
		<h3>The Aiming Doll and the Zones</h3>
		<p>On the top left is a Gargoyle known as the aiming doll. The place highlighted by blue is the place your character is currently aiming at. It also determines what you visibly look at while looking at another character with Shift-Click.</p>

		<p>Going in order from top to bottom:</p>
		<ul>
			<li><b>Head</b>: This is a zone that is covered generally by a helmet and is often an effective zone to be aiming at, though it runs you the risk of being baited - which will be explained in <i>Stances, Exposure & Vulnerability</i>. A head wound and fracture tends to be very effective in putting down and stunning an opponent, and is commonly known as a "Skullcrack" in community language. A skullcrack is split into two stages - the first stage knocks them out briefly, and a second hit shatters the skull and paralyzes them. The Head zone shares HP with its precise zone.</li>
			<li><b>Eyes, Nose, Ears and Mouth</b>: These are special subzones of the head. The Nose and Eyes are useful to aim for in opponents whose faces are uncovered - making visor / mask a good idea.</li>
			<li><b>Chest</b>: Attacking the chest makes you immune to being baited, and is a safe default option even if not stunningly effective.</li>
			<li><b>Groin / Stomach</b>: These, especially the groin, are the most niche zones. The stomach is occasionally aimed for what is known as a "gutspill" wound with cutting weapons, which spills out the opponent's guts and makes it excessively hard to recover from in combat. It is an aiming zone of the last resort generally reserved for NPCs you do not care about, or players that you really need to put down.</li>
			<li><b>Arms</b>: A disabled arm / hand tends to disable your opponents from using their weapons. Using a cutting / chopping weapon with sufficient force can also cut it off. Aiming for the hand is effectively the same as aiming for the arm, and contributes to the same pool, at risk of making your intent a bit more obvious and requiring more perception to back it up.</li>
			<li><b>Legs</b>: A disabled leg / feet will slow down your opponent or knock them down, potentially setting them up to be slain at your leisure. Like arms, it can be cut off. Aiming for the feet is effectively the same as aiming for the legs, at risk of making your intent a bit more obvious and requiring more perception to back it up.</li>
		</ul>

		<h3>Accuracy</h3>
		<p>Attacks aimed at the chest always hit the chest. Attacks aimed elsewhere must roll for accuracy. A Stab has the most accuracy, a Cut is slightly less reliable, and Blunt attacks do not benefit at all. Skill increases accuracy at +[ACC_SKILL_BONUS_PER_LEVEL] per level, and Perception above 10 matters as much as skills until it goes past [RANGED_STAT_SOFTCAP]. Perception below 10 will lower your hit rate significantly.</p>

		<p>The zone matters as much as the blow. Aiming for a whole limb, like a head or leg or arm, will always be easier to hit the subzone. Picking out parts of someone's face is the hardest target of all.</p>

		<p>No matter how good or bad your aim is, its effects are clamped</p>

		<p>A target you have Exposed, made Vulnerable, or held in an aggressive grab is far easier to strike precisely. Someone off their feet is easier to aim at, too. SHORT weapons also aim better, at +[ACC_SHORT_WEAPON_BONUS].</p>
		</div>
	"}


/datum/book_entry/combat/wounds
	name = "08. Health, Wounds & Pain"

/datum/book_entry/combat/wounds/inner_book_html(mob/user)
	return {"
		<div>
		<h3>Health and Critical Wounds</h3>
		<p>Once armor is broken, weapons and attacks will start attacking your limbs directly. This can cause bleeding, pain, and decrease the effective HP of your limbs.</p>

		<p>Certain armor piercing weapons can cause critical wounds if the limb behind it is sufficiently damaged.</p>

		<p>Once a limb has taken enough punishment, critical wounds will start rolling on it, which can be highly crippling and end the fight. Most body parts have unique critical wounds dependent on the damage types that attacked you and the part itself.</p>

		<p>The body is split into organs / limbs that share HP with each other, each having numerous subzones:</p>
		<ul>
			<li><b>Head</b>: Head, Eyes, Nose, Ears, Mouth.</li>
			<li><b>Torso</b>: Chest, Stomach, Groin.</li>
			<li><b>L / R Arms</b>: Arm + Hand (Each arm is an independent pool of its own).</li>
			<li><b>L / R Legs</b>: Leg + Feet (Each leg is an independent pool of its own).</li>
		</ul>

		<p>The torso the toughest body part to aim at, and remaining limbs and heads are of the same toughness. Their health scales with your Constitution, and high Constitution characters will survive markably longer after their armor is broken.</p>

		<h3>Bleeding</h3>
		<p>Most creatures and players bleed and can die from bleeding out and then the oxygen loss that results, though you should not refer to it as oxygen loss in an in character manner. As you lose blood, your stats are impaired until you are finally knocked out and must be helped by someone else to have a chance of survival.</p>

		<p>To deal with bleeding, you can use a needle to sew up the wound, bandage prepared by cloth to bandage the wound and slow it down, health potion (Known commonly as Red, and Lyfeblood IC) to heal the wounds. Clean Water can replenish your blood rapidly and allow you to survive otherwise fatal bleeding and is generally used for stabilization.</p>

		<p>Grabbing the spot that is bleeding with a free hand will reduce the rate you bleed quickly, and upgrading that into an aggressive grab reduces it further. Grabbing it with your other hand as well cuts it down more again - the two hands multiply together.</p>

		<h3>Pain</h3>
		<p>Being hit with certain wounds causes your character to be in pain, represented by your screen flashing red at various intensity.</p>

		<p>If your character is sufficiently pained, you will slow down, or at worst, scream in pain and then become knocked down and vulnerable.</p>

		<p>Higher Willpower alongside certain traits and classes lowers your chances of being knocked down or slowed by pain. Some classes and certain undeads are outright immune to its effect.</p>
		</div>
	"}


/datum/book_entry/combat/armor
	name = "09. Armor"

/datum/book_entry/combat/armor/inner_book_html(mob/user)
	return {"
		<div>
		<h3>Reading an Armor's Statistics</h3>
		<p>You can view your Armor's statistics by shift clicking it and clicking on the (?). It will show its:</p>
		<ul>
			<li><b>Effectiveness</b> vs various damage types.</li>
			<li><b>Coverage</b>: What parts it covers, self-explanatory.</li>
			<li><b>Durability</b> (In terms of percentage and absolute value): Its effective HP number vs attacks.</li>
			<li><b>Armor Class</b> (If any): See Below.</li>
			<li><b>Movement Speed Cap</b>: Your SPD (Speed) stat scales up how fast you can move, but medium / heavy armor limits how much it can effectively contribute. Light Armor has no such restrictions.</li>
		</ul>

		<h3>Damage Types, Armor Effectiveness and Penetration</h3>
		<p>Attacks can be classified by damage type and their effectiveness vs armor.</p>

		<p>Nearly all damages can be classified into the following types:</p>

		<h3>Absorb / Reduction Types</h3>
		<p>This category contains two damage types, each with its own unique rules. If the zone has any armor on it at all, none of the damage reaches your HP. The armor's rating decides how much integrity the armor loses instead - the better the rating, the smaller the actual damage that the armor takes. No rating will completely prevent damage.</p>
		<ul>
			<li><b>Blunt</b>: Blunt Attacks tend to cause a lot of pain when they get through armor, and cause fractures that can disable the limbs. It is often aimed for on the head or chest for maximum effectiveness. As a rule of thumb, Blunt Attacks NEVER penetrate armor. They come with a devastating integrity modifier by default that makes them exceptionally effective vs metal armor. Blunt Attack is a damage reduction type of damage, and light armor in particular are very good at reducing the effective damage of blunt attack. Blunt attacks, uniquely, will also carry through a significant portion of their damage to underlaying armor layers (but not flesh) when attacking.</li>
			<li><b>Burn</b>: Burn attacks tend to be exclusively used by magical spells and certain divine miracles. Its damage too, is effectively reduced by the armor's rating. It does not penetrate just like Blunt. However, it does not carry through its damage to underlaying layers like Blunt - it lands on a single layer instead. Worn metal armor absorbs fire even when it shows no fire rating at all. Burn wounds tend to cause decent amount of pain and bleeding and can be sewn shut.</li>
		</ul>

		<h3>Blocking Types</h3>
		<p>Blocking types of damage do not suffer from damage reduction versus any kind of armor, and instead its damage is applied 1 to 1 to the armor itself. Its secondary property is Penetration, which determines if the attack goes through the armor and attacks the limbs behind it directly. Penetration below the armor's blocking tier is stopped dead. Penetration that meets or beats it get some damage through. The greater the armor is outmatched and the stronger your Strength / Speed are, the more go through. So long as armor exists, the full damage will never go through.</p>
		<ul>
			<li><b>Slashing</b>: Slashing attacks tend to cause a lot of bleeding and cause artery critical wounds, which makes an opponent bleed out rapidly. They often come with weapons that can strike swiftly like swords, or hard like axe. Slashing attacks tend to not have the abilities to penetrate armor, but have a lot of raw damage.</li>
			<li><b>Stabbing</b>: Stabbing attacks tend to be less deadly than attacks caused by slashing, but can cause bone fractures that disable the limbs. They often come with weapons that can stab through light or heavy armor like Daggers, Stabbing Swords and Polearms. Stabbing attacks tend to be effective versus light armor by causing punctures and bleed through it, in exchange for lower effectiveness versus cutting attacks.</li>
			<li><b>Piercing</b>: Piercing is a variant of stabbing with its own armor value, used by arrows and certain spells. It causes puncture wounds that are like Stabbing, but live in a different armor track. Light Armor tends to be great against Piercing attacks.</li>
		</ul>

		<h3>Armor Class</h3>
		<p>Armor is classified into four types of Armor Class. Armor Class currently only applies to Head, Armor, Shirt and Trousers (Pants) slot armor.</p>

		<p>Wearing Armor you are not trained for will make you get knocked down when dodging and greatly reduce your parry chance. It also means you cannot run, and your jump is cut down to a tile next to you at a heavy stamina cost, making it nearly useless.</p>
		<ul>
			<li><b>NONE</b>: No armor is present.</li>
			<li><b>LIGHT</b>: Light Armor. Everyone can wear them, it does not impair your mobility nor your abilities to dodge.</li>
			<li><b>MEDIUM</b>: Medium Armor. It requires Medium Armor Training - also known as Maille Training IC. And generally protects better against penetrative wounds. It slows down your speed to [AC_MEDIUM_SPDCAP] SPD at max. Higher-end metal helmets can sometimes require Medium Armor Training.</li>
			<li><b>HEAVY</b>: Heavy Armor. It requires Heavy Armor Training, also known as Plate Training IC. It generally has higher integrity than their medium counterpart and otherwise shares the same type of protection, being both metallic armor, but restricts your speed bonus to no more than [AC_HEAVY_SPDCAP] SPD. Plate Armor in specific tends to take a much longer time to take off and put on.</li>
		</ul>

		<h3>Repairing Armor</h3>
		<p>Armor becomes damaged in time through combat and must be repaired to keep up protection. Broken armor still have some integrity left. If struck sufficiently while on the ground multiple time, it will be destroyed permanently. This is difficult to do.</p>

		<p>To repair armor, you generally need to take them off, and put them on a table.</p>

		<p>Light Armor is repaired by Sewing / Leatherworking, and is done by left clicking a needle on top of it. Light Armor requires less skills - and it is generally easier to learn in round in game to repair. Failing light armor repair will damage it and reset your progress until you acquire sufficient skills.</p>

		<p>Metallic (Medium / Heavy) Armor (And Weapons) are repaired by Armorsmithing / Weaponsmithing, and repaired by a hammer. A basic stone hammer can be made from a small log (Gained from cutting down a tree and then chopping a large piece of log) and a stone (Found everywhere on the ground) in your crafting menu.</p>

		<p>Non-crafting roles are generally limited to APPRENTICE level in the crafting skills used to repair armor. Skilled workers, or those with the appropriate Virtues can repair much quicker.</p>

		<p>Skilless repair, especially metallic one, is extremely ineffective and slow, taking a long time to repair effectively.</p>

		<h3>Sewing Kits, Scrap Kits and Armor Plates</h3>
		<p>Sewing Kit, Scrap Kit / Armor Plates allow you to repair textile / metallic armor / weapons without having the skills effectively.</p>

		<p>Sewing Kit can be used while standing, whereas Scrap Kit / Armor Plates must be used while the object of target is on a table. It allows you to repair effectively without the skills, while gaining proficiency in said skills. Eventually, you can gain enough to repair without the aid of a kit.</p>

		<p>Repairing gears this way will deplete the durability of the kit. Once used up, they disappear and you must buy or craft a new one.</p>
		</div>
	"}
/datum/book_entry/combat/weapons
	name = "10. Weapons & Intents"

/datum/book_entry/combat/weapons/inner_book_html(mob/user)
	return {"
		<div>
		<h3>Reading a Weapon's Statistics</h3>
		<p>All melee weapons can be examined by Shift-Click, and then clicking on (?), this shows a number of useful information:</p>
		<ul>
			<li><b>MIN.STR</b>: Minimum Strength needed to wield the weapon effectively. Halved on every weapon when wielded. To be changed later.</li>
			<li><b>FORCE / WIELDED FORCE</b>: How hard the weapon strikes one handed and wielded, shown as a word, with the underlying figure available by clicking the (?) beside it. Strength moves it by [round(STRENGTH_MULT * 100)]% per point away from 10, dropping to [round(STRENGTH_CAPPEDMULT * 100)]% per point once you are at [STRENGTH_SOFTCAP] or above.</li>
			<li><b>BALANCE</b>: A SWIFT balanced weapon has an easier time targeting harder to hit zones and reduce parry chance based on speed differences - capped at [SWIFTCAP_PRECISE]% against precise zones, [SWIFTCAP_LIMBS]% against large limbs, and only [SWIFTCAP_CHEST]% against the chest. A HEAVY balanced weapon is easier to dodge and inflict stamina damage on other parry-ers, at [abs(STAM_DRAIN_PER_STR_DIFF_HEAVY_BAL)] per level of strength difference.</li>
			<li><b>LENGTH</b>: The length of the weapon, which determines what body parts it can strike. SHORT weapons aim better, at +[ACC_SHORT_WEAPON_BONUS]. LONG weapons can reach the chest and down from the ground, whereas GREAT weapons can reach anywhere even if you are on the ground.</li>
			<li><b>TWO-HANDED</b>: Whether it can be two-handed (Click on the weapon to grip it, or press the Q / E while it is in your left / right hand respectively while the other hand is empty).</li>
			<li><b>DEFENSE</b>: The baseline parry abilities of the weapon. Higher is better - each point is worth [PARRY_PER_WDEF_POINT]% parry chance, and the figure shifts by [PARRY_PER_SKILL_LEVEL]% per level of skill difference between you and your attacker. A lot of weapons that are wieldable have more force and defense when wielded.</li>
			<li><b>ALT-GRIP</b>: Certain weapons, like the Longsword, have access to even more intents through ALTERNATIVE GRIP, accessible by several hotkeys.</li>
			<li><b>SHARPNESS</b>: Higher the better. Maintaining high sharpness keeps your bladed weapon effective at dealing damage. Below [SHARPNESS_TIER1_THRESHOLD * 100]% your damage factor and strength contribution start to fall off, by [SHARPNESS_TIER1_FLOOR * 100]% they contribute nothing at all, and under [SHARPNESS_TIER2_THRESHOLD * 100]% even the weapon's base damage begins to decline. It can be sharpened by a stone / whetstone or a grinder. A whetstone is made by a sharpened stick (Using a weapon on a stick) and a stone. A grinder restores it to full sharpness without the small loss in full sharpness when you sharpen it with a rock or whetstone.</li>
			<li><b>SPECIAL</b>: The SPECIAL ability of your weapon, if any, which can be used by the Special Middle Click intent.</li>
		</ul>

		<p>Melee Weapons are used by left clicking with an attack intent, preferably with Combat Mode on, on your enemy. Aiming at the tile will also attack an opponent on it, regardless of their sprite size.</p>

		<h3>Intents, Delays and Penalties</h3>
		<p>Intents are sometimes shared to weapons, but also have unique properties. Weapons, and Items in general have up to 4 Intents. This is selected by 1 to 4 on your keyboard. Shift Clicking the Intent gives you helpful information on what the intent does.</p>

		<p>Intents are used for special actions on some items.</p>

		<p>For combat, intents have the following properties:</p>
		<ul>
			<li><b>Reach</b>: How far away can the attack reach. Default is next to you, but some attacks can reach 2, and even rarer, 3, such as whips.</li>
			<li><b>Effective Range</b>: Certain intents like spear's Stab have an Effective Range, known as a "Sweetspot", if it hits out of it, it loses damage and its penetrative power.</li>
			<li><b>Damage</b>: The damage multiplier, if any. None = 1. Applied on the weapon.</li>
			<li><b>Charge Time</b>: This means there's a charge up to this attack.</li>
			<li><b>Armor Penetration</b>: Measured in Armor Type and "Pips". Equal penetration to the defending armor means partial armor, whereas more penetration means much more of the damage carries through. Every pip you hold over the armor widens that share, up to a limit, and your Strength adds pips of its own.</li>
			<li><b>Drain While Charged</b>: Additional stamina drain when this is charged.</li>
			<li><b>Drain on Release / Miss</b>: Stamina drained when you miss / release the attack.</li>
			<li><b>Attack Speed</b>: The delay before you can click again after making an attack, given from slowest to fastest as Sluggish, Normal, Quick and Very Quick. Certain more powerful attacks have higher delay, like polearm stab.</li>
			<li><b>Attack Delay</b>: How long it takes for the attack to land on the opponent after you click. Your opponent must be in range of your weapon after the delay. This is often used for more powerful attacks.</li>
			<li><b>Delay Type</b>: Normal Attack Delay has no effect. DIFFICULT attack delay, also known as YELLOW intent, will reduce your parry / dodge chance drastically. RIGID can be canceled by you being attacked and leave you completely open to being attacked. RIGID Intent usually has powerful effects but is hard to pull off.</li>
			<li><b>Integrity Modifier</b>: How much integrity and shield damage is multiplied by when attacking armor. Does nothing to flesh damage.</li>
			<li><b>Demolition Modifier</b>: How much damage is multiplied by when attacking a structure like a door. Only the demolition modifier does anything against a structure. Integrity modifier matters on a shield being parried with, where the higher of the two is taken instead of the two stacking.</li>
			<li><b>Cleave</b>: Certain attacks hit more than one tile and will explain its pattern and how many it can hit.</li>
		</ul>
		</div>
	"}


/datum/book_entry/combat/families
	name = "11. Weapon Families & Shields"

/datum/book_entry/combat/families/inner_book_html(mob/user)
	return {"
		<div>
		<h3>Family of Weapons and Characteristics</h3>
		<p>There are several families of melee weapons, each with some characteristics specific to them. These describe the general rules, and every family has its own exception.</p>
		<ul>
			<li><b>Swords</b>: The most abundant and versatile category of weapons. One-handed swords range from the versatile longsword to dedicated, quick cutting or stabbing swords like sabre or rapiers. It also includes two-handed swords like the Greatsword or more niche swords like the Estoc. Most of them are distinguished by quicker attacks and usually a lack of high armor penetration. They are also often quite defensive.</li>
			<li><b>Polearms</b>: Polearms nearly all universally have a reach of 2, but penetrative polearms tend to lose out on penetrative ability outside of certain sweetspot. Polearms tend to be defensive and good at parrying.</li>
			<li><b>Axes</b>: Axes are usually dedicated cutting weapons with devastating damage to shields and trees alike. They are slower than swords but perform better at bashing shields down.</li>
			<li><b>Maces</b>: Maces usually have poor defense but specialize in blunt attacks and dealing massive damage to armor and synergize well with high strength characters.</li>
			<li><b>Flails</b>: Flails share skills with Whips, but are a different category. Flails are one-handed weapons specialized for usage with a shield due to non-existent defense, but are otherwise a one-handed mace.</li>
			<li><b>Whips</b>: Whips are weapons with low damage and non-existent defense, in exchange for having 3 tile reach attack, which is extremely rare.</li>
		</ul>

		<h3>Shields</h3>
		<p>Shields are a special category of weapons deserving its own mention. Shields are intended for one-handed use together with a weapon in your other hand. When wielding two weapons, the weapon with the higher defense takes priority for parrying incoming blows. This preserves your other weapon's durability and integrity.</p>

		<p>They generally have very high defense. Having Shields skill is needed for effective usage.</p>

		<p>Shields have a low passive block chance for incoming projectiles in your frontal arc. They also have a special BLOCK Intent that raises it to 100% once fully charged, rendering you far less vulnerable to ranged attacks. Shield Builds, alongside certain kind of Polearms, are generally a good matchup against ranged attackers or mages. A blocked projectile only costs the shield a quarter of the damage it would have dealt, though a broken shield stops blocking entirely.</p>

		<p>A Buckler uses the skills of your weapon on your other hand for parrying, requiring no high shields skills. In exchange, it has nearly no passive block chance and has very low durability for a shield.</p>
		</div>
	"}


/datum/book_entry/combat/stances
	name = "12. Stances, Exposure & Vulnerability"

/datum/book_entry/combat/stances/inner_book_html(mob/user)
	return {"
		<div>
		<h3>Exposure and Vulnerability</h3>
		<p>The Vulnerable status, represented by a grey shattered shield on top of someone, means they are unable to parry or dodge the next attack, and that attack lands somewhat harder than it otherwise would against whatever armor covers the zone.</p>

		<p>The Exposed status, represented by a red shattered shield, means they are unable to parry or dodge the next attack. Exposure causes attack to land dramatically harder than Vulnerable.</p>

		<p>Both multipliers land on armor integrity. Both also make you considerably easier to hit, and both last ten seconds if nobody spends them sooner. Certain sources will make them last less.</p>

		<h3>Stances</h3>
		<p>On the left of your UI is your character's STANCES. Feint is the default STANCES. You can examine and learn more about them by left clicking it, and then shift + right clicking every stance that pops up.</p>

		<p>Most stances have an attached RMB mechanic.</p>
		<ul>
			<li><b>WEAK</b>: Your attack lands for only [round(WEAK_STANCE_DMG_MULT * 100)]% of its usual damage, and will never critically hit or dismember. Right Click in this stance will attempt to steal from a target. Also used for attempting surgery outside of Combat Mode.</li>
			<li><b>DEFEND</b>: Removes the delay between parries. RMB when not grabbing anything and holding a weapon allows you to RIPOSTE, which has a chapter of its own.</li>
			<li><b>SWIFT</b>: Makes your attack markedly faster, but also much less accurate, and each swing costs you extra stamina on top. In exchange it is the anti-dodge stance: It will drains a dodger's stamina hard, wheile their dodge is fresh, so long as you are not holding a HEAVY balanced weapon.</li>
			<li><b>STRONG</b>: Makes your attack stronger and costs them considerably more sharpness and integrity to defend against on every parry they make, at the cost of the same extra stamina SWIFT demands. Your attack deals +[round(STRONG_STANCE_DMG_BONUS * 100)]% damage, and crits more readily with brutal attacks.</li>
			<li><b>AIMED</b>: Makes your attack slower but improves the accuracy of your attacks significantly. RMB allows you to BAIT an opponent.</li>
			<li><b>FEINT</b>: Allows you to feint your opponent, which calculates your intelligence and skills versus theirs, and potentially allows you to open them up for a single vulnerable / exposed attack.</li>
		</ul>

		<h3>Bait</h3>
		<p>Bait is done by RMB on the AIMED stance. If your opponent happens to be aiming the same zone as you are at the same time, you will successfully bait them.</p>

		<p>This will cost them a large slice of their stamina bar - the heavier the armor they are wearing, the more it takes out of them, and a man in plate suffers worst of all - and leave them EXPOSED to your attack. They are also slowed, briefly immobilized, and locked out of attacking for five seconds, and any spell they were channeling is interrupted.</p>

		<p>If you bait someone successfully a second time before they shake it off, then you will render them Off Balance for two seconds, which allows you to kick them down into the ground, often giving you a decisive advantage in a fight. The count resets if you fail a bait, or if you land the second one. Otherwise they must stay out of combat mode for a full thirty seconds to shake it off - flicking Combat Mode off and straight back on will not do it, and each time they drop it the thirty seconds starts over.</p>

		<p>Failing a bait is punished. If their aim does not match yours, or either of you is aiming at the chest, you groan, lose a good part of your own stamina bar, and reset any progress made on them.</p>

		<p>Aiming for the head and baiting it will also count for any subzones on the head, like ears or eyes. This does not apply to any other limbs. Bait carries a [BAIT_RCLICK_CD / 10] second cooldown.</p>

		<h3>Feint</h3>
		<p>Feinting is done by RMB on the FEINT stance. It compares your weapon skills, intelligence versus your opponent and then if it is high enough, renders them VULNERABLE or EXPOSED to a followup hit. The odds are clamped between 10% and 90%.</p>

		<p>As a result, high intelligence characters have a far easier time feinting and far harder time being FEINTED. Except when someone is riposting, in which case a FEINT is guaranteed - though breaking a guard that way costs you a much longer [(BASE_RCLICK_CD + 10 SECONDS) / 10] second cooldown rather than the usual one.</p>

		<p>It has a cooldown of [FEINT_RCLICK_CD / 10] seconds. Feinting someone who cannot see you does nothing at all and merely wastes five seconds. Someone you have already feinted cannot be feinted again while it lasts.</p>
		</div>
	"}


/datum/book_entry/combat/special
	name = "13. Special & Middle Click"

/datum/book_entry/combat/special/inner_book_html(mob/user)
	return {"
		<div>
		<h3>Middle Click Intent</h3>
		<p>BITE, JUMP, KICK and SPECIAL are your middle-click intents, which are intents your character will perform when you middle click.</p>
		<ul>
			<li><b>BITE</b> allows you to bite an opponent if your mouth is exposed. It is generally an extremely niche tactic in battle. More commonly, it is useful for BITING from river or non-stagnant water to drink. It is inadvisable to BITE into Lava or Acid.</li>
			<li><b>JUMP</b> allows you to jump over a one tile gap, or fence. If you toggle RUN, you will LEAP and cross 3 - 4 tiles, but without Acrobatic trait, a LEAP will be unpredictable and can be somewhat deadly.</li>
			<li><b>KICK</b> allows you to kick an opponent, which comes out after a short delay. KICK renders you off-balance which allows them to kick you back if they react fast enough. Kicking someone into a wall or into someone else will knock them down. Kicking someone who is off-balance will knock them down from a standing position. Kick must be aimed at a place you can reach. Expert Pugilists (Unarmed Classes) can also kick the head.</li>
			<li><b>SPECIAL</b> activates the special attack on your weapon if you are skilled enough (Journeyman or above) in it.</li>
		</ul>

		<h3>Specials</h3>
		<p>Many Melee Weapons have a Special Attack attached to them that can be activated by Special intent. More details can be found by using it.</p>

		<h3>Binds</h3>
		<p>When you parry a weapon blow, the game checks the zone you are aiming at against the zone they swung for. If the two belong to the same group, your weapons bind.</p>

		<p>Your guard zone is grouped, but their swing is not. Guarding an arm or its hand catches a swing at that hand. Guarding a leg or its foot catches a swing at that foot. Guarding the chest, stomach or groin catches a swing at the stomach or groin. Guarding the head or any face zone catches a swing at a face zone. The neck is alone. Guarding the left arm will never catch a swing at the right.</p>

		<p>Note that the attacker has to be aiming at a precise zone for any of this to fire. A swing at the plain chest, arm, leg or head binds nothing, so chest against chest never binds at all.</p>

		<p>A bind demands a real weapon in your hands and theirs - unarmed skill weapons cannot bind, and you must have at least Journeyman skill with what you are holding. Meeting all that, the bind is certain.</p>

		<p>Winning a bind improves your parrying for ten seconds, you recover a slice of stamina, and while it is in effect your weapon takes no integrity damage from parrying at all. Your attacker is staggered for a moment and their next swing is slowed.</p>

		<p>The [BIND_CD / 10] second cooldown starts when the bind starts, not when it ends, so in practice you wait about five seconds after one drops before you can win another.</p>
		</div>
	"}


/datum/book_entry/combat/riposte
	name = "14. Riposte"

/datum/book_entry/combat/riposte/inner_book_html(mob/user)
	return {"
		<div>
		<p>Riposte can also be accessed by the Guard Keybind, default <b>G</b>. This is highly useful when defending against an opponent.</p>

		<p>A Riposte must be done in combat mode. It makes the next melee or magical projectile / spell that hits you deal no damage, and gives you a significant amount of stamina - enough to put you back to at least half a green bar however empty you were.</p>

		<p>If it is done to a melee weapon, it will deplete your opponent's weapon durability (Blunt Weapon) or sharpness (Sharp Weapon). If it is done to an unarmed attack, it does not hurt their hands. It will expose them for a devastating follow-up attack and slow them down. That exposure is short - three seconds - so the follow-up has to be ready before you take the blow, not thought about afterwards.</p>

		<p>Both will give you a temporary boost in willpower and constitution, +1 of each for eighteen seconds, alongside a dulling of pain and a little blood back.</p>

		<p>If it is done to a magical projectile, it will reflect it. If it is done to a magical spell that appears on the ground, it will generally reduce or remove its effects.</p>

		<p>Riposting a spell successfully generally exposes and slows down the caster and renders them vulnerable. If it is a projectile spell, it is often reflected back in their direction, exempting beam like spells, which are simply blocked.</p>

		<p>Riposting a Spell imposes a [BASE_RCLICK_CD * 0.5 / 10] second cooldown, whereas Melee imposes a longer [BASE_RCLICK_CD / 10] second cooldown.</p>

		<p>Riposting lasts for six seconds, and can be broken by using it up or FEINTING you. Feinting someone RIPOSTING is guaranteed, and is one of its primary counters - though it costs the feinter a [(BASE_RCLICK_CD + 10 SECONDS) / 10] second cooldown to do it.</p>

		<p>Attacking while Riposting will cost you a significant amount of stamina and cancel it. Specifically, striking someone who has no guard of their own while yours is up is treated as squandering it, and costs you [BAD_GUARD_FATIGUE_DRAIN]% of your green bar. Jumping, kicking, being kicked, or shooting a ranged weapon  will all break it too. Letting it simply expire costs you nothing but the cooldown.</p>

		<p>Riposte can be canceled ahead of time by swapping your hand, straining you but leaving you with less room for your opponent to expose.</p>

		<p>Two people who strike each other while both have a guard raised will Clash instead, which can disarm one or both of them dramatically.</p>
		</div>
	"}


/datum/book_entry/combat/ranged
	name = "15. Ranged Weapons"

/datum/book_entry/combat/ranged/inner_book_html(mob/user)
	return {"
		<div>
		<p>Ranged Weapons are split into three main families. Both bows and slings lean on Perception, which raises their damage at [round(RANGED_STAT_MULT * 100)]% per point up to [RANGED_STAT_SOFTCAP], and [round(RANGED_STAT_CAPPEDMULT * 100)]% per point beyond it. Perception also cuts their draw time, though that is a flat reduction with no softcap on it.</p>

		<h3>Bow</h3>
		<p>Bows are rapid-firing, exhausting weapons that deal PIERCING damage. Bows are split into:</p>
		<ul>
			<li><b>Crude Selfbow and Recurve Bow</b>, fast and the default bow. They shoot exactly the same.</li>
			<li><b>Longbow</b>, scaling slightly with STR, each arrow dealing a significantly higher amount of damage in exchange for a lower ROF.</li>
		</ul>

		<p>The most common arrows are Broadhead Arrows, which deal a large amount of integrity and normal damage but cannot pierce most armor. Bodkin Arrows pierce through armor and can bleed an opponent out or inflict critical wounds through armor, but have a much lower base damage.</p>

		<p>There are also special arrows available by crafting and using a Runic Flask.</p>

		<p>Bows must be charged after nocking an arrow. You can nock an arrow quickly by left clicking a quiver. Charging for too long and not releasing will deplete your stamina rapidly.</p>

		<h3>Crossbow</h3>
		<p>Crossbows can be kept loaded on your back and then shot rapidly, and aim can be held indefinitely without issue. However, reloading a crossbow immobilizes you. Crossbows do not scale their damage to perception, unlike the other two weapons. Perception does however improve their accuracy and reload speed.</p>

		<p>Crossbow Bolts pierce nearly all armor by default.</p>

		<p>Bolts are carried in quivers. Unlike bows, they cannot be quick-loaded by clicking the quiver, you must manually RMB the quiver to take the bolt out then load it into the crossbow.</p>

		<p>Variants include Slurbows, which are underpowered Crossbows that can be reloaded on the move, and Siegebows, which are devastating bows that are extremely awkward to load and use. Only certain classes start with one, but anyone can craft or buy them.</p>

		<h3>Slings</h3>
		<p>Slings are a fast, cheap alternative to bow. Their projectiles inflict blunt damage, making them great against metallic armor but not so great against light armor.</p>

		<p>Slings are compact, and can be used one handed unlike a bow - they load straight from the pouch even with your offhand full. Their sling bullet pouch carries 40 bullets as opposed to a quiver carrying 20 arrows. Their ammo is generally cheaper to come by, too.</p>
		</div>
	"}


/datum/book_entry/combat/archetypes
	name = "16. Character Archetypes"

/datum/book_entry/combat/archetypes/inner_book_html(mob/user)
	return {"
		<div>
		<p>Most of the above sections cover typical pure melee fighters (using weapons), also known as "Martials" in common parlance. Other archetypes also exist in combat that deviate in various ways.</p>

		<h3>Unarmed</h3>
		<p>To be expanded on later.</p>

		<h3>Ranger</h3>
		<p>Rangers are classes that have access to stats and can effectively use Ranged Weapons. Most Ranger classes are also competent fighters in melee.</p>

		<h3>Spellcasters</h3>
		<p>Spellcasters are the most common types of fighters that deviate from the norm, asides from ranged skirmishers. Spellcasters in this section refers in a broad sense to mechanical spell, not whether the spell is sourced from bardic, divine or arcyne source, which is an IC distinction.</p>

		<p>A Spellcaster generally uses special abilities that are keyed to Alt-1 to Alt-9 hotkeys and can also be selected by left clicking. They are activated by middle-click. Some abilities need to be charged by middle click and then holding and then releasing them.</p>

		<p>Abilities on the hotbar can be rearranged by activating Rearrangement Mode. This is done by Ctrl-Clicking one of the abilities there. This allow you to click and drag to reorganize the abilities, without risks of accidentally activating one of them</p>

		<p>Non-Instant Spellcast in AP will show an indicator above the user's head, usually with the spell to forewarn the receivee of any spellcast. They will often have loud invocations and indications of the cast. Spellcasts usually cost some resources:</p>
		<ul>
			<li><b>Stamina</b> is the most common type of resource.</li>
			<li><b>Energy</b> is used by certain spells that would otherwise drain the entire Stamina Bar.</li>
			<li><b>Devotion</b> is used often on top of Stamina cost, for Miracles, spells of divine origin. Devotion is harder to regain and maintain mid combat than Stamina, usually.</li>
			<li>Other resources may exist or be added to at some point.</li>
		</ul>

		<p>Intelligence improves  arcyne casting. Every point above 10 takes [round(COOLDOWN_REDUCTION_PER_INT * 100)]% off both the cooldown and the stamina cost of a spell, up to [SPELL_POSITIVE_SCALING_THRESHOLD], and every point below 10 adds the same back on. Miracles are the exception - they do not scale with any stat, so a low INT cleric is not punished for it.</p>

		<h3>Mages</h3>
		<p>Mages in AP operate under a Major-Minor-Utilities aspect system. They use their spellbook to pick what kind of Major Aspect they specialize in, which determines their offensive potential and some utilities.</p>

		<p>Minor Aspects augment their defensive potential and give utilities, and extremely rarely, some offensive potential.</p>

		<p>Utilities give out utilities spells.</p>

		<p>Mages are generally slowed down by using their offensive spells and become more vulnerable to their parry / dodge being bypassed while charging up, and their spells can often be countered by a RIPOSTE that opens them up.</p>

		<p>Most mages can only use light armor, and mages in general do not have access to any healing source. Wearing armor you are not trained for costs a caster a [round(UNTRAINED_ARMOR_CD_PENALTY * 100)]% penalty to their cooldowns and stamina cost. A caster who does have the training pays only [round(MEDIUM_ARMOR_CD_PENALTY * 100)]%, and [round(HEAVY_ARMOR_CD_PENALTY * 100)]% for heavy armor, in the rarer case of heavy armor wearing casters.</p>

		<p>In exchange, mages have great offensive potential and utilities that generally do not care about parry or dodging, being treated as ranged attack.</p>

		<p>"Spell List" in the Encyclopedia lets you learn more about them.</p>

		<h3>Bards</h3>
		<p>Bards are a supportive role that can use their songs to support their allies that they choose in their audience.</p>

		<p>Some of them are decent melee fighters, though they seldomly match a full on martial fighter in martial alone.</p>

		<p>They also have Resonance / Resonating Strikes, which allows them to inflict some magic like effects on their opponents.</p>

		<h3>Spellblades</h3>
		<p>Spellblades are martial characters playing pretend to be a mage, or a mage playing pretend to be a martial, depending on your point of view.</p>

		<p>Spellblades are known as Azurcaephan IC, and have a very limited set of restricted moves based on the specialization that they chose at spawn.</p>

		<p>They generally start with less rare stats and worse armor than pure martial fighters, but are great in dueling scenarios. Their gameplay is much closer to a martial with fancy abilities than an archetypical mage fighting at range.</p>

		<h3>Divine Casters</h3>
		<p>Divine Casters are holy casters who have devoted themselves to one of the many gods in our settings.</p>

		<p>They have access to Orison, small utilities spells, and Lesser Miracle, which heals a target including themselves.</p>

		<p>Lesser Miracles are very useful for healing away small amount of wounds or stabilizing someone, but generally cannot reverse death or heal someone completely on its own. In that aspect, Surgery or Alchemical Healing is much better.</p>

		<p>Based on the patrons you chose and the class, you will have access to different TIERS of miracles. Your class decides which tier you begin at and how much devotion you can store. It cannot be raised in round.</p>

		<p>Miracles can be seen by clicking on the MIRACLES part of the Encyclopedia.</p>

		<ul>
			<li><b>T1</b> Miracles are usually not dramatically effective, and are granted to Adventuring Paladins and certain classes.</li>
			<li><b>T2</b> Miracles are usually where the more effective miracles start to show up. They are granted to Church Templars and certain holy roles with town or with an antagonistic nature.</li>
			<li><b>T3</b> Miracles are reserved for the Adventurer Missionary, and are often the most effective part of the caster's toolkit.</li>
			<li><b>T4</b> Miracles are what the Acolyte and most of the church roles get.</li>
		</ul>

		<p>The DIVINE PANTHEON (The TENS) - the primary gods worshipped in this settings, offer a unique toolkit based on the god you selected as your PRIMARY (not your sole, Tennites are not monotheistic) patron.</p>

		<p>The ASCENDANTS - the antagonistic gods that stand in opposition to the TENS, offer their own toolkit, often more powerful than the TENs, but always illegal to use in the open. You will bear all consequences including possible choosing to use it in Town or in front of people whose job is to root out heresies and heathens.</p>

		<p>GENEISISM, also known as PSYDONISM, is belief in the one true ontologically good god that created the setting, and whose status is uncertain and may or may not be dead, and certainly inactive and non-intervening. Their miracles generally rely on sheer willpower, and leave the status of whether Psydon is alive or not in doubt due to the ambiguity of its effects.</p>
		</div>
	"}


/datum/book_entry/combat/revival
	name = "17. Death, Deadite & Revival"

/datum/book_entry/combat/revival/inner_book_html(mob/user)
	return {"
		<div>
		<p>Whether you are PVEing or PVPing, dying is a common occurence and an expected part of the game.</p>

		<p>Sometimes, your friend or helpful strangers will retrieve you for revival at the town or other places, othertime, or even during a revival, you will turn into a deadite - this settings equivalence of zombie (Do not refer to them as zombie IC), largely thought to be brought about by the disaster caused by Zizo's ascension causing the dead to walk again.</p>

		<h3>Deadite</h3>
		<p>After dying and if you are not decapitated, a timer starts as your body rots, and after [DEAD_TO_ZOMBIE_TIME / 600] minutes, your character will rise from the death as a deadite, effectively becoming a zombie you are in control of. This is a mechanic to allow you to return back to town or wherever you can be revived.</p>

		<p>That timer does not tick at all while your body is indoors in town. Certain traits or races also make it impossible.</p>

		<p>As a deadite, you are a mindless beast with a hunger for flesh, though as a deadite, you still must follows the escalation rules that is common to the server before initiating an attack. You can victimize strangers or challenge passing by adventurers - with the goal of putting up a proper fight before being promptly restrained and taken back to be revived.</p>

		<p>In general, it is highly frowned upon if not outright disallowed to simply walk back to a revival place and then just lie down without a fight, putting up an earnest fight - which you do not need to put all your efforts into unless you want to, is a minimum requirement.</p>

		<p>Becoming a deadite makes you unable to feint or use any special actions or weapons, but make you able to regenerate. You also suffer a crippling STAT debuff.</p>

		<p>After you are restrained, a surgeon can then open your chest up to burn the rot from your body, thus removing the deadite status.</p>

		<h3>Revival Methods</h3>
		<p>Three primary revival methods exists in the game. Two of them will leave a revival penalty.</p>
		<ul>
			<li><b>Lux Tranfusion</b>: Lux extracted from someone and then purified can be transplanted into someone and then used to revive them.</li>
			<li><b>FULMENOR Chair</b>: The Fulmenor Chair is exclusively accessed by the Clinic and some wretches, and can revive someone with lux with better efficiency and without any penalty.</li>
			<li><b>Revival Rituals</b>: The Church, with access to certain materials can also revive someone from the death, though they take a normal penalty.</li>
		</ul>

		<p>After non-chair revival, you gain Revival Sickness - [REVIVED_DEBUFF_DURATION / 600] minutes of -1 to every single stat you have. It stacks with the rot debuff if your body had begun to turn, so naturally rotting instead of becoming revived, followed by a ritual revival will hit you with a significant amount of debuff. You are encouraged to take it easy for a while and seek non combat roleplay after.</p>

		<p>For a brief period after revival, being slain again will results in you becoming permanently unrevivable for the round. You get [DEATHMARK_GRACE_PERIOD / 600] minutes of grace first, and only then does the penalty applies for [PERMADEATH_DURATION / 600] minutes.</p>
		</div>
	"}


/datum/book_entry/combat/misc
	name = "18. Misc. Tips"

/datum/book_entry/combat/misc/inner_book_html(mob/user)
	return {"
		<div>
		<p>Other advices</p>

		<ul>
			<li>Middle-Clicking at the groin while it is exposed will remove your underwear.</li>
			<li>Middle-Click dragging yourself onto another player begins mechanical intimacy, provided both of you have consented to it. Your middle-click intent must be unset for the drag to be read as such, and the person you drag onto must have their ERP Panel enabled - it is found under Preferences -> Options as "Toggle ERP Panel", and is off unless you turn it on. Attempting it on someone who has not enabled it simply fails and tells you both so. It is entirely opt-in on their side, so respect the answer the panel gives you.</li>
		</ul>
		</div>
	"}


/datum/book_entry/combat/looting
	name = "19. Looting, Contracts & Scrapping"

/datum/book_entry/combat/looting/inner_book_html(mob/user)
	return {"
		<div>
		<h3>Finding PVE Content</h3>
		<p>Adventurers and Mercenaries looking for PVE content can go to the Grand Contract Ledger and take on contracts. Alternatively, they can go outside to explore the many fixed dungeons that are present outside.</p>

		<h3>Simple and Complex NPCs</h3>
		<p>NPCs / Mobs are split into Complex and Simple Animals. Simple Animals are wolves, direbears etc., and usually represent non-humanoid animals. These can be butchered by middle click with a SHORT blade - like the hunting knife most adventurers start with.</p>

		<h3>Simple Animals, and Aiming</h3>
		<p>Aiming for different parts on a complex NPC will yield different results and allows you to bypass incomplete armor coverage. On simple animals like direbears, wolves or minotaur, aiming for certain body parts can cripple them, slow them down, lower their damage or in some case, cause an instant death. Penetrative stabbing / piercing weapons will also deal more part damage, especially those with HEAVY penetration like spears. Certain parts are impossible to hit standing in melee range, and must have the animals toppled by cutting their legs. Ranged Weapons deals less part damage than melee weapons.
		</p>

		<p>Complex are human-like animals, and includes skeletons and highwaymen. Whenever a complex NPC is killed and not dusted, you can use the STRIPPING Menu (Click drag their sprite onto yourself) to strip them. <b>Loot Everything</b> loots everything in order, <b>Loot Smeltable</b> loots everything that smelts to a metallic result, and <b>Loot Fabric</b> loots everything that scavenges to fabric. These are only available on a dead NPC that has never ever been possessed by a player.</p>

		<h3>Hauling It Home</h3>
		<p>You can make a handcart out of 3 small logs and 1 rope, which is quite handy for carrying your rightfully stolen loot back to town, to sell at the SMITH'S SCRAPPER or the TAILOR'S RAG-PICKER respectively.</p>
		</div>
	"}


/datum/book_entry/combat/hunting
	name = "20. Hunting"

/datum/book_entry/combat/hunting/inner_book_html(mob/user)
	return {"
		<div>
		<h3>Starting a Hunt</h3>
		<p>You can find mounds of disturbed earth. Fresh mounds are dark brown, and you can left click with a free hand to start a hunt. You cannot interact with a mound you are on top of. Higher Hunting skill makes interaction quicker.</p>

		<p>You cannot scout another mound after you have just scouted a new one. Continuing a trail is not affected. </p>

		<h3>Following the Trail</h3>
		<p>Follow the direction of the track to find the next mound. Only you and anyone hunting with you can see it, and it is lighter brown in colour. Examining a revealed track tells you which way the target went.</p>

		<p>Right click your eyeball to get directions to the nearest track you are tracking, provided it is on screen. It will tell you the direction and roughly how far off it is.</p>

		<p>Find enough mounds and you will find an animal at the end. Mounds respawn over time where they were.</p>

		<h3>What You Find</h3>
		<p>Higher Hunting skill yields better animals, and mounds will give more information. Skilled hunters can lean fresh trail toward a kind of prey.</p>

		<h3>Hunting Maps</h3>
		<p>Buy hunting maps to improve your odds at finding certain animals, and click one onto a fresh mound. Some are of more use to a skilled hunter than an unskilled one, and some wear out.</p>

		<p>If you see a white stag, think twice before attacking. Maybe just run, to be safe.</p>

		<h3>Group Hunts</h3>
		<p>A hunt can be run as a party. It forms when the first mound is read, including anyone nearby. The most skilled hunter present leads it.</p>

		<p>Every member can see the trail. Stick together - stray too far from the trail and you are quietly dropped from the hunt, and it stops showing itself to you. Everyone will gain hunting experience and more beasts will show up in a group hunt.</p>
		</div>
	"}
