/datum/book_entry/magic1
	name = "Chapter I: Leylines and Encounters"
	category = "Instructions"

/datum/book_entry/magic1/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Leylines and Encounters:</h2>
	<p>
		Leylines are fractured convergences of arcyne energy scattered across the land. A mage's primary work is to travel to these sites, draw summoning circles, and fight the creatures that pour through the veil.
		The materials dropped by slain creatures are used for enchanting and binding.
	</p>
	<h3>Finding Leylines</h3>
	<p>
		Use <b>Prestidigitation</b> (Grab intent) to attune to the veil and sense nearby leylines.
		This reveals their direction, distance, alignment, and whether they have been used today.
	</p>
	<h3>Leyline Types</h3>
	<ul>
		<li><b>Tamed</b> (University) - 4 uses/day, first circle rituals only. Good for practice or initial setup.</li>
		<li><b>Coastal</b> (Coast) - Elemental-aligned, 2 uses/day, up to the fourth circle.</li>
		<li><b>Sylvan</b> (Grove) - Fae-aligned, 2 uses/day, up to the fourth circle.</li>
		<li><b>Scorched</b> (Mount Decapitation) - Infernal-aligned, 2 uses/day, up to the fourth circle.</li>
		<li><b>Unstable</b> (Terrorbog) - Void-aligned, 2 uses/day, up to the fifth circle. Always spawns extra creatures.</li>
	</ul>
	<h3>Performing a Ritual</h3>
	<ol>
		<li>Travel to a leyline.</li>
		<li>Draw a summoning circle nearby (chalk for the first, second and third circles, arcyne silver dagger for the fourth and fifth circles).</li>
		<li>Click the circle and select a leyline encounter ritual.</li>
		<li>Chant the invocation. This is loud and visible - others will notice. Make sure you are not interrupted. </li>
		<li>Fight the creatures that emerge. Collect their materials.</li>
		<li>Bringing friends or fellow Magos is recommended, especially for higher circles rituals.</li>
		<li>Rituals has a chance to go wrong and summon more creatures than expected</li>
	</ol>
	<h3>Veil Attunement</h3>
	<p>
		Each mage can perform a limited number of rituals per week. Your body will become
		fatally weakened should you do too much. On average, a Magos can perform one 
		ritual per day safely, though many stretches it to eight a week once they gain experience.
		The leylines are the strongest on after Feast's Dae and on the weekends and 
		become the weakest on Moon's dae. In the earlier daes of the week, it is best to 
		focus on lower circles rituals or to attune yourself at your discretion. On the 
		fifth day of the week, that is when the leylines reaches their peaks and the 
		most powerful rituals can be performed.
	</p>
	<h3>Alignment</h3>
	<p>
		Matching a ritual's realm to the leyline's alignment gives the full number of creatures.
		Using a mismatched leyline results in fewer creatures spawning. Choose your leylines wisely.
		The Terrorbog, where Comet SYON has landed - is known for its powerful leylines where one can draw out\
		leyline lycans and void creechurs alike. A summoning of the wrong alignment would still draw the normal amount\
		of creechurs out - thanks to the leylines power.
	</p>
	</div>
	"}

/datum/book_entry/magic2
	name = "Chapter II: Materials and Enchanting"
	category = "Instructions"

/datum/book_entry/magic2/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Materials and Enchanting:</h2>
	<p>
		Slain creatures drop realm-aligned materials. Each realm has four circles of materials:
	</p>
	<ul>
		<li><b>Infernal:</b>Infernal Ash, Hellhound Fang, Infernal Core, Abyssal Flame</li>	
		<li><b>Fae:</b> Fairy Dust, Iridescent Scale, Heartwood Core, Sylvan Essence</li>
		<li><b>Elemental:</b> Elemental Mote, Elemental Shard, Elemental Fragment, Elemental Relic</li>
	</ul>
	<p>
		<b>Enchanting</b> uses realm materials (plus cinnabar and a scroll) on an Imbuement Array to create
		enchantment scrolls. Third and fourth circle enchantments also require a leyline shard.
		The Imbuement Array can perform up to third circle enchantments.
		The Greater Imbuement Array is required for fourth circle enchantments, but can also perform all lower circles.
		Each item may only hold a single enchantment.
	</p>
	<p>
		<b>Arcanic Melds</b> are crafted by combining one material from each of the three realms at the same tier.
		This means you need to fight creatures at leylines of different alignments - or trade with other mages.
	</p>
	<h2>Binding Creatures:</h2>
	<p>
		To bind a creature to your service, draw a <b>Binding Array</b> (or Greater Binding Array for the third and fourth circles)
		and supply realm materials, arcanic melds, and runed artifacts. The bound creature can then be
		released from a summoning circle to serve you.
	</p>
	<h3>Other Materials</h3>
	<ul>
		<li><b>Runed Artifacts</b> - Found in the wilds, especially the bog. Required for binding rituals.</li>
		<li><b>Leyline Shards</b> - Dropped by leyline lycans (summon them with the Leyline Luring ritual). Required for third circle and above enchantments.</li>
		<li><b>Cinnabar</b> - Required for all enchantments. Available from merchants or found in mines.</li>
	</ul>
	</div>
	"}
