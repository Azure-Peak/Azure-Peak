/datum/book_entry/fishing
	abstract_type = /datum/book_entry/fishing
	category = null

/datum/book_entry/fishing/basics
	name = "Introduction and Basic Mechanics"
	category = "Guide"
	book_priority = 100

/datum/book_entry/fishing/basics/inner_book_html(mob/user)
	return {"
		<div>
		<h3>How to Fish</h3>
		<p>To fish, cast with a fishing rod that is equipped with a hook, a fishing line and preferably a piece of bait on a body of water. Once the bobber moves, you can left click to start the fishing minigame. Right click to pull the line back in.</p>
		<p>Not using any bait greatly reduces the chance of fishing anything worthy.</p>
		<p>Keep the green bar on the fish to progress. The progress bar turns gold when you are doing well, becoming green if you are doing average, and red when you do poorly. A golden catch gives you a bigger fish. Harder fishes give you less time. Auto reel adjusts slower and cannot land prized fish.</p>

		<h3>Bait, Tackles and Tools</h3>
		<p>There are two types of baits.</p>
		<p><b>Live baits</b>: Having any bait is better than no bait, and excellent baits filter the fishes to prized and valuable fishes.</p>
		<p><b>Rolled baits</b>: These baits are rolled and need to be spun. They are better than good live baits for ordinary fishes and often cheaper to use. They can be spun by clicking the float whenever its light turns green. Using a rolled bait will make fishes bite more predictably.</p>
		<p>Bait quality multiplies the weight of higher value fishes.</p>
		<ul>
			<li><b>Passable</b>: worm, slice of cheese.</li>
			<li><b>Good</b>: grub, leech, leech tick, slice of aged cheese.</li>
			<li><b>Excellent</b>: cerulean aril, bloated leech tick.</li>
		</ul>
		<p>Certain fishes are herbivorous or carnivorous, they are more likely to bite onto types of bait they like. Carnivorous bait includes worms, grubs, leeches and leech ticks. Herbivorous bait includes fresh vegetables and fruit.</p>
		<p>Picky fishes will not bite onto passable bait at all unless it is one of their favourites. Every fish also has favourite baits that make it easier to catch, and disliked baits that make it harder.</p>
		<p>Certain fishes are also wary, and a thin fishing line, silk or better, helps you catch them.</p>
		<p>A rod needs a fishing line and a hook. A bobber or sinker and a bait are optional. Each piece of gear comes in tiers.</p>
		<ul>
			<li><b>Rods</b> From worst to best: Crafted, Plain, Bronze, Blacksteel rod, and one type found in ruins. A better rod makes the minigame easier, and the two best widen the catch window.</li>
			<li><b>Fishing lines</b>, from worst to best: twine, leather, silk, deluxe. Twine loses progress faster. Leather is the standard. Silk loses progress slower and will not alert wary fishes. Deluxe also progress faster on top of silk's advantage.</li>
			<li><b>Hooks</b>: The wooden gorge fishing hook is easy to acquire and struggles with larger fish. The thorn hook never lets a fish escape, and guarantee a catch if you take too long, but halve your XP gain. The iron hook is the standard and keep the bait from bouncing off the bottom. The carved minnow hook, the best hook, scares off small fish and attracts large ones, and lets you move the green bar both up and down.</li>
			<li><b>Bobber and sinker</b>: Having either of them make you progress faster. The bobber makes the bait sink slower. The sinker brings up bottom dwelling fish.</li>
			<li><b>Rolled baits</b>: Red bait for eels and meat eaters, doughy bait for carp, shrimp and plant eaters, shell bait for shellfishes, gray bait for a bit of everything, speckled bait for odd and valuable fishes, and enchanted bait draws special fishes.</li>
			<li><b>Enchanted bait</b>: Enchanted baits can be blessed by Abyssorite clerics [FISHING_ENCHANT_RITE_BAITS] at a time, for a small offering of a cup of ale (or beer, or similar).</li>
		</ul>

		<h3>Sources and Stocks</h3>
		<p>Fishing sources are counted per region and water type. For example, murky water and deep water have different distributions of fishes, and the north coast and south coast deepwater share different pools. Moving around semi frequently is a good idea to maximize the value of your catches.</p>

		<h3>Other Ways to Fish</h3>
		<ul>
			<li>The fishing cage almost exclusively catches crustaceans, and takes a while to catch one.</li>
			<li>The fishing spear does not use any bait or minigame, but will only catch as effectively as an unbaited rod.</li>
		</ul>

		<h3>Trivia</h3>
		<ul>
			<li>Expert Fishers have an easier time landing a catch, can tell the stock of a body of water is by looking at it, are warned when it runs low, and get a moment's notice before something hostile surfaces.</li>
		</ul>
		</div>
	"}
