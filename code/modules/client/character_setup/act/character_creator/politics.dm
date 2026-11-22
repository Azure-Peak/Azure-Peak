/datum/preferences/proc/ui_act_character_creator_politics(action, list/params, datum/tgui/ui, datum/ui_state/state)
	var/mob/user = ui.user

	switch(action)
		if("set_estate_region")
			var/datum/economic_region/region = GLOB.economic_regions[params["region_id"]]
			if(!region)
				return CHARACTER_ACT_DATA_UPDATE
			var/datum/economic_region/current = GLOB.economic_regions[estate_region]
			verbose_pref_log_change(user, "notice", "Estate", current?.name, region.name)
			estate_region = region.region_id
			return CHARACTER_ACT_DATA_UPDATE

		if("set_political_faction")
			var/datum/political_faction/faction = GLOB.political_factions[params["faction_id"]]
			if(!faction || !faction.allows_patron(selected_patron))
				return CHARACTER_ACT_DATA_UPDATE
			var/datum/political_faction/current = GLOB.political_factions[political_faction]
			verbose_pref_log_change(user, "notice", "Political Faction", current?.name, faction.name)
			political_faction = faction.id
			return CHARACTER_ACT_DATA_UPDATE

		if("open_faction_wiki")
			var/datum/political_faction/faction = GLOB.political_factions[params["faction_id"]]
			if(faction?.wiki_url)
				user << link(faction.wiki_url)
			return CHARACTER_ACT_DATA_UPDATE
