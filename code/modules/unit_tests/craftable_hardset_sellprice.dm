/datum/unit_test/craftable_hardset_sellprice/Run()
	var/list/grandfathered = list(
		/obj/item/alch/feaudust,
		/obj/item/alch/magicdust,
		/obj/item/clothing/neck/roguetown/psicross/bpearl,
		/obj/item/clothing/neck/roguetown/psicross/pearl,
		/obj/item/clothing/neck/roguetown/psicross/shell,
		/obj/item/clothing/neck/roguetown/psicross/shell/bracelet,
		/obj/item/clothing/ring/active/nomag,
		/obj/item/clothing/ring/dragon_ring,
		/obj/item/clothing/ring/statdorpel,
		/obj/item/clothing/suit/roguetown/armor/leather/studded,
		/obj/item/clothing/suit/roguetown/armor/leather/studded/bikini,
		/obj/item/clothing/suit/roguetown/armor/leather/studded/cuirbouilli,
		/obj/item/clothing/suit/roguetown/armor/leather/studded/warden/upgraded,
		/obj/item/ingot/component/berserkswordblade,
		/obj/item/ingot/component/berserkswordgrip,
		/obj/item/ingot/component/heapofrawiron,
		/obj/item/listenstone,
		/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry/skysugarbase,
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak/gnoll,
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak/vilespawn,
		/obj/item/reagent_containers/lux,
		/obj/item/reagent_containers/lux/moss,
		/obj/item/reagent_containers/powder/black_ichor,
		/obj/item/reagent_containers/powder/moondust,
		/obj/item/reagent_containers/powder/ozium,
		/obj/item/reagent_containers/powder/starsugar/skysugar,
		/obj/item/roguegem/blood_diamond,
		/obj/item/rogueweapon/huntingknife/idagger/stake,
		/obj/item/rogueweapon/mace/steel/silver/decorated,
		/obj/item/rogueweapon/spellbook,
		/obj/item/rogueweapon/spellbook/grand,
		/obj/item/rogueweapon/spellbook/greater,
		/obj/item/rogueweapon/woodstaff/implement,
		/obj/item/rogueweapon/woodstaff/implement/amethyst,
		/obj/item/rogueweapon/woodstaff/implement/grand,
		/obj/item/rogueweapon/woodstaff/implement/grand/blacksteel,
		/obj/item/rogueweapon/woodstaff/implement/grand/riddle,
		/obj/item/rogueweapon/woodstaff/implement/greater,
		/obj/item/rogueweapon/woodstaff/implement/greater/quartz,
		/obj/item/rogueweapon/woodstaff/implement/greater/ruby,
		/obj/item/rogueweapon/woodstaff/implement/greater/sapphire,
		/obj/item/runicflask/charged,
	)

	var/list/offenders = list()
	for(var/datum/crafting_recipe/recipe as anything in GLOB.crafting_recipes)
		var/list/result_paths = islist(recipe.result) ? recipe.result : list(recipe.result)
		for(var/path in result_paths)
			check_result(path, "crafting recipe '[recipe.name]'", grandfathered, offenders)
	for(var/datum/anvil_recipe/recipe as anything in GLOB.anvil_recipes)
		check_result(recipe.created_item, "anvil recipe '[recipe.name]'", grandfathered, offenders)

	for(var/path in grandfathered)
		if(!offenders[path])
			TEST_NOTICE(src, "[path] is grandfathered in [type] but is no longer a craftable item with a hardset sellprice. Remove it from the grandfathered list.")

/datum/unit_test/craftable_hardset_sellprice/proc/check_result(path, source, list/grandfathered, list/offenders)
	if(!ispath(path, /atom/movable))
		return
	var/atom/movable/proto = path
	if(initial(proto.sellprice) <= 0)
		return
	if(offenders[path])
		return
	offenders[path] = TRUE
	if(path in grandfathered)
		return
	TEST_FAIL("Craftable item [path] (result of [source]) has a hardset sellprice = [initial(proto.sellprice)]. Remove the item's sellprice (check its parent types - it may be inherited) so the pricing engine derives the value from the recipe's materials.")
