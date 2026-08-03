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
		<h3>Exposure and Vulnerability</h3>
		<p>The Vulnerable status, represented by a grey shattered shield on top of someone, means they are unable to parry or dodge the next attack and it has a small multiplier to their damage - [VULN_INTEG_MOD]x plus a flat [VULN_INTEG_FLAT] against whatever armor covers the zone.</p>

		<p>The Exposed status, represented by a red shattered shield, means they are unable to parry or dodge the next attack and it will add a devastating multiplier to the damage of the attack - [EXPOSED_INTEG_MOD]x plus a flat [EXPOSED_INTEG_FLAT].</p>

		<p>Both multipliers land on armor integrity. Both also make you easier to hit by +[ACC_OPENED_TARGET_BONUS] accuracy, and both last ten seconds if nobody spends them sooner. Certain sources will make them last less.</p>

		<h3>Stances</h3>
		<p>On the left of your UI is your character's STANCES. Feint is the default STANCES. You can examine and learn more about them by left clicking it, and then shift + right clicking every stance that pops up.</p>

		<p>Most stances have an attached RMB mechanic.</p>
		<ul>
			<li><b>WEAK</b>: -1 Strength to your attack, will never critically hit. Right Click in this stance will attempt to steal from a target. Also used for attempting surgery outside of Combat Mode.</li>
			<li><b>DEFEND</b>: Removes the delay between dodge / parry. RMB when not grabbing anything and holding a weapon allows you to RIPOSTE, which has a chapter of its own.</li>
			<li><b>SWIFT</b>: Makes your attack [round((1 - CLICK_CD_MOD_SWIFT) * 100)]% faster, but also much less accurate at -[ACC_SWIFT_PENALTY]. It also exhausts you and depletes your stamina on attack, by an extra [EXTRA_STAMDRAIN_SWIFSTRONG].</li>
			<li><b>STRONG</b>: Makes your attack stronger and costs them more sharpness and integrity to defend against - [STRONG_SHP_BONUS] more sharpness and [STRONG_INTG_BONUS] more integrity on every parry they make - at the cost of the same extra [EXTRA_STAMDRAIN_SWIFSTRONG] stamina. It also carries +1 Strength that ignores the usual limits, and crits more readily with brutal attacks.</li>
			<li><b>AIMED</b>: Makes your attack [round((CLICK_CD_MOD_AIMED - 1) * 100)]% slower but improves the accuracy of your attacks significantly, by +[ACC_AIMED_BONUS]. RMB allows you to BAIT an opponent.</li>
			<li><b>FEINT</b>: Allows you to feint your opponent, which calculates your intelligence and skills versus theirs, and potentially allows you to open them up for a single vulnerable / exposed attack.</li>
		</ul>

		<h3>Bait</h3>
		<p>Bait is done by RMB on the AIMED stance. If your opponent happens to be aiming the same zone as you are at the same time, you will successfully bait them.</p>

		<p>This will cost them a large slice of their stamina bar - a third of it through heavy armor, a quarter through light or medium, a fifth if they wear none at all - and leave them EXPOSED to your attack. They are also slowed, briefly immobilized, and locked out of attacking for five seconds, and any spell they were channeling is interrupted.</p>

		<p>If you bait someone successfully a second time before they shake it off, then you will render them Off Balance for two seconds, which allows you to kick them down into the ground, often giving you a decisive advantage in a fight. The count resets if you fail a bait, or if you land the second one. Otherwise they must stay out of combat mode for a full thirty seconds to shake it off - flicking Combat Mode off and straight back on will not do it, and each time they drop it the thirty seconds starts over.</p>

		<p>Failing a bait is punished. If their aim does not match yours, or either of you is aiming at the chest, you groan, losing a fifth of your own stamina bar, and reset any progress made on them.</p>

		<p>Aiming for the head and baiting it will also count for any subzones on the head, like ears or eyes. This does not apply to any other limbs. Bait carries a [BAIT_RCLICK_CD / 10] second cooldown.</p>

		<h3>Feint</h3>
		<p>Feinting is done by RMB on the FEINT stance. It compares your weapon skills, intelligence versus your opponent and then if it is high enough, renders them VULNERABLE or EXPOSED to a followup hit. The odds are clamped between 10% and 90%.</p>

		<p>As a result, high intelligence characters have a far easier time feinting and far harder time being FEINTED. Except when someone is riposting, in which case a FEINT is guaranteed - though breaking a guard that way costs you a much longer [(BASE_RCLICK_CD + 10 SECONDS) / 10] second cooldown rather than the usual one.</p>

		<p>It has a cooldown of [FEINT_RCLICK_CD / 10] seconds. Feinting someone who cannot see you does nothing at all and merely wastes five seconds. Someone you have already feinted cannot be feinted again while it lasts.</p>
		</div>
	"}


/datum/book_entry/combat_fighting/special
	name = "04. Special & Middle Click"

/datum/book_entry/combat_fighting/special/inner_book_html(mob/user)
	return {"
		<div>
		<h3>Middle Click Intent</h3>
		<p>BITE, JUMP, KICK and SPECIAL are your middle-click intents, which are intents your character will perform when you middle click.</p>
		<ul>
			<li><b>BITE</b> allows you to bite an opponent if your mouth is exposed. It is generally an extremely niche tactic in battle. More commonly, it is useful for BITING from river or non-stagnant water to drink. It is inadvisable to BITE into Lava or Acid.</li>
			<li><b>JUMP</b> allows you to jump over a one tile gap, or fence. If you toggle RUN, you will LEAP and cross 3 - 4 tiles, but without Acrobatic trait, a LEAP will be unpredictable and can be somewhat deadly.</li>
			<li><b>KICK</b> allows you to kick an opponent, which comes out after a short delay. KICK renders you off-balance which allows them to kick you back if they react fast enough. Kicking someone into a wall or into someone else will knock them down. Kicking someone who is off-balance will knock them down from a standing position. Kick must be aimed at a place you can reach. Expert Pugilists (Unarmed Classes) can kick anywhere on the body.</li>
			<li><b>SPECIAL</b> activates the special attack on your weapon if you are skilled enough (Journeyman or above) in it.</li>
		</ul>

		<h3>Specials</h3>
		<p>Many Melee Weapons have a Special Attack attached to them that can be activated by Special intent. More details can be found by using it.</p>

		<h3>Binds</h3>
		<p>When you parry a weapon blow, the game checks the zone you are aiming at against the zone they swung for. If the two belong to the same group, your weapons bind.</p>

		<p>The groups are coarser than the aiming doll. The whole face counts as one, each arm counts with its hand, each leg with its own foot, and the chest, stomach and groin all count as the torso. The neck is alone. So guarding an arm will catch a swing at that hand, but guarding the left arm will never catch a swing at the right.</p>

		<p>A bind demands a real weapon in both your hands and theirs - unarmed skill weapons cannot bind, you must be at least Journeyman skills with what you are holding. Bind is certain, except for torso vs torso, which binds rarely.</p>

		<p>Winning a bind improves your parrying for ten seconds, you recover a slice of stamina, and while it is in effect takes no integrity damage from parrying at all. Your attacker is staggered for a moment and their next swing is slowed.</p>

		<p>Once a bind ends there is a [BIND_CD / 10] second wait before you can win another.</p>
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
