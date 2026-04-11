
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
	var/list/user_cooldowns = list()
	var/list/job_titles = list()


/obj/item/treaty/Initialize()
	..()
	for(var/term_option in WARBAND_TERMS)
		src.terms += new term_option
	SSwarbands.treaties += src

/obj/item/treaty/spark_act()
	fire_act()

/obj/item/treaty/Destroy()
	SSwarbands.treaties -= src
	warband_sources = null
	return ..()

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
			var/list/display_names = list()
			if(islist(term.authorities))
				for(var/authority_name in term.authorities)
					display_names += get_display_name(authority_name)
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
				"authorities" = display_names,
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
				"job_owner" = get_display_name(faction.job_owner),
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
	var/mob/living/user = usr
	var/user_key = user.ckey
	if(user_cooldowns[user_key] && world.time < user_cooldowns[user_key])
		return TRUE
	user_cooldowns[user_key] = world.time + 10

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

	// i'm like 40% sure tgui already does this but just in case
	if(params["text"])
		params["text"] = sanitize(copytext(params["text"], 1, MAX_MESSAGE_LEN))
	if(params["custom_name"])
		params["custom_name"] = sanitize(copytext(params["custom_name"], 1, MAX_MESSAGE_LEN))

	// if a mind has a filled "original char" variable, they're an envoy of that character
	// when signing terms, envoys use the authority of that mob instead of their own
	var/original_name
	if(user.mind?.original_char)
		var/mob/living/original = user.mind.original_char
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

				for(var/auth in auth_list)
					if(ispath(auth))
						if(ispath(user.job_path, auth))
							is_authority = TRUE
							break
						if(!is_authority && ispath(user.mind?.original_char?.job_path, auth))
							is_authority = TRUE
							break
				
				if(!is_authority)
					if(auth_list.Find("target")) // check if target matches the current name (or the original name, for envoys)
						if(term_to_sign.target == user_name || (original_name && term_to_sign.target == original_name))
							is_authority = TRUE
						else
							for(var/datum/territory_faction/faction in SSwarbands.territory_factions)
								if(faction.name == term_to_sign.target)
									if(ismob(faction.owner) && faction.owner == user)
										is_authority = TRUE
									else if(faction.owner == user_name || (original_name && faction.owner == original_name))
										is_authority = TRUE
									else if(ispath(faction.job_owner, user.job_path) || (user.mind?.original_char && ispath(faction.job_owner, user.mind.original_char.job_path)))
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
										if(ismob(faction.owner) && faction.owner == user) 
											is_authority = TRUE
										if(faction.owner == user_name || (original_name && faction.owner == original_name))
											is_authority = TRUE
										if(ispath(faction.job_owner, user.job_path) || (user.mind?.original_char && ispath(faction.job_owner, user.mind.original_char.job_path)))
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

/obj/item/treaty/proc/get_display_name(authority)
	if(ispath(authority))
		if(!(authority in job_titles))
			if(ispath(authority, /datum/job))
				job_titles[authority] = initial(authority:title)

			// migrant role datums aren't actually jobs for whatever reason despite being (almost) identical to them
			else if(ispath(authority, /datum/migrant_role)) 
				job_titles[authority] = initial(authority:name)
		
			else
				job_titles[authority] = "[authority]"

		return job_titles[authority]
	return authority
