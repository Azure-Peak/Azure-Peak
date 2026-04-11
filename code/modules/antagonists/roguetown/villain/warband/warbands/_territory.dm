/datum/territory_faction
	var/name = "Warband"
	var/desc = ""
	var/job_owner 			// a job path given to the faction to determine ownership | used in preset factions	
	var/owner				// a real_name given to the faction to determine ownership | used in generated factions
	var/vault				// money
	var/list/member_names = list()
	var/list/territories = list()
	var/icon = 'icons/roguetown/weapons/shields32.dmi'
	var/icon_state = "ironsh"

/datum/territory_faction/New()
	..()
	var/list/real_territories = list() // if a territory is a path (as is the case with roundstart factions) we convert it to a real datum
	for(var/territory in src.territories)
		if(ispath(territory))
			var/datum/territory/existing_estate
			for(var/datum/territory/check_estate in SSwarbands.territory)
				if(check_estate.type == territory)
					existing_estate = check_estate
					break
			var/datum/territory/estate
			if(existing_estate)
				estate = existing_estate
				estate.associated_faction = src
			else
				estate = new territory()
				estate.associated_faction = src
				SSwarbands.territory += estate
			real_territories += estate
		else
			real_territories += territory

	src.territories = real_territories

//////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// DEFAULT FACTIONS
/*
	pre-generated factions
	note: if you're adding another job & faction to this list, that job's outfit will need to use link_treaty_faction()

*/
/datum/territory_faction/custom

/datum/territory_faction/azure
	name = "The Crown"
	desc = "It is the year 1513, and within the ruins of the Holy Land there yet stands a Grand Duchy."
	job_owner = /datum/job/roguetown/lord
	territories = list(FIEF_PASS, FIEF_KINGSFIELD, FIEF_TERRORBOG)
	icon = 'icons/roguetown/weapons/shield_heraldry.dmi'
	icon_state = "ironsh_azure peak"

/datum/territory_faction/heartfelt
	name = "The Heartfelt"
	desc = "Fortune has always been cruel to the Heartfelt."
	job_owner = /datum/migrant_role/heartfelt/lord
	vault = 2 /// https://media.tenor.com/aj47iJzWZgwAAAAM
	territories = list(FIEF_HEARTFELT)
	icon = 'icons/roguetown/weapons/shield_heraldry.dmi'
	icon_state = "woodsh_peacemaker"

/datum/territory_faction/church
	name = "The Holy See"
	desc = "And so must Ten servants be worshipped as Lords; for He is gone, and we cannot remain alone."
	job_owner = /datum/job/roguetown/priest
	vault = 3500
	territories = list(FIEF_RELIC, FIEF_DECAP)
	icon = 'icons/roguetown/weapons/shields32.dmi'
	icon_state = "gsshield"

/datum/territory_faction/orthodoxy
	name = "The Orthodoxy"
	desc = "Deep within old halls, older men weep in memory of the eldest God."
	job_owner = /datum/job/roguetown/puritan
	vault = 700
	territories = list()
	icon = 'icons/roguetown/weapons/shields32.dmi'
	icon_state = "psyshield"

/datum/territory_faction/farm
	name = "The Soilfolk"
	desc = "Several families of land-tending yeomen, graciously granted workable soil by the Crown."
	vault = 1500
	job_owner = /datum/job/roguetown/farmer
	territories = list(FIEF_HIGHLANDS)

// guildmaster is given a territory with a randomized Prized Good (limited to materials)
/datum/territory_faction/guild
	name = "The Guild"
	desc = "Stonemasons, tailors and artificers share very little in common. \
	And yet, these little commonalities are pressing enough to see a grand fraternity forged."
	vault = 1500
	job_owner = /datum/job/roguetown/guildmaster
	territories = list(FIEF_GUILD)

// merchant is given a territory with a randomized Prized Good (any)
/datum/territory_faction/merchant
	name = "The Merchant"
	desc = "A humble merchant. No more, no less."
	vault = 2000
	job_owner = /datum/job/roguetown/merchant
	territories = list(FIEF_MERCHANT)

//////////// TERRITORIES
/datum/territory
	var/name = ""
	var/desc = "A distant tract of land."	// 	shown while hovered
	var/aspects								//  extra modifiers
	var/datum/goods/prized_good				// 	when a chest from the territory's vault is imported, it contains items from its related "prized good" of a total value near the expected import
	var/distance = 1						// 	import value is divided by a territory's distance
	var/steward_hidden = FALSE				// 	if this is true it won't pop up in the nervemaster's 'all territories' section
	var/datum/territory_faction/associated_faction

/datum/territory/New()
	..()
	var/list/real_aspects = list() // if an aspect is a path, we convert it to a real datum
	for(var/aspect in src.aspects)
		if(ispath(aspect))
			var/datum/territory/aspect/full_aspect = new aspect()
			real_aspects += full_aspect
		else
			real_aspects += aspect
	src.aspects = real_aspects

/////////////////////////////////////////////////////////////
///////////////////////////////////////////////// TERRITORIES
/*
	pre-generated territories

*/
/datum/territory/custom

/datum/territory/azure_highlands
	name = "The Azure Highlands"
	desc = "A tract of grand farmland, nested upon the crest of the steep cliffs surrounding the southern bay."
	aspects = list(/datum/territory/aspect/rot)
	prized_good = /datum/goods/food/grain

/datum/territory/terrorbog
	name = "The Terrorbog"
	desc = "To be proclaimed Warden of the Terrorbog is a condemnation. It's land, yes - but it's a burden. Cursed earth."
	aspects = list(/datum/territory/aspect/rot)
	prized_good = /datum/goods/food/exotic/spiderhoney

/datum/territory/kingsfield
	name = "Kingsfield"
	desc = "Upon Tarichea's outskirts lies an untouched fragment of the Old City, left desolate after the hour of the Sundering. \
	Centuries later, within its decayed marble halls and upon its overgrowth-choked bulkheads, \
	a new strain of nobility plays their hand at civilization."
	aspects = list(/datum/territory/aspect/rot)
	prized_good = /datum/goods/misc/arms

/datum/territory/decap
	name = "Tarichea"
	desc = "The capital of Old Azuria remains as naught but a shattered monument to Progress. \
	It is known as Mount Decapitation: a wound carved into one of the Empire's many necks, from which \
	lava and forgotten treasure alike spill into condemned, unholy lands. \
	By the former Bishop's decree - and no doubt with all Gods willing - condemned it shall remain."
	aspects = list(/datum/territory/aspect/rot)
	prized_good = /datum/goods/materials/exotic/gems

/datum/territory/azure_pass
	name = "The Azure Pass"
	desc = "Just beyond the city, simple folk ply their trades in quiet villages. For now, peace shrouds them from Psydonia's ever-brewing madness."
	aspects = list(/datum/territory/aspect/rot)
	prized_good = /datum/goods/food/tea

/datum/territory/heartfelt
	name = "Heartfelt"
	desc = "Heartfelt's misfortune is immortalized in its landscape. \
	And as the Rot takes its toll on the rest of the continent, it shall soon find itself in good company."
	aspects = list(/datum/territory/aspect/rot)
	prized_good = /datum/goods/misc/rocks

/datum/territory/reliquary
	name = "Tomb of Psyvalus"
	desc = "Upon one of the diocese's lesser peaks lies an Astratan monastery. \
	Its monks follow an orderly routine as ritual: brew wine, pray skyward, and commit suicide come nitefall. \
	Upon sunrise, a select few return carrying revelations stolen from beyond death. \
	The rest remain in the cold below, and pilgrims adorn their graves with gold."
	aspects = list(/datum/territory/aspect/rot)
	prized_good = /datum/goods/materials/gold

/datum/territory/merchant_random // given a randomized Prized Good (any)
	name = "Noc's Way"
	desc = "A trade route cutting through a notably treacherous constellation in the Sea of Stars. \
	The poisoned waters of Noc's Way glitter with a bluish-silver radiance, staining the hulls of passing ships and crippling the flesh of those who grace it. \
	While once monopolized by a Lirvassi trading company, wise business left a notable share in the Merchant's hands."
	aspects = list(/datum/territory/aspect/weirding)

/datum/territory/guild_random // given a randomized Prized Good (material)
	name = "The Black Road"
	desc = ""
	aspects = list(/datum/territory/aspect/rot)

////////////////////////////////////////////////////
/////////////////////////////////// GENERATE FACTION
/*
	generate and return a faction for a given user
	also generates a single territory for said faction
*/
/datum/territory_faction/proc/generate_faction(mob/user, faction_name = "Unknown Domain", faction_desc = "", territory_name = "Unknown Territory", territory_desc = "A distant tract of land.", stewardhidden = FALSE)
	if(user)
		owner = user.real_name	
	var/given_name = faction_name
	var/given_desc = faction_desc

	if(given_name == "Unknown Domain" && user)
		given_name = "[user.real_name]'s Domain"
	if(given_name == "Warband" && user)
		given_name = "[user.real_name]'s Warband"
	
	name = verify_faction_name(given_name, user) // no two names can be the exact same
	desc = "[given_desc]"

	src.vault = rand(400, 1400)

	var/datum/territory/custom/initial_territory = new /datum/territory/custom
	initial_territory.generate_territory(user, territory_name, territory_desc, src, stewardhidden)
	var/datum/territory_faction/generated_faction = src
	generated_faction.member_names |= user.real_name
	if(owner) // adds the faction to the subsystem's cache
		SSwarbands.name_to_faction_cache[owner] = generated_faction
	if(job_owner)
		SSwarbands.job_to_faction_cache[job_owner] = generated_faction
	SSwarbands.territory_factions += generated_faction
	SSwarbands.territory += initial_territory
	generated_faction.territories += initial_territory
	return generated_faction

//////////////////////////////////////////////////////
/////////////////////////////////// GENERATE TERRITORY
/*
	generates a territory and its associated Prized Good

*/
/datum/territory/proc/generate_territory(mob/user, territory_name, territory_desc, faction, stewardhidden = FALSE)
	var/base_name
	if(territory_name)
		base_name = territory_name
	else if(user)
		base_name = "[user.real_name]'s Estate"
	else
		base_name = "Unknown Territory"
	
	name = verify_territory_name(base_name, user) // no two names can be the exact same

	src.distance = rand(1, 2)
	src.associated_faction = faction
	if(stewardhidden)
		src.steward_hidden = TRUE
	if(src.distance == 1)
		var/list/regular_goods = list(
			/datum/goods/scum/ozium,
			/datum/goods/scum/spice,
			/datum/goods/food/fish,
			/datum/goods/food/tea,
			/datum/goods/materials/copper,
			/datum/goods/misc/rocks,
			/datum/goods/misc/arms
		)
		src.prized_good = pick(regular_goods)
		var/datum/territory/aspect/rot_aspect = new /datum/territory/aspect/rot()
		src.aspects += rot_aspect
	else
		var/list/exotic_goods = list(
			/datum/goods/scum/exotic/moondust,
			/datum/goods/food/exotic/coffee,
			/datum/goods/food/exotic/rice,
			/datum/goods/materials/gold,
			/datum/goods/materials/exotic/gems
		)
		src.prized_good = pick(exotic_goods)
		var/datum/territory/aspect/weirding_aspect = new /datum/territory/aspect/weirding()
		src.aspects += weirding_aspect
	return src


//////////////////////////////////////////////////////////////
///////////////////////////////////////////////// VERIFY NAMES
/*
	makes sure that generated factions & territories will never have the exact same name
	if they ever do, you'll start to see problems w/ownership
*/
/datum/territory_faction/proc/verify_faction_name(base_name, mob/user)
	var/proposed_name = base_name
	var/counter = 1
	var/name_exists = TRUE
	
	while(name_exists)
		name_exists = FALSE
		for(var/datum/territory_faction/faction in SSwarbands.territory_factions)
			if(faction.name == proposed_name)
				name_exists = TRUE
				break
		
		if(name_exists)
			counter++
			if(user && user.real_name)
				proposed_name = "[user.real_name]'s [base_name] ([counter])"
			else
				proposed_name = "[base_name] ([counter])"
	
	return proposed_name

/datum/territory/proc/verify_territory_name(base_name, mob/user)
	var/proposed_name = base_name
	var/counter = 1
	var/name_exists = TRUE
	
	while(name_exists)
		name_exists = FALSE
		for(var/datum/territory/land in SSwarbands.territory)
			if(land.name == proposed_name)
				name_exists = TRUE
				break
		
		if(name_exists)
			counter++
			if(user && user.real_name)
				proposed_name = "[user.real_name]'s [base_name] ([counter])"
			else
				proposed_name = "[base_name] ([counter])"
	
	return proposed_name

/////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// TERRITORY MODIFIERS
/*
	these are both essentially just flavortext & distance signifiers
	if someone sees "the weirding", the prized good is pulling from the exotic loot pool
*/
/datum/territory/aspect

/datum/territory/aspect/rot 
	name = "The Rot" // so imagine a burger,
	desc = "The Rot is Mankind's first taste of the extinction promised by Psydon's death. \
	Todae, it tastes of overripe fruit. Tomorrow, stale ash. Soon, nothing at all."

/datum/territory/aspect/weirding
	name = "The Weirding"
	desc = "All east of the shattered leyline flourishes in excess, saturated with Lux bled from Psydonia itself."

///////////////////////////////////////////////////////
///////////////////////////////////////////////// GOODS
/*
	during a territory's vault import, it draws from the item pool of its associated "prized good"
	generates a crate loaded with a Good's registered items
	minimum/default value for a single imported item is 25
*/
/datum/goods
	var/name
	var/desc
	var/list/items = list()			
	var/unique_import_value			// gives each item a unique value during the import calculation

#define ALL_GOODS list(/datum/goods/scum/ozium, /datum/goods/scum/spice, /datum/goods/scum/exotic/moondust, /datum/goods/food/fish, /datum/goods/food/grain, /datum/goods/food/tea, \
/datum/goods/food/exotic/coffee, /datum/goods/food/exotic/rice, /datum/goods/food/exotic/spiderhoney, /datum/goods/materials/copper, /datum/goods/materials/gold, \
/datum/goods/materials/exotic/gems, /datum/goods/misc/rocks, /datum/goods/misc/arms)
#define MATERIAL_GOODS list(/datum/goods/materials/copper, /datum/goods/materials/exotic/gems, /datum/goods/materials/gold, /datum/goods/misc/rocks)

/datum/territory/merchant_random/New()
	..()
	prized_good = pick(ALL_GOODS)

/datum/territory/guild_random/New()
	..()
	prized_good = pick(MATERIAL_GOODS)

//////////// DRUGS
/datum/goods/scum/ozium
	name = "Ozium"
	items = list(/obj/item/reagent_containers/powder/ozium)

/datum/goods/scum/spice
	name = "Spice"
	items = list(/obj/item/reagent_containers/powder/spice)

/datum/goods/scum/exotic/moondust
	name = "Moondust"
	items = list(/obj/item/reagent_containers/powder/moondust)

//////////// FOOD
/datum/goods/food/fish
	name = "Fish"
	items = list(/obj/item/reagent_containers/food/snacks/fish/lobster, /obj/item/reagent_containers/food/snacks/fish/carp, /obj/item/reagent_containers/food/snacks/fish/cod)

/datum/goods/food/grain // outside of this being randomly rolled, grain should be left in the hands of the soilsons / the soilson territory
	name = "Grain"
	items = list(/obj/item/reagent_containers/food/snacks/grown/wheat)

/datum/goods/food/tea
	name = "Tea"
	items = list(/obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_dry)

/datum/goods/food/exotic/coffee
	name = "Coffee"
	items = list(/obj/item/reagent_containers/food/snacks/grown/coffeebeans)

/datum/goods/food/exotic/rice
	name = "Rice"
	items = list(/obj/item/reagent_containers/food/snacks/grown/rice)

/datum/goods/food/exotic/spiderhoney
	name = "Spider Honey"
	items = list(/obj/item/reagent_containers/food/snacks/rogue/honey/spider)

//////////// MATERIALS
// if you add to this, be sure to update the defined material_goods list, as the crafting guild draws on that for a randomized prized good
/datum/goods/materials/copper
	name = "Copper"
	items = list(/obj/item/ingot/copper)

/datum/goods/materials/gold
	name = "Gold"
	items = list(/obj/item/ingot/gold, /obj/item/candle/candlestick/gold, /obj/item/candle/gold, /obj/item/clothing/ring/gold, /obj/item/reagent_containers/glass/bowl/gold, \
	/obj/item/roguestatue/gold, /obj/item/cooking/platter/gold, /obj/item/reagent_containers/glass/cup/golden, /obj/item/reagent_containers/glass/cup/golden/small, /obj/item/clothing/ring/signet)

/datum/goods/materials/exotic/gems
	name = "Jewels"
	items = list(/obj/item/roguegem/green, /obj/item/roguegem/diamond, /obj/item/roguegem/violet, /obj/item/roguegem/ruby, /obj/item/roguegem/yellow)

//////////// MISC
/datum/goods/misc/rocks
	name = "Rocks"
	items = list(/obj/item/natural/bundle/stoneblock)

// mostly iron
// can potentially draw a gorget, a halberd, a decorated arming sword, a crossbow, or a silver dagger
/datum/goods/misc/arms
	name = "Arms"
	items = list(/obj/item/rogueweapon/sword/saber/iron, /obj/item/rogueweapon/sword/iron, /obj/item/rogueweapon/sword/short/iron/chipped, /obj/item/rogueweapon/sword/short/messer/iron, /obj/item/rogueweapon/spear, /obj/item/rogueweapon/shield/heater, \
	/obj/item/rogueweapon/sword/decorated, /obj/item/rogueweapon/halberd, /obj/item/rogueweapon/huntingknife/idagger/silver, /obj/item/rogueweapon/huntingknife/idagger, /obj/item/rogueweapon/greatsword/zwei, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow, \
	/obj/item/rogueweapon/eaglebeak/lucerne, /obj/item/quiver/bolts, /obj/item/rogueweapon/mace, /obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron, /obj/item/clothing/neck/roguetown/gorget/steel, /obj/item/rogueweapon/sword/short/messer/iron, \
	/obj/item/rogueweapon/flail, /obj/item/rogueweapon/halberd/bardiche, /obj/item/clothing/head/roguetown/helmet/kettle/iron, /obj/item/clothing/neck/roguetown/chaincoif/iron, /obj/item/clothing/suit/roguetown/armor/gambeson/heavy, /obj/item/reagent_containers/food/snacks/squiresdelight)


#undef MATERIAL_GOODS
#undef ALL_GOODS
