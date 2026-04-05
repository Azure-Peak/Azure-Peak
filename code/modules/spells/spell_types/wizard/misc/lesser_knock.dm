/datum/action/cooldown/spell/lesser_knock
	button_icon = 'icons/mob/actions/roguespells.dmi'
	name = "Lesser Knock"
	desc = "A simple spell used to focus the arcyne into an instrument for lockpicking. Can be dispelled by using it on anything that isn't a locked/unlocked door."
	button_icon_state = "rune4"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("Parvus Pulso")
	invocation_type = INVOCATION_WHISPER

	charge_required = FALSE
	cooldown_time = 5 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE

	point_cost = 2

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/lesser_knock/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!istype(user))
		return FALSE

	var/obj/item/melee/touch_attack/lesserknock/lockpick = new(user.drop_location())
	user.put_in_hands(lockpick)
	to_chat(user, span_notice("I prepare to perform a minor arcyne incantation."))
	return TRUE

/obj/item/melee/touch_attack/lesserknock
	name = "Spectral Lockpick"
	desc = "A faintly glowing lockpick that appears to be held together by the mysteries of the arcyne. To dispel it, simply use it on anything that isn't a door."
	catchphrase = null
	possible_item_intents = list(/datum/intent/use)
	icon = 'icons/roguetown/items/keys.dmi'
	icon_state = "lockpick"
	color = "#3FBAFD" // spooky magic blue color that's also used by presti
	picklvl = 0.99
	max_integrity = 30
	destroy_sound = 'sound/items/pickbreak.ogg'
	resistance_flags = FIRE_PROOF

/obj/item/melee/touch_attack/lesserknock/attack_self()
	qdel(src)
