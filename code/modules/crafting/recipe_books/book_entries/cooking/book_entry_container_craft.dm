/datum/book_entry/container_craft
	name = "Cooking With Pots and Pans"
	category = "Instructions"
	book_priority = 1

/datum/book_entry/container_craft/inner_book_html(mob/user)
	return {"
		<div>
		<h2>How to cook with storage containers</h2>
		In order to cook with containers like ovens, pans, and pots first you need to open their storage. Pans and Pots must be put on a lit hearth, while ovens must be lit. <br>
		You can open the container by dragging the container onto you or using it in your hand. If it is a pot or pan on a hearth, you can insert item by left clicking it while it is on the hearth. Oven can have ingredients inserted by left clicking the top with the item you want to cook. This also includes pottery recipes.
		<br>
		<br>
		Clicking an empty pan or pot on a hearth will remove the container. Middle Click will always remove the container together with any food. Left clicking a filled pot or pan will open the storage interface.
		</br>
		<br>
		A tray or bakers peel can load or unload an oven. Peel can do it from a distance.
		</br>
		</div>

		<div>
		<h2> How to start a recipe </h2>
		Starting a recipe is done simply by closing the storage interface after putting the items you want in,<br>
		its done this way to stop the game from starting a recipe before you have your toppings and other things ready.<br>
		<br>
		If the storage container is closed when you try to insert an item it will try to start a recipe at the time of insertion. <br>
		Cooking time is increased based on the amount of the item your cooking at once, so 10 dough is going to take <br>
		longer then 4 dough to make.
		</div>
	"}
