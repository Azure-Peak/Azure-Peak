// FLORID RECIPES: turn plants into other plants
/datum/transmutation_recipe/florid
	abstract_type = /datum/transmutation_recipe/florid
	name = "Base Florid Recipe"
	category = "Florid Transmutation"
	catalyst = /obj/item/alch/catalyst/florid

/datum/transmutation_recipe/florid/fiber_to_grain
	name = "Fiber Sanguination (Grain)"
	materia_aspects = list(/datum/materia_aspect/plant)
	input_items = list(/obj/item/natural/fibers = 4)
	output_items = list(/obj/item/reagent_containers/food/snacks/grown/wheat = 1)

/datum/transmutation_recipe/florid/grain_to_fibers
	name = "Grain Raefication (Fibers)"
	materia_aspects = list(/datum/materia_aspect/air)
	input_items = list(/obj/item/reagent_containers/food/snacks/grown/wheat = 1)
	output_items = list(/obj/item/natural/fibers = 3)

/datum/transmutation_recipe/florid/grain_to_westleach
	name = "Grain Sanguination (Westleach)"
	materia_aspects = list(/datum/materia_aspect/herb)
	input_items = list(/obj/item/reagent_containers/food/snacks/grown/wheat = 2)
	output_items = list(/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed = 1)

/datum/transmutation_recipe/florid/westleach_to_grain
	name = "Westleach Raefication (Grain)"
	materia_aspects = list(/datum/materia_aspect/plant)
	input_items = list(/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed = 1)
	output_items = list(/obj/item/reagent_containers/food/snacks/grown/wheat =  1)

/datum/transmutation_recipe/florid/berry_to_apple
	name = "Jacksberry Sanguination (Apple)"
	materia_aspects = list(/datum/materia_aspect/plant)
	input_items = list(/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 2)
	output_items = list(/obj/item/reagent_containers/food/snacks/grown/apple = 1)

/datum/transmutation_recipe/florid/apple_to_berry
	name = "Apple Raefication (Jacksberry)"
	materia_aspects = list(/datum/materia_aspect/air)
	input_items = list(/obj/item/reagent_containers/food/snacks/grown/apple = 1)
	output_items = list(/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 1)

/datum/transmutation_recipe/florid/soap
	name = "Herb Saponification (Herbal Soap)"
	materia_aspects = list(/datum/materia_aspect/herb)
	input_items = list(/obj/item/soap = 1)
	output_items = list(/obj/item/soap/bath = 1) // this adds no particular value other than vibes™
	unique_sellable = TRUE

/datum/transmutation_recipe/florid/mutationcatalyst
	name = "Mutatio Substantuation (Transformative Reagent)"
	materia_aspects = list(/datum/materia_aspect/change)
	input_items = list(/obj/item/alch/hypericum = 1, /obj/item/alch/salvia = 1, /obj/item/alch/taraxacum = 1) // yes, it's evil sui dust
	output_items = list(/obj/item/mutation_reagent = 1)

// TERRAN RECIPES: earthen material recipes, not including metals
/datum/transmutation_recipe/terran
	abstract_type = /datum/transmutation_recipe/terran
	name = "Base Terran Recipe"
	category = "Terran Transmutation"
	catalyst = /obj/item/alch/catalyst/terran

/datum/transmutation_recipe/terran/stone
	name = "Clay Petrification (Stone)"
	materia_aspects = list(/datum/materia_aspect/earth)
	input_items = list(/obj/item/natural/clay = 2)
	output_items = list(/obj/item/natural/stone = 2) // you need either 3 clay or 2 clay and a rock for this - so you get 2 outputs, still a loss

/datum/transmutation_recipe/terran/clay
	name = "Stone Plasticization (Clay)" // from plasticity, the "defining mechanical property of clay" (thanks wikipedia)
	materia_aspects = list(/datum/materia_aspect/water)
	input_items = list(/obj/item/natural/stone = 2)
	output_items = list(/obj/item/natural/clay = 2)

/datum/transmutation_recipe/terran/moreclay
	name = "Dirt Plasticization (Clay)"
	materia_aspects = list(/datum/materia_aspect/water)
	input_items = list(/obj/item/natural/dirtclod = 2)
	output_items = list(/obj/item/natural/clay = 2)

/datum/transmutation_recipe/terran/dirt
	name = "Clay Dehydration (Dirt)"
	materia_aspects = list(/datum/materia_aspect/fire)
	input_items = list(/obj/item/natural/clay = 2)
	output_items = list(/obj/item/natural/dirtclod = 2)

/datum/transmutation_recipe/terran/dirtbulk
	name = "Stone Weathering (Dirt)"
	materia_aspects = list(/datum/materia_aspect/earth)
	input_items = list(/obj/item/natural/stone = 3)
	output_items = list(/obj/item/natural/dirtclod = 8)

/datum/transmutation_recipe/terran/coal
	name = "Stone Carbonization (Coal)"
	materia_aspects = list(/datum/materia_aspect/earth)
	input_items = list(/obj/item/natural/stone = 3) // old recipe was 4 rocks to 1 coal, you can do this in the same - adds up with their sellprices
	output_items = list(/obj/item/rogueore/coal = 1)

/datum/transmutation_recipe/terran/boulder
	name = "Stone Agglomeration (Boulder)"
	materia_aspects = list(/datum/materia_aspect/earth)
	input_items = list(/obj/item/natural/stone = 3)
	output_items = list(/obj/item/natural/rock = 1)

// AENEIC RECIPES: metal recipes, not including silver or gold
/datum/transmutation_recipe/aeneic
	abstract_type = /datum/transmutation_recipe/aeneic
	name = "Base Aeneic Recipe"
	category = "Aeneic Transmutation"
	catalyst = /obj/item/alch/catalyst/aeneic

/datum/transmutation_recipe/aeneic/iron
	name = "Ferropoeia (Iron)" // is this mixing greek and latin? yes. deal with it
	materia_aspects = list(/datum/materia_aspect/metal)
	input_items = list(/obj/item/rogueore/coal = 2) // need iron to make iron, so this is effectively the old 2 coal : 1 iron ratio which adds up given their sellprices
	output_items = list(/obj/item/rogueore/iron = 2)

/datum/transmutation_recipe/aeneic/copper
	name = "Chalkóspoeia (Copper)" // this one is entirely greek, because i like making nerds uncomfortable
	materia_aspects = list(/datum/materia_aspect/change)
	input_items = list(/obj/item/natural/stone = 4) // 4 stone 1 clay = 6 mammon, same sellprice as 1 copper ore
	output_items = list(/obj/item/rogueore/copper = 1)

/datum/transmutation_recipe/aeneic/tin
	name = "Kassiteropoeia (Tin)" // tee hee
	materia_aspects = list(/datum/materia_aspect/mundane)
	input_items = list(/obj/item/natural/stone = 6) // tin ore is 7 so you need to feed it more rocks, dirt price assumed to be 1 mam since it's like a rock [citation needed]
	output_items = list(/obj/item/rogueore/tin = 1)

// CHRYSOPOEIA: a great work, creating alchemical gold; catalyst is difficult to make
/datum/transmutation_recipe/chrysopoeia
	name = "Chrysopoeia (Gold)"
	category = "Chrysopoeic Transmutation"
	catalyst = /obj/item/alch/catalyst/chrysopoeia
	materia_aspects = list(/datum/materia_aspect/solar)	// this _technically_ creates value - 32 sellprice of iron, 10 for the zenar for solar materia
	input_items = list(/obj/item/rogueore/iron = 4)		// means you get 8 mammons out of nothing, except you can't buy iron that cheap so it's not econ exploit
	output_items = list(/obj/item/rogueore/gold = 1) 	// the actual use of this is gilbranze production for high-level artifice in mgl3pt2

// ARGYROPOEIA: an explicitly Noccite work, the catalyst is _impossible_ to create. it's adminspawn-only for now
// and will remain an extremely rare Noccite artifact once a way to obtain it is added in part 2 of mgl3
/datum/transmutation_recipe/argyropoeia
	name = "Argyropoeia (Silver)"
	category = "Argyropoeic Transmutation"
	snowflake_desc = "Can only be performed at nite."
	catalyst = /obj/item/alch/catalyst/argyropoeia
	materia_aspects = list(/datum/materia_aspect/lunar)
	input_items = list(/obj/item/rogueore/gold = 2)		// you are actively losing value here since gold is 50 mams each and silver is 80 not to mention the materia cost
	output_items = list(/obj/item/rogueore/silver = 1)

/datum/transmutation_recipe/argyropoeia/execution_blocked(mob/user) // also you can only do it at nite because noccite ritual and whatnot
	if(GLOB.tod != "night")
		return "This work of Noc may only be performed while His light shines."
	return FALSE

// NIGREDO: lit. 'blackening'. the first stage of the great work, its recipes follow a theme of decomposition and are irreversable
/datum/transmutation_recipe/nigredo
	abstract_type = /datum/transmutation_recipe/nigredo
	name = "Base Nigredo Recipe"
	category = "Nigredic Transmutation"
	catalyst = /obj/item/alch/catalyst/nigredo
	materia_aspects = list(/datum/materia_aspect/fire) // most of these recipes use ignis so we set it here

/datum/transmutation_recipe/nigredo/albedo_precursor
	name = "Pure Materia (Precursor to Albedo Catalyst)"
	category = "Magnum Opus"
	materia_aspects = list(/datum/materia_aspect/lunar) // outlier
	input_items = list(/obj/item/alch/nigredo_precursor = 1, /obj/item/alch/puresalt = 1)
	output_items = list(/obj/item/alch/albedo_precursor = 3) // one for a catalyst, one to take up the chain, one for...?

/datum/transmutation_recipe/nigredo/soap
	name = "Fat Saponification (Soap)"
	output_items = list(/obj/item/soap = 1)	// kris get the nigredo catalyst
	input_items = list(/obj/item/reagent_containers/food/snacks/fat = 1, /obj/item/reagent_containers/powder/salt = 1) // sodium.
	unique_sellable = TRUE

/datum/transmutation_recipe/nigredo/ash_bulk // nigredo fuels your other experiments' ash needs better than fire
	name = "Alchemical Combustion (Ash)"
	input_items = list(/obj/item/natural/bundle)
	output_items = list(/obj/item/ash = 12) // twice as effective than fire, in fact

/datum/transmutation_recipe/nigredo/ash_bulk/validate_ingredient(obj/item/I)
	if(!istype(I, /obj/item/natural/bundle))
		return FALSE
	var/obj/item/natural/bundle/B = I // takes fibers, silk, cloth, etc
	if(B.amount != B.maxamount)
		return FALSE
	return TRUE

/datum/transmutation_recipe/nigredo/smelt_decomposition
	name = "Nigredic Decomposition"
	input_items = list(/obj/item = 1)
	output_items = list(/obj/item/ingot = 1) // dummy

/datum/transmutation_recipe/nigredo/smelt_decomposition/validate_ingredient(obj/item/I)
	return I.smeltresult && (I.smeltresult != I.type) // anything that can be smelted will work here... as long as it's not a loop

/datum/transmutation_recipe/nigredo/smelt_decomposition/create_outputs(mob/user, list/ingredients, list/materia_ingredients, obj/structure/fluff/alch/trans/parent)
	for(var/obj/item/I in materia_ingredients)
		qdel(I)
	var/alch_exp = user.get_skill_level(/datum/skill/craft/alchemy) // 0 to 6
	var/quality = SMELTERY_LEVEL_SPOIL
	for(var/obj/item/I in ingredients)
		user.visible_message(span_notice("[user] decomposes [I] into its fundamental components!"), span_notice("I decompose [I], salvaging its component material!"))
		var/obj/item/res = new I.smeltresult(parent.loc)
		if(istype(res, /obj/item/ingot))
			if(alch_exp < 6)
				quality = min(6, floor(rand(alch_exp*15 + 10, max(30, alch_exp*25))/25)+1) // Math explained below
			else
				quality = 6 // Guarantees a return of 6 no matter how extra experience past 3000 you have.
			var/obj/item/ingot/ing = res
			ing.apply_smelt_quality(quality)
		var/datum/component/unsellable/unsellable = I.GetComponent(/datum/component/unsellable)
		if(unsellable) // unlike most alchemy recipes, this ONLY applies unsellable if the input was unsellable - this is because it's not really transmutation, you're just smelting stuff cutely (this code is 90% equivalent to an ore furnace)
			res.AddComponent(/datum/component/unsellable, unsellable.reason)
		res.was_crafted = TRUE
		res.OnCrafted(get_dir(user, parent), user)
		res.add_fingerprint(user)
		qdel(I)

/datum/transmutation_recipe/nigredo/smelt_decomposition/generate_html(mob/user)
	var/client/client = user
	if(!istype(client))
		client = user.client
	user << browse_rsc('html/book.png')
	var/html = {"
		<!DOCTYPE html>
		<html lang="en">
		<meta charset='UTF-8'>
		<meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'/>
		<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'/>
		<body>
		  <div>
		    <h1>[name]</h1>
		"}

	html += "Requires [SSskills.level_names_plain[skill_required]] alchemy skills.<br>"

	html += "Requires [a_or_an(catalyst::name)] [icon2html(catalyst::icon, user, catalyst::icon_state)][catalyst::name], which is not consumed.<br>"

	if(snowflake_desc)
		html += "[snowflake_desc]<br>"

	html += "<br>"
	if(input_items.len)
		html += "<br><div><<strong>Consumes any input that can be smelted. Produces its smelted form.</strong><br>"
		html += "<strong>The output is only unsellable if the input is. The quality, and therefore the value, depends on your alchemy skill.</strong> <br>"
		html += "</div><br>"

	if(materia_aspects.len)
		html += "<div><strong>Requires any item(s) with the following aspect[(materia_aspects.len > 1) ? "s" : ""]:</strong><ul>"
		for(var/path as anything in materia_aspects)
			if(ispath(path, /datum/materia_aspect))
				var/datum/materia_aspect/aspect = path
				html += "<li>[aspect::name]: [aspect::desc]</li>"
		html += "</ul></div>"

	var/obj/structure/fluff/alch/trans/transpath = /obj/structure/fluff/alch/trans
	html += "<strong>Start the process at a</strong> [icon2html(transpath::icon, user, transpath::icon_state)][transpath::name]."

	html += {"
		</div>
		</div>
	</body>
	</html>
	"}
	return html

/datum/transmutation_recipe/nigredo/smelt_decomposition/build_display_cache()
	var/list/data = list()
	data["name"] = name
	data["ref"] = "[REF(src)]"
	data["path"] = type
	data["catalyst"] = catalyst::name

	data["input_text"] = "One of any smeltable item."

	data["output_text"] = "Its smelted form; quality scales with alchemy skill."

	var/list/materia_display = list()
	for(var/a in materia_aspects)
		var/datum/materia_aspect/aspect = a
		materia_display[aspect::name] = aspect::desc
	data["materia_reqs"] = materia_display

	if(skill_required)
		data["craftingdifficulty"] = "[SSskills.level_names_plain[skill_required]]."

	cached_display_data = data

/datum/transmutation_recipe/nigredo/viscera
	name = "Protein Decomposition (Viscera)"
	input_items = list(/obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef = 2)
	output_items = list(/obj/item/alch/viscera = 1) // alchemical meatgrinder, how miraculous

/datum/transmutation_recipe/nigredo/moreviscera
	name = "Mass Protein Decomposition (Viscera)"
	input_items = list(/obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef = 6)
	output_items = list(/obj/item/alch/viscera = 3) // i guess we had two of these recipes for some reason?

/datum/transmutation_recipe/nigredo/bronze_decomposition
	name = "Bronze Decomposition"
	input_items = list(/obj/item/ingot/bronze = 2)
	output_items = list(/obj/item/rogueore/copper = 1, /obj/item/rogueore/tin = 1)

// ALBEDO: lit 'whitening'. the second stage of the great work, its recipes follow a theme of purification and are irreversable
/datum/transmutation_recipe/albedo
	abstract_type = /datum/transmutation_recipe/albedo
	name = "Base Albedo Recipe"
	category = "Albedic Transmutation"
	catalyst = /obj/item/alch/catalyst/albedo
	materia_aspects = list(/datum/materia_aspect/lunar) // best representation of purity we have - adds a ~5m tax at minimum to most of these recipes

/datum/transmutation_recipe/albedo/xanthosis_precursor
	name = "Potent Materia (Precursor to Xanthosis Catalyst)"
	category = "Magnum Opus"
	materia_aspects = list(/datum/materia_aspect/arcyne) // outlier
	input_items = list(/obj/item/alch/albedo_precursor = 1, /obj/item/roguegem/amethyst = 1)
	output_items = list(/obj/item/alch/xanthosis_precursor = 2) // one for a catalyst, one to take up the chain

/datum/transmutation_recipe/albedo/cinnabar // enchanters love this one simple trick
	name = "Cinnabar Purification"
	input_items = list(/obj/item/rogueore/iron = 1, /obj/item/rogueore/coal = 1) // 8 + 4 = 12, +5m materia tax = 17, higher than buying from stockpile
	output_items = list(/obj/item/rogueore/cinnabar = 1)

/datum/transmutation_recipe/albedo/catalyzation_reagent // also you can make not-feydust more efficiently now
	name = "Ash Harmonization (Catalyzation Reagent)"
	input_items = list(/obj/item/ash = 3, /obj/item/storage/roguebag = 1)
	output_items = list(/obj/item/storage/roguebag/trans = 1)

/datum/transmutation_recipe/albedo/bathbombsalvia // look at me. i'm the bathhouse's supplier now
	name = "Herbal Materia Rendition (Alchemical Diffuser)"
	input_items = list(/obj/item/alch/salvia = 1, /obj/item/reagent_containers/powder/salt = 1)
	output_items = list(/obj/item/alchemical_bathbomb = 1)
	materia_aspects = list(/datum/materia_aspect/herb)
	unique_sellable = TRUE // it's bath salts

/datum/transmutation_recipe/albedo/bathbombrosa // and one more for the fans
	name = "Floral Materia Rendition (Alchemical Diffuser)"
	input_items = list(/obj/item/alch/rosa = 1, /obj/item/reagent_containers/powder/salt = 1)
	output_items = list(/obj/item/alchemical_bathbomb/rosa = 1)
	materia_aspects = list(/datum/materia_aspect/herb)
	unique_sellable = TRUE // it's bath salts again

/datum/transmutation_recipe/albedo/salt
	name = "Fat Salination" // usually means applying salt to something, but also refers to the increase of salt content in soil!
	materia_aspects = list(/datum/materia_aspect/water)
	input_items = list(/obj/item/ash = 1, /obj/item/reagent_containers/food/snacks/fat = 1) // this arguably creates value but it's not mass-producable - much less worth your time than selling random things to the navigator
	output_items = list(/obj/item/reagent_containers/powder/salt = 1)

/datum/transmutation_recipe/albedo/altsalt
	name = "Mince Salination"
	materia_aspects = list(/datum/materia_aspect/water)
	input_items = list(/obj/item/ash = 1, /obj/item/reagent_containers/food/snacks/rogue/meat/mince = 1)
	output_items = list(/obj/item/reagent_containers/powder/salt = 1)

// XANTHOSIS: lit 'yellowing'. the third stage of the great work, its recipes folow a theme of enhancement and are irreversable
/datum/transmutation_recipe/xanthosis
	abstract_type = /datum/transmutation_recipe/xanthosis
	name = "Base Xanthosis Recipe"
	category = "Xanthotic Transmutation"
	catalyst = /obj/item/alch/catalyst/xanthosis
	materia_aspects = list(/datum/materia_aspect/arcyne) // default bcs of gem uptiering

/datum/transmutation_recipe/xanthosis/rubedo_precursor
	name = "Harmonic Materia (Precursor to Rubedo Catalyst)"
	category = "Magnum Opus"
	materia_aspects = list(/datum/materia_aspect/aalloy) // the ultimate alchemy, the ultimate heresy. all roads lead to an enigma lost to time.
	input_items = list(/obj/item/alch/albedo_precursor = 1, /obj/item/alch/xanthosis_precursor = 1) // the culmination of your work, yet the result resembles naught before it
	output_items = list(/obj/item/alch/rubedo_precursor = 1) // and so thy work is done... what? it isn't? such is the nature of a scholar, indeed!

/datum/transmutation_recipe/xanthosis/coal
	name = "Coal Platonization"
	materia_aspects = list(/datum/materia_aspect/earth)
	input_items = list(/obj/item/alch/coaldust = 3)
	output_items = list(/obj/item/rogueore/coal = 1) // all dust ungrinding recipes are value-negative because of the materia cost

/datum/transmutation_recipe/xanthosis/iron
	name = "Iron Platonization"
	materia_aspects = list(/datum/materia_aspect/earth)
	input_items = list(/obj/item/alch/irondust = 3)
	output_items = list(/obj/item/rogueore/iron = 1) // all dust ungrinding recipes are value-negative because of the materia cost

/datum/transmutation_recipe/xanthosis/gold
	name = "Gold Platonization"
	materia_aspects = list(/datum/materia_aspect/earth)
	input_items = list(/obj/item/alch/golddust = 3)
	output_items = list(/obj/item/rogueore/gold = 1) // all dust ungrinding recipes are value-negative because of the materia cost

/datum/transmutation_recipe/xanthosis/silver
	name = "Silver Platonization"
	materia_aspects = list(/datum/materia_aspect/earth)
	input_items = list(/obj/item/alch/silverdust = 3)
	output_items = list(/obj/item/rogueore/silver = 1) // all dust ungrinding recipes are value-negative because of the materia cost

/datum/transmutation_recipe/xanthosis/toper
	name = "Toper Harmonization"
	input_items = list(/obj/item/rogueore/gold = 1, /obj/item/roguegem/amethyst = 1) // gold is 50, toper is 34 - not to mention the amythorz
	output_items = list(/obj/item/roguegem/yellow)

/datum/transmutation_recipe/xanthosis/gemerald
	name = "Gemerald Harmonization"
	input_items = list(/obj/item/roguegem/yellow = 1) // toper sells for 34, gemerald is 42 - adding a minimum of 10 mammons for solaris you're left with a 2 mammon loss
	materia_aspects = list(/datum/materia_aspect/solar, /datum/materia_aspect/arcyne)
	output_items = list(/obj/item/roguegem/green)

/datum/transmutation_recipe/xanthosis/saffira
	name = "Saffira Harmonization"
	input_items = list(/obj/item/roguegem/green = 1) // gemerald is 42 mammons, saffira 56; add 10 for the cheapest source of solaris, and you're only making 4 mammons at best
	materia_aspects = list(/datum/materia_aspect/solar, /datum/materia_aspect/arcyne)
	output_items = list(/obj/item/roguegem/blue)

/datum/transmutation_recipe/xanthosis/blortz
	name = "Blortz Harmonization"
	input_items = list(/obj/item/rogueore/gold = 1, /obj/item/roguegem/blue = 1) // gold is 50, saffira 56, blortz 88
	output_items = list(/obj/item/roguegem/turq)

/datum/transmutation_recipe/xanthosis/dorpel
	name = "Dorpel Harmonization"
	input_items = list(/obj/item/rogueore/gold = 1, /obj/item/roguegem/turq = 1) // gold is 50, blortz 88, dorpel 121. only a 17 mammon loss this time. hooray? you're almost there
	output_items = list(/obj/item/roguegem/diamond)

// RUBEDO: lit 'reddening'. the final stage of the great work, its recipes unite the spiritual and physical to create potent alchemical reagents
// with a divine resonance; also riddle of steel is here bcs malum!
/datum/transmutation_recipe/rubedo
	abstract_type = /datum/transmutation_recipe/rubedo
	name = "Base Rubedo Recipe"
	category = "Rubedic Transmutation"
	catalyst = /obj/item/alch/catalyst/rubedo

// this one TECHNICALLY creates value if you're very savvy - about 50 mammons. however, it's a legendary recipe, locked behind a difficult catalyst,
// and the prerequisites are actively harder to get with alchemy than through the economy. this is here as a badge of honor for a true alchemist,
// like it was in the olden daes where apprentices would be tasked with it as a final test to prove themselves worthy of the rank of associate.
// quick calcs: it takes 300 mammons (sellprice, so actually more) of gold, an amythorz, a bunch of manabloom, and at least 40 mammons of materia-sources
// for the cheapest-possible alchemical path to this. you're not powergaming this shit
/datum/transmutation_recipe/rubedo/riddlesteel
	name = "Resolution of a Steel'd Enigma"
	input_items = list(/obj/item/roguegem/diamond = 2, /obj/item/rogueore/gold = 2)
	skill_required = SKILL_LEVEL_LEGENDARY
	output_items = list(/obj/item/riddleofsteel = 1)

/datum/transmutation_recipe/rubedo/nitevision
	name = "Lunar Quintessence"
	materia_aspects = list(/datum/materia_aspect/lunar)
	input_items = list(/obj/item/alch/mentha = 1, /obj/item/alch/matricaria = 1) // per potion ingredients, plus the lunar aspect = noc potion
	output_items = list(/obj/item/alch/rubedo_reagent/nitevision = 1)

/datum/transmutation_recipe/rubedo/sleepdraught
	name = "Nocturnal Grace"
	materia_aspects = list(/datum/materia_aspect/lunar)
	input_items = list(/obj/item/alch/sleep_powder = 1, /obj/item/alch/briar_essence = 1) // sleep poison ingredients, purified with silver
	output_items = list(/obj/item/alch/rubedo_reagent/sleepdraught = 1)

/datum/transmutation_recipe/rubedo/waterbreathing
	name = "Call of the Abyss"
	materia_aspects = list(/datum/materia_aspect/water)
	input_items = list(/obj/item/alch/ozium = 1, /obj/item/alch/seeddust = 1) // strong stam potion ingredients, plus abyssor's blessing
	output_items = list(/obj/item/alch/rubedo_reagent/waterbreathing = 1)

/datum/transmutation_recipe/rubedo/nitevision
	name = "Nature's Provision"
	materia_aspects = list(/datum/materia_aspect/animal)
	input_items = list(/obj/item/alch/earthdust = 1, /obj/item/alch/bone = 1) // con potion ingredients, plus dendor's blessing
	output_items = list(/obj/item/alch/rubedo_reagent/nutrientslurry = 1)

/datum/transmutation_recipe/rubedo/ravenous
	name = "Feral Nature"
	materia_aspects = list(/datum/materia_aspect/animal) // gee dendor, how come your mom lets you have two rubedo potions?
	input_items = list(/obj/item/alch/viscera = 1, /obj/item/alch/atropa = 1) // disgusting combo, plus dendor's blessing
	output_items = list(/obj/item/alch/rubedo_reagent/ravenous = 1)

/datum/transmutation_recipe/rubedo/antidepressants
	name = "Lady's Mercy" // which lady? you could pass it off as eoran, but let's be real. welcome to the baotha zone
	materia_aspects = list(/datum/materia_aspect/air)
	input_items = list(/obj/item/alch/ozium = 1, /obj/item/alch/swampdust = 1) // lady of heartbreak, ease my burdens!
	output_items = list(/obj/item/alch/rubedo_reagent/antidepressants = 1)

/datum/transmutation_recipe/rubedo/wyrdlaborer // it's fucking dendor agai- what? this one's malum? oh, ok
	name = "Steelbound Might"
	materia_aspects = list(/datum/materia_aspect/tool)
	input_items = list(/obj/item/alch/salvia = 1, /obj/item/alch/coaldust = 1) // str potion ingredients, plus fire for malum's blessing
	output_items = list(/obj/item/alch/rubedo_reagent/wyrdlaborer = 1)

/datum/transmutation_recipe/rubedo/prodepressants
	name = "Grave's Premonition"
	materia_aspects = list(/datum/materia_aspect/death)
	input_items = list(/obj/item/alch/mineraldust = 1, /obj/item/alch/atropa = 1) // doom poison ingredients, plus the weight of finality = necra's curse
	output_items = list(/obj/item/alch/rubedo_reagent/prodepressants = 1)

/datum/transmutation_recipe/rubedo/evilcaffiene
	name = "Boundless Effervescence"
	materia_aspects = list(/datum/materia_aspect/fire)
	input_items = list(/obj/item/alch/waterdust = 1, /obj/item/alch/matricaria = 1) // (strong) energy potion ingredients, plus fire for malum's curse
	output_items = list(/obj/item/alch/rubedo_reagent/evilcaffiene = 1)

/datum/transmutation_recipe/rubedo/singing
	name = "Weft of the Tragedian"
	materia_aspects = list(/datum/materia_aspect/air)
	input_items = list(/obj/item/alch/rosa = 1, /obj/item/alch/calendula = 1) // extremely innocuous ingredients, plus air for xylix's whimsy
	output_items = list(/obj/item/alch/rubedo_reagent/singing = 1)

/datum/transmutation_recipe/rubedo/funnyvoice
	name = "Weave of the Tragedian"
	materia_aspects = list(/datum/materia_aspect/air)
	input_items = list(/obj/item/bone = 1, /obj/item/alch/calendula = 1) // you know why.
	output_items = list(/obj/item/alch/rubedo_reagent/funnyvoice = 1)

/datum/transmutation_recipe/rubedo/mending
	name = "Careworn Respite"
	materia_aspects = list(/datum/materia_aspect/water)
	input_items = list(/obj/item/alch/rosa = 1, /obj/item/alch/symphitum = 1) // vaguely healing potion ingredients, plus water aspect = malum potio- the fuck you mean this one's actually eoran
	output_items = list(/obj/item/alch/rubedo_reagent/mending = 1)

/datum/transmutation_recipe/rubedo/soap
	name = "Salving Embrace (Healing Soap)"
	materia_aspects = list(/datum/materia_aspect/water)
	input_items = list(/obj/item/alch/rosa = 1, /obj/item/alch/salvia = 1, /obj/item/soap = 1) // eoran herbs infused into soap. simple, but definitively eoran
	output_items = list(/obj/item/alch/rubedo_reagent/mending = 1)
	unique_sellable = TRUE
