/proc/get_spellblade_chant_html(datum/caller, mob/living/carbon/human/H, faction = "conventional")
	var/blade_chant = get_blade_chant_text(faction, H)
	var/phalanx_chant = get_phalanx_chant_text(faction, H)
	var/macebearer_chant = get_macebearer_chant_text(faction, H)
	var/preamble_closing = get_preamble_closing(faction)

	var/title = "The Chant"
	var/blade_btn = "Chant the Blade Verse"
	var/phalanx_btn = "Chant the Phalangite Verse"
	var/mace_btn = "Chant the Macebearer Verse"
	if(faction == "undead")
		title = "MEMORIES"
		blade_btn = "WAKE UP"
		phalanx_btn = "WAKE UP"
		mace_btn = "WAKE UP"

	var/blade_weapons
	var/phalanx_weapons
	var/mace_weapons
	switch(faction)
		if("blackoak")
			blade_weapons = "Elvish Longsword / Elvish Saber / Elvish Curveblade / Steel Dagger"
			phalanx_weapons = "Elvish Glaive"
			mace_weapons = "Steel Mace / Steel Warhammer & Shield"
		if("zizite")
			blade_weapons = "Avantyne Longsword / Kriegmesser / Longsword / Rapier / Sabre / Steel Dagger & Shield"
			phalanx_weapons = "Halberd / Bardiche / Boar Spear / Dory & Shield / Naginata"
			mace_weapons = "Steel Mace / Steel Warhammer & Shield"
		if("undead")
			blade_weapons = "Khopesh / Sabre / Dagger & Shield"
			phalanx_weapons = "Spear / Bardiche & Shield"
			mace_weapons = "Mace / Warhammer & Shield"
		else
			blade_weapons = "Longsword / Rapier / Sabre / Arming Sword / Shortsword / Hwando / Steel Dagger & Shield"
			phalanx_weapons = "Spear / Dory & Shield / Naginata"
			mace_weapons = "Mace / Warhammer & Shield"

	var/html = {"<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
body {
	background-color: #1a1410;
	color: #d4c4a0;
	font-family: Georgia, 'Times New Roman', serif;
	margin: 0;
	padding: 20px;
}
.chant-container {
	max-width: 960px;
	margin: 0 auto;
	text-align: center;
}
h2 {
	color: #c9a96e;
	font-size: 20px;
	letter-spacing: 3px;
	text-transform: uppercase;
	border-bottom: 1px solid #8b7355;
	padding-bottom: 10px;
	margin-bottom: 25px;
}
.columns {
	display: flex;
	gap: 20px;
	margin-bottom: 20px;
}
.column {
	flex: 1;
	display: flex;
	flex-direction: column;
	background: linear-gradient(135deg, #2a2015 0%, #1a1410 50%, #2a2015 100%);
	border: 2px solid #8b7355;
	border-radius: 4px;
	padding: 20px;
	box-shadow: 0 0 15px rgba(139, 115, 85, 0.2);
}
.column-content {
	flex: 1;
}
.column h3 {
	color: #a08050;
	font-size: 15px;
	letter-spacing: 2px;
	margin: 0 0 15px 0;
}
.chant-text p {
	font-size: 12px;
	line-height: 1.7;
	margin: 3px 0;
}
.chant-text em {
	color: #e0d0b0;
}
.abilities {
	text-align: left;
	border-top: 1px solid #5a4a30;
	padding-top: 12px;
	margin-top: 15px;
}
.abilities h4 {
	color: #a08050;
	font-size: 11px;
	letter-spacing: 1px;
	margin: 0 0 8px 0;
	text-transform: uppercase;
	text-align: center;
}
.abilities ul {
	list-style: none;
	padding: 0;
	margin: 0;
}
.abilities li {
	font-size: 11px;
	line-height: 1.5;
	margin: 5px 0;
	color: #b0a080;
}
.abilities li b {
	color: #d4c4a0;
}
.weapon-info {
	text-align: center;
	font-size: 12px;
	color: #c9a96e;
	margin-top: 12px;
	padding-top: 8px;
	border-top: 1px solid #5a4a30;
	font-style: italic;
}
a.choose-btn {
	display: block;
	margin-top: 15px;
	padding: 10px 15px;
	background: #3a2a15;
	border: 1px solid #8b7355;
	border-radius: 3px;
	color: #c9a96e;
	text-decoration: none;
	font-family: Georgia, serif;
	font-size: 13px;
	letter-spacing: 1px;
	text-align: center;
}
a.choose-btn:hover {
	background: #4a3a20;
	border-color: #c9a96e;
	color: #e0d0b0;
}
.shared-info {
	background: #2a2015;
	border: 1px solid #5a4a30;
	border-radius: 3px;
	padding: 10px 15px;
	text-align: center;
}
.shared-info + .shared-info {
	margin-top: 10px;
}
.shared-list {
	list-style: none;
	padding: 0;
	margin: 5px 0 0 0;
}
.shared-list li {
	font-size: 11px;
	line-height: 1.5;
	margin: 5px 0;
	color: #b0a080;
}
.shared-list li b {
	color: #d4c4a0;
}
.shared-info h4 {
	color: #a08050;
	font-size: 11px;
	letter-spacing: 1px;
	text-transform: uppercase;
	margin: 0 0 5px 0;
}
.shared-info p {
	font-size: 11px;
	color: #b0a080;
	margin: 0;
}
.preamble {
	margin-top: 20px;
	padding: 15px 20px;
	border-top: 1px solid #5a4a30;
	text-align: center;
	font-style: italic;
}
.preamble p {
	font-size: 11px;
	line-height: 1.8;
	margin: 4px 0;
	color: #8b7355;
}
.preamble p.loud {
	color: #c9a96e;
	font-style: normal;
	font-weight: bold;
	letter-spacing: 1px;
}
.preamble p.closing {
	color: #a08050;
	margin-top: 10px;
}
</style>
</head>
<body>
<div class="chant-container">
<h2>[title]</h2>
<p style="font-size: 11px; color: #8b7355; margin-top: -15px; margin-bottom: 15px; font-style: italic;">You have 5 minutes to make your choice.</p>
<div class="columns">
<div class="column">
<div class="column-content">
<h3>— Blade —</h3>
<div class="chant-text">
[blade_chant]
</div>
<div class="abilities">
<h4>Abilities</h4>
<ul>
<li><b>Caedo</b> — Dash through enemies, striking all in your path. Consumes 3 momentum to strike twice!</li>
<li><b>Air Strike</b> — Ranged attack that adapts to your intent. At 3+ momentum, doubles damage.</li>
<li><b>Leyline Anchor</b> — Anchor an arcyne tether to the leyline. Recast to recall. 75 HP, 20s duration, 7 tile range. Cannot recall while restrained. Tether destroyed or expired = full cooldown.</li>
<li><b>Blade Storm</b> — Hurl a shadow projectile. On hit: teleport onto the target and cut the target and everyone around them. 7 Momentum required. At 10, perform extra strikes. Reflected shadows hurt you!</li>
</ul>
</div>
<p class="weapon-info">[blade_weapons]</p>
</div>
<a class="choose-btn" href='?src=\ref[caller];subclass=blade'>[blade_btn]</a>
</div>
<div class="column">
<div class="column-content">
<h3>— Phalangite —</h3>
<div class="chant-text">
[phalanx_chant]
</div>
<div class="abilities">
<h4>Abilities</h4>
<ul>
<li><b>Azurean Phalanx</b> — 3-tile line thrust that pushes enemies back 1 tile. Empowered: doubles damage.</li>
<li><b>Azurean Javelin</b> — Hurl an armor-piercing phantom spear that slows. No slowdown while charging.</li>
<li><b>Advance!</b> — Charge forward and jab 3 times ahead. Must build up 1 pace first. If blocked, keeps jabbing in place. Brief chargeup before moving.</li>
<li><b>Gate of Reckoning</b> — Conjure a portal above a target, raining phantom spears down, then blink to their position and sweep everyone around you.</li>
</ul>
</div>
<p class="weapon-info">[phalanx_weapons]</p>
</div>
<a class="choose-btn" href='?src=\ref[caller];subclass=phalangite'>[phalanx_btn]</a>
</div>
<div class="column">
<div class="column-content">
<h3>— Macebearer —</h3>
<div class="chant-text">
[macebearer_chant]
</div>
<div class="abilities">
<h4>Abilities</h4>
<ul>
<li><b>Shatter</b> — 3-tile line smash that devastates armor integrity and knocks targets back 1 tile. Empowered: doubles damage.</li>
<li><b>Tremor</b> — Slam the ground, damaging and pushing back everyone adjacent 1 tile. Empowered: doubles damage.</li>
<li><b>Charge!</b> — Charge forward 3 paces and bash, knocking targets back 1 tile. Empowered: doubles damage. Brief chargeup before moving.</li>
<li><b>Cataclysm</b> — Conjure and hurl an arcyne hammer at a target area. Crushes a 5x5 area and leaves victims Vulnerable. Bonus damage at max momentum.</li>
</ul>
</div>
<p class="weapon-info">[mace_weapons]</p>
</div>
<a class="choose-btn" href='?src=\ref[caller];subclass=macebearer'>[mace_btn]</a>
</div>
</div>
<div class="shared-info">
<h4>Shared Abilities</h4>
<p>Bind Weapon · Recall Weapon · Empower Weapon · Mending · Enchant Weapon · 4 Utility Spell Points</p>
</div>
<div class="shared-info" style="text-align: left;">
<h4 style="text-align: center;">Shared Mechanics</h4>
<ul class="shared-list">
<li><b>Arcyne Momentum</b> — Build 1 Momentum on melee hits (even if parried or dodged) against a living creature. Melee grants 1 stack every 2 seconds. Spend 3 to unleash empowered versions of your abilities.</li>
<li><b>Decay</b> — Starts decaying 10 seconds after the last strike, losing 1 stack every 6 seconds.</li>
<li><b>Disruption</b> — You lose all Momentum when knocked down or stunned. Off-balance costs 3.</li>
<li><b>Overcharge (7)</b> — Damages your chest and blurs your vision, unlocking your most powerful ability.</li>
<li><b>Maximum (10)</b> — Unleash an empowered version of your ultimate ability.</li>
<li><b>Empower Weapon</b> — Requires 5+ momentum. Burns ALL momentum to empower your next melee attack, bypassing parry and dodge. Visible red glow warns enemies. 30s cooldown. 8s duration.</li>
<li><b>Arcyne Surge</b> — Certain non-ultimate abilities that strike 2 or more targets grant 1 bonus Momentum.</li>
<li><b>Precision</b> — Arcyne strikes use the same zone accuracy system as ranged attacks. Hands and feet are capped at 50%, limbs and head at 75%, face zones at 30%. Perception and Intelligence above 10 each improve your base accuracy.</li>
</ul>
</div>
<div class="preamble">
<p>O! Blade of Tarichea!</p>
<p>There was once a great city. On the foot of this very mountain, over the Azure Sea.</p>
<p>It prospered, and in its midst, our warriors practiced their art, combining the arcyne with blades.</p>
<p>We were master! Our skills, unmatched! Our techniques, unparalleled! Envy of the world!</p>
<p>No Ranesheni bladedancers, or Kazengunese bladesman, or Grenzelhoftian mercenary, could match our prowess!</p>
<p>Mages! Knights! Demons! All fell before our blade.</p>
<p class="loud">THEN — SHE ASCENDED, ALL WAS LOST.</p>
<p class="loud">OR WAS IT?</p>
<p>O! Blade of Azurea!</p>
<p class="closing">[preamble_closing]</p>
</div>
</div>
</body>
</html>
"}
	return html

/proc/get_blade_chant_text(faction, mob/living/carbon/human/H)
	switch(faction)
		if("blackoak")
			return {"<p><em>I am a blade of Tarichea — Azuria, her name reborn!</em></p>
<p><em>The sword is my law! Blood my ink!</em></p>
<p><em>True is my strike! Sharp is my edge!</em></p>
<p><em>With a dozen cuts I shall defend our home.</em></p>
<p><em>Five hundred yils, unbowed!</em></p>
<p><em>By blood and steel, five hundred more!</em></p>"}
		if("zizite")
			return {"<p><em>I am a blade of progress.</em></p>
<p><em>The lady my patron, and knowledge my gift.</em></p>
<p><em>No knowledge forbidden, no truth unpursued.</em></p>
<p><em>With a single cut I shall sever ignorance.</em></p>
<p><em>Stagnation is death - and I refuse to die.</em></p>
<p><em>Her word is progress, and I am her herald.</em></p>"}
		if("undead")
			return {"<p><em>I, Blade of Tarichea. Forever loyal.</em></p>
<p><em>Justice is my sword, and excellence my weapon.</em></p>
<p><em>Tarichea my charge, and Tarichea my home.</em></p>
<p><em>With a hundred blows I shall defend all that is dear.</em></p>
<p><em>This body is—</em></p>
<p><b>WAKE UP. WAKE UP.</b></p>"}
	return {"<p><em>I am a blade of Azuria.</em></p>
<p><em>The sword is my voice, and war my verse.</em></p>
<p><em>True is my strike and sharp is my edge.</em></p>
<p><em>With a hundred cuts I shall cleanse our land of its foes.</em></p>
<p><em>My body a weapon, and mastery my destination.</em></p>
<p><em>By her grace, I am unsheathed.</em></p>"}

/proc/get_phalanx_chant_text(faction, mob/living/carbon/human/H)
	switch(faction)
		if("blackoak")
			return {"<p><em>I am a blade of Tarichea — Azuria, her name reborn!</em></p>
<p><em>The glaive is my law! Blood my ink!</em></p>
<p><em>Swift is my strike! Sharp is my edge!</em></p>
<p><em>With a dozen cuts I shall hew our foe.</em></p>
<p><em>Five hundred yils, unbowed!</em></p>
<p><em>By blood and steel, five hundred more!</em></p>"}
		if("zizite")
			return {"<p><em>I am a shield of progress.</em></p>
<p><em>The lady my patron, and knowledge my gift.</em></p>
<p><em>No knowledge forbidden, no truth unpursued.</em></p>
<p><em>With a single thrust I shall pierce stagnation.</em></p>
<p><em>Stagnation is death - and I refuse to die.</em></p>
<p><em>Her word is progress, and I am her herald.</em></p>"}
		if("undead")
			return {"<p><em>I, Shield of Tarichea. Forever loyal.</em></p>
<p><em>Justice is my spear, and duty my anchor.</em></p>
<p><em>Tarichea my charge, and Tarichea my home.</em></p>
<p><em>With a hundred thrusts I shall defend all that is dear.</em></p>
<p><em>This body is—</em></p>
<p><b>WAKE UP. WAKE UP.</b></p>"}
	return {"<p><em>I am a shield of Azuria.</em></p>
<p><em>The spear is my reach, and duty my anchor.</em></p>
<p><em>True is my strike and long is my reach.</em></p>
<p><em>With a hundred thrusts I shall hold our foe at bay.</em></p>
<p><em>My body a weapon, and mastery my destination.</em></p>
<p><em>By her grace, I stand unbroken.</em></p>"}

/proc/get_macebearer_chant_text(faction, mob/living/carbon/human/H)
	switch(faction)
		if("blackoak")
			return {"<p><em>I am a mace of Tarichea — Azuria, her name reborn!</em></p>
<p><em>The hammer is my law! Blood my ink!</em></p>
<p><em>Never bowed! Never stopped!</em></p>
<p><em>With a dozen blows I shall crush all who threaten our home.</em></p>
<p><em>Five hundred yils, unbowed!</em></p>
<p><em>By blood and steel, five hundred more!</em></p>"}
		if("zizite")
			return {"<p><em>I am a mace of progress.</em></p>
<p><em>The lady my patron, and knowledge my gift.</em></p>
<p><em>No wall unbroken, no barrier unshattered.</em></p>
<p><em>With a single blow I shall crack open stagnation.</em></p>
<p><em>Stagnation is death - and I refuse to die.</em></p>
<p><em>Her word is progress, and I am her hammer.</em></p>"}
		if("undead")
			return {"<p><em>I, Mace of Tarichea. Forever loyal.</em></p>
<p><em>Justice is my hammer, and wrath my fuel.</em></p>
<p><em>Tarichea my charge, and Tarichea my home.</em></p>
<p><em>With a hundred blows I shall crush all that would threaten what is dear.</em></p>
<p><em>This body is—</em></p>
<p><b>WAKE UP. WAKE UP.</b></p>"}
	return {"<p><em>I am a mace of Azuria.</em></p>
<p><em>The hammer is my word, and ruin my punctuation.</em></p>
<p><em>Never bowed! Never stopped!</em></p>
<p><em>With a hundred blows I shall shatter our foes to dust.</em></p>
<p><em>My body a weapon, and conquest my destination.</em></p>
<p><em>By her grace, I conquer!</em></p>"}

/proc/get_preamble_closing(faction)
	switch(faction)
		if("blackoak")
			return "Hone the tradition of your people! Though the snow elves are gone, your heritage is not! As the most excellent, most long-lyved of all races, it is up to you to carry on the legacy of a spellblade! Five hundred yils of martial and arcyne excellence, five hundred yils more!"
		if("zizite")
			return "Hone the knowledge of your patron! With her ascension. The ignorant clings onto the old way, your goddess lays imprisoned. Her teachings are all that remains. Her followers — corrupted, seeking undeath and bones, forgetting that she too, is the mistress of progress. With your very blade, you shall cut open the wound of the world, cauterize it, and let her light shine through! You are her herald."
		if("undead")
			return "Hone the blade of Tarichea! You awaken to... what? There is no archdevil, no Celestial Empire. What do you fight for? Why do you wield the blade? Every move, every cut, every thrust. Engrained into those old bones of yours. Fleshy hand that once wielded weapons, now naught but a pair of bone. Why? Do you fight? Have you been awakened by an ancient evyl, or did you just wake up, lost, dead, yet, somehow, retaining your will? Why do you fight? Why do you fight? Why do you fight?"
	return "Hone the tradition of five centuries! Let not the art die with the fall of the old city! Wield your blade for justice, for profit, or for mastery! There is no wrong path, except to stray into heresy!"
