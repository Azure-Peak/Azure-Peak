// Great Shelter - Hearthcraft minor aspect spell
// Conjures a cramped prefab house: arcyne walls + door, bed, hearth, and oven.
// 4x4 footprint, 2x2 interior. Door faces away from caster.
// The caster must stand still during charge.

#define SHELTER_DURATION 15 MINUTES

/datum/action/cooldown/spell/great_shelter
	name = "Great Shelter"
	desc = "Conjure a cramped but functional shelter from arcyne force.\n\
	Contains a bed, a hearth, and an oven. Bring your own cooking tools.\n\
	The shelter lasts for 15 minutes. Door always faces south."
	button_icon = 'icons/mob/actions/mage_conjure.dmi'
	button_icon_state = "great_shelter"
	sound = 'sound/spellbooks/crystal.ogg'
	spell_color = GLOW_COLOR_HEARTH
	glow_intensity = GLOW_INTENSITY_MEDIUM

	click_to_activate = TRUE
	cast_range = 5
	self_cast_possible = FALSE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CONJURE
	secondary_resource_type = SPELL_COST_ENERGY
	secondary_resource_cost = 400

	invocations = list("Domus Arcana!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = 5 SECONDS
	charge_drain = 2
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 5 MINUTES

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_NO_MOVE | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/great_shelter/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return . | SPELL_CANCEL_CAST
	var/turf/center = get_turf(cast_on)
	if(!center)
		return . | SPELL_CANCEL_CAST
	var/list/offsets = build_shelter_offsets()
	for(var/list/offset in offsets)
		var/turf/T = locate(center.x + offset[1], center.y + offset[2], center.z)
		if(!T || T.density)
			to_chat(H, span_warning("There isn't enough space to conjure a shelter here!"))
			return . | SPELL_CANCEL_CAST
		for(var/obj/structure/S in T)
			if(S.density)
				to_chat(H, span_warning("There isn't enough space to conjure a shelter here!"))
				return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/great_shelter/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/center = get_turf(cast_on)
	if(!center)
		return FALSE

	var/list/offsets = build_shelter_offsets()

	playsound(center, 'sound/spellbooks/crystal.ogg', 100, TRUE)
	H.visible_message(span_warning("[H] conjures a shelter from arcyne force!"))

	// Place structures
	for(var/list/offset in offsets)
		var/turf/T = locate(center.x + offset[1], center.y + offset[2], center.z)
		var/tile_type = offset[3]
		switch(tile_type)
			if("wall")
				new /obj/structure/forcefield_weak/shelter_wall(T, H)
			if("bed")
				new /obj/structure/bed/rogue/conjured(T)
			if("hearth")
				new /obj/machinery/light/rogue/hearth/conjured(T)
				new /obj/machinery/light/rogue/oven/conjured(T)
			if("empty")
				continue

	return TRUE

// Fixed south-facing layout. No rotation.
//   [wall] [wall] [wall] [wall]
//   [wall] [bed ] [hrth] [wall]
//   [wall] [empt] [lite] [wall]
//   [wall] [    ] [wall] [wall]
// Hearth has oven on same tile (oven sprite offsets north).
/datum/action/cooldown/spell/great_shelter/proc/build_shelter_offsets()
	return list(
		list(-1,  2, "wall"),  list( 0,  2, "wall"),    list( 1,  2, "wall"),  list( 2,  2, "wall"),
		list(-1,  1, "wall"),  list( 0,  1, "bed"),     list( 1,  1, "hearth"), list( 2,  1, "wall"),
		list(-1,  0, "wall"),  list( 0,  0, "empty"),   list( 1,  0, "empty"), list( 2,  0, "wall"),
		list(-1, -1, "wall"),  list( 0, -1, "empty"),   list( 1, -1, "wall"),  list( 2, -1, "wall"),
	)

// --- Conjured structures ---

/obj/structure/forcefield_weak/shelter_wall
	name = "arcyne wall"
	desc = "A shimmering wall of arcyne force. It hums faintly."
	max_integrity = 200
	timeleft = 0 // Disable parent's 20s auto-delete, we use SHELTER_DURATION instead
	opacity = TRUE
	color = "#6495ED"

/obj/structure/forcefield_weak/shelter_wall/Initialize(mapload, mob/summoner)
	. = ..()
	QDEL_IN(src, SHELTER_DURATION)

/obj/structure/bed/rogue/conjured
	name = "arcyne bed"
	desc = "A bed conjured from arcyne force. It looks uncomfortable, but functional."
	color = "#6495ED"

/obj/structure/bed/rogue/conjured/Initialize(mapload)
	. = ..()
	QDEL_IN(src, SHELTER_DURATION)

/obj/machinery/light/rogue/hearth/conjured
	name = "arcyne hearth"
	desc = "A hearth of blue arcyne flame. It burns without fuel."
	color = "#6495ED"

/obj/machinery/light/rogue/hearth/conjured/Initialize()
	. = ..()
	QDEL_IN(src, SHELTER_DURATION)

/obj/machinery/light/rogue/oven/conjured
	name = "arcyne oven"
	desc = "An oven conjured from arcyne force. It glows with a faint blue heat."
	color = "#6495ED"

/obj/machinery/light/rogue/oven/conjured/Initialize()
	. = ..()
	QDEL_IN(src, SHELTER_DURATION)

#undef SHELTER_DURATION
