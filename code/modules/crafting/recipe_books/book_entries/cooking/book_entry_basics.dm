/datum/book_entry/cooking_ingredients
	name = "Basic Ingredients"
	category = "Instructions"

/datum/book_entry/cooking_ingredients/inner_book_html(mob/user)
	return {"
	<div>
	<p>Most dishes requires basic ingredients. This is a primer on how to make them. Remember, right clicking the craft button will repeat the last craft you chose. Crafting Menu also allows you to assemble multiple items.</p>

	<h2>Seasonings</h2>
	<b>Salt</b> - Mined from rock salt, boiled out of a pot of seawater, or produced by alchemy from ash, water, and either fat or mince.<br>
	<b>Pepper</b> - Bought from the merchant, or crafted from a millstone: bake 5 poison jacksberries, grind them into pepper, then craft a pepper mill from a whetstone and log.<br>
	<b>Sugar</b> - Grind sugarcane in a millstone. Seeds available from the merchant.<br>

	<h2>Flour and Dough</h2>
	<b>Flour</b> - Grind wheat or oat grains in a millstone.<br>
	<b>Dough</b> - Add water to 1 flour in a bucket. Click the unfinished dough to knead, then add 1 more flour to complete it.<br>
	<b>Flatdough</b> - Roll 1 dough flat with a rolling pin.<br>
	<b>Crackerdough</b> - Cut 1 flatdough on a table. Yields 2 pieces.<br>
	<b>Smalldough</b> - Cut 1 dough on a table. Yields 2 pieces. Two smalldough can be combined back into a dough.<br>
	<b>Butterdough</b> - Add 1 slice of butter to 1 dough. Can be sliced for individual portions.<br>

	<h2>Dairy</h2>
	<b>Butter</b> - Add 1 salt to 15dr milk in a bucket, then click the bucket with a spoon. Slice with a knife to get butter slices.<br>
	<b>Fresh Cheese</b> - Add 1 salt to 15dr milk in a bucket, then click with a cloth to strain. Each 5dr of salted milk yields 1 fresh cheese per strain.<br>
	<b>Cheese Wheel</b> - Add 4 fresh cheese to 1 cloth, then wait roughly five minutes.<br>
	<b>Aged Cheese Wheel</b> - Leave a wheel of cheese out and it will age in time.<br>

	<h2>Meats and Fish</h2>
	<b>Raw Meat</b> - Butcher animal corpses with middle-click while holding a bladed weapon. The cut depends on the animal: beef, pork, poultry, bushmeat, shellfish, or worse.<br>
	<b>Raw Fish</b> - Caught with a fishing rod from a body of water. Cooked whole or chopped into mince.<br>
	<b>Raw Bacon</b> - Slice the fatty pork meat of a butchered trufflepig.<br>
	<b>Mince</b> - Hold a cleaver or knife on CHOP intent against raw meat, a bird leg, fish, or beef. A plucked bird must first be CUT into bird legs, then chopped.<br>
	<b>Raw Shellfish / Crab Meat</b> - Cut shucked oysters, a lobster, shrimp, or a crab on a table.<br>
	<b>Raw Sausage</b> - Combine 2 mince together, or add 1 fat to 1 mince. Tenderize the result with a rolling pin to prepare it as wiener nitzel.<br>

	<h2>Other Staples</h2>
	<b>Egg</b> - Chickens lay these when fed. Eggs from chickens are sometimes fertile and may hatch.<br>
	<b>Honey</b> - Harvested from bee combs. Spiderhoney is produced by tame or corpse-fed beespiders.<br>
	<b>Toastcrumbs</b> - Grind toast in a millstone.<br>
	<b>Fresh / Dried Rosa Petals</b> - Grind a rosa flower in a millstone for fresh petals. Crafting at a drying rack will dry them.<br>
	</div>
	"}
