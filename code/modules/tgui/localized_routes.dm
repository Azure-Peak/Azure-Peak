/// Maps one base TGUI interface to a language-specific interface route.
/datum/tgui_localized_route
	var/base_interface
	var/language_code = DEFAULT_PREFERRED_UI_LANGUAGE
	var/interface_name
	var/window_title

GLOBAL_LIST_INIT(tgui_localized_routes, build_tgui_localized_routes())

/proc/build_tgui_localized_routes()
	. = list()
	for(var/route_path in subtypesof(/datum/tgui_localized_route))
		var/datum/tgui_localized_route/route = new route_path()
		if(!istext(route.base_interface) || !length(route.base_interface) || !istext(route.language_code) || !length(route.language_code) || !istext(route.interface_name) || !length(route.interface_name))
			qdel(route)
			continue

		var/list/by_language = .[route.base_interface]
		if(!by_language)
			by_language = list()
			.[route.base_interface] = by_language

		by_language[lowertext(route.language_code)] = list(
			"interface" = route.interface_name,
			"title" = route.window_title,
		)
		qdel(route)

/proc/get_tgui_language(mob/user)
	var/language_code = DEFAULT_PREFERRED_UI_LANGUAGE
	var/client/client = user?.client
	if(client)
		language_code = client.get_preferred_ui_language()
	if(!istext(language_code) || !length(language_code))
		return DEFAULT_PREFERRED_UI_LANGUAGE
	return lowertext(language_code)

/proc/get_tgui_localized_route(base_interface, language_code)
	if(!istext(base_interface) || !length(base_interface) || !istext(language_code) || !length(language_code))
		return null
	var/list/by_language = GLOB.tgui_localized_routes[base_interface]
	if(!islist(by_language))
		return null
	var/list/route = by_language[lowertext(language_code)]
	return islist(route) ? route : null

/proc/get_tgui_interface_name(mob/user, base_interface)
	var/list/route = get_tgui_localized_route(base_interface, get_tgui_language(user))
	return route ? route["interface"] : base_interface

/proc/get_tgui_window_title(mob/user, base_interface, fallback_title)
	var/list/route = get_tgui_localized_route(base_interface, get_tgui_language(user))
	return route && route["title"] ? route["title"] : fallback_title

/proc/get_tgui_locale_data(mob/user)
	var/language_code = get_tgui_language(user)
	return list(
		"language" = language_code,
		"locale" = language_code,
	)
