
///books that teach things (intrinsic actions like bar flinging, spells like fireball or smoke, or martial arts)///

/obj/item/book/granter
	due_date = 0 // Game time in deciseconds
	unique = 1   // 0  Normal book, 1  Should not be treated as normal book, unable to be copied, unable to be modified
	var/list/remarks = list() //things to read about while learning.
	var/pages_to_mastery = 3 //Essentially controls how long a mob must keep the book in his hand to actually successfully learn
	var/reading = FALSE //sanity
	var/oneuse = TRUE //default this is true, but admins can var this to 0 if we wanna all have a pass around of the rod form book
	var/used = FALSE //only really matters if oneuse but it might be nice to know if someone's used it for admin investigations perhaps
	var/dreamcost

/obj/item/book/granter/proc/turn_page(mob/user)
	playsound(user, pick('sound/blank.ogg'), 30, TRUE)
	if(do_after(user,50, user))
		if(remarks.len)
			to_chat(user, span_notice("[pick(remarks)]"))
		else
			to_chat(user, span_notice("I keep reading..."))
		return TRUE
	return FALSE

/obj/item/book/granter/proc/recoil(mob/user) //nothing so some books can just return

/obj/item/book/granter/proc/already_known(mob/user)
	return FALSE

/obj/item/book/granter/proc/on_reading_start(mob/user)
	to_chat(user, span_notice("I start reading [name]..."))

/obj/item/book/granter/proc/on_reading_stopped(mob/user)
	to_chat(user, span_notice("I stop reading..."))

/obj/item/book/granter/proc/on_reading_finished(mob/user)
	to_chat(user, span_notice("I finish reading [name]!"))

/obj/item/book/granter/proc/onlearned(mob/user)
	used = TRUE


/obj/item/book/granter/attack_self(mob/living/user)
	if(reading)
		to_chat(user, span_warning("I'm already reading this!"))
		return FALSE
	if(!user.can_read(src))
		return FALSE
	if(already_known(user))
		return FALSE
/*	AZURE PEAK REMOVAL -- UNUSED ANYWAY
	if(user.STAINT < 12)
			to_chat(user, span_warning("You can't make sense of the sprawling runes!"))
			return FALSE */
	if(used && oneuse)
		to_chat(user, span_warning("This fount of knowledge was not meant to be sipped from twice!"))
		recoil(user)
		return FALSE
	on_reading_start(user)
	reading = TRUE
	for(var/i=1, i<=pages_to_mastery, i++)
		if(!turn_page(user))
			reading = FALSE
			on_reading_stopped()
			return FALSE
	if(do_after(user, 50, user))
		reading = FALSE
		on_reading_finished(user)
		return TRUE
	reading = FALSE //failsafe
	return FALSE

/obj/item/book/granter/spell
	grid_width = 64
	grid_height = 32

	var/spell
	var/spellname = "conjure bugs"

/obj/item/book/granter/spell/already_known(mob/user)
	if(!spell)
		return TRUE
	if(user.mind.has_spell(spell, specific = TRUE))
		to_chat(user, span_warning("You've already read this one!"))
		return TRUE
	return FALSE

/obj/item/book/granter/spell/on_reading_start(mob/user)
	to_chat(user, span_notice("I start reading about casting [spellname]..."))

/obj/item/book/granter/spell/on_reading_finished(mob/user)
	to_chat(user, span_notice("I feel like you've experienced enough to cast [spellname]!"))
	var/datum/S = new spell
	user.mind.AddSpell(S)
	user.log_message("learned the spell [spellname] ([S])", LOG_ATTACK, color="orange")
	onlearned(user)

/obj/item/book/granter/spell/random
	icon_state = "random_book"

/obj/item/book/granter/spell/random/Initialize()
	. = ..()
	var/static/banned_spells = list(/obj/item/book/granter/spell/mimery_blockade)
	var/real_type = pick(subtypesof(/obj/item/book/granter/spell) - banned_spells)
	new real_type(loc)
	return INITIALIZE_HINT_QDEL

///ACTION BUTTONS///

/obj/item/book/granter/action
	var/granted_action
	var/actionname = "catching bugs" //might not seem needed but this makes it so you can safely name action buttons toggle this or that without it fucking up the granter, also caps

/obj/item/book/granter/action/already_known(mob/user)
	if(!granted_action)
		return TRUE
	for(var/datum/action/A in user.actions)
		if(A.type == granted_action)
			to_chat(user, span_warning("I already know all about [actionname]!"))
			return TRUE
	return FALSE

/obj/item/book/granter/action/on_reading_start(mob/user)
	to_chat(user, span_notice("I start reading about [actionname]..."))

/obj/item/book/granter/action/on_reading_finished(mob/user)
	to_chat(user, span_notice("I feel like you've got a good handle on [actionname]!"))
	var/datum/action/G = new granted_action
	G.Grant(user)
	onlearned(user)

/obj/item/book/granter/crafting_recipe
	var/list/crafting_recipe_types = list()
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "learning_tome"
	drop_sound = 'sound/foley/dropsound/paper_drop.ogg'
	pickup_sound =  'sound/blank.ogg'

/obj/item/book/granter/crafting_recipe/on_reading_finished(mob/user)
	. = ..()
	if(!user.mind)
		return
	
	for(var/crafting_recipe_type in crafting_recipe_types)
		var/datum/crafting_recipe/R = crafting_recipe_type
		user.mind.teach_crafting_recipe(crafting_recipe_type)
		to_chat(user,span_notice("I learned how to make [initial(R.name)]."))
	to_chat(user,span_notice("The book falls apart in my hands."))
	qdel(src)

/*
UNDER NO CIRCUMSTANCE SHOULD ANY OF THE BOOKS BE GIVEN OUT INTO SPAWNERS OR TO BE PURCHASABLE, BREAK THAT RULE ON YOUR OWN PERIL
*/
/obj/item/book/granter/crafting_recipe/tailor
	name = "MASTER TAILORING / LEATHERWORKING TOME"
	desc = "If you got hold of this either spawn system screwed up somewhere or admin is trolling you, report THIS."
	oneuse = TRUE
	crafting_recipe_types = list(
		/datum/crafting_recipe/roguetown/sewing/tailor/naledisash,
		/datum/crafting_recipe/roguetown/sewing/tailor/halfrobe,
		/datum/crafting_recipe/roguetown/sewing/tailor/monkrobe,
		/datum/crafting_recipe/roguetown/leather/unique/monkleather,
		/datum/crafting_recipe/roguetown/sewing/tailor/desertgown,
		/datum/crafting_recipe/roguetown/leather/unique/baggyleatherpants,
		/datum/crafting_recipe/roguetown/sewing/tailor/otavangambeson,
		/datum/crafting_recipe/roguetown/leather/unique/otavanleatherpants,
		/datum/crafting_recipe/roguetown/leather/unique/otavanboots,
		/datum/crafting_recipe/roguetown/sewing/tailor/hgambeson/fencer,
		/datum/crafting_recipe/roguetown/leather/unique/fencingbreeches,
		/datum/crafting_recipe/roguetown/sewing/tailor/grenzelhat,
		/datum/crafting_recipe/roguetown/sewing/tailor/grenzelshirt,
		/datum/crafting_recipe/roguetown/sewing/tailor/grenzelpants,
		/datum/crafting_recipe/roguetown/leather/unique/grenzelboots,
		/datum/crafting_recipe/roguetown/leather/unique/furlinedjacket,
		/datum/crafting_recipe/roguetown/leather/unique/artipants,
		/datum/crafting_recipe/roguetown/leatherunique/gladsandals,
		/datum/crafting_recipe/roguetown/leather/unique/buckleshoes,
		/datum/crafting_recipe/roguetown/leather/unique/winterjacket,
		/datum/crafting_recipe/roguetown/leather/unique/openrobes,
		/datum/crafting_recipe/roguetown/leather/unique/monkrobes
	)

/obj/item/book/granter/crafting_recipe/tailor/western
	name = "Grand Codex of Classic Tailoring"
	desc = "A thick book containing details on how to outfit an army of mammon-seeking scoundrels in style. Something tells you the author mislead you with the title."
	crafting_recipe_types = list(
		/datum/crafting_recipe/roguetown/sewing/tailor/otavangambeson,
		/datum/crafting_recipe/roguetown/leather/unique/otavanleathergloves,
		/datum/crafting_recipe/roguetown/leather/unique/otavanleatherpants,
		/datum/crafting_recipe/roguetown/leather/unique/otavanboots,//Otavan
		/datum/crafting_recipe/roguetown/sewing/tailor/grenzelhat,
		/datum/crafting_recipe/roguetown/sewing/tailor/grenzelshirt,
		/datum/crafting_recipe/roguetown/leather/unique/grenzelgloves,
		/datum/crafting_recipe/roguetown/sewing/tailor/grenzelpants,
		/datum/crafting_recipe/roguetown/leather/unique/grenzelboots//Grenzel
	)

/obj/item/book/granter/crafting_recipe/tailor/eastern
	name = "Almanach of Heritage Tailoring"
	desc = "A collection of images and instructions on how to assemble traditional outfits of more isolationist groups."
	crafting_recipe_types = list(
		/datum/crafting_recipe/roguetown/sewing/tailor/naledisash,
		/datum/crafting_recipe/roguetown/sewing/tailor/halfrobe,
		/datum/crafting_recipe/roguetown/sewing/tailor/monkrobe,
		/datum/crafting_recipe/roguetown/leather/unique/monkleather,
		/datum/crafting_recipe/roguetown/sewing/tailor/desertgown,
		/datum/crafting_recipe/roguetown/leather/unique/baggyleatherpants,//Naledi
		/datum/crafting_recipe/roguetown/sewing/tailor/hgambeson/fencer,
		/datum/crafting_recipe/roguetown/leather/unique/fencingbreeches,//Aanvr
		/datum/crafting_recipe/roguetown/leather/unique/openrobes,
		/datum/crafting_recipe/roguetown/leather/unique/gronngloves,
		/datum/crafting_recipe/roguetown/leather/unique/gronnpants,
		/datum/crafting_recipe/roguetown/leather/unique/gronnboots//Gronn
	)

/obj/item/book/granter/spell/bonechill
	name = "Scroll of Bone Chill"
	spell = /obj/effect/proc_holder/spell/invoked/bonechill
	spellname = "Bone Chill"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "scrolldarkred"
	oneuse = TRUE
	drop_sound = 'sound/foley/dropsound/paper_drop.ogg'
	pickup_sound = 'sound/blank.ogg'
	remarks = list("Mediolanum ventis..", "Sana damnatorum..", "Frigidus ossa mortuorum..")

/obj/item/book/granter/spell/bonechill/onlearned(mob/living/carbon/user)
	..()
	if(oneuse)
		name = "siphoned scroll"
		desc = "A scroll once inscribed with magical scripture. The surface is now barren of knowledge, siphoned by someone else. It's utterly useless."
		icon_state = "scroll"
		user.visible_message(span_warning("[src] has had its magic ink ripped from the scroll!"))

/proc/get_resident_manuscript_ui_language(mob/user)
	return user?.client?.get_preferred_ui_language() || DEFAULT_PREFERRED_UI_LANGUAGE

/proc/give_roundstart_manuscript(mob/living/carbon/human/recipient, manuscript_type)
	if(!ishuman(recipient) || !recipient.mind)
		return FALSE
	if(!ispath(manuscript_type, /obj/item/book/granter/resident_manuscript))
		return FALSE
	if(!recipient.mind.special_items)
		recipient.mind.special_items = list()
	for(var/existing_key in recipient.mind.special_items)
		var/existing_path = recipient.mind.special_items[existing_key]
		if(ispath(existing_path, /obj/item/book/granter/resident_manuscript))
			return FALSE
	recipient.mind.special_items[RESIDENT_MANUSCRIPT_SPECIAL_ITEM_NAME] = manuscript_type
	return TRUE

/// Virtue path. Caller has already added TRAIT_RESIDENT; this just stashes
/// the matching manuscript so the player can retrieve it as identity proof.
/proc/grant_roundstart_resident_manuscript(mob/living/carbon/human/recipient, manuscript_type = /obj/item/book/granter/resident_manuscript/roundstart)
	if(!ishuman(recipient) || !recipient.mind)
		return FALSE
	if(!HAS_TRAIT(recipient, TRAIT_RESIDENT))
		return FALSE
	return give_roundstart_manuscript(recipient, manuscript_type)

/// Optional outfit hook: places a faction-default manuscript into the
/// recipient's stash if a role rule resolves their role. Skips when another
/// manuscript (virtue, admin, etc.) is already stashed.
/// `get_default_manuscript_type_for_job()` lives in resident_document_rules.dm
/// and walks the role rule registry in priority order.
/proc/grant_roundstart_faction_manuscript(mob/living/carbon/human/recipient)
	var/manuscript_type = get_default_manuscript_type_for_job(recipient)
	if(!manuscript_type)
		return FALSE
	return give_roundstart_manuscript(recipient, manuscript_type)

/proc/resident_manuscript_defect_keys()
	return list(
		"ink_blot",
		"seal_smudge",
		"owner_wobble",
		"ragged_edge",
		"uncertain_hand",
		"stale_smell",
		"misaligned_initial",
		"fresh_pricking",
		"cut_gilding",
		"rethreaded_cord",
		"reheated_wax",
		"blue_halo",
		"corrected_date",
		"heretical_marginalia",
	)

/proc/resident_manuscript_validation_note_keys()
	return list(
		"steady_seals",
		"proper_ruling",
		"matched_hand",
		"deep_wax",
		"proper_rite",
	)

/// `/datum/resident_manuscript_seal_rule` and the seal registry live in
/// `code/modules/paperwork/resident_document_seals.dm`.

/obj/item/book/granter/resident_manuscript
	name = "Resident Manuscript"
	desc = "A fine ivory manuscript confirming lawful residence under the Crown."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "contractsigned"
	oneuse = FALSE
	drop_sound = 'sound/foley/dropsound/paper_drop.ogg'
	pickup_sound = 'sound/blank.ogg'
	pages_to_mastery = 0
	var/document_profile_id = "resident"
	var/tmp/datum/resident_document_profile/document_profile
	var/owner_character_key
	var/owner_name
	var/owner_age
	var/owner_status_key = RESIDENT_MANUSCRIPT_STATUS_COMMONER
	var/expiry_date
	var/issued_place
	var/is_bound = FALSE
	var/is_fake = FALSE
	var/authority_validated = FALSE
	var/auto_stamp_seals = TRUE
	var/auto_bind_on_equip = TRUE
	var/requires_feather_to_bind = FALSE
	var/expiry_year_bonus_min = 0
	var/expiry_year_bonus_max = 0
	var/list/seals
	var/list/defect_note_keys
	var/list/detection_attempts
	var/list/detection_results
	var/list/detection_note_keys

/obj/item/book/granter/resident_manuscript/Initialize()
	. = ..()
	document_profile = get_resident_document_profile(document_profile_id)
	if(document_profile?.display_name)
		name = document_profile.display_name
	issued_place = SSticker?.realm_name || "Azure Peak"
	expiry_date = compute_expiry_date()
	initialize_seals()
	defect_note_keys = list()
	detection_attempts = list()
	detection_results = list()
	detection_note_keys = list()
	if(auto_stamp_seals)
		stamp_default_seals()

/obj/item/book/granter/resident_manuscript/proc/get_profile_seal_keys()
	if(document_profile && document_profile.allowed_seals)
		return document_profile.allowed_seals
	return list()

/obj/item/book/granter/resident_manuscript/proc/initialize_seals()
	seals = list()
	for(var/seal_key in get_profile_seal_keys())
		seals[seal_key] = null

/obj/item/book/granter/resident_manuscript/proc/compute_expiry_date()
	var/round_id = text2num(GLOB.round_id) || 0
	var/days_since_epoch = (round_id * CALENDAR_DAYS_IN_WEEK) + (GLOB.dayspassed - 1)
	if(GLOB.date_override_enabled)
		days_since_epoch += GLOB.date_override_offset
	var/day_of_year = MODULUS(days_since_epoch, CALENDAR_DAYS_IN_YEAR) + 1
	var/current_month = FLOOR((day_of_year - 1) / CALENDAR_DAYS_IN_MONTH, 1) + 1
	var/current_day = MODULUS((day_of_year - 1), CALENDAR_DAYS_IN_MONTH) + 1
	var/new_day = current_day + rand(10, 20)
	var/new_month = current_month
	var/new_year = CALENDAR_EPOCH_YEAR
	while(new_day > CALENDAR_DAYS_IN_MONTH)
		new_day -= CALENDAR_DAYS_IN_MONTH
		new_month += 1
	if(new_month > CALENDAR_MONTHS_PER_YEAR)
		new_year += FLOOR((new_month - 1) / CALENDAR_MONTHS_PER_YEAR, 1)
		new_month = ((new_month - 1) % CALENDAR_MONTHS_PER_YEAR) + 1
	if(expiry_year_bonus_max > 0)
		new_year += rand(expiry_year_bonus_min, expiry_year_bonus_max)
	return "[new_day] [get_month_number_to_text(new_month)] [new_year]"

/obj/item/book/granter/resident_manuscript/proc/get_detection_character_key(mob/living/carbon/human/user)
	if(!ishuman(user))
		return null
	if(user.mobid)
		return "[user.mobid]"
	return user.real_name || user.name

/obj/item/book/granter/resident_manuscript/proc/status_key_for(mob/living/carbon/human/target)
	if(HAS_TRAIT(target, TRAIT_NOBLE))
		return RESIDENT_MANUSCRIPT_STATUS_NOBLE
	return RESIDENT_MANUSCRIPT_STATUS_COMMONER

/obj/item/book/granter/resident_manuscript/proc/bind_to_holder(mob/living/carbon/human/target)
	if(is_bound || !ishuman(target))
		return FALSE
	owner_character_key = get_detection_character_key(target)
	owner_name = target.real_name
	owner_age = target.age
	owner_status_key = status_key_for(target)
	maybe_swap_profile_for_status()
	is_bound = TRUE
	name = "Resident Manuscript"
	icon_state = "contractsigned"
	if(auto_stamp_seals)
		stamp_default_seals()
	else
		handle_post_bind_low_level_seal()
	return TRUE

/// If the document is using a generic status profile (resident/commoner) but
/// the recorded owner status disagrees, swap to the matching profile and
/// re-initialize the seal slots. Faction profiles never swap.
/obj/item/book/granter/resident_manuscript/proc/maybe_swap_profile_for_status()
	var/desired_id
	if(document_profile_id == "resident" && owner_status_key == RESIDENT_MANUSCRIPT_STATUS_COMMONER)
		desired_id = "commoner"
	else if(document_profile_id == "commoner" && owner_status_key == RESIDENT_MANUSCRIPT_STATUS_NOBLE)
		desired_id = "resident"
	if(!desired_id || desired_id == document_profile_id)
		return FALSE
	document_profile_id = desired_id
	document_profile = get_resident_document_profile(desired_id)
	if(document_profile?.display_name)
		name = document_profile.display_name
	initialize_seals()
	return TRUE

/// Auto-applies the "Towner Elder" baseline seal when a non-`auto_stamp_seals`
/// document (a blank) finishes binding to a commoner-profile holder. Higher
/// authority seals (Chancellor / Hand / Duke) still need a living role to
/// stamp them through `handle_stamp()`.
/obj/item/book/granter/resident_manuscript/proc/handle_post_bind_low_level_seal()
	if(is_fake)
		return
	if(document_profile_id != "commoner")
		return
	if(seals?["elder"])
		return
	stamp_seal("elder", null, FALSE)

/obj/item/book/granter/resident_manuscript/proc/is_owner_viewer(mob/living/carbon/human/user)
	if(!ishuman(user))
		return FALSE
	var/detection_key = get_detection_character_key(user)
	if(owner_character_key && detection_key && detection_key == owner_character_key)
		return TRUE
	if(is_fake && owner_name)
		var/real_name = user.real_name || ""
		var/user_name = user.name || ""
		if(owner_name == real_name || owner_name == user_name || owner_name == html_encode(real_name) || owner_name == html_encode(user_name))
			return TRUE
	return FALSE

/obj/item/book/granter/resident_manuscript/proc/sanitize_manuscript_field(value, max_length, fallback)
	var/text_value = ""
	if(!isnull(value))
		text_value = "[value]"
	text_value = trim(html_encode(text_value), PREVENT_CHARACTER_TRIM_LOSS(max_length))
	return length(text_value) ? text_value : fallback

/obj/item/book/granter/resident_manuscript/proc/normalize_status_key(value)
	if(value == RESIDENT_MANUSCRIPT_STATUS_NOBLE)
		return RESIDENT_MANUSCRIPT_STATUS_NOBLE
	return RESIDENT_MANUSCRIPT_STATUS_COMMONER

/obj/item/book/granter/resident_manuscript/proc/get_seal_rule(seal_key)
	var/rule_type = get_resident_manuscript_seal_rules()[seal_key]
	if(!rule_type)
		return null
	return new rule_type

/obj/item/book/granter/resident_manuscript/proc/get_seal_key_for_user(mob/living/carbon/human/user)
	if(!ishuman(user))
		return null
	for(var/seal_key in get_profile_seal_keys())
		var/datum/resident_manuscript_seal_rule/rule = get_seal_rule(seal_key)
		if(!rule)
			continue
		var/can_stamp = rule.can_stamp(user) && rule.can_apply_to_status(owner_status_key)
		qdel(rule)
		if(can_stamp)
			return seal_key
	return null

/obj/item/book/granter/resident_manuscript/proc/get_seal_priority(seal_key)
	var/datum/resident_manuscript_seal_rule/rule = get_seal_rule(seal_key)
	if(!rule)
		return 0
	var/priority = rule.priority
	qdel(rule)
	return priority

/obj/item/book/granter/resident_manuscript/proc/can_apply_seal_to_status(seal_key, status_key)
	var/datum/resident_manuscript_seal_rule/rule = get_seal_rule(seal_key)
	if(!rule)
		return FALSE
	var/result = rule.can_apply_to_status(status_key)
	qdel(rule)
	return result

/// Returns the profile's seal keys sorted by ascending priority (weakest first,
/// strongest last). UI rendering relies on this order so higher-authority
/// seals appear later in the DOM and can sit "on top" via z-index.
/obj/item/book/granter/resident_manuscript/proc/get_sorted_seal_keys()
	var/list/profile_keys = get_profile_seal_keys()
	if(!LAZYLEN(profile_keys))
		return list()
	var/list/keys_with_priority = list()
	for(var/seal_key in profile_keys)
		keys_with_priority[seal_key] = get_seal_priority(seal_key)
	sortTim(keys_with_priority, GLOBAL_PROC_REF(cmp_numeric_asc), TRUE)
	var/list/sorted = list()
	for(var/seal_key in keys_with_priority)
		sorted += seal_key
	return sorted

/// Highest-priority stamped, non-suspicious seal -- the one the UI should
/// treat as the "dominant" mark of authority. Returns null when nothing is
/// authentically stamped.
/obj/item/book/granter/resident_manuscript/proc/get_dominant_seal_key()
	if(!seals)
		return null
	var/best
	var/best_priority = -1
	for(var/seal_key in seals)
		var/list/entry = seals[seal_key]
		if(!entry || entry["suspicious"])
			continue
		var/p = get_seal_priority(seal_key)
		if(p > best_priority)
			best = seal_key
			best_priority = p
	return best

/obj/item/book/granter/resident_manuscript/proc/stamp_seal(seal_key, mob/living/carbon/human/stamper, suspicious = FALSE)
	if(!seals || !(seal_key in seals) || seals[seal_key])
		return FALSE
	var/datum/resident_manuscript_seal_rule/rule = get_seal_rule(seal_key)
	if(!rule)
		return FALSE
	seals[seal_key] = list(
		"stamper" = suspicious ? null : (rule.stamper || rule.title || rule.key),
		"time" = world.time,
		"suspicious" = suspicious,
	)
	qdel(rule)
	return TRUE

/// Stamps the seals listed in `document_profile.get_default_seal_keys()` --
/// those are the seals considered "pre-issued" with the document, and they are
/// applied in `Initialize()` for ready manuscripts and in `bind_to_holder()`
/// once the holder has been resolved.
/obj/item/book/granter/resident_manuscript/proc/stamp_default_seals()
	if(!document_profile)
		return
	for(var/seal_key in document_profile.get_default_seal_keys())
		if(!seals[seal_key])
			stamp_seal(seal_key, null, FALSE)

/obj/item/book/granter/resident_manuscript/proc/generate_fake_seals()
	var/list/available_seals = list()
	for(var/seal_key in get_profile_seal_keys())
		available_seals += seal_key
		if(prob(70))
			stamp_seal(seal_key, null, TRUE)
	if(!has_any_seal() && length(available_seals))
		stamp_seal(pick(available_seals), null, TRUE)

/obj/item/book/granter/resident_manuscript/proc/has_any_seal()
	if(!seals)
		return FALSE
	for(var/seal_key in seals)
		if(seals[seal_key])
			return TRUE
	return FALSE

/obj/item/book/granter/resident_manuscript/proc/seal_entry(seal_key, mob/user, dominant_key)
	var/datum/resident_manuscript_seal_rule/rule = get_seal_rule(seal_key)
	if(!rule)
		return null
	var/list/entry = seals?[seal_key]
	var/list/result = list(
		"key" = seal_key,
		"label" = rule.title || rule.key,
		"stamped" = entry ? TRUE : FALSE,
		"stamper" = entry ? entry["stamper"] : "",
		"visible" = TRUE,
		"suspicious" = entry ? entry["suspicious"] : FALSE,
		"priority" = rule.priority,
		"dominant" = (dominant_key && dominant_key == seal_key) ? TRUE : FALSE,
	)
	qdel(rule)
	return result

/// Returns the manuscript's seals already sorted by ascending priority and
/// tagged with `dominant` for the highest-authority stamp. The TGUI is a pure
/// renderer -- it never reorders or recomputes "important seal" itself.
/obj/item/book/granter/resident_manuscript/proc/get_seals_for_ui(mob/user)
	var/dominant_key = get_dominant_seal_key()
	var/list/result = list()
	for(var/seal_key in get_sorted_seal_keys())
		var/list/entry = seal_entry(seal_key, user, dominant_key)
		if(entry)
			result += list(entry)
	return result

/obj/item/book/granter/resident_manuscript/proc/generate_defect_note_keys()
	var/list/available_defects = resident_manuscript_defect_keys()
	var/list/generated_defects = list()
	var/defect_count = rand(RESIDENT_MANUSCRIPT_MIN_DEFECTS, RESIDENT_MANUSCRIPT_MAX_DEFECTS)
	while(length(generated_defects) < defect_count && length(available_defects))
		var/selected_defect = pick(available_defects)
		generated_defects += selected_defect
		available_defects -= selected_defect
	return generated_defects

/obj/item/book/granter/resident_manuscript/proc/ensure_defect_note_keys()
	if(length(defect_note_keys) >= RESIDENT_MANUSCRIPT_MIN_DEFECTS)
		return
	defect_note_keys = generate_defect_note_keys()

/obj/item/book/granter/resident_manuscript/proc/can_edit_fake_manuscript(mob/living/carbon/human/user)
	return ishuman(user) && is_fake && !is_bound

/obj/item/book/granter/resident_manuscript/proc/can_bind_from_ui(mob/living/carbon/human/user)
	return ishuman(user) && !is_bound && !is_fake && !requires_feather_to_bind

/obj/item/book/granter/resident_manuscript/proc/can_stamp_manuscript(mob/living/carbon/human/user)
	if(!ishuman(user) || !is_bound)
		return FALSE
	var/seal_key = get_seal_key_for_user(user)
	if(seal_key && !seals?[seal_key])
		return TRUE
	return FALSE

/obj/item/book/granter/resident_manuscript/proc/is_barred_from_residence(mob/living/carbon/human/user)
	if(!ishuman(user))
		return TRUE
	if(HAS_TRAIT(user, TRAIT_OUTLAW) || HAS_TRAIT(user, TRAIT_HERESIARCH) || HAS_TRAIT(user, TRAIT_EXCOMMUNICATED))
		return TRUE
	if((user.name in GLOB.outlawed_players) || (user.real_name in GLOB.outlawed_players))
		return TRUE
	if((user.name in GLOB.excommunicated_players) || (user.real_name in GLOB.excommunicated_players))
		return TRUE
	return FALSE

/obj/item/book/granter/resident_manuscript/proc/can_claim_residence(mob/living/carbon/human/user)
	if(!ishuman(user) || !owner_character_key || is_fake)
		return FALSE
	if(!document_profile?.grants_residence_claim)
		return FALSE
	if(get_detection_character_key(user) != owner_character_key)
		return FALSE
	if(HAS_TRAIT(user, TRAIT_RESIDENT) || is_barred_from_residence(user))
		return FALSE
	var/needs_seal = TRUE
	if(!document_profile.requires_seal_for_claim)
		needs_seal = FALSE
	if(needs_seal && !has_any_seal())
		return FALSE
	return TRUE

/obj/item/book/granter/resident_manuscript/proc/is_ruling_authority(mob/living/carbon/human/user)
	if(!ishuman(user))
		return FALSE
	var/datum/job/job = SSjob.GetJob(user.mind?.assigned_role)
	return istype(job, /datum/job/roguetown/lord) || istype(job, /datum/job/roguetown/hand)

/obj/item/book/granter/resident_manuscript/proc/can_inspect_manuscript(mob/living/carbon/human/user)
	if(!ishuman(user) || !is_bound || is_owner_viewer(user))
		return FALSE
	var/detection_key = get_detection_character_key(user)
	if(!detection_key || LAZYACCESS(detection_attempts, detection_key))
		return FALSE
	if(authority_validated && !is_ruling_authority(user))
		return FALSE
	return TRUE

/obj/item/book/granter/resident_manuscript/proc/save_fake_manuscript(mob/living/carbon/human/user, list/params)
	if(!can_edit_fake_manuscript(user))
		return FALSE
	if(!params)
		params = list()
	owner_character_key = null
	owner_name = sanitize_manuscript_field(params["owner_name"], MAX_NAME_LEN, "Unknown")
	owner_age = sanitize_manuscript_field(params["owner_age"], MAX_NAME_LEN, "")
	owner_status_key = normalize_status_key(params["owner_status_key"])
	if(maybe_swap_profile_for_status())
		generate_fake_seals()
		if(prob(RESIDENT_MANUSCRIPT_FAKE_DEFECT_CHANCE))
			ensure_defect_note_keys()
	is_bound = TRUE
	name = "Resident Manuscript"
	icon_state = "contractsigned"
	authority_validated = FALSE
	detection_attempts = list()
	detection_results = list()
	detection_note_keys = list()
	playsound(user, 'sound/items/write.ogg', 40, TRUE, -2)
	to_chat(user, span_notice("You complete the suspicious manuscript."))
	return TRUE

/obj/item/book/granter/resident_manuscript/proc/claim_residence(mob/living/carbon/human/user)
	if(!can_claim_residence(user))
		return FALSE
	ADD_TRAIT(user, TRAIT_RESIDENT, TRAIT_GENERIC)
	to_chat(user, span_notice("The seals are sufficient proof: you are recognized as a resident of these lands."))
	return TRUE

/obj/item/book/granter/resident_manuscript/proc/handle_stamp(mob/living/carbon/human/user)
	if(!can_stamp_manuscript(user))
		return FALSE
	var/seal_key = get_seal_key_for_user(user)
	if(!stamp_seal(seal_key, user, FALSE))
		return FALSE
	playsound(user, 'sound/items/write.ogg', 50, TRUE, -2)
	to_chat(user, span_notice("You press your seal into the manuscript."))
	return TRUE

/obj/item/book/granter/resident_manuscript/proc/log_detection_attempt(mob/living/carbon/human/user, result)
	var/log_ckey = user.ckey || user.key || "no ckey"
	var/character_name = user.real_name || user.name || "Unknown"
	var/scroll_owner_name = owner_name || "Unbound"
	log_game("RESIDENT MANUSCRIPT: inspect document=[REF(src)] inspector_ckey=[log_ckey] inspector_name=[character_name] result=[result] scroll_owner=[scroll_owner_name]")

/obj/item/book/granter/resident_manuscript/proc/handle_detection(mob/living/carbon/human/user)
	if(!can_inspect_manuscript(user))
		return FALSE
	var/detection_key = get_detection_character_key(user)
	LAZYSET(detection_attempts, detection_key, TRUE)
	var/result = RESIDENT_MANUSCRIPT_VERIFICATION_UNKNOWN
	var/chance = 5
	chance += max(user.get_true_stat(STATKEY_INT) - 10, 0) * 4
	chance += max(user.get_true_stat(STATKEY_PER) - 10, 0) * 3
	chance += user.get_skill_level(/datum/skill/misc/reading) * 10
	if(HAS_TRAIT(user, TRAIT_INTELLECTUAL))
		chance += 15
	if(is_ruling_authority(user))
		chance += 20
	if(prob(clamp(chance, 5, 95)))
		if(is_fake)
			ensure_defect_note_keys()
			result = RESIDENT_MANUSCRIPT_VERIFICATION_FAKE
		else
			result = RESIDENT_MANUSCRIPT_VERIFICATION_REAL
	else if(!is_fake)
		result = RESIDENT_MANUSCRIPT_VERIFICATION_REAL
	else if(is_ruling_authority(user))
		authority_validated = TRUE
	LAZYSET(detection_results, detection_key, result)
	log_detection_attempt(user, result)
	if(result == RESIDENT_MANUSCRIPT_VERIFICATION_FAKE)
		to_chat(user, span_warning("You detect signs of forgery in the manuscript."))
	else
		var/note_key = pick(resident_manuscript_validation_note_keys())
		LAZYSET(detection_note_keys, detection_key, note_key)
	return TRUE

/obj/item/book/granter/resident_manuscript/examine(mob/user)
	. = ..()
	if(is_bound && owner_name)
		. += span_info("The manuscript is issued to [owner_name].")
	else
		. += span_info("The manuscript is not yet bound to an owner.")

/obj/item/book/granter/resident_manuscript/attack_self(mob/living/user)
	ui_interact(user)

/obj/item/book/granter/resident_manuscript/equipped(mob/living/user, slot)
	. = ..()
	if(!auto_bind_on_equip || is_bound || !ishuman(user))
		return
	bind_to_holder(user)

/obj/item/book/granter/resident_manuscript/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/natural/feather) && ishuman(user))
		if(handle_feather_use(user))
			return
	return ..()

/obj/item/book/granter/resident_manuscript/proc/handle_feather_use(mob/living/carbon/human/user)
	if(!is_bound)
		if(is_fake)
			ui_interact(user)
			return TRUE
		if(bind_to_holder(user))
			to_chat(user, span_notice("You fill the manuscript and bind it to your name."))
			playsound(user, 'sound/items/write.ogg', 40, TRUE, -2)
			return TRUE
	if(handle_stamp(user))
		return TRUE
	to_chat(user, span_warning("You cannot add anything proper to this manuscript."))
	return TRUE

/obj/item/book/granter/resident_manuscript/ui_state(mob/user)
	return GLOB.hands_state

/obj/item/book/granter/resident_manuscript/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ResidentManuscript", "Resident Manuscript")
		ui.open()

/obj/item/book/granter/resident_manuscript/ui_static_data(mob/user)
	var/list/data = list()
	data["language"] = get_resident_manuscript_ui_language(user)
	return data

/obj/item/book/granter/resident_manuscript/ui_data(mob/user)
	var/list/data = list()
	var/mob/living/carbon/human/human_user
	if(ishuman(user))
		human_user = user
	var/detection_key = human_user ? get_detection_character_key(human_user) : null
	var/is_owner_viewing = human_user ? is_owner_viewer(human_user) : FALSE
	var/can_edit_fake = human_user ? can_edit_fake_manuscript(human_user) : FALSE
	var/seal_key = human_user ? get_seal_key_for_user(human_user) : null
	var/can_stamp = FALSE
	if(human_user && is_bound && seal_key && !seals?[seal_key])
		can_stamp = TRUE
	var/can_inspect = human_user ? can_inspect_manuscript(human_user) : FALSE
	var/can_claim = human_user ? can_claim_residence(human_user) : FALSE
	var/can_bind = human_user ? can_bind_from_ui(human_user) : FALSE
	var/list/verification = list(
		"done" = FALSE,
		"result" = RESIDENT_MANUSCRIPT_VERIFICATION_NONE,
		"note_key" = null,
		"defect_note_key" = null,
		"defect_note_keys" = list(),
	)
	if(detection_key && LAZYACCESS(detection_attempts, detection_key))
		var/result = LAZYACCESS(detection_results, detection_key) || RESIDENT_MANUSCRIPT_VERIFICATION_UNKNOWN
		verification["done"] = TRUE
		verification["result"] = result
		if(result == RESIDENT_MANUSCRIPT_VERIFICATION_FAKE)
			verification["defect_note_keys"] = defect_note_keys || list()
			verification["defect_note_key"] = length(defect_note_keys) ? defect_note_keys[1] : null
		else
			verification["note_key"] = LAZYACCESS(detection_note_keys, detection_key)
	data["owner"] = list(
		"name" = owner_name,
		"age" = owner_age,
		"status" = owner_status_key,
		"status_key" = owner_status_key,
	)
	data["issued_place"] = issued_place
	data["expiry_date"] = expiry_date
	data["is_bound"] = is_bound
	data["is_fake"] = is_fake
	data["is_blank"] = requires_feather_to_bind && !is_bound
	data["is_owner"] = is_owner_viewing
	data["profile"] = list(
		"id" = document_profile?.id || "resident",
		"paper_color" = document_profile?.paper_color,
		"ink_color" = document_profile?.ink_color,
		"accent_color" = document_profile?.accent_color,
		"seal_color" = document_profile?.seal_color,
	)
	var/sorted_seals = get_seals_for_ui(user)
	var/list/dominant_entry
	for(var/list/entry as anything in sorted_seals)
		if(entry["dominant"])
			dominant_entry = entry
			break
	data["seals"] = sorted_seals
	data["dominant_seal"] = dominant_entry
	data["verification"] = verification
	data["permissions"] = list(
		"can_edit" = can_edit_fake,
		"can_stamp" = can_stamp,
		"can_inspect" = can_inspect,
		"can_claim" = can_claim,
		"can_bind" = can_bind,
		"stamp_key" = seal_key,
	)
	return data

/obj/item/book/granter/resident_manuscript/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!ishuman(usr))
		return FALSE
	var/mob/living/carbon/human/human_user = usr
	switch(action)
		if("save_fake")
			return save_fake_manuscript(human_user, params)
		if("inspect")
			return handle_detection(human_user)
		if("stamp")
			return handle_stamp(human_user)
		if("claim_residence")
			return claim_residence(human_user)
		if("bind")
			return bind_to_holder(human_user)
	return FALSE

/obj/item/book/granter/resident_manuscript/blank
	name = "Blank Resident Manuscript"
	desc = "A blank resident manuscript. Fill it with a feather, then bring it to the proper authorities for seals."
	icon_state = "contractunsigned"
	auto_stamp_seals = FALSE
	auto_bind_on_equip = FALSE
	requires_feather_to_bind = TRUE

/obj/item/book/granter/resident_manuscript/fake
	name = "Suspicious Resident Manuscript"
	desc = "A resident manuscript whose provenance is best left unmentioned."
	auto_stamp_seals = FALSE
	auto_bind_on_equip = FALSE
	is_fake = TRUE

/obj/item/book/granter/resident_manuscript/fake/Initialize()
	. = ..()
	generate_fake_seals()
	if(prob(RESIDENT_MANUSCRIPT_FAKE_DEFECT_CHANCE))
		ensure_defect_note_keys()

/obj/item/book/granter/resident_manuscript/roundstart
	expiry_year_bonus_min = 5
	expiry_year_bonus_max = 10

/obj/item/book/granter/resident_manuscript/guards
	desc = "An azure mandate of the Azurian watch, granting the bearer authority of city order under the Crown."
	document_profile_id = "guards"

/obj/item/book/granter/resident_manuscript/blank/guards
	desc = "A blank Azurian Warden mandate. Fill it with a feather, then bring it to the proper authorities for seals."
	document_profile_id = "guards"

/obj/item/book/granter/resident_manuscript/fake/guards
	desc = "An Azurian mandate whose provenance is best left unmentioned."
	document_profile_id = "guards"

/obj/item/book/granter/resident_manuscript/church
	desc = "An ecclesiastical writ of the Tenfold Church, recognizing the bearer as a faithful child of the faith."
	document_profile_id = "church"

/obj/item/book/granter/resident_manuscript/blank/church
	desc = "A blank ecclesiastical writ. Fill it with a feather, then bring it for the bishop's seal."
	document_profile_id = "church"

/obj/item/book/granter/resident_manuscript/fake/church
	desc = "An ecclesiastical writ whose provenance is best left unmentioned."
	document_profile_id = "church"

/obj/item/book/granter/resident_manuscript/craftsmen
	desc = "An artisan guild charter, recognizing the bearer's standing among the city's masterly estate."
	document_profile_id = "craftsmen"

/obj/item/book/granter/resident_manuscript/blank/craftsmen
	desc = "A blank artisan guild charter. Fill it with a feather, then bring it to the proper authorities for seals."
	document_profile_id = "craftsmen"

/obj/item/book/granter/resident_manuscript/fake/craftsmen
	desc = "A guild charter whose provenance is best left unmentioned."
	document_profile_id = "craftsmen"

/obj/item/book/granter/resident_manuscript/commoner
	desc = "A modest gray commoner manuscript, attesting only that the bearer is a lawful subject."
	document_profile_id = "commoner"

/obj/item/book/granter/resident_manuscript/blank/commoner
	desc = "A blank commoner manuscript. Fill it with a feather to claim plain residence."
	document_profile_id = "commoner"

/obj/item/book/granter/resident_manuscript/fake/commoner
	desc = "A commoner manuscript whose provenance is best left unmentioned."
	document_profile_id = "commoner"

/obj/item/book/granter/resident_manuscript/mercenary
	desc = "A purple mercenary compact, recognizing the bearer as a free blade of standing."
	document_profile_id = "mercenary"

/obj/item/book/granter/resident_manuscript/blank/mercenary
	desc = "A blank mercenary compact. Fill it with a feather, then bring it to the proper authorities for seals."
	document_profile_id = "mercenary"

/obj/item/book/granter/resident_manuscript/fake/mercenary
	desc = "A mercenary compact whose provenance is best left unmentioned."
	document_profile_id = "mercenary"

/obj/item/book/granter/resident_manuscript/otava
	desc = "A silver-gold edict of the Otavan inquisition, empowering the bearer in matters of truth and faith."
	document_profile_id = "otava"

/obj/item/book/granter/resident_manuscript/blank/otava
	desc = "A blank Otavan edict. Fill it with a feather, then bring it for the inquisitor's seal."
	document_profile_id = "otava"

/obj/item/book/granter/resident_manuscript/fake/otava
	desc = "An Otavan edict whose provenance is best left unmentioned."
	document_profile_id = "otava"

/obj/item/book/granter/resident_manuscript/merchant
	desc = "A Merchant Shop charter, recognizing the bearer's standing in trade and contract."
	document_profile_id = "merchant"

/obj/item/book/granter/resident_manuscript/blank/merchant
	desc = "A blank Merchant Shop charter. Fill it with a feather, then bring it for the master's seal."
	document_profile_id = "merchant"

/obj/item/book/granter/resident_manuscript/fake/merchant
	desc = "A Merchant Shop charter whose provenance is best left unmentioned."
	document_profile_id = "merchant"

/obj/item/book/granter/resident_manuscript/mages
	desc = "A Mage's Guild patent, recognizing the bearer as a licensed practitioner under the Duchy."
	document_profile_id = "mages"

/obj/item/book/granter/resident_manuscript/blank/mages
	desc = "A blank Mage's Guild patent. Fill it with a feather, then bring it for the Court Magician's seal."
	document_profile_id = "mages"

/obj/item/book/granter/resident_manuscript/fake/mages
	desc = "A Mage's Guild patent whose provenance is best left unmentioned."
	document_profile_id = "mages"

/obj/item/book/granter/resident_manuscript/inn
	desc = "An Innkeep's writ, attesting the bearer's lawful keeping of the central inn."
	document_profile_id = "inn"

/obj/item/book/granter/resident_manuscript/blank/inn
	desc = "A blank Innkeep's writ. Fill it with a feather, then bring it for the Innkeep's seal."
	document_profile_id = "inn"

/obj/item/book/granter/resident_manuscript/fake/inn
	desc = "An Innkeep's writ whose provenance is best left unmentioned."
	document_profile_id = "inn"

/obj/item/book/granter/resident_manuscript/bathhouse
	desc = "A Bathhouse patent, granting the bearer leave to keep the steam, scent and trade beneath the inn."
	document_profile_id = "bathhouse"

/obj/item/book/granter/resident_manuscript/blank/bathhouse
	desc = "A blank Bathhouse patent. Fill it with a feather, then bring it for the Bathmaster's seal."
	document_profile_id = "bathhouse"

/obj/item/book/granter/resident_manuscript/fake/bathhouse
	desc = "A Bathhouse patent whose provenance is best left unmentioned."
	document_profile_id = "bathhouse"
