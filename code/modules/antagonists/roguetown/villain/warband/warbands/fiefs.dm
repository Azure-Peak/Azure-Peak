/////////////////////////////////////////////////////////////
///////////////////////////////////////////////// TERRITORIES
/*
	DEFAULT FACTIONS
	DEFAULT TERRITORIES

	FACTION & TERRITORY PROCS
	1 - GENERATE FACTION	// generates a faction, then procs Generate Territory
	2 - GENERATE TERRITORY	// generates a territory
	3 -

	PRIZED IMPORT PROCS


*/
/datum/territory_faction
	var/name = "Warband"
	var/desc = ""			// appears when hovered in a treaty
	var/job_owner 			// a job name given to the faction to determine ownership | used in preset factions	
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
			var/datum/territory/existing_estate = null
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
	pre-generated territories
*/
/datum/territory_faction/custom

/datum/territory_faction/azure
	name = "The Crown"
	desc = "It is the year 1513, and within the ruins of the Holy Land there yet stands a Grand Duchy."
	job_owner = "Grand Duke"
	territories = list(FIEF_PASS, FIEF_KINGSFIELD, FIEF_TERRORBOG)
	icon = 'icons/roguetown/weapons/shield_heraldry.dmi'
	icon_state = "ironsh_azure peak"

/datum/territory_faction/heartfelt
	name = "The Heartfelt"
	desc = "Fortune has always been cruel to the Heartfelt."
	job_owner = "Lord of Heartfelt"
	vault = 2 /// https://media.tenor.com/aj47iJzWZgwAAAAM
	territories = list(FIEF_HEARTFELT)
	icon = 'icons/roguetown/weapons/shield_heraldry.dmi'
	icon_state = "woodsh_peacemaker"

/datum/territory_faction/church
	name = "The Holy See"
	desc = "And so must Ten servants be worshipped as Lords; for He is gone, and we cannot remain alone."
	job_owner = "Bishop"
	vault = 3500
	territories = list(FIEF_RELIC, FIEF_DECAP)
	icon = 'icons/roguetown/weapons/shields32.dmi'
	icon_state = "gsshield"

/datum/territory_faction/orthodoxy
	name = "The Orthodoxy"
	desc = "Within the old halls of old churches, old men weep in memory of an older God."
	job_owner = "Inquisitor"
	vault = 700
	territories = list()
	icon = 'icons/roguetown/weapons/shields32.dmi'
	icon_state = "psyshield"

/datum/territory_faction/farm
	name = "The Soilfolk"
	desc = "Several families of land-tending yeomen, graciously granted workable soil by the Crown."
	vault = 1500
	job_owner = "Soilson"
	territories = list(FIEF_HIGHLANDS)

// guildmaster is given a territory with a randomized Prized Good (limited to materials)
/datum/territory_faction/guild
	name = "The Guild"
	desc = "Stonemasons, tailors and artificers share very little in common. \
	And yet, these little commonalities are pressing enough to see a grand fraternity forged."
	vault = 1500
	job_owner = "Guildmaster"
	territories = list(FIEF_GUILD)

// merchant is given a territory with a randomized Prized Good (any)
/datum/territory_faction/merchant
	name = "The Merchant"
	desc = "A humble merchant. No more, no less."
	vault = 2000
	job_owner = "Merchant"
	territories = list(FIEF_MERCHANT)

//////////// TERRITORIES
/datum/territory
	var/name = ""
	var/desc = "A distant tract of land."	// shown while hovered
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

// 1
////////////////////////////////////////////////////
/////////////////////////////////// GENERATE FACTION
/* 1
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
	if(!(user.real_name in generated_faction.member_names))
		generated_faction.member_names += user.real_name
	if(owner) // adds the faction to the subsystem's cache
		SSwarbands.name_to_faction_cache[owner] = generated_faction
	if(job_owner)
		SSwarbands.job_to_faction_cache[job_owner] = generated_faction
	SSwarbands.territory_factions += generated_faction
	SSwarbands.territory += initial_territory
	generated_faction.territories += initial_territory
	return generated_faction


// 2
//////////////////////////////////////////////////////
/////////////////////////////////// GENERATE TERRITORY
/* 2
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






// 3
/////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// TERRITORY MODIFIERS
/* 3
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



//////////////////////////////////////////////////////////////
///////////////////////////////////////////////// IMPORT WRITS
/*
	item used to trigger Prized Imports from territories
*/
/obj/item/import_writ
	name = "import writ"
	desc = "An official writ authorizing the import of goods from a distant territory."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "paperwrite"
	w_class = WEIGHT_CLASS_TINY
	
	var/territory_name
	var/import_amount = 0
	var/import_location // this'll either be "City Docks" or "Groveside"
	var/datum/territory_faction/issuing_faction
	var/sealed = FALSE
	var/obj/item/grant/attached_grant


/obj/item/import_writ/examine(mob/user)
	. = ..()
	if(sealed)
		. += span_notice("Territory: [territory_name]")
		. += span_notice("Amount: [import_amount] mammon")
		. += span_notice("Destination: [import_location]")
		if(issuing_faction)
			. += span_notice("Issued by: [issuing_faction.name]")
		if(attached_grant)
			. += span_notice("Grant attached: [attached_grant.grant_amount] mammon")
	else
		. += span_warning("This writ has not been sealed yet.")
	if(attached_grant)
		. += span_info("Use in hand to detach the grant.")

/obj/item/import_writ/update_icon_state()
	if(attached_grant)
		icon_state = "paper_prep"
		name = "import writ (grant attached)"
	else
		icon_state = "paperwrite"
		name = "import writ"

/obj/item/import_writ/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/grant))
		var/obj/item/grant/G = I
		if(!G.sealed)
			to_chat(user, span_warning("This grant must be sealed before it can be attached."))
			return
		if(attached_grant)
			to_chat(user, span_warning("There's already a grant attached to this writ."))
			return
		if(!user.transferItemToLoc(G, src))
			return
		attached_grant = G
		update_icon_state()
		to_chat(user, span_notice("I attach the grant to the import writ."))
		return
	
	return ..()


/obj/item/import_writ/attack_self(mob/user)
	if(!attached_grant)
		to_chat(user, span_info("There's no grant attached to this writ."))
		return
	if(alert(user, "Remove the attached grant?", "Detach Grant", "Yes", "No") != "Yes")
		return
	attached_grant.forceMove(user.loc)
	user.visible_message(span_notice("[user] removes a grant from [src]."))
	attached_grant = null
	update_icon_state()

////////////////////////////////////////////////////////
///////////////////////////////////////////////// GRANTS
/*
	people use these to get money into a faction's vault
	coin -> paper
	signet ring -> coin-filled paper (now called a grant)
	grant -> HERMES
*/
/obj/item/grant
	name = "grant"
	desc = "A monetary grant, prepared for transfer to a distant estate. \n \
	<span style='color:#e8bf67'>FILL:</span> Fill the grant with coins. \n \
	<span style='color:#e8bf67'>FINALIZE:</span> Use a tallowed signet ring to seal it for delivery. \n \
	<span style='color:#e8bf67'>SEND:</span> Stuff a sealed grant into a HERMES or attach it to an import writ. \n \
	<span style='color:#e8bf67'>CANCEL:</span> Activate to cancel and retrieve your coins. \n \
	"
	icon = 'icons/roguetown/clothing/storage.dmi'
	mob_overlay_icon = null
	icon_state = "pouch"
	item_state = "pouch"
	w_class = WEIGHT_CLASS_BULKY // we don't want people using these as Mega Coin Pouches

	var/grant_amount = 0
	var/sealed = FALSE
	var/datum/territory_faction/target_faction
	var/max_coin_items = 10

/obj/item/grant/proc/update_name()
	if(sealed)
		name = "sealed grant ([grant_amount] mammon)"
	else
		name = "unsealed grant ([grant_amount] mammon)"

/obj/item/grant/attackby(obj/item/P, mob/user, params)
	if(sealed)
		to_chat(user, span_warning("This grant is already sealed!"))
		return
	if(istype(P, /obj/item/roguecoin))
		var/obj/item/roguecoin/C = P
		var/coin_value = C.get_real_price()
		if(coin_value <= 0)
			to_chat(user, span_warning("These coins have no value."))
			return
		if(contents.len >= max_coin_items)
			to_chat(user, span_warning("This grant is full! It can only hold [max_coin_items] different coin stacks."))
			return
		if(!user.transferItemToLoc(C, src))
			return
		grant_amount += coin_value
		update_name()
		playsound(src, 'sound/foley/coins1.ogg', 100, TRUE, -2)
		to_chat(user, span_notice("Added [coin_value] mammon to the grant. Total: [grant_amount] mammon."))
		return
	
	if(istype(P, /obj/item/clothing/ring/signet))
		var/obj/item/clothing/ring/signet/ring = P
		if(!ring.tallowed)
			to_chat(user, span_warning("This ring needs to be tallowed first."))
			return
		return seal_grant(user)

	if(istype(P, /obj/item/scomstone/garrison))
		return seal_grant(user)
	
	return ..()

/obj/item/grant/attack_self(mob/user)
	if(alert(user, "Cancel this grant and retrieve [grant_amount] mammon?", "Cancel Grant", "Yes", "No") != "Yes")
		return
	user.visible_message(span_warning("[user] cancels the grant."))
	for(var/obj/item/roguecoin/C in contents)
		C.forceMove(user.loc)
		playsound(src, 'sound/foley/coins1.ogg', 100, TRUE, -2)
	qdel(src)

/obj/item/grant/proc/seal_grant(mob/user)
	if(!user.mind)
		if(user)
			to_chat(user, span_warning("I am by no means in any state to be handling finances."))
		return
	
	var/list/available_factions = list()

	for(var/datum/territory_faction/faction in user.mind.associated_factions)
		if(!(faction in available_factions))
			available_factions[faction.name] = faction
	
	if(!available_factions.len)
		to_chat(user, span_warning("I have no factions to send this grant to."))
		return
	
	var/chosen_faction = input(user, "Select a faction to receive this grant:", "Seal Grant") as null|anything in available_factions
	if(!chosen_faction)
		return
	
	target_faction = available_factions[chosen_faction]
	sealed = TRUE
	update_name()
	to_chat(user, span_notice("I seal the grant for delivery to [target_faction.name]."))

#undef MATERIAL_GOODS
#undef ALL_GOODS
