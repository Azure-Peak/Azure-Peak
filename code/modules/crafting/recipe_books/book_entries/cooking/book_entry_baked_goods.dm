/datum/book_entry/cooking_baked_goods
	name = "Baked Goods"
	category = "Instructions"

/datum/book_entry/cooking_baked_goods/inner_book_html(mob/user)
	return {"
	<div>
	<p>The ovens can .</p>

	<h2></h2>

	<h2>Hardtack</h2>
	<ol>
	<li>Roll 1 dough flat with a rolling pin to make flatdough.</li>
	<li>Cut the flatdough on a table. Each flatdough yields 2 crackerdough.</li>
	<li>Bake crackerdough in the oven to produce hardtack. Hardtack does not spoil.</li>
	</ol>

	<h2>Buns and Crossbuns</h2>
	<ol>
	<li>Cut 1 dough on a table to make 2 smalldough.</li>
	<li>Bake smalldough in the oven for a plain bun.</li>
	<li>Optionally, click smalldough with a cross / psycross before baking to produce a crossbun or psycrossbun for the devout.</li>
	<li>Add 1 fresh cheese to smalldough before baking to make a cheesebun.</li>
	</ol>

	<h2>Prezzel</h2>
	<p>Slice 1 butterdough, then bake the slice in the oven. You must be a dwarf to know this recipe. Prezzels do not spoil.</p>

	<h2>Pumpkin Balls</h2>
	<ol>
	<li>Slice a pumpkin on a table, or use the mashed form.</li>
	<li>Add the sliced or mashed pumpkin to 1 slice of butterdough.</li>
	<li>Bake the raw pumpkin ball in the oven.</li>
	</ol>
	<p>Grants +1 willpower for ten minutes.</p>

	<h2>Pumpkin Loaf</h2>
	<p>Add 1 sliced or mashed pumpkin to 1 butterdough, then bake. Can be sliced. Grants +1 willpower for ten minutes.</p>

	<h2>Bookbread Loaves</h2>
	<ol>
	<li>Add a piece of fruit (raspberry, jacksberry, blackberry, pear, tangerine, plum, lemon, or chocolate) to 1 butterdough.</li>
	<li>Bake the result in the oven for a fruit-flavored bookbread loaf.</li>
	<li>The loaf can be sliced into individual servings.</li>
	</ol>
	<p>Poison jacksberries will poison the bookbread. Grants +1 willpower for ten minutes.</p>

	<h2>Biscuits</h2>
	<ol>
	<li>Add 1 handful of raisins (or a fruit, depending on the variant) to 1 slice of butterdough.</li>
	<li>Bake. Biscuits do not spoil.</li>
	</ol>
	<p>Grants +1 willpower for ten minutes.</p>

	<h2>Muffins</h2>
	<ol>
	<li>Use a spoon on 1 butterdough to shape it into muffindough.</li>
	<li>Bake the muffindough for a plain muffin.</li>
	<li>For a finer meal, add 1 fresh cheese for a cheese muffin, or 1 honey for a honey muffin, then bake again.</li>
	</ol>
	<p>Cheese and honey muffins grant +1 willpower for ten minutes.</p>

	<h2>Cookies</h2>
	<ol>
	<li>Add a topping (chocolate slice, raisins, caramel, or dragee) to a piece of hardtack to make a half-cookie.</li>
	<li>Add another portion of the same topping to the half-cookie to complete the cookiedough slab.</li>
	<li>Bake the slab in the oven.</li>
	<li>Slice the baked slab on a table to yield 6 cookies.</li>
	</ol>

	<h2>Strudel</h2>
	<ol>
	<li>Add 1 dough to 1 slice of dough.</li>
	<li>Add 1 apple and 1 rocknut.</li>
	<li>Bake for a strudel.</li>
	<li>Add sugar afterwards to produce a coated strudel.</li>
	<li>The finished strudel can be sliced.</li>
	</ol>
	<p>Grants +1 willpower for ten minutes.</p>

	<h2>Cakes</h2>
	<p>Cakes start from a cake base. Plain variants are made by adding honey or cheese before baking; frosted variants take a separate frosting and accept fruits.</p>
	<ol>
	<li>Combine 1 egg with 1 butterdough to make a cake base.</li>
	<li>For a honey cake, add 1 honey to the cake base, then bake. For a cheesecake, add 1 fresh cheese to the cake base, then bake.</li>
	</ol>
	<p>For frosted cakes:</p>
	<ol>
	<li>Combine 1 sugar with 1 butter slice to make 1 frosting.</li>
	<li>Add the frosting to a cake base to make a frosted cake base, then bake. (You may instead add frosting to an already-baked plain cake to frost it retroactively.)</li>
	<li>To a frosted cake, add one of: apple, berry, blackberry, baked carrot, lemon, lime, mentha, peaceflower, raspberry, rocknut, strawberry, or tangerine. The cake takes the name of the fruit added.</li>
	<li>An apple cake combined with a rocknut (or a rocknut cake with an apple) becomes an applenut cake.</li>
	<li>Finished cakes can be sliced for 8 servings. Sliced cake suffers a slight quality reduction unless plated.</li>
	</ol>
	<p>A peaceflower produces a peace cake, which pacifies the eater for five minutes.</p>

	<h2>Stuffed Egg</h2>
	<p>Add 1 aged cheese wedge to 1 egg, then cook in an oven or pan.</p>

	<h2>Stuffed Aubergine</h2>
	<ol>
	<li>Slice an eggplant with a knife.</li>
	<li>Add meat mince.</li>
	<li>Top with a tomato. Bake for stuffed aubergine.</li>
	<li>Optionally add a cheese wedge to elevate it to fine quality.</li>
	</ol>
	<p>Grants +1 willpower and +1 constitution for ten minutes.</p>

	<h2>Handpies</h2>
	<ol>
	<li>Roll 1 slice of butterdough flat to make pie crust.</li>
	<li>Add one of: truffles, mince, jacksberries, mushroom, fish mince, crab meat, berry, apple, potato slice, or cabbage.</li>
	<li>Cook the handpie in an oven or pan.</li>
	</ol>
	<p>Handpies do not spoil until bitten. Grants +1 willpower and +1 constitution for ten minutes.</p>
	</div>
	"}
