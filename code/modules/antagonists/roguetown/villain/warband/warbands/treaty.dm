#define WARBAND_TERMS list(/datum/treaty/terms/codify_law, /datum/treaty/terms/remove_law, /datum/treaty/terms/freeze_laws, /datum/treaty/terms/set_tax/noble, \
							/datum/treaty/terms/set_tax/yeoman, /datum/treaty/terms/set_tax/peasant, /datum/treaty/terms/set_tax/church, /datum/treaty/terms/territory_loss, \
							/datum/treaty/terms/cointribute, /datum/treaty/terms/exile, /datum/treaty/terms/freeform)
//////////////////////////////////////////////////////////////
///////////////////////////////////////////////// TREATY PROCS
/*
	1 - ADD UNIQUE TERMS	// 
	2 - GET WEALTH			// 

*/





//////////// TERMS
/datum/treaty/terms
	var/name
	var/custom_name					// freeform terms can be renamed
	var/desc

	var/target	 					// the "source"
	var/receiver					// the "destination"
	var/obj_target					// the "object" / territory/object being moved

	var/target_options = 0			// 0 = no direct target | 1 = human target | 2 = territory target | 3 = faction target | 5 = faction territory/cede | 6 = open text target & receiver (mob or faction). not used atm | 7 = faction target & receiver 
	// don't ask what happened to target option number 4

	var/list/authorities = list()	// if a character's listed on a term as an authority, their signature is required.
	var/list/signatures = list()
	var/minimum_signatures = 1		// how many authorities need to sign a term before it's confirmed
	var/open_signatures = FALSE		// when this is true, a term will accept any signature
	var/hint						// when someone without Law Expert examines a treaty, they'll only get a vague idea about the terms involved
	var/warbandlock 				// certain terms can only be demanded by certain warbands
	var/signed = FALSE				// if a term has been signed
	var/text = ""					// for written text (e.g: new laws, freeform demands)
	var/number = 0 					// for numbers (e.g: new tax rates, money demands)
	var/requires_number = FALSE
	var/requires_text = FALSE
	var/datum/mind/author 			// the mind that drafted the term

//////////// CATEGORY: LAW
//////////////////////////
/datum/treaty/terms/codify_law
	name = "Codify Law"
	authorities = list("Grand Duke")
	desc = "A codified law cannot be removed."
	hint = "...something about codifying a law..."
	requires_text = TRUE

/datum/treaty/terms/remove_law
	name = "Abolish Law"
	authorities = list("Grand Duke", "Hand", "Marshal") // this can easily be reversed, so there's no real harm in letting the Hand & Marshal sign for it too
	desc = "An abolished law will be erased."
	hint = "...something about abolishing a law..."
	requires_number = TRUE

/datum/treaty/terms/freeze_laws
	name = "Freeze Laws"
	authorities = list("Grand Duke")
	desc = "No law can be instated or erased for the forseeable future."
	hint = "...something about something else getting frozen..."

//////////// CATEGORY: TAX
//////////////////////////
/datum/treaty/terms/set_tax/noble
	name = "Adjust Noble Tax"
	desc = "A tax rate established here shall remain for yils."
	authorities = list("Grand Duke")
	hint = "...something about taxes and the Nobility..."
	requires_number = TRUE

/datum/treaty/terms/set_tax/yeoman
	name = "Adjust Yeoman Tax"
	desc = "A tax rate established here shall remain for yils."
	authorities = list("Grand Duke")
	hint = "...something about Yeomen and taxes..."
	requires_number = TRUE

/datum/treaty/terms/set_tax/peasant
	name = "Adjust Peasantry Tax"
	desc = "A tax rate established here shall remain for yils."
	authorities = list("Grand Duke")
	hint = "...something about the peasantry's tax rate..."
	requires_number = TRUE

/datum/treaty/terms/set_tax/church
	name = "Adjust Church Tax"
	desc = "A tax rate established here shall remain for yils."
	authorities = list("Grand Duke", "Bishop")
	hint = "...something about taxes and the Church..."
	requires_number = TRUE

//////////// CATEGORY: COIN & TERRITORY
///////////////////////////////////////
/datum/treaty/terms/territory_loss
	name = "Cede Territory"
	desc = "Cede an entire territory"
	target_options = 5
	hint = "...something about ceding some territory."
	authorities = list("faction owner")

/datum/treaty/terms/cointribute
	name = "Mammon"
	desc = "A tribute of coin. Coin may be demanded at an excess beyond a target's coffers - at which point they are sunk into a deficit."
	hint = "...there's a few details about an exchange of mammon..."
	authorities = list("target")
	requires_number = TRUE
	target_options = 7

//////////// CATEGORY: MISC
///////////////////////////
/datum/treaty/terms/exile
	name = "Exile"
	authorities = list("target", "Bishop", "Grand Duke")
	desc = "Should daelight find the Exile within the city limits, they'll be lit ablaze."
	hint = "...something regarding someone's exile..."
	minimum_signatures = 2
	target_options = 1

/datum/treaty/terms/freeform
	name = "Freeform"
	desc = "As written."
	hint = "...something I truly can't make heads or tails of..."
	requires_text = TRUE
	open_signatures = TRUE

//////////// CATEGORY: UNIQUE
/////////////////////////////
/datum/treaty/terms/unique/wizard
	name = "Acknowledge Superior Wizard"
	desc = "Admit the arcane superiority of the SORCERER-KING, henceforth and forever."
	warbandlock = /datum/warbands/storyteller/wizard
	authorities = list("Court Magician")
	hint = "...every other sentence is about how magnificent some wizard is.."

//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////


/obj/item/treaty
	name = "treaty"
	desc = "An aged scroll of parchment tightly bound by a ribbon. Across the ribbon, countless prayers to order are inscribed in a faded, crimson script. \
	It's a disquieting thing; warm to the touch as if one is holding sun-scorched leather, while being accompanied by a faint stench of blood and ash. \n \
	<span style='color:#e8bf67'>OPEN:</span> Unroll the treaty by resizing the window. \n \
	<span style='color:#e8bf67'>DRAFT:</span> Drafting a new term will unverify all verified terms. \n \
	<span style='color:#e8bf67'>FINALIZE:</span> Hurling a completed treaty into an open flame at dawn will finalize it. \n \
	<span style='color:#e8bf67'>SWIFT FINALIZE:</span> Invoke a Sacred Flame upon a completed treaty. \n \
	<span style='color:#ae1919'>BEWARE:</span> If a single term is unsigned, finalization will fail. Freeform terms are exceptions."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "scroll_closed"
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE

	// a treaty's "first party" and "second party" are just flavor. it's possible that none of the listed terms could apply to either of them
	var/firstparty						// the first party in the treaty
	var/secondparty						// the second party in the treaty

	var/list/terms = list()				// all potential terms
	var/list/active_terms = list()		// written terms
	var/list/warband_sources = list()	// treaties from certain warband & aspects can have unique terms



/obj/item/treaty/Initialize()
	..()
	for(var/term_option in WARBAND_TERMS)
		src.terms += new term_option
	SSwarbands.treaties += src

/obj/item/treaty/spark_act()
	fire_act() // ignite on contact with fire

// 1
//////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// ADD UNIQUE TERMS
/* 1
	when a treaty is spawned by a warband, this proc adds any unique terms the warband might have
*/
/obj/item/treaty/proc/add_unique_terms()
	for(var/source_name in warband_sources)
		if(source_name == "Sorcerer-King")
			src.terms += new /datum/treaty/terms/unique/wizard

// 2
////////////////////////////////////////////////////////////
///////////////////////////////////////////////// GET WEALTH
/* 2
	get a faction's vault for the treaty's "Wealth" display
	the town's faction vault is directly linked to its treasury
	for everyone else, it just returns the actual vault value from their faction datum
*/
/obj/item/treaty/proc/get_wealth(faction_name)
	if(faction_name == "The Crown")
		return SStreasury.treasury_value // the duchy faction's "vault" is connected to the treasury
	for(var/datum/territory_faction/faction in SSwarbands.territory_factions)
		if(faction.name == faction_name)
			return faction.vault
	return FALSE

/obj/item/treaty/attack_self(mob/user)
	src.ui_interact(user)

/obj/item/treaty/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/natural/feather))
		return attack_self(user)
	return ..()

/obj/item/treaty/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/treaty_icons)
	)

/obj/item/treaty/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TreatyMenu")
		ui.open()

/obj/item/treaty/ui_data(mob/user)
	var/list/data = ..()
	var/user_role = user.job
	var/user_name = user.real_name
	var/is_expert = HAS_TRAIT(user, TRAIT_LAWEXPERT) // full interface is locked without this trait
	data["user_name"] = user_name
	data["user_role"] = user_role
	data["is_expert"] = is_expert

	var/datum/asset/spritesheet/spritesheet = get_asset_datum(/datum/asset/spritesheet/treaty_icons)
	if(src.firstparty)
		for(var/datum/territory_faction/faction in SSwarbands.territory_factions)
			if(faction.name == src.firstparty)
				data["firstparty"] = list(
					"name" = faction.name,
					"desc" = faction.desc,
					"type" = faction.type,
					"icon" = spritesheet.icon_class_name(sanitize_css_class_name("factionicon_[REF(faction)]")),
					"territories" = faction.territories,
					"owner" = faction.owner,
					"vault" = get_wealth(faction.name)
				)
				break
	if(src.secondparty)
		for(var/datum/territory_faction/faction in SSwarbands.territory_factions)
			if(faction.name == src.secondparty)
				data["secondparty"] = list(
					"name" = faction.name,
					"desc" = faction.desc,
					"type" = faction.type,
					"icon" = spritesheet.icon_class_name(sanitize_css_class_name("factionicon_[REF(faction)]")),
					"territories" = faction.territories,
					"owner" = faction.owner,
					"vault" = get_wealth(faction.name)
				)
				break

	var/list/current_terms = list()
	if(src.active_terms)
		var/i = 1
		for(var/datum/treaty/terms/term in src.active_terms)
			var/display_name = is_expert ? (term.custom_name ? term.custom_name : term.name) : "???" // characters without law expert can't read terms properly
			var/display_desc = is_expert ? term.desc : term.hint
			UNTYPED_LIST_ADD(current_terms, list(
				"name" = display_name,
				"original_name" = term.name,
				"desc" = display_desc,
				"text" = term.text,
				"number" = term.number,
				"signed" = term.signed,
				"requires_text" = term.requires_text,
				"requires_number" = term.requires_number,
				"target_options" = term.target_options,
				"target" = term.target,
				"receiver" = term.receiver,
				"obj_target" = term.obj_target,
				"open_signatures" = term.open_signatures,
				"authorities" = term.authorities,
				"signatures" = term.signatures,
				"minimum_signatures" = term.minimum_signatures,
				"index" = i - 1
			))
			i++
	data["terms"] = current_terms

	return data


/obj/item/treaty/ui_static_data(mob/user)
	var/list/data = ..()
	var/datum/asset/spritesheet/spritesheet = get_asset_datum(/datum/asset/spritesheet/treaty_icons)

	var/list/land_list = list()
	for(var/datum/territory/land in SSwarbands.territory)
		var/current_faction_name
		if(land.associated_faction)
			current_faction_name = land.associated_faction.name
		var/list/aspect_data = list()
		if(land.aspects && islist(land.aspects))
			for(var/datum/territory/aspect/asp in land.aspects)
				if(istype(asp))
					aspect_data += list(list("name" = asp.name, "desc" = asp.desc))
		var/datum/goods/goodname
		if(land.prized_good)	
			goodname = land.prized_good.name
		UNTYPED_LIST_ADD(land_list, list(
			"name" = land.name,
			"desc" = land.desc,
			"prized_good" = goodname,
			"faction_name" = current_faction_name,
			"type" = land.type,
			"aspects" = aspect_data
		))
	data["backend_territories"] = land_list

	var/list/faction_list = list()
	for(var/datum/territory_faction/faction in SSwarbands.territory_factions)
		var/show_faction = FALSE
		if(faction.type in DEFAULT_TERRITORY_FACTIONS)
			show_faction = TRUE // show the faction in the treaty UI if it's a default faction
		else if (faction.owner == user.real_name)
			show_faction = TRUE // show it if the user's the owner
		else if(user.real_name in faction.member_names)
			show_faction = TRUE // show it if they're a member
		else if(src.firstparty == faction.name || src.secondparty == faction.name)
			show_faction = TRUE // show it if it's declared as a party
		if(show_faction)
			var/list/territory_names = list()
			for(var/datum/territory/land in faction.territories)
				territory_names += land.name
			UNTYPED_LIST_ADD(faction_list, list(
				"name" = faction.name,
				"desc" = faction.desc,
				"territories" = territory_names,
				"owner" = faction.owner,
				"job_owner" = faction.job_owner,
				"type" = faction.type,
				"icon" = spritesheet.icon_class_name(sanitize_css_class_name("factionicon_[REF(faction)]"))			
			))
	data["backend_factions"] = faction_list

	var/list/all_terms = list()
	for(var/datum/treaty/terms/term in src.terms)
		UNTYPED_LIST_ADD(all_terms, list(
			"name" = term.name,
			"desc" = term.desc,
			"hint" = term.hint,
			"text" = term.text,
			"number" = term.number,
			"signed" = term.signed,
			"requires_text" = term.requires_text,
			"requires_number" = term.requires_number,
			"open_signatures" = term.open_signatures,
			"target_options" = term.target_options,
		))
	data["all_terms"] = all_terms

	return data
/obj/item/treaty/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	var/mob/user = usr
	var/user_role = user.job
	var/user_name = user.real_name
	var/has_feather = FALSE
	if(istype(user.get_active_held_item(), /obj/item/natural/feather) || istype(user.get_inactive_held_item(), /obj/item/natural/feather))
		has_feather = TRUE // a quill needs to be held in either hand
	var/is_expert = HAS_TRAIT(user, TRAIT_LAWEXPERT)
	var/list/write_sounds = list(
		'sound/misc/warband/treaty_create.ogg',
		'sound/misc/warband/treaty1.ogg',
		'sound/misc/warband/treaty2.ogg'
	)
	var/chosen_sound = pick(write_sounds)

	// if a mind has a filled "original char" variable, they're an envoy of that character
	// when signing terms, envoys use the authority of that mob instead of their own
	var/original_role
	var/original_name
	if(user.mind?.original_char)
		var/mob/original = user.mind.original_char
		original_role = original.job
		original_name = original.real_name

	if(!has_feather)
		to_chat(user, span_warning("I should be holding a quill."))
		return FALSE
	if(!is_expert && action != "sign_term")
		to_chat(user, span_warning("I can't make heads or tails of this."))
		return FALSE
	switch(action)
		if("sign_term")
			var/term_index = text2num(params["index"]) + 1
			if(!term_index || term_index < 1 || term_index > src.active_terms.len)
				return
			var/datum/treaty/terms/term_to_sign = src.active_terms[term_index]
			if(term_to_sign.signed)
				to_chat(user, span_warning("It's already signed."))
				return
			if(user_name in term_to_sign.signatures)
				to_chat(user, span_warning("I've already signed this."))
				return
			var/is_authority = FALSE
			if(term_to_sign.open_signatures)
				is_authority = TRUE
			else
				var/list/auth_list = list()
				if(islist(term_to_sign.authorities))
					auth_list = term_to_sign.authorities
				else if(istext(term_to_sign.authorities))
					auth_list = list(term_to_sign.authorities)

				if(auth_list.Find(user_role))
					is_authority = TRUE

				if(!is_authority && original_role && auth_list.Find(original_role))
					is_authority = TRUE
				
				if(!is_authority)
					if(auth_list.Find("target")) // check if target matches the current name (or the original name, for envoys)
						if(term_to_sign.target == user_name || (original_name && term_to_sign.target == original_name))
							is_authority = TRUE
						else
							for(var/datum/territory_faction/faction in SSwarbands.territory_factions)
								if(faction.name == term_to_sign.target)
									if(istype(faction.owner, /mob) && faction.owner == user)
										is_authority = TRUE
									else if(faction.owner == user_name || (original_name && faction.owner == original_name))
										is_authority = TRUE
									else if(faction.job_owner == user_role || (original_role && faction.job_owner == original_role))
										is_authority = TRUE
									break
					if(term_to_sign.target_options == 5)  // territory transfer authority
						if(auth_list.Find("faction owner")) 
							for(var/datum/territory/estate in SSwarbands.territory)
								if(estate.name == term_to_sign.obj_target)
									var/datum/territory_faction/faction = estate.associated_faction
									if(!faction)
										for(var/datum/territory_faction/F in SSwarbands.territory_factions)
											if(estate in F.territories)
												faction = F
												break
									if(faction)
										if(istype(faction.owner, /mob) && faction.owner == user) 
											is_authority = TRUE
										if(faction.owner == user_name || (original_name && faction.owner == original_name))
											is_authority = TRUE
										if(faction.job_owner == user_role || (original_role && faction.job_owner == original_role))
											is_authority = TRUE
									break
			if(is_authority)
				var/signature_name = original_name ? original_name : user_name // envoys sign with their main character's name
				term_to_sign.signatures += signature_name
				if(!term_to_sign.open_signatures && term_to_sign.signatures.len >= term_to_sign.minimum_signatures)
					term_to_sign.signed = TRUE
				playsound(src, chosen_sound, 100, TRUE, -1)
				visible_message(span_warning("[usr] signs something on the treaty."))
				. = TRUE

		if("add_term")
			if(src.active_terms.len >= 10)
				to_chat(user, span_warning("The parchment is full."))
				return FALSE
			var/term_name = params["name"]
			var/term_text = params["text"]
			var/term_number = text2num(params["number"])
			var/term_target = params["target"]
			var/term_receiver = params["receiver"]
			var/term_obj = params["obj_target"]
			var/term_custom = params["custom_name"]

			if(!term_name)
				return
			for(var/term_type in src.terms)
				var/datum/treaty/terms/found_term = term_type
				if(found_term.name == term_name)
					var/datum/treaty/terms/new_term = new found_term.type()
					if(new_term.requires_text && term_text)
						new_term.text = term_text
					if(new_term.requires_number && term_number)
						new_term.number = term_number
					if(term_target) 
						new_term.target = term_target
					if(term_receiver) 
						new_term.receiver = term_receiver
					if(term_obj) 
						new_term.obj_target = term_obj
					if(term_custom) 
						new_term.custom_name = term_custom
					if(check_duplicate_term(new_term))
						to_chat(user, span_warning("This term conflicts with an existing term on the treaty."))
						qdel(new_term)
						return FALSE

					src.active_terms += new_term
					new_term.author = user.mind?.original_char?.mind || usr.mind
					unsign_all_terms() 
					. = TRUE
					playsound(src, chosen_sound, 100, TRUE, -1)
					visible_message(span_warning("[usr] adds something to the treaty."))
					break

		if("edit_term")
			var/term_index = text2num(params["index"]) + 1
			var/term_name = params["name"]
			var/term_custom = params["custom_name"]
			var/term_text = params["text"]
			var/term_number = text2num(params["number"])
			var/term_target = params["target"]
			var/term_receiver = params["receiver"]
			var/term_obj = params["obj_target"]

			if(!term_name || !term_index || term_index < 1 || term_index > src.active_terms.len)
				return
			for(var/datum/treaty/terms/prototype_term in src.terms)
				if(prototype_term.name == term_name)
					var/datum/treaty/terms/new_term = new prototype_term.type()
					if(new_term.requires_text && term_text)
						new_term.text = term_text
					if(new_term.requires_number && term_number)
						new_term.number = term_number
					if(term_target) 
						new_term.target = term_target
					if(term_receiver) 
						new_term.receiver = term_receiver
					if(term_obj) 
						new_term.obj_target = term_obj
					if(term_custom) 
						new_term.custom_name = term_custom
					if(check_duplicate_term(new_term, term_index))
						to_chat(user, span_warning("This term conflicts with an existing term on the treaty."))
						qdel(new_term)
						return FALSE

					qdel(src.active_terms[term_index])
					src.active_terms[term_index] = new_term
					new_term.author = user.mind?.original_char?.mind || usr.mind
					unsign_all_terms()
					. = TRUE
					playsound(src, 'sound/items/write.ogg', 100, FALSE)
					visible_message(span_warning("[usr] alters something on the treaty."))
					break
	
		if("set_party")
			var/faction_name = params["name"]
			var/party_id = text2num(params["party_id"])
			if(party_id == 1 && src.secondparty == faction_name)
				to_chat(user, span_warning("A faction cannot serve as both parties!"))
				return FALSE
			if(party_id == 2 && src.firstparty == faction_name)
				to_chat(user, span_warning("A faction cannot serve as both parties!"))
				return FALSE
			var/datum/territory_faction/found_faction
			for(var/datum/territory_faction/faction in SSwarbands.territory_factions)
				if(faction.name == faction_name)
					found_faction = faction
					break
			if(found_faction)
				if(party_id == 1)
					src.firstparty = faction_name
					unsign_all_terms()
					. = TRUE
					playsound(src, 'sound/misc/warband/treaty3.ogg', 100, TRUE, -1)
					visible_message(span_warning("[usr] adds something to the treaty."))
				else
					src.secondparty = faction_name
					unsign_all_terms()
					. = TRUE
					playsound(src, 'sound/misc/warband/treaty3.ogg', 100, TRUE, -1)
					visible_message(span_warning("[usr] adds something to the treaty."))

		if("remove_term")
			var/term_index = text2num(params["index"]) + 1
			if(!term_index || term_index < 1 || term_index > src.active_terms.len)
				return
			var/datum/treaty/terms/term_to_remove = src.active_terms[term_index]
			src.active_terms.Remove(term_to_remove)
			qdel(term_to_remove)
			unsign_all_terms()
			playsound(src, 'sound/misc/warband/treaty_cancel.ogg', 100, TRUE, -1)
			visible_message(span_warning("[usr] scratches something out on the treaty."))
			. = TRUE

	if(.)
		ui_interact(user)

// adding a new term unsigns the others
/obj/item/treaty/proc/unsign_all_terms()
	if(src.active_terms.len)
		for(var/datum/treaty/terms/term in src.active_terms)
			term.signed = FALSE
			term.signatures.Cut()

/obj/item/treaty/burn()
	// if(GLOB.tod == "dawn") FIXNOTE: uncommented 4 Ease Of Testing, don't leave this uncommented
	treaty_submission()

// uses the target name provided by the treaty to return a mob
/obj/item/treaty/proc/text_to_mob(target_name) 
	if(!target_name)
		return null
	for(var/mob/living/found_mob in GLOB.player_list)
		if(found_mob.real_name == target_name)
			return found_mob
	return null

// uses the target name provided by the treaty to return a faction
/obj/item/treaty/proc/text_to_faction(target_name)
	if(!target_name)
		return null
	for(var/datum/territory_faction/faction in SSwarbands.territory_factions)
		if(faction.name == target_name)
			return faction
	return null

// uses the target name provided by the treaty to return a territory
/obj/item/treaty/proc/text_to_territory(territory_name)
	if(!territory_name)
		return null
	for(var/datum/territory/land in SSwarbands.territory)
		if(land.name == territory_name)
			return land
	return null

/obj/item/treaty/proc/check_duplicate_term(datum/treaty/terms/new_term, skip_index = null) 
	for(var/i = 1 to src.active_terms.len) // when we edit or create a new term, we want to be absolutely sure it isn't a duplicate
		if(skip_index && i == skip_index) // skip the term we're editing
			continue
			
		var/datum/treaty/terms/existing = src.active_terms[i]
		
		// same territory can't be ceded twice
		if(istype(new_term, /datum/treaty/terms/territory_loss) && istype(existing, /datum/treaty/terms/territory_loss))
			if(new_term.obj_target == existing.obj_target)
				return TRUE // return true on duplicate terms
		
		// same source+receiver combination can't exist twice
		else if(istype(new_term, /datum/treaty/terms/cointribute) && istype(existing, /datum/treaty/terms/cointribute))
			if(new_term.target == existing.target && new_term.receiver == existing.receiver)
				return TRUE
		
		// same person can't be exiled twice
		else if(istype(new_term, /datum/treaty/terms/exile) && istype(existing, /datum/treaty/terms/exile))
			if(new_term.target == existing.target)
				return TRUE
		
		// same law can't be abolished twice
		else if(istype(new_term, /datum/treaty/terms/remove_law) && istype(existing, /datum/treaty/terms/remove_law))
			if(new_term.number == existing.number)
				return TRUE
		
		// same law text can't be codified twice
		else if(istype(new_term, /datum/treaty/terms/codify_law) && istype(existing, /datum/treaty/terms/codify_law))
			if(new_term.text == existing.text)
				return TRUE
		
		// same tax category can't be adjusted twice
		else if(istype(new_term, /datum/treaty/terms/set_tax) && istype(existing, /datum/treaty/terms/set_tax))
			if(new_term.type == existing.type)
				return TRUE
	
	return FALSE

// sort law removal terms in descending. ordered by law number
/obj/item/treaty/proc/compare_law_terms_descending(datum/treaty/terms/remove_law/first_term, datum/treaty/terms/remove_law/second_term)
	return second_term.number - first_term.number

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// TREATY SUBMISSION
/*
	burning a Treaty at dawn will activate it
	every term loaded onto a treaty takes effect
	if a single term is unsigned, the entire treaty will fizzle out
*/
/obj/item/treaty/proc/treaty_submission()
	for(var/datum/treaty/terms/term in src.active_terms)
		if(!term.signed && term.name != "Freeform") // fail if anything (aside from a freeform term) is unsigned
			visible_message(span_warning("The treaty crumbles. One or more terms were unsigned."))
			SSwarbands.treaties -= src
			qdel(src)
			return FALSE

	visible_message(span_danger("The treaty evaporates in a flash of divine flame! Summer winds ferry its ashes to the heavens above."))
	var/list/law_changes = list()
	var/list/tax_changes = list()
	var/list/exile_announcements = list()
	
	// first, process any law removals
	// we need to process law removals in DESCENDING order to avoid index shifting conflicts
	var/list/law_removal_terms = list()
	for(var/datum/treaty/terms/term in src.active_terms)
		if(istype(term, /datum/treaty/terms/remove_law))
			law_removal_terms += term

	// sort by law number in descending order (highest first)
	law_removal_terms = sortTim(law_removal_terms, CALLBACK(src, PROC_REF(compare_law_terms_descending)))

	// process them from highest to lowest
	for(var/datum/treaty/terms/term in law_removal_terms)
		if(GLOB.laws_frozen)
			continue
		if(term.number in GLOB.codified_laws)
			continue
		if(term.number >= 1 && term.number <= length(GLOB.laws_of_the_land) && GLOB.laws_of_the_land[term.number])
			var/law_text = remove_law(term.number, silent = TRUE)
			if(law_text)
				law_changes += "Law [term.number] abolished: [law_text]"
		else
			visible_message(span_warning("...but one of the terms yet remains in the flame. It seems law [term.number] doesn't exist, and thus cannot be abolished."))
	
	// next, do everything else
	for(var/datum/treaty/terms/term in src.active_terms)
		// codify law
		if(istype(term, /datum/treaty/terms/codify_law))
			if(GLOB.laws_frozen)
				continue
			var/new_law_index = length(GLOB.laws_of_the_land) + 1
			make_law(term.text, silent = TRUE)
			GLOB.codified_laws += new_law_index
			law_changes += "Law [new_law_index] codified: [term.text]"
		
		// freeze laws
		else if(istype(term, /datum/treaty/terms/freeze_laws))
			GLOB.laws_frozen = TRUE
			law_changes += "In our ruler's infinite wisdom, all present laws have been frozen. So long as the Sun rises, no change shall be permitted."
		
		// tax terms
		else if(istype(term, /datum/treaty/terms/set_tax))
			var/category_name
			if(istype(term, /datum/treaty/terms/set_tax/noble))
				category_name = "Nobility"
			else if(istype(term, /datum/treaty/terms/set_tax/yeoman))
				category_name = "Yeomanry"
			else if(istype(term, /datum/treaty/terms/set_tax/peasant))
				category_name = "Peasantry"
			else if(istype(term, /datum/treaty/terms/set_tax/church))
				category_name = "Clergy"
			if(category_name)
				if(category_name in GLOB.locked_tax_categories)
					continue
				if(category_name in SStreasury.taxation_cat_settings)
					SStreasury.taxation_cat_settings[category_name]["taxAmount"] = term.number
					GLOB.locked_tax_categories += category_name
					tax_changes += "[category_name] tax set to [term.number]% and locked!"
					SStreasury.log_to_steward("[category_name] tax set to [term.number]% and locked, as demanded by a treaty.")

		// territory transfers
		else if(istype(term, /datum/treaty/terms/territory_loss))
			if(term.obj_target && term.receiver)
				var/datum/territory/estate = text_to_territory(term.obj_target)
				var/datum/territory_faction/new_faction = text_to_faction(term.receiver)
				
				if(!estate)
					visible_message(span_danger("...but one of the terms yet remains in the flame. It seems [term.obj_target] is owed elsewhere."))
					continue
				
				if(!new_faction)
					visible_message(span_danger("...but one of the terms yet remains in the flame. It seems [term.receiver] is too fractured to declare ownership of [term.obj_target]."))
					continue

				// take it from the old faction
				var/datum/territory_faction/old_faction = estate.associated_faction
				if(old_faction)
					old_faction.territories -= estate
				
				// give it to the new faction
				estate.associated_faction = new_faction
				if(!(estate in new_faction.territories))
					new_faction.territories += estate

		// coin transfers
		// note: coin transfers involving the duchy directly give or take from its treasury
		else if(istype(term, /datum/treaty/terms/cointribute))
			if(term.target && term.receiver && term.number)
				if(term.target == term.receiver) // final failsafe to prevent self-transfers
					visible_message(span_danger("...but one of the terms yet remains in the flame. A faction cannot pay tribute to itself."))
					continue
					
				var/datum/territory_faction/source_faction = text_to_faction(term.target)
				var/datum/territory_faction/dest_faction = text_to_faction(term.receiver)
				
				if(!source_faction || !dest_faction)
					visible_message(span_danger("...but one of the terms yet remains in the flame. \
					A faction expected to be involved in tribute either dissolved before said tribute could be made, or never existed to begin with."))
					continue
	
				if(source_faction.name == "The Crown")
					if(SStreasury.treasury_value >= term.number)
						SStreasury.withdraw_money_treasury(term.number, "Treaty Tribute")
						if(dest_faction.name == "The Crown")
							SStreasury.give_money_treasury(term.number, "Treaty Tribute")
						else
							dest_faction.vault += term.number
					else
						var/amount_available = SStreasury.treasury_value
						var/deficit = term.number - amount_available
						SStreasury.withdraw_money_treasury(amount_available, "Treaty Tribute")
						if(dest_faction.name == "The Crown")
							SStreasury.give_money_treasury(amount_available, "Treaty Tribute")
						else
							dest_faction.vault += amount_available
						SStreasury.treasury_value = -deficit
						SStreasury.log_to_steward("-[deficit] deficit from excess Treaty demands.")
				else
					var/amount_to_transfer = max(0, source_faction.vault)
					if(dest_faction.name == "The Crown")
						SStreasury.give_money_treasury(amount_to_transfer, "Treaty Tribute")
					else
						dest_faction.vault += amount_to_transfer
					source_faction.vault -= term.number
		
		// exiles
		else if(istype(term, /datum/treaty/terms/exile))
			if(term.target)
				var/mob/living/exile = text_to_mob(term.target)
				if(exile)
					exile.AddComponent(/datum/component/sunlight_vulnerability/exile)
					exile_announcements += "[term.target] has been exiled from the city."
				else
					visible_message(span_danger("...but one of the terms yet remains in the flame. \
					It seems [term.target] has done you the favor of exiling themselves. Or perhaps, '[term.target]' never existed to begin with."))

		// wizard
		else if(istype(term, /datum/treaty/terms/unique/wizard))
			if(term.signatures.len)
				var/signatory_name = term.signatures[1]
				var/mob/living/subpar_mage = text_to_mob(signatory_name)
				if(subpar_mage)
					to_chat(subpar_mage, span_warning("I truly signed that? Yils of studies, and to what end? My heart sinks..."))
					subpar_mage.add_stress(/datum/stressevent/wizardterm)
					subpar_mage.playsound_local(subpar_mage, 'sound/ddstress.ogg', 100, FALSE)


	// final announcement
	if(law_changes.len || tax_changes.len)
		var/list/all_changes = list()
		if(law_changes.len)
			all_changes += law_changes
		if(tax_changes.len)
			all_changes += tax_changes
		if(exile_announcements.len)
			all_changes += exile_announcements
		var/full_announcement = all_changes.Join("\n")
		priority_announce(full_announcement, "AS DEMANDED BY TREATY", ('sound/misc/royal_decree.ogg'))
	check_treaty_objectives()	
	SSwarbands.treaties -= src
	src.loc = null // don't destroy it. send it into The Great Nowhere
	SSwarbands.submitted_treaties += src // for posterity
	return


/////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// CHECK LIEUTENANT OBJECTIVES
/*
	objectiveslop
	if a treaty meets certain conditions for an antagonist, this Greentexts them
*/
/obj/item/treaty/proc/check_treaty_objectives()
	for(var/datum/treaty/terms/term in src.active_terms)
		if(term.author) // if something they wrote is submitted, the 'standard' objective is complete
			var/is_lieutenant = (term.author.special_role == "Lieutenant" || term.author.special_role == "Aspirant Lieutenant")
			var/is_warlord = (term.author.special_role == "Warlord")
			if(is_lieutenant)
				for(var/datum/objective/obj in term.author.get_all_objectives())
					if(istype(obj, /datum/objective/warband/aspirant/standard))
						obj.completed = TRUE
						to_chat(term.author.current, span_notice("One of my objectives has been fulfilled!"))
						break
			if(is_warlord)
				for(var/datum/objective/obj in term.author.get_all_objectives())
					if(istype(obj, /datum/objective/warband/warlord))
						obj.completed = TRUE
						to_chat(term.author.current, span_notice("My objective has been fulfilled!"))
						break


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
