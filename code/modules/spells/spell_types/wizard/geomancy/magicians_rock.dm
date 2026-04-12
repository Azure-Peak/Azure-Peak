/datum/action/cooldown/spell/magicians_rock
	button_icon = 'icons/mob/actions/mage_geomancy.dmi'
	name = "Magician's Rock"
	desc = "Tear a boulder from the earth itself and materialize it at your feet."
	fluff_desc = "If Magician's Stone is the cantrip born of watching one man crack another's head with a rock, \
	Magician's Rock is the cantrip born of wishing that rock had been bigger. \
	A favored utility spell of battlemages and siegecasters alike - though it sees just as much use propping open doors \
	and providing seating during long marches."
	button_icon_state = "magicians_rock"
	sound = 'sound/items/stonestone.ogg'
	spell_color = GLOW_COLOR_EARTHEN
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("Emerge, Petra.")
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	cooldown_time = 2 MINUTES

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE

	point_cost = 1

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/magicians_rock/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!istype(user))
		return FALSE

	var/turf/T = user.drop_location()
	var/obj/item/natural/rock/R = new /obj/item/natural/rock(T)
	user.put_in_hands(R)

	playsound(user, 'sound/foley/stone_scrape.ogg', 50, TRUE)
	owner.visible_message(span_notice("[owner] clenches [owner.p_their()] fist and a boulder tears itself from the earth."), span_notice("I tear a boulder from the earth itself."))

	return TRUE
