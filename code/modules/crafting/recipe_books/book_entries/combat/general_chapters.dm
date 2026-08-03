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
		</div>
	"}


/datum/book_entry/combat_common/inventory
	name = "04. Inventory & Equipment"

/datum/book_entry/combat_common/inventory/inner_book_html(mob/user)
	return {"
		<div>
		</div>
	"}


/datum/book_entry/combat_common/resources
	name = "05. Stamina & Energy"

/datum/book_entry/combat_common/resources/inner_book_html(mob/user)
	return {"
		<div>
		</div>
	"}


/datum/book_entry/combat_common/defense
	name = "06. Parry, Dodge & Defense"

/datum/book_entry/combat_common/defense/inner_book_html(mob/user)
	return {"
		<div>
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
