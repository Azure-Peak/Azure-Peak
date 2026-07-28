/datum/action/cooldown/spell/aetherknife
	button_icon = 'icons/mob/actions/mage_conjure.dmi'
	name = "Aetherknife"
	desc = "Congeal magickal energies into a blade which gains a bonus to power based on INT.\n\
	The blade lasts until a new one is summoned or the spell is forgotten. Deals physical damage."
	fluff_desc = "Invented by a mage who felt that the magician's brick was too crude, but still wanted a way to bypass magical defenses."
	button_icon_state = "aetherknife"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocations = list("Desperta ferro!")
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	cooldown_time = 5 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_LOW

	point_cost = 2
	requires_aspect_access = TRUE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/obj/item/rogueweapon/conjured_knife = null

/datum/action/cooldown/spell/aetherknife/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!istype(user))
		return FALSE

	if(src.conjured_knife)
		qdel(conjured_knife)
	var/obj/item/rogueweapon/R = new /obj/item/rogueweapon/huntingknife/throwingknife/aetherknife(user.drop_location())
	R.AddComponent(/datum/component/conjured_item, null, FALSE, user, src)

	if(user.STAINT > 10)
		var/int_scaling = user.STAINT - 10
		R.force = R.force + int_scaling
		R.throwforce = R.throwforce + int_scaling * 2
		R.name = "aetherknife +[int_scaling]"
	user.put_in_hands(R)
	src.conjured_knife = R
	return TRUE

/datum/action/cooldown/spell/aetherknife/Destroy()
	if(src.conjured_knife)
		conjured_knife.visible_message(span_warning("[conjured_knife] disintegrates into glittering motes!"))
		qdel(conjured_knife)
	return ..()

/obj/item/rogueweapon/huntingknife/throwingknife/aetherknife
	name = "aetherknife"
	desc = "A knife formed out of congealed magickal energies. Makes for a very deadly melee and throwing weapon."
	icon_state = "throw_knifecorrupt"
	force = 15
	throwforce = 20
	wdefense = 3
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_MOUTH
	possible_item_intents = list(/datum/intent/dagger/thrust, /datum/intent/dagger/thrust/pick)
	sellprice = 0
	embedding = list("embed_chance" = 0)
