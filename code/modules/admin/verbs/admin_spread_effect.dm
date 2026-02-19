/client/proc/admin_spread_effect()
	set name = "Spread Effect"
	set category = "-GameMaster-"

	if(!check_rights(R_ADMIN))
		return

	var/list/effect_types = typesof(/datum/effect_system/smoke_spread)

	var/list/effect_names = list()
	for(var/type in effect_types)
		effect_names[type] = "[type]"

	var/selected_type = input("Select an effect to spread:", "Choose Effect") as null|anything in effect_names
	if(!selected_type)
		return

	var/new_radius = input("Enter effect radius (1-10):", "Set Effect Radius", 2) as num|null
	if(!new_radius)
		return
	new_radius = clamp(new_radius, 1, 10)

	var/datum/effect_system/smoke_spread/S = new selected_type
	var/turf/T = usr.loc
	S.set_up(new_radius, T)
	S.start()

	to_chat(usr, span_notice("[selected_type] effect deployed at ([T.x], [T.y], [T.z]) with radius [new_radius]."))
//can be expanded the other effects later
