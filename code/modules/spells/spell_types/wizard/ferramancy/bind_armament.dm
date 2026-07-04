/datum/action/cooldown/spell/bind_armament
	name = "Bind Armament"
	desc = "Bind a weapon, changing its skills to Arcyne Armament instead of its original skill. Once it is unbound, it returns to the original skill. Cast with an empty hand to release the bond."
	button_icon = 'icons/mob/actions/classuniquespells/spellblade.dmi'
	button_icon_state = "bind_weapon"
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	attunement_school = ASPECT_NAME_FERRAMANCY
	sound = 'sound/magic/charged.ogg'

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("Vinculum Ferri.")
	invocation_type = INVOCATION_WHISPER

	charge_required = TRUE
	charge_time = 10 SECONDS
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	cooldown_time = 60 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

	var/bind_skill = /datum/skill/combat/arcyne
	var/obj/item/bound

/datum/action/cooldown/spell/bind_armament/Destroy()
	release_bind()
	return ..()

/datum/action/cooldown/spell/bind_armament/proc/release_bind()
	if(bound && !QDELETED(bound))
		var/datum/component/skill_bind/existing = bound.GetComponent(/datum/component/skill_bind)
		if(existing)
			qdel(existing)
	bound = null

/datum/action/cooldown/spell/bind_armament/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	var/obj/item/weapon = H.get_active_held_item()
	if(!weapon)
		if(bound && !QDELETED(bound))
			to_chat(H, span_notice("The arcyne bond on [bound] fades."))
			release_bind()
			return TRUE
		to_chat(H, span_warning("I have no bound weapon to release!"))
		return FALSE
	if(istype(weapon, /obj/item/rogueweapon/shield))
		to_chat(H, span_warning("Shields are specifically blacklisted from arcyne binding."))
		return FALSE
	if(!istype(weapon, /obj/item/rogueweapon) || !ispath(weapon.associated_skill, /datum/skill/combat))
		to_chat(H, span_warning("[weapon] is not something my arts can guide."))
		return FALSE
	if(weapon.GetComponent(/datum/component/skill_bind))
		to_chat(H, span_warning("[weapon] already carries an arcyne bond."))
		return FALSE
	release_bind()
	weapon.AddComponent(/datum/component/skill_bind, bind_skill)
	bound = weapon
	to_chat(H, span_notice("I lay an arcyne bond on [weapon]; it answers to my conjurer's training now."))
	playsound(get_turf(H), 'sound/magic/charged.ogg', 50, TRUE)
	H.visible_message(span_notice("[H] passes a hand over [weapon], which glows faintly."))
	return TRUE
