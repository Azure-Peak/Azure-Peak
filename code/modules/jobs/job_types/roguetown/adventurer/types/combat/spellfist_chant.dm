/proc/get_spellfist_chant_html(datum/caller, mob/living/carbon/human/H)
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
	max-width: 600px;
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
.sidearm-row {
	display: flex;
	gap: 10px;
	margin-top: 15px;
}
a.choose-btn {
	flex: 1;
	display: block;
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
</style>
</head>
<body>
<div class="chant-container">
<h2>The Way of the Fist</h2>
<div class="chant-text">
<p><em>I am a fist of Psydon - His will, made manifest.</em></p>
<p><em>My body a weapon! My will a flame!</em></p>
<p><em>Where my fists fall short, my wits prevail.</em></p>
<p><em>Where my magyck falters, my fists answer.</em></p>
<p><em>Humen! Daemons! Beasts! All will be brought low!</em></p>
<p><em>In His Name, I strike!</em></p>
</div>
<div class="abilities">
<h4>Abilities</h4>
<ul>
<li><b>Fist of Psydon</b> — Targeted 3x3 ground slam up to 5 paces. 40 blunt damage. At 3+ momentum: consumes 3 to double damage to 80.</li>
<li><b>Grasp of Psydon</b> — Targeted AoE yank, pulling enemies toward you. At 3+ momentum: consumes 3 to deal 40 additional blunt damage.</li>
<li><b>Storm of Psydon</b> — Leap toward a distant target and unleash a storm of blows. Requires 7 momentum: 3 punches + 1 kick. At 10 momentum: 9 punches + 1 kick. Cannot be parried or dodged — only Defend stance can interrupt. Consumes all momentum.</li>
<li><b>Empower Weapon</b> — Requires 5+ momentum. Burns ALL momentum to empower your next melee attack, bypassing parry and dodge. 30s cooldown.</li>
</ul>
</div>
<div class="shared-info" style="text-align: left;">
<h4 style="text-align: center;">Arcyne Momentum</h4>
<ul class="shared-list">
<li><b>Building</b> — Unarmed strikes and attacks with unarmed weapons grant 1 Momentum every 2 seconds against living targets.</li>
<li><b>Spending</b> — Fist and Grasp consume 3 for empowered versions. Storm requires 7+ to cast.</li>
<li><b>Decay</b> — Starts decaying 8 seconds after your last strike, losing 1 stack every 6 seconds.</li>
<li><b>Disruption</b> — You lose ALL momentum when knocked down or stunned.</li>
<li><b>Overcharge (7+)</b> — Damages your chest each tick. Storm of Psydon becomes available.</li>
<li><b>Maximum (10)</b> — Storm of Psydon becomes fully empowered: 9 punches + 1 kick.</li>
</ul>
</div>
<div class="sidearm-row">
<a class="choose-btn" href='?src=\ref[caller];sidearm=katar'>Katar</a>
<a class="choose-btn" href='?src=\ref[caller];sidearm=knuckledusters'>Knuckledusters</a>
</div>
</div>
</body>
</html>
"}
	return html
