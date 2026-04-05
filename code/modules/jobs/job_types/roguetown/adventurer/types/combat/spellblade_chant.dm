/proc/get_spellblade_chant_html(datum/caller, mob/living/carbon/human/H, faction = "conventional", extra_blade_weapon, extra_phalanx_weapon, extra_mace_weapon)
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
			blade_weapons = "Kriegmesser / Longsword / Rapier / Sabre / Steel Greatsword / Steel Dagger & Shield"
			phalanx_weapons = "Halberd / Bardiche / Boar Spear / Dory & Shield / Naginata"
			mace_weapons = "Steel Mace / Steel Warhammer & Shield / Grand Mace"
		if("noccite")
			blade_weapons = "Longsword / Rapier / Sabre / Steel Greatsword / Steel Dagger & Shield"
			phalanx_weapons = "Halberd / Bardiche / Boar Spear / Dory & Shield / Naginata"
			mace_weapons = "Steel Mace / Steel Warhammer & Shield / Grand Mace"
		if("almah")
			blade_weapons = "Dual Shamshirs / Shalal Saber & Shield"
			phalanx_weapons = "Spear / Dory & Shield"
			mace_weapons = "Steel Mace / Steel Warhammer & Shield"
		if("undead")
			blade_weapons = "Ancient Khopesh / Sabre / Corroded Dagger & Shield"
			phalanx_weapons = "Ancient Spear / Ancient Bardiche / Dory & Shield"
			mace_weapons = "Ancient Mace / Ancient Warhammer & Shield"
		else
			blade_weapons = "Longsword / Rapier / Sabre / Arming Sword / Shortsword / Hwando  / Steel Dagger & Shield"
			phalanx_weapons = "Spear / Dory & Shield / Naginata"
			mace_weapons = "Mace / Warhammer & Shield"

	// Inject patron-specific weapons into weapon lists
	if(extra_blade_weapon)
		blade_weapons = "[extra_blade_weapon] / [blade_weapons]"
	if(extra_phalanx_weapon)
		phalanx_weapons = "[extra_phalanx_weapon] / [phalanx_weapons]"
	if(extra_mace_weapon)
		mace_weapons = "[extra_mace_weapon] / [mace_weapons]"

	// Color palette per faction
	var/col_bg           // body background
	var/col_text         // main text
	var/col_header       // h2, weapon-info, button text, loud preamble
	var/col_subheader    // h3, h4, closing preamble
	var/col_border       // borders, preamble text
	var/col_divider      // inner dividers
	var/col_gradient     // column/shared-info background
	var/col_em           // chant emphasized text
	var/col_li           // list item text
	var/col_btn_bg       // button background
	var/col_btn_hover    // button hover background
	var/col_glow_r       // box-shadow RGB
	var/col_glow_g
	var/col_glow_b
	switch(faction)
		if("zizite", "undead")
			col_bg = "#140a0a";         col_text = "#d4a0a0"
			col_header = "#c96e6e";     col_subheader = "#a05050"
			col_border = "#8b5555";     col_divider = "#5a3030"
			col_gradient = "#2a1010";   col_em = "#e0b0b0"
			col_li = "#b08080";         col_btn_bg = "#3a1515"
			col_btn_hover = "#4a2020";  col_glow_r = "139"; col_glow_g = "85"; col_glow_b = "85"
		if("noccite")
			col_bg = "#0a0e1a";         col_text = "#a0b8d4"
			col_header = "#6e8ec9";     col_subheader = "#5070a0"
			col_border = "#556b8b";     col_divider = "#304a5a"
			col_gradient = "#101828";   col_em = "#b0c8e0"
			col_li = "#8098b0";         col_btn_bg = "#152030"
			col_btn_hover = "#203040";  col_glow_r = "85"; col_glow_g = "107"; col_glow_b = "139"
		if("blackoak")
			col_bg = "#0a140e";         col_text = "#a0d4b0"
			col_header = "#6ec98e";     col_subheader = "#50a070"
			col_border = "#558b65";     col_divider = "#305a40"
			col_gradient = "#102a18";   col_em = "#b0e0c0"
			col_li = "#80b090";         col_btn_bg = "#153a20"
			col_btn_hover = "#204a30";  col_glow_r = "85"; col_glow_g = "139"; col_glow_b = "101"
		if("almah")
			col_bg = "#1a150a";         col_text = "#d4c090"
			col_header = "#e0b050";     col_subheader = "#c09840"
			col_border = "#a08030";     col_divider = "#6a5520"
			col_gradient = "#2a2010";   col_em = "#f0d080"
			col_li = "#c0a860";         col_btn_bg = "#3a2a10"
			col_btn_hover = "#4a3a18";  col_glow_r = "200"; col_glow_g = "160"; col_glow_b = "60"
		else // conventional — default warm brown/gold
			col_bg = "#1a1410";         col_text = "#d4c4a0"
			col_header = "#c9a96e";     col_subheader = "#a08050"
			col_border = "#8b7355";     col_divider = "#5a4a30"
			col_gradient = "#2a2015";   col_em = "#e0d0b0"
			col_li = "#b0a080";         col_btn_bg = "#3a2a15"
			col_btn_hover = "#4a3a20";  col_glow_r = "139"; col_glow_g = "115"; col_glow_b = "85"

	var/html = {"<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
body {
	background-color: [col_bg];
	color: [col_text];
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
	color: [col_header];
	font-size: 20px;
	letter-spacing: 3px;
	text-transform: uppercase;
	border-bottom: 1px solid [col_border];
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
	background: linear-gradient(135deg, [col_gradient] 0%, [col_bg] 50%, [col_gradient] 100%);
	border: 2px solid [col_border];
	border-radius: 4px;
	padding: 20px;
	box-shadow: 0 0 15px rgba([col_glow_r], [col_glow_g], [col_glow_b], 0.2);
}
.column-content {
	flex: 1;
}
.column h3 {
	color: [col_subheader];
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
	color: [col_em];
}
.abilities {
	text-align: left;
	border-top: 1px solid [col_divider];
	padding-top: 12px;
	margin-top: 15px;
}
.abilities h4 {
	color: [col_subheader];
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
	color: [col_li];
}
.abilities li b {
	color: [col_text];
}
.weapon-info {
	text-align: center;
	font-size: 12px;
	color: [col_header];
	margin-top: 12px;
	padding-top: 8px;
	border-top: 1px solid [col_divider];
	font-style: italic;
}
a.choose-btn {
	display: block;
	margin-top: 15px;
	padding: 10px 15px;
	background: [col_btn_bg];
	border: 1px solid [col_border];
	border-radius: 3px;
	color: [col_header];
	text-decoration: none;
	font-family: Georgia, serif;
	font-size: 13px;
	letter-spacing: 1px;
	text-align: center;
}
a.choose-btn:hover {
	background: [col_btn_hover];
	border-color: [col_header];
	color: [col_em];
}
.shared-info {
	background: [col_gradient];
	border: 1px solid [col_divider];
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
	color: [col_li];
}
.shared-list li b {
	color: [col_text];
}
.shared-info h4 {
	color: [col_subheader];
	font-size: 11px;
	letter-spacing: 1px;
	text-transform: uppercase;
	margin: 0 0 5px 0;
}
.shared-info p {
	font-size: 11px;
	color: [col_li];
	margin: 0;
}
.preamble {
	margin-top: 20px;
	padding: 15px 20px;
	border-top: 1px solid [col_divider];
	text-align: center;
	font-style: italic;
}
.preamble p {
	font-size: 11px;
	line-height: 1.8;
	margin: 4px 0;
	color: [col_border];
}
.preamble p.loud {
	color: [col_header];
	font-style: normal;
	font-weight: bold;
	letter-spacing: 1px;
}
.preamble p.closing {
	color: [col_subheader];
	margin-top: 10px;
}
</style>
</head>
<body>
<div class="chant-container">
<h2>[title]</h2>
<p style="font-size: 11px; color: [col_border]; margin-top: -15px; margin-bottom: 15px; font-style: italic;">You have 5 minutes to make your choice.</p>
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
<li><b>Azurean Phalanx</b> — Prime your next melee strike with arcyne force. On hit, pierces through enemies in a line behind the target. Empowered (3 momentum): deeper, more damaging pierce.</li>
<li><b>Azurean Pilum</b> — Hurl an icy phantom pilum that applies 2 frost stacks on hit. Empowered: applies 3 stacks, guaranteeing a freeze on any frosted target. No slowdown while charging.</li>
<li><b>Advance!</b> — Leap forward up to 4 tiles, passing through enemies, then stab ahead on landing. Brief chargeup before leaping. Empowered: doubles damage.</li>
<li><b>Gate of Reckoning</b> — Summon two phantom spears that flank you in formation. For 12 seconds, each melee hit sends the spears thrusting in a 3-wide line ahead of you. Shield-blockable. Overcharged: 6 charges instead of 3.</li>
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
<li><b>Charge!</b> — Instantly dash forward 4 paces, shoving everyone in the path to the sides. Deals no damage — pure mobility and disruption.</li>
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
<p>Bind Weapon · Recall Weapon · Empower Weapon · Mending · 4 Utility Spell Points</p>
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
<p>We were masters! Our skills, unmatched! Our techniques, unparalleled! Envy of the world!</p>
<p>No Ranesheni bladedancers, or Kazengunese bladesmen, or Grenzelhoftian mercenaries, could match our prowess!</p>
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
		if("noccite")
			return {"<p><em>I, blade of Noc! Forever illuminated.</em></p>
<p><em>Wisdom is my guide, and knowledge my weapon.</em></p>
<p><em>No truth unglimpsed, no mystery untouched.</em></p>
<p><em>With a dozen cuts I shall hew ignorance.</em></p>
<p><em>My blade sharp, and my mind sharper!</em></p>
<p><em>His word is wisdom, and I am his chosen.</em></p>"}
		if("almah")
			return {"<p><em>I am a blade of Raneshen.</em></p>
<p><em>The sword my needle, my foes my tapestry.</em></p>
<p><em>Swift are my moves and sharp is my blade.</em></p>
<p><em>With a hundred cuts I shall unravel my foes.</em></p>
<p><em>Unfazed! Unstopped! Unmatched!</em></p>
<p><em>By sword and sorcery! My will be done!</em></p>"}
		if("undead")
			return {"<p><em>Some speak of Kazengun! And others of Etrusca!</em></p>
<p><em>But there are none that can compare to the blades of Tarichea!</em></p>
<p><em>Indomitable! Indivisible! Invincible!</em></p>
<p><em>With a hundred cuts, all shall be laid low!</em></p>
<p><em>Not even the gods shall stop us!</em></p>
<p><em>In Tarichea's name, we are unshea—</em></p>
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
		if("noccite")
			return {"<p><em>I, spear of Noc! Forever illuminated.</em></p>
<p><em>Wisdom is my guide, and knowledge my weapon.</em></p>
<p><em>No truth unglimpsed, no mystery untouched.</em></p>
<p><em>With a dozen thrusts I shall pierce ignorance.</em></p>
<p><em>My spear fast, and my wits quicker!</em></p>
<p><em>His word is wisdom, and I am his chosen.</em></p>"}
		if("almah")
			return {"<p><em>I am a spear of Raneshen.</em></p>
<p><em>The spear my thread, the battlefield my loom.</em></p>
<p><em>Swift are my moves and sharp is my spear.</em></p>
<p><em>With a hundred thrusts my foes will be laid low.</em></p>
<p><em>Unfazed! Unstopped! Unmatched!</em></p>
<p><em>By spear and sorcery! My will be done!</em></p>"}
		if("undead")
			return {"<p><em>Some speak of Chorodiaki! And others of Vrdaqnan!</em></p>
<p><em>But there are none that can compare to the phalanx of Tarichea!</em></p>
<p><em>Indomitable! Immovable! Impenetrable!</em></p>
<p><em>With a hundred thrusts, all shall be pierced!</em></p>
<p><em>Not even the gods shall stop us!</em></p>
<p><em>In Tarichea's name, we march for—</em></p>
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
		if("noccite")
			return {"<p><em>I, hammer of Noc! Forever illuminated.</em></p>
<p><em>Wisdom is my guide, and knowledge my weapon.</em></p>
<p><em>No truth unglimpsed, no mystery untouched.</em></p>
<p><em>With a dozen blows I shall crush ignorance.</em></p>
<p><em>My hammer strong, and my will stronger!</em></p>
<p><em>His word is wisdom, and I am his chosen.</em></p>"}
		if("almah")
			return {"<p><em>I am a mace of Raneshen.</em></p>
<p><em>The mace my chisel, my foes my monument.</em></p>
<p><em>Sure are my moves and heavy is my mace.</em></p>
<p><em>With a hundred strikes my foes will be laid low.</em></p>
<p><em>Unfazed! Unstopped! Unmatched!</em></p>
<p><em>By mace and sorcery! My will be done!</em></p>"}
		if("undead")
			return {"<p><em>Some speak of Hammerhold! And others of Gronn!</em></p>
<p><em>But there are none that can compare to the warriors of Tarichea!</em></p>
<p><em>Unstoppable! Unbreakable! Unyielding!</em></p>
<p><em>With a hundred blows, all shall be crushed!</em></p>
<p><em>Not even the gods shall stop us!</em></p>
<p><em>In Tarichea's name, we charge for—</em></p>
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
			return "Hone the tradition of your people! Though the snow elves are gone, your heritage is not! As the most excellent, most long-lived of all races, it is up to you to carry on the legacy of a spellblade! Five hundred yils of martial and arcyne excellence, five hundred yils more!"
		if("zizite")
			return "Hone the knowledge of your patron! With her ascension, the ignorant cling to the old way, your goddess lies imprisoned. Her teachings are all that remains. Her followers — corrupted, seeking undeath and bones, forgetting that she, too, is the mistress of progress. With your very blade, you shall cut open the wound of the world, cauterize it, and let her light shine through! You are her herald."
		if("noccite")
			return "Hone the wisdom of your patron! With his gift, you have glimpsed the truth of the world. The old city is gone, his teachings are not. Noc has granted you the power to seize destiny into your own hands - miracles to heal the wounded, sight to see the unseen, and magicks to strike down your foes. With your blade, you shall carve a new path forward, and let his light guide the way! You are his chosen."
		if("almah")
			return "Hone the art of your people! Show the locals the fearsome reputation of the Almah. Wield your blade for coins or mastery. The end goals need not matter, only that you enjoy every bit of your dance and your foes lay dead in the end."
		if("undead")
			return "You were a blade of Tarichea. You awaken to... what? There is no archdevil, no Celestial Empire. What do you fight for? Why do you wield the blade? Every move, every cut, every thrust. Ingrained into those old bones of yours. Hands that once wielded weapons, now naught but bare bone. Why do you fight? Have you been awakened by an ancient evyl, or did you just wake up, lost, dead, yet somehow retaining your will? Why do you fight? Why do you fight? Why do you fight?"
	return "Hone the tradition of five centuries! Let not the art die with the fall of the old city! Wield your blade for justice, for profit, or for mastery! There is no wrong path, except to stray into heresy!"
