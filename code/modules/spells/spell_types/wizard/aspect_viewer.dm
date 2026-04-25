/datum/aspect_viewer
	var/mob/living/owner
	/// If TRUE, qdel self when UI closes (used for encyclopedia-spawned viewers)
	var/ephemeral = FALSE

/datum/aspect_viewer/New(mob/living/new_owner)
	owner = new_owner

/datum/aspect_viewer/Destroy()
	owner = null
	return ..()

/datum/aspect_viewer/ui_close(mob/user)
	if(ephemeral)
		qdel(src)

/datum/aspect_viewer/ui_state(mob/user)
	return GLOB.always_state

/datum/aspect_viewer/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GrimoireAspectPicker", "Arcyne Compendium", 860, 580)
		ui.open()

/datum/aspect_viewer/ui_static_data(mob/user)
	var/list/data = list()
	var/datum/aspect_picker/builder = new(owner, FALSE)
	data["major_aspects"] = builder.build_aspect_list(GLOB.magic_aspects_major)
	data["minor_aspects"] = builder.build_aspect_list(GLOB.magic_aspects_minor)
	data["utility_spells"] = builder.build_utility_list()
	qdel(builder)
	return data

/datum/aspect_viewer/ui_data(mob/user)
	var/list/data = list()
	data["read_only"] = TRUE
	data["user_tier"] = 0
	data["max_majors"] = 0
	data["max_minors"] = 0
	data["max_utilities"] = 0
	data["initial_setup"] = FALSE
	data["attuned_majors"] = list()
	data["attuned_minors"] = list()
	data["selected_utilities"] = list()
	data["locked_aspects"] = list()
	data["staged_choices"] = list()
	data["pointbuy_selections"] = list()
	data["all_selected_spells"] = list()
	data["spent_budgets"] = list()
	data["utility_points_spent"] = 0
	data["reset_budget"] = 0
	data["reset_budget_max"] = 0
	data["resets_used"] = 0
	data["staged_unbind_aspects"] = list()
	data["staged_unbind_utilities"] = list()
	data["known_utilities"] = list()
	return data

/datum/aspect_viewer/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	return FALSE

/obj/item/book/arcyne_compendium
	name = "Arcyne Compendium"
	desc = "A comprehensive reference tome cataloguing all known arcyne disciplines, aspects, and utility spells. Its pages shimmer faintly with residual magic."
	icon = 'icons/roguetown/items/books.dmi'
	icon_state = "book4_0"
	unique = TRUE
	var/datum/aspect_viewer/viewer

/obj/item/book/arcyne_compendium/attack_self(mob/living/user)
	if(!viewer)
		viewer = new(user)
	viewer.ui_interact(user)

/obj/item/book/arcyne_compendium/Destroy()
	QDEL_NULL(viewer)
	return ..()
