/datum/book_entry/combat_common
	abstract_type = /datum/book_entry/combat_common
	category = "Common"

/datum/book_entry/combat_common/basics
	name = "01. Basic Controls & Combat Mode"

/datum/book_entry/combat_common/basics/inner_book_html(mob/user)
	return {"
		<div>
		<h3>Basic Controls</h3>
		<ul>
			<li><b>Left Click</b> to interact with most objects.</li>
			<li><b>Shift Click</b> to examine an object or person. Clicking a (?) or opening a "Mechanics" link tends to give more explanation.</li>
			<li><b>Right Clicking</b> someone with an object in hand OFFERS it to them. Doing it while sneaking will offer it stealthily. Combat Mode (see below) ensures you do not offer it by accident and use your stance's right click (More in the stances and special section).</li>
			<li><b>Holding Right Click</b> lets you turn around in place to where you are looking at, unless it is done to an object that has a specific right click override.</li>
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

		<p>You can toggle SNEAK mode by clicking on the SNEAK button. By default, it is not bound. Your ability to sneak depends on your "Sneaking" skills. Higher sneaking skills make you move faster while sneaking. Sneaking has the advantage of rendering you semi transparent and hard to detect when you are in the dark, but is broken by being near a light source. It also allows you to avoid maneaters or triggering ambushes in the wild.</p>

		<p>Right clicking on the EYE allows you to look around for hidden objects. By default, this stops your movement, though the Sleuth virtue can allow you to track and move at the same time.</p>
		</div>
	"}


/datum/book_entry/combat_common/survival
	name = "02. Survival & Upkeep"

/datum/book_entry/combat_common/survival/inner_book_html(mob/user)
	return {"
		<div>
		<h3>Bleeding and the Sewing Needle</h3>
		<p>Bleeding is one of the primary causes of death whether you are adventuring or PVPing.</p>

		<p>You can craft a sewing needle by clicking "Craft" on the top left, while you have 1 fiber and 1 thorn. Fiber can be found by cutting grass with a sharp weapon or searching a bush (left click), whereas thorn can also be found in the same way.</p>

		<p>To sew a bleeding wound, aim for the bleeding zone on yourself or another and then left click. Higher Medicine skill drastically improves effectiveness. No Medicine Skill makes it very slow.</p>

		<h3>Hunger and Thirst</h3>
		<p>Keep yourself topped up on nutrition. You can search bushes for jackberries that can make for basic food for non-nobles. Take only one bite at a time, and if you taste they are bitter, refrain from biting any further and remember that color is poisonous for the week. Sometimes, the poisonous and normal jackberries can have the same color. You can also buy and barter for food from other roles in town. Spending energy and just existing both use up your Energy, which draws from your nutrition. You can eat up ahead of time a little to keep yourself topped up.</p>

		<p>Your character also becomes thirsty with time. You can get water by using a bucket from a well and then drinking from it by clicking on yourself. You can also BITE a CLEAN, FLOWING river tile (not stagnant water!) to drink from it. Certain fruit - notably Jackberries, also provide a small amount of water.</p>

		<h3>Sleeping and Dream Points</h3>
		<p>You can sleep by closing your eyes and then laying down on the ground.</p>

		<p>The speed at which you fall asleep depends on the quality of your bed. It also affects the quality of your sleep which determines how fast you heal and recover energy. A bedroll purchased at the tailor or merchant can be useful for sleeping on the move.</p>

		<p>You cannot sleep if you have medium or heavy (usually metallic) armor on your head or chest. Take them off.</p>

		<p>Sleeping every night gives you Dream Points, which can be used to purchase and level up skills in round that will reset at the end of a round. What skills are rolled and available to level up during sleep depends on RNG - with most crafting skills being able to be randomly leveled up to Journeyman this way. Some (mostly crafting) skills are gated entirely beyond virtue and can only be leveled up to Journeyman and none beyond this way.</p>

		<p>Training certain skills in round beyond Apprentice will "bank" those XP up to 2 levels above, requiring you to spend dream points to unlock it. High intelligence increases your dream points - each point of INT is worth [DREAM_DUST_PER_INT] dream dust on top of the [BASE_DREAM_DUST] you get for sleeping at all, and every [BASE_DREAM_DUST] dust is one Dream Point.</p>

		<p>Dream Points that are not used are banked for the next night, and so is any leftover dust that did not round up into a whole point. Sleeping is not necessary mechanically for most people except for healing or skilling up.</p>
		</div>
	"}


/datum/book_entry/combat_common/stats
	name = "03. Stats"

/datum/book_entry/combat_common/stats/inner_book_html(mob/user)
	return {"
		<div>
		<p>Your character has different stats, based on your role, your race, and your chosen Statpack, if any.</p>

		<p>Most of these have a softcap at [STRENGTH_SOFTCAP] or [RANGED_STAT_SOFTCAP] beyond which its effect scales less aggressively.</p>

		<ul>
			<li><b>STR</b>: Improves the damage you deal on your weapon, and the effectiveness of your penetrative attacks on strength scaling weapon. Softcaps at [STRENGTH_SOFTCAP] - every point up to it is worth [round(STRENGTH_MULT * 100)]% damage, every point past it only [round(STRENGTH_CAPPEDMULT * 100)]%.</li>
			<li><b>PER</b>: Improves the damage you deal with scaling ranged weapon like Bow or Slings, improves your ROF with these weapons. And increases your chance of hitting a precise bodypart significantly. Softcaps at [RANGED_STAT_SOFTCAP], at [round(RANGED_STAT_MULT * 100)]% per point up to it and [round(RANGED_STAT_CAPPEDMULT * 100)]% past it.</li>
			<li><b>INT</b>: Improves the chance of your FEINTING or not being FEINTED. Also useful for Mages in particular for reducing the cooldown and stamina cost of their spells - [round(COOLDOWN_REDUCTION_PER_INT * 100)]% off each per point above [SPELL_SCALING_THRESHOLD], no longer improving past [SPELL_POSITIVE_SCALING_THRESHOLD]. Below [SPELL_SCALING_THRESHOLD], it scales iinto the negative.</li>
			<li><b>CON</b>: Increases the effective HP of your limbs and makes them harder to disable or score a critical wound on.</li>
			<li><b>WIL</b>: Increases your Energy and Stamina pool, and also increases your pain tolerance. Stamina starts at [WILLPOWER_STARTING_STAMINA] and moves [WILLPOWER_MODIFIER] for every point above or below 10.</li>
			<li><b>SPD</b>: Increases your Movement speed, and also makes SWIFT balance weapon more effective.</li>
			<li><b>FOR</b>: Increases your chance of scoring critical wounds once armor is breached and the limb is sufficiently damaged. Positive effects are small, but it has a devastating effect when in the negative and causes you to miss a large proportion of your attack.</li>
		</ul>
		</div>
	"}


/datum/book_entry/combat_common/inventory
	name = "04. Inventory & Equipment"

/datum/book_entry/combat_common/inventory/inner_book_html(mob/user)
	return {"
		<div>
		<p>On the left occupying the bottom half of your screen is your character's equipment slots. These are generally used to equip armor or gear. Hovering over the empty part of the armor UI tells you its name - even if there's armor on top. Starting from top to bottom:</p>

		<ul>
			<li><b>Mask</b>: Used to cover your mouth and often used to put on additional armor for your face.</li>
			<li><b>Helmet</b>: Used to put on a helmet. Most helmets have an Aesthetic Storage accessible by right click that allows you to put on masks and hats with no armor value to customize your look.</li>
			<li><b>Mouth</b>: Used for cigarettes or putting a Rosa in your mouth, to charm the dashing denizens of Azurea.</li>
			<li><b>Back Right and Back Left</b>: On the row below. These are used to hold satchels (Can be accessed with left click while moving), backpacks (Which need to be taken off before being accessible but hold much more), certain weapons, shields, quivers, bows, and greatweapon strap, which can store large polearms at the cost of needing a lot of time to take it on and off.</li>
			<li><b>Cloak</b>: Used for an aesthetic cloak that can also store a small amount of small items. Commonly used for tabard, jupons etc. to signify your allegiance. Cloaks with customization options like the tabard can be customized with right click with a heraldry of your choice.</li>
			<li><b>Neck</b>: Used for neck armor like Bevor, Gorget etc, can also be used to hang on a pouch.</li>
			<li><b>Armor</b>: The outer layer of your chest armor slot. Usually where one part of your most important armor is. Certain items like Gambeson or Hauberk can be layered in either slot - but the same type of item cannot appear twice in both the Shirt and the Armor slot. When you are short on mammons and gears, the armor and shirt slot is often the most cost effective place to layer on armor first.</li>
			<li><b>Wrists</b>: Used for bracers, which exclusively protect your arms. It is also vital for unarmed classes to parry. Can also be used to carry a sling.</li>
			<li><b>Ring</b>: Used for carrying certain type of valuable rings, communication rings often used by retinue or burghers like scomstone / houndstone. Certain type of loot only rings can also be worn here to improve your character's stats.</li>
			<li><b>Shirt</b>: The inner armor slot, certain type of underarmor such as gambeson, hauberk, haubergeon can be worn underneath here.</li>
			<li><b>Gloves</b>: Used for gloves, which exclusively protect your hands. As a rule of thumb, there generally isn't more than one layer of armor on this slot.</li>
			<li><b>Trou (Trousers / Pants)</b>: Used for armor which covers the legs and generally also groin.</li>
			<li><b>Belt</b>: The belt slot is used for a belt that can hold a small amount of items. Having a belt on is also essential to access your two hip slots - they are unusable otherwise.</li>
			<li><b>Hip Slots</b>: Split into left and right. These are used to hold swords, weapons, quivers, and tools. Swords need to be holstered in a scabbard to be drawn instantly, otherwise drawing them will take more time. As the saying goes, a sword without a scabbard is a troublesome gift.</li>
			<li><b>Boots</b>: Used for boots that protect exclusively your feet. Follow the same rules - there generally isn't more than one layer of armor on this slot.</li>
		</ul>
		</div>
	"}


/datum/book_entry/combat_common/resources
	name = "05. Stamina & Energy"

/datum/book_entry/combat_common/resources/inner_book_html(mob/user)
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


/datum/book_entry/combat_common/defense
	name = "06. Parry, Dodge & Defense"

/datum/book_entry/combat_common/defense/inner_book_html(mob/user)
	return {"
		<div>
		<h3>Parry / Dodge</h3>
		<p>Above the "Combat" button is the Parry / Dodge button. Parry and Dodge are the primary way you extend your durability in melee combat. When an enemy attacks you with their weapon in melee, you will attempt to Parry or Dodge them.</p>

		<p>Parrying or Dodging has a minimum cooldown of [CLICK_CD_MELEE / 10] second between each attempt, exactly equal to the normal attack speed of most weapons. DEFEND Stance removes the delay, at the cost of potentially exhausting yourself and depleting your weapon's durability and or your stamina faster.</p>

		<p>To parry, you must have a weapon held in your hand. Your parry percentage is calculated by a comparison of your weapon's defense, and your opponents skills and yours. In general, a rule of thumb is that your parry chance does not go above 90%, and that it is equal to your Weapon Defense +/- 20% per level of difference in you and your opponents weapon defense.</p>

		<p>Parrying a weapon costs you durability and sharpness, if applicable. A blunt weapon / shield costs you [INTEG_PARRY_DECAY_NOSHARP] flat integrity, whereas parrying with a sharp weapon costs you [INTEG_PARRY_DECAY] integrity and [SHARPNESS_ONHIT_DECAY] sharpness. A weapon held in your off-hand always pays the blunt rate of [INTEG_PARRY_DECAY_NOSHARP], sharp or not. This forces you to sharpen up and repair your weapon or switch it mid combat. Parrying also costs a moderate amount of stamina: [BASE_PARRY_STAMINA_DRAIN].</p>

		<p>Parrying generally works better with weapons that are good at parrying and the user is skilled in, or with a shield.</p>

		<p>Characters skilled in unarmed combat parry with their bracers instead if they have one and do not have a competing weapon in their hand with more than 0 WDefense. Knuckles and bandages serve the same purpose. The default parry chance is disastrously low at 20%, but it raises to 80% (Equal to a DEFENSE value of 8) if they are an Expert Pugilist. Your unarmed skill adds on top of both.</p>

		<p>Dodge costs more stamina, and compares your speed versus theirs. If you are a dodge expert, your dodge chance caps out at [90 + MAX_DODGE_CEIL]%. It lowers with each dodge, down as far as [90 + MAX_DODGE_FLOOR]%. Scoring hits will allow it to increase over time.</p>

		<p>Dodging works much better with classes that are built for it with Dodge Expert trait, and when there's a large difference of speed between you and your opponent. It also works well if you are wielding weapons that have very very poor defenses.</p>

		<h3>Vision Cones and Parrying</h3>
		<p>By default, your character has a vision cone that extends to 270 degrees. This determines what you can see and at what angle you can parry from. Melee Attacks outside of your vision range cannot be parried against. Dodge does not care about this.</p>

		<p>Wearing certain helmets or masks will restrict your vision to the frontal 180 degrees arc. A few rare ones will restrict it to 90 degrees. This will decrease your combat awareness and make it easier for opponents who get around you to bypass your parry.</p>

		<h3>Defense Readiness</h3>
		<p>On top of your stamina / energy bar is a light. If the light is gone, you cannot dodge or parry. If it is red, it means you are in combat and cannot perform certain stealthy actions for [IN_COMBAT_DELAY / 10] seconds. You will also be unable to benefit from energy regeneration from a campfire / fireplace briefly.</p>
		</div>
	"}


/datum/book_entry/combat_common/aiming
	name = "07. Where to Aim"

/datum/book_entry/combat_common/aiming/inner_book_html(mob/user)
	return {"
		<div>
		</div>
	"}


/datum/book_entry/combat_common/wounds
	name = "08. Health, Wounds & Pain"

/datum/book_entry/combat_common/wounds/inner_book_html(mob/user)
	return {"
		<div>
		</div>
	"}


/datum/book_entry/combat_common/armor
	name = "09. Armor"

/datum/book_entry/combat_common/armor/inner_book_html(mob/user)
	return {"
		<div>
		</div>
	"}
