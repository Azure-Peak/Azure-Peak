#define ALTER_EGO_LOOKS list(/datum/descriptor_choice/height, /datum/descriptor_choice/body, /datum/descriptor_choice/stature)
#define ALTER_EGO_VOICE_INDEX 9

/datum/component/alter_ego
	/// Voice color captured when the alter ego was put on
	var/natural_color
	/// Voice color used while the alter ego is active
	var/alter_color
	/// Voice descriptor path captured when the alter ego was put on
	var/natural_voice
	/// Voice descriptor path used while the alter ego is active
	var/alter_voice
	/// Custom voice entry captured when the alter ego was put on
	var/datum/custom_descriptor_entry/natural_entry
	/// Alternate descriptor paths
	var/list/alter_looks = list()
	/// Alternate descriptor entries
	var/list/alter_customs = list()
	var/active = FALSE

/datum/component/alter_ego/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/alter_ego/proc/disguised(mob/watcher)
	var/mob/living/carbon/human/H = parent
	return active && !isobserver(watcher) && H.get_face_name() != H.real_name

/datum/component/alter_ego/proc/apply(state)
	var/mob/living/carbon/human/H = parent
	if(state)
		natural_color = H.voice_color
		natural_voice = H.get_descriptor_of_slot(MOB_DESCRIPTOR_SLOT_VOICE, H.mob_descriptors)
		natural_entry = H.custom_entry(ALTER_EGO_VOICE_INDEX)
	active = state
	if(alter_color)
		H.voice_color = active ? alter_color : natural_color
	if(!alter_voice)
		return
	H.remove_mob_descriptor(active ? natural_voice : alter_voice)
	var/new_voice = active ? alter_voice : natural_voice
	if(new_voice)
		H.add_mob_descriptor(new_voice)
	var/datum/custom_descriptor_entry/entry = active ? alter_customs["[ALTER_EGO_VOICE_INDEX]"] : natural_entry
	if(entry && length(H.custom_descriptors) >= ALTER_EGO_VOICE_INDEX)
		H.custom_descriptors[ALTER_EGO_VOICE_INDEX] = entry

/datum/component/alter_ego/proc/reshape(color, voice)
	var/was_active = active
	if(was_active)
		apply(FALSE)
	if(color)
		alter_color = color
	if(voice)
		alter_voice = voice
	if(was_active)
		apply(TRUE)

/datum/component/alter_ego/proc/prompt(choice_type)
	var/mob/living/carbon/human/H = parent
	var/datum/descriptor_choice/choice = DESCRIPTOR_CHOICE(choice_type)
	var/list/options = list()
	for(var/path in choice.descriptors)
		var/datum/mob_descriptor/D = MOB_DESCRIPTOR(path)
		options[D.name] = path
	var/picked = tgui_input_list(H, "Choose the [LOWER_TEXT(choice.name)] of my alter ego (cancel to keep my own)", "ALTER EGO", options)
	if(!picked)
		return
	var/path = options[picked]
	var/static/list/custom_types = CUSTOM_DESCRIPTOR_TYPE_LIST
	var/index = custom_types.Find(path)
	if(!index)
		return path
	var/static/list/article_types = CUSTOM_DESCRIPTOR_ARTICLE_ONLY
	var/static/list/articles = CUSTOM_ARTICLE_INPUT_LIST
	var/datum/custom_descriptor_entry/entry = new()
	if(path in article_types)
		var/article = tgui_input_list(H, "Choose the article", "ALTER EGO", articles)
		if(!article)
			return
		entry.prefix_type = articles[article]
	var/text = tgui_input_text(H, "Describe it", "ALTER EGO", max_length = CUSTOM_DESCRIPTOR_TEXT_LENGTH, encode = FALSE)
	if(!text)
		return
	entry.content_text = STRIP_HTML_SIMPLE(LOWER_TEXT(text), PREVENT_CHARACTER_TRIM_LOSS(CUSTOM_DESCRIPTOR_TEXT_LENGTH))
	alter_customs["[index]"] = entry
	return path

/mob/living/carbon/human/get_base_descriptors(mob/watcher)
	var/list/descs = ..()
	var/datum/component/alter_ego/ego = GetComponent(/datum/component/alter_ego)
	if(!ego?.disguised(watcher))
		return descs
	descs = descs ? descs.Copy() : list()
	for(var/slot in ego.alter_looks)
		descs -= get_descriptor_of_slot(text2num(slot), descs)
		descs += ego.alter_looks[slot]
	return descs

/mob/living/carbon/human/custom_entry(index)
	var/datum/component/alter_ego/ego = GetComponent(/datum/component/alter_ego)
	if(ego?.alter_customs["[index]"] && ego.disguised())
		return ego.alter_customs["[index]"]
	return ..()

/mob/living/carbon/human/proc/alterego_color()
	set name = "Alter Ego: Voice Color (Can only use Once!)"
	set category = "RoleUnique.Virtue"

	var/new_color = input(src, "Choose my alter ego's voice color:", "ALTER EGO", "#a0a0a0") as color|null
	if(!new_color)
		return
	var/datum/component/alter_ego/ego = LoadComponent(/datum/component/alter_ego)
	ego.reshape(color = sanitize_hexcolor(new_color, 6, TRUE))
	to_chat(src, span_notice("Alter ego voice color set to [ego.alter_color]."))
	remove_verb(src, /mob/living/carbon/human/proc/alterego_color)

/mob/living/carbon/human/proc/alterego_voice()
	set name = "Alter Ego: Voice (Can only use Once!)"
	set category = "RoleUnique.Virtue"

	var/datum/component/alter_ego/ego = LoadComponent(/datum/component/alter_ego)
	var/path = ego.prompt(/datum/descriptor_choice/voice)
	if(!path)
		return
	ego.reshape(voice = path)
	to_chat(src, span_notice("Alter ego voice set."))
	remove_verb(src, /mob/living/carbon/human/proc/alterego_voice)

/mob/living/carbon/human/proc/alterego_looks()
	set name = "Alter Ego: Descriptors (Can only use Once!)"
	set category = "RoleUnique.Virtue"

	var/datum/component/alter_ego/ego = LoadComponent(/datum/component/alter_ego)
	var/changed = FALSE
	for(var/choice_type in ALTER_EGO_LOOKS)
		if(!(choice_type in dna?.species?.descriptor_choices))
			continue
		var/path = ego.prompt(choice_type)
		if(!path)
			continue
		var/datum/mob_descriptor/D = MOB_DESCRIPTOR(path)
		ego.alter_looks["[D.slot]"] = path
		changed = TRUE
	if(!changed)
		return
	to_chat(src, span_notice("Alter ego descriptors set. They only show while my face is hidden."))
	remove_verb(src, /mob/living/carbon/human/proc/alterego_looks)

/mob/living/carbon/human/proc/alterego_swap()
	set name = "Swap Alter Ego"
	set category = "RoleUnique.Virtue"

	var/datum/component/alter_ego/ego = LoadComponent(/datum/component/alter_ego)
	if(!ego.alter_color && !ego.alter_voice && !length(ego.alter_looks))
		to_chat(src, span_info("I haven't shaped my alter ego yet."))
		return
	ego.apply(!ego.active)
	name = get_visible_name()
	to_chat(src, span_info(ego.active ? "I am someone else, now." : "Hello, little old me.."))

#undef ALTER_EGO_LOOKS
#undef ALTER_EGO_VOICE_INDEX
