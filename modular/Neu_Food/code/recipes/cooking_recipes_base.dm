// Subtype of crafting_recipe for cooking

/datum/crafting_recipe/roguetown/cooking
	abstract_type = /datum/crafting_recipe/roguetown/cooking
	subtype_reqs = TRUE // Cooking recipes do not require specific subtypes of ingredients.
	skillcraft = /datum/skill/craft/cooking // All cooking recipes use the cooking skill.
	craftdiff = 0 // Default difficulty for cooking recipes.
	req_table = FALSE // Cooking recipes generally require a table to work on. /or so you would think apparently they all use drying rack.
