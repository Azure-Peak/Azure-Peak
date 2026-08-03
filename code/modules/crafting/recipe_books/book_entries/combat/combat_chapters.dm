/datum/book_entry/combat_fighting
	abstract_type = /datum/book_entry/combat_fighting
	category = "Combat"

/datum/book_entry/combat_fighting/weapons
	name = "01. Weapons & Intents"

/datum/book_entry/combat_fighting/weapons/inner_book_html(mob/user)
	return {"
		<div>
		<h3>Reading a Weapon's Statistics</h3>
		<p>All melee weapons can be examined by Shift-Click, and then clicking on (?), this shows a number of useful information:</p>
		<ul>
			<li><b>MIN.STR</b>: Minimum Strength needed to wield the weapon effectively. Halved on most weapons when wielded. To be changed later.</li>
			<li><b>FORCE / WIELDED FORCE</b>: What is the damage in number the weapon does one handed and wielded. Strength moves it by [round(STRENGTH_MULT * 100)]% per point away from 10, dropping to [round(STRENGTH_CAPPEDMULT * 100)]% per point once you are at [STRENGTH_SOFTCAP] or above.</li>
			<li><b>BALANCE</b>: A SWIFT balanced weapon has an easier time targeting harder to hit zones and reduce parry chance based on speed differences - capped at [SWIFTCAP_PRECISE]% against precise zones, [SWIFTCAP_LIMBS]% against large limbs, and only [SWIFTCAP_CHEST]% against the chest. A HEAVY balanced weapon is easier to dodge and inflict stamina damage on other parry-ers, at [abs(STAM_DRAIN_PER_STR_DIFF_HEAVY_BAL)] per level of strength difference.</li>
			<li><b>LENGTH</b>: The length of the weapon, which determines what body parts it can strike. SHORT weapons aim better, at +[ACC_SHORT_WEAPON_BONUS], whereas LONG weapons can reach the feet. GREAT weapons can reach anywhere even if you are on the ground.</li>
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
			<li><b>Armor Penetration</b>: Measured in Armor Type and "Pips". Equal penetration to the defending armor means partial armor, whereas more penetration means much more of the damage carries through. Each pip of advantage is worth [round(PEN_PASSTHROUGH_RATIO * 100)]% of the damage, up to [PEN_PASSTHROUGH_CAP] pips, and your Strength adds pips of its own.</li>
			<li><b>Drain While Charged</b>: Additional stamina drain when this is charged.</li>
			<li><b>Drain on Release / Miss</b>: Stamina drained when you miss / release the attack.</li>
			<li><b>Attack Speed</b>: The delay before you can click again after making an attack. Sluggish is [CLICK_CD_CHARGED / 10] second. Normal is [CLICK_CD_MELEE / 10] second, Quick is [CLICK_CD_QUICK / 10] and Very Quick is [CLICK_CD_FAST / 10]. Certain more powerful attacks have higher delay, like polearm stab.</li>
			<li><b>Attack Delay</b>: How long it takes for the attack to land on the opponent after you click. Your opponent must be in range of your weapon after the delay. This is often used for more powerful attacks.</li>
			<li><b>Delay Type</b>: Normal Attack Delay has no effect. DIFFICULT attack delay, also known as YELLOW intent, will reduce your parry / dodge chance drastically. RIGID can be canceled by you being attacked and leave you completely open to being attacked. RIGID Intent usually has powerful effects but is hard to pull off.</li>
			<li><b>Integrity Modifier</b>: How much integrity and shield damage is multiplied by when attacking armor. Does nothing to flesh damage.</li>
			<li><b>Demolition Modifier</b>: How much damage is multiplied by when attacking a structure like door or shield. In case both Integrity and Demolition modifier are present, the higher one prevails in the calculation instead of stacking.</li>
			<li><b>Cleave</b>: Certain attacks hit more than one tile and will explain its pattern and how many it can hit.</li>
		</ul>
		</div>
	"}


/datum/book_entry/combat_fighting/families
	name = "02. Weapon Families & Shields"

/datum/book_entry/combat_fighting/families/inner_book_html(mob/user)
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


/datum/book_entry/combat_fighting/stances
	name = "03. Stances, Exposure & Vulnerability"

/datum/book_entry/combat_fighting/stances/inner_book_html(mob/user)
	return {"
		<div>
		</div>
	"}


/datum/book_entry/combat_fighting/special
	name = "04. Special & Middle Click"

/datum/book_entry/combat_fighting/special/inner_book_html(mob/user)
	return {"
		<div>
		</div>
	"}


/datum/book_entry/combat_fighting/riposte
	name = "05. Riposte"

/datum/book_entry/combat_fighting/riposte/inner_book_html(mob/user)
	return {"
		<div>
		</div>
	"}


/datum/book_entry/combat_fighting/ranged
	name = "06. Ranged Weapons"

/datum/book_entry/combat_fighting/ranged/inner_book_html(mob/user)
	return {"
		<div>
		</div>
	"}


/datum/book_entry/combat_fighting/archetypes
	name = "07. Character Archetypes"

/datum/book_entry/combat_fighting/archetypes/inner_book_html(mob/user)
	return {"
		<div>
		</div>
	"}
