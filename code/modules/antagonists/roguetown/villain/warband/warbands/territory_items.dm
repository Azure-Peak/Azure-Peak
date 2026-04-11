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
	var/import_location // a string. this'll either be "City Docks" or "Groveside"
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
	<span style='color:#e8bf67'>SEND:</span> Stuff a sealed grant into a HERMES or attach it to an Import Writ. \n \
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


// turns a sheet of paper into an import writ for a faction's vault
/obj/item/paper/proc/create_import_writ(mob/living/user, obj/item/grant/grant)
	if(!user.mind)
		return

	var/list/available_territories = list()
	var/list/territory_to_faction = list()
	var/import_amount = 0

	if(grant)
		if(!grant.target_faction)
			to_chat(user, span_warning("This grant has no designated authority."))
			return
		
		import_amount = grant.grant_amount
		
		for(var/datum/territory/estate in grant.target_faction.territories)
			available_territories[estate.name] = estate
			territory_to_faction[estate.name] = grant.target_faction
	else
		for(var/datum/territory_faction/faction in user.mind.associated_factions)
			if(faction.owner == user.real_name || faction.job_owner == user.job_path)
				for(var/datum/territory/estate in faction.territories)
					if(!(estate.name in available_territories))
						available_territories[estate.name] = estate
						territory_to_faction[estate.name] = faction

	if(!available_territories.len)
		var/error_msg = grant ? "[grant.target_faction.name] has no territories to import from." : "I have no territories to import from."
		to_chat(user, span_warning(error_msg))
		return

	var/chosen_territory = input(user, "Select a territory to import from:", "Import Writ") as null|anything in available_territories
	if(!chosen_territory)
		return
	
	var/datum/territory/selected_estate = available_territories[chosen_territory]
	var/datum/territory_faction/controlling_faction = territory_to_faction[chosen_territory]
	if(!selected_estate)
		return
	
	if(!grant) // if there's no grant, we'll be dealing with the faction's vault
		// vault balance (treasury for Grand Duchy, faction vault for others)
		var/available_funds = 0
		if(controlling_faction)
			if(istype(controlling_faction, /datum/territory_faction/azure))
				available_funds = SStreasury.treasury_value
				to_chat(user, span_notice("The treasury has [available_funds] mammon."))
			else 
				available_funds = controlling_faction.vault
				to_chat(user, span_notice("[controlling_faction.name] has [available_funds] mammon in its vault."))
		
		import_amount = input(user, "How much mammon should be spent? (Available: [available_funds])", "Import Writ") as null|num
		if(!import_amount || import_amount <= 0)
			return
		import_amount = round(import_amount)
		if(import_amount > available_funds)
			to_chat(user, span_warning("Insufficient funds."))
			return
	else
		to_chat(user, span_notice("Using grant value of [import_amount] mammon."))

	var/delivery_location = alert(user, "Select delivery location:", "Import Writ", "City Docks (High Toll)", "Groveside (No Toll)", "Cancel")
	if(!delivery_location || delivery_location == "Cancel")
		return
	
	var/obj/item/import_writ/writ = new /obj/item/import_writ(grant ? get_turf(src) : src)
	writ.territory_name = chosen_territory
	writ.import_amount = import_amount
	writ.import_location = delivery_location
	writ.issuing_faction = controlling_faction
	writ.sealed = TRUE

	if(grant)
		if(!user.transferItemToLoc(grant, writ))
			to_chat(user, span_warning("I couldn't attach the grant!"))
			qdel(writ)
			return
		writ.attached_grant = grant
		writ.update_icon_state()
		to_chat(user, span_notice("I have drafted an import writ for [import_amount] mammon from [chosen_territory], with the grant attached."))
	else
		to_chat(user, span_notice("I have drafted an import writ for [import_amount] mammon worth of goods from [chosen_territory]."))
	
	user.put_in_hands(writ)
	qdel(src)
