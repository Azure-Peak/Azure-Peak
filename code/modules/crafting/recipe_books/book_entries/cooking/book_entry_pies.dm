/datum/book_entry/cooking_pies
	name = "Pie Making"
	category = FOOD_CAT_PIES
	book_priority = 1

/datum/book_entry/cooking_pies/inner_book_html(mob/user)
	return {"
	<div>
	<p>Pies are a special preparation. The crust and filling are assembled separately and then put together.</p>

	<h2>Preparing the Crust</h2>
	<ol>
	<li>Add 1 slice of butter to 1 finished dough to make butterdough.</li>
	<li>Slice the butterdough into pieces.</li>
	<li>Roll each butterdough piece flat with a rolling pin to produce pie dough. You will need two pieces of pie dough per pie.</li>
	<li>Bake one piece of pie dough in the oven to produce a pie bottom.</li>
	</ol>

	<h2>Filling and Baking</h2>
	<ol>
	<li>Add the filling to the pie bottom - the recipes in this category list every pie.</li>
	<li>Most pies are sealed with the second piece of pie dough on top; the pumpkin pie is left open.</li>
	<li>Bake the assembled pie in the oven.</li>
	<li>Slice the finished pie to produce pie slices.</li>
	</ol>

	<p>Unsliced pies do not spoil. Slice only what you intend to serve.</p>
	<p>Most pies grant +1 willpower for ten minutes when eaten.</p>
	</div>
	"}
