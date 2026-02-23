/proc/get_spellblade_chant_html(datum/caller, mob/living/carbon/human/H, faction = "conventional")
	var/blade_chant = get_blade_chant_text(faction, H)
	var/phalanx_chant = get_phalanx_chant_text(faction, H)

	var/title = "The Chant"
	var/blade_btn = "Chant the Blade Verse"
	var/phalanx_btn = "Chant the Phalangite Verse"
	if(faction == "undead")
		title = "MEMORIES"
		blade_btn = "WAKE UP"
		phalanx_btn = "WAKE UP"

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
	max-width: 660px;
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
</style>
</head>
<body>
<div class="chant-container">
<h2>[title]</h2>
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
<li><b>Caedo</b> — Dash through enemies, striking them, consuming all momentum for bonus damage.</li>
<li><b>Crescent Slash</b> — Arcyne arc attack that adapts to your stance. At 3+ momentum, pulls targets toward you.</li>
<li><b>Forcewall</b> — Conjure a 3x1 wall of arcyne force.</li>
<li><b>Blade Storm</b> — Cuts a 3x3 area suirrounding an immune center tile three times in a row. Power scales with momentum.</li>
</ul>
</div>
<p class="weapon-info">Rapier / Sabre / Arming Sword / Shortsword & Shield</p>
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
<li><b>Azurean Phalanx</b> — 3-tile line thrust that pushes enemies back.</li>
<li><b>Azurean Javelin</b> — Hurl an armor-piercing phantom spear that slows.</li>
<li><b>Advance!</b> — Charge forward 3 paces and thrust.</li>
<li><b>Gate of Reckoning</b> — Conjure a portal above a target, shooting a spear downward at their head, and then blinks to their position, striking them again.</li>
</ul>
</div>
<p class="weapon-info">Spear & Shield</p>
</div>
<a class="choose-btn" href='?src=\ref[caller];subclass=phalangite'>[phalanx_btn]</a>
</div>
</div>
<div class="shared-info">
<h4>Shared Abilities</h4>
<p>Bind Weapon · Recall Weapon · Mending · Enchant Weapon · Utility Spell Points</p>
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
