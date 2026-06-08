/datum/book_entry/cooking_ingredients
	name = "Basic Ingredients"
	category = "Instructions"

/datum/book_entry/cooking_ingredients/inner_book_html(mob/user)
	var/html = "<div>"
	html += "<p>Most dishes require basic ingredients. This is a primer on how to make them. Remember: right-clicking the craft button repeats the last craft you chose, and the crafting menu allows you to assemble multiple items at once.</p>"

	html += "<h2>Seasonings</h2>"
	html += "<b>Salt</b> - Mined from rock, boiled out of a pot of seawater, or produced by alchemy from ash, water, and either fat or mince.<br>"
	html += "<b>Pepper</b> - Bought from the merchant, or crafted from a millstone: bake 5 poison jacksberries, grind them into pepper, then craft a pepper mill from a whetstone and log.<br>"
	html += "<b>Sugar</b> - Grind sugarcane in a millstone. Seeds available from the merchant.<br>"

	html += "<h2>Flour and Dough</h2>"
	html += "<b>Flour</b> - Grind wheat or oat grains in a millstone.<br>"
	html += "<b>Dough</b> - Add water to 1 flour in a bucket. Click the unfinished dough to knead, then add 1 more flour to complete it.[describe_item_transforms(/obj/item/reagent_containers/food/snacks/rogue/dough)]<br>"
	html += "<b>Flatdough</b> - Roll 1 dough flat with a rolling pin.[describe_item_transforms(/obj/item/reagent_containers/food/snacks/rogue/flatdough)]<br>"
	html += "<b>Crackerdough</b> - Cut 1 flatdough on a table. Yields 2 pieces.<br>"
	html += "<b>Smalldough</b> - Cut 1 dough on a table. Yields 2 pieces. Two smalldough can be combined back into a dough.<br>"
	html += "<b>Butterdough</b> - Add 1 slice of butter to 1 dough.[describe_item_transforms(/obj/item/reagent_containers/food/snacks/rogue/butterdough)]<br>"

	html += "<h2>Dairy</h2>"
	html += "<b>Butter</b> - Add 1 salt to 15dr milk in a bucket, then click the bucket with a spoon. Slice with a knife to get butter slices.[describe_item_transforms(/obj/item/reagent_containers/food/snacks/butter)]<br>"
	html += "<b>Fresh Cheese</b> - Add 1 salt to 15dr milk in a bucket, then click with a cloth to strain. Each 5dr of salted milk yields 1 fresh cheese per strain.[describe_item_transforms(/obj/item/reagent_containers/food/snacks/rogue/cheese)]<br>"
	html += "<b>Cheese Wheel</b> - Add 4 fresh cheese to 1 cloth, then wait roughly five minutes.<br>"
	html += "<b>Aged Cheese Wheel</b> - Leave a wheel of cheese out and it will age in time.<br>"

	html += "<h2>Meats and Fish</h2>"
	html += "<b>Raw Meat</b> - Butcher animal corpses with middle-click while holding a short bladed weapon. The cut depends on the animal: beef, pork, poultry, bushmeat, shellfish, or others.<br>"
	html += "<b>Raw Fish</b> - Caught with a fishing rod or fishing cage from a body of water. Cooked whole or chopped into mince.<br>"
	html += "<b>Raw Bacon</b> - Slice the fatty pork meat of a butchered trufflepig.<br>"
	html += "<b>Mince</b> - Hold a cleaver or knife on CHOP intent against raw meat, a bird leg, fish, or beef. A plucked bird must first be CUT into bird legs, then chopped.<br>"
	html += "<b>Raw Shellfish / Crab Meat</b> - Cut shucked oysters, a lobster, shrimp, or a crab on a table.<br>"
	html += "<b>Raw Sausage</b> - Combine 2 mince together, or add 1 fat to 1 mince. Tenderize the result with a rolling pin to prepare it as wiener nitzel.[describe_item_transforms(/obj/item/reagent_containers/food/snacks/rogue/meat/sausage)]<br>"

	html += "<h2>Other Staples</h2>"
	html += "<b>Egg</b> - Chickens lay these when fed. Eggs from chickens are sometimes fertile and may hatch.[describe_item_transforms(/obj/item/reagent_containers/food/snacks/egg)]<br>"
	html += "<b>Honey</b> - Harvested from bee combs. Spiderhoney is produced by tame or corpse-fed beespiders.<br>"
	html += "<b>Toastcrumbs</b> - Grind toast in a millstone.<br>"
	html += "<b>Raisins</b> - Craft any fruit at a drying rack to dehydrate it into raisins or giblets. Poison jacksberries will produce poison raisins.[describe_item_transforms(/obj/item/reagent_containers/food/snacks/rogue/raisins)]<br>"
	html += "<b>Fresh / Dried Rosa Petals</b> - Grind a rosa flower in a millstone for fresh petals. Craft at a drying rack to dry them.<br>"

	html += "</div>"
	return html
