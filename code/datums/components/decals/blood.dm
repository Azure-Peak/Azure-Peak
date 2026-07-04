/datum/component/decal/blood
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/blood_color = BLOOD_COLOR_RED

/datum/component/decal/blood/Initialize(_icon, _icon_state, _dir, _cleanable=CLEAN_STRENGTH_BLOOD, _color, _layer=ABOVE_OBJ_LAYER)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()
	RegisterSignal(parent, COMSIG_ATOM_GET_EXAMINE_NAME, PROC_REF(get_examine_name))

/datum/component/decal/blood/generate_appearance(_icon, _icon_state, _dir, _layer, _color)
	blood_color = _color || blood_color || BLOOD_COLOR_RED
	var/obj/item/I = parent
	if(I.bigboy)
		if(!_icon)
			_icon = 'icons/effects/bloodbig.dmi'
		if(!_icon_state)
			_icon_state = "itemblood"
	else
		if(!_icon)
			_icon = 'icons/effects/blood.dmi'
		if(!_icon_state)
			_icon_state = "splatter[rand(1,6)]"

	var/icon = I.icon
	var/icon_state = I.icon_state
	var/static/list/blood_splatter_appearances = list()
	//try to find a pre-processed blood-splatter. otherwise, make a new one
	// Use initial icon to avoid cache collisions from dynamic icon objects
	var/base_icon = isfile(icon) ? "[icon]" : "[initial(I.icon)]"
	var/index = "[base_icon]-[icon_state]-[blood_color]"
	pic = blood_splatter_appearances[index]

	if(!pic)
		var/icon/blood_splatter_icon = icon(icon, icon_state, , 1)		//we only want to apply blood-splatters to the initial icon_state for each object
		blood_splatter_icon.Blend(blood_color, ICON_ADD) 			//fills the icon_state with white (except where it's transparent)
		if(blood_color)
			blood_splatter_icon.ColorTone(blood_color)
		blood_splatter_icon.Blend(icon(_icon, _icon_state), ICON_MULTIPLY) //adds blood and the remaining white areas become transparant
		pic = mutable_appearance(blood_splatter_icon, initial(icon_state))
		blood_splatter_appearances[index] = pic
	pic.alpha = 150
	return TRUE

/datum/component/decal/blood/proc/set_blood_color(new_blood_color)
	if(!new_blood_color || blood_color == new_blood_color)
		return
	blood_color = new_blood_color
	remove()
	generate_appearance()
	apply()

/datum/component/decal/blood/proc/get_examine_name(datum/source, mob/user, list/override)
	var/atom/A = parent
	override[EXAMINE_POSITION_ARTICLE] = A.gender == PLURAL? "some" : "a"
	override[EXAMINE_POSITION_BEFORE] = " <span class='bloody'>bloody</span> "
	return COMPONENT_EXNAME_CHANGED
