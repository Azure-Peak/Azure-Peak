
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

//Crafting Recipe books

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

/////////////////////
// TAILORING BOOKS //
/////////////////////

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

#define RESIDENT_MANUSCRIPT_STATUS_COMMONER "commoner"
#define RESIDENT_MANUSCRIPT_STATUS_NOBLE "noble"
#define RESIDENT_MANUSCRIPT_VERIFICATION_NONE "none"
#define RESIDENT_MANUSCRIPT_VERIFICATION_UNKNOWN "unknown"
#define RESIDENT_MANUSCRIPT_VERIFICATION_REAL "real"
#define RESIDENT_MANUSCRIPT_VERIFICATION_FAKE "fake"
#define RESIDENT_MANUSCRIPT_SPECIAL_ITEM_NAME "Resident Manuscript"
#define RESIDENT_MANUSCRIPT_FAKE_DEFECT_CHANCE 65
#define RESIDENT_MANUSCRIPT_MIN_DEFECTS 3
#define RESIDENT_MANUSCRIPT_MAX_DEFECTS 5

/proc/build_resident_manuscript_ui_texts()
	return list(
		"window_title" = "Resident Manuscript",
		"title" = "Resident Manuscript",
		"subtitle_prefix" = "Under the Crown's Hand",
		"labels" = list(
			"owner" = "Name",
			"age" = "Age",
			"class" = "Vocation",
			"status" = "Estate",
			"expires" = "Valid until",
			"issued" = "Issued at",
			"seals" = "Seals",
			"verification" = "Authenticity",
			"defects" = "Observed defects",
		),
		"buttons" = list(
			"save" = "Save",
			"inspect" = "Inspect",
			"stamp" = "Stamp",
			"claim" = "Claim residency",
			"bind" = "Bind",
		),
		"tooltips" = list(
			"save" = "Save the completed forgery.",
			"inspect" = "Quietly inspect the manuscript for forgery.",
			"stamp" = "Apply the official seal available to you.",
			"claim" = "Use the manuscript as proof of residency.",
			"bind" = "Bind the manuscript to your name.",
		),
		"placeholders" = list(
			"owner" = "Owner name",
			"age" = "Age",
			"class" = "Vocation or station",
		),
		"owner_status_options" = list(
			RESIDENT_MANUSCRIPT_STATUS_COMMONER = "Unproven",
			RESIDENT_MANUSCRIPT_STATUS_NOBLE = "Under Astrata's grace",
		),
		"states" = list(
			"owner" = "This manuscript is recognized as yours.",
			"other" = "This manuscript belongs to another.",
			"unbound" = "This manuscript is not yet bound to an owner.",
			"blank_hint" = "The blank must be filled with a feather.",
			"fake_edit_hint" = "The suspicious blank waits for an inscribed name.",
			"seal_missing" = "not sealed",
			"empty" = "-",
			"unknown" = "Unknown",
		),
		"verification" = list(
			"fake" = "The manuscript appears to be forged.",
			"real" = "The manuscript appears authentic.",
			"unknown" = "The manuscript shows no obvious cause for suspicion.",
			"none" = "Authenticity has not been inspected.",
		),
		"aria" = list(
			"seal" = "Seal",
		),
		"description" = "Let it be known: by the Crown's will and the Council's oversight, the bearer of this document is recognized as a lawful resident of these lands and stands beneath the shelter of common law. Every rank and office is charged to acknowledge the bearer as a faithful subject and to place no unjust obstacle in their path.",
		"defects" = list(
			"ink_blot" = "A faint ink blot marks one corner of the parchment.",
			"seal_smudge" = "The ink around one seal is slightly smeared.",
			"owner_wobble" = "One letter in the owner's name was written with an unsteady hand.",
			"ragged_edge" = "The parchment edge has been cut unevenly.",
			"uncertain_hand" = "The signature lacks a confident hand.",
			"stale_smell" = "The parchment carries a stale smell.",
			"misaligned_initial" = "The lapis initial falls out of line and dried over the main text.",
			"fresh_pricking" = "Fresh ruling pricks on the lower margin do not match the written lines.",
			"cut_gilding" = "The gilded edge lies over a fresh cut in places.",
			"rethreaded_cord" = "The silk-gold cord was threaded again; broken fibers show around the holes.",
			"reheated_wax" = "One wax seal is warmer in color and shines as though recently remelted.",
			"blue_halo" = "The ink casts a blue halo mid-line, as if mixed with different water.",
			"corrected_date" = "One stroke in the date was crossed out too cleanly for a chancery hand.",
			"heretical_marginalia" = "A foreign marginal note shows between the lines: 'Zizo keeps the whisper, Graggar waits for blood, Matthios weighs the debt.'",
		),
		"validation_notes" = list(
			"steady_seals" = "The seals sit evenly, the ink is sure, and the cord bears no sign of being threaded again.",
			"proper_ruling" = "The ruling, pricks, and lines agree with one another; this is a proper manuscript.",
			"matched_hand" = "The hand, seals, and gilded edge agree. There is no obvious reason to doubt the document.",
			"deep_wax" = "The wax took its impression deeply and cleanly, and the lines show no foreign hand.",
			"proper_rite" = "The document appears to have been prepared according to chancery rite.",
		),
	)

/proc/get_resident_manuscript_ui_language(mob/user)
	return DEFAULT_PREFERRED_UI_LANGUAGE

/proc/get_resident_manuscript_ui_texts(mob/user)
	var/static/list/text_cache
	if(!text_cache)
		text_cache = build_resident_manuscript_ui_texts()
	return text_cache

/proc/grant_roundstart_resident_manuscript(mob/living/carbon/human/recipient, manuscript_type = /obj/item/book/granter/resident_manuscript/roundstart)
	if(!ishuman(recipient) || !recipient.mind)
		return FALSE
	if(!HAS_TRAIT(recipient, TRAIT_RESIDENT))
		return FALSE
	if(!recipient.mind.special_items)
		recipient.mind.special_items = list()
	if(recipient.mind.special_items[RESIDENT_MANUSCRIPT_SPECIAL_ITEM_NAME])
		return FALSE
	recipient.mind.special_items[RESIDENT_MANUSCRIPT_SPECIAL_ITEM_NAME] = manuscript_type
	return TRUE

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

/// Downstream role modules can add seal authority by defining new subtypes.
/datum/resident_manuscript_seal_rule
	var/key
	var/en_title
	var/en_stamper
	var/list/job_types = list()
	var/list/advclass_types = list()

/datum/resident_manuscript_seal_rule/proc/title()
	return en_title || key

/datum/resident_manuscript_seal_rule/proc/stamper()
	return en_stamper || en_title || key

/datum/resident_manuscript_seal_rule/proc/can_stamp(mob/living/carbon/human/user)
	if(!ishuman(user))
		return FALSE
	var/datum/job/job = SSjob.GetJob(user.mind?.assigned_role)
	var/list/valid_jobs = job_types || list()
	for(var/job_type in valid_jobs)
		if(istype(job, job_type))
			return TRUE
	var/datum/advclass/advclass
	if(user.advjob)
		advclass = SSrole_class_handler.get_advclass_by_name(user.advjob)
	var/list/valid_advclasses = advclass_types || list()
	for(var/advclass_type in valid_advclasses)
		if(istype(advclass, advclass_type))
			return TRUE
	return FALSE

/datum/resident_manuscript_seal_rule/chancellor
	key = "chancellor"
	en_title = "Chancellor"
	en_stamper = "Chancellor"
	job_types = list(/datum/job/roguetown/councillor)

/datum/resident_manuscript_seal_rule/elder
	key = "elder"
	en_title = "Elder"
	en_stamper = "Elder"
	advclass_types = list(/datum/advclass/elder)

/datum/resident_manuscript_seal_rule/ruler
	key = "ruler"
	en_title = "Duke"
	en_stamper = "Duke"
	job_types = list(/datum/job/roguetown/lord)

/datum/resident_manuscript_seal_rule/hand
	key = "hand"
	en_title = "Hand"
	en_stamper = "Hand"
	job_types = list(/datum/job/roguetown/hand)

/proc/get_resident_manuscript_seal_rules()
	var/static/list/seal_rules
	if(!seal_rules)
		seal_rules = list()
		for(var/rule_type in subtypesof(/datum/resident_manuscript_seal_rule))
			var/datum/resident_manuscript_seal_rule/rule = rule_type
			var/key = initial(rule.key)
			if(!key)
				continue
			seal_rules[key] = rule_type
	return seal_rules

/obj/item/book/granter/resident_manuscript
	name = "Resident Manuscript"
	desc = "A fine ivory manuscript confirming lawful residence under the Crown."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "contractsigned"
	oneuse = FALSE
	drop_sound = 'sound/foley/dropsound/paper_drop.ogg'
	pickup_sound = 'sound/blank.ogg'
	pages_to_mastery = 0
	var/owner_character_key
	var/owner_name
	var/owner_age
	var/owner_class
	var/owner_status_key = RESIDENT_MANUSCRIPT_STATUS_COMMONER
	var/expiry_date
	var/issued_place
	var/is_bound = FALSE
	var/is_fake = FALSE
	var/authority_validated = FALSE
	var/auto_stamp_seals = TRUE
	var/auto_bind_on_equip = TRUE
	var/requires_feather_to_bind = FALSE
	var/can_grant_residence = TRUE
	var/expiry_year_bonus_min = 0
	var/expiry_year_bonus_max = 0
	var/list/seals
	var/list/defect_note_keys
	var/list/detection_attempts
	var/list/detection_results
	var/list/detection_note_keys

/obj/item/book/granter/resident_manuscript/Initialize()
	. = ..()
	issued_place = SSticker?.realm_name || "Azure Peak"
	expiry_date = compute_expiry_date()
	initialize_seals()
	defect_note_keys = list()
	detection_attempts = list()
	detection_results = list()
	detection_note_keys = list()
	if(auto_stamp_seals)
		stamp_all_seals()

/obj/item/book/granter/resident_manuscript/proc/initialize_seals()
	seals = list()
	for(var/seal_key in get_resident_manuscript_seal_rules())
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

/obj/item/book/granter/resident_manuscript/proc/get_owner_class_label(mob/living/carbon/human/target)
	if(!ishuman(target))
		return null
	return target.advjob || target.job || target.mind?.assigned_role || null

/obj/item/book/granter/resident_manuscript/proc/status_key_for(mob/living/carbon/human/target)
	if(HAS_TRAIT(target, TRAIT_NOBLE))
		return RESIDENT_MANUSCRIPT_STATUS_NOBLE
	return RESIDENT_MANUSCRIPT_STATUS_COMMONER

/obj/item/book/granter/resident_manuscript/proc/get_status_text(mob/user)
	var/list/texts = get_resident_manuscript_ui_texts(user)
	var/list/status_options = texts["owner_status_options"]
	return status_options?[owner_status_key] || status_options?[RESIDENT_MANUSCRIPT_STATUS_COMMONER] || owner_status_key

/obj/item/book/granter/resident_manuscript/proc/bind_to_holder(mob/living/carbon/human/target)
	if(is_bound || !ishuman(target))
		return FALSE
	owner_character_key = get_detection_character_key(target)
	owner_name = target.real_name
	owner_age = target.age
	owner_class = get_owner_class_label(target)
	owner_status_key = status_key_for(target)
	is_bound = TRUE
	name = "Resident Manuscript"
	icon_state = "contractsigned"
	if(auto_stamp_seals)
		stamp_all_seals()
	return TRUE

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
	for(var/seal_key in get_resident_manuscript_seal_rules())
		var/datum/resident_manuscript_seal_rule/rule = get_seal_rule(seal_key)
		if(!rule)
			continue
		var/can_stamp = rule.can_stamp(user)
		qdel(rule)
		if(can_stamp)
			return seal_key
	return null

/obj/item/book/granter/resident_manuscript/proc/stamp_seal(seal_key, mob/living/carbon/human/stamper, suspicious = FALSE)
	if(!seals || !(seal_key in seals) || seals[seal_key])
		return FALSE
	var/datum/resident_manuscript_seal_rule/rule = get_seal_rule(seal_key)
	if(!rule)
		return FALSE
	seals[seal_key] = list(
		"stamper" = suspicious ? "Unclear hand" : rule.stamper(),
		"time" = world.time,
		"suspicious" = suspicious,
	)
	qdel(rule)
	return TRUE

/obj/item/book/granter/resident_manuscript/proc/stamp_all_seals()
	for(var/seal_key in get_resident_manuscript_seal_rules())
		if(!seals[seal_key])
			stamp_seal(seal_key, null, FALSE)

/obj/item/book/granter/resident_manuscript/proc/generate_fake_seals()
	var/list/available_seals = list()
	for(var/seal_key in get_resident_manuscript_seal_rules())
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

/obj/item/book/granter/resident_manuscript/proc/seal_entry(seal_key, mob/user)
	var/datum/resident_manuscript_seal_rule/rule = get_seal_rule(seal_key)
	if(!rule)
		return null
	var/list/entry = seals?[seal_key]
	var/list/result = list(
		"key" = seal_key,
		"label" = rule.title(),
		"stamped" = entry ? TRUE : FALSE,
		"stamper" = entry ? entry["stamper"] : "",
		"visible" = TRUE,
		"suspicious" = entry ? entry["suspicious"] : FALSE,
	)
	qdel(rule)
	return result

/obj/item/book/granter/resident_manuscript/proc/get_seals_for_ui(mob/user)
	var/list/result = list()
	for(var/seal_key in get_resident_manuscript_seal_rules())
		result += list(seal_entry(seal_key, user))
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

/obj/item/book/granter/resident_manuscript/proc/localized_defect_notes(mob/user)
	var/list/result = list()
	if(!length(defect_note_keys))
		return result
	var/list/texts = get_resident_manuscript_ui_texts(user)
	var/list/defect_texts = texts["defects"]
	for(var/defect_key in defect_note_keys)
		result += defect_texts?[defect_key] || defect_key
	return result

/obj/item/book/granter/resident_manuscript/proc/localized_validation_note(mob/user, note_key)
	if(!note_key)
		return ""
	var/list/texts = get_resident_manuscript_ui_texts(user)
	var/list/validation_notes = texts["validation_notes"]
	return validation_notes?[note_key] || ""

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
	return can_grant_residence && ishuman(user) && owner_character_key && get_detection_character_key(user) == owner_character_key && !HAS_TRAIT(user, TRAIT_RESIDENT) && !is_barred_from_residence(user) && !is_fake && has_any_seal()

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
	owner_class = sanitize_manuscript_field(params["owner_class"], MAX_NAME_LEN, "")
	owner_status_key = normalize_status_key(params["owner_status_key"])
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
		var/list/texts = get_resident_manuscript_ui_texts(user)
		ui = new(user, src, "ResidentManuscript", texts["window_title"])
		ui.open()

/obj/item/book/granter/resident_manuscript/ui_static_data(mob/user)
	var/list/data = list()
	data["language"] = get_resident_manuscript_ui_language(user)
	data["texts"] = get_resident_manuscript_ui_texts(user)
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
		"note" = "",
		"defect_note" = "",
		"defect_notes" = list(),
	)
	if(detection_key && LAZYACCESS(detection_attempts, detection_key))
		var/result = LAZYACCESS(detection_results, detection_key) || RESIDENT_MANUSCRIPT_VERIFICATION_UNKNOWN
		verification["done"] = TRUE
		verification["result"] = result
		if(result == RESIDENT_MANUSCRIPT_VERIFICATION_FAKE)
			var/list/notes = localized_defect_notes(user)
			verification["defect_notes"] = notes
			verification["defect_note"] = length(notes) ? notes[1] : ""
		else
			verification["note"] = localized_validation_note(user, LAZYACCESS(detection_note_keys, detection_key))
	data["owner"] = list(
		"name" = owner_name,
		"age" = owner_age,
		"class" = owner_class,
		"status" = get_status_text(user),
		"status_key" = owner_status_key,
	)
	data["issued_place"] = issued_place
	data["expiry_date"] = expiry_date
	data["is_bound"] = is_bound
	data["is_fake"] = is_fake
	data["is_blank"] = requires_feather_to_bind && !is_bound
	data["is_owner"] = is_owner_viewing
	data["seals"] = get_seals_for_ui(user)
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
	can_grant_residence = FALSE
	expiry_year_bonus_min = 5
	expiry_year_bonus_max = 10

#undef RESIDENT_MANUSCRIPT_STATUS_COMMONER
#undef RESIDENT_MANUSCRIPT_STATUS_NOBLE
#undef RESIDENT_MANUSCRIPT_VERIFICATION_NONE
#undef RESIDENT_MANUSCRIPT_VERIFICATION_UNKNOWN
#undef RESIDENT_MANUSCRIPT_VERIFICATION_REAL
#undef RESIDENT_MANUSCRIPT_VERIFICATION_FAKE
#undef RESIDENT_MANUSCRIPT_SPECIAL_ITEM_NAME
#undef RESIDENT_MANUSCRIPT_FAKE_DEFECT_CHANCE
#undef RESIDENT_MANUSCRIPT_MIN_DEFECTS
#undef RESIDENT_MANUSCRIPT_MAX_DEFECTS
