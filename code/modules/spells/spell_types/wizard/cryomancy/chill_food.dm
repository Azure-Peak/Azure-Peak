/datum/action/cooldown/spell/chill_food
	button_icon = 'icons/mob/actions/mage_cryomancy.dmi'
	name = "Chill Food"
	desc = "Chill a piece of food with a touch of frost without affecting its quality, extending its freshness by a half of a dae (15 MINUTES OOC). \
	Cannot reverse rot already set in."
	fluff_desc = "An ancient cantrip invented to preserve food. In ancient tymes, \
	cooling tables were made en masse by inscribing the runes of this spell onto a table to preserve food. \
	Nowadays, the arts of making cooling table is rarely passed down and inevitably expensive. \
	The Etruscan Trading Company is known for devising Greater and Grand Chill Food, which is then taught to company mages \
	to be used on their food shipments, shipping premium, fresh fishes, fruits across the world to be sold at a premium price. \
	Chilled gronnic trouts with gronnic butter is particularly favored in Azuria."
	button_icon_state = "chill_food"
	sound = 'sound/spellbooks/crystal.ogg'
	spell_color = GLOW_COLOR_ICE
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	self_cast_possible = FALSE
	cast_range = 1

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("Congela.")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = CHARGETIME_POKE
	cooldown_time = 30 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE

	point_cost = 1

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/chill_food/cast(atom/cast_on)
	. = ..()
	if(!istype(cast_on, /obj/item/reagent_containers/food/snacks))
		to_chat(owner, span_warning("That is not food."))
		return FALSE

	var/obj/item/reagent_containers/food/snacks/food = cast_on

	if(!food.rotprocess)
		to_chat(owner, span_warning("[food] does not spoil."))
		return FALSE

	// Extend freshness by 15 minutes. Cannot reverse rot already set in.
	food.warming += 15 MINUTES

	new /obj/effect/temp_visual/small_smoke(get_turf(food))
	owner.visible_message(span_notice("[owner] passes a hand over [food]. A thin rime of frost coats its surface before fading."), span_notice("I chill [food] with a breath of frost."))
	return TRUE
