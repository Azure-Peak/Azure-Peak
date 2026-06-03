/datum/book_entry/cooking_basics
	name = "How to Cook"
	category = "Instructions"

/datum/book_entry/cooking_basics/inner_book_html(mob/user)
	return {"
	<div>
	<h2>Stations and Implements</h2>
	<b>Table</b> - A flat working surface. Cutting ingredients and assembling most dishes both require one.<br>
	<b>Oven</b> - Bake breads, roasts, pies. Fuel goes on the bottom shelf, food on top.<br>
	<b>Hearth</b> - An open flame. Clicking a hearth with a pot or pan sets it on top. Right-click to fan the flame and cook faster, at the risk of burning.<br>
	<b>Pot</b> - Fill with water, throw in vegetables or meat, boil into soup. Also used to melt tallow for deep frying.<br>
	<b>Pan</b> - Used to fry most things over an open flame.<br>
	<b>Knife</b> - Any small bladed weapon on CUT or CHOP intent. Slices ingredients into smaller portions on a table.<br>
	<b>Rolling Pin</b> - Flattens dough.<br>
	<b>Bucket</b> - Adds water to flour for dough, or churns butter from milk.<br>
	<b>Spoon</b> - Ladle soup from a pot into a bowl. Also churns butter.<br>
	<b>Bowl</b> - Hold soup. Click a pot with a bowl to take a portion.<br>
	<b>Platter</b> - A serving plate. Most dishes can be platted. Platters raise food quality by one tier and prevent spoilage.<br>
	<b>Drying Rack</b> - Used for dehydration, salt-curing, and similar preparations through the crafting menu.<br>
	<b>Ration Paper</b> - Wrapping any food in ration paper preserves it indefinitely. Crafted from parchment and tallow.<br>
	</div>
	<div>
	<h2>Assembly (Slap Crafting)</h2>
	Most prepared dishes are made by combining ingredients on a table. Click your base item with the next ingredient in the recipe to add it. Each step takes a moment; experienced cooks are faster.<br>
	A food item on a table will show its active recipe and the next step in its examine. Middle-click an item with an active recipe to reset its preparation if you set it down the wrong path.<br>
	</div>
	<div>
	<h2>Cooking Cues</h2>
	When food cooks to completion in an oven or pan, you will usually see Something smells good! in the chat. Pan-fried foods sometimes only signal completion by a change in sprite, so keep an eye on the pan or you will end with an inedible burned mess.<br>
	If you are out in the wild without a kitchen, you can roast raw meat over any open flame: hold the meat in one hand, a weapon set to STAB intent in the other, then click the fire.<br>
	</div>
	<div>
	<h2>Food Quality</h2>
	Foods carry a quality tier: <b>Impoverished</b>, <b>Poor</b>, <b>Neutral</b>, <b>Fine</b>, or <b>Lavish</b>. Plating on a platter (Click the platter with it) raises quality by one. Nobles complain at anything below Fine and may vomit at Poor or worse. Burghers and yeomen complain at Impoverished.<br>
	</div>
	<div>
	<h2>Platter</h2>
	Food on platter does not rot. Clicking a platter with a feather allows you to rename the name and description of the dish, which is cosmetic only but allows you to roleplay it as a different or similar dish you want!
	</div>
	<div>
	<h2>Spoilage</h2>
	Food left out too long will spoil. To prevent it: dehydrate it on a drying rack (if available), put it on a cooling table,  wrap it in ration paper, or store it in a chest (not a closet).<br>
	</div>
	"}
