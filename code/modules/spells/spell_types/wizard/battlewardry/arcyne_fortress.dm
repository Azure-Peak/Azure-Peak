/datum/action/cooldown/spell/arcyne_fortress
	button_icon = 'icons/mob/actions/mage_battlewardry.dmi'
	name = "Arcyne Fortress"
	desc = "Channel an immense surge of arcyne energy to erect a 5x5 fortress of arrow wards around yourself. \
	Each wall segment blocks incoming projectiles from the outside while allowing you and allies to shoot out freely. \
	The fortress lasts until its cooldown expires or until the walls are destroyed."
	button_icon_state = "arcyne_fortress"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_WARD
	glow_intensity = GLOW_INTENSITY_VERY_HIGH
	attunement_school = ASPECT_NAME_BATTLEWARDRY

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_ULTIMATE

	invocations = list("Castellum Arcyna Exsurgat!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_HEAVY
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 90 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/arcyne_fortress/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/center = get_turf(H)
	if(!center)
		return FALSE

	// 5x5 perimeter - outer ring at range 2 from caster
	var/list/perimeter_data = list() // list of list(turf, outward_dir)
	for(var/turf/T in range(2, center))
		var/dx = T.x - center.x
		var/dy = T.y - center.y
		if(abs(dx) != 2 && abs(dy) != 2)
			continue
		if(T.density)
			continue
		// Determine outward-facing direction based on which edge the tile is on
		var/outward_dir = 0
		if(abs(dx) == 2 && abs(dy) == 2)
			// Corners face diagonally outward
			outward_dir = get_dir(center, T)
		else if(abs(dx) == 2)
			// Left/right edges face east/west
			outward_dir = dx > 0 ? EAST : WEST
		else
			// Top/bottom edges face north/south
			outward_dir = dy > 0 ? NORTH : SOUTH
		perimeter_data += list(list(T, outward_dir))

	if(!length(perimeter_data))
		return FALSE

	H.visible_message(span_boldwarning("[H] channels a massive ward inscription - the air crackles with arcyne energy!"), span_notice("I erect the Arcyne Fortress!"))
	playsound(center, 'sound/magic/whiteflame.ogg', 80, TRUE, 5)

	for(var/list/entry in perimeter_data)
		var/turf/T = entry[1]
		var/outward_dir = entry[2]
		var/obj/structure/arrow_ward/wall = new(T, H, cooldown_time)
		wall.set_shield_dir(outward_dir)

	return TRUE
